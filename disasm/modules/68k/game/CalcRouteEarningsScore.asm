; ============================================================================
; CalcRouteEarningsScore -- Computes a per-route earnings score for a single city/player combination: scans character and route arrays for matching entries (by city index and season flag), accumulates a weighted sum factored by number of qualified characters, adjusts by year difficulty and remaining turns, and returns the result in D3.
; 364 bytes | $01E6E8-$01E853
; ============================================================================
CalcRouteEarningsScore:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d6
    lea     $e(a6), a5
    cmpi.w  #$20, (a5)
    bcc.b   l_1e72a
    move.w  (a5), d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$6,d7
    bra.b   l_1e74c
l_1e72a:
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$4,d7
l_1e74c:
    tst.w   d3
    bne.b   l_1e754
    clr.w   d5
    bra.b   l_1e760
l_1e754:
    cmpi.w  #$1, d3
    bne.b   l_1e75e
    moveq   #$3,d5
    bra.b   l_1e760
l_1e75e:
    moveq   #$2,d5
l_1e760:
    clr.w   d3
    clr.w   d4
    clr.w   d2
    bra.b   l_1e7a0
l_1e768:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bne.b   l_1e79a
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d5, d0
    bne.b   l_1e79a
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d3
    addq.w  #$1, d4
l_1e79a:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
l_1e7a0:
    cmp.w   d7, d2
    bcs.b   l_1e768
    tst.w   d4
    beq.b   l_1e81e
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$6A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
    moveq   #$0,d0
    move.w  (a5), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.w  (a5), d1
    cmp.l   d1, d0
    bne.b   l_1e81e
    moveq   #$0,d0
    move.w  (a5), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    move.w  d0, d2
    beq.b   l_1e81c
    move.w  d3, d0
    ext.l   d0
    divu.w  d2, d0
    move.w  d0, d3
    bra.b   l_1e81e
l_1e81c:
    clr.w   d3
l_1e81e:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    moveq   #$3,d1
    sub.l   d0, d1
    move.l  d1, d0
    lsl.l   #$2, d0
    add.l   d1, d0
    addi.l  #$f, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$A,d1
    jsr UnsignedDivide
    move.w  d0, d3
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
