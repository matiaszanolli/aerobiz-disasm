; ===========================================================================
; SignedDiv -- Signed 32/32 -> 32 division
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = quotient (signed)
;   169 calls
; ===========================================================================
SignedDiv:                                                  ; $03E08A
    cmpi.l  #$00007FFF,d1
    bgt.s   .slowDiv                   ; divisor > +32767
    cmpi.l  #$FFFF8000,d1
    blt.s   .slowDiv                   ; divisor < -32768
    divs.w  d1,d0                      ; fast: DIVS.W (32/16)
    bvs.s   .slowDiv                   ; overflow
    ext.l   d0                         ; sign-extend quotient
    rts
.slowDiv:                                                   ; $03E0A2
    move.l  d2,-(sp)                   ; save D2
    clr.b   d2                         ; sign tracker
    tst.l   d0
    bge.s   .divChk1                   ; dividend positive
    neg.l   d0                         ; make positive
    not.b   d2                         ; toggle sign
.divChk1:                                                   ; $03E0AE
    tst.l   d1
    bge.s   .divCall                   ; divisor positive
    neg.l   d1                         ; make positive
    not.b   d2                         ; toggle sign
.divCall:                                                   ; $03E0B6
    bsr.s   UnsignedDivide             ; unsigned D0/D1
    tst.b   d2
    beq.s   .divDone                   ; signs matched
    neg.l   d0                         ; negate quotient
.divDone:                                                   ; $03E0BE
    move.l  (sp)+,d2                   ; restore D2
    rts
