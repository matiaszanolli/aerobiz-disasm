; ============================================================================
; RecalcAllCharStats -- Accumulates weighted stat bonuses from all assigned chars; returns highest-scoring category index
; 624 bytes | $0369C0-$036C2F
; ============================================================================
RecalcAllCharStats:
    ; --- Phase: Setup ---
    ; Stack args: $8(a6)=player_index(d5), $e(a6)=search_start_slot(word, for BitFieldSearch)
    ; d5 = player_index (0-6)
    ; d7 = first char slot bit-index found by BitFieldSearch ($20+ = none found)
    ; d6 = route slot index walker (starts at d3 from FindCharSlot, walks the route list)
    ; d3 = char_type byte from route slot +$01 (used to select stat descriptor tables)
    ; d2 = computed bonus value (capped at $64=100, then inverted: 100-d2 = "remaining" score)
    ; d4 = entry count for inner stat-type loop (6 for char_type < $20, 4 for char_type >= $20)
    ; a3 = stat descriptor array ptr: $FF1704 (stride 6) for type < $20, $FF15A0 (stride 4) for type >= $20
    ; a4 = owner filter array ptr: $FF0420 (stride 6) or $FF0460 (stride 4) -- player ownership check
    ; a5 = stat_type descriptor ptr from ROM $5E31A (4-byte entries): +$03 = which accumulator (0/2/3)
    ; -$4(a6) = saved player_record ptr (for iterating route slot range)
    ; -$10(a6) = accumulator array (3 longs, 12 bytes, zeroed at start):
    ;   -$10(a6) = category-0 accumulator (stat_type +$03 == 0: primary)
    ;   -$8(a6)  = category-1 accumulator (stat_type +$03 == 2: secondary)
    ;   -$c(a6)  = category-2 accumulator (stat_type +$03 == 3: tertiary)
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5           ; d5 = player_index
    ; Compute player_record ptr and save: $FF0018 + player*$24
    move.w  d5, d0
    mulu.w  #$24, d0             ; d0 = player_index * $24 (player_record stride = 36 bytes)
    movea.l  #$00FF0018,a0       ; a0 = player_records base ($FF0018)
    lea     (a0,d0.w), a0        ; a0 = &player_records[player_index]
    move.l  a0, -$4(a6)          ; -$4(a6) = player_record ptr (saved for route slot bound check below)
    ; BitFieldSearch: find first assigned char slot for this player starting from $e(a6)
    moveq   #$0,d0
    move.w  $e(a6), d0           ; d0 = search_start_slot (second stack arg)
    move.l  d0, -(a7)            ; arg 2: start slot index
    moveq   #$0,d0
    move.w  d5, d0               ; d0 = player_index
    move.l  d0, -(a7)            ; arg 1: player_index
    jsr BitFieldSearch           ; $006EEA: scan bitfield for first slot >= start; d0 = slot index or $20+ if none
    move.w  d0, d7               ; d7 = first matching char slot index (or $20+ if not found)
    ; Zero-initialize the three 32-bit stat accumulators at -$10(a6)
    pea     ($000C).w            ; arg 3: byte count = $C (12 bytes = 3 longs)
    clr.l   -(a7)                ; arg 2: fill value = 0
    pea     -$10(a6)             ; arg 1: &accumulator_array = -$10(a6)
    jsr MemFillByte              ; zero all 3 accumulators
    lea     $14(a7), a7          ; clean 5 args (BitFieldSearch 2 + MemFillByte 3, plus saved from JSR setup)
    ; If no char slot found (d7 >= $20), skip all processing, go directly to winner scan
    cmpi.w  #$20, d7             ; d7 >= $20 = no valid char found
    bcc.w   l_36be4              ; skip to accumulator comparison phase
    ; FindCharSlot: resolve d7 (bit index from BitFieldSearch) to a route slot index for this player
    moveq   #$0,d0
    move.w  d7, d0               ; bit index from BitFieldSearch
    move.l  d0, -(a7)            ; arg 2: bit index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)            ; arg 1: player_index
    jsr FindCharSlot             ; $00759E: resolve char bit-index to route slot index; d0 = slot index or -1
    addq.l  #$8, a7
    move.w  d0, d3               ; d3 = first route slot index containing the char
    ext.l   d0
    moveq   #-$1,d1              ; -1 sentinel for "not found"
    cmp.l   d0, d1               ; d0 == -1?
    beq.w   l_36be4              ; yes: char not in any route slot, skip to accumulator scan
    ; Compute a2 = route_slots pointer for player's first char slot:
    ; &route_slots[player_index * $320 + slot_index * $14]
    move.w  d5, d0
    mulu.w  #$320, d0            ; d0 = player_index * $320 (per-player route area = 800 bytes)
    move.w  d3, d1
    mulu.w  #$14, d1             ; d1 = slot_index * $14 (route slot stride = 20 bytes)
    add.w   d1, d0               ; d0 = combined offset
    movea.l  #$00FF9A20,a0       ; a0 = route_slots base ($FF9A20)
    lea     (a0,d0.w), a0        ; a0 = &route_slots[player][slot]
    movea.l a0, a2               ; a2 = current route slot ptr (advances by $14 each iteration)
    move.w  d3, d6               ; d6 = current route slot index walker (starts at first slot)
    bra.w   l_36bbc              ; jump to loop pre-condition check
    ; =========================================================
    ; Outer loop: walks route slots for this player, accumulates weighted stat bonuses
    ; Condition at l_36bbc: continue if route_slot +$04 + +$05 > d6 (current player has more slots)
    ; =========================================================
l_36a52:
    ; Check route_slot +$00 (city_a index) against d7 (char slot bit index):
    ; if city_a > d7, we've passed the char's position in the slot ordering -> exit
    moveq   #$0,d0
    move.b  (a2), d0             ; route_slot +$00 = city_a index
    moveq   #$0,d1
    move.w  d7, d1               ; d1 = d7 (char slot bit index, upper bound)
    cmp.l   d1, d0               ; city_a > d7?
    bgt.w   l_36be4              ; yes: past the relevant slots, exit outer loop
    ; Check route_slot +$0A bit 1: status flag bit 1 = slot inactive/skip flag
    move.b  $a(a2), d0           ; route_slot +$0A = status_flags byte
    andi.l  #$2, d0              ; test bit 1 (0x02)
    bne.w   l_36bb6              ; bit set: slot inactive, skip bonus accumulation
    ; GetByteField4: extract 4-bit packed field from route_slot (returns char affinity/weight nibble)
    move.l  a2, -(a7)            ; arg: route slot ptr
    jsr GetByteField4            ; $0074E0: extract 4-bit field from packed byte in route slot
    addq.l  #$4, a7
    ; Look up affinity scale factor from FFA6B9 table (byte table, indexed by result * $C)
    mulu.w  #$c, d0              ; d0 *= $C (stride into affinity factor table)
    movea.l  #$00FFA6B9,a0       ; a0 = affinity factor table ($FFA6B9): byte per entry
    move.b  (a0,d0.w), d3        ; d3 = affinity factor byte
    andi.l  #$ff, d3             ; zero-extend
    mulu.w  #$a, d3              ; d3 *= $A (scale affinity factor: multiplier for Multiply32/SignedDiv)
    ; Compute bonus score: (route_slot +$10 * $64) / d3
    ; route_slot +$10 = char stat word (base performance rating for this slot)
    ; d3 = affinity-weighted divisor; lower d3 = less effective -> higher bonus
    moveq   #$0,d0
    move.w  $10(a2), d0          ; route_slot +$10 = char stat value (16-bit)
    moveq   #$64,d1              ; d1 = $64 = 100
    jsr Multiply32               ; d0 = stat * 100 (32-bit product)
    moveq   #$0,d1
    move.w  d3, d1               ; d1 = affinity factor (scaled)
    jsr SignedDiv                ; d0 = (stat * 100) / affinity_factor = effectiveness percentage
    move.w  d0, d2               ; d2 = raw effectiveness (0 to potentially >$64)
    ; Clamp d2 to maximum $64 (100%)
    cmpi.w  #$64, d2             ; d2 >= $64?
    bcc.b   l_36ab6              ; yes: clamp to $64
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = d2 (within range, use as-is)
    bra.b   l_36ab8
l_36ab6:
    moveq   #$64,d0              ; clamp to $64 = 100%
l_36ab8:
    move.w  d0, d2               ; d2 = clamped effectiveness (0-$64)
    ; Invert effectiveness: bonus = $64 - effectiveness (lower score = better char = more bonus)
    moveq   #$64,d0
    sub.w   d2, d0               ; d0 = $64 - d2 = inverted bonus (higher = char contributes less...)
    move.w  d0, d2               ; d2 = inverted bonus value (used as weight in Multiply32 below)
    ; Determine which stat descriptor table to use based on char_type byte (route_slot +$01)
    ; char_type < $20: use $FF1704 (stride 6, 6 entries per char); $FF0420 = owner filter (stride 6)
    ; char_type >= $20: use $FF15A0 (stride 4, 4 entries per char); $FF0460 = owner filter (stride 4)
    moveq   #$0,d3
    move.b  $1(a2), d3           ; route_slot +$01 = char_type byte
    cmpi.w  #$20, d3             ; char_type < $20?
    bcc.b   l_36af4              ; >= $20: use alternate tables
    ; char_type < $20: 6-entry tables at $FF1704 and $FF0420
    move.w  d3, d0
    mulu.w  #$6, d0              ; d0 = char_type * 6 (stride 6 bytes per char)
    movea.l  #$00FF1704,a0       ; a0 = stat descriptor table for small char types ($FF1704)
    lea     (a0,d0.w), a0        ; a0 = &stat_descriptor_tab[char_type] (6-byte aligned)
    movea.l a0, a3               ; a3 = stat descriptor ptr (inner loop walks this by +1 each iter)
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0       ; a0 = owner filter table for small char types ($FF0420, parallel to $FF1704)
    lea     (a0,d0.w), a0        ; a0 = &owner_filter_tab[char_type] (6-byte aligned)
    movea.l a0, a4               ; a4 = owner filter ptr (byte per entry = player index that owns this stat slot)
    moveq   #$6,d4               ; d4 = inner loop count = 6 entries
    bra.b   l_36b16
l_36af4:
    ; char_type >= $20: 4-entry tables at $FF15A0 and $FF0460
    move.w  d3, d0
    lsl.w   #$2, d0              ; d0 = char_type * 4 (stride 4 bytes per char)
    movea.l  #$00FF15A0,a0       ; a0 = stat descriptor table for large char types ($FF15A0)
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 = stat descriptor ptr
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0       ; a0 = owner filter table for large char types ($FF0460)
    lea     (a0,d0.w), a0
    movea.l a0, a4               ; a4 = owner filter ptr
    moveq   #$4,d4               ; d4 = inner loop count = 4 entries
l_36b16:
    clr.w   d3                   ; d3 = inner loop counter = 0
    bra.w   l_36bb0              ; jump to inner loop condition check
    ; =========================================================
    ; Inner loop: walks stat descriptor table (a3) and owner filter table (a4)
    ; For each entry that is active (a3 != $F) and owned by d5 (a4 == d5):
    ;   look up stat_type descriptor from ROM $5E31A, dispatch to correct accumulator
    ; =========================================================
l_36b1c:
    ; Skip entry if stat descriptor is $F (sentinel = no stat / end-of-active-entries)
    cmpi.b  #$f, (a3)            ; (a3) == $F = inactive/padding entry?
    beq.w   l_36baa              ; yes: skip this entry
    ; Skip entry if owner filter byte doesn't match current player (d5)
    moveq   #$0,d0
    move.b  (a4), d0             ; (a4) = required owner player index for this stat slot
    moveq   #$0,d1
    move.w  d5, d1               ; d1 = current player_index
    cmp.l   d1, d0               ; owner matches?
    bne.b   l_36baa              ; no: this stat entry belongs to a different player, skip
    ; Look up stat_type descriptor from ROM $5E31A: 4-byte entries indexed by stat_id * 4
    moveq   #$0,d0
    move.b  (a3), d0             ; (a3) = stat_id byte for this entry
    lsl.w   #$2, d0              ; d0 *= 4 (4-byte entry stride in ROM descriptor table)
    movea.l  #$0005E31A,a0       ; a0 = ROM stat_type descriptor table ($5E31A)
    lea     (a0,d0.w), a0        ; a0 = &stat_type_descriptor[stat_id]
    movea.l a0, a5               ; a5 = stat_type descriptor ptr (+$03 = accumulator index)
    ; Dispatch on descriptor +$03 (accumulator selector): 0 = primary, 2 = secondary, 3 = tertiary
    ; bonus = d2 (inverted effectiveness) * route_slot +$03 (char capacity/weight byte)
    tst.b   $3(a5)               ; +$03 == 0?
    bne.b   l_36b64              ; no: check for 2 or 3
    ; --- stat_type +$03 == 0: add bonus to category-0 accumulator (-$10(a6)) ---
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = bonus value
    moveq   #$0,d1
    move.b  $3(a2), d1           ; route_slot +$03 = char weight/capacity byte (multiplier)
    andi.l  #$ffff, d1           ; zero-extend (ensure no sign artifact from move.b)
    jsr Multiply32               ; d0 = bonus * char_weight (32-bit product)
    add.l   d0, -$10(a6)         ; category-0 accumulator += product (primary stat bonus)
    bra.b   l_36baa
l_36b64:
    ; --- stat_type +$03 == 2: add bonus to category-1 accumulator (-$8(a6)) ---
    cmpi.b  #$2, $3(a5)          ; +$03 == 2 (secondary accumulator)?
    bne.b   l_36b88              ; no: check for 3
    moveq   #$0,d0
    move.w  d2, d0               ; bonus value
    moveq   #$0,d1
    move.b  $3(a2), d1           ; route_slot +$03 = char weight byte
    andi.l  #$ffff, d1
    jsr Multiply32               ; d0 = bonus * weight
    add.l   d0, -$8(a6)          ; category-1 accumulator += product (secondary stat bonus)
    bra.b   l_36baa
l_36b88:
    ; --- stat_type +$03 == 3: add bonus to category-2 accumulator (-$c(a6)) ---
    cmpi.b  #$3, $3(a5)          ; +$03 == 3 (tertiary accumulator)?
    bne.b   l_36baa              ; no: unrecognized type, skip
    moveq   #$0,d0
    move.w  d2, d0               ; bonus value
    moveq   #$0,d1
    move.b  $3(a2), d1           ; route_slot +$03 = char weight byte
    andi.l  #$ffff, d1
    jsr Multiply32               ; d0 = bonus * weight
    add.l   d0, -$c(a6)          ; category-2 accumulator += product (tertiary stat bonus)
l_36baa:
    ; Advance inner loop pointers by 1 byte each (a3/a4 are parallel byte arrays)
    addq.l  #$1, a3              ; advance stat descriptor ptr
    addq.l  #$1, a4              ; advance owner filter ptr
    addq.w  #$1, d3              ; inner loop counter
l_36bb0:
    cmp.w   d4, d3               ; inner loop exhausted?
    bcs.w   l_36b1c              ; no: continue inner loop
l_36bb6:
    ; Advance to next route slot: a2 += $14, d6 += 1
    moveq   #$14,d0
    adda.l  d0, a2               ; a2 += $14 (advance to next route slot)
    addq.w  #$1, d6              ; d6 = next slot index
l_36bbc:
    ; Outer loop condition: continue while d6 < player_record +$04 + +$05 (total char slots for player)
    ; player_record +$04 = primary slot count, +$05 = secondary slot count
    movea.l -$4(a6), a0          ; a0 = player_record ptr (saved in setup)
    move.b  $4(a0), d0
    andi.l  #$ff, d0             ; d0 = player_record +$04 (primary slot count, byte)
    movea.l -$4(a6), a0
    move.b  $5(a0), d1
    andi.l  #$ff, d1             ; d1 = player_record +$05 (secondary slot count, byte)
    add.l   d1, d0               ; d0 = total slot count ($04 + $05)
    moveq   #$0,d1
    move.w  d6, d1               ; d1 = current slot index walker
    cmp.l   d1, d0               ; total > d6 (more slots to process)?
    bgt.w   l_36a52              ; yes: loop back to process next slot
    ; =========================================================
    ; Phase: Find highest accumulator and return its category index (0-2)
    ; d3 = running maximum value; d5 = index of category with highest accumulator; d2 = loop index
    ; =========================================================
l_36be4:
    moveq   #$0,d3               ; d3 = running maximum accumulator value = 0
    move.w  #$ff, d5             ; d5 = best category index = $FF (sentinel = no winner yet)
    clr.w   d2                   ; d2 = accumulator scan index (0-2)
l_36bec:
    ; Load accumulator[d2]: -$10(a6) + d2*4
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2 * 4 (long offset into accumulator array)
    move.l  -$10(a6, d0.w), d0  ; d0 = accumulator[d2] (32-bit)
    cmp.l   d3, d0               ; accumulator[d2] > current max?
    bls.b   l_36c02              ; no: keep current winner
    ; New maximum found: update max and winner index
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$10(a6, d0.w), d3  ; d3 = new maximum value
    move.w  d2, d5               ; d5 = index of new winner (0, 1, or 2)
l_36c02:
    addq.w  #$1, d2              ; advance scan index
    cmpi.w  #$3, d2              ; scanned all 3 accumulators?
    bcs.b   l_36bec              ; no: continue scan
    ; Normalize d5: if still $FF (no accumulator had any bonus), return 0
    ; Otherwise return d5 as-is (0, 1, or 2) via explicit cmpi chain
    tst.w   d5                   ; d5 == 0?
    bne.b   l_36c12              ; no: d5 is 1 or 2
    clr.w   d5                   ; d5 = 0 (category 0 = primary stat wins)
    bra.b   l_36c24
l_36c12:
    cmpi.w  #$1, d5              ; d5 == 1?
    bne.b   l_36c1c
    moveq   #$1,d5               ; d5 = 1 (category 1 = secondary stat wins)
    bra.b   l_36c24
l_36c1c:
    cmpi.w  #$2, d5              ; d5 == 2?
    bne.b   l_36c24              ; no match (d5 == $FF, no winner): fall through with $FF unchanged
    moveq   #$2,d5               ; d5 = 2 (category 2 = tertiary stat wins)
l_36c24:
    ; --- Phase: Epilogue -- return winning category index in d0 ---
    move.w  d5, d0               ; d0 = return value: 0=primary, 1=secondary, 2=tertiary, $FF=no winner
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
