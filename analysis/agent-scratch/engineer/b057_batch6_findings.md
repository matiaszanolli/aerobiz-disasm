# B-057 Batch 6 Findings

## Functions Described

1. **ManageTurnDisplay** (~line 16011) -- Iterates up to 4 pending turn-display events per player (state=5), loads the city/character resource, draws a facility-level summary box with a turn counter dialog, and clears the event slot when done.

2. **ProcessCharModifier** (~line 16226) -- Iterates pending modifier events (state=1) for each of 4 player slots; for each event looks up the character range, calculates the stat advantage gained this turn, and either plays a relationship panel animation or displays a stat-increase dialog with tile-formatted numbers.

3. **HandleCharSelectionS2** (~line 16563) -- Random AI-driven character selection: rolls a random char slot for a player, validates it with ValidateCharSlot, then if the owner's state flag is set shows the character's info pages (two panels) and a hire dialog.

4. **ValidateCharSlot** (~line 16670) -- Checks whether a character (by city index) is available to be hired by a given player: scans all character records for a matching skill expiry window, then verifies the character's stat is not grade 3 (retired/unavailable); returns 1 if valid, 0 otherwise.

5. **ShowCharStatus** (~line 16738) -- Shows the character status screen for a player: if it is the last turn of the year, loads the player portrait and screen, displays a city label and two turn-count info strings, then calls RenderStatusScreenS2 for the normal per-player status panel; also triggers ShowAnnualReport if the player has negative funds.

6. **RenderStatusScreenS2** (~line 16852) -- Renders the per-player status overview screen: sets up a 5x3 display box, prints a player name header, then loops through 7 route slots drawing the route name and whether each slot is occupied or empty, then calls ShowCharDetailS2.

7. **ShowCharDetailS2** (~line 16955) -- Draws a character detail overlay for a player's character: dispatches through a 4-case jump table on the character's status byte (offset $22) to render appropriate formatted text panels (character name, year label, or sprite/score lines), then awaits menu selection.

8. **DisplayStationDetail** (~line 17087) -- Displays the station/facility detail screen for a given city and player: loads resources, decompresses and renders station graphics to VRAM, shows the char portrait, displays the facility name, ownership string, and (if multi-player) animates a 152-step facility tile sequence.

9. **ShowFacilityMenu** (~line 17317) -- Displays the facility upgrade tile menu for a given facility level: decompresses the LZ-compressed facility tile set, places it in VRAM, builds a 30-entry tile index array, and issues a GameCommand to render the scrollable tile menu.

10. **ShowAnnualReport** (~line 17371) -- Displays the annual financial report for a player: determines the best rival airline, the most profitable route, and whether any special conditions apply (bankruptcy, route competition), then formats and displays the corresponding summary dialog using ShowTextDialog/ShowCharInfoPageS2.

11. **InitScenarioDisplay** (~line 17827) -- Clears the scenario display area by issuing two GameCommands (clear screen and reset display mode) with no arguments; used to initialize/reset the scenario menu background.

12. **RunScenarioMenu** (~line 17846) -- Runs the full scenario selection menu loop: reads the current scenario state from $FF0A32, computes airline scores and prices, renders the scenario screen with character portrait and info panel, handles player input to browse, select, or confirm a scenario, and writes the chosen scenario back to $FF0A32.

13. **GetAirlineScenarioInfo** (~line 18391) -- Displays info for a single airline scenario entry: looks up the airline's region and range, draws the airline name in a text window, places the character sprite on screen, and calls DrawCharInfoPanel to render the full scenario info card; waits for button press before returning.

14. **ResetScenarioMenuS2** (~line 18462) -- Resets the scenario menu state ($FF0A32 = $FFFF), then randomly rolls a valid scenario: picks a city index in range, validates it against a known-city whitelist, finds the matching group index in the scenario table, and writes the packed (group<<8|city) value to $FF0A32.

15. **ClearAircraftSlot** (~line 18533) -- Clears one byte in the aircraft roster array at $FF05C4, indexed by (player * 57 + slot), effectively removing an aircraft from a player's fleet slot.

16. **CountAircraftType** (~line 18545) -- Counts how many of 89 aircraft slots have a matching type byte equal to the given type code; returns the count in D0.

17. **RunPurchaseMenu** (~line 18570) -- Runs the aircraft purchase menu main loop: initializes the display, finds the first available aircraft slot, loops reading player input via UpdateSelectionS2/RefreshControlState, dispatches to purchase/sell/exit actions, and on exit updates the map display.

18. **UpdateSelectionS2** (~line 18686) -- Rebuilds the availability flags at $FF17C8 (one word per character slot): clears the buffer, scans 16 character records for those within the current year's age window, marks each available slot, and records the first available index in $FFBD5A.

19. **RefreshControlState** (~line 18739) -- Refreshes the aircraft selection UI state buffers ($FF17E8, $FF1584, $FF880C) from the current availability map ($FF17C8): marks available slots in all three arrays and clears entries for retired (grade-3) characters; also forces slot 11 and index $16 to available.

20. **InitControllerS2** (~line 18834) -- Sets up the player-select UI control bounds in the $FF1480 array only for player counts > 2: writes fixed values for the range ($15/$17) and step ($1/$3) fields used by the selection cursor.

21. **ClearControllerS2** (~line 18854) -- Runs the aircraft selection/assignment UI: draws the route panel and character panels, handles directional input to cycle through valid slots, shows a character name dialog on confirm (A button), calls ProcessCrewSalary/FindAvailableSlot for slot management, and exits when the player presses B/cancel.

22. **ShowRoutePanel** (~line 19086) -- Renders the route panel background: loads route tile data, decompresses and uploads route graphics to VRAM, places available route slot icons at screen positions determined by the FF1480 layout table, and overlays two fixed navigation arrow tiles.

23. **ShowCharPanelS2** (~line 19229) -- Draws a single character panel cell at its screen position: selects the appropriate tile set based on slot index (0-10 use indexed tiles, 11 uses a fixed sheet), places the tile grid, draws a background block, sets a text window, and prints the character name and role labels.

24. **CheckCharGroup** (~line 19337) -- Iterates the character group transfer loop: calls CheckCharSlotFull to see if the destination player has a free slot, then calls TransferCharacter to attempt the hire; if the hired char returns $FF (rejected) plays a cancel sound, otherwise calls ManageCharStatsS2 to apply stat changes, and repeats.

25. **ProcessCrewSalary** (~line 19398) -- Checks whether the current player can afford crew salaries: if funds are negative shows a bankruptcy dialog; otherwise scans up to 5 route records for any with salary >= 10 and if all 5 are maxed shows an over-budget dialog; returns 1 if OK to proceed, 0 if blocked.

26. **CheckCharSlotFull** (~line 19454) -- Checks if the destination player's character roster has a free slot: scans 5 route record entries for one with salary < 10; if no slot is free (all full), retrieves the blocking character and shows two ShowCharInfoPageS2 dialogs; returns 1 if a slot is free, 0 if full.

27. **TransferCharacter** (~line 19512) -- Runs the character hire/transfer negotiation UI: shows the transfer screen with stat comparison, loops reading input (up/down to scroll, A to negotiate, B to cancel), calls FindCharSlotInGroup to locate the char's current slot, checks salary cap and age limit conditions, shows appropriate result dialogs, and returns the hired character's slot index or $FF on cancel.

28. **RenderCharTransfer** (~line 19955) -- Renders the character transfer comparison screen: displays the character's stats panel and city-of-origin label, computes the weighted stat value (halved if the character is the AI's own), and prints the salary and stat score on screen.

29. **DrawCharStatus** (~line 20062) -- Draws the status indicator for a specific character slot: looks up the character's region and player owner, then calls ShowCharInfoPageS2 with the appropriate status-label pointer; returns the dialog result.

30. **ManageCharStatsS2** (~line 20095) -- Manages post-transfer stat application: computes how many stat points the player can afford (based on salary/budget), clamps to available upgrade count, shows the upgrade count dialog via ShowCharInfoPageS2, then enters a DrawCharPanelS2 loop where the player confirms or adjusts the number of stat points to apply, deducts funds, and updates the character record.

31. **FinalizeTransfer** (~line 20442) -- Stub function (2 bytes, just RTS); placeholder for finalizing a character transfer, currently does nothing.

32. **DrawCharPanelS2** (~line 20449) -- Draws the character stat-adjustment panel: sets up the display, decompresses and loads panel graphics, calls RenderCharDetails to draw the current char slots, then runs an input loop allowing the player to increase/decrease the number of stat points allocated (up/down arrows), updates the tile display live, shows cost dialogs, and returns the final input result.

33. **RenderCharDetails** (~line 20763) -- Renders the set of character stat slot tiles on the transfer panel: iterates from 0 to the current slot count, computing each tile's (x,y) screen position in a 2-column layout, and calls TilePlacement to draw each slot indicator tile.

34. **SelectCharSlot** (~line 20849) -- Selects and adds a character to the team: finds the first valid free slot via FindAvailableSlot, then repeatedly calls FindAvailableSlot+AddCharToTeam, UpdateCharDisplayS2, and CheckCharLimit until no more slots are available or the limit is hit.

35. **FindAvailableSlot** (~line 20922) -- Finds an available character slot in a player's roster starting from the given slot index, wrapping around if needed; if no slot is free, shows a "roster full" dialog (two variants depending on flag) and returns $FF.

36. **AddCharToTeam** (~line 21025) -- Adds a character to a player's team: shows the character's profile panel, displays the hire dialog with current age/salary info, runs an input loop (up/down to browse team slots, A to confirm hire, B to cancel), shows appropriate cost/rejection dialogs, and returns the assigned slot index.

37. **UpdateCharDisplayS2** (~line 21408) -- Displays the purchase confirmation UI for a character slot: renders the char's portrait and score panel, calls ReadCharInput for user input, and if confirmed deducts the total cost from the player's funds, updates the character's age/salary record, and refreshes the panel via RefreshCharPanel.

38. **ReadCharInput** (~line 21625) -- Handles character salary-quantity input: sets up a dual-column tile display with salary and count tables, shows remaining budget and current total, runs HandleCharInteraction animations, and loops processing up/down input to decrement/increment the quantity, updating the displayed subtotal until the player confirms with A or cancels with B/Start.

39. **HandleCharInteraction** (~line 22002) -- Animates a tile wipe transition on the character panel: two modes (flag=1: left-to-right tile slide, flag=0: symmetric fold-out) using TilePlacement in loops with GameCommand VBlank waits to produce smooth character-card reveal/hide effects.

40. **CheckCharLimit** (~line 22214) -- Checks whether the character roster has reached its limit: shows a "limit reached" info dialog via ShowCharInfoPageS2 and if the limit is confirmed also shows a second confirmation dialog; returns the dialog result.

41. **RefreshCharPanel** (~line 22244) -- Redraws the character info summary panel: decompresses and loads the char-panel tile sheet, places it in VRAM, draws the panel frame, sets up a text window, and prints the airline name and financial figure (revenue, profit, or salary total depending on the mode parameter).

42. **ShowCharInfoPageS2** (~line 22338) -- Displays one page of a character info dialog: sets the text window, calls DrawCharInfoPanel with layout parameters looked up from table at $485BE, prints the character name, then either waits for a button press (mode=1: PollAction) or runs a SelectPreviewPage scroll loop (mode=flag).

43. **ShowCharInfoPage** (~line 22409) -- Variant of ShowCharInfoPageS2 using a different layout table ($485D6) and different sub-calls (DrawCharInfoPanel at $643C, PollAction at $1D62C); same page structure but with separate display parameters for an alternate info page context.

44. **CalcCharScore** (~line 22470) -- Calculates a character's score value: derives a "years until retirement" figure from the current year and the character's age field, multiplies by the character's salary modifier, clamps to 100, and returns the result.

45. **FindCharSlotInGroup** (~line 22506) -- Finds the slot index of a character (by city index) within a player's 5-slot route record: scans for a matching char byte in the active (salary != 0) entries; if not found, falls back to the first active entry; returns the slot index.

46. **GameUpdate1** (~line 22553) -- Displays the seasonal transition screen: loads resources, sets up the background and screen graphics, calculates the current season name (mod-4 of the game year) and year display value, prints both in a centered text window, then animates 3 frames of the season label before returning.

47. **ShowQuarterReport** (~line 22658) -- Runs the quarterly financial report for a player: calls ProcessGameUpdateS2 to set up the display, shows income and expenses, conditionally shows a special event report (if frequency >= 70), displays route profit/loss banners, dispatches to the player action menu via ShowCharInfoPageS2, and loops through route performance results.

48. **CalcCharScoreS2** (~line 22972) -- Runs the main management menu for a player's turn: decompresses and shows the management screen background, displays the player's city chart, presents a 4-item menu (game mode, alliance roster, stats summary, char management), and loops until the player selects the exit option.

49. **FindCharSlotInGroupS2** (~line 23073) -- Shows the alliance/relationship screen for a player: draws the alliance panel GameCommand overlay, calls ShowText with a region label, loads resources, calls LoadScreen and ShowRelPanel to render the relationship map and portrait panel.

50. **ShowText** (~line 23121) -- Already described: "Thin wrapper around ShowTextDialog with simplified params."

51. **ProcessGameUpdateS2** (~line 23150) -- Sets up and renders the per-player game update display: decompresses the map background, places it in VRAM, renders the player bar and score area, calls ShowPlayerChart, then displays four stat sub-panels via the sub-function at $10CAC.

52. **UpdateGameLoopS2** (~line 23224) -- Iterates over a 3x2 grid of text lines and a 3-item footer, calling ShowText for each entry from two lookup tables ($47C78 and $47C90); used to display a multi-line quarterly summary text report for a player.

53. **ProcessGameFrame** (~line 23281) -- Displays the end-of-turn/end-of-game summary for a player: branches on the player state byte ($22 of player record: $63=won, $62=bankrupt, $61=special) to show appropriate sprintf-formatted outcome messages, then shows profitable-route count and total character value if applicable.

54. **GetCurrentGameMode** (~line 23487) -- Runs the alliance slot management screen: validates the player's alliance slot, fills a local 28-byte buffer, and begins iterating through alliance entries (body truncated at $030000 boundary -- only the first 60 bytes are in this section).

---

## Functions Skipped

- **ShowText** (line 23121) -- Already has a description: "Thin wrapper around ShowTextDialog with simplified params."
- **ShowQuarterReport** (line 22658) -- No `(TODO: ...)` comment block exists in the file (translated inline without header). Added description above for reference but no edit target exists.
- **RunPurchaseMenu** (line 18570) -- No `(TODO: ...)` comment block exists in the file (translated inline without header). Added description above for reference but no edit target exists.

---

## Notes

- ManageTurnDisplay and ProcessCharModifier share the same "pending event queue" structure at $FF0338 (4 entries of 8 bytes each, per player), with bytes: [char_id, event_type, param, timer, ...].
- ValidateCharSlot uses $FFA6B8 (the character record array, 0x0C bytes per entry) and the current game year to compute a hire-eligibility window.
- The S2 suffix on many functions indicates these are the section_020000 local variants of functions also present in earlier sections (e.g., ShowCharInfoPageS2 vs ShowCharInfoPage use different layout tables).
- FinalizeTransfer is a pure stub (RTS only); its 2-byte size suggests it was a placeholder that was never implemented.
- GetCurrentGameMode body extends into section_030000 and cannot be fully analyzed from this section alone.
- CalcCharScoreS2's name is misleading: its body is the management menu dispatcher, not a score calculation. The name likely reflects an auto-naming artifact.
- FindCharSlotInGroupS2's name is also misleading: it shows the alliance/relationship screen, not a slot search. Same naming artifact.
