; ============================================================================
; IsCharSlotAvailable -- Returns 0 if char pair already has a relation record or match slot; 1 if slot is free
; 136 bytes | $0360F2-$036179
; ============================================================================
IsCharSlotAvailable:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d2
    move.l  $24(a7), d3
    move.l  $20(a7), d4
    moveq   #$1,d6
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindRelationIndex
    lea     $c(a7), a7
    cmpi.w  #$ff, d0
    bne.b   l_36172
    move.w  d2, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  ($00FFA7DA).l, d5
    bra.b   l_36164
l_36142:
    cmpi.w  #$59, (a2)
    bcc.b   l_3615e
    cmp.w   (a2), d4
    bne.b   l_36154
    cmp.w   $2(a2), d3
    bne.b   l_3615e
    bra.b   l_36168
l_36154:
    cmp.w   (a2), d3
    bne.b   l_3615e
    cmp.w   $2(a2), d4
    beq.b   l_36168
l_3615e:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_36164:
    cmp.w   d5, d2
    bcs.b   l_36142
l_36168:
    cmp.w   ($00FFA7DA).l, d2
    bne.b   l_36172
    clr.w   d6
l_36172:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2
    rts
