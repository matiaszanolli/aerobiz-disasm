# B-057 Batch 2 Findings

## Functions Described

### City/display update cluster

- **UpdateScreenLayout**: Computes chart display parameters from two characters' stats, builds tile arrays, and renders a bar-chart-style score comparison panel with navigation input loop.
- **RefreshDisplayArea**: Scores a character pair using CharCodeScore, formats the result as a percent offset from 50, then draws an info box and processes input; calls ProcessCityChange when the value changes.
- **ProcessCityChange**: Fills a local tile-code array with up/down/neutral icon tile IDs based on two numeric parameters (row count and column index), then renders two rows of those tiles via GameCommand.
- **RunAssignmentUI**: Draws the assignment screen background and character icon grid, then runs a keyboard-entry loop accepting character-code characters, appending/deleting from a buffer, and printing it.
- **UpdateCityStatus**: Evaluates two packed byte values against signed threshold constants and sets a flag (D3=1) if the combination falls within the accepted range.
- **RunGameMenu**: Initialises the main in-game menu screen (draws background, logo, player portrait), then dispatches to sub-menus (aircraft, routes, staff, finance, or end-turn) via a jump table loop.
- **CalcCityMetrics**: Sets the background, draws a dialog, then loops calling ScanCitySlots and NavigateCharList to let the player browse city slot data; finalises by drawing a result box.
- **ResolveCityConflict**: Prepares a text box, calls GenerateEventResult to draw the box outline, prints up to 5 city-name or player-name strings, then shows confirmation text based on a conflict-type flag.
- **ScanCitySlots**: Renders a tile panel for a city slot row and runs a navigation input loop; handles up/down/confirm/cancel to select a city slot index, returning the chosen slot in D0.
- **ProcessCharSelectInput**: Sets background, draws dual panels, sets text window, calls BrowseMapPages to let the player pick a city, then calls PackSaveState and SignExtendAndCall on the selection.
- **BrowseMapPages**: Draws a paginated character-map list (two columns of tiles per entry), runs a navigation input loop, and returns the selected character index or -1 for cancel.
- **DrawDualPanels**: Draws two fixed-size background panels side-by-side by calling the tile-placement function twice at offsets (x=1,y=1) and (x=13,y=1).
- **SignExtendAndCall**: Sign-extends the word parameter from the stack to a long and calls ShowRouteInfo with it; a thin adapter shim.
- **ToggleDisplayMode**: Flips bit 0 of RAM word $FF000A, redraws a text window, and prints the new mode label from a pointer table.
- **NavigateCharList**: Toggles the view-mode flag at $FF000C or $FF000E depending on the parameter, redraws the mode label in a text window, and calls SetDisplayMode or SetDisplayPage accordingly.
- **HandleCharListAction**: Sets background, calls GenerateEventResult and ProcessEventSequence to draw the event frame, formats a player-name string, shows a dialog with a tile icon, then runs a navigation input loop for the char list.

### Event system cluster

- **ProcessEventSequence**: Prints three company/player names (from a pointer table) into a fixed text window at successive cursor rows; a display-only function with no input.
- **EvaluateEventCond**: Shows a yes/no dialog; if accepted and all players already have event flag set, shows a confirmation dialog and calls GameSetup1; otherwise clears the player's event active flag and decrements the event counter.
- **GenerateEventResult**: Draws a filled box (via DrawBox) using screen coordinates derived from all four stack parameters; a wrapper that adjusts column/row offsets by ±1.
- **RecordEventOutcome**: Draws a filled rectangle using GameCommand, adjusting the passed coordinates by +2 on the column and -1 on the row; a display utility for event result frames.
- **UpdateSlotEvents**: Iterates over 32 route/event slots; for each active slot calls UpdateEventState, and for each inactive slot where the random event threshold is met calls ApplyEventEffect.
- **UpdateEventState**: Decrements the countdown byte of a slot; when it reaches zero, computes a bonus delta, adds it to the slot's accumulator (capped at $FF), advances the slot type, draws a notification box, and waits for button press.
- **ApplyEventEffect**: Looks up a slot entry in the event table at $FF0728; if the slot is idle and its type index is below 9, sets the countdown byte to (type*3+3) to arm the event.
- **HandleEventCallback**: Copies per-player event stat bytes (bytes 1-3 of each 4-byte record) from one of two ROM stat tables into work-RAM at $FF1298, selecting between the two tables or blending them based on the current player-count flag at $FF0002.
- **ResetEventData**: For a single slot index, copies the initial event stat bytes (bytes 1-3) from the appropriate ROM table into work-RAM, selecting or blending between two source tables based on the player count.
- **CalcCityCharBonus**: For a given city/char slot index, scans the assigned character list and accumulates compatibility bonuses: sums relation scores and cap-clamps the result into the slot's bonus byte at $FF1298.

### Char management + quarter cluster

- **InitAllCharRecords**: Optionally calls HandleEventCallback to copy event stats, then iterates over all 89 character slots calling InitCharRecord on each.
- **InitCharRecord**: Calls CalcCityCharBonus for the given slot and player, then invokes the character-record builder at $021E5E to fill in the char ID and two derived stat bytes.
- **ShowStatsSummary**: Computes rank change for the given player, formats a summary string (up/down/same) via sprintf, then builds the quarterly route/char bonus table, filters by age, and calls the result-display function for each slot.
- **RunCharManagement**: Runs the full character management screen for a player: initialises the char list, scans for the best negotiation candidate and best performance char, optionally triggers an event, then shows contract negotiation or departure dialogs.
- **ComputeQuarterResults**: Calls CountCharPerformance, formats a result string (no chars / 1 char / N chars) via sprintf, picks a random display colour, and calls ShowText to display the quarterly character performance summary.
- **UpdatePlayerAssets**: Calls CalcPlayerFinances, then compares the player's loan balance to repayment capacity; formats a debt/payment/balance message via sprintf and calls ShowText to report financial standing.

### Relation system cluster

- **GetCharRelation**: Returns a tile-code for the relationship between two characters: checks if they are the same person ($0760), in a marriage relation ($0761), have a bond bit set ($0762), or are unrelated ($0763/$0764/$0765) based on city-type and compatibility bitmask.
- **BrowseRelations**: Collects up to 4 partner pointers, shows the relation panel, then runs a page-navigation loop calling FormatRelationStats for each visible partner and handling left/right navigation wrapping.
- **FormatRelationDisplay**: Draws the relation detail panel for a single character pair: loads the portrait sprite, draws the compatibility gauge, prints both names and compatibility score, and displays the relation icon tiles.
- **FormatRelationStats**: Draws the compact relation stats cell for one character: renders name, compatibility fraction, portrait icon, and score value into a tile-sized panel at the given column/row position.
- **ShowRelationAction**: Draws the relation action screen showing the offensive/defensive event bar graph (tile run proportional to current vs base event count) for either attack or defence depending on which count is nonzero.
- **ShowRelationResult**: Draws the relation result screen: computes a percent outcome from the char-pair score, divides it into filled/partial/empty tile runs, and renders three horizontal icon bars plus a portrait if the caller flag is set.
- **BrowsePartners**: Finds the first valid (non-$FF) partner slot, shows the partner list panel, then runs a left/right navigation input loop calling FormatRelationStats for the highlighted partner until the player presses the exit button.
- **ScanRouteSlots**: Iterates over all route slots for the given player, comparing each slot's assigned-char byte to the target char index; accumulates up to 4 matching route entries into a result array returned to the caller.
- **CalcRelationValue**: Looks up the compatibility score between two chars, scales it by a relation-type factor (1=attacker only, 2=defender only, 3=combined), then applies a seasonal modifier from $FF0006 to produce the final relation bonus value.

### Flight display + turn system

- **InitFlightDisplay**: Loads the flight-path background graphic, initialises the scroll table, clears the sprite counter, and zeroes the flight-slot array at $FF153C.
- **ClearFlightSlots**: Clears the sprite count register and zeroes the flight-slot array at $FF153C; a subset of InitFlightDisplay used for mid-screen resets.
- **UpdateFlightSlots**: For the given display mode and player, counts the number of active relation/route bits and fills in up to two free flight slot entries at $FF153C with the corresponding flight path parameters.
- **InitTurnState**: Selects a random route and character assignment for the current turn; looks up city and char compatibility bitmasks, searches bitfields for a valid char, and fills the turn-state record pointed to by A3 with the chosen route/char/speed data.
- **ProgressGamePhase**: Advances one flight-slot record: if the slot matches the turn record it clears it; otherwise computes the bearing and step-size from source and destination city positions and stores the tile-code and speed into the flight-slot.
- **AnimateFlightPaths**: For each active flight slot, interpolates the X/Y coordinates one step toward the destination, places the result into the sprite work buffer, calls the sprite-DMA command, and advances the slot's progress counter.
- **DiagonalWipe**: Performs a tiled diagonal wipe transition: expands a strip of tiles outward from a starting row/column using random step sizes each frame, calling the tile-placement routine per step until the full 0x22-row or 0x36-column span is covered.

## Functions Skipped

- None. All 47 functions in the assigned range had TODO markers and have been described.

## Notes

- **UpdateCityStatus** at line 10120 has a leading `dc.w $0010,$1428` (ORI.B with compiler junk byte) and `dc.w $FFFF` before the actual code begins; the description covers only the translated logic.
- **RunGameMenu** at line 10163 has a large untranslated dc.w block (212 bytes, $0170E0 onward) containing the jump-table dispatch; the description is based on the translated prologue plus the visible dispatch structure.
- **UpdateEventState** uses `link/unlk` via a frame pointer left in A6 from its caller context (called through UpdateSlotEvents which does not set a frame); the d2-d4/a2-a3 restore at end uses `-$14(a6)`, not a normal movem restore from the stack.
- The `HandleEventCallback` and `ResetEventData` pair share the same logic for copying 3-byte event stat records and selecting between ROM tables based on $FF0002; they differ only in that HandleEventCallback processes all 89 slots while ResetEventData processes one.
- `CalcRelationValue` returns its result only in D2 by register convention (the final `movem.l (sp)+,d2-d6/a2` restores D2 from the saved value, which means the computed result is lost). This appears to be a compiler artefact where the return value was left in D0 before the restore clobbered it; treat D0 as the actual return register.
