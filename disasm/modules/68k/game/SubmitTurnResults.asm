; ============================================================================
; SubmitTurnResults -- Evaluate player region match and bitfield, format result message, show turn outcome dialog
; 312 bytes | $00FB74-$00FCAB
; ============================================================================
SubmitTurnResults:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d5
    lea     -$80(a6), a3
    movea.l  #$0005EC84,a4
    movea.l  #$0003B22C,a5
    moveq   #$1,d4
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   d3, d0
    beq.w   l_0fc68
    pea     ($00FF).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckBitField
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_0fc54
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_0fbf2:
    cmpi.b  #$3, $1(a2)
    beq.b   l_0fc02
    cmpi.b  #$4, $1(a2)
    bne.b   l_0fc48
l_0fc02:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   d3, d0
    bne.b   l_0fc48
    cmpi.b  #$3, $1(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477D4).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $10(a7), a7
    bra.b   l_0fc82
l_0fc48:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_0fbf2
    bra.b   l_0fc84
l_0fc54:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477DC).l, -(a7)
    bra.b   l_0fc7a
l_0fc68:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    move.l  ($000477D8).l, -(a7)
l_0fc7a:
    move.l  a3, -(a7)
    jsr     (a5)
    lea     $c(a7), a7
l_0fc82:
    clr.w   d4
l_0fc84:
    tst.w   d4
    bne.b   l_0fca0
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
l_0fca0:
    move.w  d4, d0
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
