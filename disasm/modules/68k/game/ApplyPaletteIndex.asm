; ============================================================================
; ApplyPaletteIndex -- Remap 4-bit palette nibbles via index lookup table across multiple palette entries
; 150 bytes | $004948-$0049DD
; ============================================================================
ApplyPaletteIndex:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d6
    movea.l $2c(a7), a1
    clr.w   d5
    movea.l $24(a7), a4
    bra.b   l_049ca
l_0495c:
    move.w  (a4), d4
    clr.w   d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004736E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$00047366,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04980:
    move.w  d4, d2
    and.w   (a2), d2
    andi.l  #$ffff, d2
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    asr.l   d0, d1
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a1,a0.l), d2
    move.w  (a3), d0
    move.w  d2, d1
    lsl.w   d0, d1
    move.w  d1, d2
    move.w  (a2), d0
    move.w  #$ffff, d1
    eor.w   d1, d0
    and.w   d4, d0
    or.w    d2, d0
    move.w  d0, d4
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_04980
    move.w  d4, (a4)
    addq.w  #$1, d5
    addq.l  #$2, a4
l_049ca:
    moveq   #$0,d0
    move.w  d6, d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.b   l_0495c
    movem.l (a7)+, d2-d6/a2-a4
    rts
