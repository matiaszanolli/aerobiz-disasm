; ============================================================================
; ClearTextBuffer -- Resets the text column counters to zero by calling ClampTextColumnWidths(0, 32)
; 14 bytes | $03AAE6-$03AAF3
; ============================================================================
ClearTextBuffer:
    pea     ($0020).w
    clr.l   -(a7)
    bsr.w ClampTextColumnWidths
    addq.l  #$8, a7
    rts
