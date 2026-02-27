; ============================================================================
; UpdatePlayerStatusDisplay -- Collects wealth totals and asset peaks across all players, calls InitLeaderboardData, then drives the interactive quarterly-summary display loop navigating between per-player panels and the leaderboard screen.
; 374 bytes | $0263E4-$026559
; ============================================================================
UpdatePlayerStatusDisplay:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    movea.l  #$00FF0018,a4
    movea.l  #$00FF09A2,a3
    movea.l  #$00FF99E0,a2
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF99E0).l
    jsr MemFillByte
    lea     $c(a7), a7
    moveq   #$0,d3
    moveq   #$0,d6
    clr.w   d2
l_2641a:
    move.l  $a(a4), d0
    add.l   (a3), d0
    add.l   d0, (a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w CalcPlayerWealth
    addq.l  #$4, a7
    add.l   $4(a3), d0
    add.l   d0, $4(a2)
    cmp.l   (a2), d3
    bls.b   l_2643e
    move.l  d3, d0
    bra.b   l_26440
l_2643e:
    move.l  (a2), d0
l_26440:
    move.l  d0, d3
    cmp.l   $4(a2), d3
    bls.b   l_2644c
    move.l  d3, d0
    bra.b   l_26450
l_2644c:
    move.l  $4(a2), d0
l_26450:
    move.l  d0, d3
    move.l  $12(a4), $8(a2)
    cmp.l   $8(a2), d6
    bls.b   l_26462
    move.l  d6, d0
    bra.b   l_26466
l_26462:
    move.l  $8(a2), d0
l_26466:
    move.l  d0, d6
    moveq   #$24,d0
    adda.l  d0, a4
    addq.l  #$8, a3
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_2641a
    jsr (InitLeaderboardData,PC)
    nop
    moveq   #$4,d2
    moveq   #$1,d5
    clr.w   d7
l_26486:
    cmpi.w  #$5, d2
    bcc.b   l_264a8
    move.l  d6, -(a7)
    move.l  d3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderQuarterReport,PC)
    nop
    lea     $10(a7), a7
    bra.b   l_264b0
l_264a8:
    jsr (ShowGameStatus,PC)
    nop
    moveq   #$1,d7
l_264b0:
    cmpi.w  #$4, d2
    bls.b   l_264d2
l_264b6:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$30, d0
    beq.b   l_264b6
    bra.b   l_264ec
l_264d2:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$33, d0
    beq.b   l_264d2
l_264ec:
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_26504
    cmpi.w  #$5, d2
    bne.b   l_26500
    moveq   #$4,d2
    moveq   #$1,d5
    bra.b   l_26486
l_26500:
    moveq   #$5,d2
    bra.b   l_26486
l_26504:
    move.w  d4, d0
    andi.w  #$10, d0
    beq.b   l_26512
    tst.w   d7
    bne.b   l_26544
    bra.b   l_26500
l_26512:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_2652a
    tst.w   d2
    bne.b   l_26522
    moveq   #$4,d2
    bra.b   l_26524
l_26522:
    subq.w  #$1, d2
l_26524:
    clr.w   d5
    bra.w   l_26486
l_2652a:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.w   l_26486
    cmpi.w  #$4, d2
    bne.b   l_2653e
    clr.w   d2
    bra.b   l_26524
l_2653e:
    addq.w  #$1, d2
    bra.b   l_26524
    bra.b   l_26550
l_26544:
    jsr ResourceLoad
    jsr ClearBothPlanes
l_26550:
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts
