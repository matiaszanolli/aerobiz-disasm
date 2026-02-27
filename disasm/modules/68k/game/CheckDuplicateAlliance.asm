; ============================================================================
; CheckDuplicateAlliance -- Returns 1 if two players share an alliance entry of lower rank than the given player pair
; 106 bytes | $0325F8-$032661
; ============================================================================
CheckDuplicateAlliance:
    movem.l d2-d5, -(a7)
    move.l  $18(a7), d4
    moveq   #$1,d5
    move.w  $16(a7), d0
    lsl.w   #$3, d0
    add.w   d4, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    cmpi.w  #$1, d3
    bne.b   l_32624
l_32620:
    clr.w   d5
    bra.b   l_3265a
l_32624:
    movea.l  #$00FF0018,a1
    clr.w   d2
l_3262c:
    tst.b   (a1)
    bne.b   l_3264e
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d4, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    blt.b   l_32620
l_3264e:
    moveq   #$24,d0
    adda.l  d0, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3262c
l_3265a:
    move.w  d5, d0
    movem.l (a7)+, d2-d5
    rts
