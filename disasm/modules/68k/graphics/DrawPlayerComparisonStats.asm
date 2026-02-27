; ============================================================================
; DrawPlayerComparisonStats -- Display comparison rows for up to 5 characters showing portrait, city/char type, and computed value
; 358 bytes | $00E344-$00E4A9
; ============================================================================
DrawPlayerComparisonStats:
    link    a6,#-$C
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d6
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    lea     -$a(a6), a2
    move.w  d4, d5
    mulu.w  #$a, d5
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$5,d1
    cmp.l   d0, d1
    ble.b   l_0e386
    move.w  d6, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    bra.b   l_0e388
l_0e386:
    moveq   #$5,d0
l_0e388:
    move.w  d0, d6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0001).w
    jsr     (a4)
    pea     ($0003E8EE).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($000C).w
    jsr     (a4)
    pea     ($0003E8E4).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0018).w
    jsr     (a4)
    pea     ($0003E8DE).l
    jsr     (a3)
    lea     $24(a7), a7
    clr.w   d3
    moveq   #$5,d2
    bra.w   l_0e49a
l_0e402:
    pea     ($000A).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    jsr MemCopy
    addi.w  #$a, d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a4)
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8DA).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    jsr     (a4)
    lea     $2c(a7), a7
    move.w  $4(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2DE,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8D6).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0016).w
    jsr     (a4)
    move.l  $6(a2), d0
    lsr.l   #$2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003E8D0).l
    jsr     (a3)
    lea     $18(a7), a7
    addq.w  #$1, d4
    addq.w  #$1, d3
    addq.w  #$2, d2
l_0e49a:
    cmp.w   d6, d3
    blt.w   l_0e402
    movem.l -$2c(a6), d2-d6/a2-a4
    unlk    a6
    rts
