; ============================================================================
; ComputeDividends -- Divide 16 dividend table values at  by 10 to compute period payout amounts
; 64 bytes | $00BA3E-$00BA7D
; ============================================================================
ComputeDividends:
    movem.l d2/a2, -(a7)
    moveq   #$0,d2
    movea.l  #$00FFA6BA,a2
.l0ba4a:
    moveq   #$0,d0
    move.w  (a2), d0
    bge.b   .l0ba54
    moveq   #$F,d1
    add.l   d1, d0
.l0ba54:
    asr.l   #$4, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$A,d1
    jsr SignedDiv
    mulu.w  #$a, d0
    move.w  d0, (a2)
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$1, d2
    moveq   #$10,d0
    cmp.l   d2, d0
    bgt.b   .l0ba4a
    movem.l (a7)+, d2/a2
    rts
