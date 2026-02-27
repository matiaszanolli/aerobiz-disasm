; ============================================================================
; CheckCharPairConflict -- Returns 1 if the given char pair already appears in any current match slot, 0 if no profit conflict
; 152 bytes | $034628-$0346BF
; ============================================================================
CheckCharPairConflict:
    movem.l d2-d7/a2, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d5
    move.l  $24(a7), d6
    moveq   #$1,d7
    moveq   #$1,d0
    lsl.b   d5, d0
    move.w  d2, d1
    mulu.w  #$7, d1
    add.w   d6, d1
    movea.l  #$00FFA7BC,a0
    and.b   (a0,d1.w), d0
    bne.b   l_346b8
    move.w  d2, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_346a6
l_34668:
    cmpi.w  #$59, (a2)
    bcc.b   l_346a0
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d4
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    move.w  d0, d3
    cmp.w   d6, d4
    bne.b   l_34698
    cmp.w   d5, d3
    bne.b   l_346a0
    bra.b   l_346ae
l_34698:
    cmp.w   d5, d4
    bne.b   l_346a0
    cmp.w   d6, d3
    beq.b   l_346ae
l_346a0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_346a6:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_34668
l_346ae:
    cmp.w   ($00FFA7DA).l, d2
    bne.b   l_346b8
    clr.w   d7
l_346b8:
    move.w  d7, d0
    movem.l (a7)+, d2-d7/a2
    rts
