; ============================================================================
; HandleRouteSelectionS2 -- Handles the interactive route-selection screen: reads directional input, scrolls the route list with highlight cursor, and returns the selected route index or a back-button code.
; 738 bytes | $025B62-$025E43
; ============================================================================
HandleRouteSelectionS2:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d4
    movea.l  #$00000D64,a2
    movea.l  #$0001E044,a3
    movea.l  #$00FF13FC,a4
    lea     -$c(a6), a5
    moveq   #$1,d7
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l25b98
    moveq   #$1,d0
    bra.b   .l25b9a
.l25b98:
    moveq   #$0,d0
.l25b9a:
    move.w  d0, -$a(a6)
    clr.w   d5
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    clr.w   d3
    clr.w   d2
    clr.w   d6
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    move.l  d0, -$4(a6)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
    move.l  d0, -$8(a6)
.l25bd6:
    cmpi.w  #$1, d7
    bne.b   .l25c10
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RenderPlayerDataDisplay
    lea     $2c(a7), a7
    clr.w   d7
.l25c10:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$58, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
    tst.w   -$a(a6)
    beq.b   .l25c66
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l25bd6
.l25c66:
    clr.w   -$a(a6)
    cmpi.w  #$5, d4
    ble.w   .l25d14
    move.w  d4, d0
    sub.w   d3, d0
    move.w  d0, (a5)
    cmpi.w  #$5, (a5)
    ble.b   .l25c82
    move.w  #$5, (a5)
.l25c82:
    addq.w  #$1, d6
    cmpi.w  #$1, d6
    bne.b   .l25cf4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w
    pea     ($00F0).w
    pea     ($0039).w
    pea     ($0770).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$54, d0
    move.l  d0, -(a7)
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0771).w
    jsr     (a3)
    lea     $1c(a7), a7
.l25ce6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l25d14
.l25cf4:
    cmpi.w  #$f, d6
    bne.b   .l25d0c
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l25ce6
.l25d0c:
    cmpi.w  #$1e, d6
    bne.b   .l25d14
    clr.w   d6
.l25d14:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.b   .l25d4c
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.w   .l25df6
    move.w  d3, d0
    add.w   d2, d0
    move.w  d0, d2
    bra.w   .l25dfa
.l25d4c:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l25dc2
    move.w  #$1, (a4)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bgt.b   .l25d74
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l25db8
.l25d74:
    cmpi.w  #$5, d4
    ble.b   .l25d8c
    clr.w   d2
    addq.w  #$5, d3
    cmp.w   d4, d3
    ble.b   .l25d86
    clr.w   d3
    clr.w   d2
.l25d86:
    moveq   #$1,d7
    bra.w   .l25bd6
.l25d8c:
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   .l25dac
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l25db2
.l25dac:
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l25db2:
    move.w  d0, d2
    bra.w   .l25bd6
.l25db8:
    cmpi.w  #$5, d4
    bge.w   .l25bd6
    bra.b   .l25d8c
.l25dc2:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.w   .l25bd6
    move.w  #$1, (a4)
    subq.w  #$1, d2
    tst.w   d2
    bge.w   .l25bd6
    cmpi.w  #$5, d4
    ble.b   .l25df0
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
    bge.b   .l25d86
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
    bra.b   .l25d86
.l25df0:
    clr.w   d2
    bra.w   .l25bd6
.l25df6:
    move.w  #$ff, d2
.l25dfa:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0009).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d2, d0
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
