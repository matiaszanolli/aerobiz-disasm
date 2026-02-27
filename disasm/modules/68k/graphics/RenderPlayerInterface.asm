; ============================================================================
; RenderPlayerInterface -- Displays player pairing interface with compat bars; handles up/down selection and confirm/cancel
; 2326 bytes | $03857E-$038E93
; ============================================================================
; --- Phase: Setup ---
RenderPlayerInterface:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    ; a2 = pointer to char stat record (per-player stat record, $FF05C4-based)
    movea.l  #$00000D64,a4
    ; a4 = GameCommand dispatcher (cached for frequent calls throughout function)
    movea.l  #$0003AB2C,a5
    ; a5 = SetTextCursor (cached for frequent text-position calls)
    ; --- GameCommand #$1A: clear screen region at col $14, row $0B, width $07, height $02 ---
    ; tile $077E = blank/background tile; clears the compatibility bar area
    pea     ($077E).w
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    ; --- Locate the event_records entry for the active player ---
    ; GetByteField4: extracts the 4-byte-field index from the char stat record in a2
    move.l  a2, -(a7)
    jsr GetByteField4
    lea     $20(a7), a7
    ; d0 = byte field index (player slot index, low 16 bits only)
    andi.l  #$ffff, d0
    add.l   d0, d0
    ; d0 *= 2 (word stride within event_record row)
    move.w  $a(a6), d1
    ; d1 = match slot index (passed as second arg on stack at +$0A(a6))
    lsl.w   #$5, d1
    ; d1 *= 32 ($20) = stride of one event_record ($FFB9E8 base, 4 records × $20 bytes)
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    ; $FFB9E8 = event_records base (4 × $20 byte records: event/flight state)
    adda.l  d0, a0
    movea.l a0, a3
    ; a3 = pointer to this player's event_record entry
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; d0 = event_record[+$01]: number of available match partner slots
    move.w  d0, -$a(a6)
    ; -$a(a6) = local var: partner count (clamped to 9 max below)
    ; --- Clamp partner count to 9 (max displayable rows) ---
    cmpi.w  #$9, -$a(a6)
    bge.b   l_385f2
    move.w  -$a(a6), d0
    ext.l   d0
    bra.b   l_385f4
l_385f2:
    moveq   #$9,d0
    ; more than 9 partners available; cap display at 9
l_385f4:
    move.w  d0, -$a(a6)
    ; -$a(a6) = display row count, in [1..9]
    ; --- Phase: Draw Dialog and Header ---
    ; ShowDialog: display the dialog panel for this match slot (args: slot index + table ptr $48602)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048602).l, -(a7)
    ; $48602 = ROM pointer to dialog descriptor table for the pairing screen
    move.w  $a(a6), d0
    ext.l   d0
    ; d0 = match slot index (arg to ShowDialog selects dialog variant)
    move.l  d0, -(a7)
    jsr ShowDialog
    ; CheckMatchSlots: verify whether any valid partner slots exist for this slot index
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_38634
    ; d0 nonzero = valid matches found; print slot availability message
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_38634:
    ; SetTextWindow: set full-screen text window ($20×$20) to clear any scroll constraints
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; SetTextCursor at col 2, row 2 -- position for player name header
    pea     ($0002).w
    pea     ($0002).w
    jsr     (a5)
    ; --- Print player name (char stat record[+$00] = character type/identifier) ---
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = a2[+$00] = character base field (identifier/type byte)
    lsl.w   #$2, d0
    ; d0 *= 4 to index into longword pointer table at $5E7E4 (character name strings)
    movea.l  #$0005E7E4,a0
    ; $5E7E4 = ROM table of character name string pointers (4 bytes each)
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FDE).l
    ; $44FDE = format string for player name line (wide font)
    jsr PrintfWide
    ; --- Place icon tiles for the pairing display panel ---
    ; PlaceIconPair at col 2, row $0C -- left column player icon
    pea     ($0002).w
    pea     ($000C).w
    clr.l   -(a7)
    jsr PlaceIconPair
    lea     $2c(a7), a7
    ; PlaceIconPair at col 2, row $13, variant 1 -- compatibility icon row
    pea     ($0002).w
    pea     ($0013).w
    pea     ($0001).w
    jsr PlaceIconPair
    ; PlaceIconTiles at col 2, row $12, params 2,2 -- extra tile decorations
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0002).w
    jsr PlaceIconTiles
    ; SetTextCursor at col 2, row $0D -- position for partner name
    pea     ($0002).w
    pea     ($000D).w
    jsr     (a5)
    ; --- Print partner character name ---
    ; a2[+$01] = partner character type byte (primary skill/rating stat field)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    ; a2[+$00] = self character type -- both passed to CharCodeCompare
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    ; CharCodeCompare: compare two character codes, returns compatibility category index
    jsr CharCodeCompare
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    ; d0 = compatibility index (low word only; used as argument to format string)
    move.l  d0, -(a7)
    pea     ($00044FDA).l
    ; $44FDA = format string for compatibility category label (wide font)
    jsr PrintfWide
    lea     $2c(a7), a7
    ; SetTextCursor at col 2, row $14 -- position for partner name label
    pea     ($0002).w
    pea     ($0014).w
    jsr     (a5)
    ; --- Print partner name using name pointer table ---
    ; a2[+$01] = partner character type; same table lookup as above
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00044FD6).l
    ; $44FD6 = format string for partner name line (wide font)
    jsr PrintfWide
    ; --- Phase: Compute and Render Compatibility Bar ---
    ; CalcCompatScore: compute compatibility score between the two characters
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ; d0 = raw compatibility score (byte, sign-extended to long)
    ext.l   d0
    ; Divide by $14 (20) to map score to 0-7 bar segments
    moveq   #$14,d1
    jsr SignedDiv
    ; d4 = quotient = number of filled bar segments (0..N)
    move.w  d0, d4
    ; Clamp filled segments to max 7 (full bar)
    cmpi.w  #$7, d4
    bge.b   l_3872c
    move.w  d4, d3
    ext.l   d3
    bra.b   l_3872e
l_3872c:
    moveq   #$7,d3
    ; d3 = 7 (bar fully filled)
l_3872e:
    ; Draw filled bar tiles: tile $033E (filled segment), count=d3, at col $0B, row $14
    ; GameCommand #$1A fills a rectangle with a repeated tile
    pea     ($033E).w
    ; $033E = filled bar segment tile index
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d3 = number of filled bar segments to draw
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    ; --- Draw empty bar tiles for remainder of the 7-segment bar ---
    move.w  d4, d3
    addi.w  #$fff9, d3
    ; d3 = d4 - 7 (negative if bar not full; used to compute empty segment count)
    tst.w   d3
    ble.b   l_3877c
    ; if d3 > 0: score exceeds 7, draw overflow tiles at row $0C (second bar row)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3877c:
    ; --- Phase: Initialize Scrollable Partner List ---
    ; d2 = current selection row (starts at 0 = first partner)
    clr.w   d2
    ; SetTextCursor at col $0C, row $0E -- position for selection counter display
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    ; PrintfNarrow: display current selection index (d2=0 initially)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FD2).l
    ; $44FD2 = format string for "N of M" selection counter (narrow font)
    jsr PrintfNarrow
    ; d2 = current selected row (1-based after first increment)
    moveq   #$1,d2
    ; d5 = row start offset within the visible window (1 = top row)
    moveq   #$1,d5
    ; d7 = base Y pixel offset for the partner list (row $0E = 14)
    moveq   #$E,d7
    ; d6 = animation / blink phase counter
    clr.w   d6
; --- Phase: Build VDP Tile Index Array and Decompress Graphics ---
l_387a2:
    ; Fill local frame buffer word array at -$32(a6): 20 entries
    ; Each entry = d6 + $2D7F (VDP tile attribute base for list row d6)
    ; $2D7F = BAT attribute base: palette/priority bits for partner list tiles
    move.w  d6, d0
    addi.w  #$2d7f, d0
    move.w  d6, d1
    add.w   d1, d1
    ; d1 = d6*2 (word offset into local array at -$32(a6))
    move.w  d0, -$32(a6, d1.w)
    ; store computed tile attribute word at row d6 position
    addq.w  #$1, d6
    cmpi.w  #$14, d6
    ; loop 20 times (rows 0-19); $14 = 20 partner rows max
    blt.b   l_387a2
    ; --- Load and decompress graphics assets for the partner list panel ---
    ; DisplaySetup: set up display for $10×$10 tiles, using descriptor at $76A3E
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    ; LZ_Decompress: decompress partner panel background graphic to save_buf_base ($FF1804)
    move.l  ($000A1B04).l, -(a7)
    ; $A1B04 = ROM pointer to compressed background graphic data
    pea     ($00FF1804).l
    ; $FF1804 = save_buf_base (used as scratch decompression target)
    jsr LZ_Decompress
    ; CmdPlaceTile: write the decompressed tile data to VRAM via GameCommand
    ; args: source=$FF1804, row=$11, col=$59
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    ; --- Draw the "up" scroll arrow tile at the top of the list ---
    ; GameCommand #$1B: place tile $71A14 at col $0A, row d7, size $04 wide
    pea     ($00071A14).l
    ; $71A14 = ROM tile data for the up-arrow/scroll indicator
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d7 = row Y for the top arrow (= $0E)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d5 = column X for the list area (= 1)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    ; -$36(a6) = arrow-visible flag: 1 = up arrow shown, 0 = hidden
    move.w  #$1, -$36(a6)
    ; --- Render first visible partner name in the list (at list top position) ---
    ; SetTextCursor at (d7+2, d5+3) -- text row for first partner entry
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    ; Print partner name for entry (total_partners - current_row + 1)
    ; event_record[+$01] = total partner count for this slot
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    ; d0 = total partner count
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    addq.l  #$1, d0
    ; d0 = (total - current_row + 1) = index into partner name list to display
    move.l  d0, -(a7)
    pea     ($00044FCE).l
    ; $44FCE = format string for partner name (wide font)
    jsr PrintfWide
    lea     $2c(a7), a7
    ; --- GameCommand #$0E: wait / vblank sync before next render step ---
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a4)
    ; SetTextCursor at (d7+2, d5+3) again -- re-position for second pass
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    ; Print partner index below current selection (total_partners - current_row)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = (total - d2), one below the first entry
    move.l  d0, -(a7)
    pea     ($00044FCA).l
    ; $44FCA = format string for the "below" partner name (wide font)
    jsr PrintfWide
    ; --- DiagonalWipe: animated reveal of the partner list area ---
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; DiagonalWipe: screen transition reveal at (d5, d7), mode 1
    jsr DiagonalWipe
    ; --- Update the selection counter display (col $0C, row $0E) ---
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    lea     $2c(a7), a7
    ; PrintfNarrow: print current row index d2 as "N" in selection counter
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC6).l
    ; $44FC6 = format string for selection counter update (narrow font)
    jsr PrintfNarrow
    addq.l  #$8, a7
    ; --- Decide whether to show or hide the down-arrow indicator ---
    ; if (partner_count - 1 > 0): more rows below, keep arrow shown
    move.w  -$a(a6), d0
    ext.l   d0
    subq.l  #$1, d0
    ; d0 = partner_count - 1; if <= 0, no more below = hide arrow
    bgt.b   l_388fa
    ; Only one partner total -- draw the "no-down-arrow" tile to hide it
    pea     ($000719C4).l
    ; $719C4 = ROM tile for blank/down-arrow-hidden state
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    ; -$36(a6) = 0: up-arrow hidden (only 1 partner, nothing above)
    clr.w   -$36(a6)
l_388fa:
    ; --- Phase: Read Input and Decide Button Action ---
    ; ReadInput mode 0: check if button was held last frame (auto-fire detection)
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    ; d0 = nonzero if previous input was held (joypad still pressed)
    beq.b   l_3890c
    moveq   #$1,d6
    ; d6 = 1: input was already held -- enables auto-repeat in main input loop
    bra.b   l_3890e
l_3890c:
    moveq   #$0,d6
    ; d6 = 0: fresh input press
l_3890e:
    ; Reset input-mode state and RAM flags for a clean input read cycle
    clr.w   -$34(a6)
    ; -$34(a6) = saved input state from last ProcessInputLoop call
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear countdown/UI-input mode
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear ProcessInputLoop countdown started flag
    moveq   #$0,d0
    move.w  d0, -$38(a6)
    ; -$38(a6) = animation frame counter (reset to 0 for tile blink cycle)
    andi.l  #$ffff, d0
    ; --- Precompute tile X position for the highlight cursor ---
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    ; d7 * 8 = pixel X offset for the cursor row (each text row is 8 pixels)
    addi.l  #$c, d0
    ; +$0C = left column offset of the list area in pixels
    move.l  d0, -$4(a6)
    ; -$4(a6) = X pixel coordinate for selection cursor tile
    move.l  #$33e, -$8(a6)
    ; -$8(a6) = tile attribute word $033E (filled/highlight tile for the cursor)
; --- Phase: Input-Blink Animation Loop ---
; -$38(a6) cycles 0..30 ($1E); at frame 1 draw highlight tiles, at frame 15 clear them
l_38942:
    addq.w  #$1, -$38(a6)
    ; increment animation frame counter
    cmpi.w  #$1, -$38(a6)
    bne.b   l_389c4
    ; --- Frame 1: draw selection highlight cursor tiles ---
    ; TilePlacement: place solid cursor tile at list X position, row d5 (top tile)
    ; $8000 flag = high-priority sprite; $0772 = cursor tile variant A
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.l  -$4(a6), -(a7)
    ; -$4(a6) = pixel X of cursor (precomputed above as d7*8+$0C)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    ; d5 * 8 = pixel Y of cursor row
    move.l  d0, -(a7)
    pea     ($0039).w
    pea     ($0772).w
    ; $0772 = tile index for selection cursor (top half)
    jsr TilePlacement
    ; GameCommand #$0E: wait one vblank before placing the second tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    ; TilePlacement: place bottom half of cursor tile (+$48 pixels below = 9 rows)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.l  -$4(a6), -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$48, d0
    ; +$48 (72) pixels down = 9 text rows below top cursor position
    move.l  d0, -(a7)
    pea     ($003A).w
    pea     ($0773).w
    ; $0773 = tile index for selection cursor (bottom half)
    jsr TilePlacement
    lea     $1c(a7), a7
l_389b6:
    ; GameCommand #$0E: wait one vblank (pacing/sync)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   l_389ea
l_389c4:
    cmpi.w  #$f, -$38(a6)
    bne.b   l_389de
    ; --- Frame 15: erase cursor highlight (GameCmd16 #$39 clears sprite layer region) ---
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    ; GameCmd16 #$39 = clear the sprite entries placed for the cursor highlight
    addq.l  #$8, a7
    bra.b   l_389b6
l_389de:
    cmpi.w  #$1e, -$38(a6)
    bne.b   l_389ea
    ; --- Frame 30: reset counter to restart blink cycle ---
    clr.w   -$38(a6)
    ; animation loops: on frame 1 draw, frame 15 erase, frame 30 reset
l_389ea:
    ; --- Check whether input is held (auto-repeat path) ---
    tst.w   d6
    beq.b   l_389fe
    ; d6=1: input was held; poll again to check if still pressed
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    ; if still pressed, loop back to animate again without processing new input
    bne.w   l_38942
    ; input released -- fall through to fresh ProcessInputLoop read
; --- Phase: Process Input Button Dispatch ---
l_389fe:
    clr.w   d6
    ; d6 = 0: input-held flag cleared for next cycle
    ; ProcessInputLoop: poll joypad with $0A frame timeout; returns button bits
    move.w  -$34(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    ; mask to relevant buttons: $BC = 1011 1100 = Up/Down/A/B (no Start/C)
    move.w  d0, -$34(a6)
    ; save masked button result for next frame's auto-repeat seed
    ext.l   d0
    ; --- Button dispatch: branch to handler based on which button was pressed ---
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_38a46
    ; $20 = A button: confirm selection (accept this partner pairing)
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38aba
    ; $10 = B button: cancel / back out of pairing screen
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38b00
    ; $04 = Up: scroll partner list up (decrease selection index)
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_38c82
    ; $08 = Down: scroll partner list down (increase selection index)
    cmpi.w  #$80, d0
    beq.w   l_38dd2
    ; $80 = Start: confirm/browse partners action
    bra.w   l_38e6e
    ; no relevant button -- go to idle/update path
; --- A Button: Confirm Partner Selection ---
l_38a46:
    ; Reset input/display flags before committing the selection
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear
    ; UpdateCharField: write selected partner row (d2) into the char stat record
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d2 = confirmed selection row index (1-based)
    move.l  a2, -(a7)
    ; a2 = char stat record for the current player
    jsr UpdateCharField
    ; UpdateCharField updates a2[+$0B] and related fields with the new pairing
    ; GameCommand #$1A: clear the highlight tile region (col 1, row 1, 10×14 area)
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $24(a7), a7
    ; GameCommand #$1A: clear partner list area (second call to erase residual tiles)
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    ; GameCmd16 #$39: clear sprite layer for the cursor tiles
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    ; return code 2 = partner confirmed
    moveq   #$2,d0
    bra.w   l_38e8a
; --- B Button: Cancel / Back ---
l_38aba:
    ; Reset input/display state
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    ; GameCommand #$1A: clear the full partner list area ($20 wide, $0E tall, from col 1)
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    ; ClearTileArea: erase any residual tile graphics left in the panel
    jsr ClearTileArea
    ; GameCmd16 #$39: clear sprite layer (cursor tiles)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    ; return code 0 = cancelled
    moveq   #$0,d0
    bra.w   l_38e8a
; --- Up Button: Scroll Partner List Upward ---
l_38b00:
    ; $FF13FC = input_mode_flag: set to 1 to mark active input processing
    move.w  #$1, ($00FF13FC).l
    ; Decrement selection row
    subq.w  #$1, d2
    ; d2-- = move selection one row up
    ; Check if there are more entries above the current view window
    ; (partner_count - d2) > 0 AND partner_count > 1 AND up-arrow not already shown
    move.w  -$a(a6), d0
    ext.l   d0
    ; d0 = partner_count (max rows to show)
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = partner_count - new_d2; if <= 0, already at top of list
    ble.b   l_38b54
    cmpi.w  #$1, -$a(a6)
    ble.b   l_38b54
    ; only 1 partner total -- no scrolling possible
    tst.w   -$36(a6)
    bne.b   l_38b54
    ; -$36(a6) nonzero = up-arrow already displayed, skip redrawing it
    ; Show up-arrow tile: $71A14 = scroll-up indicator, at (d5, d7), size $04, GameCmd #$1B
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$36(a6)
    ; -$36(a6) = 1: up-arrow is now visible
l_38b54:
    ; --- Update display for Up scroll: redraw counter and scroll content ---
    tst.w   d2
    ble.b   l_38b94
    ; if d2 <= 0, already at top; skip counter update
    ; SetTextCursor at col $0C, row $0E -- selection counter position
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    ; PrintfNarrow: update the "N of M" counter with new d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FC2).l
    ; $44FC2 = format string for counter (narrow font, Up-scroll variant)
    jsr PrintfNarrow
    ; DiagonalWipe: animate scroll reveal upward (mode 0, target row d5+$0D)
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addi.l  #$d, d0
    move.l  d0, -(a7)
    jsr DiagonalWipe
    lea     $1c(a7), a7
l_38b94:
    ; Clamp d2 to minimum 1 (can't select row 0)
    cmpi.w  #$1, d2
    ble.b   l_38ba0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_38ba2
l_38ba0:
    moveq   #$1,d0
    ; d2 clamped to 1 (first valid selection row)
l_38ba2:
    move.w  d0, d2
    ; SetTextCursor at (d7+2, d5+3) for the current partner name cell
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    ; Print newly highlighted partner name: total_partners - d2
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; a3[+$01] = total partner count in event_record
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBE).l
    ; $44FBE = format string for partner name after Up scroll (wide font)
    jsr PrintfWide
    ; --- Recompute compatibility bar for newly selected partner ---
    ; CalcCompatScore * d2 / $14 = compatibility bar fill for d2 partners
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $14(a7), a7
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    ; Multiply compatibility score by d2 (number of selected partners weighting)
    jsr Multiply32
    moveq   #$14,d1
    ; Divide by $14 (20) to get bar fill count
    jsr SignedDiv
    move.w  d0, d4
    ; d4 = new bar fill count
    ; Compute overflow (d4 - 7): if positive, two-row bar
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    ble.b   l_38c04
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38c06
l_38c04:
    moveq   #$0,d3
    ; d3 = 0: no overflow (bar not over-full)
l_38c06:
    ; --- Draw empty tiles in second bar row (clear overflow area) ---
    cmpi.w  #$7, d3
    bge.b   l_38c3a
    ; d3 < 7: draw (7-d3) blank tiles at row $0C (second compat bar row)
    pea     ($077E).w
    ; $077E = blank tile (clears bar segment)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    ; d1 = 7 - d3 = number of empty slots to fill
    move.l  d1, -(a7)
    pea     ($000C).w
    ; row $0C = second compat bar row
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    ; col = d3 + $14 = start of blank region within bar
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_38c3a:
    ; --- Draw empty tiles in first bar row (clear excess) ---
    cmpi.w  #$7, d4
    bge.b   l_38c46
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38c48
l_38c46:
    moveq   #$7,d3
    ; d3 capped at 7 (maximum first-row fill)
l_38c48:
    cmpi.w  #$7, d3
    bge.w   l_38e7a
    ; if already 7 filled, skip clearing (bar is full)
    ; Draw (7-d3) blank tiles at row $0B (first compat bar row, clearing old fill)
    pea     ($077E).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000B).w
    ; row $0B = first compat bar row
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_38c72:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   l_38e7a
; --- Down Button: Scroll Partner List Downward ---
l_38c82:
    move.w  #$1, ($00FF13FC).l
    ; $FF13FC = input_mode_flag: set 1 to indicate active input cycle
    addq.w  #$1, d2
    ; d2++ = advance selection one row down
    cmp.w   -$a(a6), d2
    ; compare new d2 with partner_count (-$a(a6))
    bgt.b   l_38cda
    ; if d2 > partner_count, selection is past the end -- clamp below
    ; Show newly selected partner name (one row below the previous selection)
    ; SetTextCursor at (d7+2, d5+3) for the partner name cell
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    ; Print partner name for (total_partners - d2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FBA).l
    ; $44FBA = format string for partner name after Down scroll (wide font)
    jsr PrintfWide
    ; DiagonalWipe: animated scroll reveal downward (mode 1, row d7)
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DiagonalWipe
    lea     $1c(a7), a7
l_38cda:
    ; Clamp d2 to partner_count maximum
    cmp.w   -$a(a6), d2
    bge.b   l_38ce4
    move.w  d2, d0
    bra.b   l_38ce8
l_38ce4:
    move.w  -$a(a6), d0
    ; d0 = partner_count (clamp to max)
l_38ce8:
    ext.l   d0
    move.w  d0, d2
    ; d2 = clamped selection index
    ; SetTextCursor at col $0C, row $0E -- selection counter position
    pea     ($000C).w
    pea     ($000E).w
    jsr     (a5)
    ; PrintfNarrow: print new selection counter value d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FB6).l
    ; $44FB6 = format string for counter update after Down scroll (narrow font)
    jsr PrintfNarrow
    lea     $10(a7), a7
    ; --- Check if up-arrow should be hidden (reached bottom of list) ---
    move.w  -$a(a6), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = partner_count - d2: if <= 0, d2 is at or past the last entry
    bgt.b   l_38d4e
    cmpi.w  #$1, -$36(a6)
    bne.b   l_38d4e
    ; -$36(a6) == 1 = up-arrow is visible; hide it since we're at the bottom
    pea     ($000719C4).l
    ; $719C4 = blank/down-arrow-off tile
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$36(a6)
    ; -$36(a6) = 0: up-arrow hidden
l_38d4e:
    ; --- Recompute compatibility bar for new Down-scroll selection ---
    ; Same bar calculation as the Up handler: score * d2 / 20, clamped to 7
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d4
    ; d4 = new bar fill count
    cmpi.w  #$7, d4
    bge.b   l_38d78
    move.w  d4, d3
    ext.l   d3
    bra.b   l_38d7a
l_38d78:
    moveq   #$7,d3
    ; d3 capped at 7
l_38d7a:
    ; Draw filled bar tiles: use -$8(a6) (= $033E) as the tile index
    move.l  -$8(a6), -(a7)
    ; -$8(a6) = $033E = filled bar segment tile (precomputed at init)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d3 = number of filled segments for first bar row
    pea     ($000B).w
    ; row $0B = first compat bar row
    pea     ($0014).w
    ; col $14 = start of bar area
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    ; Compute overflow (d4 - 7) for second bar row
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    moveq   #$7,d0
    cmp.l   d3, d0
    ble.b   l_38db0
    move.w  d4, d3
    ext.l   d3
    subq.l  #$7, d3
    bra.b   l_38db2
l_38db0:
    moveq   #$7,d3
    ; d3 capped at 7 for overflow row
l_38db2:
    tst.w   d3
    ble.w   l_38e7a
    ; d3 <= 0: no overflow segments, skip second bar row
    ; Draw overflow filled tiles in second bar row (row $0C)
    move.l  -$8(a6), -(a7)
    ; -$8(a6) = $033E = filled segment tile
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    ; row $0C = second compat bar row (overflow segments)
    pea     ($0014).w
    bra.w   l_38c72
    ; tail-call shared: draw the overflow bar tiles then jump to l_38e7a
; --- Start Button: Browse Full Partner List ---
l_38dd2:
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear before partner browse
    ; Re-check match slot validity before entering browse mode
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_38e7a
    ; CheckMatchSlots returned 1 = valid match slots exist; proceed to browse
    ; BrowsePartners: interactive full-list partner browser
    ; args: slot index, self char code (a2[+$00]), partner char code (a2[+$01])
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; a2[+$01] = partner character type (primary stat/rating field)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ; a2[+$00] = self character type
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    ; BrowsePartners shows the full interactive partner selection screen
    ; GameCommand #$1A: clear partner browser display area ($12 wide, $1E tall)
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    ; Redraw the pairing dialog after returning from browse
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048602).l, -(a7)
    ; $48602 = ROM dialog descriptor table pointer (same as initial ShowDialog call)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    ; Redraw match slot status message
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    ; Restore full-screen text window
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    bra.b   l_38e7a
; --- No Relevant Button: Idle Path ---
l_38e6e:
    ; No actionable button pressed; reset input state and continue looping
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear (no UI action taken)
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear ProcessInputLoop countdown state
l_38e7a:
    ; --- Loop Tail: advance display by 3 frames then restart blink loop ---
    pea     ($0003).w
    pea     ($000E).w
    ; GameCommand #$0E: wait $03 frames (pace the UI to ~20fps)
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   l_38942
    ; restart the blink/input animation loop
l_38e8a:
    ; --- Phase: Epilogue ---
    ; Restore callee-saved registers from link frame
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts
