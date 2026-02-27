# B-058 Batch 1 Findings: section_030000.asm lines 1-7000

**Date**: 2026-02-26
**File**: `disasm/sections/section_030000.asm`
**Range**: lines 1-7000
**TODOs found**: 46
**TODOs replaced**: 46
**TODOs unresolved**: 0

## Summary

All 46 `(TODO: name)` placeholders in lines 1-7000 of section_030000.asm were replaced with accurate one-line descriptions derived from reading the 68K assembly code bodies. The functions span alliance management, AI negotiation, character roster management, match simulation, and character compatibility systems.

## Functions Described (in order of appearance)

| Line | Function | Description |
|------|----------|-------------|
| 10 | SearchCharInAlliances | Ranks candidate alliances for current player, shows negotiation dialogue, calls InitAllianceRecords |
| 328 | InitAllianceRecords | Scores and sorts alliance candidates for a player, displays proposal text, returns success flag |
| 636 | ValidateAllianceSlot | Checks player route capacity, presents AI alliance offer dialogue; returns 1 if slot is usable |
| 758 | ProcessAllianceChange | Handles player joining/leaving alliance: shows text, scans for matching chars, presents yes/no dialog |
| 961 | IsAllianceSlotValid | Checks if player alliance slot is empty or if profit ratio meets threshold; returns 1 if invalid |
| 1076 | GetAllianceScore | Formats a profit/loss score message for a character pair in an alliance slot, shows text to player |
| 1193 | ClearAllianceSlot | Resets alliance display slot to default ordering, updates VDP tile display |
| 1237 | ManageAllianceRoster | Interactive alliance roster screen: shows char pairs, handles D-pad navigation, confirm, and cancel input |
| 1755 | RunAIMainLoop | AI negotiation decision loop: evaluates character compatibility, profit, and skill; shows dialogue and makes offers |
| 2738 | PostTurnCleanup | Scans end-of-turn event list, matches char types, formats and displays event result messages |
| 3031 | InitAlliancePrefs | Initialises alliance preference table at $FFA794 based on player type and current game round |
| 3176 | ComputeAllianceScores | Scores each alliance slot for the AI player based on status, char type, and priority flags; writes ranked list |
| 3386 | HasPriorityAlliance | Returns 1 if any active player has a priority-2 alliance entry with a char matching the given range index |
| 3428 | CheckDuplicateAlliance | Returns 1 if two players share an alliance entry of lower rank than the given player pair |
| 3474 | CountAllianceMembers | Counts how many alliance slots for a player index are marked as active (status byte = 1) |
| 3511 | CalcAllianceDifference | Returns the difference in route revenue between two players sharing an alliance entry |
| 3570 | ValidateCharSlots | Clears invalid char slot pairs for a player: removes dead chars and mismatched route assignments |
| 3647 | RankCharByScore | For each slot in player roster, decides whether to renegotiate contract or degrade skill based on profit ratio |
| 3739 | EvaluateNegotiation | Decides AI negotiation action for a char slot: calls NegotiateContract, CalcRecruitmentCost, or adjusts score |
| 3853 | NegotiateContract | Resolves a contract renegotiation: adjusts level/stats if both chars are available, triggers growth/levelup |
| 4117 | AcquireCharSlot | Adjusts char slot value by compatibility offset; updates char base stat if relation score exceeds threshold |
| 4416 | DegradeCharSkill | Reduces char level and alliance stamina; calls AcquireCharSlot or SetSubstituteFlag based on slot state |
| 4595 | CalcRecruitmentCost | Finds best char replacement for a slot; transfers or trains char based on skill level comparison |
| 4843 | TransferCharSlot | Moves stamina from a source char slot to a destination slot; updates alliance stamina counters; returns success |
| 4958 | ClearSubstituteFlag | Clears bit 1 of the flags byte ($A) in a character slot record (marks char as no longer a substitute) |
| 4981 | SetSubstituteFlag | Sets bit 1 of the flags byte ($A) in a character slot record (marks char as substitute) |
| 5003 | ReorderMatchSlots | Iterates match slots for a player; evaluates lineups, updates char metrics, clears invalid pairs |
| 5086 | EvaluateMatchLineup | Checks stamina and substitute status for a single match slot pair; calls FindOpenCharSlot2 if needed |
| 5200 | FindOpenCharSlot2 | Finds an available open char slot for two char indices under a player; dispatches to ScanCharRoster or GetActiveCharCount |
| 5291 | ScanCharRoster | Checks if a char pair is already in the alliance bitmask or if any roster slot is still available; returns 1 if open |
| 5380 | GetActiveCharCount | Returns 1 if the given char-type pair has a non-zero stamina byte in the alliance table, else 0 |
| 5401 | UpdateCharMetrics | Records a char-pair relation, updates alliance bitmasks and VSRAM, adjusts stamina, shows relation panel |
| 5677 | ApplyRelationBonus | Initialises a relation record struct, computes max skill bonus from char types, calls CalcCharCompat |
| 5823 | GetCharTypeBonus | Returns scaled skill bonus (1-9) for a char based on compat score and the given level value |
| 5866 | CalcCharCompat | Computes compatibility score for a char pair: multiplies stat fields, divides by totals, scales by CharCodeScore |
| 5933 | ApplyCompatPenalty | Reorders match slots for a player: saves, clears, and rebuilds slot list from saved data |
| 6012 | SelectBestForTeam | Runs AI team selection loop: evaluates char quality and value across all alliance slots per turn |
| 6148 | GetCharQuality | Returns count of player resource entries that exceed a char's stats (higher = lower quality) |
| 6183 | EvaluateCharPool | Scores alliance preference pairs for AI: checks profitability, availability, and match state; offers contracts |
| 6440 | CheckCharAvailable | Returns 1 if a char type index is already occupied in another player's alliance or match slot |
| 6527 | CalcCharValueAI | Checks all alliance slots for a char; simulates match turns and damage; returns 1 if a profitable match found |
| 6645 | GetCharProfitAI | Returns 1 if the given char pair already appears in any current match slot, 0 if no profit conflict |
| 6710 | SortCharsByValue | Finds best char for an alliance slot via match simulation; calls ProcessCharJoin and RunMatchTurn/ApplyMatchDamage |
| 6830 | StartMatchSequence | Counts how many alliance slots for a char type index are actively filled; returns that count |
| 6859 | RunMatchTurn | Selects best available char for a match turn based on negotiation power, compat score, and skill weights |
| 6990 | ApplyMatchDamage | Searches match slot list for a char pair; returns the slot index of an empty slot or end-of-list index |

## Notable Findings

### Naming Mismatches / Semantic Notes

- **ApplyCompatPenalty** (line 5933): The name suggests applying a penalty from compatibility, but the actual code implements slot reordering -- saving, clearing, and rebuilding the match slot list. The name is misleading; the real function is closer to `RebuildMatchSlots`. Flagged for potential rename.

- **ApplyMatchDamage** (line 6990): The name implies applying damage from a match, but the code is a linear scan that finds an empty or terminal slot index. The real function is closer to `FindMatchSlotIndex`. Flagged for potential rename.

- **StartMatchSequence** (line 6830): The name suggests initiating a match, but the code counts filled alliance slots for a given char type. The real function is closer to `CountFilledAllianceSlots`. Flagged for potential rename.

- **GetCharProfitAI** (line 6645): Returns a conflict flag (1 = char pair already in a match slot), not a profit value. Name is somewhat misleading.

### RAM Layout Confirmed in this Block

- Alliance preference table: `$FFA794` (used by InitAlliancePrefs)
- Alliance stamina table: `$FFBA80` (player * stride + slot offset)
- Char type table: `$FFA6B8` (indexed by char type, 4 bytes per entry)
- Substitute flag byte: offset `$A` in char slot record (bit 1)
- Alliance bitmask: updated in UpdateCharMetrics via VSRAM write

### Architecture Observations

- The AI decision loop (RunAIMainLoop) is a single large function (~1000 lines) that orchestrates the entire per-turn AI negotiation phase. It iterates all alliance preference entries and calls the specialized helpers.
- Match simulation (CalcCharValueAI / SortCharsByValue) uses RunMatchTurn and ApplyMatchDamage as inner helpers to score candidate chars before committing a choice.
- The substitute flag system (ClearSubstituteFlag / SetSubstituteFlag) is a pair of 1-instruction wrapper functions for bit manipulation at char slot offset $A.

## Unresolved TODOs

None. All 46 TODOs in lines 1-7000 resolved.
