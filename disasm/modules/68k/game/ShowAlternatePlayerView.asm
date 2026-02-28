; ============================================================================
; ShowAlternatePlayerView -- Renders the alternate player info screen: loads background tiles, builds a 17-row info panel with competitor data (names, owned cities, aircraft) via sprintf + PrintfWide, then cleans up
; 746 bytes | $03DBE4-$03DECD
; ============================================================================
ShowAlternatePlayerView:
; --- Phase: Setup ---
; Args: $8(a6) = player_index (the player whose perspective we're showing)
; d6 = player_index (current player, used to exclude self from competitor list)
; d4 = VRAM tile offset for row commit loop (initialized to $FF51)
; d5 = current text cursor column (starts at 2, advances by 2 per row)
; d2 = row counter (0..$10 = 17 rows), d3 = competitor slot counter
; a3 = per-player data block pointer ($FF00A8 + player*$10)
; a4 = GameCommand indirect ($D64), a5 = sprintf ($3B22C)
; -$86(a6), -$84(a6), -$82(a6) = competitor index array (3 entries, word each)
    link    a6,#-$88
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6           ; d6 = player_index (current player to display for)
    movea.l  #$00000D64,a4       ; a4 = GameCommand dispatch pointer
    movea.l  #$0003B22C,a5       ; a5 = sprintf ($3B22C) for text formatting

; --- Phase: Background Screen Setup ---
; Initialize display, decompress background tile data, and configure tile windows
    clr.w   -$88(a6)             ; clear local flag at frame base
; DisplaySetup: set up the display context for this screen (mode 1, param 0)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$88(a6)
    jsr DisplaySetup
; GameCommand #$10: clear/reset display layer
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
; QueueVRAMWriteAddr: queue VRAM write address for upcoming tile upload
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w QueueVRAMWriteAddr
; PreLoopInit: one-time loop/display initialization (timers, state)
    jsr PreLoopInit
; FillRectColor: fill a rectangle with color ($12 wide, $20 tall) for background
    pea     ($0012).w
    pea     ($0020).w
    bsr.w FillRectColor
; LZ_Decompress: decompress background tile graphics from ROM $64660 to work buffer $FF1804 (save_buf_base)
    pea     ($00064660).l        ; ROM source: compressed background tile data
    pea     ($00FF1804).l        ; dest: save_buf_base work buffer
    jsr LZ_Decompress
    lea     $30(a7), a7
; GameCommand #5 (mode $AC0): bulk-load decompressed tiles from $FF1804 into VRAM
; Params: count=$20, source=$FF1804, VRAM dest=$AC0, mode 2, layer 5
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($00FF1804).l
    pea     ($0AC0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
; DisplaySetup: configure secondary tile window at ROM $644C0 (10 wide, 16 tall)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000644C0).l
    jsr DisplaySetup
    lea     $24(a7), a7
; GameCommand #$1B: place ROM tile block $644E0 into the tile map
; Params: tile addr=$644E0, col=$8, row=$6, width=$C, height=$10, layer 1
    pea     ($000644E0).l
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7

; --- Phase: Build Competitor Index Array ---
; Scan all 4 players (0..3); collect the 3 opponents (skip current player d6).
; Store competitor player indices in -$86(a6), -$84(a6), -$82(a6) (3 word slots).
; d3 = player scan index (0..3), d2 = competitor slot index (0..2)
    clr.w   d3                   ; d3 = current scan index (start at player 0)
    clr.w   d2                   ; d2 = competitor slot count
    bra.b   l_3dcbc              ; jump to loop condition check first
l_3dca8:
; Skip self: if this player index (d3) == current player (d6), don't record it
    cmp.w   d6, d3
    beq.b   l_3dcba              ; equal: this is the current player, skip
; Record competitor: store d3 into competitor array at slot d2
    move.w  d2, d0
    add.w   d0, d0               ; d0 = d2 * 2 (byte offset into word array)
    lea     -$86(a6), a0         ; a0 = base of competitor index array
    move.w  d3, (a0,d0.w)        ; competitor_array[d2] = d3 (opponent player index)
    addq.w  #$1, d2              ; advance to next competitor slot
l_3dcba:
    addq.w  #$1, d3              ; advance player scan index
l_3dcbc:
    cmpi.w  #$4, d3              ; scanned all 4 players?
    blt.b   l_3dca8              ; no: continue scan

; --- Phase: Finalize Background and Load Text Window ---
; Clear tile area, set VRAM write address, unload temporary resource, open text window
; GameCommand #$1A: clear the tile area (64 wide, 32 tall, at 0,0), priority $8000
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
; QueueVRAMWriteAddr: re-queue VRAM write address at offset -$AF
    clr.l   -(a7)
    pea     (-$AF).w
    bsr.w QueueVRAMWriteAddr
; ResourceUnload: release temporary tile graphics resource
    jsr ResourceUnload
; GameCommand #$E mode $28: display flush after tile setup
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a4)
    lea     $2c(a7), a7
; SetTextWindow: configure text window ($20 wide, $20 tall, at origin 0,0)
; This establishes the text output region for the 17-row info panel
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7

; --- Phase: Text Panel Rendering Setup ---
; d4 = VRAM tile offset for commit loop ($FF51 = first tile row in VRAM)
; d2 = row counter 0..$10 (17 rows total)
; d5 = text cursor column, starts at 2 (left margin), advances by 2 per row
; a3 = base of this player's $FF00A8 block (unknown; stride $10 per player)
; a2 = local sprintf output buffer at -$80(a6) (used for formatted strings)
    move.w  #$ff51, d4           ; d4 = starting VRAM tile row index ($FF51)
    clr.w   d2                   ; d2 = row index (0 = first info row)
    moveq   #$2,d5               ; d5 = text cursor column (col 2 = left margin)
; Compute per-player data pointer: $FF00A8 + (player_index * $10)
    move.w  d6, d0
    lsl.w   #$4, d0              ; d0 = player_index * $10 (16-byte stride)
    movea.l  #$00FF00A8,a0       ; a0 = base of unknown per-player block
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 = this player's data block
    bra.w   l_3deaa              ; jump to loop condition

; --- Phase: Per-Row Text Rendering Loop (17 rows, d2 = 0..$10) ---
; Each iteration: set text cursor, select and format row content via sprintf,
; call PrintfWide, then commit the rendered tile row to VRAM (16-tile commit loop).
l_3dd2c:
; SetTextCursor: position cursor at (column=d5, row=4) for this row's text
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    addq.l  #$8, a7
; Row 16 ($10): clear a tile area mid-panel before rendering (display boundary reset)
    cmpi.w  #$10, d2
    bne.b   l_3dd5e
; GameCommand #$1A: clear tile area (10 wide, 32 tall, at 0,0), priority $8000
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3dd5e:
; --- Row 0: Year display ---
; Compute current in-game year: frame_counter / 4 + $7A3 (1955 = Aerobiz base year)
; $FF0006 = frame_counter (increments each turn/quarter)
    tst.w   d2
    bne.b   l_3dd8e              ; not row 0: skip year
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.w  ($00FF0006).l, d0    ; d0 = frame_counter (raw turn count)
    ext.l   d0
    bge.b   l_3dd72
    addq.l  #$3, d0              ; round up for negative: (d0 + 3) >> 2 = ceil(d0 / 4)
l_3dd72:
    asr.l   #$2, d0              ; d0 = frame_counter / 4 = year offset (4 frames per year)
    addi.l  #$7a3, d0            ; d0 = year offset + $7A3 (1955) = current calendar year
    move.l  d0, -(a7)            ; push year value for sprintf
    move.l  ($0006588E).l, -(a7) ; push ROM format string pointer (e.g., "%d" year template)
l_3dd82:
; Common sprintf call: format string and args already on stack, dest = a2
    move.l  a2, -(a7)            ; push dest buffer pointer (local stack frame -$80(a6))
    jsr     (a5)                 ; call sprintf ($3B22C): format string -> a2 buffer
    lea     $c(a7), a7           ; clean 3 longwords (dest + 2 args)
    bra.w   l_3de66              ; jump to PrintfWide + tile commit

; --- Row 1: Current player name ---
; Format the current player's name using competitor data pointer (a3 = $FF00A8 block)
l_3dd8e:
    cmpi.w  #$1, d2
    bne.b   l_3dda2              ; not row 1: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.l  a3, -(a7)            ; push player data block pointer ($FF00A8 + player*$10)
    move.l  ($00065892).l, -(a7) ; push ROM format string pointer for player name
    bra.b   l_3dd82              ; common sprintf call

; --- Row 4: Cities owned (clamped to 7) ---
; $FF0004 = city count (word); add 4, cap at 7 before display
l_3dda2:
    cmpi.w  #$4, d2
    bne.b   l_3ddd8              ; not row 4: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.w  ($00FF0004).l, d0    ; d0 = current city count
    ext.l   d0
    addq.l  #$4, d0              ; d0 = city_count + 4 (offset from base?)
    moveq   #$7,d1
    cmp.l   d0, d1               ; is $7 >= adjusted count? ($7 <= d0 means cap)
    ble.b   l_3ddca              ; d0 >= 7: use capped value of 7
    move.w  ($00FF0004).l, d0    ; d0 = city_count (below cap, use real value + 4)
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)            ; push city count for sprintf
    bra.b   l_3ddd0
l_3ddca:
    move.l  #$7, -(a7)           ; push cap value 7 (max cities displayed = 7)
l_3ddd0:
    move.l  ($0006589E).l, -(a7) ; push ROM format string pointer for city count
    bra.b   l_3dd82              ; common sprintf call

; --- Row 6: Competitor 0 name ---
; competitor_array[0] = -$86(a6); compute its $FF00A8 data block pointer
l_3ddd8:
    cmpi.w  #$6, d2
    bne.b   l_3ddfa              ; not row 6: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.w  -$86(a6), d0         ; d0 = competitor_array[0] (first opponent player index)
    lsl.w   #$4, d0              ; d0 = opponent_index * $10 (stride into $FF00A8 block)
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)           ; push pointer to opponent 0's $FF00A8 data block
    move.l  ($000658A6).l, -(a7) ; push ROM format string for competitor name
    bra.b   l_3dd82              ; common sprintf call

; --- Row 7: Competitor 1 name ---
l_3ddfa:
    cmpi.w  #$7, d2
    bne.b   l_3de1e              ; not row 7: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.w  -$84(a6), d0         ; d0 = competitor_array[1] (second opponent player index)
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)           ; push pointer to opponent 1's $FF00A8 data block
    move.l  ($000658AA).l, -(a7) ; push ROM format string for competitor 1 name
    bra.w   l_3dd82

; --- Row 8: Competitor 2 name ---
l_3de1e:
    cmpi.w  #$8, d2
    bne.b   l_3de42              ; not row 8: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.w  -$82(a6), d0         ; d0 = competitor_array[2] (third opponent player index)
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)           ; push pointer to opponent 2's $FF00A8 data block
    move.l  ($000658AE).l, -(a7) ; push ROM format string for competitor 2 name
    bra.w   l_3dd82

; --- Row 10 ($A): Extended player data row ---
; Uses a3 (current player's $FF00A8 block) directly as the format argument
l_3de42:
    cmpi.w  #$a, d2
    bne.b   l_3de58              ; not row $A: skip
    lea     -$80(a6), a2         ; a2 = sprintf output buffer
    move.l  a3, -(a7)            ; push current player's $FF00A8 data block pointer
    move.l  ($000658B6).l, -(a7) ; push ROM format string for extended player data row
    bra.w   l_3dd82

; --- All other rows: ROM format string table lookup ---
; ROM table at $6588E: 4-byte entries indexed by row number (d2).
; Rows not explicitly handled (2, 3, 5, 9, 11..15) use static ROM strings as a2 directly.
l_3de58:
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2 * 4 (longword stride in pointer table)
    movea.l  #$0006588E,a0       ; a0 = ROM row format string pointer table
    movea.l (a0,d0.w), a2        ; a2 = ROM string pointer for this row (used as PrintfWide src)

; --- PrintfWide call and per-row tile commit ---
l_3de66:
; PrintfWide: render formatted string a2 into the tile buffer at current cursor position
    move.l  a2, -(a7)            ; push source string (either sprintf output or ROM string)
    pea     ($00046844).l        ; push font/display parameters for wide-character output
    jsr PrintfWide
; GameCommand #$E mode $50: flush text tile row to display
    pea     ($0050).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
; --- Phase: VRAM Tile Row Commit Loop ---
; After each text row, iterate 16 times to commit the 16 tiles of this row to VRAM.
; d3 = tile commit counter (0..$F = 16 tiles per row)
; d4 = VRAM tile offset (advances by 1 per tile, initialized to $FF51)
    clr.w   d3                   ; d3 = tile slot counter (0..15)
l_3de84:
; QueueVRAMWriteAddr: queue the next VRAM tile write address (d4 = current tile offset)
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMWriteAddr
; GameCommand #$E mode 2: commit this tile to VRAM
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d3              ; advance tile counter
    addq.w  #$1, d4              ; advance VRAM tile offset (next tile slot)
    cmpi.w  #$10, d3             ; committed all 16 tiles for this row?
    blt.b   l_3de84              ; no: commit next tile
; Advance to next row
    addq.w  #$1, d2              ; d2 = next row index
    addq.w  #$2, d5              ; d5 += 2: advance text cursor column by 2 for next row
; --- Phase: Loop Condition ---
l_3deaa:
    cmpi.w  #$11, d2             ; processed all 17 rows (0..$10)?
    blt.w   l_3dd2c              ; no: render next row

; --- Phase: Cleanup and Return ---
; GameCommand #$E mode $C8: final display flush after all rows committed
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a4)
; CmdSetBackground: restore/set the background display state on exit
    clr.l   -(a7)
    jsr CmdSetBackground
    movem.l -$ac(a6), d2-d6/a2-a5
    unlk    a6
    rts
