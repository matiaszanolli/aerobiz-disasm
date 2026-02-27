; ===========================================================================
; UnsignedDiv_FromPtr -- Alternate entry: load from (A0), swap
; ===========================================================================
UnsignedDiv_FromPtr:                                        ; $03E0C2
    move.l  (a0),d1
    exg     d0,d1                      ; D0 = (A0), D1 = caller's D0
