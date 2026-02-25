# Function Reference -- Aerobiz Supersonic

Index of all identified functions. Updated as disassembly progresses.

## Summary

- **Total RTS (function endpoints):** 854
- **Total RTE (interrupt returns):** 6
- **Unique call targets:** 2,896
- **Functions named:** 278
- **Functions translated to mnemonics:** 266 (all named)

## Most-Called Functions

These are the most frequently called subroutines -- high-priority translation targets.

| Address | Calls | Name | Notes |
|---------|-------|------|-------|
| $000D64 | 306 | GameCommand | Central command dispatcher (47 handlers via jump table) |
| $03E05C | 204 | Multiply32 | 32x32->32 unsigned multiply (cross-product MULU.W) |
| $03AB2C | 174 | SetTextCursor | Set text cursor X/Y position |
| $03B22C | 171 | sprintf | Format string to buffer (C-style varargs) |
| $03E08A | 169 | SignedDiv | Signed 32/32 divide (fast DIVS.W + slow unsigned path) |
| $03A942 | 124 | SetTextWindow | Define text rendering window bounds |
| $003FEC | 123 | LZ_Decompress | LZSS/LZ77 decompressor (variable-length bitstream) |
| $00D648 | 114 | RangeLookup | Map value to table index (0-7) via cumulative thresholds |
| $01D71C | 106 | ResourceLoad | Load resource if not loaded, set flag |
| $005092 | 101 | DisplaySetup | Display/graphics setup |
| $01E044 | 100 | TilePlacement | Build tile params, call GameCmd #15 |
| $03B270 | 97 | PrintfWide | Format + display string (2-tile wide font) |
| $01E1EC | 95 | ReadInput | Read joypad via GameCmd #10, mode select |
| $01D748 | 95 | ResourceUnload | Unload resource if loaded, clear flag |
| $03E146 | 88 | SignedMod | Signed 32/32 modulo (sign follows dividend) |
| $01E0B8 | 77 | GameCmd16 | Thin wrapper for GameCommand #16 |
| $01D520 | 71 | MemFillByte | Fill memory with byte value |
| $03B246 | 65 | PrintfNarrow | Format + display string (1-tile narrow font) |
| $01D62C | 65 | PollAction | Flush-then-wait input polling |
| $01D6A4 | 64 | RandRange | Random int in [min,max] via LCG |

## Functions by Category

### Boot / Initialization

| Address | Name | Description |
|---------|------|-------------|
| $000200 | EntryPoint | TMSS security check + hardware init |
| $0002FA | GameInit | Game initialization (after TMSS) |
| $000CDC | WaitVBlank | Wait for V-Blank (poll VDP status) |
| $003BE8 | EarlyInit | Early init (RAM/VDP setup) |
| $00070A | HardwareInit | Hardware init subroutine |
| $001036 | VDP_Init1 | VDP/display init |
| $00101C | VDP_Init2 | Init subroutine |
| $00107A | VDP_Init3 | Init subroutine |
| $0010FE | VDP_Init4 | Init subroutine |
| $0010DA | Init5 | Init subroutine |
| $001090 | Init6 | Init subroutine |
| $00260A | Z80_SoundInit | Load Z80 sound driver to Z80 RAM |

### Main Game

| Address | Name | Description |
|---------|------|-------------|
| $000D64 | GameCommand | Central command dispatcher (306 calls, 47 handlers via jump table) |
| $01E1EC | ReadInput | Read joypad input via GameCmd #10 (95 calls, 3 modes) |
| $01D62C | PollAction | Flush-then-wait input polling (65 calls) |
| $01D6A4 | RandRange | Random integer in [min,max] via C LCG (64 calls) |
| $01D71C | ResourceLoad | Load resource if not loaded, set flag (106 calls) |
| $01D748 | ResourceUnload | Unload resource, clear flag (95 calls) |
| $01E044 | TilePlacement | Build tile parameters, call GameCmd #15 (100 calls) |
| $01E0B8 | GameCmd16 | Thin wrapper for GameCommand #16 (77 calls) |
| $00D5B6 | GameEntry | Main game entry (called from boot via JMP) |
| $00D602 | GameLoopSetup | One-time pre-loop init, falls into MainLoop |
| $00D608 | MainLoop | Main game loop body (8 calls, loops forever) |
| $00D648 | RangeLookup | Map value to table index (0-7) via cumulative thresholds (114 calls) |
| $005736 | PreGameInit | Pre-game initialization |
| $03B428 | GameSetup1 | Game setup (title/scenario?) |
| $03CA4E | GameSetup2 | Game setup |
| $005092 | DisplaySetup | Display/title screen setup (101 calls) |
| $01E398 | PreLoopInit | Called once before main loop (57 calls total) |
| $02F5A6 | GameUpdate1 | Main loop: first update call |
| $01B49A | GameUpdate2 | Main loop: second update call |
| $0213B6 | GameLogic1 | Main loop: game logic (quarterly turn?) |
| $02947A | GameLogic2 | Main loop: game logic (events/AI?) |
| $01819C | InitAllCharRecords | Main loop: init all character records 0-$58 |
| $01E402 | GameUpdate3 | Main loop: third update call |
| $026128 | GameUpdate4 | Main loop: fourth update call |
| $006A2E | LoadScreen | Load and initialize a game screen (38 calls) |
| $01D568 | VRAMBulkLoad | Chunked DMA transfer to VRAM via GameCommand (46 calls) |
| $007912 | ShowDialog | Display dialog with table lookup and optional input (38 calls) |
| $01183A | ShowTextDialog | Display text dialog with PrintfWide and table lookup (31 calls) |
| $01D3AC | MenuSelectEntry | Validate selection index, update $FFBD52, dispatch GameCommand (14 calls) |
| $006F42 | CharCodeCompare | Compare two character codes, compute compatibility index via 7-category jump table (22 calls) |
| $0071DE | CharPairIndex | Compute triangular index for a symmetric pair of character codes (1 call) |
| $005A04 | DrawBox | Draw bordered dialog box: corners + edges via tile sequence (42 calls) |
| $006B78 | ShowRelPanel | Display character relationship/affinity panel (40 calls) |
| $0070DC | CharCodeScore | Compute percentage match score for two character codes (12 calls) |
| $007158 | RangeMatch | Check if two char codes map to same range category (10 calls) |
| $0058FC | PlaceIconPair | Tile icon setup variant (8 calls) |
| $005FF6 | LoadCompressedGfx | Compressed graphics loader by index (7 calls) |
| $0073A6 | UpdateCharField | Character record field updater (8 calls) |
| $007412 | CalcCompatScore | Character compatibility scorer with range buckets (8 calls) |
| $007610 | CalcTypeDistance | Character type comparison via $FF99A4 table (10 calls) |
| $008016 | CalcWeightedStat | Stat-based value calculator (8 calls) |
| $009DC4 | FindBitInField | Bit-field scanner in $FFA6A0 table (7 calls) |
| $0100F2 | LoadScreenPalette | Palette/resource loader with LZ decompress (7 calls) |
| $01A506 | CalcRelationValue | Multi-mode character value calculator (7 calls) |
| $01D340 | SetDisplayMode | Display mode setter via $FF1274 flags (7 calls) |
| $0238F0 | InitInfoPanel | Init wrapper calling BSR.W + GameCommand #$1B (9 calls) |
| $023958 | AnimateInfoPanel | 3-iteration loop calling $0239BA and $023A34 (9 calls) |
| $023A34 | PlaceItemTiles | Tile placement loop for count items (9 calls) |
| $03A5A8 | ShowCharPortrait | Display setup with palette, LZ, tiles, text (8 calls) |
| $03A9AC | ClearTileArea | GameCommand #$1A wrapper with $8000 priority (8 calls) |
| $0053BA | ClearScreen | Clear both scroll planes via GameCommand #$1A ×2 (7 calls) |
| $005518 | SetScrollQuadrant | Tile grid lookup + scroll offset calculation (7 calls) |
| $00643C | DrawCharInfoPanel | Character info display: LZ decompress, portrait, tiles, text (6 calls) |
| $0074F8 | CountMatchingChars | Walk player roster counting stat matches (6 calls) |
| $00759E | FindCharSlot | Search roster for character by type, return slot or $FF (5 calls) |
| $00865E | CalcNegotiationPower | Character stat × compatibility + type distance adjustment (6 calls) |
| $00883A | PlaceCharSprite | LZ decompress character sprite from $95A22 table (5 calls) |
| $0092BC | CalcRevenue | 3-mode income calculation (compat/roster/network) (6 calls) |
| $00969A | CalcCharOutput | Multi-type stat calculation via $5E31A tables (5 calls) |
| $0109FA | SortWordPairs | Bubble sort array of (word,word) pairs by second field (5 calls) |
| $01A2CE | BrowsePartners | Interactive player browser with input loop (5 calls) |
| $01ACBA | DiagonalWipe | Screen transition via diagonal tile reveal, 2 modes (5 calls) |
| $01D8F4 | SetScrollOffset | Write X/Y scroll values to $FF5804 buffer (5 calls) |
| $020A64 | ShowGameScreen | Full screen load with 4 render phases (5 calls) |
| $0237A8 | ClearListArea | GameCommand #$1A clear 10×29 at row 17, col 1 (6 calls) |
| $006298 | ConfigScrollBar | Configure/clear scrolling display via $FFBDAC bitfield (5 calls) |
| $007390 | SetHighNibble | Mask byte+2 of record, set upper nibble (5 calls) |
| $007784 | SelectPreviewPage | 2-page preview with d-pad, VRAMBulkLoad, input loop (5 calls) |
| $007C3C | ShowCharProfile | Character display with portrait + text window (5 calls) |
| $008458 | CalcCharAdvantage | Competitive advantage from stat diff + player ranking (5 calls) |
| $008A4A | CharacterBrowser | Full-screen character selection UI with graphics + input (5 calls) |
| $008E0C | BrowseCharList | Character list navigation with stat display + cursor (5 calls) |
| $0090F4 | CalcStatChange | Attribute modification amount by mode, clamped (5 calls) |
| $009CEC | PlaceCursor | Selection cursor tile placement with optional animation (5 calls) |
| $009E1C | DrawPlayerRoutes | Player route icons on map from $FF0338 table (5 calls) |
| $0101CA | ShowPlayerChart | Player comparison chart overlay (5 calls) |
| $01B0CE | ShowCharStats | Character detail stats panel with formatted output (5 calls) |
| $021FD4 | CheckEventMatch | Event record search with 5 match modes (5 calls) |
| $02377C | DrawLabeledBox | DrawBox + PrintfWide wrapper (5 calls) |
| $027AA4 | CountActivePlayers | Count players with byte 0 == 1 (5 calls) |
| $005F00 | LoadTileGraphics | LZ decompress + tile placement from $AE0C4 table (3 calls) |
| $00769C | CalcCharRating | Stat-based character score centered at 50 (3 calls) |
| $007A74 | AdjustScrollPos | D-pad adjusts 2D scroll position with clamping (3 calls) |
| $009F88 | LoadSlotGraphics | Decompress graphics for character slot position (3 calls) |
| $010686 | FindBestCharacter | Scan slots for best character in highest-need category (3 calls) |
| $0108F2 | FindCharByValue | Find character with best/worst value in specific type (3 calls) |
| $018EBA | GetCharRelation | Return status code $760-$765 for player-character relationship (3 calls) |
| $01A672 | UpdateFlightSlots | Manage flight path slot assignments from bitfields (3 calls) |
| $01ABB0 | AnimateFlightPaths | Place animated sprites for active flight paths (3 calls) |
| $01AFCA | GetModeRowOffset | Simple lookup: mode 0-3 to row Y position (3 calls) |
| $01D37A | SetDisplayPage | Set high byte of display mode register $FF1274 (3 calls) |
| $01DE92 | LoadMapTiles | Decompress 3 map graphics, load tile grids (3 calls) |
| $01DFBE | PlaceFormattedTiles | Format + place tile block on screen (3 calls) |
| $01E16C | MemMoveWords | Direction-safe word-level memory copy (3 calls) |
| $0206EE | CalcCharProfit | Complex character income with compat + year bonus (4 calls) |
| $005060 | InitTileBuffer | Copy ROM $472CE to tile buffer $FF14BC, clear $FFA7DC |
| $00634A | SetScrollBarMode | Mode switch: clear/set $FFBDAC scroll bar params |
| $011906 | CalcRouteRevenue | Route revenue via CalcCharRating + SignedDiv, returns ×3 |
| $01819C | InitAllCharRecords | Loop 0-$58 calling InitCharRecord for each slot |
| $01A64C | ClearFlightSlots | GameCmd16 clear sprites, zero $FF153C flight buffer |
| $01B324 | MatchCharSlots | Cross-range character matching via RangeLookup + BitFieldSearch |
| $01D310 | RefreshAndWait | GameCommand #$E + #$14, return input bit |
| $01DC26 | DrawTilemapLine | Bresenham line drawing into tilemap buffer |
| $01E0FE | CopyAlternateBytes | Word-to-byte downsample copy (stride 2 to 1) |
| $01E1BA | StringAppend | strcat: find null terminator, append source string |
| $01E3EE | StringConcat | Stack calling convention wrapper for StringAppend |
| $023B6A | AnimateScrollEffect | 3-phase scroll animation with step variation, mod $100 |
| $035CCC | FindBestCharValue | Max char value from 16 records in quarter range |
| $03A7A0 | LoadGameGraphics | Bulk LZ decompress 90+100 entries + 4 DMA graphic loads |
| $03A8D6 | ResetGameState | Clear/init 17 game state variables to defaults |
| $004CB6 | DrawLayersReverse | Reverse-order (7→0) layer rendering via $4BC6 |
| $004D04 | DrawLayersForward | Forward-order (0→7) layer rendering via $4BC6 |
| $007B1E | HitTestMapTile | Coordinate hit-test vs $5E9FA/$5ECBC range table |
| $00818A | CheckCharCompat | CharCodeCompare result vs record threshold |
| $0081D2 | FindRelationRecord | Search $FF9A20 relation entries for char pair |
| $00FFF8 | CountCharPerformance | Scan routes, count char performance via CalcCharOutput |
| $01045A | SumPlayerStats | Sum 16 bytes from $FFB9E9 stat table |
| $01E346 | WeightedAverage | (a×d3 + b×d2) / (d2+d3) via Multiply32+UnsignedDivide |
| $022554 | CalcEventValue | $5FA2A table lookup or player stat sum mod $20 |
| $023A8A | DecompressTilePair | LZ_Decompress 2 assets to $FF1804/$FF3804 |
| $023B10 | TogglePageDisplay | XOR-toggle page buffer + VRAMBulkLoad + PollAction loop |
| $023D80 | RunTransitionSteps | 3× subroutine call with $023E04 delays |
| $023DB6 | UpdateIfActive | Conditional $023E04 call if $FF000A nonzero |
| $0377C8 | ClearCharSprites | GameCmd16 wrapper: clear with #4/#$37 |
| $038544 | CheckMatchSlots | Scan $FF8804 for non-$FF slot, return 1/0 |
| $005EDE | FillSequentialWords | Fill buffer with sequential word values (d1, d1+1, d1+2...) |
| $009C9E | UpdateSlotDisplays | Loop 4 slots calling $9A88, skip slot d4, then call d4 |
| $00EFC8 | UnpackPixelData | Extract 2-bit pixels from bytes to $FF05C4 buffer |
| $00F086 | CopyRouteFields | 4× MemCopy to $FF09C2/CA/CE/D6 from sequential source |
| $00FEDA | CheckCharEligible | Quarter + char range + CalcTypeDistance eligibility check |
| $0177C4 | DrawDualPanels | Two DrawBox calls + $F104 setup at different positions |
| $01A468 | ScanRouteSlots | Iterate 4 route slots with type match via RangeLookup |
| $01E14A | ToUpperCase | Convert character 'a'-'z' to uppercase |
| $026270 | CalcPlayerWealth | Sum player fields from $FF0018/$FF0290/$FF03F0 tables |
| $028EBE | WriteEventField | $5FAB6 record lookup, write byte to $FF1298 or $FF99A4 |
| $02F430 | ShowCharInfoPage | SetTextWindow + DrawCharInfoPanel + optional preview |
| $02F4EE | CalcCharScore | Quarter-based char field × score / 100 |
| $03AAF4 | SetCursorY | Write stack arg to $FFBDA6 cursor_y |
| $03AAFE | SetCursorX | Write stack arg to $FF128A cursor_x |
| $03CB36 | ShowPlayerScreen | ResourceLoad + display setup + menu dispatch |
| $009F48 | NopStub | Empty function (just RTS) |
| $01E0E0 | CopyBytesToWords | Copy bytes to word-aligned positions (stride-2 dest) |
| $028B46 | RunEventSequence | ClearTileArea + 5 sequential event subroutines |
| $010492 | SumStatBytes | Sum 16 bytes from $FFB9E8[player*32+i*2] |
| $0140DC | CalcQuarterBonus | Quarter-adjusted percentage: (quarter/4+30)*input*20/100 |
| $01A60E | InitFlightDisplay | DrawTileGrid + GameCmd16 + MemFillByte flight buffer |
| $027184 | CountRouteFlags | Count set bits in $FF08EC[player] 32-bit mask, minus 1 |
| $007A24 | CheckBitField | RangeLookup + $FFA6A0/$5ECDC bitmask test |
| $0232B6 | ClassifyEvent | Map event codes to categories 1-5 |
| $0225B8 | SetupEventUI | Event display setup with MenuSelectEntry dispatch |
| $00F552 | VerifyChecksum | CopyAlternateBytes + ByteSum checksum comparison |
| $007728 | FindSlotByChar | Search $FF0420/$FF0460 records for character match |
| $02949A | InitQuarterEvent | Quarter table lookup to $FFBD4C/$FF1294 + CheckEventMatch |
| $02F548 | FindCharSlotInGroup | Search $FF02E8 group for matching/empty character slot |
| $0104CA | CountProfitableRelations | Count $FF9A20 relations where revenue > cost |
| $004BC6 | FadePalette | Layer palette fade with 8-iteration loop (3 calls) |
| $005C64 | DrawTileStrip | Tile strip drawing with offset calculation (3 calls) |
| $0098D2 | DrawRouteLines | Draw route connection lines between cities (3 calls) |
| $009994 | DrawRoutePair | Draw paired route display with labels (3 calls) |
| $00D6BE | RunPlayerTurn | Execute single player's turn logic (3 calls) |
| $00FDC4 | FindOpenSlot | Search player/route tables for open slot (3 calls) |
| $00FF76 | CountUnprofitableRoutes | Count routes with negative profitability (3 calls) |
| $0102CE | CalcTotalCharValue | Sum character values across all slots (3 calls) |
| $0103B0 | CalcPlayerFinances | Calculate player financial summary (3 calls) |
| $017CE6 | UpdateSlotEvents | Process slot-based event updates (3 calls) |
| $01AFF0 | DrawCharDetailPanel | Character detail panel with stats display (3 calls) |
| $023C9A | AnimateScrollWipe | Animated scroll wipe transition effect (3 calls) |
| $027F18 | BuildRouteLoop | Construct route loop from waypoints (3 calls) |
| $02A738 | RunAITurn | Execute AI player turn logic (3 calls) |
| $0357FE | ApplyCharBonus | Apply character bonus to player stats (3 calls) |
| $0082E4 | InsertRelationRecord | Insert char pair into sorted relation table (3 calls) |
| $00957C | FindRelationIndex | Find relation entry index for char pair (3 calls) |
| $00A006 | RunScreenLoop | Screen interaction loop with display setup (3 calls) |
| $00F5AA | ProcessRouteAction | Route action with dialog and retry loop (3 calls) |
| $01052E | RankCharCandidates | Rank char candidates by compat and negotiation (3 calls) |
| $0119B4 | ProcessRouteChange | Route change with validation and UI (3 calls) |
| $011BB2 | UpdateRouteMask | Update route bitmask and process changes (3 calls) |
| $01801C | CalcCityCharBonus | City character bonus to stats (3 calls) |
| $01AEB8 | ShowPlayerCompare | Two-player comparison UI with input (3 calls) |
| $021E5E | ProcessTradeAction | 5-mode trade action with jump table (3 calls) |
| $0262E4 | CalcPlayerRankings | Compute player rankings by comparing stats (3 calls) |
| $02C9C8 | RunPurchaseMenu | Purchase/acquisition menu loop (3 calls) |
| $03204A | RunAIStrategy | AI strategic decision pipeline (3 calls) |
| $0332DE | FindBestCharForSlot | Best char for slot by compat and profit (3 calls) |
| $0366D0 | CollectCharRevenue | Collect revenue from assigned chars (3 calls) |
| $004342 | DecompressVDPTiles | LZ/huffman decompressor with VDP direct writes (3 calls) |
| $005CFE | RenderTileStrip | Tile strip rendering with GameCommand partial strip XOR (3 calls) |
| $007D92 | ShowCharDetail | Character detail display with LZ graphics and stats (3 calls) |
| $00E152 | CollectPlayerChars | Scan route/player slots collecting chars for player (3 calls) |
| $00E6B2 | ShowCharCompare | Two-character comparison display with stats (3 calls) |
| $010AB6 | RunPlayerSelectUI | 4-player selection UI with d-pad navigation (3 calls) |
| $016F9E | RunGameMenu | Menu with DisplaySetup, LZ graphics, 5-case jump table (3 calls) |
| $017566 | BrowseMapPages | Map page browser with cursor navigation (3 calls) |
| $018F8E | BrowseRelations | 4-player relation browser with input navigation (3 calls) |
| $01E98E | CalcCityStats | City stat calculator with sort top-3 to $FFBDE4 (3 calls) |
| $02F712 | ShowQuarterReport | Quarter financial report with jump table (3 calls) |
| $032D7A | CalcRelationScore | Weighted relation value calculator with formulas (3 calls) |
| $034CC4 | RemoveCharRelation | Remove character from relation, update bitmasks (3 calls) |
| $036F12 | RecruitCharacter | Recruit character flow with dialog and negotiation (3 calls) |
| $03ACDC | RenderTextBlock | Text rendering engine with escape codes (=,R,E,G,W,M,P) (3 calls) |
| $00EB28 | PackSaveState | Save state packing to $FF1804 buffer (2 calls) |
| $00F104 | ShowRouteInfo | Route information display with DrawBox (2 calls) |
| $0112EE | ManageRouteSlots | Route slot management with RangeLookup (2 calls) |
| $012E92 | ShowQuarterSummary | Quarter summary display for current player (2 calls) |
| $014202 | ProcessCharActions | Character action processing (2 calls) |
| $016958 | RunAssignmentUI | Assignment UI with GameCommand (2 calls) |
| $018214 | ShowStatsSummary | Stats summary display with comparisons (2 calls) |
| $01861A | RunCharManagement | Character management screen (2 calls) |
| $019244 | FormatRelationDisplay | Relation display formatting (2 calls) |
| $019660 | FormatRelationStats | Relation stats formatting with PrintfWide (2 calls) |
| $0199FA | ShowRelationAction | Relation action display (2 calls) |
| $019DE6 | ShowRelationResult | Relation result display (2 calls) |
| $023EA8 | RunQuarterScreen | Quarter screen with GameCommand (2 calls) |
| $0271C6 | ShowGameStatus | Game status display with ResourceLoad (2 calls) |
| $029ABC | RunTurnSequence | Turn sequence with function table (2 calls) |
| $02BDB8 | ShowAnnualReport | Annual report with year calculation (2 calls) |
| $02C2FA | RunScenarioMenu | Scenario menu with function table (2 calls) |

### Interrupt Handlers

| Address | Name | Description |
|---------|------|-------------|
| $001480 | ExtInterrupt | EXT INT (Level 2) -- NOP + RTE, unused |
| $001484 | HBlankInt | H-INT (Level 4) -- HScroll raster effect |
| $0014E6 | VBlankInt | V-INT (Level 6) -- Main frame handler |

### V-INT Sub-handlers

| Address | Name | Trigger | Description |
|---------|------|---------|-------------|
| $00163E | DMA_Transfer | Flag $004B(A5) | DMA/VRAM transfer |
| $001660 | DisplayUpdate | Byte $0B2A(A5) | Display update |
| $000C38 | VInt_Sub1 | Byte $0BD4(A5) | Unknown |
| $0016CC | VInt_Sub2 | Word $0BCE(A5) | Unknown |
| $000B42 | ControllerRead | Byte $02FB(A5) | Controller/input read |
| $001346 | VInt_Handler1 | Bit 0 of $002B(A5) | Conditional handler |
| $001390 | VInt_Handler2 | Bit 1 of $002B(A5) | Conditional handler |
| $001404 | VInt_Handler3 | Bit 2 of $002B(A5) | Conditional handler |
| $00192E | ControllerPoll | Always | Controller polling |
| $0016D4 | SubsysUpdate1 | Always | Subsystem update (PC-relative) |
| $00175C | SubsysUpdate2 | Always | Subsystem update (PC-relative) |
| $001864 | SubsysUpdate3 | Always | Subsystem update (PC-relative) |
| $0018D0 | SubsysUpdate4 | Always | Subsystem update (PC-relative) |

### Exception Handlers

| Address | Name | Exception ID |
|---------|------|-------------|
| $000F84 | BusError | 2 |
| $000F8A | AddressError | 3 |
| $000F90 | IllegalInstr | 4 |
| $000F96 | ZeroDivide | 5 |
| $000F9C | ChkInstr | 6 |
| $000FA2 | TrapvInstr | 7 |
| $000FA8 | PrivilegeViol | 8 |
| $000FAE | Trace | 9 |
| $000FB4 | LineAEmulator | 10 |
| $000FBA | LineFEmulator | 11 |
| $000FC0 | Reserved_0C | 12 |
| $000FC6 | Reserved_0D | 13 |
| $000FCC | Reserved_0E | 14 |
| $000FD2 | Reserved_0F | 15 (falls through) |
| $000FD4 | ExceptionCommon | -- (common handler, calls $58EE then halts) |
| $000FE0 | ExceptionHalt | -- (infinite loop) |
| $0058EE | ErrorDisplay | -- (error display routine) |

### Math

| Address | Name | Description |
|---------|------|-------------|
| $03E05A | Multiply32_FromPtr | Alternate entry: load multiplier from (A0) |
| $03E05C | Multiply32 | 32x32->32 unsigned multiply via cross-product MULU.W (204 calls) |
| $03E086 | SignedDiv_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E08A | SignedDiv | Signed 32/32 divide, fast DIVS.W path + slow unsigned (169 calls) |
| $03E0C2 | UnsignedDiv_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E0C6 | UnsignedDivide | Unsigned 32/32 divide, D0=quotient D1=remainder |
| $03E0DE | UDiv_Overflow | Two-step 32/16 divide (quotient > 16 bits) |
| $03E0FE | UDiv_Full32 | Bit-by-bit 32/32 shift-subtract (16 iterations) |
| $03E126 | UnsignedMod_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E12A | UnsignedMod | Unsigned 32/32 modulo, D0=remainder |
| $03E142 | SignedMod_FromPtr | Alternate entry: load from (A0), swap D0/D1 |
| $03E146 | SignedMod | Signed 32/32 modulo, sign follows dividend (88 calls) |

### Compression

| Address | Name | Description |
|---------|------|-------------|
| $003FEC | LZ_Decompress | LZSS/LZ77 decompressor, 596 bytes (123 calls) |

### Text

| Address | Name | Description |
|---------|------|-------------|
| $03A942 | SetTextWindow | Define text window bounds: left/top/width/height (124 calls) |
| $03AB2C | SetTextCursor | Set text cursor X/Y position (174 calls) |
| $03B22C | sprintf | Format string to buffer, C-style varargs (171 calls) |
| $03B246 | PrintfNarrow | Format + display string, 1-tile narrow font (65 calls) |
| $03B270 | PrintfWide | Format + display string, 2-tile wide font (97 calls) |

### Sound

| Address | Name | Description |
|---------|------|-------------|
| $00260A | Z80_SoundInit | Load Z80 driver from ROM $2696 to Z80 RAM |
| $002662 | Z80_RequestBus | Request Z80 bus and wait for grant |
| $002678 | Z80_ReleaseBus | Release Z80 bus |
| $002688 | Z80_Delay | Delay loop (D0 = $18CE iterations) |

## Quick Lookup (flat, Ctrl+F friendly)

| Address | Name | Category | Calls | Status |
|---------|------|----------|-------|--------|
| $000200 | EntryPoint | boot | -- | named |
| $0002FA | GameInit | boot | -- | named |
| $00070A | HardwareInit | boot | -- | named |
| $000B42 | ControllerRead | vint | -- | named |
| $000C38 | VInt_Sub1 | vint | -- | named |
| $000CDC | WaitVBlank | boot | -- | named |
| $000D64 | GameCommand | game | 306 | translated |
| $000F84 | BusError | exception | -- | named |
| $000FD4 | ExceptionCommon | exception | -- | named |
| $001036 | VDP_Init1 | boot | -- | named |
| $001090 | Init6 | boot | -- | named |
| $0010DA | Init5 | boot | -- | named |
| $00101C | VDP_Init2 | boot | -- | named |
| $00107A | VDP_Init3 | boot | -- | named |
| $0010FE | VDP_Init4 | boot | -- | named |
| $001346 | VInt_Handler1 | vint | -- | named |
| $001390 | VInt_Handler2 | vint | -- | named |
| $001404 | VInt_Handler3 | vint | -- | named |
| $001480 | ExtInterrupt | interrupt | -- | named |
| $001484 | HBlankInt | interrupt | -- | named |
| $0014E6 | VBlankInt | interrupt | -- | named |
| $00163E | DMA_Transfer | vint | -- | named |
| $001660 | DisplayUpdate | vint | -- | named |
| $0016CC | VInt_Sub2 | vint | -- | named |
| $0016D4 | SubsysUpdate1 | vint | -- | named |
| $001760 | SubsysUpdate2 | vint | -- | named |
| $001864 | SubsysUpdate3 | vint | -- | named |
| $0018D4 | SubsysUpdate4 | vint | -- | named |
| $00192E | ControllerPoll | vint | -- | named |
| $00260A | Z80_SoundInit | sound | -- | named |
| $002662 | Z80_RequestBus | sound | -- | named |
| $002678 | Z80_ReleaseBus | sound | -- | named |
| $002688 | Z80_Delay | sound | -- | named |
| $003BE8 | EarlyInit | boot | -- | named |
| $003FEC | LZ_Decompress | compression | 123 | translated |
| $0045B2 | MemMove | memory | 19 | translated |
| $0045E6 | CmdPlaceTile2 | graphics | 23 | translated |
| $004668 | CmdPlaceTile | graphics | 46 | translated |
| $004CB6 | DrawLayersReverse | graphics | -- | translated |
| $004D04 | DrawLayersForward | graphics | -- | translated |
| $005060 | InitTileBuffer | game | -- | translated |
| $005092 | DisplaySetup | display | 101 | translated |
| $005EDE | FillSequentialWords | game | -- | translated |
| $0058FC | PlaceIconPair | game | 8 | translated |
| $0050E2 | DisplayInitRows | display | -- | translated |
| $005126 | DisplayInit15 | display | -- | translated |
| $005132 | DisplayInit0 | display | -- | translated |
| $00513C | DisplaySetupScaled | display | -- | translated |
| $005170 | DisplayTileSetup | display | -- | translated |
| $00538E | CmdSetBackground | graphics | 46 | translated |
| $005736 | PreGameInit | game | -- | named |
| $0058EE | ErrorDisplay | exception | -- | named |
| $006760 | FillTileRect | graphics | 17 | translated |
| $0068CA | LoadScreenGfx | graphics | 21 | translated |
| $006A2E | LoadScreen | game | 38 | translated |
| $00595E | PlaceIconTiles | graphics | 13 | translated |
| $005A04 | DrawBox | game | 42 | translated |
| $005F00 | LoadTileGraphics | graphics | 3 | translated |
| $005FF6 | LoadCompressedGfx | graphics | 7 | translated |
| $006298 | ConfigScrollBar | game | 5 | translated |
| $007728 | FindSlotByChar | game | -- | translated |
| $007A24 | CheckBitField | game | -- | translated |
| $007B1E | HitTestMapTile | game | -- | translated |
| $00634A | SetScrollBarMode | game | -- | translated |
| $006B78 | ShowRelPanel | game | 40 | translated |
| $006EEA | BitFieldSearch | game | 47 | translated |
| $006F42 | CharCodeCompare | game | 22 | translated |
| $0070DC | CharCodeScore | game | 12 | translated |
| $007158 | RangeMatch | game | 10 | translated |
| $0071DE | CharPairIndex | game | 1 | translated |
| $007390 | SetHighNibble | game | 5 | translated |
| $00769C | CalcCharRating | game | 3 | translated |
| $0073A6 | UpdateCharField | game | 8 | translated |
| $007402 | GetLowNibble | util | 20 | translated |
| $007412 | CalcCompatScore | game | 8 | translated |
| $007610 | CalcTypeDistance | game | 10 | translated |
| $007784 | SelectPreviewPage | game | 5 | translated |
| $007A74 | AdjustScrollPos | game | 3 | translated |
| $007C3C | ShowCharProfile | game | 5 | translated |
| $0074E0 | GetByteField4 | util | 36 | translated |
| $007912 | ShowDialog | game | 38 | translated |
| $00818A | CheckCharCompat | game | -- | translated |
| $0081D2 | FindRelationRecord | game | -- | translated |
| $008016 | CalcWeightedStat | game | 8 | translated |
| $008458 | CalcCharAdvantage | game | 5 | translated |
| $00814A | ClearBothPlanes | graphics | 15 | translated |
| $008A4A | CharacterBrowser | game | 5 | translated |
| $008E0C | BrowseCharList | game | 5 | translated |
| $0088EA | DrawStatDisplay | display | 11 | translated |
| $0090F4 | CalcStatChange | game | 5 | translated |
| $009C9E | UpdateSlotDisplays | game | -- | translated |
| $009F48 | NopStub | game | -- | translated |
| $009CEC | PlaceCursor | game | 5 | translated |
| $009D92 | GetCharStat | game | 14 | translated |
| $009DC4 | FindBitInField | game | 7 | translated |
| $009E1C | DrawPlayerRoutes | game | 5 | translated |
| $009F88 | LoadSlotGraphics | graphics | 3 | translated |
| $009F4A | SelectMenuItem | game | 14 | translated |
| $00FFF8 | CountCharPerformance | game | -- | translated |
| $0100F2 | LoadScreenPalette | game | 7 | translated |
| $0101CA | ShowPlayerChart | game | 5 | translated |
| $010492 | SumStatBytes | game | -- | translated |
| $0104CA | CountProfitableRelations | game | -- | translated |
| $01045A | SumPlayerStats | game | -- | translated |
| $0140DC | CalcQuarterBonus | game | -- | translated |
| $0177C4 | DrawDualPanels | game | -- | translated |
| $01A468 | ScanRouteSlots | game | -- | translated |
| $01A60E | InitFlightDisplay | game | -- | translated |
| $010686 | FindBestCharacter | game | 3 | translated |
| $0108F2 | FindCharByValue | game | 3 | translated |
| $011906 | CalcRouteRevenue | game | -- | translated |
| $01183A | ShowTextDialog | game | 31 | translated |
| $018EBA | GetCharRelation | game | 3 | translated |
| $0181C6 | InitCharRecord | game | 11 | translated |
| $01819C | InitAllCharRecords | game | -- | translated |
| $01A506 | CalcRelationValue | game | 7 | translated |
| $01A64C | ClearFlightSlots | game | -- | translated |
| $01A672 | UpdateFlightSlots | game | 3 | translated |
| $01ABB0 | AnimateFlightPaths | game | 3 | translated |
| $01AFCA | GetModeRowOffset | game | 3 | translated |
| $01B0CE | ShowCharStats | game | 5 | translated |
| $01B324 | MatchCharSlots | game | -- | translated |
| $01B49A | GameUpdate2 | game | -- | named |
| $01D310 | RefreshAndWait | display | -- | translated |
| $01D340 | SetDisplayMode | display | 7 | translated |
| $01D37A | SetDisplayPage | display | 3 | translated |
| $01D3AC | MenuSelectEntry | game | 14 | translated |
| $01C43C | ShowPlayerInfo | display | 12 | translated |
| $01D444 | LoadDisplaySet | game | 16 | translated |
| $01D520 | MemFillByte | util | 71 | translated |
| $01D538 | MemCopy | util | -- | translated |
| $01D550 | MemFillWord | util | -- | translated |
| $01DC26 | DrawTilemapLine | graphics | -- | translated |
| $01DE92 | LoadMapTiles | graphics | 3 | translated |
| $01DFBE | PlaceFormattedTiles | graphics | 3 | translated |
| $01D568 | VRAMBulkLoad | graphics | 46 | translated |
| $01D62C | PollAction | game | 65 | translated |
| $01D6A4 | RandRange | math | 64 | translated |
| $01D6FC | ByteSum | util | -- | translated |
| $01D71C | ResourceLoad | game | 106 | translated |
| $01D748 | ResourceUnload | game | 95 | translated |
| $01D7BE | DrawTileGrid | graphics | 14 | translated |
| $00E08E | CalcCharValue | game | 18 | translated |
| $00EFC8 | UnpackPixelData | graphics | -- | translated |
| $00F086 | CopyRouteFields | game | -- | translated |
| $00F552 | VerifyChecksum | game | -- | translated |
| $00FEDA | CheckCharEligible | game | -- | translated |
| $01E044 | TilePlacement | graphics | 100 | translated |
| $01E0B8 | GameCmd16 | game | 77 | translated |
| $01E0FE | CopyAlternateBytes | memory | -- | translated |
| $01E1BA | StringAppend | util | -- | translated |
| $01E16C | MemMoveWords | memory | 3 | translated |
| $01E0E0 | CopyBytesToWords | memory | -- | translated |
| $01E14A | ToUpperCase | util | -- | translated |
| $01E346 | WeightedAverage | math | -- | translated |
| $01E3EE | StringConcat | util | -- | translated |
| $01E1EC | ReadInput | input | 95 | translated |
| $01E290 | ProcessInputLoop | input | 42 | translated |
| $01E11C | MulDiv | math | 13 | translated |
| $01E2F4 | PollInputChange | input | 18 | translated |
| $01E398 | PreLoopInit | game | 57 | translated |
| $01E402 | GameUpdate3 | game | -- | named |
| $0213B6 | GameLogic1 | game | -- | named |
| $026128 | GameUpdate4 | game | -- | named |
| $026270 | CalcPlayerWealth | game | -- | translated |
| $027184 | CountRouteFlags | game | -- | translated |
| $028B46 | RunEventSequence | game | -- | translated |
| $028EBE | WriteEventField | game | -- | translated |
| $02947A | GameLogic2 | game | -- | named |
| $023930 | ClearInfoPanel | graphics | 11 | translated |
| $0238F0 | InitInfoPanel | game | 9 | translated |
| $023958 | AnimateInfoPanel | game | 9 | translated |
| $023A34 | PlaceItemTiles | game | 9 | translated |
| $02949A | InitQuarterEvent | game | -- | translated |
| $02F430 | ShowCharInfoPage | game | -- | translated |
| $02F4EE | CalcCharScore | game | -- | translated |
| $02F548 | FindCharSlotInGroup | game | -- | translated |
| $02FBD6 | ShowText | game | 37 | translated |
| $02F5A6 | GameUpdate1 | game | -- | named |
| $03AAF4 | SetCursorY | text | -- | translated |
| $03AAFE | SetCursorX | text | -- | translated |
| $03A5A8 | ShowCharPortrait | game | 8 | translated |
| $03A942 | SetTextWindow | text | 124 | translated |
| $03A9AC | ClearTileArea | game | 8 | translated |
| $03AB2C | SetTextCursor | text | 174 | translated |
| $03B22C | sprintf | text | 171 | translated |
| $03B246 | PrintfNarrow | text | 65 | translated |
| $03B270 | PrintfWide | text | 97 | translated |
| $03B428 | GameSetup1 | game | -- | named |
| $03CA4E | GameSetup2 | game | -- | named |
| $03E05A | Multiply32_FromPtr | math | -- | translated |
| $03E05C | Multiply32 | math | 204 | translated |
| $03E086 | SignedDiv_FromPtr | math | -- | translated |
| $03E08A | SignedDiv | math | 169 | translated |
| $03E0C2 | UnsignedDiv_FromPtr | math | -- | translated |
| $03E0C6 | UnsignedDivide | math | -- | translated |
| $03E0DE | UDiv_Overflow | math | -- | translated |
| $03E0FE | UDiv_Full32 | math | -- | translated |
| $03E126 | UnsignedMod_FromPtr | math | -- | translated |
| $03E12A | UnsignedMod | math | -- | translated |
| $03E142 | SignedMod_FromPtr | math | -- | translated |
| $03E146 | SignedMod | math | 88 | translated |
| $00D5B6 | GameEntry | game | -- | named |
| $00D602 | GameLoopSetup | game | -- | named |
| $00D608 | MainLoop | game | -- | named |
| $00D648 | RangeLookup | game | 114 | translated |
| $0053BA | ClearScreen | display | 7 | translated |
| $005518 | SetScrollQuadrant | display | 7 | translated |
| $00643C | DrawCharInfoPanel | game | 6 | translated |
| $0074F8 | CountMatchingChars | game | 6 | translated |
| $00759E | FindCharSlot | game | 5 | translated |
| $00865E | CalcNegotiationPower | game | 6 | translated |
| $00883A | PlaceCharSprite | graphics | 5 | translated |
| $0092BC | CalcRevenue | game | 6 | translated |
| $00969A | CalcCharOutput | game | 5 | translated |
| $0109FA | SortWordPairs | util | 5 | translated |
| $01A2CE | BrowsePartners | game | 5 | translated |
| $01ACBA | DiagonalWipe | display | 5 | translated |
| $01D8F4 | SetScrollOffset | display | 5 | translated |
| $0206EE | CalcCharProfit | game | 4 | translated |
| $022554 | CalcEventValue | game | -- | translated |
| $0225B8 | SetupEventUI | game | -- | translated |
| $0232B6 | ClassifyEvent | game | -- | translated |
| $023A8A | DecompressTilePair | graphics | -- | translated |
| $023B10 | TogglePageDisplay | display | -- | translated |
| $023B6A | AnimateScrollEffect | display | -- | translated |
| $023D80 | RunTransitionSteps | display | -- | translated |
| $023DB6 | UpdateIfActive | game | -- | translated |
| $020A64 | ShowGameScreen | display | 5 | translated |
| $021FD4 | CheckEventMatch | game | 5 | translated |
| $02377C | DrawLabeledBox | game | 5 | translated |
| $0237A8 | ClearListArea | display | 6 | translated |
| $027AA4 | CountActivePlayers | game | 5 | translated |
| $035CCC | FindBestCharValue | game | -- | translated |
| $0377C8 | ClearCharSprites | game | -- | translated |
| $038544 | CheckMatchSlots | game | -- | translated |
| $03A7A0 | LoadGameGraphics | game | -- | translated |
| $03A8D6 | ResetGameState | game | -- | translated |
| $03CB36 | ShowPlayerScreen | game | -- | translated |
| $004BC6 | FadePalette | graphics | -- | translated |
| $005C64 | DrawTileStrip | graphics | -- | translated |
| $0098D2 | DrawRouteLines | game | -- | translated |
| $009994 | DrawRoutePair | game | -- | translated |
| $00D6BE | RunPlayerTurn | game | -- | translated |
| $00FDC4 | FindOpenSlot | game | -- | translated |
| $00FF76 | CountUnprofitableRoutes | game | -- | translated |
| $0102CE | CalcTotalCharValue | game | -- | translated |
| $0103B0 | CalcPlayerFinances | game | -- | translated |
| $017CE6 | UpdateSlotEvents | game | -- | translated |
| $01AFF0 | DrawCharDetailPanel | game | -- | translated |
| $023C9A | AnimateScrollWipe | display | -- | translated |
| $027F18 | BuildRouteLoop | game | -- | translated |
| $02A738 | RunAITurn | game | -- | translated |
| $0357FE | ApplyCharBonus | game | -- | translated |
| $0082E4 | InsertRelationRecord | game | -- | translated |
| $00957C | FindRelationIndex | game | -- | translated |
| $00A006 | RunScreenLoop | game | -- | translated |
| $00F5AA | ProcessRouteAction | game | -- | translated |
| $01052E | RankCharCandidates | game | -- | translated |
| $0119B4 | ProcessRouteChange | game | -- | translated |
| $011BB2 | UpdateRouteMask | game | -- | translated |
| $01801C | CalcCityCharBonus | game | -- | translated |
| $01AEB8 | ShowPlayerCompare | game | -- | translated |
| $021E5E | ProcessTradeAction | game | -- | translated |
| $0262E4 | CalcPlayerRankings | game | -- | translated |
| $02C9C8 | RunPurchaseMenu | game | -- | translated |
| $03204A | RunAIStrategy | game | -- | translated |
| $0332DE | FindBestCharForSlot | game | -- | translated |
| $0366D0 | CollectCharRevenue | game | -- | translated |
| $004342 | DecompressVDPTiles | graphics | -- | translated |
| $005CFE | RenderTileStrip | graphics | -- | translated |
| $007D92 | ShowCharDetail | game | -- | translated |
| $00E152 | CollectPlayerChars | game | -- | translated |
| $00E6B2 | ShowCharCompare | game | -- | translated |
| $010AB6 | RunPlayerSelectUI | game | -- | translated |
| $016F9E | RunGameMenu | game | -- | translated |
| $017566 | BrowseMapPages | game | -- | translated |
| $018F8E | BrowseRelations | game | -- | translated |
| $01E98E | CalcCityStats | game | -- | translated |
| $02F712 | ShowQuarterReport | game | -- | translated |
| $032D7A | CalcRelationScore | game | -- | translated |
| $034CC4 | RemoveCharRelation | game | -- | translated |
| $036F12 | RecruitCharacter | game | -- | translated |
| $03ACDC | RenderTextBlock | text | -- | translated |
| $00EB28 | PackSaveState | game | -- | translated |
| $00F104 | ShowRouteInfo | game | -- | translated |
| $0112EE | ManageRouteSlots | game | -- | translated |
| $012E92 | ShowQuarterSummary | game | -- | translated |
| $014202 | ProcessCharActions | game | -- | translated |
| $016958 | RunAssignmentUI | game | -- | translated |
| $018214 | ShowStatsSummary | game | -- | translated |
| $01861A | RunCharManagement | game | -- | translated |
| $019244 | FormatRelationDisplay | game | -- | translated |
| $019660 | FormatRelationStats | game | -- | translated |
| $0199FA | ShowRelationAction | game | -- | translated |
| $019DE6 | ShowRelationResult | game | -- | translated |
| $023EA8 | RunQuarterScreen | game | -- | translated |
| $0271C6 | ShowGameStatus | game | -- | translated |
| $029ABC | RunTurnSequence | game | -- | translated |
| $02BDB8 | ShowAnnualReport | game | -- | translated |
| $02C2FA | RunScenarioMenu | game | -- | translated |
