; ============================================================================
; InitMainGameS2 -- Run the main game S2 route assignment screen: display route map with aircraft tiles and slot text, handle char selection and slot navigation input, and show char comparison on confirm.
; 1446 bytes | $025254-$0257F9
; ============================================================================
InitMainGameS2:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d4
    movea.l  #$00000D64,a3
    lea     -$20(a6), a4
    lea     -$2(a6), a5
    moveq   #$1,d3
    jsr PreLoopInit
    pea     ($001E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharOccupancy,PC)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   .l252b0
    moveq   #$1,d7
    bra.b   .l252b2
.l252b0:
    moveq   #$0,d7
.l252b2:
    clr.w   (a5)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d5
    clr.w   -$22(a6)
.l252c6:
    cmpi.w  #$1, d3
    bne.w   .l2541c
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    jsr ResourceLoad
    pea     ($0002).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    pea     ($0003).w
    jsr SetTextCursor
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005F912,a0
    move.l  (a0,d0.l), -(a7)
    jsr PrintfWide
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0007).w
    pea     ($00B8).w
    pea     ($0004).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w
    pea     ($00B8).w
    pea     ($0005).w
    pea     ($0771).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    jsr ResourceUnload
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (LoadRouteMapDisplay,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    clr.w   d3
.l2541c:
    tst.w   d7
    beq.b   .l2543e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l2543e
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l252c6
.l2543e:
    clr.w   d7
    addq.w  #$1, -$22(a6)
    cmpi.w  #$1, -$22(a6)
    bne.b   .l254b4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000C).w
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
    pea     ($000C).w
    pea     ($00B0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l254a6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   .l254da
.l254b4:
    cmpi.w  #$28a, -$22(a6)
    bne.b   .l254ce
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l254a6
.l254ce:
    cmpi.w  #$514, -$22(a6)
    bne.b   .l254da
    clr.w   -$22(a6)
.l254da:
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, (a5)
    andi.w  #$20, d0
    beq.w   .l25738
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    tst.w   d6
    ble.w   .l2570c
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($0004).w
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0010).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    pea     ($0017).w
    jsr SetTextWindow
    lea     $1c(a7), a7
    cmpi.w  #$2, d2
    bne.b   .l2557a
    pea     ($000413D8).l
    jsr PrintfNarrow
    addq.l  #$4, a7
    bra.b   .l25596
.l2557a:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000413D4).l
    jsr PrintfNarrow
    addq.l  #$8, a7
.l25596:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CollectPlayerChars
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (HandleRouteSelectionS2,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    cmpi.w  #$ff, d0
    beq.w   .l25664
    move.w  d6, d0
    mulu.w  #$a, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  $4(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharCompare
    lea     $10(a7), a7
    moveq   #$1,d3
.l2560a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l2560a
.l2561a:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l2561a
    jsr ResourceLoad
    move.l  #$8000, -(a7)
    pea     ($0013).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
    bra.b   .l2566c
.l25664:
    moveq   #$1,d3
    jsr ResourceLoad
.l2566c:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0007).w
    pea     ($00B8).w
    pea     ($0004).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w
    pea     ($00B8).w
    pea     ($0005).w
    pea     ($0771).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    bra.b   .l2570e
.l2570c:
    moveq   #$1,d3
.l2570e:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (LoadRouteMapDisplay,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d6
    bra.w   .l252c6
.l25738:
    move.w  (a5), d0
    andi.w  #$10, d0
    beq.b   .l25750
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l257f0
.l25750:
    move.w  (a5), d0
    andi.w  #$8, d0
    beq.b   .l25776
    move.w  #$1, ($00FF13FC).l
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
.l25766:
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d5
.l25770:
    moveq   #$1,d3
    bra.w   .l252c6
.l25776:
    move.w  (a5), d0
    andi.w  #$4, d0
    beq.b   .l2578e
    move.w  #$1, ($00FF13FC).l
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0
    bra.b   .l25766
.l2578e:
    move.w  (a5), d0
    andi.w  #$2, d0
    beq.b   .l257d6
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
.l257a4:
    moveq   #$7,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($001E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharOccupancy,PC)
    nop
    lea     $18(a7), a7
    bra.b   .l25770
.l257d6:
    move.w  (a5), d0
    andi.w  #$1, d0
    beq.w   .l252c6
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$6, d0
    bra.b   .l257a4
.l257f0:
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
