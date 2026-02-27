; ============================================================================
; RunAIMainLoop -- AI negotiation decision loop: evaluates character compatibility, profit, and skill; shows dialogue and makes offers
; 2986 bytes | $03131A-$031EC3
; ============================================================================
RunAIMainLoop:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    lea     -$ae(a6), a5
    move.w  d7, d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    move.w  d0, -$b6(a6)
    tst.w   $6(a4)
    beq.w   .l31dc6
    move.b  $a(a4), d0
    andi.l  #$2, d0
    bne.w   .l31dc6
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l313a4
    addq.l  #$1, d0
.l313a4:
    asr.l   #$1, d0
    move.w  d0, d3
    move.w  d2, d0
    add.w   d3, d0
    move.w  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    lea     $10(a7), a7
    move.w  d0, -$8(a6)
    clr.w   -$c(a6)
    clr.w   d6
    clr.w   d2
.l313e0:
    cmp.w   d7, d2
    beq.b   .l31442
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d5
    move.b  $4(a2), d5
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d5
    clr.w   d3
    bra.b   .l3143e
.l3141a:
    move.b  (a3), d0
    cmp.b   (a4), d0
    bne.b   .l3143c
    move.b  $1(a3), d0
    cmp.b   $1(a4), d0
    bne.b   .l3143c
    moveq   #$0,d0
    move.b  $3(a3), d0
    tst.w   d0
    ble.b   .l3143c
    addq.w  #$1, d6
    move.w  d2, -$e(a6)
    bra.b   .l31442
.l3143c:
    addq.w  #$1, d3
.l3143e:
    cmp.w   d5, d3
    blt.b   .l3141a
.l31442:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l313e0
    cmpi.w  #$1, d6
    bne.b   .l31478
    move.w  -$e(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($00047BD0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.b   .l31486
.l31478:
    cmpi.w  #$2, d6
    blt.b   .l314a2
    clr.l   -(a7)
    move.l  ($00047BD4).l, -(a7)
.l31486:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
.l314a2:
    move.l  a4, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (PostTurnCleanup,PC)
    nop
    move.l  a4, -(a7)
    jsr GetByteField4
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    mulu.w  #$a, d3
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  $10(a4), d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $18(a7), a7
    move.w  d0, -$b4(a6)
    cmpi.w  #$5c, -$b4(a6)
    blt.w   .l317e2
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bcs.w   .l31716
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.w   d1, d0
    move.w  d0, -$2(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmp.w   -$2(a6), d2
    ble.b   .l3155a
    move.w  -$2(a6), d0
    bra.b   .l3155c
.l3155a:
    move.w  d2, d0
.l3155c:
    ext.l   d0
    move.w  d0, -$4(a6)
    move.b  $3(a4), d0
    cmp.b   $b(a4), d0
    bcc.b   .l315a0
    tst.w   -$4(a6)
    ble.b   .l315a0
    cmpi.b  #$e, $3(a4)
    bcc.b   .l315a0
    pea     ($000448B0).l
    move.l  ($00047BB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    pea     ($0001).w
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.w   .l31cd0
.l315a0:
    clr.w   d6
    move.l  a4, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2
    moveq   #-$1,d5
    move.w  #$7530, -$b0(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    bge.b   .l315dc
    addq.l  #$3, d0
.l315dc:
    asr.l   #$2, d0
    move.w  d0, -$b2(a6)
    clr.w   d2
.l315e4:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr CheckCharEligible
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3162c
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    ble.b   .l3162c
    move.w  $2(a2), d0
    cmp.w   -$8(a6), d0
    bcs.b   .l3162c
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  -$b2(a6), d4
    sub.w   d0, d4
    tst.w   d4
    bge.b   .l3161e
    neg.w   d4
.l3161e:
    cmp.w   -$b0(a6), d4
    bge.b   .l3162c
    move.w  d4, -$b0(a6)
    move.w  d2, d5
    moveq   #$1,d6
.l3162c:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2
    cmpi.w  #$10, d2
    blt.b   .l315e4
    cmpi.w  #$1, d6
    bne.w   .l316da
    cmpi.w  #$5f, -$b4(a6)
    blt.w   .l316da
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l3167a
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l316b0
.l3167a:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000448A8).l
    move.l  ($00047BB4).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l316c0
.l316b0:
    pea     ($00044878).l
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l316c0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l316da:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$62, -$b4(a6)
    blt.w   .l31ce2
    cmpi.w  #$1, d6
    bne.b   .l31702
.l316f6:
    clr.l   -(a7)
    move.l  ($00047BB8).l, -(a7)
    bra.w   .l31ccc
.l31702:
    move.l  ($00047BBC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
    bra.w   .l31cc8
.l31716:
    clr.w   -$c(a6)
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBestCharForSlot
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d5
    beq.w   .l317ca
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31770
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l317a0
.l31770:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   .l317b0
.l317a0:
    pea     ($0004483C).l
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l317b0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l317ca:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$ff, d5
    bne.w   .l316f6
    bra.w   .l31702
.l317e2:
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bcc.w   .l318ac
    cmpi.w  #$2, -$b6(a6)
    blt.w   .l3187c
    cmpi.w  #$3, -$b6(a6)
    bne.b   .l3182a
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BF4).l, -(a7)
    bra.b   .l31852
.l3182a:
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047C04).l, -(a7)
.l31852:
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a5, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
.l3187c:
    cmpi.w  #$1, ($00FF99A0).l
    bne.b   .l318ac
    pea     ($0002).w
    move.l  ($00047BC8).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
.l318ac:
    clr.w   d6
    move.l  a4, -(a7)
    jsr GetByteField4
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2
    moveq   #-$1,d5
    pea     ($0001).w
    move.l  a4, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharProfit
    lea     $14(a7), a7
    move.w  d0, d4
    clr.w   d2
.l31904:
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr CheckCharEligible
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3195a
    move.w  $2(a2), d0
    cmp.w   -$8(a6), d0
    bcs.b   .l3195a
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharProfit
    lea     $10(a7), a7
    move.w  d0, -$a(a6)
    cmp.w   -$a(a6), d4
    ble.b   .l3195a
    move.w  -$a(a6), d4
    move.w  d2, d5
    moveq   #$1,d6
.l3195a:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2
    cmpi.w  #$10, d2
    blt.b   .l31904
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmpi.w  #$3, d0
    blt.w   .l31a4a
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31a4a
    pea     ($00044832).l
    move.l  ($00047BB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $1c(a7), a7
    move.w  #$1, -$c(a6)
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31a00
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31a1e
.l31a00:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   .l31a24
.l31a1e:
    pea     ($00044824).l
.l31a24:
    move.l  ($00047BCC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $1c(a7), a7
    bra.w   .l31b40
.l31a4a:
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31af8
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31aa8
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31ade
.l31aa8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004481C).l
    move.l  ($00047BB4).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l31aee
.l31ade:
    pea     ($000447EA).l
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l31aee:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.b   .l31b2e
.l31af8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
.l31b2e:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l31b40:
    clr.w   d4
    clr.w   d2
    clr.w   d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  $4(a4), d0
    sub.w   d5, d0
    ext.l   d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d5, d1
    ext.l   d1
    jsr SignedDiv
    move.w  d0, d6
    move.w  d6, d5
    addi.w  #$fffb, d5
    move.w  d5, d0
    ext.l   d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    bge.b   .l31b94
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31b96
.l31b94:
    moveq   #-$32,d0
.l31b96:
    move.w  d0, d5
    cmp.w   d5, d6
    beq.b   .l31bce
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    tst.w   d0
    bne.b   .l31bce
    cmpi.w  #$32, -$b4(a6)
    bgt.b   .l31bce
    move.w  $e(a4), d0
    cmp.w   $6(a4), d0
    bls.b   .l31bce
    moveq   #$1,d4
.l31bce:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRelationScore
    lea     $c(a7), a7
    cmp.w   $e(a4), d0
    bls.b   .l31bf6
    moveq   #$1,d3
    bra.b   .l31c2e
.l31bf6:
    move.w  d6, d5
    addq.w  #$5, d5
    cmpi.w  #$32, d5
    bge.b   .l31c06
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31c08
.l31c06:
    moveq   #$32,d0
.l31c08:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRelationScore
    lea     $c(a7), a7
    cmp.w   $e(a4), d0
    bls.b   .l31c2e
    moveq   #$1,d2
.l31c2e:
    cmpi.w  #$1, d4
    bne.b   .l31c62
    cmpi.w  #$1, d2
    bne.b   .l31c62
    clr.l   -(a7)
    move.l  ($00047C08).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
.l31c52:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    bra.w   .l31ce2
.l31c62:
    cmpi.w  #$1, d3
    bne.b   .l31c9a
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31c92
    pea     ($000447E4).l
.l31c76:
    move.l  ($00047BEC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0003).w
    bra.b   .l31c52
.l31c92:
    pea     ($000447DA).l
    bra.b   .l31cb6
.l31c9a:
    cmpi.w  #$1, d2
    bne.b   .l31ce2
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31cb0
    pea     ($000447D6).l
    bra.b   .l31c76
.l31cb0:
    pea     ($000447CE).l
.l31cb6:
    move.l  ($00047BF0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
.l31cc8:
    clr.l   -(a7)
    move.l  a5, -(a7)
.l31ccc:
    pea     ($0003).w
.l31cd0:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l31ce2:
    cmpi.w  #$1, -$c(a6)
    beq.w   .l31eba
    move.w  $e(a4), d6
    cmp.w   $6(a4), d6
    bhi.b   .l31cfa
    moveq   #$1,d6
    bra.b   .l31cfc
.l31cfa:
    moveq   #$0,d6
.l31cfc:
    cmpi.w  #$1, d6
    bne.w   .l31dba
    move.w  d7, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    jsr FindOpenSlot
    addq.l  #$8, a7
    tst.w   d0
    bne.w   .l31db0
    pea     ($0002).w
    move.l  ($00047BD8).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    moveq   #$0,d0
    move.w  $e(a4), d0
    addi.l  #$64, d0
    moveq   #$0,d1
    move.w  $6(a4), d1
    cmp.l   d1, d0
    bge.w   .l31eba
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.w   .l31eba
    cmpi.w  #$2, -$b6(a6)
    bne.b   .l31d9c
    clr.l   -(a7)
    move.l  ($00047B38).l, -(a7)
.l31d88:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    bra.w   .l31eb2
.l31d9c:
    cmpi.w  #$3, -$b6(a6)
    bne.w   .l31eba
    clr.l   -(a7)
    move.l  ($00047B3C).l, -(a7)
    bra.b   .l31d88
.l31db0:
    clr.l   -(a7)
    move.l  ($00047C00).l, -(a7)
    bra.b   .l31d88
.l31dba:
    pea     ($0001).w
    move.l  ($00047BC4).l, -(a7)
    bra.b   .l31d88
.l31dc6:
    move.b  $a(a4), d0
    btst    #$1, d0
    beq.b   .l31e0c
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BAC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.w   .l31eb0
.l31e0c:
    move.b  $a(a4), d0
    btst    #$2, d0
    beq.b   .l31e64
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BDC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BE0).l, -(a7)
    bra.b   .l31eb0
.l31e64:
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BF8).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BFC).l, -(a7)
.l31eb0:
    clr.l   -(a7)
.l31eb2:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
.l31eba:
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts
