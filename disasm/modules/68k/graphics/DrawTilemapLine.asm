; ============================================================================
; DrawTilemapLine -- Draws a Bresenham-style line in tile-map RAM: given two (col, row) endpoints and a tile palette word, uses integer error-accumulation to step along the longer axis, writing the tile attribute word into the VDP background-A tilemap buffer at each point.
; 498 bytes | $01DA34-$01DC25
; ============================================================================
DrawTilemapLine:
    link    a6,#-$10
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $10(a6), d2
    move.l  $14(a6), d3
    move.l  $8(a6), d5
    move.l  $c(a6), d6
    move.l  $18(a6), d7
    movea.l $1c(a6), a3
    lea     -$4(a6), a4
    lea     -$2(a6), a1
    move.w  d7, d0
    moveq   #$C,d1
    lsl.w   d1, d0
    move.w  d0, -$e(a6)
    move.w  d7, d0
    lsl.w   #$8, d0
    move.w  d0, -$c(a6)
    move.w  d7, d0
    lsl.w   #$4, d0
    move.w  d0, -$a(a6)
    move.w  d7, -$8(a6)
    cmpi.w  #$20, d5
    bne.b   l_1da94
    cmpi.w  #$22, d6
    bne.b   l_1da94
    cmpi.w  #$dc, d2
    bne.b   l_1da94
    cmpi.w  #$66, d3
    bne.b   l_1da94
    subq.w  #$1, d6
l_1da94:
    move.w  d2, d0
    sub.w   d5, d0
    move.w  d0, (a1)
    cmp.w   d3, d6
    ble.b   l_1daa4
    move.w  d6, d0
    sub.w   d3, d0
    bra.b   l_1daa8
l_1daa4:
    move.w  d3, d0
    sub.w   d6, d0
l_1daa8:
    move.w  d0, (a4)
    cmp.w   d2, d5
    bge.b   l_1dab2
    cmp.w   d3, d6
    blt.b   l_1daba
l_1dab2:
    cmp.w   d2, d5
    ble.b   l_1dabe
    cmp.w   d3, d6
    ble.b   l_1dabe
l_1daba:
    moveq   #$1,d0
    bra.b   l_1dac0
l_1dabe:
    moveq   #-$1,d0
l_1dac0:
    move.w  d0, -$6(a6)
    move.w  (a1), d0
    cmp.w   (a4), d0
    ble.w   l_1db76
    cmp.w   d2, d5
    ble.b   l_1dad4
    move.w  d2, d5
    move.w  d3, d6
l_1dad4:
    move.w  (a1), d0
    ext.l   d0
    bge.b   l_1dadc
    addq.l  #$1, d0
l_1dadc:
    asr.l   #$1, d0
    move.w  d0, d4
    move.w  d5, d3
    move.w  d5, d7
    add.w   (a1), d7
    bra.w   l_1db6c
l_1daea:
    tst.w   d3
    bge.b   l_1daf6
    move.w  d3, d2
    addi.w  #$100, d2
    bra.b   l_1db06
l_1daf6:
    cmpi.w  #$100, d3
    blt.b   l_1db04
    move.w  d3, d2
    addi.w  #$ff00, d2
    bra.b   l_1db06
l_1db04:
    move.w  d3, d2
l_1db06:
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1
    andi.l  #$1, d1
    add.l   d1, d1
    adda.l  d1, a0
    move.w  d6, d0
    ext.l   d0
    asr.l   #$3, d0
    moveq   #$A,d1
    lsl.l   d1, d0
    adda.l  d0, a0
    move.w  d6, d0
    andi.l  #$7, d0
    lsl.l   #$2, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    movea.l  #$0005F9B6,a0
    move.w  (a0,d0.w), d0
    and.w   d0, (a2)
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    or.w    d0, (a2)
    sub.w   (a4), d4
    tst.w   d4
    bge.b   l_1db6a
    add.w   (a1), d4
    add.w   -$6(a6), d6
l_1db6a:
    addq.w  #$1, d3
l_1db6c:
    cmp.w   d7, d3
    ble.w   l_1daea
    bra.w   l_1dc1c
l_1db76:
    cmp.w   d3, d6
    ble.b   l_1db7e
    move.w  d3, d6
    move.w  d2, d5
l_1db7e:
    move.w  (a4), d0
    ext.l   d0
    bge.b   l_1db86
    addq.l  #$1, d0
l_1db86:
    asr.l   #$1, d0
    move.w  d0, d4
    move.w  d6, d3
    move.w  d6, d7
    add.w   (a4), d7
    bra.w   l_1dc16
l_1db94:
    tst.w   d5
    bge.b   l_1dba0
    move.w  d5, d2
    addi.w  #$100, d2
    bra.b   l_1dbb0
l_1dba0:
    cmpi.w  #$100, d5
    blt.b   l_1dbae
    move.w  d5, d2
    addi.w  #$ff00, d2
    bra.b   l_1dbb0
l_1dbae:
    move.w  d5, d2
l_1dbb0:
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1
    andi.l  #$1, d1
    add.l   d1, d1
    adda.l  d1, a0
    move.w  d3, d0
    ext.l   d0
    asr.l   #$3, d0
    moveq   #$A,d1
    lsl.l   d1, d0
    adda.l  d0, a0
    move.w  d3, d0
    andi.l  #$7, d0
    lsl.l   #$2, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    movea.l  #$0005F9B6,a0
    move.w  (a0,d0.w), d0
    and.w   d0, (a2)
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    or.w    d0, (a2)
    sub.w   (a1), d4
    tst.w   d4
    bge.b   l_1dc14
    add.w   (a4), d4
    add.w   -$6(a6), d5
l_1dc14:
    addq.w  #$1, d3
l_1dc16:
    cmp.w   d7, d3
    ble.w   l_1db94
l_1dc1c:
    movem.l -$34(a6), d2-d7/a2-a4
    unlk    a6
    rts
