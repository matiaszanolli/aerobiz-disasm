; ============================================================================
; PositionUIControl -- Computes and applies per-player UI bar positions: calls ResizeUIPanel for each of 4 players to get a city-slot index, then for valid (< 0x28) slots calculates scaled revenue scores from the route tables (weighted by $FF0120 popularity factors and negotiation power) and calls UpdateUIPalette to write the result, accumulating total revenue in D6.
; 700 bytes | $01FC50-$01FF0B
; ============================================================================
PositionUIControl:
    link    a6,#-$20
    ; Frame layout (a6-relative):
    ;   -$08 to -$02: slot_index[0..3]  (word each, 4-entry array from ResizeUIPanel results)
    ;   -$18 to -$0C: revenue_score[0..3] (long each, 4-entry array of per-player scaled scores)
    ;   -$1C        : neg_power_ptr       (longword, pointer into negotiation-power table)
    ;   -$20        : popularity_ptr      (longword, pointer into $FF0120 city popularity array)
    movem.l d2-d6/a2-a5, -(a7)
    ; --- Phase 1: Call ResizeUIPanel for all 4 players, collect slot indices ---
    ; Arg from caller: D4 = some UI mode/context parameter passed through
    move.l  $8(a6), d4
    ; D5 = count of players with invalid/absent slot entries (slot_index == $FF)
    clr.w   d5
    ; D2 = player loop counter [0..3]
    clr.w   d2
    ; Compute pointer into slot_index array at -$8(a6): base - 8 + player*2
    move.w  d2, d0
    add.w   d0, d0
    ; A2 = &slot_index[d2] in the link frame; starts at -$8(a6) for player 0
    lea     -$8(a6, d0.w), a0
    movea.l a0, a2
l_1fc6a:
    ; Push args and call ResizeUIPanel(player_index=D2, context=D4)
    ; Returns D0 = city-slot index for this player, or >= $28 if none
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ResizeUIPanel,PC)
    nop
    addq.l  #$8, a7
    ; Store slot_index[d2] = D0
    move.w  d0, (a2)
    move.w  (a2), d3
    ; If slot index >= $28 (40 decimal), player has no route slot -- skip
    ; route_slot array has 40 entries per player (0..$27 valid, $28+ = none)
    cmpi.w  #$28, d3
    bcc.b   l_1fcc8
    ; Check status_flags at route_slot+$0A: bit 1 = SUSPENDED flag
    ; Compute byte offset into route_slots: player*$320 + slot*$14 + $0A
    move.w  d2, d0
    mulu.w  #$320, d0          ; player stride = 40 slots * $14 bytes = $320
    move.w  d3, d1
    mulu.w  #$14, d1           ; slot stride = $14 (20 bytes per route_slot)
    add.w   d1, d0
    ; $FF9A2A = route_slots base ($FF9A20) + $0A (status_flags offset)
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    ; Bit 1 of status_flags = SUSPENDED; if set, route is inactive -- skip
    andi.l  #$2, d0
    bne.b   l_1fcc8
    ; Check negotiation-power table at $FFB4E8: player * $140 + slot * $8
    ; If entry is zero, this slot has no negotiation data; count as "absent" (d5++)
    move.w  d2, d0
    mulu.w  #$140, d0          ; player stride in neg-power table
    move.w  d3, d1
    lsl.w   #$3, d1            ; slot * 8 (8 bytes per entry)
    add.w   d1, d0
    ; $FFB4E8 = negotiation-power table base
    movea.l  #$00FFB4E8,a0
    tst.w   (a0,d0.w)
    bne.b   l_1fcc4
    ; No negotiation-power entry: increment absent-slot counter
    addq.w  #$1, d5
    bra.b   l_1fcc8
l_1fcc4:
    ; Negotiation-power entry exists but slot failed other checks:
    ; mark slot_index as $FF (invalid sentinel) in the frame array
    move.w  #$ff, (a2)
l_1fcc8:
    ; Advance to next player's slot_index slot and increment counter
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1fc6a
    ; --- Phase 1 complete; check if enough valid players to proceed ---
    ; If D5 <= 1 (0 or 1 players absent), only 1 or fewer have data: bail to Phase 3
    ; "bls" = branch if lower or same (unsigned <=)
    cmpi.w  #$1, d5
    bls.w   l_1fe20
    ; --- Phase 2: Compute revenue scores for all 4 players ---
    ; D6 = total revenue accumulator (sum of all per-player revenue scores)
    moveq   #$0,d6
    ; Store pointer to $FF0120 (city popularity / modifier array) in frame slot -$20
    ; Will be advanced by 4 bytes per player in the loop (one long per player entry)
    move.l  #$ff0120, -$20(a6)
    clr.w   d2
    ; A3 = pointer into revenue_score[] array at -$18(a6): base - $18 + player*4
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$18(a6, d0.w), a0
    movea.l a0, a3
    ; A5 = pointer into route-stats table at $FF1004: base + player*$1C
    ; ($FF1004 holds per-player route stat records, stride $1C = 28 bytes)
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    ; A4 = pointer into negotiation-power table at $FFB4E4: base + player*$140
    ; (Offset $FFB4E4 is 4 bytes before $FFB4E8, covering a header word per player block)
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1fd14:
    ; Load slot_index[d2] from frame: -$8(a6) + player*2
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    ; Skip if no valid slot (index >= $28)
    cmpi.w  #$28, d3
    bcc.w   l_1fe08
    ; Compute route_slot pointer: &route_slots[player][slot]
    ; Offset = player*$320 + slot*$14
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    ; A2 = pointer to this player's route_slot record
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; D3 = slot_index as longword; used as byte offset (slot * 8) into neg-power block
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0            ; slot * 8 (neg-power entry stride)
    move.l  d0, d3
    ; A0 = &neg_power[player][slot] within player's $140-byte block
    lea     (a4,d0.l), a0
    ; Save this pointer in frame slot -$1C for later retrieval
    move.l  a0, -$1c(a6)
    ; Re-check SUSPENDED bit (status_flags+$0A bit 1) before computing score
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_1fe08
    ; Compute ticket_price / 100: route_slot+$04 = ticket_price (word)
    ; This gives a normalized fare score
    moveq   #$0,d0
    move.w  $4(a2), d0         ; route_slot+$04 = ticket_price
    moveq   #$64,d1            ; divisor = 100 ($64)
    jsr SignedDiv
    ; Clamp result: if quotient < 1, use 1 (minimum weight)
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1fd82
    ; Quotient >= 1: push quotient onto stack as the weight
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)          ; push weight = ticket_price/100
    bra.b   l_1fd88
l_1fd82:
    ; Quotient < 1: clamp weight to minimum of 1
    move.l  #$1, -(a7)
l_1fd88:
    ; Load city_a (route_slot+$00) and city_b (route_slot+$02) popularity scores
    ; from the route-stats table (a5), indexed by city code * 4
    movea.l -$1c(a6), a0       ; restore neg_power[player][slot] pointer
    move.w  (a0), d0           ; word at +$00 = city_a code
    andi.l  #$ffff, d0
    lsl.l   #$2, d0            ; city_a * 4 (long offset into route-stats table)
    movea.l d0, a0
    move.l  (a5,a0.l), d0     ; load city_a popularity entry from $FF1004 table
    movea.l -$1c(a6), a0
    move.w  $2(a0), d1         ; word at +$02 = city_b code
    andi.l  #$ffff, d1
    lsl.l   #$2, d1            ; city_b * 4
    movea.l d1, a0
    ; D0 = city_a_pop + city_b_pop (combined route popularity)
    add.l   (a5,a0.l), d0
    ; Multiply combined popularity by negotiation modifier at neg_power[slot]+$06
    movea.l a4, a0
    adda.l  d3, a0             ; a0 = &neg_power[player][slot]
    move.w  $6(a0), d1         ; word at +$06 = negotiation modifier factor
    andi.l  #$ffff, d1
    jsr Multiply32             ; D0 = combined_pop * neg_modifier
    ; Divide by the weight we pushed earlier (ticket_price/100, min 1)
    move.l  (a7)+, d1          ; pop weight from stack
    jsr UnsignedDivide         ; D0 /= weight
    ; Divide again by 100 to normalize into a compact score
    moveq   #$64,d1
    jsr UnsignedDivide         ; D0 /= 100
    ; Store intermediate result in revenue_score[d2]
    move.l  d0, (a3)
    ; Multiply by popularity byte from $FF0120 array (one byte per player per pass)
    movea.l -$20(a6), a0       ; current popularity_ptr (advances each iteration)
    move.b  (a0), d1           ; load one byte popularity modifier
    andi.l  #$ff, d1
    move.l  (a3), d0
    jsr Multiply32             ; D0 = score * popularity_byte
    move.l  d0, (a3)
    ; Divide by 10 to scale down
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a3)
    ; Clamp revenue_score[d2] to minimum of 1
    moveq   #$1,d0
    cmp.l   (a3), d0
    bcc.b   l_1fe02
    ; Score > 1: use it as is
    move.l  (a3), d0
    bra.b   l_1fe04
l_1fe02:
    ; Score < 1: floor to 1
    moveq   #$1,d0
l_1fe04:
    ; Write clamped score back and add to global revenue accumulator D6
    move.l  d0, (a3)
    add.l   (a3), d6           ; D6 += revenue_score[d2]
l_1fe08:
    ; Advance all per-player pointers for next iteration:
    addq.l  #$4, -$20(a6)     ; popularity_ptr += 4 (next player's byte)
    lea     $140(a4), a4       ; neg-power table: advance by player stride $140
    moveq   #$1C,d0
    adda.l  d0, a5             ; route-stats table: advance by $1C per player
    addq.l  #$4, a3            ; revenue_score[] pointer: advance by longword
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fd14
    ; --- Phase 3: Apply negotiation-power bars for each player via UpdateUIPalette ---
l_1fe20:
    clr.w   d2                 ; player loop counter reset to 0
l_1fe22:
    ; Load slot_index[d2] again from frame array
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    ; Skip invalid slots
    cmpi.w  #$28, d3
    bcc.w   l_1fef8
    ; Reconstruct route_slot pointer for this player/slot
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; Check SUSPENDED bit again
    move.b  $a(a2), d0         ; route_slot+$0A = status_flags
    andi.l  #$2, d0
    bne.b   l_1fe94
    ; Compute raw negotiation power: CalcNegotiationPower(city_a, city_b)
    ; route_slot+$00 = city_a, route_slot+$01 = city_b
    moveq   #$0,d0
    move.b  $1(a2), d0         ; city_b
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0           ; city_a
    move.l  d0, -(a7)
    jsr CalcNegotiationPower   ; returns D0 = raw negotiation-power value
    addq.l  #$8, a7
    move.w  d0, d4             ; D4 = raw negotiation power
    ; If D5 <= 1 (few valid players), skip revenue-ratio scaling; use raw power
    cmpi.w  #$1, d5
    bls.b   l_1fe96
    ; Scale: bar_height = revenue_score[d2] * raw_neg_power / total_revenue (D6)
    ; This normalizes each player's bar relative to total revenue
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$18(a6, d0.w), d0  ; revenue_score[d2] (longword from Phase 2)
    moveq   #$0,d1
    move.w  d4, d1             ; raw negotiation power
    jsr Multiply32             ; D0 = revenue_score * raw_neg_power
    move.l  d6, d1             ; D6 = total accumulated revenue
    jsr UnsignedDivide         ; D0 = scaled bar height proportional to share
    move.w  d0, d4             ; D4 = final scaled negotiation-power bar height
    bra.b   l_1fe96
l_1fe94:
    ; Slot is suspended: bar height = 0 (no power displayed)
    clr.w   d4
l_1fe96:
    ; Further scale D4 by a second modifier from $FFB4EA: player*$140 + slot*$8 + $2
    ; $FFB4EA = $FFB4E8 + $2; word at +$02 of each 8-byte neg-power entry
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1            ; slot * 8
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0      ; secondary modifier word
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32             ; D0 = scaled_power * secondary_modifier
    moveq   #$64,d1
    jsr UnsignedDivide         ; D0 /= 100 (normalize to percentage)
    move.w  d0, d4             ; D4 = final bar height after secondary scaling
    ; Check trade/alliance validity: ValidateTradeReq(player_index=D2, slot_index=D3)
    ; Returns D0 = 1 if trade is valid, 0 if not; multiply D4 by D0 to gate bar
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)          ; slot_index
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)          ; player_index
    jsr (ValidateTradeReq,PC)
    nop
    ; If trade invalid (D0=0), bar height becomes 0; if valid (D0=1), unchanged
    mulu.w  d4, d0
    move.w  d0, d4             ; D4 = gated final bar height
    ; Call UpdateUIPalette(player_index=D2, slot_index=D3, bar_height=D4)
    ; This writes the computed bar position into the VDP palette / UI bar structure
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)          ; bar_height
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)          ; slot_index
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)          ; player_index
    jsr (UpdateUIPalette,PC)
    nop
    lea     $14(a7), a7        ; pop 5 longwords (ValidateTradeReq x2 + UpdateUIPalette x3)
l_1fef8:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fe22
    ; --- Epilogue ---
    movem.l -$44(a6), d2-d6/a2-a5
    unlk    a6
    rts
