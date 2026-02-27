; ============================================================================
; DispatchGameAction -- Game-command dispatcher: reads a command index (0–10) and jumps via a PC-relative table to one of ten sub-functions (RecruitCharacter, ProcessCharActions, RunPurchaseMenu, etc.), returning the sub-function's result or 0x0B on exit.
; 178 bytes | $01C290-$01C341
; ============================================================================
DispatchGameAction:
    move.l  $c(a7), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    cmp.l   d1, d0
    bhi.w   l_1c33c
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0016
    dc.w    $001E
    dc.w    $0046
    dc.w    $002E
    dc.w    $004E
    dc.w    $005E
    dc.w    $0026
    dc.w    $0056
    dc.w    $0036
    dc.w    $0066
    dc.w    $006E
    jsr RecruitCharacter
    bra.b   l_1c33c
    jsr ProcessCharActions
    bra.b   l_1c33c
    jsr ProcessRouteAction
    bra.b   l_1c33c
    jsr RunPurchaseMenu
    bra.b   l_1c33c
    jsr ShowQuarterReport
    move.w  #$1, ($00FF14B8).l
    bra.b   l_1c33c
    jsr BuildRouteLoop
    bra.b   l_1c33c
    jsr RunTurnSequence
    bra.b   l_1c33c
    jsr ShowQuarterSummary
    bra.b   l_1c33c
    jsr RunPlayerTurn
    bra.b   l_1c33c
    jsr RunQuarterScreen
    bra.b   l_1c33c
    jsr RunGameMenu
    cmpi.w  #$1, d0
    bne.b   l_1c33c
    moveq   #$B,d2
l_1c33c:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
