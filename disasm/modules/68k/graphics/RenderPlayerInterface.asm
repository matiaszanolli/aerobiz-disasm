; ============================================================================
; RenderPlayerInterface -- Displays player pairing interface with compat bars; handles up/down selection and confirm/cancel
; 2326 bytes | $03857E-$038E93
; ============================================================================
RenderPlayerInterface:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a4
    movea.l  #$0003AB2C,a5
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $20(a7), a7
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  $a(a6), d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.w  d0, -$a(a6)
    cmpi.w  #$9, -$a(a6)
    bge.b   l_385f2
    move.w  -$a(a6), d0
    ext.l   d0
    bra.b   l_385f4
l_385f2:
    moveq   #$9,d0
l_385f4:
    move.w  d0, -$a(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048602).l, -(a7)
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
    beq.b   l_38634
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_38634:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0002).w
    pea     ($0002).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FDE).l
    jsr PrintfWide
    pea     ($0002).w
    pea     ($000C).w
    clr.l   -(a7)
    jsr PlaceIconPair
    lea     $2c(a7), a7
    pea     ($0002).w
    pea     ($0013).w
    pea     ($0001).w
    jsr PlaceIconPair
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0002).w
    jsr PlaceIconTiles
    pea     ($0002).w
    pea     ($000D).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    pea     ($00044FDA).l
    jsr PrintfWide
    lea     $2c(a7), a7
    pea     ($0002).w
    pea     ($0014).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FD6).l
    jsr PrintfWide
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d4
    cmpi.w  #$7, d4
    bge.b   l_3872c
    move.w  d4, d3
    ext.l   d3
    bra.b   l_3872e
l_3872c:
    moveq   #$7,d3
l_3872e:
    pea     ($033E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    move.w  d4, d3
    addi.w  #$fff9, d3
    tst.w   d3
    ble.b   l_3877c
    pea     ($033E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3877c:
    clr.w   d2
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FD2).l
    jsr PrintfNarrow
    moveq   #$1,d2
    moveq   #$1,d5
    moveq   #$E,d7
    clr.w   d6
l_387a2:
    move.w  d6, d0
    addi.w  #$2d7f, d0
    move.w  d6, d1
    add.w   d1, d1
    move.w  d0, -$32(a6, d1.w)
    addq.w  #$1, d6
    cmpi.w  #$14, d6
    blt.b   l_387a2
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    move.w  #$1, -$36(a6)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($00044FCE).l
    jsr PrintfWide
    lea     $2c(a7), a7
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a4)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FCA).l
    jsr PrintfWide
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DiagonalWipe
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC6).l
    jsr PrintfNarrow
    addq.l  #$8, a7
    move.w  -$a(a6), d0
    ext.l   d0
    subq.l  #$1, d0
    bgt.b   l_388fa
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$36(a6)
l_388fa:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3890c
    moveq   #$1,d6
    bra.b   l_3890e
l_3890c:
    moveq   #$0,d6
l_3890e:
    clr.w   -$34(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$0,d0
    move.w  d0, -$38(a6)
    andi.l  #$ffff, d0
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -$4(a6)
    move.l  #$33e, -$8(a6)
l_38942:
    addq.w  #$1, -$38(a6)
    cmpi.w  #$1, -$38(a6)
    bne.b   l_389c4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.l  -$4(a6), -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
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
    move.l  -$4(a6), -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$48, d0
    move.l  d0, -(a7)
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
l_389b6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_389ea
l_389c4:
    cmpi.w  #$f, -$38(a6)
    bne.b   l_389de
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_389b6
l_389de:
    cmpi.w  #$1e, -$38(a6)
    bne.b   l_389ea
    clr.w   -$38(a6)
l_389ea:
    tst.w   d6
    beq.b   l_389fe
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_38942
l_389fe:
    clr.w   d6
    move.w  -$34(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$34(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_38a46
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38aba
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38b00
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_38c82
    cmpi.w  #$80, d0
    beq.w   l_38dd2
    bra.w   l_38e6e
l_38a46:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    moveq   #$2,d0
    bra.w   l_38e8a
l_38aba:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    jsr ClearTileArea
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    moveq   #$0,d0
    bra.w   l_38e8a
l_38b00:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d2
    move.w  -$a(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   l_38b54
    cmpi.w  #$1, -$a(a6)
    ble.b   l_38b54
    tst.w   -$36(a6)
    bne.b   l_38b54
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$36(a6)
l_38b54:
    tst.w   d2
    ble.b   l_38b94
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC2).l
    jsr PrintfNarrow
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addi.l  #$d, d0
    move.l  d0, -(a7)
    jsr DiagonalWipe
    lea     $1c(a7), a7
l_38b94:
    cmpi.w  #$1, d2
    ble.b   l_38ba0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_38ba2
l_38ba0:
    moveq   #$1,d0
l_38ba2:
    move.w  d0, d2
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBE).l
    jsr PrintfWide
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $14(a7), a7
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d4
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    ble.b   l_38c04
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38c06
l_38c04:
    moveq   #$0,d3
l_38c06:
    cmpi.w  #$7, d3
    bge.b   l_38c3a
    pea     ($077E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000C).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_38c3a:
    cmpi.w  #$7, d4
    bge.b   l_38c46
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38c48
l_38c46:
    moveq   #$7,d3
l_38c48:
    cmpi.w  #$7, d3
    bge.w   l_38e7a
    pea     ($077E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000B).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_38c72:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   l_38e7a
l_38c82:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d2
    cmp.w   -$a(a6), d2
    bgt.b   l_38cda
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBA).l
    jsr PrintfWide
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DiagonalWipe
    lea     $1c(a7), a7
l_38cda:
    cmp.w   -$a(a6), d2
    bge.b   l_38ce4
    move.w  d2, d0
    bra.b   l_38ce8
l_38ce4:
    move.w  -$a(a6), d0
l_38ce8:
    ext.l   d0
    move.w  d0, d2
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FB6).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    move.w  -$a(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    bgt.b   l_38d4e
    cmpi.w  #$1, -$36(a6)
    bne.b   l_38d4e
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$36(a6)
l_38d4e:
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d4
    cmpi.w  #$7, d4
    bge.b   l_38d78
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38d7a
l_38d78:
    moveq   #$7,d3
l_38d7a:
    move.l  -$8(a6), -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    moveq   #$7,d0
    cmp.l   d3, d0
    ble.b   l_38db0
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38db2
l_38db0:
    moveq   #$7,d3
l_38db2:
    tst.w   d3
    ble.w   l_38e7a
    move.l  -$8(a6), -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    bra.w   l_38c72
l_38dd2:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_38e7a
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
    move.l  #$8000, -(a7)
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
    move.l  ($00048602).l, -(a7)
    move.w  $a(a6), d0
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
    bra.b   l_38e7a
l_38e6e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_38e7a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   l_38942
l_38e8a:
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts
