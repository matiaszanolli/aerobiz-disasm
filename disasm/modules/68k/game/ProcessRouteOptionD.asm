; ============================================================================
; ProcessRouteOptionD -- Randomly trigger a type-2 route option for an available character with 1/8 probability if $FF09C6 is empty, after CheckEventMatch and route event validation.
; 172 bytes | $02196E-$021A19
; ============================================================================
ProcessRouteOptionD:
    movem.l d2/a2-a3, -(a7)
    movea.l  #$0001D6A4,a3
    movea.l  #$00FF09C6,a2
    cmpi.b  #$ff, (a2)
    beq.b   l_2198a
l_21984:
    moveq   #$0,d0
    bra.w   l_21a14
l_2198a:
    pea     ($0007).w
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.l   d0
    bne.b   l_21984
l_21998:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a3)
    move.w  d0, d2
    clr.l   -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckEventMatch,PC)
    nop
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_21998
    pea     ($0001).w
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CheckEventMatch,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_21998
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d1
    move.l  d1, -(a7)
    jsr (CheckRouteEventMatch,PC)
    nop
    tst.w   d0
    beq.b   l_219ea
    jsr (FinalizeRouteEvent,PC)
    nop
l_219ea:
    movea.l  #$00FF09C6,a2
    move.b  #$2, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    pea     ($0004).w
    pea     ($0002).w
    jsr     (a3)
    lea     $c(a7), a7
    move.b  d0, $3(a2)
    moveq   #$1,d0
l_21a14:
    movem.l (a7)+, d2/a2-a3
    rts
