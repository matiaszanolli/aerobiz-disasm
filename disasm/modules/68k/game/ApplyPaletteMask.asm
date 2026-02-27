; ============================================================================
; ApplyPaletteMask -- Replace matching 4-bit color nibbles in palette entries using mask table
; 118 bytes | $0048D2-$004947
; ============================================================================
ApplyPaletteMask:
    movem.l d2-d7/a2, -(a7)
    move.l  $2c(a7), d7
    clr.w   d6
    movea.l $20(a7), a1
    bra.b   l_04932
l_048e2:
    move.w  (a1), d2
    move.w  $2a(a7), d5
    moveq   #$C,d0
    lsl.w   d0, d5
    move.w  d7, d4
    moveq   #$C,d0
    lsl.w   d0, d4
    clr.w   d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004735E,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_04904:
    move.w  d2, d0
    and.w   (a2), d0
    cmp.w   d5, d0
    bne.b   l_04916
    move.w  (a2), d0
    not.w   d0
    and.w   d0, d2
    move.w  d4, d0
    or.w    d0, d2
l_04916:
    addq.l  #$2, a2
    addq.w  #$1, d3
    move.w  d5, d0
    lsr.w   #$4, d0
    move.w  d0, d5
    move.w  d4, d0
    lsr.w   #$4, d0
    move.w  d0, d4
    cmpi.w  #$4, d3
    bcs.b   l_04904
    move.w  d2, (a1)
    addq.w  #$1, d6
    addq.l  #$2, a1
l_04932:
    moveq   #$0,d0
    move.w  $26(a7), d0
    lsl.l   #$4, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.b   l_048e2
    movem.l (a7)+, d2-d7/a2
    rts
