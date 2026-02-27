; ============================================================================
; GameUpdate3 -- Per-round city/route update: calls ClampValue, iterates CalcCityStats for all 7 cities, calls ValidateRange (unloads resources if needed), refreshes the map via MenuSelectEntry, optionally loads background graphics, runs ProcessInputEvent, iterates PrepareTradeOffer for 4 players, calls FilterCollection, UpdateRouteFieldValues, and UpdateGameStateCounters before reloading resources.
; 184 bytes | $01E402-$01E4B9
; ============================================================================
GameUpdate3:
    move.l  d2, -(a7)
    jsr (ClampValue,PC)
    nop
    clr.w   d2
l_1e40c:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CalcCityStats,PC)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_1e40c
    jsr (ValidateRange,PC)
    nop
    tst.w   d0
    beq.b   l_1e432
    jsr ResourceUnload
l_1e432:
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $18(a7), a7
    tst.w   ($00FF000A).l
    bne.b   l_1e480
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $18(a7), a7
l_1e480:
    jsr (ProcessInputEvent,PC)
    nop
    clr.w   d2
l_1e488:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (PrepareTradeOffer,PC)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1e488
    jsr (FilterCollection,PC)
    nop
    jsr (UpdateRouteFieldValues,PC)
    nop
    jsr (UpdateGameStateCounters,PC)
    nop
    jsr ResourceLoad
    move.l  (a7)+, d2
    rts
