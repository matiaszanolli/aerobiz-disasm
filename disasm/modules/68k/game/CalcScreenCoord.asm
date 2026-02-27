; ============================================================================
; CalcScreenCoord -- Computes a weighted blend coordinate: given two points and a denominator, returns (a*x + b*y) / (a+b) using Multiply32 and UnsignedDivide
; 82 bytes | $03B8EE-$03B93F
; ============================================================================
CalcScreenCoord:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d2
    move.l  $1c(a7), d3
    move.w  d2, d0
    or.w    d3, d0
    bne.b   l_3b904
    moveq   #$0,d0
    bra.b   l_3b93a
l_3b904:
    moveq   #$0,d0
    move.w  $1a(a7), d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $16(a7), d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.w  d2, d1
    moveq   #$0,d4
    move.w  d3, d4
    add.l   d4, d1
    jsr UnsignedDivide
    move.w  d0, d2
l_3b93a:
    movem.l (a7)+, d2-d4
    rts
