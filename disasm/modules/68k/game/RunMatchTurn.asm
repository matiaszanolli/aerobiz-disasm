; ============================================================================
; RunMatchTurn -- Selects best available char for a match turn based on negotiation power, compat score, and skill weights
; 344 bytes | $034820-$034977
; ============================================================================
RunMatchTurn:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    lea     -$6(a6), a4
    lea     -$2(a6), a5
    move.w  #$ff, d0
    move.w  d0, -$8(a6)
    move.w  d0, (a4)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    move.w  d0, -$a(a6)
    move.l  #$270fd8f0, d6
    move.l  d6, d5
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    lea     $10(a7), a7
    move.w  d0, -$4(a6)
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_34886
    addq.l  #$3, d0
l_34886:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d4
    movea.l  #$00FFA6B8,a2
    move.w  $a(a6), d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
l_348a8:
    move.w  $2(a2), d0
    cmp.w   -$4(a6), d0
    bls.w   l_3494e
    moveq   #$0,d0
    move.b  $6(a2), d0
    addi.w  #$ffff, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_3494e
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$0,d1
    move.b  $7(a2), d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bge.b   l_3494e
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    addq.l  #$8, a7
    cmpi.w  #$ffff, d0
    beq.b   l_3494e
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$0,d2
    move.w  -$a(a6), d2
    sub.l   d0, d2
    tst.l   d2
    bge.b   l_34914
    moveq   #$0,d0
    sub.l   d2, d0
    move.l  d0, d2
l_34914:
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    jsr SignedDiv
    move.w  d0, d7
    moveq   #$0,d1
    move.w  d7, d1
    move.l  d2, d0
    jsr Multiply32
    move.l  d0, d2
    cmp.l   d5, d2
    bgt.b   l_34940
    move.l  d2, d5
    move.w  d3, -$8(a6)
l_34940:
    tst.b   $1(a3)
    beq.b   l_3494e
    cmp.l   d6, d2
    bgt.b   l_3494e
    move.l  d2, d6
    move.w  d3, (a4)
l_3494e:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.w   l_348a8
    cmpi.w  #$10, (a4)
    bcc.b   l_34968
    move.w  (a4), (a5)
    bra.b   l_3496c
l_34968:
    move.w  -$8(a6), (a5)
l_3496c:
    move.w  (a5), d0
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
