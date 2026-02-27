; ============================================================================
; UnlockSkill -- Scans all match slots; calls TrainCharSkill for pending training slots (type=$1), marks done if successful
; 100 bytes | $035584-$0355E7
; ============================================================================
UnlockSkill:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d4
    move.w  d4, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_355da
l_355a2:
    cmpi.w  #$59, (a2)
    bcc.b   l_355d4
    cmpi.w  #$1, $a(a2)
    bne.b   l_355d4
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (TrainCharSkill,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_355d4
    move.w  #$2, $a(a2)
l_355d4:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_355da:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_355a2
    movem.l (a7)+, d2-d4/a2
    rts
