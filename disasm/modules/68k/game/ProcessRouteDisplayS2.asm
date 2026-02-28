; ============================================================================
; ProcessRouteDisplayS2 -- Renders one route-panel subview for a player: computes stat change and revenue for the selected route type, displays the revenue figure and occupancy bar, draws a proportional colored tile strip, and decompresses and places the plane graphic.
; 918 bytes | $02A0DE-$02A473
; ============================================================================
ProcessRouteDisplayS2:
; --- Phase: Frame Setup ---
; Args: $8(a6) = player_index (d4), $C(a6) = route_type_index (d6)
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
; Load player index and route type from stack frame
    move.l  $8(a6), d4
    move.l  $c(a6), d6
; a3 = &frame_local_word (column start for text cursor), a4 = &frame_local_stat_word
    lea     -$8(a6), a3
    lea     -$2(a6), a4
; a5 = $FF0120 = char_stat_subtab base (4 bytes per player, byte per entry)
    movea.l  #$00FF0120,a5
; Open a 32×32 text window covering the full panel area
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
; Compute column start for this route_type: col = route_type * 9 + 3
; (Each route type occupies 9 tile columns; +3 is a left-margin adjustment)
    move.w  d6, d0
    mulu.w  #$9, d0
    addq.w  #$3, d0
    move.w  d0, (a3)
; d7 = 10 = base row constant (row offset into the panel for revenue display)
    moveq   #$A,d7
; d3 = 0: stat accumulator (summed across all players later)
    clr.w   d3
; Compute offset into char_stat_subtab: player_index * 4, load as address offset
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$2, d0
; a0 = &char_stat_subtab[player_index]  (4-byte block for this player)
    lea     (a5,d0.l), a0
    movea.l a0, a2
; Dispatch on route_type_index to the matching stat-change/revenue branch
    move.w  d6, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_2a148
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_2a1cc
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_2a250
    bra.w   l_2a2d0
; --- Phase: Route Type 0 (Domestic) ---
l_2a148:
; d2 = 0 = mode for CalcStatChange (domestic)
    clr.w   d2
; Compute offset into Expense Table B ($FF03F0, stride $C): player_index * $C
; $FF03F9 = base + 9 = field at offset +$09 within the 12-byte per-player block
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03F9,a0
    move.b  (a0,d0.w), d5
; d5 = stat threshold byte for domestic route type (from expense_tab_b transient field)
    andi.l  #$ff, d5
; Push args for CalcStatChange(player_index, mode=0, stat_threshold)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
; CalcStatChange: returns attribute modification amount for the given mode, clamped
    jsr CalcStatChange
    lea     $c(a7), a7
; Add char_stat_subtab[player]+$01 (primary skill field) to stat change result
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
; a2+$01 = char_stat_subtab[player].field_01 = primary skill/rating stat (stat_record+$01)
    add.l   d1, d0
; Push args for CalcRevenue(player_index, mode=0, adjusted_stat)
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
; CalcRevenue: 3-mode income calculation (compat/roster/network) -> D0 = revenue longword
    jsr CalcRevenue
    lea     $c(a7), a7
; Save revenue at -$6(a6) (local frame variable)
    move.l  d0, -$6(a6)
; Read primary stat again to store as the displayed occupancy value
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d0, (a4)
; Loop: accumulate field_01 from all 4 players into d3 (total-occupancy sum)
    clr.w   d2
l_2a1ac:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
; Access char_stat_subtab[d2].field_01: stride 4 into a5-based table
    movea.l d0, a0
    move.b  $1(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
; Repeat for each of the 4 player records
    blt.b   l_2a1ac
    bra.w   l_2a2d0
; --- Phase: Route Type 1 (International) ---
l_2a1cc:
; d2 = 2 = mode for CalcStatChange (international)
    moveq   #$2,d2
; $FF03FB = expense_tab_b[player]+$0B (transient byte for international route type)
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FB,a0
    move.b  (a0,d0.w), d5
; d5 = international stat threshold byte
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
; Add primary stat field to stat change result (same pattern as type 0)
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
; For international routes: display stat field +$03 (cap/limit value) as occupancy
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d0, (a4)
; Accumulate field_03 across all 4 players
    clr.w   d2
l_2a230:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $3(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a230
    bra.w   l_2a2d0
; --- Phase: Route Type 2 (Charter/Alliance) ---
l_2a250:
; d2 = 1 = mode for CalcStatChange (charter)
    moveq   #$1,d2
; $FF03FA = expense_tab_b[player]+$0A (second transient byte, charter route type)
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FF03FA,a0
    move.b  (a0,d0.w), d5
; d5 = charter stat threshold byte
    andi.l  #$ff, d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcStatChange
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRevenue
    lea     $c(a7), a7
    move.l  d0, -$6(a6)
; For charter routes: display stat field +$02 (secondary stat / index) as occupancy
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.w  d0, (a4)
; Accumulate field_02 across all 4 players
    clr.w   d2
l_2a2b4:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.b  $2(a5, a0.l), d0
    andi.l  #$ff, d0
    add.w   d0, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_2a2b4
; --- Phase: Revenue Display ---
l_2a2d0:
; Place text cursor at (d7-1, col_start) = (row 9, col_start) for revenue number
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
; SetTextCursor(row, col): positions text cursor for upcoming printf
    jsr SetTextCursor
; Print revenue figure using narrow font with format string at ROM $42118
    move.l  -$6(a6), -(a7)
; Format string at $42118 likely produces a right-aligned integer (revenue in thousands)
    pea     ($00042118).l
    jsr PrintfNarrow
; Place cursor at (d7+1, col_start+4) = (row 11, col_start+4) for occupancy stat
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
; Print occupancy value (seat fill / load factor) with wide font, format at $42114
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00042114).l
    jsr PrintfWide
    lea     $20(a7), a7
; --- Phase: Occupancy Bar Rendering ---
; Compute proportional bar width: occupancy_value * 64 / 100
; (Scales a 0-100 stat value to a 0-64 tile strip width)
    pea     ($0001).w
    pea     ($0008).w
    move.w  (a4), d0
    ext.l   d0
    lsl.l   #$6, d0
; Multiply by 64 (lsl #6), then divide by $64 (100) = percentage to tile count
    moveq   #$64,d1
    jsr SignedDiv
; RenderTileStrip: draws the horizontal occupancy bar with d0 tiles at the given position
    move.l  d0, -(a7)
    move.w  d7, d0
    addq.w  #$3, d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    move.l  d0, -(a7)
    jsr RenderTileStrip
; --- Phase: Plane Icon Placement (color coded by performance) ---
; d3 = total accumulated stat across all 4 players
; Sign-extend and arithmetic-shift-right by 2 to get average (rounding negative values)
    move.w  d3, d0
    ext.l   d0
    bge.b   l_2a350
; Negative value: add 3 before arithmetic shift to round toward zero
    addq.l  #$3, d0
l_2a350:
    asr.l   #$2, d0
; d3 = average occupancy across all players (0-100 range expected)
    move.w  d0, d3
; Threshold $32 (50): below 50% average -> show small/low-tier plane icon (tile $0640)
    cmpi.w  #$32, d3
    bge.b   l_2a3ac
; --- Low occupancy path: tile $0640 (smaller/economy plane graphic) ---
; d2 = 3 = tile size parameter for TilePlacement (3×3 tile block)
    moveq   #$3,d2
; Priority flag $8000 = display plane tile at high priority
    move.l  #$8000, -(a7)
; 3-tile sprite dimensions
    pea     ($0003).w
    pea     ($0003).w
; Y position: d7*8 + $17 (pixel row = row_index*8 + 23 offset)
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
; X position: average_occupancy * 64 / 100 (same scale as bar, gives horizontal X)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
; Adjust X: add col_start*8, subtract tile half-width (d2=3), add 1 = tile center alignment
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
; X base: route_type * 4 + $A (inter-panel horizontal offset)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
; Tile $0640 = economy/small plane icon (low-performance route)
    pea     ($0640).w
    bra.b   l_2a3fc
; --- High occupancy path (d3 >= $32 = 50%): tile $0649 (larger/premium plane icon) ---
l_2a3ac:
; d2 = $15 (21) = different tile dimension or variant for high-performance plane
    moveq   #$15,d2
    move.l  #$8000, -(a7)
    pea     ($0003).w
    pea     ($0003).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$17, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$6, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  (a3), d1
    ext.l   d1
    lsl.l   #$3, d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$a, d0
    move.l  d0, -(a7)
; Tile $0649 = premium/large plane icon (high-performance route, >= 50% average occupancy)
    pea     ($0649).w
; --- Phase: Place Plane Icon Tile ---
l_2a3fc:
; TilePlacement: builds tile params and calls GameCommand #15 to write to VDP plane
    jsr TilePlacement
    lea     $30(a7), a7
; GameCommand #$E = sync/wait for VDP completion (ensures tile writes committed)
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
; --- Phase: Route Indicator and Plane Graphic ---
; RenderRouteIndicator(player_index, route_type, stat_threshold)
; Draws the small route-status dot or line on the panel
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderRouteIndicator,PC)
    nop
; --- Phase: Decompress and Place Plane Graphic ---
; d5 = stat_threshold index -> used to select plane graphic from ROM table at $A1B34
; Table $A1B34 holds LZ-compressed source pointers, one per plane type (4 bytes each)
    move.l  d5, d0
    lsl.l   #$2, d0
    movea.l  #$000A1B34,a0
; Decompress the plane graphic for this stat category into scratch buffer $FF899C
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF899C).l
; LZ_Decompress: LZSS decompressor -> output at $FF899C (screen_buf staging area)
    jsr LZ_Decompress
; CmdPlaceTile: places the decompressed tile data at the correct panel column position
; Y offset $E = row 14; X = d6*14 - d6 + $B6 (compact: d6*(8*2-2)+$B6, 14-pixel stride)
    pea     ($000E).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
; d0 = d6*8; d1 = d6; d0 - d1 = d6*7; d0+d0 - d1 = d6*14
    sub.l   d1, d0
    add.l   d0, d0
; Add $B6 ($182): base X pixel offset of the route-panel graphic area
    addi.l  #$b6, d0
    move.l  d0, -(a7)
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
