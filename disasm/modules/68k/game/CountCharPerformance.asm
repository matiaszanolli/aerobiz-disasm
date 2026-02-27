; ============================================================================
; CountCharPerformance -- Evaluate character performance metrics across player routes; compute aggregate productivity score
; Called: ?? times.
; 250 bytes | $00FFF8-$0100F1
; ============================================================================
CountCharPerformance:                                                  ; $00FFF8
    link    a6,#-$8
    movem.l d2-d7,-(sp)
