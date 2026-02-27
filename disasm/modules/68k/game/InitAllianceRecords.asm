; ============================================================================
; InitAllianceRecords -- Scores and sorts alliance candidates for a player, displays proposal text, returns success flag
; 1012 bytes | $0302C4-$0306B7
; ============================================================================
InitAllianceRecords:
    link    a6,#-$18C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr FindBestCharValue
    addq.l  #$4, a7
    move.w  d0, -$42(a6)
    clr.w   -$44(a6)
    clr.w   -$46(a6)
    clr.w   d3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    lea     -$24(a6), a5
    move.w  -$44(a6), d0
    lsl.w   #$2, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a4
.l3030c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    bne.b   .l30384
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   .l30384
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.w   d1, d0
    move.w  d0, -$48(a6)
    moveq   #$0,d2
    move.b  (a3), d2
    bra.b   .l3037e
.l3035c:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   .l3037c
    move.w  d2, d4
    bra.b   .l30384
.l3037c:
    addq.w  #$1, d2
.l3037e:
    cmp.w   -$48(a6), d2
    blt.b   .l3035c
.l30384:
    cmpi.w  #$ff, d4
    bne.w   .l30440
    pea     ($0008).w
    clr.l   -(a7)
    pea     -$8(a6)
    jsr MemFillByte
    lea     $c(a7), a7
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.w   d1, d0
    move.w  d0, -$48(a6)
    moveq   #$0,d2
    move.b  (a3), d2
    bra.b   .l30422
.l303b6:
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  (a2), d4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    moveq   #$A,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.b  $1(a2), d1
    mulu.w  d1, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    move.w  d0, -$2(a6)
    move.w  d2, -$4(a6)
    pea     ($0002).w
    pea     -$8(a6)
    jsr SortWordPairs
    addq.l  #$8, a7
    addq.w  #$1, d2
.l30422:
    cmp.w   -$48(a6), d2
    blt.b   .l303b6
    tst.w   -$6(a6)
    beq.b   .l30460
    move.w  -$8(a6), (a4)
    move.w  -$6(a6), $2(a4)
    addq.l  #$4, a4
    addq.w  #$1, -$44(a6)
    bra.b   .l30460
.l30440:
    move.w  d4, (a5)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    move.w  d0, $2(a5)
    addq.l  #$4, a5
    addq.w  #$1, -$46(a6)
.l30460:
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    blt.w   .l3030c
    move.w  -$46(a6), d0
    move.l  d0, -(a7)
    pea     -$24(a6)
    jsr SortWordPairs
    move.w  -$44(a6), d0
    move.l  d0, -(a7)
    pea     -$40(a6)
    jsr SortWordPairs
    lea     $10(a7), a7
    clr.w   -$4a(a6)
    clr.w   d3
    bra.w   .l305aa
.l3049a:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d5
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   -$42(a6), d4
    bhi.w   .l3059e
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindRelationIndex
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    bne.w   .l3059e
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr LoadScreenPalette
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004477A).l
    pea     -$18a(a6)
    jsr sprintf
    pea     -$18a(a6)
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$ea(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, $12(a6)
    addq.w  #$1, $e(a6)
    cmpi.w  #$2, $e(a6)
    ble.b   .l305a8
    move.w  #$1, -$4a(a6)
    bra.b   .l305a8
.l30594:
    move.w  d3, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d6
    move.w  d3, d2
.l3059e:
    addq.w  #$1, d2
    cmp.w   -$46(a6), d2
    blt.w   .l3049a
.l305a8:
    addq.w  #$1, d3
.l305aa:
    cmp.w   -$46(a6), d3
    bge.b   .l305b6
    tst.w   -$4a(a6)
    beq.b   .l30594
.l305b6:
    clr.w   -$4a(a6)
    clr.w   d2
    bra.w   .l3069c
.l305c0:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d6
    clr.w   d3
    bra.w   .l30692
.l305ce:
    move.w  d3, d0
    lsl.w   #$2, d0
    move.w  -$40(a6, d0.w), d5
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    move.w  d0, d4
    cmp.w   -$42(a6), d4
    bhi.w   .l30690
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
    jsr LoadScreenPalette
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047B8C).l, -(a7)
    pea     -$ea(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $2c(a7), a7
    move.w  #$1, $12(a6)
    move.w  #$1, -$4a(a6)
    bra.b   .l3069a
.l30690:
    addq.w  #$1, d3
.l30692:
    cmp.w   -$44(a6), d3
    blt.w   .l305ce
.l3069a:
    addq.w  #$1, d2
.l3069c:
    cmp.w   -$46(a6), d2
    bge.b   .l306aa
    tst.w   -$4a(a6)
    beq.w   .l305c0
.l306aa:
    move.w  $12(a6), d0
    movem.l -$1b4(a6), d2-d7/a2-a5
    unlk    a6
    rts
