; ============================================================================
; UpdateRouteRevenue -- Iterates a player's four route slots; accumulates CalcRouteValue output for active (status=3) slots and clears status on orphaned placeholder (status=6) slots.
; 264 bytes | $011F6E-$012075
; ============================================================================
UpdateRouteRevenue:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
.l11f9e:
    cmpi.b  #$3, $1(a2)
    bne.b   .l11ff4
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmpi.b  #$20, (a2)
    bcc.w   .l12064
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d5, d0
    beq.w   .l12064
    clr.b   $1(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteValue,PC)
    nop
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    add.l   d0, $6(a3)
    bra.b   .l12064
.l11ff4:
    cmpi.b  #$6, $1(a2)
    bne.b   .l12064
    moveq   #$0,d4
    move.b  (a2), d4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.b   .l12060
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    move.l  (a0,d1.w), d6
    eor.l   d6, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    bne.b   .l12064
    move.w  d2, d0
    mulu.w  #$e, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    tst.w   (a0,d0.w)
    bne.b   .l12064
.l12060:
    clr.b   $1(a2)
.l12064:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l11f9e
    movem.l (a7)+, d2-d6/a2-a3
    rts
