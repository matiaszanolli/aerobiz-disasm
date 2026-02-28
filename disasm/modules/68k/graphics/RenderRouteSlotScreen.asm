; ============================================================================
; RenderRouteSlotScreen -- draws the full route slot screen with character portraits and revenue bar graphs for a player
; 780 bytes | $010D08-$011013
; ============================================================================
; Arguments: 8(a6) = player_index (d6), $C(a6) = display_mode (d7)
; d7 < 3 = show character portrait panel; d7 >= 3 = skip portrait (summary/comparison mode)
; A5 = $FF1804 (save_buf_base / LZ decompression output buffer)
; A4 = GameCommand entry ($0D64), used for direct jsr (a4) calls
; Local frame ($-$10): 7 words used as horizontal-offset scratch for up to 7 char classes
RenderRouteSlotScreen:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6          ; d6 = player_index (0-3): selects which player's route slots
    move.l  $c(a6), d7          ; d7 = display_mode (0-2 = portrait shown; 3+ = portrait hidden)
    movea.l  #$00000D64,a4      ; a4 = GameCommand jump target
    movea.l  #$00FF1804,a5      ; a5 = save_buf_base: scratch buffer for LZ decompression output
; --- Phase: Screen clear and background setup ---
; Zero the 7-word local horizontal-offset array at -$e(a6)
    pea     ($000E).w           ; count = 14 bytes = 7 words (one per char class 0-6)
    clr.l   -(a7)               ; fill value = 0
    pea     -$e(a6)             ; destination = local frame scratch
    jsr MemFillByte              ; clear the class-offset array
    jsr ResourceLoad             ; ensure required graphics resources are loaded
    clr.l   -(a7)
    jsr CmdSetBackground         ; fill both scroll planes with background tile
; GameCommand #$10 (sync wait) after #$40 (palette reset)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
; Load route-slot screen layout graphic ($4A5BA = ROM offset for slot background tiles)
; DisplaySetup parameters: resource_ptr=$4A5BA, tile_count=$30, vram_dest=$10
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0004A5BA).l
    jsr DisplaySetup             ; DMA the slot-panel background tileset to VRAM
    lea     $28(a7), a7
; GameCommand #$1B: place tile data block at (col=$03, row=$02, w=$08, h=$06, base=$4A5DA)
; This stamps the route slot panel border/header tiles onto the screen
    pea     ($0004A5DA).l       ; ROM tile data block address for route slot frame
    pea     ($0006).w           ; height = 6
    pea     ($0008).w           ; width  = 8
    pea     ($0002).w           ; top row = 2
    pea     ($0003).w           ; left col = 3
    clr.l   -(a7)
    pea     ($001B).w           ; GameCommand #$1B = place tile block
    jsr     (a4)
; --- Phase: Decompress and DMA route-slot tile graphics ---
; $4A63A = LZ-compressed route-slot portrait frame tiles in ROM
    pea     ($0004A63A).l
    move.l  a5, -(a7)           ; output to save_buf_base ($FF1804)
    jsr LZ_Decompress            ; decompress slot portrait frame graphics
    lea     $24(a7), a7
; DMA the decompressed tiles to VRAM at tile index $0330 (slot portrait area), count $25 tiles
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0025).w           ; tile count = 37 tiles
    pea     ($0330).w           ; VRAM tile destination index
    jsr VRAMBulkLoad             ; chunked DMA transfer to VRAM
    lea     $14(a7), a7
; --- Phase: Conditional portrait panel (only when d7 < 3) ---
; d7 >= 3 skips the character portrait entirely (used in summary/compare modes)
    cmpi.w  #$3, d7
    bge.b   l_10e10             ; skip portrait if display_mode >= 3
; Look up portrait data pointer for this display mode:
; $4797C = ROM table of 3 word-indices into $A1B14 longword pointer table
    move.w  d7, d0
    add.w   d0, d0              ; d0 = d7 * 2 (word index)
    movea.l  #$0004797C,a0      ; ROM word-index table for portrait resource offsets
    move.w  (a0,d0.w), d0       ; fetch word index for this mode
    andi.l  #$ffff, d0
    lsl.l   #$2, d0             ; d0 = index * 4 (longword table offset)
    movea.l  #$000A1B14,a0      ; ROM longword pointer table: LZ-compressed portrait tile sets
    move.l  (a0,d0.l), -(a7)   ; push compressed portrait data pointer
    move.l  a5, -(a7)           ; output to save_buf_base
    jsr LZ_Decompress            ; decompress character portrait tiles for this mode
; Place the portrait: tile $03CD = portrait frame in VRAM, at (col=$14, row=$14) in pixel units
    pea     ($0014).w           ; x pixel position
    pea     ($03CD).w           ; VRAM tile index of decompressed portrait
    move.l  a5, -(a7)
    jsr CmdPlaceTile             ; place decompressed portrait tile on screen
; GameCommand #$1B: stamp portrait overlay tile block from ROM $71F98
; (col=$01, row=$19, w=$03, h=$05, plane=$0004)
    pea     ($00071F98).l       ; ROM tile block for portrait overlay (char class icon frame)
    pea     ($0004).w           ; plane mask / palette
    pea     ($0005).w           ; height = 5
    pea     ($0003).w           ; width  = 3
    pea     ($0019).w           ; top row = $19 = 25
    pea     ($0001).w           ; left col = 1
    pea     ($001B).w           ; GameCommand #$1B = place tile block
    jsr     (a4)
    lea     $30(a7), a7
; --- Phase: Per-slot render loop (4 route slots) ---
; A2 steps through 4 × 8-byte slot-display entries in $FF0338:
; $FF0338 is indexed by player_index * $20 (32 bytes/player, 4 slots × 8 bytes/slot)
l_10e10:
    move.w  d6, d0
    lsl.w   #$5, d0             ; offset = player_index * 32
    movea.l  #$00FF0338,a0      ; base of route-display working table (4 players)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> first slot entry for this player
    clr.w   d3                  ; d3 = slot index (0-3)
; Loop body: compute screen position for each slot, then render either empty or occupied slot
l_10e22:
; Compute screen column (d5) for this slot:
; Slots alternate left/right columns:  col = (slot_index & 1) * 6 + 13
    move.w  d3, d5
    andi.w  #$1, d5             ; 0 for even slots, 1 for odd slots
    mulu.w  #$6, d5             ; 0 or 6
    addi.w  #$d, d5             ; d5 = column = 13 (left pair) or 19 (right pair)
; Compute screen row (d4) for this slot:
; Rows: slot 0,1 → row index 0; slots 2,3 → row index 1  (d4 = (slot>>1)*8 + 2)
    move.w  d3, d4
    ext.l   d4
    asr.l   #$1, d4             ; d4 = slot_index >> 1  (0 or 1)
    lsl.w   #$3, d4             ; d4 *= 8
    addq.w  #$2, d4             ; d4 = row = 2 or 10
; Push screen position args and call CalcCharDisplayIndex_Prelude
; to compute portrait-tile index and stash result for portrait placement
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude  ; computes char tile index for slot; may set up portrait DMA
    lea     $10(a7), a7
; Test slot occupancy: route_slot+$01 = city_b (destination city index)
; A value of 0 means the slot is empty (city_b cleared to 0 on slot reset)
    tst.b   $1(a2)              ; route_slot+$01 = city_b: 0 = empty slot
    bne.b   l_10ea6             ; nonzero = occupied slot, go render portrait
; --- Empty slot render ---
; Place the "empty slot" placeholder tile ($0544 = grey blank tile):
; Position: col = d4*8 + $28, row = d5*8 + $20, tile = $0544, palette 2, single cell
    clr.l   -(a7)
    pea     ($0002).w           ; palette index 2
    pea     ($0001).w           ; height = 1
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$28, d0            ; x pixel = col*8 + 40
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0            ; y pixel = row*8 + 32
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0            ; tile index = slot_index + $3B (empty-slot icon sequence)
    move.l  d0, -(a7)
    pea     ($0544).w           ; tile base index ($0544 = empty slot graphic tile)
    jsr TilePlacement            ; render the empty-slot placeholder tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)                 ; GameCommand #$E = display update / sync
    lea     $24(a7), a7
    bra.w   l_10fde             ; advance to next slot
; --- Occupied slot render ---
l_10ea6:
; Determine the character class (d2) to use for portrait lookup.
; Special case: if city_b == 6 AND frequency ($6(a2)) == 3, use city_a byte directly
; (city_a is route_slot+$00, city_b is +$01, frequency is route_slot+$03 in DATA_STRUCTURES)
; $6(a2) here is the 7th byte in the 8-byte display entry (local working data, not route slot)
    cmpi.b  #$6, $1(a2)         ; is city_b (destination) == 6?
    bne.b   l_10ebc             ; no -- use RangeLookup to classify city_a
    cmpi.w  #$3, $6(a2)         ; frequency == 3 (mid-grade)?
    beq.b   l_10ebc             ; yes -- also use RangeLookup path
; city_b==6 and frequency!=3: use city_a raw byte as char class index
    moveq   #$0,d2
    move.b  (a2), d2            ; d2 = city_a byte (raw class, 0-6 range)
    bra.b   l_10ecc
; RangeLookup path: classify city_a byte into a 0-7 range bucket
l_10ebc:
    moveq   #$0,d0
    move.b  (a2), d0            ; city_a byte
    move.l  d0, -(a7)
    jsr RangeLookup              ; maps city_a value to class index 0-7 via threshold table
    addq.l  #$4, a7
    move.w  d0, d2              ; d2 = character class index (0-6)
; --- Portrait tile placement for occupied slot ---
; A3 = pointer into ROM table $5F088: per-class 2-byte portrait descriptor
; Byte 0 = horizontal base offset, byte 1 = vertical base offset for portrait tile placement
l_10ecc:
    move.w  d2, d0
    add.w   d0, d0              ; d0 = class_index * 2 (stride in descriptor table)
    movea.l  #$0005F088,a0      ; ROM class descriptor table (2 bytes per class)
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> class portrait descriptor
; Place the character portrait tile:
; x = descriptor[1] + $10; y = class_offset_array[class] + descriptor[0] + $18
; The class_offset_array (-$e(a6)) accumulates horizontal position as multiple portraits stack
    clr.l   -(a7)
    pea     ($0002).w           ; palette index 2
    pea     ($0001).w           ; height = 1
    moveq   #$0,d0
    move.b  $1(a3), d0          ; portrait descriptor byte 1 = y base offset
    addi.l  #$10, d0            ; y pixel = descriptor[1] + $10
    move.l  d0, -(a7)
    move.w  d2, d0
    add.w   d0, d0              ; index into local class-offset array (word stride)
    move.w  -$e(a6, d0.w), d0  ; current accumulated horizontal offset for this class
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1            ; portrait descriptor byte 0 = x base offset
    add.l   d1, d0
    addi.l  #$18, d0            ; x pixel = class_offset + descriptor[0] + $18
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0            ; tile index = slot_index + $3B (occupied-slot icon sequence)
    move.l  d0, -(a7)
    pea     ($0544).w           ; tile base ($0544 = slot portrait tile)
    jsr TilePlacement            ; place the character portrait tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)                 ; GameCommand #$E = display update
; Advance the horizontal offset for this char class by 3 pixels (stacking portraits left-to-right)
    move.w  d2, d0
    add.w   d0, d0
    addq.w  #$3, -$e(a6, d0.w) ; class_offset_array[class] += 3
; --- Revenue bar graph for this slot ---
; CalcRouteRevenue: returns revenue score for (slot_index=d3, player_index=d6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteRevenue,PC)    ; compute route revenue rating (based on CalcCharRating + SignedDiv)
    nop
    lea     $2c(a7), a7
; Scale revenue: divide by 3 to get a bar height in [0, 5]
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv                ; d0 = revenue_score / 3
    move.w  d0, d2              ; d2 = bar height (pre-clamp)
; Clamp bar height to maximum of 5 tiles
    cmpi.w  #$5, d2
    bge.b   l_10f62             ; if >= 5, saturate at 5
    move.w  d2, d0
    ext.l   d0
    bra.b   l_10f64
l_10f62:
    moveq   #$5,d0              ; d0 = 5 (max bar height)
l_10f64:
    move.w  d0, d2              ; d2 = clamped bar height (0-5)
; --- Draw filled (earned) portion of revenue bar ---
; Tile $0774 = filled bar segment (revenue earned)
; FillTileRect params: tile, palette, width, height, x, y, priority
    pea     ($0774).w           ; filled-bar tile index
    pea     ($0001).w           ; palette 1
    pea     ($0020).w           ; width = $20 pixels (1 tile column)
    pea     ($0001).w           ; height = 1 row
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; count = bar height (0-5 tiles high)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0             ; x = col + 6 (right side of slot panel)
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; y = row (top of bar area)
    pea     ($0001).w           ; render priority = 1
    jsr FillTileRect             ; fill the earned-revenue bar tiles
    lea     $20(a7), a7
; --- Draw unfilled (remaining) portion of revenue bar ---
; Tile $0775 = empty bar segment (revenue not yet earned / capacity remaining)
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1              ; d1 = 5 - bar_height = remaining empty tiles
    ble.b   l_10fde             ; bar is full (or over), no empty segment needed
    pea     ($0775).w           ; empty-bar tile index
    pea     ($0002).w           ; palette 2 (different colour from filled)
    pea     ($0020).w           ; width = $20 pixels
    pea     ($0001).w           ; height = 1 row
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    move.l  d1, -(a7)           ; count = remaining empty height
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0             ; x = col + 6
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0              ; y = row + bar_height (start below the filled portion)
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr FillTileRect             ; fill the empty-capacity bar tiles
    lea     $20(a7), a7
; --- Advance to next slot ---
l_10fde:
    addq.l  #$8, a2             ; each slot entry is 8 bytes in $FF0338 working table
    addq.w  #$1, d3             ; slot_index++
    cmpi.w  #$4, d3             ; loop 4 slots (0-3)
    blt.w   l_10e22
; --- Phase: Post-slot portrait summary (display_mode < 3 only) ---
; When in portrait mode, render an extra combined summary display at the bottom
    cmpi.w  #$3, d7
    bge.b   l_11004             ; skip summary if display_mode >= 3
; CalcCharDisplayIndex_Prelude for summary row: col=$000A, row=$0019, slot=4 (special), player=d6
    pea     ($000A).w
    pea     ($0019).w
    pea     ($0004).w
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude  ; render portrait summary row at screen bottom
l_11004:
    jsr ResourceUnload           ; release all loaded graphics resources
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
