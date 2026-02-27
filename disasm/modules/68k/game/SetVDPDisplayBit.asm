; ============================================================================
; SetVDPDisplayBit -- Write VDP register 1 with display enabled and DMA disabled
; 16 bytes | $00116A-$001179
; ============================================================================
SetVDPDisplayBit:
l_0116a:
    move.b  $1(a5), d0
    andi.w  #$ef, d0
    ori.w   #$8100, d0
    move.w  d0, (a4)
    rts
