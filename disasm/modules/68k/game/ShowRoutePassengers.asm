; ============================================================================
; ShowRoutePassengers -- For each player, draws the passenger-load bar on the quarterly-report page and optionally prints the passenger count text.
; 188 bytes | $026B58-$026C13
; ============================================================================
ShowRoutePassengers:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d4
    move.l  $20(a7), d5
    movea.l  #$00FF99E0,a3
    movea.l  #$00FF14B0,a2
    clr.w   d2
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    movea.l a0, a2
l_26b7e:
    tst.l   d4
    beq.b   l_26bcc
    move.l  (a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d3
    beq.b   l_26bcc
    pea     ($0758).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    clr.l   -(a7)
    jsr FillTileRect
    lea     $20(a7), a7
l_26bcc:
    cmpi.w  #$1, d5
    bne.b   l_26bfe
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    move.l  (a3), -(a7)
    pea     ($00041578).l
    jsr PrintfNarrow
    lea     $10(a7), a7
l_26bfe:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26b7e
    movem.l (a7)+, d2-d5/a2-a3
    rts
