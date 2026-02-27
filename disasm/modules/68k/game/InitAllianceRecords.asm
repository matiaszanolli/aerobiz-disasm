; ============================================================================
; InitAllianceRecords -- Scores and sorts alliance candidates for a player, displays proposal text, returns success flag
; 1012 bytes | $0302C4-$0306B7
; ============================================================================
InitAllianceRecords:
; --- Phase: Prologue / Frame Setup ---
; Link frame: $18C (396) bytes of local storage for candidate arrays, formatted strings, and temp vars
; Local variable map (all relative to a6):
;   -$42(a6): word -- best_char_value (threshold for alliance candidate eligibility)
;   -$44(a6): word -- match_count (count of direct bitfield matches = solo candidate list count)
;   -$46(a6): word -- scored_count (count of scored / ranked candidates)
;   -$48(a6): word -- temp range end for inner scan loops
;   -$4a(a6): word -- early-exit flag (set when a valid proposal has been displayed)
;   -$24(a6): array of word-pairs (char_code, score) = scored candidate list (a5 base)
;   -$40(a6): array of word-pairs (char_code, score) = direct match candidate list (a4 base)
;   -$ea(a6): char buffer for formatted proposal text (242 bytes)
;   -$18a(a6): char buffer for secondary text (6 bytes)
    link    a6,#-$18C
; Save caller registers: d2-d7 = loop counters + indices; a2-a5 = record/array pointers
    movem.l d2-d7/a2-a5, -(a7)
; d7 = player_index argument (which player is being evaluated for alliance proposals)
    move.l  $8(a6), d7
; --- Phase: Best Char Value Threshold ---
; FindBestCharValue ($035CCC): scan 16 character records for this player in the current quarter
; Returns d0 = maximum char value found -- used as the eligibility threshold
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr FindBestCharValue
    addq.l  #$4, a7
; -$42(a6) = best_char_value: candidates must score <= this to be worth an alliance proposal
    move.w  d0, -$42(a6)
; -$44(a6) = match_count: how many direct bitfield matches found (solo, no competitor)
    clr.w   -$44(a6)
; -$46(a6) = scored_count: how many scored candidates queued for ranking
    clr.w   -$46(a6)
; --- Phase: Candidate Scan Outer Loop Setup ---
; Outer loop iterates over 7 alliance types (d3 = type index 0-6)
; a3 = pointer into ROM table $5ECBC (alliance type descriptors, stride 4)
; First iteration: d3=0, so a3 = $5ECBC (base of table)
    clr.w   d3
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
; a3 = current alliance type descriptor pointer (4 bytes per type: range_start, range_count)
    movea.l a0, a3
; a5 = base of scored candidate list in link frame (-$24(a6))
; Each entry = 4 bytes: word char_code, word compatibility_score
    lea     -$24(a6), a5
; a4 = base of direct match candidate list (-$40(a6))
; -$44 = 0 initially, so a4 starts at -$40(a6)
    move.w  -$44(a6), d0
    lsl.w   #$2, d0
    lea     -$40(a6, d0.w), a0
; a4 = current write position in the direct match list
    movea.l a0, a4
; --- Phase: Candidate Scan -- Outer Loop (Alliance Type Iteration) ---
; For each alliance type d3 (0-6):
;   1. Check if this type already has a solo candidate via BitFieldSearch (no competitor)
;   2. If not, check the player's bitfield_tab to see if the type's bit is set
;   3. If either condition applies, score all candidates in this type's range
.l3030c:
; BitFieldSearch: search the bitfield for alliance type d3 within player d7's candidate pool
; Returns d0 = character index if exactly one candidate found, $FF if multiple or none
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
; d4 = result: $FF = no unique candidate found (either multiple or none)
    move.w  d0, d4
; If d4 != $FF: unique candidate found -- record it as a direct match and skip scoring
    cmpi.w  #$ff, d4
    bne.b   .l30384
; No unique candidate -- check bitfield_tab ($FFA6A0) to see if this alliance type is flagged
; bitfield_tab[player] AND alliance_mask[type d3] -- nonzero means this type is relevant
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
; d0 = player's bitfield longword from bitfield_tab
    move.l  (a0,d0.w), d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
; AND with the type's mask from ROM table $5ECDC (4 bytes per type)
    and.l   (a0,d1.w), d0
; If no bits match: this type is not relevant for this player, skip scoring
    beq.b   .l30384
; This type IS relevant -- set up the range scan for scoring all candidates in this type
; Descriptor at a3: byte[0] = range_start (first char code in this type), byte[1] = range_count
    moveq   #$0,d0
; range_start = first character index in this alliance type's group
    move.b  (a3), d0
    moveq   #$0,d1
; range_count = number of characters in this type's group
    move.b  $1(a3), d1
    add.w   d1, d0
; -$48(a6) = range_end = range_start + range_count (exclusive upper bound for inner scan)
    move.w  d0, -$48(a6)
; d2 = range_start: inner loop starting char code
    moveq   #$0,d2
    move.b  (a3), d2
; Jump into inner loop comparison (skip the addq.w #1 increment at top)
    bra.b   .l3037e
; --- Phase: Inner Loop -- Find Uncontested Candidate in Type Range ---
; Scan characters d2 to -$48(a6) within city_data to find one with no competitor
; city_data[char_code * 8 + player * 2 + 1]: byte +1 = "contested" flag (nonzero = competitor exists)
.l3035c:
; Compute city_data offset: char_code * 8 + player * 2
; city_data ($FFBA80): 8 bytes per char (4 entries × 2 bytes), player selects which entry
    move.w  d2, d0
; d0 = char_code * 8 (each char occupies 8 bytes in city_data)
    lsl.w   #$3, d0
    move.w  d7, d1
; player * 2 = stride-2 entry offset (each player's data in alternating bytes)
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
; a2 = pointer to this char's entry in city_data for the current player
    movea.l a0, a2
; Check byte +1 of the entry: nonzero = contested (another player already has this candidate)
    tst.b   $1(a2)
; Zero = uncontested: this candidate is free -- record as solo match
    beq.b   .l3037c
; Contested: this char_code is the uncontested match; record d4 and branch to record it
    move.w  d2, d4
    bra.b   .l30384
.l3037c:
; Not yet uncontested: advance to next candidate in the range
    addq.w  #$1, d2
.l3037e:
; Continue scanning while d2 < range_end (-$48(a6))
    cmp.w   -$48(a6), d2
    blt.b   .l3035c
; --- Phase: Route: Solo Match vs Scored Candidate ---
.l30384:
; If d4 != $FF: found a solo (uncontested) candidate -- record directly without scoring
    cmpi.w  #$ff, d4
    bne.w   .l30440
; d4 == $FF: no uncontested candidate found -- must score all candidates in the range
; Clear the 8-byte sort scratch buffer at -$8(a6) (holds the top candidate pair after SortWordPairs)
    pea     ($0008).w
    clr.l   -(a7)
    pea     -$8(a6)
; MemFillByte ($01D520): zero $8 bytes at -$8(a6)
    jsr MemFillByte
    lea     $c(a7), a7
; Reset inner scan range for scoring pass
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.w   d1, d0
; -$48(a6) = range_end (same as before)
    move.w  d0, -$48(a6)
    moveq   #$0,d2
; d2 = range_start: start scoring from the first char in this type's group
    move.b  (a3), d2
    bra.b   .l30422
; --- Phase: Scoring Inner Loop -- Score Each Candidate in Range ---
; For each char d2 in [range_start, range_end):
;   score = (char_stat_tab[d2].param_c + char_stat_tab[d2].param_d) / 10
;           * char_stat_tab[d2].field_1 (primary skill)
;           + city_data[d2][player] * 8
;   Keep best (lowest score wins = best candidate) via SortWordPairs on the 2-entry buffer
.l303b6:
; Compute city_data pointer for candidate d2 (same formula as above)
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d7, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
; a2 = city_data entry for candidate d2 / player d7
    movea.l a0, a2
; d4 = city_data byte[0] for this candidate: the "city score" contribution
    moveq   #$0,d4
    move.b  (a2), d4
; Now get the char_stat_tab ($FF1298) descriptor for this candidate
; char_stat_tab[d2]: 4 bytes: offset, field_1, param_c, param_d
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
; a2 = char_stat_tab descriptor for candidate d2
    movea.l a0, a2
; Formula: score = (param_c + param_d) / 10 * field_1 + city_score * 8
; param_c (byte +2) and param_d (byte +3) are the type init parameters from char_stat_tab
; field_1 (byte +1) is the primary skill/rating -- see DATA_STRUCTURES.md §3 char_stat_tab
; city_score (d4) is the raw city_data byte[0] for this candidate/player combination
; Higher score = better candidate for the alliance slot
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
; d0 = param_c + param_d (combined type parameters)
    add.l   d1, d0
; Divide by 10: SignedDiv($03E08A) with d1=10 as divisor
    moveq   #$A,d1
    jsr SignedDiv
; Multiply by field_1 (primary skill/rating, byte +1 of char_stat_tab descriptor)
    moveq   #$0,d1
    move.b  $1(a2), d1
    mulu.w  d1, d0
; Add city_score * 8 (d4 << 3): city affinity weighted 8× to amplify geographic preference
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
; Store the computed score and candidate code into the sort scratch
; -$2(a6) = score (sort key), -$4(a6) = char_code (data)
    move.w  d0, -$2(a6)
    move.w  d2, -$4(a6)
; SortWordPairs ($010AB6): bubble-sort the 2-entry buffer at -$8(a6) by score
; After each candidate, the best (highest score) bubbles to -$8(a6)
    pea     ($0002).w
    pea     -$8(a6)
    jsr SortWordPairs
    addq.l  #$8, a7
    addq.w  #$1, d2
.l30422:
; Repeat for all candidates in this type's range
    cmp.w   -$48(a6), d2
    blt.b   .l303b6
; After scoring all candidates: check if best score is nonzero (valid candidate found)
; -$6(a6) = score of best candidate (second word of sort entry at -$8(a6))
    tst.w   -$6(a6)
; Zero score = no viable candidate; skip recording
    beq.b   .l30460
; Record the best scored candidate into the direct match list at a4
; -$8(a6) = char_code of best candidate, -$6(a6) = its score
    move.w  -$8(a6), (a4)
    move.w  -$6(a6), $2(a4)
; Advance a4 to the next slot (4 bytes per entry)
    addq.l  #$4, a4
; Increment match_count (-$44): one more direct match recorded
    addq.w  #$1, -$44(a6)
    bra.b   .l30460
; --- Phase: Record Solo (Uncontested) Candidate ---
; d4 = the uncontested candidate's char_code (from BitFieldSearch or the contested scan)
.l30440:
; Store char_code at word[0] of the scored list entry at a5
    move.w  d4, (a5)
; CountMatchingChars ($0074F8): walk the player's roster counting stat matches for this candidate
; Returns d0 = compatibility score
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
; Store the compatibility score at word[2] of the entry (second word of pair)
    move.w  d0, $2(a5)
; Advance a5 to next scored list entry (4 bytes per entry)
    addq.l  #$4, a5
; Increment scored_count (-$46): one more scored candidate queued
    addq.w  #$1, -$46(a6)
.l30460:
; Advance a3 to the next alliance type descriptor (4 bytes per entry in $5ECBC table)
    addq.l  #$4, a3
    addq.w  #$1, d3
; Loop for all 7 alliance types (0-6)
    cmpi.w  #$7, d3
    blt.w   .l3030c
; --- Phase: Sort Both Candidate Lists ---
; SortWordPairs ($010AB6): sort the scored list (-$24(a6)) by compatibility score descending
; scored_count (-$46) entries, each 4 bytes (char_code, score)
    move.w  -$46(a6), d0
    move.l  d0, -(a7)
    pea     -$24(a6)
    jsr SortWordPairs
; SortWordPairs: sort the direct match list (-$40(a6)) by score descending
; match_count (-$44) entries
    move.w  -$44(a6), d0
    move.l  d0, -(a7)
    pea     -$40(a6)
    jsr SortWordPairs
    lea     $10(a7), a7
; -$4a(a6) = proposal_sent flag; cleared before the proposal display loop
    clr.w   -$4a(a6)
; d3 = outer loop index for the scored candidate list (iterates 0..scored_count-1)
    clr.w   d3
; --- Phase: Proposal Display Loop -- Scored Candidates ---
; For each pair of (scored_candidate d6, direct_match_candidate d5):
;   CharCodeCompare to check eligibility, FindRelationIndex to avoid duplicates,
;   RangeLookup to get palette, then sprintf + ShowText for the proposal dialog
    bra.w   .l305aa
; Inner loop: for each scored candidate d5, check pair with d6 (outer/current city)
.l3049a:
; d5 = char_code from scored list: -$24(a6)[d2 * 4] (word at index d2)
    move.w  d2, d0
    lsl.w   #$2, d0
    move.w  -$24(a6, d0.w), d5
; CharCodeCompare ($006F42): compute compatibility index between candidates d5 and d6
; Returns compatibility category in d0 (0-6, lower = more compatible)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
; d4 = compatibility score result
    move.w  d0, d4
; If compatibility score > best_char_value threshold: this pair is not good enough, skip
    cmp.w   -$42(a6), d4
    bhi.w   .l3059e
; Check if this char pair already has a relation entry (avoid duplicate proposals)
; FindRelationIndex ($00957C): search relation table for (d5, d6) under player d7
; Returns $FF = not found (no existing relation = eligible for new proposal)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindRelationIndex
    lea     $c(a7), a7
; If d0 != $FF: relation already exists -- skip this pair (no duplicate proposals)
    cmpi.w  #$ff, d0
    bne.w   .l3059e
; --- Sub-phase: Generate and Display Proposal Dialog ---
; RangeLookup ($00D648): map candidate d5's char_code to a region index (0-7)
; Used to select the correct screen palette for the proposal display
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
; RangeLookup for candidate d6 (the outer city candidate)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.l  d0, -(a7)
; LoadScreenPalette ($0100F2): load the palette for the region containing d6
    jsr LoadScreenPalette
; Look up d5's name string pointer from ROM table $5E680 (char name table, 4 bytes per entry)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
; Look up d6's name string pointer from the same table
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
; sprintf: format the primary proposal line using format string at $4477A
; Output into local buffer -$18a(a6) -- inserts both character names
    pea     ($0004477A).l
    pea     -$18a(a6)
    jsr sprintf
; Look up the secondary proposal text template by the dialog sequence counter ($E(a6))
; Table at $47B80: one pointer per dialog variant (up to index 2)
    pea     -$18a(a6)
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00047B80,a0
    move.l  (a0,d0.w), -(a7)
; sprintf: format the secondary proposal text using the primary line as argument
; Output into main text buffer -$ea(a6) (the longer char buffer)
    pea     -$ea(a6)
    jsr sprintf
    lea     $24(a7), a7
; RandRange ($01D6A4): pick a random dialog variant 0-3 for display variety
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
; ShowText ($???): display the formatted proposal text in a dialog box
; Args: player_index d7, random variant d0, formatted text buffer -$ea(a6)
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
    lea     $10(a7), a7
; Mark proposal as sent: $12(a6) = 1 (return value: function succeeded in showing a proposal)
    move.w  #$1, $12(a6)
; Advance the dialog sequence counter ($E(a6)) for next call
    addq.w  #$1, $e(a6)
; If counter <= 2: still have dialog variants remaining, keep going
    cmpi.w  #$2, $e(a6)
    ble.b   .l305a8
; Counter exceeded 2: all dialog variants used -- set early-exit flag
    move.w  #$1, -$4a(a6)
    bra.b   .l305a8
; Re-enter outer loop: advance d3, load next scored candidate as d6
.l30594:
    move.w  d3, d0
    lsl.w   #$2, d0
; d6 = char_code at scored list index d3 (the "primary" side of the pair)
    move.w  -$24(a6, d0.w), d6
; d2 starts from d3 (inner loop iterates d2 from d3 onward within the scored list)
    move.w  d3, d2
.l3059e:
; Advance inner loop index d2 -- try next scored candidate as the secondary partner
    addq.w  #$1, d2
; While d2 < scored_count: keep checking pairs
    cmp.w   -$46(a6), d2
    blt.w   .l3049a
.l305a8:
; Advance outer loop index d3 to next row in scored candidate list
    addq.w  #$1, d3
.l305aa:
; While d3 < scored_count AND no early exit: continue outer loop
    cmp.w   -$46(a6), d3
    bge.b   .l305b6
; Early-exit flag check: if -$4a(a6) is nonzero (proposal limit reached), stop
    tst.w   -$4a(a6)
    beq.b   .l30594
; --- Phase: Proposal Display Loop -- Direct Match Candidates ---
; After the scored list is exhausted (or early-exit), now try the direct match list
; Same eligibility checks (CharCodeCompare, FindRelationIndex), same proposal display
.l305b6:
; Reset early-exit flag for the second proposal loop (direct match list)
    clr.w   -$4a(a6)
; d2 = outer loop index over direct match list (0..match_count-1)
    clr.w   d2
    bra.w   .l3069c
.l305c0:
; Outer loop: d2 iterates over the SCORED list as primary side
; d6 = char_code from scored list at index d2 (the "primary" side of the cross-list pair)
    move.w  d2, d0
    lsl.w   #$2, d0
; Scored list entry at -$24(a6): word[0]=char_code, word[2]=score
    move.w  -$24(a6, d0.w), d6
; Inner loop: d3 iterates over the DIRECT MATCH list as secondary side
; Note: this loop does NOT call FindRelationIndex (unlike the scored-only loop above)
; Because direct matches are fresh candidates with no existing relation, the check is omitted
    clr.w   d3
    bra.w   .l30692
.l305ce:
; d5 = char_code from direct match list (-$40(a6)) at inner index d3
; Direct match list entry: word[0]=char_code, word[2]=score
    move.w  d3, d0
    lsl.w   #$2, d0
; d5 = char_code of this direct-match candidate (uncontested / solo match)
    move.w  -$40(a6, d0.w), d5
; CharCodeCompare: check compatibility between d5 (direct match) and d6 (scored outer candidate)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
; d4 = compatibility category (0-6); higher = less compatible
    move.w  d0, d4
; If d4 > best_char_value threshold: this cross-list pair is incompatible, skip to next d3
    cmp.w   -$42(a6), d4
    bhi.w   .l30690
; Pair is compatible -- load screen palette based on the region of each candidate
; RangeLookup for d5 (direct match candidate): returns region index (0-7) for palette select
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
; d0 = region index for d5 -- pushed as palette arg for LoadScreenPalette
    move.l  d0, -(a7)
; RangeLookup for d6 (scored outer candidate): returns region index for d6's palette
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
; d0 = region index for d6 -- pushed as second palette arg
    move.l  d0, -(a7)
; LoadScreenPalette: load the combined palette for the two region indices (d5's region, d6's region)
    jsr LoadScreenPalette
; Look up d5's name string from ROM name table $5E680 (4 bytes per entry = pointer)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
; d5 name pointer -- pushed as sprintf argument
    move.l  (a0,d0.w), -(a7)
; Also look up d5's range bucket for the secondary format string selector
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
; RangeLookup on d5 again: this time to index into the format-string variant table $5EC84
    jsr RangeLookup
    addq.l  #$4, a7
; Use the range index to pick a direct-match variant format string from ROM table $5EC84
; $5EC84 has one format-string pointer per range bucket (8 buckets)
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
; Format string for this direct-match alliance type (range-specific wording)
    move.l  (a0,d0.w), -(a7)
; Look up d6's name string from $5E680
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
; d6 name pointer -- pushed as second name argument to sprintf
    move.l  (a0,d0.w), -(a7)
; Fixed secondary format string pointer at $47B8C (direct-match dialog variant, as opposed to $47B80 above)
    move.l  ($00047B8C).l, -(a7)
; sprintf: format the complete direct-match proposal dialog string into -$ea(a6)
; Args on stack (top→bottom): output buffer, format ptr, d6 name, format ptr 2, d5 name
    pea     -$ea(a6)
    jsr sprintf
; RandRange ($01D6A4): pick a random display variant 0-3 for the dialog box layout
    clr.l   -(a7)
    pea     -$ea(a6)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
; ShowText: display the formatted proposal text for the direct-match alliance suggestion
; Args: player_index (d7), random variant (d0), formatted text buffer (-$ea(a6))
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w ShowText
; $2c = clean up all args pushed since the last explicit cleanup (sprintf + RandRange + ShowText = $2C)
    lea     $2c(a7), a7
; $12(a6) = function return value: 1 = at least one proposal was displayed this call
    move.w  #$1, $12(a6)
; Set early-exit flag to stop after finding the first valid direct-match pair
    move.w  #$1, -$4a(a6)
    bra.b   .l3069a
.l30690:
; d4 > threshold or incompatible: advance inner index to next direct-match candidate
    addq.w  #$1, d3
.l30692:
; While d3 < match_count (-$44): keep scanning the direct match list
    cmp.w   -$44(a6), d3
    blt.w   .l305ce
.l3069a:
; Advance outer loop index d2 to next scored candidate as the primary
    addq.w  #$1, d2
.l3069c:
; While d2 < scored_count (-$46) AND no early exit: continue outer × inner scan
    cmp.w   -$46(a6), d2
    bge.b   .l306aa
; Check early-exit flag: nonzero = a direct-match proposal was already shown, stop looping
    tst.w   -$4a(a6)
    beq.w   .l305c0
.l306aa:
; --- Phase: Epilogue ---
; d0 = return value: $12(a6) = 1 if any proposal was displayed, 0 if none
    move.w  $12(a6), d0
; Restore saved registers: d2-d7/a2-a5 from link frame
; -$1b4(a6): link allocated $18C bytes; movem saved 10 registers × 4 = $28 bytes;
; $18C + $28 = $1B4, so saved regs start at -$1b4(a6) from a6
    movem.l -$1b4(a6), d2-d7/a2-a5
; unlk restores sp = a6, then pops saved a6; drops entire link frame
    unlk    a6
    rts
