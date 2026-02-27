; ============================================================================
; DrawQuarterResultsScreen -- Renders the full quarterly results screen with decompressed tile backgrounds, per-player score panels, route-flag icon strips, and divider markers for all four players.
; 1196 bytes | $026CD8-$027183
; ============================================================================
; --- Phase: Setup / Background Load ---
; This function renders the full quarterly results screen for all 4 players in a single pass.
; It iterates d7 = 0..3 (player index), advancing a2 through player_records ($FF0018 stride $24).
; d2 tracks the running horizontal pixel position (X) for icon strip placement.
; d4 tracks the vertical pixel position (Y) for each player's panel row.
; d6 = tile selector countdown ($3F..0), decremented as special tiles are consumed.
DrawQuarterResultsScreen:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF14B0,a5
    ; a5 = $FF14B0 (within tile_buf region): working pointer for LZ output / tile staging
    ; decompress quarterly-results background tileset from ROM into $FF1804 (save_buf_base)
    pea     ($0004E382).l
    ; $4E382 = ROM address of LZ-compressed background tileset for results screen
    pea     ($00FF1804).l
    ; output to save_buf_base ($FF1804)
    jsr LZ_Decompress
    ; DMA background tiles to VRAM: tile index $0308, palette group $0007, no flags, source $FF1804
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0007).w
    ; $0007 = VRAM command word upper (tile block destination selector)
    pea     ($0308).w
    ; $0308 = 776: number of tiles / words to transfer
    jsr VRAMBulkLoad
    ; DrawTileGrid: lay the decompressed tiles into the BAT (background attribute table)
    ; args: tile_index $0640, palette $0001, count $0007, source $FF1804
    pea     ($00FF1804).l
    pea     ($0007).w
    pea     ($0001).w
    pea     ($0640).w
    ; $0640 = tile ID base in VRAM for the results screen background grid
    jsr DrawTileGrid
    lea     $2c(a7), a7
    movea.l  #$00FF0018,a2
    ; a2 = $FF0018 = player_records base: will advance by $24 each player iteration
    moveq   #$3F,d6
    ; d6 = $3F = 63: available special-tile index counter (counts down as tiles are placed)
    clr.w   d7
    ; d7 = 0: player loop counter (0..3)
    movea.l  #$0004E378,a4
    ; a4 = $4E378: ROM pointer to even-count tile graphic (used as separator tile)
    movea.l  #$0004E37A,a3
    ; a3 = $4E37A: ROM pointer to odd-count tile graphic (used as fill tile in strips)
; --- Phase: Per-Player Panel Loop (d7 = player index, 0..3) ---
l_26d42:
    ; optional: if caller passed flag $A(a6) == 1, print player score above this panel
    cmpi.w  #$1, $a(a6)
    ; $A(a6) = stack argument: display-score flag (1 = show score text)
    bne.b   l_26d82
    ; compute screen X tile position for the score text: score = a5[player*2]
    ; formula: X = score * 6 + 5 (tiles)
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    ; d0 = player_index * 2 = word offset into a5 score table
    movea.l d0, a0
    move.w  (a5,a0.l), d0
    ; d0 = score value for this player from the table at a5
    andi.l  #$ffff, d0
    move.l  d0, d1
    add.l   d0, d0
    ; d0 = score * 2
    add.l   d1, d0
    ; d0 = score * 3
    add.l   d0, d0
    ; d0 = score * 6
    addq.l  #$5, d0
    ; d0 = score * 6 + 5: tile column for score label (left-justified offset)
    move.l  d0, -(a7)
    pea     ($0013).w
    ; row $13 = 19: fixed row for all player score labels
    jsr SetTextCursor
    ; PrintfWide with format $41584: print the player's score in wide font
    pea     ($00041584).l
    ; $41584 = ROM format string for score label (e.g. "%d pts")
    jsr PrintfWide
    lea     $c(a7), a7
; --- Phase: Player Panel Tile Placement ---
; Compute this player's vertical tile position (d4) from their score, and place the
; panel anchor tile. Then determine how many route-flag icons to draw (d5 = CountRouteFlags).
l_26d82:
    moveq   #$50,d2
    ; d2 = $50 = 80: initial horizontal pixel position for icon strip (reset each player)
    moveq   #$0,d0
    move.w  d7, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    ; d4 = player score from a5 table (word, indexed by player * 2)
    mulu.w  #$30, d4
    ; d4 *= $30 (48): vertical pixel scale factor per score unit
    addi.w  #$40, d4
    ; d4 += $40 (64): base Y offset -- panel row 0 starts at pixel 64
    ; d4 = panel Y pixel position for this player
    ; place panel anchor tile ($4E380) at computed tile coords (d4/8, d2/8)
    pea     ($0004E380).l
    ; $4E380 = ROM pointer to panel anchor/header tile graphic
    pea     ($0001).w
    pea     ($0001).w
    ; divide d4 (pixel Y) by 8 to get tile row -- with signed rounding
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26dae
    addq.l  #$7, d0
    ; add 7 before right-shift if negative to implement ceiling division
l_26dae:
    asr.l   #$3, d0
    ; d0 = d4 / 8 = tile row (arithmetic shift preserves sign)
    move.l  d0, -(a7)
    ; divide d2 (pixel X) by 8 to get tile column
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26dba
    addq.l  #$7, d0
l_26dba:
    asr.l   #$3, d0
    ; d0 = d2 / 8 = tile column
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    ; GameCommand #$1B: place tile at (col, row) in BAT
    jsr GameCommand
    addq.w  #$4, d2
    ; advance X position by 4 pixels (half-tile) past the anchor tile
    ; CountRouteFlags(player_index): count set bits in $FF08EC[player] route-flag longword, minus 1
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (CountRouteFlags,PC)
    ; d0 = number of route flags set for this player (0 = no routes)
    nop
    lea     $20(a7), a7
    move.w  d0, d5
    ; d5 = route flag count: how many icon tiles to draw in the strip
    beq.w   l_26ec0
    ; no route flags: skip icon strip entirely
    ; --- Draw route-flag icon strip (d5 flags, all set bits present) ---
    ; First: place a colored "active routes" tile at the current position using TilePlacement.
    ; TilePlacement args: tile_id $0644, tile_index d6, Y=d4, X=d2, 1×1, $8000 priority
    move.l  #$8000, -(a7)
    ; $8000 = high-priority tile flag (foreground plane)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    ; d4 = panel Y pixel position for this player
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    ; d2 = current X pixel position along the strip
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    ; d6 = current tile selector value (decremented each use)
    move.l  d0, -(a7)
    pea     ($0644).w
    ; tile_id $0644 = route-flag "set" icon tile in VRAM
    jsr TilePlacement
    ; GameCommand #$000E: advance display state / sync after tile placement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    ; d6 -= 1: consume one special tile slot
    addq.w  #$4, d2
    ; d2 += 4 pixels: step right past the placed tile
    clr.w   d3
    ; d3 = 0: strip segment counter (counts fill tiles placed between markers)
    bra.b   l_26e60
; --- Fill-tile inner loop for route-flag icon strip ---
; Places fill tiles ($4E37E) between route-flag icons; d3 counts tiles placed so far.
l_26e26:
    ; place a fill/separator tile ($4E37E) at current (d4, d2) position
    pea     ($0004E37E).l
    ; $4E37E = ROM ptr to route-flag strip fill tile
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e3c
    addq.l  #$7, d0
l_26e3c:
    asr.l   #$3, d0
    ; d0 = d4 / 8 = tile row
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26e48
    addq.l  #$7, d0
l_26e48:
    asr.l   #$3, d0
    ; d0 = d2 / 8 = tile column
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    ; GameCommand #$1B: place tile at (col, row) in BAT
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    ; step right 8 pixels (one full tile width)
    addq.w  #$1, d3
    ; d3 += 1: increment fill-tile count
l_26e60:
    ; loop condition: d3 < floor((d5-1) / 2)
    ; i.e. place floor(half) fill tiles between route-flag markers
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    ; d0 = d5 - 1
    bge.b   l_26e6a
    addq.l  #$1, d0
l_26e6a:
    asr.l   #$1, d0
    ; d0 = (d5-1) / 2 (signed halving with rounding)
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ; continue fill loop if d3 < (d5-1)/2
    bgt.b   l_26e26
    ; check if (d5-1) is odd: need an extra half-width tile at the end
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    ; d0 = d5 - 1
    moveq   #$2,d1
    ; SignedMod(d0, 2): d0 = (d5-1) mod 2
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ; if (d5-1) mod 2 != 1, strip count is even -- no trailing half-tile needed
    bne.b   l_26ec0
    ; place a trailing half-width tile ($4E37C) to cap the strip when count is odd
    pea     ($0004E37C).l
    ; $4E37C = ROM ptr to route-flag strip trailing/cap tile (narrower variant)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26e9e
    addq.l  #$7, d0
l_26e9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26eaa
    addq.l  #$7, d0
l_26eaa:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
    ; advance X 4 pixels (half-tile) past the trailing cap tile
; --- Phase: Remaining (empty/unused) Slot Icons ---
; After placing the filled route-flag icons, place icons for UNUSED slots.
; d5 is reused to hold the count of remaining empty slots to draw.
l_26ec0:
    moveq   #$0,d0
    move.b  $2(a2), d0
    ; d0 = player_record[+$02] (route_type_a: total slot count)
    sub.w   d5, d0
    ; subtract the number of flags already drawn (active routes)
    addi.w  #$ffff, d0
    ; -1: convert to 0-based count of remaining slots
    move.w  d0, d5
    ; d5 = remaining empty slot count to draw
    tst.w   d5
    ; if 0 remaining, nothing more to draw for this player
    beq.b   l_26f36
    ; check if current X position is aligned to 8-pixel boundary
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    ; SignedMod(d2, 8): check alignment
    jsr SignedMod
    tst.l   d0
    ; if d2 is already 8-pixel aligned, skip the alignment adjustment loop below
    bne.b   l_26f36
    clr.w   d3
    ; d3 = 0: reset fill-tile counter for second strip
    bra.b   l_26f1c
; --- Empty-slot fill tile inner loop ---
; Places fill tiles (a3 = $4E37A, odd-count tile) between empty-slot markers.
l_26ee6:
    ; place fill tile (a3) at current (d4, d2) position
    move.l  a3, -(a7)
    ; a3 = $4E37A = ROM ptr to odd-count fill tile
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ef8
    addq.l  #$7, d0
l_26ef8:
    asr.l   #$3, d0
    ; d0 = tile row
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f04
    addq.l  #$7, d0
l_26f04:
    asr.l   #$3, d0
    ; d0 = tile column
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    ; advance 8 pixels right
    addq.w  #$1, d3
    ; increment fill count
l_26f1c:
    ; loop condition: d3 < floor(d5 / 2) (same half-count logic as route icons above)
    moveq   #$0,d0
    move.w  d5, d0
    bge.b   l_26f24
    addq.l  #$1, d0
l_26f24:
    asr.l   #$1, d0
    ; d0 = d5 / 2
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ; keep looping until d3 reaches half of d5
    bgt.b   l_26ee6
    moveq   #$0,d0
    move.w  d5, d0
    ; pass d5 to the SignedMod below (no decrement -- different from route icon path)
    bra.w   l_26fd0
; --- Alternate path: X not 8-aligned -- place empty-slot colored tile first ---
; When d2 mod 8 != 0, place a TilePlacement "empty slot" icon ($0642) before fill tiles.
l_26f36:
    tst.w   d5
    ; if no remaining slots, skip this entire section
    beq.w   l_27012
    ; TilePlacement args: tile_id $0642 (empty-slot icon), d6 selector, Y=d4, X=d2, 1×1, $8000 priority
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    ; d4 = panel Y pixel position
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    ; d2 = current X pixel position
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    ; d6 = tile selector countdown
    move.l  d0, -(a7)
    pea     ($0642).w
    ; tile_id $0642 = empty slot icon tile (unoccupied route)
    jsr TilePlacement
    ; GameCommand #$000E: display sync step
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    ; consume one tile selector slot
    addq.w  #$4, d2
    ; advance 4 pixels
    clr.w   d3
    ; reset fill-tile counter
    bra.b   l_26fb6
; --- Second fill-tile inner loop (empty slot path) ---
; Same structure as l_26ee6: places fill tiles (a3) until half of d5 are placed.
l_26f80:
    move.l  a3, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26f92
    addq.l  #$7, d0
l_26f92:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26f9e
    addq.l  #$7, d0
l_26f9e:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_26fb6:
    ; loop condition: d3 < (d5-1)/2
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    bge.b   l_26fc0
    addq.l  #$1, d0
l_26fc0:
    asr.l   #$1, d0
    ; d0 = (d5-1)/2
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ; keep looping until fill count reaches (d5-1)/2
    bgt.b   l_26f80
    moveq   #$0,d0
    move.w  d5, d0
    subq.l  #$1, d0
    ; prepare (d5-1) for the odd-remainder check below
l_26fd0:
    ; check if (d5-1) mod 2 == 1: need a trailing half-tile cap
    moveq   #$2,d1
    ; SignedMod(d5-1, 2)
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ; if even, no trailing cap needed
    bne.b   l_27012
    ; place trailing even-count cap tile (a4 = $4E378) at current position
    move.l  a4, -(a7)
    ; a4 = $4E378 = ROM ptr to even-count/end-cap tile graphic
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_26ff0
    addq.l  #$7, d0
l_26ff0:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_26ffc
    addq.l  #$7, d0
l_26ffc:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$4, d2
    ; advance 4 pixels (half-tile) past trailing cap
; --- Phase: Route-type-B (international) slot icons ---
; Uses the same fill-strip algorithm again, but now for player_record[+$03] (route_type_b count).
l_27012:
    tst.b   $3(a2)
    ; player_record[+$03] = route_type_b count; 0 = no international routes
    beq.b   l_27084
    ; check 8-pixel X alignment before deciding which sub-path to use
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    ; if not aligned, go to the TilePlacement path (l_27084)
    bne.b   l_27084
    clr.w   d3
    ; d3 = 0: fill counter for this strip
    bra.b   l_27066
; --- Route-type-B fill-tile loop (aligned path) ---
; Uses tile $4E376 (a different fill tile variant for international routes)
l_2702c:
    pea     ($0004E376).l
    ; $4E376 = ROM ptr to international-route fill tile (different color/shape from domestic)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_27042
    addq.l  #$7, d0
l_27042:
    asr.l   #$3, d0
    ; tile row = d4 / 8
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_2704e
    addq.l  #$7, d0
l_2704e:
    asr.l   #$3, d0
    ; tile column = d2 / 8
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
    ; d3 = fill count for this strip
l_27066:
    ; loop condition: d3 < floor(route_type_b / 2)
    moveq   #$0,d0
    move.b  $3(a2), d0
    ; player_record[+$03] = route_type_b (international slot count)
    bge.b   l_27070
    addq.l  #$1, d0
l_27070:
    asr.l   #$1, d0
    ; d0 = route_type_b / 2
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ; loop until d3 reaches half of route_type_b
    bgt.b   l_2702c
    moveq   #$0,d0
    move.b  $3(a2), d0
    ; pass route_type_b to the odd-remainder check (shared at l_27128)
    bra.w   l_27128
; --- Route-type-B unaligned path: place TilePlacement icon first then fill ---
l_27084:
    tst.b   $3(a2)
    ; route_type_b == 0: nothing to draw, skip to player advance
    beq.w   l_2716c
    ; TilePlacement args: tile_id $0640 (international route icon), d6 selector, Y=d4, X=d2, $8000
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0640).w
    ; tile_id $0640 = international route presence icon (colored marker tile)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    subq.w  #$1, d6
    addq.w  #$4, d2
    clr.w   d3
    bra.b   l_2710a
; --- Route-type-B unaligned fill loop ---
; Same as l_2702c but entered from the unaligned (TilePlacement) path
l_270d0:
    pea     ($0004E376).l
    ; same international fill tile
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_270e6
    addq.l  #$7, d0
l_270e6:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_270f2
    addq.l  #$7, d0
l_270f2:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    addq.w  #$8, d2
    addq.w  #$1, d3
l_2710a:
    ; loop condition: d3 < (route_type_b - 1) / 2
    moveq   #$0,d0
    move.b  $3(a2), d0
    ; player_record[+$03] = route_type_b
    subq.l  #$1, d0
    bge.b   l_27116
    addq.l  #$1, d0
l_27116:
    asr.l   #$1, d0
    ; d0 = (route_type_b - 1) / 2
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    ; loop until fill count reaches that threshold
    bgt.b   l_270d0
    moveq   #$0,d0
    move.b  $3(a2), d0
    subq.l  #$1, d0
    ; prepare (route_type_b - 1) for odd-remainder test
l_27128:
    ; shared trailing-cap logic for route_type_b strip: if (count-1) mod 2 == 1, add cap tile
    moveq   #$2,d1
    ; SignedMod((route_type_b - 1), 2)
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ; if even: no trailing cap -- advance to next player
    bne.b   l_2716c
    ; place international route trailing cap tile ($4E374) at current position
    pea     ($0004E374).l
    ; $4E374 = ROM ptr to international-route strip end-cap tile
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    bge.b   l_2714c
    addq.l  #$7, d0
l_2714c:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_27158
    addq.l  #$7, d0
l_27158:
    asr.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
; --- Phase: Advance to Next Player ---
l_2716c:
    moveq   #$24,d0
    adda.l  d0, a2
    ; a2 += $24: advance to next player record (stride 36 bytes in player_records)
    addq.w  #$1, d7
    ; d7 = next player index
    cmpi.w  #$4, d7
    ; loop until all 4 players processed
    bcs.w   l_26d42
    ; --- Phase: Return ---
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
