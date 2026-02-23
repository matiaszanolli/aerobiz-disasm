# ROM Map -- Aerobiz Supersonic

Address ranges, section types, and notes. Updated as disassembly progresses.

## ROM Overview

**Total ROM size:** 1,048,576 bytes (1MB, $100000)
**MD5:** `1269f44e846a88a2de945de082428b39`

| Range | Size | Type | Description |
|-------|------|------|-------------|
| $000000-$0000FF | 256B | Vectors | 68000 exception/interrupt vector table |
| $000100-$0001FF | 256B | Header | Sega Genesis ROM header |
| $000200-$0FFFFF | 1,048,064B | Code/Data | Game code and data |

### Code Density Heatmap (4KB blocks)

```
$000000: ################################################################
$040000: ###################.##################          ##### ##########
$080000: ########################################################
$0C0000:                                                 ############
```
`#` = code (5+ instruction markers), `.` = mixed, ` ` = empty/padding

## Major Regions

| Range | Size | Type | Description |
|-------|------|------|-------------|
| $000000-$0001FF | 512B | Header | Vectors + ROM header |
| $000200-$052FFF | 333KB | **CODE** | Main game code |
| $053000-$053FFF | 4KB | Mixed | Code/data boundary |
| $054000-$065FFF | 72KB | **CODE** | Game code continued |
| $066000-$06FFFF | 40KB | Padding | Fill $FF |
| $070000-$074FFF | 20KB | **CODE** | Game code |
| $075000-$075FFF | 4KB | Data | Non-code data |
| $076000-$0B7FFF | 264KB | **CODE** | Game code (largest block) |
| $0B8000-$0EFFFF | 224KB | Padding | Fill $FF |
| $0F0000-$0FBFFF | 48KB | **CODE** | Game code (late block) |
| $0FC000-$0FCFFF | 4KB | Data | Non-code data |
| $0FD000-$0FFFFF | 12KB | Padding | Fill $FF |

**Summary:** ~737KB code, ~35KB data/mixed, ~276KB padding (30% of ROM is unused fill)

## Code Statistics

| Metric | Count |
|--------|-------|
| RTS (function returns) | 854 |
| RTE (interrupt returns) | 6 |
| NOP | 682 |
| JSR abs.l | 3,873 |
| JMP abs.l | 3 |
| BSR (subroutine calls) | 2,968 |
| Estimated functions | ~854 |

## Key Code Regions

### Boot Code ($000200-$0003A0)

| Range | Description |
|-------|-------------|
| $000200-$000288 | TMSS security check (standard Genesis boot) |
| $00028E-$0002F8 | Inline data table (VDP init, Z80 stub, hw addresses) |
| $0002FA-$000308 | Wait for V-Blank |
| $00030A-$000394 | Game initialization (RAM clear, hardware setup, sound init) |
| $000396-$0003A0 | Enable interrupts, jump to main game ($D5B6) |

### Exception/Interrupt Handlers ($000F84-$0015AE)

| Range | Handler | Description |
|-------|---------|-------------|
| $000F84-$000FE0 | Exceptions | All 14 handlers -> common handler -> jsr $58EE -> halt |
| $001480-$001482 | EXT INT | NOP + RTE (unused) |
| $001484-$0014E4 | H-INT | HScroll raster effect (writes VSRAM) |
| $0014E6-$0015AE | V-INT | Main frame handler (DMA, display, input, subsystems) |

### Z80 Sound Driver ($002696-$003BE7)

| Field | Value |
|-------|-------|
| ROM location | $002696-$003BE7 |
| Size | 5,458 bytes ($1552) |
| Load target | Z80 RAM ($A00000) |
| Init routine | $00260A |

### Game Strings ($03E1AC-$041510+)

Large block of ASCII game text (English). Printf-style formatting with `%s`, `%d`, `%$lu`.

Content includes: scenario descriptions, advisor dialogue, route management, business ventures,
regional hubs, campaign management, fleet management, financial reports, victory conditions.

### Main Game Code

| Address | Function | Description |
|---------|----------|-------------|
| $00D5B6 | GameEntry | Main game entry (called from boot) |
| $00D602 | GameLoopSetup | One-time pre-loop init, falls into loop |
| $00D608 | MainLoop | Main game loop (iterates forever) |

## Vector Table ($000000-$0000FF)

See `disasm/sections/header.asm` for fully labeled vectors.

| Offset | Vector | Target | Description |
|--------|--------|--------|-------------|
| $0000 | Initial SP | $00FFF000 | Stack pointer (top of Work RAM) |
| $0004 | Reset | $00000200 | Entry point |
| $0008 | Bus Error | $00000F84 | Exception handler |
| $000C | Address Error | $00000F8A | Exception handler |
| $0010 | Illegal Instr | $00000F90 | Exception handler |
| $0014 | Zero Divide | $00000F96 | Exception handler |
| $0018 | CHK | $00000F9C | Exception handler |
| $001C | TRAPV | $00000FA2 | Exception handler |
| $0020 | Privilege Viol | $00000FA8 | Exception handler |
| $0024 | Trace | $00000FAE | Exception handler |
| $0028 | Line-A | $00000FB4 | Exception handler |
| $002C | Line-F | $00000FBA | Exception handler |
| $0030-$003C | Reserved | $FC0-$FD2 | Have handlers (non-zero) |
| $0068 | EXT INT (Lv2) | $00001480 | External interrupt (unused) |
| $0070 | H-INT (Lv4) | $00001484 | Horizontal blank interrupt |
| $0078 | V-INT (Lv6) | $000014E6 | Vertical blank interrupt |

## ROM Header ($000100-$0001FF)

| Field | Value |
|-------|-------|
| Console | SEGA GENESIS |
| Copyright | (C)T-76 1994.DEC |
| Domestic name | エアロビズ (Shift-JIS) |
| Overseas name | AEROBIZ SUPERSONIC |
| Product code | GM T-76136 -00 |
| Checksum | $4620 |
| I/O support | J (3-button joypad) |
| ROM range | $000000-$0FFFFF |
| RAM range | $FF0000-$FFFFFF |
| SRAM | Present, battery-backed, odd-addressed |
| SRAM range | $200001-$203FFF (~8KB) |
| Region | U (USA) |

## Padding Regions (major)

| Range | Size | Fill |
|-------|------|------|
| $065906-$06FFFF | 42,746B | $FF |
| $0B7550-$0EFFFF | 232,112B | $FF |
| $0FC622-$0FFFFF | 14,814B | $FF |

Total: 211 padding regions, 313,037 bytes (29.9% of ROM).

## Assembly Source Files

| File | ROM Range | Size |
|------|-----------|------|
| disasm/sections/header.asm | $000000-$0001FF | 512B |
| disasm/sections/section_000200.asm | $000200-$00FFFF | 63,488B |
| disasm/sections/section_010000.asm | $010000-$01FFFF | 65,536B |
| disasm/sections/section_020000.asm | $020000-$02FFFF | 65,536B |
| disasm/sections/section_030000.asm | $030000-$03FFFF | 65,536B |
| disasm/sections/section_040000.asm | $040000-$04FFFF | 65,536B |
| disasm/sections/section_050000.asm | $050000-$05FFFF | 65,536B |
| disasm/sections/section_060000.asm | $060000-$06FFFF | 65,536B |
| disasm/sections/section_070000.asm | $070000-$07FFFF | 65,536B |
| disasm/sections/section_080000.asm | $080000-$08FFFF | 65,536B |
| disasm/sections/section_090000.asm | $090000-$09FFFF | 65,536B |
| disasm/sections/section_0A0000.asm | $0A0000-$0AFFFF | 65,536B |
| disasm/sections/section_0B0000.asm | $0B0000-$0BFFFF | 65,536B |
| disasm/sections/section_0C0000.asm | $0C0000-$0CFFFF | 65,536B |
| disasm/sections/section_0D0000.asm | $0D0000-$0DFFFF | 65,536B |
| disasm/sections/section_0E0000.asm | $0E0000-$0EFFFF | 65,536B |
| disasm/sections/section_0F0000.asm | $0F0000-$0FFFFF | 65,536B |
