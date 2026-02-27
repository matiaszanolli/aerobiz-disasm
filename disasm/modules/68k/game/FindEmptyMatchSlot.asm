; ============================================================================
; FindEmptyMatchSlot -- Searches match slot list for a char pair; returns the slot index of an empty slot or end-of-list index
; 122 bytes | $034978-$0349F1
; ============================================================================
FindEmptyMatchSlot:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $20(a7), d3
    move.l  $24(a7), d4
    movea.l  #$00FFA7DA,a1
    move.w  #$ff, d1
    move.w  $1e(a7), d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l a0, a2
    clr.w   d2
    move.w  (a1), d5
    bra.b   l_349c6
l_349aa:
    cmp.w   (a2), d3
    bne.b   l_349b6
    cmp.w   $2(a2), d4
    bne.b   l_349c0
    bra.b   l_349ca
l_349b6:
    cmp.w   (a2), d4
    bne.b   l_349c0
    cmp.w   $2(a2), d3
    beq.b   l_349ca
l_349c0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_349c6:
    cmp.w   d5, d2
    bcs.b   l_349aa
l_349ca:
    cmp.w   (a1), d2
    bne.b   l_349ea
    movea.l a3, a2
    clr.w   d2
    move.w  (a1), d3
    bra.b   l_349e6
l_349d6:
    cmpi.w  #$ff, (a2)
    bne.b   l_349e0
    move.w  d2, d1
    bra.b   l_349ea
l_349e0:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_349e6:
    cmp.w   d3, d2
    bcs.b   l_349d6
l_349ea:
    move.w  d1, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts
