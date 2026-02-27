; ============================================================================
; ClearRouteSlotBit -- Clears a specific route-bit from the player's route bitmask, then sets the pending flag on every relation slot whose city pair references that route position.
; 258 bytes | $011E6C-$011F6D
; ============================================================================
ClearRouteSlotBit:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    not.l   d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    lea     (a0,d1.w), a0
    movea.l a0, a4
    and.l   d0, (a0)
    move.w  d2, d0
    ext.l   d0
    move.l  #$320, d1
    jsr Multiply32
    move.l  d0, d5
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.l  (a4), d4
    bra.b   .l11f08
.l11ecc:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11ee0
    moveq   #$0,d0
    move.b  $1(a2), d0
    bra.b   .l11ef2
.l11ee0:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11f02
    moveq   #$0,d0
    move.b  (a2), d0
.l11ef2:
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   .l11f02
    ori.b   #$80, $a(a2)
.l11f02:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l11f08:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   .l11ecc
    moveq   #$0,d0
    move.b  $4(a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    add.l   d5, d0
    movea.l  #$00FF9A20,a0
    adda.l  d0, a0
    movea.l a0, a2
    clr.w   d2
    bra.b   .l11f5a
.l11f34:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    beq.b   .l11f4e
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11f54
.l11f4e:
    ori.b   #$80, $a(a2)
.l11f54:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l11f5a:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    cmp.l   d1, d0
    blt.b   .l11f34
    movem.l (a7)+, d2-d5/a2-a4
    rts
