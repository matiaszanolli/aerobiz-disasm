; ============================================================================
; IncrementAffinity -- Advances player affinity phase: runs skill reset, level-up check, and threshold evaluation
; 144 bytes | $035880-$03590F
; ============================================================================
IncrementAffinity:
    move.l  $c(a7), d2
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w ResetSkillProgress
    addq.l  #$8, a7
    cmpi.b  #$63, $22(a2)
    bne.b   l_358c8
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w CheckLevelUpCond
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckAffinityThreshold,PC)
    nop
    lea     $c(a7), a7
l_358c8:
    cmpi.b  #$62, $22(a2)
    bne.b   l_358e2
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CollectCharRevenue,PC)
    nop
    addq.l  #$8, a7
l_358e2:
    cmpi.b  #$61, $22(a2)
    bne.b   l_3590a
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckAffinityThreshold,PC)
    nop
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (DecrementAffinity,PC)
    nop
    lea     $c(a7), a7
l_3590a:
    movem.l (a7)+, d2/a2
    rts
