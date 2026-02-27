# B-057 Batch 4 — Function Descriptions: section_020000.asm (lines 1–8000)

Engineer findings. One-line descriptions for all 93 functions in this batch.

---

## Function Descriptions

| Line | Function | Description |
|------|----------|-------------|
| 13 | CalcTradeGains | Calculate net trade gains for a route slot by scoring char-code compatibility, multiplying by slot value, and applying a signed division. |
| 327 | GetRouteSlotDetails | Compute route slot pointer and active occupancy count for a given player/slot index, applying random selection bounded by slot field 3. |
| 416 | CalcSlotValue | Sum the star ratings of all characters currently assigned to a route slot by iterating occupancy entries and looking up char stat table. |
| 507 | ValidateTradeReq | Validate a trade request by checking $FF09C2 records for type 3/4 codes and comparing char type values via the D648 lookup. |
| 573 | PrepareTradeOffer | Iterate a player's route slots, compute per-slot revenue via CalcCharProfit, and accumulate totals into the player record financial fields. |
| 669 | CalcCharProfit | Calculate profit for a character on a route incorporating char stats, morale, compatibility multiplier chain, and random variance. |
| 835 | UpdateRouteFieldValues | Recalculate route output and revenue for all players by calling CalcCharOutput on every active slot and accumulating results into $FF09A2. |
| 954 | UpdateGameStateCounters | Age time-limited game state counter records at $FF0338, decrementing each type-6 counter and clearing the record when it reaches zero. |
| 987 | ShowGameScreen | Render the main game screen: decompress graphics, place tiles, initialize route display panel, quarterly grid, and conditionally the relation panel. |
| 1054 | InitializeRouteDisplay | Initialize and render the route display panel for a character slot, including portrait, stat bars, name/type text, city bonus, and route event graphic. |
| 1237 | RenderRouteUIElements | Render the UI frame elements for a character's route panel: LZ_Decompress base graphic, TilePlacement for stat bars, and aircraft type label. |
| 1347 | DisplayRouteInfo | Decompress and place the character's portrait tile and framing border in the route info panel. |
| 1393 | RenderQuarterScreenGrid | Render the quarterly results grid showing aircraft icon tiles and profit values for each active route slot. |
| 1535 | InitializeRelationPanel | Initialize and display the city-relation panel showing city names and relationship values between the current player's cities. |
| 1621 | DisplayRouteEvent | Display the event graphic for a character's active route event in a 2x2 tile arrangement, if the character has an associated event. |
| 1699 | GameLogic1 | Initialize game logic: clear screen, load graphics, then call InitRouteFields, FinalizeRouteConfig, and SetupEventUI. |
| 1722 | InitRouteFields | Dispatch initialization of all three route field sub-records by calling InitRouteFieldA, InitRouteFieldB, and InitRouteFieldC in sequence. |
| 1735 | InitRouteFieldA | Tick down countdown timers on active $FF09C2 route field A records and trigger ProcessEventState when a timer expires. |
| 1765 | InitRouteFieldB | Reset the $FF09CA route field B slot, optionally calling InitCharRecord first if the slot has an active flag. |
| 1794 | InitRouteFieldC | Zero all $FF09CE route field C slot entries and reset the $FF09D6 active route selection word to $FFFF. |
| 1823 | FinalizeRouteConfig | Orchestrate the full route configuration finalization pipeline: InitializeRoutePipeline, FinalizeCandidateRoutes, FinalizeRouteSelection. |
| 1836 | InitializeRoutePipeline | Run the full route option selection pipeline: SelectActiveRoute, ProcessRouteOptionB, MatchRouteOption, ProcessRouteOptionC, ProcessRouteOptionD. |
| 1853 | SelectActiveRoute | Select and activate a weighted-random route event based on frame timing, process existing events via CheckEventCondition/ProcessEventState, and store the result in $FF09C2. |
| 1998 | ProcessRouteOptionB | Randomly trigger a type-1 route option event with 1/64 probability if $FF09C2 is empty, validating delay and storing to $FF09C2. |
| 2100 | MatchRouteOption | Match current game state to a route option by frame counter, validate via CalcEventValue and type checks, and activate the result at $FF09C6 as type-4. |
| 2175 | ProcessRouteOptionC | Randomly select and validate a character for route option C, checking char stat level vs. airline size and a 50% random gate, storing type-3 to $FF09C6. |
| 2303 | ProcessRouteOptionD | Randomly trigger a type-2 route option for an available character with 1/8 probability if $FF09C6 is empty, after CheckEventMatch and route event validation. |
| 2370 | FinalizeCandidateRoutes | Finalize both trade candidate route fields by calling InitRouteFieldA2 and InitRouteFieldB2. |
| 2381 | InitRouteFieldA2 | Randomly select and validate a domestic-range character (0–31) for trade candidate slot A with 1/16 probability, writing type-0 to $FF09CA. |
| 2427 | InitRouteFieldB2 | Randomly select and validate any character (0–88) for trade candidate slot B with 1/8 probability, writing type-1 to $FF09CA. |
| 2473 | FinalizeRouteSelection | Finalize route field C2 and run the turn checkpoint by calling InitRouteFieldC2 and ProcessTurnCheckpoint. |
| 2484 | InitRouteFieldC2 | Distribute random turn action counts across 4 players via RandRange(3), evaluate availability for each via EvaluateTurnAvailability, and return 1 if any slots assigned. |
| 2543 | EvaluateTurnAvailability | Evaluate and list available character turns for a player by randomly probing route slots and checking CheckCharAvailability and CheckTurnTiming. |
| 2655 | CalculateTurnCapacity | Probabilistically determine if a player has turn capacity, clamping to 20 with a +10 bonus in the final quarter phase and returning 1 if random < capacity/100. |
| 2698 | CheckCharAvailability | Check whether a character is available for a turn based on morale stat and route slot morale, returning 1 if a scaled random roll passes. |
| 2753 | CheckTurnTiming | Check whether timing is favorable for a turn based on current game phase position, returning 1 if a computed timing window random check passes. |
| 2796 | ProcessTurnCheckpoint | Select a random player for a trade turn via RandRange(3) and validate timing/availability via AggregateCharAvailability and ValidateTurnDelay. |
| 2825 | ValidateTurnDelay | Return 1 if aggregate character morale exceeds 90 and a random check on the excess passes, indicating a turn delay should be applied. |
| 2856 | ProcessTradeAction | Dispatch trade action handling for the active event type (0–4) in $FF09C2 via jump table (partially untranslated). |
| 3020 | CheckEventCondition | Check whether a character meets an event condition by translating its char code via RangeLookup and calling CheckEventMatch. |
| 3043 | CheckEventMatch | Test if the active event state in $FF09C2 matches a given character code across multiple criteria (char list, aircraft type, char index, D648, $022554). |
| 3175 | StubCodeFragment | Stub/placeholder fragment: illegal instruction word $FEDE followed by moveq #0,d0 / rts, always returning 0. |
| 3185 | ProcessEventState | Process an active event record: display route city info or char name in a dialog box, poll input, and update character availability flags. |
| 3388 | CheckRouteEventMatch | Return 1 if the pending candidate in $FF09CA has a char code range matching a given char code via RangeLookup comparison. |
| 3422 | FinalizeRouteEvent | Cancel the active route event in $FF09CA by reinitializing the character via InitCharRecord and clearing the slot to $FF. |
| 3447 | AggregateCharAvailability | Compute the average morale of all characters on a player's active route slots by calling CalcCharMorale for each and averaging. |
| 3498 | CalcCharMorale | Calculate a character's weighted morale value for a route slot using the raw morale byte, factor byte, and MulDiv. |
| 3515 | LinearByteSearch | Generic linear search: scan a byte array of given count, returning 1 if the target byte is found. |
| 3542 | CheckAirRouteAvail | Determine whether an air route is available for a character by checking player entity_bits and city/route window bits for char ownership. |
| 3615 | CalcEventValue | Compute an event's numeric value from $0005FA2A: return byte $2 directly if set, otherwise calculate from aggregate player route data. |
| 3659 | SetupEventUI | Set up the event UI layout by conditionally enabling a display mode and running multiple initialization phases via $02260C/$022D0A/$022FC8. |
| 3697 | DispatchRouteEvent | Iterate $FF09C2 records and dispatch to HandleRouteEventType0/1/2/3 or HandleAirlineRouteEvent based on stored event type. |
| 3751 | HandleRouteEventType0 | Handle a type-0 route event (character group transfer): run transition animation, display multi-char group dialog or alternative, reinitialize chars, and optionally set $FF1294. |
| 3959 | HandleRouteEventType1 | Handle a type-1 route event (individual character acquisition): animate info panel, show char name dialog, call InitCharRecord, and set char flag bit $2. |
| 4060 | HandleAirlineRouteEvent | Handle a type-4 airline route event: calculate char index value, animate info panel, show airline-specific dialog, place item tiles, and call InitCharRecord. |
| 4127 | HandleRouteEventType2 | Handle a type-2 route event (character batch transfer): process scenario menu, show event message dialog, initialize two char ranges, and display scenario menu. |
| 4213 | HandleRouteEventType3 | Handle a type-3 route event (single character event): animate info panel, show conditional player-match dialog, clear panels, place item tiles, and call InitCharRecord. |
| 4274 | RenderGameUI | Render main game UI event dialogs: dispatch on event type to trade scroll animations and info display functions, poll input, and update char state. |
| 4507 | UpdateGameStateS2 | Process pending route slot state changes in $FF09CE: execute trade offers and display route slot result notifications for types 0 and 1. |
| 4738 | ClassifyEvent | Classify a character type code into one of 5 event categories ($15→1, $3→2, $1C/$13/$F/$10→3, $7/$18/$1A→4, else→5) for UI dispatch. |
| 4793 | ProcessTradeS2 | Determine trade result category (1–4) based on character type (jump table up to $52) and current game phase timing via frame_counter mod 4. |
| 4851 | GetCharStatsS2 | Update character availability flags in route slot tables ($FF0420, $FF04E0) by scanning $FF0338 type-5 event records and setting high bits accordingly. |
| 4958 | GetCharRelationS2 | Execute a relationship-based char trade by finding a compatible player, checking willingness scaled by relation distance, and calling ExecuteTradeOffer. |
| 5089 | ExecuteTradeOffer | Execute a trade offer by checking char capacity via GetLowNibble, adjusting the capacity field, subtracting relationship values at $FFBA81, and updating $FFB9E8. |
| 5165 | FinalizeTrade | Find a suitable route slot for a trade by randomly searching a player's active routes for a slot matching the offered/accepted char codes. |
| 5226 | RenderScenarioScreen | Return 1 if any route/trade/turn pipeline slot ($FF09C2, $FF09CA, $FF09CE, $FF09D6) is active, or 0 if all are empty and all events resolved. |
| 5265 | DrawLabeledBox | Draw a labeled dialog box at fixed screen position (10x17 chars at position 1) by calling the text print function with the string pointer. |
| 5283 | ClearListArea | Clear the dialog/list display area via GameCommand $1A for a 10x17 region with priority flag. |
| 5301 | ProcessScenarioMenu | Load and display a scenario screen background: ResourceLoad, clear two display areas via GameCommand $1A, LoadScreen, ResourceUnload. |
| 5337 | DisplayScenarioMenu | Initialize resources and load the scenario menu graphics for full display via ResourceLoad, PreLoopInit, LoadScreenGfx, ResourceUnload. |
| 5352 | HandleScenarioMenuSelect | Set up tile display for a scenario menu selection by computing index mod 20, looking up display address from $0004825C, and calling DisplaySetup. |
| 5375 | ValidateMenuOption | Decompress and place the background tile for a validated menu option: mod 20 index lookup in $000482AC, LZ_Decompress to $FF1804, CmdPlaceTile2. |
| 5405 | InitInfoPanel | Initialize the info panel by calling HandleScenarioMenuSelect and ValidateMenuOption, then placing a fixed 12x10 window at (10,6) via GameCommand $1B. |
| 5442 | AnimateInfoPanel | Animate the info panel with a 3-step slide-in effect, alternating between init and step calls with GameCommand $E between each step. |
| 5488 | FinalizeScenarioScreen | Place scenario screen tile elements from a $FF-terminated position list, calling TilePlacement and GameCommand $E per entry for end-state display. |
| 5538 | PlaceItemTiles | Place a series of item tiles from a byte list at sequentially computed screen positions, calling TilePlacement and GameCommand $E per entry. |
| 5575 | DecompressTilePair | Decompress two scenario tile images by index (mod 20 lookup in $000482AC) into the two tile buffers at $FF1804 and $FF3804 respectively. |
| 5615 | TogglePageDisplay | Flip display pages alternately by decompressing tiles from $000482D4 and polling input, exiting when the player provides input (page-flip selection UI). |
| 5650 | AnimateScrollEffect | Perform a horizontal scroll animation effect when flight_active is set: ramp scroll speed up then down through 1→16 steps, ending at zero. |
| 5768 | AnimateScrollWipe | Perform a scroll-wipe transition animation when flight_active is set: two forward/reverse pulse pairs followed by a decrementing paired wipe from 15 to 1. |
| 5849 | RunTransitionSteps | Run a multi-step transition animation sequence when flight_active is set: two display step calls plus two init calls with a 6-frame wait. |
| 5873 | UpdateIfActive | Conditionally run a single display update step by calling the step function only when flight_active is set. |
| 5912 | LookupCharCode | Render a sequence of 7 char-code display tiles from $0005FA6E by calling DisplaySetup and GameCommand $E for each entry (char code build-up animation). |
| 5937 | CompareCharCode | Render char-code display tiles in reverse order (6→0) from $0005FA6E for a wipe-out animation of the char code display. |
| 5966 | ValidateCharCode | Set up and display the character code validation screen background: DisplaySetup with background data, LZ_Decompress validation graphic, CmdPlaceTile, window setup. |
| 5987 | RunQuarterScreen | Run the main quarterly review screen with full input handling: navigate players/chars/slots, dispatch to UpdateGameStateS2, trade prep, and player info sub-screens. |
| 6447 | HandleTextCompression | Display and navigate the text-based route/character information screen: decompress graphics, show player route summary with char names, browse slots, and show relation data on select. |
| 6757 | DecompressGraphicsData | Decompress and display character graphics and stats for the route graphics view: char portraits, compatibility tiles, and relationship values with conditional VRAM placement. |
| 7059 | UpdateSpriteAnimation | Display a player's summary screen showing financial summary (revenue, expenses) and route statistics (routes, chars, aircraft), waiting for the player to press a button. |
| 7179 | OrchestrateGraphicsPipeline | Render a comparative chart of character statistics across multiple rows for the planning screen, showing char name, city relation delta, availability count, and aircraft count. |
| 7424 | InitGraphicsMemory | Initialize and run the main character management screen: build owned char list, enter full navigation loop with page management, and dispatch to sub-screens. |
| 7745 | InitMainGameS2 | Run the main game S2 route assignment screen: display route map with aircraft tiles and slot text, handle char selection and slot navigation input, and show char comparison on confirm. |
