; ============================================================================
; IsAllianceSlotValid -- Checks if player alliance slot is empty or if profit ratio meets threshold; returns 1 if invalid
; 308 bytes | $030A14-$030B47
; ============================================================================
IsAllianceSlotValid:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    lea     $a(a6), a3
    movea.l  #$00047B94,a4
    movea.l  #$0001D6A4,a5
    move.w  (a3), d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d7
    move.b  $4(a2), d7
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d7
    tst.w   d7
    bne.b   .l30a74
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    moveq   #$1,d0
    bra.w   .l30b3e
.l30a74:
    move.w  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0121,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$2(a6)
    clr.w   d5
    clr.w   d4
    move.w  (a3), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   .l30ada
.l30aa6:
    addq.w  #$1, d4
    moveq   #$0,d2
    move.b  $b(a2), d2
    moveq   #$0,d6
    move.b  $3(a2), d6
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $c(a7), a7
    move.w  d0, d2
    cmp.w   -$2(a6), d2
    ble.b   .l30ad4
    addq.w  #$1, d5
.l30ad4:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
.l30ada:
    cmp.w   d7, d3
    blt.b   .l30aa6
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr MulDiv
    lea     $c(a7), a7
    cmpi.w  #$32, d0
    bls.b   .l30b3c
    cmpi.w  #$5, d4
    ble.b   .l30b20
    pea     ($0002).w
    move.l  $50(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
.l30b20:
    pea     ($0002).w
    move.l  $54(a4), -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    bsr.w ShowText
.l30b3c:
    moveq   #$0,d0
.l30b3e:
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
