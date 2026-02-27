; ============================================================================
; CheckLevelUpCond -- Adjusts match-score accumulators for each char slot based on IsCharInActiveMatch results
; 208 bytes | $035264-$035333
; ============================================================================
CheckLevelUpCond:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    movea.l  #$00FF8824,a3
    clr.w   d2
l_35284:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d3
    lsl.l   d0, d3
    move.l  (a4), d0
    and.l   d3, d0
    bne.b   l_352d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (IsCharInActiveMatch,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_352d2
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d3
    sub.b   d3, $1(a3)
    sub.b   d3, (a2)
l_352d2:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   l_35284
    movea.l  #$00FF8864,a3
    moveq   #$20,d2
l_352e4:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (IsCharInActiveMatch,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_35324
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d3
    sub.b   d3, $1(a3)
    sub.b   d3, (a2)
l_35324:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_352e4
    movem.l (a7)+, d2-d4/a2-a4
    rts
