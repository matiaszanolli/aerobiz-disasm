; ============================================================================
; CheckRouteEventMatch -- Return 1 if the pending candidate in $FF09CA has a char code range matching a given char code via RangeLookup comparison.
; 82 bytes | $02235A-$0223AB
; ============================================================================
CheckRouteEventMatch:
    movem.l d2/a2, -(a7)
    move.l  $c(a7), d2
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_223a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  d2, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  (a7)+, d1
    cmp.w   d1, d0
    bne.b   l_223a4
    moveq   #$1,d0
    bra.b   l_223a6
l_223a4:
    moveq   #$0,d0
l_223a6:
    movem.l (a7)+, d2/a2
    rts
