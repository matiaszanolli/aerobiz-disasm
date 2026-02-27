; ============================================================================
; SelectActiveRoute -- Select and activate a weighted-random route event based on frame timing, process existing events, and store the chosen route index and delay in $FF09C2.
; 342 bytes | $02150A-$02165F
; ============================================================================
SelectActiveRoute:
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00FF0006,a5
    movea.l  #$0005F9DE,a3
    clr.w   d2
l_2151c:
    move.w  (a3), d0
    cmp.w   (a5), d0
    bgt.b   l_2155e
    move.w  (a5), d0
    ext.l   d0
    move.w  (a3), d1
    ext.l   d1
    addq.l  #$4, d1
    cmp.l   d1, d0
    bgt.b   l_2155e
    move.w  (a5), d0
    ext.l   d0
    move.w  (a3), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0063).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  (a7)+, d1
    cmp.l   d1, d0
    blt.b   l_21568
l_2155e:
    addq.l  #$8, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_2151c
l_21568:
    cmpi.w  #$6, d2
    blt.b   l_21574
l_2156e:
    moveq   #$0,d0
    bra.w   l_2165a
l_21574:
    movea.l  #$00FF09C2,a4
    tst.b   (a4)
    beq.b   l_2156e
    cmpi.b  #$ff, (a4)
    beq.b   l_21590
    move.b  (a4), d0
    move.l  d0, -(a7)
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_21590:
    movea.l a3, a2
    addq.l  #$3, a2
    clr.w   d3
    bra.w   l_2161a
l_2159a:
    pea     ($0002).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr (CheckEventCondition,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_215bc
    pea     ($0002).w
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_215bc:
    pea     ($0003).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr (CheckEventCondition,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_215de
    pea     ($0003).w
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_215de:
    pea     ($0004).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr (CheckEventCondition,PC)
    nop
    addq.l  #$8, a7
    tst.w   d0
    beq.b   l_21600
    pea     ($0004).w
    jsr (ProcessEventState,PC)
    nop
    addq.l  #$4, a7
l_21600:
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr (CheckRouteEventMatch,PC)
    nop
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_21616
    jsr (FinalizeRouteEvent,PC)
    nop
l_21616:
    addq.l  #$1, a2
    addq.w  #$1, d3
l_2161a:
    cmpi.w  #$5, d3
    bge.b   l_21628
    cmpi.b  #$ff, (a2)
    bne.w   l_2159a
l_21628:
    clr.b   (a4)
    move.b  d2, $1(a4)
    move.b  $1(a5), $2(a4)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr RandRange
    addq.l  #$8, a7
    add.b   $1(a3), d0
    sub.b   $1(a5), d0
    addq.b  #$4, d0
    move.b  d0, $3(a4)
    moveq   #$1,d0
l_2165a:
    movem.l (a7)+, d2-d3/a2-a5
    rts
