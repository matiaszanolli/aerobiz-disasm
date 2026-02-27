; ============================================================================
; ShowRelationAction -- Draws the relation action screen showing an event-count bar graph (tile run proportional to current vs base count) for attack or defence depending on which count is nonzero
; Called: ?? times.
; 1004 bytes | $0199FA-$019DE5
; ============================================================================
; --- Phase: Function Prologue -- Register Setup ---
ShowRelationAction:                                                  ; $0199FA
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
; a2 = pointer to relation record (stack arg +$8): struct with attack/defence counts and base values
    movea.l $0008(a6),a2
; a3 = GameCommand ($0D64): central command dispatcher
    movea.l #$0d64,a3
; a4 = pointer to stack arg +$16: bar graph color/attribute word for tiles
    lea     $0016(a6),a4
; a5 = pointer to stack arg +$12: column/X position word for bar graph origin
    lea     $0012(a6),a5
; --- Phase: Conditional Background Load ---
; stack arg +$1A: mode flag -- 1 = first call (load background graphics), 0 = redraw only
    cmpi.w  #$1,$001a(a6)
; if not first call, skip background load entirely
    bne.b   .l19a6c
; LZ_Decompress ($003FEC): decompress background graphic from ROM ptr at $A1AE4 to save_buf_base ($FF1804)
    move.l  ($000A1AE4).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
; CmdPlaceTile ($004668): place decompressed background tile at column $20, row $694
; (large row value likely encodes VRAM destination directly)
    pea     ($0020).w
    pea     ($0694).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
; GameCommand #$1B: place action-panel header tile from $70F38 (count=4, x=4)
; at (a5) = X position, $E(a6) = Y position from stack args
    pea     ($00070F38).l
    pea     ($0004).w
    pea     ($0004).w
; push (a5) = column X position for the bar graph panel
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
; push $E(a6) = row Y position for the panel from caller's stack
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0030(sp),sp
; --- Phase: Text Window Setup and Event Count Dispatch ---
.l19a6c:                                                ; $019A6C
; SetTextWindow ($03A942): define 32×32 text window at origin (0,0) covering full screen
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
; d6 = $E(a6) + 4: Y row for bar graph rows (offset down 4 rows from panel top)
    move.w  $000e(a6),d6
    addq.w  #$4,d6
; d5 = (a5) = X column for bar graph left edge (from stack arg +$12)
    move.w  (a5),d5
; d4 = 0: horizontal pixel offset within tile strip (accumulated during bar rendering)
    clr.w   d4
; --- Phase: Dispatch -- Attack vs Defence ---
; a2+$0E = attack event count (current), a2+$06 = defence event count (base/reference)
; if attack count > defence count: this is an attack event -> draw attack bar
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
; if attack not greater: check defence branch instead
    bls.w   .l19bb8
; --- Phase: Attack Bar -- Calculate and Draw Empty Bar Background ---
; d7 = $0331: tile ID for the attack-bar background/empty tile
    move.w  #$0331,d7
; position = d4 (horizontal offset) + d7 (tile base) - 1 = rightmost empty tile position
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    subq.l  #$1,d0
; GameCommand #$1A: draw empty bar background tile at computed position
; args: position, count=$A (10 slots), col=d5, row=d6, attr=(a4)
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
; (a4) = tile attribute word (color palette + priority flags) from stack arg +$16
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
; --- Phase: Attack Bar -- Compute Filled-Tile Count (Proportional to Attack/Base ratio) ---
; compute proportion: attack_count / base_count × 100 (percent of bar to fill)
; a2+$0E = attack event count (current), a2+$06 = base count (reference/maximum)
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
; $64 = 100: scale factor for percentage calculation
    pea     ($0064).w
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
; $01E11C = percentage ratio function: (current * 100) / base -> d0 = percent (0..100)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $0028(sp),sp
; d3 = raw percentage result (0..100)
    move.w  d0,d3
    ext.l   d0
; SignedDiv ($03E08A): d0 / 10 -> d0 = number of filled tiles (0..10)
; divides by $A to convert 0-100% to 0-10 tile count
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
; d2 = number of bar tiles to fill (0..10)
    move.w  d0,d2
; if d2 == 0: nothing to fill, skip to drawing the tail tile
    tst.w   d2
    ble.b   .l19b2c
; --- Phase: Attack Bar -- Draw Filled Tiles ---
; filled tile start = d4 + d7 + 8: offset 8 tiles from base for the filled-tile graphic set
; d7 = $0331 (attack tile base); filled tiles start at $0331 + 8 = $0339
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addq.l  #$8,d0
; GameCommand #$1A: draw d2 filled attack-bar tiles at (d5+1, d6), using tile attr (a4)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
; col d5+1: filled tiles start one column right of the empty-bar background
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; --- Phase: Attack Bar -- Draw Partial/Tail Tile ---
.l19b2c:                                                ; $019B2C
; compute the partial tile index for sub-tile precision:
; d3 % 10 = remainder percentage (0..9) -> fractional fill amount
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
; SignedMod ($03E146): d0 = d3 mod $A = remainder after full tiles
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
; multiply remainder × 8 to get sub-tile pixel offset (8 sub-steps per tile)
    lsl.l   #$3,d0
; SignedDiv: divide by $A to convert 0..79 range to 0..7 sub-tile offset index
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
; d0 now holds sub-tile partial fill index (0..7)
; add d7 (tile base $0331) to get actual tile ID for partial fill graphic
    add.w   d7,d0
; d3 = tile ID for the partial (tail) tile
    move.w  d0,d3
; position = d4 + d3: place tail tile after the filled tiles
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
; GameCommand #$1A: draw the partial tile (count=1) at (d5+1, d6+d2) -- end of filled run
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
; row = d6 + d2: partial tile goes immediately after the last filled tile
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; advance d2 past the partial tile to check if bar is now full
    addq.w  #$1,d2
; if d2 >= 10: bar is completely full -- skip empty-tile suffix, fall through to footer
    cmpi.w  #$a,d2
    bge.w   .l19d3c
; --- Phase: Attack Bar -- Draw Remaining Empty Tiles (tail end of bar) ---
; tile position = d4 + d7: empty-bar tile ID for the unfilled portion
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
; count of empty tiles = 10 - d2: remaining slots after filled + partial tile
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
; col = d5+1: same column offset as filled tiles
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
; shared tail: draw empty remainder at (d5+1, d6+d2) -- picks up after partial tile row
.l19ba8:                                                ; $019BA8
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
; row = d6 + d2: starts right after the filled+partial section
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
; jump to shared GameCommand #$1A call that draws the empty tiles and falls through to footer
    bra.w   .l19d2a
; --- Phase: Defence Bar -- Check and Dispatch ---
.l19bb8:                                                ; $019BB8
; a2+$06 = defence event count; if zero: neither attack nor defence active, draw empty panel
    tst.w   $0006(a2)
    beq.w   .l19cda
; d7 = $0328: tile ID base for the defence-bar tiles (different graphic set from attack $0331)
    move.w  #$0328,d7
; draw defence-bar empty background: position = d4 + d7 + $11 ($0328 + $11 = $0339)
; +$11 = 17 tile offset selects the empty-defence tile within the set
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addi.l  #$11,d0
; GameCommand #$1A: draw 10 empty defence-bar tiles at (d5+1, d6)
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
; col d5+1 for defence bar (mirrored layout from attack)
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
; defence percentage: (defence_count / attack_count) × 100
; a2+$06 = defence count, a2+$0E = attack count (used as base reference here)
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
; $64 = 100: percentage scale factor
    pea     ($0064).w
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
; $01E11C: percentage ratio (defence/attack × 100) -> d0
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $0028(sp),sp
    move.w  d0,d3
    ext.l   d0
; SignedDiv: d3 / 10 -> d2 = number of filled defence-bar tiles
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    tst.w   d2
    ble.b   .l19c58
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; --- Phase: Defence Bar -- Draw Filled Tiles, Partial Tile, and Empty Suffix ---
.l19c58:                                                ; $019C58
; if all 10 tiles filled: skip to footer
    cmpi.w  #$a,d2
    bge.w   .l19d3c
; compute partial tile: d3 mod 10 × 8 / 10 = sub-tile step for partial fill
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
; shift × 8 (3 bits left) to expand to 8 sub-steps per tile
    lsl.l   #$3,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
; add sub-step to d7 (defence tile base $0328) to select the partial defence tile graphic
    add.w   d0,d7
; position = d4 + d7 (now partial tile ID): place partial tile at (d5, d6+d2)
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; advance d2 past partial tile
    addq.w  #$1,d2
; if now full: skip empty suffix
    cmpi.w  #$a,d2
    bge.w   .l19d3c
; draw remaining empty defence tiles: d4 + $0328 = empty defence tile base
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
; count = 10 - d2: remaining empty slots
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
; col = d5 (no +1 offset for defence empty tiles -- different alignment vs attack side)
    move.w  d5,d0
    ext.l   d0
; shared tail at .l19ba8 completes the GameCommand #$1A call for empty tiles
    bra.w   .l19ba8
; --- Phase: Empty Panel -- Neither Attack Nor Defence (draw blank bar) ---
.l19cda:                                                ; $019CDA
; draw 10 empty tiles on the left column (d5) using defence empty tile base $0328
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; draw 10 more empty tiles on the right column (d5+1) -- second row of blank bar
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
; col d5+1: second column of the blank panel
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
; --- Shared tail for GameCommand #$1A (used by both empty-panel and empty-suffix paths) ---
.l19d2a:                                                ; $019D2A
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; --- Phase: Footer -- Display Event Count and Percentage Labels ---
.l19d3c:                                                ; $019D3C
; SetTextCursor ($03AB2C): position at ((a5), $E(a6)+4) to print attack event count label
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
; +4 rows below panel top: footer label row
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; print a2+$0E (attack event count) using PrintfWide format string at $41116
    moveq   #$0,d0
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
    pea     ($00041116).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
; $0074E0 = CalcCompatScore: compute compatibility index for relation record at a2
; returns compatibility score in d0 (0..n)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
; d2 = raw compatibility index
    move.w  d0,d2
; look up colour/rank byte from bitfield_tab ($FFA6B9) at offset index*12
; $FFA6B9 is 8 bytes past bitfield_tab ($FFA6A0 + $19 = $FFA6B9): rank-to-color table
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
; multiply rank byte × $A (10): converts rank (0..7) to percentage step (0..70%)
    mulu.w  #$a,d0
; d2 = percentage base from rank table lookup (0, 10, 20, 30, 40, 50, 60, 70)
    move.w  d0,d2
; now compute actual compatibility percentage: (rank_percent / 100) * a2+$10
; a2+$10 = route slot actual_revenue (passenger_count field, used here as base score)
    move.l  d0,-(sp)
    pea     ($0064).w
    move.w  $0010(a2),d0
    move.l  d0,-(sp)
; $01E11C: percentage function (rank_percent × a2+$10) / 100 -> d0
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
; d3 = computed compatibility percentage
    move.w  d0,d3
; clamp d3 to maximum $64 = 100% (can't exceed 100%)
    cmpi.w  #$64,d3
    bge.b   .l19daa
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19dac
.l19daa:                                                ; $019DAA
; clamped: percentage is 100
    moveq   #$64,d0
.l19dac:                                                ; $019DAC
    move.w  d0,d3
; SetTextCursor: position at ((a5)+2, $E(a6)+9) for compatibility percentage label
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
; +9 rows: one row below the event-count label
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; PrintfWide: print clamped compatibility % (d3) at format string $41110
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($00041110).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
; --- Phase: Epilogue ---
    movem.l -$0028(a6),d2-d7/a2-a5
    unlk    a6
    rts
