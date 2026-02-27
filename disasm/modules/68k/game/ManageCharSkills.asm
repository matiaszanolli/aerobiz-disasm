; ============================================================================
; ManageCharSkills -- For each skill group, finds an unlearned skill the char qualifies for and calls TrainCharSkill
; 384 bytes | $0353C0-$03553F
; ============================================================================
ManageCharSkills:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d3
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d7
    movea.l  #$0005ECBC,a2
    clr.w   d4
l_353f6:
    cmp.w   d7, d4
    beq.w   l_3552e
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindNextOpenSkillSlot,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$ff, d0
    beq.w   l_3553a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.w   l_3552e
    moveq   #$0,d2
    move.b  (a2), d2
    bra.w   l_35518
l_3543e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.w   l_35516
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (HasSkill,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.w   l_35516
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d5
    move.b  $3(a3), d5
    mulu.w  #$f, d5
    addi.w  #$12c, d5
    move.w  d5, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    addq.w  #$1, d0
    move.l  d0, d5
    mulu.w  (a7)+, d5
    moveq   #$0,d0
    move.w  d5, d0
    cmp.l   $6(a4), d0
    bge.b   l_35516
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d6, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.b  d2, (a3)
    move.b  #$3, $1(a3)
    moveq   #$0,d0
    move.w  d5, d0
    sub.l   d0, $6(a4)
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $1c(a7), a7
    bra.b   l_3552e
l_35516:
    addq.w  #$1, d2
l_35518:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_3543e
l_3552e:
    addq.l  #$4, a2
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   l_353f6
l_3553a:
    movem.l (a7)+, d2-d7/a2-a4
    rts
