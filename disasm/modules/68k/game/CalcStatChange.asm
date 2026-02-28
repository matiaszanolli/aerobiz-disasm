; ============================================================================
; CalcStatChange -- Compute stat point delta for an event type and current value with category-specific scaling limits
; Called: 5 times.
; 456 bytes | $0090F4-$0092BB
;
; Algorithm summary:
;   Given: player_index (stack), event_mode (d2 on entry), current_stat_value (d3 on entry)
;   1. Multiply player_index by 4, use as index into char_stat_subtab ($FF0120).
;   2. Dispatch on d3 (category selector, 0/1/2+):
;      - Category 0: use char_stat_subtab[+1], divisors 5 or 10
;      - Category 1: use char_stat_subtab[+2], divisors 9, arith-shift-right path
;      - Category 2+: use char_stat_subtab[+3], divisor 3 or direct shift
;   3. Within each category, dispatch on d2 (event_mode 0=up, 1=moderate-up, 2=zero,
;      3=small-negative, else=large-negative):
;      - Mode 0: delta = (100 - current_val) / divisor, minimum 1
;      - Mode 1: similar with different divisor
;      - Mode 2: delta = 0
;      - Mode 3: delta = -5 or -10
;      - else:   delta = -20, -30, or -50 depending on category
;   4. Clamp delta so: current_val + delta <= 100  AND  current_val + delta >= 0
; ============================================================================
CalcStatChange:                                                  ; $0090F4
; --- Phase: Setup ---
    movem.l d2-d3/a2,-(sp)              ; save d2 (event_mode), d3 (category), a2
    move.l  $0018(sp),d2                ; d2 = event_mode (arg3, 0-based mode selector)
    move.l  $0014(sp),d3                ; d3 = category selector (0 = route, 1 = char, 2+ = other)
    move.w  $0012(sp),d0                ; d0 = player_index
    lsl.w   #$2,d0                      ; d0 *= 4 (stride into char_stat_subtab, 4 bytes/player)
    movea.l #$00ff0120,a0               ; a0 = char_stat_subtab base ($FF0120, 16-byte array)
    lea     (a0,d0.w),a0                ; a0 -> player's 4-byte entry in char_stat_subtab
    movea.l a0,a2                       ; a2 = working pointer to player's stat sub-entry

; --- Phase: Category Dispatch (d3 selects field and scaling) ---
    tst.w   d3                          ; test category selector
    bne.w   .l91a0                      ; d3 != 0 -> category 1 or 2+
    ; --- Category 0: use sub-entry byte +1 as base stat ---
    moveq   #$0,d3
    move.b  $0001(a2),d3                ; d3 = char_stat_subtab[player*4 + 1] (base stat value)
    tst.w   d2                          ; test event_mode
    bne.b   .l9156                      ; mode != 0 -> check other modes

; --- Category 0, Mode 0: delta = max(1, (100 - base) / 5) ---
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1                     ; d1 = 100 ($64)
    sub.l   d0,d1                       ; d1 = 100 - base_stat
    move.l  d1,d0                       ; d0 = headroom to 100
    moveq   #$5,d1                      ; divisor = 5
    dc.w    $4eb9,$0003,$e08a           ; jsr $03E08A (SignedDiv: d0 / d1 -> d0)
    moveq   #$1,d1
    cmp.l   d0,d1                       ; is result < 1?
    bge.b   .l914e                      ; yes -> clamp to 1
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; recompute (100 - base) for return value
    move.l  d1,d0
    moveq   #$5,d1                      ; divisor = 5
.l9146:                                                 ; $009146
    dc.w    $4eb9,$0003,$e08a           ; jsr $03E08A (SignedDiv: d0 / d1 -> d0)
    bra.b   .l9150                      ; -> store result
.l914e:                                                 ; $00914E
    moveq   #$1,d0                      ; clamp delta to minimum of 1
.l9150:                                                 ; $009150
    move.w  d0,d2                       ; d2 = computed delta
    bra.w   .l926e                      ; -> final clamp and return

; --- Category 0, Mode Dispatch (d2 != 0) ---
.l9156:                                                 ; $009156
    cmpi.w  #$1,d2                      ; mode 1?
    bne.b   .l9182
    ; Mode 1: delta = max(1, (100 - base) / 10)
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; headroom = 100 - base
    move.l  d1,d0
    moveq   #$a,d1                      ; divisor = 10 (larger mode -> smaller delta)
    dc.w    $4eb9,$0003,$e08a           ; jsr $03E08A (SignedDiv)
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e                      ; clamp to 1
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$a,d1                      ; divisor = 10
    bra.b   .l9146

.l9182:                                                 ; $009182
    cmpi.w  #$2,d2                      ; mode 2 = no change
    bne.b   .l918e
.l9188:                                                 ; $009188
    clr.w   d2                          ; delta = 0
    bra.w   .l926e

.l918e:                                                 ; $00918E
    cmpi.w  #$3,d2                      ; mode 3 = small penalty
    bne.b   .l919a
    moveq   #-$5,d2                     ; delta = -5
    bra.w   .l926e

.l919a:                                                 ; $00919A
    moveq   #-$14,d2                    ; mode 4+ -> delta = -20 ($-14)
    bra.w   .l926e

; --- Category 1 dispatch (d3 was 1 on entry) ---
.l91a0:                                                 ; $0091A0
    cmpi.w  #$1,d3                      ; is category exactly 1?
    bne.b   .l9220                      ; no -> category 2+
    moveq   #$0,d3
    move.b  $0002(a2),d3                ; d3 = char_stat_subtab[player*4 + 2] (secondary stat)
    tst.w   d2                          ; test mode
    bne.b   .l91da                      ; mode != 0

; --- Category 1, Mode 0: delta = (100 - base) >> 2 (arithmetic shift), min 1 ---
.l91b0:                                                 ; $0091B0
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; headroom = 100 - base
    move.l  d1,d0
    bge.b   .l91be                      ; headroom >= 0?
    addq.l  #$3,d0                      ; round up before ASR (bias +3 for negative values)
.l91be:                                                 ; $0091BE
    asr.l   #$2,d0                      ; d0 = headroom / 4 (signed arithmetic shift)
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e                      ; clamp to 1 if result < 1
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; recompute headroom
    move.l  d1,d0
    bge.b   .l91d4
    addq.l  #$3,d0                      ; round-up bias for negative
.l91d4:                                                 ; $0091D4
    asr.l   #$2,d0                      ; d0 = headroom / 4
    bra.w   .l9150

; --- Category 1, Mode != 0 ---
.l91da:                                                 ; $0091DA
    cmpi.w  #$1,d2                      ; mode 1?
    bne.b   .l920a
    ; Mode 1: delta = max(1, (100 - base) / 9)
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1                      ; divisor = 9
    dc.w    $4eb9,$0003,$e08a           ; jsr $03E08A (SignedDiv)
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1
    bra.w   .l9146

.l920a:                                                 ; $00920A
    cmpi.w  #$2,d2                      ; mode 2 = no change
    beq.w   .l9188
    cmpi.w  #$3,d2                      ; mode 3 = moderate penalty
    bne.b   .l921c
    moveq   #-$A,d2                     ; delta = -10 (cat1 mode3 is harsher than cat0)
    bra.b   .l926e
.l921c:                                                 ; $00921C
    moveq   #-$1E,d2                    ; mode 4+ -> delta = -30 ($-1E)
    bra.b   .l926e

; --- Category 2+ dispatch (d3 >= 2) ---
.l9220:                                                 ; $009220
    moveq   #$0,d3
    move.b  $0003(a2),d3                ; d3 = char_stat_subtab[player*4 + 3] (tertiary stat)
    tst.w   d2
    bne.b   .l9254                      ; mode != 0
    ; Mode 0: delta = max(1, (100 - base) / 3)
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; headroom = 100 - base
    move.l  d1,d0
    moveq   #$3,d1                      ; divisor = 3 (widest category, biggest positive delta)
    dc.w    $4eb9,$0003,$e08a           ; jsr $03E08A (SignedDiv)
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$3,d1
    bra.w   .l9146

; --- Category 2+, Mode != 0 ---
.l9254:                                                 ; $009254
    cmpi.w  #$1,d2
    beq.w   .l91b0                      ; mode 1 -> reuse cat1 mode-0 shift path
    cmpi.w  #$2,d2
    beq.w   .l9188                      ; mode 2 -> delta = 0
    cmpi.w  #$3,d2
    beq.w   .l919a                      ; mode 3 -> delta = -20
    moveq   #-$32,d2                    ; mode 4+ -> delta = -50 ($-32, largest penalty)

; --- Phase: Final Clamp (upper bound: current_val + delta <= 100) ---
.l926e:                                                 ; $00926E
    ; Clamp delta so it doesn't push stat above 100
    ; if delta > (100 - current_val): delta = (100 - current_val)
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1                     ; d1 = 100
    sub.l   d0,d1                       ; d1 = 100 - current_val (max positive headroom)
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1                          ; d1 = delta (signed)
    cmp.l   d1,d0                       ; is (100-val) <= delta?
    ble.b   .l9286                      ; yes -> use headroom as upper clamp
    move.w  d2,d0                       ; no -> delta fits, use it
    ext.l   d0
    bra.b   .l9290
.l9286:                                                 ; $009286
    ; delta would push over 100 -> clamp to headroom
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1                       ; clamp = 100 - current_val
    move.l  d1,d0

; --- Phase: Final Clamp (lower bound: current_val + delta >= 0) ---
.l9290:                                                 ; $009290
    ; Also clamp so stat doesn't go below 0:
    ; if delta < -current_val: delta = -current_val
    move.w  d0,d2                       ; d2 = clamped delta so far
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1                       ; d1 = -current_val (max negative headroom)
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1                          ; d1 = delta
    cmp.l   d1,d0                       ; is (-current_val) >= delta? i.e. delta would go negative
    bge.b   .l92aa                      ; yes -> clamp to floor
    move.w  d2,d0                       ; delta doesn't push below 0, use it
    ext.l   d0
    bra.b   .l92b4
.l92aa:                                                 ; $0092AA
    ; delta would push stat below 0 -> clamp to -current_val
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1                       ; clamp = -current_val
    move.l  d1,d0
.l92b4:                                                 ; $0092B4
    move.w  d0,d2                       ; d2 = final clamped delta (return value in d2)
    movem.l (sp)+,d2-d3/a2
    rts
