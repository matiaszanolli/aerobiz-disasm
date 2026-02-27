; ============================================================================
; ProcessPaletteIter -- Swap matching color nibbles between two palette values across palette entries
; 136 bytes | $0049DE-$004A65
; ============================================================================
ProcessPaletteIter:
    movem.l d2-d7/a2, -(a7)
    move.l  $2c(a7), d7
    clr.w   d6
    movea.l $20(a7), a1
    bra.b   l_04a50
l_049ee:
    move.w  (a1), d2
    move.w  $2a(a7), d4
    moveq   #$C,d0
    lsl.w   d0, d4
    move.w  d7, d3
    moveq   #$C,d0
    lsl.w   d0, d3
    clr.w   d5
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00047376,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04a10:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d4, d0
    bne.b   l_04a22
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d3, d0
    bra.b   l_04a32
l_04a22:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d3, d0
    bne.b   l_04a34
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d4, d0
l_04a32:
    or.w    d0, d2
l_04a34:
    move.w  d4, d0
    lsr.w   #$4, d0
    move.w  d0, d4
    move.w  d3, d0
    lsr.w   #$4, d0
    move.w  d0, d3
    addq.l  #$2, a2
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.b   l_04a10
    move.w  d2, (a1)
    addq.w  #$1, d6
    addq.l  #$2, a1
l_04a50:
    moveq   #$0,d0
    move.w  $26(a7), d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.b   l_049ee
    movem.l (a7)+, d2-d7/a2
    rts
