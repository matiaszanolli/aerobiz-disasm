; ============================================================================
; LookupCharRecord -- Scores available chars by CalcCharValue and returns best match for the current player/slot
; 324 bytes | $03640A-$03654D
; ============================================================================
LookupCharRecord:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    lea     -$2(a6), a5
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, -$8(a6)
    cmpi.w  #$20, d7
    bcc.b   l_36462
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$6, -$6(a6)
    bra.b   l_36488
l_36462:
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$4, -$6(a6)
l_36488:
    move.w  #$ff, d0
    move.w  d0, -$4(a6)
    move.w  d0, (a5)
    move.l  #$3b9ac9ff, d5
    move.l  d5, d4
    clr.w   d2
    bra.w   l_36528
l_364a0:
    cmpi.b  #$f, (a2)
    beq.b   l_36522
    cmpi.b  #$ff, (a3)
    bne.b   l_36522
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CalcCharValue
    lea     $c(a7), a7
    move.l  d0, d3
    move.w  d6, d0
    mulu.w  #$e, d0
    move.w  -$8(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005F936,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    cmp.l   d1, d0
    bne.b   l_36510
    cmp.l   d5, d3
    bcc.b   l_36522
    move.w  d2, (a5)
    move.l  d3, d5
    bra.b   l_36522
l_36510:
    cmpi.b  #$1, $3(a4)
    bne.b   l_36522
    cmp.l   d4, d3
    bcc.b   l_36522
    move.w  d2, -$4(a6)
    move.l  d3, d4
l_36522:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
l_36528:
    cmp.w   -$6(a6), d2
    bcs.w   l_364a0
    cmpi.w  #$ff, (a5)
    beq.b   l_3653e
    cmpi.w  #$1, $12(a6)
    bne.b   l_36542
l_3653e:
    move.w  -$4(a6), (a5)
l_36542:
    move.w  (a5), d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
