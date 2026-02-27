; ============================================================================
; AddToTileBuffer -- Add a fixed word offset to each entry in a tile buffer array
; 30 bytes | $0046F2-$00470F
; ============================================================================
AddToTileBuffer:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    movea.l $10(a7), a0
    bra.b   l_04704
l_04702:
    add.w   d1, (a0)+
l_04704:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    bne.b   l_04702
    move.l  (a7)+, d2
    rts
