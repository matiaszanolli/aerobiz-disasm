; ============================================================================
; CalcCharOutput -- Compute character productivity for a route and time slot using stat descriptors, region params, and scenario scaling
; Called: ?? times.
; 568 bytes | $00969A-$0098D1
; ============================================================================
; Args (stack):
;   $0026(sp) = secondary_slot  (word, read at .l97b0)
;   $0028(sp) = player_index    (d2)
;   $002C(sp) = stat_type/d3    (d3): which stat category (< $20 = use $FF1704, >= $20 = use $FF15A0)
;   $0030(sp) = slot_field      (d4): sub-field offset within stat entry
;   $0034(sp) = output_ptr      (a2): longword result written here
;   $0038(sp) = delta_ptr       (a0): longword delta (result - adjusted) written here
; Returns: outputs written to *a2 and *delta_ptr
;
; Algorithm overview:
;   1. Look up "type index" from a routing table ($FF1704 or $FF15A0) using stat_type + slot_field
;   2. Use type index to look up "action descriptor" in ROM $5E31A table (4 bytes each)
;   3. Use stat_type to look up "char stat descriptor" from char_stat_tab ($FF1298)
;   4. Compute base_value from descriptor type (0=direct, 1=char_stat_subtab, 2=city_value, 3=city_param, 4=composite)
;   5. Apply time-slot and difficulty adjustments
;   6. Multiply through action params and stat_scale, write clamped result to *output_ptr
;   7. Compute delta and write to *delta_ptr
CalcCharOutput:                                                  ; $00969A
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0028(sp),d2            ; d2 = player_index
    move.l  $002c(sp),d3            ; d3 = stat_type (which stat category)
    move.l  $0030(sp),d4            ; d4 = slot_field (sub-index within category)
    movea.l $0034(sp),a2            ; a2 = output longword pointer
    ; --- Phase: Select routing table and compute type index ---
    ; Two tables used depending on stat_type value:
    ;   stat_type < $20: $FF1704 (stride 6, columns indexed by slot_field)
    ;   stat_type >= $20: $FF15A0 (stride 4, columns indexed by slot_field)
    cmpi.w  #$20,d3
    bcc.b   .l96c4                  ; stat_type >= $20 -> use $FF15A0
    ; stat_type < $20: index = stat_type*6 + slot_field
    move.w  d3,d0
    mulu.w  #$6,d0                  ; d0 = stat_type * 6
    add.w   d4,d0                   ; d0 += slot_field
    movea.l #$00ff1704,a0           ; $FF1704 = routing table for stat_type < $20
    bra.b   .l96d0
.l96c4:                                                 ; $0096C4
    ; stat_type >= $20: index = stat_type*4 + slot_field
    move.w  d3,d0
    lsl.w   #$2,d0                  ; d0 = stat_type * 4
    add.w   d4,d0                   ; d0 += slot_field
    movea.l #$00ff15a0,a0           ; $FF15A0 = routing table for stat_type >= $20
.l96d0:                                                 ; $0096D0
    ; d5 = action type index byte from routing table entry
    move.b  (a0,d0.w),d5
    andi.l  #$ff,d5
    ; a4 = ROM action descriptor entry at $5E31A + type_index*4 (4 bytes each)
    move.w  d5,d0
    lsl.w   #$2,d0                  ; d0 = type_index * 4
    movea.l #$0005e31a,a0           ; ROM table: 4-byte action descriptors by type
    lea     (a0,d0.w),a0
    movea.l a0,a4                   ; a4 = action descriptor entry
    ; a3 = char_stat_tab descriptor for stat_type at $FF1298
    move.w  d3,d0
    lsl.w   #$2,d0                  ; d0 = stat_type * 4 (4 bytes per descriptor)
    movea.l #$00ff1298,a0           ; char_stat_tab: 89 descriptors x 4 bytes
    lea     (a0,d0.w),a0
    movea.l a0,a3                   ; a3 = stat descriptor for this stat_type
    ; --- Phase: Compute base_value based on action descriptor type (a4[3]) ---
    tst.b   $0003(a4)               ; a4[3] = computation mode byte
    bne.b   .l9724                  ; nonzero -> use typed computation
    ; Mode 0: base = (descriptor[+2] + descriptor[+3]) / 2 (unsigned average)
    moveq   #$0,d0
    move.b  $0002(a3),d0            ; d0 = char_stat_descriptor[+2]
.l9706:                                                 ; $009706
    andi.l  #$ffff,d0               ; zero-extend
    moveq   #$0,d1
    move.b  $0003(a3),d1            ; d1 = char_stat_descriptor[+3]
    andi.l  #$ffff,d1
.l9718:                                                 ; $009718
    add.l   d1,d0                   ; d0 = val + param
    bge.b   .l971e                  ; non-negative? -> skip sign-rounding fixup
    addq.l  #$1,d0                  ; rounding for negative: +1 before arithmetic shift
.l971e:                                                 ; $00971E
    asr.l   #$1,d0                  ; d0 = (val + param) / 2 (arithmetic signed right shift)
    bra.w   .l97b0                  ; -> apply time adjustments
.l9724:                                                 ; $009724
    ; Mode 1: base from char_stat_subtab ($FF0120) indexed by player_index*4
    cmpi.b  #$01,$0003(a4)
    bne.b   .l9742
    move.w  d2,d0
    lsl.w   #$2,d0                  ; d0 = player_index * 4
    movea.l #$00ff0120,a0           ; char_stat_subtab: byte array, player_index*4 indexed
    move.b  (a0,d0.w),d0            ; d0 = char_stat_subtab[player_index*4]
    andi.l  #$ff,d0
    bra.b   .l9706                  ; -> combine with descriptor[+3] via average
.l9742:                                                 ; $009742
    ; Mode 2: base = (descriptor[+2] + city_value[$FFBA68]) / 2
    cmpi.b  #$02,$0003(a4)
    bne.b   .l9760
    moveq   #$0,d0
    move.b  $0002(a3),d0            ; d0 = char_stat_descriptor[+2]
.l9750:                                                 ; $009750
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  ($00FFBA68).l,d1        ; d1 = city_data[$FFBA68] (city base value word)
    bra.b   .l9718                  ; -> (d0 + city_val) / 2
.l9760:                                                 ; $009760
    ; Mode 3: base = (descriptor[+3] + city_value) / 2
    cmpi.b  #$03,$0003(a4)
    bne.b   .l9770
    moveq   #$0,d0
    move.b  $0003(a3),d0            ; d0 = char_stat_descriptor[+3]
    bra.b   .l9750                  ; -> combine with city_value
.l9770:                                                 ; $009770
    ; Mode 4 (default): composite from char_stat_subtab -- sum[+3] + sum[+2], divide by 3
    move.w  d2,d0
    lsl.w   #$2,d0                  ; d0 = player_index * 4
    movea.l #$00ff0120,a0           ; char_stat_subtab
    lea     (a0,d0.w),a0
    movea.l a0,a5                   ; a5 = &char_stat_subtab[player_index*4]
    moveq   #$0,d0
    move.b  $0003(a3),d0            ; d0 = descriptor[+3] (primary param)
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0003(a5),d1            ; d1 = char_stat_subtab[+3] component
    andi.l  #$ffff,d1
    add.l   d1,d0                   ; accumulate
    moveq   #$0,d1
    move.b  $0002(a5),d1            ; d1 = char_stat_subtab[+2] component
    andi.l  #$ffff,d1
    add.l   d1,d0                   ; d0 = sum of all 3 components
    moveq   #$3,d1                  ; divisor = 3
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv ($03E08A): d0 = sum / 3
.l97b0:                                                 ; $0097B0
    ; --- Phase: Apply time-slot adjustment (modulo-8 time index) ---
    move.w  d0,d2                   ; d2 = base_value from computation above
    ; Compute time_index = (stat_type + secondary_slot + slot_field) mod 8
    moveq   #$0,d0
    move.w  d3,d0                   ; d0 = stat_type
    moveq   #$0,d1
    move.w  $0026(sp),d1            ; d1 = secondary_slot arg
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d4,d1                   ; d1 = slot_field
    add.l   d1,d0                   ; d0 = stat_type + secondary_slot + slot_field
    moveq   #$8,d1                  ; modulus = 8
    dc.w    $4eb9,$0003,$e146       ; jsr SignedMod ($03E146): d0 = d0 mod 8
    move.w  d0,d3                   ; d3 = time_index (0..7)
    ; Map time_index to adjustment factor: if >= 5, mirror around 8 (fold to 0..4)
    cmpi.w  #$5,d3
    blt.b   .l97da                  ; < 5 -> no mirroring
    moveq   #$8,d0
    sub.w   d3,d0                   ; d3 = 8 - time_index (mirror: 5->3, 6->2, 7->1)
    move.w  d0,d3
.l97da:                                                 ; $0097DA
    addq.w  #$8,d3                  ; d3 += 8: shift range to [8..12] (base multiplier level)
    ; --- Phase: Core productivity formula ---
    ; Step 1: result = action_byte0 * base_value
    moveq   #$0,d0
    move.b  (a4),d0                 ; d0 = action_descriptor[0] (scale factor A)
    moveq   #$0,d1
    move.w  d2,d1                   ; d1 = base_value
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = action_A * base_value
    ; Step 2: result *= (descriptor[+1] + $32)  ; $32 = 50 decimal bias
    moveq   #$0,d1
    move.b  $0001(a3),d1            ; d1 = char_stat_descriptor[+1] (skill/rating)
    addi.l  #$32,d1                 ; d1 += 50 (center around 50 rating)
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 *= (skill + 50)
    ; Step 3: result *= time_adjustment (d3: 8..12)
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 *= time_adjustment
    ; Step 4: result /= 100 (normalize)
    moveq   #$64,d1                 ; $64 = 100
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 /= 100
    move.l  d0,(a2)                 ; store intermediate result to *output_ptr
    ; Clamp to minimum 1
    moveq   #$1,d0
    cmp.l   (a2),d0                 ; 1 >= *output_ptr?
    bge.b   .l981a                  ; yes -> *output_ptr already >= 1, use 1 as clamp
    move.l  (a2),d0                 ; d0 = *output_ptr (it's larger than 1, keep it)
    bra.b   .l981c
.l981a:                                                 ; $00981A
    moveq   #$1,d0                  ; clamp: minimum output = 1
.l981c:                                                 ; $00981C
    move.l  d0,(a2)                 ; *output_ptr = max(*output_ptr, 1)
    ; --- Phase: Apply frame_counter randomization factor ---
    ; factor = (frame_counter mod 6) + $46  ; adds slight random variation per frame
    move.w  ($00FF0006).l,d0        ; d0 = frame_counter ($FF0006): incremented each main loop tick
    ext.l   d0
    moveq   #$6,d1
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 = frame_counter / 6
    ; NOTE: SignedDiv returns quotient; we want remainder. This may be intended as mod via repeated calls.
    addi.l  #$46,d0                 ; d0 += $46 = 70 (range: 70..75)
    move.l  (a2),d1                 ; d1 = current result
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = (frame_mod+70) * result
    moveq   #$64,d1                 ; divisor = 100
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 /= 100 (normalize)
    moveq   #$5,d1                  ; divisor = 5
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 /= 5 (further reduce)
    move.l  d0,(a2)                 ; update *output_ptr with randomized result
    ; --- Phase: Apply action[+1] multiplier ---
    moveq   #$0,d0
    move.b  $0001(a4),d0            ; d0 = action_descriptor[1] (scale factor B)
    move.l  (a2),d1                 ; d1 = current result
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = action_B * result
    moveq   #$a,d1                  ; divisor = 10
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 /= 10
    ; --- Phase: Apply stat_scale ($FF1294) adjustment ---
    ; stat_scale = scenario difficulty modifier; formula: (0x82 - stat_scale) as factor
    move.w  ($00FF1294).l,d1        ; d1 = stat_scale ($FF1294): ranges ~50-100, events may set to 100
    ext.l   d1
    move.l  #$82,d2                 ; d2 = $82 = 130 (base)
    sub.l   d1,d2                   ; d2 = 130 - stat_scale (higher scale = less reduction)
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 *= (130 - stat_scale)
    moveq   #$64,d1                 ; divisor = 100
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv: d0 /= 100 (normalize percent)
    move.l  d0,d2                   ; d2 = scaled result after stat_scale adjustment
    ; --- Phase: Final time-adjustment multiplication ---
    ; Adjust by (time_index - 9) factor, halved
    move.w  d3,d0
    ext.l   d0
    subi.l  #$9,d0                  ; d0 = time_index - 9 (range: -1..3)
    move.l  d2,d1                   ; d1 = d2 (scaled result)
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = result * (time_idx-9)
    ; Arithmetic right shift with signed rounding
    tst.l   d0
    bge.b   .l989e                  ; non-negative -> skip sign fixup
    addq.l  #$1,d0                  ; rounding for negative: +1 before shift
.l989e:                                                 ; $00989E
    asr.l   #$1,d0                  ; d0 /= 2 (arithmetic)
    ; d2 = d0 * 5 (d0 * 4 + d0)
    move.l  d0,d1
    lsl.l   #$2,d0                  ; d0 = val * 4
    add.l   d1,d0                   ; d0 = val * 5
    move.l  d0,d2                   ; d2 = time-adjusted factor
    ; --- Phase: Compute and write final output + delta ---
    ; half_result = *output_ptr / 2 (arithmetic, with rounding)
    move.l  (a2),d0                 ; d0 = *output_ptr
    bge.b   .l98ae                  ; non-negative?
    addq.l  #$1,d0                  ; rounding for negative
.l98ae:                                                 ; $0098AE
    asr.l   #$1,d0                  ; d0 = half_result
    ; final = min(half_result, d2)
    cmp.l   d2,d0                   ; half_result <= d2?
    ble.b   .l98b8                  ; yes -> use half_result
    move.l  d2,d0                   ; d0 = d2 (time factor is smaller, use it as cap)
    bra.b   .l98c0
.l98b8:                                                 ; $0098B8
    ; half_result > d2: use *output_ptr / 2 (recompute with rounding)
    move.l  (a2),d0
    bge.b   .l98be
    addq.l  #$1,d0
.l98be:                                                 ; $0098BE
    asr.l   #$1,d0                  ; d0 = half of *output_ptr (again, for final)
.l98c0:                                                 ; $0098C0
    move.l  d0,d2                   ; d2 = final_value (capped half-result)
    ; delta = *output_ptr - final_value
    move.l  (a2),d0                 ; d0 = original full result
    sub.l   d2,d0                   ; d0 = delta (full - half-capped)
    movea.l $0038(sp),a0            ; a0 = delta_ptr (arg)
    move.l  d0,(a0)                 ; *delta_ptr = delta
    movem.l (sp)+,d2-d5/a2-a5
    rts
