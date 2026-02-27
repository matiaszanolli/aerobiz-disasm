; ============================================================================
; DrawTilemapLineWrap -- Draws a line between two tile-map coordinates using Bresenham-style stepping with wrap correction: writes tile-attribute words into BG-A tilemap buffer for each step along the major axis.
; 516 bytes | $01DC26-$01DE29
; ============================================================================
DrawTilemapLineWrap:                                              ; $01DC26
    link    a6,#-$10
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0010(a6),d2
    move.l  $0014(a6),d3
    move.l  $0008(a6),d5
    move.l  $000c(a6),d6
    move.l  $0018(a6),d7
    movea.l $001c(a6),a3
    lea     -$0002(a6),a4
    lea     -$0004(a6),a1
    move.w  d7,d0
    moveq   #$c,d1
    lsl.w   d1,d0
    move.w  d0,-$000e(a6)
    move.w  d7,d0
    lsl.w   #$8,d0
    move.w  d0,-$000c(a6)
    move.w  d7,d0
    lsl.w   #$4,d0
    move.w  d0,-$000a(a6)
    move.w  d7,-$0008(a6)
    cmpi.w  #$20,d5
    bne.b   .l1dc86
    cmpi.w  #$22,d6
    bne.b   .l1dc86
    cmpi.w  #$dc,d2
    bne.b   .l1dc86
    cmpi.w  #$66,d3
    bne.b   .l1dc86
    subq.w  #$1,d6
.l1dc86:                                                ; $01DC86
    move.w  d2,d0
    sub.w   d5,d0
    move.w  d0,(a4)
    move.w  #$0100,d4
    sub.w   d2,d4
    add.w   d5,d4
    cmp.w   (a4),d4
    bge.b   .l1dc9e
    move.w  d4,(a4)
    addi.w  #$0100,d5
.l1dc9e:                                                ; $01DC9E
    cmp.w   d3,d6
    ble.b   .l1dca8
    move.w  d6,d0
    sub.w   d3,d0
    bra.b   .l1dcac
.l1dca8:                                                ; $01DCA8
    move.w  d3,d0
    sub.w   d6,d0
.l1dcac:                                                ; $01DCAC
    move.w  d0,(a1)
    cmp.w   d2,d5
    bge.b   .l1dcb6
    cmp.w   d3,d6
    blt.b   .l1dcbe
.l1dcb6:                                                ; $01DCB6
    cmp.w   d2,d5
    ble.b   .l1dcc2
    cmp.w   d3,d6
    ble.b   .l1dcc2
.l1dcbe:                                                ; $01DCBE
    moveq   #$1,d0
    bra.b   .l1dcc4
.l1dcc2:                                                ; $01DCC2
    moveq   #-$1,d0
.l1dcc4:                                                ; $01DCC4
    move.w  d0,-$0006(a6)
    move.w  (a4),d0
    cmp.w   (a1),d0
    ble.w   .l1dd7a
    cmp.w   d2,d5
    ble.b   .l1dcd8
    move.w  d2,d5
    move.w  d3,d6
.l1dcd8:                                                ; $01DCD8
    move.w  (a4),d0
    ext.l   d0
    bge.b   .l1dce0
    addq.l  #$1,d0
.l1dce0:                                                ; $01DCE0
    asr.l   #$1,d0
    move.w  d0,d4
    move.w  d5,d3
    move.w  d5,d7
    add.w   (a4),d7
    bra.w   .l1dd70
.l1dcee:                                                ; $01DCEE
    tst.w   d3
    bge.b   .l1dcfa
    move.w  d3,d2
    addi.w  #$0100,d2
    bra.b   .l1dd0a
.l1dcfa:                                                ; $01DCFA
    cmpi.w  #$0100,d3
    blt.b   .l1dd08
    move.w  d3,d2
    addi.w  #$ff00,d2
    bra.b   .l1dd0a
.l1dd08:                                                ; $01DD08
    move.w  d3,d2
.l1dd0a:                                                ; $01DD0A
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0
    lsl.l   #$5,d0
    lea     (a3,d0.l),a0
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1
    andi.l  #$1,d1
    add.l   d1,d1
    adda.l  d1,a0
    move.w  d6,d0
    ext.l   d0
    asr.l   #$3,d0
    moveq   #$a,d1
    lsl.l   d1,d0
    adda.l  d0,a0
    move.w  d6,d0
    andi.l  #$7,d0
    lsl.l   #$2,d0
    adda.l  d0,a0
    movea.l a0,a2
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    movea.l #$0005f9b6,a0
    move.w  (a0,d0.w),d0
    and.w   d0,(a2)
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    move.w  -$e(a6,d0.w),d0
    or.w    d0,(a2)
    sub.w   (a1),d4
    tst.w   d4
    bge.b   .l1dd6e
    add.w   (a4),d4
    add.w   -$0006(a6),d6
.l1dd6e:                                                ; $01DD6E
    addq.w  #$1,d3
.l1dd70:                                                ; $01DD70
    cmp.w   d7,d3
    ble.w   .l1dcee
    bra.w   .l1de20
.l1dd7a:                                                ; $01DD7A
    cmp.w   d3,d6
    ble.b   .l1dd82
    move.w  d3,d6
    move.w  d2,d5
.l1dd82:                                                ; $01DD82
    move.w  (a1),d0
    ext.l   d0
    bge.b   .l1dd8a
    addq.l  #$1,d0
.l1dd8a:                                                ; $01DD8A
    asr.l   #$1,d0
    move.w  d0,d4
    move.w  d6,d3
    move.w  d6,d7
    add.w   (a1),d7
    bra.w   .l1de1a
.l1dd98:                                                ; $01DD98
    tst.w   d5
    bge.b   .l1dda4
    move.w  d5,d2
    addi.w  #$0100,d2
    bra.b   .l1ddb4
.l1dda4:                                                ; $01DDA4
    cmpi.w  #$0100,d5
    blt.b   .l1ddb2
    move.w  d5,d2
    addi.w  #$ff00,d2
    bra.b   .l1ddb4
.l1ddb2:                                                ; $01DDB2
    move.w  d5,d2
.l1ddb4:                                                ; $01DDB4
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0
    lsl.l   #$5,d0
    lea     (a3,d0.l),a0
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1
    andi.l  #$1,d1
    add.l   d1,d1
    adda.l  d1,a0
    move.w  d3,d0
    ext.l   d0
    asr.l   #$3,d0
    moveq   #$a,d1
    lsl.l   d1,d0
    adda.l  d0,a0
    move.w  d3,d0
    andi.l  #$7,d0
    lsl.l   #$2,d0
    adda.l  d0,a0
    movea.l a0,a2
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    movea.l #$0005f9b6,a0
    move.w  (a0,d0.w),d0
    and.w   d0,(a2)
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    move.w  -$e(a6,d0.w),d0
    or.w    d0,(a2)
    sub.w   (a4),d4
    tst.w   d4
    bge.b   .l1de18
    add.w   (a1),d4
    add.w   -$0006(a6),d5
.l1de18:                                                ; $01DE18
    addq.w  #$1,d3
.l1de1a:                                                ; $01DE1A
    cmp.w   d7,d3
    ble.w   .l1dd98
.l1de20:                                                ; $01DE20
    movem.l -$0034(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $4E56,$0000,$42A7                                ; $01DE2A
; === Translated block $01DE30-$01DE92 ===
; 2 functions, 98 bytes
