; ============================================================================
; ResetMatchState -- Iterates all match slots; applies char growth and level-up outcomes, sets win/loss flags
; 208 bytes | $034F90-$03505F
; ============================================================================
ResetMatchState:
    dc.w    $0010,$3002                     ; ori.b #$2,(a0) - high byte $30 is compiler junk
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.w   l_35050
l_34faa:
    cmpi.w  #$59, (a2)
    bcc.w   l_3504a
    cmpi.w  #$1, $6(a2)
    bne.b   l_34ffc
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34fdc
    move.w  #$3, $6(a2)
    bra.b   l_34ffc
l_34fdc:
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_34ffc
    move.w  #$2, $6(a2)
l_34ffc:
    cmpi.w  #$1, $8(a2)
    bne.b   l_3504a
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_35028
    move.w  #$3, $8(a2)
    bra.b   l_3504a
l_35028:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.b   l_3504a
    move.w  #$2, $8(a2)
l_3504a:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_35050:
    cmp.w   ($00FFA7DA).l, d3
    bcs.w   l_34faa
    movem.l (a7)+, d2-d3/a2
    rts
