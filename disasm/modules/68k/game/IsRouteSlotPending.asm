; ============================================================================
; IsRouteSlotPending -- Scans a player's relation slots and returns 1 if any slot has its pending flag (bit 7 of offset $A) set, otherwise 0.
; 90 bytes | $011CF6-$011D4F
; ============================================================================
IsRouteSlotPending:
    move.l  d2, -(a7)
    move.l  $8(a7), d1
    move.w  d1, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.w  d1, d0
    mulu.w  #$24, d0
    movea.l  #$00FF001C,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d1
    clr.w   d2
    bra.b   .l11d46
.l11d2a:
    move.b  $a(a1), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    bne.b   .l11d40
    moveq   #$1,d0
    bra.b   .l11d4c
.l11d40:
    moveq   #$14,d0
    adda.l  d0, a1
    addq.w  #$1, d2
.l11d46:
    cmp.w   d1, d2
    bcs.b   .l11d2a
    moveq   #$0,d0
.l11d4c:
    move.l  (a7)+, d2
    rts
