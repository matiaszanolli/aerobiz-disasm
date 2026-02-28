; ============================================================================
; CalcCharAdvantage -- Compute character advantage score from player ranking, city traffic stats, entity bitfield, and stat descriptors
; Called: ?? times.
; 518 bytes | $008458-$00865D
;
; Stack args (from callers):
;   +$08(a6) = player_index   (d7 below)
;   +$0C(a6) = city_index     (d6 below)
;
; Returns d0.w = advantage score (0..14)
;
; Algorithm overview:
;   1. Load player record, tab32_8824 entry, city_data entry.
;   2. Compute raw traffic delta: tab32_8824[city].byte0 - [city].byte1.
;   3. Rank the requesting player among all 4 players (d3 = how many players
;      score strictly higher; starts at 4 and decrements for each rival).
;   4. Combine ranking d3 with traffic delta to produce a raw benefit d2.
;   5. Apply entity-bitfield bonus/penalty based on whether the player
;      already has a stake in the city.
;   6. Clamp final score to [0..14] and [0..raw_delta] bounds.
; ============================================================================
CalcCharAdvantage:                                                  ; $008458
; --- Phase: Setup ---
    link    a6,#-$4                                    ; allocate 4-byte local frame
    movem.l d2-d7/a2-a5,-(sp)                         ; preserve caller registers
    move.l  $000c(a6),d6                               ; d6 = city_index (arg +$0C)
    move.l  $0008(a6),d7                               ; d7 = player_index (arg +$08)
    lea     -$0002(a6),a5                              ; a5 -> local word at -$02(a6): raw traffic delta storage
; --- Phase: Pointer setup ---
    move.w  d7,d0
    mulu.w  #$24,d0                                    ; offset = player_index * $24 (player record stride)
    movea.l #$00ff0018,a0                              ; player_records base ($FF0018)
    lea     (a0,d0.w),a0                               ; a0 -> player_records[player_index]
    movea.l a0,a4                                      ; a4 = this player's record pointer
    move.w  d6,d0
    add.w   d0,d0                                      ; city_index * 2 (stride-2 table)
    movea.l #$00ff8824,a0                              ; tab32_8824 ($FF8824): 32-entry stride-2 table
    lea     (a0,d0.w),a0                               ; a0 -> tab32_8824[city_index]
    movea.l a0,a2                                      ; a2 = tab32_8824 entry pointer (traffic bytes)
    move.w  d6,d0
    lsl.w   #$3,d0                                     ; city_index * 8 (city_data inner stride: 4 entries x 2)
    move.w  d7,d1
    add.w   d1,d1                                      ; player_index * 2 (2 bytes per entry in stride-2 city_data)
    add.w   d1,d0                                      ; combined: city_index*8 + player_index*2
    movea.l #$00ffba80,a0                              ; city_data base ($FFBA80): 89 cities x 4 entries x 2
    lea     (a0,d0.w),a0                               ; a0 -> city_data[city_index][player_index]
    movea.l a0,a3                                      ; a3 = this player's city_data entry
; --- Phase: Compute raw traffic delta ---
    moveq   #$0,d0
    move.b  (a2),d0                                    ; d0 = tab32_8824[city].byte0 (traffic stat A)
    moveq   #$0,d1
    move.b  $0001(a2),d1                               ; d1 = tab32_8824[city].byte1 (traffic stat B)
    sub.w   d1,d0                                      ; d0 = delta = A - B
    move.w  d0,(a5)                                    ; store raw delta at -$02(a6)
; --- Phase: Player ranking (domestic city, city_index < $20) ---
    moveq   #$4,d3                                     ; d3 = ranking counter; start at 4 (all players below)
    cmpi.w  #$20,d6                                    ; is city_index < 32 (domestic route)?
    bge.b   .l84e8                                     ; no -> international path
; Domestic: compare this player's score directly from $FF0230 table (stride $10)
    move.w  d7,d0
    lsl.w   #$4,d0                                     ; player_index * $10 (row stride in $FF0230 block)
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d4                               ; d4 = this player's score entry at $FF0230
    clr.w   d2                                         ; d2 = rival loop counter (0..3)
.l84ca:                                                 ; $0084CA
; Loop: for each of 4 players, count how many beat this player
    move.w  d2,d0
    lsl.w   #$4,d0                                     ; rival_index * $10
    movea.l #$00ff0230,a0
    move.w  (a0,d0.w),d0                               ; rival's score
    cmp.w   d4,d0                                      ; rival >= this player?
    bcc.b   .l84de                                     ; yes -> do not decrement (rival not strictly lower)
    subq.w  #$1,d3                                     ; rival is lower -> decrement rank counter
.l84de:                                                 ; $0084DE
    addq.w  #$1,d2                                     ; next rival
    cmpi.w  #$4,d2                                     ; checked all 4?
    bcs.b   .l84ca
    bra.b   .l8530
.l84e8:                                                 ; $0084E8
; International path: city_index >= $20
; First map city_index to a region bucket via RangeLookup
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)                                   ; push city_index as arg
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 = RangeLookup: map city_index -> 0..7 region bucket
    addq.l  #$4,sp
    move.w  d0,d5                                      ; d5 = region bucket
    move.w  d7,d0
    lsl.w   #$4,d0                                     ; player_index * $10
    move.w  d5,d1
    add.w   d1,d1                                      ; region_bucket * 2
    add.w   d1,d0                                      ; combined offset into $FF0232 (international score table)
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d4                               ; d4 = this player's international score
    clr.w   d2                                         ; rival counter
.l850e:                                                 ; $00850E
    move.w  d2,d0
    lsl.w   #$4,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ff0232,a0
    move.w  (a0,d0.w),d0                               ; rival's international score
    cmp.w   d4,d0                                      ; rival >= this player?
    bcc.b   .l8528                                     ; yes -> skip decrement
    subq.w  #$1,d3                                     ; rival lower -> decrement rank counter
.l8528:                                                 ; $008528
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    bcs.b   .l850e
; --- Phase: Convert ranking + hub check into base benefit d2 ---
.l8530:                                                 ; $008530
; Check: does this player's hub_city (+$01) match the requested city?
    moveq   #$0,d0
    move.b  $0001(a4),d0                               ; d0 = player_record[+$01] = hub_city
    move.w  d6,d1
    ext.l   d1                                         ; d1 = city_index (long)
    cmp.l   d1,d0                                      ; is hub_city == city_index?
    bne.b   .l8542                                     ; no -> use ranking formula
    moveq   #$e,d2                                     ; yes (hub city match) -> maximum base benefit = $E (14)
    bra.b   .l854e
.l8542:                                                 ; $008542
; Ranking formula: d2 = $E + $3 - (d3 * $3) = $11 - d3*3
    move.w  d3,d0
    mulu.w  #$3,d0                                     ; d3 * 3
    moveq   #$e,d2                                     ; start at 14
    sub.w   d0,d2                                      ; 14 - (rank * 3)
    addq.w  #$3,d2                                     ; +3 correction -> d2 = 17 - rank*3
; --- Phase: Scale base benefit by traffic delta (SignedDiv) ---
.l854e:                                                 ; $00854E
; Compute: benefit_scaled = (raw_delta * 2) / 3
    moveq   #$0,d0
    move.w  (a5),d0                                    ; d0 = raw traffic delta (from -$02(a6))
    add.l   d0,d0                                      ; d0 * 2
    moveq   #$3,d1                                     ; divisor = 3
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A = SignedDiv: d0 = (delta*2)/3
    moveq   #$0,d1
    move.w  d2,d1                                      ; d1 = base benefit cap
    cmp.l   d1,d0                                      ; scaled_result > cap?
    ble.b   .l856a
    moveq   #$0,d0
    move.w  d2,d0                                      ; clamp to cap
    bra.b   .l8578
.l856a:                                                 ; $00856A
; Recompute (delta*2)/3 for the uncapped path
    moveq   #$0,d0
    move.w  (a5),d0
    add.l   d0,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A = SignedDiv
.l8578:                                                 ; $008578
; Ensure minimum benefit = 1
    move.w  d0,d2
    cmpi.w  #$1,d2
    bls.b   .l8586                                     ; already <= 1: skip
    moveq   #$0,d0
    move.w  d2,d0                                      ; keep d2
    bra.b   .l8588
.l8586:                                                 ; $008586
    moveq   #$1,d0                                     ; floor at 1
.l8588:                                                 ; $008588
    move.w  d0,d2                                      ; d2 = benefit score (1..14)
; --- Phase: Entity-bitfield modifier (domestic cities only) ---
    cmpi.w  #$20,d6                                    ; domestic (city_index < $20)?
    bge.b   .l85f0                                     ; no -> skip modifier, set d6=14
    moveq   #$0,d0
    move.b  $0001(a4),d0                               ; player_record.hub_city
    cmp.w   d6,d0                                      ; hub matches city?
    bne.b   .l85b4                                     ; no -> check entity bitfield
; Hub-city match: apply 3/4 scaling to traffic A byte
    moveq   #$0,d0
    move.b  (a2),d0                                    ; d0 = tab32_8824[city].byte0 (traffic A)
    andi.l  #$ffff,d0                                  ; zero-extend to long
    move.l  d0,d1
    add.l   d0,d0                                      ; d0 * 2
    add.l   d1,d0                                      ; d0 * 3  (d0*2 + original)
.l85aa:                                                 ; $0085AA
; Arithmetic right shift by 2 with sign-rounding: if negative add 3 before shifting
    bge.b   .l85ae
    addq.l  #$3,d0                                     ; add bias before arithmetic shift (sign-correct rounding)
.l85ae:                                                 ; $0085AE
    asr.l   #$2,d0                                     ; d0 = (traffic_A * 3) >> 2 (floor division by 4)
.l85b0:                                                 ; $0085B0
    move.w  d0,d6                                      ; d6 = city_derived advantage ceiling
    bra.b   .l85f2
.l85b4:                                                 ; $0085B4
; Check entity bitfield: does this player own/have stake in the city?
    move.w  d6,d0
    ext.l   d0                                         ; d0 = city_index (long)
    moveq   #$1,d1
    lsl.l   d0,d1                                      ; d1 = bit mask: 1 << city_index
    move.l  d1,d0
    move.w  d7,d1
    lsl.w   #$2,d1                                     ; player_index * 4 (longword stride)
    movea.l #$00ff08ec,a0                              ; entity_bits ($FF08EC): longword bitfield array
    and.l   (a0,d1.w),d0                               ; test player's bit for this city
    beq.b   .l85e2                                     ; bit clear -> no stake (use unsigned delta path)
; Player has a stake: halve the traffic A byte (rounded down)
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bge.b   .l85de                                     ; non-negative -> skip bias
    addq.l  #$1,d0                                     ; negative bias before shift
.l85de:                                                 ; $0085DE
    asr.l   #$1,d0                                     ; halve: d0 = traffic_A / 2
    bra.b   .l85b0                                     ; store as d6 ceiling
.l85e2:                                                 ; $0085E2
; No stake: use raw traffic A byte, then apply 3/4 scale (bra to .l85aa)
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bra.b   .l85aa                                     ; -> 3/4 scale and store to d6
.l85f0:                                                 ; $0085F0
; International city: set maximum ceiling = $E (14)
    moveq   #$e,d6
; --- Phase: Final clamp ---
.l85f2:                                                 ; $0085F2
; If d6 (city ceiling) > city_data byte (raw demand), compute d2 bounded result
    moveq   #$0,d0
    move.w  d6,d0                                      ; d0 = city ceiling value
    moveq   #$0,d1
    move.b  (a3),d1                                    ; d1 = city_data[city_index][player_index] byte (raw demand)
    cmp.l   d1,d0                                      ; d6 > raw_demand?
    ble.b   .l8650                                     ; no -> result = 0
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0                                      ; d0 = city_ceiling - raw_demand
    moveq   #$0,d1
    move.w  d2,d1                                      ; d1 = benefit score
    cmp.l   d1,d0                                      ; (ceiling - demand) > benefit?
    ble.b   .l861c                                     ; no -> use (ceiling - demand)
    moveq   #$0,d0
    move.w  d2,d0                                      ; clamp to benefit score
    bra.b   .l862c
.l861c:                                                 ; $00861C
; (ceiling - demand) is smaller: use that as result
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$0,d1
    move.b  (a3),d1
    andi.l  #$ffff,d1
    sub.l   d1,d0                                      ; d0 = ceiling - raw_demand
.l862c:                                                 ; $00862C
    move.w  d0,d2                                      ; d2 = candidate result
    cmpi.w  #$e,d2                                     ; above maximum $E (14)?
    bcc.b   .l863a
    moveq   #$0,d0
    move.w  d2,d0                                      ; within range
    bra.b   .l863c
.l863a:                                                 ; $00863A
    moveq   #$e,d0                                     ; cap at $E = 14
.l863c:                                                 ; $00863C
; Also clamp against raw traffic delta stored in (a5)
    move.w  d0,d2
    cmp.w   (a5),d2                                    ; d2 >= raw_delta?
    bcc.b   .l8648                                     ; yes -> use raw_delta as ceiling
    moveq   #$0,d0
    move.w  d2,d0                                      ; d2 < delta: use d2
    bra.b   .l864c
.l8648:                                                 ; $008648
    moveq   #$0,d0
    move.w  (a5),d0                                    ; use raw traffic delta as ceiling
.l864c:                                                 ; $00864C
    move.w  d0,d2
    bra.b   .l8652
.l8650:                                                 ; $008650
    clr.w   d2                                         ; city ceiling <= raw demand -> advantage = 0
; --- Phase: Return ---
.l8652:                                                 ; $008652
    move.w  d2,d0                                      ; d0 = final advantage score (0..14)
    movem.l -$002c(a6),d2-d7/a2-a5                    ; restore registers
    unlk    a6
    rts
