; ============================================================================
; InitAllGameTables -- Zero all major game RAM regions (player records, route slots, char stats, city data) and init route slot sentinels
; 754 bytes | $00B74C-$00BA3D
; ============================================================================
InitAllGameTables:
; --- Phase: Setup ---
; No arguments. Zeroes all major RAM tables, then initializes route slot sentinel bytes
; and copies player 0's slot region as a template for players 1-3.
; a2 = MemFillByte ($1D520): fill a region with a byte value
; a3 = $FF88DC (char_group or auxiliary table base, zeroed then initialized)
; a4 = $FF9A20 (route_slots base: 4 players × 40 slots × $14 bytes = $C80 bytes)
; a5 = MemCopy ($1D538): copy a region (used to replicate player 0 slots to players 1-3)
    movem.l d2/a2-a5, -(a7)
    movea.l  #$0001D520,a2       ; a2 = MemFillByte routine pointer
    movea.l  #$00FF88DC,a3       ; a3 = $FF88DC (auxiliary char/group table)
    movea.l  #$00FF9A20,a4       ; a4 = route_slots base ($FF9A20)
    movea.l  #$0001D538,a5       ; a5 = MemCopy routine pointer

; --- Phase: Zero Player Records ($FF0018, $90 bytes) ---
; player_records: 4 × $24 (36) bytes per player = $90 total. All fields zeroed.
    pea     ($0090).w            ; count = $90 (144 bytes = 4 players × 36 bytes)
    clr.l   -(a7)                ; fill value = 0
    pea     ($00FF0018).l        ; dest = player_records base
    jsr     (a2)                 ; MemFillByte: zero player records

; --- Phase: Zero Unknown Block $FF00A8 ($40 bytes) ---
; Unknown per-player block; $40 bytes (64 bytes). Purpose not yet documented.
    pea     ($0040).w            ; count = $40 (64 bytes)
    clr.l   -(a7)                ; fill value = 0
    pea     ($00FF00A8).l        ; dest = unknown block ($FF00A8)
    jsr     (a2)                 ; MemFillByte

; --- Phase: Zero Unknown Block $FF00E8 ($30 bytes) ---
    pea     ($0030).w            ; count = $30 (48 bytes)
    clr.l   -(a7)
    pea     ($00FF00E8).l
    jsr     (a2)                 ; MemFillByte

; --- Phase: Zero Unknown Block $FF0130 ($80 bytes) ---
    pea     ($0080).w            ; count = $80 (128 bytes)
    clr.l   -(a7)
    pea     ($00FF0130).l
    jsr     (a2)                 ; MemFillByte
    lea     $30(a7), a7          ; clean 4 × 3-arg MemFillByte calls ($C each = $30)

; --- Phase: Zero Unknown Block $FF01B0 ($80 bytes) ---
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr     (a2)

; --- Phase: Zero Unknown Block $FF0230 ($40 bytes) ---
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00FF0230).l
    jsr     (a2)

; --- Phase: Zero Unknown Block $FF0270 ($20 bytes) ---
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF0270).l
    jsr     (a2)

; --- Phase: Zero Expense Table A ($FF0290, $18 bytes) ---
; Expense table A (PackSaveState block); $18 bytes. Purpose: packed save region A.
    pea     ($0018).w            ; count = $18 (24 bytes)
    clr.l   -(a7)
    pea     ($00FF0290).l        ; dest = expense_table_a (DATA_STRUCTURES: Expense Tables A)
    jsr     (a2)                 ; MemFillByte
    lea     $30(a7), a7          ; clean 4 more calls

; --- Phase: Zero Event Records ($FFB9E8, $80 bytes) ---
; event_records: 4 players × $20 (32) bytes each = $80 total.
; Each player's event record tracks char availability and aircraft status.
    pea     ($0080).w            ; count = $80 (128 bytes = 4 × 32-byte event records)
    clr.l   -(a7)                ; fill value = 0
    pea     ($00FFB9E8).l        ; dest = event_records base
    jsr     (a2)                 ; MemFillByte: zero all event records

; --- Phase: Zero Aircraft Table $FF02E8 ($50 bytes) ---
; Aircraft/route count table: 5 entries × 4 bytes × 4 players = $50 bytes (approx).
    pea     ($0050).w            ; count = $50 (80 bytes)
    clr.l   -(a7)
    pea     ($00FF02E8).l        ; dest = aircraft count table
    jsr     (a2)

; --- Phase: Zero Unknown Block $FF0338 ($80 bytes) ---
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF0338).l
    jsr     (a2)

; --- Phase: Zero Expense Table B ($FF03F0, $30 bytes) ---
; Expense table B (PackSaveState block); $30 bytes.
    pea     ($0030).w
    clr.l   -(a7)
    pea     ($00FF03F0).l        ; dest = expense_table_b
    jsr     (a2)
    lea     $30(a7), a7

; --- Phase: Zero Entity Bitfield Table ($FF08EC, $10 bytes) ---
; entity_bits: longword array indexed by entity index. FindBitInField uses this
; to locate first available entity slot (bit clear = free).
    pea     ($0010).w            ; count = $10 (16 bytes = 4 × longword entries)
    clr.l   -(a7)                ; fill value = 0 (all bits clear = all slots free)
    pea     ($00FF08EC).l        ; dest = entity_bits table
    jsr     (a2)                 ; MemFillByte

; --- Phase: Fill Expense Table C with $FF ($FF0420, $C0 bytes) ---
; Expense table C uses $FF as a sentinel value (not-assigned), so fill with $FF rather than 0.
    pea     ($00C0).w            ; count = $C0 (192 bytes)
    pea     ($00FF).w            ; fill value = $FF (sentinel = unassigned)
    pea     ($00FF0420).l        ; dest = expense_table_c
    jsr     (a2)                 ; MemFillByte with $FF sentinel

; --- Phase: Fill Unknown Block $FF04E0 with $FF ($E4 bytes) ---
; Similarly uses $FF sentinel; purpose TBD.
    pea     ($00E4).w            ; count = $E4 (228 bytes)
    pea     ($00FF).w            ; fill value = $FF
    pea     ($00FF04E0).l
    jsr     (a2)

; --- Phase: Zero Session Block $FF09A2 ($20 bytes) ---
; session_block_a2: purpose TBD from PackSaveState analysis.
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($00FF09A2).l        ; dest = session_block_a2
    jsr     (a2)
    lea     $30(a7), a7

; --- Phase: Zero Char Session Block $FF09D8 ($59 bytes) ---
; char_session_blk: 89-byte block (1 byte per city/character?).
; PackSaveState copies $59 bytes; each byte tracks per-char session state.
    pea     ($0059).w            ; count = $59 (89 bytes)
    clr.l   -(a7)
    pea     ($00FF09D8).l        ; dest = char_session_blk
    jsr     (a2)

; --- Phase: Zero Unknown Block $FFBDE4 ($1C bytes) ---
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFBDE4).l
    jsr     (a2)

; --- Phase: Zero Unknown Block $FFA7BC ($1C bytes) ---
    pea     ($001C).w
    clr.l   -(a7)
    pea     ($00FFA7BC).l
    jsr     (a2)

; --- Phase: Zero Bitfield Table $FFA6A0 ($10 bytes) ---
; bitfield_tab: longword entity bitfield array used by FindBitInField. Zero = all free.
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FFA6A0).l        ; dest = bitfield_tab (entity bitfields)
    jsr     (a2)
    lea     $30(a7), a7

; --- Phase: Zero Unknown Block $FFBD6C ($38 bytes) ---
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($00FFBD6C).l
    jsr     (a2)

; --- Phase: Zero Char Display Lookup $FF1278 ($10 bytes) ---
; char_display_tab: lookup table for char index → name table index.
; Used by ShowCharData/ShowStatsSummary. Zero = no chars assigned.
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($00FF1278).l        ; dest = char_display_tab (char index → name index)
    jsr     (a2)

; --- Phase: Zero City Data Table ($FFBA80, $2C8 bytes) ---
; city_data: 89 cities × 4 entries × 2 bytes = $2C8 bytes.
; Tracks per-city state (ownership, routes, popularity).
    pea     ($02C8).w            ; count = $2C8 (712 bytes = 89 cities × 4 × 2B)
    clr.l   -(a7)
    pea     ($00FFBA80).l        ; dest = city_data base
    jsr     (a2)

; --- Phase: Zero Char Stat Array ($FF05C4, $E4 bytes) ---
; char_stat_array: 4 players × $39 (57) bytes per player = $E4 total.
; Each player's per-char stat record tracks all character attributes.
    pea     ($00E4).w            ; count = $E4 (228 bytes = 4 × 57-byte stat records)
    clr.l   -(a7)
    pea     ($00FF05C4).l        ; dest = char_stat_array base
    jsr     (a2)
    lea     $30(a7), a7

; --- Phase: Zero Route Slot Array ($FF9A20, $C80 bytes) ---
; route_slots: 4 players × 40 slots × $14 (20) bytes = $C80 (3200) bytes total.
; Zeroing clears all slot fields including city_a, city_b, status_flags.
    pea     ($0C80).w            ; count = $C80 (3200 bytes = full route slot table)
    clr.l   -(a7)
    move.l  a4, -(a7)            ; dest = $FF9A20 (route_slots base, stored in a4)
    jsr     (a2)                 ; MemFillByte: zero entire route slot table
    lea     $c(a7), a7

; --- Phase: Initialize Player 0 Route Slot Sentinels ---
; After zeroing, set city_a ($FF9A20+0) and city_b ($FF9A20+1) of slot 0 to $FF
; ($FF = empty sentinel; city indices $FF mean "no city assigned").
    move.b  #$ff, ($00FF9A20).l  ; route_slot[0].city_a = $FF (empty sentinel)
    move.b  #$ff, $1(a4)         ; route_slot[0].city_b = $FF (empty sentinel)

; --- Phase: Initialize Route Slot Sentinels for Slots 1-39 (Player 0) ---
; Loop d2 = 1..39 ($28-1): for each slot, copy player 0 slot 0 as a source template,
; then set the slot's own sentinel bytes. The copy helper (a5 = MemCopy at $1D538)
; copies $14 bytes from source to dest with flags ($00200003 = standard copy mode).
; Slot offset formula: d2 * $14 = d2 * 5 * 4 = ((d2*4 + d2) << 2)
    moveq   #$1,d2               ; d2 = slot index, start at 1 (slot 0 already initialized)
.l0b8f2:
; MemCopy: copy player 0 slot 0 (a4) as template into slot d2
; Stack args (MemCopy $1D538): count, dest, flags (0), src (a4), null
    pea     ($0014).w            ; count = $14 (20 bytes = 1 slot)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0              ; d0 = d2 * 4
    add.l   d1, d0               ; d0 = d2 * 4 + d2 = d2 * 5
    lsl.l   #$2, d0              ; d0 = d2 * 20 ($14) = byte offset of slot d2
    pea     (a4, d0.l)           ; dest = $FF9A20 + d2*$14 (slot d2 address)
    clr.l   -(a7)                ; flags = 0
    move.l  a4, -(a7)            ; src = $FF9A20 (player 0 slot 0, the template)
    clr.l   -(a7)                ; null terminator
    jsr     (a5)                 ; MemCopy: copy slot 0 sentinel pattern into slot d2
    lea     $14(a7), a7          ; clean 5-longword MemCopy stack frame
    addq.w  #$1, d2              ; d2++: next slot
    cmpi.w  #$28, d2             ; done all 40 slots (0..$27)?
    blt.b   .l0b8f2              ; no: continue

; --- Phase: Initialize Route Slot Sentinels for Players 1-3 ---
; Each player has $320 bytes of route slots (40 × $14). Copy player 0's slot block
; to each of players 1, 2, 3 using MemCopy (a5).
; Offset formula: d2 * $320 = d2 * 800 = Multiply32(d2, $320)
    moveq   #$1,d2               ; d2 = player index (1..3)
.l0b91c:
; Compute player d2's slot block offset: d2 * $320 into d0 via Multiply32
    pea     ($0320).w            ; count = $320 (800 bytes = 40 slots × $14)
    move.w  d2, d0
    ext.l   d0
    move.l  #$320, d1
    jsr Multiply32               ; d0 = d2 * $320 (player offset in bytes)
    pea     (a4, d0.l)           ; dest = $FF9A20 + d2*$320 (player d2 slot block)
    clr.l   -(a7)                ; flags = 0
    move.l  a4, -(a7)            ; src = $FF9A20 (player 0 slot block as template)
    clr.l   -(a7)
    jsr     (a5)                 ; MemCopy: copy player 0 slots → player d2 slots
    lea     $14(a7), a7
    addq.w  #$1, d2              ; d2++: next player
    cmpi.w  #$4, d2              ; done players 1-3?
    blt.b   .l0b91c              ; no: continue

; --- Phase: Zero Auxiliary Table $FF88DC ($C0 bytes) ---
; a3 = $FF88DC: auxiliary table (char group or slot auxiliary data).
; Zero the entire $C0 (192) byte block before setting sentinels.
    pea     ($00C0).w            ; count = $C0 (192 bytes)
    clr.l   -(a7)
    move.l  a3, -(a7)            ; dest = $FF88DC
    jsr     (a2)                 ; MemFillByte: zero table
    lea     $c(a7), a7

; --- Phase: Initialize $FF88DC Sentinels for Entry 0 ---
; Set first two word-sized entries ($FF88DC and $FF88DC+2) to $FFFF (empty sentinel).
    move.w  #$ff, ($00FF88DC).l  ; $FF88DC entry[0].word0 = $FFFF (unassigned)
    move.w  #$ff, $2(a3)         ; $FF88DC entry[0].word1 = $FFFF (unassigned)

; --- Phase: Copy $FF88DC Entry 0 to Entries 1-3 (4-entry table, stride $C) ---
; Each entry is $C (12) bytes. Offset formula: d2 * $C = d2 * 3 * 4 = ((d2*2 + d2) << 2)
    moveq   #$1,d2               ; d2 = entry index (start at 1; entry 0 already set)
.l0b966:
    pea     ($000C).w            ; count = $C (12 bytes = 1 entry)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0               ; d0 = d2 * 2
    add.l   d1, d0               ; d0 = d2 * 3
    lsl.l   #$2, d0              ; d0 = d2 * $C (byte offset to entry d2)
    pea     (a3, d0.l)           ; dest = $FF88DC + d2*$C
    clr.l   -(a7)
    move.l  a3, -(a7)            ; src = $FF88DC entry 0 (sentinel template)
    clr.l   -(a7)
    jsr     (a5)                 ; MemCopy: copy sentinel entry 0 → entry d2
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2              ; done entries 1-3?
    blt.b   .l0b966              ; no: continue

; --- Phase: Copy $FF88DC Entry 0 to Entries 1-3 (stride $30 variant) ---
; A second set of MemCopy calls using stride $30 (48 bytes) instead of $C.
; Likely initializes a parallel or extended table section at the same base $FF88DC.
    moveq   #$1,d2
.l0b990:
    pea     ($0030).w            ; count = $30 (48 bytes)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0               ; d0 = d2 * 2
    add.l   d1, d0               ; d0 = d2 * 3
    lsl.l   #$4, d0              ; d0 = d2 * $30 (48-byte stride)
    pea     (a3, d0.l)           ; dest = $FF88DC + d2*$30
    clr.l   -(a7)
    move.l  a3, -(a7)            ; src = $FF88DC entry 0 template
    clr.l   -(a7)
    jsr     (a5)                 ; MemCopy: copy 48-byte entry 0 → entry d2
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0b990

; --- Phase: Zero Unknown Block $FF1004 ($70 bytes) ---
; Purpose TBD; possibly a text or tile buffer used by the UI system.
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr     (a2)

; --- Phase: Zero Route Field A ($FF09C2, $8 bytes) ---
; route_field_a: CopyRouteFields sub-record A (8 bytes, purpose TBD from PackSaveState).
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09C2).l        ; dest = route_field_a
    jsr     (a2)

; --- Phase: Initialize Route Field A Sentinels (2 entries, stride 4) ---
; Two entries at $FF09C2 and $FF09C6 (stride $4); set first byte to $FF sentinel.
    clr.w   d2                   ; d2 = entry index (0..1)
.l0b9d6:
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2 * 4 (stride)
    movea.l  #$00FF09C2,a0
    move.b  #$ff, (a0,d0.w)      ; route_field_a[d2].byte0 = $FF (unassigned sentinel)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0b9d6              ; repeat for both entries

; --- Phase: Zero Route Field B ($FF09CA, $4 bytes) ---
; route_field_b: CopyRouteFields sub-record B (4 bytes).
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($00FF09CA).l        ; dest = route_field_b
    jsr     (a2)
; Set route_field_b entry[0].byte0 = $FF (unassigned sentinel)
    move.b  #$ff, ($00FF09CA).l

; --- Phase: Zero Route Field C ($FF09CE, $8 bytes) ---
; route_field_c: CopyRouteFields sub-record C (8 bytes).
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($00FF09CE).l        ; dest = route_field_c
    jsr     (a2)
    lea     $30(a7), a7          ; clean 4 MemFillByte stack frames

; --- Phase: Initialize Route Field C Sentinels (2 entries, stride 4) ---
    clr.w   d2
.l0ba18:
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2 * 4
    movea.l  #$00FF09CE,a0
    move.b  #$ff, (a0,d0.w)      ; route_field_c[d2].byte0 = $FF (sentinel)
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   .l0ba18

; --- Phase: Initialize Route Field D ($FF09D6, word) ---
; route_field_d: 2-byte field; $FFFF = fully unassigned sentinel.
    move.w  #$ff, ($00FF09D6).l  ; route_field_d = $FFFF (all bytes unassigned)

    movem.l (a7)+, d2/a2-a5
    rts
