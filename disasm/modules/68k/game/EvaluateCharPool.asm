; ============================================================================
; EvaluateCharPool -- Scores alliance preference pairs for AI: checks profitability, availability, and match state; offers contracts
; 632 bytes | $0341C2-$034439
; ============================================================================
; Argument: 8(a6) = player_index (d6, 0-3): which AI player is evaluating
; A5 = BitFieldSearch ($6EEA): used to look up relation-slot index for char pairs
; A4 = local score array base (-$c(a6)): 6 words, one per preference slot
; -$c(a6)..-$02(a6): score_array[0..5] -- preference pair scoring scratch (6 words)
; -$18(a6): sorted_order_array -- 6 words holding sorted preference slot indices
; -$1a(a6): active_player_count -- result of CountActivePlayers
; A2 = $FFA794: alliance preference table (6 pairs × 4 bytes: word pair1, word pair2)
; Data structure at $FFA794: pairs[6] { word char_id_1, word char_id_2 }
EvaluateCharPool:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6          ; d6 = player_index (0-3)
    lea     -$c(a6), a4         ; a4 = score_array base (6 × word, one per preference pair)
    movea.l  #$00006EEA,a5      ; a5 = BitFieldSearch entry point
; --- Phase: Initialise score array and player context ---
    pea     ($000C).w           ; 12 bytes = 6 words
    clr.l   -(a7)               ; fill value = 0
    move.l  a4, -(a7)           ; destination = score_array
    jsr MemFillByte              ; zero all 6 preference-pair scores
; Compute hub city's region index for this player:
; player_record+$01 = hub_city byte; RangeLookup maps it to region index 0-7
    move.w  d6, d0
    mulu.w  #$24, d0            ; player_index * 36 (player_record stride)
    movea.l  #$00FF0018,a0      ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> player_record[player_index]
    moveq   #$0,d0
    move.b  $1(a2), d0          ; player_record+$01 = hub_city index
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup              ; map hub_city to region index 0-7
    lea     $10(a7), a7
    move.w  d0, d4              ; d4 = hub region index (used later for "hub city bonus" check)
; Count active players (those with active_flag == 1) for single-player mode bonus
    jsr CountActivePlayers
    move.w  d0, -$1a(a6)        ; save active_player_count on frame
; --- Phase: Score each preference pair (6 pairs from $FFA794) ---
; $FFA794 = alliance preference table: 6 entries × 4 bytes each
; Each entry: word char_id_1 (+$00), word char_id_2 (+$02)
    movea.l  #$00FFA794,a2      ; a2 -> preference table start
    clr.w   d3                  ; d3 = pair index (0-5)
; Compute initial a3 pointer into score_array (word offset = d3 * 2)
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0              ; word stride
    lea     (a4,d0.l), a0
    movea.l a0, a3              ; a3 -> score_array[d3]
; Outer scoring loop: iterate through all 6 preference pairs
l_3422c:
; Look up char_id_1 in the bit field for this player (BitFieldSearch returns slot index or $FF)
    moveq   #$0,d0
    move.w  (a2), d0            ; char_id_1 (first of the pair)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr     (a5)                 ; BitFieldSearch: find slot index for char_id_1, player d6
    move.w  d0, d5              ; d5 = slot for char_id_1 ($FF = not found)
    cmpi.w  #$ff, d5
    bne.b   l_34244
    moveq   #-$2,d5             ; $FF not found -> encode as -2 for score math
; Look up char_id_2 in the bit field
l_34244:
    moveq   #$0,d0
    move.w  $2(a2), d0          ; char_id_2 (second of the pair)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr     (a5)                 ; BitFieldSearch: find slot index for char_id_2
    lea     $10(a7), a7
    move.w  d0, d2              ; d2 = slot for char_id_2 ($FF = not found)
    cmpi.w  #$ff, d2
    bne.b   l_34262
    moveq   #-$2,d2             ; $FF not found -> encode as -2
; --- Profitability filter ---
; product = (d5+1) * (d2+1): both -2 -> product = (-2+1)*(-2+1) = 1 (positive, skip)
; If one is -2 (not found) and other found: product = (-2+1)*(slot+1) = -(slot+1) (negative)
; Negative product means only one char found -- pair is incomplete, skip scoring
l_34262:
    move.w  d5, d0
    addq.w  #$1, d0             ; d5 + 1
    move.w  d2, d1
    addq.w  #$1, d1             ; d2 + 1
    mulu.w  d1, d0              ; product = (d5+1) * (d2+1)
    move.w  d0, d2
    tst.w   d2                  ; is product negative (one char found, one not)?
    bge.w   l_34302             ; zero or positive -> skip (both missing or product overflowed)
; Exactly one of the two chars is found (slot ≠ -2 but other is -2):
; Reorder so d5 = the NOT-found one, d2+$2(a2) = the found one
    tst.w   d5
    bge.b   l_34282             ; d5 >= 0 means d5 found, d2 not found (already ordered)
; Swap so pair entry always has "not-found" char in first position
    move.w  $2(a2), d2
    move.w  (a2), $2(a2)
    move.w  d2, (a2)
; --- Score accumulation for this pair ---
l_34282:
; CheckCharPairConflict: returns nonzero if these two chars conflict (should not be paired)
    moveq   #$0,d0
    move.w  $2(a2), d0          ; char_id of the "found" char (second slot)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0            ; char_id of the "not found" char (first slot)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr (CheckCharPairConflict,PC) ; returns 0 = no conflict (pair is compatible)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_34302             ; conflict: skip this pair entirely
; Base score: +$64 (100) for a compatible pair with one char already in roster
    addi.w  #$64, (a3)          ; score_array[pair] += 100
; Hub city bonus: if either char_id matches the hub region (d4), add $1E (30)
    cmp.w   (a2), d4            ; char_id_1 == hub region?
    beq.b   l_342b2
    cmp.w   $2(a2), d4          ; char_id_2 == hub region?
    bne.b   l_342b6             ; neither matches hub
l_342b2:
    addi.w  #$1e, (a3)          ; hub city bonus: score += 30
; Single-player mode bonus: if only 1 active player, add +$64 if "found" char is available
l_342b6:
    cmpi.w  #$1, -$1a(a6)       ; is active_player_count == 1?
    bne.b   l_342d6             ; more than 1 active player -- skip this bonus
    moveq   #$0,d0
    move.w  $2(a2), d0          ; char_id of the "found" char
    move.l  d0, -(a7)
    jsr (CheckCharAvailable,PC)  ; is char still available for contract?
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342d6             ; already contracted: no bonus
    addi.w  #$64, (a3)          ; availability bonus in single-player: score += 100
; Alliance slot bonus: +$14 (20) if the "found" char has no filled alliance slots
l_342d6:
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    jsr (CountFilledAllianceSlots,PC) ; returns number of filled alliance slots for this char
    nop
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_342ee             ; has alliance slots: no bonus
    addi.w  #$14, (a3)          ; open alliance slot bonus: score += 20
; Special char bonus: +$32 (50) for high-value chars (ID 3 = president, ID 5 = celebrity)
l_342ee:
    cmpi.w  #$3, $2(a2)         ; char_id == 3 (president / top executive)?
    beq.b   l_342fe
    cmpi.w  #$5, $2(a2)         ; char_id == 5 (celebrity / star player)?
    bne.b   l_34302
l_342fe:
    addi.w  #$32, (a3)          ; special char bonus: score += 50
; If score <= 0 after all evaluation, invalidate this pair by setting both IDs to $FF
l_34302:
    tst.w   (a3)
    bgt.b   l_34310             ; positive score: keep this pair
    move.w  #$ff, d0
    move.w  d0, (a2)            ; char_id_1 = $FF (invalid / discard)
    move.w  d0, $2(a2)          ; char_id_2 = $FF
; Advance to next pair entry (4 bytes each in $FFA794, 2 bytes each in score_array)
l_34310:
    addq.l  #$4, a2             ; advance preference table pointer (4 bytes/entry)
    addq.l  #$2, a3             ; advance score array pointer (2 bytes/entry)
    addq.w  #$1, d3             ; pair_index++
    cmpi.w  #$6, d3             ; 6 pairs total
    bcs.w   l_3422c
; --- Phase: Sort pairs by score (descending) using selection sort ---
; Result: sorted_order_array[-$18(a6)] holds pair indices ranked best to worst
; Up to 6 iterations, each extracting the highest-scored remaining pair
    clr.w   d4                  ; d4 = output rank position (0-5)
l_34320:
    movea.l a4, a2              ; a2 -> score_array[0]
    moveq   #-$A,d2             ; d2 = current max score (start at -10 / very low)
    clr.w   d3                  ; d3 = current scan index
l_34326:
    cmp.w   (a2), d2            ; compare score_array[d3] with current max
    bge.b   l_3432e             ; not better: skip
    move.w  (a2), d2            ; new max found
    move.w  d3, d7              ; d7 = index of best pair so far
l_3432e:
    addq.l  #$2, a2             ; advance to next score word
    addq.w  #$1, d3
    cmpi.w  #$6, d3             ; scanned all 6 entries?
    bcs.b   l_34326
; Mark the best entry as "consumed" by writing $FF9C (a very negative word) so it won't win again
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0              ; word offset into score_array
    movea.l d0, a0
    move.w  #$ff9c, (a4,a0.l)   ; $FF9C = consumed sentinel (–100 in signed word)
; Record the best pair's index at rank position d4 in sorted_order_array
    move.w  d4, d0
    add.w   d0, d0              ; word offset in sorted_order_array
    move.w  d7, -$18(a6, d0.w) ; sorted_order_array[rank] = best_pair_index
    addq.w  #$1, d4             ; advance rank
    cmpi.w  #$6, d4             ; done all 6 ranks?
    bcs.b   l_34320
; --- Phase: Process pairs in ranked order -- offer contracts ---
    clr.w   d4                  ; d4 = rank position (0-5)
l_34358:
; Look up pair index for this rank from sorted_order_array
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$18(a6, d0.w), d0  ; d0 = pair_index for this rank
    lsl.w   #$2, d0             ; pair_index * 4 (preference table stride)
    movea.l  #$00FFA794,a0      ; preference table base
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> preference entry for best remaining pair
; Skip pairs that were invalidated ($FF in first char slot)
    cmpi.w  #$ff, (a2)          ; char_id_1 == $FF = invalid pair
    beq.w   l_34430             ; stop processing (no more valid pairs)
; Look up slot for char_id_1 again (to get actual slot context for contract offer)
    moveq   #$0,d0
    move.w  (a2), d0            ; char_id_1
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr     (a5)                 ; BitFieldSearch: slot for char_id_1
    move.w  d0, d3              ; d3 = slot_1
; Offer a contract for the pair (char_id_2 + slot_1, player d6)
    moveq   #$0,d0
    move.w  $2(a2), d0          ; char_id_2
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0              ; slot_1 (context for contract placement)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr (OfferCharContract,PC)   ; attempt to sign char_id_2 into the alliance slot with char_id_1
    nop
    lea     $14(a7), a7
    move.w  d0, d2              ; d2 = result char_id (or $FF = declined / not possible)
; If either char is already contracted ($20+) skip the match turn step
    cmpi.w  #$20, d3            ; slot_1 >= $20 (already alliance-contracted)?
    bcc.b   l_34426
    cmpi.w  #$20, d2            ; returned char_id_2 >= $20 (already alliance-contracted)?
    bcc.b   l_34426
; Run a match turn for these two chars (AI decides whether to proceed with pairing)
    moveq   #$0,d0
    move.w  d2, d0              ; char_id_2 (accepted contract char)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0              ; slot_1 (context)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr (RunMatchTurn,PC)        ; execute one match/negotiation turn for this pair
    nop
    lea     $c(a7), a7
    move.w  d0, d5              ; d5 = match result code
; If result code >= $10 the match is unresolved or failed; stop further processing
    cmpi.w  #$10, d5
    bcc.b   l_34426             ; result >= $10: skip slot assignment
; Find an empty match slot for this result
    moveq   #$0,d0
    move.w  d2, d0              ; char_id_2
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0              ; slot_1
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr (FindEmptyMatchSlot,PC)  ; find an unused match slot index
    nop
    lea     $c(a7), a7
    move.w  d0, d7              ; d7 = empty match slot index
; Bounds check: slot index must be within the valid range (< $FFA7DA limit)
    cmp.w   ($00FFA7DA).l, d7   ; $FFA7DA = match slot count limit
    bcc.b   l_34430             ; slot out of range: abort
; CalcMatchScore: record/score the match in the match slot
    moveq   #$0,d0
    move.w  d5, d0              ; match result code
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0              ; char_id_2
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0              ; slot_1
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0              ; match slot index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0              ; player_index
    move.l  d0, -(a7)
    jsr (CalcMatchScore,PC)      ; record the pairing outcome into the match slot
    nop
    lea     $14(a7), a7
    bra.b   l_34430             ; done for this ranked pair
l_34426:
    addq.w  #$1, d4             ; try next ranked pair
    cmpi.w  #$6, d4             ; processed all 6 ranked pairs?
    bcs.w   l_34358
l_34430:
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts
