; ============================================================================
; FadeGraphics -- Applies negotiation/trade power weighting to each active player: for each city slot calls ManageUIElement to find the matched route index, computes per-player revenue contributions scaled by the negotiation power factor (CalcNegotiationPower), and calls UpdateUIPalette to write the final colour/value into each player's UI palette entry, iterating until all city slots are processed.
; 854 bytes | $01F82E-$01FB83
; ============================================================================
; --- Phase: Setup -- allocate frame, save registers, resolve city-range table entry ---
FadeGraphics:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    ; arg $a(a6) = city-slot index; convert to range bucket 0-7
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    ; RangeLookup: map city slot value to range index (0-7) via cumulative threshold table
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d5
    ; d0 = range bucket * 4 -> index into city-range table at $5ECBC
    lsl.w   #$2, d0
    ; $5ECBC: city-range descriptor table; each entry has count byte[0] and base byte[1]
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    ; save pointer to this city-range descriptor for outer-loop termination test
    move.l  a0, -$4(a6)
    ; a5 -> char_stat_subtab base $FF0120; iterated per player to pick per-player scale factor
    movea.l  #$00FF0120,a5
    ; d5 = outer loop counter (city slot index); outer loop walks through all cities in range
    move.w  $a(a6), d5
    ; jump to loop-exit test first (loop is structured as do-while from the back)
    bra.w   l_1fb52
; --- Phase: Outer loop -- one iteration per city slot in range ---
l_1f866:
    ; check whether this city slot (d5) is a valid/active UI element
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; ValidateInputState: returns nonzero if city slot d5 is active/enabled
    bsr.w ValidateInputState
    addq.l  #$4, a7
    tst.w   d0
    ; if slot is inactive, skip to outer-loop increment (d0 == 0 means nothing to process)
    beq.w   l_1fb52
    ; --- Phase: Pass 1 -- scan 4 players, call ManageUIElement, tally valid trade slots ---
    ; d2 = player index (0-3); d7 = count of valid trade slots (players with active trades)
    clr.w   d2
l_1f87a:
    ; call ManageUIElement(player=d5, city=$a(a6), slot=d2) -> route index in d0
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; ManageUIElement: returns route slot index for (player, city, slot) combination
    jsr (ManageUIElement,PC)
    nop
    lea     $c(a7), a7
    ; store route index for player d2 in frame temp array at -$c(a6): slot[d2] = d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$c(a6, d1.w)
    ; d3 = saved route index for player d2
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    ; $28 = 40 decimal: maximum route slot count; >= 40 means slot is invalid/empty
    cmpi.w  #$28, d3
    bcc.b   l_1f8f4
    ; compute byte offset into route_slots for (player=d2, slot=d3): player*$320 + slot*$14
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    ; $FF9A2A = route_slots + $0A; read status_flags byte for this route slot
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    ; test bit 1 of status_flags: SUSPENDED flag -- skip suspended routes
    andi.l  #$2, d0
    bne.b   l_1f8f4
    ; look up trade-value table at $FFB4E8: player stride $140, slot stride $8
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E8,a0
    ; if trade value word is zero this slot has no active trade, count it as invalid
    tst.w   (a0,d0.w)
    bne.b   l_1f8ea
    ; no active trade: increment d7 (count of players without active trades)
    addq.w  #$1, d7
    bra.b   l_1f8f4
l_1f8ea:
    ; active trade found: mark route index as $FF (sentinel = "use negotiation-power path")
    move.w  d2, d0
    add.w   d0, d0
    move.w  #$ff, -$c(a6, d0.w)
l_1f8f4:
    ; advance to next player
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f87a
    ; d7 <= 1: only 0 or 1 active trades -- skip revenue-weighting pass, go straight to negotiation
    cmpi.w  #$1, d7
    bls.w   l_1fa6c
    ; --- Phase: Pass 2 -- compute per-player revenue contribution scaled by trade share ---
    ; d6 = total weighted revenue accumulator across all 4 players
    moveq   #$0,d6
    ; reset player counter d2 for second pass
    clr.w   d2
    ; a3 -> $FF1004 player-data table; stride $1C per player
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a2 -> $FFB4E4 trade-value table; stride $140 per player
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_1f92e:
    ; reload saved route index for player d2
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    ; skip players with invalid/empty route (d3 >= 40)
    cmpi.w  #$28, d3
    bcc.w   l_1fa58
    ; locate route slot: route_slots[player=d2][slot=d3]
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    ; a4 -> route slot record for this player/slot
    movea.l a0, a4
    ; compute trade-table pointer for (player=d2, slot=d3): a2 + d3*8
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a2,d0.l), a0
    ; save trade-table pointer in frame temp
    move.l  a0, -$10(a6)
    ; check route status_flags (+$0A) bit 1 (SUSPENDED): skip suspended routes
    move.b  $a(a4), d0
    andi.l  #$2, d0
    bne.w   l_1fa58
    ; compute ticket_price / 100 to get fare fraction; route_slot+$04 = ticket_price (word)
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    ; SignedDiv: d0 = ticket_price / 100 (fare as % of base)
    jsr SignedDiv
    ; clamp: if fare fraction >= 1 use it; if < 1 force minimum of 1
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1f99a
    ; fare fraction > 1: push actual value
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    bra.b   l_1f9a0
l_1f99a:
    ; fare fraction <= 1: push minimum value of 1
    move.l  #$1, -(a7)
l_1f9a0:
    ; --- sub-phase: compute weighted revenue from a3 player-data table ---
    ; read first city index from trade-table entry, use as key into a3 pointer table
    movea.l -$10(a6), a0
    move.w  (a0), d0
    andi.l  #$ffff, d0
    ; multiply city index * 4 for longword table lookup
    lsl.l   #$2, d0
    movea.l d0, a0
    ; load revenue component A for city[0] from a3 table
    move.l  (a3,a0.l), d0
    movea.l -$10(a6), a0
    ; read second city index from trade-table entry
    move.w  $2(a0), d1
    andi.l  #$ffff, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    ; add revenue component B for city[1]; d0 = combined city-pair revenue weight
    add.l   (a3,a0.l), d0
    ; load route gross_revenue (+$08 equivalent) from trade-table slot+$6 offset
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$3, d1
    movea.l d1, a0
    ; $6(a2,a0) = gross revenue field for this slot in the trade-value table
    move.w  $6(a2, a0.l), d1
    andi.l  #$ffff, d1
    ; Multiply32: d0 = combined_city_revenue * gross_revenue
    jsr Multiply32
    ; pop fare-fraction divisor, divide: d0 = (city_rev * gross_rev) / fare_fraction
    move.l  (a7)+, d1
    jsr UnsignedDivide
    ; divide by $64 = 100 to normalize to percentage scale
    moveq   #$64,d1
    jsr UnsignedDivide
    ; store per-player revenue contribution in frame array at -$20(a6)[d2]
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    ; scale by per-player stat byte from char_stat_subtab[$FF0120] (a5 advances each player)
    moveq   #$0,d1
    move.b  (a5), d1
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    ; Multiply32: d0 = revenue_contribution * player_stat_factor
    jsr Multiply32
    move.l  d0, (a0)
    exg     d0, a1
    ; re-load updated value, divide by $A = 10 (normalize stat scale to 0-10 range)
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a0)
    exg     d0, a1
    ; clamp per-player contribution: minimum value is 1 (avoid zero-weight player)
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$1,d1
    cmp.l   d0, d1
    bcc.b   l_1fa44
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    bra.b   l_1fa46
l_1fa44:
    ; contribution was zero or negative; force to 1
    moveq   #$1,d0
l_1fa46:
    ; store clamped contribution back
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    ; accumulate into d6: total revenue weight across all players
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    add.l   d0, d6
l_1fa58:
    ; advance a5 (char_stat_subtab pointer) by 4 bytes to next player entry
    addq.l  #$4, a5
    ; advance a2 (trade-value table) by $140 (player stride)
    lea     $140(a2), a2
    ; advance a3 (player-data table) by $1C (player stride)
    moveq   #$1C,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f92e
; --- Phase: Pass 3 -- compute negotiation power, scale per-player contributions, write palette ---
l_1fa6c:
    ; call CalcNegotiationPower(char=d5, city=$a(a6)) -> negotiation-power word in d0
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    ; CalcNegotiationPower: computes character's bargaining leverage from stats + compatibility
    jsr CalcNegotiationPower
    addq.l  #$8, a7
    ; save negotiation-power result in frame at -$22(a6)
    move.w  d0, -$22(a6)
    ; reset player counter for palette-write pass
    clr.w   d2
l_1fa88:
    ; reload route index for player d2
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    ; skip invalid slots (>= 40)
    cmpi.w  #$28, d3
    bcc.w   l_1fb48
    ; compute route_slots offset: player*$320 + slot*$14
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    ; read status_flags from $FF9A2A (route_slots + $0A)
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    ; bit 1 = SUSPENDED: zero d4 (no palette contribution) and skip
    andi.l  #$2, d0
    bne.b   l_1fae4
    ; determine palette weight d4 based on active-trade-count d7
    cmpi.w  #$1, d7
    ; d7 <= 1: only one active trade, use raw negotiation power directly
    bls.b   l_1fade
    ; d7 > 1: multiple active trades, weight this player's share proportionally
    ; d4 = (revenue_contribution[d2] * negotiation_power) / total_revenue_d6
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$0,d1
    move.w  -$22(a6), d1
    jsr Multiply32
    move.l  d6, d1
    ; UnsignedDivide: d0 = (contribution * negpower) / total
    jsr UnsignedDivide
    move.w  d0, d4
    bra.b   l_1fae6
l_1fade:
    ; single active trade: d4 = raw negotiation power (no proportional weighting)
    move.w  -$22(a6), d4
    bra.b   l_1fae6
l_1fae4:
    ; suspended route: palette weight is zero
    clr.w   d4
l_1fae6:
    ; look up base-palette value for (player=d2, slot=d3) from $FFB4EA table
    ; $FFB4EA is $FFB4E8 + 2 (second word of trade-value entry)
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    ; d0 = base palette value word for this player/slot
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    ; Multiply32: d0 = base_palette_value * negotiation_weight_d4
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    ; divide by $64 = 100 to scale back to 0-100 percent range
    moveq   #$64,d1
    jsr UnsignedDivide
    ; d4 = final scaled palette contribution for this player/slot
    move.w  d0, d4
    ; call ValidateTradeReq(route=d3, player=d2) -> trade validity factor in d0
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; ValidateTradeReq: verifies trade prerequisites and returns a multiplier (0 or 1)
    jsr (ValidateTradeReq,PC)
    nop
    ; multiply palette contribution by trade-validity factor (zeroes out invalid trades)
    mulu.w  d4, d0
    move.w  d0, d4
    ; call UpdateUIPalette(weight=d4, route=d3, player=d2) -> writes final colour value
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    ; UpdateUIPalette: commits colour/intensity value into player's UI palette entry
    jsr (UpdateUIPalette,PC)
    nop
    lea     $14(a7), a7
l_1fb48:
    ; advance to next player
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fa88
; --- Phase: Outer-loop increment and termination ---
l_1fb52:
    ; advance outer loop: next city slot
    addq.w  #$1, d5
    ; reload city-range descriptor pointer; byte[1] = count, byte[0] = base offset in range
    movea.l -$4(a6), a0
    move.b  $1(a0), d0
    andi.l  #$ff, d0
    movea.l -$4(a6), a0
    move.b  (a0), d1
    andi.l  #$ff, d1
    ; d0 = base + count = one-past-end city index for this range
    add.l   d1, d0
    moveq   #$0,d1
    ; d1 = current city slot counter d5
    move.w  d5, d1
    ; loop while d5 < (base + count), i.e. while still within this city range
    cmp.l   d1, d0
    bgt.w   l_1f866
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
