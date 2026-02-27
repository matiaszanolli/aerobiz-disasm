; ============================================================================
; ProcessPlayerTurnAction -- Handle one player turn action: load screen, show char info, evaluate value, confirm purchase and deduct cost
; 808 bytes | $00D764-$00DA8B
; ============================================================================
ProcessPlayerTurnAction:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4
    move.l  $c(a6), d5
    lea     $12(a6), a5
    clr.w   -$88(a6)
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    jsr ResourceLoad
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $28(a7), a7
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $c(a7), a7
    bra.w   l_0da52
l_0d804:
    moveq   #$1,d7
    clr.w   d3
    bra.w   l_0d9d2
l_0d80c:
    clr.w   d7
    cmpi.w  #$20, d2
    bge.b   l_0d83c
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d3, d0
    movea.l  #$00FF1704,a0
    move.b  (a0,d0.w), d6
    andi.l  #$ff, d6
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d3, d0
    movea.l  #$00FF0420,a0
    bra.b   l_0d85e
l_0d83c:
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d3, d0
    movea.l  #$00FF15A0,a0
    move.b  (a0,d0.w), d6
    andi.l  #$ff, d6
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d3, d0
    movea.l  #$00FF0460,a0
l_0d85e:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcCharValue,PC)
    nop
    lea     $c(a7), a7
    move.l  d0, -$4(a6)
    move.l  $6(a4), d0
    cmp.l   -$4(a6), d0
    blt.w   l_0d9ae
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047798).l, -(a7)
    pea     -$86(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$86(a6)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0d9d2
    move.l  -$4(a6), d0
    sub.l   d0, $6(a4)
    move.b  #$5, $1(a3)
    move.b  d2, (a3)
    move.b  d3, $2(a3)
    move.b  #$1, $3(a3)
    move.b  d4, d0
    ori.b   #$80, d0
    move.b  d0, (a2)
    pea     ($0001).w
    clr.l   -(a7)
    jsr GameCmd16
    pea     ($000A).w
    pea     ($000A).w
    jsr GameCmd16
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0015).w
    jsr LoadCompressedGfx
    lea     $28(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004779C).l, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    move.w  #$1, -$88(a6)
    bra.b   l_0da04
l_0d9ae:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047794).l, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
l_0d9d2:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DisplayRouteDestChoice,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d3
    cmpi.w  #$ff, d0
    bne.w   l_0d80c
l_0da04:
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $c(a7), a7
    tst.w   -$88(a6)
    bne.b   l_0da4a
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $c(a7), a7
l_0da4a:
    cmpi.w  #$1, -$88(a6)
    beq.b   l_0da78
l_0da52:
    jsr ResourceUnload
    pea     $12(a6)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (SelectRouteDestination,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.w   l_0d804
l_0da78:
    move.w  (a5), ($00FF9A1C).l
    move.w  -$88(a6), d0
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
