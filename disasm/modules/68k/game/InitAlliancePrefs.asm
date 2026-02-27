; ============================================================================
; InitAlliancePrefs -- Initialises alliance preference table at $FFA794 based on player type and current game round
; 440 bytes | $0321E0-$032397
; ============================================================================
InitAlliancePrefs:
    move.l  $1c(a7), d3
    movea.l  #$00FFA794,a3
    movea.l a3, a4
    moveq   #$16,d0
    adda.l  d0, a4
    movea.l a3, a5
    moveq   #$14,d0
    adda.l  d0, a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $1(a2), d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    move.w  #$5, ($00FFA794).l
    move.w  #$6, $2(a3)
    clr.w   $4(a3)
    move.w  #$1, $6(a3)
    move.w  #$3, $8(a3)
    move.w  #$4, $a(a3)
    clr.w   $c(a3)
    move.w  #$2, $e(a3)
    clr.w   $10(a3)
    move.w  #$5, $12(a3)
    move.w  #$2, (a5)
    move.w  #$3, (a4)
    cmpi.w  #$1, d3
    bne.b   l_32288
    move.w  #$1, $c(a3)
    move.w  #$2, $e(a3)
    clr.w   $8(a3)
    move.w  #$1, $a(a3)
    move.w  #$3, $4(a3)
    move.w  #$4, $6(a3)
    bra.b   l_322f4
l_32288:
    cmpi.w  #$2, d3
    bne.b   l_3229c
    move.w  #$1, $4(a3)
    move.w  #$2, $6(a3)
    bra.b   l_322f4
l_3229c:
    tst.w   ($00FF0002).l
    ble.b   l_322f4
    tst.w   d3
    beq.b   l_322b4
    cmpi.w  #$5, d3
    beq.b   l_322b4
    cmpi.w  #$6, d3
    bne.b   l_322bc
l_322b4:
    clr.w   (a5)
    move.w  #$3, (a4)
    bra.b   l_322d2
l_322bc:
    cmpi.w  #$3, d3
    beq.b   l_322c8
    cmpi.w  #$4, d3
    bne.b   l_322d2
l_322c8:
    clr.w   $c(a3)
    move.w  #$3, $e(a3)
l_322d2:
    cmpi.w  #$1, d3
    bne.b   l_322e2
    move.w  #$1, (a5)
    move.w  #$3, (a4)
    bra.b   l_322f4
l_322e2:
    cmpi.w  #$3, d3
    bne.b   l_322f4
    move.w  #$3, $4(a3)
    move.w  #$1, $6(a3)
l_322f4:
    cmpi.w  #$c, d2
    bne.b   l_3230a
l_322fa:
    move.w  #$3, $10(a3)
    move.w  #$5, $12(a3)
    bra.w   l_32392
l_3230a:
    cmpi.w  #$1c, d2
    beq.b   l_32316
    cmpi.w  #$19, d2
    bne.b   l_32320
l_32316:
    move.w  #$3, (a5)
    move.w  #$5, (a4)
    bra.b   l_32392
l_32320:
    cmpi.w  #$6, d2
    bne.b   l_3232e
    clr.w   (a5)
    move.w  #$3, (a4)
    bra.b   l_32392
l_3232e:
    cmpi.w  #$d, d2
    bne.b   l_32340
    clr.w   $c(a3)
    move.w  #$3, $e(a3)
    bra.b   l_32392
l_32340:
    cmpi.w  #$e, d2
    bne.b   l_3234e
    tst.w   ($00FF0002).l
    bgt.b   l_322fa
l_3234e:
    cmpi.w  #$1d, d2
    beq.b   l_3235a
    cmpi.w  #$1e, d2
    bne.b   l_3236e
l_3235a:
    tst.w   ($00FF0002).l
    ble.b   l_3236e
    clr.w   $10(a3)
    move.w  #$6, $12(a3)
    bra.b   l_32392
l_3236e:
    tst.w   d2
    beq.b   l_3237e
    cmpi.w  #$1, d2
    beq.b   l_3237e
    cmpi.w  #$4, d2
    bne.b   l_32392
l_3237e:
    tst.w   ($00FF0002).l
    ble.b   l_32392
    clr.w   ($00FFA794).l
    move.w  #$6, $2(a3)
l_32392:
    movem.l (a7)+, d2-d3/a2-a5
    rts
