; ============================================================================
; ProcessRouteOptionB -- Randomly trigger a type-1 route option event with 1/64 probability if $FF09C2 is empty, validate delay, and store result in $FF09C2.
; 274 bytes | $021660-$021771
; ============================================================================
ProcessRouteOptionB:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$0002211A,a3
    movea.l  #$00021FD4,a4
    movea.l  #$0005FA0E,a5
    movea.l  #$00FF09C2,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21688
l_21682:
    moveq   #$0,d0
    bra.w   l_2176c
l_21688:
    pea     ($003F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21682
    pea     ($0006).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    andi.l  #$ff, d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    pea     ($0002).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_216e2
    pea     ($0002).w
    jsr     (a3)
    addq.l  #$4, a7
l_216e2:
    pea     ($0003).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_216fa
    pea     ($0003).w
    jsr     (a3)
    addq.l  #$4, a7
l_216fa:
    pea     ($0004).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_21712
    pea     ($0004).w
    jsr     (a3)
    addq.l  #$4, a7
l_21712:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    move.l  d0, -(a7)
    jsr (CheckRouteEventMatch,PC)
    nop
    tst.w   d0
    beq.b   l_21730
    jsr (FinalizeRouteEvent,PC)
    nop
l_21730:
    move.b  #$1, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $2(a5, a0.l), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr RandRange
    lea     $c(a7), a7
    addq.b  #$1, d0
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_2176c:
    movem.l (a7)+, d2-d3/a2-a5
    rts
