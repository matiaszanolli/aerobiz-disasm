; ============================================================================
; IsCharInActiveMatch -- Returns 1 if char ID appears in any active match slot for given player, 0 otherwise
; 72 bytes | $035334-$03537B
; ============================================================================
IsCharInActiveMatch:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d3
    clr.w   d1
    move.w  $12(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
    move.w  ($00FFA7DA).l, d4
    bra.b   l_35370
l_3535c:
    cmp.w   (a1), d3
    bne.b   l_35364
l_35360:
    moveq   #$1,d1
    bra.b   l_35374
l_35364:
    cmp.w   $2(a1), d3
    beq.b   l_35360
    moveq   #$C,d0
    adda.l  d0, a1
    addq.w  #$1, d2
l_35370:
    cmp.w   d4, d2
    bcs.b   l_3535c
l_35374:
    move.w  d1, d0
    movem.l (a7)+, d2-d4
    rts
