# DATA_TABLES.md -- ROM Data Table Reference

**Last Updated**: February 2026 (B-059)

This document catalogs all identified game data tables in the Aerobiz Supersonic ROM.
Each entry gives the address, format, field layout, accessor functions, and example entries.

---

## Table of Contents

- [String Tables (section_040000)](#string-tables-section_040000)
- [Pointer Tables (section_040000)](#pointer-tables-section_040000)
- [Game State Tables (section_040000)](#game-state-tables-section_040000)
- [Graphics Data (section_040000)](#graphics-data-section_040000)
- [Character Data Tables (section_050000)](#character-data-tables-section_050000)
- [Compatibility Score Tables (section_050000)](#compatibility-score-tables-section_050000)
- [City and Route Tables (section_050000)](#city-and-route-tables-section_050000)
- [Region and Aircraft Tables (section_050000)](#region-and-aircraft-tables-section_050000)

---

## String Tables (section_040000)

### GameStatusText -- $040000
| Field | Value |
|-------|-------|
| Label | `GameStatusText` |
| Address | $040000 |
| End | ~$04554E |
| Size | ~21,839 bytes |
| Format | ASCII strings, null-terminated, `$FF`-separated groups |
| Section | section_040000.asm |

In-game status and event message strings. Covers status updates, quarterly report text,
event descriptions, and scenario text. Accessed via pointer tables below.

**Accessor functions:** `StatusMsgPtrs` ($0482D8), `EventNamePtrs` ($047D7C), `ScenarioDescPtrs` ($047630)

**Example entries (at $040000):**
- Strings begin immediately at $040000 with game status messages
- Groups terminated by `$FF` byte; individual strings null-terminated

---

### NameStringPool -- $045550
| Field | Value |
|-------|-------|
| Label | `NameStringPool` |
| Address | $045550 |
| End | ~$0455DD |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Pool of short name strings (business types, titles). Accessed by `NameStringPoolPtrs` ($05E296).

---

### BusinessCategories -- $0455DE
| Field | Value |
|-------|-------|
| Label | `BusinessCategories` |
| Address | $0455DE |
| End | ~$045657 |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Business category names for in-game UI.

---

### VenueNames -- $045658
| Field | Value |
|-------|-------|
| Label | `VenueNames` |
| Address | $045658 |
| End | ~$045763 |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Airport/venue name strings.

---

### CityNames -- $045764
| Field | Value |
|-------|-------|
| Label | `CityNames` |
| Address | $045764 |
| End | ~$045D59 |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

City name strings used for route display and city selection UI.
Pointed to by entries in `CityNamePtrs` ($05E680).

**Example entries:**
- $045764: "NEW YORK" (or similar, first city entry)

---

### AirlineNames -- $045D5A
| Field | Value |
|-------|-------|
| Label | `AirlineNames` |
| Address | $045D5A |
| End | ~$045F25 |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Airline name strings. Pointed to by high-index entries in `CityNamePtrs` ($05E680)
and the `CharTypePtrs` sub-region ($05E7E4).

---

### CountryNames -- $045F26
| Field | Value |
|-------|-------|
| Label | `CountryNames` |
| Address | $045F26 |
| End | ~$0460FF |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Country name strings. Pointed to by mid-range entries in `CityNamePtrs`.
Also includes region names accessed via `RegionNamePtrs` ($05EC84) at offsets $04606x-$04608x.

**Region name subrange:** $046038-$046087 (14 region names, 1 per entry in `RegionNamePtrs`)

---

### AircraftModels -- $046100
| Field | Value |
|-------|-------|
| Label | `AircraftModels` |
| Address | $046100 |
| End | ~$0462D5 |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Aircraft model name strings. Pointed to by entries in `AircraftModelPtrs` ($05ECFC)
and `AircraftTypePtrs` ($05E2DE).

**Example entries (at $046100):**
- Strings for aircraft model names (B747, DC10, etc.)

---

### MonthNames -- $0462D6
| Field | Value |
|-------|-------|
| Label | `MonthNames` |
| Address | $0462D6 |
| End | ~$046xxx |
| Format | ASCII strings, null-terminated |
| Section | section_040000.asm |

Month name strings for quarterly/date display.

---

## Pointer Tables (section_040000)

### ScenarioStrPtrs -- $0475DC
| Field | Value |
|-------|-------|
| Label | `ScenarioStrPtrs` |
| Address | $0475DC |
| Format | Longword ptrs × N entries |
| Points to | GameStatusText ($040000) region |
| Section | section_040000.asm |

---

### ScenarioDescPtrs -- $047630
| Field | Value |
|-------|-------|
| Label | `ScenarioDescPtrs` |
| Address | $047630 |
| Format | Longword ptrs × N entries |
| Points to | GameStatusText ($040000) region |
| Section | section_040000.asm |

---

### DialoguePtrs -- $04777C
| Field | Value |
|-------|-------|
| Label | `DialoguePtrs` |
| Address | $04777C |
| Format | Longword ptrs × N entries |
| Points to | section_030000 ($03Exxx) dialogue text |
| Section | section_040000.asm |

Note: Points to section_030000, NOT GameStatusText.

---

### SfxNamePtrs -- $047A70
| Field | Value |
|-------|-------|
| Label | `SfxNamePtrs` |
| Address | $047A70 |
| Format | Longword ptrs × N entries |
| Points to | Sound effect name strings |
| Section | section_040000.asm |

---

### AdvisorTextPtrs -- $047B0C
| Field | Value |
|-------|-------|
| Label | `AdvisorTextPtrs` |
| Address | $047B0C |
| Format | Longword ptrs × N entries |
| Points to | section_030000 ($03Fxxx) advisor text |
| Section | section_040000.asm |

Note: Points to section_030000, NOT GameStatusText.

---

### EventNamePtrs -- $047D7C
| Field | Value |
|-------|-------|
| Label | `EventNamePtrs` |
| Address | $047D7C |
| Format | Longword ptrs × N entries |
| Points to | GameStatusText ($040000) region |
| Section | section_040000.asm |

---

### StatusMsgPtrs -- $0482D8
| Field | Value |
|-------|-------|
| Label | `StatusMsgPtrs` |
| Address | $0482D8 |
| Format | Longword ptrs × N entries |
| Points to | GameStatusText ($040000) region |
| Section | section_040000.asm |

---

### ScenarioTextPtrs -- $048DB0
| Field | Value |
|-------|-------|
| Label | `ScenarioTextPtrs` |
| Address | $048DB0 |
| End | $048DFF |
| Size | 20 entries × 4 bytes = 80 bytes |
| Format | 20 longword pointers |
| Points to | GameStatusText ($040000) and NameStringPool ($045550) regions |
| Section | section_040000.asm |

Scenario/event text block pointers used by `RenderTextBlock`. Special page-break
markers at indices 6, 13, 19.

---

## Game State Tables (section_040000)

### CityRouteConnections -- $048660
| Field | Value |
|-------|-------|
| Label | `CityRouteConnections` |
| Address | $048660 |
| End | ~$04885F |
| Size | ~512 bytes |
| Format | Variable-length word entries: city_idx + neighbor slots, $00FF = none |
| Section | section_040000.asm |

City route adjacency table with ~52 variable-length entries. Each entry lists
the city index followed by its available route connection slots, terminated by $00FF.

**Accessor:** Route computation functions; `RouteCodeMap` ($05EC10) is the byte complement.

---

### CharBaseStats -- $048860
| Field | Value |
|-------|-------|
| Label | `CharBaseStats` |
| Address | $048860 |
| End | ~$04895F |
| Size | ~32 entries × 4 words = 256 bytes |
| Format | 4 words per entry: stat[0], stat[1], stat[2], stat[3] |
| Fields | Each stat: 0-8 range value |
| Section | section_040000.asm |

Character base stat values for the 8-point attribute scale. One entry per
character type (up to ~32 types).

**Example entry (first 4 words at $048860):**
```
word[0] = stat0   (e.g., aggressiveness)
word[1] = stat1   (e.g., business acumen)
word[2] = stat2   (e.g., risk tolerance)
word[3] = stat3   (e.g., loyalty)
```

---

## Graphics Data (section_040000)

### CharSpriteTiles -- $048970
| Field | Value |
|-------|-------|
| Label | `CharSpriteTiles` |
| Address | $048970 |
| End | ~$048D17 |
| Size | ~32 tiles × 32 bytes = ~1,024 bytes |
| Format | 4-bit packed pixel tiles (8x8 pixels, 32 bytes each) |
| Section | section_040000.asm |

Character portrait sprite tile graphics in Genesis VDP format. Loaded to VRAM
for character display sequences.

---

### CharPortraitTileSeqs -- $048D30
| Field | Value |
|-------|-------|
| Label | `CharPortraitTileSeqs` |
| Address | $048D30 |
| End | ~$048DAF |
| Size | ~5 sequences × 16 bytes |
| Format | 4-bit packed pixel tile sequences, palette 0x0E |
| Section | section_040000.asm |

Character portrait tile sequence fill graphics. Preceded by `GraphicSequencePtrs`
(5 code function pointers at $048D18-$048D2B).

---

### DigitFontTiles -- $048E00
| Field | Value |
|-------|-------|
| Label | `DigitFontTiles` |
| Address | $048E00 |
| End | $048F5F |
| Size | 10 tiles × 32 bytes = 320 bytes |
| Format | 4-bit packed pixel tiles (8x8 pixels, 32 bytes each) |
| Section | section_040000.asm |

Digit font tiles 0-9 in Genesis VDP format. Used for number rendering in
score displays and financial figures.

---

### FontPaletteData -- $048F60
| Field | Value |
|-------|-------|
| Label | `FontPaletteData` |
| Address | $048F60 |
| End | $048F7F |
| Size | 16 words = 32 bytes |
| Format | 16 palette color words + character metric entries |
| Section | section_040000.asm |

Font rendering palette colors and character metric lookup table.

---

### FontTilemapTable -- $048F80
| Field | Value |
|-------|-------|
| Label | `FontTilemapTable` |
| Address | $048F80 |
| End | $0490A3 |
| Size | ~4 rows × 76 entries × 2 bytes = ~608 bytes |
| Format | BAT word entries: `$63xx` (palette 3, tile# xx) |
| Section | section_040000.asm |

Background Attribute Table character encoding table. Maps ASCII character
codes to VRAM tile indices using palette 3 (prefix $63xx).

**BAT entry format:** `%PCCVHNNNNNNNNNNN`
- P=0 (priority), CC=11 (palette 3), V=0, H=0, NNNNNNNNNNN=tile#

**Example:** `$6302` = palette 3, tile $102

---

### SpriteTileGraphics -- $0490A4
| Field | Value |
|-------|-------|
| Label | SpriteTileGraphics (comment only, starts mid-line) |
| Address | $0490A4 |
| End | $04FFFF |
| Size | ~32,604 bytes |
| Format | 4-bit packed pixel tiles (8x8 pixels, 32 bytes each) |
| Section | section_040000.asm |

Large bank of sprite tile graphics for aircraft, UI elements, and icons.
Fills the remainder of section_040000.

---

## Character Data Tables (section_050000)

### CharPlacementData -- $05E234
| Field | Value |
|-------|-------|
| Address | $05E234 (mid-line; word[2] of $05E230 dc.w line) |
| End | $05E295 |
| Size | 7 entries × 14 bytes = 98 bytes |
| Format | 14-byte structs |
| Section | section_050000.asm |

Character portrait animation placement data. Each 14-byte struct contains
sprite coordinate offsets and displacement values for portrait animation.

**Field layout (per 14-byte entry):**
```
bytes 0-3:  sprite_base_offset (4 bytes)
bytes 4-5:  x_displacement (word, signed)
bytes 6-7:  y_displacement (word, signed)
bytes 8-13: additional animation coord data
```

**Access pattern:** `mulu.w #$e, d0` then indexed from base address.

---

### NameStringPoolPtrs -- $05E296
| Field | Value |
|-------|-------|
| Address | $05E296 (mid-line; word[3] of $05E290 dc.w line) |
| End | $05E2DD |
| Size | 18 entries × 4 bytes = 72 bytes |
| Format | 18 longword pointers |
| Points to | NameStringPool ($045550) and related $04xxxx strings |
| Section | section_050000.asm |

Pointer table into the name string pool. Entries are `$0004,XXXX` longword pairs
pointing to ASCII strings in the $04xxxx range.

---

### AircraftTypePtrs -- $05E2DE
| Field | Value |
|-------|-------|
| Address | $05E2DE (mid-line; word[7] of $05E2D0 dc.w line) |
| End | $05E319 |
| Size | ~14 entries × 4 bytes = ~56 bytes |
| Format | Longword pointers |
| Points to | AircraftModels ($046100) strings |
| Section | section_050000.asm |

Pointer table to aircraft model name strings. Entries point into the
AircraftModels string pool at $046100.

---

### CharWeightTable -- $05E31A
| Field | Value |
|-------|-------|
| Address | $05E31A (mid-line; word[5] of $05E310 dc.w line) |
| End | $05E355 |
| Size | ~60 bytes |
| Format | Byte-pair weight factors |
| Section | section_050000.asm |

Character weight/influence factor table. Byte-pair entries used in
compatibility and stat calculation routines.

**Entry format:** `[weight_factor_A, weight_factor_B]` pairs

**Example entries (starting at $05E31A):**
```
$01,$01,$0F,$00  -- first entries
$02,$01,$1E,$00
...
```

---

### CharRangeScoreTable -- $05E356
| Field | Value |
|-------|-------|
| Address | $05E356 (mid-line; word[3] of $05E350 dc.w line) |
| End | $05E545 |
| Size | 240 bytes (0xF0) |
| Format | Byte lookup table indexed by range |
| Section | section_050000.asm |

Range-to-score mapping table. 240-byte lookup indexed by character code or
attribute range. Used in character stat and compatibility calculations.

**Access pattern:** `RangeLookup` iterates `CharTypeRangeTable` ($05ECBC) to find
threshold, then uses category result as index into score tables.

---

### CharPortraitPos -- $05E948
| Field | Value |
|-------|-------|
| Address | $05E948 (mid-line; word[4] of $05E940 dc.w line) |
| End | $05E9F9 |
| Size | ~89 entries × 4 bytes = ~178 words |
| Format | Word pairs: x_screen, y_screen |
| Section | section_050000.asm |

Character portrait screen position table. Each entry is a (x,y) coordinate
pair used to position character portrait tiles on screen.

**Access pattern:** Indexed by char_code * 4; passed to `TilePlacement` function.

**Example entries (at $05E948):**
```
$2130,$2336  -- char 0: x=$2130, y=$2336
$2A35,$2733  -- char 1: x=$2A35, y=$2733
$2E40,$2D32  -- char 2: ...
```

---

### CharRangeScoreMap -- $05E9FA
| Field | Value |
|-------|-------|
| Address | $05E9FA (mid-line; word[5] of $05E9F0 dc.w line) |
| End | $05EAAB |
| Size | ~178 bytes |
| Format | 2D word table indexed by char_code × 2 |
| Section | section_050000.asm |

Two-dimensional word lookup table mapping character code pairs to compatibility
scores. Indexed via char_code * 2 offset.

---

### CharBioPtrs -- $05EAAC
| Field | Value |
|-------|-------|
| Address | $05EAAC (mid-line; word[6] of $05EAA0 dc.w line) |
| End | $05EB2B |
| Size | ~32 entries × 4 bytes = 128 bytes |
| Format | Longword pointers |
| Points to | $045Exx CountryNames/bio string region |
| Section | section_050000.asm |

Character biography/name string pointer table. Indexed by char_code.

**Access pattern:** `lsl.w #2, d0` then `move.l (CharBioPtrs,d0.w), a0`

**Example entry (at $05EAAC):**
```
$0004,$5E44  -- ptr to $0004_5E44 (bio string for char 0)
$0004,$5E3C  -- ptr to $0004_5E3C (bio string for char 1)
...
```

---

### CharBaseStats (also in section_040000 at $048860 -- see above)

---

## Compatibility Score Tables (section_050000)

These 7 tables form the `CharCodeCompare` dispatch system. Each table stores
byte-pair compatibility scores for character combination lookups. The function
at `CharCodeCompare` ($006F42) dispatches to the appropriate table via a jump
table indexed by category (0-6).

### CharCompat_Cat0 -- $05E546
| Field | Value |
|-------|-------|
| Address | $05E546 (mid-line; word[3] of $05E540 dc.w line) |
| End | $05E5BD |
| Size | 120 bytes |
| Format | Byte pairs [score_A, score_B]; $FF terminator |
| Mask | $11 |
| Section | section_050000.asm |

---

### CharCompat_Cat1 -- $05E5BE
| Field | Value |
|-------|-------|
| Address | $05E5BE (mid-line; word[7] of $05E5B0 dc.w line) |
| End | $05E5C7 |
| Size | 10 bytes |
| Format | Byte pairs; $FF terminator |
| Mask | $05 |
| Section | section_050000.asm |

---

### CharCompat_Cat2 -- $05E5C8
| Field | Value |
|-------|-------|
| Address | $05E5C8 (mid-line; word[4] of $05E5C0 dc.w line) |
| End | $05E5D7 |
| Size | 16 bytes |
| Format | Byte pairs; $FF terminator |
| Mask | $05 |
| Section | section_050000.asm |

---

### CharCompat_Cat3 -- $05E5D8
| Field | Value |
|-------|-------|
| Address | $05E5D8 (mid-line; word[4] of $05E5D0 dc.w line) |
| End | $05E61D |
| Size | 70 bytes |
| Format | Byte pairs; $FF terminator |
| Mask | $0A |
| Section | section_050000.asm |

---

### CharCompat_Cat4 -- $05E61E
| Field | Value |
|-------|-------|
| Address | $05E61E (mid-line; word[7] of $05E610 dc.w line) |
| End | $05E62F |
| Size | 18 bytes |
| Format | Byte pairs; $FF terminator |
| Mask | $06 |
| Section | section_050000.asm |

---

### CharCompat_Cat5 -- $05E630
| Field | Value |
|-------|-------|
| Label | `CharCompat_Cat5` |
| Address | $05E630 (line-aligned) |
| End | $05E66F |
| Size | 64 bytes |
| Format | Byte pairs [score_A, score_B]; $FF terminator |
| Mask | $09 |
| Section | section_050000.asm |

**Example entries (first 8 bytes at $05E630):**
```
$27,$26,$18,$20,$02,$14,$0F,$06  -- 4 score-pairs for chars 0-3
```

---

### CharCompat_Cat6 -- $05E670
| Field | Value |
|-------|-------|
| Label | `CharCompat_Cat6` |
| Address | $05E670 (line-aligned) |
| End | $05E67F |
| Size | 16 bytes |
| Format | Byte pairs; $FF terminator at $05E67F |
| Section | section_050000.asm |

**Example entries (at $05E670):**
```
$4D,$17,$26,$4A,$42,$04,$39,$26,$11,$1A,$43,$08,$22,$45,$40,$FF
```

---

## City and Route Tables (section_050000)

### CityNamePtrs -- $05E680
| Field | Value |
|-------|-------|
| Label | `CityNamePtrs` |
| Address | $05E680 (line-aligned) |
| End | $05E947 |
| Size | ~178 entries × 4 bytes = ~712 bytes |
| Format | Longword pointers (word-pairs `$0004,XXXX`) |
| Points to | CityNames ($045764), CountryNames ($045F26), AirlineNames ($045D5A) |
| Section | section_050000.asm |

Master city/country/airline name pointer table. Indexed by city_index to retrieve
the display name string for UI rendering.

**Access pattern:** `lsl.w #2, d0` then `move.l (CityNamePtrs,d0.w), a0`

Used 68+ times in game code for city name lookup by index.

**Sub-region CharTypePtrs ($05E7E4):** Word[2] of $05E7E0 line. Secondary
char-type name ptrs pointing to AirlineNames ($045Dxx) region. Located within
the CityNamePtrs block; accessed by secondary character attribute.

**Example entries (at $05E680):**
```
$0004,$5A68  -- city 0: ptr to $0004_5A68
$0004,$5A62  -- city 1: ptr to $0004_5A62
$0004,$5A58  -- city 2: ptr to $0004_5A58
...
$0004,$5764  -- city N: ptr to $0004_5764 (CityNames base)
```

---

### CharPortraitPos (see Character Data section above)

### CharRangeScoreMap (see Character Data section above)

### CharBioPtrs (see Character Data section above)

### CountryRoutePtrs -- $05EB2C
| Field | Value |
|-------|-------|
| Address | $05EB2C (mid-line; word[6] of $05EB20 dc.w line) |
| End | $05EC0F |
| Size | ~56 entries × 4 bytes = 224 bytes |
| Format | Longword pointers |
| Points to | $04603x-$04608x region/country name strings |
| Section | section_050000.asm |

Country/route type string pointer table. Indexed by character's route type byte.
Used by `InitializeRouteDisplay` to select the appropriate route display string.

**Example entry (at $05EB2C):**
```
$0004,$6036  -- route type 0: ptr to $0004_6036
$0004,$602E  -- route type 1: ptr to $0004_602E
...
```

---

### RouteCodeMap -- $05EC10
| Field | Value |
|-------|-------|
| Label | `RouteCodeMap` |
| Address | $05EC10 (line-aligned) |
| End | $05EC83 |
| Size | 116 bytes |
| Format | Variable-length byte rows; `$FF` terminates each row |
| Section | section_050000.asm |

City route adjacency byte matrix. Each row represents a route origin; contains
byte-sized city indices of reachable destinations terminated by `$FF`.

This is the compact byte complement to `CityRouteConnections` ($048660).

**Example rows (at $05EC10):**
```
$01,$00  -- row 0: connects to city 1 (FF implicit)
$01,$00  -- row 1
$03,$01,$01  -- row 2: connects to cities 3,1
...
$04,$FF  -- terminal row ($35,$00 follows = route data boundary)
```

---

## Region and Aircraft Tables (section_050000)

### RegionNamePtrs -- $05EC84
| Field | Value |
|-------|-------|
| Address | $05EC84 (mid-line; word[2] of $05EC80 dc.w line) |
| End | $05ECBB |
| Size | 14 entries × 4 bytes = 56 bytes |
| Format | 14 longword pointers |
| Points to | $04606x-$04608x region name strings in CountryNames pool |
| Section | section_050000.asm |

Region name string pointer table with exactly 14 entries (one per game region).

**Access pattern:** Used by `SubmitTurnResults` ($00FB74) to display current player region.

**Example entries (at $05EC84):**
```
$0004,$6086  -- region 0: ptr to $0004_6086
$0004,$607E  -- region 1: ptr to $0004_607E
$0004,$606E  -- region 2: ptr to $0004_606E
...
$0004,$60C8  -- region 7: ptr to $0004_60C8
```

---

### CharTypeRangeTable -- $05ECBC
| Field | Value |
|-------|-------|
| Address | $05ECBC (mid-line; word[6] of $05ECB0 dc.w line) |
| End | $05ECDB |
| Size | 7 entries × 4 bytes = 28 bytes |
| Format | 4-byte structs: `[range1_base, range1_size, range2_base, range2_size]` |
| Section | section_050000.asm |

Character type range boundary descriptor table. 7 entries covering char categories 0-6.
Each entry defines two code ranges for the category.

**Field layout (per 4-byte entry):**
```
byte[0]: range1_base   -- starting code value for range 1
byte[1]: range1_size   -- number of codes in range 1
byte[2]: range2_base   -- starting code value for range 2
byte[3]: range2_size   -- number of codes in range 2
```

**Used by:**
- `RangeLookup` ($00D648): Iterates table to find threshold match; returns category 0-7
- `BitFieldSearch` ($006EEA): Uses byte[0]=start_bit, byte[1]=bit_count for bitfield operations

**Example entries (at $05ECBC):**
```
$0007,$20,$11  -- category 0: range1_base=7, range1_size=32, range2_base=17
$07,$02,$31,$05  -- category 1: range1(7,2), range2(49,5)
$09,$03,$36,$05  -- category 2
$0C,$07,$3B,$0A  -- category 3
$13,$03,$45,$06  -- category 4
$16,$07,$4B,$09  -- category 5
$1D,$03,$54,$05  -- category 6
```

---

### RegionBitmaskTable -- $05ECDC
| Field | Value |
|-------|-------|
| Address | $05ECDC (mid-line; word[6] of $05ECD0 dc.w line) |
| End | $05ECF7 |
| Size | 7 entries × 4 bytes = 28 bytes |
| Format | 7 longword bitmasks (one per region category) |
| Section | section_050000.asm |

Region bitmask table. Each 32-bit entry is a bitmask for the corresponding
region category. Used in bitwise region-membership tests.

**Access pattern:** `and.l (a0,d0.w), d4` where d0 = region_index * 4 (or unscaled if word-addressed)

**Entries (at $05ECDC):**
```
$00000000  -- region 0 bitmask
$00000180  -- region 1 bitmask
$00000E00  -- region 2 bitmask
$0007F000  -- region 3 bitmask
$00380000  -- region 4 bitmask
$1FC00000  -- region 5 bitmask
$E0000000  -- region 6 bitmask
```

---

### RegionAircraftIndex -- $05ECF8
| Field | Value |
|-------|-------|
| Address | $05ECF8 (mid-line; word[4] of $05ECF0 dc.w line) |
| End | $05ECFB |
| Size | 4 bytes |
| Format | 4 bytes: region_index → aircraft_category_offset |
| Section | section_050000.asm |

Compact byte table mapping region index to aircraft category offset.
Used by `SortAircraftByMetric` before indexing `AircraftStatsByRegion`.

**Entries (at $05ECF8):**
```
$00,$0C,$1A,$25  -- 4 bytes: region 0→$00, region 1→$0C, region 2→$1A, region 3→$25
```

---

### AircraftModelPtrs -- $05ECFC
| Field | Value |
|-------|-------|
| Address | $05ECFC (mid-line; word[6] of $05ECF0 dc.w line) |
| End | $05EDCF |
| Size | ~53 entries × 4 bytes = 212 bytes |
| Format | Longword pointers |
| Points to | AircraftModels ($046100) - $0462xx aircraft model name strings |
| Section | section_050000.asm |

Aircraft model name pointer table. Indexed by aircraft model ID.

**Example entries (at $05ECFC):**
```
$0004,$6254  -- model 0: ptr to $0004_6254
$0004,$624A  -- model 1: ptr to $0004_624A
$0004,$6246  -- model 2: ptr to $0004_6246
...
```

---

### AircraftStatsByRegion -- $05EDD0
| Field | Value |
|-------|-------|
| Label | `AircraftStatsByRegion` |
| Address | $05EDD0 (line-aligned) |
| End | ~$05F04B |
| Size | 16 entries × 12 bytes per category = 192 bytes per category |
| Format | 12-byte structs |
| Section | section_050000.asm |

Aircraft performance stats organized by region category. `RegionAircraftIndex`
($05ECF8) maps region → category offset; then each entry is accessed via `mulu.w #$c, d0`.

**Field layout (per 12-byte entry):**
```
word[0]:  range_stat          -- aircraft range capability
word[1]:  performance_stat_1  -- speed or capacity metric
word[2]:  performance_stat_2
word[3]:  performance_stat_3
word[4]:  performance_stat_4
word[5]:  model_index         -- aircraft model ID (index into AircraftModelPtrs)
```

**Access pattern in `SortAircraftByMetric` ($00C540):**
1. Load region_index → `move.b (RegionAircraftIndex,d1.w), d0`
2. Scale: `mulu.w #$c, d0` (12 bytes per entry)
3. Load: `lea AircraftStatsByRegion, a0` then `move.w (a0,d0.w), d2`
4. Compare word[0] and word[5] for sorting metric

**Example entries (at $05EDD0):**
```
$0903,$0BB8,$03E8,$363C,$060C,$0000  -- entry 0: range=$0903, ...
$0607,$0A8C,$07D0,$35C8,$080E,$0400  -- entry 1
...
```

---

## Summary Table

| Address | Label | Size | Format | Section |
|---------|-------|------|--------|---------|
| $040000 | GameStatusText | ~21,839 B | ASCII strings | 040000 |
| $045550 | NameStringPool | ~142 B | ASCII strings | 040000 |
| $0455DE | BusinessCategories | ~122 B | ASCII strings | 040000 |
| $045658 | VenueNames | ~268 B | ASCII strings | 040000 |
| $045764 | CityNames | ~1,526 B | ASCII strings | 040000 |
| $045D5A | AirlineNames | ~460 B | ASCII strings | 040000 |
| $045F26 | CountryNames | ~474 B | ASCII strings | 040000 |
| $046100 | AircraftModels | ~470 B | ASCII strings | 040000 |
| $0462D6 | MonthNames | ~24 B | ASCII strings | 040000 |
| $0475DC | ScenarioStrPtrs | N×4 B | Longword ptrs | 040000 |
| $047630 | ScenarioDescPtrs | N×4 B | Longword ptrs | 040000 |
| $04777C | DialoguePtrs | N×4 B | Longword ptrs | 040000 |
| $047A70 | SfxNamePtrs | N×4 B | Longword ptrs | 040000 |
| $047B0C | AdvisorTextPtrs | N×4 B | Longword ptrs | 040000 |
| $047D7C | EventNamePtrs | N×4 B | Longword ptrs | 040000 |
| $0482D8 | StatusMsgPtrs | N×4 B | Longword ptrs | 040000 |
| $048660 | CityRouteConnections | ~512 B | Var-len word entries | 040000 |
| $048860 | CharBaseStats | ~256 B | 32×4 words | 040000 |
| $048970 | CharSpriteTiles | ~1,024 B | 4-bit tiles | 040000 |
| $048D30 | CharPortraitTileSeqs | ~128 B | 4-bit tiles | 040000 |
| $048DB0 | ScenarioTextPtrs | 80 B | 20 longword ptrs | 040000 |
| $048E00 | DigitFontTiles | 320 B | 4-bit tiles | 040000 |
| $048F60 | FontPaletteData | 32 B | 16 palette words | 040000 |
| $048F80 | FontTilemapTable | ~608 B | BAT word entries | 040000 |
| $0490A4 | SpriteTileGraphics | ~32,604 B | 4-bit tiles | 040000 |
| $05E234 | CharPlacementData | 98 B | 7×14 byte structs | 050000 |
| $05E296 | NameStringPoolPtrs | 72 B | 18 longword ptrs | 050000 |
| $05E2DE | AircraftTypePtrs | ~56 B | Longword ptrs | 050000 |
| $05E31A | CharWeightTable | ~60 B | Byte pairs | 050000 |
| $05E356 | CharRangeScoreTable | 240 B | Byte lookup | 050000 |
| $05E546 | CharCompat_Cat0 | 120 B | Byte pairs | 050000 |
| $05E5BE | CharCompat_Cat1 | 10 B | Byte pairs | 050000 |
| $05E5C8 | CharCompat_Cat2 | 16 B | Byte pairs | 050000 |
| $05E5D8 | CharCompat_Cat3 | 70 B | Byte pairs | 050000 |
| $05E61E | CharCompat_Cat4 | 18 B | Byte pairs | 050000 |
| $05E630 | CharCompat_Cat5 | 64 B | Byte pairs | 050000 |
| $05E670 | CharCompat_Cat6 | 16 B | Byte pairs | 050000 |
| $05E680 | CityNamePtrs | ~712 B | ~178 longword ptrs | 050000 |
| $05E7E4 | (CharTypePtrs) | ~100 B | Longword ptrs (within CityNamePtrs) | 050000 |
| $05E948 | CharPortraitPos | ~178 W | Word pairs x,y | 050000 |
| $05E9FA | CharRangeScoreMap | ~178 B | 2D word table | 050000 |
| $05EAAC | CharBioPtrs | ~128 B | ~32 longword ptrs | 050000 |
| $05EB2C | CountryRoutePtrs | ~224 B | ~56 longword ptrs | 050000 |
| $05EC10 | RouteCodeMap | 116 B | Var-len byte rows | 050000 |
| $05EC84 | RegionNamePtrs | 56 B | 14 longword ptrs | 050000 |
| $05ECBC | CharTypeRangeTable | 28 B | 7×4 byte structs | 050000 |
| $05ECDC | RegionBitmaskTable | 28 B | 7 longwords | 050000 |
| $05ECF8 | RegionAircraftIndex | 4 B | 4 bytes | 050000 |
| $05ECFC | AircraftModelPtrs | ~212 B | ~53 longword ptrs | 050000 |
| $05EDD0 | AircraftStatsByRegion | ~192 B/cat | 16×12 byte structs | 050000 |
