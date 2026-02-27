; ============================================================================
; CheckEventConditionS2 -- Scans the two event-condition tables and for any event whose trigger date matches the current turn formats a news-ticker message, animates an info panel, displays it with a button-wait, then places the item tile.
; 370 bytes | $028FF0-$029161
; ============================================================================
CheckEventConditionS2:
    link    a6,#-$84
    movem.l d2-d3/a2-a4, -(a7)
    lea     -$80(a6), a3
    movea.l  #$0002377C,a4
    movea.l  #$0005F9DE,a2
    clr.w   d3
l_2900a:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    subq.l  #$2, d1
    cmp.l   d1, d0
    bne.w   l_290aa
    clr.w   d2
    cmpi.w  #$5, (a2)
    bne.b   l_2902a
l_29026:
    clr.w   d2
    bra.b   l_29052
l_2902a:
    cmpi.w  #$29, (a2)
    bne.b   l_29034
    moveq   #$3,d2
    bra.b   l_29052
l_29034:
    cmpi.w  #$31, (a2)
    beq.b   l_29026
    cmpi.w  #$4b, (a2)
    beq.b   l_29026
    cmpi.w  #$67, (a2)
    bne.b   l_2904a
    moveq   #$1,d2
    bra.b   l_29052
l_2904a:
    cmpi.w  #$92, (a2)
    bne.b   l_29052
    moveq   #$2,d2
l_29052:
    pea     ($0005).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr AnimateInfoPanel
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0004838C,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000483A0).l, -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    move.l  a3, -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0005).w
    move.l  a2, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr PlaceItemTiles
    lea     $28(a7), a7
l_290aa:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$6, d3
    bcs.w   l_2900a
    movea.l  #$0005FA2A,a2
    clr.w   d3
l_290be:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    subq.l  #$4, d1
    cmp.l   d1, d0
    bne.b   l_2914c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcEventValue
    move.w  d0, d2
    move.b  d2, -$81(a6)
    pea     ($0001).w
    pea     -$81(a6)
    jsr AnimateInfoPanel
    lea     $c(a7), a7
    cmpi.w  #$3b, d2
    bne.b   l_29102
    move.l  ($00048388).l, -(a7)
    bra.b   l_29124
l_29102:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00048384).l, -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    move.l  a3, -(a7)
l_29124:
    jsr     (a4)
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0001).w
    pea     -$81(a6)
    jsr PlaceItemTiles
    lea     $14(a7), a7
l_2914c:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$11, d3
    bcs.w   l_290be
    movem.l -$98(a6), d2-d3/a2-a4
    unlk    a6
    rts
