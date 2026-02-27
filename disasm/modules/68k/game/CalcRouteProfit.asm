; ============================================================================
; CalcRouteProfit -- Computes quarterly profit for all of a player's routes; processes route bitmasks, calls UpdateRouteRevenue, and updates player finance totals.
; 1182 bytes | $012076-$012513
; ============================================================================
CalcRouteProfit:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), -$c(a6)
    pea     ($000E).w
    pea     -$1a(a6)
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
    moveq   #$1,d5
    bra.b   .l120fc
.l120d4:
    move.l  d3, d0
    and.l   d5, d0
    beq.b   .l120f8
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteValue,PC)
    nop
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    add.l   d0, $6(a3)
.l120f8:
    addq.w  #$1, d2
    add.l   d5, d5
.l120fc:
    cmpi.w  #$20, d2
    blt.b   .l120d4
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9D2C,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
.l12128:
    cmpi.b  #$ff, (a2)
    beq.w   .l12240
    move.b  $a(a2), d0
    btst    #$7, d0
    beq.w   .l12232
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0
    sub.b   d0, $1(a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0
    sub.b   d0, $1(a4)
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lsr.l   #$1, d0
    add.l   d0, $6(a3)
    moveq   #$0,d3
    move.b  $2(a2), d3
    asr.l   #$4, d3
    andi.w  #$f, d3
    move.b  $2(a2), d5
    andi.w  #$f, d5
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    add.b   d5, $1(a4)
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $18(a7), a7
    move.b  #$ff, (a2)
    move.b  #$ff, $1(a2)
    moveq   #$28,d3
    sub.w   d2, d3
    addi.w  #$ffff, d3
    tst.w   d3
    ble.b   .l12238
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$14,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    jsr MemFillByte
    lea     $20(a7), a7
    move.b  #$ff, (a5)
    move.b  #$ff, $1(a5)
    bra.b   .l12238
.l12232:
    addq.w  #$1, d2
    moveq   #$14,d0
    adda.l  d0, a2
.l12238:
    cmpi.w  #$28, d2
    blt.w   .l12128
.l12240:
    move.b  #$1, $2(a3)
    clr.b   $3(a3)
    clr.b   $4(a3)
    clr.b   $5(a3)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    pea     ($0007).w
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    pea     (a0, d0.w)
    jsr MemFillByte
    pea     ($000E).w
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    jsr MemFillByte
    lea     $18(a7), a7
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.w  d4, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$8(a6)
.l122e2:
    cmpi.b  #$ff, (a2)
    beq.w   .l124ac
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    cmp.w   d5, d3
    beq.w   .l123d2
    addq.b  #$1, $4(a3)
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d6
    lsl.l   d0, d6
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d7
    lsl.l   d0, d7
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l1236e
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)
.l1236e:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0
    bne.b   .l12392
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)
.l12392:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l123ae
    move.b  (a2), d6
    move.b  $1(a2), (a2)
    move.b  d6, $1(a2)
.l123ae:
    moveq   #$1,d0
    lsl.b   d5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   -$8(a6), d1
    movea.l d1, a0
    or.b    d0, (a0)
    moveq   #$1,d0
    lsl.b   d3, d0
    move.w  d5, d1
    ext.l   d1
    add.l   -$8(a6), d1
    movea.l d1, a0
    or.b    d0, (a0)
    bra.w   .l124ac
.l123d2:
    addq.b  #$1, $5(a3)
    cmpi.b  #$20, (a2)
    bcc.b   .l1240a
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d6
    lsl.l   d0, d6
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l1243e
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)
    bra.b   .l1243e
.l1240a:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $2(a4), d1
    sub.w   d1, d0
    moveq   #$1,d6
    lsl.w   d0, d6
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d6, d0
    bne.b   .l1243e
    addq.b  #$1, $3(a3)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d6, (a0)
.l1243e:
    cmpi.b  #$20, $1(a2)
    bcc.b   .l12476
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d7
    lsl.l   d0, d7
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0
    bne.b   .l124ac
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)
    bra.b   .l124ac
.l12476:
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  $2(a5), d1
    sub.w   d1, d0
    moveq   #$1,d3
    lsl.w   d0, d3
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d3, d0
    bne.b   .l124ac
    addq.b  #$1, $3(a3)
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d3, (a0)
.l124ac:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.w   .l122e2
    clr.w   d2
.l124bc:
    move.w  d4, d0
    mulu.w  #$e, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d0.w), d0
    not.w   d0
    move.w  d2, d1
    add.w   d1, d1
    and.w   d0, -$1a(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l124bc
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    not.l   d0
    and.l   d0, -$c(a6)
    pea     -$1a(a6)
    move.l  -$c(a6), -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w UpdateRouteRevenue
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts
