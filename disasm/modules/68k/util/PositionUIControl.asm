; ============================================================================
; PositionUIControl -- Computes and applies per-player UI bar positions: calls ResizeUIPanel for each of 4 players to get a city-slot index, then for valid (< 0x28) slots calculates scaled revenue scores from the route tables (weighted by $FF0120 popularity factors and negotiation power) and calls UpdateUIPalette to write the result, accumulating total revenue in D6.
; 700 bytes | $01FC50-$01FF0B
; ============================================================================
PositionUIControl:
    link    a6,#-$20
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d4
    clr.w   d5
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$8(a6, d0.w), a0
    movea.l a0, a2
l_1fc6a:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ResizeUIPanel,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, (a2)
    move.w  (a2), d3
    cmpi.w  #$28, d3
    bcc.b   l_1fcc8
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1fcc8
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E8,a0
    tst.w   (a0,d0.w)
    bne.b   l_1fcc4
    addq.w  #$1, d5
    bra.b   l_1fcc8
l_1fcc4:
    move.w  #$ff, (a2)
l_1fcc8:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1fc6a
    cmpi.w  #$1, d5
    bls.w   l_1fe20
    moveq   #$0,d6
    move.l  #$ff0120, -$20(a6)
    clr.w   d2
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$18(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1fd14:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fe08
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    move.l  d0, d3
    lea     (a4,d0.l), a0
    move.l  a0, -$1c(a6)
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_1fe08
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1fd82
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    bra.b   l_1fd88
l_1fd82:
    move.l  #$1, -(a7)
l_1fd88:
    movea.l -$1c(a6), a0
    move.w  (a0), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), d0
    movea.l -$1c(a6), a0
    move.w  $2(a0), d1
    andi.l  #$ffff, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   (a5,a0.l), d0
    movea.l a4, a0
    adda.l  d3, a0
    move.w  $6(a0), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr UnsignedDivide
    moveq   #$64,d1
    jsr UnsignedDivide
    move.l  d0, (a3)
    movea.l -$20(a6), a0
    move.b  (a0), d1
    andi.l  #$ff, d1
    move.l  (a3), d0
    jsr Multiply32
    move.l  d0, (a3)
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a3)
    moveq   #$1,d0
    cmp.l   (a3), d0
    bcc.b   l_1fe02
    move.l  (a3), d0
    bra.b   l_1fe04
l_1fe02:
    moveq   #$1,d0
l_1fe04:
    move.l  d0, (a3)
    add.l   (a3), d6
l_1fe08:
    addq.l  #$4, -$20(a6)
    lea     $140(a4), a4
    moveq   #$1C,d0
    adda.l  d0, a5
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fd14
l_1fe20:
    clr.w   d2
l_1fe22:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fef8
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   l_1fe94
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$1, d5
    bls.b   l_1fe96
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$18(a6, d0.w), d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    move.w  d0, d4
    bra.b   l_1fe96
l_1fe94:
    clr.w   d4
l_1fe96:
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ValidateTradeReq,PC)
    nop
    mulu.w  d4, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (UpdateUIPalette,PC)
    nop
    lea     $14(a7), a7
l_1fef8:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fe22
    movem.l -$44(a6), d2-d6/a2-a5
    unlk    a6
    rts
