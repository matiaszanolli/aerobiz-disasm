; ============================================================================
; AggregateCharAvailability -- Compute the average morale of all characters on a player's active route slots by calling CalcCharMorale for each and averaging.
; 114 bytes | $0223EA-$02245B
; ============================================================================
AggregateCharAvailability:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d2
    bra.b   l_2243c
l_2242a:
    move.l  a2, -(a7)
    jsr (CalcCharMorale,PC)
    nop
    addq.l  #$4, a7
    add.w   d0, d3
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_2243c:
    cmp.w   d4, d2
    bcs.b   l_2242a
    tst.w   d4
    bne.b   l_22448
    moveq   #$0,d0
    bra.b   l_22456
l_22448:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr SignedDiv
l_22456:
    movem.l (a7)+, d2-d4/a2
    rts
