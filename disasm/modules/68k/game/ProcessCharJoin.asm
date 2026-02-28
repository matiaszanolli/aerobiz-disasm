; ============================================================================
; ProcessCharJoin -- Evaluates all candidate chars for recruitment to a player; returns best scoring char index
; 778 bytes | $035D46-$03604F
; ============================================================================
ProcessCharJoin:
; --- Phase: Setup ---
; Args: $8(a6) = ? (unused directly, but passed to IsCharSlotAvailable/$12(a6))
;       $A(a6) = player_index (word)
;       $C(a6) = city_slot_type (word, d6): selects which char roster range to search
;       $12(a6) = scoring mode flag (0=negotiation-only, nonzero=compat-weighted)
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
; d6 = city_slot_type argument (determines which range of the char table to scan)
    move.l  $c(a6), d6
; a5 = -$4(a6): best_score (longword local variable, initialized to 0 when slot found)
    lea     -$4(a6), a5
; Compute index into ROM table $5ECBC: city_slot_type * 4 (4 bytes per entry)
; $5ECBC: range descriptor table -- each 4-byte entry: [start, count_a, start_b, count_b]
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
; a3 = pointer to the city slot descriptor for this slot type
    movea.l a0, a3
; BitFieldSearch(player_index=$A(a6), slot_type=d6):
; Find the first set bit in the player's bitfield for this city slot type
; Returns d0 = bit index, or $20 if the roster has no match for this type
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
; d5 = returned rival/competitor bit index
    move.w  d0, d5
; d6 = $FF: default return value (no best char found)
    move.w  #$ff, d6
; $20 = "not found" sentinel: if player has no chars in this slot type, return $FF
    cmpi.w  #$20, d5
    bcc.w   l_36044
; --- Phase: Initialize Scan Variables ---
; Reset best_score to 0 (start fresh; first qualifying candidate sets the baseline)
    clr.l   (a5)
; d7 = 0: running best score for the second pass (compat-weighted path)
    moveq   #$0,d7
; Compute starting position in $FF0728 (char display lookup table): a3[0] * 2
; a3[0] = range start index; $FF0728 = char_display_tab (40-byte lookup)
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
; a4 = pointer into char_display_tab at the starting index for this slot type
    movea.l a0, a4
; Compute starting position in $FF8824 (tab32_8824): a3[0] * 2
; tab32_8824 = 32-entry stride-2 table; used as char eligibility / availability flags
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
; a2 = pointer into tab32_8824 at starting index
    movea.l a0, a2
; d4 = current candidate char index (initialized to a3[0] = range start)
    moveq   #$0,d4
    move.b  (a3), d4
    bra.w   l_35edc
; --- Phase: First-Pass Candidate Loop (Primary Range: a3[0]..a3[0]+a3[1]) ---
l_35dba:
; Gate 1: slot_count cap -- char_display_tab entry must be < 8
; If (a4) >= 8: this candidate is already fully recruited (all slots filled)
    cmpi.b  #$8, (a4)
; (a4) = char slot assignment count; skip if maxed at 8
    bcc.w   l_35ed6
; Gate 2: skip the rival char (d5 = BitFieldSearch result = the char already held by rival)
    cmp.w   d4, d5
; Skip this candidate if it is the rival's current char (would be redundant)
    beq.w   l_35ed6
; IsCharSlotAvailable(char_index=d4, rival_bit=d5, player_index=$A(a6)):
; Check that this char's slot is free for the recruiting player
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (IsCharSlotAvailable,PC)
    nop
    lea     $c(a7), a7
; If not available (d0 nonzero), skip this candidate
    tst.w   d0
    bne.w   l_35ed6
; --- Phase: Score Candidate (First Pass) ---
; CalcNegotiationPower(char_index=d4, rival_bit=d5):
; Computes how much this char wants to join vs go to the rival
; Higher = better for us; lower = char prefers rival
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
; d3 = negotiation power (keep low 16 bits only)
    move.l  d0, d3
    andi.l  #$ffff, d3
; CountCharPairSlots(char_index=d4): count how many slot pairs already involve this char
; Returns d0 = count of existing pair assignments (0-4)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (CountCharPairSlots,PC)
    nop
; d2 = existing pair slot count
    move.w  d0, d2
; Compute scarcity bonus: max(2, 4 - pair_count)
; Fewer existing pairs = this char is in higher demand = larger bonus multiplier
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35e2c
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35e2e
l_35e2c:
; Clamp scarcity bonus to minimum of 2
    moveq   #$2,d1
l_35e2e:
    move.w  d1, d2
; d3 = negotiation_power * scarcity_bonus (weighted score component)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    jsr Multiply32
; Round result before arithmetic shift (avoid sign-biased truncation)
    tst.l   d0
    bge.b   l_35e42
    addq.l  #$3, d0
l_35e42:
; d3 = (negotiation_power * scarcity) / 4 (scaled to manageable range)
    asr.l   #$2, d0
    move.l  d0, d3
; GetCharStatPtr(char_index=d4, rival_bit=d5): fetch the char's primary stat value
; Returns d0 = stat value (used to compute a "tier" bonus 0-7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetCharStatPtr,PC)
    nop
    lea     $14(a7), a7
; Compute tier: stat_value / $A (10); clamped to max 7
; Tier 0-7 acts as a quality multiplier in the final score
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35e78
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35e7a
l_35e78:
; Clamp tier to 7 (prevents overflow in final score multiplication)
    moveq   #$7,d0
l_35e7a:
    move.w  d0, d2
; --- Phase: Scoring Mode Branch ---
; $12(a6) = scoring mode: 0=negotiation-only, nonzero=compat-weighted
    tst.w   $12(a6)
    bne.b   l_35e98
; Mode 0: final_score = (neg_power * scarcity / 4) * tier
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    jsr Multiply32
    move.l  d0, d3
; Compare against current best_score at (a5); update if better
    cmp.l   (a5), d3
    bls.b   l_35ed6
    move.l  d3, (a5)
    bra.b   l_35ed4
l_35e98:
; Mode nonzero: compat-weighted scoring
; CharCodeScore(char_a=d4, rival=d5): percentage match score for these two char codes
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
; compat_score / 10 -> rough 0-10 compat scale
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr UnsignedDivide
; final = (compat/10) * (neg * scarcity / 4) * tier
    move.l  d3, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d3
; Compare against best seen in d7 (second-pass best tracker)
    cmp.l   d7, d3
    bls.b   l_35ed6
    move.l  d3, d7
l_35ed4:
; Record this candidate's char index as the current best
    move.w  d4, d6
l_35ed6:
; Advance to next entry in the display/availability tables (stride 2)
    addq.l  #$2, a4
    addq.l  #$2, a2
    addq.w  #$1, d4
l_35edc:
; Loop condition: d4 < a3[0] + a3[1] (iterate the primary range)
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35dba
; --- Phase: Second-Pass Candidate Loop (Extended Range: a3[2]..a3[2]+a3[3]) ---
; After exhausting the primary range, scan the secondary range (a3[2] = start, a3[3] = count)
    moveq   #$0,d0
    move.b  $2(a3), d0
    add.w   d0, d0
; Reset a2 to tab32_8824 at secondary range start
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
; d4 = secondary range start index
    moveq   #$0,d4
    move.b  $2(a3), d4
    bra.w   l_3602c
l_35f10:
; Gate: tab32_8824 entry pair comparison -- entry[0] must be > entry[1]
; This selects chars that are "better" (higher slot score) than a threshold value
    move.b  (a2), d0
    cmp.b   $1(a2), d0
; If entry[0] <= entry[1], skip this candidate
    bls.w   l_36028
; IsCharSlotAvailable: same gate as first pass -- slot must be free
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (IsCharSlotAvailable,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.w   l_36028
; CalcNegotiationPower + CountCharPairSlots + scarcity (same structure as first pass)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    move.l  d0, d3
    andi.l  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (CountCharPairSlots,PC)
    nop
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    moveq   #$2,d0
    cmp.l   d1, d0
    bge.b   l_35f7e
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$4,d1
    sub.l   d0, d1
    bra.b   l_35f80
l_35f7e:
    moveq   #$2,d1
l_35f80:
    move.w  d1, d2
; d3 = (negotiation_power * scarcity_bonus) / 4
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d3, d1
    jsr Multiply32
    tst.l   d0
    bge.b   l_35f94
    addq.l  #$3, d0
l_35f94:
    asr.l   #$2, d0
    move.l  d0, d3
; GetCharStatPtr: same stat tier lookup (0-7 clamp) as first pass
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (GetCharStatPtr,PC)
    nop
    lea     $14(a7), a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$7, d2
    bcc.b   l_35fca
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_35fcc
l_35fca:
    moveq   #$7,d0
l_35fcc:
    move.w  d0, d2
; Mode branch (same logic as first pass, reused for secondary range candidates)
    tst.w   $12(a6)
    bne.b   l_35fea
; Mode 0: score = (neg * scarcity / 4) * tier; compare against best_score at (a5)
    moveq   #$0,d1
    move.w  d2, d1
    move.l  d3, d0
    jsr Multiply32
    move.l  d0, d3
    cmp.l   (a5), d3
    bls.b   l_36028
    move.l  d3, (a5)
    bra.b   l_36026
l_35fea:
; Mode nonzero: compat-weighted score = (compat/10) * (neg * scarcity / 4) * tier
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d3, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d3
; Compare against d7 (second-pass best tracker)
    cmp.l   d7, d3
    bls.b   l_36028
    move.l  d3, d7
l_36026:
; Record this candidate's char index as the new best
    move.w  d4, d6
l_36028:
; Advance to next tab32_8824 entry (stride 2)
    addq.l  #$2, a2
    addq.w  #$1, d4
l_3602c:
; Loop condition: d4 < a3[2] + a3[3] (iterate the secondary range)
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.w   l_35f10
; --- Phase: Return Best Candidate ---
l_36044:
; d6 = index of best scoring candidate, or $FF if no valid candidate was found
    move.w  d6, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
