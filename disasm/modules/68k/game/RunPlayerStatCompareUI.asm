; ============================================================================
; RunPlayerStatCompareUI -- Run the player stat comparison screen with scrollable list navigation
; 520 bytes | $00E4AA-$00E6B1
; ============================================================================
RunPlayerStatCompareUI:
    link    a6,#$0
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $c(a6), d6
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00FFBD58,a4
    moveq   #$1,d4
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($000477A4).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    clr.w   d2
    clr.w   d3
    clr.w   (a4)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DrawPlayerComparisonStats
    addq.l  #$8, a7
l_0e538:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   l_0e538
    clr.w   d5
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d3
l_0e554:
    tst.w   (a4)
    beq.b   l_0e576
    cmpi.w  #$1, d4
    bne.b   l_0e57c
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DrawPlayerComparisonStats
    addq.l  #$8, a7
    clr.w   d2
    clr.w   d4
    bra.b   l_0e57c
l_0e576:
    clr.w   d4
    move.w  #$1, (a4)
l_0e57c:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
l_0e5c0:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    move.w  d0, d5
    andi.l  #$33, d0
    beq.b   l_0e5c0
    move.w  d5, d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_0e5fc
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   l_0e652
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_0e65a
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_0e67e
    bra.w   l_0e698
l_0e5fc:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0546).w
    jsr TilePlacement
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  d3, d0
    add.w   d2, d0
    move.w  d0, d2
l_0e63e:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $c(a7), a7
    move.w  d2, d0
    bra.b   l_0e6a8
l_0e652:
    clr.w   (a3)
    move.w  #$ff, d2
    bra.b   l_0e63e
l_0e65a:
    move.w  #$1, (a3)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.w  d6, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_0e698
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   l_0e698
    addq.w  #$5, d3
    bra.b   l_0e696
l_0e67e:
    move.w  #$1, (a3)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    subq.l  #$1, d0
    blt.b   l_0e698
    subq.w  #$1, d2
    bge.b   l_0e698
    subq.w  #$5, d3
l_0e696:
    moveq   #$1,d4
l_0e698:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.w   l_0e554
l_0e6a8:
    movem.l -$20(a6), d2-d6/a2-a4
    unlk    a6
    rts
