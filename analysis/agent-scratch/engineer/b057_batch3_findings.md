# B-057 Batch 3 Findings

## Functions Described

### Player compare + char detail + game update (~lines 16126–17060)

1. **ShowPlayerCompare** ($01AEB8, ~line 16126)
   - Compares two players: selects "same" vs "different" tile IDs (0x0770/0x771 or 0x772/0x773), polls for
     input, and dispatches the result via display/tile calls. Returns the button state in D0.

2. **GetModeRowOffset** ($01AFCA, ~line 16214)
   - Maps a display mode index (0–3) to a fixed row offset value (0x2A, 0x26, 0x22, or 0x19) and returns it in D0.
   - Already had no TODO comment (no `(TODO: describe)` tag was present). Listed for completeness.

3. **DrawCharDetailPanel** ($01AFF0, ~line 16240)
   - Draws a character detail panel: sets up a fixed data block, calls tile/text layout routines, decompresses
     a portrait graphic to the work-RAM buffer, and renders character stat fields via GameCommand.

4. **ShowCharStats** ($01B0CE, ~line 16310)
   - Displays a character statistics screen: allocates two panel areas, then renders the character's name,
     rating, age, and route load values as formatted text tiles at computed screen coordinates.

5. **MatchCharSlots** ($01B324, ~line 16506)
   - Matches character slots between two players: calls a lookup function ($00D648) to map player IDs to
     slots, fills slot array at $FF8804 with matched character indices (or 0xFF when no match), iterating
     up to 4 slots.

6. **GameUpdate2** ($01B49A, ~line 16669)
   - Main per-turn update: selects active player order (randomly if multiplayer, from save otherwise), iterates
     all four players each turn, running their menu or AI strategy, loads/unloads resources, shows relation
     panels and player info, and handles scenario event sequencing and post-turn screen transitions.

### Main menu + relation push + char trade (~lines 17011–18605)

7. **RunMainMenu** ($01B91A, ~line 17011)
   - Renders the main menu screen for a given player: clears the background, draws two header tile rows
     (tile IDs 0x077F and 0x077D), calls RenderDisplayBuffer to populate the display, then calls ShowPlayerInfo.

8. **HandleMenuSelection** ($01B9A0, ~line 17056)
   - Highlights a selected city on the route map: places a tile at the city's computed pixel coordinates
     (multiplied from row/col args), draws a stat box via GameCommand, and calls GameCmd16 to refresh.

9. **DisplayMenuOption** ($01BA1C, ~line 17098)
   - Draws a menu option entry: looks up the option's screen position from a table, checks whether the
     option is currently selected (flag arg == 1), and renders the tile with highlight or normal colour
     for each of up to 5 option slots.

10. **ValidateMenuInput** ($01BB2E, ~line 17193)
    - Main menu input validation loop: iterates until the menu returns code 0x0B (exit), dispatching each
      input to PrepareRelationPush (for non-flagged entries) or ExecMenuCommand (for flagged ones), refreshing
      the main menu after each action.

11. **ExecMenuCommand** ($01BBCC, ~line 17260)
    - Executes a menu command for a selected city: initialises the route-map display, polls for directional
      and button input in a loop, dispatches to CharacterBrowser (B button), UpdateCharRelation (A on
      same city), DrawStatDisplay/DisplayMenuOption (cursor movement), and returns the selected city index
      or an exit code.

12. **PrepareRelationPush** ($01C28E, ~line 17806)
    - One-instruction thunk (`MOVE.W D1,-(SP)`) that pushes D1 before falling through to CalcRelationship;
      serves as the caller-side argument-push stub.

13. **CalcRelationship** ($01C290, ~line 17816)
    - Game-command dispatcher: reads a command index (0–10), then jumps via a PC-relative table to one of
      ten sub-functions (RecruitCharacter, ProcessCharActions, ProcessRouteAction, RunPurchaseMenu,
      ShowQuarterReport, BuildRouteLoop, RunTurnSequence, ShowQuarterSummary, RunPlayerTurn,
      RunQuarterScreen, RunGameMenu), returning the sub-function's result or 0x0B on exit.

14. **UpdateCharRelation** ($01C342, ~line 17877)
    - Updates a character relation between two players: saves the current mode flag, calls ShowGameScreen
      and ResourceUnload, then enters an input poll loop rendering relation data (6 or 4 slots depending on
      char index) until the player presses the action button, then reloads resources and returns to the main menu.

15. **ShowPlayerInfo** ($01C43C, ~line 17971)
    - Already described: "Display player info screen with formatted data". Skipped (no TODO present).

16. **EvalCharMatch** ($01C54E, ~line 18044)
    - Displays a character match selection box for up to 4 player slots: prints each slot's status string
      (selected or unselected) and polls for directional input, toggling the active/inactive flag of each
      slot byte on button presses, looping until the player exits.

17. **ProcessCharTrade** ($01C646, ~line 18143)
    - Runs the character trade screen: decompresses the trade background, places the cursor sprite, calls
      InitFlightDisplay/UpdateFlightSlots, then processes a directional+button input loop supporting
      cursor movement (D-pad), character browsing (B), character selection (A), player info view (Start),
      and exit (C/back), animating flight paths between inputs.

### Display buffer + graphics utilities (~lines 18602–19460)

18. **RenderDisplayBuffer** ($01CB82, ~line 18602)
    - Renders the main world-map display buffer for a given player/mode: copies layout data, resolves up to
      7 visible players' screen positions from RAM tables, decompresses the background tileset, DMA-loads it
      to VRAM, iterates 4 route slots placing airline icons at computed tile coordinates, then prints the
      current year/quarter string in a text window.

19. **UpdateGraphicsState** ($01CE3E, ~line 18828)
    - Manages the player-select screen: cycles the active player display (mod 4), calls LoadScreen,
      ShowRelPanel, RunMainMenu each iteration, polls for input (D-pad to browse chars via CharacterBrowser,
      Enter to select, Back to exit), updates the relation text window, and stores the final selection
      in $FF9A1C before returning.

20. **AllocGraphicsMemory** ($01D0C6, ~line 19053)
    - Allocates/computes the character compatibility value between two players: calls RangeLookup and
      CharCodeCompare to check compatibility, then if valid displays the relation score panel (name, value,
      relation rating) via PrintfNarrow calls, offers a "browse relations" interaction, and updates the
      displayed character stat.

21. **ClearGraphicsArea** ($01D30E, ~line 19230)
    - Empty stub (single RTS); does nothing. Likely a placeholder left from an earlier implementation.

22. **RefreshAndWait** ($01D310, ~line 19237)
    - Issues two GameCommand calls (cmd 0x0E/1 and cmd 0x14) then returns 1 in D0 if bit 0 of the combined
      result byte is set, 0 otherwise; used to refresh the display and test a ready condition.

23. **SetDisplayMode** ($01D340, ~line 19260)
    - Sets the low byte of the display-state word at $FF1274 to the given mode value; if mode is 0, first
      issues a GameCommand($13, $10) clear call and resets the stored selection at $FFBD52 to 0xFFFF.

24. **SetDisplayPage** ($01D37A, ~line 19279)
    - Sets the high byte of the display-state word at $FF1274 to the given page value; if page is 0, first
      issues a GameCommand($18) sync call before updating.

25. **MenuSelectEntry** ($01D3AC, ~line 19301)
    - Already described: "Validate selection index, dispatch GameCommand calls". Skipped (no TODO present).

26. **LoadDisplaySet** ($01D444, ~line 19358)
    - Already described: "Load triple-pointer display resource set from table". Skipped (no TODO present).

### Memory + VRAM utilities (~lines 19440–19720)

27. **MemFillByte** ($01D520, ~line 19440)
    - Already described: "Fill memory with a byte value". Skipped (no TODO present).

28. **MemCopy** ($01D538, ~line 19456)
    - Already described: "Copy bytes from source to destination". Skipped (no TODO present).

29. **MemFillWord** ($01D550, ~line 19472)
    - Already described: "Fill memory with a word value". Skipped (no TODO present).

30. **VRAMBulkLoad** ($01D568, ~line 19489)
    - Already described: "Transfer tile data to VRAM in chunks via GameCommand". Skipped (no TODO present).

31. **PollAction** ($01D62C, ~line 19568)
    - Already described: "Poll for action/input with different loop strategies". Skipped (no TODO present).

32. **RandRange** ($01D6A4, ~line 19630)
    - Already described: "Random integer in [min, max]". Skipped (no TODO present).

33. **ByteSum** ($01D6FC, ~line 19661)
    - Already described: "Sum bytes in a buffer, return sum in D0.W". Skipped (no TODO present).

34. **ResourceLoad** ($01D71C, ~line 19682)
    - Already described: "Load resource if not already loaded". Skipped (no TODO present).

35. **ResourceUnload** ($01D748, ~line 19698)
    - Already described: "Unload resource if loaded". Skipped (no TODO present).

### Text rendering + tilemap utilities (~lines 19718–20260)

36. **FormatTextString** ($01D772, ~line 19718)
    - Computes a scaled rectangle from row/col/width/height args (subtracting base offsets and multiplying
      widths), then calls AdjustPercentage to pack the result into a scroll-control record at the caller's
      local buffer.

37. **DrawTileGrid** ($01D7BE, ~line 19752)
    - Already described: "Draw grid of tiles from data buffer in nested row/col loop". Skipped (no TODO
      present).

38. **RenderTextLineS1** ($01D840, ~line 19808)
    - Variant of DrawTileGrid that uses Multiply32 instead of a jsr-encoded call for the inner DMA tile
      placement, drawing a row×col grid of tiles from a source buffer via GameCommand DMA (cmd 5).

39. **ProcessTextControl** ($01D8AA, ~line 19856)
    - Issues a single GameCommand DMA tile transfer (cmd 5, sub 2): computes the VRAM offset from row and
      col arguments (shifted left), and sends the source pointer and tile count to the display system.

40. **AlignTextBlock** ($01D8E2, ~line 19882)
    - Issues GameCommand($13, $10) to trigger a display-layer sync/align operation; a one-call wrapper with
      no other logic.

41. **SetScrollOffset** ($01D8F4, ~line 19894)
    - Sets the scroll registers for both background planes: if both offsets are zero clears the scroll buffer,
      otherwise writes horizontal and vertical scroll values at $FF5804 and issues GameCommand DMA (cmd 8
      and cmd 5) to push the scroll table to VDP.

42. **PackGameState** ($01D990, ~line 19954)
    - Packs scroll/display state into a VRAM buffer: fills a working area at $FF1804+$5000, optionally
      writes a signed scroll-delta word at the computed column offset for each of N rows, then DMA-transfers
      the packed buffer to VRAM address $FC00 via GameCommand.

43. **UnpackGameState** ($01DA34, ~line 20018)
    - Draws a Bresenham-style line in tile-map RAM: given two (col, row) endpoints and a tile palette word,
      uses integer error-accumulation to step along the longer axis, writing the tile attribute word into
      the VDP background-A tilemap buffer at each point.

44. **DrawTilemapLine** ($01DC26, ~line 20241)
    - Draws a line between two tile-map coordinates using integer (Bresenham-style) stepping with wrap
      correction: writes a composed tile-attribute word (palette + tile-index bits) into the BG-A tilemap
      buffer in work RAM for each step along the major axis.

### Math + data utilities (~lines 20475–20820)

45. **CalcScalar** ($01DE30, ~line 20475)
    - Calls GameCommand($1A, 0, 0, 0, $20, $20, mode_arg) to configure a background-layer scalar; a thin
      wrapper that pushes fixed arguments plus one variable arg from the caller's frame.

46. **AdjustPercentage** ($01DE52, ~line 20492)
    - Writes a scroll-control block at the address in A0: sets the command word to $0080, encodes two
      2-bit row/col indices into a packed position word, stores the tile-attribute word with the $8000
      flag, and writes a trailing $0080 pad word.

47. **LoadMapTiles** ($01DE92, ~line 20513)
    - Loads and renders the world map tile set: decompresses three LZ-compressed graphics blobs to the work-
      RAM buffer and renders them as tile grids / single rows using DrawTileGrid, ProcessTextControl, and
      VRAMBulkLoad calls.

48. **RoundValue** ($01DF30, ~line 20566)
    - Generates a 16-byte (8 long) tile digit sprite from a 0–99 value: splits the value into tens/units,
      looks up pre-built 8-long digit bitmaps from a table at $48E00, ORs the two digit rows together into
      the caller-supplied output buffer, or zeros the buffer if value <= 0.

49. **PlaceFormattedTiles** ($01DFBE, ~line 20629)
    - Places a formatted numeric tile (0–99) at a given screen position: calls RoundValue to build the digit
      sprite, then ProcessTextControl to send it to VRAM, and finally calls TilePlacement (via jsr pc) to
      draw the tile block at the computed column/row position.

50. **TilePlacement** ($01E044, ~line 20679)
    - Already described: "Set up tile/sprite parameters, call GameCommand #15". Skipped (no TODO present).

51. **GameCmd16** ($01E0B8, ~line 20718)
    - Already described: "Call GameCommand #16 with two args". Skipped (no TODO present).

52. **CopyBytesToWords** ($01E0E0, ~line 20738)
    - Copies N bytes from a source array to every-other byte of a destination array (stride 2), effectively
      expanding a byte array into the low byte of each word slot.

53. **CopyAlternateBytes** ($01E0FE, ~line 20757)
    - Copies N bytes from alternating (stride-2) positions in a source array to consecutive bytes in a
      destination array; the reverse direction of CopyBytesToWords.

54. **MulDiv** ($01E11C, ~line 20777)
    - Already described: "Multiply then divide: (a * b) / c via Multiply32 + SignedDiv". Skipped (no TODO
      present).

55. **ToUpperCase** ($01E14A, ~line 20801)
    - Converts a single ASCII character (passed by value in the low byte of the stack arg) to uppercase:
      subtracts 0x20 if it is in the range 'a'–'z', otherwise returns it unchanged, in D0.

56. **MemMoveWords** ($01E16C, ~line 20817)
    - Already described (no TODO comment present): copies N words from source to destination, choosing
      forward or backward direction based on whether src > dst, to handle overlapping regions correctly.

57. **SetupPointerRegs** ($01E1A4, ~line 20858)
    - Copies a null-terminated string from A1 to A2 (byte by byte until the NUL is copied), then returns
      the original start address of A2 in D0; a strcpy that also saves/restores A2.

58. **StringAppend** ($01E1BA, ~line 20875)
    - Appends (concatenates) a null-terminated string from A1 onto the end of the null-terminated string
      at A2: scans A2 to its terminator, then copies from A1 including the NUL, returning the original A2
      base in D0.

59. **SearchTable** ($01E1D8, ~line 20899)
    - Returns the length of a null-terminated string at the address in the stack arg: scans forward byte
      by byte until the NUL, then returns the byte count (string length) in D0.W.

### Input + iteration + game update utilities (~lines 20918–23900)

60. **ReadInput** ($01E1EC, ~line 20918)
    - Already described: "Read joypad input via GameCommand #10". Skipped (no TODO present).

61. **IterateCollection** ($01E234, ~line 21002)
    - Wait-for-press utility: if the system is active, first flushes any held button (looping ReadInput
      until zero), then waits for a new press; if inactive, calls PollInputChange with 60-frame timeout
      and returns the first input value in D0.

62. **ProcessInputLoop** ($01E290, ~line 21037)
    - Already described (comment present): counts down a loop, calling ReadInput each iteration and
      issuing GameCommand #14 between polls; sets an init flag at $FFA7D8 after the loop and returns the
      final ReadInput value.

63. **PollInputChange** ($01E2F4, ~line 21078)
    - Already described (comment present): polls ReadInput in a loop for N frames, issuing GameCommand #14
      between reads, and returns the first input value that differs from the previous read.

64. **WeightedAverage** ($01E346, ~line 21115)
    - Computes a weighted average: multiplies value-A by weight-B and value-B by weight-A (via Multiply32),
      sums the products, then divides by the total weight (A+B) using a combined divide call ($03E0C6);
      returns zero if both weights are zero.

65. **PreLoopInit** ($01E398, ~line 21146)
    - Already described (comment present): initialises display layers by calling GameCommand(16, 0, 64)
      to set 64-column mode and GameCommand(26, ...) twice to configure both background layers at
      (0,0,32,32,$8000).

66. **StringConcat** ($01E3EE, ~line 21161)
    - Thin wrapper around StringAppend: pushes both pointer args onto the stack and calls StringAppend,
      then returns (D0 = base of destination string).

67. **GameUpdate3** ($01E402, ~line 21230)
    - Per-round city/route update: calls ClampValue, iterates CalcCityStats for all 7 cities, calls
      ValidateRange (and unloads resources if needed), refreshes the map display via MenuSelectEntry,
      sets the text window, optionally loads background graphics, then runs ProcessInputEvent, iterates
      PrepareTradeOffer for 4 players, calls FilterCollection, UpdateRouteFieldValues, and
      UpdateGameStateCounters before reloading resources.

68. **ValidateRange** ($01E4BA, ~line 21255)
    - Sums the aircraft count fields (bytes at offsets +4 and +5) across all 4 player records at $FF0018,
      returning the total in D0.W; used to check whether any player has aircraft assigned.

69. **ClampValue** ($01E4EC, ~line 21345)
    - Initialises the route-scoring buffer ($FFB4E4, 0x500 bytes): for each of 4 players iterates their
      active routes, resolves city coordinates via D648 (RangeLookup), fills the per-player/per-route
      score entries, then calls CompareElements to rank all routes.

70. **CompareElements** ($01E5D2, ~line 21453)
    - Scores and ranks route entries across all 4 players: for each player-to-player pair, finds matching
      route type-6 entries via BitFieldSearch, calls SortElements to get a base score, then adds
      individual route scores from the $FFB4E4 table for matching city pairs, accumulating into $6(a3).

71. **SortElements** ($01E6E8, ~line 21604)
    - Computes a per-route earnings score for a single city/player combination: scans the character and
      route arrays for matching entries (by city index and season flag), accumulates a weighted sum
      factored by number of qualified characters, adjusts by year difficulty and remaining turns, and
      returns the result in D3.

72. **FilterCollection** ($01E854, ~line 21720)
    - Updates per-player demand/capacity scores for all 4 players and 7 cities: computes each player's
      aggregate demand score (weighted sum of char-stat bytes multiplied by economy/popularity factors),
      clamps it to 0–100, stores in the demand table at $FF0230, then distributes route capacity scores
      (clamped 0–50) per city into adjacent word slots.

73. **CalcCityStats** ($01E98E, ~line 21997)
    - Calculates city traffic and revenue stats for one city slot: sums passenger counts and revenue
      products from active routes (using Multiply32), applies a 3:2 weighting to connecting routes,
      then insertion-sorts up to 3 top-competitor city indices and stores the resulting traffic/revenue
      summary at the city's entry in $FFBDE4.

74. **GetPlayerInput** ($01EC0E, ~line 22025)
    - Checks whether a given player's airline has any active route slots: scans up to 4 entries in the
      player's route table at $FFBA80 (checking byte at offset +1) and returns 1 in D0 if any slot is
      active, 0 otherwise.

75. **ProcessInputEvent** ($01EC40, ~line 22349)
    - Main event processing loop for one game turn: initialises route and input buffers, checks which
      players have active routes, calls MapInputToAction for the current city, iterates all 4 player/city
      combinations accumulating route scores from the $FFB4E4 and $FF1004 tables, then for each of 7
      city slots iterates over active players to call UpdateAnimation/PositionUIControl/ValidateInputState
      and FadeGraphics.

76. **MapInputToAction** ($01EF5A, ~line 22489)
    - Maps a city/player index to a display action: if the system is active and the index is < 7, loads
      the city screen and optionally calls UpdateAnimation to show the city's roster; for index >= 7 loads
      a full-screen background; then draws the route-slot selection box with city name and player name
      tiles and calls UpdateAnimation for the current slot.

77. **ValidateInputState** ($01F0FA, ~line 22525)
    - Checks whether a given character slot index is currently "locked" (active) in any of the 4 player
      route bitmask arrays at $FF08EC: returns 1 if the corresponding bit is set in any player's mask,
      0 otherwise (or 0 if the index is >= 32).

78. **UpdateAnimation** ($01F13C, ~line 22731)
    - Renders the animation bar chart for a city slot: computes the "peak traffic" value across all active
      player/city combinations (scanning either the char-presence bitmask or route-data arrays), then
      scales each player's bar height by dividing total traffic by a year-difficulty factor and renders
      each bar as a tile column via TilePlacement and GameCommand, printing the numeric value and a
      row icon alongside.

79. **RenderAnimFrame** ($01F352, ~line 23141)
    - Computes per-player route revenue shares for a specific city/slot: retrieves city capacity factors
      from $FFBDE4, calculates weighted demand contributions from both endpoint cities (scaled by the
      current market-share percentage at $FFBD4C), sums the products, and stores scaled revenue values
      per player into the output accumulator fields, calling TransitionEffect to determine each player's
      relative slot index.

80. **TransitionEffect** ($01F7C0, ~line 23191)
    - Looks up a character's slot assignment for a given player/city pair: scans the player's route entry
      list at $FF9A20 (up to the count in byte +4 of the airline record) comparing the source and
      destination city indices, returns the matched slot index in D0 (or 0xFF if not found).

81. **FadeGraphics** ($01F82E, ~line 23494)
    - Applies negotiation/trade power weighting to each active player: for each city slot calls
      ManageUIElement to find the matched route index, computes per-player revenue contributions scaled
      by the negotiation power factor (CalcNegotiationPower), and calls UpdateUIPalette to write the
      final colour/value into each player's UI palette entry, iterating until all city slots are processed.

82. **ManageUIElement** ($01FB84, ~line 23579)
    - Searches a player's route list for a route that connects two given city indices (in either order):
      scans the flight-path entries at $FF9A20 comparing (src,dst) and (dst,src) pairs, returns the
      matching slot index in D0 (or 0xFF if none found).

83. **PositionUIControl** ($01FC50, ~line 23828)
    - Computes and applies per-player UI bar positions: calls ResizeUIPanel for each of 4 players to get
      a city-slot index, then for valid (< 0x28) slots calculates scaled revenue scores from the route
      tables (weighted by $FF0120 popularity factors and negotiation power) and calls UpdateUIPalette to
      write the result, accumulating total revenue in D6.

84. **ResizeUIPanel** ($01FF0C, ~line 23892)
    - Returns the city-slot index of a given character in a given player's route list: scans the player's
      flight entries at $FF9A20 comparing the destination city byte, returns the matched index in D0 (or
      0xFF if not found).

85. **UpdateUIPalette** ($01FF9E, ~line 23894)
    - Updates a single player/slot palette entry: given player index (D6), slot index (D7), and a revenue
      value (D3), resolves the player's airline record ($FF0018), the route entry ($FF9A20), and the
      capacity table ($FFB4E4), then stores the scaled colour value into the route's palette slot.

---

## Functions Skipped (already described / no TODO tag)

- GetModeRowOffset (line 16214) — no TODO tag
- ShowPlayerInfo (line 17971) — already described
- MenuSelectEntry (line 19301) — already described
- LoadDisplaySet (line 19358) — already described
- MemFillByte (line 19440) — already described
- MemCopy (line 19456) — already described
- MemFillWord (line 19472) — already described
- VRAMBulkLoad (line 19489) — already described
- PollAction (line 19568) — already described
- RandRange (line 19630) — already described
- ByteSum (line 19661) — already described
- ResourceLoad (line 19682) — already described
- ResourceUnload (line 19698) — already described
- DrawTileGrid (line 19752) — already described
- TilePlacement (line 20679) — already described
- GameCmd16 (line 20718) — already described
- MulDiv (line 20777) — already described
- MemMoveWords (line 20817) — no TODO tag (no `(TODO: describe)` present)
- ReadInput (line 20918) — already described
- ProcessInputLoop (line 21037) — already described
- PollInputChange (line 21078) — already described
- PreLoopInit (line 21146) — already described

---

## Notes

- **ClearGraphicsArea** (line 19230) is an empty stub (single `rts`); described as placeholder.
- **PrepareRelationPush** (line 17806) is a single-instruction thunk (`move.w d1,-(sp)`) before CalcRelationship.
- **CalcRelationship** (line 17816) is misnamed: it is actually the main game-command dispatcher (jump table over 10 sub-commands). The name in the source does not match behaviour; noted for possible rename.
- **AdjustPercentage** (line 20492): the name is misleading — it actually packs a scroll-control structure (command/position/tile-attr words). Noted for possible rename.
- **AllocGraphicsMemory** (line 19053): the name is misleading — it actually displays a character compatibility score panel. Noted for possible rename.
- **SortElements** (line 21604): the name is misleading — it actually computes a weighted earnings score for one route/city combination. Noted for possible rename.
- **FilterCollection** (line 21720): the name is plausible — it filters/normalises demand values across players and cities.
- **UnpackGameState** (line 20018): the name is misleading — it draws a Bresenham line in tilemap RAM. Noted for possible rename.
- **PackGameState** (line 19954): the name is misleading — it packs scroll-delta data into VRAM. Noted for possible rename.
- Functions in the 23000–23925 range (RenderAnimFrame, TransitionEffect, FadeGraphics, ManageUIElement, PositionUIControl, ResizeUIPanel, UpdateUIPalette) all operate on the same per-player revenue/palette data structures; their names are functional approximations based on what they do to those structures.
