; ============================================================================
; RankCharCandidatesFull -- Full interactive character selection UI; displays sorted compatible-char list with portrait and detail panels, handles Up/Down navigation, and returns the selected char index.
; 666 bytes | $014DA6-$01503F
; ============================================================================
RankCharCandidatesFull:
    link    a6,#-$54
    ; Frame layout (a6-relative):
    ;   -$54        : last_input (word) -- cached filtered button bits
    ;   -$52        : last_buttons (word) -- previous ProcessInputLoop result
    ;   -$50 to ... : slot_map[] (word array, up to ~20 entries) --
    ;                 slot_map[ranked_index] = raw slot index whose city matches D5
    movem.l d2-d7/a2-a5, -(a7)
    ; Unpack arguments from caller's stack:
    ;   $10(a6) = D4 -- preselected slot index (hint for initial cursor position)
    ;   $0C(a6) = D5 -- target char code to match against route slot city codes
    ;   $08(a6) = D6 -- player index (0-3)
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    move.l  $8(a6), d6
    ; A4 = $FF13FC = input_mode_flag: written $0001 to enable countdown-gated input
    movea.l  #$00FF13FC,a4
    ; A5 = $FFA7D8 = input_init_flag: cleared each time input restarts (see ProcessInputLoop)
    movea.l  #$00FFA7D8,a5
    ; D7 = refresh flag: set to 1 when the visible panel must be redrawn before next poll
    clr.w   d7
    ; --- Phase 1: Set up player record pointer and draw initial screen frame ---
    ; Compute player_record base: $FF0018 + player_index * $24 (36 bytes per record)
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    ; A3 = player_record for this player
    movea.l a0, a3
    ; Draw outer box frame via GameCommand #$1A (DrawBox):
    ; Args: cmd=$1A, x=0, y=0, width=$13 (19 tiles), height=$20 (32 tiles),
    ;       color=0, fill=$8000 (solid fill flag)
    move.l  #$8000, -(a7)      ; solid fill / border color
    pea     ($000A).w          ; width = 10 tiles
    pea     ($0020).w          ; height = 32 tiles (full screen height)
    pea     ($0013).w          ; x column = 19
    clr.l   -(a7)              ; y row = 0, x = 0 (packed word pair)
    clr.l   -(a7)              ; padding longword
    pea     ($001A).w          ; GameCommand #$1A = DrawBox
    jsr GameCommand
    lea     $1c(a7), a7        ; pop 7 longwords
    ; Draw portrait tile ($077D) at position: x=$13, y=$20, width=1, height=1
    ; Tile $077D is the character portrait placeholder tile
    pea     ($077D).w          ; tile number
    pea     ($000A).w          ; width
    pea     ($0020).w          ; height = row 32
    pea     ($0013).w          ; x column = 19
    clr.l   -(a7)              ; y row = 0
    pea     ($0001).w          ; count = 1
    pea     ($001A).w          ; GameCommand #$1A = DrawBox (tile fill mode)
    jsr GameCommand
    lea     $1c(a7), a7
    ; --- Phase 2: Scan route slots for this player, build slot_map[] ---
    ; Route slots: $FF9A20 + player*$320; each slot is $14 bytes; 40 slots per player
    move.w  d6, d0
    mulu.w  #$320, d0          ; player stride = 40 * $14 = $320 bytes
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    ; A2 = first route_slot for this player
    movea.l a0, a2
    ; D2 = raw slot iterator [0 .. domestic_slots+intl_slots)
    clr.w   d2
    ; D3 = ranked slot counter (number of matched entries in slot_map[])
    clr.w   d3
    bra.b   .l14e5a            ; jump to loop test first
.l14e3a:
    ; Check if route_slot+$00 (city_a) or route_slot+$01 (city_b) matches target char D5
    ; D5 = char code of the character we want to find routes for
    cmp.b   (a2), d5           ; city_a == target?
    beq.b   .l14e44
    cmp.b   $1(a2), d5         ; city_b == target?
    bne.b   .l14e54            ; neither matches: skip this slot
.l14e44:
    ; Match found: record raw slot index D2 into slot_map[D3]
    ; slot_map is stored at -$50(a6, ranked*2) as word entries
    move.w  d3, d0
    add.w   d0, d0             ; ranked * 2 (word offset)
    move.w  d2, -$50(a6, d0.w) ; slot_map[d3] = d2 (raw slot index)
    ; If this raw slot was the preselected hint (D4), remap D4 to ranked index D3
    ; so the cursor lands on it initially
    cmp.w   d2, d4
    bne.b   .l14e52
    move.w  d3, d4             ; D4 now = ranked index of the preselected slot
.l14e52:
    addq.w  #$1, d3            ; ranked count++
.l14e54:
    addq.w  #$1, d2            ; raw slot index++
    ; Advance A2 by $14 to next route_slot
    moveq   #$14,d0
    adda.l  d0, a2
.l14e5a:
    ; Loop condition: iterate while D2 < (domestic_slots + intl_slots)
    ; player_record+$04 = domestic_slots (byte), +$05 = intl_slots (byte)
    moveq   #$0,d0
    move.b  $4(a3), d0         ; domestic_slots count
    moveq   #$0,d1
    move.b  $5(a3), d1         ; intl_slots count
    add.l   d1, d0             ; total slot count
    move.w  d2, d1
    ext.l   d1                 ; D1 = current raw index (sign-extended)
    cmp.l   d1, d0             ; total > current index?
    bgt.b   .l14e3a            ; yes: continue scanning
    ; --- Phase 3: Guard -- if no matching slots found, show dialog and exit ---
    tst.w   d3                 ; D3 = number of matched slots
    ble.w   .l15016            ; no matches: show "no route" dialog
    ; --- Phase 4: Initial render of selected slot ---
    ; Compute route_slot pointer for ranked index D4 (initial cursor position)
    ; slot_map[D4] gives raw slot, then offset into route_slots array
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0 ; raw slot index = slot_map[D4]
    mulu.w  #$14, d0           ; raw_slot * $14 (byte offset within player's slots)
    move.w  d6, d1
    mulu.w  #$320, d1          ; player * $320 (player stride)
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    ; A2 = current route_slot record
    movea.l a0, a2
    ; Clear tile area for this slot's display panel
    jsr ClearTileArea
    ; Render route detail panel: FormatRelationStats(slot_ptr=A2, player=D6, col=$13, row=0, scroll=0, mode=1)
    pea     ($0001).w          ; mode = 1 (full detail display)
    pea     ($0001).w          ; row offset within panel
    pea     ($0013).w          ; column = 19
    clr.l   -(a7)              ; padding (y=0)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)          ; player_index
    move.l  a2, -(a7)          ; slot_ptr (route_slot record)
    jsr FormatRelationStats    ; renders city names, revenue, char stats for this slot
    ; Initialize input state for first poll
    clr.w   -$54(a6)           ; last_input = 0 (no prior input)
    clr.l   -(a7)
    jsr ReadInput              ; initial flush read to clear stale button state
    lea     $1c(a7), a7
    ; D5 repurposed: D5 = valid_entry flag (1 = current slot is in a valid trade state)
    tst.w   d0
    beq.b   .l14ed0
    moveq   #$1,d5             ; D0 was nonzero: slot is valid
    bra.b   .l14ed2
.l14ed0:
    moveq   #$0,d5             ; D0 was zero: slot invalid / not tradeable
.l14ed2:
    ; Clear input gating registers for main poll loop
    clr.w   -$52(a6)           ; last_buttons = 0
    clr.w   (a4)               ; input_mode_flag ($FF13FC) = 0 (reset countdown mode)
    clr.w   (a5)               ; input_init_flag ($FFA7D8) = 0 (force re-init)
    ; D2 = current ranked cursor index (start at D4)
    move.w  d4, d2
    ; === Main input loop ===
.l14edc:
    ; --- Phase 5: Redraw panel if refresh flag D7 is set ---
    tst.w   d7
    beq.b   .l14f38            ; no refresh needed: skip redraw
    ; Recompute route_slot pointer for current cursor D2
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0 ; raw slot = slot_map[D2]
    mulu.w  #$14, d0
    move.w  d6, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ClearTileArea          ; wipe old panel content
    ; Re-render with updated cursor position
    pea     ($0001).w          ; mode = 1
    move.w  -$54(a6), d0      ; last_input (cached scroll position or display mode)
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0013).w          ; column = 19
    clr.l   -(a7)              ; y offset = 0
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)          ; player_index
    move.l  a2, -(a7)          ; slot_ptr
    jsr FormatRelationStats
    ; Wait for stable input (debounce): arg $20 = ~32 frame wait
    pea     ($0020).w
    bsr.w WaitStableInput      ; blocks until joypad state is stable
    lea     $1c(a7), a7
    clr.w   -$54(a6)           ; reset cached last_input
    clr.w   d7                 ; clear refresh flag
.l14f38:
    ; --- Phase 6: Check trade validity for current slot ---
    ; RangeMatch(city_a, city_b): verifies char compatibility range
    ; A2 = current route_slot; +$00 = city_a, +$01 = city_b
    moveq   #$1,d4             ; D4 = RangeMatch result (default 1 = valid)
    moveq   #$0,d0
    move.b  $1(a2), d0         ; city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0           ; city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch             ; D0 = 1 if compatible, 0 if not
    addq.l  #$8, a7
    cmpi.w  #$1, d0            ; D4 set from return (unused here -- only D4 preloaded)
    ; --- Phase 7: Poll for input, filtering to directional + A + B buttons ---
    ; If D5 = 0 (invalid slot), do a fresh button read; else skip first check
    tst.w   d5
    beq.b   .l14f7e            ; D5=0: go straight to full poll
    clr.l   -(a7)              ; timeout = 0 (immediate read)
    jsr ReadInput              ; fast read to see if any button already pressed
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14f7e            ; no button held: do timed poll
    ; Button already down: issue display sync (GameCommand #$E) then loop back
    pea     ($0002).w          ; sync arg
.l14f6e:
    pea     ($000E).w          ; GameCommand #$E = display sync / frame wait
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l14edc            ; restart loop (refresh + re-poll)
.l14f7e:
    clr.w   d5                 ; clear valid-slot shortcut flag for next iteration
    ; Timed button poll: ProcessInputLoop(timeout=$0A, prev_buttons=last_buttons)
    ; Returns D0 = filtered button bits for buttons newly pressed this frame
    move.w  -$52(a6), d0      ; last_buttons (previous poll result)
    move.l  d0, -(a7)
    pea     ($000A).w          ; timeout = 10 frames
    jsr ProcessInputLoop       ; D0 = new button bits
    addq.l  #$8, a7
    ; Mask to directional buttons + A + B: %0011 0011 = $33
    ; Bit layout: bit0=Up, bit1=Down, bit4=A, bit5=B (Genesis joypad)
    andi.w  #$33, d0
    move.w  d0, -$52(a6)       ; store as last_buttons for next iteration
    ; --- Phase 8: Decode button and act ---
    ; D4 = RangeMatch result (1 = slot is valid for trade, 0 = not)
    cmpi.w  #$1, d4
    ; Reload buttons for dispatch
    move.w  -$52(a6), d0
    ext.l   d0
    ; Dispatch on button value (A=button bit $20, B=button bit $10, Down=$02, Up=$01)
    moveq   #$20,d1            ; A button mask
    cmp.w   d1, d0
    beq.b   .l14fbe            ; A pressed: confirm selection
    moveq   #$10,d1            ; B button mask
    cmp.w   d1, d0
    beq.b   .l14fcc            ; B pressed: cancel
    moveq   #$2,d1             ; Down d-pad
    cmp.w   d1, d0
    beq.b   .l14fd2            ; Down: scroll cursor forward
    moveq   #$1,d1             ; Up d-pad
    cmp.w   d1, d0
    beq.b   .l14ff2            ; Up: scroll cursor backward
    bra.b   .l1500a            ; no recognized button: idle
.l14fbe:
    ; A button: confirm selection at current ranked cursor D2
    ; Clear input flags and return the raw slot index for D2
    clr.w   (a4)               ; input_mode_flag = 0
    clr.w   (a5)               ; input_init_flag = 0
    ; Return slot_map[D2] (the raw slot index) in D0 for the caller
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0 ; raw slot index = slot_map[D2]
    bra.b   .l15036            ; exit with D0 = selected raw slot index
.l14fcc:
    ; B button: cancel -- return $FF (no selection)
    clr.w   (a4)
    clr.w   (a5)
    bra.b   .l15032            ; exit with D0 = $FF
.l14fd2:
    ; Down d-pad: advance cursor to next ranked slot (wraps at D3-1)
    move.w  #$1, (a4)          ; input_mode_flag = 1 (enable countdown gating)
    cmpi.w  #$1, d3            ; only 1 match? no movement possible
    ble.b   .l1500e
    addq.w  #$1, d2            ; D2++ (next ranked index)
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    subq.l  #$1, d1            ; d1 = d3 - 1 (max valid index)
    cmp.l   d1, d0
    ble.b   .l14fee            ; D2 <= max: valid
    clr.w   d2                 ; D2 wrapped past end: wrap to 0
.l14fee:
    moveq   #$1,d7             ; set refresh flag: panel needs redraw
    bra.b   .l1500e
.l14ff2:
    ; Up d-pad: move cursor to previous ranked slot (wraps at 0 -> D3-1)
    move.w  #$1, (a4)          ; input_mode_flag = 1
    cmpi.w  #$1, d3            ; only 1 match? no movement
    ble.b   .l1500e
    subq.w  #$1, d2            ; D2-- (previous ranked index)
    tst.w   d2
    bge.b   .l14fee            ; still >= 0: valid
    ; D2 went negative: wrap to D3-1 (last valid entry)
    move.w  d3, d2
    addi.w  #$ffff, d2         ; d2 = d3 - 1 (using #$FFFF = -1 signed addition)
    bra.b   .l14fee
.l1500a:
    ; No recognized button: clear input gating (idle pass)
    clr.w   (a4)               ; input_mode_flag = 0
    clr.w   (a5)               ; input_init_flag = 0
.l1500e:
    ; Issue display sync (GameCommand #$E, mode 4) then re-enter loop
    pea     ($0004).w          ; sync arg = 4
    bra.w   .l14f6e            ; -> GameCommand #$E then loop
    ; --- No matching slots: show dialog and return $FF ---
.l15016:
    ; Show "no available routes" dialog:
    ; ShowDialog(player=D6, string_ptr=$3F7FC, type=2, padding=0, row=3, col=1)
    pea     ($0001).w          ; dialog column
    clr.l   -(a7)              ; padding
    pea     ($0002).w          ; dialog type = 2 (error/info box)
    pea     ($0003F7FC).l      ; pointer to dialog text string in ROM
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)          ; player_index
    jsr ShowDialog
    ; Fall through to return $FF (cancel)
.l15032:
    ; Return $FF: cancelled or no selection
    move.w  #$ff, d0
.l15036:
    ; D0 = selected raw slot index, or $FF if cancelled
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts
