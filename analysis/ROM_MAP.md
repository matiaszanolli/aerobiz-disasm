# ROM Map -- Aerobiz Supersonic

Address ranges, section types, and notes. Updated as disassembly progresses.

## ROM Overview

| Range | Size | Type | Description |
|-------|------|------|-------------|
| $000000-$0000FF | 256B | Vectors | 68000 exception/interrupt vector table |
| $000100-$0001FF | 256B | Header | Sega Genesis ROM header |
| $000200-$?????? | ??? | Code/Data | Game code and data (to be mapped) |

## Section Details

(To be populated as the ROM is analyzed)

### Vector Table ($000000-$0000FF)
- See `disasm/sections/header.asm` for labeled vectors

### ROM Header ($000100-$0001FF)
- Console: SEGA MEGA DRIVE
- Publisher: KOEI
- Game: Aerobiz Supersonic
- Checksum: (TBD from ROM)
- ROM size: (TBD from ROM)

### Code Sections
(To be identified via execution tracing from reset vector)

### Data Sections
(To be identified via ROM scanning for non-code patterns)

### Padding / Unused
(To be identified)
