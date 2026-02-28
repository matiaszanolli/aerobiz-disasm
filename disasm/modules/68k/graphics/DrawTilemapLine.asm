; ============================================================================
; DrawTilemapLine -- Draws a Bresenham-style line in tile-map RAM: given two (col, row) endpoints and a tile palette word, uses integer error-accumulation to step along the longer axis, writing the tile attribute word into the VDP background-A tilemap buffer at each point.
; 498 bytes | $01DA34-$01DC25
;
; Stack frame (link a6,#-$10 creates 16 bytes of locals):
;   $8(a6)  = arg: x1 (start col, word)
;   $c(a6)  = arg: y1 (start row, word)
;   $10(a6) = arg: x2 (end col, word)
;   $14(a6) = arg: y2 (end row, word)
;   $18(a6) = arg: tile_attr word (palette/priority bits packed)
;   $1c(a6) = arg: tilemap buffer base address
;   -$2(a6) / a1 = local: dx (signed col span)
;   -$4(a6) / a4 = local: abs_dy (absolute row span)
;   -$6(a6)      = local: row_step (+1 or -1, minor-axis direction)
;   -$8(a6)      = local: palette_word[slot0] (tile_attr verbatim)
;   -$a(a6)      = local: palette_word[slot1] (tile_attr << 4)
;   -$c(a6)      = local: palette_word[slot2] (tile_attr << 8)
;   -$e(a6)      = local: palette_word[slot3] (tile_attr << 12)
;
; Register roles after prologue:
;   d2 = x2 / end col   d3 = y2 / end row  [may be swapped for ordering]
;   d5 = x1 / start col  d6 = y1 / start row
;   d7 = tile_attr word  a3 = tilemap buffer base
;   d4 = Bresenham error accumulator
; ============================================================================
DrawTilemapLine:
    link    a6,#-$10
    movem.l d2-d7/a2-a4, -(a7)
    ; --- Phase: Load arguments ---
    move.l  $10(a6), d2                             ; d2 = x2 (destination col)
    move.l  $14(a6), d3                             ; d3 = y2 (destination row)
    move.l  $8(a6), d5                              ; d5 = x1 (source col)
    move.l  $c(a6), d6                              ; d6 = y1 (source row)
    move.l  $18(a6), d7                             ; d7 = tile attribute word (palette/priority)
    movea.l $1c(a6), a3                             ; a3 = tilemap buffer base address
    lea     -$4(a6), a4                             ; a4 -> local abs_dy word
    lea     -$2(a6), a1                             ; a1 -> local dx word
    ; --- Phase: Pre-compute palette word for each of 4 sub-pixel slots ---
    ; The tilemap packs 4 tiles per longword (2-bit col sub-index selects the
    ; slot). Pre-shift tile_attr to each 4-bit position so the inner loop can
    ; read without shifting per pixel.
    move.w  d7, d0
    moveq   #$C,d1
    lsl.w   d1, d0
    move.w  d0, -$e(a6)                             ; slot3: tile_attr << 12 (high nibble)
    move.w  d7, d0
    lsl.w   #$8, d0
    move.w  d0, -$c(a6)                             ; slot2: tile_attr << 8
    move.w  d7, d0
    lsl.w   #$4, d0
    move.w  d0, -$a(a6)                             ; slot1: tile_attr << 4
    move.w  d7, -$8(a6)                             ; slot0: tile_attr verbatim
    ; --- Phase: Hard-coded endpoint fix-up ---
    ; When drawing the exact segment (x1=$20,y1=$22)->(x2=$DC,y2=$66),
    ; subtract 1 from y1 to avoid a one-pixel overrun on that route line.
    cmpi.w  #$20, d5                                ; x1 == $20?
    bne.b   l_1da94
    cmpi.w  #$22, d6                                ; y1 == $22?
    bne.b   l_1da94
    cmpi.w  #$dc, d2                                ; x2 == $DC?
    bne.b   l_1da94
    cmpi.w  #$66, d3                                ; y2 == $66?
    bne.b   l_1da94
    subq.w  #$1, d6                                 ; y1 -= 1 (clamp to avoid overrun)
l_1da94:
    ; --- Phase: Compute signed column delta and absolute row delta ---
    move.w  d2, d0
    sub.w   d5, d0
    move.w  d0, (a1)                                ; dx = x2 - x1 (signed col span)
    cmp.w   d3, d6                                  ; y1 vs y2 to determine |dy|
    ble.b   l_1daa4
    move.w  d6, d0
    sub.w   d3, d0                                  ; abs_dy = y1 - y2  (y1 > y2)
    bra.b   l_1daa8
l_1daa4:
    move.w  d3, d0
    sub.w   d6, d0                                  ; abs_dy = y2 - y1  (y2 >= y1)
l_1daa8:
    move.w  d0, (a4)                                ; store abs_dy
    ; --- Phase: Determine row_step sign for minor-axis stepping ---
    cmp.w   d2, d5
    bge.b   l_1dab2
    cmp.w   d3, d6
    blt.b   l_1daba
l_1dab2:
    cmp.w   d2, d5
    ble.b   l_1dabe
    cmp.w   d3, d6
    ble.b   l_1dabe
l_1daba:
    moveq   #$1,d0                                  ; row_step = +1 (moving downward)
    bra.b   l_1dac0
l_1dabe:
    moveq   #-$1,d0                                 ; row_step = -1 (moving upward)
l_1dac0:
    move.w  d0, -$6(a6)                             ; save row_step to local
    ; --- Phase: Choose major axis ---
    ; dx > abs_dy -> column is major axis (more horizontal line)
    ; dx <= abs_dy -> row is major axis (more vertical line)
    move.w  (a1), d0                                ; dx
    cmp.w   (a4), d0                                ; compare dx vs abs_dy
    ble.w   l_1db76                                 ; dx <= abs_dy -> row-major branch
    ; =========================================================================
    ; COL-MAJOR Bresenham: step along columns, nudge row when error overflows
    ; =========================================================================
    cmp.w   d2, d5
    ble.b   l_1dad4
    move.w  d2, d5                                  ; swap so x1 (d5) <= x2 (d2)
    move.w  d3, d6
l_1dad4:
    move.w  (a1), d0
    ext.l   d0
    bge.b   l_1dadc
    addq.l  #$1, d0                                 ; bias for signed asr rounding (round toward zero)
l_1dadc:
    asr.l   #$1, d0
    move.w  d0, d4                                  ; d4 = initial Bresenham error = dx/2
    move.w  d5, d3                                  ; d3 = current col walker (starts at x1)
    move.w  d5, d7
    add.w   (a1), d7                                ; d7 = end col limit = x1 + dx
    bra.w   l_1db6c                                 ; enter loop at condition check
l_1daea:
    ; --- Col-major loop body: draw one pixel per column step ---
    ; Wrap d3 (current col position) into [0,$FF] -> d2
    tst.w   d3
    bge.b   l_1daf6
    move.w  d3, d2
    addi.w  #$100, d2                               ; d3 < 0: add 256 to wrap into valid range
    bra.b   l_1db06
l_1daf6:
    cmpi.w  #$100, d3
    blt.b   l_1db04
    move.w  d3, d2
    addi.w  #$ff00, d2                              ; d3 >= $100: add -256 signed to wrap down
    bra.b   l_1db06
l_1db04:
    move.w  d3, d2                                  ; in [0,$FF]: use directly
l_1db06:
    ; --- Compute tilemap word address for pixel at (col=d2, row=d6) ---
    ; Layout: 8 cols per 32-byte group, rows at stride $400 (1024) bytes.
    ; addr = base + (col>>3)*32 + ((col>>2)&1)*2 + (row>>3)*1024 + (row&7)*4
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0                                 ; col / 8 = tile-group column index
    lsl.l   #$5, d0                                 ; * 32 bytes per group
    lea     (a3,d0.l), a0                           ; base + col_group_offset
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1                                 ; col / 4
    andi.l  #$1, d1                                 ; (col/4) & 1 = which half-word of the pair
    add.l   d1, d1                                  ; * 2 bytes
    adda.l  d1, a0                                  ; apply sub-word byte offset
    move.w  d6, d0
    ext.l   d0
    asr.l   #$3, d0                                 ; row / 8 = tile-row index
    moveq   #$A,d1
    lsl.l   d1, d0                                  ; * $400 bytes per tile row
    adda.l  d0, a0                                  ; add tile-row offset
    move.w  d6, d0
    andi.l  #$7, d0                                 ; row & 7 = pixel row within tile (0-7)
    lsl.l   #$2, d0                                 ; * 4 bytes per scanline
    adda.l  d0, a0                                  ; final tilemap word address
    movea.l a0, a2                                  ; a2 = pointer to target tilemap word
    ; --- AND old bits clear, then OR in new palette bits at 2-bit sub-pixel slot ---
    move.w  d2, d0
    andi.w  #$3, d0                                 ; col & 3 = 2-bit slot index (0-3)
    add.w   d0, d0                                  ; * 2 = word index into mask table
    movea.l  #$0005F9B6,a0                          ; ROM table: 4 clear-masks, one per slot
    move.w  (a0,d0.w), d0                           ; fetch AND mask that zeroes this slot
    and.w   d0, (a2)                                ; clear old palette bits at this slot
    move.w  d2, d0
    andi.w  #$3, d0                                 ; col & 3 again (for OR index)
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0                       ; fetch pre-shifted palette word for this slot
    or.w    d0, (a2)                                ; write new palette bits
    ; --- Bresenham error update (col is major axis) ---
    sub.w   (a4), d4                                ; error -= abs_dy
    tst.w   d4
    bge.b   l_1db6a                                 ; still >= 0: skip minor-axis step
    add.w   (a1), d4                                ; negative: restore error by adding dx
    add.w   -$6(a6), d6                             ; row += row_step (step minor axis)
l_1db6a:
    addq.w  #$1, d3                                 ; col++ (advance major axis)
l_1db6c:
    cmp.w   d7, d3                                  ; reached end col?
    ble.w   l_1daea                                 ; no -> draw next pixel
    bra.w   l_1dc1c                                 ; yes -> epilogue
    ; =========================================================================
    ; ROW-MAJOR Bresenham: step along rows, nudge col when error overflows
    ; =========================================================================
l_1db76:
    cmp.w   d3, d6
    ble.b   l_1db7e
    move.w  d3, d6                                  ; swap so y1 (d6) <= y2 (d3)
    move.w  d2, d5
l_1db7e:
    move.w  (a4), d0
    ext.l   d0
    bge.b   l_1db86
    addq.l  #$1, d0                                 ; bias for signed right-shift rounding
l_1db86:
    asr.l   #$1, d0
    move.w  d0, d4                                  ; d4 = initial error = abs_dy/2
    move.w  d6, d3                                  ; d3 = current row walker (starts at y1)
    move.w  d6, d7
    add.w   (a4), d7                                ; d7 = end row limit = y1 + abs_dy
    bra.w   l_1dc16                                 ; enter loop at condition check
l_1db94:
    ; --- Row-major loop body: draw one pixel per row step ---
    ; Wrap d5 (current col position) into [0,$FF] -> d2
    tst.w   d5
    bge.b   l_1dba0
    move.w  d5, d2
    addi.w  #$100, d2                               ; d5 < 0: wrap up
    bra.b   l_1dbb0
l_1dba0:
    cmpi.w  #$100, d5
    blt.b   l_1dbae
    move.w  d5, d2
    addi.w  #$ff00, d2                              ; d5 >= $100: wrap down
    bra.b   l_1dbb0
l_1dbae:
    move.w  d5, d2                                  ; in range: use directly
l_1dbb0:
    ; --- Compute tilemap address for (col=d2, row=d3) (same formula as col-major) ---
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0                                 ; col / 8
    lsl.l   #$5, d0                                 ; * 32
    lea     (a3,d0.l), a0
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1                                 ; col / 4
    andi.l  #$1, d1                                 ; sub-word half select
    add.l   d1, d1
    adda.l  d1, a0
    move.w  d3, d0
    ext.l   d0
    asr.l   #$3, d0                                 ; row / 8
    moveq   #$A,d1
    lsl.l   d1, d0                                  ; * $400
    adda.l  d0, a0
    move.w  d3, d0
    andi.l  #$7, d0                                 ; row & 7
    lsl.l   #$2, d0                                 ; * 4
    adda.l  d0, a0
    movea.l a0, a2                                  ; a2 = target tilemap word
    ; --- Write palette bits at 2-bit sub-pixel slot (identical AND/OR sequence) ---
    move.w  d2, d0
    andi.w  #$3, d0                                 ; col & 3 = slot index
    add.w   d0, d0
    movea.l  #$0005F9B6,a0                          ; clear-mask table
    move.w  (a0,d0.w), d0
    and.w   d0, (a2)                                ; zero old slot bits
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0                       ; pre-shifted palette word for this slot
    or.w    d0, (a2)                                ; write palette bits
    ; --- Bresenham error update (row is major axis) ---
    sub.w   (a1), d4                                ; error -= dx
    tst.w   d4
    bge.b   l_1dc14                                 ; >= 0: skip minor-axis step
    add.w   (a4), d4                                ; restore error by adding abs_dy
    add.w   -$6(a6), d5                             ; col += col_step (step minor axis)
l_1dc14:
    addq.w  #$1, d3                                 ; row++ (advance major axis)
l_1dc16:
    cmp.w   d7, d3                                  ; reached end row?
    ble.w   l_1db94                                 ; no -> draw next pixel
l_1dc1c:
    movem.l -$34(a6), d2-d7/a2-a4
    unlk    a6
    rts
