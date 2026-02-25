# System Execution Flow -- Aerobiz Supersonic

Boot sequence, main loop, and interrupt handler documentation.
Updated as the disassembly progresses.

## Boot Sequence ($000200-$0003A0)

```
Reset Vector ($000004) -> $000200 (EntryPoint)

$000200-$000288: TMSS Security Check (standard Genesis boot code)
  - Test version register at $A10008/$A1000C
  - LEA to data table at $00028E (VDP init, Z80 init program, hw addresses)
  - Write "SEGA" ($53454741) to satisfy TMSS check
  - Set VDP registers from init table (24 registers)
  - Load Z80 initial stub program
  - Clear VRAM, CRAM, VSRAM
  - Clear Work RAM ($FF0000-$FFFFFF)
  - move.w #$2700,SR (disable all interrupts)

$00028C: bra.s $0002FA (skip inline data table)
$00028E-$0002F8: Inline data table (VDP init values, Z80 stub, hw addresses)

$0002FA-$000308: Wait for V-Blank
  - tst.w VDP_CTRL ($C00004)
  - bsr $000CDC (V-Blank wait loop, checks VDP status bit 2)

$00030A: bsr $003BE8 (early init -- RAM/VDP setup)

$00030E-$000336: Initialize Work RAM variables
  - A5 = $FFF010 (base pointer for work RAM variables, used throughout game)
  - Clear flags: $02FB(A5) input_enable, $0B2A(A5) display_update,
    $001C(A5) boot_flag, $002B(A5) vint_dispatch, $004B(A5) dma_pending
  - Clear words/longs: $0BCE(A5) vsub2_trigger, $0BD0(A5) vsub2_callback,
    $0BD4(A5) vsub1_enable, $0C70(A5) unknown

$00033A: jsr $00070A(pc) -- hardware init subroutine

$000340-$00034C: Test expansion controller ($A1000D bit 6)

$00034E-$000360: Copy RAM subroutine
  - Copy 10 bytes from ROM $000362 to $FFF000
  - This is a tiny subroutine (move VDP regs from RAM, RTS) executed from Work RAM

$00036C-$000394: Init subroutine calls
  - jsr $001036(pc) -- VDP/display init
  - jsr $00101C(pc) -- init
  - jsr $00107A(pc) -- init
  - jsr $0010FE(pc) -- init
  - jsr $00260A     -- Z80/SOUND DRIVER INIT (loads driver to Z80 RAM)
  - jsr $0010DA(pc) -- init
  - jsr $001090(pc) -- init

$000396: move.w #$2000,SR -- ENABLE INTERRUPTS (supervisor mode, all levels)

$00039A-$0003A0: Jump to main game
  - movea.l #$0000D5B6, A0
  - jmp (A0) -- ENTER MAIN GAME CODE
```

### Work RAM Base Pointer

A5 = $FFF010 throughout the game. All work RAM variables are accessed as offsets from A5.
This is the central data structure for the entire game state.

## Main Game Entry ($00D5B6)

```
$00D5B6: jsr $005736     -- pre-game initialization
$00D5BC: bsr $00D416     -- game init 1
$00D5C0: bsr $00D558     -- game init 2
$00D5C4: pea $0001
$00D5C8: jsr $03B428     -- game setup (title screen / scenario select?)
$00D5CE: jsr $03CA4E     -- game setup
$00D5D4: bsr $00D500     -- game init 3
$00D5D8-$00D5EA: Display/title setup (calls $005092, pushes params)
$00D5F4: jsr $00D602(pc) -- ENTER MAIN GAME LOOP
$00D5FA: clr.b $FF0006   -- cleanup after game ends
$00D600: rts
```

## Main Game Loop ($00D602-$00D644)

```
$00D602: jsr $01E398     -- PreLoopInit (one-time pre-loop initialization)

MainLoop ($00D608):
  $00D608: jsr $02F5A6   -- game update 1
  $00D60E: jsr $01B49A   -- game update 2
  $00D614: clr.b $FF17C4 -- clear turn flag
  $00D61A: jsr $0213B6   -- game logic (quarterly turn processing?)
  $00D620: jsr $02947A   -- game logic (events/AI?)
  $00D626: pea $0001
  $00D62A: jsr $01819C   -- InitAllCharRecords
  $00D630: subq.l #4,a7  -- stack cleanup
  $00D632: jsr $01E402   -- game update 3
  $00D638: jsr $026128   -- game update 4
  $00D63E: subq.w #1,$FF0006  -- decrement counter (turn/quarter?)
  $00D644: bra MainLoop  -- LOOP FOREVER
```

### Main Loop Key Subroutines (to be analyzed)

| Address | Probable Role | Notes |
|---------|--------------|-------|
| $01E398 | PreLoopInit | Called once before loop starts |
| $02F5A6 | Game update 1 | First call each iteration |
| $01B49A | Game update 2 | |
| $0213B6 | Game logic | Main turn processing? |
| $02947A | Game logic | Events/AI? |
| $01819C | InitAllCharRecords | Init all char records 0-$58, optional pre-init call |
| $01E402 | Game update 3 | |
| $026128 | Game update 4 | Last update before loop |

## V-INT Handler ($0014E6-$0015AE)

The V-Blank interrupt is the most critical handler. It runs once per frame (~60Hz NTSC).

```
$0014E6: movem.l d0-d7/a0-a6,-(sp)  -- save ALL registers

$0014EA-$0014F4: Stack safety check
  - Compare SP against $FFE000 (stack overflow guard)
  - If SP < $FFE000, jump to $001928 (emergency handler)

$0014F6: A5 = $FFF010 (work RAM base)
$0014FC: A4 = $C00004 (VDP control port)

$001502-$001506: Reset H-scroll counter to 0

$001508-$00151A: DMA/VRAM transfer (conditional)
  - Test dma_pending at $004B(A5)
  - If set: bsr $00163E (DMA_Transfer), clear dma_pending

$00151A-$001526: Display update (conditional)
  - Test display_update at $0B2A(A5)
  - If non-zero: bsr $001660 (DisplayUpdate)

$001526-$001532: VInt Sub1 - color fade/cycle (conditional)
  - Test vsub1_enable at $0BD4(A5)
  - If non-zero: bsr $000C38 (uses vsub1_data_ptr at $0BDC(A5))

$001532-$00153E: VInt Sub2 - callback (conditional)
  - Test vsub2_trigger at $0BCE(A5)
  - If non-zero: bsr $0016CC (calls vsub2_callback at $0BD0(A5))

$00153E-$00154A: Input/controller read (conditional)
  - Test input_enable at $02FB(A5)
  - If non-zero: bsr $000B42 (ControllerRead)

$00154A-$001582: Multi-dispatch based on vint_dispatch at $002B(A5)
  - Bit 0 set: bsr $001346 (VInt_Sub1), clear vint_dispatch, done
  - Bit 1 set: bsr $001390 (VInt_Sub2), done
  - Bit 2 set: bsr $001404 (VInt_Sub3), done

$001582-$00158A: A1 = $FFFBFC, bsr $00192E (controller polling?)

$00158C-$0015A2: Four subsystem update calls (PC-relative)
  - jsr $0016D4(pc) -- SubsysUpdate1 (VDP reg staging via ram_sub at $FFF000)
  - jsr $00175C(pc) -- SubsysUpdate2 (vsub4 callback dispatch)
  - jsr $001864(pc) -- SubsysUpdate3
  - jsr $0018D0(pc) -- SubsysUpdate4 (uses vsub4_data_ptr/vsub4_callback)
  (Each followed by NOP for alignment)

$0015A4-$0015A8: Clear vint_processed at $0036(A5)

$0015AA: movem.l (sp)+,d0-d7/a0-a6  -- restore ALL registers
$0015AE: rte
```

### V-INT Key Subroutines

| Address | Name | Trigger | Notes |
|---------|------|---------|-------|
| $00163E | DMA_Transfer | dma_pending $004B(A5) | Transfers staged DMA data to VDP |
| $001660 | DisplayUpdate | display_update $0B2A(A5) | Refresh screen state |
| $000C38 | VInt_ColorFade | vsub1_enable $0BD4(A5) | Color fade/cycle via vsub1_data_ptr |
| $0016CC | VInt_Callback | vsub2_trigger $0BCE(A5) | Calls function at vsub2_callback |
| $000B42 | ControllerRead | input_enable $02FB(A5) | Reads joypad, writes ctrl_state |
| $001346 | VInt_Sub1 | Bit 0 of vint_dispatch | |
| $001390 | VInt_Sub2 | Bit 1 of vint_dispatch | |
| $001404 | VInt_Sub3 | Bit 2 of vint_dispatch | |
| $00192E | ControllerPoll | Always | Writes to ctrl_io ($FFFBFC) |
| $0016D4 | SubsysUpdate1 | Always | VDP reg staging via ram_sub ($FFF000) |
| $00175C | SubsysUpdate2 | Always | Vsub4 callback dispatch |
| $001864 | SubsysUpdate3 | Always | |
| $0018D0 | SubsysUpdate4 | Always | Uses vsub4_data_ptr/vsub4_callback |

## H-INT Handler ($001484-$0014E4)

Used for horizontal scroll effects (raster scroll).

```
$001484: move sr,-(sp)        -- save SR
$001486: ori #$0700,sr        -- disable interrupts during handler
$00148A: movem.l d0-d2/a0/a5,-(sp) -- save working registers

$00148E: A5 = $FFF010 (work RAM base)
$001494-$00149C: Increment hscroll_line_ctr at $0C50(A5)

$0014A2-$0014A8: Test hscroll_enable at $0C46(A5)
  - If clear: skip to restore

$0014AA-$0014DC: HScroll position update
  - Read scroll tables from hscroll_tab_b $0C48(A5) and hscroll_tab_a $0C4C(A5)
  - Calculate scroll A and scroll B values
  - Write to VDP: move.l #$40000010,$C00004 (VSRAM write addr 0)
  - Write scroll B value to VDP data
  - Write to VDP: move.l #$40020010,$C00004 (VSRAM write addr 2)
  - Write scroll A value to VDP data

$0014DE: movem.l (sp)+,d0-d2/a0/a5  -- restore registers
$0014E2: move (sp)+,sr              -- restore SR
$0014E4: rte
```

## EXT Interrupt Handler ($001480-$001482)

```
$001480: nop
$001482: rte
```

Unused -- just returns immediately.

## Exception Handlers ($000F84-$000FE0)

All exception handlers use the same pattern: load exception ID into D0, branch to common handler.

```
$000F84: moveq #2, d0   -- Bus Error (vector 2)
         bra.w $000FD4
$000F8A: moveq #3, d0   -- Address Error (vector 3)
         bra.w $000FD4
...
$000FD2: moveq #15, d0  -- Uninitialized Interrupt (vector 15)

Common Handler ($000FD4):
  $000FD4: movea.l sp, a0   -- save stack pointer
  $000FD6: move.l a0, -(sp) -- push SP
  $000FD8: move.l d0, -(sp) -- push exception ID
  $000FDA: jsr $0058EE       -- call error display routine
  $000FE0: bra.s $000FE0     -- INFINITE LOOP (halt on error)
```

Exception IDs: 2=Bus Error, 3=Address Error, 4=Illegal, 5=Zero Divide,
6=CHK, 7=TRAPV, 8=Privilege, 9=Trace, 10=Line-A, 11=Line-F, 12-15=Reserved.

## Z80 Sound Driver

```
Init routine: $00260A
  - Request Z80 bus ($A11100)
  - Assert Z80 reset ($A11200)
  - Wait for bus grant
  - Copy Z80 program from ROM $002696-$003BE7 to Z80 RAM ($A00000)
  - Size: $1552 bytes (5458 bytes, fits in 8KB Z80 RAM)
  - Release bus and reset (Z80 starts executing)

Z80 driver ROM location: $002696-$003BE7
Z80 driver size: 5458 bytes
```

## Game State Machine

Based on 278 named functions translated so far, the following subsystems have been confirmed:

### Confirmed Subsystems

| Subsystem | Key Functions | Notes |
|-----------|--------------|-------|
| **Title / Scenario** | RunScenarioMenu ($02C2FA) | Scenario selection screen |
| **Player Selection** | RunPlayerSelectUI ($010AB6) | Player/company setup |
| **Menus** | RunGameMenu ($016F9E) | Main in-game menu |
| **Purchasing** | RunPurchaseMenu ($02C9C8) | Fleet/asset purchasing |
| **Quarterly Turn** | RunQuarterScreen ($023EA8), RunTurnSequence ($029ABC) | Main gameplay loop at $D608 |
| **Route Management** | ShowRouteInfo ($00F104), ManageRouteSlots ($0112EE), ProcessRouteAction, ProcessRouteChange, UpdateRouteMask | Open, close, adjust routes |
| **Character Management** | RunCharManagement ($01861A), RunAssignmentUI ($016958), ProcessCharActions ($014202) | Staff hiring/assignment |
| **Relations / Diplomacy** | FormatRelationDisplay, FormatRelationStats, ShowRelationAction, ShowRelationResult, BrowseRelations | Inter-company relations |
| **Financial Reports** | ShowQuarterReport ($02F712), ShowAnnualReport ($02BDB8), ShowQuarterSummary ($012E92) | Quarterly and annual |
| **Game Status** | ShowGameStatus ($0271C6), ShowStatsSummary ($018214) | Rankings, stats overview |
| **AI** | RunAITurn, RunAIStrategy | Computer player logic |
| **Save / Load** | PackSaveState ($00EB28) | Uses SRAM at $200001-$203FFF |

### Suspected States (not yet confirmed in code)

- KOEI logo / splash screen
- Company setup (name, home base, skill level)
- Events / news (wars, oil prices, airport expansions)
- Business ventures (purchase, sell, advertise)
- Regional hub management
- Advisor meeting
- Victory / defeat conditions

---

## Cross-References

- **RAM variable details**: [analysis/RAM_MAP.md](RAM_MAP.md) — all A5-relative offsets with names and sizes
- **Function details**: [analysis/FUNCTION_REFERENCE.md](FUNCTION_REFERENCE.md) — all 278 named functions
