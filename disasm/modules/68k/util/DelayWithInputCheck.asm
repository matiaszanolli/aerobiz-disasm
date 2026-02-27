; ============================================================================
; DelayWithInputCheck -- Delays N frames while checking for Start button; sets $FFA78E=1 if Start seen during the wait; returns $FFA78E value
; 64 bytes | $03B994-$03B9D3
; ============================================================================
DelayWithInputCheck:
    move.l  d2, -(a7)
    move.l  $8(a7), d2
    bra.b   l_3b9c6
l_3b99c:
    clr.l   -(a7)
    jsr ReadInput
    andi.w  #$80, d0
    beq.b   l_3b9b2
    move.w  #$1, ($00FFA78E).l
l_3b9b2:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $c(a7), a7
    subq.w  #$1, d2
l_3b9c6:
    tst.w   d2
    bne.b   l_3b99c
    move.w  ($00FFA78E).l, d0
    move.l  (a7)+, d2
    rts
