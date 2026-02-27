; ============================================================================
; RecruitFromSkillGroups -- Scans 8 skill groups to find and recruit the first char that passes ExecuteCharRecruit
; 288 bytes | $0361F0-$03630F
; ============================================================================
RecruitFromSkillGroups:
    movem.l d2-d6, -(a7)
    move.l  $18(a7), d2
    clr.w   d4
l_361fa:
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w FindNextOpenSkillSlot
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.w   l_3630a
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FFA7AC,a0
    move.w  (a0,d0.w), d3
    cmpi.w  #$7, d3
    bcc.w   l_36300
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$20, d0
    bcc.w   l_36300
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (FindBestPartnerChar,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$59, d0
    bcc.b   l_362a4
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (LookupCharRecord,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_362a4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ExecuteCharRecruit,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_3630a
l_362a4:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindSlotByChar
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_36300
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (LookupCharRecord,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d0
    beq.b   l_36300
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ExecuteCharRecruit,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    beq.b   l_3630a
l_36300:
    addq.w  #$1, d4
    cmpi.w  #$8, d4
    bcs.w   l_361fa
l_3630a:
    movem.l (a7)+, d2-d6
    rts
