; ============================================================================
; XorAndUpdate -- Store new button byte at A1 and write newly-pressed bits (changed AND new)
; 12 bytes | $001A14-$001A1F
; ============================================================================
XorAndUpdate:
    move.b  (a1), d1
    eor.b   d0, d1
    move.b  d0, (a1)+
    and.b   d0, d1
    move.b  d1, (a1)+
    rts
