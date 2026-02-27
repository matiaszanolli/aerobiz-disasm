; ============================================================================
; EvaluateTurnAvailability -- Evaluate and list available character turns for a player by randomly probing route slots and checking CheckCharAvailability and CheckTurnTiming.
; 256 bytes | $021B9C-$021C9B
; ============================================================================
EvaluateTurnAvailability:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $8(a6), d6
    movea.l $10(a6), a2
    tst.w   $e(a6)
    bgt.b   l_21bb8
l_21bb2:
    moveq   #$0,d0
    bra.w   l_21c92
l_21bb8:
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d7
    move.b  $4(a3), d7
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d7
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (CalculateTurnCapacity,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21bb2
    clr.w   d5
    clr.w   d4
    bra.w   l_21c88
l_21bf0:
    cmp.w   d7, d5
    bge.w   l_21c90
l_21bf6:
    move.w  d7, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d3
    clr.w   d2
    bra.b   l_21c1e
l_21c0e:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    move.w  -$4(a6, d0.l), d0
    cmp.w   d3, d0
    beq.b   l_21c22
    addq.w  #$1, d2
l_21c1e:
    cmp.w   d4, d2
    blt.b   l_21c0e
l_21c22:
    cmp.w   d4, d2
    blt.b   l_21bf6
    move.w  d6, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    moveq   #$2,d1
    cmp.l   d0, d1
    beq.b   l_21c86
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CheckCharAvailability,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21c86
    jsr (CheckTurnTiming,PC)
    nop
    tst.w   d0
    beq.b   l_21c6c
    clr.b   (a2)
    bra.b   l_21c70
l_21c6c:
    move.b  #$1, (a2)
l_21c70:
    move.b  d6, $1(a2)
    move.b  d3, $2(a2)
    addq.l  #$4, a2
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    move.w  d3, -$4(a6, d0.l)
    addq.w  #$1, d4
l_21c86:
    addq.w  #$1, d5
l_21c88:
    cmp.w   $e(a6), d5
    blt.w   l_21bf0
l_21c90:
    move.w  d4, d0
l_21c92:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
