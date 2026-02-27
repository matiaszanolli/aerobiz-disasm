; ============================================================================
; CalcOptimalTicketPrice -- Compute optimal ticket price from char stats and player cash, show purchase dialog, deduct cost if confirmed
; 1046 bytes | $00F75E-$00FB73
; ============================================================================
CalcOptimalTicketPrice:
    link    a6,#-$84
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d5
    move.l  $c(a6), d6
    lea     -$40(a6), a4
    movea.l  #$0003B270,a5
    clr.w   -$82(a6)
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    move.w  d0, d3
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharStat
    move.w  d0, d4
    moveq   #$0,d7
    move.b  $3(a3), d7
    addi.w  #$14, d7
    move.w  d4, d0
    addq.w  #$1, d0
    mulu.w  d0, d7
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d7, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d7
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$258, d0
    move.w  d4, d1
    ext.l   d1
    addq.l  #$1, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_0f82a
    addq.l  #$1, d0
l_0f82a:
    asr.l   #$1, d0
    move.w  d0, d4
    jsr ResourceLoad
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0640).w
    pea     ($0037).w
    pea     ($0070).w
    pea     ($0018).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    pea     ($0003).w
    pea     ($000B).w
    jsr SetTextCursor
    pea     ($0003EBB4).l
    jsr     (a5)
    pea     ($000E).w
    pea     ($0006).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003EBB0).l
    jsr     (a5)
    pea     ($0006).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     ($0003EB9C).l
    jsr     (a5)
    pea     ($0006).w
    pea     ($0017).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($0003EB96).l
    jsr     (a5)
    pea     ($0009).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     ($0003EB82).l
    jsr     (a5)
    lea     $30(a7), a7
    pea     ($0009).w
    pea     ($0017).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0003EB7C).l
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.l  ($000477BC).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C0).l, -(a7)
    pea     -$80(a6)
    jsr sprintf
    lea     $30(a7), a7
    pea     -$80(a6)
    move.l  a4, -(a7)
    jsr StringAppend
    jsr ResourceUnload
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $20(a7), a7
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.l  #$3, d0
    bne.w   l_0fb44
    moveq   #$0,d0
    move.w  d4, d0
    cmp.l   $6(a2), d0
    bgt.w   l_0fb2c
    jsr PreLoopInit
    move.w  d3, d0
    ext.l   d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477C8).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0faee
    move.w  #$1, -$82(a6)
    moveq   #$0,d0
    move.w  d4, d0
    sub.l   d0, $6(a2)
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d3, (a2)
    move.b  #$3, $1(a2)
    pea     ($0001).w
    clr.l   -(a7)
    jsr GameCmd16
    pea     ($000A).w
    pea     ($000A).w
    jsr GameCmd16
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0016).w
    jsr LoadCompressedGfx
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477D0).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
l_0faee:
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    bra.b   l_0fb66
l_0fb2c:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477C4).l, -(a7)
    bra.b   l_0fb5a
l_0fb44:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477CC).l, -(a7)
l_0fb5a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
l_0fb66:
    move.w  -$82(a6), d0
    movem.l -$ac(a6), d2-d7/a2-a5
    unlk    a6
    rts
