; ============================================================================
; ProcessCharAnimationsS2 -- Processes pending char animation and move records for a player at turn end: credits char revenue to route income, evicts expired char relations, resets char state slots, and applies accumulated city-popularity bonuses.
; 662 bytes | $027AD0-$027D65
; ============================================================================
; Calling convention: d0 = player_index on entry (before the dc.w prologue word)
; d4 = player_index (available to subroutine body after the prologue)
; A3 -> player_record[$FF0018 + player_index * $24]
; D6 = player_index * $20 (route-slot table offset for this player)
; A2 steps through 4 route-slot display entries in $FF0338
; NOTE: The dc.w at offset 0 is a byte-immediate instruction with compiler junk in the high byte
;   (see MEMORY.md: "Byte-immediate junk byte pitfall").
;   The operative part: MOVE.B d4,d0 (lower nibble = 4) seeds d0 = player_index for mulu below.
ProcessCharAnimationsS2:
; --- Phase: Setup player record and route-slot table pointers ---
; Entry: d0 = player_index (set by caller before JSR)
    dc.w    $0020,$3004                     ; ori.b #$4,-(a0) - high byte $30 is compiler junk
; Compute player_record pointer: $FF0018 + player_index * $24
    mulu.w  #$24, d0            ; d0 = player_index * 36 (player_record stride)
    movea.l  #$00FF0018,a0      ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> player_record[player_index]
; Compute $FF0338 table offset: player_index * $20 (4 slots × 8 bytes)
    moveq   #$0,d0
    move.w  d4, d0              ; d4 = player_index (loaded before entry by caller)
    lsl.l   #$5, d0             ; d0 = player_index * 32
    move.l  d0, d6              ; d6 = route-slot table offset (saved for city-data loop later)
    movea.l  #$00FF0338,a0      ; route-slot display working table base
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> first slot entry for this player (8 bytes/slot)
    clr.w   d3                  ; d3 = slot index (0-3)
; --- Phase: Credit finished char moves to player cash ---
; For each of the 4 route slots: if slot type == 5 (hired char finalised),
; compute char value and add it to player_record.cash (+$06)
l_27afa:
; Check if this slot holds a completed char move (type byte = 5)
    cmpi.b  #$5, $1(a2)         ; route_slot_display[1] = type: 5 = char just hired/moved
    bne.b   l_27b60             ; not type 5 -- just clear and advance
; Determine which char table to look up based on slot row (city_a byte):
; city_a < $20 = domestic char table ($FF1704/$FF0420, stride 6)
; city_a >= $20 = international/alliance char table ($FF15A0/$FF0460, stride 4)
    cmpi.b  #$20, (a2)          ; slot[0] = city_a / row index
    bcc.b   l_27b20             ; >= $20: use international table
; Domestic char: index = city_a * 6 + sub_index (slot[2])
    moveq   #$0,d0
    move.b  (a2), d0            ; city_a byte (row)
    mulu.w  #$6, d0             ; row * 6 (domestic stride)
    moveq   #$0,d1
    move.b  $2(a2), d1          ; slot[2] = sub_index (column)
    add.w   d1, d0
    movea.l  #$00FF1704,a0      ; domestic char ID table
    bra.b   l_27b34
; International char: index = city_a * 4 + sub_index
l_27b20:
    moveq   #$0,d0
    move.b  (a2), d0            ; city_a byte
    lsl.w   #$2, d0             ; row * 4 (international stride)
    moveq   #$0,d1
    move.b  $2(a2), d1          ; sub_index
    add.w   d1, d0
    movea.l  #$00FF15A0,a0      ; international char ID table
; Read the char ID byte and compute its value for this player
l_27b34:
    move.b  (a0,d0.w), d2       ; d2 = char_id from lookup table
    andi.l  #$ff, d2
; CalcCharValue: computes longword cost/value for (char_id, row, player_index)
    moveq   #$0,d0
    move.w  d2, d0              ; char_id
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0            ; city_a / row
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr CalcCharValue            ; returns longword char value in d0
    lea     $c(a7), a7
    move.l  d0, d2              ; d2 = char_value (longword)
; Credit char value to player cash: player_record+$06 = cash (DATA_STRUCTURES.md)
    add.l   d2, $6(a3)          ; player_record.cash += char_value
; --- Reset slot fields (unconditional, whether or not type was 5) ---
l_27b60:
    clr.b   (a2)                ; slot[0] = city_a = 0
    clr.b   $1(a2)              ; slot[1] = type   = 0
    clr.b   $2(a2)              ; slot[2] = sub_index = 0
    clr.b   $3(a2)              ; slot[3] = sub_category = 0
    clr.w   $4(a2)              ; slot[4..5] (ticket_price word) = 0
    addq.l  #$8, a2             ; advance to next 8-byte slot entry
    addq.w  #$1, d3             ; slot_index++
    cmpi.w  #$4, d3             ; processed all 4 slots?
    bcs.w   l_27afa
; --- Phase: Scan route slots for expired relations and evict them ---
; d3 = total route count = player_record[+$04] (domestic_slots) + player_record[+$05] (intl_slots)
l_27b7e:
    moveq   #$0,d3
    move.b  $4(a3), d3          ; player_record+$04 = domestic_slots count
    moveq   #$0,d0
    move.b  $5(a3), d0          ; player_record+$05 = intl_slots count
    add.w   d0, d3              ; d3 = total route slots for this player
; Compute starting route slot in $FF9A20 for this player:
; Player offset = player_index * $320 (800 bytes/player); slot_start = domestic_slots * $14
    moveq   #$0,d0
    move.b  $4(a3), d0          ; domestic_slots
    mulu.w  #$14, d0            ; domestic_slots * 20 (route slot stride)
    move.l  d0, -(a7)           ; push slot_start offset
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  #$320, d1           ; player stride = $320 = 800 bytes
    jsr Multiply32               ; d0 = player_index * $320
    move.l  d0, d5              ; d5 = player_base_offset (for later reset phase)
    add.l   (a7)+, d0           ; d0 = player_base + slot_start (first route slot to check)
    movea.l  #$00FF9A20,a0      ; route_slots base ($FF9A20)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> first route slot to evaluate for expiry
    moveq   #$0,d2
    move.b  $4(a3), d2          ; d2 = domestic_slots (start scanning from slot 0 of int'l)
    bra.b   l_27bea
; Loop: compare route_slot.actual_revenue (+$0E) vs revenue_target (+$06)
; If actual < target: route is unprofitable -- remove char relation (evict)
l_27bc0:
    move.w  $e(a2), d0          ; route_slot+$0E = actual_revenue (DATA_STRUCTURES.md)
    cmp.w   $6(a2), d0          ; route_slot+$06 = revenue_target
    bcc.b   l_27be4             ; actual >= target: profitable, keep relation
; Unprofitable route: evict the character relation for this slot
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0              ; slot_index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr RemoveCharRelation       ; remove character from relation table for this route slot
    lea     $c(a7), a7
    bra.b   l_27bee             ; slot was evicted; a2 does not advance (RemoveCharRelation shifts)
; Slot is profitable: advance to next route slot
l_27be4:
    moveq   #$14,d0
    adda.l  d0, a2              ; advance a2 by 20 bytes (one route slot)
    addq.w  #$1, d2             ; slot_index++
l_27bea:
    cmp.w   d3, d2              ; reached end of route slots?
    bcs.b   l_27bc0             ; not yet: continue eviction scan
; After inner eviction loop: check if more slots remain (handles re-entry after eviction)
l_27bee:
    cmp.w   d3, d2
    bcs.b   l_27b7e             ; still slots to check: loop back for another pass
; --- Phase: Reset cleared route slots (actual_revenue, targets, etc.) ---
; Starting from slot d5 (player base, slot index from domestic_slots):
    moveq   #$0,d3
    move.b  $4(a3), d3          ; domestic_slots
    moveq   #$0,d0
    move.b  $5(a3), d0          ; intl_slots
    add.w   d0, d3              ; d3 = total route count
    movea.l  #$00FF9A20,a0
    lea     (a0,d5.w), a2       ; a2 -> player_base in route_slots (d5 = player_index * $320)
    clr.w   d2                  ; d2 = reset slot counter
    bra.b   l_27c2e
; Clear all runtime fields of each route slot (DATA_STRUCTURES.md: fields +$0E onwards)
l_27c0e:
    clr.w   $e(a2)              ; route_slot+$0E = actual_revenue = 0
    clr.w   $6(a2)              ; route_slot+$06 = revenue_target = 0
    clr.w   $10(a2)             ; route_slot+$10 = passenger_count = 0
    clr.w   $8(a2)              ; route_slot+$08 = gross_revenue = 0
    clr.w   $12(a2)             ; route_slot+$12 = prev_revenue = 0
    move.b  #$4, $a(a2)         ; route_slot+$0A = status_flags = $04 (ESTABLISHED bit set)
    moveq   #$14,d0
    adda.l  d0, a2              ; advance to next 20-byte route slot
    addq.w  #$1, d2
l_27c2e:
    cmp.w   d3, d2              ; reset all route slots?
    bcs.b   l_27c0e
; --- Phase: City popularity decay (cities 0-31: apply route-bitfield gating) ---
; For domestic cities (0-31): if the player has no routes through this city
; (bit not set in entity_bits[$FF08EC]), decay city_data popularity by delta
; $FF08EC = entity_bits: 4 × longword, one per player. Bit N set = player has route through city N
; $FFBA80 = city_data: 89 cities × 4 entries × 2 bytes. [city*8 + player*2] = {popularity, baseline}
; $FF8824 = tab32_8824: 32-entry stride-2 table (one byte per domestic city)
    movea.l  #$00FF8824,a2      ; a2 -> tab32_8824 stride-2 table (domestic city modifiers)
    clr.w   d2                  ; d2 = city index (0-31)
l_27c3a:
; Compute city_data address for city d2, player d4:
; offset = city_index * 8 + player_index * 2 (stride-2 player offset within city block)
    move.w  d2, d0
    lsl.w   #$3, d0             ; city_index * 8 (each city has 4 entries × 2 bytes)
    move.w  d4, d1
    add.w   d1, d1              ; player_index * 2 (word stride per player)
    add.w   d1, d0
    movea.l  #$00FFBA80,a0      ; city_data base
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> city_data[city_index][player_index] = {pop, base}
; Test entity_bits bit for this player/city: bit = 1<<city_index, longword = $FF08EC[player_index*4]
    moveq   #$0,d0
    move.w  d2, d0              ; city_index
    moveq   #$1,d1
    lsl.l   d0, d1              ; d1 = 1 << city_index (bitmask for this city)
    move.l  d1, d0
    move.w  d4, d1
    lsl.w   #$2, d1             ; player_index * 4 (longword stride)
    movea.l  #$00FF08EC,a0      ; entity_bits base (player route bitfields)
    and.l   (a0,d1.w), d0       ; test if player has a route through this city
    bne.b   l_27c7c             ; bit set = player has route: skip popularity decay
; No route through this city: decay popularity
; delta = city_data[0] - city_data[1] (current popularity minus baseline)
; Decay both city_data[0] (city pop) and tab32_8824[city] (stride-2 table entry)
    moveq   #$0,d3
    move.b  (a3), d3            ; city_data.popularity (byte 0)
    moveq   #$0,d0
    move.b  $1(a3), d0          ; city_data.baseline (byte 1)
    sub.w   d0, d3              ; delta = popularity - baseline
    sub.b   d3, (a3)            ; city_data.popularity -= delta (decay toward baseline)
    sub.b   d3, $1(a2)          ; tab32_8824 entry -= delta (also decay stride-2 record)
l_27c7c:
    addq.l  #$2, a2             ; advance stride-2 table pointer (2 bytes per city entry)
    addq.w  #$1, d2             ; city_index++
    cmpi.w  #$20, d2            ; processed all 32 domestic cities?
    bcs.b   l_27c3a
; --- Phase: City popularity decay (cities 32-88: alliance/international) ---
; For alliance cities ($20-$58 = 32-88): no bitfield gating, always decay
    moveq   #$20,d2             ; d2 = city index, start at 32 (first international city)
l_27c88:
    move.w  d2, d0
    lsl.w   #$3, d0             ; city_index * 8
    move.w  d4, d1
    add.w   d1, d1              ; player_index * 2
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> city_data[city_index][player_index]
    moveq   #$0,d3
    move.b  (a3), d3            ; popularity
    moveq   #$0,d0
    move.b  $1(a3), d0          ; baseline
    sub.w   d0, d3              ; delta
    sub.b   d3, (a3)            ; decay popularity
    sub.b   d3, $1(a2)          ; decay tab32 entry
    addq.l  #$2, a2             ; advance stride-2 pointer
    addq.w  #$1, d2             ; city_index++
    cmpi.w  #$59, d2            ; processed all 89 cities ($59 = 89)?
    bcs.b   l_27c88
; --- Phase: Collect character revenue contributions ---
; CollectCharRevenue: iterates route slots, applies char income to player finances
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr CollectCharRevenue       ; credit route revenues to player financial totals
    addq.l  #$8, a7
; --- Phase: Apply city-popularity bonuses from char move records ---
; $FF02E8 = char move record table for this player (stride $14 = 20 bytes per slot)
; Each record: byte[0] = city_index ($FF = empty), byte[1] = popularity bonus
; For each valid record: add bonus to city_data[city_index][player_index] × 2 entries
    move.w  d4, d0
    mulu.w  #$14, d0            ; player_index * 20 (stride in $FF02E8 table)
    movea.l  #$00FF02E8,a0      ; char move record table base
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> this player's char move records
    clr.w   d2                  ; d2 = record index (0-4)
; $FFB9E8 = event_records: 4 × $20 bytes. d6 = player_index * $20 (offset computed earlier)
    movea.l  #$00FFB9E8,a0      ; event_records base
    lea     (a0,d6.w), a3       ; a3 -> event_records[player_index]
l_27ce8:
; Skip entries where city_index == $FF (empty/unused move slot)
    cmpi.b  #$ff, (a2)          ; move record byte 0 = city_index ($FF = empty)
    beq.b   l_27d14             ; empty -- skip
    tst.b   $1(a2)              ; move record byte 1 = popularity bonus
    beq.b   l_27d14             ; zero bonus -- nothing to apply
; Apply popularity bonus to city_data at offset [city_index * 2] in event_records:
; (stride-2 access: city_index * 2 offsets into the per-player 32-byte event record block)
    moveq   #$0,d0
    move.b  (a2), d0            ; city_index
    add.l   d0, d0              ; city_index * 2 (stride-2 word offset)
    movea.l d0, a0
    move.b  $1(a2), d0          ; popularity_bonus byte
    add.b   d0, (a3,a0.l)       ; event_records[player][city * 2 + 0] += bonus
    moveq   #$0,d0
    move.b  (a2), d0
    add.l   d0, d0
    movea.l d0, a0
    move.b  $1(a2), d0
    add.b   d0, $1(a3, a0.l)    ; event_records[player][city * 2 + 1] += bonus (mirrored slot)
l_27d14:
    addq.l  #$4, a2             ; advance to next 4-byte char move record
    addq.w  #$1, d2
    cmpi.w  #$5, d2             ; 5 records per player
    bcs.b   l_27ce8
; --- Phase: Apply accumulated event_record bonuses to player stats (16 entries) ---
; event_records[player]: stride-2 walk, 16 entries. Each entry: byte[1] = accumulated bonus
; ApplyCharBonus: applies the bonus for stat d2 to player d4's financial/stat records
    movea.l  #$00FFB9E8,a0
    lea     (a0,d6.w), a2       ; a2 -> event_records[player_index]
    clr.w   d2                  ; d2 = stat index (0-15)
l_27d2a:
    moveq   #$0,d0
    move.b  $1(a2), d0          ; event_record byte 1 = accumulated bonus
    tst.w   d0
    ble.b   l_27d48             ; zero or negative: no bonus to apply
    moveq   #$0,d0
    move.w  d2, d0              ; stat/slot index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr ApplyCharBonus           ; apply char stat bonus for this entry to player stats
    addq.l  #$8, a7
l_27d48:
    addq.l  #$2, a2             ; stride-2 advance (2 bytes per entry in event_records)
    addq.w  #$1, d2             ; stat_index++
    cmpi.w  #$10, d2            ; 16 entries per player record
    bcs.b   l_27d2a
; --- Phase: Initialise quarter start state for this player ---
    moveq   #$0,d0
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr (InitQuarterStart,PC)    ; set up quarter counters, reset accumulators for new quarter
    nop
    addq.l  #$4, a7
    movem.l (a7)+, d2-d6/a2-a3
    rts
