; ============================================================================
; WaitStableInput -- Polls ReadInput until input state is stable for N consecutive frames, advancing the frame each matching poll; debounces button input.
; 66 bytes | $014D64-$014DA5
; ============================================================================
WaitStableInput:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d4
    bra.b   .l14d9c
.l14d7a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d3
    cmp.w   d3, d4
    bne.b   .l14da0
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    subq.w  #$1, d2
.l14d9c:
    tst.w   d2
    bne.b   .l14d7a
.l14da0:
    movem.l (a7)+, d2-d4
    rts
