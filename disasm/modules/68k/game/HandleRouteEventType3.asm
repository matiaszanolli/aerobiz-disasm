; ============================================================================
; HandleRouteEventType3 -- Handle a type-3 route event (single character event): animate info panel, show conditional player-match dialog, clear panels, place item tiles, and call InitCharRecord.
; 196 bytes | $022C46-$022D09
; ============================================================================
HandleRouteEventType3:
    link    a6,#-$80
    movem.l a2-a3, -(a7)
    movea.l $8(a6), a2
    lea     -$80(a6), a3
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0004).w
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   ($00FF0006).l, d0
    bne.b   l_22c98
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047FF4).l
    bra.b   l_22cb0
l_22c98:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00048020).l
l_22cb0:
    move.l  a3, -(a7)
    jsr sprintf
    move.l  a3, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $2c(a7), a7
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    movem.l -$88(a6), a2-a3
    unlk    a6
    rts
