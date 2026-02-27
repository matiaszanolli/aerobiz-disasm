; ============================================================================
; DecompressGraphicsData -- Decompress and display character graphics and stats for the route graphics view: char portraits, compatibility tiles, and relationship values with conditional VRAM placement.
; 876 bytes | $0246DE-$024A49
; ============================================================================
DecompressGraphicsData:
    link    a6,#-$10
    movem.l d2-d6/a2-a5, -(a7)
    movea.l  #$00FF1804,a3
    movea.l  #$00000D64,a4
    movea.l  #$0004E0F4,a5
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$1,d6
    moveq   #$3,d5
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    clr.w   d4
.l247ac:
    cmpi.b  #$ff, (a2)
    beq.w   .l24a40
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l24838
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a5, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    bra.b   .l24886
.l24838:
    pea     ($0004E056).l
    pea     ($0002).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004E0CE).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($036F).w
.l24886:
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    moveq   #-$1,d3
    move.b  $a(a2), d0
    btst    #$2, d0
    beq.b   .l248a0
    clr.w   d3
    bra.b   .l248ba
.l248a0:
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l248ae
    moveq   #$10,d3
    bra.b   .l248ba
.l248ae:
    move.b  $a(a2), d0
    btst    #$0, d0
    beq.b   .l248ba
    moveq   #$8,d3
.l248ba:
    move.w  d3, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bge.b   .l24916
    clr.w   d2
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    addi.l  #$637b, d0
    move.l  d0, d3
.l248d8:
    move.w  d2, d0
    add.w   d0, d0
    move.w  d3, -$10(a6, d0.w)
    addq.l  #$1, d3
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   .l248d8
    pea     -$10(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
.l24916:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041368).l
    jsr PrintfWide
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041364).l
    jsr PrintfWide
    lea     $30(a7), a7
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, d2
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
    move.w  d0, d2
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  $10(a2), d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, d2
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$1a, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    cmpi.w  #$64, d2
    bgt.b   .l24a0e
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004135E).l
    bra.b   .l24a28
.l24a0e:
    cmpi.w  #$64, d2
    bge.b   .l24a1a
    move.w  d2, d0
    ext.l   d0
    bra.b   .l24a1c
.l24a1a:
    moveq   #$64,d0
.l24a1c:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041358).l
.l24a28:
    jsr PrintfWide
    lea     $20(a7), a7
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    blt.w   .l247ac
.l24a40:
    movem.l -$34(a6), d2-d6/a2-a5
    unlk    a6
    rts
