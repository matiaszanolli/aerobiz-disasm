; ============================================================================
; RunWorldMapAnimation -- Loads and tiles the world-map graphics set; decompresses route/city tiles into VRAM and runs an animated display loop (136 frames), then resets scroll and restores map
; 1668 bytes | $039EAA-$03A52D
; ============================================================================
; --- Phase: Setup / Register Assignments ---
; arg $8(a6) = animation mode / scenario index
RunWorldMapAnimation:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2                ; d2 = animation mode / scenario index (arg)
    movea.l  #$00FF1804,a2            ; a2 = $FF1804 = save_buf_base (decompression staging buffer)
    movea.l  #$00000D64,a3            ; a3 = GameCommand dispatcher (used as indirect call target)
    movea.l  #$00005092,a4            ; a4 = DisplaySetup function (display/graphics setup)
    movea.l  #$0001D8AA,a5            ; a5 = DrawTileGrid function (used for placing tile grids)
    jsr ResourceLoad                  ; load required resource set if not already loaded
    jsr PreLoopInit                   ; pre-loop hardware setup (VDP, scroll, display state)
; --- Phase: Screen Clear and Scroll Setup ---
    ; GameCmd #$10 (=$9010 word) with param 0 — likely a VDP mode/display register command
    move.l  #$9010, -(a7)
    clr.l   -(a7)
    jsr     (a3)                      ; GameCommand #$10 — set VDP display mode register
    ; Initialize the map scroll quadrant (world map uses a scrolling 2-plane setup)
    pea     ($0001).w
    clr.l   -(a7)
    jsr SetScrollQuadrant             ; select scroll quadrant 1 (map plane layout)
    ; Clear plane A (tile value 0): full $20×$20 region, all columns, row 0
    clr.l   -(a7)                     ; tile = 0 (blank)
    pea     ($0020).w                 ; height = $20 (32 rows)
    pea     ($0020).w                 ; width = $20 (32 cols)
    clr.l   -(a7)                     ; col = 0
    clr.l   -(a7)                     ; row = 0
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle
    jsr     (a3)
    lea     $2c(a7), a7
    ; Clear a second region (col $20) on plane 0
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w                 ; col = $20 (second 32-col page)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; Clear plane B (plane = 1): same region, col 0
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w                 ; plane = 1 (plane B)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; Clear plane B at col $20 as well
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w                 ; col = $20
    clr.l   -(a7)
    pea     ($0001).w                 ; plane = 1
    pea     ($001A).w
    jsr     (a3)
; --- Phase: Graphics Asset Loading (World Map Tiles) ---
    ; Load the world map base palette/color data via DisplaySetup (a4)
    pea     ($0010).w                 ; param = $10
    pea     ($0020).w                 ; param = $20
    pea     ($0006157C).l             ; ROM address of world map palette data set A
    jsr     (a4)                      ; DisplaySetup: load palette/display set from $6157C
    lea     $28(a7), a7
    ; Load a second palette/color entry (single entry at $6157E)
    pea     ($0001).w                 ; count = 1
    clr.l   -(a7)                     ; offset = 0
    pea     ($0006157E).l             ; ROM address of palette entry
    jsr     (a4)                      ; DisplaySetup: load palette entry from $6157E
    ; GameCmd #$1B: place compressed tile block for the map ocean/background layer
    ; $6159C = compressed tile data for ocean background
    pea     ($0006159C).l             ; compressed tile data for ocean/sky background
    pea     ($0013).w                 ; row = $13
    pea     ($0020).w                 ; width = $20
    clr.l   -(a7)                     ; col = 0
    clr.l   -(a7)                     ; plane param
    pea     ($0001).w
    pea     ($001B).w                 ; GameCmd #$1B = place compressed tile block
    jsr     (a3)
    ; Decompress the first main world map tileset ($61A5C) into the staging buffer ($FF1804)
    pea     ($00061A5C).l             ; ROM: compressed world map continent tiles
    move.l  a2, -(a7)                 ; dest = $FF1804 (save_buf_base)
    jsr LZ_Decompress                 ; decompress continent graphics to staging buffer
    lea     $30(a7), a7
    ; DMA the decompressed continent tiles to VRAM: tile $015A, count $1C tiles
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)                 ; source = $FF1804
    pea     ($001C).w                 ; tile count = $1C (28 tiles)
    pea     ($015A).w                 ; VRAM tile destination index = $015A
    jsr VRAMBulkLoad                  ; DMA $1C tiles to VRAM at tile $015A
    ; Load city/route icon palette via DisplaySetup
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00061BC2).l             ; ROM: city/route icon palette data
    jsr     (a4)                      ; DisplaySetup: load icon palette from $61BC2
    lea     $20(a7), a7
    ; GameCmd #$1B: place compressed city-label tile block (row $13, height $B)
    pea     ($00061BE2).l             ; compressed city-label tiles at $61BE2
    pea     ($000B).w                 ; height = $B (11 rows)
    pea     ($0020).w                 ; width = $20
    pea     ($0013).w                 ; row = $13
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w                 ; GameCmd #$1B = place compressed tile block
    jsr     (a3)
    ; Decompress city icon set ($61EA2) into staging buffer, DMA to VRAM tile $0001, count $52
    pea     ($00061EA2).l             ; ROM: compressed city icon tiles
    move.l  a2, -(a7)                 ; dest = $FF1804
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)                 ; source = $FF1804
    pea     ($0052).w                 ; tile count = $52 (82 tiles — city icons)
    pea     ($0001).w                 ; VRAM tile destination = $0001
    jsr VRAMBulkLoad
    ; Decompress route/airline line graphics ($6088E) into staging buffer
    pea     ($0006088E).l             ; ROM: compressed route/airline tile data
    move.l  a2, -(a7)                 ; dest = $FF1804
    jsr LZ_Decompress
    lea     $1c(a7), a7
    ; GameCmd #$1B: place the world map background layer tile pattern (plane B)
    pea     ($0006010E).l             ; compressed map background layer tiles
    pea     ($001E).w                 ; height = $1E (30 rows)
    pea     ($0020).w                 ; width = $20
    pea     ($0020).w                 ; col = $20 (second page / plane B offset)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    ; DMA route tiles to VRAM tile $0176, count $EE tiles
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)                 ; source = $FF1804 (decompressed route tiles)
    pea     ($00EE).w                 ; tile count = $EE (238 tiles — all route/land tiles)
    pea     ($0176).w                 ; VRAM tile destination = $0176
    jsr VRAMBulkLoad                  ; DMA route tiles to VRAM
    lea     $30(a7), a7
; --- Phase: Animated Route Tile Streams ---
; Load the flight-path / animated route tile strip header block
    pea     ($000620CC).l             ; compressed animated route strip descriptor at $620CC
    pea     ($0002).w                 ; height = 2
    pea     ($0010).w                 ; width = $10
    pea     ($0013).w                 ; row = $13
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w                 ; GameCmd #$1B = place tile block
    jsr     (a3)
    ; Decompress frame-A route animation tiles ($6210C) to base of staging buffer
    pea     ($0006210C).l             ; ROM: animation frame A of route tiles
    move.l  a2, -(a7)                 ; dest = $FF1804 (base of staging buffer)
    jsr LZ_Decompress
    ; Decompress frame-B route animation tiles ($621BC) to staging buffer at +$7D0 offset
    ; The buffer is split in half: frame A at $FF1804, frame B at $FF1804+$7D0
    pea     ($000621BC).l             ; ROM: animation frame B of route tiles
    move.l  a2, d0
    addi.l  #$7d0, d0                 ; d0 = $FF1804 + $7D0 = second animation frame dest
    move.l  d0, -(a7)
    jsr LZ_Decompress
    lea     $2c(a7), a7
    ; DMA frame A of route animation tiles to VRAM tile $0053, count $20
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)                 ; source = $FF1804 (frame A)
    pea     ($0020).w                 ; tile count = $20 (32 tiles per animation frame)
    pea     ($0053).w                 ; VRAM tile destination = $0053
    jsr VRAMBulkLoad
; --- Phase: World Map Tile Grid Drawing ---
; Decompress the world map tile layout data ($62212) to a+$FA0 offset in staging buffer.
; The layout stream occupies a separate sub-window of the staging buffer.
    pea     ($00062212).l             ; ROM: compressed world map tile layout data
    move.l  a2, d0
    addi.l  #$fa0, d0                 ; dest = $FF1804 + $FA0 (sub-buffer for map layout)
    move.l  d0, -(a7)
    jsr LZ_Decompress
    ; Draw 5 horizontal tile grid rows using the decompressed layout data.
    ; Each DrawTileGrid call places a 14-tile ($E) wide strip at a different VRAM tile row.
    ; VRAM tile rows $0300-$0340 correspond to the 5 world map band positions.
    move.l  a2, d0
    addi.l  #$fa0, d0                 ; source = $FF1804+$FA0 (map layout, row 0 data)
    move.l  d0, -(a7)
    pea     ($0001).w                 ; plane = 1
    pea     ($000E).w                 ; width = $E (14 tiles per row)
    pea     ($0300).w                 ; VRAM tile row base = $0300 (map row 0)
    jsr DrawTileGrid                  ; draw world map tile band 0
    lea     $2c(a7), a7
    move.l  a2, d0
    addi.l  #$1160, d0                ; source at +$1160 offset (row 1 data)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0310).w                 ; VRAM tile row base = $0310 (map row 1)
    jsr DrawTileGrid                  ; draw world map tile band 1
    move.l  a2, d0
    addi.l  #$1320, d0                ; source at +$1320 offset (row 2 data)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0320).w                 ; VRAM tile row base = $0320 (map row 2)
    jsr DrawTileGrid                  ; draw world map tile band 2
    move.l  a2, d0
    addi.l  #$14e0, d0                ; source at +$14E0 offset (row 3 data)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0330).w                 ; VRAM tile row base = $0330 (map row 3)
    jsr DrawTileGrid                  ; draw world map tile band 3
    lea     $30(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0                ; source at +$16A0 offset (row 4 data)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0340).w                 ; VRAM tile row base = $0340 (map row 4)
    jsr DrawTileGrid                  ; draw world map tile band 4
    ; Decompress the map overlay / city-marker tile layout ($62426) into staging buffer at +$FA0
    pea     ($00062426).l             ; ROM: compressed city-marker overlay layout
    move.l  a2, d0
    addi.l  #$fa0, d0                 ; dest = $FF1804 + $FA0
    move.l  d0, -(a7)
    jsr LZ_Decompress
    ; Draw 3 city-marker tile grid strips (8-tile wide) overlaid on the map bands
    move.l  a2, d0
    addi.l  #$fa0, d0                 ; source = $FF1804+$FA0 (city overlay, band 2)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w                 ; width = 8 tiles (city marker width)
    pea     ($0321).w                 ; VRAM tile row $0321 (map row 2, city overlay column)
    jsr DrawTileGrid                  ; place city markers on band 2
    lea     $28(a7), a7
    move.l  a2, d0
    addi.l  #$10a0, d0                ; source at +$10A0 offset (city overlay, band 3)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0331).w                 ; VRAM tile row $0331 (map row 3, city overlay)
    jsr DrawTileGrid                  ; place city markers on band 3
    move.l  a2, d0
    addi.l  #$11a0, d0                ; source at +$11A0 offset (city overlay, band 4)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0341).w                 ; VRAM tile row $0341 (map row 4, city overlay)
    jsr DrawTileGrid                  ; place city markers on band 4
    ; Load the airline logo/banner palette into display slot $30 using DisplaySetup
    pea     ($0010).w                 ; param = $10
    pea     ($0030).w                 ; display slot = $30
    pea     ($00062762).l             ; ROM: airline logo palette data
    jsr     (a4)                      ; DisplaySetup: load airline palette
    lea     $2c(a7), a7
    ; Load player-specific airline brand logo into display slot $31
    ; Table at $76520 has one entry per scenario/mode (stride 2) for the airline logo variant
    pea     ($0001).w                 ; count = 1
    pea     ($0031).w                 ; display slot = $31
    move.w  d2, d0                    ; d2 = scenario/mode index
    add.w   d0, d0                    ; d0 = d2 * 2 (word-stride into logo table)
    movea.l  #$00076520,a0            ; a0 = base of airline logo pointer table at $76520
    pea     (a0, d0.w)                ; push pointer to this scenario's airline logo entry
    jsr     (a4)                      ; DisplaySetup: load airline logo for this scenario
    ; Load second airline logo variant into display slot $33
    pea     ($0001).w
    pea     ($0033).w                 ; display slot = $33
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00076520,a0
    pea     (a0, d0.w)                ; same lookup but for alternate logo slot
    jsr     (a4)                      ; DisplaySetup
    lea     $18(a7), a7
    ; --- Phase: Animation Loop Setup ---
    ; d2 = frame counter (0...$87 = 136 frames)
    ; d4 = outer animation row index
    clr.w   d2                        ; d2 = 0 (animation frame counter, starts at 0)
    clr.w   d4                        ; d4 = 0 (outer tile row loop index)
; --- Phase: Initial Route Tile Placement Loop ---
; Fills the world map with route tiles in a nested 5×7 grid.
; Outer loop: d4 = map row (0..4), inner loop: d3 = map column (0..6)
; d2 = running VRAM tile index counter (incremented each cell)
l_3a21e:
    clr.w   d3                        ; d3 = 0 (inner column index, reset each outer row)
l_3a220:
    ; Compute tile parameters for cell (d4, d3) and place it on the map
    ; Screen X position: d4 * 8 + $78 pixels (horizontal spacing)
    ; Screen Y position: d3 * $10 + $58 pixels (vertical spacing)
    ; VRAM tile index: d4 * $10 + d3 * 2 + $300
    pea     ($6000).w                 ; tile attributes ($6000 = high-priority palette bits)
    pea     ($0001).w                 ; plane = 1
    pea     ($0002).w                 ; size param = 2
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0                   ; d0 = d4 * 8 (X pixel offset per row)
    addi.l  #$78, d0                  ; d0 += $78 = base X pixel ($78 = 120px left margin)
    move.l  d0, -(a7)                 ; arg: screen X position
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0                   ; d0 = d3 * $10 (Y pixel offset per column)
    addi.l  #$58, d0                  ; d0 += $58 = base Y pixel ($58 = 88px top margin)
    move.l  d0, -(a7)                 ; arg: screen Y position
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg: d2 = current VRAM tile index for this cell
    ; Compute VRAM tile row: d4*$10 + d3*2 + $300
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$4, d0                   ; d0 = d4 * $10
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1                    ; d1 = d3 * 2
    add.l   d1, d0                    ; d0 = d4*$10 + d3*2
    addi.l  #$300, d0                 ; d0 += $300 = VRAM tile row base for map band
    move.l  d0, -(a7)                 ; arg: VRAM tile row index
    jsr TilePlacement                 ; place this route tile cell on the map
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                      ; GameCmd #$E = frame sync (wait one frame per tile)
    lea     $24(a7), a7
    addq.w  #$1, d2                   ; d2++ (next VRAM tile index)
    addq.w  #$1, d3                   ; d3++ (next column)
    cmpi.w  #$7, d3
    blt.b   l_3a220                   ; inner loop: 7 columns (0..6)
    addq.w  #$1, d4                   ; d4++ (next row)
    cmpi.w  #$5, d4
    blt.b   l_3a21e                   ; outer loop: 5 rows (0..4)
; --- Phase: Animation State Initialization ---
; After the initial grid fill, set up the rolling animation state variables.
; d5 = byte-offset for animation frame A in staging buffer (a+$FA0 base + per-step stride)
; d6 = byte-offset for animation frame B in staging buffer
    moveq   #$1,d4                    ; d4 = 1 (initial animation step index)
    move.w  d4, d7                    ; d7 = current animation step (used as loop variable)
    clr.w   d3                        ; d3 = 0 (horizontal scroll offset, reset)
    clr.w   d2                        ; d2 = 0 (frame counter, reset to 0 for main loop)
    ; Compute d5 = staging buffer byte offset for animation frame A:
    ; d5 = d7 * 3 * $80 + $7D0 = d7 * $180 + $7D0
    ; This is the offset within $FF1804 for the first animation tile strip
    move.w  d7, d5
    ext.l   d5
    move.l  d5, d0
    add.l   d5, d5                    ; d5 = d7 * 2
    add.l   d0, d5                    ; d5 = d7 * 3
    lsl.l   #$7, d5                   ; d5 = d7 * 3 * $80 = d7 * $180
    addi.l  #$7d0, d5                 ; d5 += $7D0 (base offset of frame A data)
    ; Compute d6 = staging buffer byte offset for animation frame B:
    ; d6 = d7 * $100 + $9D0
    move.w  d7, d6
    ext.l   d6
    lsl.l   #$8, d6                   ; d6 = d7 * $100
    addi.l  #$9d0, d6                 ; d6 += $9D0 (base offset of frame B data)
    bra.w   l_3a4be                   ; jump to loop condition check (d2 vs $88)
; --- Phase: Main Animation Loop ---
; Each iteration: poll input, update scroll offsets, advance animation frames.
; Loop runs for $88 (136) frames (d2: 0..$87), or exits early on button press.
l_3a2b4:
    ; Poll for player input (mode 3 = immediate, no wait)
    clr.l   -(a7)
    pea     ($0003).w                 ; mode = 3 (immediate poll)
    jsr PollAction                    ; poll for button press; returns $10 if timed out/button
    addq.l  #$8, a7
    cmpi.w  #$10, d0
    beq.w   l_3a4c6                   ; d0=$10 = exit condition (button pressed or timeout) — end animation
    ; On frame 0 only: initialize the menu selection (displays the initial route selection UI)
    tst.w   d2
    bne.b   l_3a2dc                   ; d2 != 0: not the first frame, skip MenuSelectEntry
    clr.l   -(a7)
    pea     ($000D).w                 ; param = $D
    jsr MenuSelectEntry               ; first frame: validate/initialize menu selection state
    addq.l  #$8, a7
l_3a2dc:
    ; Phase A: frames 0..$27 (0..39) — early animation phase (just scroll)
    cmpi.w  #$28, d2
    bge.b   l_3a2e8                   ; frame >= $28: enter tile-cycling phase
    subq.w  #$2, d3                   ; d3 -= 2 (advance horizontal scroll offset by 2 pixels/frame)
    bra.w   l_3a42c                   ; update scroll and continue loop
; Phase B: frames $28..$87 — active tile-cycling animation with route highlighting
l_3a2e8:
    subq.w  #$2, d4                   ; d4 -= 2 (vertical scroll offset advances each frame)
    subq.w  #$3, d3                   ; d3 -= 3 (horizontal scroll faster in phase B)
    cmpi.w  #$41, d2
    bge.w   l_3a3a0                   ; frame >= $41: skip tile strip updates, only scroll
    ; Every 5th frame (when frame mod 5 == 4), update animated route tile strips
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod                     ; d0 = d2 mod 5 (0..4)
    moveq   #$4,d1
    cmp.l   d0, d1
    bne.w   l_3a3a0                   ; not a mod-5 frame — skip tile update
    ; This is a tile-update frame. Decide which animation buffer half to use.
    ; Frames $28..$36 use frame-A buffer (d5 pointer), frames $37+ use frame-B buffer (d6 pointer)
    cmpi.w  #$37, d2
    bge.b   l_3a356                   ; frame >= $37: use frame-B (d6) tile buffer
    ; Draw 3 tile grid strips for frame A (using d5 buffer pointer)
    ; Each strip is 8 tiles wide at a different vertical map band
    ; d5 is used as a word index: actual byte offset = d5*2 into staging buffer a2
    move.l  d5, d0
    add.l   d0, d0                    ; d0 = d5 * 2 (byte offset into staging buffer)
    pea     (a2, d0.l)                ; source = staging buffer at d5*2 offset (band 2 strip A)
    pea     ($0008).w                 ; width = 8 tiles
    pea     ($0321).w                 ; VRAM tile row $0321 (map band 2 route strip)
    jsr     (a5)                      ; DrawTileGrid: draw route animation strip, band 2
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0              ; a0 = source + $100 bytes (band 3 strip data)
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w                 ; VRAM tile row $0331 (map band 3 route strip)
    jsr     (a5)                      ; DrawTileGrid: draw route animation strip, band 3
    move.l  d5, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $200(a0), a0              ; a0 = source + $200 bytes (band 4 strip data)
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0341).w                 ; VRAM tile row $0341 (map band 4 route strip)
    jsr     (a5)                      ; DrawTileGrid: draw route animation strip, band 4
    lea     $24(a7), a7
    bra.b   l_3a392
; Draw 3 tile strips for frame B (using d6 buffer pointer)
l_3a356:
    move.l  d6, d0
    add.l   d0, d0                    ; d0 = d6 * 2 (byte offset for frame B data)
    pea     (a2, d0.l)                ; source = frame B band 2 strip data
    pea     ($0008).w
    pea     ($0321).w
    jsr     (a5)                      ; DrawTileGrid: frame B, band 2
    move.l  d6, d0
    add.l   d0, d0
    lea     (a2,d0.l), a0
    lea     $100(a0), a0              ; source + $100 = frame B band 3 strip data
    move.l  a0, -(a7)
    pea     ($0008).w
    pea     ($0331).w
    jsr     (a5)                      ; DrawTileGrid: frame B, band 3
    pea     ($0004).w
    pea     ($001C).w
    jsr GameCmd16                     ; GameCmd #16 with params $4/$1C (flush / DMA trigger)
    lea     $20(a7), a7
l_3a392:
    ; Advance both buffer pointers for the next animation step
    addi.l  #$100, d6                 ; d6 += $100 (step frame B pointer to next strip)
    addi.l  #$180, d5                 ; d5 += $180 (step frame A pointer to next strip)
    addq.w  #$1, d7                   ; d7++ (animation step counter)
l_3a3a0:
    ; Frame $2D (45): trigger a display set load (e.g. palette crossfade or resource swap)
    cmpi.w  #$2d, d2
    bne.b   l_3a3b4
    pea     ($000A).w                 ; display set index = $A
    jsr LoadDisplaySet                ; swap/load display set $A (city background palette etc.)
    addq.l  #$4, a7
    bra.b   l_3a42c
l_3a3b4:
    ; Frame $41 (65): redraw the full map tile grid (landscape bands 2/3/4)
    ; This refreshes the underlying map after animated flight paths have scrolled over it
    cmpi.w  #$41, d2
    bne.b   l_3a412
    pea     ($00062212).l             ; ROM: world map tile layout (same as initial load)
    move.l  a2, d0
    addi.l  #$fa0, d0                 ; dest = staging buffer at +$FA0
    move.l  d0, -(a7)
    jsr LZ_Decompress                 ; re-decompress map layout for refresh
    ; Redraw bands 2/3/4 with 14-tile-wide strips (same as initial setup)
    move.l  a2, d0
    addi.l  #$1320, d0                ; source = band 2 layout data at +$1320
    move.l  d0, -(a7)
    pea     ($000E).w                 ; width = $E (14 tiles)
    pea     ($0320).w                 ; VRAM tile row $0320 (band 2)
    jsr     (a5)                      ; DrawTileGrid: refresh map band 2
    move.l  a2, d0
    addi.l  #$14e0, d0                ; source = band 3 layout at +$14E0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0330).w                 ; VRAM tile row $0330 (band 3)
    jsr     (a5)                      ; DrawTileGrid: refresh map band 3
    lea     $20(a7), a7
    move.l  a2, d0
    addi.l  #$16a0, d0                ; source = band 4 layout at +$16A0
    move.l  d0, -(a7)
    pea     ($000E).w
    pea     ($0340).w                 ; VRAM tile row $0340 (band 4)
    jsr     (a5)                      ; DrawTileGrid: refresh map band 4
    bra.b   l_3a428
l_3a412:
    ; Frame $4C (76): load the final airline brand logo display set (animation endpoint visual)
    cmpi.w  #$4c, d2
    bne.b   l_3a42c
    pea     ($0010).w                 ; param = $10
    pea     ($0010).w                 ; param = $10
    pea     ($000600EE).l             ; ROM: final airline logo / brand graphic data
    jsr     (a4)                      ; DisplaySetup: load brand graphic
l_3a428:
    lea     $c(a7), a7
; Per-frame: update both scroll planes with current d4 (vertical) and d3 (horizontal) offsets
l_3a42c:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (vertical scroll offset for plane A)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (horizontal scroll offset)
    clr.l   -(a7)                     ; plane = 0 (plane A)
    jsr SetScrollOffset               ; apply (d3, d4) scroll to plane A
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (vertical scroll, same for plane B)
    clr.l   -(a7)                     ; horizontal = 0 (plane B doesn't scroll horizontally)
    pea     ($0001).w                 ; plane = 1 (plane B)
    jsr SetScrollOffset               ; apply d4 vertical scroll to plane B
    lea     $18(a7), a7
    ; Frame 1: free the initial resource load (now that map is fully set up)
    cmpi.w  #$1, d2
    bne.b   l_3a462
    jsr ResourceUnload                ; unload the resource loaded at the start (free memory)
l_3a462:
    ; Frames 0..$4B: alternate between two VRAM tile sets (even vs odd frame)
    ; to create the animation flip effect for the route tiles
    cmpi.w  #$4c, d2
    bge.b   l_3a4bc                   ; frame >= $4C: stop tile alternation
    ; Select which animation buffer half to DMA: even frames use frame A ($FF1804 base),
    ; odd frames use frame B ($FF1804+$7D0)
    move.w  d2, d0
    andi.l  #$1, d0                   ; d0 = d2 & 1 (0=even, 1=odd)
    bne.b   l_3a47a                   ; odd frame: use frame B buffer
    ; Even frame: source = $FF1804 (frame A)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)                 ; source = $FF1804 (animation frame A base)
    bra.b   l_3a488
l_3a47a:
    ; Odd frame: source = $FF1804 + $7D0 (frame B)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, d0
    addi.l  #$7d0, d0                 ; source = $FF1804 + $7D0 (animation frame B base)
    move.l  d0, -(a7)
l_3a488:
    ; DMA $20 route animation tiles to VRAM tile $0053 (alternating frame buffer each time)
    pea     ($0020).w                 ; tile count = $20 (32 tiles — one animation frame)
    pea     ($0053).w                 ; VRAM tile destination = $0053
    jsr VRAMBulkLoad                  ; DMA animation tiles to VRAM
    ; Cycle the airline display palette — $600E4 table has 2 entries (even/odd, stride 4)
    pea     ($0002).w
    pea     ($001A).w
    move.w  d2, d0
    ext.l   d0
    moveq   #$2,d1
    jsr SignedMod                     ; d0 = d2 mod 2 (0 or 1 — selects even/odd palette variant)
    lsl.w   #$2, d0                   ; d0 = (d2 mod 2) * 4 (longword stride into palette table)
    movea.l  #$000600E4,a0            ; a0 = base of 2-entry airline display palette table
    pea     (a0, d0.w)                ; push pointer to the even or odd palette entry
    jsr     (a4)                      ; DisplaySetup: cycle the airline animation palette
    lea     $20(a7), a7
l_3a4bc:
    addq.w  #$1, d2                   ; d2++ (increment frame counter)
l_3a4be:
    cmpi.w  #$88, d2
    blt.w   l_3a2b4                   ; $88 = 136 frames total — loop until done
; --- Phase: Teardown / Restore Map ---
; Animation complete (136 frames elapsed) or button was pressed to skip.
; Restore the normal map display state.
l_3a4c6:
    jsr ResourceLoad                  ; reload the standard gameplay resource set
    ; GameCmd $18 (=$18 dispatch code) — likely palette restore or display mode reset
    pea     ($0018).w
    jsr     (a3)                      ; GameCommand #$18 = restore display state
    jsr PreLoopInit                   ; reset hardware state (VDP, scroll registers)
    ; Reset both scroll planes to offset (0, 0)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollOffset               ; plane A: X=0, Y=0
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w                 ; plane = 1
    jsr SetScrollOffset               ; plane B: Y=0
    ; Load the default airline brand graphic back into display slot (normal map display set)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l             ; ROM: default airline display set / title graphic
    jsr     (a4)                      ; DisplaySetup: restore default airline display
    ; GameCmd $9000 — likely a VDP display mode restore (re-enable display after animation)
    move.l  #$9000, -(a7)
    clr.l   -(a7)
    jsr     (a3)                      ; GameCommand #$90 = restore display mode register
    lea     $30(a7), a7
    ; Restore normal map scroll quadrant (0 = default world map view)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollQuadrant             ; reset scroll quadrant to default (0, 0)
    jsr PreLoopInit                   ; final hardware state sync before returning
    jsr LoadMapTiles                  ; reload and place the normal gameplay world map tiles
    movem.l -$28(a6), d2-d7/a2-a5    ; restore callee-saved registers
    unlk    a6
    rts
