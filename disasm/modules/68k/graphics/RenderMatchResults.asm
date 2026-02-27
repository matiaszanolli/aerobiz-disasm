; ============================================================================
; RenderMatchResults -- Shows match result screen with compatible char list; handles char selection and pairing input
; 1350 bytes | $037FFE-$038543
; ============================================================================
RenderMatchResults:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l $c(a6), a3
    movea.l  #$00000D64,a4
    movea.l  #$00FF13FC,a5
    move.w  #$2, -$2(a6)
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0020).w
    pea     ($000D).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
    clr.w   d2
l_3806c:
    tst.b   (a2)
    beq.b   l_380a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckCharCompat
    lea     $c(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   l_380a2
    move.w  d4, d0
    add.w   d0, d0
    move.w  d2, -$22(a6, d0.w)
    addq.w  #$1, d4
l_380a2:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_3806c
    tst.w   d4
    ble.b   l_380bc
    move.w  d4, d0
    addi.w  #$ffff, d0
    move.w  d0, -$26(a6)
    bra.b   l_380e4
l_380bc:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($0004863A).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    move.w  #$ff, d0
    bra.w   l_3853a
l_380e4:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CheckMatchSlots,PC)
    nop
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_38120
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_38120:
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawCharDetailPanel
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FB2).l
    jsr PrintfWide
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000C).w
    clr.l   -(a7)
    jsr PlaceIconPair
    pea     ($0001).w
    pea     ($0013).w
    pea     ($0001).w
    jsr PlaceIconPair
    pea     ($0001).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0002).w
    jsr PlaceIconTiles
    pea     ($0001).w
    pea     ($000D).w
    jsr SetTextCursor
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00044FAE).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0014).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FAA).l
    jsr PrintfWide
    tst.w   -$26(a6)
    bne.b   l_3822a
    move.w  #$1, -$28(a6)
    bra.b   l_3822e
l_3822a:
    clr.w   -$28(a6)
l_3822e:
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_38242
    moveq   #$1,d7
    bra.b   l_38244
l_38242:
    moveq   #$0,d7
l_38244:
    clr.w   -$24(a6)
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
    clr.w   d2
    clr.w   d4
    clr.w   d3
    bra.w   l_38532
l_3825c:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   l_382cc
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0040).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0040).w
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
l_382be:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_382ec
l_382cc:
    cmpi.w  #$f, d3
    bne.b   l_382e4
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_382be
l_382e4:
    cmpi.w  #$1e, d3
    bne.b   l_382ec
    clr.w   d3
l_382ec:
    cmpi.w  #$1, d6
    bne.b   l_38320
    pea     ($0002).w
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$22(a6, d0.w), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharStats
    lea     $14(a7), a7
    clr.w   d6
l_38320:
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    move.w  -$22(a6, d1.w), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    bne.b   l_38354
    pea     ($0001).w
    pea     ($000A).w
    pea     ($001D).w
    clr.l   -(a7)
    jsr (GameLoopExit,PC)
    nop
    lea     $10(a7), a7
l_38354:
    tst.w   d7
    beq.b   l_38368
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_38526
l_38368:
    clr.w   d7
    move.w  -$24(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$24(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_383b0
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38448
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38456
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_3846c
    cmpi.w  #$80, d0
    beq.w   l_38482
    bra.w   l_38514
l_383b0:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    add.w   d1, d1
    move.w  -$22(a6, d1.w), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)
    beq.b   l_38402
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$22(a6, d0.w), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr SetHighNibble
    addq.l  #$8, a7
    moveq   #$1,d2
l_383ec:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d2, d0
    bra.w   l_3853a
l_38402:
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048646).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    pea     ($001E).w
    jsr PollInputChange
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $2c(a7), a7
    clr.w   d6
    bra.w   l_3851c
l_38448:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d2
    bra.b   l_383ec
l_38456:
    move.w  #$1, (a5)
    moveq   #$1,d6
    subq.w  #$1, d4
    tst.w   d4
    bge.w   l_3851c
    move.w  -$26(a6), d4
    bra.w   l_3851c
l_3846c:
    move.w  #$1, (a5)
    moveq   #$1,d6
    addq.w  #$1, d4
    cmp.w   -$26(a6), d4
    ble.w   l_3851c
    clr.w   d4
    bra.w   l_3851c
l_38482:
    clr.w   (a5)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CheckMatchSlots,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_3851c
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
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
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    moveq   #$1,d6
    bra.b   l_3851c
l_38514:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
l_3851c:
    cmpi.w  #$1, -$28(a6)
    bne.b   l_38526
    clr.w   d6
l_38526:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
l_38532:
    cmpi.w  #$ff, d2
    bne.w   l_3825c
l_3853a:
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts
