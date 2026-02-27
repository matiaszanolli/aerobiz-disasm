; ============================================================================
; CalcRouteValue -- Computes a route's monetary value; reads char stat and airport capacity, applies a scaled formula (capacity * (stat+1) / 4), and returns the result.
; 100 bytes | $012E2E-$012E91
; ============================================================================
CalcRouteValue:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$258, d0
    move.w  d2, d1
    ext.l   d1
    addq.l  #$1, d1
    jsr Multiply32
    tst.l   d0
    bge.b   .l12e88
    addq.l  #$3, d0
.l12e88:
    asr.l   #$2, d0
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2
    rts
