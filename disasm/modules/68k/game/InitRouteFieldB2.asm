; ============================================================================
; InitRouteFieldB2 -- Randomly select and validate any character (0-88) for trade candidate slot B with 1/8 probability, writing type-1 to $FF09CA.
; 110 bytes | $021A94-$021B01
; ============================================================================
InitRouteFieldB2:
    movem.l d2/a2, -(a7)
    movea.l  #$00FF09CA,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_21aa8
l_21aa4:
    moveq   #$0,d0
    bra.b   l_21afc
l_21aa8:
    pea     ($0007).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21aa4
    pea     ($0058).w
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
    bne.b   l_21aa4
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckAirRouteAvail,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21aa4
    move.b  #$1, (a2)
    move.b  d2, $1(a2)
    clr.b   $2(a2)
    moveq   #$1,d0
l_21afc:
    movem.l (a7)+, d2/a2
    rts
