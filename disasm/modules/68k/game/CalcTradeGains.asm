; ============================================================================
; CalcTradeGains -- Calculate net trade gains for a route slot by scoring char-code compatibility, multiplying by slot value, and applying a signed division.
; 892 bytes | $020000-$02037B
; ============================================================================
; --- Phase: Setup and route slot lookup ---
; d6 = slot index within route table, d7 = current player index
; a2 = pointer to current route slot ($FF9A20 area, stride $14)
; -$4(a6) = player record pointer ($FF0018 + player*$24)
CalcTradeGains:
; GetRouteSlotDetails: populate a2 with pointer to route slot data for slot d6
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (GetRouteSlotDetails,PC)
    nop
    addq.l  #$8, a7
; d4 = frequency value from slot (route slot +$03, returned from GetRouteSlotDetails)
    move.w  d0, d4
; --- Phase: Optional preliminary slot-value adjustment ---
; Check if this route belongs to an alliance city (player_record+$4 vs d7 player index)
    movea.l -$4(a6), a0
; player_record+$04 = domestic_slots count (used here as an alliance city indicator byte)
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
; If player_record+$4 > d7 (current player), skip slot-value adjustment
    cmp.l   d1, d0
    bgt.b   l_20076
; CalcSlotValue: compute value contribution for city_b (route slot +$01)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CalcSlotValue,PC)
    nop
    addq.l  #$8, a7
    move.l  d0, -(a7)
; CalcSlotValue: compute value contribution for city_a (route slot +$00)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr (CalcSlotValue,PC)
    nop
    addq.l  #$8, a7
; d2 = sum of both city value contributions
    add.l   (a7)+, d0
    move.w  d0, d2
; Adjust d3 (running gain): d3 = d3 * (d2 + $64) / $64
; ($64 = 100: converts the value sum into a percentage multiplier centered on 100%)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    addi.l  #$64, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
; --- Phase: Compute compatibility-adjusted revenue ---
l_20076:
; Snapshot current gross_revenue (+$08) to prev_revenue (+$12) at cycle start
    move.w  $8(a2), $12(a2)
; CharCodeScore: compute % compatibility between city_a and city_b character codes
; route slot +$00 = city_a char code, +$01 = city_b char code
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
; d2 = compatibility score (0-100%)
    move.w  d0, d2
; Compute: (ticket_price - compatibility_score) * $64 / compatibility_score + $32
; ticket_price = route slot +$04; the formula normalizes price vs compatibility
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$0,d1
    move.w  d2, d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr SignedDiv
; $32 = 50: bias the result to center at 50 (neutral profit ratio)
    addi.w  #$32, d0
; d5 = normalized price-vs-compatibility ratio (used later as base multiplier)
    move.w  d0, d5
; --- Phase: Weighted average stat calculation ---
; Choose between alliance-city stats ($FFBDE4) or char_stat_tab ($FF1298)
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
; If player_record+$4 > d7: use top-3 city stats from CalcCityStats output at $FFBDE4
    cmp.l   d1, d0
    ble.b   l_2012a
; --- Alliance-city path: use $FFBDE4 top-3 city stat records ---
; $FFBDE4 = CalcCityStats result area (top-3 city indices/weights, 4 bytes per entry)
; a5 = city pair pointer (a5[0] = city_a index, a5[2] = city_b index)
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
; a3 = $FFBDE4 entry for city_a
    movea.l a0, a3
    move.w  $2(a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
; a4 = $FFBDE4 entry for city_b
    movea.l a0, a4
; Weighted average = (a4[+3]*a4[+0] + a3[+3]*a3[+0]) / (a3[+0] + a4[+0])
; +$00 = city weight/count word, +$03 = city stat byte
    moveq   #$0,d0
    move.b  $3(a4), d0
    moveq   #$0,d1
    move.w  (a4), d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    moveq   #$0,d1
    move.w  (a3), d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.w  (a3), d1
    moveq   #$0,d2
    move.w  (a4), d2
    add.l   d2, d1
    jsr UnsignedDivide
    bra.w   l_201b0
; --- Standard path: use char_stat_tab descriptors at $FF1298 ---
; $FF1298 = 89 stat-type descriptors, 4 bytes each; indexed by char code * 4
l_2012a:
; a3 = char_stat_tab entry for city_a code (route slot +$00)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
; a4 = char_stat_tab entry for city_b code (route slot +$01)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
; Weighted average = (a4[+3]*a4[+1] + a3[+3]*a3[+1]) / (a3[+1] + a4[+1])
; descriptor +$01 = primary skill/rating byte, +$03 = cap/limit byte (DATA_STRUCTURES.md)
    moveq   #$0,d0
    move.b  $3(a4), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    andi.l  #$ffff, d1
    moveq   #$0,d2
    move.b  $1(a4), d2
    andi.l  #$ffff, d2
    add.l   d2, d1
    jsr SignedDiv
; --- Phase: Final revenue formula ---
l_201b0:
; d2 = weighted stat average (0-255 range, represents route demand strength)
    move.w  d0, d2
; Formula: d3 = (d2 - d5 + $64) * d3 / $64
; Combines demand strength (d2), price ratio (d5), and current gain (d3)
; Subtracting d5 inverts the price effect: higher price vs compat = lower gain
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  d5, d1
    sub.l   d1, d0
; +$64 = 100: re-center to neutral (pure demand score when price matches compat)
    addi.l  #$64, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
; d3 = gain adjusted for demand strength and price ratio
    move.w  d0, d3
; --- Phase: Apply frequency penalty/bonus ---
; Clamp d4 (frequency) to 7 max; each unit of frequency above 7 reduces multiplier
    cmpi.w  #$7, d4
    bcc.b   l_201e2
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_201e4
l_201e2:
; Frequency >= 7: cap at 7 for multiplier calculation
    moveq   #$7,d0
l_201e4:
; Multiplier = $68 - frequency*4 (higher frequency = lower per-flight gain, as load spreads)
; $68 = 104; max multiplier at freq=0 is 104%, min at freq=7 is 76%
    lsl.l   #$2, d0
    moveq   #$68,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
; d3 = frequency-adjusted gain
    move.w  d0, d3
; --- Phase: Lookup load factor from $FFA6B9 table ---
; GetByteField4: retrieve 4-bit field from route slot record (a2), returns nibble as word in d0
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $c(a7), a7
; d2 = nibble field index, used to look up load factor byte at $FFA6B9[d2*$C]
    move.w  d0, d2
    mulu.w  #$c, d0
; $FFA6B9 = sub-table within bitfield_tab ($FFA6A0 area): per-slot load factor bytes
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    andi.l  #$ffff, d5
; Compute load weight: d5 = d5 * 4 + d5 * 2 = d5 * 10 (packed as lsl#2+add+lsl#1)
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    add.l   d5, d5
; If d5 (weighted load) >= d3 (adjusted gain): use weighted load as the cap
    moveq   #$0,d0
    move.w  d3, d0
    cmp.l   d0, d5
    bge.b   l_2025e
; Gain exceeds load capacity: re-fetch load factor and recalculate cap
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    andi.l  #$ffff, d5
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    add.l   d5, d5
    bra.b   l_20262
; Load fits within gain: use d3 directly
l_2025e:
    moveq   #$0,d5
    move.w  d3, d5
; --- Phase: Scale by frequency, write to gross_revenue ---
; d5 = effective load-capped gain, clamped frequency in d0 (0-7)
l_20262:
    cmpi.w  #$7, d4
    bcc.b   l_2026e
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_20270
l_2026e:
    moveq   #$7,d0
; gross_revenue (+$08) = load_gain * min(frequency, 7)
l_20270:
    mulu.w  d5, d0
; Write to route slot +$08 = gross_revenue (DATA_STRUCTURES.md: current gross revenue)
    move.w  d0, $8(a2)
; --- Phase: Overflow bonus for high-frequency routes ---
; Only applies when frequency > 7 (beyond base capacity, excess flights yield extra revenue)
    cmpi.w  #$7, d4
    bls.w   l_202fc
; Compute base load threshold: load_factor * $A (10x base)
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    mulu.w  #$a, d0
; d5 = excess above threshold (d3 - base_threshold); only apply if positive
    move.w  d3, d1
    sub.w   d0, d1
    move.w  d1, d5
    ble.b   l_202fc
; Compute max bonus capacity = load_factor * 10 (same formula as above)
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
; If max_bonus >= d5 (excess): bonus = d5, else cap bonus at max_bonus
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_202ea
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    bra.b   l_202ee
l_202ea:
    move.w  d5, d0
    ext.l   d0
l_202ee:
; d5 = capped excess bonus amount
    move.w  d0, d5
; Extra bonus per extra flight: (frequency - 7) * bonus_amount
; addi.w #$fff9 = subtract 7 (signed)
    move.w  d4, d0
    addi.w  #$fff9, d0
    mulu.w  d5, d0
; Add overflow bonus to gross_revenue (+$08)
    add.w   d0, $8(a2)
; --- Phase: Finalize passenger_count and round gross_revenue ---
l_202fc:
; passenger_count (+$10) = gross_revenue / frequency (revenue per flight)
    moveq   #$0,d0
    move.w  $8(a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr SignedDiv
; Write to route slot +$10 = passenger_count (passengers per flight)
    move.w  d0, $10(a2)
; Round gross_revenue back: multiply passenger_count by frequency to normalize
    mulu.w  d4, d0
; Write rounded value back to route slot +$08 = gross_revenue
    move.w  d0, $8(a2)
; --- Phase: Accumulate gain into per-city or global revenue table ---
; d2 = gross_revenue * 12 (annualized: 12 quarters per year)
; computed as: d2 * 3 * 4 = d2*2 + d2, then <<2
    moveq   #$0,d2
    move.w  $8(a2), d2
    move.l  d2, d0
    add.l   d2, d2
    add.l   d0, d2
    lsl.l   #$2, d2
; a3 = $FF01B0 + slot_index*$20 (per-slot accumulator block, stride $20)
; $FF01B0 area (PackSaveState unknown block) stores running revenue totals per slot
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
; Check player_record+$4 again to choose accumulation path
    movea.l -$4(a6), a0
    move.b  $4(a0), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d7, d1
; Alliance city: add d2 to a3+$1C (offset $1C = alliance revenue accumulator)
    cmp.l   d1, d0
    ble.b   l_20350
    add.l   d2, $1c(a3)
    bra.b   l_2036c
; Standard city: RangeLookup maps city_a code to region bucket (0-7)
; then add d2 to a3[region_index*4] (per-region revenue accumulator)
l_20350:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
; RangeLookup: map city code to region index 0-7 via cumulative threshold table
    jsr RangeLookup
    move.w  d0, d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    movea.l d0, a0
; Add annualized revenue to the per-region longword in the a3 block
    add.l   d2, (a3,a0.l)
; --- Phase: Mark slot updated ---
l_2036c:
; Set a5+$4 = 1 to signal that this slot has been processed this cycle
    move.w  #$1, $4(a5)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
