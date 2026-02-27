; ============================================================================
; RenderRouteIndicator -- Draws the coloured route-popularity indicator tile for a given player/route-type combination: reads the relevant stat byte, applies any in-progress stat change, clamps to [0,100], scales to a pixel position, and calls TilePlacement.
; 230 bytes | $02A5D2-$02A6B7
; ============================================================================
RenderRouteIndicator:
    movem.l d2-d6/a2, -(a7)
    move.l  $1c(a7), d3
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_2a608
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_2a612
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_2a61c
    bra.b   l_2a624
l_2a608:
    clr.w   d4
    moveq   #$0,d2
    move.b  $1(a2), d2
    bra.b   l_2a624
l_2a612:
    moveq   #$2,d4
    moveq   #$0,d2
    move.b  $3(a2), d2
    bra.b   l_2a624
l_2a61c:
    moveq   #$1,d4
    moveq   #$0,d2
    move.b  $2(a2), d2
l_2a624:
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    add.w   d0, d2
    move.w  d5, d3
    mulu.w  #$9, d3
    addq.w  #$3, d3
    tst.w   d2
    ble.b   l_2a650
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2a652
l_2a650:
    moveq   #$0,d0
l_2a652:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   l_2a660
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2a662
l_2a660:
    moveq   #$64,d0
l_2a662:
    move.w  d0, d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($006F).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d3, d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    movem.l (a7)+, d2-d6/a2
    rts
