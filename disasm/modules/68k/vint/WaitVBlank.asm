; ============================================================================
; WaitVBlank -- Read and return VDP status register word from $C00004 (caller checks VBlank bit)
; 16 bytes | $000CDC-$000CEB
; ============================================================================
WaitVBlank:
    movea.l  #$00C00004,a4
    move.w  (a4), d0
    andi.l  #$ffff, d0
    rts
