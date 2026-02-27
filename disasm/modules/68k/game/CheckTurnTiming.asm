; ============================================================================
; CheckTurnTiming -- Check whether timing is favorable for a turn based on current game phase position, returning 1 if a computed timing window random check passes.
; 88 bytes | $021D8A-$021DE1
; ============================================================================
CheckTurnTiming:
    move.l  d2, -(a7)
    move.w  ($00FFA6B2).l, d0
    ext.l   d0
    moveq   #$3C,d2
    sub.l   d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    add.l   d0, d2
    moveq   #$A,d0
    cmp.l   d2, d0
    bge.b   l_21dc0
    move.w  ($00FFA6B2).l, d0
    ext.l   d0
    moveq   #$3C,d2
    sub.l   d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    add.l   d0, d2
    bra.b   l_21dc2
l_21dc0:
    moveq   #$A,d2
l_21dc2:
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bge.b   l_21ddc
    moveq   #$1,d0
    bra.b   l_21dde
l_21ddc:
    moveq   #$0,d0
l_21dde:
    move.l  (a7)+, d2
    rts
