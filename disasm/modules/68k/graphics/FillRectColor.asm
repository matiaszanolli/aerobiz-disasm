; ============================================================================
; FillRectColor -- Fills a rectangular area of the background plane with solid color tiles using DisplaySetup and GameCommand $1A; takes width and height in tile units
; 190 bytes | $03D1BA-$03D277
; ============================================================================
FillRectColor:
    link    a6,#-$20
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    lea     -$20(a6), a2
    movea.l  #$00000D64,a3
    tst.w   d3
    ble.w   l_3d26e
    tst.w   d2
    ble.w   l_3d26e
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    pea     ($0010).w
    pea     ($0030).w
    move.l  a2, -(a7)
    jsr DisplaySetup
    pea     ($0020).w
    pea     ($2222).w
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($18C0).w
    move.l  a2, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $18(a7), a7
    move.l  #$e0c6, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.l  #$e0c6, -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
l_3d26e:
    movem.l -$30(a6), d2-d3/a2-a3
    unlk    a6
    rts
