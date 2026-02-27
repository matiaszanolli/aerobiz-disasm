; ============================================================================
; SelectCharRelation -- Populates available char-relation options for a player/route slot; counts chars via SearchCharInSlots, prints city labels, and shows quarter-bonus value or status string for each slot.
; 286 bytes | $0134F6-$013613
; ============================================================================
SelectCharRelation:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d5
    move.l  $24(a7), d6
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (SearchCharInSlots,PC)
    nop
    pea     ($0013).w
    pea     ($001F).w
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextWindow
    pea     ($0002).w
    pea     ($0001).w
    jsr     (a4)
    pea     ($0003F5EC).l
    jsr     (a3)
    pea     ($0002).w
    pea     ($0011).w
    jsr     (a4)
    pea     ($0003F5DC).l
    jsr     (a3)
    lea     $30(a7), a7
    movea.l  #$00FF9A10,a2
    moveq   #$4,d4
    clr.w   d2
l_13568:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr     (a4)
    lea     $14(a7), a7
    tst.w   (a2)
    ble.b   l_135f6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (FindSpriteByID,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_135e0
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcQuarterBonus,PC)
    nop
    move.w  d0, d3
    mulu.w  #$a, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F5D6).l
    jsr     (a3)
    lea     $c(a7), a7
    bra.b   l_13600
l_135e0:
    cmpi.w  #$4, d3
    bne.b   l_135ee
    pea     ($0003F5CA).l
    bra.b   l_135fc
l_135ee:
    pea     ($0003F5C2).l
    bra.b   l_135fc
l_135f6:
    pea     ($0003F5B4).l
l_135fc:
    jsr     (a3)
    addq.l  #$4, a7
l_13600:
    addq.w  #$2, d4
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.w   l_13568
    movem.l (a7)+, d2-d6/a2-a4
    rts
