; ============================================================================
; ProcessCityChange -- Builds an array of up/neutral/down icon tile IDs from row-count and column-index parameters and renders two rows of those tiles via GameCommand
; 240 bytes | $016868-$016957
; ============================================================================
ProcessCityChange:
    link    a6,#-$18
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d4
    lea     -$16(a6), a2
    movea.l  #$00000D64,a3
    cmpi.w  #$a, d3
    bge.b   .l1688e
    move.w  d3, d0
    ext.l   d0
    bra.b   .l16890
.l1688e:
    moveq   #$A,d0
.l16890:
    move.w  d0, d3
    cmpi.w  #$1, d4
    bge.b   .l1689e
    move.w  d4, d0
    ext.l   d0
    bra.b   .l168a0
.l1689e:
    moveq   #$1,d0
.l168a0:
    move.w  d0, d4
    clr.w   d2
    bra.b   .l168b6
.l168a6:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33a, (a2,a0.l)
    addq.w  #$1, d2
.l168b6:
    moveq   #$0,d0
    move.w  d2, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    blt.b   .l168a6
    bra.b   .l168d4
.l168c4:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33b, (a2,a0.l)
    addq.w  #$1, d2
.l168d4:
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   .l168c4
    bra.b   .l168f8
.l168e8:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33c, (a2,a0.l)
    addq.w  #$1, d2
.l168f8:
    cmpi.w  #$a, d2
    bcs.b   .l168e8
    move.l  a2, -(a7)
    pea     ($0001).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  a2, -(a7)
    pea     ($0001).w
    pea     ($000A).w
    pea     ($0014).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$2c(a6), d2-d4/a2-a3
    unlk    a6
    rts
