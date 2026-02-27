; ============================================================================
; HandleRouteEventType2 -- Handle a type-2 route event (character batch transfer): process scenario menu, show event message dialog, initialize two char ranges, and display scenario menu.
; 240 bytes | $022B56-$022C45
; ============================================================================
HandleRouteEventType2:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    movea.l $8(a6), a3
    lea     -$80(a6), a4
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr (ProcessScenarioMenu,PC)
    nop
    pea     ($0004).w
    jsr InitInfoPanel
    cmpi.b  #$2, $1(a3)
    bne.b   l_22ba2
    pea     ($00041316).l
    bra.b   l_22bb4
l_22ba2:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
l_22bb4:
    pea     ($00047FCE).l
    move.l  a4, -(a7)
    jsr sprintf
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    clr.w   d2
    bra.b   l_22c0a
l_22bf6:
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    addq.w  #$1, d3
    addq.w  #$1, d2
l_22c0a:
    cmp.w   d4, d2
    bcs.b   l_22bf6
    moveq   #$0,d3
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_22c32
l_22c1e:
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    addq.w  #$1, d3
    addq.w  #$1, d2
l_22c32:
    cmp.w   d4, d2
    bcs.b   l_22c1e
    jsr (DisplayScenarioMenu,PC)
    nop
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts
