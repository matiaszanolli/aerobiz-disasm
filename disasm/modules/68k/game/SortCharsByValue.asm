; ============================================================================
; SortCharsByValue -- Finds best char for an alliance slot via match simulation; calls ProcessCharJoin and RunMatchTurn/FindEmptyMatchSlot
; 296 bytes | $0346C0-$0347E7
; ============================================================================
SortCharsByValue:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $1c(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.w   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CountFilledAllianceSlots,PC)
    nop
    cmpi.w  #$1, d0
    bls.b   l_34712
    clr.w   d4
    bra.b   l_34714
l_34712:
    moveq   #$1,d4
l_34714:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  #$12c, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcPlayerWealth
    addq.l  #$4, a7
    add.l   $e(a2), d0
    add.l   (a7)+, d0
    addi.l  #$12c, d0
    cmp.l   $a(a2), d0
    bls.b   l_3474c
    moveq   #$1,d4
l_3474c:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ProcessCharJoin,PC)
    nop
    lea     $10(a7), a7
    move.w  d0, d2
    cmpi.w  #$59, d2
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RunMatchTurn,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d4
    cmpi.w  #$10, d4
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindEmptyMatchSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d6
    cmp.w   ($00FFA7DA).l, d6
    bcc.b   l_347e2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcMatchScore,PC)
    nop
    lea     $14(a7), a7
l_347e2:
    movem.l (a7)+, d2-d6/a2
    rts
