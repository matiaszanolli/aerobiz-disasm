; ===========================================================================
; ROM Data: $030000-$03FFFF
; 65536 bytes (32768 words)
; ===========================================================================

; === Translated block $030000-$03204A ===
; 10 functions, 8266 bytes

    include "disasm/modules/68k/game/SearchCharInAlliances.asm"

    include "disasm/modules/68k/game/InitAllianceRecords.asm"

    include "disasm/modules/68k/game/ValidateAllianceSlot.asm"

    include "disasm/modules/68k/game/ProcessAllianceChange.asm"

    include "disasm/modules/68k/game/IsAllianceSlotValid.asm"

    include "disasm/modules/68k/game/GetAllianceScore.asm"

    include "disasm/modules/68k/game/ClearAllianceSlot.asm"

    include "disasm/modules/68k/game/ManageAllianceRoster.asm"

    include "disasm/modules/68k/game/RunAIMainLoop.asm"

    include "disasm/modules/68k/game/PostTurnCleanup.asm"

    include "disasm/modules/68k/game/InitAlliancePrefs.asm"

    include "disasm/modules/68k/game/ComputeAllianceScores.asm"

    include "disasm/modules/68k/game/HasPriorityAlliance.asm"

    include "disasm/modules/68k/game/CheckDuplicateAlliance.asm"

    include "disasm/modules/68k/game/CountAllianceMembers.asm"

    include "disasm/modules/68k/game/CalcAllianceDifference.asm"

    include "disasm/modules/68k/game/ValidateCharSlots.asm"

    include "disasm/modules/68k/game/RankCharByScore.asm"

    include "disasm/modules/68k/game/EvaluateNegotiation.asm"

    include "disasm/modules/68k/game/NegotiateContract.asm"

    include "disasm/modules/68k/game/AcquireCharSlot.asm"

    include "disasm/modules/68k/game/DegradeCharSkill.asm"

    include "disasm/modules/68k/game/CalcRecruitmentCost.asm"

    include "disasm/modules/68k/game/TransferCharSlot.asm"

    include "disasm/modules/68k/util/ClearSubstituteFlag.asm"

    include "disasm/modules/68k/game/SetSubstituteFlag.asm"

    include "disasm/modules/68k/game/ReorderMatchSlots.asm"

    include "disasm/modules/68k/game/EvaluateMatchLineup.asm"

    include "disasm/modules/68k/game/FindOpenCharSlot2.asm"

    include "disasm/modules/68k/game/ScanCharRoster.asm"

    include "disasm/modules/68k/game/GetActiveCharCount.asm"

    include "disasm/modules/68k/game/UpdateCharMetrics.asm"

    include "disasm/modules/68k/game/ApplyRelationBonus.asm"

    include "disasm/modules/68k/game/GetCharTypeBonus.asm"

    include "disasm/modules/68k/game/CalcCharCompat.asm"

    include "disasm/modules/68k/game/RebuildMatchSlots.asm"

    include "disasm/modules/68k/game/SelectBestForTeam.asm"

    include "disasm/modules/68k/game/GetCharQuality.asm"

    include "disasm/modules/68k/game/EvaluateCharPool.asm"

    include "disasm/modules/68k/game/CheckCharAvailable.asm"

    include "disasm/modules/68k/game/CalcCharValueAI.asm"

    include "disasm/modules/68k/game/CheckCharPairConflict.asm"

    include "disasm/modules/68k/game/SortCharsByValue.asm"

    include "disasm/modules/68k/game/CountFilledAllianceSlots.asm"

    include "disasm/modules/68k/game/RunMatchTurn.asm"

    include "disasm/modules/68k/game/FindEmptyMatchSlot.asm"

    include "disasm/modules/68k/game/CalcMatchScore.asm"

    include "disasm/modules/68k/game/ProcessMatchResult.asm"

    include "disasm/modules/68k/game/UpdatePlayerRating.asm"

    include "disasm/modules/68k/game/ResetMatchState.asm"

    include "disasm/modules/68k/game/ApplyCharGrowth.asm"

    include "disasm/modules/68k/game/ProcessLevelUp.asm"

    include "disasm/modules/68k/game/CheckLevelUpCond.asm"

    include "disasm/modules/68k/game/IsCharInActiveMatch.asm"

    include "disasm/modules/68k/game/IncrementCharLevel.asm"

    include "disasm/modules/68k/game/ManageCharSkills.asm"

    include "disasm/modules/68k/game/HasSkill.asm"

    include "disasm/modules/68k/game/UnlockSkill.asm"

    include "disasm/modules/68k/game/TrainCharSkill.asm"

    include "disasm/modules/68k/game/ResetSkillProgress.asm"

    include "disasm/modules/68k/game/ApplyCharBonus.asm"

    include "disasm/modules/68k/game/IncrementAffinity.asm"

    include "disasm/modules/68k/game/DecrementAffinity.asm"

    include "disasm/modules/68k/game/CheckAffinityThreshold.asm"

    include "disasm/modules/68k/game/GetAffinityRating.asm"

    include "disasm/modules/68k/game/OfferCharContract.asm"

    include "disasm/modules/68k/game/FindBestCharValue.asm"

    include "disasm/modules/68k/game/ProcessCharJoin.asm"

    include "disasm/modules/68k/game/GetCharStatPtr.asm"

    include "disasm/modules/68k/game/CountCharPairSlots.asm"

    include "disasm/modules/68k/game/IsCharSlotAvailable.asm"

    include "disasm/modules/68k/game/FindNextOpenSkillSlot.asm"

    include "disasm/modules/68k/game/CalcQuarterTurnOffset.asm"

    include "disasm/modules/68k/game/RecruitFromSkillGroups.asm"

    include "disasm/modules/68k/game/FindBestPartnerChar.asm"

    include "disasm/modules/68k/game/LookupCharRecord.asm"

    include "disasm/modules/68k/game/ExecuteCharRecruit.asm"

    include "disasm/modules/68k/game/ProcessRecruitmentGroups.asm"

    include "disasm/modules/68k/game/ApplyStatBonus.asm"

    include "disasm/modules/68k/game/RecalcAllCharStats.asm"

    include "disasm/modules/68k/game/CheckRecruitEligible.asm"

    include "disasm/modules/68k/game/IsCharSlotEmpty.asm"

    include "disasm/modules/68k/game/ValidateCharPool.asm"

    include "disasm/modules/68k/game/GetPlayerCharCount.asm"

    include "disasm/modules/68k/graphics/RenderGameplayScreen.asm"

    include "disasm/modules/68k/game/ClearCharSprites.asm"

    include "disasm/modules/68k/graphics/RenderCharInfoPanel.asm"

    include "disasm/modules/68k/graphics/RenderTeamRoster.asm"

    include "disasm/modules/68k/graphics/RenderMatchResults.asm"


    include "disasm/modules/68k/game/CheckMatchSlots.asm"

    include "disasm/modules/68k/graphics/RenderPlayerInterface.asm"

    include "disasm/modules/68k/game/HandlePlayerMenuInput.asm"

    include "disasm/modules/68k/graphics/RenderGameDialogs.asm"

    include "disasm/modules/68k/game/CheckCharInRoster.asm"

    include "disasm/modules/68k/game/CheckAlliancePermission.asm"

    include "disasm/modules/68k/game/GameLoopExit.asm"

    include "disasm/modules/68k/game/RunWorldMapAnimation.asm"

    include "disasm/modules/68k/game/LoadGraphicLine.asm"

    include "disasm/modules/68k/game/ShowCharPortrait.asm"
    include "disasm/modules/68k/game/LoadGameGraphics.asm"
    include "disasm/modules/68k/game/ResetGameState.asm"
    include "disasm/modules/68k/graphics/ClearTileArea.asm"

    include "disasm/modules/68k/game/ParseDecimalDigit.asm"

    include "disasm/modules/68k/text/IntToDecimalStr.asm"

    include "disasm/modules/68k/text/IntToHexStr.asm"

    include "disasm/modules/68k/math/ClampTextColumnWidths.asm"

    include "disasm/modules/68k/text/ClearTextBuffer.asm"

    include "disasm/modules/68k/game/SetCursorY.asm"
    include "disasm/modules/68k/game/SetCursorX.asm"

    include "disasm/modules/68k/text/SetTextCursorXY.asm"

    include "disasm/modules/68k/game/CountFormatChars.asm"

    include "disasm/modules/68k/graphics/RenderTextLine.asm"

    include "disasm/modules/68k/game/SkipControlChars.asm"

    include "disasm/modules/68k/game/FindCharInSet.asm"

    include "disasm/modules/68k/text/Vsprintf.asm"

    include "disasm/modules/68k/text/PrintfDirect.asm"

    include "disasm/modules/68k/game/InitTextColors.asm"

    include "disasm/modules/68k/sound/ClearSoundBuffer.asm"

    include "disasm/modules/68k/input/DelayFrames.asm"

    include "disasm/modules/68k/display/FadeOutAndWait.asm"

    include "disasm/modules/68k/display/FadeInAndWait.asm"

    include "disasm/modules/68k/game/GameSetup1.asm"

    include "disasm/modules/68k/game/CalcScreenCoord.asm"

    include "disasm/modules/68k/input/WaitForStartButton.asm"

    include "disasm/modules/68k/input/DelayWithInputCheck.asm"

    include "disasm/modules/68k/graphics/RenderColorTileset.asm"

    include "disasm/modules/68k/game/UpdateScrollRegisters.asm"

    include "disasm/modules/68k/game/InitGameScreen.asm"

    include "disasm/modules/68k/game/PlayIntroSequence.asm"

    include "disasm/modules/68k/game/RunIntroLoop.asm"

    include "disasm/modules/68k/game/ShowGameOverScreen.asm"

    include "disasm/modules/68k/game/LoadMapGraphics.asm"

    include "disasm/modules/68k/graphics/RenderEndingCredits.asm"

    include "disasm/modules/68k/graphics/RenderMainMenu.asm"

    include "disasm/modules/68k/game/GameSetup2.asm"

    include "disasm/modules/68k/game/ShowPlayerScreen.asm"

    include "disasm/modules/68k/game/InitStatusScreenGfx.asm"

    include "disasm/modules/68k/graphics/RenderRouteStatus.asm"

    include "disasm/modules/68k/graphics/RenderCharStats.asm"

    include "disasm/modules/68k/vdp/QueueVRAMWriteAddr.asm"

    include "disasm/modules/68k/vdp/QueueVRAMReadAddr.asm"

    include "disasm/modules/68k/graphics/FillRectColor.asm"

    include "disasm/modules/68k/graphics/RenderPlayerStatusUI.asm"

    include "disasm/modules/68k/graphics/RenderDetailedStats.asm"

    include "disasm/modules/68k/game/InitCursorPalette.asm"

    include "disasm/modules/68k/game/ShowPlayerDetailScreen.asm"

    include "disasm/modules/68k/game/ShowAlternatePlayerView.asm"

    include "disasm/modules/68k/graphics/RenderPlayerListUI.asm"

    include "disasm/modules/68k/math/Multiply32_FromPtr.asm"
    include "disasm/modules/68k/math/Multiply32.asm"
    include "disasm/modules/68k/math/SignedDiv_FromPtr.asm"
    include "disasm/modules/68k/math/SignedDiv.asm"
    include "disasm/modules/68k/math/UnsignedDiv_FromPtr.asm"
    include "disasm/modules/68k/math/UnsignedDivide.asm"
    include "disasm/modules/68k/math/UnsignedMod_FromPtr.asm"
    include "disasm/modules/68k/math/UnsignedMod.asm"
    include "disasm/modules/68k/math/SignedMod_FromPtr.asm"
    include "disasm/modules/68k/math/SignedMod.asm"
; ============================================================================
; GameStrings -- Game text string pool (679 strings, ASCII null-terminated)
; printf-style formatting (%s, %d, %$lu). $03E1AC-$041FFF (~15.4 KB)
; ============================================================================
GameStrings:                                            ; $03E1AC
    dc.w    $506C,$6561                                 ; $03E1AC
    dc.w    $7365,$2063,$686F,$6F73,$6520,$616E,$6F74,$6865; $03E1B0
    dc.w    $7220,$6369,$7479,$2E20,$2573,$2069,$7320,$616C; $03E1C0
    dc.w    $7265,$6164,$7920,$7468,$6520,$686F,$6D65,$2062; $03E1D0
    dc.w    $6173,$6520,$6F66,$2061,$6E6F,$7468,$6572,$2063; $03E1E0
    dc.w    $6F6D,$7061,$6E79,$2E00,$5765,$2772,$6520,$7265; $03E1F0
    dc.w    $6164,$7920,$746F,$2062,$6567,$696E,$2E20,$4973; $03E200
    dc.w    $2065,$7665,$7279,$7468,$696E,$6720,$696E,$206F; $03E210
    dc.w    $7264,$6572,$3F00,$4368,$616E,$6765,$2063,$6F6D; $03E220
    dc.w    $7061,$6E79,$206E,$616D,$653F,$00FF,$4973,$2025; $03E230
    dc.w    $7320,$4F4B,$3F00,$2573,$2069,$7320,$746F,$6F20; $03E240
    dc.w    $736D,$616C,$6C20,$746F,$2062,$6520,$7468,$6520; $03E250
    dc.w    $686F,$6D65,$2062,$6173,$6520,$666F,$7220,$6120; $03E260
    dc.w    $636F,$6D70,$616E,$7920,$6173,$2067,$7265,$6174; $03E270
    dc.w    $2061,$7320,$6F75,$7273,$2100,$4368,$6F6F,$7365; $03E280
    dc.w    $2061,$2025,$7320,$666F,$7220,$706C,$6179,$6572; $03E290
    dc.w    $2025,$6427,$7320,$686F,$6D65,$2062,$6173,$652E; $03E2A0
    dc.w    $00FF,$4368,$6F6F,$7365,$2073,$6B69,$6C6C,$206C; $03E2B0
    dc.w    $6576,$656C,$2E00,$00FF,$4368,$6F6F,$7365,$2061; $03E2C0
    dc.w    $2073,$6365,$6E61,$7269,$6F2E,$00FF,$2832,$3030; $03E2D0
    dc.w    $3020,$2D20,$3230,$3230,$2900,$2831,$3938,$3520; $03E2E0
    dc.w    $2D20,$3230,$3035,$2900,$2831,$3937,$3020,$2D20; $03E2F0
    dc.w    $3139,$3930,$2900,$2831,$3935,$3520,$2D20,$3139; $03E300
    dc.w    $3735,$2900,$5375,$7065,$7273,$6F6E,$6963,$2054; $03E310
    dc.w    $7261,$7665,$6C00,$4169,$726C,$696E,$6573,$2043; $03E320
    dc.w    $6F76,$6572,$2074,$6865,$2047,$6C6F,$6265,$00FF; $03E330
    dc.w    $4169,$7220,$5472,$6176,$656C,$2054,$616B,$6573; $03E340
    dc.w    $204F,$6666,$00FF,$5468,$6520,$4461,$776E,$206F; $03E350
    dc.w    $6620,$7468,$6520,$4A65,$7420,$4167,$6500,$5468; $03E360
    dc.w    $6520,$6167,$6520,$6F66,$2063,$6F6E,$7665,$6E74; $03E370
    dc.w    $696F,$6E61,$6C20,$6A65,$7420,$6169,$7220,$7472; $03E380
    dc.w    $6176,$656C,$2068,$6173,$2070,$6173,$7365,$642E; $03E390
    dc.w    $2020,$4E6F,$7720,$7468,$6520,$6F6E,$6C79,$2077; $03E3A0
    dc.w    $6179,$2074,$6F20,$666C,$7920,$6973,$2053,$7570; $03E3B0
    dc.w    $6572,$736F,$6E69,$6321,$00FF,$496E,$6372,$6561; $03E3C0
    dc.w    $7365,$6420,$666C,$7969,$6E67,$2072,$616E,$6765; $03E3D0
    dc.w    $206D,$6561,$6E74,$2074,$6861,$7420,$6D6F,$7374; $03E3E0
    dc.w    $2063,$6974,$6965,$7320,$636F,$756C,$6420,$6265; $03E3F0
    dc.w    $2073,$6572,$7665,$6420,$6279,$206E,$6F6E,$2D73; $03E400
    dc.w    $746F,$7020,$666C,$6967,$6874,$732E,$00FF,$5468; $03E410
    dc.w    $6520,$6E75,$6D62,$6572,$206F,$6620,$666C,$7969; $03E420
    dc.w    $6E67,$2070,$6173,$7365,$6E67,$6572,$7320,$7374; $03E430
    dc.w    $6561,$6469,$6C79,$2063,$6C69,$6D62,$6564,$2061; $03E440
    dc.w    $6E64,$2070,$6C61,$6E65,$7320,$6265,$6361,$6D65; $03E450
    dc.w    $206C,$6172,$6765,$7220,$616E,$6420,$6661,$7374; $03E460
    dc.w    $6572,$2E00,$5175,$6965,$742C,$2063,$6F6D,$666F; $03E470
    dc.w    $7274,$6162,$6C65,$206A,$6574,$2061,$6972,$6372; $03E480
    dc.w    $6166,$7420,$7765,$7265,$2071,$7569,$636B,$2074; $03E490
    dc.w    $6F20,$7265,$706C,$6163,$6520,$7072,$6F70,$2065; $03E4A0
    dc.w    $6E67,$696E,$6520,$706C,$616E,$6573,$2E00,$4237; $03E4B0
    dc.w    $3737,$204D,$4431,$3120,$4133,$3430,$2020,$2E20; $03E4C0
    dc.w    $2E20,$2E20,$00FF,$4D44,$3131,$2042,$3734,$3720; $03E4D0
    dc.w    $4237,$3637,$2041,$3334,$3000,$4237,$3437,$2044; $03E4E0
    dc.w    $4331,$3020,$4C31,$3031,$3120,$4133,$3030,$00FF; $03E4F0
    dc.w    $4237,$3037,$2044,$4338,$2043,$4152,$4156,$454C; $03E500
    dc.w    $4C45,$2042,$3732,$3720,$4237,$3337,$2044,$4339; $03E510
    dc.w    $00FF,$2532,$643A,$2025,$7300,$7468,$6973,$2073; $03E520
    dc.w    $6365,$6E61,$7269,$6F00,$4D61,$6A6F,$7220,$4E65; $03E530
    dc.w    $7720,$4169,$7263,$7261,$6674,$204D,$6F64,$656C; $03E540
    dc.w    $733A,$0A25,$7300,$2573,$00FF,$2573,$00FF,$2573; $03E550
    dc.w    $0A00,$5363,$656E,$6172,$696F,$2025,$3264,$0A00; $03E560
    dc.w    $2532,$643A,$2025,$7300,$486F,$7720,$6D61,$6E79; $03E570
    dc.w    $2070,$656F,$706C,$6520,$7769,$6C6C,$2070,$6C61; $03E580
    dc.w    $793F,$00FF,$5375,$7065,$7273,$6F6E,$6963,$00FF; $03E590
    dc.w    $4A75,$6D62,$6F20,$4A65,$7400,$5475,$7262,$6F00; $03E5A0
    dc.w    $5072,$6F70,$00FF,$476C,$6964,$6572,$00FF,$4C65; $03E5B0
    dc.w    $7665,$6C20,$2564,$00FF,$2573,$00FF,$6369,$7479; $03E5C0
    dc.w    $00FF,$7265,$6769,$6F6E,$00FF,$4C76,$2025,$6400; $03E5D0
    dc.w    $2532,$6400,$5363,$656E,$00FF,$2573,$00FF,$2573; $03E5E0
    dc.w    $00FF,$2573,$00FF,$4375,$7374,$6F6D,$697A,$6520; $03E5F0
    dc.w    $6561,$6368,$2063,$6F6D,$7061,$6E79,$2773,$206E; $03E600
    dc.w    $616D,$653F,$00FF,$6E61,$6D65,$00FF,$636F,$6C6F; $03E610
    dc.w    $7200,$4578,$6974,$00FF,$4368,$616E,$6765,$2077; $03E620
    dc.w    $6869,$6368,$2063,$6F6D,$7061,$6E79,$2773,$2025; $03E630
    dc.w    $733F,$00FF,$5468,$6973,$2063,$6974,$7920,$6973; $03E640
    dc.w    $2069,$6E20,$7468,$6520,$6D69,$6473,$7420,$6F66; $03E650
    dc.w    $2061,$2077,$6172,$2E20,$596F,$7520,$6361,$6E6E; $03E660
    dc.w    $6F74,$2070,$7572,$7375,$6520,$6120,$6275,$7369; $03E670
    dc.w    $6E65,$7373,$2076,$656E,$7475,$7265,$2074,$6865; $03E680
    dc.w    $7265,$2E00,$5765,$2064,$6F20,$6E6F,$7420,$6861; $03E690
    dc.w    $7665,$2061,$6E79,$2062,$7573,$696E,$6573,$7320; $03E6A0
    dc.w    $7665,$6E74,$7572,$6573,$2069,$6E20,$7468,$6973; $03E6B0
    dc.w    $2072,$6567,$696F,$6E2E,$00FF,$5768,$6963,$6820; $03E6C0
    dc.w    $6275,$7369,$6E65,$7373,$2076,$656E,$7475,$7265; $03E6D0
    dc.w    $2077,$696C,$6C20,$796F,$7520,$7365,$6C6C,$3F00; $03E6E0
    dc.w    $5765,$2061,$6C72,$6561,$6479,$206F,$776E,$2074; $03E6F0
    dc.w    $6869,$7320,$2573,$2E00,$4920,$7769,$6C6C,$2062; $03E700
    dc.w    $6567,$696E,$206E,$6567,$6F74,$6961,$7469,$6F6E; $03E710
    dc.w    $7320,$7769,$7468,$2074,$6865,$2063,$6974,$7920; $03E720
    dc.w    $746F,$2070,$7572,$6368,$6173,$6520,$7468,$6520; $03E730
    dc.w    $6275,$7369,$6E65,$7373,$2E00,$596F,$7520,$6D75; $03E740
    dc.w    $7374,$206E,$6567,$6F74,$6961,$7465,$2077,$6974; $03E750
    dc.w    $6820,$7468,$6520,$6369,$7479,$2074,$6F20,$7075; $03E760
    dc.w    $7263,$6861,$7365,$2074,$6869,$7320,$2573,$2E20; $03E770
    dc.w    $4974,$2077,$696C,$6C20,$7461,$6B65,$2033,$206D; $03E780
    dc.w    $6F6E,$7468,$732E,$2049,$7320,$7468,$6973,$204F; $03E790
    dc.w    $4B3F,$00FF,$536F,$7272,$792C,$2077,$6520,$646F; $03E7A0
    dc.w    $6E27,$7420,$6861,$7665,$2065,$6E6F,$7567,$6820; $03E7B0
    dc.w    $6D6F,$6E65,$792E,$00FF,$5468,$6973,$2025,$7320; $03E7C0
    dc.w    $6973,$2061,$6C72,$6561,$6479,$206F,$776E,$6564; $03E7D0
    dc.w    $2062,$7920,$2573,$2E00,$5768,$6963,$6820,$6275; $03E7E0
    dc.w    $7369,$6E65,$7373,$2076,$656E,$7475,$7265,$2077; $03E7F0
    dc.w    $696C,$6C20,$796F,$7520,$7075,$7263,$6861,$7365; $03E800
    dc.w    $3F00,$4F6E,$6C79,$2062,$7573,$696E,$6573,$7320; $03E810
    dc.w    $7665,$6E74,$7572,$6573,$2069,$6E20,$636F,$6E6E; $03E820
    dc.w    $6563,$7469,$6E67,$2063,$6974,$6965,$7320,$6361; $03E830
    dc.w    $6E20,$6265,$2070,$7572,$6368,$6173,$6564,$2E00; $03E840
    dc.w    $496E,$2077,$6869,$6368,$2063,$6974,$7920,$7368; $03E850
    dc.w    $616C,$6C20,$7765,$2062,$6964,$2066,$6F72,$2061; $03E860
    dc.w    $2062,$7573,$696E,$6573,$7320,$7665,$6E74,$7572; $03E870
    dc.w    $653F,$00FF,$5768,$6174,$2072,$6567,$696F,$6E20; $03E880
    dc.w    $646F,$2079,$6F75,$2077,$616E,$7420,$6265,$2074; $03E890
    dc.w    $6F20,$6D6F,$7665,$2069,$6E74,$6F3F,$00FF,$5768; $03E8A0
    dc.w    $6174,$2063,$616E,$2049,$2064,$6F20,$666F,$7220; $03E8B0
    dc.w    $796F,$753F,$00FF,$2524,$386C,$6400,$2573,$00FF; $03E8C0
    dc.w    $2524,$366C,$7500,$2573,$00FF,$2573,$00FF,$5661; $03E8D0
    dc.w    $6C75,$6500,$4275,$7369,$6E65,$7373,$00FF,$4369; $03E8E0
    dc.w    $7479,$00FF,$5661,$6C75,$6520,$2524,$3130,$6C75; $03E8F0
    dc.w    $00FF,$436F,$7374,$2025,$2431,$316C,$7500,$5072; $03E900
    dc.w    $6F66,$6974,$2025,$2439,$6400,$4578,$7065,$6E73; $03E910
    dc.w    $6573,$2025,$2437,$6C75,$00FF,$5361,$6C65,$7320; $03E920
    dc.w    $2025,$2439,$6C75,$00FF,$2573,$00FF,$2573,$00FF; $03E930
    dc.w    $5468,$6973,$2071,$7561,$7274,$6572,$2074,$6865; $03E940
    dc.w    $2025,$7320,$6861,$7320,$6265,$656E,$2075,$6E70; $03E950
    dc.w    $726F,$6669,$7461,$626C,$652E,$2044,$6F20,$796F; $03E960
    dc.w    $7520,$7761,$6E74,$2074,$6F20,$7365,$6C6C,$3F00; $03E970
    dc.w    $5468,$6973,$2071,$7561,$7274,$6572,$2062,$7573; $03E980
    dc.w    $696E,$6573,$7320,$6861,$7320,$6265,$656E,$2067; $03E990
    dc.w    $6F6F,$6420,$666F,$7220,$7468,$6520,$2573,$2E20; $03E9A0
    dc.w    $446F,$2079,$6F75,$2072,$6561,$6C6C,$7920,$7761; $03E9B0
    dc.w    $6E74,$2074,$6F20,$7365,$6C6C,$3F00,$4966,$2079; $03E9C0
    dc.w    $6F75,$2073,$656C,$6C20,$6974,$206E,$6F77,$2079; $03E9D0
    dc.w    $6F75,$7220,$6164,$2063,$616D,$7061,$6967,$6E20; $03E9E0
    dc.w    $7769,$6C6C,$2062,$6520,$7761,$7374,$6564,$2E20; $03E9F0
    dc.w    $5365,$6C6C,$2061,$6E79,$7761,$793F,$00FF,$2533; $03EA00
    dc.w    $7300,$2534,$6400,$2531,$6400,$6C76,$00FF,$2531; $03EA10
    dc.w    $6400,$7363,$00FF,$252D,$3973,$00FF,$2533,$7300; $03EA20
    dc.w    $252D,$3773,$00FF,$4E6F,$2053,$6176,$6564,$2047; $03EA30
    dc.w    $616D,$6500,$2533,$7300,$2534,$6400,$2531,$6400; $03EA40
    dc.w    $6C76,$00FF,$2531,$6400,$7363,$00FF,$252D,$3973; $03EA50
    dc.w    $00FF,$2533,$7300,$252D,$3773,$00FF,$4E6F,$2053; $03EA60
    dc.w    $6176,$6564,$2047,$616D,$6500,$596F,$7520,$616C; $03EA70
    dc.w    $7265,$6164,$7920,$6861,$7665,$2061,$2072,$6567; $03EA80
    dc.w    $696F,$6E61,$6C20,$6875,$6220,$696E,$2025,$732E; $03EA90
    dc.w    $00FF,$4927,$6C6C,$2067,$6574,$2072,$6967,$6874; $03EAA0
    dc.w    $206F,$6E20,$6974,$2E00,$536F,$7272,$792C,$2077; $03EAB0
    dc.w    $6520,$6361,$6E27,$7420,$6F70,$656E,$2061,$2072; $03EAC0
    dc.w    $6567,$696F,$6E61,$6C20,$6875,$6220,$6265,$6361; $03EAD0
    dc.w    $7573,$6520,$6F66,$2074,$6865,$2077,$6172,$2E00; $03EAE0
    dc.w    $5368,$616C,$6C20,$7765,$206F,$7065,$6E20,$6120; $03EAF0
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2069,$6E20; $03EB00
    dc.w    $2573,$3F00,$536F,$7272,$792C,$2077,$6520,$646F; $03EB10
    dc.w    $6E27,$7420,$6861,$7665,$2065,$6E6F,$7567,$6820; $03EB20
    dc.w    $6D6F,$6E65,$7920,$746F,$206F,$7065,$6E20,$6120; $03EB30
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2E00,$6120; $03EB40
    dc.w    $666C,$6967,$6874,$2067,$6F69,$6E67,$2074,$6F20; $03EB50
    dc.w    $2573,$2E00,$496E,$2074,$6869,$7320,$7265,$6769; $03EB60
    dc.w    $6F6E,$2077,$6520,$6861,$7665,$2000,$2524,$3564; $03EB70
    dc.w    $00FF,$436F,$6E73,$7472,$7563,$7469,$6F6E,$2043; $03EB80
    dc.w    $6F73,$7473,$00FF,$2524,$3564,$00FF,$4D61,$696E; $03EB90
    dc.w    $7465,$6E61,$6E63,$6520,$4578,$7065,$6E73,$6500; $03EBA0
    dc.w    $2573,$00FF,$4875,$6220,$5365,$742D,$7570,$00FF; $03EBB0
    dc.w    $5765,$2063,$616E,$2774,$206F,$7065,$6E20,$6120; $03EBC0
    dc.w    $7265,$6769,$6F6E,$616C,$2068,$7562,$2069,$6E20; $03EBD0
    dc.w    $2573,$2E20,$5765,$2064,$6F6E,$2774,$2068,$6176; $03EBE0
    dc.w    $6520,$616E,$7920,$666C,$6967,$6874,$7320,$676F; $03EBF0
    dc.w    $696E,$6720,$7468,$6572,$6520,$7965,$742E,$00FF; $03EC00
    dc.w    $4F75,$7220,$686F,$6D65,$2062,$6173,$6520,$6973; $03EC10
    dc.w    $2068,$6572,$6520,$696E,$2025,$732E,$2057,$6520; $03EC20
    dc.w    $646F,$6E27,$7420,$6E65,$6564,$2061,$2072,$6567; $03EC30
    dc.w    $696F,$6E61,$6C20,$6875,$622E,$00FF,$496E,$2025; $03EC40
    dc.w    $732C,$2070,$7265,$7061,$7261,$7469,$6F6E,$7320; $03EC50
    dc.w    $666F,$7220,$6120,$7265,$6769,$6F6E,$616C,$2068; $03EC60
    dc.w    $7562,$2061,$7265,$2061,$6C72,$6561,$6479,$2075; $03EC70
    dc.w    $6E64,$6572,$7761,$7920,$696E,$2025,$732E,$00FF; $03EC80
    dc.w    $4172,$6520,$796F,$7520,$7375,$7265,$2079,$6F75; $03EC90
    dc.w    $2077,$616E,$7420,$746F,$2063,$6C6F,$7365,$2074; $03ECA0
    dc.w    $6865,$2072,$6567,$696F,$6E61,$6C20,$6875,$6220; $03ECB0
    dc.w    $696E,$2025,$733F,$00FF,$5765,$2064,$6F20,$6E6F; $03ECC0
    dc.w    $7420,$6861,$7665,$2061,$2072,$6567,$696F,$6E61; $03ECD0
    dc.w    $6C20,$6875,$6220,$696E,$2025,$732E,$00FF,$4164; $03ECE0
    dc.w    $2043,$616D,$7061,$6967,$6E00,$4275,$7369,$6E65; $03ECF0
    dc.w    $7373,$2050,$7572,$6368,$6173,$6500,$00FF,$4875; $03ED00
    dc.w    $6220,$5365,$7475,$7000,$00FF,$4169,$7270,$6F72; $03ED10
    dc.w    $7420,$536C,$6F74,$7300,$776F,$726B,$696E,$6720; $03ED20
    dc.w    $6F6E,$2061,$6E20,$6164,$7665,$7274,$6973,$696E; $03ED30
    dc.w    $6720,$6361,$6D70,$6169,$676E,$2E00,$6E65,$676F; $03ED40
    dc.w    $7469,$6174,$696E,$6720,$666F,$7220,$6120,$6275; $03ED50
    dc.w    $7369,$6E65,$7373,$2076,$656E,$7475,$7265,$2E00; $03ED60
    dc.w    $00FF,$6F76,$6572,$7365,$6569,$6E67,$2063,$6F6E; $03ED70
    dc.w    $7374,$7275,$6374,$696F,$6E20,$6F66,$2061,$2072; $03ED80
    dc.w    $6567,$696F,$6E61,$6C20,$6875,$622E,$0000,$6D61; $03ED90
    dc.w    $6B69,$6E67,$2061,$2062,$6964,$2066,$6F72,$2073; $03EDA0
    dc.w    $6F6D,$6520,$6169,$7270,$6F72,$7420,$736C,$6F74; $03EDB0
    dc.w    $732E,$00FF,$5361,$6E74,$6961,$676F,$00FF,$4275; $03EDC0
    dc.w    $656E,$6F73,$2041,$6972,$6573,$00FF,$4C69,$6D61; $03EDD0
    dc.w    $00FF,$4B69,$6E67,$7374,$6F6E,$00FF,$5269,$6F20; $03EDE0
    dc.w    $6465,$204A,$616E,$6569,$726F,$00FF,$486F,$6E6F; $03EDF0
    dc.w    $6C75,$6C75,$00FF,$546F,$726F,$6E74,$6F00,$4D69; $03EE00
    dc.w    $616D,$6900,$486F,$7573,$746F,$6E00,$5068,$696C; $03EE10
    dc.w    $612D,$2064,$656C,$7068,$6961,$00FF,$5068,$6F65; $03EE20
    dc.w    $6E69,$7800,$4465,$6E76,$6572,$00FF,$5365,$6174; $03EE30
    dc.w    $746C,$6500,$5361,$6E20,$4672,$616E,$2063,$6973; $03EE40
    dc.w    $636F,$00FF,$5061,$7065,$6574,$6500,$4E6F,$756D; $03EE50
    dc.w    $6561,$00FF,$4E61,$6469,$00FF,$4164,$656C,$6169; $03EE60
    dc.w    $6465,$00FF,$4D65,$6C2D,$2062,$6F75,$726E,$6500; $03EE70
    dc.w    $4272,$6973,$6261,$6E65,$00FF,$4B68,$6162,$2D20; $03EE80
    dc.w    $6172,$6F76,$736B,$00FF,$5361,$6970,$616E,$00FF; $03EE90
    dc.w    $4775,$616D,$00FF,$4365,$6275,$00FF,$4B75,$616C; $03EEA0
    dc.w    $6120,$4C75,$6D70,$7572,$00FF,$5461,$6970,$6569; $03EEB0
    dc.w    $00FF,$5368,$616E,$6768,$6169,$00FF,$4675,$6B75; $03EEC0
    dc.w    $6F6B,$6100,$5361,$7070,$6F72,$6F00,$4F73,$616B; $03EED0
    dc.w    $6100,$5461,$7368,$6B65,$6E74,$00FF,$426F,$6D62; $03EEE0
    dc.w    $6179,$00FF,$4361,$6C63,$7574,$7461,$00FF,$4B61; $03EEF0
    dc.w    $7261,$6368,$6900,$4973,$6C61,$6D61,$2D20,$6261; $03EF00
    dc.w    $6400,$5472,$6970,$6F6C,$6900,$4164,$6469,$7320; $03EF10
    dc.w    $4162,$6162,$6100,$4E61,$6972,$6F62,$6900,$4C61; $03EF20
    dc.w    $676F,$7300,$416C,$6769,$6572,$7300,$4D69,$6E73; $03EF30
    dc.w    $6B00,$4B69,$6576,$00FF,$526F,$7374,$6F76,$00FF; $03EF40
    dc.w    $5669,$656E,$6E61,$00FF,$4F73,$6C6F,$00FF,$5374; $03EF50
    dc.w    $6F63,$6B2D,$2068,$6F6C,$6D00,$4865,$6C73,$696E; $03EF60
    dc.w    $6B69,$00FF,$4261,$7263,$652D,$206C,$6F6E,$6100; $03EF70
    dc.w    $4D61,$6472,$6964,$00FF,$5A75,$7269,$6368,$00FF; $03EF80
    dc.w    $4174,$6865,$6E73,$00FF,$436F,$7065,$6E2D,$2068; $03EF90
    dc.w    $6167,$656E,$00FF,$4D69,$6C61,$6E00,$4272,$7573; $03EFA0
    dc.w    $7365,$6C73,$00FF,$4D75,$6E69,$6368,$00FF,$4E69; $03EFB0
    dc.w    $6365,$00FF,$4D61,$6E2D,$2063,$6865,$7374,$6572; $03EFC0
    dc.w    $00FF,$4861,$7661,$6E61,$00FF,$5361,$6F20,$5061; $03EFD0
    dc.w    $756C,$6F00,$4D65,$7869,$636F,$2043,$6974,$7900; $03EFE0
    dc.w    $5661,$6E2D,$2063,$6F75,$7665,$7200,$4174,$6C61; $03EFF0
    dc.w    $6E74,$6100,$4461,$6C6C,$6173,$00FF,$4C6F,$7320; $03F000
    dc.w    $416E,$6765,$6C65,$7300,$4368,$6963,$6167,$6F00; $03F010
    dc.w    $4E65,$7720,$596F,$726B,$00FF,$5761,$7368,$696E; $03F020
    dc.w    $672D,$2074,$6F6E,$00FF,$4175,$636B,$6C61,$6E64; $03F030
    dc.w    $00FF,$5065,$7274,$6800,$5379,$646E,$6579,$00FF; $03F040
    dc.w    $4D61,$6E69,$6C61,$00FF,$4261,$6E67,$6B6F,$6B00; $03F050
    dc.w    $5369,$6E67,$2D20,$6170,$6F72,$6500,$486F,$6E67; $03F060
    dc.w    $204B,$6F6E,$6700,$5365,$6F75,$6C00,$4265,$696A; $03F070
    dc.w    $696E,$6700,$546F,$6B79,$6F00,$4E65,$7720,$4465; $03F080
    dc.w    $6C68,$6900,$4261,$6768,$6461,$6400,$5465,$6872; $03F090
    dc.w    $616E,$00FF,$5475,$6E69,$7300,$4361,$6972,$6F00; $03F0A0
    dc.w    $4D6F,$7363,$6F77,$00FF,$4265,$726C,$696E,$00FF; $03F0B0
    dc.w    $526F,$6D65,$00FF,$416D,$7374,$6572,$2D20,$6461; $03F0C0
    dc.w    $6D00,$4672,$616E,$6B2D,$2066,$7572,$7400,$5061; $03F0D0
    dc.w    $7269,$7300,$4C6F,$6E64,$6F6E,$00FF,$6F76,$6572; $03F0E0
    dc.w    $206F,$6E65,$2079,$6561,$7200,$2532,$6420,$6D6F; $03F0F0
    dc.w    $6E74,$6873,$00FF,$2573,$00FF,$4D69,$6464,$6C65; $03F100
    dc.w    $2045,$6173,$7400,$5345,$2041,$7369,$6100,$536F; $03F110
    dc.w    $7272,$792C,$2049,$276D,$2062,$7573,$7920,$2573; $03F120
    dc.w    $00FF,$5768,$6F20,$7769,$6C6C,$2079,$6F75,$2073; $03F130
    dc.w    $656E,$6420,$746F,$2000,$636F,$6E64,$7563,$7420; $03F140
    dc.w    $616E,$2061,$6420,$6361,$6D70,$6169,$676E,$3F00; $03F150
    dc.w    $6368,$6563,$6B20,$6F75,$7420,$6275,$7369,$6E65; $03F160
    dc.w    $7373,$2070,$6F73,$7369,$6269,$6C69,$7469,$6573; $03F170
    dc.w    $3F00,$6E65,$676F,$7469,$6174,$6520,$666F,$7220; $03F180
    dc.w    $6120,$7265,$6769,$6F6E,$616C,$2068,$7562,$3F00; $03F190
    dc.w    $6269,$6420,$666F,$7220,$736C,$6F74,$733F,$00FF; $03F1A0
    dc.w    $2000,$2524,$396C,$6400,$4172,$6520,$796F,$7520; $03F1B0
    dc.w    $7375,$7265,$2079,$6F75,$2077,$616E,$7420,$746F; $03F1C0
    dc.w    $2063,$6C6F,$7365,$3F00,$2573,$2077,$696C,$6C20; $03F1D0
    dc.w    $6265,$2063,$6C6F,$7365,$642E,$00FF,$2573,$2061; $03F1E0
    dc.w    $6E64,$2025,$7300,$2564,$2072,$6F75,$7465,$7300; $03F1F0
    dc.w    $2564,$2072,$6567,$696F,$6E61,$6C20,$6875,$6273; $03F200
    dc.w    $00FF,$5468,$6520,$726F,$7574,$6520,$7761,$7320; $03F210
    dc.w    $636C,$6F73,$6564,$2E00,$2573,$00FF,$2573,$00FF; $03F220
    dc.w    $3120,$726F,$7574,$6500,$3120,$7265,$6769,$6F6E; $03F230
    dc.w    $616C,$2068,$7562,$00FF,$2573,$00FF,$2573,$00FF; $03F240
    dc.w    $3120,$726F,$7574,$6500,$3120,$7265,$6769,$6F6E; $03F250
    dc.w    $616C,$2068,$7562,$00FF,$416C,$6C20,$666C,$6967; $03F260
    dc.w    $6874,$7320,$6C69,$7374,$6564,$2061,$626F,$7665; $03F270
    dc.w    $2077,$696C,$6C20,$6265,$2063,$6C6F,$7365,$642E; $03F280
    dc.w    $00FF,$5765,$2063,$616E,$2774,$2061,$6666,$6F72; $03F290
    dc.w    $6420,$746F,$2072,$756E,$2074,$6861,$7420,$6361; $03F2A0
    dc.w    $6D70,$6169,$676E,$2072,$6967,$6874,$206E,$6F77; $03F2B0
    dc.w    $2E00,$5765,$2772,$6520,$696E,$2074,$6865,$206D; $03F2C0
    dc.w    $6964,$646C,$6520,$6F66,$2061,$2077,$6172,$2120; $03F2D0
    dc.w    $5765,$2063,$616E,$2774,$2063,$6F6E,$6475,$6374; $03F2E0
    dc.w    $2061,$2063,$616D,$7061,$6967,$6E20,$6E6F,$7721; $03F2F0
    dc.w    $00FF,$4927,$6C6C,$2067,$6574,$2072,$6967,$6874; $03F300
    dc.w    $206F,$6E20,$6974,$2E00,$486F,$7720,$6D75,$6368; $03F310
    dc.w    $2077,$696C,$6C20,$796F,$7520,$7370,$656E,$6420; $03F320
    dc.w    $6F6E,$2074,$6865,$2063,$616D,$7061,$6967,$6E3F; $03F330
    dc.w    $00FF,$5468,$6572,$6520,$6172,$6520,$6E6F,$2062; $03F340
    dc.w    $7573,$696E,$6573,$7365,$7320,$696E,$206F,$7572; $03F350
    dc.w    $2025,$7320,$6E65,$7477,$6F72,$6B20,$746F,$2070; $03F360
    dc.w    $726F,$6D6F,$7465,$2E00,$5768,$6174,$206B,$696E; $03F370
    dc.w    $6420,$6F66,$2063,$616D,$7061,$6967,$6E20,$776F; $03F380
    dc.w    $756C,$6420,$796F,$7520,$6C69,$6B65,$2074,$6F20; $03F390
    dc.w    $7275,$6E3F,$00FF,$5765,$2064,$6F6E,$2774,$206F; $03F3A0
    dc.w    $776E,$2061,$6E79,$2025,$7320,$6275,$7369,$6E65; $03F3B0
    dc.w    $7373,$6573,$2120,$486F,$7720,$6361,$6E20,$7765; $03F3C0
    dc.w    $2072,$756E,$2061,$2063,$616D,$7061,$6967,$6E3F; $03F3D0
    dc.w    $00FF,$4172,$6520,$796F,$7520,$7375,$7265,$2079; $03F3E0
    dc.w    $6F75,$2077,$616E,$7420,$746F,$2072,$756E,$2074; $03F3F0
    dc.w    $6869,$7320,$2573,$2063,$616D,$7061,$6967,$6E3F; $03F400
    dc.w    $00FF,$4C65,$6973,$7572,$652F,$5370,$6F72,$7473; $03F410
    dc.w    $00FF,$5472,$6176,$656C,$204E,$6574,$776F,$726B; $03F420
    dc.w    $00FF,$4375,$6C74,$7572,$6520,$616E,$6420,$4172; $03F430
    dc.w    $7473,$00FF,$5269,$6768,$7420,$6E6F,$7720,$7765; $03F440
    dc.w    $2772,$6520,$7275,$6E6E,$696E,$6720,$6120,$2573; $03F450
    dc.w    $2063,$616D,$7061,$6967,$6E2E,$00FF,$5765,$2063; $03F460
    dc.w    $616E,$2774,$2072,$756E,$2061,$6E20,$6164,$2063; $03F470
    dc.w    $616D,$7061,$6967,$6E20,$696E,$2025,$732E,$2057; $03F480
    dc.w    $6520,$646F,$6E27,$7420,$6861,$7665,$2061,$6E79; $03F490
    dc.w    $2072,$6F75,$7465,$7320,$696E,$2074,$6861,$7420; $03F4A0
    dc.w    $7265,$6769,$6F6E,$2E00,$5665,$7279,$2068,$6967; $03F4B0
    dc.w    $6800,$4869,$6768,$00FF,$4176,$6572,$6167,$6500; $03F4C0
    dc.w    $536C,$696D,$00FF,$5665,$7279,$2073,$6C69,$6D00; $03F4D0
    dc.w    $5765,$2077,$696C,$6C20,$7072,$6F6D,$6F74,$6520; $03F4E0
    dc.w    $6563,$6F6E,$6F6D,$6963,$616C,$2074,$6F75,$7273; $03F4F0
    dc.w    $2061,$7420,$6F75,$7220,$7370,$6F72,$7473,$2061; $03F500
    dc.w    $6E64,$2061,$6D75,$7365,$6D65,$6E74,$2066,$6163; $03F510
    dc.w    $696C,$6974,$6965,$732E,$00FF,$5765,$2077,$696C; $03F520
    dc.w    $6C20,$6869,$6768,$6C69,$6768,$7420,$7468,$6520; $03F530
    dc.w    $636F,$6E76,$656E,$6965,$6E63,$6520,$6F66,$206F; $03F540
    dc.w    $7572,$2074,$7261,$7665,$6C20,$7365,$7276,$6963; $03F550
    dc.w    $6573,$2061,$6E64,$206F,$6666,$6572,$2075,$7067; $03F560
    dc.w    $7261,$6465,$6420,$6361,$7465,$7269,$6E67,$2E00; $03F570
    dc.w    $5765,$2077,$696C,$6C20,$7370,$6F6E,$736F,$7220; $03F580
    dc.w    $6375,$6C74,$7572,$616C,$2065,$7665,$6E74,$7320; $03F590
    dc.w    $6174,$206F,$7572,$2066,$6163,$696C,$6974,$6965; $03F5A0
    dc.w    $732E,$00FF,$4E6F,$7420,$506F,$7373,$6962,$6C65; $03F5B0
    dc.w    $00FF,$4F6E,$676F,$696E,$6700,$5365,$7474,$696E; $03F5C0
    dc.w    $6720,$7570,$00FF,$2524,$3564,$00FF,$4578,$7065; $03F5D0
    dc.w    $6E73,$652F,$5374,$6174,$7573,$00FF,$5479,$7065; $03F5E0
    dc.w    $00FF,$2524,$356C,$6400,$4368,$616E,$6365,$2066; $03F5F0
    dc.w    $6F72,$2053,$7563,$6365,$7373,$3A00,$5072,$6F6D; $03F600
    dc.w    $6F74,$696F,$6E20,$4578,$7065,$6E73,$6500,$2524; $03F610
    dc.w    $356C,$6400,$5374,$616E,$6461,$7264,$2045,$7870; $03F620
    dc.w    $656E,$7365,$00FF,$4368,$616E,$6365,$2066,$6F72; $03F630
    dc.w    $2053,$7563,$6365,$7373,$3A00,$5072,$6F6D,$6F74; $03F640
    dc.w    $696F,$6E20,$4578,$7065,$6E73,$6500,$2524,$356C; $03F650
    dc.w    $6400,$5374,$616E,$6461,$7264,$2045,$7870,$656E; $03F660
    dc.w    $7365,$00FF,$7825,$6400,$4973,$2074,$6869,$7320; $03F670
    dc.w    $636F,$7272,$6563,$743F,$00FF,$5768,$6174,$2066; $03F680
    dc.w    $6172,$6520,$7769,$6C6C,$2079,$6F75,$2073,$6574; $03F690
    dc.w    $3F00,$486F,$7720,$6D61,$6E79,$2066,$6C69,$6768; $03F6A0
    dc.w    $7473,$2070,$6572,$2077,$6565,$6B3F,$00FF,$486F; $03F6B0
    dc.w    $7720,$6D61,$6E79,$2070,$6C61,$6E65,$7320,$7769; $03F6C0
    dc.w    $6C6C,$2066,$6C79,$206F,$6E20,$7468,$6520,$726F; $03F6D0
    dc.w    $7574,$653F,$00FF,$5768,$6963,$6820,$6169,$7263; $03F6E0
    dc.w    $7261,$6674,$2077,$696C,$6C20,$796F,$7520,$7573; $03F6F0
    dc.w    $6520,$6F6E,$2074,$6865,$2072,$6F75,$7465,$3F00; $03F700
    dc.w    $4F4B,$3F00,$5365,$6C65,$6374,$2064,$6573,$7469; $03F710
    dc.w    $6E61,$7469,$6F6E,$2E00,$5365,$6C65,$6374,$2072; $03F720
    dc.w    $6567,$696F,$6E20,$666F,$7220,$6465,$7374,$696E; $03F730
    dc.w    $6174,$696F,$6E2E,$0000,$4973,$2069,$7420,$4F4B; $03F740
    dc.w    $2074,$6F20,$6368,$616E,$6765,$2074,$6869,$7320; $03F750
    dc.w    $666C,$6967,$6874,$2061,$7320,$7368,$6F77,$6E3F; $03F760
    dc.w    $00FF,$5765,$2064,$6F6E,$2774,$2068,$6176,$6520; $03F770
    dc.w    $616E,$7920,$726F,$7574,$6573,$2066,$6C79,$696E; $03F780
    dc.w    $6720,$696E,$746F,$2074,$6869,$7320,$7265,$6769; $03F790
    dc.w    $6F6E,$2E00,$2534,$6400,$2532,$6400,$2532,$6400; $03F7A0
    dc.w    $2573,$0D00,$5075,$7368,$2053,$5441,$5254,$2074; $03F7B0
    dc.w    $6F20,$7669,$6577,$2074,$6865,$2063,$6F6D,$7065; $03F7C0
    dc.w    $7469,$7469,$6F6E,$2E00,$5075,$7368,$2053,$5441; $03F7D0
    dc.w    $5254,$2074,$6F20,$7669,$6577,$2074,$6865,$2063; $03F7E0
    dc.w    $6F6D,$7065,$7469,$7469,$6F6E,$2E00,$4974,$2077; $03F7F0
    dc.w    $6F75,$6C64,$2062,$6520,$6469,$6666,$6963,$756C; $03F800
    dc.w    $7420,$746F,$2063,$6861,$6E67,$6520,$6120,$726F; $03F810
    dc.w    $7574,$6520,$7468,$6174,$2064,$6F65,$736E,$2774; $03F820
    dc.w    $2065,$7869,$7374,$2E00,$2A25,$6400,$2532,$6400; $03F830
    dc.w    $2532,$6400,$2A25,$6400,$2533,$6400,$2533,$6400; $03F840
    dc.w    $2A25,$6400,$2532,$6400,$2532,$6400,$2533,$6400; $03F850
    dc.w    $2533,$6400,$2532,$6400,$2532,$6400,$2533,$6400; $03F860
    dc.w    $2533,$6400,$2534,$6425,$2500,$2524,$2434,$6400; $03F870
    dc.w    $2534,$6425,$2500,$2524,$2434,$6400,$6176,$6572; $03F880
    dc.w    $6167,$6520,$6661,$7265,$2020,$00FF,$2532,$6425; $03F890
    dc.w    $2520,$6162,$6F76,$6520,$6176,$672E,$00FF,$2532; $03F8A0
    dc.w    $6425,$2520,$6265,$6C6F,$7720,$6176,$672E,$00FF; $03F8B0
    dc.w    $0000,$00FF,$5346,$5800,$4247,$4D00,$456E,$6420; $03F8C0
    dc.w    $4761,$6D65,$00FF,$4D65,$7373,$6167,$6500,$536F; $03F8D0
    dc.w    $756E,$6400,$416E,$696D,$6174,$696F,$6E00,$5361; $03F8E0
    dc.w    $7665,$00FF,$4247,$4D00,$5346,$5800,$4F6E,$2000; $03F8F0
    dc.w    $4F66,$6600,$5374,$6572,$656F,$00FF,$4D6F,$6E6F; $03F900
    dc.w    $00FF,$536C,$6F77,$00FF,$4D65,$6469,$756D,$00FF; $03F910
    dc.w    $4661,$7374,$00FF,$5365,$6520,$686F,$7720,$6974; $03F920
    dc.w    $2065,$6E64,$7320,$7570,$3F00,$456E,$6420,$6761; $03F930
    dc.w    $6D65,$3F00,$2573,$00FF,$2573,$00FF,$2573,$0A00; $03F940
    dc.w    $5361,$7665,$2063,$6F6D,$706C,$6574,$6564,$2E00; $03F950
    dc.w    $4D65,$7373,$6167,$6573,$2061,$7265,$2063,$7572; $03F960
    dc.w    $7265,$6E74,$6C79,$2062,$6569,$6E67,$2064,$6973; $03F970
    dc.w    $706C,$6179,$6564,$2061,$7420,$2573,$2073,$7065; $03F980
    dc.w    $6564,$2E20,$5768,$6174,$2073,$7065,$6564,$2077; $03F990
    dc.w    $6F75,$6C64,$2079,$6F75,$206C,$696B,$653F,$00FF; $03F9A0
    dc.w    $2573,$00FF,$446F,$6E27,$7420,$796F,$7520,$7468; $03F9B0
    dc.w    $696E,$6B20,$7765,$2073,$686F,$756C,$6420,$7465; $03F9C0
    dc.w    $726D,$696E,$6174,$6520,$7365,$7276,$6963,$6520; $03F9D0
    dc.w    $6F6E,$2074,$6869,$7320,$726F,$7574,$653F,$00FF; $03F9E0
    dc.w    $4920,$7468,$696E,$6B20,$7765,$2073,$686F,$756C; $03F9F0
    dc.w    $6420,$7465,$6D70,$6F72,$6172,$696C,$7920,$7375; $03FA00
    dc.w    $7370,$656E,$6420,$6F70,$6572,$6174,$696F,$6E73; $03FA10
    dc.w    $206F,$6E20,$7468,$6973,$2072,$6F75,$7465,$2E00; $03FA20
    dc.w    $5468,$6520,$726F,$7574,$6520,$6265,$7477,$6565; $03FA30
    dc.w    $6E20,$2573,$2061,$6E64,$2025,$7320,$6973,$206E; $03FA40
    dc.w    $6F74,$2070,$726F,$6669,$7461,$626C,$652E,$00FF; $03FA50
    dc.w    $5468,$6520,$726F,$7574,$6520,$6265,$7477,$6565; $03FA60
    dc.w    $6E20,$2573,$2061,$6E64,$2025,$7320,$6973,$2072; $03FA70
    dc.w    $756E,$6E69,$6E67,$2025,$246C,$7520,$696E,$2074; $03FA80
    dc.w    $6865,$2062,$6C61,$636B,$2E00,$5468,$6520,$726F; $03FA90
    dc.w    $7574,$6520,$6265,$7477,$6565,$6E20,$2573,$2061; $03FAA0
    dc.w    $6E64,$2025,$7320,$6973,$2072,$756E,$6E69,$6E67; $03FAB0
    dc.w    $2025,$246C,$7520,$696E,$2074,$6865,$2072,$6564; $03FAC0
    dc.w    $2E00,$5269,$7369,$6E67,$206F,$696C,$2070,$7269; $03FAD0
    dc.w    $6365,$7320,$6172,$6520,$6861,$7669,$6E67,$2061; $03FAE0
    dc.w    $2073,$6576,$6572,$6520,$696D,$7061,$6374,$206F; $03FAF0
    dc.w    $6E20,$6F75,$7220,$6578,$7065,$6E73,$6573,$2E00; $03FB00
    dc.w    $5468,$6572,$6520,$2573,$2025,$6420,$2573,$2077; $03FB10
    dc.w    $6865,$7265,$2077,$6520,$646F,$206E,$6F74,$2068; $03FB20
    dc.w    $6176,$6520,$6120,$6875,$622E,$00FF,$4279,$206F; $03FB30
    dc.w    $7065,$6E69,$6E67,$2068,$7562,$7320,$696E,$2061; $03FB40
    dc.w    $6C6C,$2072,$6567,$696F,$6E73,$2077,$6520,$6361; $03FB50
    dc.w    $6E20,$6578,$7061,$6E64,$206F,$7572,$206E,$6574; $03FB60
    dc.w    $776F,$726B,$2074,$6F20,$636F,$7665,$7220,$7468; $03FB70
    dc.w    $6520,$7768,$6F6C,$6520,$776F,$726C,$642E,$00FF; $03FB80
    dc.w    $4C65,$7427,$7320,$7465,$726D,$696E,$6174,$6520; $03FB90
    dc.w    $756E,$6E65,$6365,$7373,$6172,$7920,$726F,$7574; $03FBA0
    dc.w    $6573,$2061,$6E64,$206F,$7065,$6E20,$6E65,$7720; $03FBB0
    dc.w    $6F6E,$6573,$2069,$6E20,$7265,$6769,$6F6E,$7320; $03FBC0
    dc.w    $7768,$6572,$6520,$7765,$2772,$6520,$7765,$616B; $03FBD0
    dc.w    $2E00,$416E,$2061,$6972,$6C69,$6E65,$2069,$7320; $03FBE0
    dc.w    $6F6E,$6C79,$2061,$6C6C,$6F77,$6564,$2074,$6F20; $03FBF0
    dc.w    $6F70,$6572,$6174,$6520,$3430,$2072,$6F75,$7465; $03FC00
    dc.w    $732E,$00FF,$4966,$2079,$6F75,$2064,$6F6E,$2774; $03FC10
    dc.w    $2074,$6572,$6D69,$6E61,$7465,$2073,$6F6D,$6520; $03FC20
    dc.w    $726F,$7574,$6573,$2079,$6F75,$2063,$616E,$2774; $03FC30
    dc.w    $206F,$7065,$6E20,$6E65,$7720,$6F6E,$6573,$2E00; $03FC40
    dc.w    $4927,$6D20,$7375,$7265,$2077,$6520,$6861,$7665; $03FC50
    dc.w    $2061,$2066,$6577,$2072,$6F75,$7465,$7320,$7468; $03FC60
    dc.w    $6174,$2063,$6F75,$6C64,$2062,$6520,$636C,$6F73; $03FC70
    dc.w    $6564,$2061,$6E64,$2072,$6570,$6C61,$6365,$6420; $03FC80
    dc.w    $6279,$2073,$6F6D,$6574,$6869,$6E67,$206D,$6F72; $03FC90
    dc.w    $6520,$7072,$6F66,$6974,$6162,$6C65,$2E00,$4F75; $03FCA0
    dc.w    $7220,$636F,$6D70,$616E,$7927,$7320,$726F,$7574; $03FCB0
    dc.w    $6573,$2061,$6C72,$6561,$6479,$2063,$6F76,$6572; $03FCC0
    dc.w    $2065,$7665,$7279,$2072,$6567,$696F,$6E20,$6F6E; $03FCD0
    dc.w    $2074,$6865,$2067,$6C6F,$6265,$2E00,$2573,$2055; $03FCE0
    dc.w    $7365,$2074,$6865,$2063,$6F6E,$7472,$6F6C,$2070; $03FCF0
    dc.w    $6164,$2074,$6F20,$7365,$6C65,$6374,$2061,$2072; $03FD00
    dc.w    $6F75,$7465,$2E00,$5768,$6963,$6820,$726F,$7574; $03FD10
    dc.w    $6520,$7368,$6F75,$6C64,$2077,$6520,$6469,$7363; $03FD20
    dc.w    $7573,$733F,$0A0A,$436F,$6E74,$726F,$6C20,$5061; $03FD30
    dc.w    $643A,$0A20,$4C2F,$5220,$746F,$2063,$6861,$6E67; $03FD40
    dc.w    $6520,$7265,$6769,$6F6E,$0A20,$552F,$4420,$746F; $03FD50
    dc.w    $2063,$6861,$6E67,$6520,$726F,$7574,$6500,$4D65; $03FD60
    dc.w    $6574,$696E,$6720,$6973,$2061,$646A,$6F75,$726E; $03FD70
    dc.w    $6564,$2E00,$5368,$616C,$6C20,$7765,$2061,$646A; $03FD80
    dc.w    $6F75,$726E,$2061,$6E64,$206D,$6565,$7420,$6167; $03FD90
    dc.w    $6169,$6E20,$6C61,$7465,$723F,$00FF,$506C,$6561; $03FDA0
    dc.w    $7365,$2063,$686F,$6F73,$6520,$6120,$746F,$7069; $03FDB0
    dc.w    $6320,$666F,$7220,$6469,$7363,$7573,$7369,$6F6E; $03FDC0
    dc.w    $2E00,$4920,$6361,$6C6C,$2074,$6869,$7320,$6D65; $03FDD0
    dc.w    $6574,$696E,$6720,$746F,$206F,$7264,$6572,$2E00; $03FDE0
    dc.w    $5368,$616C,$6C20,$4920,$636F,$6E64,$7563,$7420; $03FDF0
    dc.w    $7468,$6520,$6D65,$6574,$696E,$673F,$00FF,$2573; $03FE00
    dc.w    $206C,$6574,$2773,$2064,$6973,$6375,$7373,$2025; $03FE10
    dc.w    $732E,$00FF,$4E65,$7874,$2C00,$536F,$2C00,$4669; $03FE20
    dc.w    $7273,$742C,$00FF,$6275,$7369,$6E65,$7373,$2076; $03FE30
    dc.w    $656E,$7475,$7265,$7300,$6F75,$7220,$706C,$616E; $03FE40
    dc.w    $6520,$686F,$6C64,$696E,$6773,$00FF,$6164,$6A75; $03FE50
    dc.w    $7374,$696E,$6720,$6578,$6973,$7469,$6E67,$2072; $03FE60
    dc.w    $6F75,$7465,$7300,$6F70,$656E,$696E,$6720,$6E65; $03FE70
    dc.w    $7720,$726F,$7574,$6573,$00FF,$6169,$7263,$7261; $03FE80
    dc.w    $6674,$00FF,$4920,$6B6E,$6F77,$2077,$6520,$6E65; $03FE90
    dc.w    $6564,$206E,$6577,$2072,$6F75,$7465,$732C,$2062; $03FEA0
    dc.w    $7574,$2049,$2064,$6F6E,$2774,$2072,$6561,$6C6C; $03FEB0
    dc.w    $7920,$6861,$7665,$2061,$6E79,$2067,$6F6F,$6420; $03FEC0
    dc.w    $6964,$6561,$732E,$00FF,$596F,$7527,$6C6C,$2077; $03FED0
    dc.w    $616E,$7420,$746F,$2065,$7374,$6162,$6C69,$7368; $03FEE0
    dc.w    $2073,$6572,$7669,$6365,$2062,$6574,$7765,$656E; $03FEF0
    dc.w    $2025,$7320,$616E,$6420,$2573,$2C20,$6F66,$2063; $03FF00
    dc.w    $6F75,$7273,$652E,$2048,$6F77,$2061,$626F,$7574; $03FF10
    dc.w    $2025,$733F,$00FF,$4C65,$7427,$7320,$616C,$736F; $03FF20
    dc.w    $206F,$7065,$6E20,$6120,$726F,$7574,$6520,$2573; $03FF30
    dc.w    $2E00,$4F72,$2025,$7320,$776F,$756C,$6420,$6265; $03FF40
    dc.w    $2067,$6F6F,$642E,$00FF,$486F,$7720,$6162,$6F75; $03FF50
    dc.w    $7420,$6120,$726F,$7574,$6520,$2573,$3F00,$5765; $03FF60
    dc.w    $2063,$6F75,$6C64,$206C,$6F77,$6572,$2066,$6172; $03FF70
    dc.w    $6573,$2061,$6E64,$2067,$6976,$6520,$7072,$696F; $03FF80
    dc.w    $7269,$7479,$2074,$6F20,$766F,$6C75,$6D65,$206F; $03FF90
    dc.w    $7665,$7220,$7065,$722D,$7365,$6174,$2070,$726F; $03FFA0
    dc.w    $6669,$7420,$6D61,$7267,$696E,$732E,$00FF,$5265; $03FFB0
    dc.w    $6C61,$7469,$6F6E,$7320,$6265,$7477,$6565,$6E20; $03FFC0
    dc.w    $2573,$2061,$6E64,$2025,$7320,$6172,$6520,$7374; $03FFD0
    dc.w    $7261,$696E,$6564,$2E00,$5765,$2073,$686F,$756C; $03FFE0
    dc.w    $6420,$6275,$7920,$6275,$7369,$6E65,$7373,$6573; $03FFF0

