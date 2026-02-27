; ============================================================================
; TriggerVDPDMA -- Invoke ConfigVDPDMA to program and fire a DMA transfer
; 8 bytes | $00111E-$001125
; ============================================================================
TriggerVDPDMA:
    jsr (ConfigVDPDMA,PC)
    nop
    rts
