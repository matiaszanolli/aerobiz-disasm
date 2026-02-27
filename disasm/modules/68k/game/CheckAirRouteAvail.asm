; ============================================================================
; CheckAirRouteAvail -- Determine whether an air route is available for a character by checking player entity_bits and city/route window bits for char ownership.
; 168 bytes | $0224AC-$022553
; ============================================================================
CheckAirRouteAvail:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d4
    movea.l  #$00FF0018,a2
    clr.w   d2
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d5
    bra.b   l_22546
l_224dc:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_2250a
    moveq   #$0,d0
    move.b  $4(a2), d0
    moveq   #$0,d1
    move.b  $5(a2), d1
    add.l   d1, d0
    ble.b   l_22540
l_22506:
    moveq   #$1,d0
    bra.b   l_2254e
l_2250a:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  d5, d1
    andi.l  #$ffff, d1
    sub.l   d1, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d2, d1
    mulu.w  #$e, d1
    move.w  d4, d6
    add.w   d6, d6
    add.w   d6, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    bne.b   l_22506
l_22540:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_22546:
    cmpi.w  #$4, d2
    blt.b   l_224dc
    moveq   #$0,d0
l_2254e:
    movem.l (a7)+, d2-d6/a2
    rts
