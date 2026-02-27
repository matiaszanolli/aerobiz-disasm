; ============================================================================
; RankCharByScore -- For each slot in player roster, decides whether to renegotiate contract or degrade skill based on profit ratio
; 236 bytes | $032812-$0328FD
; ============================================================================
RankCharByScore:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $14(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   l_328e0
l_32844:
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   l_32898
    moveq   #$0,d0
    move.w  $6(a2), d0
    moveq   #$6E,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  $e(a2), d1
    cmp.l   d1, d0
    bgt.b   l_32884
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (EvaluateNegotiation,PC)
    nop
    bra.b   l_328d8
l_32884:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (DegradeSkillLinked,PC)
    nop
    bra.b   l_328d8
l_32898:
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_328da
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_328da
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ClearSubstituteFlag,PC)
    nop
l_328d8:
    addq.l  #$8, a7
l_328da:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_328e0:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_32844
    movem.l (a7)+, d2-d3/a2-a3
    rts
