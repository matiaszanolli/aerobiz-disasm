; ============================================================================
; IncrementCharLevel -- Returns 1 if char ID has an active level-up slot (type=$1) in the player skill table
; 68 bytes | $03537C-$0353BF
; ============================================================================
IncrementCharLevel:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d3
    clr.w   d1
    move.w  $e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_3539a:
    cmpi.b  #$1, $1(a1)
    bne.b   l_353ae
    moveq   #$0,d0
    move.b  (a1), d0
    cmp.w   d3, d0
    bne.b   l_353ae
    moveq   #$1,d1
    bra.b   l_353b8
l_353ae:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_3539a
l_353b8:
    move.w  d1, d0
    movem.l (a7)+, d2-d3
    rts
