; ============================================================================
; RunAircraftParamShuffle -- Randomize character stat entries for each player using region lookup and stat descriptor tables
; 396 bytes | $00C3B4-$00C53F
; ============================================================================
RunAircraftParamShuffle:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    clr.w   d6
    move.w  d6, d0
    mulu.w  #$a, d0
    movea.l  #$00FF03B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$00FF03E0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l0c3e6:
    moveq   #$0,d0
    move.b  $1(a5), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    ext.l   d0
    moveq   #$7,d1
    jsr SignedMod
    move.w  d0, d5
    pea     ($000E).w
    pea     -$e(a6)
    move.w  d5, d0
    mulu.w  #$e, d0
    movea.l  #$00047692,a0
    pea     (a0, d0.w)
    jsr MemMove
    lea     $10(a7), a7
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00047684,a0
    move.w  (a0,d0.w), d2
    clr.w   d3
    move.w  d2, d0
    sub.w   d3, d0
    add.w   d0, d0
    lea     -$10(a6, d0.w), a0
    movea.l a0, a2
    bra.b   .l0c46e
.l0c440:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d3, d1
    sub.l   d1, d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d4
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d7
    move.w  d4, d0
    add.w   d0, d0
    move.w  (a2), -$e(a6, d0.w)
    move.w  d7, (a2)
    subq.l  #$2, a2
    addq.w  #$1, d3
.l0c46e:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    blt.b   .l0c440
    pea     ($000A).w
    move.l  a4, -(a7)
    pea     -$e(a6)
    jsr MemMove
    lea     $c(a7), a7
    cmpi.w  #$5, d5
    bne.w   .l0c51c
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l  #$000473A0,a0
    move.l  (a0,d0.l), (a3)
    clr.w   d4
    clr.w   d2
    moveq   #$0,d0
    move.w  d4, d0
    add.l   d0, d0
    lea     (a4,d0.l), a0
    movea.l a0, a2
    bra.b   .l0c514
.l0c4ca:
    move.w  (a2), d5
    cmpi.w  #$1b, d5
    bcs.b   .l0c4ee
    cmpi.w  #$1d, d5
    bhi.b   .l0c4ee
    move.w  d2, d0
    andi.w  #$1, d0
    bne.b   .l0c4ee
    move.w  d3, d0
    add.w   d0, d0
    addi.w  #$21, d0
    move.w  d0, (a2)
    ori.w   #$1, d2
.l0c4ee:
    cmpi.w  #$1e, d5
    bcs.b   .l0c510
    cmpi.w  #$20, d5
    bhi.b   .l0c510
    move.w  d2, d0
    andi.w  #$2, d0
    bne.b   .l0c510
    move.w  d3, d0
    add.w   d0, d0
    addi.w  #$22, d0
    move.w  d0, (a2)
    ori.w   #$2, d2
.l0c510:
    addq.l  #$2, a2
    addq.w  #$1, d4
.l0c514:
    cmpi.w  #$5, d4
    bcs.b   .l0c4ca
    bra.b   .l0c522
.l0c51c:
    move.l  ($00047390).l, (a3)
.l0c522:
    addq.l  #$4, a3
    moveq   #$A,d0
    adda.l  d0, a4
    addq.w  #$1, d6
    moveq   #$24,d0
    adda.l  d0, a5
    cmpi.w  #$4, d6
    bcs.w   .l0c3e6
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
