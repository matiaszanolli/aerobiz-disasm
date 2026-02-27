; ============================================================================
; RecalcAllCharStats -- Accumulates weighted stat bonuses from all assigned chars; returns highest-scoring category index
; 624 bytes | $0369C0-$036C2F
; ============================================================================
RecalcAllCharStats:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    move.w  d0, d7
    pea     ($000C).w
    clr.l   -(a7)
    pea     -$10(a6)
    jsr MemFillByte
    lea     $14(a7), a7
    cmpi.w  #$20, d7
    bcc.w   l_36be4
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   l_36be4
    move.w  d5, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d6
    bra.w   l_36bbc
l_36a52:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d7, d1
    cmp.l   d1, d0
    bgt.w   l_36be4
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_36bb6
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    mulu.w  #$a, d3
    moveq   #$0,d0
    move.w  $10(a2), d0
    moveq   #$64,d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d3, d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$64, d2
    bcc.b   l_36ab6
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_36ab8
l_36ab6:
    moveq   #$64,d0
l_36ab8:
    move.w  d0, d2
    moveq   #$64,d0
    sub.w   d2, d0
    move.w  d0, d2
    moveq   #$0,d3
    move.b  $1(a2), d3
    cmpi.w  #$20, d3
    bcc.b   l_36af4
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$6,d4
    bra.b   l_36b16
l_36af4:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$4,d4
l_36b16:
    clr.w   d3
    bra.w   l_36bb0
l_36b1c:
    cmpi.b  #$f, (a3)
    beq.w   l_36baa
    moveq   #$0,d0
    move.b  (a4), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_36baa
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    tst.b   $3(a5)
    bne.b   l_36b64
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   d0, -$10(a6)
    bra.b   l_36baa
l_36b64:
    cmpi.b  #$2, $3(a5)
    bne.b   l_36b88
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   d0, -$8(a6)
    bra.b   l_36baa
l_36b88:
    cmpi.b  #$3, $3(a5)
    bne.b   l_36baa
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   d0, -$c(a6)
l_36baa:
    addq.l  #$1, a3
    addq.l  #$1, a4
    addq.w  #$1, d3
l_36bb0:
    cmp.w   d4, d3
    bcs.w   l_36b1c
l_36bb6:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d6
l_36bbc:
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    movea.l -$4(a6), a0
    move.b  $5(a0), d1
    andi.l  #$ff, d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bgt.w   l_36a52
l_36be4:
    moveq   #$0,d3
    move.w  #$ff, d5
    clr.w   d2
l_36bec:
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$10(a6, d0.w), d0
    cmp.l   d3, d0
    bls.b   l_36c02
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$10(a6, d0.w), d3
    move.w  d2, d5
l_36c02:
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    bcs.b   l_36bec
    tst.w   d5
    bne.b   l_36c12
    clr.w   d5
    bra.b   l_36c24
l_36c12:
    cmpi.w  #$1, d5
    bne.b   l_36c1c
    moveq   #$1,d5
    bra.b   l_36c24
l_36c1c:
    cmpi.w  #$2, d5
    bne.b   l_36c24
    moveq   #$2,d5
l_36c24:
    move.w  d5, d0
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
