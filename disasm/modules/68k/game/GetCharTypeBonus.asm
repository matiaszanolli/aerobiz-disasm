; ============================================================================
; GetCharTypeBonus -- Returns scaled skill bonus (1-9) for a char based on compat score and the given level value
; 86 bytes | $033E3E-$033E93
; ============================================================================
GetCharTypeBonus:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    move.l  a2, -(a7)
    jsr CalcCompatScore
    addq.l  #$4, a7
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_33e7a
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e7c
l_33e7a:
    moveq   #$1,d0
l_33e7c:
    move.w  d0, d2
    cmpi.w  #$9, d2
    bcc.b   l_33e8a
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_33e8c
l_33e8a:
    moveq   #$9,d0
l_33e8c:
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2
    rts
