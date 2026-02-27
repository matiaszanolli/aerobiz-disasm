; ============================================================================
; ManageAllianceRoster -- Interactive alliance roster screen: shows char pairs, handles D-pad navigation, confirm, and cancel input
; 1558 bytes | $030D04-$031319
; ============================================================================
ManageAllianceRoster:
    link    a6,#-$320
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$00000D64,a3
    lea     -$17a(a6), a4
    movea.l  #$00FF13FC,a5
    clr.w   -$16c(a6)
    pea     ($000E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w IsAllianceSlotValid
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    beq.w   .l31310
    moveq   #$0,d2
    move.b  $4(a2), d2
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d2
    move.w  d7, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d5
    bra.w   .l30dfe
.l30d7e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    mulu.w  #$3c, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  d5, (a0,d0.w)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   d4, d3
    beq.b   .l30df8
    move.w  d4, d0
    mulu.w  #$3c, d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  d5, (a0,d0.w)
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
.l30df8:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d5
.l30dfe:
    cmp.w   d2, d5
    blt.w   .l30d7e
    clr.l   -(a7)
    pea     ($000B).w
    pea     ($000B).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    move.l  ($00047B58).l, -(a7)
    pea     -$16a(a6)
    jsr sprintf
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    pea     -$16a(a6)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0004A63A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    jsr VRAMBulkLoad
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $1c(a7), a7
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0015).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  ($00FF9A1C).l, d2
.l30ede:
    cmpi.w  #$7, d2
    blt.b   .l30ee6
    clr.w   d2
.l30ee6:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    bgt.b   .l30ef8
    addq.w  #$1, d2
    bra.b   .l30ede
.l30ef8:
    clr.w   d5
    moveq   #-$1,d3
    clr.l   -(a7)
    jsr ReadInput
    lea     $28(a7), a7
    tst.w   d0
    beq.b   .l30f10
    moveq   #$1,d0
    bra.b   .l30f12
.l30f10:
    moveq   #$0,d0
.l30f12:
    move.w  d0, -$320(a6)
    clr.w   -$2(a6)
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
.l30f24:
    tst.w   d6
    beq.w   .l310ba
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     (-$1).w
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w ClearAllianceSlot
    lea     $18(a7), a7
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0013).w
    pea     ($0002).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECA0,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447CA).l
    jsr PrintfWide
    move.w  d7, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$3c, d1
    movea.l d7, a0
    move.w  d5, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    lea     -$31e(a6), a0
    move.w  (a0,d1.w), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    cmp.w   d2, d0
    beq.b   .l30ff2
    moveq   #$0,d4
    move.b  (a2), d4
    moveq   #$0,d3
    move.b  $1(a2), d3
.l30ff2:
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($0017).w
    pea     ($0015).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0015).w
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447C6).l
    jsr PrintfWide
    pea     ($0015).w
    move.w  ($00FF128A).l, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    jsr PlaceIconTiles
    pea     ($0015).w
    moveq   #$0,d0
    move.w  ($00FF128A).l, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000447C2).l
    jsr PrintfWide
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d2, d0
    mulu.w  #$3c, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    lea     -$31e(a6), a0
    move.w  (a0,d0.w), d3
.l310ba:
    tst.w   -$320(a6)
    beq.b   .l310e0
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l310e0
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    clr.w   d6
    bra.w   .l30f24
.l310e0:
    clr.w   -$320(a6)
    clr.w   d6
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, -$2(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l31134
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l311e2
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   .l311f4
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   .l31214
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l31230
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l31256
    bra.w   .l31276
.l31134:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w GetAllianceScore
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (RunAIMainLoop,PC)
    nop
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    lea     $14(a7), a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
    beq.b   .l31190
    pea     (-$1).w
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w ClearAllianceSlot
    addq.l  #$8, a7
.l31190:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($00047B58).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a3)
    lea     $20(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    bra.w   .l3127e
.l311e2:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$1, -$16c(a6)
    bra.w   .l3127e
.l311f4:
    move.w  #$1, (a5)
    moveq   #$1,d6
    subq.w  #$1, d5
    tst.w   d5
    bge.w   .l3127e
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d5
    addi.w  #$ffff, d5
    bra.b   .l3127e
.l31214:
    move.w  #$1, (a5)
    moveq   #$1,d6
    addq.w  #$1, d5
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    cmp.w   d5, d0
    bgt.b   .l3127e
.l3122c:
    clr.w   d5
    bra.b   .l3127e
.l31230:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4
.l31238:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l31242
    clr.w   d2
.l31242:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    ble.b   .l31238
.l31250:
    cmp.w   d2, d4
    beq.b   .l3127e
    bra.b   .l3122c
.l31256:
    move.w  #$1, (a5)
    moveq   #$1,d6
    move.w  d2, d4
.l3125e:
    subq.w  #$1, d2
    tst.w   d2
    bge.b   .l31266
    moveq   #$6,d2
.l31266:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    tst.w   (a4,a0.l)
    ble.b   .l3125e
    bra.b   .l31250
.l31276:
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
.l3127e:
    cmpi.w  #$1, -$16c(a6)
    bne.w   .l30f24
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  ($000A1B28).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7
    pea     ($003E).w
    pea     ($0109).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($000725D8).l
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0008).w
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $30(a7), a7
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowPlayerChart
.l31310:
    movem.l -$348(a6), d2-d7/a2-a5
    unlk    a6
    rts
