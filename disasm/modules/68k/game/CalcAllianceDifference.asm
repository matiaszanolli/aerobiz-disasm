; ============================================================================
; CalcAllianceDifference -- Returns the difference in route revenue between two players sharing an alliance entry
; 124 bytes | $0326B2-$03272D
; ============================================================================
CalcAllianceDifference:
    movem.l d2-d7/a2, -(a7)
    move.l  $24(a7), d5
    move.l  $20(a7), d6
    movea.l  #$00FF0130,a1
    clr.w   d2
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d5, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_326d8:
    cmpi.b  #$1, (a2)
    bne.b   l_326e2
    move.w  d2, d3
    bra.b   l_326ea
l_326e2:
    cmpi.b  #$2, (a2)
    bne.b   l_326ea
    move.w  d2, d4
l_326ea:
    addq.l  #$8, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_326d8
    cmp.w   d6, d3
    bne.b   l_326fe
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_32702
l_326fe:
    moveq   #$0,d0
    move.w  d3, d0
l_32702:
    lsl.l   #$5, d0
    lea     (a1,d0.l), a0
    moveq   #$0,d1
    move.w  d5, d1
    lsl.l   #$2, d1
    adda.l  d1, a0
    move.l  (a0), d0
    moveq   #$0,d1
    move.w  d6, d1
    lsl.l   #$5, d1
    lea     (a1,d1.l), a0
    moveq   #$0,d7
    move.w  d5, d7
    lsl.l   #$2, d7
    adda.l  d7, a0
    sub.l   (a0), d0
    move.l  d0, d5
    movem.l (a7)+, d2-d7/a2
    rts
