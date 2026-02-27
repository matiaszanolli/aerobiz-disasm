; ============================================================================
; CmdSetVDPReg -- Write VDP register command word to control port and cache in work RAM shadow
; 26 bytes | $0003A2-$0003BB
; ============================================================================
CmdSetVDPReg:
    move.l  $e(a6), d0
    movea.l  #$00C00004,a4
    move.w  d0, (a4)
    move.w  d0, d1
    lsr.w   #$8, d1
    andi.b  #$7f, d1
    move.b  d0, (a5,d1.w)
    rts
