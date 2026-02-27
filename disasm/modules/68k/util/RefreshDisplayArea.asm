; ============================================================================
; RefreshDisplayArea -- Scores a character pair, formats the result as percent offset from 50, draws info box, and processes directional input; calls ProcessCityChange on value change
; 1158 bytes | $0163E2-$016867
; ============================================================================
RefreshDisplayArea:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a3
    movea.l  #$00FF13FC,a4
    movea.l  #$0003AB2C,a5
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, d4
    pea     ($0064).w
    pea     ($0096).w
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1
    jsr SignedDiv
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d3
    beq.b   .l16474
    cmpi.w  #$3, d3
    bge.b   .l1646e
    sub.w   d3, d2
    bra.b   .l16474
.l1646e:
    moveq   #$5,d0
    sub.w   d3, d0
    add.w   d0, d2
.l16474:
    pea     ($0004).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    jsr DrawBox
    lea     $24(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l164b4
    moveq   #$1,d0
    bra.b   .l164b6
.l164b4:
    moveq   #$0,d0
.l164b6:
    move.w  d0, -$2(a6)
    clr.w   d6
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    moveq   #-$1,d5
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)
    lea     $20(a7), a7
    move.w  $4(a2), d0
    move.w  d0, d3
    ext.l   d0
.l164f2:
    tst.w   d2
    ble.b   .l164fc
    move.w  d2, d0
    ext.l   d0
    bra.b   .l164fe
.l164fc:
    moveq   #$0,d0
.l164fe:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   .l1650c
    move.w  d2, d0
    ext.l   d0
    bra.b   .l1650e
.l1650c:
    moveq   #$64,d0
.l1650e:
    move.w  d0, d2
    cmp.w   d5, d2
    beq.w   .l16600
    pea     ($0013).w
    pea     ($000F).w
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    beq.b   .l1656c
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    bge.b   .l16558
    move.w  d2, d0
    ext.l   d0
    neg.l   d0
    addi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F8AE).l
.l1654e:
    jsr PrintfWide
    addq.l  #$8, a7
    bra.b   .l1657a
.l16558:
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F89C).l
    bra.b   .l1654e
.l1656c:
    pea     ($0003F88C).l
    jsr PrintfWide
    addq.l  #$4, a7
.l1657a:
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F886).l
    jsr PrintfNarrow
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F880).l
    jsr PrintfNarrow
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l165e6
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l165e8
.l165e6:
    moveq   #$1,d0
.l165e8:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCityChange,PC)
    nop
    lea     $28(a7), a7
    move.w  d2, d5
.l16600:
    tst.w   -$2(a6)
    beq.b   .l16616
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l164f2
.l16616:
    clr.w   -$2(a6)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   .l167c6
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l16654
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l1673a
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l16788
    bra.w   .l167ba
.l16654:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  $4(a2), d1
    cmp.l   d1, d0
    beq.w   .l167d2
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1
    jsr SignedDiv
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d3
    beq.b   .l166b0
    cmpi.w  #$3, d3
    bge.b   .l166aa
    sub.w   d3, d2
    bra.b   .l166b0
.l166aa:
    moveq   #$5,d0
    sub.w   d3, d0
    add.w   d0, d2
.l166b0:
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l166de
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l166e0
.l166de:
    moveq   #$1,d0
.l166e0:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCityChange,PC)
    nop
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F87A).l
    jsr PrintfNarrow
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F874).l
    jsr PrintfNarrow
    lea     $28(a7), a7
    bra.w   .l167d2
.l1673a:
    move.w  #$1, (a4)
    subq.w  #$5, d2
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   d4, d0
    move.w  d0, d3
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16768
    addq.l  #$1, d0
.l16768:
    asr.l   #$1, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l16778
.l16772:
    move.w  d3, d0
.l16774:
    ext.l   d0
    bra.b   .l16782
.l16778:
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16780
    addq.l  #$1, d0
.l16780:
    asr.l   #$1, d0
.l16782:
    move.w  d0, d3
    bra.w   .l164f2
.l16788:
    move.w  #$1, (a4)
    addq.w  #$5, d2
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   d4, d0
    move.w  d0, d3
    cmp.w   -$4(a6), d3
    blt.b   .l16772
    move.w  -$4(a6), d0
    bra.b   .l16774
.l167ba:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    bra.w   .l164f2
.l167c6:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d3, $4(a2)
.l167d2:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
