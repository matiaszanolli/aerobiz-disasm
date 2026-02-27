; ============================================================================
; AccumulateRouteBits -- Iteratively ORs available route-bit masks into an output bitmask by calling FindAvailSlot in a loop until no bits remain.
; 58 bytes | $011D50-$011D89
; ============================================================================
AccumulateRouteBits:
    movem.l d2-d4/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $14(a7), d4
    movea.l $20(a7), a2
.l11d64:
    tst.l   d2
    bne.b   .l11d6c
    move.l  d3, (a2)
    bra.b   .l11d84
.l11d6c:
    move.l  d3, -(a7)
    move.l  d2, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindAvailSlot,PC)
    nop
    lea     $c(a7), a7
    move.l  d0, d2
    or.l    d2, d3
    bra.b   .l11d64
.l11d84:
    movem.l (a7)+, d2-d4/a2
    rts
