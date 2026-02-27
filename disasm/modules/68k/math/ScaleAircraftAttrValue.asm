; ============================================================================
; ScaleAircraftAttrValue -- Linearly interpolate one aircraft attribute between two scenario boundary values based on scenario index
; 82 bytes | $00C860-$00C8B1
; ============================================================================
ScaleAircraftAttrValue:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    move.w  $e(a7), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.w  ($00FF0002).l, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$3,d1
    jsr SignedDiv
    add.w   d2, d0
    move.w  d0, d2
    tst.w   d2
    ble.b   .l0c896
    move.w  d2, d0
    ext.l   d0
    bra.b   .l0c898
.l0c896:
    moveq   #$0,d0
.l0c898:
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bge.b   .l0c8a6
    move.w  d2, d0
    ext.l   d0
    bra.b   .l0c8ac
.l0c8a6:
    move.l  #$ff, d0
.l0c8ac:
    move.w  d0, d2
    move.l  (a7)+, d2
    rts
