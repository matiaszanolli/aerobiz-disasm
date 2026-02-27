; ============================================================================
; DisplayRouteFunds -- For each player, prints the quarterly funds figure and draws a proportional tile strip indicating financial performance on the quarterly-report page.
; 196 bytes | $026C14-$026CD7
; ============================================================================
DisplayRouteFunds:
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
l_26c3a:
    cmpi.w  #$1, d5
    bne.b   l_26c8a
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    jsr SetTextCursor
    move.l  $8(a3), -(a7)
    pea     ($0004157E).l
    jsr PrintfNarrow
    move.w  (a2), d0
    mulu.w  #$6, d0
    addq.w  #$6, d0
    move.l  d0, -(a7)
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr PlaceIconTiles
    lea     $20(a7), a7
l_26c8a:
    tst.l   d4
    beq.b   l_26cc2
    move.l  $8(a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d3
    beq.b   l_26cc2
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    mulu.w  #$6, d0
    addq.w  #$7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr DrawTileStrip
    lea     $c(a7), a7
l_26cc2:
    moveq   #$C,d0
    adda.l  d0, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26c3a
    movem.l (a7)+, d2-d5/a2-a3
    rts
