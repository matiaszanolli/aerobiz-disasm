; ============================================================================
; UnpackEventRecord -- Expands an event record: finds which char and player are affected by a city-type event and updates the popularity-distance table for all relevant player/city combinations.
; 246 bytes | $028EFA-$028FEF
; ============================================================================
UnpackEventRecord:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.w  $a(a6), d0
    lsl.w   #$3, d0
    movea.l  #$0005FAB6,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    cmpi.b  #$1, $6(a5)
    bne.w   l_28fe6
    move.w  #$ff, d4
    movea.l  #$00FF1298,a2
    clr.w   d2
l_28f2a:
    move.b  (a2), d0
    cmp.b   $5(a5), d0
    bne.b   l_28f36
    move.w  d2, d4
    bra.b   l_28f40
l_28f36:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_28f2a
l_28f40:
    cmpi.w  #$59, d4
    bcc.w   l_28fe6
    movea.l  #$00FF0018,a3
    clr.w   d3
    move.w  d3, d0
    mulu.w  #$39, d0
    movea.l  #$00FF05C4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_28f62:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    move.b  (a0,d0.w), d0
    cmp.b   $5(a5), d0
    bne.b   l_28fb0
    movea.l  #$00FF1298,a2
    clr.w   d2
l_28f82:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    moveq   #$0,d1
    move.b  (a2), d1
    movea.l d1, a0
    move.b  d0, (a4,a0.l)
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_28f82
    bra.b   l_28fd4
l_28fb0:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    moveq   #$0,d1
    move.b  $5(a5), d1
    movea.l d1, a0
    move.b  d0, (a4,a0.l)
l_28fd4:
    moveq   #$24,d0
    adda.l  d0, a3
    moveq   #$39,d0
    adda.l  d0, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_28f62
l_28fe6:
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts
