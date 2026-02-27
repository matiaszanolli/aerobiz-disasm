; ============================================================================
; HandleRouteEventType0 -- Handle a type-0 route event (character group transfer): run transition animation, display group dialog, reinitialize chars, and optionally set $FF1294.
; 676 bytes | $022682-$022925
; ============================================================================
HandleRouteEventType0:
    link    a6,#-$C0
    movem.l d2/a2-a5, -(a7)
    movea.l $8(a6), a2
    lea     -$80(a6), a4
    movea.l  #$0003B22C,a5
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    movea.l  #$0005F9DE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    jsr RunTransitionSteps
    pea     ($0005).w
    move.l  a3, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    pea     ($0002).w
    jsr InitInfoPanel
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   ($00FF0006).l, d0
    bne.w   l_2285c
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E22).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    movea.l a3, a0
    addq.l  #$4, a0
    movea.l a0, a2
    cmpi.b  #$ff, (a0)
    bne.b   l_22750
    moveq   #$0,d0
    move.b  $3(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$c0(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_227a6
l_22750:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004130C).l
    pea     -$c0(a6)
    jsr     (a5)
    lea     $10(a7), a7
l_227a6:
    pea     -$c0(a6)
    pea     ($00047E3E).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    movea.l a3, a2
    addq.l  #$3, a2
    clr.w   d2
    bra.b   l_227fc
l_227d6:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    addq.l  #$8, a7
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    ori.b   #$1, (a0,d0.w)
    addq.l  #$1, a2
    addq.w  #$1, d2
l_227fc:
    cmpi.w  #$5, d2
    bge.b   l_22808
    cmpi.b  #$ff, (a2)
    bne.b   l_227d6
l_22808:
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr (GetCharStatsS2,PC)
    nop
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    lea     $10(a7), a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $2(a3), d0
    move.l  d0, -(a7)
    movea.w d2, a0
    move.b  $3(a3, a0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    jsr (GetCharRelationS2,PC)
    nop
    bra.b   l_228da
l_2285c:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E5C).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    clr.l   -(a7)
    pea     ($0002).w
    jsr CheckEventMatch
    lea     $20(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_228dc
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047E98).l
    move.l  a4, -(a7)
    jsr     (a5)
    move.l  a4, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    lea     $10(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
l_228da:
    addq.l  #$8, a7
l_228dc:
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    pea     ($0005).w
    move.l  a3, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    jsr UpdateIfActive
    clr.l   -(a7)
    pea     ($0002).w
    jsr CheckEventMatch
    lea     $10(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2291c
    move.w  #$64, ($00FF1294).l
l_2291c:
    movem.l -$d4(a6), d2/a2-a5
    unlk    a6
    rts
