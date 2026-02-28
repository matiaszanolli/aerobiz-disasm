; ============================================================================
; ProcessCharRoster -- Draw route arcs on the world map for all domestic and international routes of a player
; 534 bytes | $009A88-$009C9D
; ============================================================================
; Args (stack, via link frame):
;   $8(a6)  = player_index (d7)
;   $C(a6)  = route_type   (d5): region/category filter (e.g. 0=domestic)
;   $10(a6) = show_flag    (d6): 0 = show profit/loss color, nonzero = show fixed color
; This function draws route arcs in two passes:
;   Pass 1: Domestic slots (indices 0 .. domestic_slots-1), category d5 from $5E234 table
;   Pass 2: International slots (indices 0 .. intl_slots-1), category 1 (fixed), from $5E9FA table
ProcessCharRoster:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    ; --- Phase: Load args ---
    move.l  $c(a6), d5              ; d5 = route_type / region category filter
    move.l  $10(a6), d6             ; d6 = show_flag (0 = color by profit, else fixed)
    move.l  $8(a6), d7              ; d7 = player_index
    ; --- Phase: Point a5 at player record ($FF0018 base, stride $24) ---
    move.w  d7, d0
    mulu.w  #$24, d0                ; d0 = player_index * $24 (36 bytes/player)
    movea.l  #$00FF0018,a0          ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a5                  ; a5 = &player_record[player_index]
    ; --- Phase: Build bitfield mask for pass 1 (domestic) ---
    ; d4 = entity_bits[player] AND mask_from_5ECDC[route_type]
    move.w  d7, d0
    lsl.w   #$2, d0                 ; d0 = player_index * 4 (longword-indexed)
    movea.l  #$00FFA6A0,a0          ; bitfield_tab: entity bitfield array
    move.l  (a0,d0.w), d4           ; d4 = raw entity bitfield for player
    move.w  d5, d0
    lsl.w   #$2, d0                 ; d0 = route_type * 4
    movea.l  #$0005ECDC,a0          ; ROM table: category bitmasks indexed by route_type
    and.l   (a0,d0.w), d4           ; d4 = filtered bitfield (only bits for category d5)
    ; --- Phase: Point a2 at player's route slot array ($FF9A20, stride $320 per player) ---
    move.w  d7, d0
    mulu.w  #$320, d0               ; d0 = player_index * $320 (800 bytes/player in route_slots)
    movea.l  #$00FF9A20,a0          ; route_slots array base
    lea     (a0,d0.w), a0
    movea.l a0, a2                  ; a2 = player's route slot 0
    clr.w   d3                      ; d3 = slot loop counter
    ; --- Phase: Load arc-style pointer from $5E234 table (14 bytes per route_type entry) ---
    move.w  d5, d0
    mulu.w  #$e, d0                 ; d0 = route_type * 14
    movea.l  #$0005E234,a0          ; ROM table: arc drawing style descriptors by route_type
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)             ; store arc-style pointer in frame local (used per-slot)
    bra.w   l_09bc0                 ; jump to loop condition
    ; =========================================================
    ; Pass 1: Domestic route slots (0 .. domestic_slots-1)
    ; =========================================================
l_09af6:
    ; Skip slots with city_a == $FF (empty)
    cmpi.b  #$ff, (a2)              ; route_slot[+0].city_a == $FF?
    beq.w   l_09bba                 ; empty slot -> advance to next
    ; --- Check if city_a or city_b bit is set in the filtered bitfield ---
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = city_a index
    moveq   #$1,d1
    lsl.l   d0, d1                  ; d1 = 1 << city_a (bit for city_a)
    move.l  d1, d0
    and.l   d4, d0                  ; test city_a bit in filtered bitfield
    bne.b   l_09b1e                 ; city_a in category -> proceed
    ; city_a not in category; check city_b
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = city_b index
    moveq   #$1,d1
    lsl.l   d0, d1                  ; d1 = 1 << city_b
    move.l  d1, d0
    and.l   d4, d0                  ; test city_b bit
    beq.w   l_09bba                 ; neither city in category -> skip slot
l_09b1e:
    ; --- Determine arc direction: which city is the "hub" side ---
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = city_a
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                 ; map city_a index to region category (0-7)
    addq.l  #$4, a7
    move.w  d0, d2                  ; d2 = city_a region
    cmp.w   d5, d0                  ; city_a region == route_type filter?
    beq.b   l_09b56                 ; yes -> city_a is hub, look up city_b coord
    ; city_a is remote -- a4 = arc-style for city_a region, a3 = city_b coord
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0                  ; d0 = city_a_region * 2 (word-indexed)
    add.l   -$4(a6), d0             ; d0 = arc_style_ptr + city_a_region*2
    movea.l d0, a4                  ; a4 = arc style entry for city_a endpoint
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = city_b index
    add.w   d0, d0                  ; x2 for word offset into $5E9FA
    movea.l  #$0005E9FA,a0          ; ROM table: city map coordinates (word pairs)
    lea     (a0,d0.w), a0
    movea.l a0, a3                  ; a3 = city_b coordinate entry
    bra.b   l_09b8c
l_09b56:
    ; city_a is hub -- check city_b region
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = city_b
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup                 ; map city_b to region category
    addq.l  #$4, a7
    move.w  d0, d2                  ; d2 = city_b region
    cmp.w   d5, d0                  ; city_b region == route_type filter?
    beq.b   l_09b8c                 ; both hub side -> skip this arc (intra-region)
    ; city_b is remote -- a4 = city_a coord, a3 = arc-style for city_b region
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = city_a
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4                  ; a4 = city_a coordinate entry
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a3                  ; a3 = arc style entry for city_b region
l_09b8c:
    ; --- Determine draw color based on show_flag and route profitability ---
    tst.w   d6                      ; show_flag nonzero?
    bne.b   l_09ba2                 ; yes -> use fixed color 3
    ; show_flag == 0: color by profit vs target
    move.w  $e(a2), d0              ; d0 = route_slot[+$E].actual_revenue
    cmp.w   $6(a2), d0              ; compare with revenue_target at +$6
    bcs.b   l_09b9e                 ; actual < target -> unprofitable (color 2)
    moveq   #$1,d2                  ; color 1 = profitable (green arc)
    bra.b   l_09ba4
l_09b9e:
    moveq   #$2,d2                  ; color 2 = unprofitable (red arc)
    bra.b   l_09ba4
l_09ba2:
    moveq   #$3,d2                  ; color 3 = forced/selected (highlight arc)
l_09ba4:
    ; DrawRoutePair(a4=src_coord, a3=dst_coord, mode=2, color=d2)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: arc color/style
    pea     ($0002).w               ; arg: draw mode = 2 (domestic arc)
    move.l  a3, -(a7)               ; arg: destination coordinate pointer
    move.l  a4, -(a7)               ; arg: source coordinate pointer
    bsr.w DrawRoutePair             ; draw route arc between two city coordinates
    lea     $10(a7), a7             ; clean up 4 args
l_09bba:
    ; Advance to next slot ($14 = 20 bytes per route_slot)
    moveq   #$14,d0
    adda.l  d0, a2                  ; a2 += 20
    addq.w  #$1, d3                 ; d3++
l_09bc0:
    ; Loop condition: d3 < player_record[+4].domestic_slots
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a5), d1              ; d1 = player_record.domestic_slots
    cmp.l   d1, d0
    blt.w   l_09af6                 ; d3 < domestic_slots -> process next slot
    ; =========================================================
    ; Pass 2: International route slots (domestic_slots .. domestic+intl-1)
    ; =========================================================
    ; Reload bitfield mask using entity_bits ($FF08EC) instead of $FFA6A0
    move.w  d7, d0
    lsl.w   #$2, d0                 ; player_index * 4
    movea.l  #$00FF08EC,a0          ; entity_bits: second bitfield table ($10 bytes, 4 players)
    move.l  (a0,d0.w), d4           ; d4 = entity bitfield for player (from entity_bits)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0          ; category bitmask table
    and.l   (a0,d0.w), d4           ; d4 = filtered bitfield (international category)
    ; Point a2 at first international slot (starts after domestic_slots * $14)
    moveq   #$0,d0
    move.b  $4(a5), d0              ; d0 = domestic_slots count
    mulu.w  #$14, d0                ; d0 = domestic_slots * $14 (byte offset)
    move.w  d7, d1
    mulu.w  #$320, d1               ; d1 = player_index * $320
    add.w   d1, d0                  ; d0 = player_offset + intl_start_offset
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                  ; a2 = first international slot
    clr.w   d3                      ; reset slot counter
    bra.b   l_09c7c
l_09c0e:
    ; Skip empty slots
    cmpi.b  #$ff, (a2)              ; city_a == $FF?
    beq.b   l_09c76                 ; empty -> next slot
    ; Check city_a bit in international bitfield
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = city_a
    moveq   #$1,d1
    lsl.l   d0, d1                  ; d1 = 1 << city_a
    move.l  d1, d0
    and.l   d4, d0                  ; test city_a bit
    beq.b   l_09c76                 ; not in international filter -> skip
    ; Both endpoints go through $5E9FA city coordinate table (no arc-style table for intl)
    moveq   #$0,d0
    move.b  (a2), d0                ; d0 = city_a
    add.w   d0, d0                  ; x2 for word index
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4                  ; a4 = city_a map coordinate
    moveq   #$0,d0
    move.b  $1(a2), d0              ; d0 = city_b
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                  ; a3 = city_b map coordinate
    ; Color selection (same logic as pass 1)
    tst.w   d6
    bne.b   l_09c5e
    move.w  $e(a2), d0              ; actual_revenue
    cmp.w   $6(a2), d0              ; vs revenue_target
    bcs.b   l_09c5a
    moveq   #$1,d2                  ; profitable
    bra.b   l_09c60
l_09c5a:
    moveq   #$2,d2                  ; unprofitable
    bra.b   l_09c60
l_09c5e:
    moveq   #$3,d2                  ; forced/highlight
l_09c60:
    ; DrawRoutePair(a4=src, a3=dst, mode=1, color=d2)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w               ; draw mode = 1 (international arc)
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    bsr.w DrawRoutePair
    lea     $10(a7), a7
l_09c76:
    moveq   #$14,d0
    adda.l  d0, a2                  ; advance to next slot
    addq.w  #$1, d3
l_09c7c:
    ; Loop condition: d3 < player_record[+5].intl_slots
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a5), d1              ; d1 = player_record.intl_slots
    cmp.l   d1, d0
    blt.b   l_09c0e                 ; d3 < intl_slots -> next slot
    ; --- Phase: Finalize -- flush tile buffer to display ---
    pea     ($000C).w               ; GameCommand #$C = commit/flush tile write buffer
    jsr GameCommand
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
