; ============================================================================
; ProcessRouteOptionC -- Randomly select and validate a character for route option C, checking char stat level vs. airline size and a 50% random gate, storing type-3 to $FF09C6.
; 330 bytes | $021824-$02196D
; ============================================================================
ProcessRouteOptionC:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$0001D6A4,a5
    movea.l  #$00FF09C6,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21840
l_2183a:
    moveq   #$0,d0
    bra.w   l_21968
l_21840:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a5)
    move.w  d0, d2
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckEventMatch,PC)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21840
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckEventMatch,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21840
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $1(a2), d4
    add.b   $3(a2), d4
    addi.b  #$ff, d4
    andi.l  #$ff, d4
    clr.w   d3
l_21896:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    ble.b   l_218b6
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d2
    bra.b   l_218ca
l_218b6:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d2, d1
    sub.w   d0, d1
    moveq   #$0,d0
    move.b  $2(a2), d0
    add.w   d0, d1
    move.w  d1, d2
l_218ca:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    addi.l  #$a, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF1298,a0
    lea     (a0,d1.w), a0
    movea.l a0, a3
    addq.l  #$2, a0
    movea.l a0, a4
    move.b  (a0), d1
    andi.l  #$ff, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.b   l_2190a
    move.b  (a4), d0
    cmp.b   $3(a3), d0
    bcc.b   l_21912
l_2190a:
    addq.w  #$1, d3
    cmpi.w  #$a, d3
    blt.b   l_21896
l_21912:
    cmpi.w  #$a, d3
    bge.w   l_2183a
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    tst.l   d0
    beq.w   l_2183a
    move.b  d2, d0
    move.l  d0, -(a7)
    jsr (CheckRouteEventMatch,PC)
    nop
    tst.w   d0
    beq.b   l_2193e
    jsr (FinalizeRouteEvent,PC)
    nop
l_2193e:
    movea.l  #$00FF09C6,a2
    move.b  #$3, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    pea     ($0004).w
    pea     ($0002).w
    jsr     (a5)
    lea     $c(a7), a7
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_21968:
    movem.l (a7)+, d2-d4/a2-a5
    rts
