; ===========================================================================
; Multiply32 -- 32x32 -> 32 unsigned multiply
;   In:  D0.l = multiplicand, D1.l = multiplier
;   Out: D0.l = low 32 bits of product
;   Uses: D2 (saved/restored)
;   204 calls
; ===========================================================================
Multiply32:                                                 ; $03E05C
    movem.l d0/d2,-(sp)               ; save D0 and D2
    move.l  d0,d2                      ; D2 = multiplicand copy
    mulu.w  d1,d0                      ; D0 = low * low (16x16->32)
    clr.w   d2
    swap    d2                         ; D2 = multiplicand high word
    beq.s   .crossB                    ; skip if high word zero
    mulu.w  d1,d2                      ; D2 = mcand_high * mplier_low
    swap    d2
    clr.w   d2                         ; cross product << 16
    add.l   d2,d0                      ; accumulate
.crossB:                                                    ; $03E072
    move.l  (sp)+,d2                   ; recover saved D0 into D2
    clr.w   d1
    swap    d1                         ; D1 = multiplier high word
    beq.s   .mulDone                   ; skip if high word zero
    mulu.w  d1,d2                      ; D2 = saved_D0_low * mplier_high
    swap    d2
    clr.w   d2                         ; cross product << 16
    add.l   d2,d0                      ; accumulate
.mulDone:                                                   ; $03E082
    move.l  (sp)+,d2                   ; restore original D2
    rts
