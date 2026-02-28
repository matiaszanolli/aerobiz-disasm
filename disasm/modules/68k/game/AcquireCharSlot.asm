; ============================================================================
; AcquireCharSlot -- Adjusts char slot value by compatibility offset; updates char base stat if relation score exceeds threshold
; 218 bytes | $032CA0-$032D79
; ============================================================================
; --- Phase: Setup -- save registers, load arguments, resolve route slot pointer ---
; Args (stdcall layout, no link frame -- arguments above saved registers on stack):
;   $1c(a7) = player index (d3)
;   $20(a7) = route slot index (d6)
;   $24(a7) = input compatibility offset / adjustment value (d2)
;
; Purpose: adjusts ticket_price (+$04) of a route slot by a compatibility-derived offset,
; clamped to ±$32 (±50). Calls CalcRelationScore to check whether the adjusted price
; actually improves the slot's revenue; if so, writes the new price back.
; Returns d0 = 1 if price was updated, 0 if unchanged.
AcquireCharSlot:
    movem.l d2-d6/a2, -(a7)
    ; d2 = input adjustment value (caller-supplied compatibility offset)
    move.l  $24(a7), d2
    ; d3 = player index (0-3)
    move.l  $1c(a7), d3
    ; d6 = route slot index (0-39)
    move.l  $20(a7), d6
    ; compute route_slots byte offset: player * $320 + slot * $14
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    ; a2 -> route slot record (20 bytes)
    movea.l a0, a2
    ; compute compatibility score for city pair (city_a, city_b) in this slot
    ; route slot +$00 = city_a, +$01 = city_b
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    ; CharCodeScore: computes percentage match score (0-100) for two character codes
    jsr CharCodeScore
    ; d5 = compatibility score (0-100) for this city pair
    move.w  d0, d5
    ; --- Phase: Compute compatibility-adjusted delta for ticket price ---
    ; formula: delta = ((ticket_price - compat_score) * 100) / compat_score
    ; route slot +$04 = ticket_price (word)
    move.w  $4(a2), d0
    sub.w   d5, d0
    ext.l   d0
    ; d0 = (ticket_price - compat_score); scale by 100 to get proportion
    moveq   #$64,d1
    ; Multiply32: d0 = (ticket_price - compat_score) * 100
    jsr Multiply32
    move.w  d5, d1
    ext.l   d1
    ; SignedDiv: d0 = scaled_delta / compat_score = proportional price deviation
    jsr SignedDiv
    ; d4 = proportional delta (saved for comparison at end)
    move.w  d0, d4
    ; apply input adjustment: d2 = delta + input_adjustment
    add.w   d2, d0
    move.w  d0, d2
    ; --- Phase: Clamp adjustment to range [-$32, +$32] = [-50, +50] ---
    ; upper clamp: if d2 >= $32 (50), cap at 50
    cmpi.w  #$32, d2
    bge.b   l_32d10
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d12
l_32d10:
    ; clamp to maximum of $32 = 50
    moveq   #$32,d0
l_32d12:
    move.w  d0, d2
    ext.l   d0
    ; lower clamp: if d2 <= -$32 (-50), floor at -50
    moveq   #-$32,d1
    cmp.l   d0, d1
    bge.b   l_32d22
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d24
l_32d22:
    ; clamp to minimum of -$32 = -50
    moveq   #-$32,d0
l_32d24:
    ; d2 = clamped adjustment in range [-50, +50]
    move.w  d0, d2
    ext.l   d0
    ; --- Phase: Check if the clamped adjustment improves relation score ---
    ; call CalcRelationScore(player=d3, slot=d6, adjustment=d2)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    ; CalcRelationScore: evaluates weighted relation value for this player/slot combination
    jsr (CalcRelationScore,PC)
    nop
    lea     $14(a7), a7
    ; compare relation score d0 with current revenue_target (+$06 in route slot)
    ; if score < revenue_target: use d4 (proportional delta only, discard input adjustment)
    cmp.w   $6(a2), d0
    bcc.b   l_32d48
    ; score did not meet revenue target: revert d2 to pure proportional delta (no adjustment)
    move.w  d4, d2
l_32d48:
    ; if adjusted d2 == proportional d4: no net change, nothing to write
    cmp.w   d4, d2
    bne.b   l_32d50
    ; no change: return 0 (slot not updated)
    clr.w   d3
    bra.b   l_32d72
l_32d50:
    ; --- Phase: Apply updated ticket price and write back to route slot ---
    ; new ticket_price = (compat_score * (d2 + 100)) / 100
    ; this maps d2 in [-50,+50] to a price multiplier of [50%, 150%] of compat_score
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    ; d1 = adjustment + $64 (100): shift from [-50,+50] to [50,150] percent range
    addi.l  #$64, d1
    ; Multiply32: d0 = compat_score * (adjustment + 100)
    jsr Multiply32
    ; SignedDiv: d0 = (compat_score * (adj+100)) / 100 -- scaled ticket price
    moveq   #$64,d1
    jsr SignedDiv
    ; write updated ticket_price back to route slot +$04
    move.w  d0, $4(a2)
    ; return 1: slot was updated
    moveq   #$1,d3
l_32d72:
    ; d0 = return value (0 = no change, 1 = price updated)
    move.w  d3, d0
    movem.l (a7)+, d2-d6/a2
    rts

CalcRelationScore:                                                  ; $032D7A
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d2
    move.l  $002c(sp),d3
    move.l  $0030(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d3,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    move.w  d0,d2
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    bge.b   .l32e54
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$8,sp
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    moveq   #$0,d1
    move.w  (a4),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    moveq   #$0,d1
    move.w  (a3),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.w  (a3),d1
    moveq   #$0,d2
    move.w  (a4),d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    bra.w   .l32eda
.l32e54:                                                ; $032E54
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a4),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    moveq   #$0,d2
    move.b  $0001(a4),d2
    andi.l  #$ffff,d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l32eda:                                                ; $032EDA
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$70dc                           ; jsr $0070DC
    addq.l  #$8,sp
    move.w  d0,d3
    move.w  $0004(a2),d0
    sub.w   d3,d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d2,d0
    move.w  d4,d1
    ext.l   d1
    sub.l   d1,d0
    addi.l  #$32,d0
    moveq   #$0,d1
    move.w  $0008(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    move.w  d5,d6
    ext.l   d6
    sub.l   d6,d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l32f7c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l32fa2
.l32f7c:                                                ; $032F7C
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l32fa2:                                                ; $032FA2
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    move.w  d4,d1
    ext.l   d1
    addi.l  #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  #$2710,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    movem.l (sp)+,d2-d6/a2-a5
    rts
DegradeSkillLinked:                                          ; $032FEC
    dc.w    $4E56,$0000                                      ; link a6,#0 [falls through to DegradeCharSkill]
; === Translated block $032FF0-$0332DE ===
; 2 functions, 750 bytes
