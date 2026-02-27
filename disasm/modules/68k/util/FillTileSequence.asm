; ============================================================================
; FillTileSequence -- Fill buffer with sequential BAT cell words encoding palette, flip, and tile index
; 76 bytes | $0046A6-$0046F1
; ============================================================================
FillTileSequence:
    movem.l d2-d6, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    movea.l $28(a7), a0
    andi.w  #$3, d5
    andi.w  #$1, d4
    andi.w  #$7ff, d2
    move.w  d5, d0
    moveq   #$D,d1
    lsl.w   d1, d0
    add.w   d2, d0
    move.w  d4, d1
    moveq   #$F,d6
    lsl.w   d6, d1
    add.w   d1, d0
    move.w  d0, d2
    bra.b   l_046e4
l_046de:
    move.l  d2, d0
    addq.w  #$1, d2
    move.w  d0, (a0)+
l_046e4:
    move.l  d3, d0
    subq.w  #$1, d3
    tst.w   d0
    bne.b   l_046de
    movem.l (a7)+, d2-d6
    rts
