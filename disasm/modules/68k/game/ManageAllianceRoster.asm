; ============================================================================
; ManageAllianceRoster -- Interactive alliance roster screen: shows char pairs, handles D-pad navigation, confirm, and cancel input
; 1558 bytes | $030D04-$031319
; ============================================================================
ManageAllianceRoster:
; --- Phase: Frame setup -- link frame, locate player record, validate alliance ---
; Frame: link a6,#-$320 allocates $320 bytes of locals.
; Key locals:
;   -$17a(a6)  = category_count_tab (7 words, one per alliance category 0-6)
;   -$31e(a6)  = slot_index_tab (2D word table: [category * $3C + count*2] = slot index)
;   -$16c(a6)  = exit_flag (1 = user pressed cancel / exit requested)
;   -$320(a6)  = input_ready_flag (1 = hardware input available for this frame)
;   -$2(a6)    = last_input_raw (latched raw input word before masking)
; Register usage throughout:
;   d7 = player_index (argument)
;   d2 = active category index (0-6; cycles through categories with data)
;   d5 = selected slot within category (cursor position)
;   d3 = slot_index_tab entry (absolute route slot index for current selection)
;   a2 = current route slot pointer
;   a3 = GameCommand ($0D64)
;   a4 = category_count_tab base (-$17a from a6)
;   a5 = $FF13FC (input_mode_flag)
    link    a6,#-$320
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7                 ; d7 = player_index argument
    movea.l  #$00000D64,a3            ; a3 = GameCommand dispatcher ($0D64)
    lea     -$17a(a6), a4              ; a4 = category_count_tab (7 word slots, one per category)
    movea.l  #$00FF13FC,a5            ; a5 = input_mode_flag ($FF13FC)
    clr.w   -$16c(a6)                 ; exit_flag = 0

; --- Phase: Zero category count table ---
; category_count_tab stores how many route slots belong to each of the 7 alliance categories.
; Cleared here before the slot classification scan below.
    pea     ($000E).w                  ; size = $0E bytes = 7 words (one per category 0-6)
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte                    ; MemFillByte(a4, 0, $0E) -- zero all 7 category counts

; --- Phase: Validate alliance -- check if player already has a valid alliance slot ---
    move.w  d7, d0
    mulu.w  #$24, d0                   ; player_index * $24 (36 bytes per player record)
    movea.l  #$00FF0018,a0            ; player_records base ($FF0018)
    lea     (a0,d0.w), a0
    movea.l a0, a2                     ; a2 = this player's record
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w IsAllianceSlotValid          ; IsAllianceSlotValid(player_index) -> d0
    lea     $10(a7), a7                ; clean up stack (4 args * 4 bytes)
    cmpi.w  #$1, d0
    beq.w   .l31310                    ; d0 == 1: already valid -- skip straight to exit

; --- Phase: Count player's active routes -- needed for slot classification loop ---
    moveq   #$0,d2
    move.b  $4(a2), d2                 ; player_record.domestic_slots (+$04)
    moveq   #$0,d0
    move.b  $5(a2), d0                 ; player_record.intl_slots (+$05)
    add.w   d0, d2                     ; d2 = total slot count (domestic + intl)
    move.w  d7, d0
    mulu.w  #$320, d0                  ; player route base offset = player_index * $320
                                       ; ($320 = 40 slots * $14 bytes = 800 bytes per player)
    movea.l  #$00FF9A20,a0            ; route_slots base ($FF9A20)
    lea     (a0,d0.w), a0
    movea.l a0, a2                     ; a2 = start of this player's route slot array
    clr.w   d5                         ; d5 = slot loop counter
    bra.w   .l30dfe                    ; branch to loop condition first

; ============================================================================
; --- Phase: Slot classification scan -- assign each route to an alliance category ---
; For each route slot, call RangeLookup on city_a and city_b to get their
; alliance categories (0-6). Record the slot index in slot_index_tab and
; increment the category count in category_count_tab.
;
; slot_index_tab layout (starting at -$31e(a6)):
;   index = category * $3C + count_in_category * 2
;   This gives a 2D table: [category][count] = slot_index
;   $3C = 60 = max 30 slots per category (30 * 2 bytes)
;
; category_count_tab layout (at a4 = -$17a(a6)):
;   category_count_tab[category] = number of slots classified into that category
;   Accessed as: (a4, d_category*2) -- stride-2 word entries
; ============================================================================
.l30d7e:
; Process city_a (source city of current route slot)
    moveq   #$0,d0
    move.b  (a2), d0                   ; route_slot.city_a (+$00) -- source city index
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                    ; RangeLookup(city_a) -> d0 = alliance category 0-6
    move.w  d0, d3                     ; d3 = category for city_a
    mulu.w  #$3c, d0                   ; d0 = category * $3C (row offset in slot_index_tab)
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1                     ; d1 = category * 2 (word offset into count table)
    movea.l d1, a0
    move.w  (a4,a0.l), d1             ; d1 = current count for this category
    add.w   d1, d1                     ; d1 *= 2 (word stride within the row)
    add.w   d1, d0                     ; d0 = category*$3C + count*2 (final table index)
    lea     -$31e(a6), a0              ; slot_index_tab base
    move.w  d5, (a0,d0.w)             ; slot_index_tab[category][count] = d5 (current slot#)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0                     ; d0 = category * 2 (word offset)
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)            ; category_count_tab[category]++

; Process city_b (destination city) -- only if different category from city_a
    moveq   #$0,d0
    move.b  $1(a2), d0                 ; route_slot.city_b (+$01) -- dest city index
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                    ; RangeLookup(city_b) -> d0 = alliance category 0-6
    addq.l  #$8, a7                    ; clean 2 pushed args (city_a + city_b each 4 bytes)
    move.w  d0, d4                     ; d4 = category for city_b
    cmp.w   d4, d3                     ; city_a category == city_b category?
    beq.b   .l30df8                    ; same category -- don't double-count this slot

; city_b in a different category: also record slot there
    move.w  d4, d0
    mulu.w  #$3c, d0                   ; row offset for city_b's category
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  d5, (a0,d0.w)             ; slot_index_tab[city_b_cat][count] = d5
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)            ; category_count_tab[city_b_cat]++
.l30df8:
    moveq   #$14,d0
    adda.l  d0, a2                     ; advance a2 to next route slot ($14 = 20 bytes)
    addq.w  #$1, d5                    ; slot counter++
.l30dfe:
    cmp.w   d2, d5                     ; all slots scanned?
    blt.w   .l30d7e                    ; no -- continue

; ============================================================================
; --- Phase: Initial screen render -- draw alliance overview header ---
; ============================================================================
; GameCommand $1A: set up display mode/screen
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($000B).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                       ; GameCommand(26, 0, $A, 6, $B, $B, 0)

; sprintf: format alliance header string into local buffer -$16a(a6)
    move.l  ($00047B58).l, -(a7)      ; ptr to alliance header format string at $47B58
    pea     -$16a(a6)                  ; dest buffer (local frame)
    jsr sprintf
    lea     $24(a7), a7

; ShowTextDialog: display the header text in dialog box
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    pea     -$16a(a6)                  ; formatted header string
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)                  ; player_index
    jsr ShowTextDialog
    lea     $18(a7), a7

; GameCommand $1A: set up category panel area
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                       ; GameCommand(26, 0, 2, $13, $17, 6, 0)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                       ; GameCommand($E, 1) -- display flush

; LZ_Decompress: load alliance roster graphics from ROM at $4A63A into save buf
    pea     ($0004A63A).l              ; ptr to LZ-compressed graphic data in ROM
    pea     ($00FF1804).l              ; dest: save_buf_base ($FF1804)
    jsr LZ_Decompress
    lea     $2c(a7), a7

; VRAMBulkLoad: DMA the decompressed graphics to VRAM
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l              ; source: decompressed data
    pea     ($0025).w                  ; VRAM tile count ($25 = 37 tiles)
    pea     ($0330).w                  ; VRAM destination tile offset
    jsr VRAMBulkLoad
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                       ; GameCommand($E, 1) -- display flush
    lea     $1c(a7), a7

; GameCommand $1B: draw category icon panel (background sprites for category tabs)
    pea     ($0004A5DA).l              ; ptr to icon tilemap data at $4A5DA
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0015).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)                       ; GameCommand(27, 0, $15, 0, 8, 6, ptr)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                       ; GameCommand($E, 1)

; ============================================================================
; --- Phase: Find first non-empty category -- start cursor there ---
; screen_id ($FF9A1C) holds the last-used category. Find the first category
; with count > 0, cycling through 0-6 modulo 7 from the saved position.
; ============================================================================
    move.w  ($00FF9A1C).l, d2          ; d2 = screen_id (last used category index)
.l30ede:
    cmpi.w  #$7, d2                    ; category >= 7?
    blt.b   .l30ee6
    clr.w   d2                         ; wrap around: category = 0
.l30ee6:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0                     ; d0 = d2 * 2 (word offset for count table)
    movea.l d0, a0
    tst.w   (a4,a0.l)                  ; category_count_tab[d2] > 0?
    bgt.b   .l30ef8                    ; yes -- this is the starting category
    addq.w  #$1, d2                    ; try next category
    bra.b   .l30ede
.l30ef8:
    clr.w   d5                         ; d5 = selected slot within category (start at 0)
    moveq   #-$1,d3                    ; d3 = slot_index_tab entry (-1 = not yet loaded)

; Read initial hardware input state
    clr.l   -(a7)
    jsr ReadInput                      ; ReadInput(0) -> d0 = raw input word
    lea     $28(a7), a7                ; clean stack (10 args * 4 bytes -- ReadInput is variadic)
    tst.w   d0
    beq.b   .l30f10
    moveq   #$1,d0                     ; d0 = 1 if any input pending
    bra.b   .l30f12
.l30f10:
    moveq   #$0,d0                     ; d0 = 0 if no input
.l30f12:
    move.w  d0, -$320(a6)             ; input_ready_flag = d0
    clr.w   -$2(a6)                    ; last_input_raw = 0
    clr.w   (a5)                       ; input_mode_flag ($FF13FC) = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag ($FFA7D8) = 0
    moveq   #$1,d6                     ; d6 = redraw_flag (1 = need full panel redraw)

; ============================================================================
; --- Phase: Main input loop -- draw panel and dispatch button presses ---
; ============================================================================
.l30f24:
    tst.w   d6                         ; redraw_flag set?
    beq.w   .l310ba                    ; no -- skip to input poll

; --- Subphase: Redraw selected category panel ---
; Clear the display area
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow                  ; SetTextWindow(0, 0, $20, $20) -- full clear

; ClearAllianceSlot: blank the old slot display before redrawing
    pea     (-$1).w                    ; flag: clear (not select)
    move.w  d2, d0
    move.l  d0, -(a7)                  ; current category index
    bsr.w ClearAllianceSlot
    lea     $18(a7), a7

; GameCommand $1A: set category name area bounds
    pea     ($077E).w                  ; attribute: wide font ($077E)
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                       ; GameCommand(26, 0, 2, $13, $10, 2, $77E)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)

; SetTextCursor: position cursor at column $13, row 2 for category name
    pea     ($0013).w
    pea     ($0002).w
    jsr SetTextCursor
    lea     $2c(a7), a7

; PrintfWide: print the category name (looked up from $05ECA0 by category index)
    move.w  d2, d0
    lsl.w   #$2, d0                    ; category * 4 (longword ptr table)
    movea.l  #$0005ECA0,a0            ; alliance category name pointer table ($05ECA0)
    move.l  (a0,d0.w), -(a7)         ; ptr to category name string
    pea     ($000447CA).l             ; wide printf format string at $47CA
    jsr PrintfWide

; ============================================================================
; Compute current route slot pointer from 2D table.
; Formula: a2 = route_slots + player*$320 + slot_index_tab[d2][d5] * $14
;   player offset: d7 * $320
;   table lookup: slot_index_tab[d2][d5] where index = d2*$3C + d5*2
;   slot byte offset: table_entry * $14 (20 bytes per slot)
; ============================================================================
    move.w  d7, d0
    mulu.w  #$320, d0                  ; player route base offset
    move.w  d2, d1
    mulu.w  #$3c, d1                   ; d1 = category * $3C (row offset in slot_index_tab)
    movea.l d7, a0                     ; save d7 temporarily in a0
    move.w  d5, d7                     ; d7 = selected slot within category
    add.w   d7, d7                     ; d7 *= 2 (word stride)
    exg     d7, a0                     ; restore d7 = player_index; a0 = d5*2
    add.w   a0, d1                     ; d1 = category*$3C + d5*2
    lea     -$31e(a6), a0              ; slot_index_tab base
    move.w  (a0,d1.w), d1             ; d1 = absolute slot index from table
    mulu.w  #$14, d1                   ; d1 = slot byte offset (slot_index * $14)
    add.w   d1, d0                     ; d0 = player_offset + slot_offset
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                     ; a2 = current route slot

; Load city_a and city_b from the current slot
    moveq   #$0,d3
    move.b  (a2), d3                   ; d3 = route_slot.city_a (source city index)
    moveq   #$0,d4
    move.b  $1(a2), d4                 ; d4 = route_slot.city_b (dest city index)

; Determine canonical display order: city_a should be in category d2.
; If city_a is not in category d2, swap city_a and city_b for display.
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                    ; RangeLookup(city_a) -> category
    cmp.w   d2, d0                     ; city_a's category == currently selected category?
    beq.b   .l30ff2                    ; yes -- display as-is
    moveq   #$0,d4
    move.b  (a2), d4                   ; swap: d4 = city_a (old)
    moveq   #$0,d3
    move.b  $1(a2), d3                 ; d3 = city_b (destination becomes primary)
.l30ff2:

; --- Draw slot info panel: city pair and type icons ---
; GameCommand $1A: set slot detail area
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0015).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7

; SetTextCursor: position at column $15, row 2 for city name
    pea     ($0015).w
    pea     ($0002).w
    jsr SetTextCursor

; PrintfWide: print city_a name (or swapped primary city)
    move.w  d3, d0
    lsl.w   #$2, d0                    ; city_index * 4
    movea.l  #$0005E680,a0            ; CityNamePtrs ($05E680)
    move.l  (a0,d0.w), -(a7)         ; ptr to city name string
    pea     ($000447C6).l             ; wide printf format string at $447C6
    jsr PrintfWide

; PlaceIconTiles: draw the airline type icon for city_a
    pea     ($0015).w
    move.w  ($00FF128A).l, d0          ; font cursor column after city name
    move.l  d0, -(a7)
    pea     ($0002).w                  ; row 2
    pea     ($0004).w                  ; icon tile set 4 (airline type icons)
    jsr PlaceIconTiles

; SetTextCursor: advance cursor past the icon for city_b name
    pea     ($0015).w
    moveq   #$0,d0
    move.w  ($00FF128A).l, d0
    addq.l  #$2, d0                    ; skip 2 columns for icon width
    move.l  d0, -(a7)
    jsr SetTextCursor

; PrintfWide: print city_b type name (airline company name)
    move.w  d4, d0
    lsl.w   #$2, d0                    ; city_b_index * 4
    movea.l  #$0005E7E4,a0            ; CharTypePtrs ($05E7E4): airline company name ptrs
    move.l  (a0,d0.w), -(a7)
    pea     ($000447C2).l             ; wide printf format string at $447C2
    jsr PrintfWide
    lea     $30(a7), a7

; Reset text window to full screen
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7

; Look up the absolute slot index for cursor position (used after panel draw)
    move.w  d2, d0
    mulu.w  #$3c, d0                   ; category * $3C
    move.w  d5, d1
    add.w   d1, d1                     ; d5 * 2
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  (a0,d0.w), d3             ; d3 = current absolute slot index (for confirm)

; ============================================================================
; --- Phase: Input dispatch -- poll controller and handle button presses ---
; ============================================================================
.l310ba:
    tst.w   -$320(a6)                  ; input_ready_flag?
    beq.b   .l310e0                    ; not ready -- skip ReadInput raw check

; Hardware input ready: read raw state and clear display lock
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l310e0
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)                       ; GameCommand($E, 3) -- display sync
    addq.l  #$8, a7
    clr.w   d6                         ; redraw_flag = 0 (suppress extra redraw)
    bra.w   .l30f24                    ; re-enter main loop

.l310e0:
    clr.w   -$320(a6)                  ; input_ready_flag = 0
    clr.w   d6                         ; redraw_flag = 0
    move.w  -$2(a6), d0               ; last_input_raw
    move.l  d0, -(a7)
    pea     ($000A).w                  ; input timeout = $A (10 frames)
    jsr ProcessInputLoop               ; ProcessInputLoop(last_raw, $A) -> d0 = button bits
    addq.l  #$8, a7

; Decode d0: mask to D-pad + buttons, store for next frame
    andi.w  #$3f, d0                   ; keep bits 0-5 (D-pad + A/B/C)
    move.w  d0, -$2(a6)               ; update last_input_raw
    ext.l   d0

; --- Button decode: dispatch on individual bit flags ---
; Bit $20 = A button (confirm/select)
; Bit $10 = B button (cancel)
; Bit $01 = Up
; Bit $02 = Down
; Bit $04 = Right (next category)
; Bit $08 = Left (prev category)
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l31134                    ; A button: confirm slot selection
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l311e2                    ; B button: cancel / exit
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   .l311f4                    ; Up: previous slot in category
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   .l31214                    ; Down: next slot in category
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l31230                    ; Right: next category
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l31256                    ; Left: prev category
    bra.w   .l31276                    ; No recognized button: no-op

; ============================================================================
; --- Button handler: A (confirm) -- commit the selected slot ---
; ============================================================================
.l31134:
    clr.w   (a5)                       ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag = 0

; Score and commit the selected alliance
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w GetAllianceScore             ; GetAllianceScore(player_index, slot_index) -- score current alliance
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (RunAIMainLoop,PC)             ; RunAIMainLoop(player_index, slot_index) -- run AI step for alliance
    nop

; After AI step: re-check city categories to see if they still match.
; If city_b is now in a different category from city_a, clear the alliance slot.
    moveq   #$0,d0
    move.b  $1(a2), d0                 ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                    ; RangeLookup(city_b) -> category
    lea     $14(a7), a7
    move.l  d0, -(a7)                  ; save city_b category
    moveq   #$0,d0
    move.b  (a2), d0                   ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                    ; RangeLookup(city_a) -> category
    addq.l  #$4, a7
    move.l  (a7)+, d1                  ; d1 = city_b category
    cmp.w   d1, d0                     ; city_a category still matches city_b?
    beq.b   .l31190                    ; yes -- no need to clear slot

; Cities now in different categories: invalidate the slot
    pea     (-$1).w
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w ClearAllianceSlot            ; ClearAllianceSlot(-1, category) -- unlink this slot
    addq.l  #$8, a7

.l31190:
; Show updated alliance dialog after committing
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B58).l, -(a7)      ; ptr to alliance result format string at $47B58
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog                 ; ShowTextDialog(player, ptr, 4, 0, 0, 1)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a3)                       ; GameCommand($E, $A)
    lea     $20(a7), a7

; Redraw category panel with updated state
    move.l  #$8000, -(a7)             ; attribute: use high-priority rendering
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    bra.w   .l3127e                    ; go to exit-flag check

; ============================================================================
; --- Button handler: B (cancel) -- set exit_flag and return ---
; ============================================================================
.l311e2:
    clr.w   (a5)                       ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag = 0
    move.w  #$1, -$16c(a6)            ; exit_flag = 1 (request exit after this loop tick)
    bra.w   .l3127e

; ============================================================================
; --- Button handler: Up -- move cursor to previous slot within category ---
; ============================================================================
.l311f4:
    move.w  #$1, (a5)                  ; input_mode_flag = 1 (input was consumed)
    moveq   #$1,d6                     ; redraw_flag = 1
    subq.w  #$1, d5                    ; d5-- (previous slot)
    tst.w   d5
    bge.w   .l3127e                    ; still >= 0: valid slot
    ; Wrap around: d5 = count_in_category - 1
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0                     ; category * 2
    movea.l d0, a0
    move.w  (a4,a0.l), d5             ; d5 = category_count_tab[d2]
    addi.w  #$ffff, d5                 ; d5 -= 1 (wrap to last slot in category)
    bra.b   .l3127e

; ============================================================================
; --- Button handler: Down -- move cursor to next slot within category ---
; ============================================================================
.l31214:
    move.w  #$1, (a5)
    moveq   #$1,d6
    addq.w  #$1, d5                    ; d5++ (next slot)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0             ; d0 = category_count_tab[d2]
    cmp.w   d5, d0                     ; d5 < count? (still within range)
    bgt.b   .l3127e
.l3122c:
    clr.w   d5                         ; wrap: d5 = 0 (first slot in category)
    bra.b   .l3127e

; ============================================================================
; --- Button handler: Right -- advance to next non-empty category ---
; ============================================================================
.l31230:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4                     ; save current category for wrap detection
.l31238:
    addq.w  #$1, d2                    ; d2++ (try next category)
    cmpi.w  #$7, d2                    ; past last category?
    blt.b   .l31242
    clr.w   d2                         ; wrap: category = 0
.l31242:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)                  ; category_count_tab[d2] > 0?
    ble.b   .l31238                    ; skip empty categories
.l31250:
    cmp.w   d2, d4                     ; wrapped all the way back to start?
    beq.b   .l3127e                    ; yes -- no non-empty category found; stay put
    bra.b   .l3122c                    ; reset slot cursor d5 = 0

; ============================================================================
; --- Button handler: Left -- go to previous non-empty category ---
; ============================================================================
.l31256:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4                     ; save current category
.l3125e:
    subq.w  #$1, d2                    ; d2-- (try prev category)
    tst.w   d2
    bge.b   .l31266
    moveq   #$6,d2                     ; wrap: category = 6 (last)
.l31266:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)                  ; category_count_tab[d2] > 0?
    ble.b   .l3125e                    ; skip empty categories
    bra.b   .l31250                    ; check if we wrapped fully (no non-empty found)

; ============================================================================
; --- No recognized button: clear input flags ---
; ============================================================================
.l31276:
    clr.w   (a5)                       ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag = 0

; ============================================================================
; --- Loop tail: check exit_flag; if set, tear down and return ---
; ============================================================================
.l3127e:
    cmpi.w  #$1, -$16c(a6)            ; exit_flag set?
    bne.w   .l30f24                    ; no -- continue main input loop

; --- Phase: Teardown -- reload original graphics and show player chart ---
; LZ_Decompress: restore original tile data from $0A1B28 (full tileset)
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  ($000A1B28).l, -(a7)      ; ptr to original tileset LZ data at $0A1B28
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7

; CmdPlaceTile: restore background tile at panel origin
    pea     ($003E).w                  ; tile row $3E
    pea     ($0109).w                  ; tile column $109
    pea     ($00FF1804).l              ; tile data source
    jsr CmdPlaceTile

; GameCommand $1B: restore main map/world tileset
    pea     ($000725D8).l              ; ptr to world map tileset at $725D8
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0008).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7

; ShowPlayerChart: render the player's airline chart/summary screen
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowPlayerChart                ; ShowPlayerChart(player_index)

; ============================================================================
; --- Phase: Epilog -- restore registers and return ---
; ============================================================================
.l31310:
    movem.l -$348(a6), d2-d7/a2-a5
    unlk    a6
    rts
