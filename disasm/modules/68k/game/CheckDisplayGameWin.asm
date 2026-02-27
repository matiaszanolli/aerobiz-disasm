; ============================================================================
; CheckDisplayGameWin -- Checks whether any player has met the win condition (6+ route flags covering enough cities) every fourth turn; if so calls DisplayPlayerLeaderboard, and if the turn limit is reached transitions to the end-game screen.
; 224 bytes | $02763C-$02771B
; ============================================================================
CheckDisplayGameWin:
    movem.l d2-d5/a2-a4, -(a7)
    move.w  ($00FF0004).l, d5
    addq.w  #$4, d5
    cmpi.w  #$7, d5
    bcc.b   l_27654
    moveq   #$0,d0
    move.w  d5, d0
    bra.b   l_27656
l_27654:
    moveq   #$7,d0
l_27656:
    move.w  d0, d5
    movea.l  #$00FF0018,a4
    clr.w   d4
    move.w  d4, d0
    lsl.w   #$4, d0
    movea.l  #$00FFBE00,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
l_27670:
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    cmpi.w  #$1, (a3,a0.l)
    bne.b   l_276e2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w CountRouteFlags
    addq.l  #$4, a7
    cmpi.w  #$6, d0
    bcs.b   l_276e2
    clr.w   d2
    movea.l a3, a2
    clr.w   d3
l_276ac:
    cmpi.w  #$1, (a2)
    bne.b   l_276b4
    addq.w  #$1, d2
l_276b4:
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    bcs.b   l_276ac
    cmp.w   d5, d2
    bcs.b   l_276e2
    move.b  d4, ($00FF0016).l
    pea     ($0064).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (DisplayPlayerLeaderboard,PC)
    nop
    lea     $c(a7), a7
l_276e2:
    moveq   #$24,d0
    adda.l  d0, a4
    moveq   #$10,d0
    adda.l  d0, a3
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_27670
    move.w  ($00FF0006).l, d0
    cmp.w   ($00FFA6B2).l, d0
    blt.b   l_27716
    jsr ClearBothPlanes
    pea     ($0004).w
    jsr ShowPlayerScreen
    addq.l  #$4, a7
l_27714:
    bra.b   l_27714
l_27716:
    movem.l (a7)+, d2-d5/a2-a4
    rts
