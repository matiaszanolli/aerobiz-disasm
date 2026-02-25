# CLAUDE.md

Agent briefing for Aerobiz Supersonic (Sega Genesis / Mega Drive) disassembly/reassembly project.

**Last Updated**: February 2026

## Agent Team

This project uses a specialized agent team. See [agents/README.md](agents/README.md) for the full roster.

**Task Manager** is the entry point for all game code work. **Always invoke it before modifying any file in `disasm/`, or working on any BACKLOG item.** It spins up the Navigator, orients on the task, delegates to the Engineer, and manages the Auditor sign-off gate.

- Invoke explicitly: `/task-manager` or `/task-manager <issue>`
- Auto-trigger: whenever a session is about to touch game code

**Navigator** (Haiku) is a fast, cheap lookup agent loaded with only `analysis/agent-scratch/navigator/index.md`. It answers "where is X?" -> file + section. It never answers from memory and never summarizes. Session ID in `analysis/agent-scratch/navigator/session_id.txt`. Respawn freely if stale -- it loads one file.

**Engineer** (Sonnet) does all technical work: reads code, proposes patches, verifies encodings, translates dc.w to mnemonics. It queries the Navigator for pointers and reads primary sources directly. Has KNOWN_ISSUES pitfalls baked in and must obtain Auditor sign-off before any VDP/DMA/Z80 bus modifications.

**Auditor** (Opus) is a focused safety reviewer. Spawned fresh per concrete proposal, never resumed. Returns APPROVED or BLOCKED with specific hazard and source citation.

**Research-First Principle:** Before implementing any fix, the Engineer must read relevant documentation (`docs/`, `analysis/`) and build a mental model grounded in documented facts. The Task Manager enforces this via the Research Gate (Step 2.5). See [agents/README.md](agents/README.md) for details. Named anti-patterns: address shopping, circular investigation, modern platform assumptions, undocumented guessing -- all banned.

**index.md maintenance rule:** After any session where a new pitfall is discovered or a new architectural fact is established, update `analysis/agent-scratch/navigator/index.md` before closing. The Navigator is only as good as its index.

## Build & Test

```bash
make all          # Build ROM from disassembly
make clean        # Remove build artifacts
blastem build/aerobiz.bin   # Test in emulator (BlastEm recommended for accuracy)
```

Build produces `build/aerobiz.bin`. The goal is byte-identical reassembly from disassembly sources, verified with `md5sum` against the original ROM.

## Ground Rules -- STRICTLY ENFORCED

1. **Do Not Guess** -- Use `docs/` (hardware manuals) and `analysis/` (architecture). Query the Navigator for where to look, then read the primary source. Research first.
2. **Understand Before Modifying** -- Never patch `dc.w` without understanding it. Disassemble and document first.
3. **Use Available Tools** -- Disassembler at `tools/m68k_disasm.py`. Measure, don't assume.
4. **Proper Assembly** -- Modify assembly source, not raw binary. Convert `dc.w` to mnemonics when possible (see [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for known pitfalls).
5. **Clean Commits** -- No stale comments, no partial changes. Revert completely if something doesn't work.
6. **Verify Changes** -- `make clean && make all` after every modification. Confirm build succeeds. Compare `md5sum` against original ROM for byte-identical phases.
7. **DRY** -- Never create duplicate files. Fix in place. Use git branches for experiments.
8. **VDP Safety** -- Before modifying any VDP register access or DMA operation, read the relevant Genesis hardware manual sections. Critical rules:
   - **DMA during V-Blank only** -- DMA outside V-Blank can corrupt VRAM/CRAM/VSRAM
   - **VDP command word ordering** -- Set up registers before issuing commands
   - **Auto-increment register** -- Must be correctly set before bulk writes
9. **Z80 Bus Arbitration** -- 68K must request Z80 bus (`$A11100`) and wait for grant before accessing Z80 RAM. Releasing the bus without waiting for grant = undefined.
10. **Memory Boundaries** -- Always check the Genesis memory map before assuming an address is valid.
    - **68K Work RAM**: `$FF0000-$FFFFFF` (64KB)
    - **68K ROM**: `$000000-$3FFFFF` (up to 4MB, game dependent)
    - **VDP ports**: `$C00000-$C00008`
    - **Z80 RAM**: `$A00000-$A01FFF` (8KB, bus request required)
    - **I/O ports**: `$A10000-$A1001F`

## Architecture

**Approach:** Full ROM rebuild from disassembly (NOT code injection).
**Workflow:** Edit sources in `disasm/sections/` or `disasm/modules/` -> `make all` -> test.

### ROM Layout

```
$000000-$0001FF    512B   Header + vectors
$000200-$??????    ???    Game code + data (to be mapped)
```

### Build Pipeline

```
disasm/aerobiz.asm (entry point)
  -> disasm/sections/*.asm (header + vectors + code sections + data)
    -> disasm/modules/68k/*/*.asm (modular functions, as translated)
  -> build/aerobiz.bin (ROM)
```

### Platform Details

| Component | Details |
|-----------|---------|
| **CPU** | Motorola 68000 @ 7.67 MHz (NTSC) / 7.61 MHz (PAL) |
| **Sound CPU** | Zilog Z80 @ 3.58 MHz |
| **VDP** | Sega Genesis VDP (based on TMS9918), 64KB VRAM |
| **Work RAM** | 64KB ($FF0000-$FFFFFF) |
| **Sound RAM** | 8KB Z80 RAM ($A00000-$A01FFF) |
| **ROM** | Up to 4MB ($000000-$3FFFFF) |

### Key Stats (to be updated as disassembly progresses)

- **68K modules**: 0 (translating in-place in section files for now)
- **Functions identified**: 246 named, 2,896 unique call targets
- **Translation progress**: ~38,260 bytes translated (exceptions, interrupts, boot, Z80 sound, GameCommand, main loop, utility cluster, display, graphics, memory, math, text, compression, input, UI dialogs, menu selection, screen loading, char code functions, DrawBox, ShowRelPanel, 165 unnamed call targets)

### ROM Address Mapping

- **68000**: Addresses map 1:1 to file offsets for the first 4MB (no banking by default)
- **If banked**: SEGA mapper at `$A130F1-$A130FF` controls $200000-$3FFFFF windows

## Where to Look

| Question | File |
|----------|------|
| What to work on next | [BACKLOG.md](BACKLOG.md) |
| Known pitfalls and bugs | [KNOWN_ISSUES.md](KNOWN_ISSUES.md) |
| Hardware reference (Genesis) | [docs/genesis-software-development-manual.md](docs/genesis-software-development-manual.md) |
| Genesis technical overview | [docs/genesis-technical-overview.md](docs/genesis-technical-overview.md) |
| 68K instruction set + opcode map | [docs/motorola-68000-programmers-reference.md](docs/motorola-68000-programmers-reference.md) |
| Z80 / sound driver reference | [docs/sound-driver-v3.md](docs/sound-driver-v3.md) |
| All documentation index | [docs/DOCUMENTATION_INDEX.md](docs/DOCUMENTATION_INDEX.md) |
| Function reference (auto-gen) | [analysis/FUNCTION_REFERENCE.md](analysis/FUNCTION_REFERENCE.md) |
| System execution flow | [analysis/SYSTEM_EXECUTION_FLOW.md](analysis/SYSTEM_EXECUTION_FLOW.md) |

## Module Categories

68K modules live in `disasm/modules/68k/<category>/`:

| Category | Purpose |
|----------|---------|
| boot | Initialization, hardware setup |
| display | Display list, screen rendering |
| game | Game logic (to be subcategorized as disassembly progresses) |
| graphics | Graphics primitives, tile/sprite management |
| input | Controller I/O |
| main-loop | V-INT handler, main loop |
| math | Arithmetic, fixed-point math |
| memory | Memory management |
| object | Object system |
| sound | Sound driver interface, Z80 communication |
| util | Utility functions |
| vdp | VDP register access, DMA routines |
| vint | V-INT sub-handlers |

## Shared Documentation

This project shares hardware documentation with the [32x-playground](../32x-playground/) project via symlinks in `docs/`. Genesis-specific and 68K documentation is shared; 32X/SH2-specific docs are excluded.

## Disassembly Phases

### Phase 1: Initial Dump (current)
- Dump ROM as raw `dc.w` / `dc.l` / `dc.b` data
- Identify and label the vector table and entry point
- Map ROM sections (code vs data vs padding)

### Phase 2: Code Discovery
- Trace execution from reset vector
- Identify subroutine boundaries (RTS/RTE markers)
- Label branch targets and jump tables
- Separate code from inline data

### Phase 3: Function Translation
- Convert `dc.w` blocks to 68K mnemonics
- Name functions based on behavior analysis
- Organize into module categories
- Build function reference documentation

### Phase 4: Data Analysis
- Identify and label data tables (text, graphics, game data)
- Document data formats and structures
- Map cross-references between code and data

### Phase 5: Full Understanding
- All code translated to mnemonics
- All functions named and documented
- Complete system execution flow documented
- ROM rebuilds byte-identical
