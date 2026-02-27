; ============================================================================
; EvaluateCharPool -- Scores alliance preference pairs for AI: checks profitability, availability, and match state; offers contracts
; 632 bytes | $0341C2-$034439
; ============================================================================
EvaluateCharPool:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    lea     -$c(a6), a4
    movea.l  #$00006EEA,a5
    pea     ($000C).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    lea     $10(a7), a7
    move.w  d0, d4
    jsr CountActivePlayers
    move.w  d0, -$1a(a6)
    movea.l  #$00FFA794,a2
    clr.w   d3
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a3
l_3422c:
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d5
    cmpi.w  #$ff, d5
    bne.b   l_34244
    moveq   #-$2,d5
l_34244:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.b   l_34262
    moveq   #-$2,d2
l_34262:
    move.w  d5, d0
    addq.w  #$1, d0
    move.w  d2, d1
    addq.w  #$1, d1
    mulu.w  d1, d0
    move.w  d0, d2
    tst.w   d2
    bge.w   l_34302
    tst.w   d5
    bge.b   l_34282
    move.w  $2(a2), d2
    move.w  (a2), $2(a2)
    move.w  d2, (a2)
l_34282:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CheckCharPairConflict,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_34302
    addi.w  #$64, (a3)
    cmp.w   (a2), d4
    beq.b   l_342b2
    cmp.w   $2(a2), d4
    bne.b   l_342b6
l_342b2:
    addi.w  #$1e, (a3)
l_342b6:
    cmpi.w  #$1, -$1a(a6)
    bne.b   l_342d6
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    jsr (CheckCharAvailable,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342d6
    addi.w  #$64, (a3)
l_342d6:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    jsr (CountFilledAllianceSlots,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342ee
    addi.w  #$14, (a3)
l_342ee:
    cmpi.w  #$3, $2(a2)
    beq.b   l_342fe
    cmpi.w  #$5, $2(a2)
    bne.b   l_34302
l_342fe:
    addi.w  #$32, (a3)
l_34302:
    tst.w   (a3)
    bgt.b   l_34310
    move.w  #$ff, d0
    move.w  d0, (a2)
    move.w  d0, $2(a2)
l_34310:
    addq.l  #$4, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.w   l_3422c
    clr.w   d4
l_34320:
    movea.l a4, a2
    moveq   #-$A,d2
    clr.w   d3
l_34326:
    cmp.w   (a2), d2
    bge.b   l_3432e
    move.w  (a2), d2
    move.w  d3, d7
l_3432e:
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.b   l_34326
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)
    move.w  d4, d0
    add.w   d0, d0
    move.w  d7, -$18(a6, d0.w)
    addq.w  #$1, d4
    cmpi.w  #$6, d4
    bcs.b   l_34320
    clr.w   d4
l_34358:
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$18(a6, d0.w), d0
    lsl.w   #$2, d0
    movea.l  #$00FFA794,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$ff, (a2)
    beq.w   l_34430
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, d3
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (OfferCharContract,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    cmpi.w  #$20, d3
    bcc.b   l_34426
    cmpi.w  #$20, d2
    bcc.b   l_34426
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (RunMatchTurn,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$10, d5
    bcc.b   l_34426
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (FindEmptyMatchSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    cmp.w   ($00FFA7DA).l, d7
    bcc.b   l_34430
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CalcMatchScore,PC)
    nop
    lea     $14(a7), a7
    bra.b   l_34430
l_34426:
    addq.w  #$1, d4
    cmpi.w  #$6, d4
    bcs.w   l_34358
l_34430:
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts
