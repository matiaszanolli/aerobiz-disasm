; ============================================================================
; DrawTilemapLineWrap -- Draws a line between two tile-map coordinates using Bresenham-style stepping with wrap correction: writes tile-attribute words into BG-A tilemap buffer for each step along the major axis.
; 516 bytes | $01DC26-$01DE29
; ============================================================================
DrawTilemapLineWrap:                                              ; $01DC26
    ; --- Phase: Setup ---
    ; Args (pushed right-to-left): x0(d5), y0(d6), x1(d2), y1(d3), tile_attr(d7), tilemap_ptr(a3)
    link    a6,#-$10           ; 16 bytes local: -$e/-$c/-$a/-$8 = shifted tile-attr variants, -$6 = Y-step, -$4/-$2 = dx/dy accumulators
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0010(a6),d2       ; d2 = x1 (destination X, tile units)
    move.l  $0014(a6),d3       ; d3 = y1 (destination Y, tile units)
    move.l  $0008(a6),d5       ; d5 = x0 (source X, tile units)
    move.l  $000c(a6),d6       ; d6 = y0 (source Y, tile units)
    move.l  $0018(a6),d7       ; d7 = tile attribute word (palette+priority+char# base)
    movea.l $001c(a6),a3       ; a3 = tilemap buffer base pointer (BG-A RAM buffer)
    lea     -$0002(a6),a4      ; a4 = &local_dx: major-axis delta accumulator
    lea     -$0004(a6),a1      ; a1 = &local_dy: minor-axis delta accumulator
    ; --- Phase: Pre-compute four shifted tile-attribute variants ---
    ; The tilemap packs 4 tiles per word at 2-bit sub-tile positions; each
    ; variant shifts the base attribute to occupy one of those 4 bit-slots.
    move.w  d7,d0
    moveq   #$c,d1
    lsl.w   d1,d0              ; shift left by 12: tile attr in bits [15:12]
    move.w  d0,-$000e(a6)      ; local[-$e] = tile_attr << 12 (sub-tile slot 3)
    move.w  d7,d0
    lsl.w   #$8,d0             ; shift left by 8: tile attr in bits [11:8]
    move.w  d0,-$000c(a6)      ; local[-$c] = tile_attr << 8  (sub-tile slot 2)
    move.w  d7,d0
    lsl.w   #$4,d0             ; shift left by 4: tile attr in bits [7:4]
    move.w  d0,-$000a(a6)      ; local[-$a] = tile_attr << 4  (sub-tile slot 1)
    move.w  d7,-$0008(a6)      ; local[-$8] = tile_attr       (sub-tile slot 0, unshifted)
    ; --- Phase: Special-case wrap correction ---
    ; Hardcoded geometry fix for one specific route on the world map that wraps
    ; across the 256-tile (0x100) horizontal boundary. If start=(x0=0x20,y0=0x22)
    ; and end=(x1=0xDC,y1=0x66), nudge y0 down by 1 to correct the wrap.
    cmpi.w  #$20,d5            ; x0 == 32?
    bne.b   .l1dc86
    cmpi.w  #$22,d6            ; y0 == 34?
    bne.b   .l1dc86
    cmpi.w  #$dc,d2            ; x1 == 220?
    bne.b   .l1dc86
    cmpi.w  #$66,d3            ; y1 == 102?
    bne.b   .l1dc86
    subq.w  #$1,d6             ; wrap correction: nudge y0 up by 1 pixel row
.l1dc86:                                                ; $01DC86
    ; --- Phase: Compute absolute deltas; determine major/minor axis ---
    ; dx = |x1 - x0|, stored at (a4)
    move.w  d2,d0
    sub.w   d5,d0              ; d0 = x1 - x0 (signed)
    move.w  d0,(a4)            ; local_dx = x1 - x0
    ; Handle horizontal wrap: if wrapping across the 256-unit boundary,
    ; use the shorter complementary span and adjust x0.
    move.w  #$0100,d4          ; $100 = tilemap row width (256 tile units)
    sub.w   d2,d4
    add.w   d5,d4              ; d4 = $100 - dx = wrapped span width
    cmp.w   (a4),d4
    bge.b   .l1dc9e            ; wrapped span >= direct span: no wrap needed
    move.w  d4,(a4)            ; use wrapped (shorter) span as dx
    addi.w  #$0100,d5          ; adjust x0 into the wrapped coordinate space
.l1dc9e:                                                ; $01DC9E
    ; dy = |y1 - y0|, stored at (a1)
    cmp.w   d3,d6              ; y0 > y1?
    ble.b   .l1dca8
    move.w  d6,d0
    sub.w   d3,d0              ; dy = y0 - y1 (y0 is larger)
    bra.b   .l1dcac
.l1dca8:                                                ; $01DCA8
    move.w  d3,d0
    sub.w   d6,d0              ; dy = y1 - y0
.l1dcac:                                                ; $01DCAC
    move.w  d0,(a1)            ; local_dy = |y1 - y0|
    ; --- Phase: Determine Y-step direction (+1 or -1) ---
    ; The step is +1 if we're going from smaller toward larger coordinate,
    ; -1 otherwise. Logic uses two overlapping comparisons to handle both axes.
    cmp.w   d2,d5              ; x0 >= x1?
    bge.b   .l1dcb6
    cmp.w   d3,d6              ; y0 < y1 (go positive)?
    blt.b   .l1dcbe
.l1dcb6:                                                ; $01DCB6
    cmp.w   d2,d5              ; x0 <= x1?
    ble.b   .l1dcc2
    cmp.w   d3,d6              ; y0 <= y1?
    ble.b   .l1dcc2
.l1dcbe:                                                ; $01DCBE
    moveq   #$1,d0             ; step = +1 (moving in positive Y direction)
    bra.b   .l1dcc4
.l1dcc2:                                                ; $01DCC2
    moveq   #-$1,d0            ; step = -1 (moving in negative Y direction)
.l1dcc4:                                                ; $01DCC4
    move.w  d0,-$0006(a6)      ; local_ystep = Y-step direction (+1 or -1)
    ; --- Phase: Choose major axis and set up Bresenham loop ---
    move.w  (a4),d0            ; d0 = dx
    cmp.w   (a1),d0            ; dx > dy? (X is major axis)
    ble.w   .l1dd7a            ; no: Y is major axis -> jump to Y-major loop
    ; === X-major Bresenham loop setup ===
    cmp.w   d2,d5              ; x0 > x1? (going right-to-left)
    ble.b   .l1dcd8
    move.w  d2,d5              ; swap: ensure x0 <= x1 (always iterate left to right)
    move.w  d3,d6              ; update y0 accordingly
.l1dcd8:                                                ; $01DCD8
    ; Bresenham error term init: err = dx/2 (rounded toward zero)
    move.w  (a4),d0            ; d0 = dx
    ext.l   d0
    bge.b   .l1dce0
    addq.l  #$1,d0             ; round toward zero for negative dx (shouldn't occur here)
.l1dce0:                                                ; $01DCE0
    asr.l   #$1,d0             ; err = dx >> 1
    move.w  d0,d4              ; d4 = Bresenham error accumulator
    move.w  d5,d3              ; d3 = x (current X position, starts at x0)
    move.w  d5,d7
    add.w   (a4),d7            ; d7 = x_end = x0 + dx (loop termination)
    bra.w   .l1dd70            ; enter X-major loop at loop-condition check
    ; === X-major plot loop body ===
.l1dcee:                                                ; $01DCEE
    ; Wrap X coordinate d3 into [0, $100) for tilemap addressing
    tst.w   d3                 ; d3 < 0?
    bge.b   .l1dcfa
    move.w  d3,d2
    addi.w  #$0100,d2          ; wrap negative: d2 = d3 + $100
    bra.b   .l1dd0a
.l1dcfa:                                                ; $01DCFA
    cmpi.w  #$0100,d3          ; d3 >= $100?
    blt.b   .l1dd08
    move.w  d3,d2
    addi.w  #$ff00,d2          ; wrap high: d2 = d3 - $100 (= d3 + $FF00 as signed word)
    bra.b   .l1dd0a
.l1dd08:                                                ; $01DD08
    move.w  d3,d2              ; no wrap needed: d2 = d3
.l1dd0a:                                                ; $01DD0A
    ; --- Compute tilemap word address for this pixel (X=d2, Y=d6) ---
    ; Tilemap stores 2-bit sub-tiles; each word covers 4 X-positions.
    ; Row offset: (d2 >> 3) * 32 bytes = d2/8 * 32
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0             ; d0 = d2 / 8 (word group within row)
    lsl.l   #$5,d0             ; d0 *= 32 (bytes per word-group row)
    lea     (a3,d0.l),a0       ; a0 = tilemap_base + row_byte_offset
    ; Even/odd word select within the 32-byte group: bit 2 of (d2 >> 2)
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1             ; d1 = d2 / 4
    andi.l  #$1,d1             ; d1 = bit 0 = even or odd word
    add.l   d1,d1              ; d1 *= 2 (byte offset: 0 or 2)
    adda.l  d1,a0
    ; Column within tile row: (d6 >> 3) * 1024 bytes (1024 = 2^10, tile row stride)
    move.w  d6,d0
    ext.l   d0
    asr.l   #$3,d0             ; d0 = d6 / 8 (tile row index)
    moveq   #$a,d1
    lsl.l   d1,d0              ; d0 *= 1024 (bytes per tile row in tilemap)
    adda.l  d0,a0
    ; Sub-tile within tile column: (d6 & 7) * 4 bytes
    move.w  d6,d0
    andi.l  #$7,d0             ; d0 = d6 mod 8
    lsl.l   #$2,d0             ; d0 *= 4 bytes
    adda.l  d0,a0
    movea.l a0,a2              ; a2 = final word address in tilemap buffer
    ; --- Write tile attribute bits into the target word ---
    ; Mask off old bits at this sub-tile position using table at $5F9B6
    move.w  d2,d0
    andi.w  #$3,d0             ; d0 = d2 & 3: sub-tile slot index (0-3)
    add.w   d0,d0              ; d0 *= 2 (word index into mask table)
    movea.l #$0005f9b6,a0      ; a0 = ROM mask table: 4 words, one per sub-tile slot
    move.w  (a0,d0.w),d0       ; d0 = AND mask that clears this sub-tile's bits
    and.w   d0,(a2)            ; apply clear mask to tilemap word
    ; OR in the new tile attribute at the correct sub-tile bit position
    move.w  d2,d0
    andi.w  #$3,d0             ; d0 = sub-tile slot index again
    add.w   d0,d0              ; d0 *= 2
    move.w  -$e(a6,d0.w),d0   ; d0 = pre-shifted tile-attr from local table [-$e..-$8]
    or.w    d0,(a2)            ; merge tile attribute into tilemap word
    ; --- Bresenham error update (X-major: Y steps on error underflow) ---
    sub.w   (a1),d4            ; err -= dy
    tst.w   d4
    bge.b   .l1dd6e            ; err >= 0: no Y step
    add.w   (a4),d4            ; err += dx (restore error accumulator)
    add.w   -$0006(a6),d6      ; d6 += y_step (+1 or -1): advance Y by one
.l1dd6e:                                                ; $01DD6E
    addq.w  #$1,d3             ; advance X position by 1
.l1dd70:                                                ; $01DD70
    cmp.w   d7,d3              ; reached x_end?
    ble.w   .l1dcee            ; no: continue X-major loop
    bra.w   .l1de20            ; yes: done

    ; === Y-major Bresenham loop setup ===
.l1dd7a:                                                ; $01DD7A
    cmp.w   d3,d6              ; y0 > y1? (going bottom-to-top)
    ble.b   .l1dd82
    move.w  d3,d6              ; swap: ensure y0 <= y1 (always iterate top to bottom)
    move.w  d2,d5              ; update x0 accordingly
.l1dd82:                                                ; $01DD82
    ; Bresenham error term init: err = dy/2 (rounded toward zero)
    move.w  (a1),d0            ; d0 = dy
    ext.l   d0
    bge.b   .l1dd8a
    addq.l  #$1,d0             ; round toward zero for negative values
.l1dd8a:                                                ; $01DD8A
    asr.l   #$1,d0             ; err = dy >> 1
    move.w  d0,d4              ; d4 = Bresenham error accumulator
    move.w  d6,d3              ; d3 = y (current Y position, starts at y0)
    move.w  d6,d7
    add.w   (a1),d7            ; d7 = y_end = y0 + dy (loop termination)
    bra.w   .l1de1a            ; enter Y-major loop at loop-condition check
    ; === Y-major plot loop body ===
.l1dd98:                                                ; $01DD98
    ; Wrap X coordinate d5 into [0, $100) for tilemap addressing
    tst.w   d5                 ; d5 < 0?
    bge.b   .l1dda4
    move.w  d5,d2
    addi.w  #$0100,d2          ; wrap negative X
    bra.b   .l1ddb4
.l1dda4:                                                ; $01DDA4
    cmpi.w  #$0100,d5          ; d5 >= $100?
    blt.b   .l1ddb2
    move.w  d5,d2
    addi.w  #$ff00,d2          ; wrap high X
    bra.b   .l1ddb4
.l1ddb2:                                                ; $01DDB2
    move.w  d5,d2              ; no wrap: d2 = d5
.l1ddb4:                                                ; $01DDB4
    ; --- Compute tilemap word address for this pixel (X=d2, Y=d3) ---
    ; Identical address formula to X-major path, but using d3 as Y
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0             ; d0 = d2 / 8
    lsl.l   #$5,d0             ; d0 *= 32 (bytes per word-group row)
    lea     (a3,d0.l),a0
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1             ; d1 = d2 / 4
    andi.l  #$1,d1             ; d1 = even/odd word select
    add.l   d1,d1
    adda.l  d1,a0
    move.w  d3,d0              ; Y position = d3 (current Y in Y-major loop)
    ext.l   d0
    asr.l   #$3,d0             ; d0 = d3 / 8 (tile row)
    moveq   #$a,d1
    lsl.l   d1,d0              ; d0 *= 1024 (tile row stride)
    adda.l  d0,a0
    move.w  d3,d0
    andi.l  #$7,d0             ; d0 = d3 mod 8 (sub-row)
    lsl.l   #$2,d0             ; d0 *= 4
    adda.l  d0,a0
    movea.l a0,a2              ; a2 = tilemap word address
    ; Mask off old bits at this sub-tile position
    move.w  d2,d0
    andi.w  #$3,d0             ; sub-tile slot index
    add.w   d0,d0
    movea.l #$0005f9b6,a0      ; ROM mask table
    move.w  (a0,d0.w),d0       ; AND clear mask
    and.w   d0,(a2)
    ; OR in new tile attribute
    move.w  d2,d0
    andi.w  #$3,d0             ; sub-tile slot index
    add.w   d0,d0
    move.w  -$e(a6,d0.w),d0   ; pre-shifted tile attribute from local table
    or.w    d0,(a2)
    ; --- Bresenham error update (Y-major: X steps on error underflow) ---
    sub.w   (a4),d4            ; err -= dx
    tst.w   d4
    bge.b   .l1de18            ; err >= 0: no X step
    add.w   (a1),d4            ; err += dy (restore)
    add.w   -$0006(a6),d5      ; d5 += x_step (+1 or -1): advance X by one
.l1de18:                                                ; $01DE18
    addq.w  #$1,d3             ; advance Y position by 1
.l1de1a:                                                ; $01DE1A
    cmp.w   d7,d3              ; reached y_end?
    ble.w   .l1dd98            ; no: continue Y-major loop
.l1de20:                                                ; $01DE20
    ; --- Phase: Epilogue ---
    movem.l -$0034(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $4E56,$0000,$42A7                                ; $01DE2A
; === Translated block $01DE30-$01DE92 ===
; 2 functions, 98 bytes
