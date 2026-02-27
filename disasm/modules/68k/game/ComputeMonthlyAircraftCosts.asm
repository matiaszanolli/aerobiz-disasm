; ============================================================================
; ComputeMonthlyAircraftCosts -- Compute per-player monthly aircraft operating costs from hub city, aircraft class stats, and scenario multipliers
; 1002 bytes | $00BC84-$00C06D
;
; No arguments. Iterates all 4 players, each with up to 5 aircraft categories
; (d6 = 0..4). For each player+category, allocates cost "budget" (d4) and
; distributes it across aircraft types in the category range by calling
; CalcTypeDistance and RandRange.
;
; Key data structures:
;   a5  = player record pointer, walks $FF0018, $FF003C, $FF0060, $FF0084
;         (stride $24 = 36 bytes, incremented by addq/adda at bottom of outer loop)
;   a4  = CharTypeRangeTable entry ($05ECBC + region_cat*4)
;         4-byte struct: [range2_base, range2_size, range1_base, range1_size]
;         a4[+$00/+$01] = primary range  (used by overflow pass)
;         a4[+$02/+$03] = secondary range (used by main distribution pass)
;   a2  = tab32_8824 entry ($FF8824 + char_type*2)
;         stride-2 word-addressed byte table; [+$00]=current_budget, [+$01]=max_budget
;   a3  = char_stat_tab descriptor ($FF1298 + char_type*4)
;         byte[0] = field_offset within 57-byte stat record
;   -$2(a6) = player_index (outer loop counter, 0-3)
;   -$4(a6) = hub_city stat_field_offset (for home-city matching)
;   -$6(a6) = char_type range end (last type to process in inner loop)
;   -$a(a6) = city_data entry ptr ($FFBA80 + hub_city*8 + player_index*2)
;   d4  = remaining cost budget for this player+category
;   d5  = "committed" flag (1 = update applied, 0 = skip)
;   d6  = aircraft category index (0-4, drives RangeLookup for each pass)
;   d7  = hub_city_sum mod 4 -- random seed rotator for RandRange calls
; ============================================================================
ComputeMonthlyAircraftCosts:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)

; --- Phase: Compute hub_city_sum mod 4 as the random phase offset ---
; Sum all 4 players' hub_city bytes (player_record[+$01]), then mod 4.
; This gives d7 = a rotating offset (0-3) used as a "phase" to stagger
; which aircraft category gets the random cost spike each month.
    movea.l  #$00FF0018,a5      ; a5 = player_records base ($FF0018)
    clr.w   d7                  ; d7 = hub_city_sum accumulator
    clr.w   -$2(a6)            ; -$2(a6) = loop counter (0-3)
.l0bc98:
    moveq   #$0,d0
    move.b  $1(a5), d0          ; player_record[+$01] = hub_city index
    add.w   d0, d7              ; accumulate hub_city indices
    addq.w  #$1, -$2(a6)
    cmpi.w  #$4, -$2(a6)       ; processed all 4 players?
    blt.b   .l0bc98
    ; hub_city_sum mod 4 -> d7 (drives category-phase for RandRange)
    move.w  d7, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d0, d7              ; d7 = (sum of hub_cities) mod 4

; --- Phase: Outer loop -- iterate all 4 players ---
; For each player, compute the initial cost budget d4 from the hub city's
; stat record and the current quarter modifier, then distribute it.
    movea.l  #$00FF0018,a5      ; reset a5 to first player record
    clr.w   -$2(a6)            ; -$2(a6) = player_index = 0
.l0bcc4:
    ; Load hub_city_stat_field_offset: char_stat_tab[$FF1298][hub_city*4][+$00]
    ; = field offset (0-$38) within the player's 57-byte stat record.
    ; This identifies which stat field corresponds to the hub city.
    moveq   #$0,d0
    move.b  $1(a5), d0          ; player_record[+$01] = hub_city
    lsl.w   #$2, d0             ; hub_city * 4 (descriptor stride in char_stat_tab)
    movea.l  #$00FF1298,a0      ; char_stat_tab base ($FF1298)
    move.b  (a0,d0.w), d0       ; descriptor[hub_city*4][+$00] = field_offset
    andi.l  #$ff, d0
    move.w  d0, -$4(a6)        ; -$4(a6) = hub_city stat_field_offset

    ; Load tab32_8824 entry for the hub city: $FF8824 + hub_city*2 (stride-2 table).
    ; tab32_8824[+$00] = current_budget byte, [+$01] = max_budget byte.
    moveq   #$0,d0
    move.b  $1(a5), d0          ; hub_city
    add.w   d0, d0              ; hub_city * 2 (stride-2 word index)
    movea.l  #$00FF8824,a0      ; tab32_8824 base ($FF8824)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = tab32_8824 entry for hub_city

    ; Compute city_data pointer: $FFBA80 + hub_city*8 + player_index*2
    ; city_data is 89 cities * 4 entries * 2 bytes; player_index selects the entry.
    ; The formula: hub_city * 8 = hub_city * 4_entries * 2_bytes = column of the city row.
    moveq   #$0,d0
    move.b  $1(a5), d0          ; hub_city
    lsl.w   #$3, d0             ; hub_city * 8
    move.w  -$2(a6), d1        ; player_index
    add.w   d1, d1              ; player_index * 2 (word stride)
    add.w   d1, d0
    movea.l  #$00FFBA80,a0      ; city_data base ($FFBA80)
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)        ; -$a(a6) = city_data entry ptr for this player+city

    ; --- Compute initial cost budget d4 ---
    ; base_val = tab32_8824[+$00] (current_budget byte), rounded to half (signed).
    moveq   #$0,d0
    move.b  (a2), d0            ; tab32_8824[+$00] = current_budget
    bge.b   .l0bd1a             ; >= 0 -> no rounding correction
    addq.l  #$1, d0             ; add 1 for signed-right-shift rounding (negative)
.l0bd1a:
    asr.l   #$1, d0             ; halved: base_val / 2
    move.l  d0, d4              ; d4 = base_val / 2 (initial budget candidate)

    ; Compare against (current - max): tab32_8824[+$00] - tab32_8824[+$01]
    ; If base_val/2 >= (current - max), use (current - max) as the budget;
    ; otherwise use base_val/2. This caps the budget at the available headroom.
    moveq   #$0,d0
    move.b  (a2), d0            ; tab32_8824[+$00] = current_budget
    moveq   #$0,d1
    move.b  $1(a2), d1          ; tab32_8824[+$01] = max_budget
    sub.l   d1, d0              ; d0 = current - max (headroom, usually negative)
    cmp.l   d0, d4              ; d4 (base/2) >= headroom?
    bge.b   .l0bd3a             ; yes -> use headroom
    ; Use base_val/2 (rounded).
    moveq   #$0,d0
    move.b  (a2), d0
    bge.b   .l0bd36
    addq.l  #$1, d0
.l0bd36:
    asr.l   #$1, d0             ; base_val / 2
    bra.b   .l0bd46
.l0bd3a:
    ; Use (current - max) directly.
    moveq   #$0,d0
    move.b  (a2), d0            ; current_budget
    moveq   #$0,d1
    move.b  $1(a2), d1          ; max_budget
    sub.l   d1, d0              ; headroom = current - max

.l0bd46:
    ; Apply quarterly cost multiplier to d4.
    ; quarter = $FF0004 (word). Formula: factor = $64 - quarter*(4*quarter+1)*2
    ; = $64 - quarter*(4q+1)*2. For quarter 0: factor=$64 (100%), quarter 3: reduced.
    ; This scales costs down in later quarters as efficiency improves.
    move.w  d0, d4              ; d4 = headroom or base/2
    move.w  ($00FF0004).l, d0   ; current quarter (0-3)
    ext.l   d0
    move.l  d0, d1              ; save quarter
    lsl.l   #$2, d0             ; quarter * 4
    add.l   d1, d0              ; quarter * 5 = quarter*(4+1)
    add.l   d0, d0              ; quarter * 10 = quarter*(4+1)*2
    moveq   #$64,d1             ; $64 = 100
    sub.l   d0, d1              ; factor = 100 - quarter*10
    move.l  d1, d0              ; d0 = factor
    move.w  d4, d1
    ext.l   d1                  ; d1 = cost_basis
    jsr Multiply32              ; d0 = cost_basis * factor
    moveq   #$64,d1             ; divide by 100
    jsr SignedDiv               ; d0 = (cost_basis * factor) / 100
    move.w  d0, d4              ; d4 = scaled cost

    ; Compute the minimum floor: $32 - quarter*3.
    ; For quarter 0: floor=$32 (50%). For quarter 3: floor=$32-9=$29 (41%).
    move.w  ($00FF0004).l, d0   ; quarter
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0              ; quarter * 2
    add.l   d1, d0              ; quarter * 3
    moveq   #$32,d1             ; $32 = 50
    sub.l   d0, d1              ; floor = 50 - quarter*3
    move.l  d1, d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0              ; floor > scaled_cost?
    ble.b   .l0bd94             ; no -> use scaled_cost
    move.w  d4, d0
    ext.l   d0                  ; use scaled_cost (d4)
    bra.b   .l0bda8
.l0bd94:
    ; floor <= scaled_cost: use the floor value (minimum cost guarantee).
    move.w  ($00FF0004).l, d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0              ; quarter * 3
    moveq   #$32,d1             ; $32 = 50
    sub.l   d0, d1              ; floor = 50 - quarter*3
    move.l  d1, d0

.l0bda8:
    ; d4 = final cost budget. Apply to tab32_8824 and city_data.
    move.w  d0, d4
    add.b   d4, $1(a2)          ; tab32_8824[+$01] += d4 (accumulate into max_budget)
    movea.l -$a(a6), a0        ; restore city_data entry ptr
    move.b  d4, (a0)            ; city_data[player_index] = d4 (write cost)

    ; Determine the aircraft region category for this player's hub city.
    ; RangeLookup(hub_city) -> category 0-6 (CharTypeRangeTable index).
    moveq   #$0,d0
    move.b  $1(a5), d0          ; hub_city
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup             ; -> d0 = aircraft_region_category
    addq.l  #$4, a7
    move.w  d0, d3              ; d3 = region_category
    lsl.w   #$2, d0             ; category * 4 (4 bytes per CharTypeRangeTable entry)
    movea.l  #$0005ECBC,a0      ; CharTypeRangeTable ($05ECBC) -- 7 entries * 4 bytes
    lea     (a0,d0.w), a0
    movea.l a0, a4              ; a4 = CharTypeRangeTable[region_category]
    clr.w   d6                  ; d6 = aircraft_category_pass (0-4, inner loop counter)

; --- Phase: Inner distribution loop -- 5 passes (d6 = 0..4) ---
; Each pass distributes a portion of d4 across one sub-range of aircraft types.
; d7 is advanced +1 (mod 4) each pass to rotate the random-seed phase.
.l0bdd8:
    addq.w  #$1, d7             ; advance phase counter
    cmpi.w  #$4, d7
    blt.b   .l0bde2
    clr.w   d7                  ; wrap d7 at 4 (mod 4)

.l0bde2:
    ; Load secondary range from a4: a4[+$02] = range_start, a4[+$03] = range_count.
    ; char_stat_tab index = range_start * 4; tab32_8824 index = range_start * 2.
    ; The inner type scan covers types range_start to (range_start + range_count - 1).
    moveq   #$0,d0
    move.b  $2(a4), d0          ; CharTypeRangeTable[+$02] = secondary range_start
    lsl.w   #$2, d0             ; range_start * 4 (char_stat_tab stride)
    movea.l  #$00FF1298,a0      ; char_stat_tab base ($FF1298)
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 = char_stat_tab entry for range_start
    moveq   #$0,d0
    move.b  $2(a4), d0          ; range_start
    add.w   d0, d0              ; range_start * 2 (tab32_8824 stride)
    movea.l  #$00FF8824,a0      ; tab32_8824 ($FF8824)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = tab32_8824 entry for range_start
    ; Compute range_end = range_start + range_count.
    moveq   #$0,d0
    move.b  $2(a4), d0          ; range_start
    moveq   #$0,d1
    move.b  $3(a4), d1          ; range_count
    add.w   d1, d0
    move.w  d0, -$6(a6)        ; -$6(a6) = range_end (exclusive)
    moveq   #$0,d3
    move.b  $2(a4), d3          ; d3 = current char_type (starts at range_start)
    bra.w   .l0bf06             ; enter type scan loop (test first)

; --- Type scan loop (secondary range: a4[+$02]/a4[+$03]) ---
.l0be26:
    tst.w   d4                  ; any budget remaining?
    ble.w   .l0bf0e             ; no -> skip to overflow check

    ; CalcTypeDistance(hub_city, char_type): measure how far this char type is
    ; from the player's hub city. Returns 0=same, 1=adjacent, 2+=distant.
    ; If distance >= 2, this type is irrelevant for this hub -> skip.
    moveq   #$0,d0
    move.b  $1(a5), d0          ; hub_city (player_record[+$01])
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; char_type (current type in range)
    jsr CalcTypeDistance        ; -> d0 = distance (0=local, 1=regional, 2+=remote)
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0bf00             ; distance >= 2 -> skip this type

    ; Load city_data for this char_type:
    ; address = $FFBA80 + char_type*8 + player_index*2
    move.w  d3, d0
    lsl.w   #$3, d0             ; char_type * 8
    move.w  -$2(a6), d1        ; player_index
    add.w   d1, d1              ; player_index * 2
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)        ; -$a(a6) = city_data ptr for this type+player

    ; Compute available allocation: d2 = min(current - max, $E)
    ; cap at $E (14) = max aircraft slots distributable per type per pass.
    clr.w   d5                  ; d5 = "commit" flag = 0
    moveq   #$0,d2
    move.b  (a2), d2            ; tab32_8824[+$00] = current_budget
    moveq   #$0,d0
    move.b  $1(a2), d0          ; tab32_8824[+$01] = max_budget
    sub.w   d0, d2              ; d2 = current - max (allocation delta)
    cmpi.w  #$e, d2             ; > $E (14)?
    ble.b   .l0be7e
    moveq   #$E,d2              ; clamp to $E (14 max slots per pass)
    bra.b   .l0be8c
.l0be7e:
    ; Recompute signed delta (full precision).
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2                  ; sign-extend for proper comparison

.l0be8c:
    ; d2 = min(d4, d2): don't exceed remaining budget.
    cmp.w   d2, d4
    bge.b   .l0be94
    move.w  d4, d0              ; d0 = d4 (budget cap)
    bra.b   .l0be96
.l0be94:
    move.w  d2, d0              ; d0 = d2 (allocation cap)
.l0be96:
    ext.l   d0
    move.w  d0, d2              ; d2 = final allocation for this type

    ; Check if this type's stat_field_offset matches the hub_city's stat_field_offset
    ; (i.e., this type IS the hub city's type).
    moveq   #$0,d0
    move.b  (a3), d0            ; char_stat_tab[char_type*4][+$00] = field_offset
    move.w  -$4(a6), d1        ; hub_city stat_field_offset
    ext.l   d1
    cmp.l   d1, d0              ; same stat field?
    bne.b   .l0bec2             ; no -> different type branch

    ; Same type as hub city. If this is the first pass (d6 == 0), deterministic
    ; allocation: RandRange(d2/2, d2) for a spread around half.
    tst.w   d6
    bne.b   .l0beee             ; not first pass -> skip deterministic
    moveq   #$1,d5              ; d5 = 1 -> will commit
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; RandRange upper bound = d2
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bebc
    addq.l  #$1, d0             ; round for signed halving
.l0bebc:
    asr.l   #$1, d0             ; lower bound = d2 / 2
    move.l  d0, -(a7)
    bra.b   .l0bee4

.l0bec2:
    ; Different type from hub city: only allocate on passes where
    ; char_type mod 4 == d7 (the rotating phase). This staggers which
    ; off-hub type gets budget each month.
    tst.w   d6
    ble.b   .l0beee             ; first pass -> skip off-hub types
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod               ; d0 = char_type mod 4
    move.w  d7, d1
    ext.l   d1                  ; d1 = current phase
    cmp.l   d1, d0              ; phase match?
    bne.b   .l0beee             ; no -> skip this type this pass
    moveq   #$1,d5              ; d5 = 1 -> will commit
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; RandRange upper bound = d2
    clr.l   -(a7)               ; RandRange lower bound = 0

.l0bee4:
    jsr RandRange               ; -> d0 = random allocation in [lower, upper]
    addq.l  #$8, a7
    move.w  d0, d2              ; d2 = randomised allocation

.l0beee:
    ; Commit the allocation if d5 == 1.
    cmpi.w  #$1, d5
    bne.b   .l0bf00             ; d5 != 1 -> skip write
    add.b   d2, $1(a2)          ; tab32_8824[+$01] += d2 (add to max_budget)
    movea.l -$a(a6), a0
    move.b  d2, (a0)            ; city_data[player_index] = d2
    sub.w   d2, d4              ; deduct from remaining budget

.l0bf00:
    addq.l  #$4, a3             ; advance char_stat_tab ptr to next type (4 bytes/entry)
    addq.l  #$2, a2             ; advance tab32_8824 ptr to next type (2 bytes/entry)
    addq.w  #$1, d3             ; next char_type in range

.l0bf06:
    cmp.w   -$6(a6), d3         ; d3 < range_end?
    blt.w   .l0be26             ; yes -> continue type scan

; --- Overflow check after secondary range scan ---
; If budget still remaining (d4 > 0), try primary range (a4[+$00]/a4[+$01]).
.l0bf0e:
    tst.w   d4
    ble.w   .l0c048             ; d4 <= 0 -> no overflow, advance to next pass

    ; Load primary range: a4[+$00] = primary range_start, a4[+$01] = range_count.
    moveq   #$0,d0
    move.b  (a4), d0            ; CharTypeRangeTable[+$00] = primary range_start
    lsl.w   #$2, d0             ; * 4
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 = char_stat_tab for primary range_start
    moveq   #$0,d0
    move.b  (a4), d0            ; primary range_start
    add.w   d0, d0              ; * 2
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = tab32_8824 for primary range_start
    moveq   #$0,d0
    move.b  (a4), d0            ; primary range_start
    moveq   #$0,d1
    move.b  $1(a4), d1          ; primary range_count
    add.w   d1, d0
    move.w  d0, -$6(a6)        ; range_end for primary scan
    moveq   #$0,d3
    move.b  (a4), d3            ; d3 = current char_type = primary range_start
    bra.w   .l0c040             ; enter primary type scan loop (test first)

; --- Primary range type scan (overflow distribution) ---
.l0bf50:
    tst.w   d4
    ble.w   .l0c048             ; budget exhausted -> advance pass

    ; Skip if char_type == hub_city (already handled in secondary scan).
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a5), d1          ; hub_city
    cmp.l   d1, d0              ; is this the hub city's type?
    beq.w   .l0c03a             ; yes -> skip (already processed)

    ; CalcTypeDistance check (same as secondary scan).
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)           ; hub_city
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; char_type
    jsr CalcTypeDistance
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    bge.w   .l0c03a             ; distance >= 2 -> skip

    ; Compute city_data ptr and allocation bounds (same pattern as secondary scan).
    move.w  d3, d0
    lsl.w   #$3, d0             ; char_type * 8
    move.w  -$2(a6), d1        ; player_index
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$a(a6)
    clr.w   d5
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    ble.b   .l0bfb8
    moveq   #$E,d2
    bra.b   .l0bfc6
.l0bfb8:
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ext.l   d2

.l0bfc6:
    ; d2 = min(d4, d2)
    cmp.w   d2, d4
    bge.b   .l0bfce
    move.w  d4, d0
    bra.b   .l0bfd0
.l0bfce:
    move.w  d2, d0
.l0bfd0:
    ext.l   d0
    move.w  d0, d2

    ; Same hub-type and phase-match logic as secondary scan.
    moveq   #$0,d0
    move.b  (a3), d0            ; stat_field_offset
    move.w  -$4(a6), d1
    ext.l   d1
    cmp.l   d1, d0              ; hub-type match?
    bne.b   .l0bffc
    tst.w   d6
    bne.b   .l0c028             ; not first pass -> skip
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    bge.b   .l0bff6
    addq.l  #$1, d0
.l0bff6:
    asr.l   #$1, d0
    move.l  d0, -(a7)
    bra.b   .l0c01e
.l0bffc:
    tst.w   d6
    ble.b   .l0c028
    move.w  d3, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l0c028
    moveq   #$1,d5
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)

.l0c01e:
    jsr RandRange
    addq.l  #$8, a7
    move.w  d0, d2

.l0c028:
    cmpi.w  #$1, d5
    bne.b   .l0c03a             ; not committed -> advance
    add.b   d2, $1(a2)          ; tab32_8824[+$01] += d2
    movea.l -$a(a6), a0
    move.b  d2, (a0)            ; city_data[player_index] = d2
    sub.w   d2, d4              ; deduct from budget

.l0c03a:
    addq.l  #$4, a3
    addq.l  #$2, a2
    addq.w  #$1, d3

.l0c040:
    cmp.w   -$6(a6), d3         ; d3 < primary range_end?
    blt.w   .l0bf50

; --- Advance pass counter and outer loop control ---
.l0c048:
    addq.w  #$1, d6             ; d6++ (next aircraft category pass)
    cmpi.w  #$5, d6             ; done all 5 passes (0-4)?
    blt.w   .l0bdd8             ; no -> next pass

    ; Advance to next player: a5 += $24 (stride to next player record).
    moveq   #$24,d0
    adda.l  d0, a5              ; a5 += $24 -> next player record
    addq.w  #$1, -$2(a6)       ; player_index++
    cmpi.w  #$4, -$2(a6)       ; processed all 4 players?
    blt.w   .l0bcc4             ; no -> next player

; --- Epilogue ---
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
