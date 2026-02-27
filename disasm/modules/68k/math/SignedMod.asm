; ===========================================================================
; SignedMod -- Signed 32/32 modulo
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = remainder (sign follows dividend)
;   88 calls
; ===========================================================================
SignedMod:                                                  ; $03E146
    cmpi.l  #$00007FFF,d1
    bgt.s   .slowMod                   ; divisor out of 16-bit range
    cmpi.l  #$FFFF8000,d1
    blt.s   .slowMod                   ; divisor out of 16-bit range
    divs.w  d1,d0                      ; fast: DIVS.W
    bvs.s   .slowMod                   ; overflow
    swap    d0                         ; remainder in low word
    ext.l   d0                         ; sign-extend remainder
    rts
.slowMod:                                                   ; $03E160
    move.l  d2,-(sp)                   ; save D2
    clr.l   d2                         ; sign tracker
    tst.l   d1
    bge.s   .modChk                    ; divisor positive
    neg.l   d1                         ; make positive
.modChk:                                                    ; $03E16A
    tst.l   d0
    bge.s   .modCall                   ; dividend positive
    neg.l   d0                         ; make positive
    addq.b  #1,d2                      ; mark: dividend was negative
.modCall:                                                   ; $03E172
    bsr.w UnsignedDivide
    move.l  d1,d0                      ; D0 = remainder
    tst.b   d2
    beq.s   .modDone                   ; dividend was positive
    neg.l   d0                         ; negate remainder
.modDone:                                                   ; $03E17E
    move.l  (sp)+,d2                   ; restore D2
    rts
; ---------------------------------------------------------------------------
    dc.w    $1B47,$2573,$00FF,$2524,$366C,$6400,$2533        ; $03E182 (string data)
    dc.w    $6400,$2533,$6400,$2533,$6400,$2533,$6400,$2534; $03E190
    dc.w    $6400,$2535,$6400,$2573,$00FF,$00FF         ; $03E1A0
