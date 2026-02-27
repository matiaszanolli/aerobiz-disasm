; ============================================================================
; ComputeAllianceScores -- Scores each alliance slot for the AI player based on status, char type, and priority flags; writes ranked list
; 514 bytes | $032398-$032599
; ============================================================================
ComputeAllianceScores:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$10(a6), a4
    movea.l  #$00FF0270,a5
    move.w  ($00FF0004).l, d7
    ext.l   d7
    addq.l  #$4, d7
    moveq   #$7,d0
    cmp.l   d7, d0
    ble.b   l_323ca
    move.w  ($00FF0004).l, d7
    ext.l   d7
    addq.l  #$4, d7
    bra.b   l_323cc
l_323ca:
    moveq   #$7,d7
l_323cc:
    jsr CountActivePlayers
    move.w  d0, d4
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
    move.w  d0, d2
    pea     ($0010).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    lea     $10(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  d2, d1
    adda.l  d1, a0
    cmpi.b  #$1, (a0)
    bne.b   l_3244a
    cmpi.w  #$1, d4
    bne.b   l_3244a
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (HasPriorityAlliance,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.b   l_3246e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    addi.w  #$c8, (a4,a0.l)
    bra.b   l_3246e
l_3244a:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    moveq   #$0,d1
    move.w  d2, d1
    adda.l  d1, a0
    cmpi.b  #$1, (a0)
    bls.b   l_3246e
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    addi.w  #$7d0, (a4,a0.l)
l_3246e:
    movea.l a4, a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    clr.w   d4
    clr.w   d2
l_32480:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_32536
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CountAllianceMembers,PC)
    nop
    addq.l  #$4, a7
    cmp.w   d7, d0
    bcc.b   l_324d0
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   l_324d0
    addi.w  #$190, (a2)
l_324d0:
    jsr (CalcQuarterTurnOffset,PC)
    nop
    cmpi.w  #$14, d0
    bcc.b   l_324ec
    cmpi.w  #$5, d2
    beq.b   l_324e8
    cmpi.w  #$3, d2
    bne.b   l_324ec
l_324e8:
    addi.w  #$64, (a2)
l_324ec:
    cmpi.b  #$1, (a3)
    bne.b   l_324f8
    addi.w  #$c8, (a2)
    bra.b   l_32514
l_324f8:
    cmpi.b  #$2, (a3)
    bne.b   l_32504
    addi.w  #$190, (a2)
    bra.b   l_32514
l_32504:
    cmpi.b  #$3, (a3)
    beq.b   l_32510
    cmpi.b  #$4, (a3)
    bne.b   l_32514
l_32510:
    addi.w  #$12c, (a2)
l_32514:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CheckDuplicateAlliance,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_32532
    addi.w  #$c8, (a2)
l_32532:
    addq.w  #$1, d4
    bra.b   l_32538
l_32536:
    clr.w   (a2)
l_32538:
    addq.l  #$2, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.w   l_32480
    cmpi.w  #$7, d4
    bcc.b   l_32552
    addi.w  #$320, $e(a4)
l_32552:
    clr.w   d3
l_32554:
    movea.l a4, a2
    moveq   #-$A,d4
    clr.w   d2
l_3255a:
    cmp.w   (a2), d4
    bge.b   l_32562
    move.w  (a2), d4
    move.w  d2, d5
l_32562:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   l_3255a
    moveq   #$0,d0
    move.w  d5, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  d5, (a0,d0.w)
    addq.w  #$1, d3
    cmpi.w  #$8, d3
    bcs.b   l_32554
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
