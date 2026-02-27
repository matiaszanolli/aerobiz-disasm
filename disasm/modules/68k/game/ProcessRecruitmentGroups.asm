; ============================================================================
; ProcessRecruitmentGroups -- Iterates 8 skill groups; calls ApplyStatBonus and CheckRecruitEligible for each qualified group
; 142 bytes | $036894-$036921
; ============================================================================
ProcessRecruitmentGroups:
    movem.l d2-d5, -(a7)
    move.l  $14(a7), d3
    clr.w   d2
l_3689e:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w FindNextOpenSkillSlot
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.b   l_3691c
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ApplyStatBonus,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bcs.b   l_3691c
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d4
    cmpi.w  #$7, d4
    bcc.b   l_36914
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (RecalcAllCharStats,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_36914
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CheckRecruitEligible,PC)
    nop
    lea     $c(a7), a7
l_36914:
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    bcs.b   l_3689e
l_3691c:
    movem.l (a7)+, d2-d5
    rts
