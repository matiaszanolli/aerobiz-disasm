; ============================================================================
; CalcRouteProfit -- Computes quarterly profit for all of a player's routes; processes route bitmasks, calls UpdateRouteRevenue, and updates player finance totals.
; 1182 bytes | $012076-$012513
; ============================================================================
; Register usage throughout:
;   d3 = route bitmask (arg $0c(a6)) -- bits 0..31 mark which of the 32 aircraft
;        slots contributed revenue this period (passed by caller)
;   d4 = player index (arg $08(a6))
;   d2 = loop counter / slot index (0..39 = $28)
;   d5 = walking bitmask bit (starts at 1, doubled each iteration via add.l d5,d5)
;   a3 = player record ptr  ($FF0018 + player * $24)
;   a2 = current route slot ptr  ($FF9A20 + player * $320 + slot * $14)
;   a5 = mirror slot ptr into second route array ($FF9D2C base, same player stride)
CalcRouteProfit:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d3                  ; d3 = caller's route bitmask (32 active-aircraft bits)
    move.l  $8(a6), d4                  ; d4 = player index (0-3)

; --- Phase: snapshot aircraft fleet bitmask and route-availability words ---
    move.w  d4, d0
    lsl.w   #$2, d0                     ; player * 4 = longword index
    movea.l  #$00FFA6A0,a0              ; bitfield_tab: per-player aircraft fleet bitmasks
    move.l  (a0,d0.w), -$c(a6)         ; save current fleet bitmask to local (-$c(a6))
    pea     ($000E).w                   ; copy 14 bytes (7 route-availability words)
    pea     -$1a(a6)                    ; dest: local stack buffer (-$1a(a6))
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0                     ; player * $e = 14-byte stride into $FFBD6C
    movea.l  #$00FFBD6C,a0             ; route-availability word array (7 words × 14 bytes/player)
    pea     (a0, d0.w)                  ; src: player's 7 availability words
    clr.l   -(a7)
    jsr MemCopy                         ; snapshot player's route-availability words locally
    lea     $14(a7), a7

; --- Phase: locate player record ---
    move.w  d4, d0
    mulu.w  #$24, d0                    ; player * $24 (36 bytes per record)
    movea.l  #$00FF0018,a0              ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a3                      ; a3 = this player's record

; --- Phase: bitmask walk -- add revenue from the 32 active-aircraft slots ---
; Walks bits 0..31 of d3. For each set bit, calls CalcRouteValue(slot, player)
; and adds the returned revenue to player_record.cash (+$06).
    clr.w   d2                          ; d2 = slot counter (0..31)
    moveq   #$1,d5                      ; d5 = walking bit (1 << slot)
    bra.b   .l120fc
.l120d4:
    move.l  d3, d0
    and.l   d5, d0                      ; test bit for this slot in caller's bitmask
    beq.b   .l120f8                     ; skip if this aircraft slot not active
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; arg: slot_index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; arg: player_index
    jsr (CalcRouteValue,PC)
    nop
    addq.l  #$8, a7
    andi.l  #$ffff, d0                  ; mask to 16-bit revenue result
    add.l   d0, $6(a3)                  ; player_record.cash += route revenue
.l120f8:
    addq.w  #$1, d2                     ; next slot
    add.l   d5, d5                      ; shift walking bit left by 1
.l120fc:
    cmpi.w  #$20, d2                    ; tested all 32 aircraft slots?
    blt.b   .l120d4

; --- Phase: scan route slots -- process pending-update (bit 7) flags ---
; Routes with status_flags bit 7 ($80) set have been marked for deletion/cleanup
; (e.g., their city was removed from the network). This pass handles the accounting
; and compacts the slot array by moving the last slot into the vacated position.
    move.w  d4, d0
    mulu.w  #$320, d0                   ; player * $320 ($320 = 40 slots × $14 bytes)
    movea.l  #$00FF9A20,a0              ; route_slots base
    lea     (a0,d0.w), a0
    movea.l a0, a2                      ; a2 = start of this player's 40 route slots
    clr.w   d2                          ; d2 = slot index (0..39)
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9D2C,a0             ; secondary route array ($FF9D2C, same layout, same stride)
    lea     (a0,d0.w), a0
    movea.l a0, a5                      ; a5 = mirror slot in secondary array (used in compaction)
.l12128:
    cmpi.b  #$ff, (a2)                  ; route_slot.city_a == $FF -> empty slot, end of array
    beq.w   .l12240
    move.b  $a(a2), d0                  ; route_slot.status_flags
    btst    #$7, d0                     ; bit 7 = pending-update / deletion flag
    beq.w   .l12232                     ; not flagged -- skip to next slot

; --- Slot cleanup: city dropped from route network ---
; Deduct this route's service_quality from both endpoint cities' city_data entries,
; then credit half the alliance bonus to player cash, then compact the slot array.
    moveq   #$0,d0
    move.b  (a2), d0                    ; route_slot.city_a
    lsl.w   #$3, d0                     ; city_a * 8 (4 entries × 2 bytes stride in city_data)
    move.w  d4, d1
    add.w   d1, d1                      ; player * 2
    add.w   d1, d0                      ; offset = city_a*8 + player*2
    movea.l  #$00FFBA80,a0             ; city_data base ($FFBA80: 89 cities × 4 entries × 2 bytes)
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0                  ; route_slot.frequency
    sub.b   d0, $1(a4)                  ; city_data[city_a][player] -= frequency
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; route_slot.city_b
    lsl.w   #$3, d0                     ; city_b * 8
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0                  ; route_slot.frequency
    sub.b   d0, $1(a4)                  ; city_data[city_b][player] -= frequency
    pea     ($0003).w                   ; arg: relation type
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; arg: city_b
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0                    ; arg: city_a
    move.l  d0, -(a7)
    jsr CalcRelationValue               ; d0 = alliance/relation bonus value
    lsr.l   #$1, d0                     ; halve the alliance bonus on route removal
    add.l   d0, $6(a3)                  ; player_record.cash += half alliance bonus
    moveq   #$0,d3
    move.b  $2(a2), d3                  ; route_slot.plane_type (packed nibbles)
    asr.l   #$4, d3                     ; high nibble = plane class B index
    andi.w  #$f, d3
    move.b  $2(a2), d5
    andi.w  #$f, d5                     ; low nibble = plane class A index
    move.w  d4, d0
    lsl.w   #$5, d0                     ; player * $20 (32 bytes/player in event_records)
    move.w  d3, d1
    add.w   d1, d1                      ; plane_class_B * 2
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0             ; event_records base ($FFB9E8: 4 players × $20 bytes)
    lea     (a0,d0.w), a0
    movea.l a0, a4
    add.b   d5, $1(a4)                  ; event_records[player][plane_B].byte1 += plane_class_A

; Zero out this slot (20 bytes) and mark city_a/city_b as $FF (empty)
    pea     ($0014).w                   ; 20 bytes = $14 = 1 route slot
    clr.l   -(a7)                       ; fill value = 0
    move.l  a2, -(a7)                   ; dest = current slot
    jsr MemFillByte
    lea     $18(a7), a7
    move.b  #$ff, (a2)                  ; route_slot.city_a = $FF (mark empty)
    move.b  #$ff, $1(a2)               ; route_slot.city_b = $FF

; Compact the slot array: move last valid slot into this gap
; d3 = remaining slots after current = ($28 - d2 - 1) = slots to shift
    moveq   #$28,d3                     ; $28 = 40 slots total
    sub.w   d2, d3                      ; remaining = 40 - current_index
    addi.w  #$ffff, d3                  ; remaining - 1 (count of slots after this one)
    tst.w   d3
    ble.b   .l12238                     ; nothing to compact (at or past end)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0                     ; d0 = remaining * 4
    add.l   d1, d0                      ; d0 = remaining * 5
    lsl.l   #$2, d0                     ; d0 = remaining * 20 = byte count to shift
    move.l  d0, -(a7)                   ; arg: byte count
    move.l  a2, -(a7)                   ; arg: dest = current slot address
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$14,d1
    add.l   d1, d0                      ; src = next slot (a2 + $14)
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr MemCopy                         ; shift tail of slot array left by one entry
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a5, -(a7)                   ; also clear corresponding mirror slot
    jsr MemFillByte
    lea     $20(a7), a7
    move.b  #$ff, (a5)                  ; mirror slot city_a = $FF
    move.b  #$ff, $1(a5)               ; mirror slot city_b = $FF
    bra.b   .l12238
.l12232:
    addq.w  #$1, d2                     ; advance to next slot index
    moveq   #$14,d0
    adda.l  d0, a2                      ; advance a2 by 20 bytes (1 slot stride)
.l12238:
    cmpi.w  #$28, d2                    ; scanned all 40 slots?
    blt.w   .l12128

; --- Phase: reinitialize player aircraft state after slot cleanup ---
; Reset player record's route type counters and rebuild fleet bitmask from hub city.
.l12240:
    move.b  #$1, $2(a3)                 ; player_record.route_type_a = 1 (domestic reset)
    clr.b   $3(a3)                      ; player_record.route_type_b = 0
    clr.b   $4(a3)                      ; player_record.domestic_slots = 0
    clr.b   $5(a3)                      ; player_record.intl_slots = 0
    moveq   #$0,d0
    move.b  $1(a3), d0                  ; player_record.hub_city
    moveq   #$1,d1
    lsl.l   d0, d1                      ; d1 = 1 << hub_city (single-bit bitmask for hub)
    move.w  d4, d0
    lsl.w   #$2, d0                     ; player * 4
    movea.l  #$00FFA6A0,a0             ; bitfield_tab
    move.l  d1, (a0,d0.w)              ; reset fleet bitmask to hub-city bit only

; Clear per-player availability tables (7 bytes aircraft slots, 14 bytes route words)
    pea     ($0007).w                   ; 7 bytes
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$7, d0                     ; player * 7
    movea.l  #$00FFA7BC,a0             ; aircraft availability table ($FFA7BC: 4 × 7 bytes)
    pea     (a0, d0.w)
    jsr MemFillByte                     ; zero this player's 7 aircraft-availability bytes
    pea     ($000E).w                   ; 14 bytes (7 words)
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    jsr MemFillByte                     ; zero this player's 7 route-availability words
    lea     $18(a7), a7

; --- Phase: second slot scan -- rebuild fleet bitmasks and availability tables ---
; Walk all 40 route slots and for each valid (non-$FF) slot:
;   1. RangeLookup converts city_a and city_b codes to region categories (0-6)
;   2. If categories differ: cross-region (international) route -- set bits in fleet bitmask
;      and availability table; possibly swap city order for canonical ordering
;   3. If categories same: domestic route -- set bits differently based on whether city
;      code < $20 (direct aircraft) or >= $20 (alliance city requiring FFBD6C word table)
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                      ; a2 = start of player's route slot array
    clr.w   d2                          ; slot index
    move.w  d4, d0
    mulu.w  #$e, d0                     ; player * $e
    movea.l  #$00FFBD6C,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)                ; -$4(a6) = player's FFBD6C route-availability word ptr
    move.w  d4, d0
    mulu.w  #$7, d0                     ; player * 7
    movea.l  #$00FFA7BC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$8(a6)                ; -$8(a6) = player's FFA7BC aircraft-availability byte ptr
.l122e2:
    cmpi.b  #$ff, (a2)                  ; route_slot.city_a == $FF -> end of used slots
    beq.w   .l124ac
    moveq   #$0,d0
    move.b  (a2), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                     ; d0 = region category for city_a (0-6)
    move.w  d0, d3                      ; d3 = city_a region
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                     ; d0 = region category for city_b (0-6)
    addq.l  #$8, a7
    move.w  d0, d5                      ; d5 = city_b region
    move.w  d3, d0
    lsl.w   #$2, d0                     ; city_a region * 4 bytes per CharTypeRangeTable entry
    movea.l  #$0005ECBC,a0             ; CharTypeRangeTable: 7 entries × 4 bytes, one per region
    lea     (a0,d0.w), a0
    movea.l a0, a4                      ; a4 = CharTypeRangeTable[city_a_region]
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5                      ; a5 = CharTypeRangeTable[city_b_region]
    cmp.w   d5, d3                      ; same region?
    beq.w   .l123d2                     ; yes -> domestic route handling

; --- International route: city_a region != city_b region ---
    addq.b  #$1, $4(a3)                ; player_record.domestic_slots++ (counts intl routes too)
    moveq   #$0,d0
    move.b  (a2), d0                    ; city_a index
    moveq   #$1,d6
    lsl.l   d0, d6                      ; d6 = 1 << city_a  (bit for city_a in fleet bitmask)
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; city_b index
    moveq   #$1,d7
    lsl.l   d0, d7                      ; d7 = 1 << city_b

; Test if city_a already registered in fleet bitmask
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0              ; load current fleet bitmask
    and.l   d6, d0                      ; test city_a bit
    bne.b   .l1236e                     ; already set -- skip
    addq.b  #$1, $2(a3)               ; player_record.route_type_a++ (new unique city)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)              ; set city_a bit in fleet bitmask
.l1236e:
; Test if city_b already registered
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0                      ; test city_b bit
    bne.b   .l12392                     ; already set
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)              ; set city_b bit in fleet bitmask
.l12392:
; Check entity_bits to decide canonical city ordering (swap if needed)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0             ; entity_bits: per-player longword bitfield
    move.l  (a0,d0.w), d0
    and.l   d6, d0                      ; test city_a bit in entity_bits
    bne.b   .l123ae                     ; bit set -> keep current ordering
    move.b  (a2), d6                    ; swap city_a and city_b in the slot for canonical order
    move.b  $1(a2), (a2)
    move.b  d6, $1(a2)

; Set mutual availability bits in aircraft availability byte table
; FFA7BC byte[city_a_region] |= (1 << city_b_region)
; FFA7BC byte[city_b_region] |= (1 << city_a_region)
.l123ae:
    moveq   #$1,d0
    lsl.b   d5, d0                      ; d0 = 1 << city_b_region
    move.w  d3, d1
    ext.l   d1                          ; d1 = city_a_region
    add.l   -$8(a6), d1                ; ptr = FFA7BC_player_base + city_a_region
    movea.l d1, a0
    or.b    d0, (a0)                   ; FFA7BC[city_a_region] |= (1 << city_b_region)
    moveq   #$1,d0
    lsl.b   d3, d0                      ; d0 = 1 << city_a_region
    move.w  d5, d1
    ext.l   d1
    add.l   -$8(a6), d1               ; ptr = FFA7BC_player_base + city_b_region
    movea.l d1, a0
    or.b    d0, (a0)                   ; FFA7BC[city_b_region] |= (1 << city_a_region)
    bra.w   .l124ac                    ; advance to next slot

; --- Domestic route: city_a region == city_b region ---
.l123d2:
    addq.b  #$1, $5(a3)               ; player_record.intl_slots++ (actually domestic counter)
; city_a processing: direct city (<$20) vs alliance city (>=$20)
    cmpi.b  #$20, (a2)                 ; city_a < $20? (direct domestic city)
    bcc.b   .l1240a                    ; city_a >= $20 -> alliance city path
    moveq   #$0,d0
    move.b  (a2), d0                    ; city_a direct city code
    moveq   #$1,d6
    lsl.l   d0, d6                      ; d6 = 1 << city_a
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0                      ; test city_a bit in fleet bitmask
    bne.b   .l1243e                     ; already registered
    addq.b  #$1, $2(a3)               ; new direct city -- increment route_type_a
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)              ; register city_a in fleet bitmask
    bra.b   .l1243e

; city_a is an alliance city (code >= $20): use the FFBD6C route-availability word table
; The alliance city slot bit is stored as a word in FFBD6C[region][city_a - range_base]
.l1240a:
    moveq   #$0,d0
    move.b  (a2), d0                    ; city_a alliance code
    moveq   #$0,d1
    move.b  $2(a4), d1                  ; CharTypeRangeTable[city_a_region].range2_base
    sub.w   d1, d0                      ; city_a - range_base = bit position within range
    moveq   #$1,d6
    lsl.w   d0, d6                      ; d6 = bit mask for this alliance slot
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0                      ; region * 2 (word index into FFBD6C)
    add.l   -$4(a6), d0               ; ptr = FFBD6C_player_base + region * 2
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d6, d0                      ; test alliance slot bit
    bne.b   .l1243e                     ; already registered
    addq.b  #$1, $3(a3)               ; player_record.route_type_b++ (new alliance city)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d6, (a0)                   ; register alliance city_a in FFBD6C word table
.l1243e:
; city_b processing (same logic as city_a above)
    cmpi.b  #$20, $1(a2)              ; city_b < $20?
    bcc.b   .l12476                    ; city_b >= $20 -> alliance city path
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d7
    lsl.l   d0, d7                      ; d7 = 1 << city_b
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0
    bne.b   .l124ac
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)              ; register city_b in fleet bitmask
    bra.b   .l124ac

; city_b is an alliance city
.l12476:
    moveq   #$0,d0
    move.b  $1(a2), d0                  ; city_b alliance code
    moveq   #$0,d1
    move.b  $2(a5), d1                  ; CharTypeRangeTable[city_b_region].range2_base
    sub.w   d1, d0                      ; city_b - range_base
    moveq   #$1,d3
    lsl.w   d0, d3                      ; d3 = bit mask for city_b alliance slot
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0                      ; city_b_region * 2
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d3, d0
    bne.b   .l124ac
    addq.b  #$1, $3(a3)
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d3, (a0)                   ; register alliance city_b in FFBD6C word table
.l124ac:
    moveq   #$14,d0
    adda.l  d0, a2                      ; a2 += $14 (advance to next route slot)
    addq.w  #$1, d2
    cmpi.w  #$28, d2                    ; all 40 slots processed?
    blt.w   .l122e2

; --- Phase: merge snapshotted availability words into rebuilt set (AND-NOT mask) ---
; Any bits that were set in the original snapshot but are NOT in the new fleet bitmask
; should be cleared from the local availability word buffer. This removes stale entries.
    clr.w   d2
.l124bc:
    move.w  d4, d0
    mulu.w  #$e, d0                     ; player * $e
    move.w  d2, d1
    add.w   d1, d1                      ; d2 * 2 (word index)
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d0.w), d0              ; load rebuilt FFBD6C word for region d2
    not.w   d0                          ; invert: bits NOT in new set
    move.w  d2, d1
    add.w   d1, d1
    and.w   d0, -$1a(a6, d1.w)        ; clear those bits in the local snapshot buffer
    addq.w  #$1, d2
    cmpi.w  #$7, d2                    ; all 7 availability words processed?
    blt.b   .l124bc

; Also mask the fleet bitmask snapshot against the new fleet bitmask (remove stale aircraft)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0             ; new fleet bitmask
    not.l   d0                         ; invert
    and.l   d0, -$c(a6)               ; remove from snapshot any bits not in new fleet

; --- Phase: call UpdateRouteRevenue to process revenue for all active routes ---
    pea     -$1a(a6)                   ; arg: ptr to availability word buffer (7 words)
    move.l  -$c(a6), -(a7)            ; arg: filtered fleet bitmask
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                  ; arg: player index
    bsr.w UpdateRouteRevenue
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts
