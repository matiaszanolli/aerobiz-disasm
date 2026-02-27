; ============================================================================
; ToggleScrollBar -- Enable or disable the animation tick scroll bar (flag in $FFBDAC bit 3)
; 118 bytes | $0063C6-$00643B
; ============================================================================
ToggleScrollBar:
    movem.l d2-d3/a2-a4, -(a7)
    move.l  $18(a7), d3
    movea.l  #$00FFBDAC,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFBDE2,a2
    moveq   #$1,d2
    moveq   #$0,d0
    move.w  d3, d0
    beq.b   l_063f0
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_06402
    bra.b   l_06416
l_063f0:
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_06434
l_06402:
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    clr.w   (a2)
    bra.b   l_06430
l_06416:
    move.w  (a3), d0
    andi.w  #$8, d0
    beq.b   l_06434
    andi.w  #$fff7, (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    move.w  (a2), d2
l_06430:
    ori.w   #$8, (a3)
l_06434:
    move.w  d2, d0
    movem.l (a7)+, d2-d3/a2-a4
    rts
