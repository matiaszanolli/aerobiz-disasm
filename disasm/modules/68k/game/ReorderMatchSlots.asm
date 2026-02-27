; ============================================================================
; ReorderMatchSlots -- Iterates match slots for a player; evaluates lineups, updates char metrics, clears invalid pairs
; 212 bytes | $03360C-$0336DF
; ============================================================================
ReorderMatchSlots:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d4
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    mulu.w  #$30, d0
    movea.l  #$00FF88DC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.w   l_336c2
l_3363e:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$28,d1
    cmp.l   d0, d1
    ble.b   l_336bc
    cmpi.w  #$59, (a2)
    bcc.b   l_336bc
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (EvaluateMatchLineup,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_336bc
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateCharMetrics,PC)
    nop
    lea     $10(a7), a7
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_336bc
    move.w  #$ff, d0
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    clr.w   $8(a2)
    clr.w   $a(a2)
l_336bc:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_336c2:
    cmp.w   ($00FFA7DA).l, d2
    bcs.w   l_3363e
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (RebuildMatchSlots,PC)
    nop
    addq.l  #$4, a7
    movem.l (a7)+, d2-d4/a2-a3
    rts
