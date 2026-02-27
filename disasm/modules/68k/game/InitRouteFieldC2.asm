; ============================================================================
; InitRouteFieldC2 -- Distribute random turn action counts across 4 players via RandRange(3), evaluate availability for each via EvaluateTurnAvailability, return 1 if any slots assigned.
; 140 bytes | $021B10-$021B9B
; ============================================================================
InitRouteFieldC2:
    link    a6,#-$8
    movem.l d2-d3/a2-a3, -(a7)
    lea     -$8(a6), a3
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    clr.w   d2
l_21b30:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a3,a0.l)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_21b30
    movea.l  #$00FF09CE,a2
    clr.w   d3
    clr.w   d2
l_21b58:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    pea     (a2, d0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a3,a0.l), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (EvaluateTurnAvailability,PC)
    nop
    lea     $c(a7), a7
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_21b58
    tst.w   d3
    ble.b   l_21b90
    moveq   #$1,d0
    bra.b   l_21b92
l_21b90:
    moveq   #$0,d0
l_21b92:
    movem.l -$18(a6), d2-d3/a2-a3
    unlk    a6
    rts
