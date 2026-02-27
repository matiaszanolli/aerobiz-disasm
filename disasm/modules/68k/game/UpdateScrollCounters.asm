; ============================================================================
; UpdateScrollCounters -- Tick H/V scroll counters; when period elapsed, advance scroll pos and redraw
; 92 bytes | $0061F6-$006251
; ============================================================================
UpdateScrollCounters:
    move.l  a2, -(a7)
    movea.l  #$00FFBDDA,a2
    addq.w  #$1, $4(a2)
    move.w  $4(a2), d0
    cmp.w   (a2), d0
    bcs.b   l_06214
    addq.w  #$1, ($00FFA788).l
    clr.w   $4(a2)
l_06214:
    addq.w  #$1, $6(a2)
    move.w  $6(a2), d0
    cmp.w   $2(a2), d0
    bcs.b   l_0622c
    addq.w  #$1, ($00FFA784).l
    clr.w   $6(a2)
l_0622c:
    tst.w   $4(a2)
    beq.b   l_06238
    tst.w   $6(a2)
    bne.b   l_0624e
l_06238:
    move.w  ($00FFA784).l, d0
    move.l  d0, -(a7)
    move.w  ($00FFA788).l, d0
    move.l  d0, -(a7)
    bsr.w CalcScrollBarPos
    addq.l  #$8, a7
l_0624e:
    movea.l (a7)+, a2
    rts
