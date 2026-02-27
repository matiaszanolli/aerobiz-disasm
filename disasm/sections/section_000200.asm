; ===========================================================================
; ROM Data: $000200-$00FFFF
; 65024 bytes (32512 words)
; ===========================================================================


; --- Reset vector -- program entry point ---
EntryPoint:
    dc.w    $4AB9,$00A1,$0008,$6606,$4A79,$00A1,$000C,$667C; $000200
    dc.w    $4BFA,$007C,$4C9D,$00E0,$4CDD,$1F00,$1029,$EF01; $000210
    dc.w    $0200,$000F,$6708,$237C,$5345,$4741,$2F00,$3014; $000220
    dc.w    $7000,$2C40,$4E66,$7217,$1A1D,$3885,$DA47,$51C9; $000230
    dc.w    $FFF8,$289D,$3680,$3287,$3487,$0111,$66FC,$7425; $000240
    dc.w    $10DD,$51CA,$FFFC,$3480,$3280,$3487,$2D00,$51CE; $000250
    dc.w    $FFFC,$289D,$289D,$761F,$2680,$51CB,$FFFC,$289D; $000260
    dc.w    $7813,$2680,$51CC,$FFFC,$7A03,$175D,$0011,$51CD; $000270
    dc.w    $FFFA,$3480,$4CD6,$7FFF,$46FC,$2700,$606C,$8000; $000280
    dc.w    $3FFF,$0100,$00A0,$0000,$00A1,$1100,$00A1,$1200; $000290
    dc.w    $00C0,$0000,$00C0,$0004,$0414,$303C,$076C,$0000; $0002A0
    dc.w    $0000,$FF00,$8137,$0001,$0100,$00FF,$FF00,$0080; $0002B0
    dc.w    $4000,$0080,$AF01,$D91F,$1127,$0021,$2600,$F977; $0002C0
    dc.w    $EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1; $0002D0
    dc.w    $D1E1,$F1F9,$F3ED,$5636,$E9E9,$8104,$8F02,$C000; $0002E0
    dc.w    $0000,$4000,$0010,$9FBF,$DFFF                   ; $0002F0 (end of data table)

; ===========================================================================
; Post-Boot Initialization ($0002FA-$0003A0)
; Wait for V-Blank, init work RAM, call init subroutines, enter game
; ===========================================================================

    tst.w   VDP_CTRL                                        ; $0002FA: read/clear VDP status
.vblank_wait:                                               ; $000300
    bsr.w WaitVBlank
    andi.w  #$0002,d0                                       ; check status bit 1
    bne.s   .vblank_wait                                    ; loop while set
; --- Early init (RAM/VDP setup) ---
    bsr.w EarlyInit
; --- Set up work RAM base and clear game state flags ---
    moveq   #0,d0                                           ; D0 = 0 (clear value)
    movea.l #$00FFF010,a5                                   ; A5 = work RAM base pointer
    move.b  d0,$02FB(a5)                                    ; clear input enable flag
    move.b  d0,$0B2A(a5)                                    ; clear display update flag
    move.b  d0,$001C(a5)                                    ; clear flag
    move.b  d0,$002B(a5)                                    ; clear V-INT dispatch flags
    move.b  d0,$004B(a5)                                    ; clear DMA pending flag
    move.w  d0,$0BCE(a5)                                    ; clear word flag
    move.l  d0,$0BD0(a5)                                    ; clear long
    move.b  d0,$0BD4(a5)                                    ; clear V-INT sub1 flag
    move.w  d0,$0C70(a5)                                    ; clear word
; --- Hardware init subroutine ---
    jsr (HardwareInit,PC)
    nop
; --- Test expansion controller ---
    btst    #6,IO_CTRL3                                     ; expansion controller present?
    bne.w   .copy_ram_sub                                   ; skip nop if yes
    nop
; --- Copy 10-byte subroutine from ROM to Work RAM ---
.copy_ram_sub:                                              ; $00034E
    movea.l #$00FFF000,a0                                   ; A0 = RAM target ($FFF000)
    movea.l #$00000362,a1                                   ; A1 = ROM source (inline below)
    move.l  (a1)+,(a0)+                                     ; copy bytes 0-3
    move.l  (a1)+,(a0)+                                     ; copy bytes 4-7
    move.w  (a1),(a0)                                       ; copy bytes 8-9
    bra.s   .init_subs                                      ; skip over inline data
; --- Inline RAM subroutine data (copied to $FFF000, 10 bytes) ---
    dc.w    $38AD,$0042                                     ; move.w $0042(a5),(a4)
    dc.w    $38AD,$0044                                     ; move.w $0044(a5),(a4)
    rts                                                     ; $00036A
; --- Init subroutine calls ---
.init_subs:                                                 ; $00036C
    jsr (VDP_Init1,PC)
    nop
    jsr (VDP_Init2,PC)
    nop
    jsr (VDP_Init3,PC)
    nop
    jsr (VDP_Init4,PC)
    nop
    jsr Z80_SoundInit
    jsr (Init5,PC)
    nop
    jsr (Init6,PC)
    nop
; --- Enable interrupts and enter main game ---
    move    #$2000,sr                                       ; enable interrupts (supervisor mode)
    movea.l #$0000D5B6,a0                                   ; A0 = GameEntry address
    jmp     (a0)                                            ; ENTER MAIN GAME

; ---------------------------------------------------------------------------
; === Translated block $0003A2-$000D64 ===
; 18 functions, 2498 bytes

    include "disasm/modules/68k/vdp/CmdSetVDPReg.asm"

    include "disasm/modules/68k/vdp/CmdSetScrollMode.asm"

    include "disasm/modules/68k/vdp/CmdGetVDPReg.asm"

    include "disasm/modules/68k/vdp/CmdGetVDPStatus.asm"

    include "disasm/modules/68k/game/CmdRunSubroutine.asm"

    include "disasm/modules/68k/graphics/CmdSetupDMA.asm"

    include "disasm/modules/68k/game/CmdTransferPlane.asm"

    include "disasm/modules/68k/game/CmdLoadTiles.asm"

    include "disasm/modules/68k/game/CmdSetupSprite.asm"

    include "disasm/modules/68k/game/CmdCopyMemory.asm"

    include "disasm/modules/68k/input/CmdReadInput.asm"

    include "disasm/modules/68k/game/CmdSetupObject.asm"

    include "disasm/modules/68k/game/CmdEnableDisplay.asm"

    include "disasm/modules/68k/boot/HardwareInit.asm"

    include "disasm/modules/68k/game/CmdWaitFrames.asm"

    include "disasm/modules/68k/game/CmdUpdateSprites.asm"

    include "disasm/modules/68k/display/CmdClearSprites.asm"

    include "disasm/modules/68k/game/CmdTestVRAM.asm"

    include "disasm/modules/68k/util/ComputeMapCoordOffset.asm"

    include "disasm/modules/68k/game/CmdDMABatchWrite.asm"

    include "disasm/modules/68k/game/CmdDMARowWrite.asm"

    include "disasm/modules/68k/game/CmdWaitDMA.asm"

    include "disasm/modules/68k/game/CmdSetWorkFlags.asm"

    include "disasm/modules/68k/game/CmdSystemReset.asm"
    include "disasm/modules/68k/game/CmdInitCharTable.asm"

    include "disasm/modules/68k/display/CmdClearCharTable.asm"

    include "disasm/modules/68k/game/CmdSetCharState.asm"

    include "disasm/modules/68k/util/ControllerRead.asm"

    include "disasm/modules/68k/game/CmdInitAnimation.asm"

    include "disasm/modules/68k/vint/VInt_Sub1.asm"

    include "disasm/modules/68k/vint/WaitVBlank.asm"

    include "disasm/modules/68k/game/CmdSetAnimState.asm"

    include "disasm/modules/68k/game/CmdSetTimer.asm"

    include "disasm/modules/68k/game/CmdConditionalWrite.asm"

    include "disasm/modules/68k/game/CmdInitGameVars.asm"


    include "disasm/modules/68k/game/GameCommand.asm"

    include "disasm/modules/68k/game/CmdClampCoords.asm"

    include "disasm/modules/68k/game/CmdGetCoords.asm"

    include "disasm/modules/68k/game/CmdReadCombinedWord.asm"

    include "disasm/modules/68k/game/CmdSetBoundsAndClamp.asm"

    include "disasm/modules/68k/vdp/CmdSetScrollParam.asm"

    include "disasm/modules/68k/game/CmdScanStatusArray.asm"

    include "disasm/modules/68k/game/CmdSaveBuffer.asm"

    include "disasm/modules/68k/game/InitSpriteLinks.asm"

    include "disasm/modules/68k/vdp/VDP_Init2.asm"

    include "disasm/modules/68k/vdp/VDP_Init1.asm"

    include "disasm/modules/68k/vdp/VDP_Init3.asm"

    include "disasm/modules/68k/boot/Init6.asm"

    include "disasm/modules/68k/boot/Init5.asm"

    include "disasm/modules/68k/vdp/VDP_Init4.asm"

    include "disasm/modules/68k/util/TriggerVDPDMA.asm"

    include "disasm/modules/68k/game/DispatchVDPWrite.asm"

    include "disasm/modules/68k/util/ReleaseZ80BusDirect.asm"

    include "disasm/modules/68k/game/SetVDPDisplayBit.asm"

    include "disasm/modules/68k/util/WaitVDPAndWrite.asm"

    include "disasm/modules/68k/util/ConfigVDPDMA.asm"

    include "disasm/modules/68k/util/ConfigVDPScroll.asm"

    include "disasm/modules/68k/util/ConfigVDPColors.asm"

    include "disasm/modules/68k/vint/VInt_Handler1.asm"

    include "disasm/modules/68k/util/BulkCopyVDP.asm"

    include "disasm/modules/68k/vint/VInt_Handler2.asm"

    include "disasm/modules/68k/vint/VInt_Handler3.asm"

    include "disasm/modules/68k/game/SelectVDPInit.asm"

    include "disasm/modules/68k/game/InitDisplayLayout.asm"

    include "disasm/modules/68k/vdp/DMA_Transfer.asm"

    include "disasm/modules/68k/display/DisplayUpdate.asm"

    include "disasm/modules/68k/vint/VInt_Sub2.asm"

    include "disasm/modules/68k/util/SubsysUpdate1.asm"

    include "disasm/modules/68k/util/SubsysUpdate2.asm"

    include "disasm/modules/68k/util/SubsysUpdate3.asm"

    include "disasm/modules/68k/util/SubsysUpdate4.asm"

    include "disasm/modules/68k/input/InitInputArrays.asm"

    include "disasm/modules/68k/util/ReadPortByte.asm"

    include "disasm/modules/68k/util/InputCaseDispatch.asm"

    include "disasm/modules/68k/game/CountInputBits.asm"

    include "disasm/modules/68k/util/StubReturn.asm"

    include "disasm/modules/68k/util/WritePortToggle.asm"

    include "disasm/modules/68k/util/XorAndUpdate.asm"

    include "disasm/modules/68k/util/ReadMultiNibbles.asm"

    include "disasm/modules/68k/util/WaitInputReady.asm"

    include "disasm/modules/68k/game/ParseInputData.asm"

    include "disasm/modules/68k/game/ParseInputExtended.asm"

    include "disasm/modules/68k/util/InputStateMachine.asm"

    include "disasm/modules/68k/game/ParseInputDispatch.asm"

    include "disasm/modules/68k/game/ParseInputNibbles.asm"

    include "disasm/modules/68k/util/WriteNibble.asm"

    include "disasm/modules/68k/util/CombineNibbles.asm"

    include "disasm/modules/68k/input/PollInputStatus.asm"

    include "disasm/modules/68k/util/WaitInputZero.asm"

    include "disasm/modules/68k/util/ReturnError.asm"

    include "disasm/modules/68k/game/InitAnimTable.asm"

    include "disasm/modules/68k/game/UpdateAnimTimer.asm"

    include "disasm/modules/68k/sound/CmdSendZ80Param.asm"


    include "disasm/modules/68k/sound/Z80_SoundInit.asm"
    include "disasm/modules/68k/sound/Z80_RequestBus.asm"
    include "disasm/modules/68k/sound/Z80_ReleaseBus.asm"
    include "disasm/modules/68k/sound/Z80_Delay.asm"

    include "disasm/modules/68k/boot/EarlyInit.asm"

    include "disasm/modules/68k/util/WriteColorBitsVRAM.asm"

    include "disasm/modules/68k/util/VRAMWriteWithMode.asm"

    include "disasm/modules/68k/util/VRAMWriteExtended.asm"

    include "disasm/modules/68k/game/DecompressVDPTiles.asm"

    include "disasm/modules/68k/graphics/TilePlaceWrapper.asm"

    include "disasm/modules/68k/util/FillTileSequence.asm"

    include "disasm/modules/68k/game/AddToTileBuffer.asm"

    include "disasm/modules/68k/graphics/TilePlaceComposite.asm"

    include "disasm/modules/68k/graphics/TilePaletteRotate.asm"

    include "disasm/modules/68k/game/LoadPaletteDataTile.asm"

    include "disasm/modules/68k/game/BuildPaletteWord.asm"

    include "disasm/modules/68k/game/SetPaletteViaCmd.asm"

    include "disasm/modules/68k/game/ApplyPaletteMask.asm"

    include "disasm/modules/68k/game/ApplyPaletteIndex.asm"

    include "disasm/modules/68k/game/ProcessPaletteIter.asm"

    include "disasm/modules/68k/game/ApplyPaletteShifts.asm"

    include "disasm/modules/68k/game/BuildSpriteDataRows.asm"

    include "disasm/modules/68k/util/WriteCharUIDisplay.asm"

    include "disasm/modules/68k/display/FadePalette.asm"
    include "disasm/modules/68k/graphics/DrawLayersReverse.asm"
    include "disasm/modules/68k/graphics/DrawLayersForward.asm"

    include "disasm/modules/68k/util/ComputeDisplayAttrsUpper.asm"

    include "disasm/modules/68k/util/ComputeDisplayAttrsLower.asm"

    include "disasm/modules/68k/util/NormalizeDisplayAttrs.asm"

    include "disasm/modules/68k/util/CopyWithMultiply.asm"

    include "disasm/modules/68k/util/CopyBufferPair.asm"

    include "disasm/modules/68k/game/BuildSpriteBuffer.asm"
    include "disasm/modules/68k/display/ClearScreen.asm"

    include "disasm/modules/68k/game/SetHorizontalScroll.asm"

    include "disasm/modules/68k/game/SetVerticalScroll.asm"

    include "disasm/modules/68k/game/SetScrollBothAxes.asm"

    include "disasm/modules/68k/game/SetScrollAlternate.asm"

    include "disasm/modules/68k/game/SetScrollQuadrant.asm"

    include "disasm/modules/68k/game/SelectPaletteMode.asm"

    include "disasm/modules/68k/util/ConfigDmaMode.asm"

    include "disasm/modules/68k/game/InitScrollModes.asm"

    include "disasm/modules/68k/util/PreGameInit.asm"

    include "disasm/modules/68k/game/ResetScrollModes.asm"

    include "disasm/modules/68k/game/UpdateScrollDisplay.asm"

    include "disasm/modules/68k/memory/ClearMemoryRange.asm"

    include "disasm/modules/68k/memory/CopyMemoryOffset.asm"

    include "disasm/modules/68k/util/CopyDataWithChecksum.asm"

    include "disasm/modules/68k/util/ComputeDataChecksum.asm"

    include "disasm/modules/68k/util/ComputeDataChecksumAlt.asm"

    include "disasm/modules/68k/util/EmptyStub.asm"

    include "disasm/modules/68k/util/ErrorDisplay.asm"

    include "disasm/modules/68k/util/PlaceIconPair.asm"
    include "disasm/modules/68k/util/PlaceIconTiles.asm"
    include "disasm/modules/68k/graphics/DrawBox.asm"
    include "disasm/modules/68k/graphics/DrawTileStrip.asm"
    include "disasm/modules/68k/graphics/RenderTileStrip.asm"
    include "disasm/modules/68k/util/FillSequentialWords.asm"
    include "disasm/modules/68k/graphics/LoadCompressedGfx.asm"

    include "disasm/modules/68k/game/UpdateScrollBar1.asm"

    include "disasm/modules/68k/game/UpdateScrollBar2.asm"

    include "disasm/modules/68k/game/CalcScrollBarPos.asm"

    include "disasm/modules/68k/game/UpdateScrollCounters.asm"

    include "disasm/modules/68k/util/TickAnimCounter.asm"

    include "disasm/modules/68k/game/DispatchScrollUpdates.asm"

    include "disasm/modules/68k/util/ConfigScrollBar.asm"

    include "disasm/modules/68k/game/ToggleScrollBar.asm"

    include "disasm/modules/68k/graphics/DrawCharInfoPanel.asm"
    include "disasm/modules/68k/util/FillTileRect.asm"
    include "disasm/modules/68k/graphics/LoadScreenGfx.asm"
    include "disasm/modules/68k/game/LoadScreen.asm"
    include "disasm/modules/68k/game/ShowRelPanel.asm"
    include "disasm/modules/68k/util/CharCodeCompare.asm"
    include "disasm/modules/68k/util/CharCodeScore.asm"
    include "disasm/modules/68k/util/RangeMatch.asm"
    include "disasm/modules/68k/util/CharPairIndex.asm"

    include "disasm/modules/68k/game/FindCompatChars.asm"


    include "disasm/modules/68k/game/SetHighNibble.asm"
    include "disasm/modules/68k/game/UpdateCharField.asm"
    include "disasm/modules/68k/game/CalcCompatScore.asm"
    include "disasm/modules/68k/game/CountMatchingChars.asm"
    include "disasm/modules/68k/game/FindCharSlot.asm"
    include "disasm/modules/68k/game/CalcTypeDistance.asm"
    include "disasm/modules/68k/game/FindSlotByChar.asm"
    include "disasm/modules/68k/game/SelectPreviewPage.asm"
    include "disasm/modules/68k/game/ShowDialog.asm"

    include "disasm/modules/68k/game/CheckCharRelation.asm"

    include "disasm/modules/68k/game/CheckBitField.asm"
    include "disasm/modules/68k/util/HitTestMapTile.asm"
    include "disasm/modules/68k/game/ShowCharProfile.asm"
    include "disasm/modules/68k/game/ShowCharDetail.asm"
    include "disasm/modules/68k/game/CalcWeightedStat.asm"

    include "disasm/modules/68k/game/CalcAffinityScore.asm"

    include "disasm/modules/68k/util/ClearBothPlanes.asm"
    include "disasm/modules/68k/game/CheckCharCompat.asm"
    include "disasm/modules/68k/game/FindRelationRecord.asm"
    include "disasm/modules/68k/game/InsertRelationRecord.asm"
    include "disasm/modules/68k/game/CalcCharAdvantage.asm"
    include "disasm/modules/68k/game/CalcNegotiationPower.asm"
    include "disasm/modules/68k/util/PlaceCharSprite.asm"
    include "disasm/modules/68k/graphics/DrawStatDisplay.asm"
    include "disasm/modules/68k/util/CharacterBrowser.asm"
    include "disasm/modules/68k/game/BrowseCharList.asm"
    include "disasm/modules/68k/game/CalcStatChange.asm"
    include "disasm/modules/68k/game/CalcRevenue.asm"
    include "disasm/modules/68k/game/FindRelationIndex.asm"
    include "disasm/modules/68k/game/CalcCharOutput.asm"
    include "disasm/modules/68k/graphics/DrawRouteLines.asm"
    include "disasm/modules/68k/graphics/DrawRoutePair.asm"

    include "disasm/modules/68k/game/ProcessCharRoster.asm"

    include "disasm/modules/68k/game/UpdateSlotDisplays.asm"
    include "disasm/modules/68k/util/PlaceCursor.asm"
    include "disasm/modules/68k/game/GetCharStat.asm"
    include "disasm/modules/68k/game/FindBitInField.asm"
    include "disasm/modules/68k/graphics/DrawPlayerRoutes.asm"
    include "disasm/modules/68k/util/NopStub.asm"
    include "disasm/modules/68k/game/SelectMenuItem.asm"
    include "disasm/modules/68k/game/RunScreenLoop.asm"

    include "disasm/modules/68k/game/InitGameDatabase.asm"

    include "disasm/modules/68k/game/LoadScenarioState.asm"

    include "disasm/modules/68k/game/InitDefaultScenario.asm"

    include "disasm/modules/68k/game/HandleScenarioTurns.asm"

    include "disasm/modules/68k/game/RunPortfolioManagement.asm"

    include "disasm/modules/68k/display/DisplayModelStats.asm"

    include "disasm/modules/68k/util/PlacePlayerNameLabels.asm"

    include "disasm/modules/68k/game/ProcessPlayerSelectInput.asm"

    include "disasm/modules/68k/util/WaitForKeyPress.asm"

    include "disasm/modules/68k/game/GetPlayerModelSelect.asm"

    include "disasm/modules/68k/game/RunModelSelectUI.asm"

    include "disasm/modules/68k/game/InitAllGameTables.asm"

    include "disasm/modules/68k/util/ComputeDividends.asm"

    include "disasm/modules/68k/game/RunAircraftPurchase.asm"

    include "disasm/modules/68k/util/ComputeMonthlyAircraftCosts.asm"

    include "disasm/modules/68k/util/ComputeAircraftSpeedDisp.asm"

    include "disasm/modules/68k/game/RunAircraftStatsDisplay.asm"

    include "disasm/modules/68k/util/PollSingleButtonPress.asm"

    include "disasm/modules/68k/game/RunAircraftParamShuffle.asm"

    include "disasm/modules/68k/game/SortAircraftByMetric.asm"

    include "disasm/modules/68k/display/DisplayMessageWithParams.asm"

    include "disasm/modules/68k/game/BuildAircraftAttrTable.asm"

    include "disasm/modules/68k/util/ScaleAircraftAttrValue.asm"

    include "disasm/modules/68k/game/RunDestSelectLoop.asm"

    include "disasm/modules/68k/game/LoadAllGameData.asm"

    include "disasm/modules/68k/game/InitPlayerAircraftState.asm"

    include "disasm/modules/68k/game/UpdateEventSchedule.asm"

    include "disasm/modules/68k/util/WaitForEventInput.asm"

    include "disasm/modules/68k/display/DisplayEventChoice.asm"

    include "disasm/modules/68k/game/InitGameGraphicsMode.asm"

    include "disasm/modules/68k/util/ClearDisplayBuffers.asm"

    include "disasm/modules/68k/game/InitGameAudioState.asm"

    include "disasm/modules/68k/game/GameEntry.asm"
    include "disasm/modules/68k/game/GameLoopSetup.asm"
    include "disasm/modules/68k/util/MainLoop.asm"
; ===========================================================================
; RangeLookup -- Map a value to a table index (0-7)
;   In:  4(sp) = value to look up (longword on stack)
;   Out: D0.w = index (0-7), or $FF if out of range
;   Table: 8 entries x 4 bytes at $5ECBC, cumulative thresholds
;   Value < 32: search bytes [0]+[1]; 32-88: search bytes [2]+[3]
;   Value 89: returns 7; Value >= 90: returns $FF
;   114 calls
; ===========================================================================
RangeLookup:                                                ; $00D648
    movem.l d2-d3,-(sp)               ; save D2-D3
    move.l  $000C(sp),d3              ; D3 = argument (past saved regs + return addr)
    movea.l #$0005ECBC,a0             ; A0 = range table in ROM
    cmpi.w  #$0020,d3                 ; value < 32?
    bge.s   .range2                    ; no, try second range
; --- Range 1: value 0-31, search using table bytes [0]+[1] ---
    clr.w   d2                         ; D2 = index counter
.loop1:                                                     ; $00D65E
    moveq   #0,d0
    move.b  (a0),d0                    ; D0 = entry byte 0
    moveq   #0,d1
    move.b  1(a0),d1                   ; D1 = entry byte 1
    add.l   d1,d0                      ; D0 = threshold sum
    move.w  d3,d1
    ext.l   d1                         ; D1 = value (sign-extended)
    cmp.l   d1,d0
    bgt.s   .found                     ; threshold > value, match
    addq.l  #4,a0                      ; next table entry
    addq.w  #1,d2                      ; index++
    cmpi.w  #$0007,d2
    bcs.s   .loop1                     ; loop while index < 7
    bra.s   .found                     ; not found, D2 = 7
; --- Range 2: value 32-88, search using table bytes [2]+[3] ---
.range2:                                                    ; $00D67E
    cmpi.w  #$0059,d3                  ; value < 89?
    bge.s   .range3                    ; no, check special cases
    clr.w   d2                         ; D2 = index counter
.loop2:                                                     ; $00D686
    moveq   #0,d0
    move.b  2(a0),d0                   ; D0 = entry byte 2
    moveq   #0,d1
    move.b  3(a0),d1                   ; D1 = entry byte 3
    add.l   d1,d0                      ; D0 = threshold sum
    move.w  d3,d1
    ext.l   d1                         ; D1 = value (sign-extended)
    cmp.l   d1,d0
    bgt.s   .found                     ; threshold > value, match
    addq.l  #4,a0                      ; next table entry
    addq.w  #1,d2                      ; index++
    cmpi.w  #$0007,d2
    bcs.s   .loop2                     ; loop while index < 7
    bra.s   .found                     ; not found, D2 = 7
; --- Range 3: special values ---
.range3:                                                    ; $00D6A8
    cmpi.w  #$005A,d3                  ; value < 90?
    bge.s   .invalid                   ; no, out of range
    moveq   #7,d2                      ; value == 89 -> index 7
    bra.s   .found
.invalid:                                                   ; $00D6B2
    move.w  #$00FF,d2                  ; out of range marker
.found:                                                     ; $00D6B6
    move.w  d2,d0                      ; D0 = result
    movem.l (sp)+,d2-d3               ; restore D2-D3
    rts
    include "disasm/modules/68k/game/RunPlayerTurn.asm"

    include "disasm/modules/68k/game/ProcessPlayerTurnAction.asm"

    include "disasm/modules/68k/game/SelectRouteDestination.asm"

    include "disasm/modules/68k/display/DisplayRouteDestChoice.asm"

    include "disasm/modules/68k/game/CalcCharValue.asm"
    include "disasm/modules/68k/util/CollectPlayerChars.asm"

    include "disasm/modules/68k/graphics/DrawPlayerComparisonStats.asm"

    include "disasm/modules/68k/game/RunPlayerStatCompareUI.asm"

    include "disasm/modules/68k/game/ShowCharCompare.asm"

    include "disasm/modules/68k/game/ProcessRouteEventLogic.asm"

    include "disasm/modules/68k/game/HandleDestArrival.asm"


    include "disasm/modules/68k/game/PackSaveState.asm"

    include "disasm/modules/68k/util/ExecPassengerLoadUnload.asm"

    include "disasm/modules/68k/game/UnpackPixelData.asm"

    include "disasm/modules/68k/game/ProcessAirportTransact.asm"

    include "disasm/modules/68k/util/CopyRouteFields.asm"
    include "disasm/modules/68k/game/ShowRouteInfo.asm"

    include "disasm/modules/68k/game/UpdatePassengerDemand.asm"

    include "disasm/modules/68k/util/VerifyChecksum.asm"
    include "disasm/modules/68k/game/ProcessRouteAction.asm"

    include "disasm/modules/68k/util/ComputeRouteProfit.asm"

    include "disasm/modules/68k/game/CalcOptimalTicketPrice.asm"

    include "disasm/modules/68k/util/SubmitTurnResults.asm"

    include "disasm/modules/68k/game/AdvanceToNextMonth.asm"

    include "disasm/modules/68k/game/FindOpenSlot.asm"
    include "disasm/modules/68k/game/CheckCharEligible.asm"
    include "disasm/modules/68k/game/CountUnprofitableRoutes.asm"
    include "disasm/modules/68k/game/CountCharPerformance.asm"

