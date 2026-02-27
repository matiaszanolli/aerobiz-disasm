; ============================================================================
; ShowStatsSummary -- Computes rank change for a player, formats a summary string, builds the quarterly route/char bonus table, filters by age, and calls result-display for each slot
; Called: ?? times.
; 1030 bytes | $018214-$018619
; ============================================================================
; --- Phase: Setup and Rank-Change Calculation ---
; Arg: $8(a6) = player index (d6).
; a5 = local string/format buffer (-$B0 bytes on stack frame).
; d5 = current quarter/season index (derived from frame_counter at $FF0006).
; d7 = rank-change direction flag: 0 = no change or worse, 1 = improved.
ShowStatsSummary:                                                  ; $018214
    link    a6,#-$d4
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d6         ; d6 = player index (0-3)
    lea     -$00b0(a6),a5        ; a5 = 176-byte local string buffer (sprintf output)
    clr.w   d7                   ; d7 = rank-change flag (0 = not improved)
    ; SumPlayerStats($01045A): sum 16 bytes from $FFB9E9 stat table for this player
    ; Returns signed sum representing player's current ranking score vs previous quarter.
    move.w  d6,d0
    move.l  d0,-(sp)             ; arg: player index
    dc.w    $4eb9,$0001,$045a                           ; jsr SumPlayerStats ($01045A)
    move.w  d0,-$00d2(a6)        ; local[-$D2] = stat sum (negative = dropped, positive = rose)
    ; Compute season index from frame_counter: d5 = (frame_counter >> 2) + $37
    ; $FF0006 = frame_counter (increments each MainLoop tick)
    ; >> 2 scales to quarter units; + $37 ($37 = 55) offsets to a game-year range
    move.w  ($00FF0006).l,d5     ; d5 = frame_counter (current game tick)
    ext.l   d5
    asr.l   #$2,d5               ; d5 >>= 2: convert ticks to quarter units
    addi.w  #$37,d5              ; d5 += $37 = 55: offset to get season/year display value
    ; Check if rank improved: if stat sum > 0, player rose in ranking
    tst.w   -$00d2(a6)
    ble.b   .l1824a              ; <= 0: rank didn't improve
    moveq   #$1,d7               ; d7 = 1: rank improved this quarter
.l1824a:                                                ; $01824A
    ; SumStatBytes($010492): sum 16 bytes from event_records $FFB9E8 for this player
    ; Returns the player's total "rank score" (absolute level, not delta).
    move.w  d6,d0
    move.l  d0,-(sp)             ; arg: player index
    dc.w    $4eb9,$0001,$0492                           ; jsr SumStatBytes ($010492)
    addq.l  #$8,sp               ; pop both args (SumPlayerStats + SumStatBytes)
    move.w  d0,d2                ; d2 = current total rank score
    tst.w   d2
    bne.b   .l1827e              ; nonzero rank: branch to rank-based format selection
    ; --- Phase: Format Rank Summary String (Zero Score = First-Time Display) ---
    ; d2==0 means this is the player's first quarter or no routes active.
    ; Use sprintf($03B22C) with a "welcome / getting started" format string.
    ; Format string pointers from ROM at $47B7C and $47C1C (specific to rank-0 message).
    move.l  ($00047B7C).l,-(sp)  ; arg: format string pointer for rank-0 (first quarter)
    move.l  ($00047C1C).l,-(sp)  ; arg: second format part (continuation string)
    move.l  a5,-(sp)             ; arg: output buffer (a5 = local stack string buffer)
    dc.w    $4eb9,$0003,$b22c                           ; jsr sprintf ($03B22C) -- format rank-0 message
    lea     $000c(sp),sp
    pea     ($0002).w            ; arg: display mode = 2
    move.l  a5,-(sp)             ; arg: formatted string buffer
    bra.w   .l185f6              ; skip to result display call
.l1827e:                                                ; $01827E
    ; --- Phase: Select Rank-Change Format String ---
    ; Compare d2 (current rank) with local[-$D2] (previous rank / stat delta).
    ; Cases:
    ;   d2 == stat_delta: rank unchanged (same score both periods)
    ;   stat_delta == 0:  rank fell (dropped from last quarter)
    ;   else:             rank rose by (d2 - delta) places
    cmp.w   -$00d2(a6),d2        ; d2 = current rank, local[-$D2] = delta/previous
    bne.b   .l182b2              ; different: rank changed
    ; Rank unchanged: use a "steady / holding" format string
    ; Two sub-cases based on rank value:
    ;   rank == 1: use $4109C format (top-rank unchanged: "Staying in 1st")
    ;   rank != 1: use $4109C or $410A4 (other rank: "Holding at rank N")
    cmpi.w  #$1,d2               ; rank == 1 (top position)?
    bne.b   .l18292
    pea     ($000410A4).l        ; format string for "holding at 1st place" message
    bra.b   .l18298
.l18292:                                                ; $018292
    pea     ($0004109C).l        ; format string for "holding at rank N" (rank != 1)
.l18298:                                                ; $018298
    ; sprintf(buf=a5, fmt=@stack, rank=d2): format "holding at rank N" message
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg: current rank value (for "%d" in format string)
    move.l  ($00047C2C).l,-(sp)  ; arg: secondary format string (continuation)
    move.l  a5,-(sp)             ; arg: output buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr sprintf ($03B22C)
    lea     $0010(sp),sp         ; pop 4 args
    bra.b   .l18318
.l182b2:                                                ; $0182B2
    ; Rank changed: check direction (rose vs fell)
    tst.w   -$00d2(a6)           ; local[-$D2] = stat delta (positive = rose, 0 = fell)
    bne.b   .l182d2              ; nonzero delta: rank rose
    ; Delta == 0: rank fell (player had positive score last quarter but dropped)
    ; Format "fell to rank N" message
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg: new (lower) rank
    move.l  ($00047C28).l,-(sp)  ; arg: format string for "dropped to rank N"
    move.l  a5,-(sp)             ; arg: output buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr sprintf ($03B22C)
    lea     $000c(sp),sp
    bra.b   .l18318
.l182d2:                                                ; $0182D2
    ; Rank rose: compute places gained = d2 - local[-$D2]
    ; Two format strings based on places gained:
    ;   1 place:  $41096 ("moved up 1 place to rank N")
    ;   N places: $4108E ("moved up N places to rank N")
    move.w  d2,d0
    ext.l   d0
    move.w  -$00d2(a6),d1        ; d1 = stat delta (previous rank or change value)
    ext.l   d1
    sub.l   d1,d0                ; d0 = places gained = current - previous
    moveq   #$1,d1
    cmp.l   d0,d1
    bne.b   .l182ec              ; gained more than 1 place: use "N places" format
    pea     ($00041096).l        ; format string: "moved up 1 place to rank N"
    bra.b   .l182f2
.l182ec:                                                ; $0182EC
    pea     ($0004108E).l        ; format string: "moved up N places to rank N"
.l182f2:                                                ; $0182F2
    ; sprintf(buf, fmt, rank, places_gained): format "rose N places to rank M"
    move.w  d2,d0
    ext.l   d0
    move.w  -$00d2(a6),d1
    ext.l   d1
    sub.l   d1,d0                ; d0 = places gained (recomputed)
    move.l  d0,-(sp)             ; arg: places gained (for "%d" #1 in format)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)             ; arg: new rank (for "%d" #2 in format)
    move.l  ($00047C24).l,-(sp)  ; arg: format string continuation
    move.l  a5,-(sp)             ; arg: output buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr sprintf ($03B22C) -- "moved up" message
    lea     $0014(sp),sp         ; pop 5 args
.l18318:                                                ; $018318
    ; --- Phase: Render Rank Summary String and Initialize Route/Char Bonus Tables ---
    ; RandRange($01D6A4): generate random value in range [0, 3] for result display variation.
    ; $02FBD6: display/render the rank summary with the formatted string.
    clr.l   -(sp)                ; arg: min = 0
    move.l  a5,-(sp)             ; arg: formatted string buffer (sprintf output)
    pea     ($0003).w            ; arg: max = 3 (random 0-3 for display mode selection)
    clr.l   -(sp)                ; arg: extra = 0
    dc.w    $4eb9,$0001,$d6a4                           ; jsr RandRange ($01D6A4) -- random 0-3
    addq.l  #$8,sp               ; pop RandRange args
    move.l  d0,-(sp)             ; arg: random display mode (0-3)
    move.w  d6,d0
    move.l  d0,-(sp)             ; arg: player index
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- render rank summary string
    lea     $0010(sp),sp
    ; --- Phase: Initialize Route-Pair Result Table and Char-Bonus Accumulator ---
    ; Initialize 4 slot-pair result entries (at -$10(a6)) to $FFFF,$FFFF = empty/invalid.
    ; These hold (route_slot, bonus_value) pairs for the top contributing routes.
    clr.w   d2                   ; d2 = slot-pair table index (0-3)
    move.w  d2,d0
    lsl.w   #$2,d0               ; d0 = index * 4 (longword offset)
    lea     -$10(a6,d0.w),a0     ; a0 = &result_tab[0] (4 × (word,word) pairs)
    movea.l a0,a2
.l18346:                                                ; $018346
    ; Each result entry: first word = route slot ($FFFF=empty), second word = bonus ($FFFF=none)
    move.w  #$ffff,(a2)          ; slot = $FFFF (empty slot sentinel)
    move.w  #$ffff,$0002(a2)     ; bonus = $FFFF (invalid / not yet computed)
    addq.l  #$4,a2               ; advance to next (word,word) pair
    addq.w  #$1,d2
    cmpi.w  #$4,d2               ; initialize all 4 result slots
    blt.b   .l18346
    ; Initialize 16-entry char-bonus accumulator to $FFFF = unvisited.
    ; One entry per character slot (16 chars in the roster).
    ; Stored at -$D0(a6): 16 × word, indexed by char slot number.
    clr.w   d2                   ; d2 = char slot index (0-15)
.l1835c:                                                ; $01835C
    move.w  d2,d0
    add.w   d0,d0                ; d0 = index * 2 (word offset)
    lea     -$00d0(a6),a0        ; a0 = char bonus accumulator base
    move.w  #$ffff,(a0,d0.w)     ; char_bonus_acc[i] = $FFFF (not yet accumulated)
    addq.w  #$1,d2
    cmpi.w  #$10,d2              ; initialize all 16 char slots
    blt.b   .l1835c
    ; --- Phase: Locate Player Record and Count Active Route Slots ---
    ; player_records base = $FF0018, stride $24 (36 bytes per player).
    ; Load domestic_slots (+$04) and intl_slots (+$05) to get total route count.
    move.w  d6,d0
    mulu.w  #$24,d0              ; d0 = player_index * $24 (player_record stride = 36)
    movea.l #$00ff0018,a0        ; a0 = $FF0018 (player_records base)
    lea     (a0,d0.w),a0         ; a0 = &player_records[player]
    movea.l a0,a2                ; a2 = player record pointer (36-byte struct)
    moveq   #$0,d0
    move.b  $0004(a2),d0         ; d0 = domestic_slots (+$04 of player_record)
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a2),d1         ; d1 = intl_slots (+$05 of player_record)
    ext.l   d1
    add.l   d1,d0                ; d0 = total route slots (domestic + international)
    ble.w   .l1841e              ; zero or negative: no routes; skip route-scanning loop
    ; --- Phase: Scan Route Slots to Build Char-Bonus Accumulator ---
    ; For each of the player's route slots, compute the char's compatibility score (d4)
    ; versus a threshold, then look up the char's slot assignment and add the surplus to
    ; char_bonus_acc[] keyed by the char's slot number (GetCharStat result).
    move.w  d6,d0
    mulu.w  #$0320,d0            ; d0 = player_index * $320 (800 bytes per player in route_slots)
    movea.l #$00ff9a20,a0        ; a0 = $FF9A20 (route_slots base)
    lea     (a0,d0.w),a0         ; a0 = &route_slots[player][0]
    movea.l a0,a3                ; a3 = walking pointer through this player's route slots ($14 each)
    moveq   #$0,d2               ; d2 = total route count (domestic + intl, computed above)
    move.b  $0004(a2),d2         ; d2 = domestic_slots (+$04 player_record)
    moveq   #$0,d0
    move.b  $0005(a2),d0         ; d0 = intl_slots (+$05 player_record)
    add.w   d0,d2                ; d2 = total route count for this player
    clr.w   d3                   ; d3 = current slot iterator (0 .. d2-1)
    bra.b   .l1841a              ; enter loop at condition check
.l183be:                                                ; $0183BE
    ; Find the minimum compatibility level (d4) at which this char's score equals the threshold.
    ; CalcCompatScore ($007412) returns a compatibility score for the char at (a3).
    ; We iterate d4 upward until CalcCompatScore * d4 / $14 > $0E (14).
    moveq   #$1,d4               ; d4 = compatibility threshold level (starts at 1)
    bra.b   .l183c4
.l183c2:                                                ; $0183C2
    addq.w  #$1,d4               ; increment threshold if score still too low
.l183c4:                                                ; $0183C4
    ; CalcCompatScore(a3): compute compatibility score for the char in this route slot
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$7412                           ; jsr CalcCompatScore ($007412)
    addq.l  #$4,sp
    ext.l   d0                   ; d0 = raw compatibility score
    ; Multiply32(d0, d4): scale score by threshold level
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr Multiply32 ($03E05C)
    ; SignedDiv(d0, $14): normalize by $14 (20) to get score-per-level
    moveq   #$14,d1              ; d1 = $14 = 20 (scaling denominator)
    dc.w    $4eb9,$0003,$e08a                           ; jsr SignedDiv ($03E08A)
    moveq   #$e,d1               ; d1 = $0E = 14 (minimum score threshold)
    cmp.l   d0,d1                ; is normalized score > 14?
    bgt.b   .l183c2              ; not yet: try next d4 level
    ; Score exceeds threshold at level d4.
    ; GetCharStat ($007402) at a3: returns the char slot number for this route
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402 (GetCharStat / slot-lookup)
    addq.l  #$4,sp
    ; Compute bonus surplus: d4 - GetCharStat_result = how much d4 exceeds the baseline
    move.w  d4,d1
    sub.w   d0,d1                ; d1 = d4 - char_stat_result (bonus surplus)
    move.w  d1,d4                ; d4 = bonus amount for this char slot
    tst.w   d4
    ble.b   .l18414              ; bonus <= 0: no accumulation for this slot
    ; $0074E0: get the char's secondary index/field (slot assignment within the roster)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0 (char roster-slot lookup)
    addq.l  #$4,sp
    ; Index char_bonus_acc[] by the secondary index: acc[idx] += d4
    add.w   d0,d0                ; d0 *= 2 (word offset into char_bonus_acc)
    lea     -$00d0(a6),a0        ; a0 = char_bonus_acc base (-$D0 from frame)
    lea     (a0,d0.w),a1
    movea.l a1,a2                ; a2 = &char_bonus_acc[char_index]
    add.w   d4,(a2)              ; char_bonus_acc[char_index] += bonus_surplus
.l18414:                                                ; $018414
    moveq   #$14,d0
    adda.l  d0,a3                ; advance a3 to next route slot ($14 = 20 bytes per slot)
    addq.w  #$1,d3               ; slot iterator++
.l1841a:                                                ; $01841A
    cmp.w   d2,d3                ; loop until all route slots scanned
    blt.b   .l183be
.l1841e:                                                ; $01841E
    ; --- Phase: Filter Char-Bonus Accumulator by Age (Season Range) ---
    ; Walk all 16 char slots. For each slot with a positive bonus accumulated, check:
    ;   1. Is the char's contract age range active this season? (d5 = current season)
    ;      route_slot +$07 (expiry season) must encompass d5 ± 2.
    ;   2. Look up any additional bonus from $FF02E8 (player skill/bonus table).
    ;   3. Apply rank-improvement bonus (d7=1) if player rose in ranking.
    ;   4. If slot qualifies: subtract bonus from the accumulator entry.
    ;      If ineligible or contract expired: invalidate entry ($FFFF).
    ; a3 = event_records[$FFB9E8] walking pointer for this player (stride 2 per slot).
    ; a4 = char_bonus_acc walking pointer.
    clr.w   d3                   ; d3 = char slot iterator (0-15)
    move.w  d6,d0
    lsl.w   #$5,d0               ; d0 = player * $20 (32 bytes per player in event_records)
    move.w  d3,d1                ; d1 = slot 0
    add.w   d1,d1                ; d1 *= 2 (2-byte entries)
    add.w   d1,d0                ; d0 = offset into event_records for player, slot 0
    movea.l #$00ffb9e8,a0        ; a0 = $FFB9E8 (event_records base)
    lea     (a0,d0.w),a0
    movea.l a0,a3                ; a3 = &event_records[player][0]
    ; a4 = &char_bonus_acc[0] (the accumulator built in the route-scan loop)
    move.w  d3,d0
    add.w   d0,d0                ; d0 = slot 0 * 2
    lea     -$00d0(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a4                ; a4 = char_bonus_acc[0]
.l18444:                                                ; $018444
    clr.w   d4                   ; d4 = bonus for this slot (from $FF02E8 lookup)
    tst.w   (a4)                 ; is there any bonus accumulated for this char slot?
    ble.w   .l184d0              ; <= 0 or $FFFF: skip (no bonus or already invalidated)
    ; Look up this char's record in $FFA6B8 by slot:
    ; $FFA6B8 = some per-slot entity table, stride $C (12 bytes per slot).
    move.w  d3,d0
    mulu.w  #$c,d0               ; d0 = slot * $0C (12-byte stride)
    movea.l #$00ffa6b8,a0        ; a0 = $FFA6B8 (entity/char table, stride $0C)
    lea     (a0,d0.w),a0
    movea.l a0,a2                ; a2 = entity record for this char slot
    ; Age/contract check: +$07 = contract expiry season (end period byte)
    ; Valid if: expiry > (d5 + 2) AND expiry > d5 (char is in active contract range)
    moveq   #$0,d0
    move.b  $0007(a2),d0         ; d0 = contract expiry season (+$07 = end period)
    ext.l   d0
    move.w  d5,d1                ; d1 = current season
    ext.l   d1
    addq.l  #$2,d1               ; d1 = d5 + 2 (near-future threshold)
    cmp.l   d1,d0                ; expiry > (season + 2)?
    bgt.b   .l18480              ; yes: char will be around for a while, eligible
    moveq   #$0,d0
    move.b  $0007(a2),d0         ; d0 = expiry season (re-read for comparison)
    cmp.w   d5,d0                ; expiry > current season (d5)?
    ble.b   .l18480              ; yes (NOTE: bgt logic -- see below)
.l1847a:                                                ; $01847A
    ; Contract expired or char not in active range: invalidate this accumulator entry
    move.w  #$ffff,(a4)          ; mark as invalid ($FFFF = no bonus)
    bra.b   .l184d0              ; advance to next slot
.l18480:                                                ; $018480
    ; Char is eligible. Look up any additional bonus from the player's skill table.
    ; $FF02E8 = per-player bonus table, stride $14 (20 bytes per player), 5 × 4-byte entries.
    ; Each entry: byte0 = route_slot_match, byte1 = bonus_value.
    move.w  d6,d0
    mulu.w  #$14,d0              ; d0 = player * $14 (20-byte stride)
    movea.l #$00ff02e8,a0        ; a0 = $FF02E8 (player skill/bonus table)
    lea     (a0,d0.w),a0
    movea.l a0,a2                ; a2 = this player's 5-entry skill bonus table
    clr.w   d2                   ; d2 = entry iterator (0-4)
.l18494:                                                ; $018494
    ; Scan up to 5 entries for one matching this char slot (d3)
    moveq   #$0,d0
    move.b  (a2),d0              ; d0 = byte0 = route slot index this entry applies to
    cmp.w   d3,d0                ; matches current char slot (d3)?
    bne.b   .l184a4              ; no: try next entry
    moveq   #$0,d4
    move.b  $0001(a2),d4         ; d4 = byte1 = bonus value for matching entry
    bra.b   .l184ae              ; found: use this bonus
.l184a4:                                                ; $0184A4
    addq.l  #$4,a2               ; advance to next 4-byte entry
    addq.w  #$1,d2
    cmpi.w  #$5,d2               ; checked all 5 entries?
    blt.b   .l18494              ; loop; d4 stays 0 if no match found
.l184ae:                                                ; $0184AE
    ; Check if char_bonus_acc + skill_bonus exceeds $63 (99 = approval cap)
    ; If bonus + event_record byte >= 100: this char exceeds the cap; invalidate.
    move.w  d4,d0
    ext.l   d0                   ; d0 = skill bonus d4
    moveq   #$0,d1
    move.b  (a3),d1              ; d1 = event_records byte for this slot (current stat byte)
    ext.l   d1
    add.l   d1,d0                ; d0 = skill_bonus + event_record_byte
    moveq   #$63,d1              ; d1 = $63 = 99 (approval rating cap)
    cmp.l   d0,d1
    ble.b   .l1847a              ; <= 99: cap exceeded, invalidate this entry
    ; Bonus is within cap. Apply rank-improvement bonus if player rose this quarter.
    cmpi.w  #$1,d7               ; d7 = 1 means player improved in ranking
    bne.b   .l184ce
    moveq   #$0,d0
    move.b  $0001(a3),d0         ; d0 = event_records second byte (secondary stat/bonus)
    add.w   d0,d4                ; d4 += secondary bonus (rank-improvement bonus applied)
.l184ce:                                                ; $0184CE
    sub.w   d4,(a4)              ; char_bonus_acc[slot] -= final bonus (deduct eligible bonus)
.l184d0:                                                ; $0184D0
    addq.l  #$2,a4               ; advance accumulator pointer (2 bytes per slot)
    addq.l  #$2,a3               ; advance event_records pointer (2 bytes per entry)
    addq.w  #$1,d3               ; next char slot
    cmpi.w  #$10,d3              ; loop over all 16 slots
    blt.w   .l18444
    ; --- Phase: Sort Top Bonus Entries (SortWordPairs) ---
    ; Walk all 16 char-bonus accumulator entries. For each with a non-negative value,
    ; write a (slot_index, bonus) word-pair to the result table at -$10(a6),
    ; then call SortWordPairs to keep only the top 4 by bonus value.
    clr.w   d3                   ; d3 = char slot iterator (0-15)
    move.w  d3,d0
    add.w   d0,d0                ; d0 = slot 0 * 2
    lea     -$00d0(a6),a0        ; a0 = char_bonus_acc base
    lea     (a0,d0.w),a1
    movea.l a1,a2                ; a2 = &char_bonus_acc[0]
.l184ee:                                                ; $0184EE
    tst.w   (a2)                 ; is the bonus value non-negative?
    blt.b   .l1850a              ; negative (including $FFFF as sign-extended -1): skip
    ; Positive bonus: store (slot_index, bonus_value) pair and sort
    move.w  d3,-$0004(a6)        ; result_pair[0] = slot index (d3)
    move.w  (a2),-$0002(a6)      ; result_pair[1] = bonus value (from accumulator)
    ; SortWordPairs($0109FA): insert this pair into the top-4 result table at -$10(a6)
    pea     ($0004).w            ; arg: table size = 4 (keep best 4)
    pea     -$0010(a6)           ; arg: result table base (4 × (slot,bonus) pairs)
    dc.w    $4eb9,$0001,$09fa                           ; jsr SortWordPairs ($0109FA)
    addq.l  #$8,sp
.l1850a:                                                ; $01850A
    addq.l  #$2,a2               ; advance accumulator pointer
    addq.w  #$1,d3               ; next char slot
    cmpi.w  #$10,d3              ; loop over all 16 slots
    blt.b   .l184ee
    ; --- Phase: Render Top-2 Route/Char Bonus Results ---
    ; Iterate the top-2 result table entries (d2=0,1 = up to 2 best results).
    ; For each valid entry: look up the char's contract range in $FFA6B8,
    ; check if they're in-season, select a display format, format the result string,
    ; then call $02FBD6 to render it on screen.
    clr.w   d3                   ; d3 = display mode (0 = in-season char, 5 = out-of-season)
    clr.w   d2                   ; d2 = result table iterator (0-1)
    move.w  d2,d0
    lsl.w   #$2,d0               ; d0 = index * 4 (each result entry = 4 bytes = (word,word))
    lea     -$10(a6,d0.w),a0     ; a0 = &result_tab[0]
    movea.l a0,a3                ; a3 = walking pointer through result table
.l18522:                                                ; $018522
    ; Check if result slot is valid (first word != $FFFF = -1 = empty)
    move.w  (a3),d0             ; d0 = slot index from result table
    ext.l   d0
    moveq   #-$1,d1              ; d1 = -1 ($FFFF extended)
    cmp.l   d0,d1
    beq.w   .l185be              ; slot = $FFFF: no result, skip
    ; Also check the second word of the result pair (-$E offset relative to current d2 entry)
    move.w  d2,d0
    lsl.w   #$2,d0
    tst.w   -$e(a6,d0.w)         ; second word of result pair (bonus value)
    ble.w   .l185be              ; bonus <= 0: skip
    ; Look up this char's entity record in $FFA6B8 (stride $0C = 12 bytes)
    move.w  (a3),d0             ; d0 = slot index
    mulu.w  #$c,d0               ; d0 = slot * $0C (12-byte stride in entity table)
    movea.l #$00ffa6b8,a0        ; a0 = $FFA6B8 (entity/char attribute table)
    lea     (a0,d0.w),a0
    movea.l a0,a2                ; a2 = this char's entity record (12 bytes)
    ; Check if char is in current season:
    ;   +$06 (start period / hire date) <= d5 (current season) <= +$07 (end period / expiry)
    moveq   #$0,d0
    move.b  $0006(a2),d0         ; d0 = start_period (+$06 = hire date / season start)
    cmp.w   d5,d0                ; start_period > current season?
    bgt.b   .l18564              ; yes: char not yet active, use out-of-season format
    moveq   #$0,d0
    move.b  $0007(a2),d0         ; d0 = end_period (+$07 = expiry / season end)
    cmp.w   d5,d0                ; end_period < current season?
    blt.b   .l18564              ; yes: char contract expired, use out-of-season format
    ; Char is in-season: use d2 as the display format index (0 = slot 0 format, 1 = slot 1)
    move.w  d2,d3                ; d3 = display format = slot index (in-season display)
    bra.b   .l18566
.l18564:                                                ; $018564
    moveq   #$5,d3               ; d3 = 5 = out-of-season format (greyed / different style)
.l18566:                                                ; $018566
    ; Build the format string for this result:
    ;   char name string: $FF1278[slot_index] indexes into $5ECFC ROM name table
    ;   format prefix:    $47C0C[d3*4] selects the display format by season/slot
    move.w  (a3),d0             ; d0 = slot index from result table
    movea.l #$00ff1278,a0        ; a0 = $FF1278 (char-to-name-index lookup byte table)
    move.b  (a0,d0.w),d0        ; d0 = char name index (byte lookup)
    andi.l  #$ff,d0
    lsl.w   #$2,d0               ; d0 *= 4 (pointer table = 4 bytes per entry)
    movea.l #$0005ecfc,a0        ; a0 = $5ECFC (char name string pointer table in ROM)
    move.l  (a0,d0.w),-(sp)      ; arg: char name string pointer (for "%s" in format)
    move.w  d3,d0                ; d0 = display format index
    lsl.w   #$2,d0               ; d0 *= 4
    movea.l #$00047c0c,a0        ; a0 = $47C0C (display format string pointer table)
    move.l  (a0,d0.w),-(sp)      ; arg: format string pointer (header text for this result)
    move.l  a5,-(sp)             ; arg: output buffer a5
    dc.w    $4eb9,$0003,$b22c                           ; jsr sprintf ($03B22C) -- format result
    ; RandRange(0, 3): random display variant
    clr.l   -(sp)                ; arg: min = 0
    move.l  a5,-(sp)             ; arg: formatted result string
    pea     ($0003).w            ; arg: max = 3
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr RandRange ($01D6A4)
    addq.l  #$8,sp
    move.l  d0,-(sp)             ; arg: random display mode (0-3)
    move.w  d6,d0
    move.l  d0,-(sp)             ; arg: player index
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- render result on screen
    lea     $001c(sp),sp         ; pop sprintf + RandRange + $02FBD6 args
    moveq   #$1,d3               ; d3 = 1: at least one result was displayed
.l185be:                                                ; $0185BE
    addq.l  #$4,a3               ; advance result table pointer (4 bytes per entry)
    addq.w  #$1,d2               ; next result entry
    cmpi.w  #$2,d2               ; display top 2 results
    blt.w   .l18522
    ; --- Phase: Final Display -- Overall Player Result ---
    ; If d3 OR stat_delta is zero: display the "no change" format ($47C30).
    ; Otherwise: select format based on whether d3==1 (one result slot used) or d3==2+.
    move.w  d3,d0
    or.w    -$00d2(a6),d0        ; OR d3 with stat delta; zero means no results and no change
    bne.b   .l185dc
    ; No results at all: use neutral "no change" format
    clr.l   -(sp)
    move.l  ($00047C30).l,-(sp)  ; format string for "no notable change" result
    bra.b   .l185f6
.l185dc:                                                ; $0185DC
    ; At least one result displayed: select format index based on d3 (0=none, 1=one, 2+=two)
    clr.l   -(sp)                ; padding / null arg
    cmpi.w  #$1,d3
    bne.b   .l185e8
    moveq   #$2,d0               ; d3==1: use format index 2 (single-result summary format)
    bra.b   .l185ea
.l185e8:                                                ; $0185E8
    moveq   #$3,d0               ; d3!=1 (0 or 2+): use format index 3 (multi-result summary)
.l185ea:                                                ; $0185EA
    ; $47C0C[d0*4] = format string pointer table for final summary header
    lsl.w   #$2,d0               ; d0 *= 4
    movea.l #$00047c0c,a0        ; a0 = $47C0C (summary format string pointer table)
    move.l  (a0,d0.w),-(sp)      ; arg: chosen summary format string
.l185f6:                                                ; $0185F6
    ; RandRange(0, 3) + $02FBD6: generate random variant and render final summary
    pea     ($0003).w            ; arg: max = 3
    clr.l   -(sp)                ; arg: min = 0
    dc.w    $4eb9,$0001,$d6a4                           ; jsr RandRange ($01D6A4)
    addq.l  #$8,sp
    move.l  d0,-(sp)             ; arg: random display mode (0-3)
    move.w  d6,d0
    move.l  d0,-(sp)             ; arg: player index
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- render final summary on screen
    movem.l -$00FC(a6),d2-d7/a2-a5
    unlk    a6
    rts
