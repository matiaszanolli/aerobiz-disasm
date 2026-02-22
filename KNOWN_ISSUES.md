# KNOWN_ISSUES -- Pitfalls, Bugs, and Gotchas

Lessons learned across sessions. **Read this before modifying code.**

---

## 68K Assembly Translation

### ASL vs LSL -- Different Opcodes
- `ASL.L #4,D0` = $E980 (type bits 4-3 = 00)
- `LSL.L #4,D0` = $E988 (type bits 4-3 = 01)
- Both shift left identically for positive values, but encode differently and have different flag behavior
- **Always verify against ROM bytes**

### BSR.W vs JSR (d16,PC) -- Different Opcodes
- `BSR.W label` = $6100 + displacement
- `JSR label(pc)` = $4EBA + displacement
- **Fix:** Use `jsr label(pc)` syntax in vasm to get the $4EBA encoding

### Indexed vs Displacement Addressing -- Easy to Confuse
- `dc.w $31BC,$0000,$2000` is **NOT** `move.w #$0000,$2000(a0)` (d16,An mode 5)
- It IS `move.w #$0000,(a0,d2.w)` (d8,An,Xn mode 6) -- $2000 is the extension word
- Extension word $2000 = D2.W index register, displacement $00
- **Rule:** When translating dc.w with 3+ words, decode the addressing mode bits before choosing mnemonic syntax

### vasm BSR.W -- Displacement May Be Off by +2
vasm's `bsr.w` may generate a displacement 2 bytes too large. This was confirmed in the
VRD sister project and applies to the same assembler.

**Prefer alternatives:**
- `bsr.s label` -- for targets within +/-127 bytes (always correct, shorter)
- `jsr label(pc)` -- for longer-range PC-relative calls
- `jsr label` -- when `label` is an absolute `equ` constant

### MOVE.W #$0000 vs CLR.W -- Different Encodings
- `MOVE.W #$0000,(addr)` = 6 bytes
- `CLR.W (addr)` = 4 bytes
- They produce the same result but encode differently
- **Never substitute one for the other when byte-matching original ROM**

### m68k_disasm.py Known Bugs
The project disassembler (`tools/m68k_disasm.py`) has these confirmed issues:
- **ASL/LSL:** Shift count field 000 means 8, not 0 (shows wrong count)
- **EXT.L** ($48C0): Confused with MOVEM.L when followed by certain words
- **CLR.W** ($4268): Decoded as CLR.B (size bits 01=word decoded as byte)
- **DIVS.W** ($81Cx): Shown as "OR" (opcode line 8 misidentified)
- **BSR target address:** Computed incorrectly (uses wrong PC base)
- **Multi-word instructions:** Extension words sometimes parsed as new opcodes

**Rule:** Always verify disassembler output against ROM hex bytes for critical code.

---

## Genesis Hardware

### VDP DMA Timing
- DMA transfers must happen during V-Blank or H-Blank on real hardware
- DMA during active display causes VRAM corruption
- Emulators may be more lenient than real hardware -- always assume strict timing
- **Reference:** docs/genesis-software-development-manual.md

### VDP Auto-Increment
- Register $0F controls auto-increment for VRAM/CRAM/VSRAM writes
- Must be set before bulk write operations
- Common value: $02 (increment by 2 for word writes)
- Wrong increment = data scattered across VRAM at wrong addresses

### Z80 Bus Arbitration
- Write $0100 to $A11100 to request bus
- Poll $A11100 until bit 0 is set (bus granted)
- Access Z80 RAM ($A00000-$A01FFF) only while bus is held
- Write $0000 to $A11100 to release
- **Never access Z80 RAM without holding the bus**

### Genesis Memory Map Quick Reference
| Range | Size | Description |
|-------|------|-------------|
| $000000-$3FFFFF | 4MB max | Cartridge ROM |
| $A00000-$A01FFF | 8KB | Z80 RAM (bus required) |
| $A04000-$A04003 | 4B | YM2612 FM sound chip |
| $A10000-$A1001F | 32B | I/O ports (controllers) |
| $A11100-$A11101 | 2B | Z80 bus request |
| $A11200-$A11201 | 2B | Z80 reset |
| $C00000-$C00003 | 4B | VDP data port |
| $C00004-$C00007 | 4B | VDP control port |
| $C00008-$C0000F | 8B | VDP HV counter, PSG |
| $FF0000-$FFFFFF | 64KB | 68K Work RAM |

### SEGA ROM Header
- $000100-$0001FF: Standard Sega Genesis ROM header
- Contains: console name, copyright, game title (domestic/overseas), ROM checksum, I/O support, ROM address range, RAM address range, SRAM info, modem info, region
- Checksum at $00018E covers $000200 to end of ROM

---

## Aerobiz-Specific (to be populated)

### KOEI Game Engine Patterns
(To be documented as the disassembly progresses. KOEI games often share engine patterns
across titles -- look for common structures in save/load, menu systems, AI logic.)

---

## Abandoned Approaches (Don't Re-Try)

| Approach | Why It Failed |
|----------|--------------|
| (none yet) | |
