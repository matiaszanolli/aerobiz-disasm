; ============================================================================
; ResetScrollModes -- Clear display then reinitialize DMA config and scroll modes
; 32 bytes | $005780-$00579F
; ============================================================================
ResetScrollModes:
    pea     ($000D).w
    jsr GameCommand
    bsr.w ConfigDmaMode
    bsr.w InitScrollModes
    pea     ($000C).w
    jsr GameCommand
    addq.l  #$8, a7
    rts
