; ============================================================================
; AnimateScrollEffect -- Perform a horizontal scroll animation effect when flight_active is set: ramp scroll speed up then down through 1-16 steps, ending at zero.
; 304 bytes | $023B6A-$023C99
; ============================================================================
AnimateScrollEffect:                                                  ; $023B6A
    movem.l d2-d4/a2-a3,-(sp)
    movea.l #$0001d98c,a2
    movea.l #$0d64,a3
    tst.w   ($00FF000A).l
    beq.w   .l23c94
    clr.l   -(sp)
    move.l  #$fc00,-(sp)
    pea     ($0400).w
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a3)
    lea     $0014(sp),sp
    clr.w   d2
    moveq   #$1,d4
.l23ba2:                                                ; $023BA2
    clr.w   d3
.l23ba4:                                                ; $023BA4
    add.w   d4,d2
    cmpi.w  #$0100,d2
    blt.b   .l23bb0
    subi.w  #$0100,d2
.l23bb0:                                                ; $023BB0
    add.w   d4,d3
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    cmpi.w  #$20,d3
    blt.b   .l23ba4
    addq.w  #$1,d4
    cmpi.w  #$10,d4
    ble.b   .l23ba2
    clr.w   d3
.l23be2:                                                ; $023BE2
    addi.w  #$10,d2
    cmpi.w  #$0100,d2
    blt.b   .l23bf0
    subi.w  #$0100,d2
.l23bf0:                                                ; $023BF0
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    ble.b   .l23be2
    moveq   #$10,d4
.l23c1a:                                                ; $023C1A
    clr.w   d3
.l23c1c:                                                ; $023C1C
    add.w   d4,d2
    cmpi.w  #$0100,d2
    blt.b   .l23c28
    subi.w  #$0100,d2
.l23c28:                                                ; $023C28
    add.w   d4,d3
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    cmpi.w  #$18,d3
    blt.b   .l23c1c
    subq.w  #$1,d4
    cmpi.w  #$1,d4
    bge.b   .l23c1a
    bra.b   .l23c7c
.l23c5a:                                                ; $023C5A
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0018(sp),sp
    addq.w  #$1,d2
.l23c7c:                                                ; $023C7C
    cmpi.w  #$0100,d2
    blt.b   .l23c5a
    clr.l   -(sp)
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($0001).w
    jsr     (a2)
    lea     $0010(sp),sp
.l23c94:                                                ; $023C94
    movem.l (sp)+,d2-d4/a2-a3
    rts
