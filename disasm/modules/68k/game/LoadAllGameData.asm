; ============================================================================
; LoadAllGameData -- Load game save state from cartridge SRAM, unpack header fields (player count, scenario, frame counter) into work RAM
; 1196 bytes | $00CA3E-$00CEE9
; ============================================================================
LoadAllGameData:
; --- Phase: Prologue / SRAM Read ---
; Preserve caller registers; d3 = slot index argument (save-state slot 0-3)
    movem.l d2-d3/a2-a4, -(a7)
; d3 = save slot index (passed on stack at +$18 after saves)
    move.l  $18(a7), d3
; a4 = copy helper at $1D538 (CopyBytesToWords / stride-2 loader) -- used throughout
    movea.l  #$0001D538,a4
; a3 = save_buf_base ($FF1804); will advance through the save buffer as fields are unpacked
    movea.l  #$00FF1804,a3
; Push size $2000 (8KB) -- read entire SRAM save block into $FF1804 buffer
    pea     ($2000).w
; Compute SRAM source address: slot * $2000 + $200003
; $200003 is the Sega Genesis SRAM base address (16-bit SRAM, byte-wide on odd addresses)
    move.w  d3, d0
    ext.l   d0
; lsl.l #$D = shift left 13 = multiply by $2000 (8KB per save slot)
    moveq   #$D,d1
    lsl.l   d1, d0
; d0 = $200003 + (slot * $2000) = SRAM byte address for this slot
    addi.l  #$200003, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
; Read raw SRAM bytes (stride-2 -- SRAM is on odd data bus) into save_buf_base ($FF1804)
    jsr CopyAlternateBytes
; Now a3 starts 6 bytes past the buffer base = first field area after save header
    addq.l  #$6, a3
; --- Phase: Header Fields Unpack ---
; Unpack individual scalar fields from the save header into low work-RAM

; save_byte_03 ($FF0003 area) -- read one byte, widen to word
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0002).l
; save_byte_05 ($FF0005 area) -- second header byte
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0004).l
; Read 2-byte block into frame_counter ($FF0006): MainLoop iteration counter
; Args to stride-2 loader (a4): count=$0002, dest=$FF0006, flags=0, src=a3, base=$200003
    pea     ($0002).w
    pea     ($00FF0006).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
; Advance past the 2 bytes just loaded (a3 already moved by caller, align past padding)
    addq.l  #$2, a3
; frame_counter2 ($FF0008) -- secondary timer used by PollInputChange
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0008).l
; flight_active ($FF000A) -- nonzero if a flight/route operation is active
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000A).l
; ($FF000C) -- display mode field (restored to SetDisplayMode later)
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000C).l
; ($FF000E) -- display page field (restored to SetDisplayPage later)
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000E).l
; ($FF0010) -- additional scalar field
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0010).l
; --- Phase: Aircraft Table Rebuild ---
; Compute aircraft display limit: player_count (from $FF0002) * $3C (60) + $50 (80)
; Stored at $FFA6B2 -- used as iteration bound for aircraft attribute loops
    move.w  ($00FF0002).l, d0
; $3C = 60 aircraft entries per player
    mulu.w  #$3c, d0
; $50 = 80 base offset (minimum table size for 0 players)
    addi.w  #$50, d0
    move.w  d0, ($00FFA6B2).l
; Rebuild the aircraft attribute lookup table (populated from ROM tables)
    bsr.w BuildAircraftAttrTable
; Sort aircraft entries by performance metric (prepares table for UI display)
    bsr.w SortAircraftByMetric
; --- Phase: Game State Blocks Restore ---
; The remainder of this function mirrors PackSaveState in reverse:
; each block is read from the SRAM source (a3) into the corresponding RAM region.
; The stride-2 loader at a4 expands alternate-byte (SRAM odd-bus) data into words.
; Stack call convention for a4: (count, dest, 0, src, $200003) = 5 longs = $14 bytes.
; Note: some call sites follow jsr (a4) with lea $28(a7),a7 to clean all 5 args ($14 bytes)
; plus the caller's own $14 bytes of arg pushes = $28 total.  Others use addq + moveq patterns.

; save_block_12 ($FF0012, 4 bytes) -- purpose TBD
    pea     ($0004).w
    pea     ($00FF0012).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; No stack cleanup here: caller advances a3 and lets the next call reclaim stack space
    addq.l  #$4, a3
; current_player ($FF0016) -- current player turn index (0-3), set by RunPlayerTurn
    move.b  (a3)+, ($00FF0016).l
; player_records ($FF0018, $90 = 144 bytes) -- 4 × $24 (36B) player records
; Each record holds: active_flag, hub_city, route counts, cash, quarterly accumulators, approval
; See DATA_STRUCTURES.md §1 for full field layout (active_flag+$00, hub_city+$01, cash+$06, etc.)
    pea     ($0090).w
    pea     ($00FF0018).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; $28 = 5 × 4 bytes pushed before jsr (a4) (count+dest+0+src+base) plus this caller's own $14
    lea     $28(a7), a7
; Advance a3 past the $90 bytes just read ($28 = 5 stack args already cleaned, so advance source)
    lea     $90(a3), a3
; Unknown block ($FF00A8, $40 = 64 bytes) -- TBD (likely AI state or schedule data)
    pea     ($0040).w
    pea     ($00FF00A8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
; Unknown block ($FF00E8, $30 = 48 bytes) -- TBD
    pea     ($0030).w
    pea     ($00FF00E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$30,d0
    adda.l  d0, a3
; player_word_tab ($FF0118, $08 = 8 bytes) -- 4 words, one per player (DrawPlayerRoutes)
    pea     ($0008).w
    pea     ($00FF0118).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$8, a3
; char_stat_subtab ($FF0120, $10 = 16 bytes) -- byte array indexed by player_index * 4
    pea     ($0010).w
    pea     ($00FF0120).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
; Unknown block ($FF0130, $80 = 128 bytes) -- TBD (likely AI/economic data)
    pea     ($0080).w
    pea     ($00FF0130).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; Advance a3 by $80 (no stack cleanup here -- the $28 stack frame will be cleaned by the next lea $28)
    lea     $80(a3), a3
; Unknown block ($FF01B0, $80 = 128 bytes) -- TBD (second AI/economic block)
    pea     ($0080).w
    pea     ($00FF01B0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
; Unknown block ($FF0230, $40 = 64 bytes) -- TBD
    pea     ($0040).w
    pea     ($00FF0230).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
; Unknown block ($FF0270, $20 = 32 bytes) -- TBD
    pea     ($0020).w
    pea     ($00FF0270).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$20,d0
    adda.l  d0, a3
; Expense table A ($FF0290, $18 = 24 bytes) -- 4 players × 6 bytes expense components (A/B/C)
; See DATA_STRUCTURES.md §4a: +$00=expense_A, +$02=expense_B, +$04=expense_C; all cleared quarterly
    pea     ($0018).w
    pea     ($00FF0290).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; Only $14 cleaned here (not $28): the prior lea $28 already consumed the stacked args from $FF0270
    lea     $14(a7), a7
    moveq   #$18,d0
    adda.l  d0, a3
; --- Phase: Event Records Restore (Stride-2 Loop) ---
; event_records ($FFB9E8, 128 bytes) -- 4 records × $20 (32B) each
; PackSaveState saves 1 byte per entry at stride 2, 16 entries per record.
; Here the load mirrors that: load 1 byte per slot via a4, then copy byte to stride+1 position.
; Outer loop: d3 = record index (0-3), a0 = base of record (a0 = $FFB9E8 + d3*$20)
; Inner loop: d2 = entry index (0-15), loads 1 byte, duplicates it into the stride-2 slot
    clr.w   d3
.l0cc2c:
; a0 = event_records base + record * $20 (32 bytes per record)
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
; a2 tracks current entry within this record
    movea.l a0, a2
    clr.w   d2
.l0cc3e:
; Load 1 byte from SRAM (stride-2 source) into current entry word at (a2)
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
; Duplicate the loaded byte into position +1 (stride-2 mirror slot)
    move.b  (a2), $1(a2)
    addq.l  #$1, a3
; Advance a2 by 2 (stride-2: each logical entry occupies 2 bytes in RAM)
    addq.l  #$2, a2
    addq.w  #$1, d2
; 16 entries per record ($10)
    cmpi.w  #$10, d2
    blt.b   .l0cc3e
; Next of 4 event records
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cc2c
; Unknown block ($FF02E8, $50 = 80 bytes) -- TBD (possibly financial or scheduling tables)
    pea     ($0050).w
    pea     ($00FF02E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$50,d0
    adda.l  d0, a3
; Unknown block ($FF0338, $80 = 128 bytes) -- route display / player route icon table (DrawPlayerRoutes)
    pea     ($0080).w
    pea     ($00FF0338).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
; char_display_tab ($FF03B8, $28 = 40 bytes) -- lookup table for ShowCharData / ShowStatsSummary
; Indexed: char_idx * 10 + col * 2
    pea     ($0028).w
    pea     ($00FF03B8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$28,d0
    adda.l  d0, a3
; Unknown block ($FF03E0, $10 = 16 bytes) -- TBD
    pea     ($0010).w
    pea     ($00FF03E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
; Expense table B ($FF03F0, $30 = 48 bytes) -- 4 players × 12 bytes (expense components D/E/F + persistent fields)
    pea     ($0030).w
    pea     ($00FF03F0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$30,d0
    adda.l  d0, a3
; Unknown block ($FF0420, $C0 = 192 bytes) -- TBD (large block, likely AI/city relationship data)
    pea     ($00C0).w
    pea     ($00FF0420).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $c0(a3), a3
; char_stat_array compressed source ($FF04E0, $E4 = 228 bytes) -- raw compressed pixel data
; This is NOT the final array; UnpackPixelData will decompress it below
    pea     ($00E4).w
    pea     ($00FF04E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; Advance a3 past $E4 bytes -- now pointing at next block in SRAM source
    lea     $e4(a3), a3
; Decompress 2-bit packed pixel data from a3 (compressed) into char_stat_array ($FF05C4)
; 4 players × 57 bytes = 228 bytes of unpacked character stat values
; Returns new source pointer in d0 (consumed bytes past the compressed input)
    move.l  a3, -(a7)
    jsr UnpackPixelData
; a3 = updated source pointer after consuming compressed data (returned in d0)
    movea.l d0, a3
; Unknown block ($FF0728, $40 = 64 bytes) -- follows char stat data; purpose TBD
    pea     ($0040).w
    pea     ($00FF0728).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; $2C cleanup: $28 for 5 args + $4 for the extra pea from jsr UnpackPixelData above
    lea     $2c(a7), a7
    moveq   #$40,d0
    adda.l  d0, a3
; --- Phase: tab32_8824 Restore (32-Entry Stride-2 Loop) ---
; tab32_8824 ($FF8824, $40 = 64 raw bytes, 32 logical entries at stride 2)
; PackSaveState saved 1 byte per entry; here each byte is loaded then the dest pointer
; advances by 2, leaving stride-2 gaps (only the even positions are filled here)
    movea.l  #$00FF8824,a2
    clr.w   d2
.l0cd5e:
; Load 1 byte from SRAM source into current stride-2 slot in tab32_8824
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
; Stride 2: advance a2 by 2 bytes per logical entry
    addq.l  #$2, a2
    addq.w  #$1, d2
; 32 entries ($20) in tab32_8824
    cmpi.w  #$20, d2
    blt.b   .l0cd5e
; --- Phase: city_data Restore (89 Cities × 4 Entries Loop) ---
; city_data ($FFBA80, $2C8 = 712 bytes) -- 89 cities × 4 entries × 2 bytes per entry
; Outer loop: d2 = city index (0-88), inner loop: d3 = entry index (0-3)
; Each entry is saved as 1 byte, stored into the first byte of a 2-byte stride-2 slot
    movea.l  #$00FFBA80,a2
    clr.w   d2
.l0cd88:
; Inner loop counter: 4 entries per city
    clr.w   d3
.l0cd8a:
; Load 1 byte for this city's entry from SRAM
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
; a2 advances by 2 per entry (stride-2 layout within city_data)
    addq.l  #$2, a2
    addq.w  #$1, d3
; 4 entries per city
    cmpi.w  #$4, d3
    blt.b   .l0cd8a
    addq.w  #$1, d2
; $59 = 89 cities total
    cmpi.w  #$59, d2
    blt.b   .l0cd88
; --- Phase: Entity Bitfield Table + Route Slots Restore ---
; entity_bits ($FF08EC, $10 = 16 bytes) -- longword bitfield array indexed by entity * 4
; Used by FindBitInField to locate set bits for entity scheduling
    pea     ($0010).w
    pea     ($00FF08EC).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
; Route slot array ($FF9A20) -- 4 players × 40 slots × $C saved bytes per slot
; Only the first $0C bytes of each $14-byte slot are saved (fields +$0C through +$13 are runtime)
; Saved fields: city_a(+$00), city_b(+$01), plane_type(+$02), frequency(+$03),
;   ticket_price(+$04 word), revenue_target(+$06 word), gross_revenue(+$08 word),
;   status_flags(+$0A byte), service_quality(+$0B byte) -- see DATA_STRUCTURES.md §2
; Outer loop: d3 = player index (0-3)
; Inner loop: d2 = slot index (0-39 = $28)
    clr.w   d3
.l0cdd4:
; Compute player base: a0 = $FF9A20 + player * $0320 (800 bytes per player)
    move.w  d3, d0
; $320 = 800 = 40 slots × $14 bytes per slot
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
; a2 = current slot pointer (will advance by $14 per slot within this player's range)
    movea.l a0, a2
    clr.w   d2
.l0cde8:
; Load $0C (12) saved bytes for this slot: city_a, city_b, plane_type, frequency,
; ticket_price, revenue_target, gross_revenue, status_flags, service_quality
    pea     ($000C).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
; Advance a3 (source) by $C bytes consumed
    moveq   #$C,d0
    adda.l  d0, a3
; Advance a2 (dest) by full slot stride $14 (20 bytes) -- runtime fields +$0C..+$13 left zeroed
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
; $28 = 40 slots per player
    cmpi.w  #$28, d2
    blt.b   .l0cde8
    addq.w  #$1, d3
; 4 players
    cmpi.w  #$4, d3
    blt.b   .l0cdd4
; --- Phase: Route / Session Sub-Records Restore ---
; session_block_9c ($FF099C, 4 bytes) -- purpose TBD
    pea     ($0004).w
    pea     ($00FF099C).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$4, a3
; session_byte_a0 ($FF09A0, 1 byte) -- purpose TBD
    pea     ($0001).w
    pea     ($00FF09A0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    addq.l  #$1, a3
; Income/expense table ($FF09A2, $20 = 32 bytes) -- 4 players × 8 bytes (income + expense longwords)
; See DATA_STRUCTURES.md §4c: +$00 = income component (long), +$04 = expense component (long)
    pea     ($0020).w
    pea     ($00FF09A2).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$20,d0
    adda.l  d0, a3
; Restore 4 route sub-records (route_field_a/b/c/d at $FF09C2-$FF09D7)
; CopyRouteFields copies 4 fixed-size blocks from sequential source into their RAM destinations
; Returns updated source pointer in d0
    move.l  a3, -(a7)
    jsr CopyRouteFields
; a3 = source pointer after all 4 route field blocks consumed
    movea.l d0, a3
; char_session_blk ($FF09D8, $59 = 89 bytes) -- 1 byte per character (session assignment state?)
    pea     ($0059).w
    pea     ($00FF09D8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; $2C cleanup: $28 for 5 args + $4 for the CopyRouteFields push above
    lea     $2c(a7), a7
; $59 = 89 bytes consumed
    moveq   #$59,d0
    adda.l  d0, a3
; session_word_a32 ($FF0A32, 2 bytes) -- purpose TBD
    pea     ($0002).w
    pea     ($00FF0A32).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$2, a3
; ui_active_flag ($FF0A34, 2 bytes) -- nonzero = UI/input system active (PollAction gating)
    pea     ($0002).w
    pea     ($00FF0A34).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
; --- Phase: Runtime Reconstruction ---
; Initialize per-player aircraft assignment state (slot data not stored in save)
    jsr (InitPlayerAircraftState,PC)
    nop
; Restore the display mode that was active when the game was saved
; display mode word was loaded from SRAM into $FF000C earlier
    move.w  ($00FF000C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetDisplayMode
; Restore display page (which scroll plane / screen page was active)
    move.w  ($00FF000E).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetDisplayPage
; Stack: clean up the two SetDisplay calls (2 longs = $8) plus the leftover $28 stack frame
; that was never cleaned after the last jsr (a4) route-loads block: $8 + $28 = $30 total
    lea     $30(a7), a7
    movem.l (a7)+, d2-d3/a2-a4
    rts
