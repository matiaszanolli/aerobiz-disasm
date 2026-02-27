; ============================================================================
; ProcessRouteDisplayS2 -- Renders one route-panel subview for a player: computes stat change and revenue for the selected route type, displays the revenue figure and occupancy bar, draws a proportional colored tile strip, and decompresses and places the plane graphic.
; 918 bytes | $02A0DE-$02A473
; ============================================================================
ProcessRouteDisplayS2:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d6
    lea     -$8(a6), a3
    lea     -$2(a6), a4
    movea.l  #$00FF0120,a5
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d6, d0
    mulu.w  #$9, d0
    addq.w  #$3, d0
    move.w  d0, (a3)
    moveq   #$A,d7
    clr.w   d3
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_2a148
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_2a1cc
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_2a250
    bra.w   l_2a2d0
l_2a148:
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a1ac:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $1(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a1ac
    bra.w   l_2a2d0
l_2a1cc:
    moveq   #$2,d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FB,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a230:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a230
    bra.w   l_2a2d0
l_2a250:
    moveq   #$1,d2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FA,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.w  d0, (a4)
    clr.w   d2
l_2a2b4:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $2(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a2b4
l_2a2d0:
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$6(a6), -(a7)
    pea     ($00042118).l
    jsr PrintfNarrow
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00042114).l
    jsr PrintfWide
    lea     $20(a7), a7
    pea     ($0001).w
    pea     ($0008).w
    move.w  (a4), d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    move.w  d7, d0
    addq.w  #$3, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    jsr RenderTileStrip
    move.w  d3, d0
    ext.l   d0
    bge.b   l_2a350
    addq.l  #$3, d0
l_2a350:
    asr.l   #$2, d0
    move.w  d0, d3
    cmpi.w  #$32, d3
    bge.b   l_2a3ac
    moveq   #$3,d2
    move.l  #$8000, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    pea     ($0640).w
    bra.b   l_2a3fc
l_2a3ac:
    moveq   #$15,d2
    move.l  #$8000, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
    pea     ($0649).w
l_2a3fc:
    jsr TilePlacement
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderRouteIndicator,PC)
    nop
    move.l  d5, d0
    lsl.l   #$2, d0
    movea.l  #$000A1B34,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($000E).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$b6, d0
    move.l  d0, -(a7)
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
