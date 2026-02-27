# Engineer Findings -- B-054 Data Region Labeling

## Region 1: $3D16-$3F6F Analysis (TMSS Boot Screen Data)

The data block at $3D16 is referenced exclusively by `EarlyInit` ($3BE8) and its
helper `WriteVDPTileRow` ($3CE0). EarlyInit reads the version register ($A10001),
extracts bits[7:6] to get a region index (0-3), and uses these tables to render the
TMSS "PRODUCED BY OR UNDER LICENSE..." text via the VDP.

Note: $3F70-$3FEB contains code (the bitstream-reader helper for LZ_Decompress),
not data. The data region ends at $3F6F.

### Sub-region breakdown ($3D16-$3F6F = 858 bytes = 429 dc.w words)

**$3D16 -- TMSSRegionTable** (4 bytes)
- Byte table indexed by version bits[7:6] (0-3)
- Values: J=0x4A ('J'), 0x00 (none), U=0x55 ('U'), E=0x45 ('E')
- EarlyInit reads `TMSSRegionTable[region_index]` to get the system identifier char

**$3D1A -- TMSSCharTable** (24 bytes = 4 entries x 6 bytes)
- 6-byte entries: word(match_char) | long(byte_offset from TMSSRegionTable)
- Entry 0: char='J' (0x004A), offset=$00000042 -> $3D58 (NTSC MEGA DRIVE string)
- Entry 1: char='U' (0x0055), offset=$00000053 -> $3D69 (NTSC GENESIS string)
- Entry 2: char='E' (0x0045), offset=$00000061 -> $3D77 (PAL string)
- Entry 3: $0000 = end of table

**$3D2E -- TMSSTopStr** (20 bytes)
- Byte 0: column=$06 (VDP tile column to start writing at)
- Bytes 1+: "DEVELOPED FOR USE ONLY WITH\0" (null-terminated)
- Referenced by: `lea $3d2e(pc), a0` in EarlyInit's main render loop

**$3D4B -- TMSSSpaceStr** (3 bytes)
- Byte 0: column=$12 (18)
- Bytes 1+: "&\0" (ampersand = separator/connector word or decorative space tile)
- Referenced by: `lea $3d4b(pc), a0` for space/separator character

**$3D4E -- TMSSSystemsStr** (10 bytes)
- Byte 0: column=$0F (15)
- Bytes 1+: "SYSTEMS.\0" (null-terminated)
- Referenced by: `lea $3d4e(pc), a0` for second line of license text

**$3D58 -- TMSSNTSCMegaDriveStr** (17 bytes)
- Byte 0: column=$0C (12)
- Bytes 1+: "NTSC MEGA DRIVE\0"
- Pointed to by TMSSCharTable entry 0 (Japan region, 'J')

**$3D69 -- TMSSNTSCGenesisStr** (14 bytes)
- Byte 0: column=$0D (13)
- Bytes 1+: "NTSC GENESIS\0"
- Pointed to by TMSSCharTable entry 1 (USA region, 'U')

**$3D77 -- TMSSPALStr** (33 bytes)
- Byte 0: column=$04 (4)
- Bytes 1+: "PAL AND FRENCH SECAM MEGA DRIVE\0"
- Pointed to by TMSSCharTable entry 2 (Europe region, 'E')

**$3D98 -- TMSSFontTiles** (472 bytes = 59 tiles × 8 bytes)
- 1bpp 8x8 glyph bitmaps for the TMSS text rendering engine
- EarlyInit loops 59 times reading 8 bytes each, converting to VDP pixel data
- Tile set covers: '!' (0x18 pattern), '"', digits 0-9, uppercase A-Z, misc punctuation
- Referenced by: `lea $3d98(pc), a0` then outer loop `dbra d0, $3C56` (d0=$3A=58)
- VDP conversion: each bit expanded to a 4-pixel run via ROL.L+ROR.B pattern

$3F70-$3FEB: code (LZ_Decompress bitstream-reader helper, not data -- already labeled
via LZ_Decompress function comment at line 3680)

---

## Region 2: $1D1A-$24B7 Analysis (Display/Palette Data)

The data block starting at $1D1A (the task describes starting at $1D20, but $1D1A is
the actual boundary) is split into several distinct sub-regions used by different
display-related functions. A code function (UpdateAnimTimer at $1D58-$1D87) sits
embedded within the data region.

### Sub-region breakdown

**$1D1A -- BlueAnimPalette** (62 bytes = 31 words)
- Genesis color words in format %0000BBB0GGG0RRR0
- Blue-dominant cycling gradient: $0EC0 -> $0000 (11 steps down) then back up
- Exact sequence: EC0,EA0,E80,E60,E40,E20,E00,C00,A00,800,600,
                  800,A00,C00,E00,E20,E40,E60,E80,EA0,EC0,
                  EA0,E80,E60,E40,E20,E00,C00,A00,800,600
- Used by InitAnimTable ($1CA0) and UpdateAnimTimer ($1D58): both do
  `lea $1d1a(pc, d0.w), a0; moveq #$A, d0; move.w (a0)+,(a1)+; dbra` to copy 11
  consecutive words to $FFF06A (VDP color RAM buffer) -- animates boot palette

[Code gap: UpdateAnimTimer function at $1D58-$1D87]

**$1D88 -- InitSpriteTiles** (1600 bytes = 50 tiles × 32 bytes = 800 words)
- 4bpp Genesis VDP tile data (each tile: 8 rows × 4 bytes = 32 bytes)
- Written to VRAM at address 0 by Init5 ($10DA): move.w (a6)+,(a5); dbra d1,$10F6
  where D1=$31F (800 iterations) -- bulk-loads all tiles to VRAM at boot
- Also referenced by CmdPlaceTile2 call: pea($00001D88).l loads 51 tiles into
  tile slot $0200 (tile number 512+) for screen background setup
- Data is 4bpp nibble-packed tile pixels; leading 40 bytes ($1D88-$1DAF) are
  zero (blank tile + partial blank tile)
- Nibble values are palette indices 0-15; patterns like $1111/$7778/$8889 are
  typical dithered 4bpp sprite tiles (background image/logo tiles)

**$23C8 -- 8 bytes zero padding** (between tile data and index tables)

**$23D0 -- TileIndexTable_A** (96 bytes = 48 words)
- Word array of tile slot indices for display frame A
- Layout: 4 leading zero words, then 1..11, 0 (separator), 12..47
- Effectively maps 48 sprite/tile positions to VRAM slot numbers
- Position 12 uses slot 0 (blank) where table B uses slots $30/$31

**$2430 -- TileIndexTable_B** (96 bytes = 48 words)
- Word array of tile slot indices for display frame B
- Same structure but positions 11-12 are $0030/$0031 (alternate tiles)
- Both tables together form a two-frame animation or A/B plane mapping

**$2498 -- $0000** (2 bytes, table terminator / palette separator)

**$249A -- FadeInPalette** (30 bytes = 15 words)
- Genesis color words for a white-to-blue fade sequence
- Values: EEE,EC0,EA0,E80,E60,E40,E20,E00,C00,A00,800,600,800,A00,C00
- Format: $0EEE=white (B=7,G=7,R=7), fading through blue ($0E00), to dim blue ($0600)
  then rising back to $0C00 -- 15-entry fade palette for screen transitions

---

## Labels Added

### In section_000200.asm

**Region 1 ($3D16)**: Added 8 labels with descriptive comments:
- `TMSSRegionTable:` at $3D16
- `TMSSCharTable:` at $3D1A
- `TMSSTopStr:` at $3D2E
- `TMSSSpaceStr:` at $3D4B
- `TMSSSystemsStr:` at $3D4E
- `TMSSNTSCMegaDriveStr:` at $3D58
- `TMSSNTSCGenesisStr:` at $3D69
- `TMSSPALStr:` at $3D77
- `TMSSFontTiles:` at $3D98

**Region 2 ($1D1A)**: Added 6 labels with descriptive comments:
- `BlueAnimPalette:` at $1D1A
- `InitSpriteTiles:` at $1D88
- `TileIndexTable_A:` at $23D0
- `TileIndexTable_B:` at $2430
- `FadeInPalette:` at $249A

---

## Build Verification (MD5)

`make clean && make all` succeeded. MD5 of build/aerobiz.bin:
```
1269f44e846a88a2de945de082428b39  build/aerobiz.bin
```
Matches expected. Build is byte-identical to original ROM. All labels are comment-only additions; no dc.w values were changed.

---

## Note on Odd-Byte Labels

Three TMSS data addresses are odd-byte (not word-aligned):
- `TMSSSpaceStr` ($3D4B) -- not given an assembly label; documented via comments on the containing word ($3D4A = $0012, where $3D4B holds the column byte $12=18)
- `TMSSNTSCGenesisStr` ($3D69) -- label placed at $3D6A (next word boundary); comment notes the true odd-byte address
- `TMSSPALStr` ($3D77) -- label placed at $3D78 (next word boundary); comment notes the true odd-byte address

These labels cannot be placed at the true byte addresses without converting the surrounding dc.w to dc.b, which would be a structural change. The EarlyInit code uses numerical PC-relative offsets (`lea $3D69(pc)`) not label names, so the symbol table addresses do not affect assembly output.

## Recommendation

- The `TMSSSpaceStr` at $3D4B contains an ampersand '&' (0x26) as the first displayed
  character. This looks unusual but matches: the full license reads "DEVELOPED FOR USE
  ONLY WITH [system] SYSTEMS." The '&' may be a decorative space tile or a system-
  specific glyph in the tile font. Worth confirming via emulator screenshot.

- The `TMSSCharTable` entries at $3D1A use absolute offsets from TMSSRegionTable base
  (not from PC). EarlyInit does `lea $3d16(pc), a0; adda.l (a2)+, a0` which adds the
  stored offset to the base address of TMSSRegionTable.

- The two tile index tables ($23D0 and $2430) differ only at positions 11 and 12:
  Table A has ($000B, $0000) and Table B has ($0030, $0031). These likely correspond
  to two different animation or display configurations for the same tile layout.

- `FadeInPalette` ($249A) is distinct from `BlueAnimPalette` ($1D1A): the fade palette
  includes white ($0EEE) and fades through blue, while the anim palette starts at
  medium-blue ($0EC0) and cycles without white. They serve different visual purposes.
