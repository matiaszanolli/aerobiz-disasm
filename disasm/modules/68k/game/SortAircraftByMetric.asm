; ============================================================================
; SortAircraftByMetric -- Sort 16 aircraft entries by region-specific metric and write ranked order to 
; 222 bytes | $00C540-$00C61D
; ============================================================================
SortAircraftByMetric:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    pea     ($0020).w
    clr.l   -(a7)
    pea     -$20(a6)
    jsr MemFillByte
    move.w  ($00FF0002).l, d0
    movea.l  #$0005ECF8,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    pea     ($00C0).w
    pea     ($00FF).w
    pea     ($00FFA6B8).l
    jsr MemFillByte
    lea     $18(a7), a7
    movea.l  #$00FFA6B8,a3
    movea.l  #$00FF1278,a4
    clr.w   d4
.l0c594:
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$0005EDD0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    lea     -$20(a6), a5
    clr.w   d3
    moveq   #$0,d2
    move.w  d5, d2
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d2
.l0c5b6:
    tst.w   (a5)
    bne.b   .l0c5e8
    move.b  (a3), d0
    cmp.b   (a2), d0
    bhi.b   .l0c5d0
    move.b  (a3), d0
    cmp.b   (a2), d0
    bne.b   .l0c5e8
    move.b  $6(a3), d0
    cmp.b   $6(a2), d0
    bls.b   .l0c5e8
.l0c5d0:
    pea     ($000C).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    move.b  d2, (a4)
.l0c5e8:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a5
    addq.l  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    bcs.b   .l0c5b6
    moveq   #$0,d0
    move.b  (a4), d0
    sub.w   d5, d0
    add.w   d0, d0
    move.w  #$1, -$20(a6, d0.w)
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$1, a4
    addq.w  #$1, d4
    cmpi.w  #$10, d4
    bcs.b   .l0c594
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts
