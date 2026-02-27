; ============================================================================
; SelectBestForTeam -- Runs AI team selection loop: evaluates char quality and value across all alliance slots per turn
; 324 bytes | $03402E-$034171
; ============================================================================
SelectBestForTeam:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d3
    lea     -$2(a6), a3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d7
    clr.w   (a3)
    bra.w   l_3415c
l_3406a:
    pea     ($00FE).w
    pea     ($00FE).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindEmptyMatchSlot,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    beq.w   l_34168
    clr.w   d4
l_3408c:
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d2
    cmpi.w  #$7, d2
    bcc.w   l_34142
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$20, d0
    bcc.w   l_34150
    clr.w   d6
    cmp.w   d7, d2
    bne.b   l_340c8
    moveq   #$1,d5
    bra.b   l_340ca
l_340c8:
    moveq   #$2,d5
l_340ca:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (GetCharQuality,PC)
    nop
    addq.l  #$8, a7
    cmp.w   d5, d0
    bls.b   l_340f8
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcCharValueAI,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d6
l_340f8:
    tst.w   d6
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (SortCharsByValue,PC)
    nop
    addq.l  #$8, a7
    cmp.w   d7, d2
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w CheckDuplicateAlliance
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34150
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (SortCharsByValue,PC)
    nop
    addq.l  #$8, a7
    bra.b   l_34150
l_34142:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (EvaluateCharPool,PC)
    nop
    addq.l  #$4, a7
l_34150:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_3408c
    addq.w  #$1, (a3)
l_3415c:
    move.w  (a3), d0
    cmp.w   ($00FFA7DA).l, d0
    bcs.w   l_3406a
l_34168:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
