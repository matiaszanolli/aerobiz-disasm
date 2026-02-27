; ============================================================================
; CmdGetVDPReg -- Read cached VDP register value from work RAM shadow by register index
; 16 bytes | $00045A-$000469
; ============================================================================
CmdGetVDPReg:
    move.l  $e(a6), d1
    move.b  (a5,d1.w), d0
    andi.l  #$ff, d0
    rts
