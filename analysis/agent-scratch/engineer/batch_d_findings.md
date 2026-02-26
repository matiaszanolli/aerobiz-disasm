# B-055 Batch D: Function Description Findings

**Date:** 2026-02-26
**File:** `disasm/sections/section_000200.asm`
**Batch scope:** ~81 functions across display layers, scroll, memory utilities, icon placement, scroll bars, character system, and character UI

---

## Functions Described (63 edits)

### Display Layer System
- **DrawLayersReverse** -- Loop 8 palette layers calling FadePalette, index counts 7 down to 0
- **DrawLayersForward** -- Loop 8 palette layers calling FadePalette, index counts 0 up to 7
- **ComputeDisplayAttrsUpper** -- For 8 rows (0→7), scan each element, write max of 3 RGB nibbles to output
- **ComputeDisplayAttrsLower** -- For 8 rows (7→0), scan each element, write max of 3 RGB nibbles to output
- **NormalizeDisplayAttrs** -- Step each color channel toward target value over 8 iterations
- **InitTileBuffer** -- Load tile ROM data to $FF14BC, clear display init flag at $FFA7DC

### Buffer / Background / Clear
- **CopyWithMultiply** -- Copy tile rows into buffer using row*width arithmetic as offset
- **CopyBufferPair** -- Call CopyWithMultiply twice, for source flags 0 and 1
- **BuildSpriteBuffer** -- Build sprite attribute table in 512-byte local frame buffer, submit via GameCommand #15
- **ClearScreen** -- Sequence GameCommand calls: #13 (clear), #16 (fill tile), #26 (blank layers), #12

### Scroll System
- **SetHorizontalScroll** -- Store scroll value at $FFA784, negate+mask to 10 bits, call GameCommand #8
- **SetVerticalScroll** -- Store scroll value at $FFA788, call GameCommand #9
- **SetScrollBothAxes** -- Set H and V scroll from one argument, store at $FFA782
- **SetScrollAlternate** -- Store alternate scroll value at $FFA786
- **SetScrollQuadrant** -- Look up quadrant in table, set palette reg and offsets at $FFA77C/$FFA77E
- **SelectPaletteMode** -- Set VDP reg 12 to $8C08 (shadow/highlight) or $8C00 (normal) based on D2
- **ConfigDmaMode** -- Initialize VDP registers 4-23 via 14 GameCommand calls
- **InitScrollModes** -- Set VDP scroll registers and RAM scroll variables to default layout
- **PreGameInit** -- Clear and fill RAM + VRAM map + call ConfigDmaMode + InitScrollModes
- **ResetScrollModes** -- GameCommand #13 then ConfigDmaMode + InitScrollModes
- **UpdateScrollDisplay** -- If quadrant=$20, compute offsets and call GameCommand #29

### Memory Utilities
- **ClearMemoryRange** -- Zero bytes in interleaved stride-2 region (base $200003 + index*2)
- **CopyMemoryOffset** -- Copy source bytes to interleaved region with byte-sum checksum
- **CopyDataWithChecksum** -- Copy interleaved region to dest buffer with byte-sum checksum
- **ComputeDataChecksum** -- Sum bytes in interleaved stride-2 region
- **ComputeDataChecksumAlt** -- Sum bytes in flat buffer via direct pointer increment
- **EmptyStub** -- Contains only RTS; no-op placeholder
- **ErrorDisplay** -- Call GameCommand #30

### Icon / Tile Placement Utilities
- **PlaceIconPair** -- Place 2 icon tiles at a screen position
- **DrawTileStrip** -- Build null-terminated fill tile strip plus half-tile overhang
- **RenderTileStrip** -- Render horizontal strip with fill and partial endpoint tiles

### Screen / Graphics Loading
- **FillSequentialWords** -- Write N incrementing words to buffer
- **LoadCompressedGfx** -- Load world-map graphics for screen IDs 18-25

### Scroll Bars
- **UpdateScrollBar1** -- Tick frame counter for slot 0 at $FFBDAE, draw animation frame when period elapsed
- **UpdateScrollBar2** -- Tick frame counter for slot 1 at $FFBDC4, draw animation frame when period elapsed
- **CalcScrollBarPos** -- Compute modulo-clamped positions, apply via GameCommand #5
- **UpdateScrollCounters** -- Tick H/V counters, advance scroll position when period elapsed
- **TickAnimCounter** -- Increment animation tick counter at $FFBDE2
- **DispatchScrollUpdates** -- Check bit flags and dispatch to UpdateScrollBar1/2, UpdateScrollCounters, TickAnimCounter
- **ConfigScrollBar** -- Set slot frame rate, data pointer, and enable flag
- **SetScrollBarMode** -- Switch scroll counter mode
- **ToggleScrollBar** -- Enable/disable animation tick scroll bar (bit 3 of $FFBDAC)

### Character Info Panel / UI
- **DrawCharInfoPanel** -- Draw character info panel with tile graphics, stat bar, and scroll bar overlays

### Character Search / Comparison System
- **FindCompatChars** -- Scan 7 character slots for bitfield matches and render tile icons for each match
- **SetHighNibble** -- Write argument byte shifted left 4 into high nibble of byte[2] of struct pointer
- **UpdateCharField** -- Write low nibble to struct byte[2], compute compat score, clamp to byte[3] max
- **CalcCompatScore** -- Score character pair compatibility via CharCodeCompare tier table, apply type bonus, clamp to 30
- **CountMatchingChars** -- Count roster entries for player D3 matching char code D4 via BitFieldSearch
- **FindCharSlot** -- Find absolute roster index for char code D4 in player D2 slot; return -1 if not found
- **CalcTypeDistance** -- Return absolute category distance between two char types from $FF1298/$FF99A4 tables
- **FindSlotByChar** -- Search low ($FF0420) or high ($FF0460) char code table for char code; return 1 if found

### Character Preview / Dialog
- **SelectPreviewPage** -- Display 6-page character preview table and handle left/right/confirm/cancel input
- **CheckCharRelation** -- Test if char code D2 is present in player relation bitfield at $FFA6A0 or $FFBD6C
- **CheckBitField** -- AND player bitfield at $FFA6A0 with $5ECDC relation mask; resolve slot via $D648 if D2=$FF
- **HitTestMapTile** -- Test screen (X,Y) against two hit-rect groups from $5E9FA/$5ECBC tables; return region or $FF
- **ShowCharProfile** -- Render character profile panel with text window, tile header, and ShowCharDetail display
- **ShowCharDetail** -- Render full character detail panel: clear tiles, draw stat bars, format numeric stat fields

---

## Functions Already Described (no TODO -- skipped)

- DisplaySetup, DisplayInitRows, DisplayInit15, DisplayInit0, DisplaySetupScaled, DisplayTileSetup
- CmdSetBackground
- PlaceIconTiles, DrawBox
- FillTileRect, LoadScreenGfx, LoadScreen, ShowRelPanel
- BitFieldSearch, CharCodeCompare, CharCodeScore, RangeMatch, CharPairIndex
- GetLowNibble, GetByteField4
- ShowDialog, AdjustScrollPos

## Functions Without Header Block (skipped)

- **CalcCharRating** ($00769C) -- No header comment. Has no link/unlk frame. Computes rating score using CalcTypeDistance + CharCodeScore, multiplied by 25 and adjusted for match bonus.
- **CalcWeightedStat** ($008016) -- Already had description at line 10361 (was complete before batch started).

---

## Technical Notes

### Interleaved ROM/RAM Region Pattern
ClearMemoryRange, CopyMemoryOffset, CopyDataWithChecksum, and ComputeDataChecksum all operate on an interleaved stride-2 region where actual data bytes reside at `base + index*2` (odd addresses in the range starting at $200003). ComputeDataChecksumAlt is the exception -- it operates on a flat buffer with direct pointer increment.

### Scroll Bar Slots
Two independent scroll animation slots exist:
- Slot 0: $FFBDAE (data pointer), controlled by bit 1 of $FFBDAC
- Slot 1: $FFBDC4 (data pointer), controlled by bit 2 of $FFBDAC
- TickAnimCounter uses bit 3 of $FFBDAC and a separate counter at $FFBDE2

### Character Type System
- $FF1298: Per-char type code table (stride-4, byte[0] = type)
- $FF99A4: Category byte table indexed by type code
- Category 4 is a special "universal" type (always distance 1 from any other)
- Categories 1 and 2 are also treated as adjacent (special case in CalcTypeDistance)

### Char Code Range Split
- Codes 0-31 ($20): Use $FF0420 table (6 bytes per entry)
- Codes 32+ ($20+): Use $FF0460 table (4 bytes per entry, stride-4 via lsl #2)

### CheckCharRelation vs CheckBitField
These two are closely related but distinct:
- CheckCharRelation: tests char code D2 directly against $FFA6A0 bitfield (32-bit shift) OR against $FFBD6C relation matrix (indexed by player D4 and slot D5)
- CheckBitField: uses precomputed relation mask from ROM table $5ECDC, ANDs against $FFA6A0

### HitTestMapTile Hit-Rect Format
$5ECBC table: per-region entry = byte[0]=start_index, byte[1]=count_group1, byte[2]=start_index2, byte[3]=count_group2
$5E9FA table: packed (x,y) pairs as consecutive bytes. Each rect tested as: x in [rx-2, rx+10) AND y in [ry-2, ry+10)
