; ============================================================================
; SetScrollAlternate -- Write alternate scroll value to $FFA786, mask to 10 bits, apply via GameCommand #8
; 58 bytes | $0054DE-$005517
; ============================================================================
SetScrollAlternate:
    link    a6,#-$4
    move.l  $8(a6), d1
    move.w  d1, ($00FFA786).l
    move.w  d1, d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    unlk    a6
    rts
