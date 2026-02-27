# B058 Batch 2 Findings

## Assignment
File: `disasm/sections/section_030000.asm`
Line range: 7001–14000
TODOs replaced: **46**

## Summary

All 46 `(TODO: name)` / `(TODO: describe)` occurrences in the target line range were
replaced. The build verified byte-identical after edits (`make clean && make all`
succeeded, 1.0MB ROM produced).

## Functions Described

| Function | Lines | Description written |
|---|---|---|
| CalcMatchScore | 7051 | Writes char/player IDs and win/draw flags into match record at $FF88DC |
| ProcessMatchResult | 7128 | Finds best rival char to challenge; calls RemoveCharRelation and SortCharsByValue on success |
| UpdatePlayerRating | 7254 | Scans player char slots for rival match; returns lowest-cost slot index or $FF on failure |
| ResetMatchState | 7571 | Iterates all match slots; applies char growth and level-up outcomes, sets win/loss flags |
| ApplyCharGrowth | 7653 | Decrements training counter for chars matched against given char; returns 1 if any counter changed |
| ProcessLevelUp | 7730 | Checks level-up conditions for a char; writes new skill slot and shows promotion dialog if eligible |
| CheckLevelUpCond | 7849 | Adjusts match-score accumulators for each char slot based on GetCharLevel results |
| GetCharLevel | 7939 | Returns 1 if char ID appears in any active match slot for given player, 0 otherwise |
| IncrementCharLevel | 7975 | Returns 1 if char ID has an active level-up slot (type=$1) in the player skill table |
| ManageCharSkills | 8008 | For each skill group, finds an unlearned skill the char qualifies for and calls TrainCharSkill |
| HasSkill | 8155 | Returns 1 if skill ID is already learned (type=$3) in the player skill table, 0 otherwise |
| UnlockSkill | 8188 | Scans all match slots; calls TrainCharSkill for pending training slots (type=$1), marks done if successful |
| TrainCharSkill | 8230 | Checks skill cost vs player wealth and char stat threshold; deducts cost and records new skill if passed |
| ResetSkillProgress | 8377 | Iterates skill slots; calls ApplyCharBonus to award or clamp accumulated skill XP points |
| ApplyCharBonus | 8430 | Applies accumulated skill bonus to player wealth and clears skill counters; returns 1 on success |
| IncrementAffinity | 8484 | Advances player affinity phase: runs skill reset, level-up check, and threshold evaluation |
| DecrementAffinity | 8543 | Shows affinity-lost dialog, adds $186A0 to player wealth, and resets affinity byte to $64 |
| CheckAffinityThreshold | 8592 | Scans char relations; calls RemoveCharRelation for slots that have exceeded their limit |
| GetAffinityRating | 8657 | Sets affinity-quality bytes (9/A/B) based on player wealth vs target thresholds |
| OfferCharContract | 8713 | Scores all available chars for a player and returns best candidate char index |
| FindBestCharValue | 8880 | Returns highest $FFA6B8 cost field among recruitables that are in the current age window |
| ProcessCharJoin | 8936 | Evaluates all candidate chars for recruitment to a player; returns best scoring char index |
| GetCharStatPtr | 9252 | Returns stat multiplier tier (30/35/50/100/150/200) based on CharCodeCompare score |
| GetCharNamePtr | 9307 | Counts occupied $FFBA80 pair slots for a player; returns slot count |
| GetCharPortraitIdx | 9333 | Returns 0 if char pair already has a relation record or match slot; 1 if slot is free |
| GetCharDescription | 9393 | Returns next open skill slot index (forward or reverse) from the player skill table |
| GetCharTypeID | 9443 | Returns elapsed turns since game start (turn counter minus quarter * 60) |
| GetCharSpecialty | 9455 | Scans 8 skill groups to find and recruit the first char that passes CalcCharStatFull |
| GetCharBackground | 9574 | Searches player char slots for best uncontested partner; returns char index or $FF |
| LookupCharRecord | 9672 | Scores available chars by CalcCharValue and returns best match for the current player/slot |
| CalcCharStatFull | 9789 | Deducts char recruitment cost, writes char to skill slot, shows acquisition dialog; returns 1 on success |
| GetBaseCharStat | 10056 | Iterates 8 skill groups; calls ApplyStatBonus and CheckRecruitEligible for each qualified group |
| ApplyStatBonus | 10119 | Counts unfulfilled skill slots (type=1 with unmet stat threshold) for a player; returns count |
| RecalcAllCharStats | 10182 | Accumulates weighted stat bonuses from all assigned chars; returns highest-scoring category index |
| CheckRecruitEligible | 10408 | Validates slot availability and wealth; deducts cost and records recruitment record if eligible |
| IsCharSlotEmpty | 10500 | Returns 1 if a recruitment slot (type=$6) for the given char and cost exists in the skill table |
| ValidateCharPool | 10538 | Counts chars in the active pool matching a target tier; returns count of qualifying chars |
| GetPlayerCharCount | 10691 | Returns count of char slots occupied by the given player (via BitFieldSearch) |
| RenderGameplayScreen | 10922 | Main map interaction loop: handles cursor, tile selection, char comparison, and dialog display |
| ClearCharSprites | 11425 | Clears the char sprite panel by calling GameCommand $0037 with flag 4 |
| RenderCharInfoPanel | 11440 | Renders the char info/relationship status panel for a given player char pair |
| RenderTeamRoster | 11659 | Displays team roster screen with portraits and stats; routes input to sub-screens |
| RenderMatchResults | 12140 | Shows match result screen with compatible char list; handles char selection and pairing input |
| CheckMatchSlots | 12589 | Returns 1 if all 4 player match slots at $FF8804 are filled (none equal $FF), else 0 |
| RenderPlayerInterface | 12622 | Displays player pairing interface with compat bars; handles up/down selection and confirm/cancel |
| HandlePlayerMenuInput | 13390 | Handles negotiation menu: shows stat bars, processes directional input, confirms char selection |

## Notable Observations

### Naming Mismatches (functions whose names are misleading given the code)

- **GetCharLevel**: The name suggests "get level value" but actually returns a boolean
  (1 if char ID is in any active match slot). The level meaning here is "is char
  currently in a match" not an RPG-style numeric level.

- **GetCharNamePtr**: The name suggests returning a pointer to a name string, but it
  returns a count of occupied $FFBA80 pair slots. Likely a compiler-era naming artifact.

- **GetCharPortraitIdx**: Returns a boolean (0 or 1 indicating slot availability), not a
  portrait index. Actual portrait index lookup behavior was not found in this function.

- **GetCharDescription**: Returns a slot index (not a text description). The function
  scans skill slots and returns a free-slot position.

- **GetCharStatPtr**: Returns a numeric threshold value (e.g. 30, 50, 100, 200), not a
  pointer. It uses CharCodeCompare scoring to pick a tier.

- **GetCharTypeID**: The name implies type lookup but is actually a simple arithmetic:
  `FF0006 - FF0002*60`. Returns "days remaining" or similar time offset.

- **CalcCharStatFull**: The name implies a calculation, but it executes the full char
  acquisition sequence including cost deduction and dialog display -- a major side-effect
  function.

- **GetBaseCharStat**: The name implies a simple getter but is an 8-group iteration with
  calls to ApplyStatBonus and CheckRecruitEligible.

### Unresolved TODOs
None -- all 46 were resolved.

### Technical Notes
- The "match" system in this section is a character social/team-matching system (not a
  sports match), where chars are paired into mutual-influence relationships.
- $FF88DC is the primary match-record table (indexed by player*0x30 + slot*0xC).
- $FFBA80/$FFBA81 are per-char stat accumulators (raw / opponent).
- $FF0338/$FF0350 are the skill/level-up slot tables (8 bytes each, 4 slots per player).
- $FFA6B8 is the char skill descriptor table (12 bytes per char, 16 chars).
