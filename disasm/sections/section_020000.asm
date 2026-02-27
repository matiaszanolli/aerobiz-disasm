; ===========================================================================
; ROM Data: $020000-$02FFFF
; 65536 bytes (32768 words)
; ===========================================================================

; === Translated block $020000-$0206EE ===
; 5 functions, 1774 bytes

    include "disasm/modules/68k/game/CalcTradeGains.asm"

    include "disasm/modules/68k/game/GetRouteSlotDetails.asm"

    include "disasm/modules/68k/game/CalcSlotValue.asm"

    include "disasm/modules/68k/game/ValidateTradeReq.asm"

    include "disasm/modules/68k/game/PrepareTradeOffer.asm"

    include "disasm/modules/68k/game/UpdateRouteFieldValues.asm"

    include "disasm/modules/68k/game/UpdateGameStateCounters.asm"


    include "disasm/modules/68k/game/ShowGameScreen.asm"

    include "disasm/modules/68k/game/InitializeRouteDisplay.asm"

    include "disasm/modules/68k/graphics/RenderRouteUIElements.asm"

    include "disasm/modules/68k/display/DisplayRouteInfo.asm"

    include "disasm/modules/68k/graphics/RenderQuarterScreenGrid.asm"

    include "disasm/modules/68k/game/InitializeRelationPanel.asm"

    include "disasm/modules/68k/display/DisplayRouteEvent.asm"

    include "disasm/modules/68k/game/GameLogic1.asm"

    include "disasm/modules/68k/game/InitRouteFields.asm"

    include "disasm/modules/68k/game/InitRouteFieldA.asm"

    include "disasm/modules/68k/game/InitRouteFieldB.asm"

    include "disasm/modules/68k/game/InitRouteFieldC.asm"

    include "disasm/modules/68k/game/FinalizeRouteConfig.asm"

    include "disasm/modules/68k/game/InitializeRoutePipeline.asm"

    include "disasm/modules/68k/game/SelectActiveRoute.asm"

    include "disasm/modules/68k/game/ProcessRouteOptionB.asm"

    include "disasm/modules/68k/game/MatchRouteOption.asm"

    include "disasm/modules/68k/game/ProcessRouteOptionC.asm"

    include "disasm/modules/68k/game/ProcessRouteOptionD.asm"

    include "disasm/modules/68k/game/FinalizeCandidateRoutes.asm"

    include "disasm/modules/68k/game/InitRouteFieldA2.asm"

    include "disasm/modules/68k/game/InitRouteFieldB2.asm"

    include "disasm/modules/68k/game/FinalizeRouteSelection.asm"

    include "disasm/modules/68k/game/InitRouteFieldC2.asm"

    include "disasm/modules/68k/game/EvaluateTurnAvailability.asm"

    include "disasm/modules/68k/game/CalculateTurnCapacity.asm"

    include "disasm/modules/68k/game/CheckCharAvailability.asm"

    include "disasm/modules/68k/game/CheckTurnTiming.asm"

    include "disasm/modules/68k/game/ProcessTurnCheckpoint.asm"

    include "disasm/modules/68k/game/ValidateTurnDelay.asm"

    include "disasm/modules/68k/game/CheckEventCondition.asm"

    include "disasm/modules/68k/game/CheckEventMatch.asm"

    include "disasm/modules/68k/util/StubCodeFragment.asm"

    include "disasm/modules/68k/game/ProcessEventState.asm"

    include "disasm/modules/68k/game/CheckRouteEventMatch.asm"

    include "disasm/modules/68k/game/FinalizeRouteEvent.asm"

    include "disasm/modules/68k/game/AggregateCharAvailability.asm"

    include "disasm/modules/68k/game/CalcCharMorale.asm"

    include "disasm/modules/68k/util/LinearByteSearch.asm"

    include "disasm/modules/68k/game/CheckAirRouteAvail.asm"

    include "disasm/modules/68k/game/CalcEventValue.asm"
    include "disasm/modules/68k/game/SetupEventUI.asm"

    include "disasm/modules/68k/game/DispatchRouteEvent.asm"

    include "disasm/modules/68k/game/HandleRouteEventType0.asm"

    include "disasm/modules/68k/game/HandleRouteEventType1.asm"

    include "disasm/modules/68k/game/HandleAirlineRouteEvent.asm"

    include "disasm/modules/68k/game/HandleRouteEventType2.asm"

    include "disasm/modules/68k/game/HandleRouteEventType3.asm"

    include "disasm/modules/68k/graphics/RenderGameUI.asm"

    include "disasm/modules/68k/game/UpdateGameStateS2.asm"


    include "disasm/modules/68k/game/ClassifyEvent.asm"

    include "disasm/modules/68k/game/ProcessTradeS2.asm"

    include "disasm/modules/68k/game/GetCharStatsS2.asm"

    include "disasm/modules/68k/game/GetCharRelationS2.asm"

    include "disasm/modules/68k/game/ExecuteTradeOffer.asm"

    include "disasm/modules/68k/game/FinalizeTrade.asm"

    include "disasm/modules/68k/graphics/RenderScenarioScreen.asm"


    include "disasm/modules/68k/graphics/DrawLabeledBox.asm"
    include "disasm/modules/68k/graphics/ClearListArea.asm"

    include "disasm/modules/68k/game/ProcessScenarioMenu.asm"

    include "disasm/modules/68k/display/DisplayScenarioMenu.asm"

    include "disasm/modules/68k/game/HandleScenarioMenuSelect.asm"

    include "disasm/modules/68k/game/ValidateMenuOption.asm"

    include "disasm/modules/68k/game/InitInfoPanel.asm"
    include "disasm/modules/68k/graphics/ClearInfoPanel.asm"
    include "disasm/modules/68k/graphics/AnimateInfoPanel.asm"

    include "disasm/modules/68k/game/FinalizeScenarioScreen.asm"

    include "disasm/modules/68k/graphics/PlaceItemTiles.asm"
    include "disasm/modules/68k/game/DecompressTilePair.asm"
    include "disasm/modules/68k/game/TogglePageDisplay.asm"
    include "disasm/modules/68k/graphics/AnimateScrollEffect.asm"
    include "disasm/modules/68k/graphics/AnimateScrollWipe.asm"
    include "disasm/modules/68k/game/RunTransitionSteps.asm"
    include "disasm/modules/68k/game/UpdateIfActive.asm"

    include "disasm/modules/68k/game/LookupCharCode.asm"

    include "disasm/modules/68k/game/CompareCharCode.asm"

    include "disasm/modules/68k/game/ValidateCharCode.asm"

    include "disasm/modules/68k/game/RunQuarterScreen.asm"

    include "disasm/modules/68k/game/HandleTextCompression.asm"

    include "disasm/modules/68k/game/DecompressGraphicsData.asm"

    include "disasm/modules/68k/game/UpdateSpriteAnimation.asm"

    include "disasm/modules/68k/graphics/OrchestrateGraphicsPipeline.asm"

    include "disasm/modules/68k/game/InitGraphicsMemory.asm"

    include "disasm/modules/68k/game/InitMainGameS2.asm"

    include "disasm/modules/68k/game/LoadRouteMapDisplay.asm"

    include "disasm/modules/68k/game/UpdateCharOccupancy.asm"

    include "disasm/modules/68k/graphics/RenderPlayerDataDisplay.asm"

    include "disasm/modules/68k/game/HandleRouteSelectionS2.asm"

    include "disasm/modules/68k/display/DisplayPlayerStatsScreen.asm"

    include "disasm/modules/68k/input/WaitForAButtonPress.asm"

    include "disasm/modules/68k/game/GameUpdate4.asm"

    include "disasm/modules/68k/game/CalculatePlayerWealth.asm"

    include "disasm/modules/68k/game/CalcPlayerWealth.asm"
    include "disasm/modules/68k/game/CalcPlayerRankings.asm"

    include "disasm/modules/68k/game/UpdatePlayerStatusDisplay.asm"

    include "disasm/modules/68k/game/InitLeaderboardData.asm"

    include "disasm/modules/68k/graphics/RenderQuarterReport.asm"

    include "disasm/modules/68k/display/DisplayRouteCargoInfo.asm"

    include "disasm/modules/68k/game/ShowRoutePassengers.asm"

    include "disasm/modules/68k/display/DisplayRouteFunds.asm"

    include "disasm/modules/68k/graphics/DrawQuarterResultsScreen.asm"


    include "disasm/modules/68k/game/CountRouteFlags.asm"
    include "disasm/modules/68k/game/ShowGameStatus.asm"

    include "disasm/modules/68k/game/UpdatePlayerHealthBars.asm"

    include "disasm/modules/68k/game/CheckDisplayGameWin.asm"

    include "disasm/modules/68k/display/DisplayPlayerLeaderboard.asm"

    include "disasm/modules/68k/game/ManagePlayerInvoice.asm"

    include "disasm/modules/68k/game/CountActivePlayers.asm"

    include "disasm/modules/68k/game/ProcessCharAnimationsS2.asm"

    include "disasm/modules/68k/game/InitQuarterStart.asm"

    include "disasm/modules/68k/game/BuildRouteLoop.asm"

    include "disasm/modules/68k/game/FinalizeQuarterEnd.asm"

    include "disasm/modules/68k/game/FindRouteSlotByCharState.asm"

    include "disasm/modules/68k/game/ShowRouteSwapDialog.asm"

    include "disasm/modules/68k/game/ManageCharSlotReassignment.asm"

    include "disasm/modules/68k/game/RunSlotCountPicker.asm"

    include "disasm/modules/68k/game/RunEventSequence.asm"

    include "disasm/modules/68k/game/DecrementEventTimers.asm"

    include "disasm/modules/68k/game/PackEventRecord.asm"

    include "disasm/modules/68k/game/WriteEventField.asm"

    include "disasm/modules/68k/game/UnpackEventRecord.asm"

    include "disasm/modules/68k/game/CheckEventConditionS2.asm"

    include "disasm/modules/68k/game/ExecuteEventAction.asm"

    include "disasm/modules/68k/game/ApplyEventEffectS2.asm"

    include "disasm/modules/68k/game/HandleEventConsequence.asm"

    include "disasm/modules/68k/game/GameLogic2.asm"

    include "disasm/modules/68k/game/InitQuarterEvent.asm"

    include "disasm/modules/68k/game/MakeAIDecision.asm"

    include "disasm/modules/68k/game/AnalyzeRouteProfit.asm"

    include "disasm/modules/68k/game/OptimizeCosts.asm"

    include "disasm/modules/68k/game/RunTurnSequence.asm"

    include "disasm/modules/68k/game/ValidateRouteNetwork.asm"

    include "disasm/modules/68k/game/ProcessRouteDisplayS2.asm"

    include "disasm/modules/68k/game/ShowRouteSelectMenu.asm"

    include "disasm/modules/68k/graphics/RenderRouteIndicator.asm"

    include "disasm/modules/68k/input/WaitInputWithTimeout.asm"

    include "disasm/modules/68k/game/RunAITurn.asm"

    include "disasm/modules/68k/game/LoadRouteDataS2.asm"

    include "disasm/modules/68k/game/ProcessCharAnimS2.asm"

    include "disasm/modules/68k/game/UpdateCharStateS2.asm"

    include "disasm/modules/68k/game/HandleCharEventTrigger.asm"

    include "disasm/modules/68k/game/ManageTurnDisplay.asm"

    include "disasm/modules/68k/game/ProcessCharModifier.asm"

    include "disasm/modules/68k/game/HandleCharSelectionS2.asm"

    include "disasm/modules/68k/game/ValidateCharSlot.asm"

    include "disasm/modules/68k/game/ShowCharStatus.asm"

    include "disasm/modules/68k/graphics/RenderStatusScreenS2.asm"

    include "disasm/modules/68k/game/ShowCharDetailS2.asm"

    include "disasm/modules/68k/display/DisplayStationDetail.asm"

    include "disasm/modules/68k/game/ShowFacilityMenu.asm"


    include "disasm/modules/68k/game/ShowAnnualReport.asm"

    include "disasm/modules/68k/game/InitScenarioDisplay.asm"

    include "disasm/modules/68k/game/RunScenarioMenu.asm"

    include "disasm/modules/68k/game/GetAirlineScenarioInfo.asm"

    include "disasm/modules/68k/game/ResetScenarioMenuS2.asm"

    include "disasm/modules/68k/game/ClearAircraftSlot.asm"

    include "disasm/modules/68k/game/CountAircraftType.asm"

    include "disasm/modules/68k/game/UpdateSelectionS2.asm"

    include "disasm/modules/68k/game/RefreshControlState.asm"

    include "disasm/modules/68k/game/InitControllerS2.asm"

    include "disasm/modules/68k/input/ClearControllerS2.asm"

    include "disasm/modules/68k/game/ShowRoutePanel.asm"

    include "disasm/modules/68k/game/ShowCharPanelS2.asm"

    include "disasm/modules/68k/game/CheckCharGroup.asm"

    include "disasm/modules/68k/game/ProcessCrewSalary.asm"

    include "disasm/modules/68k/game/CheckCharSlotFull.asm"

    include "disasm/modules/68k/game/TransferCharacter.asm"

    include "disasm/modules/68k/graphics/RenderCharTransfer.asm"

    include "disasm/modules/68k/graphics/DrawCharStatus.asm"

    include "disasm/modules/68k/game/ManageCharStatsS2.asm"

    include "disasm/modules/68k/game/FinalizeTransfer.asm"

    include "disasm/modules/68k/graphics/DrawCharPanelS2.asm"

    include "disasm/modules/68k/graphics/RenderCharDetails.asm"

    include "disasm/modules/68k/game/SelectCharSlot.asm"

    include "disasm/modules/68k/game/FindAvailableSlot.asm"

    include "disasm/modules/68k/game/AddCharToTeam.asm"

    include "disasm/modules/68k/game/UpdateCharDisplayS2.asm"

    include "disasm/modules/68k/input/ReadCharInput.asm"

    include "disasm/modules/68k/game/HandleCharInteraction.asm"

    include "disasm/modules/68k/game/CheckCharLimit.asm"

    include "disasm/modules/68k/graphics/RefreshCharPanel.asm"

    include "disasm/modules/68k/game/ShowCharInfoPageS2.asm"

    include "disasm/modules/68k/game/ShowCharInfoPage.asm"
    include "disasm/modules/68k/game/CalcCharScore.asm"
    include "disasm/modules/68k/game/FindCharSlotInGroup.asm"

    include "disasm/modules/68k/game/GameUpdate1.asm"

    include "disasm/modules/68k/game/RunManagementMenu.asm"

    include "disasm/modules/68k/game/ShowAllianceScreen.asm"


    include "disasm/modules/68k/game/ShowText.asm"

    include "disasm/modules/68k/game/ProcessGameUpdateS2.asm"

    include "disasm/modules/68k/game/UpdateGameLoopS2.asm"

    include "disasm/modules/68k/game/ProcessGameFrame.asm"

    include "disasm/modules/68k/game/GetCurrentGameMode.asm"



