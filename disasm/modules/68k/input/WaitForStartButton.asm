; ============================================================================
; WaitForStartButton -- Polls controller input for up to N frames; returns 1 and sets $FFA78E if Start is pressed, 0 if the frame count expires
; 84 bytes | $03B940-$03B993
; ============================================================================
WaitForStartButton:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    bra.b   l_3b984
l_3b954:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d3
    andi.w  #$80, d0
    beq.b   l_3b972
    move.w  #$1, ($00FFA78E).l
    moveq   #$1,d0
    bra.b   l_3b98e
l_3b972:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    subq.w  #$1, d2
l_3b984:
    tst.w   d2
    bne.b   l_3b954
    move.w  ($00FFA78E).l, d0
l_3b98e:
    movem.l (a7)+, d2-d3
    rts
