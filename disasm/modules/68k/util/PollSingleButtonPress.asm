; ============================================================================
; PollSingleButtonPress -- Display a prompt message via DisplayMessageWithParams and return the button press result
; 34 bytes | $00C392-$00C3B3
; ============================================================================
PollSingleButtonPress:
    move.l  d2, -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0003E5F6).l
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    move.l  (a7)+, d2
    rts
