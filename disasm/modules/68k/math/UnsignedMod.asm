; ===========================================================================
; UnsignedMod -- Unsigned 32/32 modulo
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = remainder
; ===========================================================================
UnsignedMod:                                                ; $03E12A
    cmpi.l  #$00010000,d1
    bcc.s   .slowMod                   ; divisor >= 65536
    divu.w  d1,d0                      ; fast: DIVU.W
    bvs.s   .slowMod                   ; overflow
    clr.w   d0
    swap    d0                         ; D0 = remainder
    rts
.slowMod:                                                   ; $03E13C
    bsr.s   UnsignedDivide             ; full divide, D1 = remainder
    move.l  d1,d0                      ; D0 = remainder
    rts
