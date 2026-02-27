; ============================================================================
; SetHorizontalScroll -- Store H-scroll value, negate and mask to 10 bits, apply via GameCommand #8
; 64 bytes | $005420-$00545F
; ============================================================================
SetHorizontalScroll:
    move.l  $8(a6), d1
    move.w  d1, ($00FFA784).l
    move.w  d1, d0
    neg.w   d0
    andi.w  #$3ff, d0
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    unlk    a6
    rts
