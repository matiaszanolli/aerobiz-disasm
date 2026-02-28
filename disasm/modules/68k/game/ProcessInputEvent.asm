; ============================================================================
; ProcessInputEvent -- Main event processing loop for one game turn: initialises route and input buffers, checks which players have active routes, calls MapInputToAction for the current city, iterates all 4 player/city combinations accumulating route scores, then for each of 7 city slots calls UpdateAnimation/PositionUIControl/ValidateInputState and FadeGraphics.
; 794 bytes | $01EC40-$01EF59
; ============================================================================
ProcessInputEvent:
; --- Phase: Setup / Buffer Clear ---
    link    a6,#-$4
    movem.l d2-d6/a2-a5, -(a7)
; Zero $80 (128) bytes at $FF01B0: unknown block used as per-player working state this turn
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr MemFillByte
; Zero $70 (112) bytes at $FF1004: score accumulation buffer (7 slots * 4 players * 4 bytes)
; This is win_right_dup region; used here as a per-slot score table
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr MemFillByte
    lea     $18(a7), a7
; d3 = 0: flag for "any player has domestic_slots > 0"
    clr.w   d3
; a5 = $FF0018: player_records base (player 0)
    movea.l  #$00FF0018,a5
    clr.w   d2
; --- Phase: Scan Players for Active Domestic Routes ---
l_1ec7a:
; player_record+$04 = domestic_slots count; nonzero means this player has active routes
    tst.b   $4(a5)
    beq.b   l_1ec84
; At least one player has domestic routes -- set the active flag and stop scanning
    moveq   #$1,d3
    bra.b   l_1ec90
l_1ec84:
; Advance to next player record ($24 bytes per record)
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ec7a
; --- Phase: First MapInputToAction Call (global slot 7) ---
l_1ec90:
; d6 = 1: input-mode flag (used later as a "valid" indicator)
    moveq   #$1,d6
; Only proceed with input processing if at least one player has domestic routes
    cmpi.w  #$1, d3
    bne.w   l_1edde
; MapInputToAction(slot=7, flag=1): maps controller input for city slot 7
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
; --- Phase: Accumulate Route Scores Across All 4 Players ---
    moveq   #$1,d6
; Reset to player 0
    movea.l  #$00FF0018,a5
    clr.w   d2
; a4 points into score buffer: $FF1004 + player_index * $1C
; (Each player occupies 7 slots * 4 bytes = $1C bytes of score space)
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1ecc8:
; a3 = route_slots[player_index]: $FF9A20 + player_index * $320 (800 bytes per player)
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
; a2 points into a second working table: base $FFB4E4, stride $140 per player
; Purpose: animation/display state per city slot for each player
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
; d3 = route slot counter (inner loop index)
    clr.w   d3
    bra.b   l_1ed54
l_1ecf0:
; Check city display state word at a2+$4: if nonzero, skip animation for this slot
    tst.w   $4(a2)
    bne.b   l_1ed16
; Slot display is ready: call RenderAnimFrame(player_index, slot_index)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderAnimFrame,PC)
    nop
; UpdateAnimation(slot_count=7): step the animation state machine for this slot
    pea     ($0007).w
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ed16:
; Accumulate route score: read route slot gross_revenue (+$08) into score buffer
; route_slot+$08 = gross_revenue (word). Signed-extend to long.
    moveq   #$0,d0
    move.w  $8(a3), d0
; Arithmetic round before right-shift: if negative, add $7F to round toward zero
    bge.b   l_1ed22
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed22:
; Divide by 128 (asr #7): scale gross_revenue to a per-turn score unit
    asr.l   #$7, d0
; a0 = slot_word_a2 * 4: city slot index as longword offset into score buffer row
    moveq   #$0,d1
    move.w  (a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
; Accumulate scaled revenue score into the score table entry for city a (word at a2+$00)
    add.l   d0, (a4,a0.l)
; Repeat the same accumulation for city b (word at a2+$02): twin-city slot scoring
    moveq   #$0,d0
    move.w  $8(a3), d0
    bge.b   l_1ed3c
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed3c:
    asr.l   #$7, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
; Accumulate same score under the second city slot index (route is bidirectional)
    add.l   d0, (a4,a0.l)
; Advance to next route slot: a3 += $14 (20 bytes per route_slot)
    moveq   #$14,d0
    adda.l  d0, a3
; Advance to next city animation entry: a2 += $8 (8 bytes per entry)
    addq.l  #$8, a2
    addq.w  #$1, d3
l_1ed54:
; Loop condition: d3 < domestic_slots (player_record+$04)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    cmp.l   d1, d0
    blt.b   l_1ecf0
; --- Phase: Hub-City Score Bonus ---
; After processing this player's routes, add a bonus for the hub city
; Read $FF0002 (save_byte_03 adjacent word -- hub score factor for this player)
    clr.w   d4
    move.w  ($00FF0002).l, d3
l_1ed6a:
; Write (d3*2 + 3) into each of 7 score slots: d3 = hub score, *2+3 = weighted bonus
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    moveq   #$0,d1
    move.w  d4, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    addq.w  #$1, d4
    cmpi.w  #$7, d4
; Repeat for all 7 city slots
    bcs.b   l_1ed6a
; --- Phase: Hub City RangeLookup ---
; Translate player hub city (player_record+$01) through RangeLookup to get region index
    moveq   #$0,d0
    move.b  $1(a5), d0
; player_record+$01 = hub_city index
    ext.l   d0
    move.l  d0, -(a7)
; RangeLookup: maps value to index 0-7 via cumulative threshold table
    jsr RangeLookup
    addq.l  #$4, a7
; d3 = region index (0-7) for hub city
    move.w  d0, d3
; Compute adjusted hub score from $FF0002 value (signed with rounding)
    move.w  ($00FF0002).l, d0
    ext.l   d0
    bge.b   l_1eda6
    addq.l  #$1, d0
l_1eda6:
; asr #1 then +1: divide by 2 rounding up (gives half the hub-bonus value + 1)
    asr.l   #$1, d0
    addq.l  #$1, d0
; Add this adjusted score into the score slot corresponding to the hub's region index
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
; Advance to next player: a5 += $24 (player record stride), a4 += $1C (score row stride)
    moveq   #$24,d0
    adda.l  d0, a5
    moveq   #$1C,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
; Loop over all 4 players
    bcs.w   l_1ecc8
; --- Phase: Optional Input Wait (flight_active check) ---
; $FF000A = flight_active: if == 1, pause for 60 frames before continuing
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1edde
; PollInputChange($3C): poll until input changes or 60 frames ($3C) elapse
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
; --- Phase: City Slot Loop (7 iterations) ---
; Process each of 7 city slot entries in the range table at $5ECBC
l_1edde:
; a3 = $5ECBC: ROM table with 4-byte entries describing city slot ranges/counts
; Each entry: byte[0]=start, byte[1]=end, byte[2]=range_start_b, byte[3]=range_end_b
    movea.l  #$0005ECBC,a3
; d4 = outer city slot index (0-6)
    clr.w   d4
l_1ede6:
; d3 = inner sub-slot counter, d2 = player sub-slot index
    clr.w   d3
    clr.w   d2
l_1edea:
; BitFieldSearch(player_index=d2, slot_type=d4): find first set bit in bitfield for this type
; Returns d0 = bit index or $20 if none found
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
; d5 = returned bit index
    move.w  d0, d5
; $20 (32) = sentinel "not found" from BitFieldSearch; skip if no match
    cmpi.w  #$20, d5
    bcc.b   l_1ee26
; FindCharSlot(bit_index=d5, player=d2): locate this character in the roster
; Returns d0 = slot index or $FF if not assigned
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    ext.l   d0
; -1 ($FF sign-extended) means no char found in this slot -- skip
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_1ee26
; Found a char in this slot: set d3=1 to flag that action is needed
    moveq   #$1,d3
    bra.b   l_1ee2e
l_1ee26:
; Try next player sub-slot (d2 up to 3)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1edea
l_1ee2e:
; If no active char found for this city slot, skip the UI update
    cmpi.w  #$1, d3
    bne.w   l_1ef2e
; MapInputToAction(d4=slot_index, d6=mode): map user input to an action for this city slot
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
    moveq   #$1,d6
; d3 = start of city sub-range from ROM table entry (byte[2])
    moveq   #$0,d3
    move.b  $2(a3), d3
    bra.b   l_1ee98
; --- Phase: Sub-range A: PositionUIControl / UpdateAnimation ---
l_1ee54:
; a2 = city_data[$FF_BA80] + d3 * 8 (stride 8 bytes per city in the block)
    move.w  d3, d0
    lsl.w   #$3, d0
; city_data base at $FFBA80: 89 cities * 4 entries * 2 bytes = stride-2 storage
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1ee66:
; Check city_data[city]+$01: if nonzero the city entry is active/valid, break the inner scan
    tst.b   $1(a2)
    bne.b   l_1ee76
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ee66
l_1ee76:
; If no valid entry found (d2 reached 4), skip this city sub-slot
    cmpi.w  #$4, d2
    bcc.b   l_1ee96
; PositionUIControl(city_index=d3): position the UI widget for this city on screen
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
; UpdateAnimation(slot_count=d4): advance animation frame for this city's sprite
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$8, a7
l_1ee96:
    addq.w  #$1, d3
l_1ee98:
; Loop bounds: iterate while d3 < (a3[2] + a3[3]) -- range [start_b .. start_b+count_b)
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1ee54
; Now switch to sub-range B: start at a3[0] (byte[0] = range_a start index)
    moveq   #$0,d3
    move.b  (a3), d3
    bra.b   l_1ef1a
; --- Phase: Sub-range B: ValidateInputState / FadeGraphics / PositionUIControl ---
l_1eeb4:
; Same city_data scan pattern as sub-range A
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1eec6:
    tst.b   $1(a2)
    bne.b   l_1eed6
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1eec6
l_1eed6:
; If no valid city entry, skip this sub-slot
    cmpi.w  #$4, d2
    bcc.b   l_1ef18
; ValidateInputState(city_index=d3): check if current input is valid for this city
; Returns d0=1 if transition should trigger a fade, 0 if just reposition
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ValidateInputState,PC)
    nop
    cmpi.w  #$1, d0
    bne.b   l_1eefc
; Input state valid -> FadeGraphics(city_index): fade-out the city's UI element
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FadeGraphics,PC)
    nop
    bra.b   l_1ef08
l_1eefc:
; Input state not valid -> PositionUIControl(city_index): just update position
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
l_1ef08:
; UpdateAnimation(slot_index=d4): advance animation regardless of validate result
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ef18:
    addq.w  #$1, d3
l_1ef1a:
; Loop bounds: iterate while d3 < (a3[0] + a3[1]) -- range [0 .. count_a)
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1eeb4
l_1ef2e:
; Check flight_active again before next city slot; wait 60 frames if active
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1ef44
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
l_1ef44:
; Advance ROM table pointer by 4 bytes to next city slot descriptor, advance outer index
    addq.l  #$4, a3
    addq.w  #$1, d4
; Process all 7 city slots (d4 < 7)
    cmpi.w  #$7, d4
    bcs.w   l_1ede6
    movem.l -$28(a6), d2-d6/a2-a5
    unlk    a6
    rts
