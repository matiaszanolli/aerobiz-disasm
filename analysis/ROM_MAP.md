# ROM Map -- Aerobiz Supersonic

Address ranges, section types, and notes. Updated as disassembly progresses.

## ROM Overview

| Range | Size | Type | Description |
|-------|------|------|-------------|
| $000000-$0000FF | 256B | Vectors | 68000 exception/interrupt vector table |
| $000100-$0001FF | 256B | Header | Sega Genesis ROM header |
| $000200-$0FFFFF | 1,048,064B | Code/Data | Game code and data (to be mapped) |

**Total ROM size:** 1,048,576 bytes (1MB, $100000)
**MD5:** `1269f44e846a88a2de945de082428b39`

## Section Details

### Vector Table ($000000-$0000FF)

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
| $0068 | EXT INT (Lv2) | $00001480 | External interrupt |
| $0070 | H-INT (Lv4) | $00001484 | Horizontal blank interrupt |
| $0078 | V-INT (Lv6) | $000014E6 | Vertical blank interrupt |

**Notable:** Exception handlers are clustered at $000F84-$000FD2 (6 bytes each). All TRAP vectors and most reserved vectors are $00000000 (unused).

### ROM Header ($000100-$0001FF)

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

### Code Sections
(To be identified via execution tracing from reset vector -- B-004)

**Known code entry points from vector table:**
- $000200: Entry point / boot code
- $000F84-$000FD2: Exception handlers
- $001480: EXT interrupt handler
- $001484: H-blank interrupt handler
- $0014E6: V-blank interrupt handler

### Data Sections
(To be identified via ROM scanning for non-code patterns -- B-003)

### Padding / Unused
(To be identified -- B-003)

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
