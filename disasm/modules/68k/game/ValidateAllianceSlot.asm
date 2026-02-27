; ============================================================================
; ValidateAllianceSlot -- Checks player route capacity, presents AI alliance offer dialogue; returns 1 if slot is usable
; 324 bytes | $0306B8-$0307FB
; ============================================================================
ValidateAllianceSlot:
    link    a6,#-$A0
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0002FBD6,a3
    movea.l  #$00047B0C,a4
    clr.w   d4
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.w   d1, d0
    cmpi.w  #$28, d0
    blt.w   .l307f0
    moveq   #$1,d4
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountRouteFlags
    addq.l  #$4, a7
    move.w  d0, d3
    cmpi.w  #$6, d0
    bge.w   .l3079c
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    moveq   #$6,d0
    sub.w   d3, d0
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   .l30736
    pea     ($00044794).l
    bra.b   .l3073c
.l30736:
    pea     ($0004478C).l
.l3073c:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    cmpi.w  #$1, d3
    bne.b   .l30750
    pea     ($000447A0).l
    bra.b   .l30756
.l30750:
    pea     ($0004479C).l
.l30756:
    move.l  $18(a4), -(a7)
    pea     -$a0(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     -$a0(a6)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l30794
    clr.l   -(a7)
    move.l  $10(a4), -(a7)
    bra.b   .l307e6
.l30794:
    clr.l   -(a7)
    move.l  $14(a4), -(a7)
    bra.b   .l307e6
.l3079c:
    clr.l   -(a7)
    move.l  ($00047B0C).l, -(a7)
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l307e0
    clr.l   -(a7)
    move.l  $c(a4), -(a7)
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  $8(a4), -(a7)
    clr.l   -(a7)
    bra.b   .l307ea
.l307e0:
    clr.l   -(a7)
    move.l  $4(a4), -(a7)
.l307e6:
    pea     ($0001).w
.l307ea:
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a3)
.l307f0:
    move.w  d4, d0
    movem.l -$b8(a6), d2-d4/a2-a4
    unlk    a6
    rts
