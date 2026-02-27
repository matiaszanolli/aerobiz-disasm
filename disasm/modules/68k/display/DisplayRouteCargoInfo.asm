; ============================================================================
; DisplayRouteCargoInfo -- For each player, renders the cargo bar on the quarterly-report page: optionally prints the revenue figure and draws a proportional filled tile strip representing cargo volume vs. capacity.
; 296 bytes | $026A30-$026B57
; ============================================================================
DisplayRouteCargoInfo:
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $24(a7), d5
    move.l  $28(a7), d7
    movea.l  #$00FF99E0,a2
    movea.l  #$00FF14B0,a3
    cmpi.w  #$1, d7
    moveq   #$1,d6
    clr.w   d4
    moveq   #$0,d0
    move.w  d4, d0
    add.l   d0, d0
    lea     (a3,d0.l), a0
    movea.l a0, a3
l_26a5c:
    move.l  (a2), d2
    sub.l   $4(a2), d2
    cmpi.w  #$1, d7
    bne.b   l_26a94
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    move.l  d2, -(a7)
    pea     ($00041572).l
    jsr PrintfNarrow
    lea     $10(a7), a7
l_26a94:
    tst.l   d5
    beq.w   l_26b42
    move.l  $4(a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d5, d1
    jsr UnsignedDivide
    move.w  d0, d2
    tst.w   d2
    ble.b   l_26aea
    pea     ($0759).w
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26aea:
    move.l  (a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d5, d1
    jsr UnsignedDivide
    move.w  d0, d3
    sub.w   d2, d3
    tst.w   d3
    ble.b   l_26b42
    pea     ($075A).w
    pea     ($0009).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26b42:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_26a5c
    movem.l (a7)+, d2-d7/a2-a3
    rts
