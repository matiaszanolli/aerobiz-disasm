; ============================================================================
; RunSlotCountPicker -- Presents a numbered selector widget for choosing how many char slots to commit (1 through N), using left/right input to navigate and A/B to confirm or cancel, returning the selected count.
; 674 bytes | $0288A4-$028B45
; ============================================================================
RunSlotCountPicker:
; --- Phase: Setup ---
; Arg: $8(a6) = max_slots (maximum selectable count, 1-based)
; Returns D0.W = selected count (1..max_slots), or 0 if cancelled
; d2=current_selection, d3=last_raw_input, d4=redraw_flag, d5=max_slots
; d6=box_height($15=21), d7=box_x($2=2)
; a2=GameCommand ($D64), a3=$FF13FC (input_mode_flag), a4=tile_attr_array, a5=hl_tile_array
    link    a6,#-$54
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5           ; d5 = max_slots (number of options to display)
    movea.l  #$00000D64,a2       ; a2 = GameCommand entry point (called via indirect jsr)
    movea.l  #$00FF13FC,a3       ; a3 = input_mode_flag: nonzero = input countdown active
    lea     -$52(a6), a4         ; a4 -> local tile attribute word array (on stack frame)
    lea     -$2a(a6), a5         ; a5 -> local highlight tile word array (on stack frame)

; --- Phase: Initialize Tile Word Tables ---
; Build two parallel word arrays in the stack frame, one entry per selectable slot.
; a5[i] = $8000 (unselected highlight tile), a4[i] = $8543 (normal slot tile)
; Entries beyond max_slots are zeroed as terminators.
    clr.w   d2                   ; d2 = loop counter (slot index 0..max_slots-1)
    bra.b   l_288e6
l_288c8:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0               ; d0 = d2*2 (word offset into local arrays)
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)    ; highlight tile word = $8000 (normal/unselected state)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)    ; attribute tile word = $8543 (slot tile graphic)
    addq.w  #$1, d2
l_288e6:
    cmp.w   d5, d2               ; loop until d2 == max_slots
    blt.b   l_288c8
; Write zero terminators at index [max_slots] in both arrays
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a5,a0.l)            ; terminator in highlight array
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a4,a0.l)            ; terminator in attribute array
; Write special fixed tiles for the selector arrows/endpoints:
; $8541 = left-arrow/start tile, $8542 = right-arrow/end tile
    move.w  #$8541, -$2a(a6)     ; first entry of highlight array = left-arrow tile
    move.w  #$8542, -$52(a6)     ; first entry of attribute array = right-arrow tile

; --- Phase: Draw Dialog Box ---
; Dialog box: top-left at (d7=2, d6+4=25), width 4, height 23 ($17)
    moveq   #$2,d7               ; d7 = box column X = 2
    moveq   #$15,d6              ; d6 = box height = $15 = 21 rows
    pea     ($0004).w            ; width = 4 chars
    pea     ($0017).w            ; height = $17 = 23
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
; Draw bordered box at (x=2, y=21, w=4, h=23)
    jsr DrawBox
; Set corresponding text rendering window to same dimensions
    pea     ($0004).w
    pea     ($0017).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetTextWindow            ; restrict text output to the dialog box area
; Position cursor for the dialog title/prompt line
    pea     ($0017).w            ; Y = $17 = 23
    pea     ($0013).w            ; X = $13 = 19
    jsr SetTextCursor
    pea     ($00041AE4).l        ; ROM string: "Slots" or slot-count prompt label
    jsr PrintfNarrow             ; print dialog header text

; Check if first ReadInput returns with an existing held button state
    clr.l   -(a7)
    jsr ReadInput                ; flush / sample current input state
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_28970
    moveq   #$1,d0               ; input was already held: set -$2(a6)=1 (skip first wait)
    bra.b   l_28972
l_28970:
    moveq   #$0,d0               ; no prior input: normal wait
l_28972:
    move.w  d0, -$2(a6)         ; -$2(a6) = "skip initial ReadInput" flag
    clr.w   d3                   ; d3 = accumulated raw direction bits from ProcessInputLoop
    moveq   #$1,d4               ; d4 = redraw flag: 1 = redraw picker display this frame
    clr.w   (a3)                 ; input_mode_flag ($FF13FC) = 0 (reset UI mode)
    clr.w   ($00FFA7D8).l        ; input_init_flag ($FFA7D8) = 0 (reset input countdown)
    moveq   #$1,d2               ; d2 = current selected count (starts at 1)

; --- Phase: Main Interaction Loop ---
l_28984:
    tst.w   d4                   ; redraw_flag nonzero?
    beq.w   l_28a6c              ; no: skip redraw, go to input polling

; --- Phase: Redraw Current Selection Display ---
; Position cursor to display the number in the center of the box
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0              ; row = d6+1
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$f, d0              ; col = d7+$F = 17
    move.l  d0, -(a7)
    jsr SetTextCursor            ; position for number display
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AE0).l        ; ROM format string: "%d" (decimal number)
    jsr PrintfWide               ; display current selection count (d2) in wide font
    lea     $10(a7), a7

; If selection is exactly 1, show the left-limit indicator (special tile at row 1)
    cmpi.w  #$1, d2
    bne.b   l_289f4
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
; GameCommand #$1A: clear a tile region (erase previous number display)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0017).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)                 ; GameCommand #$1A = ClearTileArea
    lea     $24(a7), a7
    pea     ($00041ADA).l        ; ROM string: "<" or left-limit label
    bra.b   l_28a0a
l_289f4:
; Selection > 1: show the right navigation label instead
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    addq.l  #$8, a7
    pea     ($00041AD4).l        ; ROM string: ">" or right-nav label
l_28a0a:
    jsr PrintfNarrow             ; print the directional label

; GameCommand #$1B: DMA tile strip (update slot tile display row, highlight tiles)
; a5 = highlight tile array (word per slot), displayed at row d6+1, col d7+1
    move.l  a5, -(a7)            ; source: highlight tile word array
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; count = max_slots
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)            ; row = d6+1
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)            ; col = d7+1
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)                 ; GameCommand #$1B = place tile strip (highlight row)
    lea     $20(a7), a7

; a4 = attribute tile word array, displayed at row d6+2, col d7+1
    move.l  a4, -(a7)            ; source: attribute tile word array
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; count = max_slots
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)            ; row = d6+2
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)            ; col = d7+1
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)                 ; GameCommand #$1B = place tile strip (attribute row)
; GameCommand #$E: trigger display update / swap buffers
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)                 ; GameCommand #$E = display refresh
    lea     $24(a7), a7
    clr.w   d4                   ; clear redraw flag (display is now current)

; --- Phase: Input Polling ---
l_28a6c:
; If "skip first wait" flag is set, do one ReadInput to drain any held button
    tst.w   -$2(a6)
    beq.b   l_28a82
    clr.l   -(a7)
    jsr ReadInput                ; drain held button state
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_28984              ; still held: force redraw and loop
l_28a82:
    clr.w   -$2(a6)
; ProcessInputLoop: wait up to $A ticks for a directional button press
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000A).w            ; timeout = $A frames
    jsr ProcessInputLoop         ; returns raw direction bits: bit3=right, bit2=left, bit4=B, bit5=A
    addq.l  #$8, a7
; Mask to direction + A/B bits: $3C = bits 2,3,4,5 (left/right/B/A)
    andi.w  #$3c, d0
    move.w  d0, d3               ; save masked bits for next poll

; --- Phase: Handle Right (Increment) ---
    andi.w  #$8, d0              ; bit 3 = right d-pad
    beq.b   l_28acc
    move.w  #$1, (a3)            ; input_mode_flag = 1 (activate input countdown)
    cmp.w   d5, d2               ; already at max?
    bge.b   l_28ac8              ; yes: no further increment
    addq.w  #$1, d2              ; d2++ (increment selection)
; Update the tile for the newly-selected slot: write $8541 (selected highlight tile)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0               ; word offset = d2*2
    movea.l d0, a0
    move.w  #$8541, -$2(a5, a0.l) ; highlight array[d2-1] = $8541 (selected)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8542, -$2(a4, a0.l) ; attribute array[d2-1] = $8542 (right-arrow tile)
l_28ac8:
    moveq   #$1,d4               ; set redraw flag
    bra.b   l_28b2a

; --- Phase: Handle Left (Decrement) ---
l_28acc:
    move.w  d3, d0
    andi.w  #$4, d0              ; bit 2 = left d-pad
    beq.b   l_28b04
    move.w  #$1, (a3)            ; input_mode_flag = 1
; Clamp: do not go below 1
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0              ; d0 = d2-1
    moveq   #$1,d1
    cmp.l   d0, d1               ; (d2-1) < 1?
    bgt.b   l_28ac8              ; already at minimum: just redraw
    subq.w  #$1, d2              ; d2-- (decrement selection)
; Revert tile at the slot just vacated back to unselected state
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)    ; highlight array[d2] = $8000 (unselected)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)    ; attribute array[d2] = $8543 (normal slot tile)
    bra.b   l_28ac8

; --- Phase: Handle B Button (Cancel) ---
l_28b04:
    move.w  d3, d0
    andi.w  #$10, d0             ; bit 4 = B button (cancel)
    beq.b   l_28b18
    clr.w   (a3)                 ; input_mode_flag = 0 (exit countdown)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
    clr.w   d2                   ; d2 = 0 (return value 0 = cancelled)
    bra.b   l_28b3a              ; exit

; --- Phase: Handle A Button (Confirm) ---
l_28b18:
    move.w  d3, d0
    andi.w  #$20, d0             ; bit 5 = A button (confirm)
    beq.b   l_28b2a              ; no button pressed: continue loop
    clr.w   (a3)                 ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
    bra.b   l_28b3a              ; exit with d2 = current selection

; No directional input: issue a display-idle GameCommand and loop
l_28b2a:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a2)                 ; GameCommand #$E mode $6: idle display tick
    addq.l  #$8, a7
    bra.w   l_28984              ; continue main loop

; --- Phase: Return ---
l_28b3a:
    move.w  d2, d0               ; D0 = selected count (1..max), or 0 if cancelled
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts
