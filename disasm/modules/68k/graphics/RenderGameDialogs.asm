; ============================================================================
; RenderGameDialogs -- Runs the negotiation/dialog UI loop for a match slot; handles Up/Down offer adjustment, partner browsing, and confirm/cancel input
; 1878 bytes | $039688-$039DDD
; ============================================================================
RenderGameDialogs:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a3
    lea     -$8(a6), a4
    lea     -$4(a6), a5
    move.w  #$33a, d7
    clr.w   d6
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_396e4
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_396e4:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, (a5)
    pea     ($0064).w
    pea     ($0096).w
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $24(a7), a7
    move.w  d0, -$6(a6)
    clr.w   $4(a2)
    moveq   #$32,d2
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  #$1, -$c(a6)
    clr.l   -(a7)
    jsr ReadInput
    lea     $24(a7), a7
    tst.w   d0
    beq.b   l_39774
    moveq   #$1,d0
    bra.b   l_39776
l_39774:
    moveq   #$0,d0
l_39776:
    move.w  d0, -$2(a6)
    clr.w   -$a(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  (a5), (a4)
    clr.w   d5
l_3978e:
    addq.w  #$1, d5
    cmpi.w  #$1, d5
    bne.b   l_397fe
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0010).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0068).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
l_397f0:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   l_3981e
l_397fe:
    cmpi.w  #$f, d5
    bne.b   l_39816
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_397f0
l_39816:
    cmpi.w  #$1e, d5
    bne.b   l_3981e
    clr.w   d5
l_3981e:
    tst.w   d2
    ble.b   l_39828
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3982a
l_39828:
    moveq   #$0,d0
l_3982a:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   l_39838
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3983a
l_39838:
    moveq   #$64,d0
l_3983a:
    move.w  d0, d2
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    beq.w   l_398ea
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    bge.b   l_398b0
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    neg.l   d0
    addi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0004502C).l
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.w   l_3991c
    pea     ($0004501E).l
l_398a2:
    jsr PrintfWide
    addq.l  #$4, a7
    clr.w   -$c(a6)
    bra.b   l_3991c
l_398b0:
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0004501A).l
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.b   l_3991c
    pea     ($0004500C).l
    bra.b   l_398a2
l_398ea:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000F).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($00044FFE).l
    jsr PrintfWide
    lea     $20(a7), a7
    move.w  (a4), (a5)
    move.w  #$1, -$c(a6)
l_3991c:
    pea     ($0009).w
    pea     ($0019).w
    jsr SetTextCursor
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF8).l
    jsr PrintfNarrow
    pea     ($000A).w
    pea     ($0019).w
    jsr SetTextCursor
    move.w  d2, d0
    addi.w  #$ffce, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF2).l
    jsr PrintfNarrow
    lea     $20(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   l_39992
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   l_39994
l_39992:
    moveq   #$1,d0
l_39994:
    move.w  d0, d4
    tst.w   d3
    ble.b   l_399f2
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_399f2:
    tst.w   d4
    beq.b   l_39a5a
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000A).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0010).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_39a5a:
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    ble.w   l_39af4
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000A).w
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_39af4:
    tst.w   -$2(a6)
    beq.b   l_39b18
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_39b18
l_39b08:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   l_3978e
l_39b18:
    clr.w   -$2(a6)
    move.w  -$a(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$a(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_39b62
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_39bcc
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_39c52
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39ca4
    cmpi.w  #$80, d0
    beq.w   l_39cda
    bra.w   l_39dc4
l_39b62:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  -$8(a6), $4(a2)
    pea     ($0018).w
    jsr     (a3)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    moveq   #$4,d0
    bra.w   l_39dd4
l_39bcc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    pea     ($0328).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0009).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0018).w
    jsr     (a3)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    moveq   #$2,d0
    bra.w   l_39dd4
l_39c52:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$5, d2
    move.w  (a5), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   (a5), d0
    move.w  d0, (a4)
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c84
    addq.l  #$1, d0
l_39c84:
    asr.l   #$1, d0
    move.w  (a4), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_39c94
l_39c8e:
    move.w  (a4), d0
l_39c90:
    ext.l   d0
    bra.b   l_39c9e
l_39c94:
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c9c
    addq.l  #$1, d0
l_39c9c:
    asr.l   #$1, d0
l_39c9e:
    move.w  d0, (a4)
    bra.w   l_39b08
l_39ca4:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$5, d2
    move.w  (a5), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   (a5), d0
    move.w  d0, (a4)
    cmp.w   -$6(a6), d0
    blt.b   l_39c8e
    move.w  -$6(a6), d0
    bra.b   l_39c90
l_39cda:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_39b08
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($000F).w
    pea     ($000F).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $30(a7), a7
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
    bra.w   l_39b08
l_39dc4:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   l_39b08
l_39dd4:
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
