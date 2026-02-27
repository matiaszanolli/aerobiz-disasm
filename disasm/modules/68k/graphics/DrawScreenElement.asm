; ============================================================================
; DrawScreenElement -- Draws a char attribute tile panel with stat bar and level delta; computes stat delta vs baseline, decompresses the bar graphic, and navigates with Up/Down/A/B input.
; 1878 bytes | $0154F8-$015C4D
; ============================================================================
DrawScreenElement:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a4
    lea     -$2e(a6), a5
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, -$32(a6)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, -$34(a6)
    move.l  a2, -(a7)
    jsr GetByteField4
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
    move.w  d0, (a5)
    moveq   #$0,d6
    move.b  $b(a2), d6
    cmpi.w  #$9, (a5)
    bge.b   .l155a0
    move.w  (a5), d0
    ext.l   d0
    bra.b   .l155a2
.l155a0:
    moveq   #$9,d0
.l155a2:
    move.w  d0, (a5)
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, d3
    move.w  d0, -$2(a6)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$12,d7
    clr.w   d2
.l155c8:
    move.w  d2, d0
    addi.w  #$2d7f, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$2a(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    blt.b   .l155c8
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $c(a7), a7
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   .l1565a
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
    bra.b   .l15684
.l1565a:
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
.l15684:
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F854).l
    jsr PrintfWide
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l156c6
    moveq   #$1,d2
    bra.b   .l156c8
.l156c6:
    moveq   #$0,d2
.l156c8:
    clr.w   -$2c(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d4
    clr.w   -$36(a6)
    bra.w   .l15bc0
.l156e2:
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F850).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    tst.w   d2
    beq.b   .l1571a
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l15bb4
.l1571a:
    clr.w   d2
    addq.w  #$1, -$36(a6)
    cmpi.w  #$1, -$36(a6)
    bne.b   .l157a4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
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
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l15796:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l157ca
.l157a4:
    cmpi.w  #$f, -$36(a6)
    bne.b   .l157be
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l15796
.l157be:
    cmpi.w  #$1e, -$36(a6)
    bne.b   .l157ca
    clr.w   -$36(a6)
.l157ca:
    move.w  -$2c(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, -$2c(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l15808
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l158f4
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15924
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15a80
    bra.w   .l15ba8
.l15808:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   -$2(a6), d3
    beq.w   .l15bc8
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d6, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l15840
    moveq   #$0,d0
    move.b  $3(a2), d0
    bra.b   .l15844
.l15840:
    move.w  d6, d0
    ext.l   d0
.l15844:
    move.b  d0, $3(a2)
    move.b  -$31(a6), d0
    add.b   $3(a2), d0
    moveq   #$0,d1
    move.b  (a2), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    move.b  -$33(a6), d0
    add.b   $3(a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$32(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F84C).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $20(a7), a7
    move.w  -$34(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F848).l
.l158e8:
    jsr PrintfNarrow
    addq.l  #$8, a7
    bra.w   .l15bc8
.l158f4:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    addq.l  #$8, a7
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    move.l  d0, -(a7)
    pea     ($0003F844).l
    bra.b   .l158e8
.l15924:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d3
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   .l15972
    cmpi.w  #$1, (a5)
    ble.b   .l15972
    tst.w   -$30(a6)
    bne.b   .l15972
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
.l15972:
    tst.w   d3
    ble.b   .l1598e
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l1598e:
    cmpi.w  #$1, d3
    ble.b   .l1599a
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1599c
.l1599a:
    moveq   #$1,d0
.l1599c:
    move.w  d0, d3
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F840).l
    jsr PrintfWide
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $14(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d6
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    ble.b   .l159fe
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15a00
.l159fe:
    moveq   #$0,d5
.l15a00:
    cmpi.w  #$7, d5
    bge.b   .l15a36
    pea     ($077E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
.l15a36:
    cmpi.w  #$7, d6
    bge.b   .l15a42
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15a44
.l15a42:
    moveq   #$7,d5
.l15a44:
    cmpi.w  #$7, d5
    bge.w   .l15bb4
    pea     ($077E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000F).w
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
.l15a6e:
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l15bb4
.l15a80:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d3
    cmp.w   (a5), d3
    bgt.b   .l15aa6
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l15aa6:
    cmp.w   (a5), d3
    bge.b   .l15aae
    move.w  d3, d0
    bra.b   .l15ab0
.l15aae:
    move.w  (a5), d0
.l15ab0:
    ext.l   d0
    move.w  d0, d3
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F83C).l
    jsr PrintfWide
    lea     $10(a7), a7
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    bgt.b   .l15b24
    cmpi.w  #$1, -$30(a6)
    bne.b   .l15b24
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
.l15b24:
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d6
    cmpi.w  #$7, d6
    bge.b   .l15b4e
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15b50
.l15b4e:
    moveq   #$7,d5
.l15b50:
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    moveq   #$7,d0
    cmp.l   d5, d0
    ble.b   .l15b88
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15b8a
.l15b88:
    moveq   #$7,d5
.l15b8a:
    tst.w   d5
    ble.b   .l15bb4
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    bra.w   .l15a6e
.l15ba8:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l15bb4:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
.l15bc0:
    cmpi.w  #$ff, d4
    bne.w   .l156e2
.l15bc8:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationAction
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationResult
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts
