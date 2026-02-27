; ============================================================================
; NegotiateContract -- Processes a single route-slot negotiation tick:
; checks whether both endpoint cities have capacity headroom, computes the
; maximum frequency growth allowed by quality/capacity, applies it to the
; route slot and city data, then triggers char growth/level-up events for
; chars at full-capacity cities, or schedules training if the route is
; already at its service ceiling.
; 632 bytes | $032A28-$032C9F
;
; Args (C-style):
;   $8(a6)  = player index       (d4, word)
;   $e(a6)  = route slot index   (d1, word; loaded into mulu immediately)
;
; Register map (stable across body):
;   d4 = player index (0-3)
;   d2 = 0 = success flag (nonzero on return = no growth applied)
;   d3 = city_a available capacity  (city_a[0] - city_a[1])
;   d5 = route growth headroom      = min(quality_headroom, freq_ceiling)
;   d6 = city_b available capacity  (city_b[0] - city_b[1])
;   d7 = plane_type nibble (from GetByteField4 on route slot)
;   a2 = route slot ptr: $FF9A20 + player*$320 + slot*$14
;   a3 = city_data ptr for city_b:  $FFBA80 + city_b*8 + player*2
;   a4 = city_data ptr for city_a:  $FFBA80 + city_a*8 + player*2
;
; Route slot field layout (a2, 20 bytes, stride $14):
;   +$00 = city_a  (source city index, byte)
;   +$01 = city_b  (dest city index, byte)
;   +$02 = plane_type (packed nibbles: low=class A, high=class B)
;   +$03 = frequency (0-$0E; max 14)
;   +$04 = ticket_price (word)
;   +$0B = service_quality (computed quality byte)
;
; city_data layout at $FFBA80 (per city, 8 bytes = 4 entries x 2 bytes):
;   stride-8 per city; player*2 selects column within each city block
;   +$00 = total/current slot count  (byte at even address)
;   +$01 = slot capacity ceiling      (byte at odd address)
;   city_available = [0] - [1]
; ============================================================================
NegotiateContract:
    link    a6,#$0
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $8(a6), d4                 ; d4 = player index
    clr.w   d2                         ; d2 = result flag (0=growth applied)

; --- Phase: Route Slot Address Computation ---
; a2 = $FF9A20 + player*$0320 + slot*$14
; $0320 = 800 bytes/player = 40 slots * 20 bytes/slot
    move.w  d4, d0
    mulu.w  #$320, d0                  ; d0 = player * $320 (800 bytes per player)
    move.w  $e(a6), d1                 ; d1 = route slot index
    mulu.w  #$14, d1                   ; d1 = slot * $14 (20 bytes per slot)
    add.w   d1, d0                     ; d0 = total offset into route slot array
    movea.l  #$00FF9A20,a0             ; route_slots base ($FF9A20: 4 players x 40 slots x $14)
    lea     (a0,d0.w), a0
    movea.l a0, a2                     ; a2 = route slot for (player, slot_index)

; --- Phase: Load Plane Type and Route Score ---
    move.l  a2, -(a7)
    jsr GetByteField4                  ; get packed 4-bit field from a2+$02 (plane_type nibble)
    move.w  d0, d7                     ; d7 = plane_type code (low nibble of route +$02)
    ; Lookup aircraft capacity for this plane type
    ; $FFA6B9 + plane_code*12: RAM aircraft stats table (12 bytes/entry)
    mulu.w  #$c, d0                    ; d0 = plane_code * 12
    movea.l  #$00FFA6B9,a0             ; $FFA6B9 = aircraft stats table base (RAM, 12 bytes/entry)
    move.b  (a0,d0.w), d1             ; d1 = aircraft_capacity byte for this plane type
    ; CharCodeScore(city_b, city_a) -> d3 = route compatibility/base-revenue score
    moveq   #$0,d0
    move.b  $1(a2), d0                 ; a2+$01 = city_b (destination city index)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0                   ; a2+$00 = city_a (source city index)
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore                  ; CharCodeScore(city_b, city_a) -> d0 = base score
    lea     $c(a7), a7
    move.w  d0, d3                     ; d3 = route base score (from city code compatibility)

; --- Phase: Ticket Price Premium Calculation ---
; premium% = (ticket_price - base_score) * 100 / base_score
; Result stored back in d3 (reuses register -- d3 now = premium percentage).
    move.w  $4(a2), d0                 ; a2+$04 = ticket_price (word)
    sub.w   d3, d0                     ; d0 = ticket_price - base_score = premium
    ext.l   d0
    moveq   #$64,d1                    ; $64 = 100 (percentage scale)
    jsr Multiply32                     ; d0 = premium * 100
    move.w  d3, d1
    ext.l   d1                         ; d1 = base_score
    jsr SignedDiv                      ; d0 = (premium * 100) / base_score = premium%
    move.w  d0, d3                     ; d3 = ticket premium percentage

; --- Phase: City Data Pointer Setup ---
; city_data at $FFBA80: each city occupies 8 bytes (4 entries x 2 bytes)
; Within a city's 8-byte block: player*2 = byte offset for this player's column
; So: city_entry = $FFBA80 + city_index*8 + player*2
    moveq   #$0,d0
    move.b  (a2), d0                   ; a2+$00 = city_a index
    lsl.w   #$3, d0                    ; d0 = city_a * 8 (8 bytes/city in city_data)
    move.w  d4, d1
    add.w   d1, d1                     ; d1 = player * 2 (word column offset)
    add.w   d1, d0                     ; d0 = city_a*8 + player*2
    movea.l  #$00FFBA80,a0             ; city_data base ($FFBA80: 89 cities x 4 entries x 2 bytes)
    lea     (a0,d0.w), a0
    movea.l a0, a4                     ; a4 = city_data entry for city_a

    moveq   #$0,d0
    move.b  $1(a2), d0                 ; a2+$01 = city_b index
    lsl.w   #$3, d0                    ; d0 = city_b * 8
    move.w  d4, d1
    add.w   d1, d1                     ; d1 = player * 2
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                     ; a3 = city_data entry for city_b

    ; If premium% <= 0: no growth possible (route not profitable enough)
    tst.w   d3
    ble.w   l_32c94                    ; premium <= 0: return d2=0 (no action)

; --- Phase: Compute Available City Capacity ---
; city_data[city][player].byte[0] = total slots used/allocated
; city_data[city][player].byte[1] = capacity ceiling
; available = byte[0] - byte[1]
    moveq   #$0,d3
    move.b  (a4), d3                   ; city_a total slot count
    moveq   #$0,d0
    move.b  $1(a4), d0                 ; city_a capacity ceiling
    sub.w   d0, d3                     ; d3 = city_a available slots (can be 0 = full)
    moveq   #$0,d6
    move.b  (a3), d6                   ; city_b total slot count
    moveq   #$0,d0
    move.b  $1(a3), d0                 ; city_b capacity ceiling
    sub.w   d0, d6                     ; d6 = city_b available slots (can be 0 = full)

; --- Phase: Compute Route Growth Headroom (d5) ---
; quality_headroom = (service_quality * 95 / 100) - frequency
; This measures how many more frequency slots the route quality can support.
; Cap: also can't exceed (14 - frequency) because 14 is the hard frequency max.
    moveq   #$0,d0
    move.b  $b(a2), d0                 ; a2+$0B = service_quality byte
    andi.l  #$ffff, d0                 ; zero-extend to long
    moveq   #$5F,d1                    ; $5F = 95 (95% of quality = usable capacity)
    jsr Multiply32                     ; d0 = service_quality * 95
    moveq   #$64,d1                    ; $64 = 100 (percentage divisor)
    jsr SignedDiv                      ; d0 = quality * 95 / 100 = quality headroom
    moveq   #$0,d1
    move.b  $3(a2), d1                 ; a2+$03 = current frequency
    sub.w   d1, d0                     ; d0 = quality_headroom - frequency = growth potential
    move.w  d0, d5                     ; d5 = quality-based growth headroom

    ; Cap at frequency ceiling: d5 = min(d5, 14 - frequency)
    ; 14 = $0E = max frequency (from DATA_STRUCTURES: frequency max = $0E)
    moveq   #$0,d0
    move.b  $3(a2), d0                 ; current frequency
    moveq   #$E,d1                     ; $E = 14 = frequency hard maximum
    sub.l   d0, d1                     ; d1 = 14 - frequency = ceiling gap
    move.l  d1, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0                     ; compare ceiling_gap vs quality_headroom
    ble.b   l_32b34                    ; ceiling_gap <= quality_headroom: use ceiling_gap
    move.w  d5, d0                     ; ceiling_gap > quality_headroom: use quality headroom
    ext.l   d0
    bra.b   l_32b40
l_32b34:
    ; ceiling_gap is the binding constraint
    moveq   #$0,d0
    move.b  $3(a2), d0                 ; frequency
    moveq   #$E,d1                     ; 14
    sub.l   d0, d1
    move.l  d1, d0                     ; d0 = 14 - frequency
l_32b40:
    move.w  d0, d5                     ; d5 = effective growth headroom = min(quality, ceiling)

; --- Phase: Growth Conditions Check ---
; Growth requires all three conditions simultaneously:
;   d3 > 0 (city_a has open capacity)
;   d6 > 0 (city_b has open capacity)
;   d5 > 0 (route has growth headroom)
    tst.w   d3
    beq.b   l_32bbc                    ; city_a full: skip growth
    tst.w   d6
    beq.b   l_32bbc                    ; city_b full: skip growth
    tst.w   d5
    ble.b   l_32bbc                    ; no headroom: skip growth

; --- Phase: Compute Slot Increment (d2 = slots to add) ---
; d2 = min(city_a_available, city_b_available) -- bounded by whichever city is tighter
    cmp.w   d6, d3                     ; compare city_a vs city_b availability
    bcc.b   l_32b58                    ; city_a >= city_b: city_b is the tighter constraint
    moveq   #$0,d2
    move.w  d3, d2                     ; d2 = city_a (smaller)
    bra.b   l_32b5c
l_32b58:
    moveq   #$0,d2
    move.w  d6, d2                     ; d2 = city_b (smaller)
l_32b5c:
    ; d2 = min(d2, d5) -- also bounded by quality/frequency headroom
    moveq   #$0,d0
    move.w  d2, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0                     ; d2 vs d5
    bge.b   l_32b6e                    ; d2 >= d5: headroom is binding, use d5
    moveq   #$0,d0
    move.w  d2, d0                     ; d2 < d5: city capacity is binding, keep d2
    bra.b   l_32b72
l_32b6e:
    move.w  d5, d0
    ext.l   d0                         ; d0 = d5 (headroom is tighter)
l_32b72:
    move.w  d0, d2                     ; d2 = effective slot increment

; --- Phase: Frequency-Tier Cap ---
; Additional cap on increment based on current frequency tier:
;   If frequency >= 7 ($07): max increment is 2
;   Else:                    max increment is (7 - frequency) = remaining slots to tier boundary
; The threshold of 7 is the upgrade check boundary from DATA_STRUCTURES (+$03 frequency note).
    cmpi.b  #$7, $3(a2)               ; a2+$03 = frequency; compare to tier boundary 7
    bcs.b   l_32b8c                   ; frequency < 7: apply sub-tier cap
    ; High-frequency tier (>= 7): cap increment at 2
    cmpi.w  #$2, d2
    bcc.b   l_32b88                   ; d2 >= 2: cap to 2
l_32b82:
    moveq   #$0,d0
    move.w  d2, d0                    ; d2 <= 2: keep as-is
    bra.b   l_32bac
l_32b88:
    moveq   #$2,d0                    ; cap: max 2 slots per tick in high-freq tier
    bra.b   l_32bac
l_32b8c:
    ; Low-frequency tier (< 7): cap at (7 - frequency) to stay within tier
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1                    ; d1 = 7 - frequency = slots to tier boundary
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0                    ; (7-freq) vs d2
    bgt.b   l_32b82                   ; (7-freq) > d2: d2 is binding, keep
    moveq   #$0,d0
    move.b  $3(a2), d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, d0                    ; d0 = 7 - frequency (tier boundary cap)
l_32bac:
    move.w  d0, d2                    ; d2 = final slot increment (tier-capped)

; --- Phase: Apply Growth ---
; Commit frequency increase and update both city slot counts
    add.b   d2, $3(a2)                ; route +$03 frequency += d2
    add.b   d2, $1(a4)                ; city_a capacity ceiling += d2
    add.b   d2, $1(a3)                ; city_b capacity ceiling += d2
    moveq   #$1,d2                    ; d2 = 1 (growth was applied; signal success to caller)
l_32bbc:
    ; If d2 != 0: growth was applied or impossible, return
    tst.w   d2
    bne.w   l_32c94

; --- Phase: City-A Capacity Events (city_a is full, d3 == 0) ---
; When city is at capacity, trigger char growth/level-up for the char serving that city.
; a2+$00 = city_a char code; used to identify which char to advance.
    tst.w   d3
    bne.b   l_32bf6                   ; city_a not full: skip growth for city_a char
    moveq   #$0,d0
    move.b  (a2), d0                  ; a2+$00 = city_a char code
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0                    ; player index
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)          ; attempt organic growth for city_a char
    nop
    addq.l  #$8, a7
    tst.w   d0                        ; d0 != 0: growth was not applicable this tick
    bne.b   l_32bf6
    moveq   #$0,d0
    move.b  (a2), d0                  ; city_a char code
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)           ; check and apply level-up for city_a char
    nop
    addq.l  #$8, a7

; --- Phase: City-B Capacity Events (city_b is full, d6 == 0) ---
l_32bf6:
    tst.w   d6
    bne.b   l_32c2e                   ; city_b not full: skip growth for city_b char
    moveq   #$0,d0
    move.b  $1(a2), d0                ; a2+$01 = city_b char code
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ApplyCharGrowth,PC)          ; attempt organic growth for city_b char
    nop
    addq.l  #$8, a7
    tst.w   d0
    bne.b   l_32c2e
    moveq   #$0,d0
    move.b  $1(a2), d0                ; city_b char code
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ProcessLevelUp,PC)           ; check and apply level-up for city_b char
    nop
    addq.l  #$8, a7

; --- Phase: Route Ceiling Check (d5 <= 0: route already at quality ceiling) ---
; If both city events were handled but d5<=0 the route has reached its quality cap.
; In this case: check whether the schedule class can be upgraded (class < 9),
; and if an event slot is available, increment the schedule class and consume the slot;
; otherwise train the char's skill directly.
l_32c2e:
    tst.w   d5
    bgt.b   l_32c94                   ; d5 > 0: still have headroom, return
    ; d5 <= 0: route is at or above quality ceiling
    move.l  a2, -(a7)
    jsr GetLowNibble                  ; get low nibble of route slot plane_type (schedule class tier)
    addq.l  #$4, a7
    move.w  d0, d3                    ; d3 = schedule class (low nibble of route +$02)
    cmpi.w  #$9, d0                   ; $9 = schedule tier maximum
    bcc.b   l_32c94                   ; class >= 9: already at max tier, return

; --- Phase: Schedule Slot Availability Check ---
; Check event_records slot for (player, route): $FFB9E9 + player*32 + route_slot*2
; $FFB9E9 = event_records+1 = odd byte of event_records ($FFB9E8 base)
; event_records: 4 players x $20 bytes each; within each record stride-2 gives 16 effective slots
    move.w  d4, d0
    lsl.w   #$5, d0                    ; d0 = player * 32 ($20 bytes per event record)
    move.w  d7, d1                     ; d7 = plane_type nibble (route identifier index)
    add.w   d1, d1                     ; d1 = d7 * 2 (stride-2 within event record)
    add.w   d1, d0                     ; d0 = player*32 + d7*2
    movea.l  #$00FFB9E9,a0             ; $FFB9E9 = event_records+1 (byte slots at stride 2)
    tst.b   (a0,d0.w)                 ; test event slot byte for this player/route
    beq.b   l_32c82                    ; slot empty: no schedule event pending -> train skill

; --- Phase: Schedule Upgrade (event slot occupied) ---
    ; Event slot is nonzero: upgrade the schedule class and consume the slot
    addq.w  #$1, d3                    ; d3 = schedule_class + 1 (upgrade by one tier)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)                  ; new schedule class
    move.l  a2, -(a7)                  ; route slot ptr
    jsr UpdateCharField                ; write upgraded schedule class back to route slot
    addq.l  #$8, a7
    ; Decrement event slot counter to consume this upgrade opportunity
    move.w  d4, d0
    lsl.w   #$5, d0                    ; player * 32
    move.w  d7, d1
    add.w   d1, d1                     ; d7 * 2
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    subq.b  #$1, (a0,d0.w)            ; event_records slot-- (consume schedule upgrade token)
    bra.b   l_32c94

; --- Phase: Train Skill (no event slot, route at ceiling) ---
l_32c82:
    ; No event pending: directly train the char's skill for this route
    moveq   #$0,d0
    move.w  d7, d0                     ; d7 = slot/route index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0                     ; player index
    move.l  d0, -(a7)
    jsr (TrainCharSkill,PC)            ; train skill for (route_slot, player)
    nop

; --- Phase: Return ---
l_32c94:
    move.w  d2, d0                     ; d0 = result: 0=growth applied, 1=no growth/already done
    movem.l -$24(a6), d2-d7/a2-a4
    unlk    a6
    rts
