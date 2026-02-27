; ============================================================================
; SetScrollBothAxes -- Set both H+V scroll from one value, mask to 10 bits, apply via GameCommand #8
; 60 bytes | $0054A2-$0054DD
; ============================================================================
SetScrollBothAxes:
    link    a6,#-$4
    move.l  $8(a6), d1
    move.w  d1, ($00FFA782).l
    move.w  d1, d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0002).w
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    unlk    a6
    rts
