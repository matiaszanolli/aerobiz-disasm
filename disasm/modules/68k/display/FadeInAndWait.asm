; ============================================================================
; FadeInAndWait -- Steps palette brightness from 0 up to 7 (fade in) calling FadePalette + DelayFrames per step; returns 1 if interrupted by input
; 78 bytes | $03B3DA-$03B427
; ============================================================================
FadeInAndWait:
    movem.l d2-d5/a2, -(a7)
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    movea.l $18(a7), a2
    clr.w   d2
l_3b3f0:
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
    beq.b   l_3b418
    moveq   #$1,d0
    bra.b   l_3b422
l_3b418:
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   l_3b3f0
    moveq   #$0,d0
l_3b422:
    movem.l (a7)+, d2-d5/a2
    rts
