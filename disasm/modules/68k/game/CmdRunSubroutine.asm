; ============================================================================
; CmdRunSubroutine -- Call InitAnimTable subroutine (thin wrapper)
; 8 bytes | $000474-$00047B
; ============================================================================
CmdRunSubroutine:
    jsr (InitAnimTable,PC)
    nop
    rts
