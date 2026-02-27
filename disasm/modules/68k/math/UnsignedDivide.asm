; ===========================================================================
; UnsignedDivide -- Unsigned 32/32 divide
;   In:  D0.l = dividend, D1.l = divisor
;   Out: D0.l = quotient, D1.l = remainder
; ===========================================================================
UnsignedDivide:                                             ; $03E0C6
    cmpi.l  #$00010000,d1
    bcc.s   UDiv_Full32                ; divisor >= 65536, bit-by-bit
    divu.w  d1,d0                      ; fast: DIVU.W (32/16)
    bvs.s   UDiv_Overflow              ; quotient overflow, two-step
    moveq   #0,d1
    move.w  d0,d1                      ; D1 = quotient (low word)
    clr.w   d0
    swap    d0                         ; D0 = remainder (high word)
    exg     d0,d1                      ; D0 = quotient, D1 = remainder
    rts
; ---------------------------------------------------------------------------
; UDiv_Overflow -- Two-step 32/16 (quotient > 16 bits)
; ---------------------------------------------------------------------------
UDiv_Overflow:                                              ; $03E0DE
    move.l  d2,-(sp)                   ; save D2
    move.l  d1,d2                      ; D2 = divisor
    move.l  d0,d1                      ; D1 = original dividend
    clr.w   d0
    swap    d0                         ; D0 = dividend high word
    divu.w  d2,d0                      ; high / divisor -> rem1:quot_hi
    swap    d0                         ; D0 = quot_hi:rem1
    swap    d1
    move.w  d0,d1                      ; D1.low = rem1
    swap    d1                         ; D1 = rem1:dividend_low
    divu.w  d2,d1                      ; rem1:low / divisor -> rem2:quot_lo
    move.w  d1,d0                      ; D0 = quot_hi:quot_lo
    clr.w   d1
    swap    d1                         ; D1 = remainder
    move.l  (sp)+,d2                   ; restore D2
    rts
; ---------------------------------------------------------------------------
; UDiv_Full32 -- Bit-by-bit 32/32 shift-subtract (16 iterations)
;   Quotient fits in 16 bits since divisor >= $10000
; ---------------------------------------------------------------------------
UDiv_Full32:                                                ; $03E0FE
    movem.l d2-d3,-(sp)               ; save D2-D3
    move.l  d1,d3                      ; D3 = divisor
    move.l  d0,d1                      ; D1 = dividend
    swap    d0
    clr.w   d0                         ; D0 = dividend_low:0 (quotient accum)
    clr.w   d1
    swap    d1                         ; D1 = 0:dividend_high (remainder seed)
    moveq   #15,d2                     ; 16 iterations
.shiftLoop:                                                 ; $03E110
    add.l   d0,d0                      ; shift quotient left
    addx.l  d1,d1                      ; shift remainder left with carry
    cmp.l   d3,d1
    bcs.s   .noSub                     ; remainder < divisor
    sub.l   d3,d1                      ; remainder -= divisor
    addq.b  #1,d0                      ; set quotient bit
.noSub:                                                     ; $03E11C
    dbra    d2,.shiftLoop
    movem.l (sp)+,d2-d3               ; restore D2-D3
    rts
