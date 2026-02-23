# Navigator Index -- Aerobiz Supersonic

The Navigator's complete knowledge base. Updated after each session.

---

## Section 1: Document Registry

| Document | Path | Topics Covered |
|----------|------|----------------|
| Project briefing | CLAUDE.md | Ground rules, architecture, build, module categories |
| Task queue | BACKLOG.md | Prioritized work items with acceptance criteria |
| Known pitfalls | KNOWN_ISSUES.md | 68K translation bugs, Genesis hardware hazards |
| Agent team | agents/README.md | Team roles, session flow, research-first principle |
| Genesis software manual | docs/genesis-software-development-manual.md | VDP, DMA, I/O, memory map, sound |
| Genesis technical overview | docs/genesis-technical-overview.md | System architecture, bus, timing |
| 68K programmer's reference | docs/motorola-68000-programmers-reference.md | Instruction set, addressing modes, opcodes |
| Sound driver reference | docs/sound-driver-v3.md | Z80 sound driver, FM/PSG, 68K<->Z80 protocol |
| Genesis reference sheets | docs/sega-genesis-reference-sheets.md | Quick-reference for VDP registers, colors |
| Genesis software manual (alt) | docs/sega-genesis-software-manual.md | Additional Genesis documentation |
| Function reference | analysis/FUNCTION_REFERENCE.md | All identified functions (auto-generated) |
| System execution flow | analysis/SYSTEM_EXECUTION_FLOW.md | Boot, main loop, V-INT, game states |
| ROM map | analysis/ROM_MAP.md | ROM section layout (code/data/padding) |

---

## Section 2: Key Facts

### Platform
- CPU: Motorola 68000 @ 7.67 MHz (NTSC)
- Sound: Zilog Z80 @ 3.58 MHz + YM2612 + SN76489 (PSG)
- VDP: Genesis VDP, 64KB VRAM, 64 colors on screen (512 palette)
- Work RAM: 64KB at $FF0000-$FFFFFF
- ROM: up to 4MB at $000000-$3FFFFF

### Genesis Vector Table ($000000-$0000FF)
- $000000: Initial SP = $00FFF000 (top of work RAM)
- $000004: Reset vector = $00000200 (EntryPoint)
- $000008-$00002F: Exception vectors (bus error, address error, etc.)
- $000030-$00003C: Reserved vectors (have non-zero handlers at $FC0-$FD2)
- $000068: EXT INT (Level 2) = $00001480
- $000070: H-INT vector (Level 4) = $00001484
- $000078: V-INT vector (Level 6) = $000014E6
- $00007C: NMI (Level 7) = $00000000 (unused)
- Exception handlers clustered at $000F84-$000FD2 (6 bytes apart)
- All TRAP vectors ($0080-$00BC) are $00000000 (unused)

### Aerobiz ROM Facts
- ROM size: 1MB ($000000-$0FFFFF), MD5: 1269f44e846a88a2de945de082428b39
- Publisher: KOEI (T-76), December 1994
- Product code: GM T-76136 -00
- Checksum in header: $4620
- SRAM present: $200001-$203FFF (battery-backed, odd byte addressed, ~8KB)
- I/O: J (3-button joypad only)
- Region: U (USA)

### VDP Ports
- $C00000: VDP data port (read/write VRAM/CRAM/VSRAM)
- $C00004: VDP control port (register set, VRAM address, DMA)
- $C00008: HV counter
- $C00011: PSG port

### I/O Ports
- $A10001: Version register
- $A10003: Data port 1 (controller 1)
- $A10005: Data port 2 (controller 2)
- $A10009: Control port 1
- $A1000B: Control port 2

---

## Section 3: Known Pitfalls

| Pitfall | Reference |
|---------|-----------|
| ASL vs LSL different opcodes | KNOWN_ISSUES.md / ASL vs LSL |
| BSR.W vs JSR (d16,PC) | KNOWN_ISSUES.md / BSR.W vs JSR |
| vasm BSR.W displacement off by +2 | KNOWN_ISSUES.md / vasm BSR.W |
| Indexed vs displacement modes 5/6 | KNOWN_ISSUES.md / Indexed vs Displacement |
| MOVE.W #0 vs CLR.W encoding | KNOWN_ISSUES.md / MOVE.W vs CLR.W |
| VDP DMA outside V-Blank | KNOWN_ISSUES.md / VDP DMA Timing |
| Z80 bus not granted before access | KNOWN_ISSUES.md / Z80 Bus Arbitration |
| m68k_disasm.py bugs | KNOWN_ISSUES.md / m68k_disasm.py Known Bugs |

---

## Section 4: Cross-Reference Table

| Topic | Primary Source | Secondary Source |
|-------|---------------|-----------------|
| VDP registers | docs/genesis-software-development-manual.md | docs/sega-genesis-reference-sheets.md |
| VDP DMA | docs/genesis-software-development-manual.md | KNOWN_ISSUES.md / VDP DMA Timing |
| 68K instruction encoding | docs/motorola-68000-programmers-reference.md | KNOWN_ISSUES.md / 68K Assembly |
| Z80 bus protocol | docs/genesis-technical-overview.md | KNOWN_ISSUES.md / Z80 Bus |
| Sound driver | docs/sound-driver-v3.md | -- |
| Genesis memory map | docs/genesis-technical-overview.md | KNOWN_ISSUES.md / Memory Map |
| ROM header format | docs/genesis-software-development-manual.md | KNOWN_ISSUES.md / SEGA ROM Header |
| Controller I/O | docs/genesis-software-development-manual.md | docs/sega-genesis-reference-sheets.md |
