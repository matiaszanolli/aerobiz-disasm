; ============================================================================
; RunCharManagement -- Runs the full char management screen: initialises the char list, scans for best negotiation and performance candidates, optionally triggers an event, and shows contract or departure dialogs
; Called: ?? times.
; 1638 bytes | $01861A-$018C7F
; ============================================================================
RunCharManagement:                                                  ; $01861A
; --- Phase: Frame setup -- compute player record and financial state ---
; Frame: link a6,#-$bc allocates $BC bytes of locals.
; Key locals:
;   -$0002(a6)  = best_profitable_slot (route slot index with max profit gap)
;   -$00b0(a6)  = resolved_airport_type (RangeLookup result for hub city)
;   -$00b2(a6)  = total_route_slots (domestic_slots + intl_slots)
;   -$00b4(a6)  = contract_event_flag (1 = negotiation dialog triggered)
;   -$00b6(a6)  = perf_event_flag (1 = performance dialog triggered)
;   -$00b8(a6)  = contract_printed_flag (1 = contract already shown)
;   -$00ba(a6)  = is_city_a_flag (1 = best slot's source city was used, else dest)
;   -$00ae(a6)  = local char stats buffer (a5 base for $03B22C call)
    link    a6,#-$bc
    movem.l d2-d7/a2-a5,-(sp)
    lea     $000a(a6),a4               ; a4 = ptr to first arg (player_index word at +$A from frame)
    lea     -$00ae(a6),a5              ; a5 = local work/display buffer for dialog rendering
    move.w  (a4),d0                    ; d0 = player_index
    mulu.w  #$24,d0                    ; player record offset = index * $24 (36 bytes/record)
    movea.l #$00ff0018,a0              ; player_records base ($FF0018)
    lea     (a0,d0.w),a0
    movea.l a0,a3                      ; a3 = this player's record (used for cash checks throughout)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$063e                                 ; jsr $018C80 -- ComputeQuarterResults(player)
    nop
    addq.l  #$4,sp

; --- Phase: Conditional asset update -- apply quarter result if not -1 ---
    move.w  $000e(a6),d0               ; second arg: quarter result flag
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l18660                    ; skip UpdatePlayerAssets if result == -1 (no update needed)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$06ba                                 ; jsr $018D14 -- UpdatePlayerAssets(player)
    nop
    addq.l  #$4,sp
.l18660:                                                ; $018660
; --- Phase: Cash gate -- skip char scan if player is bankrupt ---
    tst.l   $0006(a3)                  ; player_record.cash (+$06) -- can they afford chars?
    ble.w   .l18c3e                    ; no cash: jump to no-char event path

; --- Phase: Init scan state -- clear flags, set sentinel values ---
    clr.w   -$00b4(a6)                ; contract_event_flag = 0
    clr.w   -$00b6(a6)                ; perf_event_flag = 0
    clr.w   -$00b8(a6)                ; contract_printed_flag = 0
    clr.w   -$00ba(a6)                ; is_city_a_flag = 0
    moveq   #$0,d4                     ; d4 = best profit gap (running max)
    move.w  #$ffff,-$0002(a6)         ; best_profitable_slot = -1 (sentinel: none found)
    move.w  #$ffff,-$00b0(a6)         ; resolved_airport_type = -1 (sentinel)

; --- Phase: Resolve hub city type -- look up airport category for player's hub ---
; $FF09C2 byte determines which hub-city table to use:
;   == 0: use $05F9E1 table, entry index = $FF09C3, stride 8
;   == 1: use $05FA11 table, entry index = $FF09C3, stride 4
;   else: skip (no hub type resolution)
    tst.b   ($00FF09C2).l              ; route_field_d type byte
    bne.b   .l186a0
    moveq   #$0,d0
    move.b  ($00FF09C3).l,d0           ; table entry index
    lsl.w   #$3,d0                     ; * 8 (stride for $05F9E1 table)
    movea.l #$0005f9e1,a0             ; hub city type table (route_field_d == 0 variant)
    bra.b   .l186ba
.l186a0:                                                ; $0186A0
    cmpi.b  #$01,($00FF09C2).l
    bne.b   .l186d4                    ; neither 0 nor 1: skip hub type resolution
    moveq   #$0,d0
    move.b  ($00FF09C3).l,d0
    lsl.w   #$2,d0                     ; * 4 (stride for $05FA11 table)
    movea.l #$0005fa11,a0             ; hub city type table (route_field_d == 1 variant)
.l186ba:                                                ; $0186BA
    move.b  (a0,d0.w),d0              ; raw airport type byte
    andi.l  #$ff,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(airport_type) -> category
    addq.l  #$4,sp
    move.w  d0,-$00b0(a6)             ; resolved_airport_type = category result

; --- Phase: Build route slot index -- count total routes and get base pointer ---
.l186d4:                                                ; $0186D4
    moveq   #$0,d0
    move.b  $0004(a3),d0              ; player_record.domestic_slots
    moveq   #$0,d1
    move.b  $0005(a3),d1              ; player_record.intl_slots
    add.w   d1,d0
    move.w  d0,-$00b2(a6)            ; total_route_slots = domestic + intl
    move.w  (a4),d0
    mulu.w  #$0320,d0                  ; player route base offset = index * $320 (40 slots * $14)
    movea.l #$00ff9a20,a0             ; route_slots base ($FF9A20)
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = start of this player's route slot array
    moveq   #$6f,d5                    ; d5 = best service_quality score seen (lower = better; $6F init)
    moveq   #-$1,d7                    ; d7 = best_perf_slot index (-1 = none)
    clr.w   d3                         ; d3 = slot counter
    bra.w   .l187b4                    ; branch to loop condition first

; --- Phase: Route slot scan -- find most profitable gap and lowest quality slot ---
.l18702:                                                ; $018702
; Each route slot is $14 (20) bytes. a2 advances by $14 per iteration.
; Tests two conditions per slot:
;   1. Profitable gap: revenue_target - actual_revenue > current best gap -> update best_profitable_slot
;   2. Low quality: computed service score < d5 -> update best_perf_slot
    move.b  $000a(a2),d0              ; route_slot.status_flags (+$0A)
    andi.l  #$4,d0                     ; bit 2 = ESTABLISHED flag
    bne.w   .l187ae                    ; skip unestablished slots
    move.b  $000a(a2),d0              ; status_flags again
    andi.l  #$2,d0                     ; bit 1 = SUSPENDED flag
    bne.w   .l187ae                    ; skip suspended routes
    moveq   #$0,d0
    move.b  $0001(a2),d0              ; route_slot.city_b (destination city index)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city_b) -> dest category
    addq.l  #$4,sp
    move.l  d0,-(sp)                   ; save dest category
    moveq   #$0,d0
    move.b  (a2),d0                    ; route_slot.city_a (source city index)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city_a) -> src category
    addq.l  #$4,sp
    move.l  (sp)+,d1                   ; d1 = dest category
    cmp.w   d1,d0                      ; src category == dest category?
    bne.b   .l187ae                    ; skip if they differ (cross-category route, not domestic)
    moveq   #$0,d0
    move.b  $0001(a2),d0              ; city_b again (for airport type comparison)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city_b) -> category
    addq.l  #$4,sp
    cmp.w   -$00b0(a6),d0             ; matches resolved hub airport type?
    beq.b   .l187ae                    ; skip if same type as hub (not a candidate)

; --- Profitability gap check ---
    move.w  $000e(a2),d0              ; route_slot.actual_revenue (+$0E)
    cmp.w   $0006(a2),d0              ; actual_revenue vs revenue_target (+$06)
    bcc.b   .l18782                    ; skip if actual >= target (already profitable)
    moveq   #$0,d2
    move.w  $0006(a2),d2             ; d2 = revenue_target
    moveq   #$0,d0
    move.w  $000e(a2),d0             ; d0 = actual_revenue
    sub.l   d0,d2                      ; d2 = profit gap = target - actual
    cmp.l   d2,d4                      ; gap > current best?
    bge.b   .l18782                    ; no -- keep looking
    move.l  d2,d4                      ; new best gap
    move.w  d3,-$0002(a6)            ; best_profitable_slot = current slot index

; --- Service quality score check ---
.l18782:                                                ; $018782
    moveq   #$0,d6
    move.b  $000b(a2),d6             ; d6 = route_slot.service_quality (+$0B)
    moveq   #$0,d2
    move.b  $0003(a2),d2             ; d2 = route_slot.frequency (+$03)
    move.w  d6,d0
    move.l  d0,-(sp)                   ; arg: service_quality
    pea     ($0064).w                  ; arg: 100 (score scale factor)
    move.w  d2,d0
    move.l  d0,-(sp)                   ; arg: frequency
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C -- CalcServiceScore(quality, 100, freq) -> d0
    lea     $000c(sp),sp
    move.w  d0,d2                      ; d2 = computed service score
    cmp.w   d5,d2                      ; score < current best (lower = worse performance)?
    bge.b   .l187ae                    ; not worse -- skip
    move.w  d2,d5                      ; update best (worst) score
    move.w  d3,d7                      ; best_perf_slot = current slot index

.l187ae:                                                ; $0187AE
    moveq   #$14,d0
    adda.l  d0,a2                      ; advance a2 to next route slot ($14 = 20 bytes)
    addq.w  #$1,d3                     ; slot counter++
.l187b4:                                                ; $0187B4
    cmp.w   -$00b2(a6),d3             ; scanned all total_route_slots?
    blt.w   .l18702                    ; no -- continue

; --- Phase: Disambiguate slot indices -- if both slots same, clear perf slot ---
    cmp.w   -$0002(a6),d7             ; best_perf_slot == best_profitable_slot?
    bne.b   .l187c4
    moveq   #-$1,d7                    ; yes -- clear perf slot (avoid acting on same slot twice)
.l187c4:                                                ; $0187C4

; ============================================================================
; --- Phase: Profitable slot processing -- show contract/negotiation dialog ---
; ============================================================================
    move.w  -$0002(a6),d0             ; best_profitable_slot
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l189de                    ; no profitable slot found -- skip to perf slot check

; Load the best profitable route slot into a2
    pea     ($000C).w
    pea     ($00FF).w
    pea     -$000e(a6)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520 -- MemFill(local_buf, $FF, $0C)
    move.w  (a4),d0                    ; player_index
    mulu.w  #$0320,d0                  ; player offset
    move.w  -$0002(a6),d1            ; slot index
    mulu.w  #$14,d1                    ; slot offset = index * $14 (20 bytes/slot)
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = the best profitable route slot

; Determine which city endpoint to use for char lookup
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4 -- GetCityEndpoint(0, 1) -> d0
    tst.l   d0
    bne.b   .l18816                    ; d0 != 0: use city_b (destination)
    moveq   #$0,d3
    move.b  (a2),d3                    ; d3 = route_slot.city_a (source)
    bra.b   .l1881c
.l18816:                                                ; $018816
    moveq   #$0,d3
    move.b  $0001(a2),d3             ; d3 = route_slot.city_b (destination)
.l1881c:                                                ; $01881C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city) -> category
    lea     $0018(sp),sp

; --- Revenue 3x check: if actual*3 > target*2, look up a char for this route ---
; Formula: actual * 3 > target * 2 means route is over-performing relative to target
    moveq   #$0,d0
    move.w  $000e(a2),d0             ; actual_revenue
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0                      ; d0 = actual * 3
    moveq   #$0,d1
    move.w  $0006(a2),d1             ; revenue_target
    add.l   d1,d1                      ; d1 = target * 2
    cmp.l   d1,d0                      ; actual*3 > target*2?
    ble.b   .l1887e                    ; no -- go straight to contract lookup

; Try FindCharByValue first (prefer cheap char)
    clr.l   -(sp)                      ; flag: prefer cheapest
    move.w  d3,d0
    move.l  d0,-(sp)                   ; city endpoint category
    move.w  (a4),d0
    move.l  d0,-(sp)                   ; player_index
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2 -- FindCharByValue(player, city_cat, 0)
    lea     $000c(sp),sp
    move.w  d0,d2                      ; d2 = char candidate (or -1)
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l1887e                    ; no candidate -- fall through to contract path
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E -- CalcCharCost(d2, d3, player)
    lea     $000c(sp),sp
    cmp.l   $0006(a3),d0              ; cost vs player_record.cash (+$06)?
    bls.b   .l18890                    ; affordable -- use this candidate

; Fallback: use FindBestCharacter (no cost filter)
.l1887e:                                                ; $01887E
    move.w  d3,d0
    move.l  d0,-(sp)                   ; city endpoint category
    move.w  (a4),d0
    move.l  d0,-(sp)                   ; player_index
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686 -- FindBestCharacter(player, city_cat)
    addq.l  #$8,sp
    move.w  d0,d2                      ; d2 = char candidate

; --- Phase: Char weight lookup and event dispatch ---
.l18890:                                                ; $018890
    move.w  d2,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l189de                    ; no candidate at all -- skip to perf slot
    move.w  d2,d0
    lsl.w   #$2,d0                     ; char_code * 4
    movea.l #$0005e31d,a0             ; CharWeightTable subrange ($05E31D): weight category per char type
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4                    ; d4 = weight category (0-3: negotiation types; >3: performance only)

; Resolve char to airport type for dialog
    pea     ($FFFFFFFF).w              ; flag: use abs.l form
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; city endpoint category
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city_cat) -> airport type
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2 -- ShowCharIcon(airport_type)
    addq.l  #$8,sp

; Dispatch by weight category:
;   d4 == 1 -> negotiation path A
;   2 <= d4 <= 3 -> negotiation path B/C (d4=3 remapped to 1)
;   else (>3 or 0) -> skip negotiation, check perf score instead
    cmpi.w  #$1,d4
    beq.b   .l1894a                    ; category 1: direct negotiation dialog
    cmpi.w  #$3,d4
    bgt.b   .l1894a                    ; category > 3: go to negotiation (high value)
    cmpi.w  #$3,d4
    bne.b   .l188e0                    ; category 2: use negotiation with type name
    moveq   #$1,d4                     ; remap category 3 -> 1 for NameStringPoolPtrs index

; --- Category 2/3: Negotiation dialog with airline type name ---
.l188e0:                                                ; $0188E0
    move.w  d4,d0
    ext.l   d0
    lsl.l   #$2,d0                     ; d4 * 4 for NameStringPoolPtrs (longword entries)
    movea.l #$0005e296,a0             ; NameStringPoolPtrs ($05E296): 18 longword ptrs
    move.l  (a0,d0.l),-(sp)          ; push ptr to airline type name string
    move.w  d3,d0
    lsl.w   #$2,d0                     ; city_cat * 4 for CityNamePtrs
    movea.l #$0005e680,a0             ; CityNamePtrs ($05E680): city name string ptrs
    move.l  (a0,d0.w),-(sp)          ; push ptr to city name string
    move.w  d2,d0
    lsl.w   #$2,d0                     ; char_code * 4 for char name ptr table
    movea.l #$0005e2a2,a0             ; char name ptrs (within NameStringPoolPtrs region)
    move.l  (a0,d0.w),-(sp)          ; push ptr to char name string
    move.l  ($00047CA4).l,-(sp)      ; ptr to dialog format string at $47CA4
    move.l  a5,-(sp)                   ; local display buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C -- RenderTextBlock(buf, fmt, char, city, type)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4 -- DisplayDialog(0, 3, buf, 0)
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- ShowNegotiationResult(player, result)
    lea     $0024(sp),sp
    move.w  #$1,-$00b4(a6)           ; contract_event_flag = 1 (negotiation shown)
    move.w  #$1,-$00b8(a6)           ; contract_printed_flag = 1
    bra.b   .l1899c

; --- Category 1 and high-value: Shorter negotiation dialog (no type name) ---
.l1894a:                                                ; $01894A
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0             ; char name ptrs
    move.l  (a0,d0.w),-(sp)          ; char name
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0             ; CityNamePtrs
    move.l  (a0,d0.w),-(sp)          ; city name
    move.l  ($00047CA8).l,-(sp)      ; ptr to dialog format string at $47CA8
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C -- RenderTextBlock(buf, fmt, city, char)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4 -- DisplayDialog(0, 3, buf, 0)
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- ShowNegotiationResult(player, result)
    lea     $0020(sp),sp
    move.w  #$1,-$00b4(a6)           ; contract_event_flag = 1

; --- Cash re-check after negotiation: fire perf event if player still wealthy ---
.l1899c:                                                ; $01899C
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E -- CalcCharCost(char, city, player) -> d0
    lea     $000c(sp),sp
    move.l  d0,d2
    add.l   d0,d0
    add.l   d2,d0                      ; d0 = cost * 3 (threshold: is player 3x richer than cost?)
    cmp.l   $0006(a3),d0              ; cost*3 vs player cash
    ble.b   .l189de                    ; affordable -- skip performance event
    clr.l   -(sp)
    move.l  ($00047CC0).l,-(sp)      ; ptr to performance event dialog format at $47CC0
    pea     ($0004).w                  ; dialog type 4
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- ShowNegotiationResult(player, 4, fmt, 0)
    lea     $0010(sp),sp
    move.w  #$1,-$00b6(a6)           ; perf_event_flag = 1

; ============================================================================
; --- Phase: Performance slot processing -- show departure/offer dialog ---
; ============================================================================
.l189de:                                                ; $0189DE
    move.w  d7,d0                      ; best_perf_slot
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c                    ; no perf slot -- skip to epilog
    tst.w   -$00b6(a6)                ; perf_event_flag already set?
    bne.w   .l18c6c                    ; yes -- skip (one event per turn)

; Load the best performance (worst-quality) route slot into a2
    move.w  (a4),d0
    mulu.w  #$0320,d0
    move.w  d7,d1                      ; slot index
    mulu.w  #$14,d1                    ; slot byte offset = index * $14
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2

; Determine city endpoint for this route slot
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4 -- GetCityEndpoint(0, 1) -> d0
    addq.l  #$8,sp
    tst.l   d0
    bne.b   .l18a2a                    ; d0 != 0: use city_b
    moveq   #$0,d3
    move.b  (a2),d3                    ; d3 = route_slot.city_a
    move.w  #$1,-$00ba(a6)           ; is_city_a_flag = 1 (using source city)
    bra.b   .l18a30
.l18a2a:                                                ; $018A2A
    moveq   #$0,d3
    move.b  $0001(a2),d3             ; d3 = route_slot.city_b (destination)

; --- Perf threshold gate: score <= $28 or contract was already printed ---
.l18a30:                                                ; $018A30
    cmpi.w  #$28,d5                    ; best_service_score <= $28 (threshold for poor performance)?
    bgt.b   .l18a3c                    ; score > $28 -- might still trigger if is_city_a set
    tst.w   -$00b8(a6)                ; contract_printed_flag set?
    beq.b   .l18a44                    ; not set -- use FindBestCharacter (simpler lookup)
.l18a3c:                                                ; $018A3C
    cmpi.w  #$1,-$00ba(a6)           ; is_city_a_flag?
    bne.b   .l18a56                    ; not city_a -- use FindCharByValue (prefer cheap)

.l18a44:                                                ; $018A44
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686 -- FindBestCharacter(player, city_cat)
    addq.l  #$8,sp
    bra.b   .l18a6c

.l18a56:                                                ; $018A56
    pea     ($0001).w                  ; prefer-cheapest flag = 1 (find cheapest available)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2 -- FindCharByValue(player, city_cat, 1)
    lea     $000c(sp),sp

.l18a6c:                                                ; $018A6C
    move.w  d0,d2                      ; d2 = candidate char code
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c                    ; no candidate -- skip to epilog

; Resolve weight category for the performance char candidate
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4                    ; d4 = weight category

    pea     ($FFFFFFFF).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city) -> airport type
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2 -- ShowCharIcon(airport_type)
    addq.l  #$8,sp

; Dispatch by weight category for performance dialog:
;   d4 == 1 -> direct performance path
;   d5 <= $28 -> cheaper dialog if score is truly bad
;   else -> rich offer dialog
    cmpi.w  #$1,d4
    beq.b   .l18ab6                    ; category 1: direct offer
    cmpi.w  #$28,d5
    ble.w   .l18bfa                    ; service score <= $28: use cheaper dialog path

; --- Category >= 2 with score > $28: calculate cost and choose dialog ---
.l18ab6:                                                ; $018AB6
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E -- CalcCharCost(char, city, player) -> d0
    lea     $000c(sp),sp
    lsl.l   #$2,d0                     ; cost * 4 (threshold multiplier)
    cmp.l   $0006(a3),d0              ; cost*4 vs player cash
    bge.b   .l18b4c                    ; too expensive relative to cash -- go to fallback

; Player is wealthy enough: show "departure offer" dialog
    cmpi.w  #$1,-$00b4(a6)           ; contract_event_flag set (negotiation already shown)?
    bne.b   .l18b00

; Negotiation was shown: use "enhanced departure" dialog format $4810C0
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)          ; city name
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)          ; char name
    pea     ($000410C0).l             ; dialog format string for enhanced departure
    bra.b   .l18b22

; Negotiation not shown: use "standard departure" dialog format $4810B8
.l18b00:                                                ; $018B00
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)          ; city name
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)          ; char name
    pea     ($000410B8).l             ; dialog format string for standard departure
.l18b22:                                                ; $018B22
    move.l  ($00047CC4).l,-(sp)      ; ptr to dialog header format at $47CC4
.l18b28:                                                ; $018B28
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C -- RenderTextBlock(buf, header, city, char)
    lea     $0014(sp),sp
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4 -- DisplayDialog(0, 3, buf, 0)
    addq.l  #$8,sp
    move.l  d0,-(sp)
    bra.w   .l18c5e

; --- Fallback: char cost too high relative to cash -- try departure via FindBestCharacter ---
.l18b4c:                                                ; $018B4C
    cmpi.w  #$1,-$00ba(a6)           ; is_city_a_flag?
    bne.b   .l18b66
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686 -- FindBestCharacter(player, city_cat)
    addq.l  #$8,sp
    bra.b   .l18b7a

.l18b66:                                                ; $018B66
    clr.l   -(sp)                      ; prefer-cheapest = 0
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2 -- FindCharByValue(player, city_cat, 0)
    lea     $000c(sp),sp

.l18b7a:                                                ; $018B7A
    move.w  d0,d2                      ; fallback candidate
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c                    ; no fallback candidate -- skip to epilog

; Show dialog for fallback candidate
    pea     ($FFFFFFFF).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(city) -> airport type
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2 -- ShowCharIcon
    addq.l  #$8,sp

; Dispatch dialog variant by contract_event_flag
    cmpi.w  #$1,-$00b4(a6)           ; contract already shown?
    bne.b   .l18bce

; Post-contract dialog at $4810B2
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410B2).l             ; dialog format at $4810B2 (post-negotiation departure)
    bra.b   .l18bf0

; No prior contract dialog at $4810AA
.l18bce:                                                ; $018BCE
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410AA).l             ; dialog format at $4810AA (simple departure)
.l18bf0:                                                ; $018BF0
    move.l  ($00047CC8).l,-(sp)      ; ptr to dialog header format at $47CC8
    bra.w   .l18b28                    ; render and display dialog (shared tail)

; --- Category with score <= $28: low-score departure dialog ---
.l18bfa:                                                ; $018BFA
    cmpi.w  #$3,d4
    bgt.b   .l18c6c                    ; category > 3: no dialog for this case
    cmpi.w  #$3,d4
    bne.b   .l18c08
    moveq   #$1,d4                     ; remap category 3 -> 1

.l18c08:                                                ; $018C08
    move.w  d4,d0
    ext.l   d0
    lsl.l   #$2,d0                     ; d4 * 4 for NameStringPoolPtrs
    movea.l #$0005e296,a0             ; NameStringPoolPtrs ($05E296)
    move.l  (a0,d0.l),-(sp)          ; airline type name
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0             ; CityNamePtrs
    move.l  (a0,d0.w),-(sp)          ; city name
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0             ; char name ptrs
    move.l  (a0,d0.w),-(sp)          ; char name
    move.l  ($00047CA4).l,-(sp)      ; dialog format at $47CA4 (low-score departure)
    bra.w   .l18b28                    ; render and display (shared tail)

; ============================================================================
; --- Phase: No-cash path -- show generic event when player has no money ---
; ============================================================================
.l18c3e:                                                ; $018C3E
    move.l  ($00047B78).l,-(sp)      ; ptr to event format string at $47B78
    move.l  ($00047CBC).l,-(sp)      ; ptr to data arg at $47CBC
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C -- RenderTextBlock(buf, fmt, arg)
    lea     $000c(sp),sp
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
.l18c5e:                                                ; $018C5E
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6 -- ShowNegotiationResult(player, result)
    lea     $0010(sp),sp

; ============================================================================
; --- Phase: Epilog -- show char list and return ---
; ============================================================================
.l18c6c:                                                ; $018C6C
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$01ca                           ; jsr $0101CA -- ShowCharManagementList(player)
    movem.l -$00e4(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $018C80-$018EBA ===
; 2 functions, 570 bytes
