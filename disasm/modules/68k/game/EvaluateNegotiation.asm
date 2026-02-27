; ============================================================================
; EvaluateNegotiation -- Decides AI negotiation action for a char slot: calls NegotiateContract, CalcRecruitmentCost, or adjusts score
; 298 bytes | $0328FE-$032A27
; ============================================================================
EvaluateNegotiation:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    movea.l  #$00032CA0,a4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d2, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    move.w  d0, d4
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  $10(a2), d0
    moveq   #$64,d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d4, d1
    jsr SignedDiv
    move.w  d0, d4
    clr.w   d5
    cmpi.w  #$5a, d4
    bcs.b   l_329e2
    cmpi.b  #$e, $3(a2)
    bcc.b   l_329a6
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (NegotiateContract,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    beq.b   l_32a22
l_329a6:
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcRecruitmentCost,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_32a22
    pea     ($000A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_32a22
    bra.b   l_32a22
l_329e2:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    bge.b   l_32a08
    pea     (-$14).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    move.w  d0, d5
l_32a08:
    tst.w   d5
    bne.b   l_32a22
    pea     (-$A).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
l_32a22:
    movem.l (a7)+, d2-d5/a2-a4
    rts
