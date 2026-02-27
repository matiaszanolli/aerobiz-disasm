; ============================================================================
; SelectPaletteMode -- Set VDP register 12 to shadow/highlight mode or normal mode based on D2
; 32 bytes | $005590-$0055AF
; ============================================================================
SelectPaletteMode:
    tst.w   d2
    beq.b   l_0559c
    move.l  #$8c08, -(a7)
    bra.b   l_055a2
l_0559c:
    move.l  #$8c00, -(a7)
l_055a2:
    clr.l   -(a7)
    jsr GameCommand
    addq.l  #$8, a7
    move.l  (a7)+, d2
    rts
