; ============================================================================
; AnalyzeRouteProfit -- Computes expected route revenue for all players by combining char stats, city popularity, game-turn scaling, and route-slot assignment counts; updates per-player revenue forecast buffers and deducts total costs from cash balance.
; 824 bytes | $029580-$0298B7
; ============================================================================
AnalyzeRouteProfit:
    link    a6,#-$4
    movem.l d2-d5/a2-a5, -(a7)
    pea     ($0018).w
    clr.l   -(a7)
    pea     ($00FF0290).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF1298,a3
    move.l  #$ff8824, -$4(a6)
    clr.w   d4
l_295ae:
    movea.l -$4(a6), a0
    tst.b   $1(a0)
    beq.w   l_2968c
    movea.l  #$00FF0290,a4
    move.w  d4, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    movea.l  #$00FF0018,a5
    clr.w   d3
l_295d8:
    tst.b   (a2)
    beq.w   l_2967a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.l  d0, d2
    ext.l   d2
    addq.l  #$2, d2
    move.l  d2, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$A,d1
    jsr SignedDiv
    cmpi.w  #$1, d0
    ble.b   l_29620
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$A,d1
    jsr SignedDiv
    ext.l   d0
    bra.b   l_29622
l_29620:
    moveq   #$1,d0
l_29622:
    moveq   #$0,d1
    move.b  (a2), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr Multiply32
    move.l  d0, d2
    asr.l   #$2, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_29674
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_29676
l_29674:
    moveq   #$1,d0
l_29676:
    move.w  d0, d2
    add.w   d2, (a4)
l_2967a:
    addq.l  #$6, a4
    addq.l  #$2, a2
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_295d8
l_2968c:
    addq.l  #$4, a3
    addq.l  #$2, -$4(a6)
    addq.w  #$1, d4
    cmpi.w  #$59, d4
    bcs.w   l_295ae
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    clr.w   d3
l_296aa:
    clr.w   d5
l_296ac:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.b   l_2972a
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    addq.w  #$1, d0
    move.l  d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    addi.w  #$14, d0
    mulu.w  d0, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    addi.l  #$1e, d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    add.w   d2, $2(a4)
l_2972a:
    addq.w  #$1, d5
    cmpi.w  #$7, d5
    bcs.w   l_296ac
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_296aa
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    clr.w   d3
l_29752:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d4
l_29764:
    cmpi.b  #$1, $1(a2)
    bne.b   l_297d0
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d2, d1
    addq.l  #$1, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_297b4
    addq.l  #$3, d0
l_297b4:
    asr.l   #$2, d0
    move.w  d0, d2
    cmpi.w  #$1, d2
    bcc.b   l_297c2
    moveq   #$1,d0
    bra.b   l_297c6
l_297c2:
    moveq   #$0,d0
    move.w  d2, d0
l_297c6:
    move.w  d0, d2
    add.w   d2, $4(a2)
    add.w   d2, $4(a4)
l_297d0:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.b   l_29764
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_29752
    movea.l  #$00FF03F0,a3
    movea.l  #$00FF0120,a2
    clr.w   d3
l_297f8:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    move.w  d0, (a3)
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    move.w  d0, $2(a3)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $24(a7), a7
    move.w  d0, $4(a3)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_297f8
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0290,a4
    movea.l  #$00FF03F0,a3
    clr.w   d3
l_2986e:
    moveq   #$0,d2
    move.w  (a4), d2
    moveq   #$0,d0
    move.w  $2(a4), d0
    add.l   d0, d2
    moveq   #$0,d0
    move.w  $4(a4), d0
    add.l   d0, d2
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  $2(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  $4(a3), d1
    add.l   d1, d0
    add.l   d0, d2
    sub.l   d2, $6(a5)
    moveq   #$24,d0
    adda.l  d0, a5
    addq.l  #$6, a4
    moveq   #$C,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_2986e
    movem.l -$24(a6), d2-d5/a2-a5
    unlk    a6
    rts
