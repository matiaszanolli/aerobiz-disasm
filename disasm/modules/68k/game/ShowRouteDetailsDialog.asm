; ============================================================================
; ShowRouteDetailsDialog -- Draws a pop-up dialog showing route details; fills tile rectangles for text rows and renders city-pair info.
; 730 bytes | $011014-$0112ED
; ============================================================================
ShowRouteDetailsDialog:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    movea.l  #$0003B246,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$0001E0B8,a5
    move.l  #$8000, -(a7)
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($075C).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($000B).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    pea     ($075D).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000D).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    pea     ($075E).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000F).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    move.l  ($000A1B2C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    pea     ($0012).w
    pea     ($03E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072658).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0009).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($00072664).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000D).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($00072670).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000F).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    pea     ($0002).w
    pea     ($0037).w
    jsr     (a5)
    lea     $24(a7), a7
    cmpi.w  #$4, d3
    bge.w   l_112dc
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.w   l_112dc
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000B).w
    pea     ($0004).w
    jsr SetTextWindow
    pea     ($0002).w
    pea     ($0037).w
    jsr     (a5)
    lea     $18(a7), a7
    cmpi.b  #$6, $1(a2)
    beq.b   l_11210
    pea     ($0001).w
    pea     ($0640).w
    clr.l   -(a7)
    pea     ($0058).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    pea     ($0009).w
    pea     ($0004).w
    jsr     (a4)
    lea     $20(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047818,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
l_1120c:
    addq.l  #$4, a7
    bra.b   l_11274
l_11210:
    cmpi.w  #$3, $6(a2)
    bne.b   l_1122a
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    bra.b   l_1122e
l_1122a:
    moveq   #$0,d2
    move.b  (a2), d2
l_1122e:
    pea     ($0009).w
    pea     ($0004).w
    jsr     (a4)
    addq.l  #$8, a7
    cmpi.w  #$3, d2
    bne.b   l_1124a
    pea     ($0003F116).l
l_11246:
    jsr     (a3)
    bra.b   l_1120c
l_1124a:
    cmpi.w  #$2, d2
    bne.b   l_11258
    pea     ($0003F10A).l
    bra.b   l_11246
l_11258:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F106).l
    jsr PrintfWide
    addq.l  #$8, a7
l_11274:
    moveq   #$0,d2
    move.b  $1(a2), d2
    addi.w  #$ffff, d2
    pea     ($000D).w
    pea     ($0004).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$000477E8,a0
    move.l  (a0,d0.w), -(a7)
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteRevenue,PC)
    nop
    move.w  d0, d3
    pea     ($000F).w
    pea     ($0004).w
    jsr     (a4)
    lea     $1c(a7), a7
    cmpi.w  #$c, d3
    bgt.b   l_112d0
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F0FA).l
    jsr     (a3)
    bra.b   l_112e4
l_112d0:
    pea     ($0003F0EC).l
    jsr     (a3)
    addq.l  #$4, a7
    bra.b   l_112e4
l_112dc:
    pea     ($0002).w
    clr.l   -(a7)
    jsr     (a5)
l_112e4:
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts
