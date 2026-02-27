; ============================================================================
; ErrorDisplay -- Trigger GameCommand #30 (error/freeze display handler)
; 14 bytes | $0058EE-$0058FB
; ============================================================================
ErrorDisplay:
    pea     ($001E).w
    jsr GameCommand
    addq.l  #$4, a7
    rts
