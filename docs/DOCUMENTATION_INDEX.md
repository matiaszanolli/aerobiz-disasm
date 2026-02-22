# Documentation Index

All documentation available for the Aerobiz Supersonic disassembly project.

## Genesis Hardware Documentation (shared via symlinks from 32x-playground)

| Document | Description |
|----------|-------------|
| [genesis-software-development-manual.md](genesis-software-development-manual.md) | Official Sega Genesis Software Development Manual v2.0 -- VDP, DMA, I/O, memory map |
| [genesis-technical-overview.md](genesis-technical-overview.md) | System architecture overview -- bus timing, memory layout, Z80 |
| [genesis-technical-bulletins.md](genesis-technical-bulletins.md) | Technical bulletins with errata and clarifications |
| [sega-genesis-reference-sheets.md](sega-genesis-reference-sheets.md) | Quick-reference for VDP registers, color palette, sprites |
| [sega-genesis-software-manual.md](sega-genesis-software-manual.md) | Additional Genesis software documentation |
| [motorola-68000-programmers-reference.md](motorola-68000-programmers-reference.md) | Complete 68000 instruction set reference, addressing modes, opcodes |
| [sound-driver-v3.md](sound-driver-v3.md) | Sound driver v3 documentation (YM2612 FM + PSG) |
| [snasm68k-console-z80-notes.md](snasm68k-console-z80-notes.md) | Z80 console notes from SNASM development system |
| [genesis-32x-overview.md](genesis-32x-overview.md) | Genesis/32X system overview (Genesis sections relevant) |

## Project Documentation

| Document | Description |
|----------|-------------|
| [../CLAUDE.md](../CLAUDE.md) | Project briefing, ground rules, architecture |
| [../BACKLOG.md](../BACKLOG.md) | Prioritized task queue |
| [../KNOWN_ISSUES.md](../KNOWN_ISSUES.md) | Known pitfalls, bugs, hardware gotchas |
| [../agents/README.md](../agents/README.md) | Agent team coordination model |

## Analysis (grows as disassembly progresses)

| Document | Description |
|----------|-------------|
| [../analysis/ROM_MAP.md](../analysis/ROM_MAP.md) | ROM section layout (code/data/padding) |
| [../analysis/SYSTEM_EXECUTION_FLOW.md](../analysis/SYSTEM_EXECUTION_FLOW.md) | Boot sequence, main loop, V-INT handler |
| [../analysis/FUNCTION_REFERENCE.md](../analysis/FUNCTION_REFERENCE.md) | All identified functions (auto-generated) |

## Adding New Documentation

To add new documentation to this project:
1. If it's Genesis-generic (useful across projects): add to `../32x-playground/docs/` and symlink
2. If it's Aerobiz-specific: add directly to this `docs/` directory
3. Update this index
4. Update the Navigator's `analysis/agent-scratch/navigator/index.md`
