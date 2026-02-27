; ============================================================================
; ReleaseZ80BusDirect -- Write zero to Z80 bus-request register to release Z80 bus
; 12 bytes | $00115E-$001169
; ============================================================================
ReleaseZ80BusDirect:
    movea.l  #$00A11100,a2
    move.w  #$0, (a2)
    rts
