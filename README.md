# Aerobiz Supersonic -- Sega Genesis Disassembly

A full disassembly and reassembly project for **Aerobiz Supersonic** (USA) on the Sega Genesis / Mega Drive.

| | |
|---|---|
| **Platform** | Sega Genesis / Mega Drive |
| **CPU** | Motorola 68000 @ 7.67 MHz |
| **Sound** | Zilog Z80 @ 3.58 MHz, YM2612 FM, SN76489 PSG |
| **Publisher** | KOEI (T-76) |
| **Release** | December 1994 |
| **ROM size** | 1 MB |
| **Region** | USA |
| **Product code** | GM T-76136 -00 |

## Goal

Produce a fully documented, byte-identical reassembly of the original ROM from 68000 assembly source. All code translated to mnemonics, all functions named and documented, all data tables identified.

## Building

Requires `vasmm68k_mot` (Motorola-syntax 68000 assembler). The toolchain is included in `tools/`.

```bash
make all          # Assemble ROM -> build/aerobiz.bin
make verify       # Compare MD5 against original ROM
make clean        # Remove build artifacts
```

Place the original ROM as `Aerobiz Supersonic (USA).gen` in the project root for verification.

## Project Structure

```
aerobiz-disasm/
  disasm/
    aerobiz.asm                  # Main entry point (includes everything)
    modules/
      shared/definitions.asm     # Hardware register equates
      68k/<category>/*.asm       # Translated 68K modules (by category)
    sections/
      header.asm                 # Vector table + ROM header ($000000-$0001FF)
      section_XXXXXX.asm         # ROM data sections (64KB each)
  analysis/
    ROM_MAP.md                   # ROM layout (code/data/padding)
    RAM_MAP.md                   # Work RAM variables and data structures
    FUNCTION_REFERENCE.md        # All identified functions
    SYSTEM_EXECUTION_FLOW.md     # Boot, main loop, V-INT, game states
  docs/                          # Hardware reference documentation (symlinked)
  tools/                         # Assembler and disassembler (symlinked)
  agents/                        # AI agent team definitions
  BACKLOG.md                     # Task queue
  KNOWN_ISSUES.md                # Pitfalls and gotchas
```

## ROM Layout

| Range | Size | Description |
|-------|------|-------------|
| `$000000-$0000FF` | 256 B | Exception vector table (64 longwords) |
| `$000100-$0001FF` | 256 B | ROM header (console name, title, checksum, SRAM info) |
| `$000200-$0FFFFF` | ~1 MB | Game code and data |

### Key Addresses

| Address | Purpose |
|---------|---------|
| `$000200` | Entry point (reset vector, TMSS boot) |
| `$0002FA` | Post-boot initialization (work RAM setup, HW init calls) |
| `$000F84-$000FE1` | Exception handlers (14 IDs + common handler + halt) |
| `$001480` | EXT interrupt handler (Level 2, unused -- nop + rte) |
| `$001484` | H-Blank interrupt handler (Level 4, raster scroll effect) |
| `$0014E6` | V-Blank interrupt handler (Level 6, main per-frame handler) |
| `$00D5B6` | Main game entry |
| `$00D608` | Main game loop (iterates forever) |
| `$002696-$003BE7` | Z80 sound driver (5,458 bytes, custom) |
| `$03E1AC-$041FFF` | Game text strings (ASCII, null-terminated, printf-style) |
| `$200001-$203FFF` | SRAM (battery-backed save data, ~8 KB) |

## Progress

| Phase | Description | Status |
|-------|-------------|--------|
| 1. Initial dump | ROM as raw `dc.w` data, vector table labeled | Done |
| 2. Code discovery | Trace execution, map ROM regions, identify functions | Done |
| 3. Function translation | `dc.w` -> 68K mnemonics, name functions | Done (all JSR call targets) |
| 4. Data analysis | Identify tables, strings, graphics data | **In progress** |
| 5. Full understanding | Complete documentation, byte-identical rebuild | Not started |

### Translation Status

~67,772 bytes of code translated from raw `dc.w` to 68000 mnemonics (all verified byte-identical):

- **System core** -- 944 bytes (5 groups): exception handlers, EXT/H-INT/V-INT interrupts, boot init, Z80 sound interface, GameCommand dispatcher
- **Main loop & resources** -- 2,816 bytes (25 functions): GameEntry, MainLoop, RangeLookup, ResourceLoad, DiagonalWipe, ShowGameScreen, LoadGameGraphics, and 18 more
- **Math & memory** -- 1,284 bytes (29 functions): Multiply32, SignedDiv, UnsignedDivide, WeightedAverage, MemCopy, MemMove, StringConcat, and 22 more
- **Text & compression** -- 2,280 bytes (10 functions): sprintf, PrintfNarrow, SetTextWindow, RenderTextBlock, LZ_Decompress, DecompressVDPTiles, and 4 more
- **Display & graphics** -- 5,096 bytes (35 functions): DisplaySetup cluster, FillTileRect, LoadScreenGfx, FadePalette, DrawTilemapLine, UnpackPixelData, and 29 more
- **Input** -- 268 bytes (3 functions): ProcessInputLoop, PollInputChange, PreLoopInit
- **Game UI** -- 16,380 bytes (55 functions): DrawBox, ShowDialog, LoadScreen, MenuSelectEntry, CharacterBrowser, RunGameMenu, ShowQuarterReport, and 48 more
- **Character system** -- 14,462 bytes (62 functions): CharCodeCompare, CalcRelationValue, RecruitCharacter, CalcCharScore, FindBestCharacter, and 57 more
- **Game logic & AI** -- 6,122 bytes (23 functions): RunPlayerTurn, RunAITurn, RunScenarioMenu, AnimateFlightPaths, RunEventSequence, SortWordPairs, and 17 more
- **Management screens** -- 15,934 bytes (15 functions): PackSaveState, ShowRouteInfo, ShowQuarterSummary, RunQuarterScreen, ShowAnnualReport, RunCharManagement, ShowRelationAction, and 8 more

278 functions named, 266 translated to mnemonics, out of ~854 total. See [BACKLOG.md](BACKLOG.md) for the full task queue.

**Milestone (B-031 through B-040):** All 854 unique JSR call targets from the function reference have been translated. Remaining untranslated code consists of inline routines, branch targets, and data-interleaved sections not reachable via JSR.

**Phase 4 (B-041):** Work RAM map created — 50+ variables and 30+ regions extracted from PackSaveState ($00EB28). Key structures: player records (4 × 36B), character stat array (stride 57B), route slots (4 × 40 × 20B), city data (89 cities × 4 entries). See [analysis/RAM_MAP.md](analysis/RAM_MAP.md).

## License

This repository contains no copyrighted ROM data. You must supply your own legally obtained ROM file to build. The disassembly source, tooling, and documentation are provided for educational and preservation purposes.
