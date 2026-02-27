; ============================================================================
; HardwareInit -- Initialize VDP display-disable state: clear display bits in mode reg 1 shadow and port
; 26 bytes | $00070A-$000723
; ============================================================================
HardwareInit:
    move.b  $1(a5), d0
    andi.w  #$9f, d0
    ori.w   #$8104, d0
    movea.l  #$00C00004,a4
    move.b  d0, $1(a5)
    move.w  d0, (a4)
    rts
