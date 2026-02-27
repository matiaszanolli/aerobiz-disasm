; ============================================================================
; InitRouteFieldA2 -- Randomly select and validate a domestic-range character (0-31) for trade candidate slot A with 1/16 probability, writing type-0 to $FF09CA.
; 108 bytes | $021A28-$021A93
; ============================================================================
InitRouteFieldA2:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21a3c
l_21a38:
    moveq   #$0,d0
    bra.b   l_21a8e
l_21a3c:
    pea     ($000F).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21a38
    pea     ($001F).w
    clr.l   -(a7)
    jsr RandRange
    move.w  d0, d2
    pea     ($0005).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckEventCondition,PC)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21a38
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckAirRouteAvail,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21a38
    clr.b   (a2)
    move.b  d2, $1(a2)
    clr.b   $2(a2)
    moveq   #$1,d0
l_21a8e:
    movem.l (a7)+, d2/a2
    rts
