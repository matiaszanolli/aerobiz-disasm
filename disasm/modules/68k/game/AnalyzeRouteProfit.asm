; ============================================================================
; AnalyzeRouteProfit -- Computes expected route revenue for all players by combining char stats, city popularity, game-turn scaling, and route-slot assignment counts; updates per-player revenue forecast buffers and deducts total costs from cash balance.
; 824 bytes | $029580-$0298B7
;
; Called from GameLogic2 each frame as part of the route profitability analysis pass.
; Has four distinct phases:
;
;   Phase 1 (outer loop: 89 stats x 4 players):
;     For each stat_type / city combination where the tab32_8824 entry is active,
;     compute a revenue forecast from GetCharStat + popularity + time-ramp and
;     accumulate into expense_tab_a[player]+$00 (first word).
;
;   Phase 2 (4 players x 7 aircraft slots):
;     For each aircraft slot with a valid BitFieldSearch result, compute an
;     aircraft-weighted revenue contribution and add to expense_tab_a[player]+$02.
;
;   Phase 3 (4 players x 4 route entries per player in $FF0338):
;     For each active $FF0338 entry (slot_type_flags[+$01]==1), run GetCharStat
;     and accumulate into route-slot field +$04 and expense_tab_a[player]+$04.
;
;   Phase 4 (4 players):
;     Call CalcRevenue 3 times per player (for aircraft-type sub-categories) to
;     populate expense_tab_b ($FF03F0) words +$00/+$02/+$04.
;
;   Phase 5 (4 players):
;     Sum all six cost components (3 from expense_tab_a, 3 from expense_tab_b)
;     and subtract from player cash (+$06 of player record).
;
; Frame layout:
;   -$4(a6) = walking ptr into tab32_8824 ($FF8824): stride-2 32-entry table
; ============================================================================
AnalyzeRouteProfit:
    link    a6,#-$4
    movem.l d2-d5/a2-a5, -(a7)

; --- Phase 1: Zero expense_tab_a ($FF0290) ---
    ; expense_tab_a: 4 players * 6 bytes = $18 bytes ($FF0290-$FF02A7)
    pea     ($0018).w                  ; size = $18 bytes
    clr.l   -(a7)                      ; fill value = 0
    pea     ($00FF0290).l              ; dest = expense_tab_a ($FF0290)
    jsr MemFillByte
    lea     $c(a7), a7

; --- Phase 1a: Stat x city x player revenue forecast loop ---
    ; Outer loop: 89 stat_types (d4 = 0..$58, one per city in char_stat_tab)
    ; A3 walks char_stat_tab at $FF1298 in steps of 4 bytes (one descriptor per stat).
    movea.l  #$00FF1298,a3             ; a3 = char_stat_tab base ($FF1298): 89 * 4-byte descriptors
    ; -$4(a6): walking ptr into tab32_8824 ($FF8824), stride +2 per stat iteration
    ; tab32_8824: 32-entry stride-2 byte table; byte[1] of each entry = activity flag
    move.l  #$ff8824, -$4(a6)          ; init ptr to tab32_8824[0]
    clr.w   d4                         ; d4 = stat_type index (0..88)

l_295ae:
    movea.l -$4(a6), a0                ; a0 = &tab32_8824[stat_type]
    tst.b   $1(a0)                     ; tab32_8824[stat_type]+$01: activity flag
    beq.w   l_2968c                    ; 0 = inactive stat: skip all 4 players

    ; For this stat_type: iterate all 4 players
    movea.l  #$00FF0290,a4             ; a4 = expense_tab_a base ($FF0290; stride 6/player)
    ; city_data 2D index: city_data[$FFBA80 + stat_type*8 + player_index*2]
    ; stat_type*8 = lsl.w #3, player_index*2 = add.w d1,d1
    move.w  d4, d0
    lsl.w   #$3, d0                    ; d0 = stat_type * 8 (city_data row stride)
    movea.l  #$00FFBA80,a0             ; city_data base ($FFBA80): 89 cities * 8 bytes each
    lea     (a0,d0.w), a0              ; a0 -> city_data row for stat_type
    movea.l a0, a2                     ; a2 = city row ptr (walks +2 per player)
    movea.l  #$00FF0018,a5             ; a5 = player_records base ($FF0018)
    clr.w   d3                         ; d3 = player_index (0..3)

l_295d8:
    ; Skip players where city data byte is zero (city not active for this player)
    tst.b   (a2)                       ; city_data[stat_type][player_index] = popularity byte
    beq.w   l_2967a                    ; 0 = player not present in this city

    ; GetCharStat(stat_type, player_index): returns player's stat value for this city
    moveq   #$0,d0
    move.w  d4, d0                     ; arg2 = stat_type (d4)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index (d3)
    move.l  d0, -(a7)
    jsr GetCharStat                    ; d0 = char stat byte for (player, stat_type)
    addq.l  #$8, a7
    move.l  d0, d2
    ext.l   d2
    addq.l  #$2, d2                    ; d2 = stat_value + 2 (minimum bias = 2)
    move.l  d2, -(a7)                  ; push stat+2 for later multiply

    ; Compute quality divisor from char_stat_tab descriptor byte +$01
    ; descriptor[+$01] / $A (10): scale down the stat descriptor quality.
    moveq   #$0,d0
    move.b  $1(a3), d0                 ; d0 = stat descriptor byte +$01 (quality/scale)
    moveq   #$A,d1                     ; d1 = 10
    jsr SignedDiv                      ; d0 = descriptor_quality / 10
    cmpi.w  #$1, d0
    ble.b   l_29620                    ; <= 1: clamp to 1
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$A,d1
    jsr SignedDiv                      ; d0 = descriptor_quality / 10 (valid result)
    ext.l   d0
    bra.b   l_29622
l_29620:
    moveq   #$1,d0                     ; clamped quality divisor = 1
l_29622:
    ; d0 = quality_factor (clamped >= 1)
    moveq   #$0,d1
    move.b  (a2), d1                   ; d1 = city popularity byte at city_data[stat][player]
    andi.l  #$ffff, d1
    jsr Multiply32                     ; d0 = quality_factor * city_popularity
    move.l  (a7)+, d1                  ; d1 = stat+2 (popped from earlier push)
    jsr Multiply32                     ; d0 = quality_factor * popularity * (stat+2)

    ; Scale by time ramp: (frame_counter/3 + $1E) * d0 / $64
    move.l  d0, d2
    asr.l   #$2, d2                    ; d2 = product >> 2 (pre-ramp divisor)
    move.w  ($00FF0006).l, d0          ; d0 = frame_counter ($FF0006: incremented each frame)
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv                      ; d0 = frame_counter / 3
    addi.l  #$1e, d0                   ; d0 += $1E (30): minimum ramp offset
    moveq   #$0,d1
    move.w  d2, d1                     ; d1 = pre-ramp scaled product
    jsr Multiply32                     ; d0 = ramp * product
    moveq   #$64,d1                    ; d1 = $64 (100): normalize to percentage
    jsr SignedDiv                      ; d0 = forecast / 100
    move.w  d0, d2
    cmpi.w  #$1, d2
    bls.b   l_29674                    ; <= 1: clamp to 1
    moveq   #$0,d0
    move.w  d2, d0                     ; d0 = forecast (valid)
    bra.b   l_29676
l_29674:
    moveq   #$1,d0                     ; clamped forecast = 1
l_29676:
    move.w  d0, d2
    add.w   d2, (a4)                   ; expense_tab_a[player]+$00 += forecast

l_2967a:
    addq.l  #$6, a4                    ; a4 += 6 (next player in expense_tab_a, stride 6)
    addq.l  #$2, a2                    ; a2 += 2 (next player entry in city_data row)
    moveq   #$24,d0
    adda.l  d0, a5                     ; a5 += $24 (next player_record, stride 36)
    addq.w  #$1, d3                    ; player_index++
    cmpi.w  #$4, d3
    bcs.w   l_295d8                    ; loop while player_index < 4

l_2968c:
    ; Advance to next stat_type
    addq.l  #$4, a3                    ; a3 += 4 (next char_stat_tab descriptor)
    addq.l  #$2, -$4(a6)              ; tab32_8824 ptr += 2 (stride-2 table advance)
    addq.w  #$1, d4                    ; stat_type++
    cmpi.w  #$59, d4                   ; $59 = 89: total city/stat count
    bcs.w   l_295ae                    ; loop while stat_type < 89

; --- Phase 2: Aircraft slot x player revenue loop ---
    ; For each player, scan up to 7 aircraft slots via BitFieldSearch.
    ; BitFieldSearch(slot_index, player_index) returns the stat_type for that slot,
    ; or $FF if no entry. The result feeds a char stat -> revenue calculation
    ; that accumulates into expense_tab_a[player]+$02.
    movea.l  #$00FF0018,a5             ; a5 = player_records base
    movea.l  #$00FF0290,a4             ; a4 = expense_tab_a base
    clr.w   d3                         ; d3 = player_index (0..3)

l_296aa:
    clr.w   d5                         ; d5 = slot_index (0..6, up to 7 aircraft slots)

l_296ac:
    ; BitFieldSearch(slot_index, player_index): scan aircraft assignment bitfield
    moveq   #$0,d0
    move.w  d5, d0                     ; arg2 = slot_index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr BitFieldSearch                 ; d0 = stat_type for this slot, or $FF if empty
    addq.l  #$8, a7
    move.w  d0, d4                     ; d4 = stat_type result
    cmpi.w  #$ff, d4
    beq.b   l_2972a                    ; $FF = no aircraft in this slot: skip

    ; Load char_stat_tab descriptor for found stat_type
    move.w  d4, d0
    lsl.w   #$2, d0                    ; offset = stat_type * 4
    movea.l  #$00FF1298,a0             ; char_stat_tab ($FF1298)
    lea     (a0,d0.w), a0
    movea.l a0, a3                     ; a3 = descriptor for stat_type (d4)

    ; GetCharStat(stat_type, player_index)
    moveq   #$0,d0
    move.w  d4, d0                     ; arg2 = stat_type
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr GetCharStat                    ; d0 = char stat for (player, slot_type)
    addq.l  #$8, a7
    addq.w  #$1, d0                    ; d0 = stat + 1 (minimum bias)
    move.l  d0, d2

    ; Multiply by scale: (descriptor[+$03] + $14) * (stat+1)
    moveq   #$0,d0
    move.b  $3(a3), d0                 ; d0 = descriptor scale byte +$03
    addi.w  #$14, d0                   ; d0 += $14 (20): base offset for aircraft scale
    mulu.w  d0, d2                     ; d2 = (stat+1) * (scale+20)

    ; Apply time ramp: same formula as Phase 1
    move.w  ($00FF0006).l, d0          ; frame_counter
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv                      ; / 3
    addi.l  #$1e, d0                   ; + 30
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32                     ; ramp * product
    moveq   #$64,d1
    jsr SignedDiv                      ; / 100
    move.w  d0, d2
    add.w   d2, $2(a4)                 ; expense_tab_a[player]+$02 += aircraft slot forecast

l_2972a:
    addq.w  #$1, d5                    ; slot_index++
    cmpi.w  #$7, d5                    ; 7 aircraft slots per player
    bcs.w   l_296ac                    ; loop while slot_index < 7
    moveq   #$24,d0
    adda.l  d0, a5                     ; next player_record
    addq.l  #$6, a4                    ; next expense_tab_a entry
    addq.w  #$1, d3                    ; player_index++
    cmpi.w  #$4, d3
    bcs.w   l_296aa                    ; loop while player_index < 4

; --- Phase 3: Route slot assignment ($FF0338) x player loop ---
    ; $FF0338: per-player route slot state table (stride $20 = 32 bytes per player).
    ; Each 8-byte entry: byte[0]=aircraft_code, byte[1]=slot_type_flags.
    ; Phase 3 scans 4 entries per player; accumulates into route-slot +$04 field
    ; and expense_tab_a[player]+$04.
    movea.l  #$00FF0018,a5             ; a5 = player_records base
    movea.l  #$00FF0290,a4             ; a4 = expense_tab_a base
    clr.w   d3                         ; d3 = player_index (0..3)

l_29752:
    ; Navigate to this player's $FF0338 block
    move.w  d3, d0
    lsl.w   #$5, d0                    ; offset = player_index * $20 (32 bytes/player)
    movea.l  #$00FF0338,a0             ; $FF0338: per-player route slot state table
    lea     (a0,d0.w), a0              ; a0 -> this player's $FF0338 block
    movea.l a0, a2                     ; a2 = walking 8-byte entry ptr
    clr.w   d4                         ; d4 = entry_index (0..3)

l_29764:
    cmpi.b  #$1, $1(a2)               ; slot_type_flags (+$01): 1 = active entry
    bne.b   l_297d0                    ; not active: skip

    ; Decode aircraft_code to stat_type via char_stat_tab
    moveq   #$0,d0
    move.b  (a2), d0                   ; byte[0] = aircraft_code
    lsl.w   #$2, d0                    ; offset = aircraft_code * 4 (char_stat_tab stride)
    movea.l  #$00FF1298,a0             ; char_stat_tab ($FF1298)
    lea     (a0,d0.w), a0
    movea.l a0, a3                     ; a3 = stat descriptor for aircraft_code

    ; GetCharStat(aircraft_code, player_index)
    moveq   #$0,d0
    move.b  (a2), d0                   ; arg2 = aircraft_code (used as stat_type)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr GetCharStat                    ; d0 = char stat for this entry
    addq.l  #$8, a7
    move.w  d0, d2                     ; d2 = stat value

    ; Revenue contribution: stat_descriptor[+$01] * (stat_value + 1)
    moveq   #$0,d0
    move.b  $1(a3), d0                 ; d0 = descriptor quality byte +$01
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d2, d1
    addq.l  #$1, d1                    ; d1 = stat + 1
    jsr Multiply32                     ; d0 = quality * (stat+1)

    ; Arithmetic right shift by 2 with rounding: (d0 < 0) ? d0+3 : d0 >> 2
    tst.l   d0
    bge.b   l_297b4                    ; non-negative: no rounding needed
    addq.l  #$3, d0                    ; negative: add 3 before asr for round-toward-zero
l_297b4:
    asr.l   #$2, d0                    ; d0 >>= 2 (divide by 4, round toward zero)
    move.w  d0, d2
    cmpi.w  #$1, d2
    bcc.b   l_297c2                    ; >= 1: valid
    moveq   #$1,d0                     ; clamp to 1
    bra.b   l_297c6
l_297c2:
    moveq   #$0,d0
    move.w  d2, d0                     ; d0 = contribution (valid)
l_297c6:
    move.w  d0, d2
    add.w   d2, $4(a2)                 ; $FF0338 entry +$04 += contribution (route slot field)
    add.w   d2, $4(a4)                 ; expense_tab_a[player]+$04 += contribution

l_297d0:
    addq.l  #$8, a2                    ; a2 += 8 (next 8-byte $FF0338 entry)
    addq.w  #$1, d4                    ; entry_index++
    cmpi.w  #$4, d4                    ; 4 entries per player
    bcs.b   l_29764                    ; loop while entry_index < 4
    moveq   #$24,d0
    adda.l  d0, a5                     ; next player_record
    addq.l  #$6, a4                    ; next expense_tab_a entry (stride 6)
    addq.w  #$1, d3                    ; player_index++
    cmpi.w  #$4, d3
    bcs.w   l_29752                    ; loop while player_index < 4

; --- Phase 4: CalcRevenue into expense_tab_b ($FF03F0) ---
    ; aircraft_assignment_tab at $FF0120: 4 players * 4 bytes
    ;   +$01 = aircraft class A count, +$02 = class B count, +$03 = class C count
    ; For each player, call CalcRevenue 3 times (one per aircraft sub-category 0/1/2),
    ; writing results into expense_tab_b ($FF03F0, stride $C per player):
    ;   word +$00 = revenue for sub-category 0 (class A)
    ;   word +$02 = revenue for sub-category 1 (class B)
    ;   word +$04 = revenue for sub-category 2 (class C)
    movea.l  #$00FF03F0,a3             ; a3 = expense_tab_b base ($FF03F0; stride $C/player)
    movea.l  #$00FF0120,a2             ; a2 = aircraft_assignment_tab ($FF0120; stride 4/player)
    clr.w   d3                         ; d3 = player_index (0..3)

l_297f8:
    ; Sub-category 0: aircraft class A count (+$01)
    moveq   #$0,d0
    move.b  $1(a2), d0                 ; d0 = aircraft_class_A count (+$01)
    move.l  d0, -(a7)                  ; arg3 = class_A count
    clr.l   -(a7)                      ; arg2 = sub_category = 0
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr CalcRevenue                    ; d0 = revenue for sub-category 0
    move.w  d0, (a3)                   ; expense_tab_b[player]+$00 = class A revenue

    ; Sub-category 1: aircraft class B count (+$02)
    moveq   #$0,d0
    move.b  $2(a2), d0                 ; d0 = aircraft_class_B count (+$02)
    move.l  d0, -(a7)                  ; arg3 = class_B count
    pea     ($0001).w                  ; arg2 = sub_category = 1
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr CalcRevenue                    ; d0 = revenue for sub-category 1
    move.w  d0, $2(a3)                 ; expense_tab_b[player]+$02 = class B revenue

    ; Sub-category 2: aircraft class C count (+$03)
    moveq   #$0,d0
    move.b  $3(a2), d0                 ; d0 = aircraft_class_C count (+$03)
    move.l  d0, -(a7)                  ; arg3 = class_C count
    pea     ($0002).w                  ; arg2 = sub_category = 2
    moveq   #$0,d0
    move.w  d3, d0                     ; arg1 = player_index
    move.l  d0, -(a7)
    jsr CalcRevenue                    ; d0 = revenue for sub-category 2
    lea     $24(a7), a7                ; pop 9 longwords ($24 bytes = all 3 CalcRevenue arg sets)
    move.w  d0, $4(a3)                 ; expense_tab_b[player]+$04 = class C revenue

    ; Advance to next player
    moveq   #$C,d0
    adda.l  d0, a3                     ; a3 += $C (next expense_tab_b entry, stride 12)
    addq.l  #$4, a2                    ; a2 += 4 (next aircraft_assignment_tab entry)
    addq.w  #$1, d3                    ; player_index++
    cmpi.w  #$4, d3
    bcs.b   l_297f8                    ; loop while player_index < 4

; --- Phase 5: Deduct total costs from each player's cash ---
    ; For each player sum all 6 cost words:
    ;   expense_tab_a[player]: +$00, +$02, +$04
    ;   expense_tab_b[player]: +$00, +$02, +$04
    ; Then subtract total from player_record+$06 (cash).
    movea.l  #$00FF0018,a5             ; a5 = player_records base
    movea.l  #$00FF0290,a4             ; a4 = expense_tab_a base
    movea.l  #$00FF03F0,a3             ; a3 = expense_tab_b base
    clr.w   d3                         ; d3 = player_index (0..3)

l_2986e:
    ; Sum expense_tab_a words: +$00 + +$02 + +$04
    moveq   #$0,d2
    move.w  (a4), d2                   ; expense_tab_a[player]+$00 (city stat forecast)
    moveq   #$0,d0
    move.w  $2(a4), d0                 ; expense_tab_a[player]+$02 (aircraft slot forecast)
    add.l   d0, d2
    moveq   #$0,d0
    move.w  $4(a4), d0                 ; expense_tab_a[player]+$04 (route slot contribution)
    add.l   d0, d2                     ; d2 = sum of all expense_tab_a components

    ; Sum expense_tab_b words: +$00 + +$02 + +$04
    moveq   #$0,d0
    move.w  (a3), d0                   ; expense_tab_b[player]+$00 (class A revenue cost)
    moveq   #$0,d1
    move.w  $2(a3), d1                 ; expense_tab_b[player]+$02 (class B revenue cost)
    add.l   d1, d0
    moveq   #$0,d1
    move.w  $4(a3), d1                 ; expense_tab_b[player]+$04 (class C revenue cost)
    add.l   d1, d0                     ; d0 = sum of all expense_tab_b components
    add.l   d0, d2                     ; d2 = total costs for this player

    sub.l   d2, $6(a5)                 ; player_record+$06 (cash) -= total_costs

    ; Advance all three table ptrs in lockstep
    moveq   #$24,d0
    adda.l  d0, a5                     ; next player_record (stride $24)
    addq.l  #$6, a4                    ; next expense_tab_a entry (stride 6)
    moveq   #$C,d0
    adda.l  d0, a3                     ; next expense_tab_b entry (stride $C)
    addq.w  #$1, d3                    ; player_index++
    cmpi.w  #$4, d3
    bcs.b   l_2986e                    ; loop while player_index < 4

    movem.l -$24(a6), d2-d5/a2-a5
    unlk    a6
    rts
