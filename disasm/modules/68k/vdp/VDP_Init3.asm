; ============================================================================
; VDP_Init3 -- Set all three I/O port control registers to output mode ($40)
; 22 bytes | $00107A-$00108F
; ============================================================================
VDP_Init3:
    moveq   #$40,d7
    move.b  d7, ($00A10009).l
    move.b  d7, ($00A1000B).l
    move.b  d7, ($00A1000D).l
    rts
