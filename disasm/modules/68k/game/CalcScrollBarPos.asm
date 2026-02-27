; ============================================================================
; CalcScrollBarPos -- Compute modulo-clamped scroll bar positions and apply via GameCommand #5
; 106 bytes | $00618C-$0061F5
; ============================================================================
CalcScrollBarPos:
    link    a6,#-$4
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l, d1
    lsl.l   #$3, d1
    move.l  d1, d2
    jsr SignedMod
    move.w  d0, ($00FFA788).l
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d2, d1
    jsr SignedMod
    move.w  d0, ($00FFA784).l
    move.w  d0, -$2(a6)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    move.l  -$8(a6), d2
    unlk    a6
    rts
