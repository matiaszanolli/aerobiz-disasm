; ============================================================================
; CountRouteFlags -- Counts the number of set bits (active route flags) in the route-flag longword for a given player, returning the count minus one.
; Called: ?? times.
; 66 bytes | $027184-$0271C5
; ============================================================================
CountRouteFlags:                                                  ; $027184
    movem.l d2-d4,-(sp)
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff08ec,a0
    move.l  (a0,d0.w),d4
    clr.w   d3
    tst.l   d4
    bne.b   .l271a2
    clr.w   d3
    bra.b   .l271be
.l271a2:                                                ; $0271A2
    clr.w   d2
.l271a4:                                                ; $0271A4
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    and.l   d4,d0
    beq.b   .l271b4
    addq.w  #$1,d3
.l271b4:                                                ; $0271B4
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    bcs.b   .l271a4
    subq.w  #$1,d3
.l271be:                                                ; $0271BE
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
