; ============================================================================
; ShowRouteSelectMenu -- Shows the aircraft-selection menu for a route, allows the player to navigate with left/right input to cycle through aircraft types, updates the route indicator graphic, and returns the selected aircraft index or -1 for cancel.
; 350 bytes | $02A474-$02A5D1
; ============================================================================
ShowRouteSelectMenu:
    link    a6,#-$8
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    lea     -$6(a6), a2
    movea.l  #$00FF13FC,a3
    moveq   #$1,d5
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004211E).l
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_2a4c0
    moveq   #$1,d6
    bra.b   l_2a4c2
l_2a4c0:
    moveq   #$0,d6
l_2a4c2:
    clr.w   (a2)
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d3
    bra.w   l_2a5c0
l_2a4d2:
    tst.w   d3
    beq.b   l_2a534
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$000A1B34,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($000E).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$b6, d0
    move.l  d0, -(a7)
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderRouteIndicator,PC)
    nop
    lea     $20(a7), a7
    clr.w   d3
l_2a534:
    tst.w   d6
    beq.b   l_2a54c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_2a54c
    pea     ($0003).w
    bra.b   l_2a5b4
l_2a54c:
    clr.w   d6
    move.w  -$6(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, (a2)
    andi.w  #$30, d0
    beq.b   l_2a582
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d5
    move.w  (a2), d0
    andi.w  #$10, d0
    beq.b   l_2a5b0
    moveq   #-$1,d2
    bra.b   l_2a5b0
l_2a582:
    move.w  (a2), d0
    andi.w  #$1, d0
    beq.b   l_2a598
    move.w  #$1, (a3)
    subq.w  #$1, d2
    tst.w   d2
    bge.b   l_2a5ae
    moveq   #$4,d2
    bra.b   l_2a5ae
l_2a598:
    move.w  (a2), d0
    andi.w  #$2, d0
    beq.b   l_2a5b0
    move.w  #$1, (a3)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    ble.b   l_2a5ae
    clr.w   d2
l_2a5ae:
    moveq   #$1,d3
l_2a5b0:
    pea     ($0006).w
l_2a5b4:
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_2a5c0:
    tst.w   d5
    bne.w   l_2a4d2
    move.w  d2, d0
    movem.l -$28(a6), d2-d7/a2-a3
    unlk    a6
    rts
