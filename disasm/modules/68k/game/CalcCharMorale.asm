; ============================================================================
; CalcCharMorale -- Calculate a character's weighted morale value for a route slot using the raw morale byte, factor byte, and MulDiv.
; 36 bytes | $02245C-$02247F
; ============================================================================
CalcCharMorale:
    movea.l $4(a7), a0
    moveq   #$0,d0
    move.b  $b(a0), d0
    move.l  d0, -(a7)
    pea     ($0064).w
    moveq   #$0,d0
    move.b  $3(a0), d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $c(a7), a7
    rts
