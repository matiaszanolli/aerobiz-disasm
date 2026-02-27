; ============================================================================
; CountFilledAllianceSlots -- Counts how many alliance slots for a char type index are actively filled; returns that count
; 56 bytes | $0347E8-$03481F
; ============================================================================
CountFilledAllianceSlots:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d4
    clr.w   d3
    clr.w   d2
l_347f4:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bge.b   l_34810
    addq.w  #$1, d3
l_34810:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_347f4
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts
