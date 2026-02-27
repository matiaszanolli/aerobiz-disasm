; ============================================================================
; RenderCharacterPanel -- Draws the character detail panel for one route slot; prints char name, displays bonus value labels computed from CalcQuarterBonus, and shows a star rating bar.
; 1346 bytes | $01377E-$013CBF
; ============================================================================
; --- Phase: Setup / Bonus Calculation ---
; Stack frame (link #-$14 = 5 locals × 4 bytes):
;   $8(a6)  = player_index (passed by caller)
;   $12(a6) = route slot index within player (word)
;   $e(a6)  = (used later) secondary player index or context word
;   $-$04(a6) = local[0]: bonus_value * 4      (x4 scale)
;   $-$08(a6) = local[1]: bonus_value * 2      (x2 scale)
;   $-$0c(a6) = local[2]: bonus_value * 10     (base display value)
;   $-$10(a6) = local[3]: bonus_value * 10 * 3/4 (three-quarter display value)
;   $-$14(a6) = local[4]: bonus_value * 10 / 2  (half display value)
; a5 = PrintfWide ($3B270): cached for repeated wide-font text output calls
RenderCharacterPanel:
    link    a6,#-$14
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    ; d7 = player_index (0-3): identifies which player's panel to render
    movea.l  #$0003B270,a5
    ; a5 = PrintfWide: cached for all subsequent wide-font text calls
    ; compute pointer to per-slot char data: base $FF0338 + player*32 + slot*8
    move.w  d7, d0
    lsl.w   #$5, d0
    ; d0 = player_index * 32 (=$20): player stride in $FF0338 block
    move.w  $12(a6), d1
    ; d1 = route slot index (0-based)
    lsl.w   #$3, d1
    ; d1 *= 8: slot stride (8 bytes per slot in this table)
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    ; $FF0338 = char display table (PackSaveState $80-byte block, purpose TBD; slot assignments)
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; a2 = pointer to this player's slot record in $FF0338
    ; a2+$06 holds a word used to index into route_slots / char stat table
    ; compute pointer to this player's record in player_records ($FF0018)
    move.w  d7, d0
    mulu.w  #$24, d0
    ; d0 = player_index * $24 = byte offset into player_records
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a3 = player record (36-byte struct at $FF0018 + player_index * $24)
    ; look up the char stat route entry: $FF9A10 is near the route_slots header area
    move.w  $6(a2), d0
    ; a2+$06 = route entry index word (indexes into stat lookup table)
    lsl.w   #$2, d0
    ; d0 *= 4: word offset in route stat table
    movea.l  #$00FF9A10,a0
    ; $FF9A10 = just before route_slots ($FF9A20): route stat header table
    lea     (a0,d0.w), a0
    movea.l a0, a4
    ; a4 = pointer to route stat entry for this slot
    move.w  (a4), d0
    ; d0 = route stat entry value (word): input to quarterly bonus calculation
    ext.l   d0
    move.l  d0, -(a7)
    ; CalcQuarterBonus(stat_value): (quarter/4 + 30) * stat_value * 20 / 100
    ; computes the quarter-adjusted percentage bonus for this character's contribution
    jsr (CalcQuarterBonus,PC)
    nop
    ; d0 = raw bonus result; multiply by 10 to produce display-scale value
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    ; d0 = bonus * 4
    add.l   d1, d0
    ; d0 = bonus * 5
    add.l   d0, d0
    ; d0 = bonus * 10 = base display value
    move.l  d0, d5
    ; d5 = bonus * 10: master scaled value used for all derived locals
    move.l  d0, -$c(a6)
    ; local[-$0c] = bonus * 10 (full value for "total" label)
    ; compute half value: d5 / 2 (with signed rounding)
    move.l  d5, d0
    bge.b   l_137ee
    addq.l  #$1, d0
    ; round up before right-shift for negative values
l_137ee:
    asr.l   #$1, d0
    ; d0 = bonus * 10 / 2 = half display value
    move.l  d0, -$14(a6)
    ; local[-$14] = bonus / 2 (half-value for star bar midpoint)
    ; compute three-quarter value: d5 - d5/4
    move.l  d5, d0
    bge.b   l_137fa
    addq.l  #$3, d0
l_137fa:
    asr.l   #$2, d0
    ; d0 = bonus * 10 / 4 = quarter value
    move.l  d5, d1
    sub.l   d0, d1
    ; d1 = bonus * 10 - bonus * 10/4 = three-quarter value
    move.l  d1, -$10(a6)
    ; local[-$10] = bonus * 10 * 3/4 (three-quarter for second label tier)
    ; compute double value
    move.l  d5, d0
    add.l   d0, d0
    ; d0 = bonus * 20 = x2 scale
    move.l  d0, -$8(a6)
    ; local[-$08] = bonus * 20 (double value for third label tier)
    ; compute quadruple value
    move.l  d5, d0
    lsl.l   #$2, d0
    ; d0 = bonus * 40 = x4 scale
    move.l  d0, -$4(a6)
    ; local[-$04] = bonus * 40 (quadruple value for fourth label tier)
; --- Phase: Panel Layout and Initial Text Render ---
; Clear the screen, draw the panel box, print the character name and bonus value labels.
    ; CmdSetBackground(0): clear background tiles / reset display layer
    clr.l   -(a7)
    jsr CmdSetBackground
    ; SetTextWindow: full 32×32 tile window at (0,0) -- clear any prior clip region
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.w   d2
    ; d2 = 0: column base (left edge of text panel, tile units)
    moveq   #$4,d3
    ; d3 = 4: row base (top of character panel, tile units) -- panel starts at tile row 4
    ; SetTextWindow again (redundant clear) to finalize clip state before DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    ; DrawBox: draw a bordered dialog box 17 tiles wide, 30 tiles tall, at tile (1,1)
    pea     ($0011).w
    ; $11 = 17 tile columns wide
    pea     ($001E).w
    ; $1E = 30 tile rows tall
    pea     ($0001).w
    ; origin column = 1 (leave 1 tile left margin)
    pea     ($0001).w
    ; origin row = 1 (leave 1 tile top margin)
    jsr DrawBox
    ; reset text window to 32×32 after DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; position cursor at (d3 = col 4, d2+2 = row 2) for character name
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; column = d3 = 4
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; row = d2 + 2 = 2
    jsr SetTextCursor
    ; look up character name string pointer from ROM table at $5E296
    moveq   #$0,d0
    move.w  $6(a2), d0
    ; a2+$06 = route entry index: identifies the character assigned to this slot
    lsl.l   #$2, d0
    ; d0 *= 4: longword offset into character name pointer table at $5E296
    movea.l  #$0005E296,a0
    ; $5E296 = ROM character name string pointer table (one longword per character)
    move.l  (a0,d0.l), -(a7)
    ; push pointer to character name string
    jsr     (a5)
    ; PrintfWide: print character name in wide font at current cursor position
    lea     $2c(a7), a7
    ; position cursor at (d3+3, d2+2) for first bonus label
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    ; column = d3 + 3 = 7
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; row = d2 + 2 = 2
    jsr SetTextCursor
    ; print label for "full bonus" value at $3F662
    pea     ($0003F662).l
    ; $3F662 = ROM format string for full-value label (e.g. "Full: %d")
    jsr     (a5)
    ; position cursor at (d3+3, d2+$14) for bonus value display
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    ; column = d2 + $14 = $14 (right side of panel, wide-font column 20)
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    ; local[-$0c] = bonus * 10 = full display value
    pea     ($0003F65C).l
    ; $3F65C = ROM format string for full value number (e.g. "%d")
    jsr     (a5)
    ; PrintfWide: print the full bonus value
    ; position cursor at (d3+7, d2+2) for half-value label
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    ; column = d3 + 7 = 11
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; row = d2 + 2 = 2
    jsr SetTextCursor
    pea     ($0003F64A).l
    ; $3F64A = ROM format string for half-value label (e.g. "Half: %d")
    jsr     (a5)
    ; position cursor at (d3+$b, d2+2) for quarter-value label
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    ; column = d3 + $B = 15
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; row = d2 + 2 = 2
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F636).l
    ; $3F636 = ROM format string for quarter/lowest-tier value label
    jsr     (a5)
    ; PrintfWide: print the lowest-tier bonus label
    ; ShowTextDialog: display the introductory character description dialog
    ; args: player_index d7, dialog_table $479D2, slot_index $12(a6), 0, 0, 0
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ; $12(a6) = route slot index
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    ; $479D2 = ROM dialog table pointer for character description text
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; ShowTextDialog: display dialog text box with PrintfWide and table lookup
    jsr ShowTextDialog
    ; reset text window to 32×32 after dialog
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
; --- Phase: Input Flush Loop ---
; Wait until no buttons are held before entering the main interaction loop.
; This prevents accidentally consuming the button press that opened this panel.
l_1395a:
    clr.l   -(a7)
    ; ReadInput(0): read joypad via GameCommand #10, return held-button word
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    ; mask to 12 button bits; if any button still held, keep waiting
    bne.b   l_1395a
    ; --- Phase: Main Input Loop Initialization ---
    clr.w   d6
    ; d6 = 0: current display value index / result accumulator for ShowPlayerCompare
    clr.w   ($00FFBD58).l
    ; $FFBD58 = display state flag (near win_bottom region): 0 = initial state
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: 0 = not in countdown mode
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: 0 = countdown not yet started
    clr.w   d5
    ; d5 = 0: re-render flag (0 = no redraw needed, 1 = panel must be redrawn)
    moveq   #$2,d4
    ; d4 = 2: star-rating bar initial index (selects which bonus-tier local to display)
; --- Phase: Main Interaction Loop ---
; Each iteration: check if redraw is needed (d5==1 or FFBD58 flag), draw star bar,
; call ShowPlayerCompare for d-pad navigation, dispatch on result.
l_13982:
    tst.w   ($00FFBD58).l
    ; $FFBD58: nonzero = button event processed; 0 = no new input, skip to star bar render
    beq.w   l_13ac0
    cmpi.w  #$1, d5
    ; d5 = 1 means a full panel redraw was requested (e.g. after dialog dismissed)
    bne.w   l_13ac8
    ; --- Panel Redraw Path: re-draw box and all text labels ---
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; redraw the panel border box (same dimensions as initial render)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    ; re-print character name at (d3, d2+2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  $6(a2), d0
    ; a2+$06 = character slot index for name lookup
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a5)
    ; re-print full-value label at (d3+3, d2+2)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F624).l
    ; $3F624 = refreshed format string for full-value label (redraw variant)
    jsr     (a5)
    ; re-print full-value number at (d3+3, d2+$14)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    ; local[-$0c] = bonus * 10 = full display value
    pea     ($0003F61E).l
    ; $3F61E = refreshed format string for full-value number (redraw variant)
    jsr     (a5)
    ; re-print half-value label at (d3+7, d2+2)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F60C).l
    ; $3F60C = refreshed half-value label format string
    jsr     (a5)
    ; re-print quarter-value label at (d3+$b, d2+2)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F5F8).l
    ; $3F5F8 = refreshed quarter-value label format string
    jsr     (a5)
    ; re-display character description dialog after panel redraw
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d5
    ; d5 = 0: redraw complete, clear flag
    bra.b   l_13ac8
; --- No new input: set FFBD58 so next iteration processes star-bar update ---
l_13ac0:
    move.w  #$1, ($00FFBD58).l
    ; $FFBD58 = 1: signal that star-bar redraw is pending
; --- Phase: Star Bar Render and Input Dispatch ---
; Print the bonus value for the currently selected tier (d4), draw the star bar,
; then call ShowPlayerCompare to handle d-pad input and return a navigation code.
l_13ac8:
    ; position cursor at (d3+7, d2+$14) for the selected-tier value
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    ; column = d3 + 7 = 11
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    ; row = d2 + $14 = 20 (right column, lower area)
    jsr SetTextCursor
    ; select the local variable for the current d4 tier: -$14(a6) base, stride 4
    move.w  d4, d0
    lsl.w   #$2, d0
    ; d4 * 4 = offset into local array: 0→-$14, 1→-$10, 2→-$0c, 3→-$08, 4→-$04
    move.l  -$14(a6, d0.w), -(a7)
    ; push: local[-$14 + d4*4] = bonus value for the selected tier
    pea     ($0003F5F2).l
    ; $3F5F2 = format string for the selected-tier value display
    jsr     (a5)
    ; PrintfWide: print the tier value
    ; draw the star rating bar background: GameCommand #$1A clear at (d3+$b, d2+$15)
    move.l  #$8000, -(a7)
    ; $8000 = high-priority (foreground plane)
    pea     ($0002).w
    ; 2 tiles wide
    pea     ($0009).w
    ; 9 tiles tall
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    ; column = d3 + $B = 15
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    ; row = d2 + $15 = 21
    clr.l   -(a7)
    pea     ($001A).w
    ; GameCommand #$1A: clear the star bar tile region before redrawing
    jsr GameCommand
    lea     $2c(a7), a7
    ; position cursor at (d3+$b, d2+$15) for the star-tier label
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    ; print the label string for this tier from the tier-label table at $479E2
    move.w  d4, d0
    lsl.w   #$2, d0
    ; d4 * 4 = offset into tier-label pointer table
    movea.l  #$000479E2,a0
    ; $479E2 = ROM table of format string pointers for each star-bar tier label
    move.l  (a0,d0.w), -(a7)
    jsr     (a5)
    ; PrintfWide: print the tier label (e.g. "★★★☆☆")
    ; ShowPlayerCompare: interactive star-bar with d-pad navigation
    ; Pixel positions computed from tile coords: col*8+$48, row*8+$C0 (inner area)
    move.w  d6, d0
    ; d6 = current result / scroll position from previous ShowPlayerCompare call
    move.l  d0, -(a7)
    pea     ($0033).w
    ; $33 = 51: max star count / scale for bar length
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$48, d0
    ; pixel X right = d3*8 + $48 = column in pixels (right edge of bar)
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    ; pixel Y bottom = d2*8 + $C0 = row in pixels (bottom edge of bar)
    move.l  d0, -(a7)
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$30, d0
    ; pixel X left = d3*8 + $30 = left edge of bar (offset from right by panel width)
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    ; pixel Y top = d2*8 + $C0 (same row -- horizontal bar)
    move.l  d0, -(a7)
    ; ShowPlayerCompare: renders bar and handles d-pad; returns navigation code in d0
    jsr ShowPlayerCompare
    lea     $24(a7), a7
    move.w  d0, d6
    ; d6 = navigation result (also the new display value)
    ext.l   d0
    ; --- Dispatch on ShowPlayerCompare return code ---
    ; $20 = confirm/select: player pressed A/Start to commit current tier selection
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_13bb6
    ; $10 = cancel/back: player pressed B/Start to exit without changes
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_13c5c
    ; $01 = scroll right / up: increment tier selector
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_13c66
    ; $02 = scroll left / down: decrement tier selector
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_13c86
    ; any other code: loop back without changing tier
    bra.w   l_13ca2
; --- Case $20: Player Confirmed Tier Selection ---
; Check if the selected tier value is within budget (player cash). Commit or show error.
l_13bb6:
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag = 0: exit countdown mode
    ; get the bonus value for the currently selected tier
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
    ; d5 = selected tier value (local[-$14 + d4*4])
    cmp.l   $6(a3), d5
    ; compare d5 against player_record[+$06] (cash): can we afford this tier?
    bgt.b   l_13c12
    ; cost exceeds cash: show "can't afford" dialog instead
    ; cost is within budget: commit the selection
    move.w  #$64, $4(a2)
    ; a2+$04 = route_slot.ticket_price (word): set fare to $64 = 100 (base price)
    ; compute stat adjustment offset: d2 = d4 * $14 + $A
    move.w  d4, d2
    mulu.w  #$14, d2
    ; d2 = d4 * 20: tier × 20 = stat row base
    addi.w  #$a, d2
    ; d2 += $A: offset within stat row
    move.w  $e(a6), d0
    ; $e(a6) = secondary player index / context word
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; UpdateCharacterStats(player_index, context_index): apply stat changes to character records
    jsr (UpdateCharacterStats,PC)
    nop
    addq.l  #$8, a7
    add.w   d0, d2
    ; d2 += UpdateCharacterStats return: final stat value after update
    cmpi.w  #$64, d2
    ; clamp to max $64 = 100
    bcc.b   l_13bfe
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_13c00
l_13bfe:
    ; stat capped at $64 = 100 (maximum)
    moveq   #$64,d0
l_13c00:
    move.b  d0, $2(a2)
    ; a2+$02 = route_slot.plane_type byte: write the capped stat as the slot's plane_type
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
    ; reload d5 = tier value (for return)
l_13c0c:
    ; return d5 as the result value (zero for cancel, tier value for confirm)
    move.l  d5, d0
    bra.w   l_13cb6
    ; fall through to function return with d0 = result
l_13c12:
    ; Player's cash < tier cost: clear the selection area and show "insufficient funds" dialog
    ; GameCommand #$1A: clear 18-row × 32-col text region to erase current panel text
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    ; ShowTextDialog: display "insufficient funds" message
    ; args: player_index d7, dialog_table $479DE, slot $12(a6), choice 2, flag 0, flag 1
    pea     ($0001).w
    ; wait-for-button flag
    clr.l   -(a7)
    pea     ($0002).w
    ; $0002 = choice count or display mode for insufficient-funds dialog
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479DE).l, -(a7)
    ; $479DE = ROM dialog pointer for "insufficient funds" text
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    moveq   #$1,d5
    ; d5 = 1: request full panel redraw on next loop iteration
    bra.b   l_13ca2
; --- Case $10: Cancel / Back ---
l_13c5c:
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag = 0: exit countdown mode
    moveq   #$0,d5
    ; d5 = 0: return 0 = no selection made (cancelled)
    bra.b   l_13c0c
; --- Case $01: Scroll Right -- increment tier selector ---
l_13c66:
    move.w  #$1, ($00FF13FC).l
    ; $FF13FC = input_mode_flag = 1: start countdown mode for this UI context
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    ; d0 = d4 + 1 (tentative new tier)
    moveq   #$4,d1
    ; max tier index = 4 (5 tiers: 0-4)
    cmp.l   d0, d1
    ; if new index <= 4, accept it
    ble.b   l_13c82
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   l_13ca0
l_13c82:
    moveq   #$4,d0
    ; clamp to max tier 4
    bra.b   l_13ca0
; --- Case $02: Scroll Left -- decrement tier selector ---
l_13c86:
    move.w  #$1, ($00FF13FC).l
    ; $FF13FC = input_mode_flag = 1
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    ; d0 = d4 - 1 (tentative new tier)
    ble.b   l_13c9e
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   l_13ca0
l_13c9e:
    moveq   #$0,d0
    ; clamp to min tier 0
l_13ca0:
    move.w  d0, d4
    ; d4 = new tier index after clamp
; --- Loop-back: advance display frame and repeat ---
l_13ca2:
    ; GameCommand #$000E + #$0006: advance display state (render one frame)
    pea     ($0006).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    ; loop back to main interaction loop
    bra.w   l_13982
; --- Phase: Return ---
l_13cb6:
    ; d0 = result: 0 = cancelled, nonzero = tier value selected
    movem.l -$3c(a6), d2-d7/a2-a5
    unlk    a6
    rts
