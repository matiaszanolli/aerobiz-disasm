; ============================================================================
; SearchCharInAlliances -- Ranks candidate alliances for current player, shows negotiation dialogue, calls InitAllianceRecords
; 708 bytes | $030000-$0302C3
; ============================================================================
SearchCharInAlliances:
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    bra.w   .l30144
.l30010:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.b   .l30092
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   .l30092
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  (a2), d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d7
    moveq   #$0,d3
    move.b  (a2), d3
    bra.b   .l3008e
.l3006c:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   .l3008c
    move.w  d3, d2
    bra.b   .l30092
.l3008c:
    addq.w  #$1, d3
.l3008e:
    cmp.w   d7, d3
    blt.b   .l3006c
.l30092:
    cmpi.w  #$ff, d2
    beq.w   .l30142
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    beq.w   .l30142
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l30110
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.w   d1, d0
    lsl.w   #$2, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.w   d1, d0
    add.w   d0, d0
    bra.b   .l30136
.l30110:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    ext.l   d1
    sub.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    ext.l   d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    jsr SignedDiv
.l30136:
    addi.w  #$64, d0
    move.w  d0, $2(a3)
    addq.l  #$4, a3
    addq.w  #$1, d6
.l30142:
    addq.w  #$1, d4
.l30144:
    cmpi.w  #$7, d4
    blt.w   .l30010
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    jsr SortWordPairs
    addq.l  #$8, a7
    clr.w   d7
    clr.w   d3
    clr.w   d4
    movea.l a5, a2
    addq.l  #$8, a2
.l30164:
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d6
    tst.w   d4
    bne.b   .l30184
    move.w  -$1c(a6), d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l3026e
    bra.b   .l301b6
.l30184:
    move.w  (a2), d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   .l301a2
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l301a2
    move.w  (a2), d6
.l301a2:
    move.w  d6, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   .l301b6
    move.w  -$1c(a6), d6
    pea     ($0002).w
    bra.b   .l301ba
.l301b6:
    pea     ($0001).w
.l301ba:
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr RankCharCandidates
    lea     $c(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l30264
    pea     (-$1).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr LoadScreenPalette
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044768).l
    pea     -$15c(a6)
    jsr sprintf
    pea     -$15c(a6)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$bc(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$bc(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    addq.w  #$1, d3
    moveq   #$1,d7
.l30264:
    addq.w  #$1, d4
    cmpi.w  #$2, d4
    blt.w   .l30164
.l3026e:
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (InitAllianceRecords,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    tst.w   d7
    bne.b   .l302b0
    clr.l   -(a7)
    move.l  ($00047B90).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    bra.b   .l302ba
.l302b0:
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowPlayerChart
.l302ba:
    movem.l -$184(a6), d2-d7/a2-a5
    unlk    a6
    rts
