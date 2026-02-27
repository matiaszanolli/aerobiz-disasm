; ============================================================================
; RunDestSelectLoop -- Handle map destination selection input loop: d-pad navigation over region/sub-region grid, confirm or cancel
; 396 bytes | $00C8B2-$00CA3D
; ============================================================================
RunDestSelectLoop:
    link    a6,#-$14
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF13FC,a2
    lea     -$12(a6), a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFA7D8,a5
    move.w  #$ff, d3
    clr.w   d6
    clr.w   d7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.w   d2
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l0c900
    moveq   #$1,d4
    bra.b   .l0c902
.l0c900:
    moveq   #$0,d4
.l0c902:
    clr.w   d5
    clr.w   (a2)
    clr.w   (a5)
.l0c908:
    cmpi.w  #$ff, d2
    beq.b   .l0c912
    cmp.w   d3, d2
    beq.b   .l0c96e
.l0c912:
    pea     ($000E).w
    move.l  a3, -(a7)
    pea     ($000767AE).l
    jsr MemMove
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  ($000767BC).l, (a3,a0.l)
    pea     ($0007).w
    pea     ($0038).w
    move.l  a3, -(a7)
    jsr DisplaySetup
    lea     $18(a7), a7
    cmpi.w  #$ff, d2
    beq.b   .l0c97a
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0004).w
    jsr LoadSlotGraphics
    lea     $10(a7), a7
    move.w  d2, d3
    bra.b   .l0c97a
.l0c96e:
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
.l0c97a:
    tst.w   d4
    beq.b   .l0c99c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0c99c
    pea     ($0002).w
.l0c990:
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   .l0c908
.l0c99c:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3f, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.b   .l0c9c6
    clr.w   (a2)
    clr.w   (a5)
    cmpi.w  #$ff, d2
    beq.b   .l0ca2a
    bra.b   .l0ca32
.l0c9c6:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l0c9d8
    clr.w   (a2)
    clr.w   (a5)
    move.w  #$ff, d2
    bra.b   .l0ca32
.l0c9d8:
    move.w  d5, d0
    andi.w  #$f, d0
    beq.b   .l0ca2a
    move.w  #$1, (a2)
    move.w  d5, d0
    andi.w  #$8, d0
    beq.b   .l0c9f2
    addq.w  #$1, d6
    andi.w  #$3, d6
.l0c9f2:
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l0ca00
    addq.w  #$3, d6
    andi.w  #$3, d6
.l0ca00:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0ca0a
    clr.w   d7
.l0ca0a:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0ca14
    moveq   #$1,d7
.l0ca14:
    move.w  d6, d0
    add.w   d0, d0
    add.w   d7, d0
    movea.l  #$0005F6D6,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
.l0ca2a:
    pea     ($0003).w
    bra.w   .l0c990
.l0ca32:
    move.w  d2, d0
    movem.l -$3c(a6), d2-d7/a2-a5
    unlk    a6
    rts
