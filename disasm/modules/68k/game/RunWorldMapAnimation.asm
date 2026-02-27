; ============================================================================
; RunWorldMapAnimation -- Loads and tiles the world-map graphics set; decompresses route/city tiles into VRAM and runs an animated display loop (136 frames), then resets scroll and restores map
; 1668 bytes | $039EAA-$03A52D
; ============================================================================
RunWorldMapAnimation:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$00FF1804,a2
    movea.l  #$00000D64,a3
    movea.l  #$00005092,a4
    movea.l  #$0001D8AA,a5
    jsr ResourceLoad
    jsr PreLoopInit
    move.l  #$9010, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr SetScrollQuadrant
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $2c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0006157C).l
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0006157E).l
    jsr     (a4)
    pea     ($0006159C).l
    pea     ($0013).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($00061A5C).l
    move.l  a2, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($001C).w
    pea     ($015A).w
    jsr VRAMBulkLoad
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00061BC2).l
    jsr     (a4)
    lea     $20(a7), a7
    pea     ($00061BE2).l
    pea     ($000B).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($00061EA2).l
    move.l  a2, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0052).w
    pea     ($0001).w
    jsr VRAMBulkLoad
    pea     ($0006088E).l
    move.l  a2, -(a7)
    jsr LZ_Decompress
    lea     $1c(a7), a7
    pea     ($0006010E).l
    pea     ($001E).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($00EE).w
    pea     ($0176).w
    jsr VRAMBulkLoad
    lea     $30(a7), a7
    pea     ($000620CC).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0006210C).l
    move.l  a2, -(a7)
    jsr LZ_Decompress
    pea     ($000621BC).l
    move.l  a2, d0
    addi.l  #$7d0, d0
    move.l  d0, -(a7)
    jsr LZ_Decompress
    lea     $2c(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0020).w
    pea     ($0053).w
    jsr VRAMBulkLoad
    pea     ($00062212).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    jsr LZ_Decompress
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0300).w
    jsr DrawTileGrid
    lea     $2c(a7), a7
    move.l  a2, d0
    addi.l  #$1160, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0310).w
    jsr DrawTileGrid
    move.l  a2, d0
    addi.l  #$1320, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0320).w
    jsr DrawTileGrid
    move.l  a2, d0
    addi.l  #$14e0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0330).w
    jsr DrawTileGrid
    lea     $30(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0340).w
    jsr DrawTileGrid
    pea     ($00062426).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    jsr LZ_Decompress
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0321).w
    jsr DrawTileGrid
    lea     $28(a7), a7
    move.l  a2, d0
    addi.l  #$10a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0331).w
    jsr DrawTileGrid
    move.l  a2, d0
    addi.l  #$11a0, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0341).w
    jsr DrawTileGrid
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00062762).l
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0031).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00076520,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0033).w
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00076520,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $18(a7), a7
    clr.w   d2
    clr.w   d4
l_3a21e:
    clr.w   d3
l_3a220:
    pea     ($6000).w
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$78, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$58, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$4, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    addi.l  #$300, d0
    move.l  d0, -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.b   l_3a220
    addq.w  #$1, d4
    cmpi.w  #$5, d4
    blt.b   l_3a21e
    moveq   #$1,d4
    move.w  d4, d7
    clr.w   d3
    clr.w   d2
    move.w  d7, d5
    ext.l   d5
    move.l  d5, d0
    add.l   d5, d5
    add.l   d0, d5
    lsl.l   #$7, d5
    addi.l  #$7d0, d5
    move.w  d7, d6
    ext.l   d6
    lsl.l   #$8, d6
    addi.l  #$9d0, d6
    bra.w   l_3a4be
l_3a2b4:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    cmpi.w  #$10, d0
    beq.w   l_3a4c6
    tst.w   d2
    bne.b   l_3a2dc
    clr.l   -(a7)
    pea     ($000D).w
    jsr MenuSelectEntry
    addq.l  #$8, a7
l_3a2dc:
    cmpi.w  #$28, d2
    bge.b   l_3a2e8
    subq.w  #$2, d3
    bra.w   l_3a42c
l_3a2e8:
    subq.w  #$2, d4
    subq.w  #$3, d3
    cmpi.w  #$41, d2
    bge.w   l_3a3a0
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    moveq   #$4,d1
    cmp.l   d0, d1
    bne.w   l_3a3a0
    cmpi.w  #$37, d2
    bge.b   l_3a356
    move.l  d5, d0
    add.l   d0, d0
    pea     (a2, d0.l)
    pea     ($0008).w
    pea     ($0321).w
    jsr     (a5)
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w
    jsr     (a5)
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $200(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0341).w
    jsr     (a5)
    lea     $24(a7), a7
    bra.b   l_3a392
l_3a356:
    move.l  d6, d0
    add.l   d0, d0
    pea     (a2, d0.l)
    pea     ($0008).w
    pea     ($0321).w
    jsr     (a5)
    move.l  d6, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($001C).w
    jsr GameCmd16
    lea     $20(a7), a7
l_3a392:
    addi.l  #$100, d6
    addi.l  #$180, d5
    addq.w  #$1, d7
l_3a3a0:
    cmpi.w  #$2d, d2
    bne.b   l_3a3b4
    pea     ($000A).w
    jsr LoadDisplaySet
    addq.l  #$4, a7
    bra.b   l_3a42c
l_3a3b4:
    cmpi.w  #$41, d2
    bne.b   l_3a412
    pea     ($00062212).l
    move.l  a2, d0
    addi.l  #$fa0, d0
    move.l  d0, -(a7)
    jsr LZ_Decompress
    move.l  a2, d0
    addi.l  #$1320, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0320).w
    jsr     (a5)
    move.l  a2, d0
    addi.l  #$14e0, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0330).w
    jsr     (a5)
    lea     $20(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0340).w
    jsr     (a5)
    bra.b   l_3a428
l_3a412:
    cmpi.w  #$4c, d2
    bne.b   l_3a42c
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000600EE).l
    jsr     (a4)
l_3a428:
    lea     $c(a7), a7
l_3a42c:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr SetScrollOffset
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr SetScrollOffset
    lea     $18(a7), a7
    cmpi.w  #$1, d2
    bne.b   l_3a462
    jsr ResourceUnload
l_3a462:
    cmpi.w  #$4c, d2
    bge.b   l_3a4bc
    move.w  d2, d0
    andi.l  #$1, d0
    bne.b   l_3a47a
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    bra.b   l_3a488
l_3a47a:
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, d0
    addi.l  #$7d0, d0
    move.l  d0, -(a7)
l_3a488:
    pea     ($0020).w
    pea     ($0053).w
    jsr VRAMBulkLoad
    pea     ($0002).w
    pea     ($001A).w
    move.w  d2, d0
    ext.l   d0
    moveq   #$2,d1
    jsr SignedMod
    lsl.w   #$2, d0
    movea.l  #$000600E4,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $20(a7), a7
l_3a4bc:
    addq.w  #$1, d2
l_3a4be:
    cmpi.w  #$88, d2
    blt.w   l_3a2b4
l_3a4c6:
    jsr ResourceLoad
    pea     ($0018).w
    jsr     (a3)
    jsr PreLoopInit
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollOffset
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr SetScrollOffset
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    move.l  #$9000, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    lea     $30(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollQuadrant
    jsr PreLoopInit
    jsr LoadMapTiles
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
