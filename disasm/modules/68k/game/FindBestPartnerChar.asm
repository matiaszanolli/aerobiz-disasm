; ============================================================================
; FindBestPartnerChar -- Searches player char slots for best uncontested partner; returns char index or $FF
; 250 bytes | $036310-$036409
; ============================================================================
FindBestPartnerChar:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$ff, d6
    moveq   #$0,d4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.w   l_36402
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   l_36402
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d2
    bra.b   l_363ec
l_36390:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.b   l_36402
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_363e6
    moveq   #$0,d0
    move.b  $1(a2), d0
    movea.l  #$00FF09D8,a0
    move.b  (a0,d0.w), d0
    andi.l  #$3, d0
    bne.b   l_363e6
    moveq   #$0,d0
    move.w  $e(a2), d0
    moveq   #$0,d1
    move.w  $6(a2), d1
    sub.l   d1, d0
    move.l  d0, d3
    cmp.l   d4, d0
    bge.b   l_363e6
    move.l  d3, d4
    moveq   #$0,d6
    move.b  $1(a2), d6
l_363e6:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_363ec:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_36390
l_36402:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts
