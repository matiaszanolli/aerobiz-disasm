; ============================================================================
; RenderAnimFrame -- Computes per-player route revenue shares for a specific city/slot: retrieves city capacity factors from $FFBDE4, calculates weighted demand contributions from both endpoint cities (scaled by the current market-share percentage at $FFBD4C), sums the products, and stores scaled revenue values per player into output accumulator fields, calling TransitionEffect to determine each player's relative slot index.
; 1134 bytes | $01F352-$01F7BF
; ============================================================================
RenderAnimFrame:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d7
    movea.l  #$00FF0002,a4
    lea     -$14(a6), a5
    move.w  #$3a98, d6
    move.w  d3, d0
    mulu.w  #$140, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a2), -$4(a6)
    move.w  $2(a2), -$6(a6)
    move.w  -$4(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  -$6(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, -$c(a6)
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  (a2), d0
    moveq   #$0,d1
    move.w  -$c(a6), d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d0, -$a(a6)
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d0, d2
    move.l  -$a(a6), d0
    add.l   d2, d0
    moveq   #$0,d1
    move.w  d6, d1
    jsr UnsignedDivide
    move.w  d0, -$2(a6)
    clr.w   d2
    bra.b   l_1f4dc
l_1f4cc:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff, (a5,a0.l)
    addq.w  #$1, d2
l_1f4dc:
    cmp.w   d3, d2
    bcs.b   l_1f4cc
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d7, (a5,a0.l)
    move.w  d3, d2
    bra.b   l_1f51c
l_1f4f0:
    moveq   #$0,d0
    move.w  -$6(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (TransitionEffect,PC)
    nop
    lea     $c(a7), a7
    moveq   #$0,d1
    move.w  d2, d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, (a5,a0.l)
l_1f51c:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f4f0
    clr.w   d7
    moveq   #$0,d6
    move.w  d3, d2
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$24(a6, d0.w), a0
    movea.l a0, a2
    bra.w   l_1f5de
l_1f538:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    cmpi.w  #$28, d4
    bcc.w   l_1f5da
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1f5da
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF0230,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  -$4(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  -$6(a6), d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  $2(a3, a0.l), d1
    andi.l  #$ffff, d1
    add.l   d1, d0
    move.w  d2, d1
    mulu.w  #$140, d1
    movea.l d7, a0
    move.w  d4, d7
    lsl.w   #$3, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.l  d0, (a2)
    add.l   (a2), d6
    addq.w  #$1, d7
l_1f5da:
    addq.l  #$4, a2
    addq.w  #$1, d2
l_1f5de:
    cmpi.w  #$4, d2
    bcs.w   l_1f538
    move.w  d3, d2
    bra.w   l_1f7ae
l_1f5ec:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    cmpi.w  #$28, d4
    bcc.w   l_1f7ac
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_1f726
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF0230,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.l   d6
    beq.b   l_1f65a
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$24(a6, d0.w), d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    bra.b   l_1f66a
l_1f65a:
    moveq   #$0,d0
    move.w  -$2(a6), d0
    moveq   #$0,d1
    move.w  d7, d1
    jsr SignedDiv
l_1f66a:
    move.w  d0, d3
    moveq   #$0,d0
    move.w  -$6(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    move.w  (a4), d1
    ext.l   d1
    addq.l  #$2, d1
    jsr SignedDiv
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$4(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    move.w  (a4), d1
    ext.l   d1
    addq.l  #$2, d1
    jsr SignedDiv
    add.l   (a7)+, d0
    move.l  d0, d5
    tst.l   d5
    bge.b   l_1f6b8
    addq.l  #$1, d5
l_1f6b8:
    asr.l   #$1, d5
    cmpi.l  #$36b0, d5
    bge.b   l_1f6c6
    move.l  d5, d0
    bra.b   l_1f6cc
l_1f6c6:
    move.l  #$36b0, d0
l_1f6cc:
    add.w   d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$3, d5
    bne.b   l_1f6fe
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f6f8
    addq.l  #$3, d0
l_1f6f8:
    asr.l   #$2, d0
l_1f6fa:
    move.w  d0, d3
    bra.b   l_1f728
l_1f6fe:
    cmpi.w  #$2, d5
    bne.b   l_1f710
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f70c
    addq.l  #$1, d0
l_1f70c:
    asr.l   #$1, d0
    bra.b   l_1f6fa
l_1f710:
    cmpi.w  #$1, d5
    bne.b   l_1f728
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$5,d1
    jsr SignedDiv
    sub.w   d0, d3
    bra.b   l_1f728
l_1f726:
    clr.w   d3
l_1f728:
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d3
    tst.w   (a4)
    bne.b   l_1f76a
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f764
    addq.l  #$1, d0
l_1f764:
    asr.l   #$1, d0
l_1f766:
    add.w   d0, d3
    bra.b   l_1f790
l_1f76a:
    cmpi.w  #$1, (a4)
    bne.b   l_1f77c
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f778
    addq.l  #$3, d0
l_1f778:
    asr.l   #$2, d0
    bra.b   l_1f766
l_1f77c:
    cmpi.w  #$3, (a4)
    bne.b   l_1f790
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$3,d1
    jsr SignedDiv
    sub.w   d0, d3
l_1f790:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (UpdateUIPalette,PC)
    nop
    lea     $c(a7), a7
l_1f7ac:
    addq.w  #$1, d2
l_1f7ae:
    cmpi.w  #$4, d2
    bcs.w   l_1f5ec
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
