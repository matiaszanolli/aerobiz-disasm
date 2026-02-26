# B-055 Batch C Findings

## Functions Described

- InitAnimTable: Initialize boot animation: copy gradient palette, poll VRAM, cycle until done
- UpdateAnimTimer: Advance boot palette animation: decrement timer, shift gradient index, copy colors
- CmdSendZ80Param: GameCommand Z80 dispatch: send 3-byte param, signal Z80, poll for result
  (Note: CmdSendZ80Param is the actual block header; CmdSendZ80Byte/CmdTriggerZ80/CmdLoadZ80Tables/CmdLoadZ80Encoded are fall-through entry points within this block with no separate header)
- EarlyInit: TMSS boot screen: detect region, load font tiles, render license text to VDP
- WriteColorBitsVRAM: Bit-pack D2 bits from source word into 16-bit accumulator for VDP tile output
- VRAMWriteWithMode: Set VDP VRAM address via control port (A6), read one byte from data port (A5)
- VRAMWriteExtended: Set VDP address via control port, merge D0 byte into existing word and write back
- DecompressVDPTiles: Decompress LZ-encoded 4bpp tile data directly into VDP VRAM via data port
- TilePlaceWrapper: Place tile block via GameCommand(8, 2) with sub-command 1 flag
- FillTileSequence: Fill buffer with sequential BAT cell words encoding palette, flip, and tile index
- AddToTileBuffer: Add a fixed word offset to each entry in a tile buffer array
- TilePlaceComposite: Place tile block via cmd 8 then fill sequential tile indices in one call
- TilePaletteRotate: Place tile block via cmd 5 then fill sequential tile indices in one call
- LoadPaletteDataTile: Copy tiles from 2D source grid into a local buffer then place via CmdPlaceTile
- BuildPaletteWord: Build BAT attribute word from palette and flip args, load tiles, write to output buffer
- SetPaletteViaCmd: Write palette data to CRAM via GameCommand(8, 2) with VRAM base offset
- ApplyPaletteMask: Replace matching 4-bit color nibbles in palette entries using mask table
- ApplyPaletteIndex: Remap 4-bit palette nibbles via index lookup table across multiple palette entries
- ProcessPaletteIter: Swap matching color nibbles between two palette values across palette entries
- ApplyPaletteShifts: Load tiles via GameCommand, apply palette index shift to each entry, then flush
- BuildSpriteDataRows: Build sprite attribute table rows from source data with Y/link/attr/X layout
- WriteCharUIDisplay: Upload character sprite data via GameCommand(8, 2) and copy to display buffer
- FadePalette: Clamp each RGB channel of palette entries toward a target level and write to output

## Functions Skipped (no TODO or already described)

- CmdSendZ80Byte: No standalone header block; inline entry point within CmdSendZ80Param block
- CmdTriggerZ80: No standalone header block; inline entry point within CmdSendZ80Param block
- CmdLoadZ80Tables: No standalone header block; inline entry point within CmdSendZ80Param block
- CmdLoadZ80Encoded: No standalone header block; inline entry point within CmdSendZ80Param block
- Z80_SoundInit: Already described ("Load Z80 sound driver from ROM into Z80 RAM")
- Z80_RequestBus: Already described ("Request and wait for Z80 bus ownership")
- Z80_ReleaseBus: Already described ("Release Z80 bus")
- Z80_Delay: Already described ("Busy-wait delay (~5ms at 7.67 MHz)")
- WriteVDPTileRow: No standalone header block; falls directly inside EarlyInit's translated block
- LZ_Decompress: No `; LZ_Decompress -- (TODO:...)` header; preceded by a detailed block comment
- MemMove: No `; MemMove -- (TODO:...)` header; uses `; === MemMove ...` inline label style
- CmdPlaceTile2: No `; CmdPlaceTile2 -- (TODO:...)` header; uses `; === CmdPlaceTile2 ...` inline style
- CmdPlaceTile: Already described ("Place tile block via GameCommand(5, 2, ...)")

## Notes

- CmdSendZ80Param (not in the original batch list) was also described since it contains the
  the TODO for the entire Z80 command dispatch block (lines 3007-3132). Its sub-entry points
  (CmdSendZ80Byte, CmdTriggerZ80, CmdLoadZ80Tables, CmdLoadZ80Encoded) are fall-through labels
  with inline `; -- GameCommand N: ...` comments rather than full header blocks.

- VRAMWriteWithMode and VRAMWriteExtended use A6 as VDP control port ($C00004) and A5 as VDP
  data port ($C00000). Both compute the VDP address control word from an address register using
  the standard Genesis bit-shuffle: `addr & $FFFE` -> split into bits[17:16] and bits[15:1],
  recombine with $40000000 prefix. VRAMWriteWithMode reads a byte; VRAMWriteExtended merges a
  byte into an existing word and writes it back.

- WriteColorBitsVRAM is a bitstream accumulator helper: it maintains a 16-bit register
  ($FF88DA) and a bit-count register ($FFBD50). When the accumulator fills, it fetches the next
  source word from (A1) and wraps the remaining bits. Used by DecompressVDPTiles.

- DecompressVDPTiles mirrors the LZ_Decompress algorithm but outputs directly to VDP VRAM via
  VRAMWriteWithMode ($4EB9 $4EB9 dc.w jsr calls to $4EB9/$4EBA addresses). It processes 8
  control bits per control byte iteration.

- FadePalette takes a "level" parameter (0-7). For each palette entry, it extracts B/G/R
  channels (bits[11:9], [7:5], [3:1]), subtracts the fade level clamped to 0, and packs back.
  Called by DrawLayersReverse/DrawLayersForward to fade 8 palette entries in sequence.
