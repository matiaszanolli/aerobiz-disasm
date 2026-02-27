; ============================================================================
; AlignTextBlock -- Issues GameCommand($13, $10) to trigger a display-layer sync/align operation; a one-call wrapper with no other logic.
; 18 bytes | $01D8E2-$01D8F3
; ============================================================================
AlignTextBlock:
    pea     ($0010).w
    pea     ($0013).w
    jsr GameCommand
    addq.l  #$8, a7
    rts
