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
| 3. Function translation | `dc.w` -> 68K mnemonics, name functions | **In progress** |
| 4. Data analysis | Identify tables, strings, graphics data | Partial |
| 5. Full understanding | Complete documentation, byte-identical rebuild | Not started |

### Translation Status

~2,122 bytes of code translated from raw `dc.w` to 68000 mnemonics (all verified byte-identical):

- Exception handlers ($F84-$FE1) -- 94 bytes, full mnemonics
- EXT/H-INT/V-INT interrupt handlers ($1480-$15AF) -- 304 bytes
- Boot post-initialization ($2FA-$3A0) -- 166 bytes
- Z80 sound driver interface ($260A-$2695) -- 140 bytes, 4 functions
- GameCommand dispatcher ($D64-$E53) -- 240 bytes (52 code + 188 jump table, 47 handlers)
- Main game loop ($D5B6-$D6BC) -- 262 bytes, 4 functions (GameEntry, GameLoopSetup, MainLoop, RangeLookup)
- Utility cluster ($1D520-$1E233) -- 624 bytes, 11 functions (memory ops, input, RNG, tiles, resources)
- Math primitives ($3E05A-$3E181) -- 296 bytes, 12 functions (multiply, signed/unsigned div/mod)

79 functions named out of ~854 total. See [BACKLOG.md](BACKLOG.md) for the full task queue.

## License

This repository contains no copyrighted ROM data. You must supply your own legally obtained ROM file to build. The disassembly source, tooling, and documentation are provided for educational and preservation purposes.
