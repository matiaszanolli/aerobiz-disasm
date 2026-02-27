; ============================================================================
; CmdGetVDPStatus -- Read VDP H/V counter port ($C00008) and return value in D0
; 10 bytes | $00046A-$000473
; ============================================================================
CmdGetVDPStatus:
    movea.l  #$00C00008,a4
    move.w  (a4), d0
    rts
