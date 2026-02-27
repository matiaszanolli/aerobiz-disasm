; ============================================================================
; ShowAnnualReport -- Displays the annual financial report for a player: determines best rival airline, most profitable route, and special conditions (bankruptcy, competition), then formats and shows the corresponding summary dialog
; Called: ?? times.
; 1298 bytes | $02BDB8-$02C2C9
; ============================================================================
; Register usage throughout:
;   d4 = player index (arg $08(a6))
;   d7 = count of active licensed routes for this player (routes where $FF0270 entry==1 and $FF0130 entry nonzero)
;   d3 = slot index (0-6) in outer scan loop
;   d2 = rival player index in inner scan loop
;   d5 = rival player index of best competitor found (-1 if none)
;   d6 = best rival player (licensee) found in inner loop (-1 if none)
;   a2 = player record ptr ($FF0018 + player*$24)
;   a3 = report string buffer (stack frame at -$A6(a6), $A6 bytes)
;   a4 = report display function ($0001183A)
;   a5 = base of ROM dialog/data pointer table ($0004843C)
; Stack frame locals:
;   -$0002(a6) = aircraft_region (RangeLookup result for player's hub_city)
;   -$0004(a6) = win_threshold (quarter+4, capped at 7)
;   -$0006(a6) = best route slot index (d3 at time of best-route discovery)
;   -$00a6(a6) = base of report string buffer (170 bytes)
;   -$00a8(a6) = rival player with active license on same slot
;   -$00aa(a6) = flag: rival-with-license found (0=no, 1=yes)
;   -$00ac(a6) = bankruptcy/year-boundary flag (0=no, 1=yes)
;   -$00b0(a6) = best route revenue accumulator (highest seen so far)
ShowAnnualReport:                                                  ; $02BDB8
    link    a6,#-$b0
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4                ; d4 = player index (0-3)
    lea     -$00a6(a6),a3               ; a3 = report string buffer (170-byte stack area)
    movea.l #$0001183a,a4               ; a4 = report display/format function
    movea.l #$0004843c,a5               ; a5 = ROM dialog pointer table (base for a5+offset ptrs)

; --- Phase: guard -- only run on the "correct" frame ---
; Computes the expected frame_counter value for annual report:
;   expected = month_counter * (16 - 1) * 4 + 1 = month_counter * 60 + 1
; If frame_counter != expected, skip the entire report (not the right moment).
    move.w  ($00FF0002).l,d0            ; d0 = month_counter ($FF0002)
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$4,d0                      ; d0 = month * 16
    sub.l   d1,d0                       ; d0 = month * 15
    lsl.l   #$2,d0                      ; d0 = month * 60
    addq.l  #$1,d0                      ; d0 = month * 60 + 1 (expected frame)
    move.w  ($00FF0006).l,d1            ; d1 = frame_counter
    ext.l   d1
    cmp.l   d1,d0                       ; frame_counter == expected?
    beq.w   .l2c2c0                     ; not the right frame -- skip to exit

; --- Phase: initialize report state ---
    clr.w   -$00ac(a6)                  ; bankruptcy_flag = 0
    clr.w   -$00aa(a6)                  ; rival_license_flag = 0
    clr.w   d7                          ; d7 = active-route count for this player

; Locate player record
    move.w  d4,d0
    mulu.w  #$24,d0                     ; player * $24 (36 bytes per record)
    movea.l #$00ff0018,a0               ; player_records base
    lea     (a0,d0.w),a0
    movea.l a0,a2                       ; a2 = player record ptr

; Resolve player's hub city to aircraft region category
    moveq   #$0,d0
    move.b  $0001(a2),d0                ; player_record.hub_city
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: city code
    dc.w    $4eb9,$0000,$d648           ; jsr $00D648  -- RangeLookup: city -> region (0-6)
    addq.l  #$4,sp
    move.w  d0,-$0002(a6)              ; save aircraft_region = RangeLookup(hub_city)

; --- Phase: scan all rivals for licensing on the best slot ---
; For each rival (d2 != d4), check if they have an active license (type=1) on the
; player's current best route. Uses $FF0270 (8 bytes per player × 4 players = relation matrix)
; and $FF0130 (32-byte franchise/license block per player × slot).
    clr.w   d2                          ; d2 = rival player index (0-3)
.l2be28:                                                ; $02BE28
    cmp.w   d4,d2                       ; skip self
    beq.b   .l2be6c
    move.w  d2,d0
    lsl.w   #$3,d0                      ; rival * 8
    add.w   -$0002(a6),d0              ; + aircraft_region (= player's region index)
    movea.l #$00ff0270,a0              ; $FF0270 = relation matrix (4 players × 8 bytes)
    move.b  (a0,d0.w),d0              ; relation byte at [rival][player_region]
    andi.l  #$ff,d0
    cmpi.w  #$1,d0                      ; relation type == 1 (active license)?
    bne.b   .l2be6c                     ; no license
    move.w  d2,d0
    lsl.w   #$5,d0                      ; rival * $20 (32 bytes per player)
    move.w  -$0002(a6),d1
    lsl.w   #$2,d1                      ; aircraft_region * 4
    add.w   d1,d0
    movea.l #$00ff0130,a0              ; $FF0130 = franchise/license block (4 × 32 bytes)
    tst.l   (a0,d0.w)                   ; license entry nonzero?
    beq.b   .l2be6c                     ; empty
    move.w  #$1,-$00aa(a6)             ; rival_license_flag = 1 (competitor found)
    move.w  d2,-$00a8(a6)              ; rival_license_player = d2
.l2be6c:                                                ; $02BE6C
    addq.w  #$1,d2
    cmpi.w  #$4,d2                      ; checked all 4 players?
    blt.b   .l2be28

; --- Phase: compute win threshold for this quarter ---
; win_threshold = min(quarter + 4, 7)
    move.w  ($00FF0004).l,d0            ; d0 = quarter (0-3)
    addq.w  #$4,d0                      ; threshold base = quarter + 4 (range 4-7)
    move.w  d0,-$0004(a6)
    cmpi.w  #$7,-$0004(a6)
    bge.b   .l2be90                     ; already at max (7)
    move.w  -$0004(a6),d0
    ext.l   d0
    bra.b   .l2be92
.l2be90:                                                ; $02BE90
    moveq   #$7,d0                      ; cap at 7
.l2be92:                                                ; $02BE92
    move.w  d0,-$0004(a6)              ; win_threshold stored

; --- Phase: scan 7 route slots -- count active licensed routes and find competitors ---
; For each slot d3 (0-6):
;   1. Call BitFieldSearch ($006EEA) to check if this slot has a year-boundary marker
;   2. Check $FF0270[player][d3] == 1 AND $FF0130[player][d3] nonzero -> count in d7
;   3. If not self-licensed, scan rivals for the first competitor on this slot
    moveq   #-$1,d5                     ; d5 = best rival player index (-1 = none found)
    clr.w   d3                          ; d3 = slot index (0-6)
.l2be9a:                                                ; $02BE9A
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: slot index
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: player index
    dc.w    $4eb9,$0000,$6eea           ; jsr $006EEA  -- BitFieldSearch: check year boundary
    addq.l  #$8,sp
    cmpi.w  #$ff,d0                     ; returned $FF -> year boundary marker
    bne.b   .l2beba
    move.w  #$1,-$00ac(a6)             ; bankruptcy_flag = 1 (year boundary / insolvency)

.l2beba:                                                ; $02BEBA
; Check if THIS player has an active license on slot d3
    move.w  d4,d0
    lsl.w   #$3,d0                      ; player * 8
    add.w   d3,d0                       ; + slot index
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0              ; $FF0270[player][slot] = relation type
    andi.l  #$ff,d0
    cmpi.w  #$1,d0                      ; active license?
    bne.b   .l2bef0                     ; no -> check rivals instead
    move.w  d4,d0
    lsl.w   #$5,d0                      ; player * $20
    move.w  d3,d1
    lsl.w   #$2,d1                      ; slot * 4
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)                   ; license block nonzero?
    beq.b   .l2bef0                     ; empty
    addq.w  #$1,d7                      ; increment active-route count
    bra.b   .l2bf38                     ; done with this slot

.l2bef0:                                                ; $02BEF0
; Player has no license on slot d3 -- scan rivals for competitor
    move.w  d3,-$0006(a6)              ; save this slot index as candidate best_route_slot
    clr.w   d2                          ; d2 = rival index (0-3)
.l2bef6:                                                ; $02BEF6
    cmp.w   d4,d2                       ; skip self
    beq.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$3,d0
    add.w   d3,d0                       ; [rival][slot]
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0                      ; rival has license on this slot?
    bne.b   .l2bf30
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    movea.l #$00ff0130,a0
    tst.l   (a0,d0.w)                   ; rival's license block nonzero?
    beq.b   .l2bf30
    move.w  d2,d5                       ; d5 = first competitor found on this slot
    bra.b   .l2bf38
.l2bf30:                                                ; $02BF30
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2bef6
.l2bf38:                                                ; $02BF38
    addq.w  #$1,d3
    cmpi.w  #$7,d3                      ; scanned all 7 slots?
    blt.w   .l2be9a

; --- Phase: check profitability -- dispatch to appropriate report variant ---
; $0074F8 returns an income/solvency score for the player. d2 > 0 = solvent; <= 0 = insolvent.
    moveq   #$0,d0
    move.b  $0001(a2),d0                ; player_record.hub_city
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$74f8           ; jsr $0074F8  -- CalcPlayerWealth: d0 = solvency score
    addq.l  #$8,sp
    move.w  d0,d2                       ; d2 = solvency (0 = broke, >0 = solvent)
    tst.w   d2
    bgt.b   .l2bfae                     ; solvent -> check for license-competition report

; --- Report variant: player is bankrupt / insolvent ---
; Show "no revenue" report with default city string
    dc.w    $4eba,$0368                ; jsr $02C2CA  -- clear/init report buffer
    nop
    move.w  -$0002(a6),d0              ; aircraft_region
    lsl.w   #$2,d0                      ; region * 4 (longword index)
    movea.l #$0005ec84,a0              ; RegionNamePtrs ($05EC84): 14 region name ptrs
    move.l  (a0,d0.w),-(sp)            ; arg: region name string ptr
    move.l  $0024(a5),-(sp)            ; a5+$24 = ROM dialog ptr [9] (bankruptcy msg template)
    move.l  a3,-(sp)                   ; arg: report buffer
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C  -- format report string
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)                   ; arg: formatted report buffer
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                   ; arg: player index
    jsr     (a4)                        ; display report (a4 = $0001183A)
    move.l  $0028(a5),-(sp)            ; a5+$28 = ROM dialog ptr [10] (second msg)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C
    lea     $002c(sp),sp
    bra.w   .l2c2aa

; --- Report variant: rival has license on player's best route ---
.l2bfae:                                                ; $02BFAE
    cmpi.w  #$1,-$00aa(a6)             ; rival_license_flag set?
    bne.w   .l2c048                     ; no -> try next variant
    move.w  d7,d0                       ; d7 = active-route count
    ext.l   d0
    move.w  -$0004(a6),d1              ; win_threshold
    ext.l   d1
    subq.l  #$1,d1                      ; threshold - 1
    cmp.l   d1,d0                       ; active_routes < win_threshold - 1?
    blt.w   .l2c2c0                     ; not enough routes -> skip to exit

; Show "competitor licensed on your route" report
    dc.w    $4eba,$02fe                ; jsr $02C2CA  -- init report buffer
    nop
    move.w  -$0002(a6),d0              ; aircraft_region
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0              ; RegionNamePtrs
    move.l  (a0,d0.w),-(sp)            ; arg: player's region name
    move.w  -$00a8(a6),d0              ; rival_license_player index
    lsl.w   #$4,d0                      ; rival * $10 (16 bytes per entry in $FF00A8)
    movea.l #$00ff00a8,a0             ; $FF00A8 = unknown 64-byte block (4 × $10 bytes)
    pea     (a0,d0.w)                   ; arg: rival's record at $FF00A8[rival]
    move.l  ($0004843C).l,-(sp)        ; ROM indirect ptr at $4843C (competitor msg template)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C  -- format report
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)                        ; display first part of competitor report
    lea     $0028(sp),sp
    move.w  -$00a8(a6),d0             ; rival_license_player
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    move.l  $0004(a5),-(sp)            ; a5+$4 = ROM dialog ptr [1] (follow-up msg)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    bra.w   .l2c2b2

; --- Report variant: active routes == win_threshold - 1 (near-win or route milestone) ---
.l2c048:                                                ; $02C048
    move.w  d7,d0                       ; active-route count
    ext.l   d0
    move.w  -$0004(a6),d1              ; win_threshold
    ext.l   d1
    subq.l  #$1,d1                      ; threshold - 1
    cmp.l   d1,d0                       ; active_routes == threshold - 1?
    bne.w   .l2c114                     ; no -> try next variant
    dc.w    $4eba,$026e                ; jsr $02C2CA  -- init report buffer
    nop
    cmpi.w  #$3,($00FF0004).l          ; quarter < 3 (not final quarter)?
    bge.b   .l2c0ac                     ; final quarter -> use competitor route msg
; Early quarters: show "opening soon" style msg ($42ECE = generic expansion string)
    pea     ($00042ECE).l              ; ROM string: generic expansion text
    move.l  $0008(a5),-(sp)            ; a5+$8 = ROM dialog ptr [2] (milestone msg A)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)                        ; display milestone report
    lea     $0024(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $000c(a5),-(sp)            ; a5+$C = ROM dialog ptr [3] (follow-up)
    bra.w   .l2c2b8

; Final quarter with routes near-win: show competitor's route region name
.l2c0ac:                                                ; $02C0AC
    move.w  -$0006(a6),d0              ; best_route_slot (last slot scanned without license)
    lsl.w   #$2,d0                      ; slot * 4
    movea.l #$0005ec84,a0              ; RegionNamePtrs
    move.l  (a0,d0.w),-(sp)            ; arg: route slot's region name
    move.l  $0008(a5),-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w
    move.l  a3,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)                        ; display report
    lea     $0024(sp),sp
    move.w  d5,d0                       ; d5 = competitor player (-1 if none)
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l2c2c0                     ; no competitor found -> exit
    move.w  -$0006(a6),d0             ; best_route_slot
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0                       ; competitor player index
    lsl.w   #$4,d0                      ; competitor * $10
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)                   ; arg: competitor's $FF00A8 record
    move.l  $0010(a5),-(sp)            ; a5+$10 = ROM dialog ptr [4] (competitor route msg)
    bra.w   .l2c29e                    ; -> join common report-display path

; --- Report variant: active routes == win_threshold (route count matches threshold exactly) ---
.l2c114:                                                ; $02C114
    cmp.w   -$0004(a6),d7             ; active_routes == win_threshold?
    bne.w   .l2c2c0                    ; no -> skip to exit
    cmpi.w  #$1,-$00ac(a6)            ; bankruptcy_flag set?
    bne.b   .l2c140                    ; no -> show standard annual milestone report
    dc.w    $4eba,$01a4               ; jsr $02C2CA  -- init report buffer
    nop
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $0014(a5),-(sp)           ; a5+$14 = ROM dialog ptr [5] (year-end/bankruptcy msg)
    bra.w   .l2c2b8

; --- Report variant: standard annual milestone -- find best route by revenue ---
; Scans all 7 route slots to find which route generated the most revenue.
; Compares: (d5 * 10) vs opponent_revenue to find best competitor reference.
.l2c140:                                                ; $02C140
    dc.w    $4eba,$0188               ; jsr $02C2CA  -- init report buffer
    nop
; Compute frame_counter mod 4 for random-feeling dialog variant selection
    move.w  ($00FF0006).l,d0           ; d0 = frame_counter
    ext.l   d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146           ; jsr $03E146  -- d0 = frame_counter mod 4
    move.w  d0,d2                      ; d2 = variant selector (0-3)
    tst.w   d2
    bne.b   .l2c170
; Variant 0: generic "great year" msg
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  $001c(a5),-(sp)           ; a5+$1C = ROM dialog ptr [7] (generic annual msg)
    bra.b   .l2c1a0
.l2c170:                                                ; $02C170
; Variant 1-3: "year #N" messages keyed by (5 - variant) * 3 offset into dialog table
    move.w  d2,d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0,d1                      ; d1 = 5 - variant
    move.l  d1,d0
    add.l   d0,d0                      ; d0 = (5 - variant) * 2
    add.l   d1,d0                      ; d0 = (5 - variant) * 3  [stride into msg table]
    move.l  d0,-(sp)                   ; arg: index offset
    move.l  $0018(a5),-(sp)           ; a5+$18 = ROM dialog ptr [6] (year-N msg base)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0003,$b22c           ; jsr $03B22C  -- format "year N" message
    lea     $000c(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0004).w
    move.l  a3,-(sp)
.l2c1a0:                                                ; $02C1A0
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)                        ; display annual msg
    lea     $0018(sp),sp

; --- Phase: find most profitable route for this player ---
; Scans $FF0130[player][d3] and $FF0270[player][d3] for each of 7 slots.
; For slot d3 where player has license (type=1) and entry is nonzero,
; look up the competitor (type=2) and compare revenues using the $03E05C multiply.
    clr.l   -$00b0(a6)                ; best_revenue_so_far = 0
    moveq   #-$1,d7                   ; d7 = slot index of best route (-1 = none yet)
    clr.w   d3                        ; d3 = slot index (0-6)
.l2c1b4:                                                ; $02C1B4
    move.w  d4,d0
    lsl.w   #$5,d0                    ; player * $20
    move.w  d3,d1
    lsl.w   #$2,d1                    ; slot * 4
    add.w   d1,d0
    movea.l #$00ff0130,a0             ; $FF0130 = franchise/license block (4 players × $20 each)
    move.l  (a0,d0.w),d5             ; d5 = license value for this player/slot
    tst.l   d5
    beq.w   .l2c26a                   ; zero -> slot unused, skip

    move.w  d4,d0
    lsl.w   #$3,d0
    add.w   d3,d0
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$1,d0                    ; player license type == 1?
    bne.w   .l2c26a                   ; not active license -> skip

; Find the competitor (type=2) on this slot from any rival
    moveq   #-$1,d6                   ; d6 = competitor player index (-1 if none)
    clr.w   d2
.l2c1f0:                                                ; $02C1F0
    move.w  d2,d0
    lsl.w   #$3,d0                    ; rival * 8
    add.w   d3,d0                     ; + slot
    movea.l #$00ff0270,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmpi.w  #$2,d0                    ; rival relation type == 2 (competitor)?
    bne.b   .l2c210
    move.w  d2,d6                     ; found competitor at player d2
    bra.b   .l2c218
.l2c210:                                                ; $02C210
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l2c1f0
.l2c218:                                                ; $02C218
; Load competitor's license value (or 0 if no competitor)
    move.w  d6,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1                     ; d6 == -1 (no competitor)?
    beq.b   .l2c238
    move.w  d6,d0
    lsl.w   #$5,d0                    ; competitor * $20
    move.w  d3,d1
    lsl.w   #$2,d1                    ; slot * 4
    add.w   d1,d0
    movea.l #$00ff0130,a0
    move.l  (a0,d0.w),d2             ; d2 = competitor's license value (revenue measure)
    bra.b   .l2c23a
.l2c238:                                                ; $02C238
    moveq   #$0,d2                    ; no competitor -> competitor_value = 0

; Compare: is player's route revenue better than competitor's?
; profit_ratio = d5 * 10 (using d5 * (4+1) * 2 = d5 * 10 via shifts)
.l2c23a:                                                ; $02C23A
    move.l  d2,d0                     ; d0 = competitor_value
    moveq   #$b,d1                    ; d1 = 11
    dc.w    $4eb9,$0003,$e05c         ; jsr $03E05C  -- d0 = d0 mod d1 (competitor metric)
    move.l  d0,-(sp)                  ; save competitor metric
    move.l  d5,d0                     ; d0 = player's license value
    lsl.l   #$2,d0                    ; d0 = d5 * 4
    add.l   d5,d0                     ; d0 = d5 * 5
    add.l   d0,d0                     ; d0 = d5 * 10 (player's scaled revenue)
    move.l  (sp)+,d1                  ; d1 = competitor metric
    cmp.l   d1,d0                     ; player_revenue * 10 >= competitor_metric?
    bcc.b   .l2c26a                   ; no -- player underperforms competitor on this slot

; Player outperforms competitor -- is this our own route?
    cmp.w   -$0002(a6),d3            ; slot == aircraft_region?
    bne.b   .l2c25e
    move.w  d3,d7                     ; best slot = current slot (own region preferred)
    bra.b   .l2c274
.l2c25e:                                                ; $02C25E
; Pick highest-revenue slot overall
    cmp.l   -$00b0(a6),d5            ; d5 > best_revenue_so_far?
    bls.b   .l2c26a                   ; no
    move.l  d5,-$00b0(a6)            ; update best revenue
    move.w  d3,d7                     ; update best slot index
.l2c26a:                                                ; $02C26A
    addq.w  #$1,d3
    cmpi.w  #$7,d3                    ; scanned all 7 slots?
    blt.w   .l2c1b4

; --- Phase: display best-route report ---
.l2c274:                                                ; $02C274
    move.w  d7,d0                     ; best route slot (-1 if none)
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l2c2c0                   ; no best route found -> exit
    move.w  d6,d0                     ; d6 = competitor player index
    lsl.w   #$4,d0                    ; competitor * $10
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)                 ; arg: competitor's $FF00A8[competitor] record
    move.w  d7,d0                     ; d7 = best route slot index
    lsl.w   #$2,d0                    ; slot * 4 = longword index into RegionNamePtrs
    movea.l #$0005ec84,a0            ; RegionNamePtrs ($05EC84): 14 region name ptrs
    move.l  (a0,d0.w),-(sp)          ; arg: region name string for best slot
    move.l  $0020(a5),-(sp)          ; a5+$20 = ROM dialog ptr [8] (best-route msg template)
.l2c29e:                                                ; $02C29E
    move.l  a3,-(sp)                  ; arg: report buffer
    dc.w    $4eb9,$0003,$b22c         ; jsr $03B22C  -- format best-route report
    lea     $0010(sp),sp

; --- Phase: common display tail -- call a4 with extra parameters to show final dialog ---
.l2c2aa:                                                ; $02C2AA
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
.l2c2b2:                                                ; $02C2B2
    pea     ($0004).w
    move.l  a3,-(sp)                  ; arg: report buffer
.l2c2b8:                                                ; $02C2B8
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; arg: player index
    jsr     (a4)                       ; display annual report dialog ($0001183A)
.l2c2c0:                                                ; $02C2C0
    movem.l -$00d8(a6),d2-d7/a2-a5
    unlk    a6
    rts
    dc.w    $42A7,$4878,$0020; $02C2CA  -- start of init-report-buffer helper
; === Translated block $02C2D0-$02C2FA ===
; 1 functions, 42 bytes
