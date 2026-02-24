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
- ~854 functions (RTS count), ~737KB code, ~276KB padding (30% fill)
- Work RAM base pointer: A5 = $FFF010 (used throughout game)

### Aerobiz Execution Flow
- Boot: $000200 (TMSS) -> $0002FA (game init) -> $0003A0 (jmp $D5B6)
- Main game entry: $00D5B6
- Main game loop: $00D608 (loops via bra back to itself)
- V-INT handler: $0014E6-$0015AE (DMA, display, input, 4 subsystem updates)
- H-INT handler: $001484-$0014E4 (HScroll raster effect)
- EXT INT: $001480 (NOP + RTE, unused)
- Exception handlers: $000F84-$000FE0 (load ID, jsr $58EE, halt)
- Z80 sound driver: ROM $002696-$003BE7 (5458 bytes, loaded to $A00000)
- Sound init routine: $00260A
- Game strings: $03E1AC-$041FFF (398+ strings, ASCII null-terminated, printf-style %s/%d/%$lu)
- String pointer tables: $0475DC-$0488D7 (8 tables, largest: 128 ptrs for dialogue)
- City name tables: $0459xx, $045Axx, $045Cxx (3 copies, 14+ cities)
- Z80 sound driver: custom (not GEMS/SMPS), entry: DI+LD SP,$2000+JP $E0, uses YM2612+PSG
- Most-called function: $000D64 (306 calls), $03E05C (204), $03AB2C (174)
- V-INT subsystem update targets (corrected): $0016D4, $00175C, $001864, $0018D0

### Translation Progress (Phase 3)
- Exception handlers ($F84-$FE1): DONE -- 94 bytes, all mnemonics
- EXT INT ($1480-$1483): DONE -- 4 bytes (nop + rte)
- H-INT ($1484-$14E5): DONE -- 98 bytes, full mnemonics with VDP equates
- V-INT ($14E6-$15AF): DONE -- 202 bytes, hybrid (mnemonics + dc.w for external calls)
- Boot post-init ($2FA-$3A0): DONE -- 166 bytes, hybrid
- Z80 sound interface ($260A-$2695): DONE -- 140 bytes, 4 functions (SoundInit/RequestBus/ReleaseBus/Delay)
- Main game loop ($D5B6-$D6BC): DONE -- 262 bytes, 4 functions (GameEntry/GameLoopSetup/MainLoop/RangeLookup)
- GameCommand ($D64-$E53): DONE -- 240 bytes, command dispatcher + 47-entry jump table
- Utility cluster ($1D520-$1E233): DONE -- 624 bytes, 11 functions: MemFillByte/MemCopy/MemFillWord/PollAction/RandRange/ByteSum/ResourceLoad/ResourceUnload/TilePlacement/GameCmd16/ReadInput
- Math primitives ($3E05A-$3E181): DONE -- 296 bytes, 12 functions: Multiply32/SignedDiv/UnsignedDivide/UDiv_Overflow/UDiv_Full32/UnsignedMod/SignedMod + 5 FromPtr alternate entries
- Text system ($3A942-$3B29B): DONE -- 250 bytes, 5 functions: SetTextWindow/SetTextCursor/sprintf/PrintfNarrow/PrintfWide
- LZ_Decompress ($3FEC-$423F): DONE -- 596 bytes, LZSS decompressor with variable-length bitstream encoding
- DisplaySetup cluster ($5092-$51B5): DONE -- 292 bytes, 6 functions: DisplaySetup/DisplayInitRows/DisplayInit15/DisplayInit0/DisplaySetupScaled/DisplayTileSetup
- High-call graphics/util ($4668-$74E0): DONE -- 234 bytes, 5 functions: CmdPlaceTile/CmdSetBackground/BitFieldSearch/GetByteField4/GetLowNibble + 2 more: MemMove/CmdPlaceTile2 (116B)
- Input/game cluster ($1E290-$1E3DD): DONE -- 268 bytes, 3 functions: ProcessInputLoop/PollInputChange/PreLoopInit
- MenuSelectEntry ($1D3AC): DONE -- 152 bytes, 14 calls, section_010000.asm
- LoadScreen ($6A2E): DONE -- 330 bytes, 38 calls, section_000200.asm
- CharCodeScore ($70DC): DONE -- 124 bytes, 12 calls, section_000200.asm; calls $006F42 via dc.w bsr.w
- RangeMatch ($7158): DONE -- 134 bytes, 10 calls, section_000200.asm; uses A2=RangeLookup ($D648) via jsr (a2)
- CharCodeCompare ($6F42): DONE -- 410 bytes, 22 calls, section_000200.asm; 7-category jump table (dc.w $303B/$4EFB pattern), calls CharPairIndex + RangeLookup + SignedDiv
- CharPairIndex ($71DE): DONE -- 74 bytes, 1 call (from CharCodeCompare), section_000200.asm; triangular index for symmetric pair lookup
- DrawBox ($5A04): DONE -- 608 bytes, 42 calls, section_000200.asm; LINK/MOVEM frame, sets 4 win vars, GameCommand #$1A fill + #$1B tiles; A3/A4 = &local_tile(A6-2), ADDQ.W #1,(A3) tile sequencing, BCC.W bounds check
- TMSS boot ($200-$28C): not yet (standard Genesis boilerplate)
- vasm bra.w: CONFIRMED correct displacement (no +2 bug like bsr.w)
- vasm pea ($xxxx).w: CONFIRMED correct absolute short encoding
- vasm movem.l d0-d7/a0-a7: works correctly with $FFFF reglist
- vasm bsr.s: CONFIRMED correct displacement (no bug, unlike bsr.w)
- vasm divs.w/divu.w/mulu.w: CONFIRMED correct encoding
- vasm ext.l: CONFIRMED correct ($48C0 for D0)
- vasm addx.l/dbra: CONFIRMED correct encoding
- Most-called function: $000D64 (306 calls), $03E05C Multiply32 (204), $03AB2C SetTextCursor (174), $03B22C sprintf (171)
- Text system RAM: font_mode $FF1800, cursor_x $FF128A, cursor_y $FFBDA6, char_width $FF99DE, cursor_advance $FFA77A, win_left $FFBD68, win_top $FFB9E4, win_right $FFBDA8, win_bottom $FFBD48

### ROM Major Regions
- $000200-$052FFF: CODE (333KB, main game code)
- $054000-$065FFF: CODE (72KB)
- $066000-$06FFFF: PADDING (40KB, $FF fill)
- $070000-$074FFF: CODE (20KB)
- $076000-$0B7FFF: CODE (264KB, largest block)
- $0B8000-$0EFFFF: PADDING (224KB, $FF fill, largest gap)
- $0F0000-$0FBFFF: CODE (48KB)
- $0FC000-$0FFFFF: DATA + PADDING

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
| Sound driver | docs/sound-driver-v3.md | analysis/SYSTEM_EXECUTION_FLOW.md / Z80 Sound Driver |
| Boot sequence | analysis/SYSTEM_EXECUTION_FLOW.md / Boot Sequence | -- |
| Main game loop | analysis/SYSTEM_EXECUTION_FLOW.md / Main Game Loop | -- |
| V-INT handler | analysis/SYSTEM_EXECUTION_FLOW.md / V-INT Handler | -- |
| ROM layout / regions | analysis/ROM_MAP.md / Major Regions | -- |
| Genesis memory map | docs/genesis-technical-overview.md | KNOWN_ISSUES.md / Memory Map |
| ROM header format | docs/genesis-software-development-manual.md | KNOWN_ISSUES.md / SEGA ROM Header |
| Controller I/O | docs/genesis-software-development-manual.md | docs/sega-genesis-reference-sheets.md |
| Function reference | analysis/FUNCTION_REFERENCE.md | -- |
| String tables / text | analysis/ROM_MAP.md / Game Strings | -- |
| City name data | analysis/ROM_MAP.md (search: city) | -- |
