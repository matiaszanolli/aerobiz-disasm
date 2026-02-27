; ============================================================================
; InitQuarterStart -- Resets a player's quarterly stats at the start of a new quarter: grants the turn stipend, clears income/expense accumulators, resets the health bar, zeroes route-slot revenue buffers, and recomputes popularity scores.
; 434 bytes | $027D66-$027F17
; ============================================================================
InitQuarterStart:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0001D520,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.w   ($00FF0004).l
    bne.b   l_27d9e
    cmpi.b  #$1, (a2)
    bne.b   l_27d9e
    addi.l  #$30d40, $6(a2)
    bra.b   l_27da6
l_27d9e:
    addi.l  #$186a0, $6(a2)
l_27da6:
    cmpi.l  #$186a0, $6(a2)
    ble.b   l_27db6
    move.l  $6(a2), d0
    bra.b   l_27dbc
l_27db6:
    move.l  #$186a0, d0
l_27dbc:
    move.l  d0, $6(a2)
    clr.l   $a(a2)
    clr.l   $e(a2)
    clr.l   $12(a2)
    clr.l   $16(a2)
    clr.l   $1a(a2)
    clr.l   $1e(a2)
    move.b  #$64, $22(a2)
    pea     ($000C).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, d4
    movea.l  #$00FF00E8,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0020).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$5, d0
    move.l  d0, d2
    movea.l  #$00FF0130,a0
    pea     (a0, d0.w)
    jsr     (a4)
    pea     ($0020).w
    clr.l   -(a7)
    movea.l  #$00FF01B0,a0
    pea     (a0, d2.w)
    jsr     (a4)
    bsr.w CalcPlayerRankings
    pea     ($0006).w
    clr.l   -(a7)
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0290,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $3(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   l_27e84
    addq.l  #$1, d0
l_27e84:
    asr.l   #$1, d0
    moveq   #$64,d1
    cmp.l   d0, d1
    ble.b   l_27e9a
    moveq   #$0,d0
    move.b  $1(a3), d0
    bge.b   l_27e96
    addq.l  #$1, d0
l_27e96:
    asr.l   #$1, d0
    bra.b   l_27e9c
l_27e9a:
    moveq   #$64,d0
l_27e9c:
    move.b  d0, $3(a2)
    moveq   #$0,d2
    move.b  $1(a2), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    move.b  d2, (a2)
    movea.l  #$00FF03F0,a0
    lea     (a0,d4.w), a2
    clr.w   (a2)
    clr.w   $2(a2)
    clr.w   $4(a2)
    clr.b   $9(a2)
    clr.b   $a(a2)
    clr.b   $b(a2)
    pea     ($0008).w
    clr.l   -(a7)
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FF09A2,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $c(a7), a7
    movem.l (a7)+, d2-d4/a2-a4
    rts
