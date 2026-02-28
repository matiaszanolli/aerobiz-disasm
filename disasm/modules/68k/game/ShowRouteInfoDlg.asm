; ============================================================================
; ShowRouteInfoDlg -- Displays a route-info dialog showing pending city-pair relation entries; scans pending slots, formats city names from lookup table, and prints them.
; 706 bytes | $012514-$0127D5
; ============================================================================
ShowRouteInfoDlg:
; --- Phase: Setup ---
; Args: $A(a6) = player_index, $C(a6) = city_bitmask (longword, 1 bit per city index)
; d2 = slot scan index (0..$27 = 40 slots), d4 = pending_relation_count (established routes)
; d3 = established_city_count (cities with bit set in $C(a6))
; d5, d6, d7 = city name lookup fields (low/high byte pairs from $5E948 name table)
; a2 = city_a name pointer, a4 = city_b name pointer
; a3 = current route slot pointer (a0 base + slot*$14)
; a5 = sprintf ($3B22C) for text formatting
; Stack frame: -$a0(a6) = 80-byte result string buffer (final dialog message)
;              -$f0(a6) = city-count string buffer
;              -$140(a6) = relation-count string buffer
;              -$190(a6) = combined format buffer (both counts together)
    link    a6,#-$190
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$0003B22C,a5       ; a5 = sprintf ($3B22C)
; MemFillByte: zero the 80-byte result buffer at -$a0(a6) before use
    pea     ($0050).w            ; count = $50 (80) bytes
    clr.l   -(a7)                ; fill value = 0
    pea     -$a0(a6)             ; dest = result buffer
    jsr MemFillByte
; ResourceLoad: load graphics/tile resource for the route info screen
    jsr ResourceLoad
; PreLoopInit: one-time display/timer initialization before main logic
    jsr PreLoopInit
; LZ_Decompress: decompress background tile data from ROM $95118 to save_buf_base ($FF1804)
    move.l  ($00095118).l, -(a7) ; ROM source pointer (compressed tile data for this screen)
    pea     ($00FF1804).l        ; dest = save_buf_base ($FF1804)
    jsr LZ_Decompress
    lea     $14(a7), a7

; --- Phase: Compute Route Slot Base for This Player ---
; route_slots($FF9A20) + player_index * $320 bytes (40 slots × $14 bytes each = $320 per player)
    move.w  $a(a6), d0           ; d0 = player_index
    mulu.w  #$320, d0            ; d0 = player offset ($320 = 800 bytes per player)
    movea.l  #$00FF9A20,a0       ; a0 = route slot array base
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 = pointer to slot 0 for this player
    clr.w   d2                   ; d2 = slot scan index (0..39)
    clr.w   d4                   ; d4 = pending_relation_count (slots with pending city-pair)
    bra.w   .l12606              ; jump to loop condition check first

; --- Phase: Pending Route Slot Scan Loop ---
; Scan all 40 route slots for this player; for each slot that has:
;   - city_a != $FF (not empty sentinel), AND
;   - status_flags bit 7 ($80) set (slot is established/active)
; Look up both city names from $5E948 (city name byte-pair table), order alphabetically,
; then call DrawTilemapLineWrap to render the city-pair as a tile map line.
.l12570:
; Skip slot if city_a == $FF (empty sentinel, slot is unused)
    cmpi.b  #$ff, (a3)           ; route_slot+$0 = city_a: $FF = empty
    beq.w   .l12600              ; empty slot: skip
; Skip slot if status_flags bit 7 is clear (slot not yet established)
    move.b  $a(a3), d0           ; route_slot+$A = status_flags byte
    andi.l  #$80, d0             ; isolate bit 7: set = slot active/established
    beq.b   .l12600              ; bit clear: slot pending, skip

; --- City A lookup: name bytes from ROM $5E948 table ---
; $5E948 is a 2-byte-per-city name-index table; each entry holds a name string pair.
; city_index * 2 gives byte offset into the table; result is a 2-byte name descriptor.
    moveq   #$0,d0
    move.b  (a3), d0             ; d0 = city_a index (route_slot+$0)
    add.w   d0, d0               ; d0 = city_a * 2 (stride into name table)
    movea.l  #$0005E948,a0       ; a0 = city name byte-pair table base
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 = pointer to city_a name entry

; --- City B lookup ---
    moveq   #$0,d0
    move.b  $1(a3), d0           ; d0 = city_b index (route_slot+$1)
    add.w   d0, d0               ; d0 = city_b * 2
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4               ; a4 = pointer to city_b name entry

; --- Alphabetical ordering: ensure city_a name byte < city_b name byte ---
; Compare first byte of each name entry to sort the pair for consistent display.
    move.b  (a2), d0             ; d0 = city_a name byte[0]
    cmp.b   (a4), d0             ; compare with city_b name byte[0]
    bcc.b   .l125c6              ; city_a >= city_b: swap so smaller comes first
; city_a < city_b: assign d3/d7 = city_a, d6/d5 = city_b
    moveq   #$0,d3
    move.b  (a2), d3             ; d3 = city_a name byte[0]
    moveq   #$0,d7
    move.b  $1(a2), d7           ; d7 = city_a name byte[1]
    moveq   #$0,d6
    move.b  (a4), d6             ; d6 = city_b name byte[0]
    moveq   #$0,d5
    move.b  $1(a4), d5           ; d5 = city_b name byte[1]
    bra.b   .l125da
.l125c6:
; city_a >= city_b: swap -- assign d6/d5 = city_a, d3/d7 = city_b
    moveq   #$0,d6
    move.b  (a2), d6             ; d6 = city_a name byte[0] (now the "second" city)
    moveq   #$0,d5
    move.b  $1(a2), d5           ; d5 = city_a name byte[1]
    moveq   #$0,d3
    move.b  (a4), d3             ; d3 = city_b name byte[0] (now the "first" city)
    moveq   #$0,d7
    move.b  $1(a4), d7           ; d7 = city_b name byte[1]

.l125da:
; DrawTilemapLineWrap: render one tile-map line for this city-pair into the background buffer
; Args: dest=$FF1804 (save_buf), mode=1, city_b_high=d5, city_b_low=d6, city_a_high=d7, city_a_low=d3
    pea     ($00FF1804).l        ; dest = save_buf_base tile buffer
    pea     ($0001).w            ; mode = 1 (draw one relation line)
    move.w  d5, d0
    move.l  d0, -(a7)            ; city_b name byte[1] (high descriptor)
    move.w  d6, d0
    move.l  d0, -(a7)            ; city_b name byte[0] (low descriptor)
    move.w  d7, d0
    move.l  d0, -(a7)            ; city_a name byte[1]
    move.w  d3, d0
    move.l  d0, -(a7)            ; city_a name byte[0]
    jsr DrawTilemapLineWrap
    lea     $18(a7), a7
    addq.w  #$1, d4              ; d4++: one more pending city-pair relation found

; Advance slot pointer and index; check loop condition
.l12600:
    moveq   #$14,d0
    adda.l  d0, a3               ; a3 += $14: advance to next route slot
    addq.w  #$1, d2              ; d2++: next slot index
.l12606:
    cmpi.w  #$28, d2             ; scanned all 40 slots ($28)?
    blt.w   .l12570              ; no: scan next slot

; --- Phase: City Bitmask Scan (count established cities) ---
; Scan 32 city indices (0..$1F); for each bit set in $C(a6) (city_bitmask longword),
; place a marker tile ($761) at the corresponding city position in the tile map.
; d2 = city bit index (0..31), d3 = established city count
; a2 = walking pointer into $5E948 city name table (2 bytes per entry)
    movea.l  #$0005E948,a2       ; a2 = city name table base (walk entry by entry)
    clr.w   d2                   ; d2 = city bit index
    clr.w   d3                   ; d3 = established city count
    bra.b   .l12670              ; jump to condition check first
.l1261a:
; Build bitmask for this city index: 1 << d2
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1               ; d1 = (1 << d2): bitmask for city d2
    move.l  d1, d0
    and.l   $c(a6), d0           ; test bit against caller's city_bitmask parameter
    beq.b   .l1266c              ; bit clear: this city not established, skip
; City is established: place marker tile
; TilePlacement: place tile $761 (city marker) at computed row/col position
; Row = city_name[0] - 4 (maps name byte to screen row), Col = city_name[1] - 4
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0           ; d0 = city name byte[1] (column offset in name table)
    subq.l  #$4, d0              ; col = name_byte1 - 4 (offset to screen column)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0             ; d0 = city name byte[0] (row offset in name table)
    subq.l  #$4, d0              ; row = name_byte0 - 4
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$7, d0              ; tile row = city_index + 7 (screen row offset)
    move.l  d0, -(a7)
    pea     ($0761).w            ; tile $761 = city established marker
    jsr TilePlacement
; GameCommand #$E: flush tile placement to display
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d3              ; d3++: count established city
.l1266c:
    addq.l  #$2, a2              ; a2 += 2: advance to next city name entry ($5E948 stride)
    addq.w  #$1, d2              ; d2++: next city bit
.l12670:
    cmpi.w  #$20, d2             ; checked all 32 city bits?
    blt.b   .l1261a              ; no: check next city

; --- Phase: Finalize Tile Display ---
; Place the tile map result and load the text window for the dialog
; CmdPlaceTile2: place the rendered tile buffer ($FF1804) into the display at col $2C0, row 1
    pea     ($02C0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
; GameCommand #$1B: configure display window at ROM $70198
; Params: addr=$70198, width=$20, height=$14, row=0, col=0, layer 1
    pea     ($00070198).l
    pea     ($0014).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
; DisplaySetup: configure text window at ROM $7677E (16 wide, 16 tall)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $c(a7), a7

; --- Phase: Format City-Count String ---
; Format singular ("1 city") or plural ("%d cities") into -$f0(a6) buffer
; d3 = established city count (from bitmask scan above)
    cmpi.w  #$1, d3
    bne.b   .l126dc              ; count != 1: use plural format
; Exactly 1 city: use singular format string from ROM $3F238
    pea     ($0003F238).l        ; ROM string: "1 city" (singular)
    pea     -$f0(a6)             ; dest: city-count string buffer
    jsr     (a5)                 ; sprintf -> -$f0(a6)
    addq.l  #$8, a7
    bra.b   .l126f2
.l126dc:
; More than 1 city: format "%d cities" with count d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; push city count value
    move.l  ($0004799A).l, -(a7) ; push ROM format string pointer for plural city count
    pea     -$f0(a6)             ; dest: city-count string buffer
    jsr     (a5)                 ; sprintf -> -$f0(a6)
    lea     $c(a7), a7

; --- Phase: Format Relation-Count String ---
; Format singular or plural relation-count string into -$140(a6) buffer
; d4 = pending_relation_count (routes added during slot scan above)
.l126f2:
    cmpi.w  #$1, d4
    bne.b   .l12708              ; count != 1: use plural format
; Exactly 1 relation: use singular format string from ROM $3F230
    pea     ($0003F230).l        ; ROM string: "1 route" (singular)
    pea     -$140(a6)            ; dest: relation-count string buffer
    jsr     (a5)                 ; sprintf -> -$140(a6)
    addq.l  #$8, a7
    bra.b   .l1271e
.l12708:
; More than 1 relation: format "%d routes" with count d4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)            ; push relation count value
    move.l  ($0004799E).l, -(a7) ; push ROM format string pointer for plural route count
    pea     -$140(a6)            ; dest: relation-count string buffer
    jsr     (a5)                 ; sprintf -> -$140(a6)
    lea     $c(a7), a7

; --- Phase: Combine Counts into Final Dialog String ---
; Build the complete dialog message in -$190(a6) by combining city-count and relation-count strings.
; Logic: if d4 == 0 (no pending routes): only show city-count string.
;        if d3 == 0 (no established cities): only show route-count string.
;        otherwise: combine both with ROM format string at $479A2 (e.g., "%s and %s").
.l1271e:
    tst.w   d4                   ; any pending routes (relation_count > 0)?
    bne.b   .l12738              ; yes: go check city count too
; d4 == 0: no pending routes -- use city-count string only
    pea     -$f0(a6)             ; push city-count string (-$f0(a6))
    pea     ($0003F22C).l        ; push ROM format: city-only message template
.l1272c:
; Common sprintf: format combined message -> -$190(a6) result buffer
    pea     -$190(a6)            ; dest = combined dialog string buffer
    jsr     (a5)                 ; sprintf -> -$190(a6)
    lea     $c(a7), a7
    bra.b   .l12760

.l12738:
; d4 > 0: have pending routes -- check if city count is also nonzero
    tst.w   d3                   ; any established cities (d3 > 0)?
    bne.b   .l12748              ; yes: combine both strings
; d3 == 0: no established cities -- use route-count string only
    pea     -$140(a6)            ; push route-count string (-$140(a6))
    pea     ($0003F228).l        ; push ROM format: route-only message template
    bra.b   .l1272c

.l12748:
; Both d3 and d4 nonzero: format both city-count and route-count into combined message
    pea     -$140(a6)            ; push route-count string
    pea     -$f0(a6)             ; push city-count string
    move.l  ($000479A2).l, -(a7) ; push ROM format: "%s and %s" combined template
    pea     -$190(a6)            ; dest = combined string buffer
    jsr     (a5)                 ; sprintf -> -$190(a6)
    lea     $10(a7), a7

; --- Phase: Build Final Result String ---
; Wrap -$190(a6) into the final 80-byte result buffer -$a0(a6) using ROM wrapper format
.l12760:
    pea     -$190(a6)            ; push combined message string
    move.l  ($000479A6).l, -(a7) ; push ROM final wrapper format string pointer
    pea     -$a0(a6)             ; dest = final result buffer
    jsr     (a5)                 ; sprintf -> -$a0(a6)
    jsr ResourceUnload           ; release graphics resource

; --- Phase: Show Dialog and Stat Browser ---
; ShowDialog: display the formatted route info dialog to the player
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$a0(a6)             ; push result string as dialog text
    move.w  $a(a6), d0           ; d0 = player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog               ; show dialog; waits for A/B button
    lea     $20(a7), a7
; If any pending routes were found (d4 > 0), open the char stat browser for selection
    tst.w   d4
    ble.b   .l127ae              ; d4 <= 0: no routes to select, skip stat browser
; GetCharStatField: interactive char-stat browser; arg 0 = d4 (slot count), arg 1 = player_index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)            ; push pending_relation_count as mode/arg
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)            ; push player_index
    jsr (GetCharStatField,PC)    ; open interactive char stat browser for pending routes
    nop
    addq.l  #$8, a7

; --- Phase: Final Summary Dialog ---
.l127ae:
; ShowDialog: show a final summary dialog using ROM string $479AA, player_index
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000479AA).l, -(a7) ; ROM format string for final summary message
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  d0, d2               ; d2 = ShowDialog return value (button pressed)
    movem.l -$1b8(a6), d2-d7/a2-a5
    unlk    a6
    rts
