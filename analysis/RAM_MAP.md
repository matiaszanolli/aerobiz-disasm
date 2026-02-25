# RAM Map — Aerobiz Supersonic

Work RAM: `$FF0000–$FFFFFF` (64 KB, 68000 bus)

All addresses are 68000 absolute (no banking). `A5 = $FFF010` is the canonical
work-RAM base established by `GameCommand` and the V-Blank handler at every entry.
Low-level flags are accessed as A5-relative offsets; game-state structures use
direct absolute addresses.

**Primary source:** `PackSaveState` (`$00EB28`) serializes RAM in source-address
order with explicit sizes — the definitive layout reference.

---

## Summary Table

| Address         | Size       | Name                 | Description                                       |
|-----------------|------------|----------------------|---------------------------------------------------|
| `$FF0006`       | word       | frame_counter        | Incremented each MainLoop tick                    |
| `$FF0008`       | word       | frame_counter2       | Secondary timer, PollInputChange                  |
| `$FF0016`       | byte       | current_player       | Current player turn index (0–3)                   |
| `$FF0018`       | $90 (144B) | player_records       | 4 × $24 (36) bytes per player                     |
| `$FF0118`       | $08 (8B)   | player_word_tab      | 4 × word, one per player                          |
| `$FF05C4`       | ?          | char_stat_array      | Character stat records, stride $39 (57B) per char |
| `$FF08EC`       | $10 (16B)  | entity_bits          | Longword bitfield array indexed by entity         |
| `$FF0A34`       | word       | ui_active_flag       | Nonzero = UI/input system active                  |
| `$FF1000`       | word       | win_right_dup        | Duplicate of win_right ($FFBDA8)                  |
| `$FF1290`       | word       | win_left_dup         | Duplicate of win_left ($FFBD68)                   |
| `$FF1298`       | —          | char_stat_tab        | Per-char / per-stat-type 4-byte descriptor table  |
| `$FF1800`       | word       | font_mode            | 0 = narrow, 1 = wide                              |
| `$FF1802`       | word       | lz_init_flag         | LZ_Decompress init flag                           |
| `$FF1804`       | —          | save_buf_base        | Save state buffer base                            |
| `$FF420`        | $C0 (192B) | route_slot_tab_low   | Route slot block (PackSaveState)                  |
| `$FF8824`       | $40 (64B)  | tab32_8824           | 32-entry stride-2 table                           |
| `$FF9A20`       | $C80 (3200B)| route_slots         | 4 × 40 × $14 (20B) route slot array              |
| `$FF99DE`       | word       | char_width           | Character advance width (1 or 2)                  |
| `$FFA6A0`       | —          | bitfield_tab         | Entity bitfield array (longwords × entity)        |
| `$FFA77A`       | word       | cursor_advance       | Text cursor advance per character                 |
| `$FFA77E`       | word       | display_param2       | Tile-row multiply factor (BAT addressing)         |
| `$FFA78C`       | byte       | lz_ctrl_byte         | LZ_Decompress bitstream control byte              |
| `$FFA790`       | word       | input_mask           | Joypad button filter                              |
| `$FFA7DC`       | word       | display_flag         | Display init guard (0 = unloaded, 1 = loaded)     |
| `$FFA7E0`       | long       | rng_state            | LCG RNG seed                                      |
| `$FFA7E4`       | word       | rng_accum            | RNG accumulator                                   |
| `$FFB9E4`       | word       | win_top              | Top edge of text/display window                   |
| `$FFB9E8`       | $80 (128B) | event_records        | 4 × $20 (32B) records (event/flight state?)       |
| `$FFBA80`       | $2C8 (712B)| city_data            | 89 cities × 4 entries, stride 2                   |
| `$FFBD48`       | word       | win_bottom           | Bottom edge of text/display window                |
| `$FFBD56`       | —          | lz_window            | LZ_Decompress bitstream window buffer             |
| `$FFBD68`       | word       | win_left             | Left edge of text/display window                  |
| `$FFBDA8`       | word       | win_right            | Right edge of text/display window                 |
| `$FFF000`       | 10B        | ram_sub              | Boot-copied RAM subroutine                        |
| `$FFF010`       | —          | work_ram_base        | A5 canonical base (boot-cleared flags start here) |

---

## Regions

### `$FF0000–$FF0017`: Game State / Flags

| Address   | Size  | Name           | Description                                                              |
|-----------|-------|----------------|--------------------------------------------------------------------------|
| `$FF0003` | byte  | save_byte_03   | PackSaveState header byte 1 (purpose TBD)                                |
| `$FF0005` | byte  | save_byte_05   | PackSaveState header byte 2 (purpose TBD)                                |
| `$FF0006` | word  | frame_counter  | Incremented each MainLoop iteration. Used as RNG input and display timing. |
| `$FF0008` | word  | frame_counter2 | Secondary timer; read by PollInputChange for inter-frame command timing.  |
| `$FF000A` | word  | flight_active  | Nonzero when a flight/route operation is active (checked by UpdateFlightSlots). |
| `$FF000B` | byte  | save_byte_0b   | PackSaveState individual byte (purpose TBD)                              |
| `$FF000D` | byte  | save_byte_0d   | PackSaveState individual byte (purpose TBD)                              |
| `$FF000F` | byte  | save_byte_0f   | PackSaveState individual byte (purpose TBD)                              |
| `$FF0011` | byte  | save_byte_11   | PackSaveState individual byte (purpose TBD)                              |
| `$FF0012` | 4B    | save_block_12  | 4-byte block (PackSaveState, purpose TBD)                                |
| `$FF0016` | byte  | current_player | Current player turn index (0–3). Set by RunPlayerTurn.                   |

---

### `$FF0018–$FF00A7`: Player Records (4 × $24 = $90 bytes)

Base: `$FF0018`. Stride: `$24` (36 bytes). Indexed by player index 0–3.

```
$FF0018   Player 0 record  (36 bytes, ends $FF003B)
$FF003C   Player 1 record  (36 bytes, ends $FF005F)
$FF0060   Player 2 record  (36 bytes, ends $FF0083)
$FF0084   Player 3 record  (36 bytes, ends $FF00A7)
```

**Evidence:** `movea.l #$FF0018,a0; mulu.w #$24,d0; lea (a0,d0.w),a0` in
`FindRelationIndex`. PackSaveState `pea $0090.w; pea $FF0018.l`.

**Known fields (offsets within a player record):**
- `+$00`: longword — loaded for relation lookup (FindRelationIndex)
- `+$01`: byte — compared `cmpi.b #$20` in ShowRouteInfo (city/occupation code?)
- `+$06`: byte — read for display in ShowRouteInfo
- Other fields: TBD

---

### `$FF00A8–$FF00E7`: Unknown Block ($40 = 64 bytes)

PackSaveState: `pea $0040.w; pea $FF00A8.l`. Purpose unknown (?).

---

### `$FF00E8–$FF0117`: Unknown Block ($30 = 48 bytes)

PackSaveState: `pea $0030.w; pea $FF00E8.l`. Purpose unknown (?).

---

### `$FF0118–$FF011F`: Player Word Table ($08 = 8 bytes)

| Address   | Size | Name            | Description                                                    |
|-----------|------|-----------------|----------------------------------------------------------------|
| `$FF0118` | 8B   | player_word_tab | 4 words, one per player. Indexed `player_index * 2`. DrawPlayerRoutes reads `movea.l #$FF0118,a0; move.w (a0,d0.w),-$2(a6)`. |

---

### `$FF0120–$FF012F`: Char-Stat Sub-Table ($10 = 16 bytes)

| Address   | Size | Name            | Description                                                        |
|-----------|------|-----------------|--------------------------------------------------------------------|
| `$FF0120` | 16B  | char_stat_subtab | Byte array. `movea.l #$FF0120,a0; move.b (a0,d0.w),d0` with `d0 = player_index * 4`. Used by GetCharStat path. |

---

### `$FF0130–$FF02E7`: Unknown Blocks

| Address   | Size      | Notes                                           |
|-----------|-----------|-------------------------------------------------|
| `$FF0130` | $80 (128B) | PackSaveState block; purpose TBD               |
| `$FF01B0` | $80 (128B) | PackSaveState block; purpose TBD               |
| `$FF0230` | $40 (64B)  | PackSaveState block; purpose TBD               |
| `$FF0270` | $20 (32B)  | PackSaveState block; purpose TBD               |
| `$FF0290` | $18 (24B)  | PackSaveState block; purpose TBD               |
| `$FF02A8–$FF02E7` | 64B | PackSaveState saves 64 bytes from the `$FFB9E8` event_records via stride-2 loop (4 × 16 bytes) |

---

### `$FF02E8–$FF03B7`: Unknown Blocks

| Address   | Size      | Notes                          |
|-----------|-----------|--------------------------------|
| `$FF02E8` | $50 (80B)  | PackSaveState block; TBD      |
| `$FF0338` | $80 (128B) | PackSaveState block; TBD      |

---

### `$FF03B8–$FF03DF`: Char Display Lookup Table ($28 = 40 bytes)

| Address   | Size | Name             | Description                                                               |
|-----------|------|------------------|---------------------------------------------------------------------------|
| `$FF03B8` | 40B  | char_display_tab | Lookup table used by ShowCharData / ShowStatsSummary. Indexed `char_idx * 10 + col * 2`. PackSaveState copies $28 bytes. |

---

### `$FF03E0–$FF05C3`: Unknown Blocks

| Address   | Size      | Notes                         |
|-----------|-----------|-------------------------------|
| `$FF03E0` | $10 (16B)  | PackSaveState block; TBD     |
| `$FF03F0` | $30 (48B)  | PackSaveState block; TBD     |
| `$FF0420` | $C0 (192B) | PackSaveState block; TBD     |
| `$FF04E0` | $E4 (228B) | PackSaveState block; TBD     |

---

### `$FF05C4`: Character Stat Array

| Address   | Size | Name            | Description                                                        |
|-----------|------|-----------------|--------------------------------------------------------------------|
| `$FF05C4` | ?    | char_stat_array | Character stat records. Stride: `$39` (57) bytes per character, confirmed by GetCharStat (`mulu.w #$39,d0`). Field offset within each record is looked up from `char_stat_tab` ($FF1298). Exact total size and end address TBD — apparent overlap with `$FF1298` needs field-layout analysis. |

**Note:** `$FF05C4 + 89 × 57 = $FF1995` appears to overlap with `char_stat_tab`
at `$FF1298`. This needs resolution — either the char count is lower, the
stride is wrong, or the two tables interleave. Leave TBD until more functions
are translated.

---

### `$FF0728–$FF0767`: Unknown Block ($40 = 64 bytes)

PackSaveState: `pea $0040.w; pea $FF0728.l`. Follows char stat data. TBD.

---

### `$FF08EC–$FF08FB`: Entity Bitfield Table ($10 = 16 bytes)

| Address   | Size | Name        | Description                                                           |
|-----------|------|-------------|-----------------------------------------------------------------------|
| `$FF08EC` | 16B  | entity_bits | Longword array indexed `entity * 4`. `FindBitInField` searches for the first set bit within a longword. PackSaveState copies $10 bytes. |

---

### `$FF099C–$FF0A35`: Route / Session Sub-Records

| Address   | Size | Name             | Description                                                |
|-----------|------|------------------|------------------------------------------------------------|
| `$FF099C` | 4B   | session_block_9c | PackSaveState; purpose TBD                                 |
| `$FF09A0` | 1B   | session_byte_a0  | PackSaveState; purpose TBD                                 |
| `$FF09A2` | $20B | session_block_a2 | PackSaveState; purpose TBD                                 |
| `$FF09C2` | 8B   | route_field_a    | CopyRouteFields sub-record A                               |
| `$FF09CA` | 4B   | route_field_b    | CopyRouteFields sub-record B                               |
| `$FF09CE` | 8B   | route_field_c    | CopyRouteFields sub-record C                               |
| `$FF09D6` | 2B   | route_field_d    | CopyRouteFields sub-record D                               |
| `$FF09D8` | $59B | char_session_blk | 89-byte block (1 byte per character?); PackSaveState `pea $0059.w` |
| `$FF0A32` | 2B   | session_word_a32 | PackSaveState; purpose TBD                                 |
| `$FF0A34` | word | ui_active_flag   | PollAction gating: nonzero = UI active; zero = 60-frame delay + return 16. ANDed with `$7FFF` by PostDisplayInit. |

---

### `$FF1000–$FF1003`: win_right_dup

| Address   | Size | Name          | Description                                            |
|-----------|------|---------------|--------------------------------------------------------|
| `$FF1000` | word | win_right_dup | Duplicate of `win_right` ($FFBDA8). Both written by DrawBox/SetTextWindow. |

---

### `$FF128E–$FF13FB`: Display / Stat Type Data

| Address   | Size | Name           | Description                                                               |
|-----------|------|----------------|---------------------------------------------------------------------------|
| `$FF128E` | byte | decomp_ctrl2   | DecompressVDPTiles working control byte (separate from LZ decompressor).  |
| `$FF1290` | word | win_left_dup   | Duplicate of `win_left` ($FFBD68). Written together with win_left.        |
| `$FF1294` | word | stat_scale     | Stat computation scaling factor. Used in GetCharStat: `move.l #$82,d2; sub.l d1,d2` path. |
| `$FF1296` | word | scenario_flag  | UI state flag. Cleared at scenario menu entry (`clr.w ($FF1296).l`).      |
| `$FF1298` | —    | char_stat_tab  | 4-byte descriptor entries, indexed by `char_index * 4` (InitCharRecord) or `stat_type * 4` (GetCharStat). Byte 0 = field offset into the 57-byte char record; bytes 2–3 = type discriminator. 89 entries → $164 (356) bytes, ending ~$FF13FB. |
| `$FF13FC` | word | input_mode_flag | Nonzero = countdown / UI-input mode active (ProcessInputLoop, BrowseCharList). |

---

### `$FF14BC–$FF14FB`: Tile / Resource Buffer ($40 = 64 bytes)

| Address   | Size | Name     | Description                                                                |
|-----------|------|----------|----------------------------------------------------------------------------|
| `$FF14BC` | 64B  | tile_buf | Resource staging buffer. InitTileBuffer loads 64 bytes from ROM `$472CE`. DisplaySetup uses it as a pointer table (`resource_index * 2`). |

---

### `$FF153C–$FF1583`: Flight Slot Data ($48 = 72 bytes)

| Address   | Size | Name         | Description                                                   |
|-----------|------|--------------|---------------------------------------------------------------|
| `$FF153C` | 72B  | flight_slots | Active flight slot data. ClearFlightSlots zeroes $48 bytes. UpdateFlightSlots reads/writes entries. Field layout TBD. |

---

### `$FF1800–$FF1803`: Font / Decompressor Flags

| Address   | Size | Name         | Description                                        |
|-----------|------|--------------|----------------------------------------------------|
| `$FF1800` | word | font_mode    | 0 = narrow font, 1 = wide. Set by SetFontMode.     |
| `$FF1802` | word | lz_init_flag | LZ_Decompress initialization flag.                 |

---

### `$FF1804`: Save State Buffer

| Address   | Size | Name          | Description                                                              |
|-----------|------|---------------|--------------------------------------------------------------------------|
| `$FF1804` | —    | save_buf_base | Save state buffer. A4 = `$FF1804` (header base). A3 starts at `$FF180A` (6 bytes past base = first write position). PackSaveState writes sequentially from `$FF180A` onward. |

---

### `$FF8824–$FF8863`: 32-Entry Stride-2 Table ($40 bytes raw)

| Address   | Size | Name       | Description                                                  |
|-----------|------|------------|--------------------------------------------------------------|
| `$FF8824` | 64B  | tab32_8824 | 32 entries at stride 2 (1 effective byte per slot). PackSaveState reads 32 bytes via stride-2 loop. Purpose TBD. |

---

### `$FF88D6–$FF88DB`: Display State

| Address   | Size | Name          | Description                                                         |
|-----------|------|---------------|---------------------------------------------------------------------|
| `$FF88D6` | word | bat_base_word | BAT/VRAM write address base. Used in `mulu.w ($FFA77E).l,d0; adda.l d0,a2` for tile-row BAT offset computation. |
| `$FF88DA` | —    | decomp_a3     | DecompressVDPTiles A3 working area base (`movea.l #$00FF88DA,a3`). |

---

### `$FF899C`: Screen Graphics Buffer

| Address   | Size   | Name       | Description                                                          |
|-----------|--------|------------|----------------------------------------------------------------------|
| `$FF899C` | $3A4+B | screen_buf | Tile staging buffer. LoadSlotGraphics loads $3A4 bytes here, then DMA transfers to VRAM. |

---

### `$FF9A1C–$FF9A1F`: Screen / Scenario ID

| Address   | Size | Name      | Description                                                        |
|-----------|------|-----------|--------------------------------------------------------------------|
| `$FF9A1C` | word | screen_id | Current screen / scenario index. Set to `$7` by LoadScreenGfx. Drives scene transition dispatch. |

---

### `$FF9A20–$FFCA9F`: Route Slot Array (4 × 40 × $14 = $C80 bytes)

| Address   | Size    | Name        | Description                                                        |
|-----------|---------|-------------|--------------------------------------------------------------------|
| `$FF9A20` | 3,200B  | route_slots | Route slot array. 4 players × 40 slots × `$14` (20) bytes/slot. Player offset: `mulu.w #$0320,d0` (800 bytes/player). PackSaveState saves $C bytes per slot. |

```
$FF9A20   Player 0: slots 0–39  ($500 bytes, ends $FF9F1F)
$FF9F20   Player 1: slots 0–39  ($500 bytes, ends $FFA41F)
$FFA420   Player 2: slots 0–39  ($500 bytes, ends $FFA91F)
$FFA920   Player 3: slots 0–39  ($500 bytes, ends $FFAE1F)
```

---

### `$FF99DE–$FF99DF`: char_width

| Address   | Size | Name       | Description                                   |
|-----------|------|------------|-----------------------------------------------|
| `$FF99DE` | word | char_width | Character advance width. 1 = narrow, 2 = wide. Set by SetFontMode alongside font_mode. |

---

### `$FFA6A0`: Entity Bitfield Array

| Address   | Size | Name         | Description                                                         |
|-----------|------|--------------|---------------------------------------------------------------------|
| `$FFA6A0` | —    | bitfield_tab | Longword bitfield array indexed `entity * 4`. FindBitInField scans for first set bit. FindBitInField also accesses `$FFA6B4` as a sub-region. |

---

### `$FFA77A–$FFA791`: Text Rendering and Input Parameters

| Address   | Size | Name           | Description                                                     |
|-----------|------|----------------|-----------------------------------------------------------------|
| `$FFA77A` | word | cursor_advance | Horizontal cursor advance per character. 1 = narrow, 2 = wide. Set by SetFontMode. |
| `$FFA77C` | word | display_param1 | Display/scroll parameter. Set by GameCommand handler.           |
| `$FFA77E` | word | display_param2 | Tile-row address multiply factor. `mulu.w ($FFA77E).l,d0` computes BAT row byte offset. |
| `$FFA78C` | byte | lz_ctrl_byte   | LZ_Decompress bitstream state. Loaded from stream; `add.b d0,($FFA78C).l` doubles it each iteration. |
| `$FFA790` | word | input_mask     | Joypad button filter. ReadInput ANDs raw button word with this before returning. |

---

### `$FFA7D8–$FFA7E5`: Input / Display Flags and RNG

| Address   | Size | Name            | Description                                                      |
|-----------|------|-----------------|------------------------------------------------------------------|
| `$FFA7D8` | word | input_init_flag | ProcessInputLoop: 1 = countdown started for this UI context.    |
| `$FFA7DC` | word | display_flag    | DisplaySetup / InitTileBuffer init guard. 0 = not loaded, 1 = loaded. |
| `$FFA7E0` | long | rng_state       | LCG RNG seed. Updated by game logic.                            |
| `$FFA7E4` | word | rng_accum       | RNG accumulator word.                                            |

---

### `$FFB9E4–$FFB9E5`: win_top

| Address   | Size | Name    | Description                          |
|-----------|------|---------|--------------------------------------|
| `$FFB9E4` | word | win_top | Top edge of current text/display window. |

---

### `$FFB9E8–$FFBA67`: Event / Flight Records ($80 = 128 bytes)

| Address   | Size  | Name          | Description                                                            |
|-----------|-------|---------------|------------------------------------------------------------------------|
| `$FFB9E8` | 128B  | event_records | 4 records × $20 (32) bytes. PackSaveState saves 1 byte per entry at stride 2, 16 entries per record → 64 bytes effective. Purpose TBD (event state, flight booking data?). |

---

### `$FFBA80–$FFBD47`: City Data Array ($2C8 = 712 bytes)

| Address   | Size  | Name      | Description                                                               |
|-----------|-------|-----------|---------------------------------------------------------------------------|
| `$FFBA80` | 712B  | city_data | 89 cities × 4 entries per city × 2 bytes per entry (stride-2 storage). PackSaveState: outer loop 89 ($59), inner loop 4, saves 1 byte per entry. Total raw range: 89 × 4 × 2 = 712 bytes. |

---

### `$FFBD48–$FFBD69`: Text Window and Decompressor State

| Address   | Size | Name          | Description                                                        |
|-----------|------|---------------|--------------------------------------------------------------------|
| `$FFBD48` | word | win_bottom    | Bottom edge of current text/display window.                        |
| `$FFBD50` | word | decomp_flag   | DecompressVDPTiles working flag. Cleared at tile decompression start. |
| `$FFBD52` | word | menu_sel      | Stored menu selection. Set to `$FFFF` on display-mode clear.      |
| `$FFBD56` | —    | lz_window     | LZ_Decompress bitstream window (`movea.l #$FFBD56,a3` at `$003FF8`). |
| `$FFBD64` | —    | charlist_ptr  | BrowseCharList A2 base (cursor / selection working state).         |
| `$FFBD68` | word | win_left      | Left edge of current text/display window.                          |

---

### `$FFBDA8–$FFBDE9`: win_right and Scroll-Bar State

| Address   | Size | Name            | Description                                                         |
|-----------|------|-----------------|---------------------------------------------------------------------|
| `$FFBDA8` | word | win_right       | Right edge of current text/display window.                          |
| `$FFBDAC` | word | scrollbar_flags | Bit 2 = scrollbar active. Cleared/set by SetScrollBarMode.         |
| `$FFBDDA` | 4+B  | scrollbar_a3    | SetScrollBarMode A3 working area base.                              |
| `$FFBDE2` | 8+B  | scrollbar_a2    | SetScrollBarMode A2 working area (position, limit, offset, count). |

---

### `$FFF000–$FFF00F`: RAM Subroutine

| Address   | Size | Name    | Description                                                               |
|-----------|------|---------|---------------------------------------------------------------------------|
| `$FFF000` | 10B  | ram_sub | Subroutine copied from ROM at boot (`$000362–$00036B`). Reads `$0042(A5)` and `$0044(A5)` (VDP reg staging words) and writes both to VDP data port `(A4)`. Called by SubsysUpdate1. |

---

### `$FFF010–$FFF06F`: Work RAM Base — Boot-Cleared Flags (A5-Relative)

A5 = `$FFF010`. All offsets below are relative to A5.

| Address    | A5 Offset | Size  | Name            | Description                                                  |
|------------|-----------|-------|-----------------|--------------------------------------------------------------|
| `$FFF010`  | `+$0000`  | —     | work_ram_base   | A5 canonical base. 64+ bytes cleared during boot.           |
| `$FFF02C`  | `+$001C`  | byte  | boot_flag_1c    | Cleared at boot; purpose TBD                                 |
| `$FFF03B`  | `+$002B`  | byte  | vint_dispatch   | V-INT dispatch flags. Bit 0 = VInt_Sub1, bit 1 = VInt_Sub2, bit 2 = VInt_Sub3. Cleared after dispatch. |
| `$FFF046`  | `+$0036`  | byte  | vint_processed  | V-INT processed flag. Cleared at end of VBlankInt.           |
| `$FFF052`  | `+$0042`  | word  | vdp_reg_val_a   | VDP register staging word A. Written to VDP by `ram_sub`.    |
| `$FFF054`  | `+$0044`  | word  | vdp_reg_val_b   | VDP register staging word B. Written to VDP by `ram_sub`.    |
| `$FFF05B`  | `+$004B`  | byte  | dma_pending     | DMA pending flag (bit 0). V-INT calls DMA_Transfer and clears. |

---

### `$FFCB36–$FFCC80`: V-INT Subsystem State (A5-Relative)

| Address    | A5 Offset | Size  | Name            | Description                                                   |
|------------|-----------|-------|-----------------|---------------------------------------------------------------|
| `$FFCB3A`  | `+$0B2A`  | byte  | display_update  | Nonzero = call DisplayUpdate from V-INT.                      |
| `$FFCBDE`  | `+$0BCE`  | word  | vsub2_trigger   | VInt_Sub2 trigger. Nonzero = run VInt_Sub2.                   |
| `$FFCBE0`  | `+$0BD0`  | long  | vsub2_callback  | VInt_Sub2 function pointer.                                   |
| `$FFCBE4`  | `+$0BD4`  | byte  | vsub1_enable    | VInt_Sub1 enable (color fade/cycle).                          |
| `$FFCBEC`  | `+$0BDC`  | long  | vsub1_data_ptr  | VInt_Sub1 CRAM/VSRAM data pointer.                            |
| `$FFCBF4`  | `+$0BE4`  | long  | vsub4_data_ptr  | SubsysUpdate4 data pointer.                                   |
| `$FFCBF8`  | `+$0BE8`  | long  | vsub4_callback  | SubsysUpdate4 function pointer.                               |
| `$FFCC56`  | `+$0C46`  | byte  | hscroll_enable  | H-scroll per-line effect enable (bit 0).                      |
| `$FFCC58`  | `+$0C48`  | long  | hscroll_tab_b   | Plane B per-line H-scroll table pointer.                      |
| `$FFCC5C`  | `+$0C4C`  | long  | hscroll_tab_a   | Plane A per-line H-scroll table pointer.                      |
| `$FFCC60`  | `+$0C50`  | word  | hscroll_line_ctr | H-scroll line counter. Incremented by H-INT, reset by V-INT. |
| `$FFCC80`  | `+$0C70`  | word  | unknown_c70     | Cleared at boot; accessed by GameCommand $23. Purpose TBD.   |

---

### `$FFF30B–$FFF314`: Input Enable and Controller Data (A5-Relative)

| Address    | A5 Offset | Size  | Name         | Description                                              |
|------------|-----------|-------|--------------|----------------------------------------------------------|
| `$FFF30B`  | `+$02FB`  | byte  | input_enable | Nonzero = call ControllerRead in V-INT.                  |
| `$FFF30C`  | `+$02FC`  | word  | ctrl_state   | Controller state word (current joypad byte pair).        |
| `$FFF30E`  | `+$02FE`  | byte  | ctrl_cur     | Current controller byte.                                 |
| `$FFF30F`  | `+$02FF`  | byte  | ctrl_prev    | Previous frame controller byte.                          |
| `$FFF310`  | `+$0300`  | word  | ctrl_repeat  | Auto-repeat / direction accumulator.                     |
| `$FFF312`  | `+$0302`  | word  | ctrl_new     | New button presses (edge-detected).                      |
| `$FFF314`  | `+$0304`  | word  | ctrl_held    | Held buttons / repeat data.                              |

---

### `$FFFBFC–$FFFD37`: Controller I/O Area

| Address    | Size | Name      | Description                                                               |
|------------|------|-----------|---------------------------------------------------------------------------|
| `$FFFBFC`  | —    | ctrl_io   | ControllerPoll A1 base. Decoded joypad data written here.                 |
| `$FFFD16`  | 32B  | ctrl_raw1 | Raw controller data buffer 1 (ControllerRead output).                     |
| `$FFFD36`  | 2+B  | ctrl_raw2 | Raw controller data buffer 2 start.                                       |

---

## Notes

1. **Overlapping addresses ($FF05C4 and $FF1298):** `char_stat_array` at $FF05C4
   with stride $39 and 89 chars would end at $FF1995, which overlaps `char_stat_tab`
   at $FF1298. Likely resolution: either the char count is smaller, the stat_tab
   IS embedded within the char array region, or GetCharStat's `mulu #$39` is used
   on a different index than char count. Needs field-level analysis before resolving.

2. **Duplicate window variables:** `win_left`/`win_left_dup` and `win_right`/`win_right_dup`
   are written together by DrawBox and SetTextWindow. The lower-address duplicates
   ($FF1290, $FF1000) may serve a different display subsystem or may be legacy.

3. **A5-relative vs direct addressing:** Interrupt-context state (V-INT, DMA,
   controller, H-scroll) is always accessed via `A5 + offset`. Game-state
   structures ($FF0000–$FFA7FF) use direct absolute addresses.

4. **PackSaveState sequential layout:** The save buffer begins at `$FF180A`
   (A3 = A4+6, A4 = `$FF1804`). Source regions are copied in ascending address
   order. The copy helper at `$1D538` takes: count, dest, flags ($00200003), src,
   null — 5 longwords = $14 bytes on stack. Total save record size ~$C30 bytes.

5. **Unknown blocks ($FF0130–$FF04DF):** Large unanalyzed regions saved by
   PackSaveState. Likely contain: AI player state, economic simulation data,
   quarter/year accounting, schedule tables, city relationship matrices.
