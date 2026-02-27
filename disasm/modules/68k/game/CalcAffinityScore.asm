; ============================================================================
; CalcAffinityScore -- Iterate event records, accumulate entity affinity scores, return 1 if weighted total reaches 50 percent
; 122 bytes | $0080D0-$008149
; ============================================================================
CalcAffinityScore:
    dc.w    $0020,$4243                     ; ori.b #$43,-(a0) - high byte $42 is compiler junk
    clr.w   d4
    movea.l  #$00FFA6B8,a3
    move.w  $1e(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_080f0:
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d3
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_08108
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d4
l_08108:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    bcs.b   l_080f0
    tst.w   d3
    beq.b   l_08134
    moveq   #$0,d0
    move.w  d4, d0
    moveq   #$64,d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d3, d1
    jsr SignedDiv
    move.w  d0, d2
    bra.b   l_08136
l_08134:
    clr.w   d2
l_08136:
    cmpi.w  #$32, d2
    bcs.b   l_08140
    moveq   #$1,d5
    bra.b   l_08142
l_08140:
    clr.w   d5
l_08142:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts
