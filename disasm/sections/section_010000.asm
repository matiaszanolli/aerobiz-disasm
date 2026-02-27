; ===========================================================================
; ROM Data: $010000-$01FFFF
; 65536 bytes (32768 words)
; ===========================================================================

    move.l  $0008(a6),d6
    clr.w   d5
    clr.w   d4
    move.w  ($00FF0006).l,d7
    addi.w  #$ffff,d7
    clr.w   d3
.l10014:                                                ; $010014
    clr.w   d2
.l10016:                                                ; $010016
    move.w  d3,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l10062
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    lea     $0018(sp),sp
    move.l  -$0004(a6),d0
    cmp.l   -$0008(a6),d0
    bge.b   .l10060
    addq.w  #$1,d5
.l10060:                                                ; $010060
    addq.w  #$1,d4
.l10062:                                                ; $010062
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l10016
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    blt.b   .l10014
    clr.w   d3
.l10074:                                                ; $010074
    clr.w   d2
.l10076:                                                ; $010076
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff04e0,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l100c4
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    addi.w  #$20,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    lea     $0018(sp),sp
    move.l  -$0004(a6),d0
    cmp.l   -$0008(a6),d0
    bge.b   .l100c2
    addq.w  #$1,d5
.l100c2:                                                ; $0100C2
    addq.w  #$1,d4
.l100c4:                                                ; $0100C4
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l10076
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    blt.b   .l10074
    tst.w   d4
    bne.b   .l100da
    moveq   #-$1,d5
.l100da:                                                ; $0100DA
    cmpi.w  #$1,$000e(a6)
    bne.b   .l100e6
    move.w  d4,d0
    bra.b   .l100e8
.l100e6:                                                ; $0100E6
    move.w  d5,d0
.l100e8:                                                ; $0100E8
    movem.l -$0020(a6),d2-d7
    unlk    a6
    rts
    include "disasm/modules/68k/game/LoadScreenPalette.asm"
    include "disasm/modules/68k/game/ShowPlayerChart.asm"
    include "disasm/modules/68k/game/CalcTotalCharValue.asm"
    include "disasm/modules/68k/game/CalcPlayerFinances.asm"
    include "disasm/modules/68k/game/SumPlayerStats.asm"
    include "disasm/modules/68k/math/SumStatBytes.asm"
    include "disasm/modules/68k/game/CountProfitableRelations.asm"
    include "disasm/modules/68k/game/SortWordPairs.asm"

    include "disasm/modules/68k/game/CalcCharDisplayIndex.asm"

    include "disasm/modules/68k/graphics/RenderRouteSlotScreen.asm"

    include "disasm/modules/68k/game/ShowRouteDetailsDialog.asm"

    include "disasm/modules/68k/game/ManageRouteSlots.asm"
    include "disasm/modules/68k/game/ShowTextDialog.asm"
    include "disasm/modules/68k/game/CalcRouteRevenue.asm"

    include "disasm/modules/68k/game/ProcessPlayerRoutes.asm"

    include "disasm/modules/68k/game/IsRouteSlotPending.asm"

    include "disasm/modules/68k/game/AccumulateRouteBits.asm"

    include "disasm/modules/68k/game/FindAvailSlot.asm"

    include "disasm/modules/68k/game/ClearRouteSlotBit.asm"

    include "disasm/modules/68k/game/UpdateRouteRevenue.asm"

    include "disasm/modules/68k/game/CalcRouteProfit.asm"

    include "disasm/modules/68k/game/ShowRouteInfoDlg.asm"

    include "disasm/modules/68k/text/FormatRouteDetails.asm"

    include "disasm/modules/68k/game/GetCharStatField.asm"

    include "disasm/modules/68k/game/ClearRoutePendingFlags.asm"

    include "disasm/modules/68k/game/CalcRouteValue.asm"

    include "disasm/modules/68k/game/ShowQuarterSummary.asm"

    include "disasm/modules/68k/game/IsCharAttrValid.asm"

    include "disasm/modules/68k/game/RunRouteManagementUI.asm"

    include "disasm/modules/68k/game/SelectCharRelation.asm"

    include "disasm/modules/68k/game/FindRelationByChar.asm"

    include "disasm/modules/68k/game/SearchCharInSlots.asm"

    include "disasm/modules/68k/graphics/RenderCharacterPanel.asm"

    include "disasm/modules/68k/game/FindSpriteByID.asm"

    include "disasm/modules/68k/game/UpdateSpritePos.asm"

    include "disasm/modules/68k/game/InitRouteBuffer.asm"

    include "disasm/modules/68k/game/InitSpriteData.asm"

    include "disasm/modules/68k/game/CalcQuarterBonus.asm"

    include "disasm/modules/68k/game/UpdateCharacterStats.asm"

    include "disasm/modules/68k/game/ProcessCharActions.asm"

    include "disasm/modules/68k/game/ProcessCharacterAction.asm"

    include "disasm/modules/68k/game/ValidateCharacterState.asm"

    include "disasm/modules/68k/game/CalcCharacterBonus.asm"

    include "disasm/modules/68k/game/ApplyCharacterEffect.asm"

    include "disasm/modules/68k/input/WaitStableInput.asm"

    include "disasm/modules/68k/game/RankCharCandidatesFull.asm"

    include "disasm/modules/68k/graphics/RenderTilePattern.asm"

    include "disasm/modules/68k/graphics/DrawScreenElement.asm"

    include "disasm/modules/68k/game/UpdateScreenLayout.asm"

    include "disasm/modules/68k/graphics/RefreshDisplayArea.asm"

    include "disasm/modules/68k/game/ProcessCityChange.asm"

    include "disasm/modules/68k/game/RunAssignmentUI.asm"

    include "disasm/modules/68k/game/UpdateCityStatus.asm"

    include "disasm/modules/68k/game/RunGameMenu.asm"

    include "disasm/modules/68k/game/CalcCityMetrics.asm"

    include "disasm/modules/68k/game/ResolveCityConflict.asm"

    include "disasm/modules/68k/game/ScanCitySlots.asm"

    include "disasm/modules/68k/game/ProcessCharSelectInput.asm"

    include "disasm/modules/68k/game/BrowseMapPages.asm"
    include "disasm/modules/68k/graphics/DrawDualPanels.asm"

    include "disasm/modules/68k/util/SignExtendAndCall.asm"

    include "disasm/modules/68k/game/ToggleDisplayMode.asm"

    include "disasm/modules/68k/game/NavigateCharList.asm"

    include "disasm/modules/68k/game/HandleCharListAction.asm"

    include "disasm/modules/68k/game/ProcessEventSequence.asm"

    include "disasm/modules/68k/game/EvaluateEventCond.asm"

    include "disasm/modules/68k/game/GenerateEventResult.asm"

    include "disasm/modules/68k/game/RecordEventOutcome.asm"

    include "disasm/modules/68k/game/UpdateSlotEvents.asm"

    include "disasm/modules/68k/game/UpdateEventState.asm"

    include "disasm/modules/68k/game/ApplyEventEffect.asm"

    include "disasm/modules/68k/game/HandleEventCallback.asm"

    include "disasm/modules/68k/game/ResetEventData.asm"

    include "disasm/modules/68k/game/CalcCityCharBonus.asm"
    include "disasm/modules/68k/game/InitAllCharRecords.asm"
    include "disasm/modules/68k/game/InitCharRecord.asm"
    include "disasm/modules/68k/game/ShowStatsSummary.asm"
    include "disasm/modules/68k/game/RunCharManagement.asm"

    include "disasm/modules/68k/game/ComputeQuarterResults.asm"

    include "disasm/modules/68k/game/UpdatePlayerAssets.asm"

    include "disasm/modules/68k/game/GetCharRelation.asm"
    include "disasm/modules/68k/game/BrowseRelations.asm"
    include "disasm/modules/68k/text/FormatRelationDisplay.asm"
    include "disasm/modules/68k/text/FormatRelationStats.asm"
    include "disasm/modules/68k/game/ShowRelationAction.asm"
    include "disasm/modules/68k/game/ShowRelationResult.asm"
    include "disasm/modules/68k/game/BrowsePartners.asm"
    include "disasm/modules/68k/game/ScanRouteSlots.asm"
    include "disasm/modules/68k/game/CalcRelationValue.asm"
    include "disasm/modules/68k/game/InitFlightDisplay.asm"
    include "disasm/modules/68k/game/ClearFlightSlots.asm"
    include "disasm/modules/68k/game/UpdateFlightSlots.asm"

    include "disasm/modules/68k/game/InitTurnState.asm"

    include "disasm/modules/68k/game/ProgressGamePhase.asm"


    include "disasm/modules/68k/graphics/AnimateFlightPaths.asm"
    include "disasm/modules/68k/graphics/DiagonalWipe.asm"
    include "disasm/modules/68k/graphics/DrawCharDetailPanel.asm"
    include "disasm/modules/68k/game/ShowCharStats.asm"
    include "disasm/modules/68k/game/MatchCharSlots.asm"

    include "disasm/modules/68k/game/GameUpdate2.asm"

    include "disasm/modules/68k/game/RunMainMenu.asm"

    include "disasm/modules/68k/game/HandleMenuSelection.asm"

    include "disasm/modules/68k/display/DisplayMenuOption.asm"

    include "disasm/modules/68k/input/ValidateMenuInput.asm"

    include "disasm/modules/68k/game/ExecMenuCommand.asm"

    include "disasm/modules/68k/game/DispatchGameAction.asm"

    include "disasm/modules/68k/game/UpdateCharRelation.asm"


    include "disasm/modules/68k/game/ShowPlayerInfo.asm"

    include "disasm/modules/68k/game/EvalCharMatch.asm"

    include "disasm/modules/68k/game/ProcessCharTrade.asm"

    include "disasm/modules/68k/graphics/RenderDisplayBuffer.asm"

    include "disasm/modules/68k/game/UpdateGraphicsState.asm"

    include "disasm/modules/68k/game/ShowCompatibilityScore.asm"

    include "disasm/modules/68k/graphics/ClearGraphicsArea.asm"

    include "disasm/modules/68k/input/RefreshAndWait.asm"
    include "disasm/modules/68k/display/SetDisplayMode.asm"
    include "disasm/modules/68k/game/MenuSelectEntry.asm"
    include "disasm/modules/68k/game/LoadDisplaySet.asm"
    include "disasm/modules/68k/memory/MemFillByte.asm"
    include "disasm/modules/68k/memory/MemCopy.asm"
    include "disasm/modules/68k/memory/MemFillWord.asm"
    include "disasm/modules/68k/vdp/VRAMBulkLoad.asm"
    include "disasm/modules/68k/input/PollAction.asm"
    include "disasm/modules/68k/math/RandRange.asm"
    include "disasm/modules/68k/math/ByteSum.asm"
    include "disasm/modules/68k/game/ResourceLoad.asm"
    include "disasm/modules/68k/game/ResourceUnload.asm"

    include "disasm/modules/68k/text/FormatTextString.asm"

    include "disasm/modules/68k/graphics/DrawTileGrid.asm"

    include "disasm/modules/68k/graphics/RenderTextLineS1.asm"

    include "disasm/modules/68k/game/ProcessTextControl.asm"

    include "disasm/modules/68k/text/AlignTextBlock.asm"

    include "disasm/modules/68k/game/SetScrollOffset.asm"

    include "disasm/modules/68k/game/PackScrollDeltaToVRAM.asm"

    include "disasm/modules/68k/graphics/DrawTilemapLine.asm"

    include "disasm/modules/68k/graphics/DrawTilemapLineWrap.asm"

    include "disasm/modules/68k/game/CalcScalar.asm"

    include "disasm/modules/68k/game/PackScrollControlBlock.asm"

    include "disasm/modules/68k/math/RoundValue.asm"
    include "disasm/modules/68k/graphics/TilePlacement.asm"
    include "disasm/modules/68k/game/GameCmd16.asm"
    include "disasm/modules/68k/memory/CopyBytesToWords.asm"
    include "disasm/modules/68k/memory/CopyAlternateBytes.asm"
    include "disasm/modules/68k/math/MulDiv.asm"
    include "disasm/modules/68k/text/ToUpperCase.asm"

    include "disasm/modules/68k/game/SetupPointerRegs.asm"


    include "disasm/modules/68k/text/StringAppend.asm"

    include "disasm/modules/68k/game/SearchTable.asm"

    include "disasm/modules/68k/input/ReadInput.asm"

    include "disasm/modules/68k/game/IterateCollection.asm"
    include "disasm/modules/68k/math/WeightedAverage.asm"
    include "disasm/modules/68k/text/StringConcat.asm"

    include "disasm/modules/68k/game/GameUpdate3.asm"

    include "disasm/modules/68k/util/ValidateRange.asm"

    include "disasm/modules/68k/math/ClampValue.asm"

    include "disasm/modules/68k/math/CompareElements.asm"

    include "disasm/modules/68k/game/CalcRouteEarningsScore.asm"

    include "disasm/modules/68k/game/FilterCollection.asm"

    include "disasm/modules/68k/game/GetPlayerInput.asm"

    include "disasm/modules/68k/game/ProcessInputEvent.asm"

    include "disasm/modules/68k/input/MapInputToAction.asm"

    include "disasm/modules/68k/input/ValidateInputState.asm"

    include "disasm/modules/68k/game/UpdateAnimation.asm"

    include "disasm/modules/68k/graphics/RenderAnimFrame.asm"

    include "disasm/modules/68k/graphics/TransitionEffect.asm"

    include "disasm/modules/68k/display/FadeGraphics.asm"

    include "disasm/modules/68k/game/ManageUIElement.asm"

    include "disasm/modules/68k/graphics/PositionUIControl.asm"

    include "disasm/modules/68k/graphics/ResizeUIPanel.asm"

    include "disasm/modules/68k/game/UpdateUIPalette.asm"



