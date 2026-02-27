# B-057 Batch 1 Findings: section_010000.asm Lines 1-8000

Generated: 2026-02-26
Scope: All (TODO: name) and (TODO: describe) tags in lines 1-8000

## Function Descriptions

### ShowRouteDetailsDialog (line 1509)
**Address**: $011014-$0112ED (730 bytes)
**Description**: Draws a pop-up dialog box showing route details; decompresses graphics, fills tile rectangles for three text rows, then renders route city pair info.

### ManageRouteSlots (line 1727)
**Address**: $0112EE-$011843 (1366 bytes)
**Description**: Interactive browser for a player's route slots; builds a list of slot revenue values, renders the route slot screen, and runs an input loop for slot selection and navigation.

### CalcRouteRevenue (line 2244)
**Address**: $011906-$0119B3 (174 bytes)
**Description**: Calculates revenue for one route slot given player index and slot index; looks up demand/capacity data, calls route-value helpers, and returns net revenue.

### ProcessPlayerRoutes (line 2451)
**Address**: $011B26-$011BB1 (140 bytes)
**Description**: Marks a player's changed route slot as pending (sets bit 7 of byte $A), accumulates route bitmasks, then clears any route-slot bits that changed since last turn.

### IsRouteSlotPending (line 2643)
**Address**: $011CF6-$011D4F (90 bytes)
**Description**: Scans a player's relation slots and returns 1 if any slot has its pending flag (bit 7 of offset $A) set, otherwise 0.

### AccumulateRouteBits (line 2682)
**Address**: $011D50-$011D89 (58 bytes)
**Description**: Iteratively ORs available route-bit masks into an output bitmask by calling FindAvailSlot in a loop until the remaining bit set is exhausted.

### FindAvailSlot (line 2712)
**Address**: $011D8A-$011E6B (226 bytes)
**Description**: Scans all 32 route positions for a player's relation slots, collecting city-pair route bits that are present in the global mask but not yet claimed; returns the accumulated available-slot bitmask.

### ClearRouteSlotBit (line 2804)
**Address**: $011E6C-$011F6D (258 bytes)
**Description**: Clears a specific route-bit from the player's route bitmask, then sets the pending flag on every relation slot whose city pair references that route position.

### UpdateRouteRevenue (line 2918)
**Address**: $011F6E-$012075 (264 bytes)
**Description**: Iterates a player's four route slots; for active (status=3) slots accumulates CalcRouteValue output into the player finance table; for placeholder (status=6) slots clears slot status if no matching route is found.

### CalcRouteProfit (line 3016)
**Address**: $012076-$012513 (1182 bytes)
**Description**: Computes quarterly profit for all of a player's routes; processes route bitmasks, calls UpdateRouteRevenue, and updates player finance totals.

### ShowRouteInfoDlg (line 3427)
**Address**: $012514-$0127D5 (706 bytes)
**Description**: Displays a route-info dialog showing pending city-pair relation entries; decompresses graphics, scans relation slots with the pending flag, formats city names from a lookup table, and prints them.

### FormatRouteDetails (line 3665)
**Address**: $0127D6-$012B3D (872 bytes)
**Description**: Formats and renders the route details screen for a given player and route type; clears the screen, decompresses background tiles, iterates relation slots to build city-pair rows with profit indicators, and calls ShowDialog.

### GetCharStatField (line 3948)
**Address**: $012B3E-$012E03 (710 bytes)
**Description**: Interactive character stat browser; displays each character's stats across all relation slots with arrow-key navigation and page scrolling, returning the selected stat value.

### ClearRoutePendingFlags (line 4194)
**Address**: $012E04-$012E2D (42 bytes)
**Description**: Clears the pending flag (bit 7 of offset $A) on all 40 relation slots for a given player, resetting their dirty state.

### CalcRouteValue (line 4214)
**Address**: $012E2E-$012E91 (100 bytes)
**Description**: Computes a route's monetary value given player index and city code; reads the char stat and airport capacity table, applies a scaled formula (capacity * (stat+1) / 4), and returns the result.

### ShowQuarterSummary (line 4257)
**Address**: $012E92-$0131D9 (840 bytes)
**Description**: Displays the end-of-quarter summary screen; reads the current player and turn counter, calls route-selection and profit-computation helpers, shows a summary dialog with route results and financial totals.

### IsCharAttrValid (line 4545)
**Address**: $0131DA-$01325B (130 bytes)
**Description**: Validates that a character type's attributes are usable; checks both primary and secondary attribute byte ranges against the $FF09D8 attribute table, returning 1 if all entries are non-zero type.

### RunRouteManagementUI (line 4604)
**Address**: $01325C-$0134F5 (666 bytes)
**Description**: Runs the route management UI for a player; calls SelectCharRelation to build available slots, then loops reading directional input to scroll through char-relation pairs and update the displayed sprite and text panel.

### SelectCharRelation (line 4850)
**Address**: $0134F6-$013613 (286 bytes)
**Description**: Populates the display with available char-relation options for a given player and route slot; counts chars in slots via SearchCharInSlots, prints city labels, and for each of three slots shows the char name and quarter-bonus value or a status string.

### FindRelationByChar (line 4957)
**Address**: $013614-$0136F7 (228 bytes)
**Description**: Counts how many times a given character ID appears across all player slot char-arrays (both 6-slot and 4-slot groups) and tallies the occurrence counts into a caller-supplied output array indexed by char position.

### SearchCharInSlots (line 5058)
**Address**: $0136F8-$01377D (134 bytes)
**Description**: Counts how many active relation slots for a given player contain a specific character ID (as either slot.city_a or slot.city_b), returning the total count.

### RenderCharacterPanel (line 5117)
**Address**: $01377E-$013CBF (1346 bytes)
**Description**: Draws the character detail panel for one route slot; sets up text windows, prints the char name, displays bonus value labels (total, half, quarter, double) computed from CalcQuarterBonus, and shows a star rating bar.

### FindSpriteByID (line 5578)
**Address**: $013CC0-$013D13 (84 bytes)
**Description**: Searches a player's four route slots for one whose status is 6 (sprite active) and whose char-ID and city-ID fields match the given arguments; returns the slot's byte-field-4 value or 0 if not found.

### UpdateSpritePos (line 5616)
**Address**: $013D14-$013E61 (334 bytes)
**Description**: Loads and places character portrait sprites for a set of route slots at calculated tile positions; decompresses each portrait, builds a tile-attribute word array, calls GameCommand to place tiles, then prints the revenue value beside each portrait.

### InitRouteBuffer (line 5728)
**Address**: $013E62-$013EF1 (144 bytes)
**Description**: Populates the $FF9A10 route-summary buffer from a caller-supplied revenue array; iterates three bucket groups (sizes from table $5F908), summing positive revenue values and counting active slots per bucket.

### InitSpriteData (line 5794)
**Address**: $013EF2-$0140DB (490 bytes)
**Description**: Scans characters compatible with a given player and char-type, fills a sprite-data working area with their indices and revenue values, and prepares the display list for the route management sprite display.

### CalcQuarterBonus (line 5977)
**Address**: $0140DC-$014117 (60 bytes)
**Description**: Computes a quarter-scaled bonus for a relation-slot revenue value; multiplies input by 20 (lsl*4, add, lsl*2), divides by turn-modulo-3 using Divide32/Multiply32, and clamps to 100, returning the percentage bonus.

### UpdateCharacterStats (line 6005)
**Address**: $014118-$014201 (234 bytes)
**Description**: Counts how many trainer entries (action-type $0E) in a player's char-slot arrays match a given character ID across both the 6-slot and 4-slot groups; returns count * 30.

### ProcessCharActions (line 6108)
**Address**: $014202-$014691 (1168 bytes)
**Description**: Processes all pending char actions for the current player in a turn; iterates each char's stat block, selects a target char via the selection UI, then calls ProcessCharacterAction for each active char-action slot.

### ProcessCharacterAction (line 6488)
**Address**: $014692-$01489D (524 bytes)
**Description**: Applies a single char action to a relation slot; saves old stat bytes, calls CalcCharacterBonus to display the bonus screen, then loops calling ApplyCharacterEffect until the player confirms or cancels, restoring stats on cancel.

### ValidateCharacterState (line 6675)
**Address**: $01489E-$014971 (212 bytes)
**Description**: Decompresses status-icon tiles and displays one of three status tile sets based on char action flags (bits 0-2 of offset $A): bit2=active(tile 0), bit1=changed(tile $10), bit0=pending(tile 8).

### CalcCharacterBonus (line 6750)
**Address**: $014972-$014AA9 (312 bytes)
**Description**: Displays the character bonus detail screen; reads char type and nibble fields, clears the screen, decompresses a portrait graphic, places tiles, then prints char name, type string, and bonus values at fixed positions.

### ApplyCharacterEffect (line 6835)
**Address**: $014AAA-$014D63 (698 bytes)
**Description**: Interactive UI for applying a char effect to a target relation slot; shows available match slots, runs an input loop for Up/Down/A/B navigation to select a target, calls BrowsePartners on B-button, and returns the selected slot index or -1 on cancel.

### WaitStableInput (line 7071)
**Address**: $014D64-$014DA5 (66 bytes)
**Description**: Polls ReadInput repeatedly until the input state is stable for N consecutive frames (param), advancing the frame via GameCommand each matching poll; used to debounce button input.

### RankCharCandidatesFull (line 7102)
**Address**: $014DA6-$01503F (666 bytes)
**Description**: Full interactive character selection UI; displays a sorted list of compatible chars with portrait and detail panels, handles Up/Down navigation with cursor wrapping, and returns the selected char index.

### RenderTilePattern (line 7351)
**Address**: $015040-$0154F7 (1208 bytes)
**Description**: Displays the list of chars compatible with the current relation slot type and highlights the currently selected char; builds a compact list of compatible-char indices, renders their names and a selection cursor, handles paging, and updates stat bytes on selection change.

### DrawScreenElement (line 7759)
**Address**: $0154F8-$015C4D (1878 bytes)
**Description**: Draws a char's attribute tile panel showing a stat bar, level delta, and selection arrow; computes the stat delta vs baseline, decompresses and places the bar graphic, updates the tile-attribute array, and navigates with Up/Down/A/B input.
