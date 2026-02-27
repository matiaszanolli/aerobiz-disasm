; ============================================================================
; RunAIMainLoop -- AI negotiation decision loop: evaluates character compatibility, profit, and skill; shows dialogue and makes offers
; 2986 bytes | $03131A-$031EC3
;
; Parameters (pushed on stack, link frame):
;   $8(a6)  = player_index (word) -- the AI player whose turn it is
;   $e(a6)  = slot_index (word)   -- route slot index within this player's route array
;
; Register conventions throughout:
;   a4 = pointer to the current route slot (route_slots + player*$320 + slot*$14)
;   a5 = text/sprintf output buffer (-$ae(a6) in link frame)
;   d7 = player_index (cached copy of $8(a6))
;   -$b4(a6) = computed profitability score (passenger_count * skill_factor / 100)
;   -$b6(a6) = CalcTypeDistance result (city-pair type distance)
;   -$6(a6)  = CharCodeScore result (adjusted compatibility score)
;   -$8(a6)  = CharCodeCompare result (character pair category match)
;   -$c(a6)  = "showed dialogue" flag (1 = a ShowText call was already made this entry)
;   -$e(a6)  = index of the single other player with a matching route (used for greeting)
; ============================================================================
RunAIMainLoop:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7                  ; d7 = player_index arg

; --- Phase: Locate route slot and compute city-pair type distance ---
    lea     -$ae(a6), a5                ; a5 = local sprintf buffer
    move.w  d7, d0
    mulu.w  #$320, d0                   ; player offset: player_index * $320 (800 bytes/player)
    move.w  $e(a6), d1
    mulu.w  #$14, d1                    ; slot offset: slot_index * $14 (20 bytes/slot)
    add.w   d1, d0
    movea.l  #$00FF9A20,a0              ; route_slots base
    lea     (a0,d0.w), a0
    movea.l a0, a4                      ; a4 = &route_slots[player][slot]
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b (destination city)
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a (source city)
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance                ; compute distance category between city_a and city_b
    addq.l  #$8, a7
    move.w  d0, -$b6(a6)               ; save type_distance result

; --- Phase: Early exit if route inactive or suspended ---
    tst.w   $6(a4)                      ; route_slot.revenue_target -- zero means no route set up
    beq.w   .l31dc6                     ; skip AI logic if route has no revenue target
    move.b  $a(a4), d0                  ; route_slot.status_flags
    andi.l  #$2, d0                     ; test bit 1 = SUSPENDED flag
    bne.w   .l31dc6                     ; skip if route is suspended

; --- Phase: Compute character compatibility scores ---
    ; CharCodeScore returns a raw compatibility value for the city-pair characters.
    ; The score is then adjusted: if negative, add 1 before halving (arithmetic rounding).
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore                   ; raw compatibility score for this city pair
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l313a4
    addq.l  #$1, d0                     ; adjust for signed halving (avoid -1 bias)
.l313a4:
    asr.l   #$1, d0                     ; d0 = score / 2 (rounding toward zero)
    move.w  d0, d3
    move.w  d2, d0
    add.w   d3, d0                      ; combined = raw + (raw/2) = 1.5x raw
    move.w  d0, -$6(a6)                 ; save adjusted compatibility score

    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare                 ; category-based compatibility (7 CharCompat tables)
    lea     $10(a7), a7
    move.w  d0, -$8(a6)                 ; save CharCodeCompare result (category match score)
    clr.w   -$c(a6)                     ; clear "showed dialogue" flag
    clr.w   d6                          ; d6 = count of other players sharing this route
    clr.w   d2                          ; d2 = loop counter (iterate all 4 players)

; --- Phase: Scan all players for route overlap (shared city-pair detection) ---
    ; Walk all 4 player records to count how many other players have a route with the
    ; same city_a + city_b pair AND a positive frequency (+$03). If exactly 1 match,
    ; record that player's index for a personalized greeting dialogue later.
.l313e0:
    cmp.w   d7, d2                      ; skip self
    beq.b   .l31442
    move.w  d2, d0
    mulu.w  #$320, d0                   ; player offset for player d2
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                      ; a3 = route_slots[d2] (other player's slot array base)
    move.w  d2, d0
    mulu.w  #$24, d0                    ; player record offset: d2 * $24
    movea.l  #$00FF0018,a0              ; player_records base ($FF0018)
    lea     (a0,d0.w), a0
    movea.l a0, a2                      ; a2 = &player_records[d2]
    moveq   #$0,d5
    move.b  $4(a2), d5                  ; player_record.domestic_slots count
    moveq   #$0,d0
    move.b  $5(a2), d0                  ; player_record.intl_slots count
    add.w   d0, d5                      ; d5 = total slot count (domestic + international)
    clr.w   d3
    bra.b   .l3143e
.l3141a:
    ; Compare city pair of this other player's slot against our route slot (a4)
    move.b  (a3), d0                    ; other_slot.city_a
    cmp.b   (a4), d0                    ; vs our route_slot.city_a
    bne.b   .l3143c
    move.b  $1(a3), d0                  ; other_slot.city_b
    cmp.b   $1(a4), d0                  ; vs our route_slot.city_b
    bne.b   .l3143c
    moveq   #$0,d0
    move.b  $3(a3), d0                  ; other_slot.frequency (must be > 0 = active)
    tst.w   d0
    ble.b   .l3143c                     ; skip if frequency == 0 (inactive)
    addq.w  #$1, d6                     ; d6++: another player shares this route
    move.w  d2, -$e(a6)                 ; save that player's index for greeting later
    bra.b   .l31442
.l3143c:
    addq.w  #$1, d3                     ; next slot in other player's route array
.l3143e:
    cmp.w   d5, d3                      ; iterated all of other player's slots?
    blt.b   .l3141a
.l31442:
    addq.w  #$1, d2
    cmpi.w  #$4, d2                     ; all 4 players scanned?
    blt.b   .l313e0

; --- Phase: Greeting dialogue for shared routes ---
    ; If exactly 1 other player shares this route, show a personalized greeting.
    ; If 2+ players share it, show a generic "many competitors" message.
    cmpi.w  #$1, d6                     ; exactly one other player on same route?
    bne.b   .l31478
    move.w  -$e(a6), d0                 ; the other player's index
    lsl.w   #$4, d0                     ; * $10 = offset into player name block at $FF00A8
    movea.l  #$00FF00A8,a0              ; $FF00A8 = unknown player data block (4 * $10 entries)
    pea     (a0, d0.w)                  ; push pointer to matching player's name/data
    move.l  ($00047BD0).l, -(a7)        ; ptr to format string (greeting with named rival)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.b   .l31486
.l31478:
    cmpi.w  #$2, d6                     ; 2 or more rival players on same route?
    blt.b   .l314a2
    clr.l   -(a7)
    move.l  ($00047BD4).l, -(a7)        ; ptr to generic multi-rival format string
.l31486:
    pea     ($0003).w                   ; max random dialogue variant = 3
    clr.l   -(a7)
    jsr RandRange                       ; pick random variant 0-2
    addq.l  #$8, a7
    move.l  d0, -(a7)                   ; random variant index
    move.w  d7, d0
    move.l  d0, -(a7)                   ; player_index
    bsr.w ShowText                      ; display the greeting dialogue
    lea     $10(a7), a7

; --- Phase: Compute profitability score and decide main AI branch ---
.l314a2:
    move.l  a4, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (PostTurnCleanup,PC)            ; finalize turn state for this route
    nop
    ; Profitability = passenger_count (slot+$10) * (aircraft_skill * 10) / 100
    move.l  a4, -(a7)
    jsr GetByteField4                   ; returns aircraft type byte for this route
    mulu.w  #$c, d0                     ; * $C = offset into aircraft stats array
    movea.l  #$00FFA6B9,a0              ; $FFA6B9 = aircraft skill table (stride $C per type)
    move.b  (a0,d0.w), d3              ; d3 = aircraft_skill byte for this plane type
    andi.l  #$ff, d3
    mulu.w  #$a, d3                     ; skill * 10 = scaled skill factor
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0064).w                   ; divisor = 100
    move.w  $10(a4), d0                 ; route_slot.passenger_count
    move.l  d0, -(a7)
    jsr MulDiv                          ; result = passenger_count * skill_factor / 100
    lea     $18(a7), a7
    move.w  d0, -$b4(a6)               ; save profitability score

; --- Phase: Branch on profitability >= $5C (92) threshold ---
    ; Score < $5C: not profitable enough to negotiate -- jump to low-profit handler
    ; Score >= $5C: route is generating real revenue; evaluate actual_revenue vs target
    cmpi.w  #$5c, -$b4(a6)             ; #$5C = 92 (profitability threshold for negotiation)
    blt.w   .l317e2                     ; below threshold -> low-profit branch
    move.w  $e(a4), d0                  ; route_slot.actual_revenue
    cmp.w   $6(a4), d0                  ; vs route_slot.revenue_target
    bcs.w   .l31716                     ; actual < target: profitable slot, find best char

; --- Phase: City demand delta computation for high-profit route ---
    ; Compute demand gap: city_a_demand - city_a_supply for source city,
    ; then same for city_b. Take the minimum as the effective negotiation headroom.
    ; city_data layout at $FFBA80: stride 8 per city (city_idx * 8 + player * 2):
    ;   byte[0] = demand, byte[1] = supply
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a index
    lsl.w   #$3, d0                     ; city_a * 8 (8 bytes per city in city_data)
    move.w  d7, d1
    add.w   d1, d1                      ; player_index * 2 (stride-2 within city entry)
    add.w   d1, d0
    movea.l  #$00FFBA80,a0              ; city_data base
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  (a2), d0                    ; city_data[city_a][player].demand
    moveq   #$0,d1
    move.b  $1(a2), d1                  ; city_data[city_a][player].supply
    sub.w   d1, d0                      ; demand - supply = demand_gap_a
    move.w  d0, -$2(a6)                 ; save demand_gap_a

    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b index
    lsl.w   #$3, d0                     ; city_b * 8
    move.w  d7, d1
    add.w   d1, d1                      ; player_index * 2
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  (a2), d2                    ; city_data[city_b][player].demand
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; city_data[city_b][player].supply
    sub.w   d0, d2                      ; demand_gap_b
    cmp.w   -$2(a6), d2                 ; demand_gap_b vs demand_gap_a
    ble.b   .l3155a                     ; take the smaller gap (more conservative estimate)
    move.w  -$2(a6), d0                 ; d0 = min(demand_gap_a, demand_gap_b)
    bra.b   .l3155c
.l3155a:
    move.w  d2, d0
.l3155c:
    ext.l   d0
    move.w  d0, -$4(a6)                 ; save min(demand_gap_a, demand_gap_b)

; --- Phase: Decide whether to promote frequency upgrade ---
    ; If current frequency (slot+$03) is below service_quality (slot+$0B), there's room
    ; to grow. If the demand gap is positive and frequency is below max ($E=14), offer upgrade.
    move.b  $3(a4), d0                  ; route_slot.frequency
    cmp.b   $b(a4), d0                  ; vs route_slot.service_quality
    bcc.b   .l315a0                     ; frequency >= service_quality: skip upgrade offer
    tst.w   -$4(a6)                     ; demand gap > 0?
    ble.b   .l315a0                     ; no demand headroom: skip
    cmpi.b  #$e, $3(a4)                 ; frequency < $E (14 = max)?
    bcc.b   .l315a0                     ; already at max frequency: skip
    ; Offer frequency upgrade: format message with route city names, then branch to ShowText
    pea     ($000448B0).l               ; ptr to "consider increasing flights" format string
    move.l  ($00047BB0).l, -(a7)        ; ptr to city name format argument
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    pea     ($0001).w
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.w   .l31cd0                     ; show text and set -$c flag

; --- Phase: Find best eligible character for this route (high-profit path) ---
    ; Search up to 16 candidate characters at $FFA6B8 (aircraft slot structs, stride $C).
    ; Pick the one whose skill rating is closest to d3 (target skill) with a valid
    ; compatibility score. Best candidate index saved in d5.
.l315a0:
    clr.w   d6                          ; d6 = "found candidate" flag
    move.l  a4, -(a7)
    jsr GetByteField4                   ; get aircraft type byte for this slot
    addq.l  #$4, a7
    mulu.w  #$c, d0                     ; * $C = offset into $FFA6B8 aircraft stat structs
    movea.l  #$00FFA6B9,a0              ; $FFA6B9 = aircraft skill table (byte 1 of each $C-byte struct)
    move.b  (a0,d0.w), d3              ; d3 = target skill level for this aircraft type
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2              ; a2 = ptr to aircraft slot array (stride $C per entry)
    moveq   #-$1,d5                     ; d5 = best candidate index (-1 = none yet)
    ; Compute target skill midpoint: (d3 * 7) / 4  (= d3 * 1.75, a bias toward lower skill)
    move.w  #$7530, -$b0(a6)           ; -$b0(a6) = best delta so far (init to $7530 = very large)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0                     ; d0 = d3 * 8
    sub.l   d1, d0                      ; d0 = d3 * 7
    bge.b   .l315dc
    addq.l  #$3, d0                     ; bias for signed arithmetic right shift
.l315dc:
    asr.l   #$2, d0                     ; d0 = (d3 * 7) / 4 = target skill midpoint
    move.w  d0, -$b2(a6)               ; save target skill midpoint for comparison

    clr.w   d2                          ; d2 = candidate index (0..15)
.l315e4:
    ; For each of 16 candidates: check eligibility, then score proximity to target skill
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr CheckCharEligible               ; returns nonzero if candidate d2 is valid for player d7
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3162c                     ; skip ineligible candidate
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; aircraft_slot.skill_rating (byte 1 of $C-byte struct)
    cmp.w   d3, d0                      ; must exceed target skill (d3) to be useful
    ble.b   .l3162c                     ; skill too low: skip
    move.w  $2(a2), d0                  ; aircraft_slot.compat_score (word at offset +$2)
    cmp.w   -$8(a6), d0                 ; vs CharCodeCompare result saved in -$8(a6)
    bcs.b   .l3162c                     ; compat score too low: skip
    ; Compute |skill_rating - target_midpoint| and keep the candidate with smallest delta
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; candidate skill_rating
    move.w  -$b2(a6), d4               ; target midpoint
    sub.w   d0, d4                      ; delta = target - actual
    tst.w   d4
    bge.b   .l3161e
    neg.w   d4                          ; |delta|
.l3161e:
    cmp.w   -$b0(a6), d4               ; better (smaller) than current best?
    bge.b   .l3162c                     ; no improvement: skip
    move.w  d4, -$b0(a6)               ; update best delta
    move.w  d2, d5                      ; save this candidate as best so far
    moveq   #$1,d6                      ; mark found
.l3162c:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2                      ; advance to next $C-byte aircraft struct
    cmpi.w  #$10, d2                    ; 16 candidates examined?
    blt.b   .l315e4

; --- Phase: Dialogue for best skill-match candidate (high-profit, score >= $5F) ---
    cmpi.w  #$1, d6                     ; found a valid candidate?
    bne.w   .l316da
    cmpi.w  #$5f, -$b4(a6)             ; profitability score >= $5F (95)?
    blt.w   .l316da
    ; Look up candidate name from $FF1278 (char display table) -> AircraftModelPtrs
    move.w  d7, d0
    lsl.w   #$5, d0                     ; player_index * $20 (event_records stride per player)
    move.w  d5, d1
    add.w   d1, d1                      ; candidate_index * 2
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0              ; $FFB9E9 = event_records stride-2 pilot field (byte 1 per slot)
    move.b  (a0,d0.w), d0              ; check if candidate slot is already occupied
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l3167a                     ; already populated: show named candidate message
    ; 50% random chance to show generic vs named message
    pea     ($0001).w                   ; RandRange(0, 1)
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l316b0                     ; random = 1: show generic message
.l3167a:
    ; Show named character recommendation message
    movea.l  #$00FF1278,a0              ; $FF1278 = char display lookup table (1 byte per candidate)
    move.b  (a0,d5.w), d0              ; char type byte for candidate d5
    andi.l  #$ff, d0
    lsl.w   #$2, d0                     ; * 4 = longword index into AircraftModelPtrs
    movea.l  #$0005ECFC,a0              ; AircraftModelPtrs table ($5ECFC)
    move.l  (a0,d0.w), -(a7)           ; push pointer to aircraft model name string
    pea     ($000448A8).l               ; ptr to named-recommendation format string
    move.l  ($00047BB4).l, -(a7)        ; additional format arg
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l316c0
.l316b0:
    ; Show generic (no-name) recommendation
    pea     ($00044878).l               ; ptr to generic recommendation format string
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l316c0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w                   ; text display mode 2
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)               ; mark "showed dialogue"
.l316da:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$62, -$b4(a6)
    blt.w   .l31ce2
    cmpi.w  #$1, d6
    bne.b   .l31702
.l316f6:
    clr.l   -(a7)
    move.l  ($00047BB8).l, -(a7)
    bra.w   .l31ccc
.l31702:
    move.l  ($00047BBC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
    bra.w   .l31cc8
.l31716:
    clr.w   -$c(a6)
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBestCharForSlot
    lea     $c(a7), a7
    move.w  d0, d5
    cmpi.w  #$ff, d5
    beq.w   .l317ca
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31770
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l317a0
.l31770:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   .l317b0
.l317a0:
    pea     ($0004483C).l
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l317b0:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
.l317ca:
    move.w  $4(a4), d0
    cmp.w   -$6(a6), d0
    bcc.w   .l31ce2
    cmpi.w  #$ff, d5
    bne.w   .l316f6
    bra.w   .l31702
; --- Phase: Low-profit branch (profitability score < $5C) ---
.l317e2:
    move.w  $e(a4), d0                  ; route_slot.actual_revenue
    cmp.w   $6(a4), d0                  ; vs route_slot.revenue_target
    bcc.w   .l318ac                     ; actual >= target (not a loss): skip city-pair dialogue
    ; Route is running at a loss. Show city-name dialogue based on type_distance:
    ;   type_distance >= 3: long-haul message (CityNamePtrs lookup for both cities)
    ;   type_distance == 2: domestic/short-haul message
    cmpi.w  #$2, -$b6(a6)              ; type_distance >= 2?
    blt.w   .l3187c                     ; distance < 2: skip city-name message
    cmpi.w  #$3, -$b6(a6)              ; type_distance == 3 (long-haul)?
    bne.b   .l3182a                     ; no: use shorter-range format string
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b index
    lsl.w   #$2, d0                     ; * 4 = longword index into CityNamePtrs
    movea.l  #$0005E680,a0              ; CityNamePtrs table
    move.l  (a0,d0.w), -(a7)           ; push city_b name string ptr
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; push city_a name string ptr
    move.l  ($00047BF4).l, -(a7)        ; ptr to long-haul loss format string
    bra.b   .l31852
.l3182a:
    ; type_distance == 2: domestic/short-haul loss message (same CityNamePtrs lookup)
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; city_b name ptr
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; city_a name ptr
    move.l  ($00047C04).l, -(a7)        ; ptr to short-haul loss format string
.l31852:
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w                   ; mode 2
    move.l  a5, -(a7)
    pea     ($0003).w                   ; max random variant = 3
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7

; --- Phase: Show "$FF99A0 active" status message (if quota met) ---
.l3187c:
    cmpi.w  #$1, ($00FF99A0).l          ; $FF99A0 = nonzero if some quota/milestone was reached
    bne.b   .l318ac
    pea     ($0002).w
    move.l  ($00047BC8).l, -(a7)        ; ptr to quota-achieved format string
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange                       ; pick random dialogue variant
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7

; --- Phase: Find most profitable eligible character (second candidate scan) ---
    ; This scan uses CalcCharProfit (actual profit potential) rather than skill proximity.
    ; Best candidate is the one with LOWEST CalcCharProfit result (minimize loss / maximize gain).
.l318ac:
    clr.w   d6                          ; d6 = "found candidate" flag
    move.l  a4, -(a7)
    jsr GetByteField4                   ; get aircraft type for this slot
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d3              ; d3 = target aircraft skill level
    andi.l  #$ff, d3
    movea.l  #$00FFA6B8,a2              ; a2 = aircraft candidate slot array (stride $C)
    moveq   #-$1,d5                     ; d5 = best candidate index (-1 = none found)
    ; Compute baseline profit for current route with the original aircraft type
    pea     ($0001).w
    move.l  a4, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)                   ; aircraft type (plan A)
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharProfit                  ; baseline profit for current aircraft
    lea     $14(a7), a7
    move.w  d0, d4                      ; d4 = baseline profit (lower is better for AI)
    clr.w   d2                          ; d2 = candidate index (0..15)
.l31904:
    ; For each eligible candidate: run CalcCharProfit and keep the one with lowest cost
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr CheckCharEligible               ; is candidate d2 eligible for player d7?
    addq.l  #$8, a7
    tst.w   d0
    beq.b   .l3195a                     ; skip ineligible candidate
    move.w  $2(a2), d0                  ; aircraft_slot compat_score (word +$2)
    cmp.w   -$8(a6), d0                 ; vs CharCodeCompare threshold
    bcs.b   .l3195a                     ; compat too low: skip
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; candidate index
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharProfit                  ; profit if we use candidate d2
    lea     $10(a7), a7
    move.w  d0, -$a(a6)
    cmp.w   -$a(a6), d4                 ; better (lower cost) than current best?
    ble.b   .l3195a
    move.w  -$a(a6), d4                 ; update best profit value
    move.w  d2, d5                      ; save best candidate index
    moveq   #$1,d6                      ; mark found
.l3195a:
    addq.w  #$1, d2
    moveq   #$C,d0
    adda.l  d0, a2
    cmpi.w  #$10, d2
    blt.b   .l31904
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmpi.w  #$3, d0
    blt.w   .l31a4a
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31a4a
    pea     ($00044832).l
    move.l  ($00047BB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $1c(a7), a7
    move.w  #$1, -$c(a6)
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31a00
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31a1e
.l31a00:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   .l31a24
.l31a1e:
    pea     ($00044824).l
.l31a24:
    move.l  ($00047BCC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $1c(a7), a7
    bra.w   .l31b40
.l31a4a:
    cmpi.w  #$1, d6
    bne.w   .l31b40
    move.w  d5, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    cmp.w   d3, d0
    bge.w   .l31af8
    cmpi.w  #$46, -$b4(a6)
    bge.w   .l31b40
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    bgt.b   .l31aa8
    pea     ($0002).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    beq.b   .l31ade
.l31aa8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004481C).l
    move.l  ($00047BB4).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   .l31aee
.l31ade:
    pea     ($000447EA).l
    move.l  a5, -(a7)
    jsr sprintf
    addq.l  #$8, a7
.l31aee:
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0002).w
    bra.b   .l31b2e
.l31af8:
    movea.l  #$00FF1278,a0
    move.b  (a0,d5.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047BC0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0001).w
.l31b2e:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
; --- Phase: Negotiation scoring -- compute ticket price adjustment and relation score ---
.l31b40:
    clr.w   d4                          ; d4 = "offer price-cut" flag
    clr.w   d2                          ; d2 = "offer higher price" flag
    clr.w   d3                          ; d3 = "relation score exceeded target" flag
    ; Formula: adjusted_fare = (ticket_price - CharCodeScore) * 100 / CharCodeScore
    ; This converts the raw fare into a percentage deviation from the compatibility baseline.
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore                   ; baseline compatibility score for city pair
    addq.l  #$8, a7
    move.w  d0, d5                      ; d5 = baseline score
    move.w  $4(a4), d0                  ; route_slot.ticket_price
    sub.w   d5, d0                      ; price_delta = ticket_price - baseline
    ext.l   d0
    moveq   #$64,d1                     ; * 100 (to scale before division)
    jsr Multiply32
    move.w  d5, d1                      ; divisor = baseline score
    ext.l   d1
    jsr SignedDiv                       ; result = (price_delta * 100) / baseline = % above baseline
    move.w  d0, d6                      ; d6 = fare_pct_above_baseline

    ; Clamp to max of -5 below baseline (d5 = fare_pct - 5, floor at -$32 = -50)
    move.w  d6, d5
    addi.w  #$fffb, d5                  ; d5 = fare_pct - 5
    move.w  d5, d0
    ext.l   d0
    moveq   #-$32,d1                    ; clamp minimum = -50
    cmp.l   d0, d1
    bge.b   .l31b94
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31b96
.l31b94:
    moveq   #-$32,d0                    ; clamped at -50
.l31b96:
    move.w  d0, d5                      ; d5 = clamped fare deviation (for CalcRelationScore)

    ; If fare deviation == baseline (no gap): skip relation check
    cmp.w   d5, d6
    beq.b   .l31bce
    ; Also check if city types are in the same range (RangeMatch) and profitability <= $32 (50)
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch                      ; returns 1 if both cities are in the same range category
    addq.l  #$8, a7
    tst.w   d0
    bne.b   .l31bce                     ; same range: don't push price lower
    cmpi.w  #$32, -$b4(a6)             ; profitability <= $32 (50)?
    bgt.b   .l31bce
    move.w  $e(a4), d0                  ; actual_revenue
    cmp.w   $6(a4), d0                  ; vs revenue_target
    bls.b   .l31bce                     ; not profitable enough to cut: skip
    moveq   #$1,d4                      ; signal: offer price cut

; --- Phase: CalcRelationScore -- determine if a price increase is warranted ---
.l31bce:
    move.w  d5, d0                      ; clamped fare deviation
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0                  ; slot_index arg
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0                      ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRelationScore               ; returns a relation-adjusted score
    lea     $c(a7), a7
    cmp.w   $e(a4), d0                  ; vs route_slot.actual_revenue (word at +$E)
    bls.b   .l31bf6                     ; score <= actual: consider raising price
    moveq   #$1,d3                      ; d3 = "relation score exceeded threshold": offer higher fare
    bra.b   .l31c2e
.l31bf6:
    ; Score <= actual_revenue: maybe try raising fare (add 5 to deviation and recheck)
    move.w  d6, d5
    addq.w  #$5, d5                     ; d5 = fare_pct + 5 (test slightly higher price)
    cmpi.w  #$32, d5
    bge.b   .l31c06
    move.w  d5, d0
    ext.l   d0
    bra.b   .l31c08
.l31c06:
    moveq   #$32,d0
.l31c08:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRelationScore
    lea     $c(a7), a7
    cmp.w   $e(a4), d0
    bls.b   .l31c2e
    moveq   #$1,d2
.l31c2e:
    cmpi.w  #$1, d4
    bne.b   .l31c62
    cmpi.w  #$1, d2
    bne.b   .l31c62
    clr.l   -(a7)
    move.l  ($00047C08).l, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
.l31c52:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    bra.w   .l31ce2
.l31c62:
    cmpi.w  #$1, d3
    bne.b   .l31c9a
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31c92
    pea     ($000447E4).l
.l31c76:
    move.l  ($00047BEC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0003).w
    bra.b   .l31c52
.l31c92:
    pea     ($000447DA).l
    bra.b   .l31cb6
.l31c9a:
    cmpi.w  #$1, d2
    bne.b   .l31ce2
    cmpi.w  #$1, -$c(a6)
    bne.b   .l31cb0
    pea     ($000447D6).l
    bra.b   .l31c76
.l31cb0:
    pea     ($000447CE).l
.l31cb6:
    move.l  ($00047BF0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
.l31cc8:
    clr.l   -(a7)
    move.l  a5, -(a7)
.l31ccc:
    pea     ($0003).w
.l31cd0:
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
; --- Phase: Offer outcome dispatch ---
.l31ce2:
    ; If a dialogue was already shown (-$c flag set), skip to function epilogue
    cmpi.w  #$1, -$c(a6)               ; "showed dialogue" flag set?
    beq.w   .l31eba                     ; yes: don't show another offer, just exit

    ; Determine if actual revenue > revenue target (route is profitable)
    move.w  $e(a4), d6                  ; route_slot.actual_revenue
    cmp.w   $6(a4), d6                  ; vs route_slot.revenue_target
    bhi.b   .l31cfa
    moveq   #$1,d6                      ; d6 = 1: route not profitable (actual <= target)
    bra.b   .l31cfc
.l31cfa:
    moveq   #$0,d6                      ; d6 = 0: route is profitable (actual > target)
.l31cfc:
    cmpi.w  #$1, d6                     ; route unprofitable?
    bne.w   .l31dba                     ; profitable: show "thank you" message variant

; --- Phase: Route unprofitable -- look for open slot and potentially make offer ---
    move.w  d7, d0
    move.l  d0, -(a7)
    move.l  a4, -(a7)
    jsr FindOpenSlot                    ; check if any open slot is available for this player
    addq.l  #$8, a7
    tst.w   d0
    bne.w   .l31db0                     ; no open slot: show "slot full" message
    ; Open slot available: show "interested" dialogue then check if upgrade is warranted
    pea     ($0002).w
    move.l  ($00047BD8).l, -(a7)        ; ptr to "we should expand" format string
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    ; Check if actual_revenue + $64 (100) < revenue_target -- if so, don't promote upgrade
    moveq   #$0,d0
    move.w  $e(a4), d0                  ; actual_revenue
    addi.l  #$64, d0                    ; add 100 (minimum uplift needed)
    moveq   #$0,d1
    move.w  $6(a4), d1                  ; revenue_target
    cmp.l   d1, d0                      ; (actual + 100) < target?
    bge.w   .l31eba                     ; revenue gap too large: no upgrade offer
    ; Check city range: only offer upgrade if cities are in matching range category
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch                      ; 1 if city_a and city_b are in same range category
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    bne.w   .l31eba                     ; different ranges: skip upgrade offer
    ; Show upgrade offer message based on type_distance:
    cmpi.w  #$2, -$b6(a6)              ; type_distance == 2 (domestic)?
    bne.b   .l31d9c
    clr.l   -(a7)
    move.l  ($00047B38).l, -(a7)        ; domestic upgrade offer format string
.l31d88:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    bra.w   .l31eb2                     ; show text then exit
.l31d9c:
    cmpi.w  #$3, -$b6(a6)              ; type_distance == 3 (international)?
    bne.w   .l31eba
    clr.l   -(a7)
    move.l  ($00047B3C).l, -(a7)        ; international upgrade offer format string
    bra.b   .l31d88
.l31db0:
    ; No open slot: "all slots occupied" message
    clr.l   -(a7)
    move.l  ($00047C00).l, -(a7)        ; ptr to "no open slots" format string
    bra.b   .l31d88
.l31dba:
    ; Route is profitable: show generic positive/thank-you message
    pea     ($0001).w
    move.l  ($00047BC4).l, -(a7)        ; ptr to positive acknowledgment format string
    bra.b   .l31d88

; --- Phase: Suspended / zero-target route dialogue ---
    ; Reached here when route has no revenue target (empty) or is suspended.
    ; Dispatch on status_flags bits to select the appropriate dialogue message.
.l31dc6:
    move.b  $a(a4), d0                  ; route_slot.status_flags
    btst    #$1, d0                     ; bit 1 = SUSPENDED?
    beq.b   .l31e0c                     ; not suspended: check bit 2 (ESTABLISHED)
    ; Route is suspended (bit 1 set): show suspension dialogue with both city names
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; city_b index
    lsl.w   #$2, d0                     ; * 4 = longword index into CityNamePtrs
    movea.l  #$0005E680,a0              ; CityNamePtrs ($5E680)
    move.l  (a0,d0.w), -(a7)           ; city_b name string ptr
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; city_a name string ptr
    move.l  ($00047BAC).l, -(a7)        ; ptr to "suspended route" format string
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    bra.w   .l31eb0
.l31e0c:
    ; Check status_flags bit 2 (ESTABLISHED flag): different dialogue from bit 1
    move.b  $a(a4), d0                  ; route_slot.status_flags
    btst    #$2, d0                     ; bit 2 = ESTABLISHED?
    beq.b   .l31e64                     ; neither bit: show generic city-pair message
    ; Bit 2 set (ESTABLISHED): route exists but has zero revenue target -- show "restart" dialogue
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; city_b index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0              ; CityNamePtrs
    move.l  (a0,d0.w), -(a7)           ; city_b name ptr
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; city_a name ptr
    move.l  ($00047BDC).l, -(a7)        ; ptr to "established route (restart?)" format string
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BE0).l, -(a7)        ; ptr to restart-offer follow-up format string
    bra.b   .l31eb0
.l31e64:
    ; No special flag: show generic "no revenue target" message with city names
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; city_b index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0              ; CityNamePtrs
    move.l  (a0,d0.w), -(a7)           ; city_b name ptr
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a index
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)           ; city_a name ptr
    move.l  ($00047BF8).l, -(a7)        ; ptr to "empty slot" format string
    move.l  a5, -(a7)
    jsr sprintf
    clr.l   -(a7)
    move.l  a5, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $20(a7), a7
    pea     ($0001).w
    move.l  ($00047BFC).l, -(a7)        ; ptr to empty-slot follow-up format string
.l31eb0:
    clr.l   -(a7)
.l31eb2:
    ; Common ShowText tail: show final queued message and return
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
.l31eba:
    movem.l -$e0(a6), d2-d7/a2-a5      ; restore all saved registers
    unlk    a6
    rts
