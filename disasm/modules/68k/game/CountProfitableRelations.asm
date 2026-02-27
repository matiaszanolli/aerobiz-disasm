; ============================================================================
; CountProfitableRelations -- counts a player's route slots where current revenue exceeds the cost threshold
; Called: ?? times.
; 100 bytes | $0104CA-$01052D
; ============================================================================
CountProfitableRelations:                                                  ; $0104CA
; --- Phase: Setup -- locate player's route slot base and count active slots ---
    movem.l d2-d3/a2,-(sp)
    move.l  $0010(sp),d2               ; d2 = player_index (arg from stack)
    move.w  d2,d0
    mulu.w  #$0320,d0                  ; player offset = index * $320 (40 slots * $14 bytes)
    movea.l #$00ff9a20,a0              ; route_slots base ($FF9A20)
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = player's route slot array base
    move.w  d2,d0
    mulu.w  #$24,d0                    ; player record offset = index * $24 (36 bytes)
    movea.l #$00ff0018,a0              ; player_records base ($FF0018)
    lea     (a0,d0.w),a0
    movea.l a0,a1                      ; a1 = this player's record
    moveq   #$0,d1
    move.b  $0004(a1),d1               ; d1 = player_record.domestic_slots
    moveq   #$0,d0
    move.b  $0005(a1),d0               ; d0 = player_record.intl_slots
    add.w   d0,d1                      ; d1 = total slot count (domestic + intl)
    clr.w   d2                         ; d2 = slot loop counter
    clr.w   d3                         ; d3 = profitable route tally (result)
    bra.b   .l10522                    ; branch to loop test first

; --- Phase: Slot scan loop -- test each slot for profitability ---
.l1050a:                                                ; $01050A
    tst.b   $0003(a2)                  ; route_slot.frequency == 0?
    beq.b   .l1051c                    ; skip inactive slot (frequency = 0 means no flights)
    move.w  $0006(a2),d0               ; d0 = route_slot.revenue_target
    cmp.w   $000e(a2),d0               ; compare revenue_target vs actual_revenue
    bls.b   .l1051c                    ; skip if actual_revenue >= revenue_target (not LOSS; bls = unsigned <=)
    addq.w  #$1,d3                     ; route is unprofitable (target > actual): increment count
.l1051c:                                                ; $01051C
    moveq   #$14,d0
    adda.l  d0,a2                      ; advance a2 by $14 (next route slot)
    addq.w  #$1,d2                     ; slot counter++
.l10522:                                                ; $010522
    cmp.w   d1,d2                      ; all slots scanned?
    blt.b   .l1050a                    ; no -- keep looping
    move.w  d3,d0                      ; return count of unprofitable routes in d0
    movem.l (sp)+,d2-d3/a2
    rts
RankCharCandidates:                                                  ; $01052E
; --- Phase: Frame setup -- resolve char type range for the given city ---
    link    a6,#-$c
    movem.l d2-d6/a2-a4,-(sp)
    move.l  $000c(a6),d4               ; d4 = char_type (city index or char category)
    move.l  $0008(a6),d5               ; d5 = player_index
    lea     -$000c(a6),a4              ; a4 = local work buffer (12 bytes: 3 word slots)
    pea     ($000C).w
    clr.l   -(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520  -- MemFill(a4, 0, 12)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648  -- RangeLookup(d4) -> char category 0-6
    lea     $0010(sp),sp
    move.w  d0,d2                      ; d2 = char category index (result of RangeLookup)
    lsl.w   #$2,d0                     ; category * 4 (each CharTypeRangeTable entry is 4 bytes)
    movea.l #$0005ecbc,a0              ; CharTypeRangeTable base ($05ECBC)
    lea     (a0,d0.w),a0
    movea.l a0,a3                      ; a3 = descriptor entry for this category
    moveq   #$0,d6
    move.b  $0002(a3),d6               ; d6 = descriptor.range2_base
    moveq   #$0,d0
    move.b  $0003(a3),d0               ; d0 = descriptor.range2_size
    add.w   d0,d6                      ; d6 = range2 end (range2_base + range2_size)
    moveq   #$0,d2
    move.b  (a3),d2                    ; d2 = descriptor.range1_base (loop start)
    bra.w   .l10642                    ; branch to loop test

; --- Phase: Range1 scan -- tally candidates from first char code range ---
.l10586:                                                ; $010586
    moveq   #$0,d0
    move.b  (a3),d0                    ; range1_base
    moveq   #$0,d1
    move.b  $0001(a3),d1              ; range1_size
    add.l   d1,d0                      ; d0 = range1_base + range1_size (range1 end)
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0                      ; current d2 past range1 end?
    bne.b   .l105a0                    ; still in range1 -- continue
    moveq   #$0,d2
    move.b  $0002(a3),d2              ; wrap to range2_base when range1 exhausted
.l105a0:                                                ; $0105A0
    cmp.w   d2,d4                      ; skip self (current char == query type)?
    beq.w   .l10640
    move.w  d2,d0
    add.w   d0,d0                      ; d0 = d2 * 2 (stride-2 table index)
    movea.l #$00ff8824,a0              ; tab32_8824 ($FF8824): 32-entry stride-2 table
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.b  (a2),d0                    ; tab32_8824[d2].byte0
    cmp.b   $0001(a2),d0              ; compare byte0 vs byte1 -- skip if equal (no vacancy?)
    beq.w   .l10640
    move.w  d2,d0
    lsl.w   #$3,d0                     ; d0 = d2 * 8 (city_data stride: 4 entries * 2 bytes)
    move.w  d5,d1
    add.w   d1,d1                      ; d1 = player_index * 2
    add.w   d1,d0                      ; offset = city_idx*8 + player*2
    movea.l #$00ffba80,a0              ; city_data base ($FFBA80): 89 cities * 4 entries * 2 bytes
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = city_data[d2][d5] entry
    tst.b   $0001(a2)                  ; city_data entry byte1 -- nonzero = already occupied?
    bne.b   .l10640                    ; skip if city relation already filled
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)                   ; arg: candidate char type index
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)                   ; arg: query char type (d4)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42 -- CharCodeCompare(d2, d4) -> compatibility score
    move.w  d0,d3                      ; d3 = compatibility score
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)                   ; arg: player_index
    dc.w    $4eb9,$0003,$5ccc                           ; jsr $035CCC -- GetRelationScore(d5) -> d0
    lea     $000c(sp),sp
    cmp.w   d3,d0                      ; relation score vs compatibility?
    bcs.b   .l10640                    ; skip if relation score < compat (not worth it)
    moveq   #$0,d3
    move.b  (a2),d3                    ; d3 = city_data entry byte0 (current relation count/rank)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$865e                           ; jsr $00865E -- CalcCharCompatScore(d2, d4) -> d0
    andi.l  #$ffff,d0
    asr.l   #$1,d0                     ; halve score (shift right 1 = /2)
    move.w  d3,d1
    lsl.w   #$2,d1                     ; d1 = city_rank * 4 (priority weight)
    add.w   d1,d0                      ; combined score = compat/2 + rank*4
    move.w  d0,$000a(a4)               ; store combined score in work buffer slot +$0A
    move.w  d2,$0008(a4)               ; store candidate char index in work buffer slot +$08
    pea     ($0003).w
    move.l  a4,-(sp)
    dc.w    $4eba,$03c2                                 ; jsr $0109FA -- InsertSortedCandidate(a4, 3)
    nop
    lea     $0010(sp),sp
.l10640:                                                ; $010640
    addq.w  #$1,d2                     ; next char code in range
.l10642:                                                ; $010642
    cmp.w   d6,d2                      ; reached range end (range2 end)?
    blt.w   .l10586
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a4,d0.l),a0               ; a0 = work buffer base (d2=0, so start)
    movea.l a0,a2

; --- Phase: Finalize candidates -- sentinel-fill any unfilled slots ---
.l10656:                                                ; $010656
    tst.w   $0002(a2)                  ; slot has a valid candidate (count field nonzero)?
    bne.b   .l10660
    move.w  #$ffff,(a2)                ; mark slot as unused ($FFFF sentinel)
.l10660:                                                ; $010660
    addq.l  #$4,a2                     ; advance 4 bytes per candidate slot
    addq.w  #$1,d2
    cmpi.w  #$2,d2                     ; check all 2 candidate slots
    blt.b   .l10656
    cmpi.w  #$1,$0012(a6)             ; arg: prefer-first flag?
    bne.b   .l10678
    move.w  -$000c(a6),d0             ; return slot 0 candidate (first/best)
    bra.b   .l1067c
.l10678:                                                ; $010678
    move.w  $0004(a4),d0              ; return slot 1 candidate (second choice)
.l1067c:                                                ; $01067C
    movem.l -$002c(a6),d2-d6/a2-a4
    unlk    a6
    rts
; ---------------------------------------------------------------------------
FindBestCharacter:                                                  ; $010686
; --- Phase: Frame setup -- resolve char range for the given char type ---
    link    a6,#-$c
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d6               ; d6 = char_type (city/category index)
    move.w  d6,d0
    mulu.w  #$24,d0                    ; player record offset
    movea.l #$00ff0018,a0              ; player_records base
    lea     (a0,d0.w),a0
    movea.l a0,a5                      ; a5 = player record for this char_type
    pea     ($0008).w
    clr.l   -(sp)
    pea     -$0008(a6)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520 -- MemFill(local_buf, 0, 8)
    move.w  $000e(a6),d0               ; d0 = char_type arg (second param)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup -> category 0-6
    lea     $0010(sp),sp
    move.w  d0,d2                      ; d2 = category index
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0              ; CharTypeRangeTable ($05ECBC)
    lea     (a0,d0.w),a0
    movea.l a0,a2                      ; a2 = descriptor for this category
    moveq   #$0,d7
    move.b  (a2),d7                    ; d7 = range1_base
    moveq   #$0,d0
    move.b  $0001(a2),d0               ; range1_size
    add.w   d0,d7                      ; d7 = range1 end
    moveq   #$0,d5
    move.b  (a2),d5                    ; d5 = range1_base (loop start)
    bra.b   .l10750

; --- Phase: Range1 scan -- score chars in $FF0420/$FF1704 tables ---
.l106e8:                                                ; $0106E8
    clr.w   d2                         ; d2 = column counter (6 columns per row)
.l106ea:                                                ; $0106EA
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0                      ; index = d4 * 6 + d2 (6 bytes per row)
    movea.l #$00ff0420,a0              ; $FF0420: char slot ownership table (player byte per slot)
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0                      ; owned by this char_type (player)?
    bne.b   .l10746                    ; skip if not owned by query player
    move.w  d5,d0
    mulu.w  #$6,d0
    add.w   d2,d0                      ; same index for candidate row d5
    movea.l #$00ff1704,a0              ; $FF1704: char type/category table
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3                    ; d3 = char type code from table
    move.w  d3,d0
    lsl.w   #$2,d0                     ; type * 4 (CharWeightTable stride)
    movea.l #$0005e31d,a0              ; CharWeightTable subrange ($05E31D+)
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,d3                      ; d3 = weight category (0-3 valid, else skip)
    tst.w   d3
    blt.b   .l10746                    ; negative = invalid
    cmpi.w  #$4,d3
    bge.b   .l10746                    ; >= 4 = invalid category
    move.w  d3,d0
    add.w   d0,d0                      ; d0 = category * 2 (word offset into local tally)
    addq.w  #$1,-$8(a6,d0.w)          ; tally[category]++
.l10746:                                                ; $010746
    addq.w  #$1,d2
    cmpi.w  #$6,d2                     ; 6 columns per row
    blt.b   .l106ea
    addq.w  #$1,d5                     ; next candidate char index
.l10750:                                                ; $010750
    cmp.w   d7,d5                      ; end of range1?
    blt.b   .l106e8
    moveq   #$0,d7
    move.b  $0002(a2),d7               ; d7 = range2_base
    moveq   #$0,d0
    move.b  $0003(a2),d0               ; range2_size
    add.w   d0,d7                      ; d7 = range2 end
    moveq   #$0,d5
    move.b  $0002(a2),d5               ; d5 = range2_base (loop start)
    bra.b   .l107ce

; --- Phase: Range2 scan -- score chars in $FF0460/$FF15A0 tables (4 cols/row) ---
.l1076a:                                                ; $01076A
    clr.w   d2
.l1076c:                                                ; $01076C
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0                      ; index = d4 * 4 + d2 (4 bytes per row)
    movea.l #$00ff04e0,a0              ; $FF04E0: char slot ownership table (range2 variant)
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0                      ; owned by query player?
    bne.b   .l107c4
    move.w  d5,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff1620,a0              ; $FF1620: char type table (range2 variant, stride 4)
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0              ; CharWeightTable subrange
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,d3
    tst.w   d3
    blt.b   .l107c4
    cmpi.w  #$4,d3
    bge.b   .l107c4
    move.w  d3,d0
    add.w   d0,d0
    addq.w  #$1,-$8(a6,d0.w)          ; tally[category]++
.l107c4:                                                ; $0107C4
    addq.w  #$1,d2
    cmpi.w  #$4,d2                     ; 4 columns per row (range2 table)
    blt.b   .l1076c
    addq.w  #$1,d5
.l107ce:                                                ; $0107CE
    cmp.w   d7,d5                      ; end of range2?
    blt.b   .l1076a

; --- Phase: Find best category -- pick category with highest tally ---
    clr.w   d2                         ; d2 = best tally seen so far
    clr.w   -$000a(a6)                ; best category result (local)
    clr.w   d4                         ; d4 = category iterator (0-3)
.l107da:                                                ; $0107DA
    cmpi.w  #$1,d4
    bne.b   .l107e2
    addq.w  #$1,d4                     ; skip category 1 (unused/reserved slot)
.l107e2:                                                ; $0107E2
    move.w  d4,d0
    add.w   d0,d0                      ; word offset
    move.w  -$8(a6,d0.w),d0           ; d0 = tally[d4]
    cmp.w   d2,d0                      ; better than current best?
    ble.b   .l107fa
    move.w  d4,d0
    add.w   d0,d0
    move.w  -$8(a6,d0.w),d2           ; update best tally
    move.w  d4,-$000a(a6)             ; store winning category index
.l107fa:                                                ; $0107FA
    addq.w  #$1,d4
    cmpi.w  #$4,d4                     ; checked all 4 categories?
    blt.b   .l107da

; --- Phase: Char lookup -- find the best specific char within winning category ---
    cmpi.w  #$20,$000e(a6)            ; arg < $20 (range1 threshold)?
    bge.b   .l10836
    move.w  $000e(a6),d0
    mulu.w  #$6,d0                     ; stride 6 for range1 tables
    movea.l #$00ff1704,a0              ; $FF1704: char type table (range1)
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  $000e(a6),d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0              ; $FF0420: ownership table (range1)
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$6,d5                     ; 6 entries per row (range1)
    bra.b   .l1085c
.l10836:                                                ; $010836
    move.w  $000e(a6),d0
    lsl.w   #$2,d0                     ; stride 4 for range2 tables
    movea.l #$00ff15a0,a0              ; $FF15A0: char type table (range2)
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0              ; $FF0460: ownership table (range2)
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$4,d5                     ; 4 entries per row (range2)
.l1085c:                                                ; $01085C
    moveq   #-$1,d3                    ; d3 = best primary match ($-1 = none yet)
    move.w  d3,d7                      ; d7 = best secondary match ($-1 = none yet)
    move.l  #$3b9ac9ff,d4             ; d4 = best score so far ($3B9AC9FF = very large sentinel)
    clr.w   d4                         ; clear low word: d4 = $3B9AC900 (keep high)
    bra.b   .l108d6

; --- Phase: Candidate scan -- find char with lowest viable cost ---
.l1086a:                                                ; $01086A
    cmpi.b  #$0f,(a2)                  ; char type $0F = end-of-list sentinel?
    beq.b   .l108d0                    ; skip sentinel entries
    cmpi.b  #$ff,(a3)                  ; ownership byte $FF = slot owned elsewhere?
    bne.b   .l108d0                    ; skip if not free ($FF = not owned by query)
    moveq   #$0,d0
    move.b  (a2),d0                    ; d0 = char type code from row
    lsl.w   #$2,d0                     ; * 4 for CharWeightTable stride
    movea.l #$0005e31a,a0             ; CharWeightTable ($05E31A): byte-pair weight factors
    lea     (a0,d0.w),a0
    movea.l a0,a4                      ; a4 = weight entry for this char type
    moveq   #$0,d0
    move.b  (a2),d0                    ; char type for cost calc
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E -- CalcCharCost(type, arg_e, d6) -> d0
    lea     $000c(sp),sp
    move.l  d0,d2                      ; d2 = computed cost
    cmp.l   $0006(a5),d2               ; compare vs player_record.cash (+$06)
    bgt.b   .l108d0                    ; skip if cost exceeds available cash
    moveq   #$0,d0
    move.b  $0003(a4),d0               ; weight_entry.byte3 = category qualifier
    cmp.w   -$000a(a6),d0             ; matches winning category?
    bne.b   .l108c4                    ; no -- try as secondary candidate
    cmpi.l  #$3b9ac9ff,d2             ; cost < sentinel threshold?
    bcc.b   .l108d0
    moveq   #$0,d3
    move.b  (a2),d3                    ; d3 = this char type (primary best candidate)
    bra.b   .l108d0
.l108c4:                                                ; $0108C4
    cmpi.l  #$3b9ac9ff,d2             ; secondary candidate cost < threshold?
    bcc.b   .l108d0
    moveq   #$0,d7
    move.b  (a2),d7                    ; d7 = secondary best candidate char type
.l108d0:                                                ; $0108D0
    addq.w  #$1,d4                     ; advance slot counter
    addq.l  #$1,a3                     ; next ownership byte
    addq.l  #$1,a2                     ; next char type byte
.l108d6:                                                ; $0108D6
    cmp.w   d5,d4                      ; all slots scanned?
    blt.b   .l1086a
    move.w  d3,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1                      ; no primary candidate found (d3 == -1)?
    bne.b   .l108e6
    move.w  d7,d3                      ; fall back to secondary candidate
.l108e6:                                                ; $0108E6
    move.w  d3,d0                      ; return best candidate char type in d0
    movem.l -$0034(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
FindCharByValue:                                                  ; $0108F2
; --- Phase: Frame setup -- locate player record and resolve char range ---
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d6               ; d6 = char_type (city/category index)
    move.w  $000a(a6),d0               ; d0 = player_index
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5                      ; a5 = player record
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648 -- RangeLookup(d6) -> category
    addq.l  #$4,sp

; --- Phase: Table selection -- pick range1 or range2 table based on char_type ---
    cmpi.w  #$20,d6                    ; d6 < $20 -> range1 (6-col tables)
    bge.b   .l1094e
    move.w  d6,d0
    mulu.w  #$6,d0
    movea.l #$00ff1704,a0             ; $FF1704: char type table (range1, stride 6)
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0             ; $FF0420: ownership table (range1, stride 6)
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$6,d7                     ; 6 entries per row
    bra.b   .l10970
.l1094e:                                                ; $01094E
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0             ; $FF15A0: char type table (range2, stride 4)
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0             ; $FF0460: ownership table (range2, stride 4)
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$4,d7                     ; 4 entries per row
.l10970:                                                ; $010970
    moveq   #-$1,d5                    ; d5 = best candidate char code (-1 = none)
    tst.w   $0012(a6)                  ; prefer-cheapest flag?
    bne.b   .l10980
    move.l  #$3b9ac9ff,d3             ; d3 = best cost (min-search: start very high)
    bra.b   .l10982
.l10980:                                                ; $010980
    moveq   #-$1,d3                    ; d3 = best cost (max-search: start very low)
.l10982:                                                ; $010982
    clr.w   d4                         ; d4 = slot counter
    bra.b   .l109ea

; --- Phase: Slot scan -- find best char by cost (min or max search) ---
.l10986:                                                ; $010986
    cmpi.b  #$0f,(a2)                  ; sentinel type $0F = end of valid chars
    beq.b   .l109e4
    cmpi.b  #$ff,(a3)                  ; ownership $FF = slot available?
    bne.b   .l109e4                    ; skip if occupied
    moveq   #$0,d0
    move.b  (a2),d0                    ; d0 = char type code
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0             ; CharWeightTable ($05E31A)
    lea     (a0,d0.w),a0
    movea.l a0,a4                      ; a4 = weight entry for this char
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E -- CalcCharCost(type, d6, player) -> d0
    lea     $000c(sp),sp
    move.l  d0,d2                      ; d2 = cost for this candidate
    cmp.l   $0006(a5),d2               ; cost <= player.cash?
    bgt.b   .l109e4                    ; skip if too expensive
    cmpi.b  #$01,$0003(a4)            ; weight_entry.byte3 == 1? (eligible category)
    bne.b   .l109e4
    tst.w   $0012(a6)                  ; prefer-cheapest (0) or most expensive (1)?
    bne.b   .l109da
    cmp.l   d3,d2                      ; cost < current best (cheaper)?
    bge.b   .l109e4
    bra.b   .l109de
.l109da:                                                ; $0109DA
    cmp.l   d3,d2                      ; cost > current best (more expensive)?
    ble.b   .l109e4
.l109de:                                                ; $0109DE
    moveq   #$0,d5
    move.b  (a2),d5                    ; d5 = new best candidate char code
    move.l  d2,d3                      ; d3 = new best cost
.l109e4:                                                ; $0109E4
    addq.w  #$1,d4
    addq.l  #$1,a3                     ; advance ownership pointer
    addq.l  #$1,a2                     ; advance char type pointer
.l109ea:                                                ; $0109EA
    cmp.w   d7,d4                      ; all slots scanned?
    blt.b   .l10986
    move.w  d5,d0                      ; return best char code in d0 (-1 if none found)
    movem.l -$0028(a6),d2-d7/a2-a5
    unlk    a6
    rts
