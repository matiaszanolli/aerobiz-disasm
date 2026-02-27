; ============================================================================
; RenderAnimFrame -- Computes per-player route revenue shares for a specific city/slot: retrieves city capacity factors from $FFBDE4, calculates weighted demand contributions from both endpoint cities (scaled by the current market-share percentage at $FFBD4C), sums the products, and stores scaled revenue values per player into output accumulator fields, calling TransitionEffect to determine each player's relative slot index.
; 1134 bytes | $01F352-$01F7BF
; ============================================================================
; --- Phase: Setup ---
; Args (pushed right-to-left): arg0 = player index (d3), arg1 = slot index (d7)
RenderAnimFrame:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3           ; d3 = player index (0-3)
    move.l  $c(a6), d7           ; d7 = route slot index within player (0-39)
    movea.l  #$00FF0002,a4       ; a4 = $FF0002 (game-state flags base)
    lea     -$14(a6), a5         ; a5 = local slot-index result table (10 words on stack)
    move.w  #$3a98, d6           ; d6 = $3A98 = 15000 -- divisor for normalizing revenue to per-unit share
    ; --- Phase: Locate Route Slot in FFB4E4 Table ---
    ; Compute byte offset: player*$140 + slot*8 to index into $FFB4E4 route data table
    move.w  d3, d0               ; d0 = player index
    mulu.w  #$140, d0            ; d0 = player * $140 (320 bytes per player in this table)
    move.w  d7, d1               ; d1 = slot index
    lsl.w   #$3, d1              ; d1 = slot * 8 (8 bytes per slot entry)
    add.w   d1, d0               ; d0 = player*$140 + slot*8 (byte offset into table)
    movea.l  #$00FFB4E4,a0       ; a0 = $FFB4E4 (route data table: city pairs and capacity)
    lea     (a0,d0.w), a0        ; a0 = pointer to this player's slot entry
    movea.l a0, a2               ; a2 = saved slot entry pointer
    move.w  (a2), -$4(a6)        ; local[-4] = city_a index for this route slot (source city)
    move.w  $2(a2), -$6(a6)      ; local[-6] = city_b index for this route slot (dest city)
    ; --- Phase: Load City Capacity Factors from FFBDE4 ---
    ; $FFBDE4 = CalcCityStats output: top-3 city capacity values, sorted and stored per city
    ; Index into it by city_a*4 and city_b*4 to get their capacity factor pointers
    move.w  -$4(a6), d0          ; d0 = city_a index
    lsl.w   #$2, d0              ; d0 = city_a * 4 (4-byte stride in capacity table)
    movea.l  #$00FFBDE4,a0       ; a0 = $FFBDE4 (city capacity/stat factor table)
    lea     (a0,d0.w), a0        ; a0 = &capacity[city_a]
    movea.l a0, a2               ; a2 = capacity entry for city_a
    move.w  -$6(a6), d0          ; d0 = city_b index
    lsl.w   #$2, d0              ; d0 = city_b * 4
    movea.l  #$00FFBDE4,a0       ; a0 = $FFBDE4 capacity table (reloaded)
    lea     (a0,d0.w), a0        ; a0 = &capacity[city_b]
    movea.l a0, a3               ; a3 = capacity entry for city_b
    ; --- Phase: Compute Weighted Demand from city_b (a3) using current market-share ---
    ; $FFBD4C = current market-share percentage (0-100).
    ; Formula: demand_b = (freq_b3 * (100-share) + freq_b2 * share) / 100
    ; This computes the blended demand contribution for the destination city.
    move.w  ($00FFBD4C).l, d0    ; d0 = market-share percentage (0-100) from $FFBD4C
    ext.l   d0                   ; sign-extend to 32 bits
    moveq   #$64,d1              ; d1 = 100
    sub.l   d0, d1               ; d1 = 100 - share  (complement share for city_b byte3)
    move.l  d1, d0               ; d0 = (100 - share)
    moveq   #$0,d1
    move.b  $3(a3), d1           ; d1 = city_b capacity factor byte 3 (high demand weight)
    ext.l   d1
    jsr Multiply32               ; d0 = (100-share) * byte3(city_b)
    move.l  d0, -(a7)            ; save partial product on stack
    moveq   #$0,d0
    move.b  $2(a3), d0           ; d0 = city_b capacity factor byte 2 (low demand weight)
    ext.l   d0
    move.w  ($00FFBD4C).l, d1    ; d1 = share percentage
    ext.l   d1
    jsr Multiply32               ; d0 = share * byte2(city_b)
    add.l   (a7)+, d0            ; d0 = (100-share)*byte3 + share*byte2  (blended demand)
    moveq   #$64,d1              ; d1 = 100
    jsr SignedDiv                ; d0 = blended_demand_b / 100 (normalized)
    move.w  d0, -$c(a6)          ; local[-$C] = blended demand from city_b endpoint
    ; --- Phase: Compute Capacity Factor for city_a (a2) ---
    ; byte3(a2) encodes city_a's peak load factor. Scale by 90% (×$5A/100) then add 10.
    moveq   #$0,d0
    move.b  $3(a2), d0           ; d0 = city_a capacity byte3 (peak load coefficient)
    andi.l  #$ffff, d0           ; zero-extend
    moveq   #$5A,d1              ; d1 = $5A = 90
    jsr Multiply32               ; d0 = byte3 * 90
    moveq   #$64,d1              ; d1 = 100
    jsr SignedDiv                ; d0 = byte3 * 90 / 100  (scaled to 0-90 range)
    addi.w  #$a, d0              ; d0 += 10  (shift range to 10-100; minimum 10% factor)
    move.w  d0, d4               ; d4 = city_a capacity factor (10-100)
    ; --- Phase: Compute Revenue Contribution from city_a (a2) ---
    ; capacity(a2) * blended_demand_b * d4 = raw contribution for city_a endpoint
    moveq   #$0,d0
    move.w  (a2), d0             ; d0 = city_a base capacity word (from $FFB4E4 table)
    moveq   #$0,d1
    move.w  -$c(a6), d1          ; d1 = blended demand from city_b (computed above)
    jsr Multiply32               ; d0 = capacity_a * demand_b
    moveq   #$0,d1
    move.w  d4, d1               ; d1 = city_a capacity factor (10-100)
    jsr Multiply32               ; d0 = capacity_a * demand_b * factor_a
    move.l  d0, -$a(a6)          ; local[-$A] = city_a revenue contribution (unscaled long)
    ; --- Phase: Compute Weighted Demand from city_a (a2) ---
    ; Mirror of the city_b calculation, now applied to city_a endpoint
    move.w  ($00FFBD4C).l, d0    ; d0 = market-share percentage
    ext.l   d0
    moveq   #$64,d1              ; d1 = 100
    sub.l   d0, d1               ; d1 = 100 - share
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a2), d1           ; d1 = city_a capacity byte3 (high demand weight)
    ext.l   d1
    jsr Multiply32               ; d0 = (100-share) * byte3(city_a)
    move.l  d0, -(a7)            ; save on stack
    moveq   #$0,d0
    move.b  $2(a2), d0           ; d0 = city_a capacity byte2 (low demand weight)
    ext.l   d0
    move.w  ($00FFBD4C).l, d1    ; d1 = share
    ext.l   d1
    jsr Multiply32               ; d0 = share * byte2(city_a)
    add.l   (a7)+, d0            ; d0 = blended demand from city_a endpoint
    moveq   #$64,d1
    jsr SignedDiv                ; d0 = blended_demand_a / 100 (normalized)
    move.w  d0, d2               ; d2 = blended demand from city_a
    ; --- Phase: Compute Capacity Factor for city_b (a3) ---
    moveq   #$0,d0
    move.b  $3(a3), d0           ; d0 = city_b capacity byte3
    andi.l  #$ffff, d0
    moveq   #$5A,d1              ; d1 = 90
    jsr Multiply32               ; d0 = byte3 * 90
    moveq   #$64,d1
    jsr SignedDiv                ; d0 = byte3 * 90 / 100
    addi.w  #$a, d0              ; d0 += 10  (capacity factor 10-100)
    move.w  d0, d4               ; d4 = city_b capacity factor
    ; --- Phase: Sum Both City Contributions and Normalize ---
    moveq   #$0,d0
    move.w  (a3), d0             ; d0 = city_b base capacity word
    moveq   #$0,d1
    move.w  d2, d1               ; d1 = blended demand from city_a
    jsr Multiply32               ; d0 = capacity_b * demand_a
    moveq   #$0,d1
    move.w  d4, d1               ; d1 = city_b capacity factor
    jsr Multiply32               ; d0 = capacity_b * demand_a * factor_b
    move.l  d0, d2               ; d2 = city_b revenue contribution
    move.l  -$a(a6), d0          ; d0 = city_a revenue contribution
    add.l   d2, d0               ; d0 = total combined revenue (city_a + city_b)
    moveq   #$0,d1
    move.w  d6, d1               ; d1 = $3A98 = 15000 (normalization constant)
    jsr UnsignedDivide           ; d0 = combined_revenue / 15000 (per-unit revenue share)
    move.w  d0, -$2(a6)          ; local[-2] = normalized per-unit revenue share for this slot
    ; --- Phase: Pre-fill Local Slot-Index Table ---
    ; Before calling TransitionEffect for each player, pre-fill all slots[0..player-1]
    ; with $FF (meaning "not yet assigned / invalid"), then set slot[player] = slot_index.
    clr.w   d2               ; d2 = loop counter (0 .. player-1)
    bra.b   l_1f4dc          ; enter loop check first
l_1f4cc:
    moveq   #$0,d0
    move.w  d2, d0           ; d0 = current loop index
    add.l   d0, d0           ; d0 *= 2 (word offset)
    movea.l d0, a0
    move.w  #$ff, (a5,a0.l)  ; slot_tab[i] = $FF (slot not yet determined for player i)
    addq.w  #$1, d2
l_1f4dc:
    cmp.w   d3, d2           ; loop until i == player index
    bcs.b   l_1f4cc          ; continue filling with $FF for all players before current
    ; Place the current player's own slot index at position [player]
    moveq   #$0,d0
    move.w  d3, d0           ; d0 = current player index
    add.l   d0, d0           ; d0 *= 2
    movea.l d0, a0
    move.w  d7, (a5,a0.l)    ; slot_tab[player] = slot index (d7) = current player's route slot
    move.w  d3, d2           ; d2 = player index (start TransitionEffect loop from here)
    bra.b   l_1f51c
    ; --- Phase: Call TransitionEffect for Each Remaining Player ---
    ; For players d2=player..3, call TransitionEffect(player_i, city_a, city_b)
    ; which returns the relative slot index for that player on this route.
l_1f4f0:
    moveq   #$0,d0
    move.w  -$6(a6), d0     ; arg: city_b index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$4(a6), d0     ; arg: city_a index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0           ; arg: player index
    move.l  d0, -(a7)
    ; TransitionEffect: given a player and city pair, return this player's slot index
    jsr (TransitionEffect,PC)
    nop
    lea     $c(a7), a7       ; pop 3 args
    moveq   #$0,d1
    move.w  d2, d1           ; d1 = player index
    add.l   d1, d1           ; d1 *= 2 (word offset)
    movea.l d1, a0
    move.w  d0, (a5,a0.l)   ; slot_tab[player_i] = TransitionEffect result (slot index)
l_1f51c:
    addq.w  #$1, d2
    cmpi.w  #$4, d2          ; loop over all 4 players
    bcs.b   l_1f4f0          ; keep iterating until all players covered
    ; --- Phase: Compute Per-Player Revenue Contributions (First Pass) ---
    ; For each player (starting at current player d3), look up their slot index,
    ; check it is valid and active, then compute that player's revenue share for this route.
    ; Results are accumulated in d6 (total revenue for normalization) and stored at a2.
    clr.w   d7               ; d7 = count of players with valid revenue contributions
    moveq   #$0,d6           ; d6 = running total of all players' revenue (for normalization)
    move.w  d3, d2           ; d2 = player loop counter (starts at current player)
    move.w  d2, d0
    lsl.w   #$2, d0          ; d0 = player * 4 (each result slot is a longword)
    lea     -$24(a6, d0.w), a0  ; a0 = &result_tab[player] (output accumulator on stack)
    movea.l a0, a2           ; a2 = current write pointer into result table
    bra.w   l_1f5de          ; enter loop at condition check
l_1f538:
    moveq   #$0,d0
    move.w  d2, d0           ; d0 = current player index
    add.l   d0, d0           ; d0 *= 2 (word index)
    movea.l d0, a0
    move.w  (a5,a0.l), d4   ; d4 = slot index for this player (from TransitionEffect table)
    cmpi.w  #$28, d4         ; $28 = 40 = max valid slot index
    bcc.w   l_1f5da          ; slot >= 40 means invalid; skip this player
    ; Check if route slot is active (status_flags bit 1 = $02 means suspended)
    move.w  d2, d0
    mulu.w  #$320, d0        ; d0 = player * $320 (800 bytes per player in route_slots)
    move.w  d4, d1
    mulu.w  #$14, d1         ; d1 = slot * $14 (20 bytes per route_slot entry)
    add.w   d1, d0           ; d0 = byte offset into $FF9A20 route_slots for this player+slot
    movea.l  #$00FF9A2A,a0   ; a0 = $FF9A2A = $FF9A20 + $0A (status_flags field of slot 0)
    move.b  (a0,d0.w), d0   ; d0 = status_flags byte (+$0A of route_slot struct)
    andi.l  #$2, d0          ; test bit 1 = suspended flag
    bne.b   l_1f5da          ; suspended: skip revenue calculation
    ; Look up player's route data in $FF0230 sub-table (unknown block, per-player stride $10)
    move.w  d2, d0
    lsl.w   #$4, d0          ; d0 = player * $10
    movea.l  #$00FF0230,a0   ; a0 = $FF0230 (unknown per-player block, stride $10)
    lea     (a0,d0.w), a0
    movea.l a0, a3           ; a3 = player's sub-record in $FF0230
    ; Sum the demand weights for city_a and city_b from this player's sub-record
    ; $2(a3, city*2) = per-player demand contribution for that city endpoint
    moveq   #$0,d0
    move.w  -$4(a6), d0     ; d0 = city_a index
    add.l   d0, d0           ; d0 *= 2 (word index)
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0  ; d0 = demand weight for city_a from this player's sub-record
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  -$6(a6), d1     ; d1 = city_b index
    add.l   d1, d1           ; d1 *= 2
    movea.l d1, a0
    move.w  $2(a3, a0.l), d1  ; d1 = demand weight for city_b
    andi.l  #$ffff, d1
    add.l   d1, d0           ; d0 = total demand weight (city_a + city_b) for this player
    ; Multiply by per-slot fare from $FFB4EA (route fare table)
    ; $FFB4EA = $FFB4E4 + 6 (the ticket_price field at +$06 in the table entry? or fare word)
    move.w  d2, d1
    mulu.w  #$140, d1        ; d1 = player * $140 (player stride in $FFB4EA table)
    movea.l d7, a0           ; a0 = old d7 value (saved for EXG)
    move.w  d4, d7
    lsl.w   #$3, d7          ; d7 = slot * 8 (slot stride, 8 bytes per slot in fare table)
    exg     d7, a0           ; restore d7 from a0, a0 = slot*8
    add.w   a0, d1           ; d1 = player*$140 + slot*8 (byte offset into $FFB4EA)
    movea.l  #$00FFB4EA,a0   ; a0 = $FFB4EA (route fare / ticket-price table)
    move.w  (a0,d1.w), d1   ; d1 = ticket price (fare word) for this player+slot
    andi.l  #$ffff, d1
    jsr Multiply32           ; d0 = demand_weight * ticket_price
    moveq   #$64,d1          ; d1 = 100
    jsr UnsignedDivide       ; d0 = (demand * price) / 100 = revenue for this player's slot
    move.l  d0, (a2)         ; result_tab[player] = revenue contribution
    add.l   (a2), d6         ; d6 += revenue (accumulate total for normalization pass)
    addq.w  #$1, d7          ; d7 = count of valid contributing players
l_1f5da:
    addq.l  #$4, a2          ; advance result pointer by 4 (next longword)
    addq.w  #$1, d2          ; next player
l_1f5de:
    cmpi.w  #$4, d2          ; loop over all 4 players
    bcs.w   l_1f538          ; keep going until d2 == 4
    ; --- Phase: Second Pass -- Scale Revenue Shares and Apply Type-Distance Adjustments ---
    ; Iterate all 4 players again. For each valid slot, normalize the raw revenue by the
    ; total (d6), then scale by the per-slot fare and apply a type-distance penalty/bonus,
    ; then call UpdateUIPalette to display the result.
    move.w  d3, d2           ; d2 = loop counter starting at current player
    bra.w   l_1f7ae          ; enter at condition check
l_1f5ec:
    moveq   #$0,d0
    move.w  d2, d0           ; d0 = player index
    add.l   d0, d0           ; d0 *= 2
    movea.l d0, a0
    move.w  (a5,a0.l), d4   ; d4 = slot index for this player
    cmpi.w  #$28, d4         ; $28 = 40 = invalid slot sentinel
    bcc.w   l_1f7ac          ; skip if no valid slot
    ; Locate route slot in $FF9A20 array to check suspended flag (+$0A)
    move.w  d2, d0
    mulu.w  #$320, d0        ; d0 = player * $320 (800 bytes per player)
    move.w  d4, d1
    mulu.w  #$14, d1         ; d1 = slot * $14 (20 bytes per slot in route_slot struct)
    add.w   d1, d0           ; d0 = byte offset
    movea.l  #$00FF9A20,a0   ; a0 = $FF9A20 (route_slots base)
    lea     (a0,d0.w), a0
    movea.l a0, a2           ; a2 = pointer to this player's route slot struct
    move.b  $a(a2), d0      ; d0 = status_flags (+$0A of route_slot)
    andi.l  #$2, d0          ; bit 1 = suspended flag
    bne.w   l_1f726          ; suspended: revenue = 0 for this slot
    ; Load player's $FF0230 sub-record (same table as first pass)
    move.w  d2, d0
    lsl.w   #$4, d0          ; d0 = player * $10
    movea.l  #$00FF0230,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3           ; a3 = player's sub-record in $FF0230
    ; --- Phase: Normalize Revenue Share ---
    ; If d6 (total revenue) is nonzero: player_share = result_tab[player] * per_unit / d6
    ; If d6 is zero: split per_unit evenly among d7 contributing players
    tst.l   d6               ; d6 = total revenue accumulated in first pass
    beq.b   l_1f65a          ; if zero, use even split path
    move.w  d2, d0
    lsl.w   #$2, d0          ; d0 = player * 4 (longword index)
    move.l  -$24(a6, d0.w), d0  ; d0 = this player's raw revenue contribution
    moveq   #$0,d1
    move.w  -$2(a6), d1     ; d1 = normalized per-unit revenue share (computed above)
    jsr Multiply32           ; d0 = player_revenue * per_unit
    move.l  d6, d1           ; d1 = total of all players' revenues
    jsr UnsignedDivide       ; d0 = player_share = proportional allocation of per_unit
    bra.b   l_1f66a
l_1f65a:
    ; Even split: divide per_unit share equally among contributing players
    moveq   #$0,d0
    move.w  -$2(a6), d0     ; d0 = per-unit revenue share
    moveq   #$0,d1
    move.w  d7, d1           ; d1 = count of valid contributing players
    jsr SignedDiv            ; d0 = per_unit / n_players (equal share when no data)
l_1f66a:
    move.w  d0, d3           ; d3 = base revenue share for this player's slot
    ; --- Phase: Apply Seat-Count Adjustment (city demand sub-record) ---
    ; Read per-player demand offsets for city_b and city_a from $FF0230 sub-record.
    ; Scale each by (a4)+2 (a flag/multiplier from $FF0002) and sum.
    ; This adds a seat-availability adjustment based on actual occupancy numbers.
    moveq   #$0,d0
    move.w  -$6(a6), d0     ; d0 = city_b index
    add.l   d0, d0           ; d0 *= 2
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0  ; d0 = city_b demand adjustment from $FF0230
    andi.l  #$ffff, d0
    move.w  (a4), d1         ; d1 = word at $FF0002 (game-state flag / seat multiplier)
    ext.l   d1
    addq.l  #$2, d1          ; d1 = flag + 2 (bias so denominator is never zero)
    jsr SignedDiv            ; d0 = city_b adjustment / (flag+2)
    move.l  d0, -(a7)        ; save city_b portion
    moveq   #$0,d0
    move.w  -$4(a6), d0     ; d0 = city_a index
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0  ; d0 = city_a demand adjustment
    andi.l  #$ffff, d0
    move.w  (a4), d1         ; d1 = same flag word
    ext.l   d1
    addq.l  #$2, d1
    jsr SignedDiv            ; d0 = city_a adjustment / (flag+2)
    add.l   (a7)+, d0        ; d0 = sum of both city demand adjustments
    move.l  d0, d5           ; d5 = combined seat-count adjustment (signed)
    ; Arithmetic right-shift d5 by 1, correcting for sign (add 1 before shift if negative)
    tst.l   d5
    bge.b   l_1f6b8
    addq.l  #$1, d5          ; round toward zero for negative values
l_1f6b8:
    asr.l   #$1, d5          ; d5 >>= 1 (halve the seat adjustment)
    ; Clamp adjustment to max $36B0 = 14000 (prevents runaway seat-count bonus)
    cmpi.l  #$36b0, d5
    bge.b   l_1f6c6
    move.l  d5, d0           ; adjustment is within range; use as-is
    bra.b   l_1f6cc
l_1f6c6:
    move.l  #$36b0, d0       ; d0 = $36B0 = 14000 (cap the adjustment)
l_1f6cc:
    add.w   d0, d3           ; d3 += seat adjustment (revenue share grows with more seats)
    ; --- Phase: Apply Type-Distance Penalty ---
    ; CalcTypeDistance computes how far apart the two character types are (0-3).
    ; Larger distance = smaller revenue share (competitors undercut the route).
    moveq   #$0,d0
    move.b  $1(a2), d0      ; d0 = route_slot city_b field (+$01 = city_b index)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0         ; d0 = route_slot city_a field (+$00 = city_a index)
    ext.l   d0
    move.l  d0, -(a7)
    ; CalcTypeDistance: returns type "distance" 0-3 between the two city codes
    jsr CalcTypeDistance
    addq.l  #$8, a7          ; pop 2 args
    move.w  d0, d5           ; d5 = type distance (0=same, 1=close, 2=mid, 3=far)
    ; Apply revenue penalty based on type distance:
    ;   distance 3 (far):  d3 = (d3 + bias) >> 2  (quarter = large penalty)
    ;   distance 2 (mid):  d3 = (d3 + bias) >> 1  (half = medium penalty)
    ;   distance 1 (close): d3 -= d3/5            (20% reduction = small penalty)
    ;   distance 0 (same): no change
    cmpi.w  #$3, d5
    bne.b   l_1f6fe
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f6f8
    addq.l  #$3, d0          ; bias negative values up before right shift (round toward 0)
l_1f6f8:
    asr.l   #$2, d0          ; d3 / 4 (heavy penalty for far type distance)
l_1f6fa:
    move.w  d0, d3           ; store penalty-adjusted share
    bra.b   l_1f728
l_1f6fe:
    cmpi.w  #$2, d5
    bne.b   l_1f710
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f70c
    addq.l  #$1, d0          ; bias for negative value rounding
l_1f70c:
    asr.l   #$1, d0          ; d3 / 2 (medium penalty)
    bra.b   l_1f6fa
l_1f710:
    cmpi.w  #$1, d5
    bne.b   l_1f728          ; distance 0 or unrecognized: no penalty
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$5,d1           ; d1 = 5
    jsr SignedDiv            ; d0 = d3 / 5  (20% of the share)
    sub.w   d0, d3           ; d3 -= d3/5  (small penalty: lose 20%)
    bra.b   l_1f728
l_1f726:
    clr.w   d3               ; suspended slot: force revenue share to zero
l_1f728:
    ; --- Phase: Scale Final Share by Ticket Price and Call UpdateUIPalette ---
    ; Multiply adjusted share (d3) by this player+slot's ticket price from $FFB4EA,
    ; then call UpdateUIPalette(player, slot, value) to store the display result.
    move.w  d2, d0
    mulu.w  #$140, d0        ; d0 = player * $140 (table stride)
    move.w  d4, d1
    lsl.w   #$3, d1          ; d1 = slot * 8
    add.w   d1, d0           ; d0 = offset into $FFB4EA fare table
    movea.l  #$00FFB4EA,a0   ; a0 = $FFB4EA (ticket price / fare table)
    move.w  (a0,d0.w), d0   ; d0 = fare word for this player+slot
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d3, d1           ; d1 = adjusted revenue share
    jsr Multiply32           ; d0 = fare * share
    moveq   #$64,d1          ; d1 = 100
    jsr UnsignedDivide       ; d0 = (fare * share) / 100 = final display value
    move.w  d0, d3           ; d3 = final per-player revenue value for display
    ; Apply a further scaling based on game-state flag at $FF0002:
    ;   flag=0: halve (conservative)
    ;   flag=1: quarter (aggressive cut)
    ;   flag=3: subtract 1/3 (moderate reduction)
    ;   other:  no change
    tst.w   (a4)             ; a4 = $FF0002; test game-state flag word
    bne.b   l_1f76a
    ; flag == 0: apply 50% reduction (halve the value)
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f764
    addq.l  #$1, d0          ; bias for rounding negative
l_1f764:
    asr.l   #$1, d0          ; d0 = d3 / 2
l_1f766:
    add.w   d0, d3           ; d3 += halved value (i.e. d3 = d3 + d3/2 = 1.5x? or d3+bias)
    bra.b   l_1f790
l_1f76a:
    cmpi.w  #$1, (a4)        ; flag == 1?
    bne.b   l_1f77c
    ; flag == 1: apply 25% reduction (quarter)
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f778
    addq.l  #$3, d0          ; bias for rounding
l_1f778:
    asr.l   #$2, d0          ; d0 = d3 / 4
    bra.b   l_1f766
l_1f77c:
    cmpi.w  #$3, (a4)        ; flag == 3?
    bne.b   l_1f790          ; flag not 0/1/3: no adjustment
    ; flag == 3: subtract 1/3 of value (moderate reduction)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$3,d1
    jsr SignedDiv            ; d0 = d3 / 3
    sub.w   d0, d3           ; d3 -= d3/3 (net: d3 * 2/3)
l_1f790:
    ; Call UpdateUIPalette(player, slot, final_value) to store/render the result
    moveq   #$0,d0
    move.w  d3, d0           ; arg: final revenue value
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0           ; arg: slot index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0           ; arg: player index
    move.l  d0, -(a7)
    ; UpdateUIPalette: stores the computed revenue value for this player's route slot display
    jsr (UpdateUIPalette,PC)
    nop
    lea     $c(a7), a7       ; pop 3 args
l_1f7ac:
    addq.w  #$1, d2          ; next player
l_1f7ae:
    cmpi.w  #$4, d2          ; loop over all 4 players
    bcs.w   l_1f5ec          ; continue until all players processed
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
