# Data Structures — Aerobiz Supersonic

Field-level layouts for the three major game data structures, plus three auxiliary
per-player financial tables. All offsets verified from translated assembly code and
disassembled untranslated regions.

**Primary sources:** CalcPlayerFinances, CalcPlayerWealth, FindRelationIndex, GetCharStat,
InitCharRecord, CountActivePlayers, CountUnprofitableRoutes, PackSaveState, NewQuarter
(`$027D66`), ScenarioInit (`$00BA7E`), QuarterEnd (`$0205B8`), and ~30 additional functions.

---

## 1. Player Record (`$FF0018`, stride `$24` = 36 bytes, 4 players)

Base: `$FF0018`. Index: `player_index * $24`. Total: `$90` (144 bytes).

```
Player 0: $FF0018–$FF003B
Player 1: $FF003C–$FF005F
Player 2: $FF0060–$FF0083
Player 3: $FF0084–$FF00A7
```

**Access pattern:** `mulu.w #$24,d0; movea.l #$00FF0018,a0; lea (a0,d0.w),a0`

### Field Layout

| Offset | Size | Name | Description |
|--------|------|------|-------------|
| `+$00` | byte | `active_flag` | Player active: `$01` = active (human or AI), `$00` = empty. Tested by CountActivePlayers. |
| `+$01` | byte | `hub_city` | Hub city index, or `$FF` = no hub. Set during scenario init. Used for region lookup via RangeLookup. |
| `+$02` | byte | `route_type_a` | Route classification count A (domestic?). Written as `#$01` at scenario init. |
| `+$03` | byte | `route_type_b` | Route classification count B (international?). Read with +$02 for ranking display. |
| `+$04` | byte | `domestic_slots` | Domestic route slot count. Cleared at scenario init. Used with +$05 for total: `+$04 + +$05`. |
| `+$05` | byte | `intl_slots` | International route slot count. Cleared at scenario init. |
| `+$06` | long | `cash` | Cash / treasury balance. Major financial field. Increased by quarterly income (`ADDI.L #$30D40` = 200K, or `#$186A0` = 100K). Decreased when purchasing routes. Displayed in ShowPlayerInfo. |
| `+$0A` | long | `quarter_accum_a` | Current quarter revenue accumulator A. In CalcPlayerFinances: added with `(a4)+$00` for total income. Cleared at quarter start, copied to +$16 at quarter end. |
| `+$0E` | long | `quarter_accum_b` | Current quarter expense accumulator B. In CalcPlayerFinances: added to expense sum. Cleared at quarter start, copied to +$1A at quarter end. |
| `+$12` | long | `quarter_accum_c` | Current quarter accumulator C (route income?). Cleared at quarter start, copied to +$1E at quarter end. |
| `+$16` | long | `prev_accum_a` | Previous quarter copy of +$0A. Set by `MOVE.L $A(a3),$16(a3)` at quarter end. |
| `+$1A` | long | `prev_accum_b` | Previous quarter copy of +$0E. Set by `MOVE.L $E(a3),$1A(a3)`. |
| `+$1E` | long | `prev_accum_c` | Previous quarter copy of +$12. Set by `MOVE.L $12(a3),$1E(a3)`. |
| `+$22` | byte | `approval` | Approval rating (0–100). Initialized to `$64` (100) at quarter start. Compared with 99/98/97 to trigger events. |
| `+$23` | byte | *(padding)* | Unused. Pads record to $24-byte boundary. |

### Quarter Lifecycle

**Quarter start** (NewQuarter at `$027D66`):
1. Add income to `+$06` (cash)
2. Copy accumulators: `+$0A → +$16`, `+$0E → +$1A`, `+$12 → +$1E`
3. Clear accumulators: `+$0A`, `+$0E`, `+$12` = 0
4. Reset approval: `+$22` = 100

**Scenario init** (`$00BA7E`):
- `+$01` = hub city, `+$02` = 1, `+$03`/`+$04`/`+$05` = 0
- `+$06` = calculated starting cash
- `+$0A` through `+$1E` = 0, `+$22` = 100

### Financial Calculation (CalcPlayerFinances)

```
Expenses = ($FF0290 + p*6)+$00 + player+$0E + ($FF0290 + p*6)+$02
         + ($FF0290 + p*6)+$04 + ($FF03F0 + p*$C)+$00
         + ($FF03F0 + p*$C)+$02 + ($FF03F0 + p*$C)+$04
         + ($FF09A2 + p*8)+$04

Income   = player+$0A + ($FF09A2 + p*8)+$00

Profit   = Income - Expenses
```

---

## 2. Route Slot (`$FF9A20`, stride `$14` = 20 bytes)

Base: `$FF9A20`. Layout: 4 players x 40 slots. Player stride: `$0320` (800 bytes).

```
Player 0: $FF9A20–$FF9F1F  (slots 0–39)
Player 1: $FF9F20–$FFA41F  (slots 0–39)
Player 2: $FFA420–$FFA91F  (slots 0–39)
Player 3: $FFA920–$FFAE1F  (slots 0–39)
```

**Access pattern:** `mulu.w #$0320,d0; movea.l #$00FF9A20,a0; lea (a0,d0.w),a0` (player),
then iterate with `adda.l #$14,a2` (slot).

**Save state:** PackSaveState saves only the first `$0C` (12) bytes per slot.
Fields `+$0C` through `+$13` are runtime-only (recomputed each quarter).

### Field Layout

| Offset | Size | Name | Saved | Description |
|--------|------|------|-------|-------------|
| `+$00` | byte | `city_a` | yes | Source city index. `$FF` = empty slot. `$20`+ = alliance city. |
| `+$01` | byte | `city_b` | yes | Destination city index. Same encoding as city_a. |
| `+$02` | byte | `plane_type` | yes | Packed nibbles: low = plane class A, high = plane class B. Indices into `$FFB9E8` scheduling table. |
| `+$03` | byte | `frequency` | yes | Flight frequency (0–$0E). Max = 14. Threshold $07 triggers upgrade check. |
| `+$04` | word | `ticket_price` | yes | Fare per passenger. Used in revenue formula: `(fare - base_cost) * load`. |
| `+$06` | word | `revenue_target` | yes | Expected revenue threshold. `actual >= target` = profitable. Cleared on route deletion. |
| `+$08` | word | `gross_revenue` | yes | Current gross revenue. Accumulated via `ADD.W`. Copied to `+$12` at cycle start. Scaled by `ASR.L #7` for GDP. |
| `+$0A` | byte | `status_flags` | yes | Bit flags (see below). Initialized to `$04` on slot reset. |
| `+$0B` | byte | `service_quality` | yes | Computed quality: `(popularity * frequency) / 20`. Used for profitability. |
| `+$0C` | byte | *(runtime)* | no | Not accessed in any translated function. |
| `+$0D` | byte | *(runtime)* | no | Not accessed in any translated function. |
| `+$0E` | word | `actual_revenue` | no | Realized revenue: `(fare * passengers * 12) / 10000`. Compared with `+$06` for profitability. |
| `+$10` | word | `passenger_count` | no | Passenger load factor. Calculated from revenue/fare ratio. |
| `+$12` | word | `prev_revenue` | no | Previous period revenue. Snapshot of `+$08` at cycle start. |

### Status Flags (`+$0A`)

| Bit | Mask | Meaning |
|-----|------|---------|
| 1 | `$02` | Suspended — route skipped in revenue calculations |
| 2 | `$04` | Established — set on slot init, tested for route maturity |
| 7 | `$80` | Pending update — set when city drops from network, bulk-cleared at `$12E04` |

### Slot Reset Pattern (`$027C0E`)

```
CLR.W  $E(a2)           ; actual_revenue = 0
CLR.W  $6(a2)           ; revenue_target = 0
CLR.W  $10(a2)          ; passenger_count = 0
CLR.W  $8(a2)           ; gross_revenue = 0
CLR.W  $12(a2)          ; prev_revenue = 0
MOVE.B #$4,$A(a2)       ; status_flags = ESTABLISHED
```

---

## 3. Per-Player Stat Record (`$FF05C4`, stride `$39` = 57 bytes, 4 players)

Base: `$FF05C4`. Stride: `$39` (57 bytes) per player. 4 players. Total: `$E4` (228 bytes).

```
Player 0: $FF05C4–$FF05FC
Player 1: $FF05FD–$FF0635
Player 2: $FF0636–$FF066E
Player 3: $FF066F–$FF06A7
```

**Access pattern:** `mulu.w #$39,d0; movea.l #$00FF05C4,a0; move.b (a0,d0.w),d0`

**Indirect access via `char_stat_tab`:** Most field accesses go through GetCharStat
(`$009D92`), which uses a descriptor table at `$FF1298` to look up the field offset
within the 57-byte record. The descriptor table has 89 entries (one per city/stat_type),
mapping stat_type indices to byte offsets within each player's 57-byte record.

**Initialization:** UnpackPixelData (`$00EFC8`) unpacks 57 compressed bytes (2-bit
packed values, 4 per source byte) into 228 bytes at `$FF05C4`, filling all 4 records.

### GetCharStat Algorithm (`$009D92`)

```
1. stat_type (word) → index into char_stat_tab at $FF1298
2. descriptor = $FF1298 + stat_type * 4  (4 bytes per descriptor)
3. field_offset = descriptor[0]           (byte: offset 0–$38 within record)
4. address = $FF05C4 + char_index * $39 + field_offset
5. return byte at address
```

### Character Stat Descriptor Table (`$FF1298`)

4-byte entries, indexed by `stat_type * 4`. 89 entries (one per city). Initialized by
InitAllCharRecords (89 iterations of InitCharRecord, which calls CalcCityCharBonus
at `$01801C` and the descriptor init helper at `$021E5E`).

| Byte | Purpose |
|------|---------|
| 0 | Field offset within 57-byte record (0–$38) |
| 1 | Unknown (type discriminator byte 1) |
| 2 | Parameter passed to init function (byte 2 of descriptor) |
| 3 | Parameter passed to init function (byte 3 of descriptor) |

89 entries × 4 bytes = $164 (356) bytes, spanning `$FF1298`–`$FF13FB`.

### Known Direct Field Offsets

These offsets are accessed directly (without going through GetCharStat):

| Offset | Size | Accessed In | Description |
|--------|------|-------------|-------------|
| `+$00` | byte | UpdateCharField, display functions | Character base field (identifier or type) |
| `+$01` | byte | CalcCharRating, CalcCharAdvantage, CalcCompatScore, ShowCharDetail, FindBestCharacter | Primary skill/rating stat. Most frequently accessed field. |
| `+$02` | byte | CalcCharValue, CalcCharAdvantage, CalcCharOutput, ShowCharDetail, ShowCharStats | Secondary stat or index. Updated by UpdateCharField (nibble operations). |
| `+$03` | byte | UpdateCharField, CalcCharValue, CalcCharAdvantage, CalcCharOutput | Cap/limit value or alternative rating. |
| `+$04` | byte | FindCharSlot, CheckCharEligible, FindBestCharacter | Character slot ID or category index. |
| `+$05` | byte | FindCharSlot, CheckCharEligible, FindBestCharacter | Count or subcategory field. |
| `+$06` | byte | CheckCharEligible, CountUnprofitableRoutes | Start period or hire date (compared with season). |
| `+$07` | byte | CheckCharEligible | End period or contract expiry (age/experience limit). |
| `+$08` | byte | ShowCharDetail, ShowCharStats | Display stat A (secondary). |
| `+$09` | byte | ShowCharDetail, ShowCharStats | Display stat B (secondary). |
| `+$0A` | byte | CountUnprofitableRoutes | Flags or status field. |
| `+$0B` | byte | UpdateCharField | Computed/cached value (written after calculation). |

### Overlap Resolved (B-045)

The apparent overlap (`$FF05C4 + 89 × 57 = $FF1995` vs `$FF1298`) was caused by
confusing `stat_type` count (89) with `char_index` count. In GetCharStat, these are
separate parameters: `char_index` (player index, 0–3) selects the 57-byte record via
`mulu.w #$39`, while `stat_type` (0–88) selects the descriptor via `lsl.w #2`. The
array has only 4 records (228 bytes, ending at `$FF06A7`), well before `$FF1298`.

---

## 4. Auxiliary Per-Player Tables

Three additional per-player tables are used in financial calculations alongside the
main player record. All are cleared at quarter start.

### 4a. Expense Table A (`$FF0290`, stride 6, 4 players = 24 bytes)

| Offset | Size | Description |
|--------|------|-------------|
| `+$00` | word | Expense component A |
| `+$02` | word | Expense component B |
| `+$04` | word | Expense component C |

Cleared via `memset(0, 6)` at NewQuarter (`$027E32`).

### 4b. Expense Table B (`$FF03F0`, stride `$C` = 12, 4 players = 48 bytes)

| Offset | Size | Description |
|--------|------|-------------|
| `+$00` | word | Expense component D (cleared quarterly) |
| `+$02` | word | Expense component E (cleared quarterly) |
| `+$04` | word | Expense component F (cleared quarterly) |
| `+$06` | byte | Persistent field (NOT cleared at quarter start) |
| `+$07` | byte | Persistent field |
| `+$08` | byte | Persistent field |
| `+$09` | byte | Transient byte (cleared at quarter start) |
| `+$0A` | byte | Transient byte (cleared at quarter start) |
| `+$0B` | byte | Transient byte (cleared at quarter start) |

### 4c. Income/Expense Table (`$FF09A2`, stride 8, 4 players = 32 bytes)

| Offset | Size | Description |
|--------|------|-------------|
| `+$00` | long | Income component. Added to `player+$0A` for total income. |
| `+$04` | long | Expense component. Added to expense total. |

Cleared via `memset(0, 8)` at NewQuarter (`$027EF8`).

---

## Cross-Reference: PackSaveState Regions vs Structures

| Source Address | Size | Structure | Notes |
|----------------|------|-----------|-------|
| `$FF0018` | `$90` | Player records | All 4 × 36 bytes |
| `$FF0290` | `$18` | Expense table A | 4 × 6 bytes |
| `$FF03F0` | `$30` | Expense table B | 4 × 12 bytes |
| `$FF09A2` | `$20` | Income/expense table | 4 × 8 bytes |
| `$FF9A20` | varies | Route slots | 4 players × 40 slots × **12 bytes** (first $0C only) |
| `$FFBA80` | `$2C8` | City data | 89 cities × 4 entries × 2 bytes |
| `$FFB9E8` | `$80` | Event records | 4 × 32 bytes (saved at stride 2) |

Fields beyond `+$0B` in route slots are NOT saved — they are recomputed at load time.
