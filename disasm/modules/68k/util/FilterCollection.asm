; ============================================================================
; FilterCollection -- Updates per-player demand/capacity scores for all 4
; players: computes each player's aggregate demand score (weighted sum of
; char-stat bytes multiplied by economy factors), stores normalized 0-100
; score in char_stat_subtab, then distributes per-city capacity scores
; (clamped 0-50) across 7 city slots in the demand table.
;
; No args. No return value. Modifies RAM in place.
; 314 bytes | $01E854-$01E98D
;
; Outer loop: d5 = player index (0-3)
;   a3 = $FF0120 + player*4  (char_stat_subtab: 4 bytes/player)
;            +0: demand_score (byte, OUTPUT)
;            +1: aircraft_class_A type (byte)
;            +2: aircraft_class_B type (byte)
;            +3: aircraft_param_C     (byte)
;   a4 = $FF01B0 + player*$20 (route_pool_tab: 32 bytes/player)
;            +0..$18: 7 longword city capacity values (one per city)
;            +$1C:    total route capacity (denominator for demand formula)
;   a5 = $FF0230 + player*$10 (demand_tab: 16 bytes/player)
;            +0:  aggregate demand score word (OUTPUT)
;            +2,+4,...+$10: 7 per-city capacity score words (OUTPUT)
; ============================================================================
FilterCollection:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0120,a3             ; a3 = char_stat_subtab base
    movea.l  #$00FF0230,a5             ; a5 = demand_tab base ($FF0230: 4 players * $10 bytes)
    clr.w   d5                         ; d5 = player index = 0

; --- Phase: Per-Player Stride Setup ---
    move.w  d5, d0
    lsl.w   #$5, d0                    ; d0 = player * 32 ($20)
    movea.l  #$00FF01B0,a0             ; route_pool_tab base ($FF01B0: 4 players * $20 bytes)
    lea     (a0,d0.w), a0              ; a0 -> this player's 32-byte route pool block
    movea.l a0, a4                     ; a4 = route_pool_tab[player]

; ==========================================================================
; --- Phase: Demand Score Calculation (per player) ---
; Formula: d2 = (a3+1 * [$FF999C]) + (a3+2 * [$FFBA68]) + (a3+3 * [$FF1288])
; Weighted sum of three aircraft params by economy factor words, then /100.
; $FF999C, $FFBA68, $FF1288 are economy/popularity weight factors (words).
; ==========================================================================
l_1e876:
    moveq   #$0,d2
    move.b  $1(a3), d2                 ; d2 = aircraft_class_A type byte (a3+1)
    mulu.w  ($00FF999C).l, d2          ; weighted by economy factor A ($FF999C)
    moveq   #$0,d0
    move.b  $2(a3), d0                 ; aircraft_class_B type byte (a3+2)
    mulu.w  ($00FFBA68).l, d0          ; weighted by economy factor B ($FFBA68, 24 bytes before city_data)
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0                 ; aircraft_param_C byte (a3+3)
    mulu.w  ($00FF1288).l, d0          ; weighted by economy factor C ($FF1288, 16 bytes before char_stat_tab)
    add.w   d0, d2
    ; Normalize: d2 = d2 / 100 (converts weighted sum to 0-100 score)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1                    ; $64 = 100 (normalization divisor)
    jsr SignedDiv
    move.w  d0, d2                     ; d2 = normalized demand score

; --- Phase: Total Demand Score -> Apply via Capacity Formula ---
    ; Store raw normalized score back into char_stat_subtab byte 0
    move.b  d2, (a3)                   ; char_stat_subtab[player].demand_score = d2

    ; Compute scaled aggregate demand: (a4+$1C / 12) * d2 >> 8
    ; a4+$1C = total route capacity; /12 converts to monthly units; *d2/256 weights by demand
    move.l  $1c(a4), d0               ; route_pool_tab[player]+$1C = total capacity longword
    moveq   #$C,d1                     ; $C = 12 (monthly divisor)
    jsr SignedDiv                      ; d0 = total_capacity / 12
    moveq   #$0,d1
    move.w  d2, d1                     ; d1 = demand score (unsigned word)
    jsr Multiply32                     ; d0 = (total_capacity/12) * demand_score
    move.l  d0, d4
    asr.l   #$8, d4                    ; d4 = result >> 8 (divide by 256 for fixed-point)
    ; Overflow guard: if d4 >= $FFFF, recompute cleanly (avoids spurious saturation)
    cmpi.l  #$ffff, d4                 ; $FFFF = no-overflow sentinel
    bge.b   l_1e8ec                    ; >= $FFFF means the first pass is valid (non-overflow)
    move.l  $1c(a4), d0               ; recompute: same formula (compiler double-path idiom)
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e8f2
l_1e8ec:
    move.l  #$ffff, d4                 ; d4 = $FFFF (saturate at max word value)
l_1e8f2:
    ; Clamp aggregate score to <= 100 ($64)
    cmpi.w  #$64, d4                   ; 100 = max demand score
    bls.b   l_1e8fe                    ; d4 <= 100: use as-is
    moveq   #$0,d0
    move.w  d4, d0                     ; d4 > 100: use unclamped word (demand_tab stores full range)
    bra.b   l_1e900
l_1e8fe:
    moveq   #$64,d0                    ; $64 = 100: clamp to maximum
l_1e900:
    ; Write aggregate demand score word to demand_tab[player]+0
    move.w  d0, (a5)                   ; demand_tab[player].word0 = aggregate demand score

; ==========================================================================
; --- Phase: Per-City Capacity Score Loop (7 cities) ---
; For each of 7 cities (d3 = 0..6):
;   score = (route_pool_tab[player][city*4] / 12) * demand_score >> 8
;   Clamp to <= 50 ($32)
;   Store at demand_tab[player] + 2 + city*2
; ==========================================================================
    clr.w   d3                         ; d3 = city index = 0
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0                    ; d0 = city * 4 (longword stride)
    lea     (a4,d0.l), a0              ; a0 -> route_pool_tab[player][0] (city 0 capacity)
    movea.l a0, a2                     ; a2 = city capacity ptr (advances by 4 each iteration)
l_1e910:
    ; Compute per-city capacity score: (a2 / 12) * d2 >> 8
    move.l  (a2), d0                   ; city capacity longword
    moveq   #$C,d1                     ; 12 (monthly divisor, same as aggregate above)
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1                     ; demand score
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4                    ; >> 8 fixed-point scale
    ; Overflow guard (same compiler double-path as above)
    cmpi.l  #$ffff, d4
    bge.b   l_1e94a                    ; >= $FFFF: first pass valid
    move.l  (a2), d0                   ; recompute
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e950
l_1e94a:
    move.l  #$ffff, d4                 ; saturate
l_1e950:
    ; Clamp per-city score to <= 50 ($32)
    cmpi.w  #$32, d4                   ; $32 = 50 = max per-city capacity score
    bls.b   l_1e95c                    ; d4 <= 50: use as-is
    moveq   #$0,d0
    move.w  d4, d0                     ; d4 > 50: use unclamped
    bra.b   l_1e95e
l_1e95c:
    moveq   #$32,d0                    ; $32 = 50: clamp to maximum
l_1e95e:
    ; Store city score: demand_tab[player] + 2 + city*2
    ; Idiom: a0 = city_index * 2; move.w d0, $2(a5, a0.l)
    moveq   #$0,d1
    move.w  d3, d1                     ; d1 = city index
    add.l   d1, d1                     ; d1 = city * 2 (word offset)
    movea.l d1, a0
    move.w  d0, $2(a5, a0.l)          ; demand_tab[player].words[1+city] = per-city score
    addq.l  #$4, a2                    ; advance to next city's capacity longword
    addq.w  #$1, d3                    ; city++
    cmpi.w  #$7, d3                    ; 7 cities total
    bcs.b   l_1e910                    ; loop until all 7 cities done

; --- Phase: Advance to Next Player ---
    addq.l  #$4, a3                    ; a3 += 4: next player in char_stat_subtab
    moveq   #$10,d0
    adda.l  d0, a5                     ; a5 += $10: next player's 16-byte demand_tab slot
    moveq   #$20,d0
    adda.l  d0, a4                     ; a4 += $20: next player's 32-byte route_pool slot
    addq.w  #$1, d5                    ; player++
    cmpi.w  #$4, d5                    ; 4 players total
    bcs.w   l_1e876                    ; loop until all 4 players done
    movem.l (a7)+, d2-d5/a2-a5
    rts

; ============================================================================
; CalcCityStats -- Computes composite stat scores for a city category and
; stores the top-3 sorted results plus a weighted average into the output
; buffer at $FFBDE4 + city*4.
; 418 bytes | $01E98E-$01EC0D
;
; Args (C-style):
;   $0008(a6) = city_category index    (d5)
;
; Key registers:
;   a4 = $FFBDE4 + category*4   output buffer: top-3 results
;   a3 = $05ECBC + category*4   CharTypeRangeTable entry (4 bytes):
;            byte[0] = range1_base (char_stat_tab start index for group 1)
;            byte[1] = range1_size (count of group-1 descriptors)
;            byte[2] = range2_base (char_stat_tab start index for group 2)
;            byte[3] = range2_size (count of group-2 descriptors)
;   a2 = descriptor ptr: $FF1298 + stat_idx*4  (char_stat_tab, 4 bytes/entry)
;            descriptor byte[1] = primary rating
;            descriptor byte[2] = category param / sort key
;            descriptor byte[3] = secondary value (passed to Multiply32)
;   a5 = -$6(a6): 3-word local sort buffer (top-3 insertion sort working area)
;
; Output at $FFBDE4 + category*4:
;   word[0] = d5 = total stat sum (group-1 + group-2 rating accumulator)
;   byte[2] = d3 = top-3 average rank (insertion sort result averaged)
;   byte[3] = d6 = weighted score average (UnsignedDivide(d6_sum, d5))
; ============================================================================
CalcCityStats:                                                  ; $01E98E
    link    a6,#-$8
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d5               ; d5 = city_category index
    lea     -$0006(a6),a5              ; a5 = top-3 sort buffer (3 words on stack)
    ; Index into output buffer: $FFBDE4 + category*4
    move.w  d5,d0
    lsl.w   #$2,d0                     ; d0 = category * 4
    movea.l #$00ffbde4,a0              ; $FFBDE4 = top-3 result buffer (base)
    lea     (a0,d0.w),a0
    movea.l a0,a4                      ; a4 = output entry ptr for this category
    ; Index into CharTypeRangeTable: $05ECBC + category*4
    move.w  d5,d0
    lsl.w   #$2,d0                     ; d0 = category * 4
    movea.l #$0005ecbc,a0             ; $05ECBC = CharTypeRangeTable (7 entries x 4 bytes)
    lea     (a0,d0.w),a0
    movea.l a0,a3                      ; a3 = CharTypeRangeTable[category]

; --- Phase: Group-1 Stat Accumulation ---
; Iterate char_stat_tab descriptors for range1 [a3+0 .. a3+0+a3+1)
; Accumulate: d5 += descriptor[1] (rating); d6 += Multiply32(descriptor[3], descriptor[1])
    clr.w   d5                         ; d5 = total stat sum accumulator
    moveq   #$0,d6                     ; d6 = weighted score accumulator
    moveq   #$0,d0
    move.b  (a3),d0                    ; d0 = range1_base index
    lsl.w   #$2,d0                     ; * 4 bytes per descriptor
    movea.l #$00ff1298,a0              ; char_stat_tab base ($FF1298: 89 entries x 4 bytes)
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = char_stat_tab[range1_base]
    clr.w   d4                         ; d4 = descriptor index counter
    bra.b   .l1e9f8
.l1e9d8:                                                ; $01E9D8
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; descriptor byte[1] = primary rating
    add.w   d0,d5                      ; d5 += rating (group-1 sum)
    moveq   #$0,d0
    move.b  $0003(a2),d0               ; descriptor byte[3] = secondary value
    moveq   #$0,d1
    move.b  $0001(a2),d1               ; descriptor byte[1] = primary rating (multiplier)
    dc.w    $4eb9,$0003,$e05c          ; jsr Multiply32 ($03E05C): d0 = byte[3] * byte[1]
    add.l   d0,d6                      ; d6 += weighted product
    addq.l  #$4,a2                     ; next descriptor (4 bytes/entry)
    addq.w  #$1,d4                     ; d4 = iteration counter
.l1e9f8:                                                ; $01E9F8
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1               ; range1_size = count of group-1 entries
    cmp.l   d1,d0
    blt.b   .l1e9d8                    ; loop until d4 == range1_size

; --- Phase: Group-1 Normalization (x1.5) ---
; Scale both accumulators by 3/2 (multiply by 3, right shift 1 = x1.5)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,d1
    add.l   d0,d0                      ; d0 = d5 * 2
    add.l   d1,d0                      ; d0 = d5 * 3
    asr.l   #$1,d0                     ; d0 = d5 * 3 / 2 = d5 * 1.5
    move.w  d0,d5
    move.l  d6,d0
    add.l   d0,d0                      ; d6 * 2
    add.l   d6,d0                      ; d6 * 3
    lsr.l   #$1,d0                     ; d6 * 3 / 2 (unsigned, no sign extension)
    move.l  d0,d6                      ; d6 = group-1 weighted sum * 1.5

; --- Phase: Group-2 Stat Accumulation ---
; Range2: [a3+2 .. a3+2+a3+3). Each descriptor checked via $01EC0E (eligibility test).
; Eligible (+pass): apply 1.5x bonus; ineligible: use raw values.
    moveq   #$0,d0
    move.b  $0002(a3),d0               ; range2_base index
    lsl.w   #$2,d0                     ; * 4 bytes per descriptor
    movea.l #$00ff1298,a0              ; char_stat_tab base
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = char_stat_tab[range2_base]
    clr.w   d4                         ; d4 = descriptor counter
    bra.b   .l1eaa2
.l1ea36:                                                ; $01EA36
    ; Eligibility check: jsr $01EC0E(range2_base + d4) -> d0 = 1 if eligible
    moveq   #$0,d0
    move.b  $0002(a3),d0               ; range2_base
    moveq   #$0,d1
    move.w  d4,d1                      ; d4 = current descriptor offset
    add.l   d1,d0                      ; d0 = range2_base + d4 = stat index
    move.l  d0,-(sp)
    dc.w    $4eba,$01c8                ; jsr $01EC0E (eligibility check for this stat)
    nop
    addq.l  #$4,sp
    tst.w   d0                         ; d0 = 0: not eligible; nonzero: eligible
    ble.b   .l1ea82                    ; not eligible: use raw accumulation

    ; Eligible path: apply 1.5x bonus (multiply by 3/2)
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; descriptor byte[1] = primary rating
    andi.l  #$ffff,d0                  ; zero-extend to long
    move.l  d0,d1
    add.l   d0,d0                      ; * 2
    add.l   d1,d0                      ; * 3
    asr.l   #$1,d0                     ; * 3/2 = 1.5x bonus
    add.w   d0,d5                      ; d5 += eligible rating * 1.5
    moveq   #$0,d0
    move.b  $0003(a2),d0               ; descriptor byte[3]
    moveq   #$0,d1
    move.b  $0001(a2),d1               ; descriptor byte[1]
    dc.w    $4eb9,$0003,$e05c          ; jsr Multiply32 ($03E05C)
    move.l  d0,d1
    add.l   d0,d0                      ; * 2
    add.l   d1,d0                      ; * 3
    lsr.l   #$1,d0                     ; * 3/2 = 1.5x bonus
    bra.b   .l1ea9c

.l1ea82:                                                ; $01EA82
    ; Not eligible path: accumulate at base weight (no bonus)
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; descriptor byte[1] = primary rating
    add.w   d0,d5                      ; d5 += rating (unweighted)
    moveq   #$0,d0
    move.b  $0003(a2),d0               ; descriptor byte[3]
    moveq   #$0,d1
    move.b  $0001(a2),d1               ; descriptor byte[1]
    dc.w    $4eb9,$0003,$e05c          ; jsr Multiply32 ($03E05C)
.l1ea9c:                                                ; $01EA9C
    add.l   d0,d6                      ; d6 += weighted product
    addq.l  #$4,a2                     ; next descriptor
    addq.w  #$1,d4
.l1eaa2:                                                ; $01EAA2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1               ; range2_size
    cmp.l   d1,d0
    blt.b   .l1ea36                    ; loop until d4 == range2_size

; --- Phase: Final Weighted Average ---
; d6 = UnsignedDivide(d6_total, d5_total) = weighted average score
    moveq   #$0,d1
    move.w  d5,d1                      ; d1 = total stat sum (divisor)
    move.l  d6,d0                      ; d0 = weighted product sum (dividend)
    dc.w    $4eb9,$0003,$e0c6          ; jsr UnsignedDivide ($03E0C6): d0 = d6/d5
    move.l  d0,d6                      ; d6 = weighted average

; --- Phase: Insertion Sort Top-3 (first sort pass, by range1 category) ---
; Sort descriptors from range1 into top-3 slots at a5 (3 words).
; Inner loop shifts entries up to make room; only keeps top 3 by byte[2] key.
    clr.w   d2                         ; zero top-3 sort buffer (3 words)
.l1eac0:                                                ; $01EAC0
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0                      ; word offset = d2 * 2
    movea.l d0,a0
    clr.w   (a5,a0.l)                  ; a5[d2] = 0
    addq.w  #$1,d2
    cmpi.w  #$3,d2                     ; 3 slots
    blt.b   .l1eac0

    ; Reload range1 descriptors for sort pass
    moveq   #$0,d0
    move.b  (a3),d0                    ; range1_base
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0              ; char_stat_tab base
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = char_stat_tab[range1_base]
    clr.w   d4
    bra.b   .l1eb44
.l1eaea:                                                ; $01EAEA
    ; Insertion sort: try to insert descriptor byte[2] into top-3 buffer (a5)
    clr.w   d2                         ; d2 = insertion position candidate
.l1eaec:                                                ; $01EAEC
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0              ; d0 = current slot value
    moveq   #$0,d1
    move.b  $0002(a2),d1              ; descriptor byte[2] = sort key
    cmp.w   d1,d0                     ; compare slot vs. new entry sort key
    bcc.b   .l1eb38                   ; slot >= new: new entry doesn't belong here

    ; New entry is larger: shift remaining entries up to make room
    moveq   #$2,d3                    ; d3 = top index (3-1=2)
    bra.b   .l1eb20
.l1eb06:                                                ; $01EB06
    ; Shift: a5[d3] = a5[d3-1]  (move entry up one slot)
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0          ; read a5[d3-1]
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)             ; write a5[d3]
    subq.w  #$1,d3                   ; d3--
.l1eb20:                                                ; $01EB20
    cmp.w   d2,d3                    ; stop when d3 == insertion position
    bgt.b   .l1eb06
    ; Insert: a5[d2] = new entry byte[2]
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)             ; a5[insertion_pos] = new sort key
    bra.b   .l1eb40
.l1eb38:                                                ; $01EB38
    addq.w  #$1,d2                   ; advance position to look further down
    cmpi.w  #$3,d2                   ; don't exceed 3 slots
    blt.b   .l1eaec
.l1eb40:                                                ; $01EB40
    addq.l  #$4,a2                   ; next descriptor
    addq.w  #$1,d4
.l1eb44:                                                ; $01EB44
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1             ; range1_size
    cmp.l   d1,d0
    blt.b   .l1eaea                  ; loop until all range1 descriptors sorted

; --- Phase: Insertion Sort Top-3 (second sort pass, by range2 category) ---
; Same insertion sort pattern as above, applied to range2 descriptors.
    moveq   #$0,d0
    move.b  $0002(a3),d0             ; range2_base
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2                    ; a2 = char_stat_tab[range2_base]
    clr.w   d4
    bra.b   .l1ebc4
.l1eb6a:                                                ; $01EB6A
    clr.w   d2
.l1eb6c:                                                ; $01EB6C
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    moveq   #$0,d1
    move.b  $0002(a2),d1             ; sort key for range2 descriptor
    cmp.w   d1,d0
    bcc.b   .l1ebb8
    moveq   #$2,d3
    bra.b   .l1eba0
.l1eb86:                                                ; $01EB86
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0         ; shift a5[d3-1] -> a5[d3]
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    subq.w  #$1,d3
.l1eba0:                                                ; $01EBA0
    cmp.w   d2,d3
    bgt.b   .l1eb86
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    bra.b   .l1ebc0
.l1ebb8:                                                ; $01EBB8
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eb6c
.l1ebc0:                                                ; $01EBC0
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1ebc4:                                                ; $01EBC4
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1             ; range2_size
    cmp.l   d1,d0
    blt.b   .l1eb6a

; --- Phase: Sum Top-3 and Compute Average ---
; d3 = sum of a5[0]+a5[1]+a5[2], then divide by 3 -> top-3 average rank
    clr.w   d3                        ; d3 = sum accumulator
    clr.w   d2
.l1ebd6:                                                ; $01EBD6
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0                    ; word offset = d2 * 2
    movea.l d0,a0
    move.w  (a5,a0.l),d0            ; load top-3 sort slot value
    add.w   d0,d3                    ; accumulate sum
    addq.w  #$1,d2
    cmpi.w  #$3,d2                   ; 3 slots
    blt.b   .l1ebd6

    ; d3 = sum / 3 = average rank of top-3
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$3,d1                   ; divisor = 3
    dc.w    $4eb9,$0003,$e08a        ; jsr SignedDiv ($03E08A): d0 = d3 / 3
    move.w  d0,d3                    ; d3 = top-3 rank average

; --- Phase: Write Output ---
; Output buffer at a4 = $FFBDE4 + category*4 (4 bytes per category)
    move.w  d5,(a4)                  ; word[0] = total stat sum
    move.b  d3,$0002(a4)            ; byte[2] = top-3 average rank
    move.b  d6,$0003(a4)            ; byte[3] = weighted score average
    movem.l -$002c(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $01EC0E-$020000 ===
; 11 functions, 5106 bytes
