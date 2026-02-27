; ============================================================================
; CheckRecruitEligible -- Validates slot availability and wealth; deducts cost and records recruitment record if eligible
; 244 bytes | $036C30-$036D23
; ============================================================================
CheckRecruitEligible:
    movem.l d2-d7/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    clr.w   d6
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (IsCharSlotEmpty,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_36d1c
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ValidateCharPool,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    beq.w   l_36d1c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcQuarterBonus
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d3
    cmp.l   $6(a2), d3
    bge.b   l_36d1c
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w FindNextOpenSkillSlot
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$4, d0
    bcc.b   l_36d1c
    sub.l   d3, $6(a2)
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d5, (a2)
    move.b  #$6, $1(a2)
    move.b  #$32, $2(a2)
    move.b  #$4, $3(a2)
    move.w  #$32, $4(a2)
    move.w  d4, $6(a2)
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr DrawPlayerRoutes
    addq.l  #$8, a7
    moveq   #$1,d6
l_36d1c:
    move.w  d6, d0
    movem.l (a7)+, d2-d7/a2
    rts
