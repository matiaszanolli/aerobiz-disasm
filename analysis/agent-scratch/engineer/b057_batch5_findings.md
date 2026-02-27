# B-057 Batch 5 Findings

## Functions Described

### Route display + player stats screens (~lines 8204–10110)

1. **LoadRouteMapDisplay** (~line 8204) — Renders the route map display panel for a player, iterating over route entries and placing decompressed tile graphics and route name text at computed screen positions.

2. **UpdateCharOccupancy** (~line 8305) — Scans all char slots on routes for a given airline player and increments per-type occupancy counters in a caller-supplied array.

3. **RenderPlayerDataDisplay** (~line 8406) — Draws the per-player route list panel showing route name, region, and revenue for up to five routes, with header labels.

4. **HandleRouteSelectionS2** (~line 8529) — Handles the interactive route-selection screen: reads directional input, scrolls the route list with highlight cursor, and returns the selected route index or a back-button code.

5. **DisplayPlayerStatsScreen** (~line 8805) — Loads resources and renders the full player stats screen showing profit/loss, rank, route type summary, and character employment for one player, then waits for a button press before returning.

6. **WaitForAButtonPress** (~line 9021) — Initializes the display loop, shows the game status bar, issues a "wait" tile command, then polls until A-button is pressed.

7. **GameUpdate4** (~line 9041) — Orchestrates an end-of-month game update: resets display, calls CalculatePlayerWealth, CalcPlayerRankings, UpdatePlayerStatusDisplay, UpdatePlayerHealthBars, checks for game-win every fourth turn, and processes invoices for each player.

8. **CalculatePlayerWealth** (~line 9090) — Accumulates net-asset totals across all four players (cash + loans + route-revenue forecast), zeroing the buffers at quarter boundaries, then calls CalcPlayerWealth for each player.

9. **CalcPlayerWealth** (~line 9159) — Computes a single player's total wealth: sums cash balance, outstanding loans, and three categories of route-slot values, returning the result in D0.

10. **CalcPlayerRankings** (~line 9198) — Rebuilds the per-player rank and tie-count arrays in $FF0270/$FFBE00 by comparing each player's accumulated wealth score against every other player, applying tie-break rules.

11. **UpdatePlayerStatusDisplay** (~line 9301) — Collects wealth totals and asset peaks across all players, calls InitLeaderboardData, then drives the interactive quarterly-summary display loop (navigating between per-player panels and the leaderboard screen).

12. **InitLeaderboardData** (~line 9459) — Clears and initialises the leaderboard working buffer at $FF14B0 by writing each player index in order.

13. **RenderQuarterReport** (~line 9488) — Draws one page of the quarterly report: on first call loads and sets up the full background (map, banner, player icons); dispatches to DisplayRouteCargoInfo, ShowRoutePassengers, DisplayRouteFunds, or DrawQuarterResultsScreen depending on the page selector argument.

14. **DisplayRouteCargoInfo** (~line 9837) — For each player, renders the cargo bar on the quarterly-report page: optionally prints the revenue figure and draws a proportional filled tile strip representing cargo volume vs. capacity.

15. **ShowRoutePassengers** (~line 9954) — For each player, draws the passenger-load bar on the quarterly-report page and optionally prints the passenger count text.

16. **DisplayRouteFunds** (~line 10028) — For each player, prints the quarterly funds figure and draws a proportional tile strip indicating financial performance on the quarterly-report page.

17. **DrawQuarterResultsScreen** (~line 10100) — Renders the full quarterly results screen with decompressed tile backgrounds, per-player score panels, route-flag icon strips, and divider markers for all four players.

### Route flags + game status + player health bars (~lines 10572–11400)

18. **CountRouteFlags** (~line 10572) — Counts the number of set bits (active route flags) in the route-flag longword for a given player, returning the count minus one (so an empty set returns 0 rather than -1).

19. **ShowGameStatus** (~line 10608) — Renders the global game-status screen: builds the background with city-column headers, displays each player's city count and rank tokens, places character portraits with their current rankings, and shows total route counts.

20. **UpdatePlayerHealthBars** (~line 10956) — Adjusts each player's health-bar byte (at offset $22 in the player record): increments if the player has positive balance (capping at $65), decrements if negative (flooring at $63).

21. **CheckDisplayGameWin** (~line 10988) — Checks whether any player has met the win condition (6+ route flags covering enough cities) every fourth turn; if so, calls DisplayPlayerLeaderboard for that player, and if the turn limit is reached transitions to the end-game screen.

22. **DisplayPlayerLeaderboard** (~line 11079) — Shows the end-game leaderboard sequence for a winning player: clears the screen, loads the winner's graphic, presents rank dialog boxes for all four players with their final standings, then restores the play screen.

23. **ManagePlayerInvoice** (~line 11226) — Handles the loan-invoice screen for one player: if the player is active and a loan is due, shows the invoice dialog with repayment options; accepting reduces the active-player count, rejecting (if sole survivor) triggers game-over.

24. **CountActivePlayers** (~line 11369) — Iterates the four player records and returns in D0 the count of players whose active flag (byte 0) is set to 1.

25. **ProcessCharAnimationsS2** (~line 11395) — Processes pending char animation/move records for a player at turn end: credits char revenue to route income, evicts expired char relations, resets char state slots, and applies accumulated city-popularity bonuses.

### Quarter + game state management (~lines 11648–12910)

26. **InitQuarterStart** (~line 11648) — Resets a single player's quarterly stats at the start of a new quarter: grants the turn stipend (doubled for player 0 if $FF0004=0), clears income/expense accumulators, resets the health bar, zeroes route-slot revenue buffers, and recomputes popularity scores.

27. **BuildRouteLoop** (~line 11790) — Drives the interactive route-building phase for the current player: loops calling the route-selection function until the player passes, then invokes CalcRouteRevenue and CalcCharAdvantage to finalise the new route.

28. **FinalizeQuarterEnd** (~line 11877) — Finalises a player's route-placement turn: presents relation panels, browses the char list for a new hire, calls SnapshotGameState/CalcRouteRevenue/CalcCharAdvantage, handles the confirmation dialog, and stores the resulting hire into the route slot.

29. **SnapshotGameState** (~line 12240) — Searches the player's route-slot array for a slot whose char code and state byte match the given values, returning the slot index (or -1 if not found).

30. **ValidateGameStateS2** (~line 12270) — Shows a confirmation dialog comparing two route-revenue values for a proposed char swap, and if confirmed copies the char assignment into the target slot.

31. **ProcessUndoRedo** (~line 12369) — Manages the char-reassignment screen for a player: allows the player to select a char and shift that char's assignment count up or down across slots using directional input, confirming or cancelling the change with dialog prompts.

32. **ResetGameStateS2** (~line 12636) — Presents a numbered selector widget for choosing how many char slots to commit (1 through N), using left/right input to navigate and A/B to confirm or cancel, returning the selected count.

### Event system S2 cluster (~lines 12883–13740)

33. **RunEventSequence** (~line 12883) — Top-level dispatcher that calls DecrementEventTimers, CheckEventConditionS2, ExecuteEventAction, ApplyEventEffectS2, and HandleEventConsequence in sequence to process all game events for the current turn.

34. **DecrementEventTimers** (~line 12904) — Iterates the event-schedule table; for each event whose trigger date matches the current game turn, formats a notification message, animates the info panel, displays it, then calls WriteEventField and UnpackEventRecord to commit the event effect.

35. **PackEventRecord** (~line 13098) — Builds a compact byte list of city indices or route IDs affected by a scheduled event record, based on the event type, and returns the count.

36. **WriteEventField** (~line 13203) — Writes the event's result byte to either the char-region table ($FF1298) or the global event-effect table ($FF99A4) based on the event's group flag.

37. **UnpackEventRecord** (~line 13230) — Expands an event record: finds which char and player are affected by a city-type event and updates the popularity-distance table for all relevant player/city combinations.

38. **CheckEventConditionS2** (~line 13324) — Scans the two event-condition tables and, for any event whose trigger date matches the current turn, formats a news-ticker message, animates an info panel, displays it with a wait-for-button, then places the item tile.

39. **ExecuteEventAction** (~line 13450) — Iterates the active-event list; for events whose start or end dates match the current turn, loads the appropriate char portrait screen, formats a dialog describing the event outcome, waits for confirmation, and clears the event from the list.

40. **ApplyEventEffectS2** (~line 13609) — Aggregates char assignment counts across all player routes into a temporary work buffer, then for any city whose total exceeds the threshold applies a random bonus increment to matching char assignment records.

41. **HandleEventConsequence** (~line 13687) — Clears the per-player event-consequence flags, then scans all route slots looking for slots in state 3 with completion flag ≤1; for each found slot it sets the corresponding bit in the player's route-result byte.

42. **GameLogic2** (~line 13734) — Calls InitQuarterEvent, MakeAIDecision, AnalyzeRouteProfit, UpdateSlotEvents, and OptimizeCosts in sequence to perform the AI game-logic phase for the current quarter.

### AI decision + route optimization (~lines 13751–14800)

43. **InitQuarterEvent** (~line 13751) — Reads the quarter-indexed event-count and popularity tables, stores the values in RAM, then calls a random-check function ($021FD4); if it returns 1 the popularity cap is set to 100.

44. **MakeAIDecision** (~line 13785) — For each AI player, generates three random stat-adjustment values (using table-driven ranges) and adds them to the player's three decision bytes in the route-priority table.

45. **AnalyzeRouteProfit** (~line 13839) — Computes expected route revenue for all players by combining char stats, city popularity, game-turn scaling, and route-slot assignment counts; updates the per-player revenue forecast buffers and deducts total costs from each player's cash balance.

46. **OptimizeCosts** (~line 14134) — Scans all player route slots for pending cost-optimisation events (type 6, stage 4); for each, generates a random outcome and either offers the player an upgrade dialog (for the human player) or silently accepts/rejects for AI players, clearing the slot on rejection.

47. **RunTurnSequence** (~line 14292) — Renders the full turn intro sequence (route maps, banner graphics, city panels) for the current player, loops over three route-panel subviews calling ProcessRouteDisplayS2, then handles end-of-turn input (direction keys to change route type, B to finish) and invokes CalcRouteRevenue on exit.

48. **ValidateRouteNetwork** (~line 14763) — Formats a two-city confirmation message and shows a yes/no dialog; returns 1 if the player confirmed, 0 otherwise.

### Route display S2 + char animation (~lines 14800–15880)

49. **ProcessRouteDisplayS2** (~line 14800) — Renders one route-panel subview for a player: computes the stat change and revenue for the selected route type, displays the revenue figure and occupancy bar, draws a proportional colored tile strip, decompresses and places the plane graphic, and calls RenderRouteIndicator.

50. **ShowRouteSelectMenu** (~line 15131) — Shows the aircraft-selection menu for a route, allows the player to navigate with left/right input to cycle through aircraft types, updates the route indicator graphic, and returns the selected aircraft index (or -1 for cancel/back).

51. **RenderRouteIndicator** (~line 15265) — Draws the coloured route-popularity indicator tile for a given player/route-type combination: reads the relevant stat byte, applies any in-progress stat change, clamps to [0,100], scales to a pixel position, and calls TilePlacement.

52. **WaitInputWithTimeout** (~line 15364) — Polls for any input matching the caller's button mask while looping a GameCommand timeout ticker; once a matching button is pressed (or the ticker expires) resets the ticker tile and returns the button state.

53. **RunAITurn** (~line 15410) — Executes a full AI turn for the current player: if the player is human calls the human-interaction sub-routine; then unconditionally calls the AI route-update, char-event, char-state, cost sub-routines, and char-bonus sub-routine in sequence.

54. **LoadRouteDataS2** (~line 15473) — For each route-type slot (0–6), calls BitFieldSearch to find available chars and, if 1–3 are found, shows a dialog reporting how many chars are available on the new route, optionally loading the player's background screen first.

55. **ProcessCharAnimS2** (~line 15593) — Processes up to four pending char-event animation records for a player's route slots: formats a narrative message describing the event (hire, fire, accident, purchase) depending on the animation code, then shows a text dialog and clears the animation record.

56. **UpdateCharStateS2** (~line 15783) — Advances pending char-countdown timers for a player's route assignments: when a timer expires, if the player is human it shows the station detail and credits the char's bonus to the route's popularity, then marks the assignment complete; if still counting shows a progress dialog.

57. **HandleCharEventTrigger** (~line 15880) — Scans the player's route slots for type-3 char events; for each found, shows the departure/arrival relation panel, presents a hire/dismiss dialog with the char's name, sets the route-flag bit, and clears the slot.

## Functions Skipped

None — all 57 functions were analysed and described.

## Notes

- **SnapshotGameState** (line 12240): the name implies a broad save operation but the code is actually a slot-search helper returning an index; the description reflects actual behaviour.
- **ValidateGameStateS2** (line 12270): similarly named more broadly than its actual scope (it is a route-char-swap confirmation dialog).
- **ResetGameStateS2** (line 12636): the code implements a number-picker widget, not a state reset — description reflects observed behaviour.
- **ProcessUndoRedo** (line 12369): despite the name the logic is a char-slot reassignment flow with forward/backward navigation; no undo stack found.
- Several functions in this range (RunTurnSequence, ShowGameStatus, FinalizeQuarterEnd) are large (500–1500 bytes) and contain substantial untranslated dc.w sequences; descriptions are inferred from the translated portions and called-function names.
