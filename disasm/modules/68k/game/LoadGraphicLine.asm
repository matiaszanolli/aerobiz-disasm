; ============================================================================
; LoadGraphicLine -- Copies a row of graphic tiles from source VRAM buffer to the tile work area at $FFAA64; iterates over the tile count in the record
; 122 bytes | $03A52E-$03A5A7
; ============================================================================
LoadGraphicLine:
    link    a6,#$0
    movem.l d2-d5/a2-a3, -(a7)
    move.w  $a(a6), d0
    lsl.w   #$3, d0
    movea.l  #$00048868,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a0), d3
    move.w  $2(a2), d4
    move.w  $4(a2), d2
    move.w  $6(a2), d5
    move.w  d5, d0
    mulu.w  #$c, d0
    add.w   d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FFAA64,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    movea.l  #$00FFA7E4,a3
    clr.w   d2
    bra.b   l_3a59a
l_3a576:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    jsr MemMove
    lea     $c(a7), a7
    lea     $180(a2), a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    adda.l  d0, a3
    addq.w  #$1, d2
l_3a59a:
    cmp.w   d4, d2
    bcs.b   l_3a576
    movem.l -$18(a6), d2-d5/a2-a3
    unlk    a6
    rts
