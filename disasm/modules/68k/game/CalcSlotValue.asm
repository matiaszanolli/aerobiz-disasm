; ============================================================================
; CalcSlotValue -- Sum the star ratings of all characters currently assigned to a route slot by iterating occupancy entries and looking up the char stat table.
; 212 bytes | $020448-$02051B
; ============================================================================
CalcSlotValue:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d3
    move.l  $24(a7), d6
    cmpi.w  #$20, d3
    bcc.b   l_20482
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d2
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF0420,a0
    lea     (a0,d2.w), a2
    moveq   #$6,d5
    bra.b   l_204a4
l_20482:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$4,d5
l_204a4:
    clr.w   d3
    clr.w   d4
    clr.w   d2
    bra.b   l_204e6
l_204ac:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bne.b   l_204e0
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmpi.w  #$1, d0
    bne.b   l_204e0
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d3
    addq.w  #$1, d4
l_204e0:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
l_204e6:
    cmp.w   d5, d2
    bcs.b   l_204ac
    tst.w   d4
    beq.b   l_20514
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$6A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
l_20514:
    move.w  d3, d0
    movem.l (a7)+, d2-d6/a2-a4
    rts
