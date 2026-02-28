; ============================================================================
; SearchCharInAlliances -- Ranks candidate alliances for current player, shows negotiation dialogue, calls InitAllianceRecords
; 708 bytes | $030000-$0302C3
; ============================================================================
; --- Phase: Setup -- Output Buffer Pointer ---
; Called with d4=category_start (0), d5=player_index, d6=output_count (starts at 0)
; a5 = output array base (word pairs: [city_index, score])
SearchCharInAlliances:
    ; a3 = pointer into output array at current write position (d6 * 4 bytes)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a3
    bra.w   .l30144
; --- Phase: Outer Loop -- Scan Alliance Categories 0..6 ---
.l30010:
    ; BitFieldSearch: find a set bit in the player's bitfield for category d4
    ; Returns char/city index, or $FF if none
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    ; d2 = candidate city index from bitfield search
    move.w  d0, d2
    cmpi.w  #$ff, d2
    bne.b   .l30092
    ; BitFieldSearch returned $FF: check alliance bitmask directly in bitfield_tab
    ; bitfield_tab[$FFA6A0 + player*4] AND $5ECDC[category*4] = player's city mask for d4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    ; If no active cities in this category: skip to next category
    beq.b   .l30092
    ; --- Find first active city in this category's range ---
    ; $5ECBC is a ROM descriptor table: entry d4*4 has range info
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    ; a2 = category range descriptor
    movea.l a0, a2
    ; d7 = range upper bound: descriptor[0] + descriptor[1]
    moveq   #$0,d7
    move.b  (a2), d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d7
    ; d3 = start of range (descriptor[0] = base city index)
    moveq   #$0,d3
    move.b  (a2), d3
    bra.b   .l3008e
.l3006c:
    ; Check city_data ($FFBA80) for this city: city*8 + player*2
    ; FFBA80 holds city data: 89 cities, stride 8, each entry has availability flags
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    ; a2 = city data entry for city d3, player d5
    movea.l a0, a2
    ; city_data+$01: if zero, this city is available for alliance use
    tst.b   $1(a2)
    beq.b   .l3008c
    ; City is occupied/unavailable: select it as the candidate
    move.w  d3, d2
    bra.b   .l30092
.l3008c:
    addq.w  #$1, d3
.l3008e:
    ; Scan city indices d3..d7-1 looking for an available slot
    cmp.w   d7, d3
    blt.b   .l3006c
; --- Phase: Score Candidate City ---
.l30092:
    ; Skip if no valid candidate found in this category
    cmpi.w  #$ff, d2
    beq.w   .l30142
    ; Check tab32_8824 ($FF8824): stride-2 table (32 entries); word at index d2
    ; If both bytes equal: city already has maximum fill (skip)
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    ; a2 = tab32_8824 entry for city d2
    movea.l a0, a2
    move.b  (a2), d0
    ; If byte[0] == byte[1]: city is saturated, no room for more -- skip it
    cmp.b   $1(a2), d0
    beq.w   .l30142
    ; Get stat descriptor for this city from char_stat_tab ($FF1298, 4 bytes/entry)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    ; a4 = char_stat_tab descriptor for city d2 (byte[1] = type discriminator)
    movea.l a0, a4
    ; Look up city_data entry for city d2 and player d5
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    ; a2 = city_data entry (current demand/load level data)
    movea.l a0, a2
    ; Write candidate city index to output array (first word of pair)
    move.w  d2, (a3)
    ; CountMatchingChars: count how many chars in this player's roster match city d2
    ; Returns match count in d0; used to determine competition level
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    ; d2 = match count
    move.w  d0, d2
    tst.w   d2
    bne.b   .l30110
    ; --- No matches: score = (city_demand_a - city_demand_b) * 4 + stat_descriptor[1]) * 2 ---
    ; city_data[0] = current demand (how many allies active), city_data[1] = capacity
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    sub.w   d1, d0
    ; (demand - capacity) * 4 = rough surplus indicator
    lsl.w   #$2, d0
    ; Add stat descriptor byte 1 (type weighting)
    moveq   #$0,d1
    move.b  $1(a4), d1
    add.w   d1, d0
    ; Double the result for wider score range
    add.w   d0, d0
    bra.b   .l30136
.l30110:
    ; --- Matches found: score = ((demand - capacity) * 4 + descriptor[1]) / match_count ---
    ; Higher match count = more competition = lower score (worse for player)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    ext.l   d1
    sub.l   d1, d0
    lsl.l   #$2, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    ext.l   d1
    add.l   d1, d0
    ; Divide by match count: more competition = lower priority
    move.w  d2, d1
    ext.l   d1
    jsr SignedDiv
.l30136:
    ; Add base score of $64 (100) so scores are always positive
    addi.w  #$64, d0
    ; Write score (second word of pair) into output array
    move.w  d0, $2(a3)
    ; Advance output pointer by 4 bytes (one word pair)
    addq.l  #$4, a3
    ; Increment output count
    addq.w  #$1, d6
.l30142:
    ; Next category
    addq.w  #$1, d4
; --- Phase: Loop Condition ---
.l30144:
    ; Process categories 0..6 (7 alliance categories total)
    cmpi.w  #$7, d4
    blt.w   .l30010
; --- Phase: Sort and Select Top-2 Candidates ---
    ; SortWordPairs: sorts d6 word pairs in a5 by score (second word) descending
    ; Result: a5[0] = best city candidate, a5[1] = second-best
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    jsr SortWordPairs
    addq.l  #$8, a7
    ; d7 = "at least one candidate shown" flag (used at end to decide output path)
    clr.w   d7
    ; d3 = count of negotiation texts shown so far (0..1)
    clr.w   d3
    ; d4 = candidate index (0=best, 1=second-best)
    clr.w   d4
    ; a2 = pointer to second word of first pair (score word of best candidate)
    movea.l a5, a2
    addq.l  #$8, a2
; --- Phase: Process Top-2 Candidates ---
.l30164:
    ; Load city index for this candidate from output array (first word of pair d4)
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    ; d6 = city index for candidate d4
    move.w  (a5,a0.l), d6
    tst.w   d4
    bne.b   .l30184
    ; --- First candidate (best): check if the forced city override is set ---
    ; -$1C(a6) = caller-specified city override ($FFFF = no override)
    move.w  -$1c(a6), d0
    ext.l   d0
    ; If override == -1: proceed with best sorted candidate
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l3026e
    bra.b   .l301b6
.l30184:
    ; --- Second candidate: check if it's valid or if random skip applies ---
    ; a2 now points to the second pair's score word
    move.w  (a2), d0
    ext.l   d0
    moveq   #-$1,d1
    ; If score == -1: this slot is empty, skip
    cmp.l   d0, d1
    beq.b   .l301a2
    ; 50% chance: randomly skip this candidate (RandRange 0..1, skip if nonzero)
    pea     ($0001).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    tst.l   d0
    bne.b   .l301a2
    ; Use the second candidate's city index (from score word of pair)
    move.w  (a2), d6
.l301a2:
    ; Validate d6: if still $FFFF, fall back to override city
    move.w  d6, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bne.b   .l301b6
    ; d6 invalid: use the override city (-$1C(a6)), show 2 candidates instead of 1
    move.w  -$1c(a6), d6
    pea     ($0002).w
    bra.b   .l301ba
.l301b6:
    ; Valid candidate: show just 1 negotiation option
    pea     ($0001).w
.l301ba:
    ; RankCharCandidates: pick the best available char for city d6, player d5
    ; Returns char index in d0, or -1 if no suitable char found
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr RankCharCandidates
    lea     $c(a7), a7
    ; d2 = selected char index for negotiation
    move.w  d0, d2
    ext.l   d0
    ; If -1: no char available for this city -- skip to next candidate
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.w   .l30264
    ; --- Load screen palette for this char's nationality ---
    ; RangeLookup maps char index d2 to palette index (0-7)
    pea     (-$1).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ; LoadScreenPalette: loads the correct palette for this char's regional graphics
    move.l  d0, -(a7)
    jsr LoadScreenPalette
    ; --- Format negotiation text ---
    ; $5E680 = ROM table: char display name pointers (stride 4)
    ; Format char name + city name into negotiation text buffers
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; ROM format string at $44768: "CharName negotiates for CityName" template
    pea     ($00044768).l
    pea     -$15c(a6)
    jsr sprintf
    ; Format secondary text line using dialog index d3 (which negotiation line 0 or 1)
    pea     -$15c(a6)
    move.w  d3, d0
    lsl.w   #$2, d0
    ; $47B80 = pointer table for negotiation dialog text variants by round
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$bc(a6)
    jsr sprintf
    lea     $24(a7), a7
    ; --- Show negotiation dialog ---
    ; Choose a random dialog variant from 0..3 for this negotiation encounter
    clr.l   -(a7)
    pea     -$bc(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    ; ShowText: display the formatted negotiation dialog for player d5
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
    ; Increment negotiation round counter
    addq.w  #$1, d3
    ; Set "showed at least one" flag
    moveq   #$1,d7
.l30264:
    addq.w  #$1, d4
    ; Process up to 2 candidates (best and second-best)
    cmpi.w  #$2, d4
    blt.w   .l30164
; --- Phase: Initialize Alliance Records and Show Result ---
.l3026e:
    ; InitAllianceRecords: commit the negotiation results for player d5
    ; Args: player_index, rounds_shown, showed_flag
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (InitAllianceRecords,PC)
    nop
    lea     $c(a7), a7
    ; d7 = return value from InitAllianceRecords: 0 = no alliance formed, nonzero = success
    move.w  d0, d7
    tst.w   d7
    bne.b   .l302b0
    ; Alliance failed: show a rejection/no-deal dialog text
    ; $47B90 = pointer to failure dialog text
    clr.l   -(a7)
    move.l  ($00047B90).l, -(a7)
    ; Random variant 0..3 of the failure message
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    ; ShowText: display the failure message for player d5
    bsr.w ShowText
    lea     $10(a7), a7
    bra.b   .l302ba
.l302b0:
    ; Alliance succeeded: show the player's updated comparison chart
    move.w  d5, d0
    move.l  d0, -(a7)
    ; ShowPlayerChart: display comparative stats after alliance formation
    jsr ShowPlayerChart
.l302ba:
    movem.l -$184(a6), d2-d7/a2-a5
    unlk    a6
    rts
