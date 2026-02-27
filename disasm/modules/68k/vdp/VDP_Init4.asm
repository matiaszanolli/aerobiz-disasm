; ============================================================================
; VDP_Init4 -- Request Z80 bus and reset Z80, then wait for bus grant with IRQs disabled
; 32 bytes | $0010FE-$00111D
; ============================================================================
VDP_Init4:
    lea     ($00A11100).l, a4
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.w  #$100, (a4)
    move.w  #$100, $100(a4)
l_01114:
    btst    #$0, (a4)
    bne.b   l_01114
    move.w  (a7)+, sr
    rts
