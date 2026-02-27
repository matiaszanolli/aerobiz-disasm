; ============================================================================
; RenderTilePattern -- Displays chars compatible with the current slot type; builds compatible-char index list, renders names with selection cursor, handles paging, and updates stat bytes on selection change.
; 1208 bytes | $015040-$0154F7
; ============================================================================
; --- Phase: Setup ---
; Args: $8(a6) = slot type index (d5), $C(a6) = pointer to char/slot record (a2)
RenderTilePattern:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5           ; d5 = slot type index (used to select roster for this slot)
    movea.l $c(a6), a2           ; a2 = pointer to char/slot record (char stat or player record)
    lea     -$20(a6), a4         ; a4 = local compat-index table (16 words on stack)
    movea.l  #$00000D64,a5       ; a5 = GameCommand dispatch address (used throughout)
    ; GetLowNibble: extract low nibble from the record -- stores current selection byte
    move.l  a2, -(a7)
    jsr GetLowNibble             ; d0 = low nibble of record byte = current selection sub-field
    move.w  d0, -$28(a6)         ; local[-$28] = saved low nibble (original selection)
    ; --- Phase: Clear Display Area ---
    ; GameCommand #$1A clears a rectangular tile region.
    ; Args on stack (right-to-left): cmd=1A, priority=$8000, col=0, row=2, w=9, h=4, ?=2
    move.l  #$8000, -(a7)        ; display priority high bit
    pea     ($0002).w            ; column = 2
    pea     ($0004).w            ; width = 4 tiles
    pea     ($0009).w            ; height = 9 tiles
    pea     ($0002).w            ; row = 2
    clr.l   -(a7)                ; padding / extra arg
    pea     ($001A).w            ; GameCommand #$1A = clear tile rectangle
    jsr     (a5)                 ; call GameCommand via a5 = $0D64
    lea     $20(a7), a7          ; pop 8 longwords (7 args + cmd word)
    ; --- Phase: Build Compatible-Char Index List ---
    ; Walk the event_records table ($FFB9E8) for this slot type, checking each of
    ; the 16 character slots ($10 = 16 entries). For each slot whose character
    ; is compatible with the slot requirements, record its global char index in a4[].
    ; d3 = count of compatible chars found so far.
    ; d2 = character slot iterator (0-15).
    ; d7 = index within d3[] of the currently selected character.
    move.w  d5, d0               ; d0 = slot type
    lsl.w   #$5, d0              ; d0 = slot_type * $20 (32 bytes per slot type in event_records)
    movea.l  #$00FFB9E8,a0       ; a0 = $FFB9E8 = event_records base
    lea     (a0,d0.w), a0        ; a0 = event_records[slot_type] start
    movea.l a0, a3               ; a3 = walking pointer through this slot type's 16 char entries
    clr.w   d3                   ; d3 = compatible-char count (index into a4[] list)
    clr.w   d2                   ; d2 = character iterator (0-15)
.l1509c:
    tst.b   (a3)                 ; test char slot occupancy byte (0 = empty slot)
    beq.b   .l150f0              ; empty slot: skip
    ; CheckCharCompat(char_index, slot_byte0, slot_byte1): returns 1 if compatible
    moveq   #$0,d0
    move.b  $1(a2), d0           ; d0 = record byte +1 (slot requirement field B)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0             ; d0 = record byte +0 (slot requirement field A)
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0               ; d0 = char slot index (0-15)
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckCharCompat          ; returns 1 if char at slot d2 is compatible with this record
    lea     $c(a7), a7           ; pop 3 args
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l150f0              ; not compatible: skip this slot
    ; Record this char's global index in the compat-index table at a4
    move.w  d3, d0               ; d0 = current compat count (= table write index)
    ext.l   d0
    add.l   d0, d0               ; d0 *= 2 (word offset)
    movea.l d0, a0
    move.w  d2, (a4,a0.l)        ; compat_tab[d3] = d2 (store char slot index)
    ; Check if this char is the currently selected one (GetByteField4 returns current selection)
    move.l  a2, -(a7)
    jsr GetByteField4            ; d0 = current selection index from record (low byte field)
    addq.l  #$4, a7
    andi.l  #$ffff, d0           ; zero-extend
    move.w  d2, d1               ; d1 = current char iterator index
    ext.l   d1
    cmp.l   d1, d0               ; does current selection == this char index?
    bne.b   .l150ee
    move.w  d3, d7               ; d7 = position of selected char in the compat list
.l150ee:
    addq.w  #$1, d3              ; compatible char count++
.l150f0:
    addq.l  #$2, a3              ; advance to next event_record entry (2 bytes/entry)
    addq.w  #$1, d2              ; next char slot
    cmpi.w  #$10, d2             ; loop over all 16 character slots
    blt.b   .l1509c              ; keep scanning
    ; --- Phase: Compute List Bounds and Mark Current Selection ---
    move.w  d3, d0               ; d0 = total compatible char count
    addi.w  #$ffff, d0           ; d0 = count - 1 (max valid index)
    move.w  d0, -$24(a6)         ; local[-$24] = last valid list index (for wrap-around)
    tst.w   -$24(a6)
    bne.b   .l15112
    move.w  #$1, -$26(a6)        ; only 1 compatible char: disable navigation (flag=1 = single-entry)
    bra.b   .l15116
.l15112:
    clr.w   -$26(a6)             ; multiple chars available: enable d-pad navigation (flag=0)
.l15116:
    ; Set d3 = cursor position = index of currently selected char in compat list
    move.w  d7, d3               ; d3 = d7 = index of selected char in compat_tab[]
    ; Subtract a stat byte from the event_records entry for the selected char.
    ; This marks that entry to distinguish it as the current selection during rendering.
    ; $FFB9E9 = event_records + 1 (second byte of each 2-byte entry = stat/selection byte)
    move.w  d5, d0               ; d0 = slot type
    lsl.w   #$5, d0              ; d0 = slot_type * $20
    move.w  d7, d1               ; d1 = selected char's compat index
    ext.l   d1
    add.l   d1, d1               ; d1 *= 2 (word offset into compat_tab)
    movea.l d1, a0
    move.w  (a4,a0.l), d1        ; d1 = compat_tab[d7] = global char slot index of selection
    add.w   d1, d1               ; d1 *= 2 (event_record entry is 2 bytes wide)
    add.w   d1, d0               ; d0 = slot_type*$20 + char_slot*2 (offset into FFB9E9)
    move.b  -$27(a6), d1         ; d1 = saved stat byte (from link frame, caller-set)
    movea.l  #$00FFB9E9,a0       ; a0 = $FFB9E9 (event_records stat/selection byte base)
    sub.b   d1, (a0,d0.w)        ; mark selection: subtract stat byte from this entry's second byte
    ; --- Phase: Initial Input Read (Debounce) ---
    ; Read joypad once to determine if a button was held coming in.
    ; d2 = 1 if button already held (skip portrait redraw on entry), 0 if fresh press.
    clr.l   -(a7)
    jsr ReadInput                ; read joypad state via GameCommand #10
    addq.l  #$4, a7
    tst.w   d0                   ; d0 = input state; nonzero = button held
    beq.b   .l1514c
    moveq   #$1,d2               ; d2 = 1: input was already held on entry (suppress redraw)
    bra.b   .l1514e
.l1514c:
    moveq   #$0,d2               ; d2 = 0: fresh input state
.l1514e:
    clr.w   -$22(a6)             ; local[-$22] = last processed input button bits (cleared)
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0 (reset countdown UI mode)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0 (reset ProcessInputLoop countdown state)
    moveq   #$1,d6               ; d6 = 1: force portrait + detail panel redraw on first iteration
    clr.w   d4                   ; d4 = animation/display sub-phase counter
    ; --- Phase: Display Sub-Phase Loop ---
    ; d4 cycles: 1 (render arrows + wait), 15 (page turn + wait), 30 (wrap d4 to 0).
    ; This paces the display updates and handles arrow tile placement.
.l15162:
    addq.w  #$1, d4              ; d4 = sub-phase counter (increments each outer loop pass)
    cmpi.w  #$1, d4              ; on first pass (d4==1): place navigation arrow tiles
    bne.b   .l151d2
    ; Place up-arrow tile: TilePlacement(tile=$0772, row=$39, col=$80, h=8, w=1, pal=1, pri=$8000)
    ; $0772 = up-arrow tile index in the BAT
    move.l  #$8000, -(a7)        ; priority flag
    pea     ($0001).w            ; palette 1
    pea     ($0001).w            ; width = 1
    pea     ($0094).w            ; height = $94 (?)
    pea     ($0008).w            ; h param
    pea     ($0039).w            ; row = $39
    pea     ($0772).w            ; tile index = $772 (up-arrow navigation tile)
    jsr TilePlacement            ; place up-arrow indicator tile on screen
    pea     ($0001).w
    pea     ($000E).w            ; GameCommand #$0E = wait for V-blank / display sync
    jsr     (a5)
    lea     $24(a7), a7
    ; Place down-arrow tile: tile=$0773 at row=$3A
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0094).w
    pea     ($0080).w
    pea     ($003A).w            ; row = $3A (one row below up arrow)
    pea     ($0773).w            ; tile index = $773 (down-arrow navigation tile)
    jsr TilePlacement            ; place down-arrow indicator tile
    lea     $1c(a7), a7
.l151c4:
    pea     ($0001).w
    pea     ($000E).w            ; GameCommand #$0E = wait for display sync
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l151f2
.l151d2:
    cmpi.w  #$f, d4              ; d4 == 15: page-turn effect frame
    bne.b   .l151ea
    ; GameCmd16 with args ($39, $02): trigger page-scroll or cursor blink effect
    pea     ($0002).w
    pea     ($0039).w            ; param = $39 (row?)
    jsr GameCmd16                ; GameCommand #16 wrapper (display register or sprite effect)
    addq.l  #$8, a7
    bra.b   .l151c4
.l151ea:
    cmpi.w  #$1e, d4             ; d4 == 30: wrap counter back to 0
    bne.b   .l151f2
    clr.w   d4                   ; reset sub-phase counter (30-frame animation cycle)
.l151f2:
    ; --- Phase: Redraw Character Detail and Portrait (when d6=1) ---
    ; d6 is set to 1 on first entry and whenever the selection changes.
    ; Skip this block if d6==0 (no selection change since last draw).
    cmpi.w  #$1, d6
    bne.b   .l1525a
    ; ShowCharDetail(slot_type, char_index, 0, col=2, row=$13, mode=1, extra=3):
    ; Draws the selected character's stat panel (name, attributes, etc.)
    pea     ($0003).w
    pea     ($0001).w
    pea     ($0013).w            ; row = $13 (panel row position)
    pea     ($0002).w            ; col = 2
    clr.l   -(a7)               ; extra param = 0
    move.w  d3, d0               ; d0 = cursor position in compat list
    ext.l   d0
    add.l   d0, d0               ; d0 *= 2 (word offset)
    movea.l d0, a0
    move.w  (a4,a0.l), d0        ; d0 = compat_tab[d3] = global char slot index
    ext.l   d0
    move.l  d0, -(a7)            ; arg: global char index (which character to show detail for)
    move.w  d5, d0               ; d0 = slot type
    ext.l   d0
    move.l  d0, -(a7)            ; arg: slot type
    jsr ShowCharDetail           ; render character stat panel for selected char
    lea     $1c(a7), a7          ; pop 7 args
    ; ShowCharPortrait(char_index, 0, col=2, row=9, mode=7, slot_type):
    ; Draws the character's portrait graphic in the portrait window.
    move.w  d5, d0               ; d0 = slot type
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w            ; mode = 7 (portrait display mode)
    clr.l   -(a7)
    pea     ($0009).w            ; row = 9
    pea     ($0002).w            ; col = 2
    move.w  d3, d0               ; d0 = cursor position
    ext.l   d0
    add.l   d0, d0               ; d0 *= 2
    movea.l d0, a0
    move.w  (a4,a0.l), d0        ; d0 = global char index
    ext.l   d0
    move.l  d0, -(a7)            ; arg: global char index (which portrait to display)
    jsr ShowCharPortrait         ; render portrait for the selected character
    lea     $18(a7), a7          ; pop 6 args
    clr.w   d6                   ; d6 = 0: portrait is now up to date; suppress redraw next pass
.l1525a:
    ; --- Phase: Held-Button Fast-Scroll Check ---
    ; If d2=1 (button was held on entry), read input again.
    ; If still held: redisplay with GameCommand #$0E and loop (fast scroll).
    ; If released: fall through to normal ProcessInputLoop polling.
    tst.w   d2
    beq.b   .l1527c              ; d2=0: normal path
    clr.l   -(a7)
    jsr ReadInput                ; re-read joypad
    addq.l  #$4, a7
    tst.w   d0                   ; still held?
    beq.b   .l1527c              ; released: go to normal input processing
.l1526c:
    ; Button still held: display-sync wait and loop back to redraw
    pea     ($0003).w
    pea     ($000E).w            ; GameCommand #$0E = display sync / V-blank wait
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l15162              ; loop back to top of display cycle
.l1527c:
    ; --- Phase: Input Dispatch ---
    ; Call ProcessInputLoop with a 10-frame countdown.
    ; Returns button bits; dispatch on $20=A, $10=B, $4=up, $8=down.
    clr.w   d2                   ; clear held-input flag
    move.w  -$22(a6), d0        ; d0 = previous button state (for repeat detection)
    move.l  d0, -(a7)
    pea     ($000A).w            ; countdown = $0A = 10 frames (auto-repeat delay)
    jsr ProcessInputLoop         ; poll input with countdown; d0 = new button bits
    addq.l  #$8, a7
    andi.w  #$bc, d0             ; mask: keep only meaningful buttons ($BC = %10111100)
    move.w  d0, -$22(a6)        ; save current button state for next iteration
    ext.l   d0
    ; Dispatch on button pressed:
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l152bc              ; $20 = A button: confirm selection
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l153f2              ; $10 = B button: cancel / back
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15432              ; $4 = D-pad up: previous character
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15448              ; $8 = D-pad down: next character
    bra.w   .l1545e              ; no recognized button: no-op path
    ; --- Phase: A Button -- Confirm Selection ---
.l152bc:
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0 (exit countdown mode)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0 (reset ProcessInputLoop state)
    cmp.w   d7, d3               ; d7 = original selection, d3 = new cursor position
    beq.w   .l1547a              ; selection unchanged: skip update, go to exit
    ; Selection changed: get the new char's stat byte from event_records[$FFB9E9]
    move.w  d5, d0               ; d0 = slot type
    lsl.w   #$5, d0              ; d0 = slot_type * $20
    move.w  d3, d1               ; d1 = new cursor position in compat list
    ext.l   d1
    add.l   d1, d1               ; d1 *= 2 (word offset)
    movea.l d1, a0
    move.w  (a4,a0.l), d1        ; d1 = compat_tab[d3] = global char index
    add.w   d1, d1               ; d1 *= 2 (byte entry stride in event_records = 2)
    add.w   d1, d0               ; d0 = byte offset into $FFB9E9
    movea.l  #$00FFB9E9,a0       ; a0 = $FFB9E9 (event_records stat byte)
    move.b  (a0,d0.w), d0        ; d0 = stat byte for newly selected char
    andi.l  #$ff, d0             ; zero-extend
    tst.w   d0                   ; is stat byte zero?
    ble.w   .l153ee              ; zero or negative: slot ineligible; clear redraw flag
    ; Stat byte is positive: update the record with the new selection
    ; SetTextWindow(0, 0, $20, $20): expand text window to full screen for update
    pea     ($0020).w            ; right = $20
    pea     ($0020).w            ; bottom = $20
    clr.l   -(a7)               ; top = 0
    clr.l   -(a7)               ; left = 0
    jsr SetTextWindow            ; set text rendering window bounds
    ; SetHighNibble(a2, char_index): write selected char's index into upper nibble of record
    move.w  d3, d0               ; d0 = new cursor position
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0        ; d0 = global char index
    ext.l   d0
    move.l  d0, -(a7)            ; arg: new char index
    move.l  a2, -(a7)            ; arg: record pointer
    jsr SetHighNibble            ; write new selection index into high nibble of record
    ; Re-read the stat byte for the new selection (confirming it after write)
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d2        ; d2 = stat byte for newly selected char (post-update)
    andi.l  #$ff, d2
    ; GetLowNibble: retrieve original low nibble (saved at entry = -$28(a6))
    move.l  a2, -(a7)
    jsr GetLowNibble             ; d0 = current low nibble of record
    lea     $1c(a7), a7          ; pop SetHighNibble args + GetLowNibble arg
    ; If stat byte d2 < low nibble d0: clamp to low nibble value
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0               ; compare low nibble vs stat byte
    bge.b   .l15366              ; low nibble >= stat: use stat byte directly
    ; Low nibble < stat byte: constrain to low nibble (d0 from GetLowNibble)
    move.l  a2, -(a7)
    jsr GetLowNibble             ; re-read (may have changed after SetHighNibble)
    addq.l  #$4, a7
    bra.b   .l1536a
.l15366:
    move.w  d2, d0               ; d0 = stat byte (d2)
    ext.l   d0
.l1536a:
    ; UpdateCharField(a2, new_value): commit the final selection value into the record
    move.w  d0, d2               ; d2 = final selected value
    ext.l   d0
    move.l  d0, -(a7)            ; arg: new value
    move.l  a2, -(a7)            ; arg: record pointer
    jsr UpdateCharField          ; write new selection to character stat record
    ; Display the new stat value as text: SetTextCursor(row=$0E, col=$10) then PrintfNarrow
    pea     ($0010).w            ; row = $10
    pea     ($000E).w            ; col = $0E
    jsr SetTextCursor            ; position text cursor for stat display
    move.w  d2, d0               ; d0 = new stat value to print
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F838).l        ; format string pointer at $3F838 (numeric format?)
    jsr PrintfNarrow             ; print stat value in narrow font
    ; ShowRelationAction: display relation/action panel for the updated selection
    clr.l   -(a7)
    pea     ($0002).w            ; col = 2
    pea     ($0009).w            ; row = 9
    pea     ($0010).w            ; mode = $10
    move.l  a2, -(a7)            ; record pointer
    jsr ShowRelationAction       ; show relation action panel for this character
    lea     $2c(a7), a7
    ; ShowRelationResult: display relation result below the action panel
    clr.l   -(a7)
    pea     ($0002).w            ; col = 2
    pea     ($000D).w            ; row = $0D
    pea     ($0010).w            ; mode = $10
    move.l  a2, -(a7)
    jsr ShowRelationResult       ; show relation outcome display
    ; GameCommand #$1A: clear a 8×9 tile area at col=2, row=9 with priority $8000
    pea     ($064C).w            ; param $064C
    pea     ($0008).w            ; height = 8
    pea     ($000E).w            ; col = $0E
    pea     ($0009).w            ; row = 9
    pea     ($0002).w            ; param
    pea     ($0001).w            ; param
    pea     ($001A).w            ; GameCommand #$1A = clear tile area
    jsr     (a5)
    lea     $30(a7), a7
    bra.w   .l1547a              ; go to exit sequence
.l153ee:
    clr.w   d6                   ; d6 = 0: suppress portrait redraw (ineligible selection)
    bra.b   .l1546a              ; loop back to input dispatch
    ; --- Phase: B Button -- Cancel / Restore Original Portrait ---
.l153f2:
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0 (exit countdown mode)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
    cmp.w   d7, d3               ; has the cursor moved from original position?
    beq.b   .l1547a              ; cursor at original position: nothing to restore, exit
    ; Restore the portrait of the ORIGINAL selection (d7) since user pressed B to cancel
    move.w  d5, d0               ; d0 = slot type
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w            ; mode = 7 (portrait mode)
    clr.l   -(a7)
    pea     ($0009).w            ; row = 9
    pea     ($0002).w            ; col = 2
    move.w  d7, d0               ; d0 = ORIGINAL selection (d7, not d3)
    ext.l   d0
    add.l   d0, d0               ; d0 *= 2
    movea.l d0, a0
    move.w  (a4,a0.l), d0        ; d0 = global char index of original selection
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait         ; redisplay original character's portrait (cancel preview)
    lea     $18(a7), a7
    bra.b   .l1547a              ; go to exit

    ; --- Phase: D-Pad Up -- Previous Character ---
.l15432:
    move.w  #$1, ($00FF13FC).l   ; input_mode_flag = 1 (activate countdown auto-repeat)
    moveq   #$1,d6               ; d6 = 1: force portrait + detail redraw
    subq.w  #$1, d3              ; cursor--
    tst.w   d3                   ; wrapped below 0?
    bge.b   .l1546a              ; no: keep new position
    move.w  -$24(a6), d3         ; wrap to last entry (local[-$24] = max index)
    bra.b   .l1546a

    ; --- Phase: D-Pad Down -- Next Character ---
.l15448:
    move.w  #$1, ($00FF13FC).l   ; input_mode_flag = 1 (activate auto-repeat)
    moveq   #$1,d6               ; d6 = 1: force portrait + detail redraw
    addq.w  #$1, d3              ; cursor++
    cmp.w   -$24(a6), d3         ; past last entry?
    ble.b   .l1546a              ; no: keep new position
    clr.w   d3                   ; wrap to first entry (index 0)
    bra.b   .l1546a

    ; --- Phase: No Recognized Button ---
.l1545e:
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0 (no countdown needed)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
.l1546a:
    ; If single-entry mode (only 1 compatible char), suppress redraw and loop fast
    cmpi.w  #$1, -$26(a6)        ; local[-$26] = single-entry flag (1 = only 1 compat char)
    bne.w   .l1526c              ; multiple chars: go to fast-scroll check
    clr.w   d6                   ; single entry: suppress redraw (nothing to scroll)
    bra.w   .l1526c              ; loop back
    ; --- Phase: Exit / Cleanup ---
    ; Restore arrow tiles and selection marker, reload map tiles, return.
.l1547a:
    ; GameCmd16($39, $02): remove navigation arrows / clear cursor sprite
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16                ; clear up/down arrow tiles via sprite command
    ; GameCommand #$1A: clear upper portion of the detail panel (row $13, col=1, w=$20, h=$0D)
    move.l  #$8000, -(a7)
    pea     ($000D).w            ; height = $0D rows
    pea     ($0020).w            ; width = $20 tiles
    pea     ($0013).w            ; row = $13 (stat panel area)
    clr.l   -(a7)
    pea     ($0001).w            ; col = 1
    pea     ($001A).w            ; GameCommand #$1A = clear tile area
    jsr     (a5)
    lea     $24(a7), a7
    ; GameCommand #$1A: clear lower portion (same area but col=0)
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)                ; col = 0
    pea     ($001A).w
    jsr     (a5)
    ; Restore the original selection marker in $FFB9E9:
    ; ADD back the stat byte that was subtracted at entry (undo the selection marking)
    move.w  d5, d0               ; d0 = slot type
    lsl.w   #$5, d0              ; d0 = slot_type * $20
    move.w  d7, d1               ; d1 = original selected char's compat index (d7)
    ext.l   d1
    add.l   d1, d1               ; d1 *= 2
    movea.l d1, a0
    move.w  (a4,a0.l), d1        ; d1 = compat_tab[d7] = original char's global index
    add.w   d1, d1               ; d1 *= 2 (2-byte stride in event_records)
    add.w   d1, d0               ; d0 = byte offset in $FFB9E9
    move.b  -$27(a6), d1         ; d1 = saved stat byte from entry
    movea.l  #$00FFB9E9,a0
    add.b   d1, (a0,d0.w)        ; restore event_records stat byte (undo selection marker)
    ; LoadMapTiles: reload the background map tile graphics (restores display state)
    jsr LoadMapTiles             ; reload/refresh map background tiles after UI overlay
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts
