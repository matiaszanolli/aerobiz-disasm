# BACKLOG -- Task Queue

Pick the highest-priority unclaimed task. Mark it `IN PROGRESS` with your session date before starting. Mark `DONE` when complete with commit hash.

**Priority levels:** P0 = blocking other work, P1 = high impact, P2 = infrastructure, P3 = nice to have.

---

## P0 -- Blockers

### B-001: Initial ROM dump as dc.w
**Status:** DONE (2026-02-23)
**Why:** Foundation for all subsequent work. Need the complete ROM as raw data words.
**Approach:** Python script generated all assembly source from ROM binary. Split into header.asm (vectors + ROM header) and 16 x 64KB section files (dc.w data with 8 words per line, address comments).
**Acceptance:** `make verify` passes -- byte-identical (MD5: `1269f44e846a88a2de945de082428b39`).
**Key files:** `disasm/aerobiz.asm`, `disasm/sections/header.asm`, `disasm/sections/section_*.asm`

### B-002: Identify and label vector table
**Status:** DONE (2026-02-23)
**Why:** The vector table at $000000-$0000FF defines all entry points (reset, interrupts, exceptions). This is the roadmap for everything else.
**Approach:** All 64 vectors extracted from ROM and labeled with descriptive comments in header.asm. Key targets: Entry point at $000200, exception handlers clustered at $000F84-$000FD2, H-INT at $001484, V-INT at $000014E6, EXT INT at $001480. Labels placed at vector target addresses in data sections (EntryPoint, BusError, etc.).
**Acceptance:** All 64 vectors labeled. Reset vector -> $000200 (EntryPoint). ROM map updated.
**Key files:** `disasm/sections/header.asm`, `analysis/ROM_MAP.md`

---

## P1 -- High Impact

### B-003: Map ROM sections (code vs data vs padding)
**Status:** DONE (2026-02-23)
**Why:** Understanding ROM layout is prerequisite for targeted disassembly.
**Approach:** Heuristic scan counting 68K instruction markers (RTS, RTE, JSR, BSR, Bcc) per 4KB block. Combined with padding detection (runs of $00/$FF) and ASCII string detection. Identified 5 major code regions, 3 padding regions, mixed/data zones.
**Acceptance:** `analysis/ROM_MAP.md` populated with major regions, code density heatmap, statistics (854 RTS, 3873 JSR, ~30% padding).

### B-004: Trace entry point and main loop
**Status:** DONE (2026-02-23)
**Why:** Understanding the main execution flow tells us where everything else hangs from.
**Approach:** Disassembled from reset vector ($200) through TMSS boot -> game init -> main game entry ($D5B6) -> main loop ($D608). Traced V-INT ($14E6), H-INT ($1484), EXT INT ($1480), and exception handlers ($F84-$FE0). Identified Z80 sound driver at $2696-$3BE7 (5458 bytes).
**Acceptance:** `analysis/SYSTEM_EXECUTION_FLOW.md` fully documented: boot sequence, main game loop, V-INT/H-INT/exception handlers, Z80 sound driver location.

### B-005: Identify and document the sound driver
**Status:** DONE (2026-02-23)
**Why:** Sound driver is usually self-contained Z80 code loaded during boot. Identifying it early prevents it from being confused with game data.
**Approach:** Z80 driver at ROM $002696-$003BE7 (5458 bytes). Custom driver (not GEMS/SMPS). Entry: DI, LD SP,$2000, JP $00E0. References YM2612 ($4000-$4003) and PSG ($7F11). Init at $00260A, bus request at $002662.
**Acceptance:** Z80 driver located, entry structure and port usage documented.

---

## P2 -- Infrastructure

### B-006: Build function reference index
**Status:** DONE (2026-02-23)
**Why:** As functions are identified, we need a searchable reference.
**Approach:** Scanned all JSR/BSR/JMP targets to find 2,896 unique call targets. Named 41 functions across boot, game, interrupt, exception, and sound categories. Top 20 most-called functions identified. Quick lookup table for Ctrl+F searching.
**Acceptance:** `analysis/FUNCTION_REFERENCE.md` populated with categorized functions, call counts, and flat lookup table.

### B-007: Set up Navigator index
**Status:** DONE (2026-02-23)
**Why:** The Navigator agent needs its index populated to be useful.
**Approach:** Index populated incrementally during B-001 through B-004. Contains document registry (13 entries), platform facts, vector table details, ROM facts, execution flow, major regions, known pitfalls (8), and cross-reference table (12 entries).
**Acceptance:** Navigator answers queries about documentation, ROM layout, execution flow, and hardware.

---

## P3 -- Nice to Have

### B-008: Identify text encoding and string tables
**Status:** DONE (2026-02-23)
**Why:** Aerobiz has significant text content (airline names, city names, menus). Finding the text encoding early enables data table documentation.
**Approach:** Encoding is plain ASCII, null-terminated, printf-style (%s, %d, %$lu). 1,942 string runs found. Main dialogue region at $03E1AC-$041FFF (~398 strings). 8 pointer tables found at $0475DC-$0488D7 (largest: 128 pointers for dialogue, 118 for advisor text). City names at 3 locations ($0459xx, $045Axx, $045Cxx). 283 format strings.
**Acceptance:** Text encoding = ASCII null-terminated with printf formatting. Multiple string tables and pointer tables located.

---

## Phase 4 -- Data Analysis

### B-041: Build RAM variable map
**Status:** DONE (2026-02-25)
**Why:** All translated functions reference RAM variables. A central map is needed to understand what the code reads/writes and to resolve struct layouts.
**Approach:** Grepped all $FFxxxx references from section files. Traced PackSaveState ($00EB28) sequentially — it copies 30+ RAM regions in address order with explicit sizes, giving the definitive layout. Cross-referenced GetCharStat, InitCharRecord, DrawPlayerRoutes, FindBitInField, and V-INT handler for additional context.
**Acceptance:** `analysis/RAM_MAP.md` created with 50+ named addresses, grouped by region, with PackSaveState-derived sizes.
**Known issue:** Apparent overlap between char_stat_array ($FF05C4, stride $39 × 89 chars = ends $FF1995) and char_stat_tab ($FF1298). Needs field-level analysis to resolve.

### B-042: Label string / text pointer tables in section files
**Status:** DONE (2026-02-25)
**Why:** 7 pointer tables at $0475DC–$0488D7 and the string region at $03E1AC–$041FFF are raw dc.w. Adding labels makes cross-references visible and enables printf-string analysis.
**Approach:** Decoded ROM to identify 7 major pointer tables: ScenarioStrPtrs (9), ScenarioDescPtrs (21), DialoguePtrs (128), SfxNamePtrs (11), AdvisorTextPtrs (118), EventNamePtrs (17), StatusMsgPtrs (100). Split mid-line dc.w where tables don't start on 16-byte boundaries. Added GameStrings label at $03E1AC (679 strings, 15.4 KB).
**Acceptance:** `make verify` passes. 7 pointer table labels + 1 string region label in section_030000.asm and section_040000.asm.

### B-043: Label name string pool in section_040000.asm
**Status:** DONE (2026-02-25)
**Why:** Large name/data string pool at $04554F–$046384 (~3.6 KB, 405 strings) contains city names, airline names, aircraft models, venue names, country names, month abbreviations, and business categories — all used by game UI. Not "3 copies" as originally thought; one contiguous pool with sub-regions.
**Approach:** Decoded ROM to find exact pool boundaries and sub-region transitions. Added 8 labels: NameStringPool (master), BusinessCategories, VenueNames, CityNames (~200 cities), AirlineNames (~30), CountryNames (~50), AircraftModels (~40), MonthNames (12). Split mid-line dc.w where needed.
**Acceptance:** `make verify` passes. 8 labels in section_040000.asm.

### B-044: Document game data structures (player records, route slots, char records)
**Status:** TODO
**Why:** PackSaveState revealed the raw block layout; now field-level semantics are needed. Player records ($FF0018, 36B each), route slots ($FF9A20, 20B each), char stat records ($FF05C4, 57B each) are the three major structs.
**Approach:** Translate/read functions that access these structs with field offsets (ShowRouteInfo, ManageRouteSlots, CalcCharRating, etc.). Cross-reference with SNES/PC version docs if available.
**Acceptance:** DATA_STRUCTURES.md with field-level layout for all three structs.

### B-045: Resolve char_stat_array / char_stat_tab overlap
**Status:** TODO (depends on B-044)
**Why:** $FF05C4 + 89 × 57 = $FF1995 appears to overlap with $FF1298 (char_stat_tab). Either the count or stride is wrong, or the tables interleave. Must be resolved before RAM_MAP can be considered accurate.
**Approach:** Read UnpackPixelData fully. Trace InitCharRecord call chain. Confirm actual output stride and character count. Update RAM_MAP.md.
**Acceptance:** Overlap resolved; RAM_MAP.md updated with correct ranges.

---

## Phase 3 -- Function Translation

### B-009: Translate exception handlers ($F84-$FE0)
**Status:** DONE (2026-02-23)
**Why:** Simplest functions in the ROM -- each is 6 bytes (moveq + bra.w). Perfect first translation target.
**Approach:** Replaced dc.w with mnemonics. 14 handlers + ExceptionCommon + ExceptionHalt (94 bytes). All labels placed. Confirmed bra.w displacement correct in vasm (no +2 bug like bsr.w).
**Acceptance:** `make verify` passes. All exception handlers are mnemonics.

### B-010: Translate interrupt handlers (EXT/H-INT/V-INT)
**Status:** DONE (2026-02-23)
**Why:** Critical system code. EXT INT (4 bytes), H-INT (98 bytes), V-INT (202 bytes).
**Approach:** Full mnemonics for EXT INT (nop+rte) and H-INT (raster scroll with VDP_CTRL/VDP_DATA equates, indexed addressing verified). V-INT uses hybrid: mnemonics for logic (beq.s/beq.w/bra.s with local labels, movem.l, btst/bclr, move.b/w) + dc.w for bsr.w/jsr(pc) calls to external targets (no labels at target addresses yet). Subsystem update targets corrected: $175C not $1760, $18D0 not $18D4.
**Acceptance:** `make verify` passes. All three interrupt handlers readable with full control flow.

### B-011: Translate boot code ($200-$3A0)
**Status:** DONE (2026-02-23)
**Why:** Entry point and hardware initialization. ~416 bytes including inline data table.
**Approach:** Translated post-boot init ($2FA-$3A0): V-Blank wait loop, work RAM flag clearing (10 flags via A5 offsets), hardware init calls (7 jsr's to VDP/sound init), RAM subroutine copy (10 bytes to $FFF000), enable interrupts + jmp to GameEntry. TMSS code ($200-$28C) and data table ($28E-$2F8) remain as dc.w (standard Genesis boilerplate). Inline RAM sub kept as dc.w with comments.
**Acceptance:** `make verify` passes. Post-boot init fully readable.

### B-012: Translate sound driver interface ($260A-$2695)
**Status:** DONE (2026-02-23)
**Why:** Z80 init, bus request/release, delay routines. Self-contained utility functions.
**Approach:** Translated 4 functions: Z80_SoundInit (88 bytes, copies driver to Z80 RAM with bus arbitration), Z80_RequestBus (22 bytes), Z80_ReleaseBus (16 bytes), Z80_Delay (14 bytes). Used Z80_BUSREQ/Z80_RAM equates from definitions.asm. PC-relative lea and jsr(pc) kept as dc.w for displacement safety.
**Acceptance:** `make verify` passes. Sound interface functions are mnemonics.

### B-013: Translate most-called function $000D64
**Status:** DONE (2026-02-23)
**Why:** Called 306 times -- highest call count in ROM. Understanding it unlocks many callers.
**Approach:** Named "GameCommand" -- central command dispatcher with 47 handlers via jump table. Unusual stack frame: `move sr,-(sp)` BEFORE `link a6,#0` shifts first arg to $A(a6). Range check via cmpi.l #$2F / bcc.s, invalid command triggers infinite loop. 52 bytes of code + 188 bytes jump table (47 dc.l entries). First use of link/unlk, rtr, cmpi.l, indexed movea.l, jsr (a4), dc.l directive.
**Acceptance:** `make verify` passes. GameCommand fully translated with jump table.

### B-014: Translate main game loop ($D5B6-$D645)
**Status:** DONE (2026-02-23)
**Why:** The main loop structure. ~144 bytes of high-level game flow.
**Approach:** Translated 3 functions: GameEntry (76 bytes, 5 init calls + display setup + enters loop), GameLoopSetup (6 bytes, falls through to MainLoop), MainLoop (62 bytes, 8 jsr calls + frame counter + bra.s loop). All jsr/bsr kept as dc.w; pea, clr.w, addq, lea, bra.s as mnemonics. First use of pea instruction in translation.
**Acceptance:** `make verify` passes. Main loop is mnemonics with named subroutine calls.

### B-015: Translate top utility functions ($1D520-$1E1EC cluster)
**Status:** DONE (2026-02-23)
**Why:** 8 functions in the $01D5xx-$01E1xx range with 64-106 calls each, plus 3 helper functions between them.
**Approach:** Translated 11 functions totaling 624 bytes: MemFillByte (24B), MemCopy (24B), MemFillWord (24B), PollAction (120B, flush-then-wait input loop), RandRange (88B, classic C LCG with constants 1103515245/12345), ByteSum (30B), ResourceLoad/ResourceUnload (44B/42B, paired load/unload with flag), TilePlacement (116B, builds param block for GameCmd #15), GameCmd16 (40B, thin wrapper), ReadInput (72B, joypad input with mode selection). Hit ASL-vs-LSL pitfall on TilePlacement (KNOWN_ISSUES confirmed). Also hit a branch-target labeling bug on PollAction (bne.s to wrong label).
**Acceptance:** `make verify` passes. All 11 functions translated with full control flow.

### B-017: Translate RangeLookup at $D648
**Status:** DONE (2026-02-23)
**Why:** 114 calls, immediately after MainLoop. High-traffic utility.
**Approach:** Translated 1 function at $D648-$D6BC (118 bytes). Takes a value from stack, searches 8-entry table at ROM $5ECBC (4 bytes/entry). Value < 32: searches bytes [0]+[1] thresholds. Value 32-88: searches bytes [2]+[3] thresholds. Value 89: returns 7. Value >= 90: returns $FF. Standard loop with CMPI.W/BCS.S for iteration control.
**Acceptance:** `make verify` passes. Function fully translated.

### B-016: Translate math primitives ($3E05C, $3E08A, $3E146)
**Status:** DONE (2026-02-23)
**Why:** Top 3 most-called unnamed functions (204+169+88 = 461 total calls). Critical math infrastructure used by RandRange and throughout game logic.
**Approach:** Translated 12 functions in the $3E05A-$3E181 math block (296 bytes): Multiply32 (42B, 204 calls, 32x32->32 via cross-product MULU.W), SignedDiv (54B, 169 calls, fast DIVS.W path + slow negate-and-unsigned path), UnsignedDivide (24B, shared entry with fast DIVU.W), UDiv_Overflow (30B, two-step 32/16 long division), UDiv_Full32 (38B, bit-by-bit shift-subtract, 16 iterations), UnsignedMod (24B, remainder extraction), SignedMod (60B, 88 calls, sign-follows-dividend), plus 5 FromPtr alternate entries (load from pointer, swap operands). BSR.W at $3E172 kept as dc.w (vasm +2 displacement bug). All DIVS.W/DIVU.W/MULU.W/EXT.L/ADDX.L/DBRA verified against ROM bytes.
**Acceptance:** `make verify` passes. All 12 functions translated with full control flow.

### B-018: Translate LZ_Decompress ($003FEC-$00423F)
**Status:** DONE (2026-02-23)
**Why:** 123 calls. Core decompression routine used for loading compressed game assets.
**Approach:** Translated 1 function at $003FEC-$00423F (596 bytes, largest single function translated). LZSS/LZ77 variant with control-byte-driven bitstream processing. Algorithm: 8 flag bits per control byte, bit=1 for literal copy, bit=0 for back-reference match (variable-length encoded length + distance). Match length via cascading priority encoding (test bits 15-9, extract 1-13 bits, 255=end marker). Match distance via cascading range checks (7-15 bits consumed). Copy loop: (length+1) bytes from (dest - distance - 1). Helper function at $003F72 called via JSR (A4) for bitstream consumption. All 16 ASR.L shifts verified (type bits 00, no ASL/LSL pitfall). All 10 BRA.W/Bcc.W branches verified correct in vasm (no displacement bug unlike BSR.W). No BSR.W in function. 17 PEA instructions for constant passing. RAM: $FFBD56 (bitstream window via A3), $FFA78C (control byte), $FF1802 (init flag).
**Acceptance:** `make verify` passes. Function fully translated with 24 local labels.

### B-019: Translate text system functions ($03A942-$03B29B)
**Status:** DONE (2026-02-23)
**Why:** 5 functions with 124+174+171+65+97 = 631 total calls. The game's complete text rendering pipeline.
**Approach:** Translated 5 functions totaling 250 bytes: SetTextWindow (106B, 124 calls, sets win_left/top/right/bottom RAM + cursor helpers), SetTextCursor (36B, 174 calls, sets cursor X/Y via helpers), sprintf (26B, 171 calls, C-style varargs format to buffer), PrintfNarrow (42B, 65 calls, format + display with 1-tile font), PrintfWide (44B, 97 calls, format + display with 2-tile font). Discovered text RAM variables: font_mode $FF1800, cursor_x $FF128A, cursor_y $FFBDA6, char_width $FF99DE, cursor_advance $FFA77A, window bounds at $FFBD48/68/B9E4/BDA8/1000/1290. All BSR.W kept as dc.w (vasm bug). First use of LINK/UNLK/LEA for C-style varargs.
**Acceptance:** `make verify` passes. All 5 functions translated.

### B-020: Translate high-call-count functions (display, graphics, memory, input)
**Status:** DONE (2026-02-23)
**Why:** 16 functions with combined 590+ calls. Covers display setup, tile placement, memory copy, input polling, and bitfield search.
**Approach:** Translated 3 batches totaling 910 bytes:
- Batch 1 (DisplaySetup cluster, 292B, 6 functions): DisplaySetup (80B, 101 calls), DisplayInitRows (68B), DisplayInit15 (12B), DisplayInit0 (10B), DisplaySetupScaled (52B), DisplayTileSetup (70B). Hit ASL vs LSL pitfall at $00515C.
- Batch 2 (304B, 5 functions): CmdPlaceTile (62B, 46 calls, GameCommand #5), CmdSetBackground (44B, 46 calls, GameCommand #26), BitFieldSearch (88B, 47 calls, RAM bitfield scan), GetByteField4 (24B, 36 calls, high nibble extract), PreLoopInit (86B, 57 calls, display layer init via JSR (A2) pattern).
- Batch 3 (314B, 5 functions): GetLowNibble (16B, 20 calls), MemMove (52B, 19 calls, direction-safe byte copy), CmdPlaceTile2 (64B, 23 calls, GameCommand #8), ProcessInputLoop (100B, 42 calls, input polling with ReadInput BSR.W), PollInputChange (82B, 18 calls, frame-counting input change detection).
All verified byte-identical before applying. JSR abs.l kept as dc.w, BSR.W as dc.w (vasm displacement bug).
**Acceptance:** `make clean && make all` passes. MD5 1269f44e846a88a2de945de082428b39. All 16 functions translated.

---

## Done

| ID | Description | Commit | Date |
|----|-------------|--------|------|
| B-040 | Batch mnemonization of 17 targets (20278B: PackSaveState/ShowRouteInfo/ManageRouteSlots/ShowQuarterSummary/ProcessCharActions/RunAssignmentUI/ShowStatsSummary/RunCharManagement/FormatRelationDisplay/FormatRelationStats/ShowRelationAction/ShowRelationResult/RunQuarterScreen/ShowGameStatus/RunTurnSequence/ShowAnnualReport/RunScenarioMenu) | 5821108 | 2026-02-25 |
| B-039 | Batch mnemonization of 15 targets (9234B: DecompressVDPTiles/RenderTileStrip/ShowCharDetail/CollectPlayerChars/ShowCharCompare/RunPlayerSelectUI/RunGameMenu/BrowseMapPages/BrowseRelations/CalcCityStats/ShowQuarterReport/CalcRelationScore/RemoveCharRelation/RecruitCharacter/RenderTextBlock) | 2f2ae41 | 2026-02-25 |
| B-038 | Batch mnemonization of 15 targets (5190B: InsertRelationRecord/FindRelationIndex/RunScreenLoop/ProcessRouteAction/RankCharCandidates/ProcessRouteChange/UpdateRouteMask/CalcCityCharBonus/ShowPlayerCompare/ProcessTradeAction/CalcPlayerRankings/RunPurchaseMenu/RunAIStrategy/FindBestCharForSlot/CollectCharRevenue) | a7d07ca | 2026-02-25 |
| B-037 | Batch mnemonization of 15 targets (2878B: FadePalette/DrawTileStrip/DrawRouteLines/DrawRoutePair/RunPlayerTurn/FindOpenSlot/CountUnprofitableRoutes/CalcTotalCharValue/CalcPlayerFinances/UpdateSlotEvents/DrawCharDetailPanel/AnimateScrollWipe/BuildRouteLoop/RunAITurn/ApplyCharBonus) | 8d85b82 | 2026-02-25 |
| B-036 | Batch mnemonization of 15 targets (1028B: NopStub/CopyBytesToWords/RunEventSequence/SumStatBytes/CalcQuarterBonus/InitFlightDisplay/CountRouteFlags/CheckBitField/ClassifyEvent/SetupEventUI/VerifyChecksum/FindSlotByChar/InitQuarterEvent/FindCharSlotInGroup/CountProfitableRelations) | 0af386b | 2026-02-25 |
| B-035 | Batch mnemonization of 15 targets (1376B: FillSequentialWords/UpdateSlotDisplays/UnpackPixelData/CopyRouteFields/CheckCharEligible/DrawDualPanels/ScanRouteSlots/ToUpperCase/CalcPlayerWealth/WriteEventField/ShowCharInfoPage/CalcCharScore/SetCursorY/SetCursorX/ShowPlayerScreen) | fb09f0e | 2026-02-25 |
| B-034 | Batch mnemonization of 15 targets (1648B: DrawLayersReverse/DrawLayersForward/HitTestMapTile/CheckCharCompat/FindRelationRecord/CountCharPerformance/SumPlayerStats/WeightedAverage/CalcEventValue/DecompressTilePair/TogglePageDisplay/RunTransitionSteps/UpdateIfActive/ClearCharSprites/CheckMatchSlots) | e769c4c | 2026-02-25 |
| B-033 | Batch mnemonization of 15 targets (2290B: InitTileBuffer/SetScrollBarMode/CalcRouteRevenue/InitAllCharRecords/ClearFlightSlots/MatchCharSlots/RefreshAndWait/DrawTilemapLine/CopyAlternateBytes/StringAppend/StringConcat/AnimateScrollEffect/FindBestCharValue/LoadGameGraphics/ResetGameState) | 2bb3c72 | 2026-02-25 |
| B-032 | Batch mnemonization of 15 targets (3284B: LoadTileGraphics/CalcCharRating/AdjustScrollPos/LoadSlotGraphics/FindBestCharacter/FindCharByValue/GetCharRelation/UpdateFlightSlots/AnimateFlightPaths/GetModeRowOffset/SetDisplayPage/LoadMapTiles/PlaceFormattedTiles/MemMoveWords/CalcCharProfit) | 3844575 | 2026-02-24 |
| B-031 | Batch mnemonization of 15 high-call-count targets (5336B: ConfigScrollBar/SetHighNibble/SelectPreviewPage/ShowCharProfile/CalcCharAdvantage/CharacterBrowser/BrowseCharList/CalcStatChange/PlaceCursor/DrawPlayerRoutes/ShowPlayerChart/ShowCharStats/CheckEventMatch/DrawLabeledBox/CountActivePlayers) | ae5b0cb | 2026-02-24 |
| B-030 | Batch mnemonization of 15 high-call-count targets (4782B: ClearScreen/SetScrollQuadrant/DrawCharInfoPanel/CountMatchingChars/FindCharSlot/CalcNegotiationPower/PlaceCharSprite/CalcRevenue/CalcCharOutput/SortWordPairs/BrowsePartners/DiagonalWipe/SetScrollOffset/ShowGameScreen/ClearListArea) | 0fe1212 | 2026-02-24 |
| B-029 | Batch mnemonization of 15 high-call-count targets (2304B: PlaceIconPair/LoadCompressedGfx/UpdateCharField/CalcCompatScore/CalcTypeDistance/CalcWeightedStat/FindBitInField/LoadScreenPalette/CalcRelationValue/SetDisplayMode/InitInfoPanel/AnimateInfoPanel/PlaceItemTiles/ShowCharPortrait/ClearTileArea) | b0236fe | 2026-02-24 |
| B-028 | Unnamed call targets batch 2 (10 functions, 1258B: PlaceIconTiles/ClearBothPlanes/DrawStatDisplay/GetCharStat/SelectMenuItem/InitCharRecord/ShowPlayerInfo/DrawTileGrid/MulDiv/ClearInfoPanel) | 5839ea2 | 2026-02-24 |
| B-027 | Top unnamed call targets (5 functions, 1196B: ShowText/LoadScreenGfx/CalcCharValue/FillTileRect/LoadDisplaySet) | 4dfc342 | 2026-02-24 |
| B-026 | ShowRelPanel ($006B78, 40 calls, 882B: char relationship/affinity panel, 2-path bar-draw loops) | 7b6a94b | 2026-02-24 |
| B-025 | DrawBox ($005A04, 42 calls, 608B: corners+edges+fill tile loop) | fa57e84 | 2026-02-24 |
| B-024 | Character code functions translated (CharCodeCompare $6F42 + CharPairIndex $71DE, 484 bytes, 7-category jump table) | d0078b6 | 2026-02-24 |
| B-023 | CharCodeScore + RangeMatch translated ($70DC + $7158, 258 bytes) | b6b5939 | 2026-02-24 |
| B-022 | MenuSelectEntry + LoadScreen translated ($1D3AC + $6A2E, 482 bytes) | 0a0309d | 2026-02-24 |
| B-021 | High-call-count functions translated (ShowDialog/ShowTextDialog/BitFieldSearch cluster, 550 bytes) | 02c6f26 | 2026-02-24 |
| B-020 | High-call-count functions translated (16 functions, 910 bytes: display/graphics/memory/input) | 173f37c | 2026-02-23 |
| B-019 | Text system translated (5 functions, 250 bytes) | -- | 2026-02-23 |
| B-018 | LZ_Decompress translated (596 bytes, LZSS decompressor) | -- | 2026-02-23 |
| B-017 | RangeLookup translated ($D648, 118 bytes) | -- | 2026-02-23 |
| B-016 | Math primitives translated (12 functions, 296 bytes) | -- | 2026-02-23 |
| B-015 | Utility cluster translated (11 functions, 624 bytes) | -- | 2026-02-23 |
| B-013 | GameCommand dispatcher translated (47-entry jump table, 240 bytes) | -- | 2026-02-23 |
| B-012 | Sound driver interface translated (4 functions, 140 bytes) | -- | 2026-02-23 |
| B-014 | Main game loop translated (GameEntry + GameLoopSetup + MainLoop, 144 bytes) | -- | 2026-02-23 |
| B-009 | Exception handlers translated (14 handlers + common, 94 bytes) | -- | 2026-02-23 |
| B-010 | Interrupt handlers translated (EXT 4B + H-INT 98B + V-INT 202B) | -- | 2026-02-23 |
| B-011 | Boot code translated ($2FA-$3A0, post-init 166 bytes) | -- | 2026-02-23 |
| B-005 | Z80 sound driver identified (custom, 5458 bytes at $2696) | -- | 2026-02-23 |
| B-006 | Function reference built (41 named, 2896 targets, top-20 by calls) | -- | 2026-02-23 |
| B-007 | Navigator index populated (13 docs, 12 cross-refs) | -- | 2026-02-23 |
| B-008 | Text encoding: ASCII null-term, 8 pointer tables, 398+ strings | -- | 2026-02-23 |
| B-003 | ROM sections mapped (code/data/padding heatmap, 854 functions) | aac6850 | 2026-02-23 |
| B-004 | Entry point traced, main loop + all interrupt handlers documented | aac6850 | 2026-02-23 |
| B-001 | Initial ROM dump as dc.w (byte-identical, 16 section files) | f46553e | 2026-02-23 |
| B-002 | Vector table identified and labeled (all 64 vectors) | f46553e | 2026-02-23 |
| -- | Project scaffolding created | 412e6cf | 2026-02-22 |
