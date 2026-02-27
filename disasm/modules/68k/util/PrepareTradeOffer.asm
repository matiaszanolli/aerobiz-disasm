; ============================================================================
; PrepareTradeOffer -- Iterate a player's route slots, compute per-slot revenue via CalcCharProfit, and accumulate totals into the player record financial fields.
; 310 bytes | $0205B8-$0206ED
;
; Args: $18(a7) = player_index (longword, passed by value)
;
; Performs a quarter-start revenue pass for one player:
;   1. Archives previous-quarter accumulators into the player record.
;   2. Clears current-quarter accumulators.
;   3. For each active route slot: computes actual_revenue, calls CalcCharProfit
;      for the expected revenue (revenue_target), and accumulates both.
;   4. Applies net result to player cash: cash += quarter_accum_a - quarter_accum_b.
;
; Register map during slot loop:
;   D2 = slot index (0 .. d4-1)
;   D4 = total active slot count (domestic_slots + intl_slots from player record)
;   A2 = current route slot ptr (route_slots base + player*$320 + slot*$14)
;   A3 = player record ptr ($FF0018 + player*$24)
; ============================================================================
PrepareTradeOffer:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2                ; d2 = player_index

; --- Phase: Locate player record and initialize slot count ---
    move.w  d2, d0
    mulu.w  #$24, d0                   ; offset = player_index * $24 (36 bytes/record)
    movea.l  #$00FF0018,a0             ; player_records base ($FF0018)
    lea     (a0,d0.w), a0              ; a0 -> this player's record
    movea.l a0, a3                     ; a3 = player record ptr (kept for accumulator writes)
    moveq   #$0,d4
    move.b  $4(a3), d4                 ; d4 = domestic_slots count (+$04)
    moveq   #$0,d0
    move.b  $5(a3), d0                 ; d0 = intl_slots count (+$05)
    add.w   d0, d4                     ; d4 = total active slots (loop limit)

; --- Phase: Archive previous-quarter accumulators ---
    ; Copy current values to prev_accum fields before zeroing.
    move.l  $a(a3), $16(a3)            ; prev_accum_a = quarter_accum_a (+$0A -> +$16)
    move.l  $e(a3), $1a(a3)            ; prev_accum_b = quarter_accum_b (+$0E -> +$1A)
    move.l  $12(a3), $1e(a3)           ; prev_accum_c = quarter_accum_c (+$12 -> +$1E)

; --- Phase: Clear current-quarter accumulators ---
    clr.l   $a(a3)                     ; quarter_accum_a = 0 (revenue accumulator)
    clr.l   $e(a3)                     ; quarter_accum_b = 0 (expense/target accumulator)
    clr.l   $12(a3)                    ; quarter_accum_c = 0 (gross revenue accumulator)

; --- Phase: Locate route slot array for this player ---
    move.w  d2, d0
    mulu.w  #$320, d0                  ; offset = player_index * $320 (800 bytes/player)
    movea.l  #$00FF9A20,a0             ; route_slots base ($FF9A20)
    lea     (a0,d0.w), a0              ; a0 -> this player's route slot block
    movea.l a0, a2                     ; a2 = walking slot ptr (stride $14 per slot)
    clr.w   d2                         ; d2 = slot index (starts at 0)
    bra.w   l_206d2                    ; -> check loop condition first

; --- Phase: Per-slot revenue computation loop ---
l_20616:
    ; Clear bits 0 and 2 of status_flags (+$0A): reset PENDING_UPDATE ($01) and
    ; the lower busy bit ($04); preserves SUSPENDED ($02) and ESTABLISHED ($04).
    ; Mask $FA = %11111010 clears bits 0 and 2.
    andi.b  #$fa, $a(a2)               ; status_flags &= ~($01|$04): clear pending/busy bits
    move.b  $a(a2), d0
    andi.l  #$2, d0                    ; test SUSPENDED bit ($02) of status_flags
    bne.w   l_206c4                    ; suspended -> skip revenue calculation

; --- Compute actual_revenue = (gross_revenue * 3 * 4 * ticket_price) / 10000 ---
    ; Formula: actual_revenue = gross_revenue * 12 * ticket_price / 10000
    ; The *12 is encoded as: d0 = gross*2 + gross = gross*3, then lsl #2 = *4 -> *12 total.
    moveq   #$0,d0
    move.w  $8(a2), d0                 ; d0 = gross_revenue (+$08)
    move.l  d0, d1
    add.l   d0, d0                     ; d0 = gross*2
    add.l   d1, d0                     ; d0 = gross*3
    lsl.l   #$2, d0                    ; d0 = gross*12 (multiply by 3*4)
    moveq   #$0,d1
    move.w  $4(a2), d1                 ; d1 = ticket_price (+$04)
    jsr Multiply32                     ; d0 = gross*12 * ticket_price
    move.l  #$2710, d1                 ; d1 = 10000 ($2710) -- fixed-point divisor
    jsr SignedDiv                      ; d0 = (gross*12 * ticket_price) / 10000
    move.w  d0, $e(a2)                 ; actual_revenue (+$0E) = result

; --- Call CalcCharProfit to compute revenue_target for this slot ---
    ; Args pushed right-to-left: city_a, city_b, plane_type, frequency
    moveq   #$0,d0
    move.b  $3(a2), d0                 ; d0 = frequency (+$03, low nibble)
    andi.l  #$ffff, d0
    move.l  d0, -(a7)                  ; arg4 = frequency (zero-extended)
    move.l  a2, -(a7)                  ; arg3 = slot ptr (for GetByteField4 plane lookup)
    jsr GetByteField4                  ; extracts plane_type field from packed nibbles (+$02)
    addq.l  #$4, a7                    ; pop slot ptr (frequency arg stays)
    andi.l  #$ffff, d0                 ; zero-extend plane_type byte
    move.l  d0, -(a7)                  ; arg3 = plane_type
    moveq   #$0,d0
    move.b  $1(a2), d0                 ; d0 = city_b (+$01)
    andi.l  #$ffff, d0
    move.l  d0, -(a7)                  ; arg2 = city_b
    moveq   #$0,d0
    move.b  (a2), d0                   ; d0 = city_a (+$00)
    andi.l  #$ffff, d0
    move.l  d0, -(a7)                  ; arg1 = city_a
    jsr (CalcCharProfit,PC)            ; d0 = revenue_target for this route slot
    nop
    lea     $10(a7), a7                ; pop 4 args (frequency + 3 from above = 16 bytes)
    move.w  d0, $6(a2)                 ; revenue_target (+$06) = CalcCharProfit result

; --- Accumulate into player record ---
    moveq   #$0,d0
    move.w  $e(a2), d0                 ; d0 = actual_revenue (+$0E)
    add.l   d0, $a(a3)                 ; quarter_accum_a += actual_revenue
    moveq   #$0,d0
    move.w  $6(a2), d0                 ; d0 = revenue_target (+$06)
    add.l   d0, $e(a3)                 ; quarter_accum_b += revenue_target

    ; quarter_accum_c += gross_revenue * 12 (scaled for GDP calculation)
    moveq   #$0,d3
    move.w  $8(a2), d3                 ; d3 = gross_revenue (+$08)
    move.l  d3, d0
    add.l   d3, d3                     ; d3 = gross*2
    add.l   d0, d3                     ; d3 = gross*3
    lsl.l   #$2, d3                    ; d3 = gross*12
    add.l   d3, $12(a3)                ; quarter_accum_c += gross*12
    bra.b   l_206cc

; --- Suspended slot: zero out revenue fields ---
l_206c4:
    clr.w   $e(a2)                     ; actual_revenue = 0 (suspended route earns nothing)
    clr.w   $6(a2)                     ; revenue_target = 0

; --- Advance to next slot ---
l_206cc:
    moveq   #$14,d0
    adda.l  d0, a2                     ; a2 += $14 (next route slot, stride 20 bytes)
    addq.w  #$1, d2                    ; slot_index++
l_206d2:
    cmp.w   d4, d2
    bcs.w   l_20616                    ; loop while slot_index < total_slots

; --- Phase: Apply net revenue to player cash ---
    ; cash = cash - quarter_accum_b (expenses/targets) + quarter_accum_a (actual revenue)
    move.l  $e(a3), d0
    sub.l   d0, $6(a3)                 ; cash (-= quarter_accum_b: deduct expenses)
    move.l  $a(a3), d0
    add.l   d0, $6(a3)                 ; cash (+= quarter_accum_a: add actual revenue)
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ---------------------------------------------------------------------------
; CalcCharProfit -- Compute expected route revenue_target for one route slot.
; $0206EE
;
; Args (on stack, all longwords):
;   $20(sp) = city_a       (source city index, 0-88)
;   $24(sp) = stat_type    (char stat index, 0-88; maps into char_stat_tab at $FF1298)
;   $28(sp) = city_b       (destination city index, 0-88)
;   $2C(sp) = plane_type   (aircraft type index, indexes into $FF0728 lookup)
;
; Returns: d0.w = revenue_target
;
; Register map:
;   D2 = stat_type (char stat index)
;   D3 = city_b
;   D4 = city_a
;   D5 = international route bonus term (asr.l #6 of city_a stat product)
;   D6 = domestic/alternative route bonus term (asr.l #6)
;   A2 = char descriptor entry ptr ($FFA6B8 + plane_type*$C; stride-$C char stat structs)
;   A3 = stat descriptor ptr ($FF1298 + stat_type*4; char_stat_tab entry)
;
; Algorithm sketch:
;   1. Load plane stat from $FFA6B8 (char type descriptor, +$01 = primary stat).
;   2. Multiply plane stat by city popularity (city_b entry at $FFBA80).
;   3. Scale by aircraft lookup byte from $FF0728 (plane_type*2).
;   4. Compute route-category bonus (domestic vs. international; $20 threshold).
;   5. Call CharCodeCompare ($006F42) to get compatibility score for (stat_type, city_a).
;   6. Blend char slot stat (+$02 of A2), compatibility score, and frequency scalar.
;   7. Apply game-turn scaling: (frame_counter/3 + $1E) as time-ramp factor.
;   8. Clamp result to minimum 1.
; ---------------------------------------------------------------------------
CalcCharProfit:                                                  ; $0206EE
    movem.l d2-d6/a2-a3,-(sp)
    move.l  $0024(sp),d2               ; d2 = stat_type (char stat index 0-88)
    move.l  $002c(sp),d3               ; d3 = city_b (destination city)
    move.l  $0020(sp),d4               ; d4 = city_a (source city)
    move.l  $0028(sp),d5               ; d5 = plane_type (aircraft type index)

; --- Phase: Locate char descriptor and stat descriptor ---
    move.w  d5,d0
    mulu.w  #$c,d0                     ; offset = plane_type * $C (12 bytes per entry)
    movea.l #$00ffa6b8,a0              ; $FFA6B8: char type/skill descriptor table (stride $C)
    lea     (a0,d0.w),a0               ; a0 -> descriptor for this plane_type
    movea.l a0,a2                      ; a2 = char descriptor ptr

    move.w  d2,d0
    lsl.w   #$2,d0                     ; offset = stat_type * 4 (4 bytes per descriptor)
    movea.l #$00ff1298,a0              ; char_stat_tab ($FF1298): 89 stat descriptors
    lea     (a0,d0.w),a0               ; a0 -> descriptor for this stat_type
    movea.l a0,a3                      ; a3 = stat descriptor ptr (+$03 = scale param)

; --- Phase: Compute initial popularity product (city_b side) ---
    ; Product = plane_stat * city_b_popularity * aircraft_factor
    ; plane_stat = char descriptor +$01 (primary skill/rating byte)
    ; city_b_popularity = city_data[$FFBA80] byte at city_b * 8 + player_index*2
    ; aircraft_factor = lookup byte from $FF0728 at plane_type * 2
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; d0 = plane_stat (+$01: primary skill)
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1                      ; d1 = city_b index
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- multiply d0 by city_b popularity
    move.w  d4,d1
    add.w   d1,d1                      ; d1 = plane_type * 2 (byte index into $FF0728)
    movea.l #$00ff0728,a0              ; $FF0728: per-aircraft-type lookup table (stride 2)
    move.b  (a0,d1.w),d1              ; d1 = aircraft lookup factor for this plane_type
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- multiply by aircraft factor
    move.l  d0,d5
    asr.l   #$6,d5                     ; d5 = scaled city_b product >> 6 (international bonus)

; --- Phase: Route category branch (domestic < $20, international >= $20) ---
    cmpi.w  #$20,d2                    ; stat_type < $20 = domestic route; >= $20 = international
    bcs.b   .l207aa                    ; domestic path

; --- International path: compute stat descriptor scale factor ---
    ; Uses char_stat_tab[stat_type]+$03 (scale param) clamped to $0C maximum.
    moveq   #$0,d0
    move.b  $0003(a3),d0               ; d0 = stat descriptor scale param (+$03)
    andi.l  #$ffff,d0
    moveq   #$c,d1                     ; d1 = $C (cap / modulus for international routes)
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- compute scaled factor (modulo/clamp)
    tst.l   d0
    ble.b   .l2078e                    ; scale factor <= 0: push 0 bonus
    moveq   #$0,d0
    move.b  $0003(a3),d0               ; reload scale param
    andi.l  #$ffff,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- recompute (positive: use real value)
    move.l  d0,-(sp)                   ; push international scale factor onto stack
    bra.b   .l20790
.l2078e:                                                ; $02078E
    clr.l   -(sp)                      ; push 0: scale factor clamped to zero
.l20790:                                                ; $020790
    ; Continue international path: city_a popularity product with saved scale factor
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; d0 = plane_stat (+$01)
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1                      ; d1 = city_b (used again for second multiply)
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- plane_stat * city_b popularity
    move.l  (sp)+,d1                   ; d1 = international scale factor (popped from stack)
    bra.b   .l207d4

.l207aa:                                                ; $0207AA -- domestic path
    ; Domestic: use plane_stat * city_b popularity * per-stat aircraft factor
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; d0 = plane_stat (+$01)
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  d3,d1                      ; d1 = city_b
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- plane_stat * city_b popularity
    move.w  d2,d1
    add.w   d1,d1                      ; d1 = stat_type * 2 (index into $FF0728 for domestic)
    movea.l #$00ff0728,a0              ; $FF0728: per-stat-type aircraft factor lookup
    move.b  (a0,d1.w),d1              ; d1 = domestic aircraft factor
    andi.l  #$ff,d1
    ; fall through to shared multiply

.l207d4:                                                ; $0207D4
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- final multiply (plane*pop*factor)
    move.l  d0,d6
    asr.l   #$6,d6                     ; d6 = domestic/alt bonus term >> 6

; --- Phase: Compatibility score lookup ---
    ; CharCodeCompare ($006F42): returns compatibility score for (stat_type, city_a) pair.
    ; Dispatches to CharCompat_Cat0-6 tables based on stat_type category.
    moveq   #$0,d0
    move.w  d2,d0                      ; d0 = stat_type
    move.l  d0,-(sp)                   ; arg2 = stat_type
    moveq   #$0,d0
    move.w  d4,d0                      ; d0 = city_a
    move.l  d0,-(sp)                   ; arg1 = city_a
    dc.w    $4eb9,$0000,$6f42          ; jsr CharCodeCompare ($006F42): d0 = compat score
    addq.l  #$8,sp
    move.w  d0,d2                      ; d2 = compatibility score (reuses stat_type reg)

; --- Phase: Blend slot stat, compatibility score, and quality factors ---
    ; Term A: char slot +$02 stat * $32 (50)
    moveq   #$0,d0
    move.w  $0002(a2),d0               ; d0 = char slot secondary stat (+$02)
    moveq   #$32,d1                    ; d1 = $32 = 50
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = slot_stat * 50
    move.l  d0,-(sp)                   ; push term A

    ; Term B: compatibility score * $A (10)
    moveq   #$0,d0
    move.w  d2,d0                      ; d0 = compat score
    moveq   #$a,d1                     ; d1 = $A = 10
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = compat * 10
    add.l   (sp)+,d0                   ; d0 = term_A + term_B (slot_stat*50 + compat*10)
    move.l  d0,-(sp)                   ; push combined term

    ; Term C: slot_stat * $32 * slot_quality_factor
    moveq   #$0,d0
    move.w  $0002(a2),d0               ; d0 = slot secondary stat (+$02)
    moveq   #$32,d1
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = slot_stat * 50
    moveq   #$0,d1
    move.b  $0008(a2),d1               ; d1 = slot quality byte (+$08)
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= quality_factor
    move.l  (sp)+,d1                   ; d1 = combined (term_A + term_B)
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = combined * quality_scaled
    moveq   #$0,d1
    move.b  $0008(a2),d1               ; d1 = quality byte (add back directly)
    add.w   d1,d0
    move.w  d0,d4                      ; d4 = blended quality/compat product

; --- Phase: Apply stat_scale factor ($FF1294) and final frequency scaling ---
    ; Compute: compat*10 * (stat_scale + $32) * blended_product * city_b
    moveq   #$0,d0
    move.w  d2,d0                      ; d0 = compat score
    moveq   #$a,d1                     ; * 10
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A
    move.w  ($00FF1294).l,d1           ; d1 = stat_scale ($FF1294: global stat scaling factor)
    ext.l   d1
    addi.l  #$32,d1                    ; d1 += $32 (50): base bias for stat scaling
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= (stat_scale + 50)
    moveq   #$0,d1
    move.w  d4,d1                      ; d1 = blended quality product
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= blended_quality
    moveq   #$0,d1
    move.w  d3,d1                      ; d1 = city_b index
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= city_b factor
    lsr.l   #$1,d0                     ; halve to normalize scale
    move.l  d0,d2
    move.l  #$2710,d1                  ; d1 = 10000 -- normalize to percentage base
    dc.w    $4eb9,$0003,$e0c6          ; jsr $03E0C6 -- d0 = d2 / 10000 (scaled division)
    add.w   d5,d0                      ; add international bonus term (d5 = city_b scaled >> 6)
    add.w   d6,d0                      ; add domestic/alt bonus term (d6 = domestic >> 6)
    move.w  d0,d2                      ; d2 = pre-ramp revenue estimate

; --- Phase: Game-turn time ramp ---
    ; Scale by (frame_counter / 3 + $1E): revenue grows as game progresses.
    ; frame_counter at $FF0006 incremented each main loop tick.
    move.w  ($00FF0006).l,d0           ; d0 = frame_counter ($FF0006)
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = frame_counter / 3
    addi.l  #$1e,d0                    ; d0 += $1E (30): time ramp offset (minimum multiplier)
    moveq   #$0,d1
    move.w  d2,d1                      ; d1 = pre-ramp estimate
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= pre-ramp
    moveq   #$64,d1                    ; d1 = $64 (100): normalize ramp
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 /= 100
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l208e8                    ; result <= 1: clamp to 1

; --- Second pass: repeat time ramp (game progressively increases revenue ceiling) ---
    move.w  ($00FF0006).l,d0           ; re-read frame_counter for second ramp pass
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 = frame_counter / 3
    addi.l  #$1e,d0                    ; + $1E (30)
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c          ; jsr $03E05C -- d0 *= pre-ramp (second pass)
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a          ; jsr $03E08A -- d0 /= 100
    bra.b   .l208ea
.l208e8:                                                ; $0208E8
    moveq   #$1,d0                     ; clamp result to minimum 1
.l208ea:                                                ; $0208EA
    move.w  d0,d2                      ; return value in d2 (caller reads d0.w directly)
    movem.l (sp)+,d2-d6/a2-a3
    rts
; ---------------------------------------------------------------------------
; === Translated block $0208F0-$020A62 ===
; 2 functions, 370 bytes
