; ============================================================================
; IsCharSlotEmpty -- Returns 1 if a recruitment slot (type=$6) for the given char and cost exists in the skill table
; 82 bytes | $036D24-$036D75
; ============================================================================
IsCharSlotEmpty:
    movem.l d2-d5, -(a7)
    move.l  $1c(a7), d3
    move.l  $18(a7), d4
    clr.w   d5
    move.w  $16(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_36d46:
    cmpi.b  #$6, $1(a1)
    bne.b   l_36d64
    moveq   #$0,d0
    move.b  (a1), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_36d64
    cmp.w   $6(a1), d3
    bne.b   l_36d64
    moveq   #$1,d5
    bra.b   l_36d6e
l_36d64:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_36d46
l_36d6e:
    move.w  d5, d0
    movem.l (a7)+, d2-d5
    rts
