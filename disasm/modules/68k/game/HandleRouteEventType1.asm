; ============================================================================
; HandleRouteEventType1 -- Handle a type-1 route event (individual character acquisition): animate info panel, show char name dialog, call InitCharRecord, and set char flag bit $2.
; 342 bytes | $022926-$022A7B
; ============================================================================
HandleRouteEventType1:
    link    a6,#-$80
    movem.l a2-a4, -(a7)
    movea.l $8(a6), a3
    lea     -$80(a6), a4
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA0E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr RunTransitionSteps
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0003).w
    jsr InitInfoPanel
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  $2(a3), d0
    cmp.w   ($00FF0006).l, d0
    bne.w   l_22a16
    moveq   #$0,d0
    move.b  $3(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047ECE).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    moveq   #$0,d0
    move.b  $3(a2), d0
    movea.l  #$00FF09D8,a0
    ori.b   #$2, (a0,d0.w)
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr (GetCharStatsS2,PC)
    nop
    lea     $28(a7), a7
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    jsr (GetCharRelationS2,PC)
    nop
    bra.b   l_22a50
l_22a16:
    moveq   #$0,d0
    move.b  $3(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047EEC).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    lea     $10(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_22a50:
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    jsr UpdateIfActive
    movem.l -$8c(a6), a2-a4
    unlk    a6
    rts
