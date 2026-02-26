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
    DATA_STRUCTURES.md           # Field-level layouts for game structs
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
| 3. Function translation | `dc.w` -> 68K mnemonics, name functions, symbolize calls | **Done** |
| 4. Data analysis | Identify tables, strings, graphics data | **Done** |
| 5. Full understanding | Complete documentation, byte-identical rebuild | **In progress** |

### Translation Status

~252,000 bytes of code translated from raw `dc.w` to 68000 mnemonics (all verified byte-identical). **860 functions translated, 593 named.** Only data tables remain as `dc.w` (system strings/tile patterns at $3D16-$3FEC, ~726 bytes; data tables at $1D20, ~1,896 bytes).

**Call symbolization complete (B-049 through B-051):** All raw `dc.w` call instructions replaced with symbolic mnemonics:
- **2,869 `jsr abs.l`** calls symbolized (B-049): `dc.w $4EB9,$HHHH,$LLLL` → `jsr FunctionName`
- **490 `jsr (d16,PC)`** calls symbolized (B-050): `dc.w $4EBA,$XXXX` → `jsr (FunctionName,PC)`
- **332 `bsr.w`** calls symbolized (B-051): `dc.w $6100,$XXXX` → `bsr.w FunctionName`

Only 7 raw `dc.w` call instructions remain: 1 RAM jump (`$FFF000`), 5 mid-function alt-entry BSR.Ws, 1 mislabeled address.

**Milestone (B-031 through B-040):** All 854 unique JSR call targets from the function reference have been translated. Remaining untranslated code consists of inline routines, branch targets, and data-interleaved sections not reachable via JSR.

**Bulk translation complete (B-046):** All translatable code blocks converted via automated capstone-to-vasm translation of 104 contiguous code blocks across 4 section files. Includes jump-table-aware disassembly, misaligned block boundaries, and cross-section blocks. Translation tooling: `tools/translate_block.py`, `tools/disasm_jtab.py`, `tools/find_dcw_blocks.py`.

**All functions named (B-047):** 593 functions named across all subsystems via docs-based analysis (GameCommand handlers) and code-pattern analysis (B-047 waves 1-4: 68 + 525 functions).

**Phase 4 (B-041 through B-045):** Work RAM map created — 50+ variables and 30+ regions. Data structure field layouts documented for player records (12 fields), route slots (13 fields), and char stat records (12 fields). String/text tables labeled. GAME_PHASE_FLOW.md documents complete gameplay flow. See [analysis/RAM_MAP.md](analysis/RAM_MAP.md), [analysis/DATA_STRUCTURES.md](analysis/DATA_STRUCTURES.md), and [analysis/GAME_PHASE_FLOW.md](analysis/GAME_PHASE_FLOW.md).

## License

This repository contains no copyrighted ROM data. You must supply your own legally obtained ROM file to build. The disassembly source, tooling, and documentation are provided for educational and preservation purposes.
