; ============================================================================
; HandleAirlineRouteEvent -- Handle a type-4 airline route event: calculate char index value, animate info panel, show airline-specific dialog, place item tiles, and call InitCharRecord.
; 218 bytes | $022A7C-$022B55
; ============================================================================
HandleAirlineRouteEvent:
    link    a6,#-$84
    movem.l d2/a2-a3, -(a7)
    movea.l $8(a6), a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA2A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr CalcEventValue
    move.w  d0, d2
    move.b  d2, -$81(a6)
    pea     ($0001).w
    pea     -$81(a6)
    jsr AnimateInfoPanel
    cmpi.b  #$3b, $2(a2)
    beq.b   l_22aca
    moveq   #$5,d0
    bra.b   l_22acc
l_22aca:
    moveq   #$6,d0
l_22acc:
    move.l  d0, -(a7)
    jsr InitInfoPanel
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.b  #$3b, $2(a2)
    beq.b   l_22af2
    pea     ($00047FB8).l
    bra.b   l_22af8
l_22af2:
    pea     ($00047FC2).l
l_22af8:
    pea     ($00047F70).l
    pea     -$80(a6)
    jsr sprintf
    pea     -$80(a6)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $2c(a7), a7
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    pea     ($0001).w
    pea     -$81(a6)
    jsr PlaceItemTiles
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    movem.l -$90(a6), d2/a2-a3
    unlk    a6
    rts
