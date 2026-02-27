; ============================================================================
; ProcessCharJoin -- Evaluates all candidate chars for recruitment to a player; returns best scoring char index
; 778 bytes | $035D46-$03604F
; ============================================================================
ProcessCharJoin:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d6
    lea     -$4(a6), a5
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  #$ff, d6
    cmpi.w  #$20, d5
    bcc.w   l_36044
    clr.l   (a5)
    moveq   #$0,d7
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  (a3), d4
    bra.w   l_35edc
l_35dba:
    cmpi.b  #$8, (a4)
    bcc.w   l_35ed6
    cmp.w   d4, d5
    beq.w   l_35ed6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (IsCharSlotAvailable,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_35ed6
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    move.l  d0, d3
    andi.l  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (CountCharPairSlots,PC)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35e2c
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35e2e
l_35e2c:
    moveq   #$2,d1
l_35e2e:
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_35e42
    addq.l  #$3, d0
l_35e42:
    asr.l   #$2, d0
    move.l  d0, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetCharStatPtr,PC)
    nop
    lea     $14(a7), a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35e78
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35e7a
l_35e78:
    moveq   #$7,d0
l_35e7a:
    move.w  d0, d2
    tst.w   $12(a6)
    bne.b   l_35e98
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    jsr Multiply32
    move.l  d0, d3
    cmp.l   (a5), d3
    bls.b   l_35ed6
    move.l  d3, (a5)
    bra.b   l_35ed4
l_35e98:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d3, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d3
    cmp.l   d7, d3
    bls.b   l_35ed6
    move.l  d3, d7
l_35ed4:
    move.w  d4, d6
l_35ed6:
    addq.l  #$2, a4
    addq.l  #$2, a2
    addq.w  #$1, d4
l_35edc:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35dba
    moveq   #$0,d0
    move.b  $2(a3), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d4
    move.b  $2(a3), d4
    bra.w   l_3602c
l_35f10:
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    bls.w   l_36028
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (IsCharSlotAvailable,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_36028
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    move.l  d0, d3
    andi.l  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (CountCharPairSlots,PC)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35f7e
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35f80
l_35f7e:
    moveq   #$2,d1
l_35f80:
    move.w  d1, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_35f94
    addq.l  #$3, d0
l_35f94:
    asr.l   #$2, d0
    move.l  d0, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetCharStatPtr,PC)
    nop
    lea     $14(a7), a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35fca
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35fcc
l_35fca:
    moveq   #$7,d0
l_35fcc:
    move.w  d0, d2
    tst.w   $12(a6)
    bne.b   l_35fea
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    jsr Multiply32
    move.l  d0, d3
    cmp.l   (a5), d3
    bls.b   l_36028
    move.l  d3, (a5)
    bra.b   l_36026
l_35fea:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d3, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d3
    cmp.l   d7, d3
    bls.b   l_36028
    move.l  d3, d7
l_36026:
    move.w  d4, d6
l_36028:
    addq.l  #$2, a2
    addq.w  #$1, d4
l_3602c:
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35f10
l_36044:
    move.w  d6, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
