; ============================================================================
; FindAvailSlot -- Scans all 32 route positions for a player's relation slots, collecting city-pair route bits present in the global mask but not yet claimed.
; 226 bytes | $011D8A-$011E6B
; ============================================================================
FindAvailSlot:
    link    a6,#-$8
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $10(a6), d1
    lea     -$8(a6), a3
    lea     $a(a6), a1
    move.w  (a1), d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d6
    moveq   #$0,d3
    moveq   #$1,d0
    move.l  d0, (a3)
    clr.w   d4
    move.w  (a1), d0
    mulu.w  #$24, d0
    movea.l  #$00FF001C,a0
    move.b  (a0,d0.w), -$1(a6)
    bra.w   .l11e58
.l11dca:
    move.l  $c(a6), d0
    and.l   (a3), d0
    beq.w   .l11e52
    move.w  (a1), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  -$1(a6), d0
    move.w  d0, -$4(a6)
    clr.w   d5
    bra.b   .l11e4c
.l11df4:
    move.b  $a(a2), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    beq.b   .l11e46
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    bne.b   .l11e26
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d2
    lsl.l   d0, d2
    move.l  d6, d0
    and.l   d2, d0
    beq.b   .l11e26
    move.l  d1, d0
    and.l   d2, d0
    bne.b   .l11e26
    or.l    d2, d3
.l11e26:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bne.b   .l11e46
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d2
    lsl.l   d0, d2
    move.l  d6, d0
    and.l   d2, d0
    beq.b   .l11e46
    move.l  d1, d0
    and.l   d2, d0
    bne.b   .l11e46
    or.l    d2, d3
.l11e46:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d5
.l11e4c:
    cmp.w   -$4(a6), d5
    blt.b   .l11df4
.l11e52:
    move.l  (a3), d0
    add.l   d0, (a3)
    addq.w  #$1, d4
.l11e58:
    cmpi.w  #$20, d4
    bcs.w   .l11dca
    move.l  d3, d0
    movem.l -$24(a6), d2-d6/a2-a3
    unlk    a6
    rts
