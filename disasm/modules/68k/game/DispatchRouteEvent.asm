; ============================================================================
; DispatchRouteEvent -- Iterate $FF09C2 records and dispatch to HandleRouteEventType0/1/2/3 or HandleAirlineRouteEvent based on stored event type.
; 114 bytes | $022610-$022681
; ============================================================================
DispatchRouteEvent:
    move.l  $10(a7), d3
    movea.l  #$00FF09C2,a2
    clr.w   d2
l_2261c:
    cmp.b   (a2), d3
    bne.b   l_22672
    moveq   #$0,d0
    move.b  d3, d0
    ext.l   d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.b   l_22672
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $0014
    dc.w    $001E
    dc.w    $0028
    dc.w    $0032
    move.l  a2, -(a7)
    jsr (HandleRouteEventType0,PC)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    jsr (HandleRouteEventType1,PC)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    jsr (HandleRouteEventType2,PC)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    jsr (HandleRouteEventType3,PC)
    nop
    bra.b   l_22670
    move.l  a2, -(a7)
    jsr (HandleAirlineRouteEvent,PC)
    nop
l_22670:
    addq.l  #$4, a7
l_22672:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_2261c
    movem.l (a7)+, d2-d3/a2
    rts
