; ============================================================================
; FinalizeQuarterEnd -- Finalises a player's route-placement turn: presents relation panels, browses the char list for a new hire, calls FindRouteSlotByCharState/CalcRouteRevenue/CalcCharAdvantage, handles the confirmation dialog, and stores the resulting hire into the route slot.
; 1090 bytes | $027FF4-$028435
; ============================================================================
FinalizeQuarterEnd:
    link    a6,#-$50
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    movea.l  #$000482FC,a3
    movea.l  #$0001183A,a4
    lea     $12(a6), a5
    clr.w   d5
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots
    lea     $24(a7), a7
    jsr ResourceUnload
l_2807e:
    cmpi.w  #$1, d5
    bne.b   l_280d8
    jsr ResourceLoad
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ScanRouteSlots
    lea     $24(a7), a7
    jsr ResourceUnload
    clr.w   d5
l_280d8:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $8(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0019).w
    pea     ($0007).w
    jsr SetTextCursor
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     $12(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $2c(a7), a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    beq.w   l_283ec
    movea.l  #$00FF09D8,a0
    move.b  (a0,d4.w), d0
    andi.b  #$3, d0
    beq.b   l_281ca
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $24(a3), -(a7)
l_281ba:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_2807e
l_281ca:
    move.w  d4, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    moveq   #$1,d5
    jsr ResourceUnload
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (FindRouteSlotByCharState,PC)
    nop
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.w   l_283d6
    move.b  #$1, $1(a2)
    move.b  d4, (a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$c, d0
    bgt.w   l_283b4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.w  d0, d6
    ble.w   l_28360
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $10(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunSlotCountPicker,PC)
    nop
    lea     $1c(a7), a7
    move.w  d0, d6
    ble.w   l_2834a
    move.b  d6, $2(a2)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $c(a3), -(a7)
    pea     -$50(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$50(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_2834a
    pea     ($0008).w
    pea     ($000A).w
    jsr GameCmd16
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
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
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $20(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_283ec
l_2834a:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    bra.w   l_2807e
l_28360:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    tst.b   (a0,d0.w)
    beq.b   l_2839e
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $14(a3), -(a7)
    bra.w   l_281ba
l_2839e:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)
    bra.w   l_281ba
l_283b4:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $18(a3), -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $18(a7), a7
    bra.w   l_2834a
l_283d6:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $1c(a3), -(a7)
    bra.w   l_281ba
l_283ec:
    cmpi.w  #$1, d5
    bne.b   l_2842a
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
l_2842a:
    move.w  (a5), d0
    movem.l -$78(a6), d2-d7/a2-a5
    unlk    a6
    rts
