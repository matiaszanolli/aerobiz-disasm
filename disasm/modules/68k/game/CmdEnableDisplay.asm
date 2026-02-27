; ============================================================================
; CmdEnableDisplay -- Enable VDP display output by setting bit 6 in mode register 1 shadow and port
; 26 bytes | $0006F0-$000709
; ============================================================================
CmdEnableDisplay:
    move.b  $1(a5), d0
    andi.w  #$ff, d0
    ori.w   #$8164, d0
    movea.l  #$00C00004,a4
    move.b  d0, $1(a5)
    move.w  d0, (a4)
    rts
