; ============================================================================
; StubCodeFragment -- Stub/placeholder fragment: illegal instruction word $FEDE followed by moveq #0,d0 / rts, always returning 0.
; 10 bytes | $022110-$022119
; ============================================================================
StubCodeFragment:
    dc.w    $FEDE
    moveq   #$0,d0
    movem.l (a7)+, d2-d5/a2-a4
    rts
