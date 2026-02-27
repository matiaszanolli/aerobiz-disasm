; ============================================================================
; ProcessCharModifier -- Iterates pending modifier events (state=1) per player; computes stat advantage gained this turn and either plays a relationship panel animation or displays a stat-increase dialog with tile-formatted numbers
; 974 bytes | $02B06C-$02B439
; ============================================================================
; --- Phase: Setup ---
ProcessCharModifier:
    link    a6,#-$80
    ; reserve $80 bytes of local stack space (used for sprintf output buffer at -$80(a6))
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    ; d5 = player index (argument passed by caller)
    move.w  d5, d0
    mulu.w  #$24, d0
    ; d0 = player_index * $24 (player record stride = 36 bytes)
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    ; a5 = &player_records[player_index] (this player's 36-byte record)
    move.w  d5, d0
    lsl.w   #$5, d0
    ; d0 = player_index * 32 ($20): stride into modifier event table at $FF0338
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; a2 = &modifier_event_table[player_index] ($FF0338 block, 32 bytes per player)
    ; Each 8-byte entry in this table describes one pending modifier event.
    ; The loop below walks up to 4 entries (d6 = 0..3), stride $8.
    move.w  #$ff, d7
    ; d7 = $FF: "last relation panel shown" guard; $FF means "none shown yet this call"
    ; avoids reloading the same relation screen if consecutive modifiers share a panel
    clr.w   d6
    ; d6 = modifier event slot index (0..3, iterating the 4 slots)
; --- Phase: Modifier Event Slot Loop ---
; Walk each of the 4 modifier event slots for this player.
; Modifier event record layout (8 bytes, at a2):
;   +$00: char_index (which character is affected)
;   +$01: state (1 = pending, 0 = cleared)
;   +$02: gain_cap (maximum stat points that can be awarded)
;   +$03: gain_accum (stat points accumulated so far this modifier)
;   +$04: (word, purpose TBD)
.l2b0a0:
    cmpi.b  #$1, $1(a2)
    ; modifier_event.state: only process slots with state == 1 (pending)
    bne.w   .l2b424
    ; slot not pending -> skip to next slot

    moveq   #$0,d2
    move.b  (a2), d2
    ; d2 = modifier_event.char_index (which character receives the stat boost)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    ; arg: slot index (d6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player index (d5)
    jsr GetModeRowOffset
    ; returns a row-Y offset based on game mode (0-3 -> table value)
    add.b   d0, $3(a2)
    ; modifier_event.gain_accum += mode_row_offset: accumulate stat gain this turn

; Compute the character's current rating to check whether the cap is already met
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; arg: char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player_index
    jsr CalcCharRating
    ; returns the character's current stat score (centered at 50)
    lea     $10(a7), a7
    ; clean up 4 args (GetModeRowOffset + CalcCharRating each took 2)
    move.w  d0, d3
    ; d3 = current char rating

    moveq   #$0,d0
    move.b  $3(a2), d0
    ; d0 = gain_accum (bytes earned so far)
    cmp.w   d3, d0
    ; compare gain_accum vs current_rating
    bcs.w   .l2b424
    ; if gain_accum < current_rating: char's rating already exceeds accumulated gain;
    ; no award possible this pass -> clear the slot and move on
; Compute pointers into tab32_8824 and city_data for this character and player
    move.w  d2, d0
    add.w   d0, d0
    ; d0 = char_index * 2 (word stride)
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a3 = &tab32_8824[char_index] (stride-2 word entry for this character)

    move.w  d2, d0
    lsl.w   #$3, d0
    ; d0 = char_index * 8 (city_data entry size: 4 entries × 2 bytes)
    move.w  d5, d1
    add.w   d1, d1
    ; d1 = player_index * 2
    add.w   d1, d0
    ; d0 = char_index*8 + player_index*2: selects the player's slot within this city's 4-entry block
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    ; a4 = &city_data[char_index][player_index] (stride-2 entry in the city data array)

; Compute the competitive advantage this character provides this turn
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; arg: char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player_index
    jsr CalcCharAdvantage
    ; returns a stat-diff-based advantage value (how much better this char is vs rivals)
    addq.l  #$8, a7
    move.l  d0, d4
    ; d4 = raw advantage value

; Cap advantage at gain_cap (modifier_event.+$02)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ; d0 = modifier_event.gain_cap
    cmp.w   d0, d4
    ; compare raw_advantage vs gain_cap
    ble.b   .l2b136
    ; advantage <= cap: use raw value (no clamping needed)
    moveq   #$0,d4
    move.b  $2(a2), d4
    ; d4 = gain_cap (clamp: advantage was above cap, use cap instead)
    bra.b   .l2b14c
; Not capped: recalculate fresh (ensures d4 is unmodified CalcCharAdvantage result)
.l2b136:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    ; second call: advantage was within cap so recalculate cleanly
    addq.l  #$8, a7
    move.l  d0, d4
    ; d4 = final advantage to award (uncapped path)

.l2b14c:
    ext.l   d4
    ; sign-extend d4 to long (advantage may be 0)
    add.b   d4, $1(a3)
    ; tab32_8824[char_index] += advantage (accumulate gained stat points for this char)

; Check if this player is active (can show UI)
    cmpi.b  #$1, (a5)
    ; player_record.active_flag: $01 = active human player (can display feedback)
    bne.w   .l2b410
    ; not active (AI or empty player): just apply gain silently, skip all UI
; --- Phase: Relationship Panel Display (human player only) ---
; Show the relation affinity panel once per unique region (deduplicated via d7).
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; arg: char_index
    jsr RangeLookup
    ; map char_index to a region/screen index (0-7)
    addq.l  #$4, a7
    move.w  d0, d3
    ; d3 = screen/region index for this character

    cmp.w   d3, d7
    ; d7 = previously shown region index ($FF = none yet)
    beq.b   .l2b1ac
    ; same region as last time: skip reload (relation panel already on screen)

    jsr ResourceLoad
    ; load graphics resources for the relation panel
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    ; arg: screen_index (d3)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player_index
    jsr LoadScreen
    ; load the tilemap for this region screen
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    ; arg: screen_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player_index
    jsr ShowRelPanel
    ; display the character relationship/affinity panel (mode=3)
    lea     $18(a7), a7
    ; clean up LoadScreen (3) + ShowRelPanel (3) args = 6 longs
    jsr ResourceUnload
    ; release resources after panel is rendered
    move.w  d3, d7
    ; d7 = d3: remember which region we just showed (dedup guard for next slot)

; Now prepare to build the stat-gain display string
.l2b1ac:
; Look up the ROM tile-position record for this character (for stat-gain tile display)
    move.w  d2, d0
    add.w   d0, d0
    ; d0 = char_index * 2 (word stride into pointer table)
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a3 = ROM tile position record for char_index (byte-pair: col, row for stat display)

; Branch on whether any advantage was gained this pass
    tst.w   d4
    bne.b   .l2b1ea
    ; d4 != 0: advantage > 0, show a stat-increase dialog
    ; d4 == 0: no gain this pass -> show a "no change" / neutral text dialog

; d4 == 0: show "no stat change" dialog
    pea     ($0001).w
    clr.l   -(a7)
    ; 0 = "no change" indicator arg
    pea     ($0002).w
    ; mode = 2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    ; arg: slot index (d6)
    pea     ($00042530).l
    ; ROM address $42530 = "no change" format string (fixed message)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player_index
    jsr ShowTextDialog
    ; display the neutral outcome dialog box
    lea     $18(a7), a7
    bra.w   .l2b412
    ; skip the stat-increase tile animation
; --- Phase: Stat-Increase Dialog Construction (d4 > 0) ---
; Build a formatted string describing the stat gain, then show it.
.l2b1ea:
    moveq   #$0,d0
    move.b  $2(a2), d0
    ; d0 = modifier_event.gain_cap
    move.w  d4, d1
    ext.l   d1
    ; d1 = d4 (advantage gained, sign-extended)
    cmp.l   d1, d0
    bne.b   .l2b23e
    ; gain_cap != advantage_gained: not at cap -> use "partial gain" format strings

; At cap: this modifier awards the maximum possible gain
    move.w  d2, d0
    lsl.w   #$2, d0
    ; d0 = char_index * 4 (longword stride into character name pointer table)
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; push char name string pointer from ROM table at $5E680[char_index]
    cmpi.w  #$1, d4
    bne.b   .l2b214
    ; d4 == 1: gain of exactly 1 -> use singular format ("gained 1 point")
    pea     ($00042506).l
    ; ROM format string at $42506 = singular "cap reached" template (e.g. "...+1 point max")
    bra.b   .l2b21a
.l2b214:
    pea     ($00042500).l
    ; ROM format string at $42500 = plural "cap reached" template (e.g. "...+N points max")
.l2b21a:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; push advantage value (d4) as the numeric argument to sprintf
    pea     ($0004250C).l
    ; ROM format string at $4250C = outer sprintf template (combines char name + points text)
    pea     -$80(a6)
    ; destination = local stack buffer at -$80(a6) ($80 bytes reserved in link frame)
    jsr sprintf
    ; format the stat-increase message into the local buffer
    lea     $14(a7), a7
    ; clean up 5 sprintf args (dest, fmt, value, name_str, inner_fmt)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    ; mode = 1 (at-cap dialog variant)
    bra.b   .l2b282
    ; jump to ShowTextDialog call
; Partial gain (advantage < cap): different format strings indicating progress
.l2b23e:
    move.w  d2, d0
    lsl.w   #$2, d0
    ; d0 = char_index * 4
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; push char name string pointer (same table as above)
    cmpi.w  #$1, d4
    bne.b   .l2b25a
    ; d4 == 1: singular gain
    pea     ($000424D0).l
    ; ROM format string at $424D0 = singular partial-gain template ("+1 point")
    bra.b   .l2b260
.l2b25a:
    pea     ($000424CA).l
    ; ROM format string at $424CA = plural partial-gain template ("+N points")
.l2b260:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; push numeric gain value
    pea     ($000424D6).l
    ; ROM format string at $424D6 = partial-gain outer template
    pea     -$80(a6)
    ; destination = local sprintf buffer
    jsr sprintf
    ; build the partial-gain message string
    lea     $14(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    ; mode = 2 (partial-gain dialog variant, different from mode=1 at-cap)

; --- Phase: Show Stat-Gain Dialog and Tile Animation ---
; Both at-cap (mode 1) and partial-gain (mode 2) paths converge here.
.l2b282:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    ; arg: slot index
    pea     -$80(a6)
    ; arg: pointer to formatted string in local buffer
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; arg: player index
    jsr ShowTextDialog
    ; display the stat-increase dialog box with the formatted message
    lea     $18(a7), a7
    ; clean up ShowTextDialog args (mode + 0 + 2 + slot + string + player = 6 longs)

; Place three successive tile frames at the character's stat position to animate the gain.
; a3.+$00 = col, a3.+$01 = row (map tile coordinates from ROM table $5E9FA).
; Offset -8 for column and +8 for row adjusts from map coords to screen tile position.
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    ; Y = tile_record.row - 8
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    ; X = tile_record.col + 8
    pea     ($0002).w
    pea     ($0544).w
    ; tile ID $0544 = first frame of stat-gain animation ("+N" first digit tile)
    jsr TilePlacement
    pea     ($001E).w
    pea     ($000E).w
    jsr GameCommand
    ; wait $1E = 30 frames (~0.5 sec) before next frame
    lea     $24(a7), a7

    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0546).w
    ; tile ID $0546 = second animation frame
    jsr TilePlacement
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    ; wait $14 = 20 frames before third frame
    lea     $24(a7), a7

    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0548).w
    ; tile ID $0548 = third / final animation frame (settled "+N" display)
    jsr TilePlacement
    pea     ($000A).w
    jsr PollInputChange
    ; wait up to $A = 10 frames for input; player can skip early
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    ; trigger display update after animation
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    ; final frame sync
    lea     $30(a7), a7
    ; clean up all remaining TilePlacement + timing args
; --- Phase: Tile Column Range Computation ---
; Compute the starting tile column (d3) and the delta (d2) for the animated number display.
; Different table offsets are used depending on whether char_index < $20 or >= $20.
    cmpi.w  #$20, d2
    ; d2 = char_index; $20 = 32 (split between lower and upper char range)
    bcc.b   .l2b388
    ; char_index >= $20: use the upper-range table entries

; Lower char range (index < $20): one table lookup
    move.w  d3, d0
    lsl.w   #$2, d0
    ; d0 = d3 * 4 (region index * 4 = stride into range table)
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d0
    ; base column offset from ROM table $5ECBC[region*4]
    andi.l  #$ff, d0
    ; zero-extend byte
    move.w  d2, d1
    ; d1 = char_index
    sub.w   d0, d1
    ; d1 = char_index - base_col (relative tile column within range)
    bra.b   .l2b3b6

; Upper char range (index >= $20): two lookups (base + range start adjustment)
.l2b388:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    ; upper-range base column from $5ECBE[region*4]
    andi.l  #$ff, d0
    move.w  d2, d1
    sub.w   d0, d1
    ; d1 = char_index - upper_base
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBD,a0
    move.b  (a0,d0.w), d0
    ; range start adjustment from $5ECBD[region*4]
    andi.l  #$ff, d0
    add.w   d0, d1
    ; d1 += range_start_adj: final relative column

.l2b3b6:
    addi.w  #$1f, d1
    ; add $1F = 31: bias offset so column 0 maps to tile position 31 (right-aligned display)
    move.w  d1, d3
    ; d3 = computed starting tile column for the animated number

    moveq   #$0,d2
    move.b  (a4), d2
    ; d2 = city_data[char][player] current value (low byte of stride-2 entry)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ; d0 = city_data[char][player]+1 (previous value, stored in next byte)
    sub.w   d0, d2
    ; d2 = current - previous = net change in city data this turn
    bra.b   .l2b40a
    ; jump into loop condition check (d4 times)
; --- Phase: Incremental Tile Number Animation Loop ---
; Step city_data up by 1 each iteration, rendering the tile number each frame.
; Runs d4 times (advantage value), so each point is shown as a separate step.
.l2b3ca:
    addq.b  #$1, (a4)
    ; city_data[char][player]++: advance the tracked value by one step
    addq.w  #$1, d2
    ; d2 = current display value (incremented in sync with city_data)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; arg: current value to display (number to render as tiles)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$660, d0
    ; d0 = d3 + $660: tile ID base $660 offset (selects digit tile glyph set)
    move.l  d0, -(a7)
    ; arg: tile ID (base + column)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; arg: column position (d3)
    moveq   #$0,d0
    move.b  $1(a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    ; arg: row = tile_record.row + 8 (place number one row below event marker)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    ; arg: col = tile_record.col (column from ROM record, unadjusted)
    jsr PlaceFormattedTiles
    ; render the formatted number (d2) at the given tile position using digit tiles
    pea     ($0001).w
    jsr PollInputChange
    ; wait 1 frame between each increment (player can skip)
    lea     $18(a7), a7
    ; clean up PlaceFormattedTiles (5) + PollInputChange (1) args

.l2b40a:
    subq.w  #$1, d4
    bge.b   .l2b3ca
    ; decrement counter; loop until all d4 increments have been displayed
    bra.b   .l2b412
    ; fall through to slot cleanup
; AI / silent path: apply gain directly without animation
.l2b410:
    add.b   d4, (a4)
    ; city_data[char][player] += advantage: apply full gain in one step (no UI)

; --- Phase: Slot Cleanup ---
; Clear the processed modifier event slot so it won't be re-processed.
.l2b412:
    clr.b   (a2)
    ; modifier_event.char_index = 0
    clr.b   $1(a2)
    ; modifier_event.state = 0 (no longer pending)
    clr.b   $2(a2)
    ; modifier_event.gain_cap = 0
    clr.b   $3(a2)
    ; modifier_event.gain_accum = 0
    clr.w   $4(a2)
    ; modifier_event.+$04 (word field) = 0

; --- Phase: Advance to Next Slot ---
.l2b424:
    addq.l  #$8, a2
    ; advance a2 to next 8-byte modifier event slot
    addq.w  #$1, d6
    ; d6 = next slot index
    cmpi.w  #$4, d6
    bcs.w   .l2b0a0
    ; loop while d6 < 4 (process all 4 event slots)

; --- Phase: Teardown ---
    movem.l -$a8(a6), d2-d7/a2-a5
    ; restore callee-saved registers ($80 locals + $28 = $A8 offset from saved SP)
    unlk    a6
    rts
