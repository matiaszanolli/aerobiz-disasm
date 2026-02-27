; ============================================================================
; FormatRelationDisplay -- Draws the relation detail panel for a character pair: loads portrait sprite, draws compatibility gauge, prints both names and score, and displays relation icon tiles
; Called: ?? times.
; 1052 bytes | $019244-$01965F
; ============================================================================
FormatRelationDisplay:                                                  ; $019244
; --- Phase: Prologue / Argument Setup ---
; Link frame: $10 bytes of local storage for tile index array (8 words = 16 bytes)
    link    a6,#-$10
; Save caller registers: d2-d5 (loop counters, args) and a2-a5 (pointers)
    movem.l d2-d5/a2-a5,-(sp)
; d2 = display_flag argument: 1 = draw portrait and name tiles, 0 = skip them
    move.l  $0018(a6),d2
; d3 = relation_index: which "column" of the city_data / relation table to read (partner index)
    move.l  $000c(a6),d3
; d4 = tile column (X position in tile coordinates for this panel)
    move.l  $0014(a6),d4
; a2 = pointer to char pair record: byte (a2) = char_a index, byte $1(a2) = char_b index
    movea.l $0008(a6),a2
; a3 = save_buf_base ($FF1804) -- used as LZ decompress output buffer throughout
    movea.l #$00ff1804,a3
; a4 = SetTextCursor ($03AB2C) -- called frequently to position text before printing
    movea.l #$0003ab2c,a4
; a5 = city_data ($FFBA80) -- 89 cities × 4 entries × 2 bytes; indexed by char_code * 8 + relation * 2
    movea.l #$00ffba80,a5
; d5 = 1 = base tile row for this panel (Y position in tile coordinates)
    moveq   #$1,d5
; --- Phase: Clear Panel Background ---
; GameCommand #$1A: clear a rectangular tile area to prepare the relation panel background
; Args: priority=$8000, width=$0D (13 tiles), height=$1E (30 tiles), col=d4, row=d5, tile=1, palette=$1A
; This erases any old content before redrawing
    move.l  #$8000,-(sp)
; Height = $1E = 30 rows, width = $0D = 13 columns
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
; GameCommand ($000D64) #$1A = ClearTileArea
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
; If display_flag (d2) != 1, skip portrait and name rendering -- go straight to gauge/stats
    cmpi.w  #$1,d2
    bne.w   .l1933a
; --- Phase: Portrait Sprite Load ---
; Check if the two characters (char_a and char_b) are in the same range category
; RangeMatch ($007158): returns nonzero if both map to the same RangeLookup bucket
    moveq   #$0,d0
; char_b index from byte +1 of the pair record
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
; char_a index from byte +0 of the pair record
    move.b  (a2),d0
    move.l  d0,-(sp)
; RangeMatch: returns nonzero if char_a and char_b are in the same range bucket (compatible type group)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    tst.w   d0
; If same range: use portrait pointer from $000A1B50 (matched pair graphic)
    beq.b   .l192c4
    move.l  ($000A1B50).l,-(sp)
    bra.b   .l192ca
.l192c4:                                                ; $0192C4
; If different range: use portrait pointer from $000A1B4C (unmatched pair graphic)
    move.l  ($000A1B4C).l,-(sp)
.l192ca:                                                ; $0192CA
; LZ_Decompress ($003FEC): decompress selected portrait graphic data into save_buf_base ($FF1804)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
; Call $4668: tile placement helper -- place portrait at position ($10 wide, 1 tall) into buffer at a3
    pea     ($0010).w
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
; LZ_Decompress secondary portrait overlay data from $4DCE8 into the buffer
    pea     ($0004DCE8).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
; VRAMBulkLoad ($01D568): DMA-transfer the portrait tile data to VRAM
; Args: size=$0328 (808 bytes = ~50 tiles), dest=a3 buffer, flags=0, tile_addr=$001A
; $0012(a6) = 5th argument passed to FormatRelationDisplay (VRAM destination tile offset)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
; $001A = VRAM tile slot for portrait graphics (tile index 26 = first portrait graphic block)
    pea     ($001A).w
; $0328 = 808 bytes = portrait tile data size (~50 tiles × 32 bytes each; 8×8 pixels, 4bpp)
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
; GameCommand #$1B: place the portrait sprite tiles on screen
; Source $72AC0 = portrait tile index table; $0D wide, $1E tall at column d4, row d5+1
    pea     ($00072AC0).l
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
; GameCommand #$1B = place tile block from table onto screen
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
; --- Phase: Compatibility Gauge ---
.l1933a:                                                ; $01933A
; SetTextWindow ($03A942): define the text rendering window for the gauge area
; $20 × $20 tile region, at origin (0,0) -- full-panel text bounds
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
; SetTextCursor (a4 = $03AB2C): position cursor at (d4+1, d5+1) for the gauge display
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    jsr     (a4)
; Look up the char_a name string pointer from ROM table at $5E7E4
; Table is indexed by char_code * 4 (longword pointer per character)
    moveq   #$0,d0
; char_a code = byte 0 of pair record
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
; Name string pointer for char_a
    move.l  (a0,d0.w),-(sp)
; Format string at $410F8 -- prints first character's name with wide font
    pea     ($000410F8).l
; PrintfWide ($03B270): format + display string using 2-tile wide font
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
; SetTextCursor: position at (d4+1, d5+$C) -- 12 rows below the first name (for char_b name)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
; $C = 12 rows down: char_b name appears below char_a's portrait area
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
; --- Phase: Compatibility Score Display ---
; PlaceIconPair ($0058FC): place a pair of icon tiles at (d4+1, d5+$B)
; Variant 0 (clr.l arg): draw the compatibility gauge base icon pair
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
; $B = row offset 11: gauge appears between the two character names
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
; PlaceIconPair: draws tile pair at position, variant 0 = base gauge frame
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
; PlaceIconPair at (d4+1, d5+$12): draw top icon of the relation indicator
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
; $12 = row 18: top relation icon position
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
; PlaceIconPair variant 1 = top icon
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
; $00595E: place a tile pair with 2×2 icon at (d4+1, d5+$11)
; $11 = row 17, 2×2 tile block for the relation strength icon
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
; Width=2, height=2 for the relation icon block
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
; --- Phase: Compatibility Score Calculation and Print ---
; CharCodeCompare ($006F42): compute a raw compatibility index from the two character codes
; This is NOT the percentage -- it returns a category index (0-6) from the 7-category jump table
    moveq   #$0,d0
; char_b index
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
; char_a index
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
; CharCodeCompare: returns compatibility category index in d0
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
; Mask to word: compatibility score is a word value (0-$FFFF range)
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
; Format string at $410F4: prints the compatibility score value with wide font
    pea     ($000410F4).l
; PrintfWide: display the numeric compatibility score
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0030(sp),sp
; SetTextCursor: position at (d4+1, d5+$13) for char_b's name
; $13 = row 19: char_b name below the relation icon block
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
; $13 = 19 rows from top: second character name line
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
; Look up char_b name string pointer from ROM table $5E7E4
    moveq   #$0,d0
; char_b code = byte +1 of pair record
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
; Name string pointer for char_b
    move.l  (a0,d0.w),-(sp)
; Format string at $410F0 -- prints second character's name
    pea     ($000410F0).l
; PrintfWide: display char_b's name
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
; --- Phase: City Data Fields Display (char_a) ---
; SetTextCursor: position at (d4+3, d5+4) -- city stat line for char_a
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    jsr     (a4)
; Read char_a's city data entry from city_data ($FFBA80)
; city_data layout: 89 cities × 8 bytes (4 entries × 2-byte stride)
; Index: city_data + char_a_code * 8 + relation_index * 2
    moveq   #$0,d0
; char_a code
    move.b  (a2),d0
; * 8 (4 entries × 2 bytes stride = 8 bytes per character slot in city_data)
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
; relation_index * 2 (stride-2 entry select within the 4 entries for this character)
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
; d0 = city_data byte [0] for char_a at this relation index (e.g. current stat value)
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
; Read the companion byte [1] of the same city_data entry (second stat field)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
; d0 = city_data byte [1] for char_a (companion stat: e.g. max or target value)
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
; Format string at $410E6: prints two stat values for char_a (current / max) with narrow font
    pea     ($000410E6).l
; PrintfNarrow ($03B246): format + display with 1-tile narrow font
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
; --- Phase: City Data Fields Display (char_a, second line) ---
; SetTextCursor: position at (d4+3, d5+$14) -- second city stat line for char_a
; $14 = row 20: the line below the first city stat row
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
; $14 = 20 rows down: second stat line for char_a (second city relationship metric)
    addi.l  #$14,d0
    move.l  d0,-(sp)
    jsr     (a4)
; Clean up 3 sets of 4 args: this cursor call ($8) + previous PrintfNarrow args ($24) = $2C total
    lea     $002c(sp),sp
; Read char_b's city_data byte[0] for the SECOND city relationship entry (relation_index = d3)
; Same formula as char_a's lookup but using char_b code from pair record byte +1
    moveq   #$0,d0
; char_b code
    move.b  $0001(a2),d0
; * 8 (each char occupies 8 bytes in city_data: 4 entries × 2-byte stride)
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
; relation_index * 2 = stride-2 entry offset within this char's 8-byte block
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
; d0 = city_data byte[0] for char_b at this relation index (current stat value)
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
; Read char_b's city_data byte[1] for the same relation entry (companion/max stat)
    moveq   #$0,d0
; char_b code again (same lookup, but reading byte +1 of the entry)
    move.b  $0001(a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
; d0 = city_data byte[1] for char_b (companion field: e.g. maximum or target value)
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
; Format string at $410DC: prints two stat values for char_a's second city entry (narrow font)
    pea     ($000410DC).l
; PrintfNarrow: display the second stat pair for char_a's side of the panel
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
; --- Phase: City Data Fields Display (char_b) ---
; SetTextCursor: position at (d4+$B, $E) for char_b's city stats
; $B = column 11, $E = row 14
    move.w  d4,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    jsr     (a4)
; Read char_b's city data (same city_data lookup pattern, but using char_b code from byte +1)
; (char_b city_data reads performed implicitly within $7402)
    move.l  a2,-(sp)
; $7402: compute and return two city stat values for the char pair (using char_b as primary)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
; Format string at $410D8: print char_b's city stat result with narrow font
    pea     ($000410D8).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $001c(sp),sp
; --- Phase: Relation Action Buttons (char_a side) ---
; Display the relation action chooser for char_a
; $74E0: compute available relation actions for the pair, return action bitmask
; Args: pair record (a2), col=d4+4, row=d5+1, 0, 7 (max actions), relation_index=d3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
; $74E0: CalcCompatScore variant -- compute relation action set for display
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
; d0 = action bitmask (word); mask to 16 bits
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
; ShowCharPortrait ($03A5A8): display action/portrait panel using the action bitmask
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
; ShowRelationAction ($0199FA): display relation action button/icon for char_a
; Args: pair record (a2), col=d4+4, row=d5+$F, mode=1, display_flag=d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
; $F = row 15: relation action icon position
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
; ShowRelationAction: render the relation action display for the primary character
    dc.w    $4eba,$0476                                 ; jsr $0199FA
    nop
    lea     $002c(sp),sp
; ShowRelationResult ($019DE6): display relation result/outcome area for char_b side
; Args: pair record (a2), col=d4+8, row=d5+$F, mode=1, display_flag=d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
; +$8 = 8 columns right of the primary panel: char_b's result area
    addq.l  #$8,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
; ShowRelationResult: render the relation outcome panel for the second character
    dc.w    $4eba,$0838                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
; --- Phase: Relation Icon Tile Selection ---
; Read the status flags byte from the char pair record (+$A)
; This byte encodes which relation icon(s) are active via bit flags
; d3 will hold the tile set base offset into the icon table, or -1 if no icon applies
    moveq   #-$1,d3
    move.b  $000a(a2),d0
; Bit 2: highest-priority relation type (full partnership / alliance icon)
    btst    #$02,d0
    beq.b   .l195c6
; Bit 2 set: use tile set at offset 0 (first icon group = full alliance)
    moveq   #$0,d3
    bra.b   .l195e0
.l195c6:                                                ; $0195C6
    move.b  $000a(a2),d0
; Bit 1: intermediate relation type (code-share / partial partnership)
    btst    #$01,d0
    beq.b   .l195d4
; Bit 1 set: use tile set at offset $10 (16 = second icon group)
    moveq   #$10,d3
    bra.b   .l195e0
.l195d4:                                                ; $0195D4
    move.b  $000a(a2),d0
; Bit 0: lowest relation type (interline agreement / basic relation icon)
    btst    #$00,d0
    beq.b   .l195e0
; Bit 0 set: use tile set at offset $8 (8 = third icon group)
    moveq   #$8,d3
.l195e0:                                                ; $0195E0
; If d3 == -1 (no relation bits set): skip icon rendering entirely
    moveq   #-$1,d0
    cmp.l   d3,d0
; d3 == -1: no active relation icon, jump to epilogue
    bge.b   .l19656
; --- Phase: Relation Icon Tile Table Build ---
; Build an 8-word array in the link frame local area (-$10(a6) .. -$2(a6))
; Each word is a tile index: starting at $037B + d3 (icon base), sequential for 8 tiles
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
; d3 = first tile index = $037B + icon_set_offset
    add.l   d3,d0
; $037B = tile base address of relation icon tiles in VRAM pattern table
    addi.l  #$037b,d0
    move.l  d0,d3
.l195f6:                                                ; $0195F6
; Store sequential tile indices into local array at -$10(a6) as words
; -$10(a6): 8 words = 16 bytes = the link frame allocation
    move.w  d2,d0
; d0 * 2 = word offset into local array
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
; Next sequential tile in the relation icon strip
    addq.l  #$1,d3
    addq.w  #$1,d2
; 8 tiles per icon set
    cmpi.w  #$8,d2
    blt.b   .l195f6
; --- Phase: Relation Icon Tile DMA and Placement ---
; GameCommand #$1B: place 8-tile relation icon strip at (d4+4, d5+1), 4 wide × 2 high
; Source: local tile array at -$10(a6)
    pea     -$0010(a6)
; 2 rows × 4 columns = 8 tiles
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
; GameCommand #$1B = place tile block from table (local array) onto screen
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
; LZ_Decompress: decompress relation icon graphics from $4E28A into the save buffer at a3
    pea     ($0004E28A).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
; VRAMBulkLoad ($01D568): DMA the decompressed icon tiles to VRAM
; Dest tile: $037B, size=$18 words = 24 bytes = 3 tiles, flags=0
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
; $18 = 24 bytes -- size of relation icon tile data block
    pea     ($0018).w
; $037B = VRAM tile destination (base of relation icon tile strip)
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l19656:                                                ; $019656
; --- Phase: Epilogue ---
; Restore caller registers from link frame and return
; -$0030(a6) = start of saved registers in the link frame
; Link allocated -$10 for the tile index array; movem saved 8 registers × 4 bytes = $20 bytes
; Total offset from a6: $10 (local array) + $20 (saved regs) = $30 = -$0030(a6)
    movem.l -$0030(a6),d2-d5/a2-a5
; unlk restores sp to a6 (discards link frame) and pops saved a6 from stack
    unlk    a6
    rts
