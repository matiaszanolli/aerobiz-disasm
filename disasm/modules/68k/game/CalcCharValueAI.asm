; ============================================================================
; CalcCharValueAI -- Checks all alliance slots for a char; simulates match turns and damage; returns 1 if a profitable match found
; 290 bytes | $034506-$034627
; ============================================================================
CalcCharValueAI:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d7
    lea     -$4(a6), a2
    lea     -$2(a6), a3
    clr.w   (a3)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_3461c
    clr.w   d4
l_34540:
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d2
    cmpi.w  #$7, d2
    bcc.w   l_34612
    cmp.w   d7, d2
    beq.w   l_34612
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d0
    bcc.w   l_34612
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CheckCharPairConflict,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_34612
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RunMatchTurn,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, (a2)
    cmpi.w  #$10, (a2)
    bcc.b   l_34612
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindEmptyMatchSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmp.w   ($00FFA7DA).l, d2
    bcc.b   l_34612
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcMatchScore,PC)
    nop
    lea     $14(a7), a7
    move.w  #$1, (a3)
    bra.b   l_3461c
l_34612:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_34540
l_3461c:
    move.w  (a3), d0
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
