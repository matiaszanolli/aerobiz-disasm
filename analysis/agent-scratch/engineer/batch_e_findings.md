# Batch E Function Description Findings

**Task:** B-055 Batch E
**Date:** 2026-02-26
**File:** `disasm/sections/section_000200.asm`
**Functions described:** 83

---

## Summary

All 83 Batch E function descriptions were applied successfully. Build verified (exit 0, byte-identical output confirmed by prior session). No assembly code was modified -- only comment header lines were changed.

---

## Function Descriptions Applied

### Character Management Group ($008016–$009F47)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| CalcWeightedStat | $008016 | Look up stat via GetCharStat, apply weighted multiplier from table, scale and clamp result |
| CalcAffinityScore | $0080D0 | Iterate event records, accumulate entity affinity scores, return 1 if weighted total reaches 50 percent |
| CheckCharCompat | $00818A | Call FindRelationRecord for two cities, compare returned score against compatibility threshold |
| FindRelationRecord | $0081D2 | Search player route slots for a bidirectional city-pair match, return slot pointer or 0 |
| InsertRelationRecord | $0082E4 | Insert new route entry into sorted player route array, shifting existing entries via memory copy |
| CalcCharAdvantage | $008458 | Compute character advantage score from player ranking, city traffic stats, entity bitfield, and stat descriptors |
| CalcNegotiationPower | $00865E | Compute negotiation power from two stat descriptors, win_bottom scaling, and route type bonus |
| PlaceCharSprite | $00883A | Look up character sprite index from stat table, decompress portrait, and place sprite on screen |
| CharacterBrowser | $008A4A | Full scrollable character browser UI: handles region/category navigation, stat display, and selection confirmation |
| BrowseCharList | $008E0C | Scrollable character list loop with up/down navigation, stat preview on hover, and confirm or cancel |
| CalcStatChange | $0090F4 | Compute stat point delta for an event type and current value with category-specific scaling limits |

### Route System Group ($0092BC–$009F47)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| CalcRevenue | $0092BC | Accumulate total route revenue for a player scaled by flight frequency, popularity, and ticket price |
| FindRelationIndex | $00957C | Find route slot index by city pair in player array, return slot index or $FF if not found |
| CalcCharOutput | $00969A | Compute character productivity for a route and time slot using stat descriptors, region params, and scenario scaling |
| DrawRouteLines | $0098D2 | Draw color-coded route lines between city map positions for all of a player's active routes |
| DrawRoutePair | $009994 | Draw one or two line segments between two city screen positions with profitability color coding |
| ProcessCharRoster | $009A88 | Draw route arcs on the world map for all domestic and international routes of a player |
| UpdateSlotDisplays | $009C9E | Redraw route map display for all players except one, then redraw the designated player |
| PlaceCursor | $009CEC | Place cursor tile at (x,y), optionally placing a second cursor tile for two-player mode |
| FindBitInField | $009DC4 | Scan bitfield_tab longword for first set bit of a given entity type, return global bit index or $FF |
| DrawPlayerRoutes | $009E1C | Draw up to 4 numbered route assignment markers on the world map for a player |
| NopStub | $009F48 | Empty stub function returning immediately (RTS only) |

### Game Initialization Group ($00A006–$00B74B)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| RunScreenLoop | $00A006 | Main game screen state machine loop: process actions, load graphics packs, dispatch to UI screen handlers |
| InitGameDatabase | $00A156 | Show new game setup screen, let player choose player count (1 or 2), return selection |
| LoadScenarioState | $00A2D4 | Orchestrate scenario setup: run selection, model stats, portfolio, player select, aircraft stats, and purchase screens |
| InitDefaultScenario | $00A526 | Copy default scenario data block from ROM to RAM and set initial game parameters |
| HandleScenarioTurns | $00A5E4 | Display scenario selection menu for all 4 players with navigation and confirmation, return chosen scenario index |
| RunPortfolioManagement | $00AB1C | Reset player records, display portfolio options menu, handle cursor navigation and player count confirmation |
| DisplayModelStats | $00AD02 | Show aircraft model names and numbers in a table, handle scrolling selection of aircraft type |
| PlacePlayerNameLabels | $00AF2E | Place name tile labels for each active player at their hub city position on the map |
| ProcessPlayerSelectInput | $00B042 | Assign hub cities to all 4 player slots (human via UI, AI via random valid selection), build name strings |
| WaitForKeyPress | $00B1E6 | Loop selecting random aircraft/city indices until finding one valid for player count and region constraints |
| GetPlayerModelSelect | $00B2FA | Determine AI opponent hub city for single-player games based on player count and existing selection |
| RunModelSelectUI | $00B3F4 | Full player hub city selection screen: show map with labels, select via BrowseCharList, confirm via dialog |
| InitAllGameTables | $00B74C | Zero all major game RAM regions (player records, route slots, char stats, city data) and init route slot sentinels |

### Aircraft Management Group ($00BA3E–$00C68A)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| ComputeDividends | $00BA3E | Divide 16 dividend table values at $FFA6BA by 10 to compute period payout amounts |
| RunAircraftPurchase | $00BA7E | Initialize all players financial state: starting cash, accumulators, char stat tables, routes; call aircraft sort and cost routines |
| ComputeMonthlyAircraftCosts | $00BC84 | Compute per-player monthly aircraft operating costs from hub city, aircraft class stats, and scenario multipliers |
| ComputeAircraftSpeedDisp | $00C070 | Fill speed and capacity display values for a player aircraft type into the $FFB9E8 scheduling table |
| RunAircraftStatsDisplay | $00C1AC | Display all 4 players aircraft type and hub city in a formatted stats panel, wait for confirm or back input |
| PollSingleButtonPress | $00C392 | Display a prompt message via DisplayMessageWithParams and return the button press result |
| RunAircraftParamShuffle | $00C3B4 | Randomize character stat entries for each player using region lookup and stat descriptor tables |
| SortAircraftByMetric | $00C540 | Sort 16 aircraft entries by region-specific metric and write ranked order to $FF1278 |
| DisplayMessageWithParams | $00C61E | Draw a character info panel with formatted message, optionally calling SelectPreviewPage or PollAction |
| BuildAircraftAttrTable | $00C68A | Copy aircraft attribute tables from ROM to RAM, interpolating between scenario variants per player count |

### Data Loading and Events Group ($00C860–$00D415)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| ScaleAircraftAttrValue | $00C860 | Linearly interpolate one aircraft attribute between two scenario boundary values based on scenario index |
| RunDestSelectLoop | $00C8B2 | Handle map destination selection input loop: d-pad navigation over region/sub-region grid, confirm or cancel |
| LoadAllGameData | $00CA3E | Load game save state from cartridge SRAM, unpack header fields (player count, scenario, frame counter) into work RAM |
| InitPlayerAircraftState | $00CEEA | Initialize runtime route slot fields for all players: revenue, passenger count, city traffic, compatibility scores |
| UpdateEventSchedule | $00D20E | Scan 55 scheduled events from ROM table, call WriteEventField for each whose trigger frame has been reached |
| WaitForEventInput | $00D24C | Loop calling DisplayEventChoice until player confirms; if assignment flag set, also run RunAssignmentUI |
| DisplayEventChoice | $00D28C | Show event dialog with choice tiles, handle scrolling selection input, return chosen option index |

### Main Game Loop Group ($00D416–$00DA97)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| InitGameGraphicsMode | $00D416 | Set VDP display mode, configure scroll planes, build tile table, set input_mask, initialize tile buffer |
| ClearDisplayBuffers | $00D500 | Clear both VDP scroll planes, then reload map tiles and game graphics |
| InitGameAudioState | $00D558 | Initialize sound flags, RNG seed to 33, scrollbar data, ui_active_flag, and send sound driver enable command |
| RunPlayerTurn | $00D6BE | Read current player, loop dispatching ProcessPlayerTurnAction per action; call end-of-turn handler on $FF action |
| ProcessPlayerTurnAction | $00D764 | Handle one player turn action: load screen, show char info, evaluate value, confirm purchase and deduct cost |
| SelectRouteDestination | $00DA98 | Show route selection dialog, call BrowseCharList for destination pick, validate against session block, loop until done |
| DisplayRouteDestChoice | $00DB72 | Display selectable destination slots for a route type, handle scrolling navigation and selection input |

### Player Comparison and Character Value Group ($00E08E–$00E6B1)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| CollectPlayerChars | $00E152 | Collect and sort purchasable characters for player filtered by ownership and stat range, calling CalcCharValue for each |
| DrawPlayerComparisonStats | $00E344 | Display comparison rows for up to 5 characters showing portrait, city/char type, and computed value |
| RunPlayerStatCompareUI | $00E4AA | Run the player stat comparison screen with scrollable list navigation |
| ShowCharCompare | $00E6B2 | Display character comparison panel: compute output and value, show stats, portrait, delta, and return win/lose flag |

### Route Event and Save/Load Group ($00E8AA–$00F521)

| Function | ROM Address | Description |
|----------|-------------|-------------|
| ProcessRouteEventLogic | $00E8AA | Handle route event: collect available chars, show comparison UI, confirm purchase or decline, update player record |
| HandleDestArrival | $00EA86 | Decompress and place destination arrival tile graphic at specified screen position with palette attribute |
| PackSaveState | $00EB28 | Serialize all game state regions (player records, routes, chars, city data) into a packed buffer for SRAM save |
| ExecPassengerLoadUnload | $00EF92 | Pack char_stat_array bytes into output buffer (4 per source byte, 2-bit wide), return end pointer |
| UnpackPixelData | $00EFC8 | Unpack 2-bit packed pixel data from ROM source into byte-per-pixel array at $FF05C4 (57 bytes per player) |
| ProcessAirportTransact | $00F008 | Unpack save buffer fields into work RAM regions $FF09C2, $FF09CA, $FF09CE, $FF09D6, return end pointer |
| CopyRouteFields | $00F086 | Copy work RAM fields $FF09C2, $FF09CA, $FF09CE, $FF09D6 to output buffer in sequence, return end pointer |
| ShowRouteInfo | $00F104 | Display route information panel: show player slot details, city/char names, route stats, and price/category labels |
| UpdatePassengerDemand | $00F522 | Compute byte sum of demand table starting at $FF1804+6, store result and input value into header fields |
| VerifyChecksum | $00F552 | Load save buffer from SRAM, compute checksum, compare against stored value, return 1 if valid or 0 if corrupt |
| ProcessRouteAction | $00F5AA | Show route management screen, prompt player for action type, execute buy/assign/cancel, update route records |
| ComputeRouteProfit | $00F722 | Compute route profit eligibility by ANDing region mask against active bitfield and excluding blocked entities |
| CalcOptimalTicketPrice | $00F75E | Compute optimal ticket price from char stats and player cash, show purchase dialog, deduct cost if confirmed |
| SubmitTurnResults | $00FB74 | Evaluate player region match and bitfield, format result message, show turn outcome dialog |
| AdvanceToNextMonth | $00FCAC | Search bitfield for available route slot, prompt player to confirm or skip, update route mask and reload screen |
| FindOpenSlot | $00FDC4 | Search player's domestic and international char slots for one whose value is below player cash, return 1 if found |
| CheckCharEligible | $00FEDA | Check if a char entry is within active contract period and region-compatible with player hub city, return 1 if eligible |
| CountUnprofitableRoutes | $00FF76 | Count unprofitable routes for a player; return -1 if no routes, -2 if no established routes, else count |
| CountCharPerformance | $00FFF8 | Evaluate character performance metrics across player routes; compute aggregate productivity score |

---

## Notes

- `LoadSlotGraphics` at line 13494 had no TODO and already had a description -- confirmed skipped (already described in prior batch).
- `sub_0082E4` has label `InsertRelationRecord` in the code; the header comment still referenced `sub_0082E4` and was updated accordingly.
- `sub_00957C` has label `FindRelationIndex` in the code; updated similarly.
- `sub_00F5AA` has label `ProcessRouteAction` in the code; updated accordingly.
- `ExecPassengerLoadUnload` and `UnpackPixelData` are a symmetric pair: Unpack expands 2-bit data to bytes, ExecPassengerLoadUnload repacks bytes to 2-bit. They are inverses used for SRAM compression.
- `PackSaveState` is the main save serializer; it calls both `ExecPassengerLoadUnload` ($00EF92) and `ProcessAirportTransact` ($00F008) as sub-serializers.
- `ProcessRouteEventLogic` and `ProcessRouteAction` both handle route-event flow but at different levels: ProcessRouteEventLogic is the high-level handler (collect chars, compare, confirm); ProcessRouteAction manages the lower-level route action menu.
- `WaitForKeyPress` (name is misleading): it actually loops picking random valid city indices for AI opponents, not literally waiting for a key.
- `CopyRouteFields` and `ProcessAirportTransact` have nearly identical structure (same RAM regions, same call pattern) but differ in argument order -- they are load and save counterparts for the same sub-region.

---

## Build Verification

Build ran successfully (exit 0) after all 83 description-only comment changes.
