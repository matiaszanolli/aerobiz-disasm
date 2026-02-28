; ============================================================================
; FormatRouteDetails -- Formats and renders the route details screen; clears display, decompresses background tiles, builds city-pair rows with profit indicators, and calls ShowDialog.
; 872 bytes | $0127D6-$012B3D
; ============================================================================
; --- Phase: Setup ---
FormatRouteDetails:
    link    a6,#-$140
    movem.l d2-d7/a2-a5, -(a7)
    ; d4 = region/player index (arg 2, from $C(a6))
    ; d7 = player index (arg 1, from $8(a6))
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    ; Ensure background resource is loaded before rendering
    jsr ResourceLoad
    ; Zero the 80-byte ($50) stack buffer at -$50(a6) -- used as a text assembly area
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$50(a6)
    jsr MemFillByte
    ; Wipe both scroll planes before drawing the route details screen
    jsr ClearBothPlanes
    ; --- Phase: Decompress Background Tiles ---
    ; Index into pointer table at $9511C with d4 (region), yielding the LZ stream address
    ; Each entry is 4 bytes (longword pointer), so d4*4 = byte offset into table
    moveq   #$0,d0
    move.w  d4, d0
    lsl.l   #$2, d0
    movea.l  #$0009511C,a0
    move.l  (a0,d0.l), -(a7)
    ; Decompress the region background tiles to save_buf_base ($FF1804)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $14(a7), a7
    ; --- Phase: Iterate Route Slots ---
    ; d5 = row counter (starting at row 7, where route entries begin on screen)
    moveq   #$7,d5
    ; Locate player record: base $FF0018 + player_index * $24 (stride = 36 bytes/player)
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    ; a5 = pointer to this player's record (player_records base)
    movea.l a0, a5
    ; Compute base address of first route slot for this player in route_slots ($FF9A20)
    ; player_record+$4 = domestic_slots count; used as starting slot index
    moveq   #$0,d0
    move.b  $4(a5), d0
    ; slot_offset = domestic_slots * $14 (20 bytes per slot)
    mulu.w  #$14, d0
    ; player_offset = player_index * $320 (800 bytes per player block)
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    ; a2 = pointer to first slot to examine in this player's route block
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; d6 = count of profitable/matching routes found (for conditional text later)
    clr.w   d6
    ; d2 = slot iterator (counts slots examined so far)
    clr.w   d2
    bra.w   .l12942
; --- Phase: Slot Loop Body ---
.l1285c:
    ; Read slot+$00 = city_a (source city index), look up its region via RangeLookup
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    ; RangeLookup maps city index to a region code (0-7)
    jsr RangeLookup
    addq.l  #$4, a7
    ; d0 = region code for city_a; compare against d4 (selected region filter)
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    ; Skip slot if it's not in the player's selected region
    cmp.l   d1, d0
    bne.w   .l1293c
    ; Check slot+$0A status_flags bit 7 ($80 = pending/active update flag)
    ; Only display slots that have this flag set (i.e., active/pending routes)
    move.b  $a(a2), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    bne.w   .l1293c
    ; --- Look up city name entries for both endpoints ---
    ; city_a entry: $5E9FA is a ROM table of city name/info pairs indexed by city_index*2
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a4 = pointer to city_a info entry (source city)
    movea.l a0, a4
    ; city_b entry (destination city), same table
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a3 = pointer to city_b info entry (destination city)
    movea.l a0, a3
    ; --- Determine profitability indicator ---
    ; slot+$0E = actual_revenue, slot+$06 = revenue_target
    ; d3 = 1 if actual >= target (profitable), 2 if below (unprofitable)
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   .l128c4
    moveq   #$1,d3
    bra.b   .l128c6
.l128c4:
    ; actual_revenue < revenue_target: route is running at a loss
    moveq   #$2,d3
.l128c6:
    ; Draw the paired route display (city A <-> city B, with d3 profit icon)
    ; Args: city_a ptr, city_b ptr, indicator type 4, profit flag d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    ; DrawRoutePair: places the city-pair row including icons and names
    jsr DrawRoutePair
    ; --- Place relation indicator tile for this route ---
    ; GetCharRelation returns a status code ($760-$765) for the player-character pair
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    ; city_b+$01 = second info byte (nationality/type of destination)
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    ; city_b+$00 = first info byte
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    ; d5 = current screen row for this route entry
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; slot+$01 = city_b index (destination city)
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    ; d4 = region filter index
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    ; d7 = player index
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    ; GetCharRelation: returns relationship status code for player vs character
    jsr GetCharRelation
    lea     $c(a7), a7
    move.l  d0, -(a7)
    ; Place the relation icon tile at the computed position
    jsr TilePlacement
    lea     $2c(a7), a7
    ; GameCommand #$E with arg 1: flush/trigger the tile write to display
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    ; Advance row counter and matching-route count
    addq.w  #$1, d5
    addq.w  #$1, d6
.l1293c:
    ; Advance to next slot: each slot is $14 (20) bytes
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
; --- Phase: Loop Condition ---
.l12942:
    ; Loop until d2 >= player_record+$05 (intl_slots count = total slots to scan)
    moveq   #$0,d0
    move.b  $5(a5), d0
    cmp.w   d2, d0
    bhi.w   .l1285c
; --- Phase: Render Background and Extra City Tile ---
    ; Place the decompressed background tile block ($2E0 = 736 tiles) from save_buf_base
    pea     ($02E0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    ; DisplaySetup with 16x16 window at ROM addr $7677E (status/info overlay)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $18(a7), a7
    ; d3 = count of "extra" (non-route) city tiles placed (used for summary text later)
    clr.w   d3
    ; --- Compute bitmask of player's alliance/active cities ---
    ; $5ECDC is a ROM table: entry d4*4 = bitmask of cities for that region
    ; $10(a6) = arg 3 (alliance bitmask passed in by caller)
    ; AND narrows to only cities the player is currently active in
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    and.l   $10(a6), d0
    ; d4 now = filtered city bitmask (player's cities in this region)
    move.l  d0, d4
    ; If no cities active in this region, skip the extra tile
    beq.b   .l129f6
    ; --- Find lowest set bit in d4 (first active city index) ---
    clr.w   d2
.l12994:
    ; Shift 1 left by d2 and compare with bitmask to find bit position
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    cmp.l   d4, d0
    beq.b   .l129aa
    addq.w  #$1, d2
    ; Scan up to 32 bits (all cities)
    cmpi.w  #$20, d2
    bcs.b   .l12994
.l129aa:
    ; d2 = city index of the first active city; look up its info entry
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    ; a4 = pointer to city info entry for the extra city
    movea.l a0, a4
    ; Place a special tile ($0761 = city-icon tile ID) at the next available row
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    ; city info byte 1 (e.g., type or country)
    moveq   #$0,d0
    move.b  $1(a4), d0
    move.l  d0, -(a7)
    ; city info byte 0 (e.g., continent/region code)
    moveq   #$0,d0
    move.b  (a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    ; $0761 = tile ID for the extra alliance/hub city marker icon
    pea     ($0761).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    ; Increment extra-city counter (used to choose singular/plural summary string)
    addq.w  #$1, d3
; --- Phase: Build Summary Text and Show Dialog ---
.l129f6:
    ; GameCommand #$1B: write tile block from ROM ptr $70198 at position (col=$20, row=$17)
    ; This places the info panel frame or header graphic
    pea     ($00070198).l
    pea     ($0017).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    ; --- Format "extra city" count string into buffer at -$A0(a6) ---
    ; d3 = number of extra (alliance) cities placed; choose singular vs plural template
    cmpi.w  #$1, d3
    bne.b   .l12a34
    ; Singular: "1 city" -- ROM string at $3F258
    pea     ($0003F258).l
    pea     -$a0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a4e
.l12a34:
    ; Plural: "%d cities" -- format string pointer loaded from $4799A
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$a0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a4e:
    ; --- Format matching-route count string into buffer at -$F0(a6) ---
    ; d6 = number of route-match slots found; choose singular vs plural
    cmpi.w  #$1, d6
    bne.b   .l12a68
    ; Singular: "1 route" -- ROM string at $3F250
    pea     ($0003F250).l
    pea     -$f0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a82
.l12a68:
    ; Plural: "%d routes" -- format string pointer from $4799E
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$f0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a82:
    ; --- Combine city and route strings into the final -$140 summary buffer ---
    ; If no matching routes (d6==0): show only city string (e.g., "0 routes, 1 city")
    tst.w   d6
    bne.b   .l12aa0
    ; No routes: combine just the city-count string with a fixed ROM template ($3F24C)
    pea     -$a0(a6)
    pea     ($0003F24C).l
.l12a90:
    pea     -$140(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   .l12acc
.l12aa0:
    ; Routes exist: if no extra cities (d3==0), use cities-only template ($3F248)
    tst.w   d3
    bne.b   .l12ab0
    pea     -$f0(a6)
    pea     ($0003F248).l
    bra.b   .l12a90
.l12ab0:
    ; Both routes and extra cities: combine both sub-strings via template at $479A2
    pea     -$f0(a6)
    pea     -$a0(a6)
    move.l  ($000479A2).l, -(a7)
    pea     -$140(a6)
    jsr sprintf
    lea     $10(a7), a7
.l12acc:
    ; Wrap the summary string into the final display buffer at -$50(a6)
    ; Template at $479A6 adds outer formatting (e.g., box/title frame)
    pea     -$140(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$50(a6)
    jsr sprintf
    ; Release the background resource now that tiles are placed
    jsr ResourceUnload
    ; --- Show the route details dialog ---
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    ; ShowDialog: display the formatted text for player d7
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    ; If there were matching routes, update character stat field for those routes
    tst.w   d6
    beq.b   .l12b1a
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    ; GetCharStatField: record the route count into the character's stat record
    jsr (GetCharStatField,PC)
    nop
    addq.l  #$8, a7
.l12b1a:
    ; --- Show final follow-up dialog (e.g., confirmation or score reveal) ---
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    ; Format string pointer from $479AA (final screen text)
    move.l  ($000479AA).l, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    ; ShowDialog: show the closing summary for player d7
    jsr ShowDialog
    movem.l -$168(a6), d2-d7/a2-a5
    unlk    a6
    rts
