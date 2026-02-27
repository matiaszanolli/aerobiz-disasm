; ============================================================================
; LoadPaletteDataTile -- Copy tiles from 2D source grid into a local buffer then place via CmdPlaceTile
; 132 bytes | $0047A4-$004827
; ============================================================================
LoadPaletteDataTile:
    link    a6,#-$200
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $10(a6), d5
    move.l  $14(a6), d6
    movea.l $8(a6), a3
    clr.w   d4
    clr.w   d3
    bra.b   l_04802
l_047be:
    clr.w   d2
    bra.b   l_047fc
l_047c2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d5, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    movea.l a0, a2
    pea     ($0020).w
    move.l  d4, d0
    addq.w  #$1, d4
    lsl.w   #$5, d0
    lea     -$200(a6), a0
    pea     (a0, d0.w)
    move.l  a2, -(a7)
    bsr.w MemMove
    lea     $c(a7), a7
    addq.w  #$1, d2
l_047fc:
    cmp.w   d6, d2
    bcs.b   l_047c2
    addq.w  #$1, d3
l_04802:
    cmp.w   d5, d3
    bcs.b   l_047be
    move.w  d5, d0
    mulu.w  d6, d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    andi.w  #$7ff, d0
    move.l  d0, -(a7)
    pea     -$200(a6)
    bsr.w CmdPlaceTile
    movem.l -$21c(a6), d2-d6/a2-a3
    unlk    a6
    rts
