; ============================================================================
; CheckEventCondition -- Check whether a character meets an event condition by translating its char code via RangeLookup and calling CheckEventMatch.
; 46 bytes | $021FA6-$021FD3
; ============================================================================
CheckEventCondition:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr (CheckEventMatch,PC)
    nop
    addq.l  #$8, a7
    movem.l (a7)+, d2-d3
    rts
