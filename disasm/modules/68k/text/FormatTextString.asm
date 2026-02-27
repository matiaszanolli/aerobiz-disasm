; ============================================================================
; FormatTextString -- Computes a scaled rectangle from row/col/width/height args (subtracting base offsets and multiplying widths), then calls PackScrollControlBlock to pack the result into a scroll-control record at the caller's local buffer.
; 76 bytes | $01D772-$01D7BD
; ============================================================================
FormatTextString:
    link    a6,#-$8
    movem.l d2-d3, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d3
    move.w  $16(a6), d1
    sub.w   d3, d1
    move.w  $1a(a6), d0
    sub.w   d2, d0
    mulu.w  d0, d1
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d1, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$8(a6)
    jsr (PackScrollControlBlock,PC)
    nop
    movem.l -$10(a6), d2-d3
    unlk    a6
    rts
