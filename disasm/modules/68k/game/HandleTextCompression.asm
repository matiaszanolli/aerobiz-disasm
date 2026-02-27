; ============================================================================
; HandleTextCompression -- Display and navigate the text-based route/character information screen: decompress graphics, show player route summary with char names, browse slots, and show relation data on select.
; 914 bytes | $02434C-$0246DD
; ============================================================================
HandleTextCompression:
    move.l  $8(a6), d7
    movea.l  #$00000D64,a3
    movea.l  #$00FF13FC,a4
    movea.l  #$0003B270,a5
    moveq   #$1,d6
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    clr.w   d3
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    jsr VRAMBulkLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0019).w
    pea     ($0001).w
    jsr SetTextCursor
    cmpi.w  #$1, d4
    bne.b   .l243f4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041350).l
    bra.b   .l24400
.l243f4:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041346).l
.l24400:
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0004E0F6).l
    jsr DisplaySetup
    lea     $1c(a7), a7
    pea     ($0004E116).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    pea     ($0001).w
    pea     ($0005).w
    jsr SetTextCursor
    pea     ($0004133E).l
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr SetTextCursor
    pea     ($00041332).l
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($001A).w
    jsr SetTextCursor
    pea     ($0004132C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DecompressGraphicsData,PC)
    nop
    jsr ResourceUnload
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l244dc
    moveq   #$1,d0
    bra.b   .l244de
.l244dc:
    moveq   #$0,d0
.l244de:
    move.w  d0, -$6(a6)
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d2
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, -$4(a6)
.l24500:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    tst.w   -$6(a6)
    beq.b   .l2454e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   .l24500
.l2454e:
    clr.w   -$6(a6)
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l245d6
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    tst.w   d6
    beq.w   .l246c4
    cmpi.w  #$4, d2
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    pea     ($000C).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    add.w   d2, d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    pea     (a0, d0.w)
    jsr FormatRelationDisplay
    lea     $30(a7), a7
    clr.w   d6
    bra.w   .l246c4
.l245d6:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l245ea
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    bra.w   .l246d4
.l245ea:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l24668
    move.w  #$1, (a4)
    moveq   #$1,d6
    cmpi.w  #$1, d4
    ble.b   .l24600
    subq.w  #$1, d2
.l24600:
    tst.w   d2
    bge.w   .l246c4
    subq.w  #$4, d3
    cmpi.w  #$4, d4
    ble.b   .l24662
    moveq   #$3,d2
    tst.w   d3
    bge.b   .l24628
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bge.b   .l2461e
    addq.l  #$3, d0
.l2461e:
    asr.l   #$2, d0
    move.l  d0, d3
    lsl.w   #$2, d3
    move.w  -$2(a6), d2
.l24628:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DecompressGraphicsData,PC)
    nop
    lea     $2c(a7), a7
    bra.b   .l246c4
.l24662:
    clr.w   d3
    clr.w   d2
    bra.b   .l246c4
.l24668:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l246c4
    move.w  #$1, (a4)
    moveq   #$1,d6
    cmpi.w  #$1, d4
    ble.b   .l2467e
    addq.w  #$1, d2
.l2467e:
    cmpi.w  #$3, d2
    bgt.b   .l24698
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l246b0
.l24698:
    addq.w  #$4, d3
    cmpi.w  #$4, d4
    ble.b   .l246ac
    cmp.w   d4, d3
    blt.b   .l246a6
    clr.w   d3
.l246a6:
    clr.w   d2
    bra.w   .l24628
.l246ac:
    clr.w   d3
    bra.b   .l246be
.l246b0:
    move.w  d2, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l246c4
.l246be:
    move.w  d4, d2
    addi.w  #$ffff, d2
.l246c4:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l24500
.l246d4:
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
