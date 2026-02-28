; ============================================================================
; CalcRouteRevenue -- Calculates revenue for one route slot given player and slot indices; looks up demand/capacity data and returns net revenue.
; 174 bytes | $011906-$0119B3
; ============================================================================
; Args (stack, pushed before call):
;   $001C(sp) = player_index (word-sized long)
;   $0020(sp) = slot_index   (word-sized long)
; Returns:
;   d0.w = revenue value * 3 (tripled for caller's use)
CalcRouteRevenue:                                                  ; $011906
    movem.l d2-d6/a2,-(sp)
    ; --- Phase: Load args and compute byte-offset into $FF0338 table ---
    move.l  $001c(sp),d2            ; d2 = player_index
    move.l  $0020(sp),d3            ; d3 = slot_index
    ; player_index * $20 = d5 (row stride = 32 entries)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$5,d0                  ; d0 = player_index * 32
    move.l  d0,d5                   ; d5 = player row offset (preserved)
    ; slot_index * 8 = d4 (column stride = 8 bytes per slot)
    move.w  d3,d1
    ext.l   d1
    lsl.l   #$3,d1                  ; d1 = slot_index * 8
    move.l  d1,d4                   ; d4 = slot column offset (preserved)
    add.w   d1,d0                   ; d0 = player_offset + slot_offset
    movea.l #$00ff0338,a0           ; $FF0338 = unknown 128-byte block (PackSaveState, char display related)
    lea     (a0,d0.w),a0            ; a0 = &$FF0338[player*32 + slot*8]
    movea.l a0,a2                   ; a2 = slot entry pointer
    ; --- Phase: Load city code and check slot type byte ---
    moveq   #$0,d6
    move.b  (a2),d6                 ; d6 = city code from slot (byte at +0)
    cmpi.b  #$03,$0001(a2)          ; is slot type byte < 3? (type byte at +1)
    bcc.b   .l11996                 ; type >= 3 -> skip normal revenue calc
    ; --- Phase: Normal revenue path (type 0, 1, or 2) ---
    ; Call GetModeRowOffset($01AFCA) to get row Y for slot_index
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                ; arg: slot_index
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                ; arg: player_index
    dc.w    $4eb9,$0001,$afca       ; jsr GetModeRowOffset ($01AFCA) -> d0 = row offset
    move.w  d0,d3                   ; d3 = row Y offset (replaces slot_index for next call)
    ; Re-point a2 to same slot entry (d5/d4 offsets reconstructed)
    movea.w d5,a2
    adda.w  d4,a2
    movea.l #$00ff0338,a0
    lea     (a0,a2.w),a2            ; a2 = slot entry (same as before)
    ; Call CalcCharRating($00769C) for this city/player
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)                ; arg: city code (d6)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                ; arg: player_index
    dc.w    $4eb9,$0000,$769c       ; jsr CalcCharRating ($00769C) -> d0 = base rating score
    lea     $0010(sp),sp            ; clean up 4 args
    ; Net revenue formula: (base_rating - slot_cost + row_offset - 1) / row_offset
    move.w  d0,d2                   ; d2 = base rating (CalcCharRating result)
    ext.l   d0
    moveq   #$0,d1
    move.b  $0003(a2),d1            ; d1 = slot cost byte at +3
    sub.l   d1,d0                   ; d0 = base_rating - slot_cost
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0                   ; d0 += row_offset
    subq.l  #$1,d0                  ; d0 -= 1 (bias before division)
    move.w  d3,d1
    ext.l   d1                      ; d1 = divisor (row_offset)
    dc.w    $4eb9,$0003,$e08a       ; jsr SignedDiv ($03E08A): d0 = d0 / d1 (signed 32/32)
    move.w  d0,d2                   ; d2 = net revenue quotient
    bra.b   .l119a8
.l11996:                                                ; $011996
    ; --- Phase: Type >= 3 paths ---
    cmpi.b  #$06,$0001(a2)          ; type == 6?
    bne.b   .l119a6                 ; no -> return 1
    ; Type 6: revenue comes directly from slot byte +3
    moveq   #$0,d2
    move.b  $0003(a2),d2            ; d2 = direct revenue value from slot +3
    bra.b   .l119a8
.l119a6:                                                ; $0119A6
    ; Type 3/4/5 (not 6): default minimum revenue = 1
    moveq   #$1,d2
.l119a8:                                                ; $0119A8
    ; --- Phase: Return -- multiply revenue by 3 (caller expects tripled value) ---
    move.w  d2,d0
    mulu.w  #$3,d0                  ; d0 = revenue * 3
    movem.l (sp)+,d2-d6/a2
    rts
ProcessRouteChange:                                                  ; $0119B4
    movem.l d2-d4/a2-a4,-(sp)
    move.l  $001c(sp),d2
    movea.l $0020(sp),a2
    movea.l #$00ff08ec,a3
    movea.l #$d648,a4
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  (sp)+,d1
    cmp.w   d1,d0
    beq.b   .l11a28
    move.l  a2,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0126                                 ; jsr $011B26
    nop
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0af6                                 ; jsr $012514
    nop
    lea     $0010(sp),sp
    bra.b   .l11a60
.l11a28:                                                ; $011A28
    ori.b   #$80,$000a(a2)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0d7e                                 ; jsr $0127D6
    nop
    lea     $000c(sp),sp
.l11a60:                                                ; $011A60
    move.w  d0,d4
    cmpi.w  #$1,d4
    bne.w   .l11b00
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    clr.l   -(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0017).w
    dc.w    $4eb9,$0000,$5ff6                           ; jsr $005FF6
    lea     $0020(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0003F212).l
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0590                                 ; jsr $012076
    nop
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    lea     $0020(sp),sp
    bra.b   .l11b20
.l11b00:                                                ; $011B00
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  d3,(a3,a0.l)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$12f0                                 ; jsr $012E04
    nop
    addq.l  #$4,sp
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
.l11b20:                                                ; $011B20
    movem.l (sp)+,d2-d4/a2-a4
    rts
; === Translated block $011B26-$011BB2 ===
; 1 functions, 140 bytes
