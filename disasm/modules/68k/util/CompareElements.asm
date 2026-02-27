; ============================================================================
; CompareElements -- Scores and ranks route entries across all 4 players: for each player-to-player pair, finds matching route type-6 entries via BitFieldSearch, calls CalcRouteEarningsScore to get a base score, then adds individual route scores from the $FFB4E4 table for matching city pairs, accumulating into $6(a3).
; 278 bytes | $01E5D2-$01E6E7
; ============================================================================
CompareElements:
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0338,a2
    clr.w   d3
l_1e5e4:
    moveq   #$0,d7
    move.b  $4(a5), d7
    moveq   #$0,d0
    move.b  $5(a5), d0
    add.w   d0, d7
    clr.w   d4
l_1e5f4:
    cmpi.b  #$6, $1(a2)
    bne.w   l_1e6c8
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bcc.w   l_1e6c8
    moveq   #$0,d0
    move.w  $6(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcRouteEarningsScore,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d6
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d3, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    mulu.w  #$140, d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d2
    move.b  $4(a5), d2
    bra.b   l_1e6c4
l_1e684:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   (a3), d0
    bne.b   l_1e6bc
    moveq   #$0,d0
    move.w  $6(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcRouteEarningsScore,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    move.w  d6, d0
    add.w   d5, d0
    add.w   d0, $6(a3)
l_1e6bc:
    moveq   #$14,d0
    adda.l  d0, a4
    addq.l  #$8, a3
    addq.w  #$1, d2
l_1e6c4:
    cmp.w   d7, d2
    bcs.b   l_1e684
l_1e6c8:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_1e5f4
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1e5e4
    movem.l (a7)+, d2-d7/a2-a5
    rts
