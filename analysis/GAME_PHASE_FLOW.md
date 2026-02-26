# Game Phase Flow -- Aerobiz Supersonic

Gameplay flow from scenario selection through win/loss conditions.
Complements [SYSTEM_EXECUTION_FLOW.md](SYSTEM_EXECUTION_FLOW.md) (boot, V-INT, hardware init).

## Overview

```
GameEntry ($00D5B6)
  |
  +-- PreGameInit, GameSetup1 (scenario select), GameSetup2
  |
  +-- GameLoopSetup (one-time)
  |     +-- PreLoopInit: set display mode, backgrounds
  |
  +-- MainLoop ($00D608) -- runs every frame (~60fps)
        +-- GameUpdate1: display/sprite updates
        +-- GameUpdate2: input/menu processing
        +-- GameLogic1: turn/route processing
        +-- GameLogic2: events, AI decisions
        +-- InitAllCharRecords (conditional)
        +-- GameUpdate3: post-logic display
        +-- GameUpdate4: final frame updates
        +-- frame_counter++ -> loop
```

---

## 1. Game Initialization

### GameEntry ($00D5B6, section_000200)

```
GameEntry:
  jsr PreGameInit         ($005736)   -- Pre-game hardware/memory init
  bsr InitGameGraphicsMode ($00D416)  -- VDP display mode setup
  bsr InitGameAudioState   ($00D558)  -- Sound system init
  pea $0001
  jsr GameSetup1          ($03B428)   -- Scenario selection / title screen
  jsr GameSetup2          ($03CA4E)   -- Post-scenario setup
  bsr ClearDisplayBuffers  ($00D500)  -- Clear display state
  jsr DisplaySetup        ($005092)   -- Final display config
  jsr PostDisplayInit     ($00A006)   -- Post-display init
  jsr GameLoopSetup       ($00D602)   -- Enter main loop (never returns)
  clr.w $FF0006                       -- (dead code; loop is infinite)
```

### Data Loading Pipeline

When a scenario is selected, these functions execute in sequence:

| Function | Address | What It Does |
|----------|---------|-------------|
| InitDefaultScenario | $00A526 | Clears all game RAM ($FF0000, $FFE3C bytes). Sets default player count, hub cities, starting funds, month/year. |
| InitAllGameTables | $00B74C | Zeros ~22 RAM tables: player records ($FF0018), route slots ($FF9A20), city data ($FFBA80), AI decision tables ($FF03F0), financial accumulators ($FF0290, $FF09A2), etc. |
| LoadAllGameData | $00CA3E | Streams scenario data from ROM into RAM. Calculates ROM offset as `scenario_id << 13 + $200003` (8KB blocks). LZ-decompresses into $FF1804, then distributes to game tables. |
| InitPlayerAircraftState | $00CEEA | Builds per-player aircraft fleet bitmasks at $FFA6A0. Traces route slots at $FF9A20 to populate aircraft availability at $FFA7BC. |

---

## 2. Main Loop Architecture

### MainLoop ($00D608)

Runs every frame. Each iteration calls 7 functions in fixed order:

```
MainLoop:
  jsr GameUpdate1  ($02F5A6)   -- Display and sprite rendering
  jsr GameUpdate2  ($01B49A)   -- Controller input and menu processing
  clr.w $FF17C4                -- Clear per-frame work flag
  jsr GameLogic1   ($0213B6)   -- Turn/route processing
  jsr GameLogic2   ($02947A)   -- Events and AI decisions
  pea $0001
  jsr GameCall     ($01819C)   -- Conditional char record refresh
  addq.l #4,sp
  jsr GameUpdate3  ($01E402)   -- Post-logic display updates
  jsr GameUpdate4  ($026128)   -- Final frame updates
  addq.w #1,$FF0006            -- Increment frame counter
  bra.s MainLoop               -- Loop forever
```

### GameLogic1 ($0213B6, section_020000)

Handles per-frame route/turn state updates:

```
GameLogic1:
  GameCommand(16, 0, 64)        -- Reset display mode
  jsr $00538E                   -- Audio tick
  jsr $0068CA                   -- Graphics tick
  jsr InitRouteFields(pc)       -- Update route periodic fields
    +-- InitRouteFieldA: decrement event timers at $FF09C2
    +-- InitRouteFieldB: process route field B entries
    +-- InitRouteFieldC: process route field C entries
  jsr FinalizeRouteConfig(pc)   -- Finalize route config
  jsr $0225B8                   -- Turn/quarterly logic dispatch
```

### GameLogic2 ($02947A, section_020000)

Handles events and AI player decisions:

```
GameLogic2:
  jsr InitQuarterEvent(pc)     ($02949A)  -- Check frame counter, init periodic events
  jsr MakeAIDecision(pc)       ($0294F8)  -- AI player turn logic
  jsr AnalyzeRouteProfit(pc)   ($029580)  -- Route profitability analysis
  jsr $017CE6                              -- Event callback dispatch
  jsr OptimizeCosts(pc)        ($0298B8)  -- Cost optimization pass
```

### Frame Counter Timing

`$FF0006` (word) increments every frame. Used for:
- **InitQuarterEvent**: `frame_counter / 4` indexes into event tables at $5FCB0 and $5FC6E
- **CheckDisplayGameWin**: compared against turn limit at $FFA6B2 for game-over timeout
- **AdvanceToNextMonth**: compared for month/quarter transitions

---

## 3. Turn Sequence

### HandleScenarioTurns ($00A5E4, section_000200)

The outer turn loop. Iterates through all 4 players per turn:

```
HandleScenarioTurns:
  a2 = $FF0002 (month counter)
  a4 = $000D64 (GameCommand dispatcher)
  -- Render turn header for each player (0-3):
     jsr $03AB2C with player names from $047630 table
  -- Wait for input (jsr $01E1EC)
  -- Per-player turn loop:
     Read (a2) = current month/turn index
     Display player indicator (jsr $01E044)
     Process input (jsr $01E290) -> d5 = button mask
     If Start pressed (bit 5): enter player action phase
     Else: AI or skip
```

### Human Player Turn

When a human player's turn begins:

```
RunMainMenu ($01B91A):
  Display menu options via GameCommand ($0D64)
  Dispatch to RenderDisplayBuffer ($01CB82) for menu rendering
  Handle selection via $01C43C -> player choice

ExecMenuCommand ($01BBCC):
  Validate aircraft (jsr $00D648)
  Route to selected action:
    - Aircraft purchase -> RunAircraftPurchase ($00BA7E)
    - Route management -> RunRouteManagementUI ($01325C)
    - Player stats -> RunPlayerStatCompareUI ($00E4AA)

SubmitTurnResults ($00FB74):
  For each route slot matching player's aircraft:
    jsr $03B22C -- Calculate route profitability
    Update cash at $FF0018 + player*$24 + $06
  End turn: jsr $01D71C (sync)
```

### AI Player Turn

```
MakeAIDecision ($0294F8):
  a4 = $000090F4 (AI strategy table in ROM)
  a2 = $FF0120   (aircraft assignment table)
  a3 = $FF03F0   (AI decision table, 4 players * $0C bytes)
  For each player (d2 = 0-3):
    Read AI params: byte[9] and byte[10] from $FF03F0 + player*$0C
    Call strategy function at (a4) with player index and params
    Accumulate result into aircraft bytes at $FF0120 + player*4:
      +$01: aircraft class A modifier
      +$02: aircraft class B modifier
```

---

## 4. Quarterly Processing

### Quarter Start

**InitQuarterStart** ($027D66, section_020000):

```
For the active player:
  a2 = $FF0018 + player * $24 (player record)

  Add quarterly income to cash (+$06):
    If quarter == 0 AND player is human (byte[0] == 1):
      cash += $30D40 (200,000)
    Else:
      cash += $186A0 (100,000)

  Floor cash at $186A0 (100,000 minimum)

  Clear quarterly accumulators:
    +$0A: quarter_accum_a = 0
    +$0E: quarter_accum_b = 0
    +$12: quarter_accum_c = 0

  Archive previous quarter:
    +$16: prev_accum_a = (old +$0A)
    +$1A: prev_accum_b = (old +$0E)
    +$1E: prev_accum_c = (old +$12)

  Reset approval rating:
    +$22: approval = $64 (100%)

  Clear working tables:
    $FF00E8 + player*$0C: 12 bytes (route lookup)
    $FF0130 + player*$20: 32 bytes (franchise/licensing)
    $FF01B0 + player*$20: 32 bytes (route pool)
    $FF0290 + player*$06: 6 bytes (financial accumulators)

  Recalculate route baselines:
    bsr $0262E4 -- compute route profitability baseline
```

### Quarter Results

**ComputeQuarterResults** ($018C80, section_010000):

Aggregates all financial data for the quarter. Calls `$03B22C` (the central profit/loss computation engine) with ROM data table pointers from $047B78/$047C9C.

**UpdatePlayerAssets** ($018D14, section_010000):

Applies quarterly profit/loss to player cash:
- Reads route income from `$FF09A2 + player*8`
- Computes profit margin via Multiply32/Divide32
- Updates cash at `$FF0018 + player*$24 + $06`
- Triggers insolvency events if loss exceeds threshold

### Quarter Display

| Function | Address | Purpose |
|----------|---------|---------|
| RenderQuarterReport | $026598 | Full quarterly financial report with GDP scaling |
| DrawQuarterResultsScreen | $026CD8 | Per-player quarter-end results (cash, routes, approval) |

### Quarter End

**FinalizeQuarterEnd** ($027FF4, section_020000):

```
For the active player:
  Calculate offset: (player << 5) + (quarter << 3) into $FF0338
  Finalize revenue:  jsr $006A2E
  Finalize expenses: jsr $006B78
  Archive snapshot:  jsr $01A468
  If year-end: re-run with CEO evaluation data
  Display summary: jsr $01D748 (VBlank sync)
```

---

## 5. Month Advancement

**AdvanceToNextMonth** ($00FCAC, section_000200):

```
AdvanceToNextMonth(player, month):
  jsr $006EEA -- Get next month index
  If normal month (d4 != $FF):
    jsr $03B22C -- Calculate monthly results
    jsr $007912 -- Check for special events/milestones
    If event: enter event handler
  If year boundary (d4 == $FF):
    jsr $01D748 -- VBlank sync
    Trigger annual report / CEO evaluation
    Check game-over: compare frame_counter vs turn_limit ($FFA6B2)
```

---

## 6. Win/Loss Conditions

### CheckDisplayGameWin ($02763C, section_020000)

Called each frame to check if any player has won:

```
CheckDisplayGameWin:
  d5 = min($FF0004 + 4, 7)  -- Required achievements (scales with quarter)

  For each player (d4 = 0-3):
    a4 = $FF0018 + player * $24  (player record)
    a3 = $FFBE00 + player * $10  (leaderboard, 7 word-sized slots)

    Read player aircraft type from +$01
    jsr $00D648 -- Resolve aircraft index

    Count achievement flags in leaderboard:
      For slots 0-6: if (a3)[slot] == $0001, increment d2

    If d2 >= d5 (enough achievements):
      Store winner: move.b d4, $FF0016
      jsr DisplayPlayerLeaderboard ($02771C)
      (game continues to end screen)

  After all players checked:
    If frame_counter ($FF0006) >= turn_limit ($FFA6B2):
      jsr $00814A       -- Game timeout handler
      jsr $03CB36       -- End-game display
      bra.b *           -- Infinite loop (game over)

  If no winner and not timed out: return to main loop
```

### Win Threshold

| Quarter | Required Achievements |
|---------|----------------------|
| 0 | 4 |
| 1 | 5 |
| 2 | 6 |
| 3+ | 7 (maximum) |

### Leaderboard Structure

`$FFBE00`: 4 players * 16 bytes (8 word-sized achievement slots)
- Each slot is $0001 (achieved) or $0000 (not achieved)
- Achievements likely correspond to: routes opened, cities connected, profit targets, approval milestones, fleet size, etc.

---

## 7. Key RAM State Variables

### Core Game State

| Address | Size | Name | Description |
|---------|------|------|-------------|
| $FF0002 | word | month_counter | Current month (0-11) |
| $FF0004 | word | quarter | Current quarter (0-3 per year) |
| $FF0006 | word | frame_counter | Incremented every MainLoop tick |
| $FF0016 | byte | current_player | Active player index (0-3) |
| $FF17C4 | word | work_flag | Per-frame work flag, cleared each loop |
| $FF9A1C | word | screen_id | Current screen/scenario index |
| $FFA6B2 | word | turn_limit | Game-over frame threshold |

### Player Records ($FF0018, 4 players * $24 bytes)

| Offset | Size | Field |
|--------|------|-------|
| +$00 | byte | active_flag (1=human, 0=AI) |
| +$01 | byte | hub_city / aircraft_type |
| +$06 | long | cash |
| +$0A | long | quarter_accum_a (revenue) |
| +$0E | long | quarter_accum_b (expenses) |
| +$12 | long | quarter_accum_c (other) |
| +$16 | long | prev_accum_a |
| +$1A | long | prev_accum_b |
| +$1E | long | prev_accum_c |
| +$22 | byte | approval_rating (0-100, reset to 100 each quarter) |

### Financial Tables

| Address | Size | Description |
|---------|------|-------------|
| $FF0290 | $18 | Financial accumulators (4 players * 6 bytes) |
| $FF03F0 | $30 | AI decision table (4 players * $0C bytes) |
| $FF09A2 | $20 | Route profitability (4 players * 8 bytes) |

### Route & City Data

| Address | Size | Description |
|---------|------|-------------|
| $FF9A20 | $C80 | Route slots (4 players * 40 slots * $14 bytes) |
| $FFA6A0 | $10 | Aircraft fleet bitfield (4 players * longword) |
| $FFA7BC | $1C | Aircraft availability per route (4 players * 7 bytes) |
| $FFBA80 | $2C8 | City data (89 cities * 4 entries * 2 bytes) |
| $FFBE00 | $40 | Leaderboard/win tracking (4 players * 16 bytes) |

### AI & Events

| Address | Size | Description |
|---------|------|-------------|
| $FF0120 | $10 | Aircraft assignment (4 players * 4 bytes) |
| $FF09C2 | varies | Route event timer array (InitRouteFieldA decrements these) |
| $FF13FC | word | Turn input state |
| $FFA7D8 | word | Turn display state |
| $FFBD4C | word | Event type / franchise flag |

---

## 8. Function Call Graph

### Initialization Chain
```
GameEntry
  +-- PreGameInit
  +-- InitGameGraphicsMode
  +-- InitGameAudioState
  +-- GameSetup1 (scenario select UI)
  +-- GameSetup2 (post-scenario setup)
  +-- ClearDisplayBuffers
  +-- GameLoopSetup
        +-- PreLoopInit
```

### Per-Frame Main Loop
```
MainLoop (every frame)
  +-- GameUpdate1 (display)
  +-- GameUpdate2 (input)
  +-- GameLogic1
  |     +-- InitRouteFields
  |     |     +-- InitRouteFieldA (decrement event timers)
  |     |     +-- InitRouteFieldB
  |     |     +-- InitRouteFieldC
  |     +-- FinalizeRouteConfig
  |     +-- Turn/quarterly dispatch ($0225B8)
  +-- GameLogic2
  |     +-- InitQuarterEvent (periodic event init from frame counter)
  |     +-- MakeAIDecision (AI player turns)
  |     +-- AnalyzeRouteProfit
  |     +-- OptimizeCosts
  +-- InitAllCharRecords (conditional)
  +-- GameUpdate3 (post-logic display)
  +-- GameUpdate4 (final updates)
```

### Turn Processing
```
HandleScenarioTurns
  +-- (per player 0-3)
  |     +-- RunMainMenu -> HandleMenuSelection -> ExecMenuCommand
  |     |     +-- RunAircraftPurchase
  |     |     +-- RunRouteManagementUI
  |     |     +-- RunPlayerStatCompareUI
  |     +-- SubmitTurnResults
  |     +-- AdvanceToNextMonth
  |           +-- Monthly financial calculation
  |           +-- Event/milestone check
  |           +-- (year boundary: annual report)
```

### Quarterly Cycle
```
InitQuarterStart
  +-- Add income, reset accumulators, set approval=100
  +-- Clear working tables
  +-- Recalculate route baselines
      |
ComputeQuarterResults
  +-- Aggregate income/expenses
      |
UpdatePlayerAssets
  +-- Apply profit/loss to cash
      |
RenderQuarterReport / DrawQuarterResultsScreen
      |
FinalizeQuarterEnd
  +-- Archive results, finalize revenue/expense tables
      |
CheckDisplayGameWin
  +-- Count achievements in leaderboard
  +-- If winner: DisplayPlayerLeaderboard (end game)
  +-- If timeout: game-over screen (infinite loop)
```
