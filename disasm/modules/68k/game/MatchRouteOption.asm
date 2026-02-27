; ============================================================================
; MatchRouteOption -- Match current game state to a route option by frame counter, validate via CalcEventValue and type checks, and activate the result at $FF09C6 as type-4.
; 178 bytes | $021772-$021823
; ============================================================================
MatchRouteOption:
    movem.l d2-d3/a2-a3, -(a7)
    movea.l  #$00021FA6,a3
    movea.l  #$0005FA2A,a2
    clr.w   d2
    move.w  ($00FF0006).l, d3
l_2178a:
    cmp.w   (a2), d3
    beq.b   l_21798
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$11, d2
    blt.b   l_2178a
l_21798:
    cmpi.w  #$11, d2
    blt.b   l_217a2
l_2179e:
    moveq   #$0,d0
    bra.b   l_2181e
l_217a2:
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CalcEventValue,PC)
    nop
    move.w  d0, d3
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_2179e
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_2179e
    pea     ($0003).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_217ea
    pea     ($0003).w
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_217ea:
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr (CheckRouteEventMatch,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21800
    jsr (FinalizeRouteEvent,PC)
    nop
l_21800:
    movea.l  #$00FF09C6,a2
    move.b  #$4, (a2)
    move.b  d2, $1(a2)
    move.b  ($00FF0007).l, $2(a2)
    move.b  #$1, $3(a2)
    moveq   #$1,d0
l_2181e:
    movem.l (a7)+, d2-d3/a2-a3
    rts
