; ============================================================================
; CalcRecruitmentCost -- Finds best char replacement for a slot; transfers or trains char based on skill level comparison
; 274 bytes | $0331CC-$0332DD
; ============================================================================
CalcRecruitmentCost:
; --- Phase: Setup ---
; Args: $8(a6)=player_index, $C(a6)=slot_index, $10(a6)=mode
; Returns: D0.W = result code from TransferCharSlot (or 0 if trained/no-op)
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3           ; d3 = player_index (0-3)
    move.l  $10(a6), d4          ; d4 = mode (0=normal compare, 1=alternate path)
    move.l  $c(a6), d5           ; d5 = slot_index (0-39) within player's route array
    clr.w   d7                   ; d7 = result accumulator (0 = no transfer yet)

; --- Phase: Find Best Replacement Character ---
; Call FindBestCharForSlot(player, slot, mode) -> D0 = candidate char index (0-$F), or $10+ = none
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
; Find the highest-value candidate for the given route slot
    jsr (FindBestCharForSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2               ; d2 = best candidate char index returned by FindBestCharForSlot
; $10 = 16 = sentinel "no valid candidate found"; skip all processing
    cmpi.w  #$10, d2
    bcc.w   l_332d2

; --- Phase: Resolve Candidate and Current Char Record Pointers ---
; Candidate char record in char group table at $FFA6B8; stride $C per entry
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4               ; a4 -> candidate char record at $FFA6B8 + d2*$C

; event_records ($FFB9E8): stride $20 per player, then +d2*2 for char slot entry
; index = player*$20 + candidate*2; a2 -> current assignment entry in event_records
    move.w  d3, d0
    lsl.w   #$5, d0              ; d0 = player_index * $20 (32 bytes per player block)
    move.w  d2, d1
    add.w   d1, d1               ; d1 = candidate_index * 2 (word stride)
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 -> event_records entry for this player/candidate

; Route slot pointer: route_slots($FF9A20) + player*$320 + slot*$14
    move.w  d3, d0
    mulu.w  #$320, d0            ; d0 = player_index * $320 (800 bytes per player)
    move.w  d5, d1
    mulu.w  #$14, d1             ; d1 = slot_index * $14 (20 bytes per slot)
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 -> route slot record (20 bytes)

; GetByteField4: reads the packed byte field (byte 4) from the route slot -> char category index
    move.l  a3, -(a7)
    jsr GetByteField4            ; returns byte field 4 of slot (char category/type index)
    move.w  d0, d6               ; d6 = category index from GetByteField4
; Look up the current char's record via the char group table, stride $C
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5               ; a5 -> current char's group record ($FFA6B8 + category*$C)

; GetLowNibble: extracts the low nibble of byte 0 of the slot (plane type low nibble)
    move.l  a3, -(a7)
    jsr GetLowNibble             ; returns low nibble of slot byte 0
    addq.l  #$8, a7
    move.w  d0, d6               ; d6 = low nibble (plane class A from route_slot+$02)

; --- Phase: Skill Comparison (mode 0 path) ---
    tst.w   d4                   ; mode==0 means normal skill-level comparison
    bne.b   l_332b4              ; mode!=0: skip to alternate branch

; Compare candidate rating vs current char rating:
; current_score = event_records[a2+$1] * current_group[a4+$1]
; candidate_score = candidate_group[a5+$1] * plane_nibble(d6)
; If candidate_score > current_score: train instead of transfer
    moveq   #$0,d0
    move.b  $1(a2), d0           ; current assignment's stat byte (+$1 of event_records entry)
    moveq   #$0,d1
    move.b  $1(a4), d1           ; candidate char record rating (+$1 of $FFA6B8 entry)
    mulu.w  d1, d0               ; current_score = event_stat * candidate_rating
    move.w  d0, -$2(a6)         ; stash current_score on stack frame
    moveq   #$0,d4
    move.b  $1(a5), d4           ; new candidate rating from group record +$1
    mulu.w  d6, d4               ; candidate_score = new_rating * plane_nibble
    cmp.w   -$2(a6), d4         ; candidate_score > current_score? (unsigned)
    bhi.b   l_332c0              ; yes -> train the char instead

; --- Phase: Transfer ---
; candidate_score <= current_score: transfer the candidate char into this slot
l_33294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
; Transfer the best candidate character into this route slot
    jsr (TransferCharSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d7               ; d7 = TransferCharSlot result (returned in D0 on exit)
    bra.b   l_332d2

; --- Phase: Alternate Mode Branch (mode==1 path) ---
l_332b4:
; Mode 1: only transfer if the current char's primary stat byte (+$1 of event_records) is nonzero
    cmpi.w  #$1, d4              ; mode must be exactly 1 to enter this path
    bne.b   l_332d2              ; mode >= 2: nothing to do, exit
    tst.b   $1(a2)               ; check current char's stat byte in event_records (+$1)
    bne.b   l_33294              ; nonzero => current char is active, transfer candidate in

; --- Phase: Train ---
; Candidate is better than current, or current slot is empty: train the character
l_332c0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
; Improve the candidate char's skill without changing slot ownership
    jsr (TrainCharSkill,PC)
    nop

; --- Phase: Return ---
l_332d2:
    move.w  d7, d0               ; D0 = transfer result (0 if only trained or no action)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

FindBestCharForSlot:                                                  ; $0332DE
; --- Phase: Setup ---
; Args: $A(a6)=player_index, $C(a6)=slot_index, $10(a6)=mode (0=rating, 1=profit)
; Returns: D0.W = index of best candidate char (0-$F), or $FF if none found
    link    a6,#-$4
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $000c(a6),d2         ; d2 = slot_index (target route slot to fill)
    move.l  $0010(a6),d5         ; d5 = mode (0=use rating, 1=use CalcCharProfit)
    move.w  #$ff,d6              ; d6 = best candidate index (init $FF = not found)
; Compute route slot pointer: route_slots base + player*$320 + slot*$14
    move.w  $000a(a6),d0
    mulu.w  #$0320,d0            ; player offset: 800 bytes per player block
    move.w  d2,d1
    mulu.w  #$14,d1              ; slot offset: 20 bytes per route slot
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3                ; a3 -> target route slot record

; --- Phase: Characterize The Target Slot ---
; CharCodeCompare($6F42): compare city_b vs city_a codes -> compatibility index in D0
; Used to establish what "type" of route this is for matching candidates
    moveq   #$0,d0
    move.b  $0001(a3),d0         ; route_slot+$01 = city_b index
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0              ; route_slot+$00 = city_a index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr CharCodeCompare ($006F42)
    move.w  d0,-$0002(a6)        ; local $-2(a6) = char code compatibility index for this route
; GetByteField4($74E0): read byte field 4 from slot -> char category/type index
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr GetByteField4 ($0074E0): slot byte field 4
    lea     $000c(sp),sp
    move.w  d0,d2                ; d2 = char category index (reused as loop var below)

; --- Phase: Compute Reference Score (for later comparison) ---
    tst.w   d5                   ; mode == 0 = use simple rating lookup
    bne.b   .l33354

; Mode 0: look up the current char's base rating byte from char group table
; $FFA6B9 = $FFA6B8+1 (rating byte of char group entry); stride $C per entry
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d3        ; d3 = current char's base rating (reference for beat-this)
    andi.l  #$ff,d3
    bra.b   .l3338e

.l33354:                                                ; $033354
; Mode 1: use CalcCharProfit to compute the reference profitability score
    cmpi.w  #$1,d5
    bne.b   .l3338e              ; mode > 1: skip, use d3=0 (any candidate wins)
; GetByteField4 again with flag=1 (high nibble) to get alternate field
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr GetByteField4 ($0074E0) high nibble
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
; CalcCharProfit($206EE): compute current char's profit value using city_a, city_b, mode
    moveq   #$0,d0
    move.b  $0001(a3),d0         ; route_slot+$01 = city_b
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0              ; route_slot+$00 = city_a
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr CalcCharProfit ($0206EE)
    lea     $0010(sp),sp
    move.w  d0,d3                ; d3 = reference profit score (beat-this threshold)

; --- Phase: Compute Year/Season Window for Eligibility ---
.l3338e:                                                ; $03338E
; Convert frame_counter ($FF0006) to a season/quarter index:
; season = (frame_counter / 4) + $37 (= 55)
; This gives a value in the range of valid season codes for CheckCharEligible
    move.w  ($00FF0006).l,d0     ; frame_counter: frames elapsed since game start
    ext.l   d0
    bge.b   .l3339a
    addq.l  #$3,d0               ; round up for arithmetic right shift (handles negative)
.l3339a:                                                ; $03339A
    asr.l   #$2,d0               ; divide by 4 -> quarter index
    addi.w  #$37,d0              ; bias by $37=55 to map into season code range
    move.w  d0,d7                ; d7 = current season code (used for eligibility window check)

; --- Phase: Scan All 16 Candidate Character Slots ---
; a2 starts at $FFA6B8 (char group table base), stride $C per candidate, 16 candidates
    movea.l #$00ffa6b8,a2
    clr.w   d2                   ; d2 = candidate index (0-$F)
.l333aa:                                                ; $0333AA
; Eligibility check 1: candidate's type word (+$2) must match the route's compat index
; (compat index was stored in local $-2(a6) from CharCodeCompare above)
    move.w  $0002(a2),d0         ; char group record +$2: type/compat word
    cmp.w   -$0002(a6),d0        ; must equal route's compat index
    bcs.w   .l33444              ; no match: skip this candidate

; Eligibility check 2: season start (+$6) must be <= current season (d7)
; addi.w #$ffff = subtract 1 (season start - 1)
    moveq   #$0,d0
    move.b  $0006(a2),d0         ; char group +$6: season start code (hire date)
    addi.w  #$ffff,d0            ; season_start - 1 (make check inclusive)
    ext.l   d0
    moveq   #$0,d1
    move.w  d7,d1                ; d1 = current season
    cmp.l   d1,d0                ; (season_start-1) > current? -> too early
    bgt.b   .l33444

; Eligibility check 3: season end (+$7) must be > current season
; char not eligible if contract has expired (season_end - 2 < current)
    moveq   #$0,d0
    move.w  d7,d0                ; d0 = current season
    moveq   #$0,d1
    move.b  $0007(a2),d1         ; char group +$7: season end/expiry code
    ext.l   d1
    subq.l  #$2,d1               ; season_end - 2 (boundary check)
    cmp.l   d1,d0                ; current >= season_end-2 -> expired
    bge.b   .l33444

; CalcWeightedStat($8016): check if candidate contributes a valid weighted stat for this player
    move.w  d2,d0
    move.l  d0,-(sp)             ; candidate index
    move.w  $000a(a6),d0
    move.l  d0,-(sp)             ; player index
    dc.w    $4eb9,$0000,$8016                           ; jsr CalcWeightedStat ($008016)
    addq.l  #$8,sp
    cmpi.w  #$ffff,d0            ; $FFFF = no contribution (char not useful for this player)
    beq.b   .l33444

; --- Phase: Mode-Specific Score Comparison ---
    tst.w   d5
    bne.b   .l3340e              ; mode != 0: use profit comparison

; Mode 0: beat-this by raw rating byte
    moveq   #$0,d0
    move.b  $0001(a2),d0         ; candidate rating byte (+$1 of char group record)
    moveq   #$0,d1
    move.w  d3,d1                ; d3 = current best rating
    cmp.l   d1,d0                ; candidate rating > best so far?
    ble.b   .l33444              ; no: skip
    moveq   #$0,d3
    move.b  $0001(a2),d3         ; update best rating with this candidate
    bra.b   .l33442

.l3340e:                                                ; $03340E
; Mode 1: beat-this using CalcCharProfit (returns lower = worse, so we want lower than d3)
    cmpi.w  #$1,d5
    bne.b   .l33444
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)             ; candidate index
    moveq   #$0,d0
    move.b  $0001(a3),d0         ; route_slot+$01 = city_b
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0              ; route_slot+$00 = city_a
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr CalcCharProfit ($0206EE)
    lea     $0010(sp),sp
    move.w  d0,d4                ; d4 = candidate's profit score
    cmp.w   d3,d4                ; candidate profit >= current best? (lower is better here)
    bcc.b   .l33444              ; no improvement: skip
    move.w  d4,d3                ; update best profit threshold

.l33442:                                                ; $033442
; Record this candidate as the new best
    move.w  d2,d6                ; d6 = best candidate index found so far

.l33444:                                                ; $033444
; Advance to next candidate: step by $C bytes, increment index, loop for 16 candidates
    moveq   #$c,d0
    adda.l  d0,a2                ; next char group record ($C bytes per entry)
    addq.w  #$1,d2               ; candidate index++
    cmpi.w  #$10,d2              ; 16 candidates total
    bcs.w   .l333aa

; --- Phase: Return ---
    move.w  d6,d0                ; D0 = index of best candidate ($FF if none found)
    movem.l -$0024(a6),d2-d7/a2-a3
    unlk    a6
    rts
; === Translated block $03345E-$034CC4 ===
; 26 functions, 6246 bytes
