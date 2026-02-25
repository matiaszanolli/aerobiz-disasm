# Aerobiz Supersonic -- Sega Genesis Disassembly

A full disassembly and reassembly project for **Aerobiz Supersonic** (USA) on the Sega Genesis / Mega Drive.

| | |
|---|---|
| **Platform** | Sega Genesis / Mega Drive |
| **CPU** | Motorola 68000 @ 7.67 MHz |
| **Sound** | Zilog Z80 @ 3.58 MHz, YM2612 FM, SN76489 PSG |
| **Publisher** | KOEI (T-76) |
| **Release** | December 1994 |
| **ROM size** | 1 MB |
| **Region** | USA |
| **Product code** | GM T-76136 -00 |

## Goal

Produce a fully documented, byte-identical reassembly of the original ROM from 68000 assembly source. All code translated to mnemonics, all functions named and documented, all data tables identified.

## Building

Requires `vasmm68k_mot` (Motorola-syntax 68000 assembler). The toolchain is included in `tools/`.

```bash
make all          # Assemble ROM -> build/aerobiz.bin
make verify       # Compare MD5 against original ROM
make clean        # Remove build artifacts
```

Place the original ROM as `Aerobiz Supersonic (USA).gen` in the project root for verification.

## Project Structure

```
aerobiz-disasm/
  disasm/
    aerobiz.asm                  # Main entry point (includes everything)
    modules/
      shared/definitions.asm     # Hardware register equates
      68k/<category>/*.asm       # Translated 68K modules (by category)
    sections/
      header.asm                 # Vector table + ROM header ($000000-$0001FF)
      section_XXXXXX.asm         # ROM data sections (64KB each)
  analysis/
    ROM_MAP.md                   # ROM layout (code/data/padding)
    FUNCTION_REFERENCE.md        # All identified functions
    SYSTEM_EXECUTION_FLOW.md     # Boot, main loop, V-INT, game states
  docs/                          # Hardware reference documentation (symlinked)
  tools/                         # Assembler and disassembler (symlinked)
  agents/                        # AI agent team definitions
  BACKLOG.md                     # Task queue
  KNOWN_ISSUES.md                # Pitfalls and gotchas
```

## ROM Layout

| Range | Size | Description |
|-------|------|-------------|
| `$000000-$0000FF` | 256 B | Exception vector table (64 longwords) |
| `$000100-$0001FF` | 256 B | ROM header (console name, title, checksum, SRAM info) |
| `$000200-$0FFFFF` | ~1 MB | Game code and data |

### Key Addresses

| Address | Purpose |
|---------|---------|
| `$000200` | Entry point (reset vector, TMSS boot) |
| `$0002FA` | Post-boot initialization (work RAM setup, HW init calls) |
| `$000F84-$000FE1` | Exception handlers (14 IDs + common handler + halt) |
| `$001480` | EXT interrupt handler (Level 2, unused -- nop + rte) |
| `$001484` | H-Blank interrupt handler (Level 4, raster scroll effect) |
| `$0014E6` | V-Blank interrupt handler (Level 6, main per-frame handler) |
| `$00D5B6` | Main game entry |
| `$00D608` | Main game loop (iterates forever) |
| `$002696-$003BE7` | Z80 sound driver (5,458 bytes, custom) |
| `$03E1AC-$041FFF` | Game text strings (ASCII, null-terminated, printf-style) |
| `$200001-$203FFF` | SRAM (battery-backed save data, ~8 KB) |

## Progress

| Phase | Description | Status |
|-------|-------------|--------|
| 1. Initial dump | ROM as raw `dc.w` data, vector table labeled | Done |
| 2. Code discovery | Trace execution, map ROM regions, identify functions | Done |
| 3. Function translation | `dc.w` -> 68K mnemonics, name functions | **In progress** |
| 4. Data analysis | Identify tables, strings, graphics data | Partial |
| 5. Full understanding | Complete documentation, byte-identical rebuild | Not started |

### Translation Status

~33,070 bytes of code translated from raw `dc.w` to 68000 mnemonics (all verified byte-identical):

- **System core** -- 944 bytes: exception handlers (94B), EXT/H-INT/V-INT interrupts (304B), boot init (166B), Z80 sound interface (140B), GameCommand dispatcher (240B)
- **Main game loop** -- 262 bytes: GameEntry, GameLoopSetup, MainLoop, RangeLookup
- **Math** -- 424 bytes: Multiply32, SignedDiv, UnsignedDivide, UnsignedMod, SignedMod (12 functions + MulDiv), WeightedAverage
- **Memory/util** -- 860 bytes: MemFillByte, MemCopy, MemFillWord, MemMove, ByteSum, GetLowNibble, GetByteField4, MemMoveWords, CopyAlternateBytes, StringAppend, StringConcat, FillSequentialWords, ToUpperCase, CopyBytesToWords, NopStub
- **Text** -- 270 bytes: SetTextWindow, SetTextCursor, sprintf, PrintfNarrow, PrintfWide, SetCursorX, SetCursorY
- **Compression** -- 596 bytes: LZ_Decompress (LZSS/LZ77)
- **Display/graphics** -- 4,010 bytes: DisplaySetup cluster (6), CmdPlaceTile/2, CmdSetBackground, FillTileRect, LoadScreenGfx, PlaceIconTiles, PlaceIconPair, LoadCompressedGfx, ClearBothPlanes, DrawTileGrid, ClearInfoPanel, ClearTileArea, LoadScreenPalette, SetDisplayMode, ShowCharPortrait, PlaceCharSprite, LoadTileGraphics, LoadSlotGraphics, LoadMapTiles, PlaceFormattedTiles, SetDisplayPage, DrawTilemapLine, DrawLayersReverse, DrawLayersForward, UnpackPixelData, VerifyChecksum, FadePalette, DrawTileStrip
- **Input** -- 268 bytes: ProcessInputLoop, PollInputChange, PreLoopInit
- **Game UI** -- 11,424 bytes: DrawBox, ShowRelPanel, DrawStatDisplay, ShowDialog, ShowTextDialog, ShowText, ShowPlayerInfo, LoadScreen, MenuSelectEntry, SelectMenuItem, InitInfoPanel, AnimateInfoPanel, PlaceItemTiles, DrawCharInfoPanel, BrowsePartners, ClearListArea, ConfigScrollBar, SelectPreviewPage, ShowCharProfile, CharacterBrowser, BrowseCharList, PlaceCursor, DrawPlayerRoutes, ShowPlayerChart, ShowCharStats, DrawLabeledBox, AdjustScrollPos, GetModeRowOffset, SetScrollBarMode, InitTileBuffer, RefreshAndWait, HitTestMapTile, UpdateSlotDisplays, CopyRouteFields, DrawDualPanels, CalcPlayerWealth, ShowCharInfoPage, ShowPlayerScreen, CheckBitField, FindSlotByChar, SetupEventUI, ClassifyEvent, DrawRouteLines, DrawRoutePair, DrawCharDetailPanel
- **Character system** -- 9,212 bytes: CharCodeCompare, CharPairIndex, CharCodeScore, RangeMatch, CalcCompatScore, CalcTypeDistance, CalcWeightedStat, CalcRelationValue, UpdateCharField, CalcCharValue, GetCharStat, InitCharRecord, FindBitInField, BitFieldSearch, CountMatchingChars, FindCharSlot, CalcNegotiationPower, CalcRevenue, CalcCharOutput, SetHighNibble, CalcCharAdvantage, CalcStatChange, CheckEventMatch, CountActivePlayers, CalcCharRating, FindBestCharacter, FindCharByValue, GetCharRelation, CalcCharProfit, CalcRouteRevenue, InitAllCharRecords, MatchCharSlots, FindBestCharValue, CheckCharCompat, FindRelationRecord, CountCharPerformance, SumPlayerStats, CheckMatchSlots, ClearCharSprites, CheckCharEligible, ScanRouteSlots, CalcCharScore, SumStatBytes, CountProfitableRelations, FindCharSlotInGroup, CalcQuarterBonus, CalcTotalCharValue, CalcPlayerFinances, CountUnprofitableRoutes, FindOpenSlot, ApplyCharBonus
- **Resources** -- 522 bytes: ResourceLoad, ResourceUnload, TilePlacement, GameCmd16, ReadInput, PollAction, RandRange, LoadDisplaySet, VRAMBulkLoad
- **Screen transitions** -- 1,480 bytes: DiagonalWipe, SetScrollOffset, SetScrollQuadrant, ShowGameScreen, ClearScreen, AnimateScrollEffect, RunTransitionSteps, UpdateIfActive, AnimateScrollWipe
- **Sorting** -- 188 bytes: SortWordPairs
- **Flight system** -- 654 bytes: UpdateFlightSlots, AnimateFlightPaths, ClearFlightSlots, InitFlightDisplay
- **Resource loading** -- 552 bytes: LoadGameGraphics, ResetGameState, DecompressTilePair
- **Events** -- 426 bytes: CalcEventValue, WriteEventField, RunEventSequence, InitQuarterEvent, UpdateSlotEvents
- **Page display** -- 156 bytes: TogglePageDisplay, CountRouteFlags
- **Game logic** -- 530 bytes: RunPlayerTurn, RunAITurn, BuildRouteLoop

231 functions named, 219 translated to mnemonics, out of ~854 total. See [BACKLOG.md](BACKLOG.md) for the full task queue.

## License

This repository contains no copyrighted ROM data. You must supply your own legally obtained ROM file to build. The disassembly source, tooling, and documentation are provided for educational and preservation purposes.
