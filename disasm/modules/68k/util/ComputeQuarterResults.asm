; ============================================================================
; ComputeQuarterResults -- Calls CountCharPerformance, formats a result string (no chars / 1 char / N chars) via sprintf, and calls ShowText to display the quarterly character performance summary
; 148 bytes | $018C80-$018D13
; ============================================================================
ComputeQuarterResults:
    link    a6,#-$A0
    movem.l d2-d3/a2, -(a7)
    move.l  $8(a6), d3
    lea     -$a0(a6), a2
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CountCharPerformance
    addq.l  #$8, a7
    move.w  d0, d2
    tst.w   d2
    bne.b   l_18cc0
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047C9C).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_18cec
l_18cc0:
    cmpi.w  #$1, d2
    bne.b   l_18cce
    pea     ($000410C6).l
    bra.b   l_18cd4
l_18cce:
    move.l  ($00047B78).l, -(a7)
l_18cd4:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047CA0).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $10(a7), a7
l_18cec:
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
    movem.l -$ac(a6), d2-d3/a2
    unlk    a6
    rts
