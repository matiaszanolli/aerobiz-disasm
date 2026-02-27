; ============================================================================
; FinalizeRouteEvent -- Cancel the active route event in $FF09CA by reinitializing the character via InitCharRecord and clearing the slot to $FF.
; 62 bytes | $0223AC-$0223E9
; ============================================================================
FinalizeRouteEvent:
    move.l  a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_223e6
    clr.b   $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $14(a7), a7
    move.b  #$ff, (a2)
l_223e6:
    movea.l (a7)+, a2
    rts
