; ============================================================================
; RenderGameUI -- Render main game UI event dialogs: dispatch on event type to trade scroll animations and info display functions, poll input, and update char state.
; 702 bytes | $022D0A-$022FC7
; ============================================================================
RenderGameUI:
    link    a6,#-$80
    movem.l d2/a2-a5, -(a7)
    movea.l  #$000238F0,a3
    movea.l  #$00023958,a4
    lea     -$80(a6), a5
    movea.l  #$00FF09CA,a2
    tst.b   (a2)
    bne.w   l_22e92
    tst.b   $2(a2)
    bne.w   l_22fbe
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr (ClassifyEvent,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.b   l_22dca
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $001E
    dc.w    $001E
    dc.w    $0032
    dc.w    $0046
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($0008).w
    bra.b   l_22dc6
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($0009).w
    bra.b   l_22dc6
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000A).w
    bra.b   l_22dc6
    pea     ($0001).w
    jsr LoadDisplaySet
    jsr AnimateScrollWipe
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    pea     ($0007).w
l_22dc6:
    jsr     (a3)
    addq.l  #$4, a7
l_22dca:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047D94,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$5, d2
    bne.b   l_22df8
    pea     ($00041328).l
    bra.b   l_22dfe
l_22df8:
    pea     ($00041326).l
l_22dfe:
    pea     ($0004805A).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     ($0018).w
    jsr GameCommand
    jsr ClearInfoPanel
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0001).w
    jsr RandRange
    mulu.w  #$a, d0
    move.b  d0, $2(a2)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr (GetCharRelationS2,PC)
    nop
    lea     $18(a7), a7
    jsr (ClearListArea,PC)
    nop
    bra.w   l_22fbe
l_22e92:
    cmpi.b  #$1, (a2)
    bne.w   l_22fbe
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr (ProcessTradeS2,PC)
    nop
    move.w  d0, d2
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $2c(a7), a7
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_22f5e
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0022
    dc.w    $003C
    dc.w    $0050
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000B).w
    bra.b   l_22f5a
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000D).w
    bra.b   l_22f5a
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000E).w
    bra.b   l_22f5a
    jsr AnimateScrollEffect
    pea     ($0001).w
    move.l  a2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    pea     ($000C).w
l_22f5a:
    jsr     (a3)
    addq.l  #$4, a7
l_22f5e:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047DAC,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004808E).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
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
l_22fbe:
    movem.l -$94(a6), d2/a2-a5
    unlk    a6
    rts
