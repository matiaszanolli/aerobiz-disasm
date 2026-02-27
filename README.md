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
      68k/<category>/*.asm       # 801 translated 68K modules (12 categories)
    sections/
      header.asm                 # Vector table + ROM header ($000000-$0001FF)
      section_XXXXXX.asm         # ROM sections (data + include directives)
  analysis/
    ROM_MAP.md                   # ROM layout (code/data/padding)
    RAM_MAP.md                   # Work RAM variables and data structures
    DATA_STRUCTURES.md           # Field-level layouts for game structs
    DATA_TABLES.md               # ROM data tables (53 tables with field layouts)
    FUNCTION_REFERENCE.md        # All identified functions
    CALL_GRAPH.md                # Cross-reference index (who calls what)
    SYSTEM_EXECUTION_FLOW.md     # Boot, main loop, V-INT, game states
    GAME_PHASE_FLOW.md           # Gameplay flow: turns, quarters, win/loss
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
| 3. Function translation | `dc.w` → 68K mnemonics, name functions, symbolize calls | **Done** |
| 4. Data analysis | Identify tables, strings, graphics data | **Done** |
| 5. Full understanding | Complete documentation, byte-identical rebuild | **Done** |

### By the Numbers

| Metric | Count |
|--------|-------|
| Code translated | ~252,000 bytes (all translatable blocks) |
| Functions translated | 860 |
| Functions named | 595 (0 unnamed) |
| Functions described | 595 (one-line descriptions for every function) |
| Functions extracted to modules | 801 (12 categories) |
| Call sites symbolized | 3,696 (`jsr`, `bsr.w`, `jsr (d16,PC)`) |
| ROM data tables documented | 53 (field-level layouts) |
| RAM variables mapped | 50+ variables, 30+ named regions |
| Data structures documented | 6 (player records, route slots, char stats, + 3 auxiliary) |

### Phase 3 — Code Translation

All translatable code blocks converted from raw `dc.w` to 68000 mnemonics via automated capstone-to-vasm translation (B-046). All 595 functions named via docs-based analysis and code-pattern inference (B-047, B-053). All 3,691 raw call instructions replaced with symbolic mnemonics:

- **2,869 `jsr abs.l`** calls (B-049): `dc.w $4EB9,$HHHH,$LLLL` → `jsr FunctionName`
- **490 `jsr (d16,PC)`** calls (B-050): `dc.w $4EBA,$XXXX` → `jsr (FunctionName,PC)`
- **337 `bsr.w`** calls (B-051, B-053): `dc.w $6100,$XXXX` → `bsr.w FunctionName`

Only data tables remain as `dc.w`.

### Phase 4 — Data Analysis

Work RAM map: 50+ variables and 30+ named regions traced from `PackSaveState` and cross-referenced functions. Data structure field layouts for player records (12 fields), route slots (13 fields), char stat records (12 fields), and 3 auxiliary tables. String/text tables labeled. Game phase flow documented: initialization, main loop, turn sequence, quarterly processing, win/loss conditions.

See [RAM_MAP.md](analysis/RAM_MAP.md), [DATA_STRUCTURES.md](analysis/DATA_STRUCTURES.md), [GAME_PHASE_FLOW.md](analysis/GAME_PHASE_FLOW.md).

### Phase 5 — Full Understanding

Every function has a one-line description explaining what it does (B-055, B-057, B-058 — 538 TODOs resolved across 4 section files). Cross-reference index generated: 605 unique callees, 3,698 call sites, 366 leaf functions (B-056). 53 ROM data tables documented with field layouts, accessor functions, and decoded examples — covering string pools, city/route/region tables, aircraft stats, character compatibility matrices, and graphics data (B-059). 31 misleading function names corrected based on actual behavior analysis (B-061).

All 801 translated functions extracted from monolithic section files into individual module files at `disasm/modules/68k/<category>/` (B-060). Section files now contain only data tables and include directives.

| Category | Count | Purpose |
|----------|-------|---------|
| game | 452 | Game logic, UI, AI, turn processing |
| util | 211 | General utilities, uncategorized helpers |
| graphics | 59 | Tile/sprite drawing, graphics loading |
| display | 22 | Screen management, fading, display modes |
| math | 13 | Arithmetic, division, random numbers |
| vdp | 12 | VDP register access, DMA routines |
| text | 7 | Printf, text rendering, cursor control |
| vint | 6 | V-INT/H-INT handlers |
| sound | 5 | Z80 communication, sound driver interface |
| memory | 5 | Memory fill, copy, clear |
| input | 5 | Controller polling, input processing |
| boot | 4 | Hardware init, early startup |

Deep inline annotations added to the 30 most complex functions (B-062): phase block markers, struct field names, magic number explanations, ROM address identifications, and algorithm descriptions. Covers the AI decision tree, turn sequencing, route economics, save serialization, character management, alliance system, and quarterly processing.

See [CALL_GRAPH.md](analysis/CALL_GRAPH.md), [DATA_TABLES.md](analysis/DATA_TABLES.md).

## License

This repository contains no copyrighted ROM data. You must supply your own legally obtained ROM file to build. The disassembly source, tooling, and documentation are provided for educational and preservation purposes.
