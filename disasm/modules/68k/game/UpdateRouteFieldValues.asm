; ============================================================================
; UpdateRouteFieldValues -- Recalculate route output and revenue for all players by calling CalcCharOutput on every active slot and accumulating results into $FF09A2.
; 300 bytes | $0208F2-$020A1D
; ============================================================================
UpdateRouteFieldValues:
    link    a6,#-$8
    movem.l d2-d3/a2-a4, -(a7)
    movea.l  #$00FF09A2,a4
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF0420,a2
    clr.w   d3
l_2091a:
    clr.w   d2
l_2091c:
    moveq   #$0,d0
    move.b  (a2), d0
    cmpi.w  #$4, d0
    bcc.b   l_2096e
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    move.w  ($00FF0006).l, d0
    move.l  d0, -(a7)
    jsr CalcCharOutput
    lea     $18(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$4(a6), d0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$8(a6), d0
    add.l   d0, $4(a4, a0.l)
l_2096e:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_2091c
    addq.w  #$1, d3
    cmpi.w  #$20, d3
    bcs.b   l_2091a
    movea.l  #$00FF04E0,a2
    moveq   #$20,d3
l_20988:
    clr.w   d2
l_2098a:
    moveq   #$0,d0
    move.b  (a2), d0
    cmpi.w  #$4, d0
    bcc.b   l_209dc
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    move.w  ($00FF0006).l, d0
    move.l  d0, -(a7)
    jsr CalcCharOutput
    lea     $18(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$4(a6), d0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    movea.l d0, a0
    move.l  -$8(a6), d0
    add.l   d0, $4(a4, a0.l)
l_209dc:
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_2098a
    addq.w  #$1, d3
    cmpi.w  #$59, d3
    bcs.b   l_20988
    movea.l  #$00FF0018,a2
    movea.l a4, a3
    clr.w   d3
l_209f8:
    move.l  $4(a3), d0
    sub.l   d0, $6(a2)
    move.l  (a3), d0
    add.l   d0, $6(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.l  #$8, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_209f8
    movem.l -$1c(a6), d2-d3/a2-a4
    unlk    a6
    rts


; === Translated block $020A1E-$020A64 ===
; 1 functions, 70 bytes
