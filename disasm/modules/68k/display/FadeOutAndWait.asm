; ============================================================================
; FadeOutAndWait -- Steps palette brightness from 7 down to 0 (fade out) calling FadePalette + DelayFrames per step; returns 1 if interrupted by input
; 76 bytes | $03B38E-$03B3D9
; ============================================================================
FadeOutAndWait:
    movem.l d2-d5/a2, -(a7)
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    movea.l $18(a7), a2
    moveq   #$7,d2
l_3b3a4:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FadePalette
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w DelayFrames
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_3b3cc
    moveq   #$1,d0
    bra.b   l_3b3d4
l_3b3cc:
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_3b3a4
    moveq   #$0,d0
l_3b3d4:
    movem.l (a7)+, d2-d5/a2
    rts
