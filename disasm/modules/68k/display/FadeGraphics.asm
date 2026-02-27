; ============================================================================
; FadeGraphics -- Applies negotiation/trade power weighting to each active player: for each city slot calls ManageUIElement to find the matched route index, computes per-player revenue contributions scaled by the negotiation power factor (CalcNegotiationPower), and calls UpdateUIPalette to write the final colour/value into each player's UI palette entry, iterating until all city slots are processed.
; 854 bytes | $01F82E-$01FB83
; ============================================================================
FadeGraphics:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d5
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    movea.l  #$00FF0120,a5
    move.w  $a(a6), d5
    bra.w   l_1fb52
l_1f866:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w ValidateInputState
    addq.l  #$4, a7
    tst.w   d0
    beq.w   l_1fb52
    clr.w   d2
l_1f87a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ManageUIElement,PC)
    nop
    lea     $c(a7), a7
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$c(a6, d1.w)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.b   l_1f8f4
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1f8f4
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E8,a0
    tst.w   (a0,d0.w)
    bne.b   l_1f8ea
    addq.w  #$1, d7
    bra.b   l_1f8f4
l_1f8ea:
    move.w  d2, d0
    add.w   d0, d0
    move.w  #$ff, -$c(a6, d0.w)
l_1f8f4:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f87a
    cmpi.w  #$1, d7
    bls.w   l_1fa6c
    moveq   #$0,d6
    clr.w   d2
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_1f92e:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fa58
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a2,d0.l), a0
    move.l  a0, -$10(a6)
    move.b  $a(a4), d0
    andi.l  #$2, d0
    bne.w   l_1fa58
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1f99a
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    bra.b   l_1f9a0
l_1f99a:
    move.l  #$1, -(a7)
l_1f9a0:
    movea.l -$10(a6), a0
    move.w  (a0), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), d0
    movea.l -$10(a6), a0
    move.w  $2(a0), d1
    andi.l  #$ffff, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   (a3,a0.l), d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$3, d1
    movea.l d1, a0
    move.w  $6(a2, a0.l), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr UnsignedDivide
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    moveq   #$0,d1
    move.b  (a5), d1
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    jsr Multiply32
    move.l  d0, (a0)
    exg     d0, a1
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a0)
    exg     d0, a1
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$1,d1
    cmp.l   d0, d1
    bcc.b   l_1fa44
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    bra.b   l_1fa46
l_1fa44:
    moveq   #$1,d0
l_1fa46:
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    add.l   d0, d6
l_1fa58:
    addq.l  #$4, a5
    lea     $140(a2), a2
    moveq   #$1C,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f92e
l_1fa6c:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    addq.l  #$8, a7
    move.w  d0, -$22(a6)
    clr.w   d2
l_1fa88:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fb48
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1fae4
    cmpi.w  #$1, d7
    bls.b   l_1fade
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$0,d1
    move.w  -$22(a6), d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    move.w  d0, d4
    bra.b   l_1fae6
l_1fade:
    move.w  -$22(a6), d4
    bra.b   l_1fae6
l_1fae4:
    clr.w   d4
l_1fae6:
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
l_1fb48:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fa88
l_1fb52:
    addq.w  #$1, d5
    movea.l -$4(a6), a0
    move.b  $1(a0), d0
    andi.l  #$ff, d0
    movea.l -$4(a6), a0
    move.b  (a0), d1
    andi.l  #$ff, d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.w   l_1f866
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
