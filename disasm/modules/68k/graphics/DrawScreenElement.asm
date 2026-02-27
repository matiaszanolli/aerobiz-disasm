; ============================================================================
; DrawScreenElement -- Draws a char attribute tile panel with stat bar and level delta; computes stat delta vs baseline, decompresses the bar graphic, and navigates with Up/Down/A/B input.
; 1878 bytes | $0154F8-$015C4D
; ============================================================================
; --- Phase: Setup and Stat Delta Computation ---
DrawScreenElement:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    ; a2 = pointer to char stat record (per-player stat, $FF05C4-based)
    movea.l  #$00000D64,a4
    ; a4 = GameCommand dispatcher (cached)
    lea     -$2e(a6), a5
    ; a5 = pointer to local word variable -$2e(a6), used as partner count storage
    ; --- Compute stat delta for character A (self): city_data[char_type * 8 + stat_type * 2] - base ---
    ; $FFBA80 = city_data (89 cities × 4 entries × 2 bytes = stride-2 storage)
    ; $FFBA81 = first byte within each stride-2 word entry (odd byte = low byte of city stat)
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = a2[+$00] = character base field (char type / identifier)
    lsl.w   #$3, d0
    ; d0 *= 8 (stride: 4 entries × 2 bytes per city row)
    move.w  $a(a6), d1
    ; d1 = stat_type (second argument, passed at +$0A(a6))
    add.w   d1, d1
    ; d1 *= 2 (word stride within the 4-entry city row)
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    ; $FFBA81 = city_data odd-byte base (actual stat value byte)
    move.b  (a0,d0.w), d0
    ; d0 = city stat value for self character at this stat_type
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ; a2[+$03] = cap/limit value (baseline stat to compare against)
    sub.w   d1, d0
    ; d0 = delta: (city_stat - baseline); positive = stat improvement
    move.w  d0, -$32(a6)
    ; -$32(a6) = self stat delta (used later for display)
    ; --- Compute stat delta for character B (partner): same formula with a2[+$01] ---
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; a2[+$01] = partner character type (primary skill/rating field)
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ; a2[+$03] = same baseline for both characters
    sub.w   d1, d0
    ; d0 = partner stat delta
    move.w  d0, -$34(a6)
    ; -$34(a6) = partner stat delta (used later for display)
    ; --- Locate event_record for the active player (same pattern as RenderPlayerInterface) ---
    move.l  a2, -(a7)
    jsr GetByteField4
    ; d0 = player slot index from char stat record
    andi.l  #$ffff, d0
    add.l   d0, d0
    ; d0 *= 2 (word stride)
    move.w  $a(a6), d1
    lsl.w   #$5, d1
    ; d1 *= 32 = event_record stride ($20 bytes each)
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    ; $FFB9E8 = event_records base (4 × $20 byte player event/flight records)
    adda.l  d0, a0
    movea.l a0, a3
    ; a3 = this player's event_record pointer
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; a3[+$01] = partner count available for this slot
    move.w  d0, (a5)
    ; (a5) = local partner count word at -$2e(a6)
    moveq   #$0,d6
    move.b  $b(a2), d6
    ; d6 = a2[+$0B] = computed/cached value field (secondary cap or previous score)
    ; Clamp partner count to 9
    cmpi.w  #$9, (a5)
    bge.b   .l155a0
    move.w  (a5), d0
    ext.l   d0
    bra.b   .l155a2
.l155a0:
    moveq   #$9,d0
    ; clamp: max 9 displayed rows
.l155a2:
    move.w  d0, (a5)
    ; (a5) = clamped partner count
    ; GetLowNibble: extract the low nibble from the char stat record (selection index)
    move.l  a2, -(a7)
    jsr GetLowNibble
    ; d0 = low nibble of char record = initial selection row
    move.w  d0, d3
    ; d3 = current selected row index
    move.w  d0, -$2(a6)
    ; -$2(a6) = original selection (saved to detect changes at confirm time)
    ; --- Phase: Build VDP Tile Array and Decompress Graphics ---
    ; SetTextWindow: full-screen ($20×$20) to clear scroll constraints
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; d7 = $12 = base Y row offset for the stat bar panel (row 18)
    moveq   #$12,d7
    ; Fill local tile attribute array at -$2a(a6): 20 entries, same pattern as RenderPlayerInterface
    clr.w   d2
.l155c8:
    ; entry = d2 + $2D7F (VDP tile attribute base)
    move.w  d2, d0
    addi.w  #$2d7f, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$2a(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    ; loop 20 times ($14 = 20 tile rows)
    blt.b   .l155c8
    ; DisplaySetup: configure display for $10×$10 tiles with descriptor at $76A3E
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    ; LZ_Decompress: decompress stat-bar background graphic to $FF1804 (save_buf_base)
    move.l  ($000A1B04).l, -(a7)
    ; $A1B04 = ROM pointer to compressed panel background graphic
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7
    ; CmdPlaceTile: write decompressed tiles to VRAM (col $59, row $11, source $FF1804)
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $c(a7), a7
    ; --- Decide whether to draw up-arrow or blank based on whether list can scroll up ---
    ; (a5) = partner count, d3 = current selection; if count > selection, arrow can scroll
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = partner_count - d3; if <= 0 only one option, no up-scroll
    ble.b   .l1565a
    ; Draw up-scroll arrow tile ($71A14) at (d7, col $0A)
    pea     ($00071A14).l
    ; $71A14 = scroll-up arrow tile
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
    ; -$30(a6) = 1: up-arrow is currently visible
    bra.b   .l15684
.l1565a:
    ; Draw blank arrow tile ($719C4) -- hide the up-arrow
    pea     ($000719C4).l
    ; $719C4 = blank/no-arrow tile
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
    ; -$30(a6) = 0: arrow hidden (only one choice or at top already)
.l15684:
    ; --- Render the initial selected stat entry ---
    ; SetTextCursor at (d7+2, col 4) for the stat value text row
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    ; Print stat value: a3[+$01] (event_record primary stat) minus d3 (selection offset)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; a3[+$01] = total available stat points / partner count in event_record
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = (total - d3) = stat value for the selected row
    move.l  d0, -(a7)
    pea     ($0003F854).l
    ; $3F854 = format string for stat value display (wide font)
    jsr PrintfWide
    ; --- Read input to determine auto-repeat state ---
    ; ReadInput mode 0: check if button was already held last frame
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l156c6
    moveq   #$1,d2
    ; d2 = 1: input was held -- enable auto-repeat in main loop
    bra.b   .l156c8
.l156c6:
    moveq   #$0,d2
    ; d2 = 0: fresh press
.l156c8:
    ; Reset input state variables for a clean input cycle
    clr.w   -$2c(a6)
    ; -$2c(a6) = saved ProcessInputLoop state (cleared)
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear
    clr.w   d4
    ; d4 = exit flag (0 = keep looping; $FF = exit)
    clr.w   -$36(a6)
    ; -$36(a6) = animation frame counter
    bra.w   .l15bc0
    ; jump to the loop condition check (enters main input loop)
; --- Phase: Main Input-Blink Animation Loop ---
.l156e2:
    ; SetTextCursor at col $10, row $0E -- position for the "N of M" selection counter
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    ; PrintfNarrow: display current selection d3 as counter
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F850).l
    ; $3F850 = format string for selection index counter (narrow font)
    jsr PrintfNarrow
    lea     $10(a7), a7
    ; If auto-repeat (d2=1), poll input again to check for held button
    tst.w   d2
    beq.b   .l1571a
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    ; if input still held, jump to idle tail (keep blinking without new action)
    bne.w   .l15bb4
.l1571a:
    ; Clear auto-repeat flag; process blink frame counter
    clr.w   d2
    addq.w  #$1, -$36(a6)
    ; -$36(a6) = blink animation frame counter (same 30-frame cycle as RenderPlayerInterface)
    cmpi.w  #$1, -$36(a6)
    bne.b   .l157a4
    ; --- Frame 1: draw selection cursor tiles ---
    ; TilePlacement: place top cursor tile at (d7*8 + $0C, col $08), tile $0772
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    ; d7 * 8 = pixel Y for cursor row
    addi.l  #$c, d0
    ; +$0C = left panel offset
    move.l  d0, -(a7)
    pea     ($0008).w
    ; width = 8 pixels (1 tile)
    pea     ($0039).w
    pea     ($0772).w
    ; $0772 = cursor highlight tile (top)
    jsr TilePlacement
    ; Wait 1 frame between tile placements
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    ; TilePlacement: place bottom cursor tile ($0773) at same X, +$50 pixels down
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    ; +$50 = 80 pixels = 10 text rows below top cursor position
    pea     ($003A).w
    pea     ($0773).w
    ; $0773 = cursor highlight tile (bottom)
    jsr TilePlacement
    lea     $1c(a7), a7
.l15796:
    ; Wait 1 frame between blink phases
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l157ca
.l157a4:
    cmpi.w  #$f, -$36(a6)
    bne.b   .l157be
    ; --- Frame 15: erase cursor (GameCmd16 #$39 clears sprite region) ---
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l15796
.l157be:
    cmpi.w  #$1e, -$36(a6)
    bne.b   .l157ca
    ; --- Frame 30: reset blink counter for next cycle ---
    clr.w   -$36(a6)
.l157ca:
    ; --- Process input: poll joypad with $0A frame timeout ---
    move.w  -$2c(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    ; $3C = 0011 1100 = Up/Down/A/B only (DrawScreenElement uses narrower mask than RenderPlayerInterface's $BC)
    move.w  d0, -$2c(a6)
    ; save for next frame's auto-repeat seed
    ext.l   d0
    ; --- Button dispatch ---
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l15808
    ; $20 = A button: confirm selection
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l158f4
    ; $10 = B button: cancel
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15924
    ; $04 = Up: decrease selection (scroll up)
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15a80
    ; $08 = Down: increase selection (scroll down)
    bra.w   .l15ba8
    ; no relevant button -- idle path
; --- A Button: Confirm Selection and Write Updated Stats ---
.l15808:
    ; Reset input/display flags
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    ; If selection hasn't changed, skip writing (no-op confirm)
    cmp.w   -$2(a6), d3
    ; -$2(a6) = original selection saved at entry; d3 = current selection
    beq.w   .l15bc8
    ; --- Update char field with new selection ---
    ; UpdateCharField: write d3 as new field value into char stat record a2
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    ; --- Clamp a2[+$03] to d6 (the cached cap value loaded at entry) ---
    ; a2[+$03] = cap/limit byte; d6 = a2[+$0B] original cap value
    moveq   #$0,d0
    move.b  $3(a2), d0
    ; d0 = current cap value after UpdateCharField
    move.w  d6, d1
    ext.l   d1
    cmp.l   d1, d0
    ; if current cap >= d6, keep d6 as the clamped value
    bge.b   .l15840
    moveq   #$0,d0
    move.b  $3(a2), d0
    bra.b   .l15844
.l15840:
    move.w  d6, d0
    ext.l   d0
    ; d0 = d6 (clamped cap value)
.l15844:
    move.b  d0, $3(a2)
    ; a2[+$03] = clamped new cap/limit value
    ; --- Write updated stat for self character (char A) to city_data ---
    ; formula: city_data[char_A_type * 8 + stat_type * 2] = self_delta + new_cap
    move.b  -$31(a6), d0
    ; -$31(a6) = byte above -$32(a6) (low byte of self stat delta word -$32)
    add.b   $3(a2), d0
    ; d0 = stat_delta_self_low_byte + new cap = new stat value for char A
    moveq   #$0,d1
    move.b  (a2), d1
    ; a2[+$00] = self char type
    lsl.w   #$3, d1
    ; d1 *= 8 = city row offset for char A
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    ; temporarily use d7 to compute stat_type*2, then swap back to a0
    add.w   a0, d1
    ; d1 = char_A_row + stat_type*2 = index into city_data
    movea.l  #$00FFBA81,a0
    ; $FFBA81 = city_data odd-byte base
    move.b  d0, (a0,d1.w)
    ; write new char A stat value back to city_data RAM
    ; --- Write updated stat for partner character (char B) to city_data ---
    move.b  -$33(a6), d0
    ; -$33(a6) = low byte of partner stat delta -$34(a6)
    add.b   $3(a2), d0
    ; d0 = partner_delta + new cap = new stat for char B
    moveq   #$0,d1
    move.b  $1(a2), d1
    ; a2[+$01] = partner char type
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    ; write new char B stat value back to city_data RAM
    ; --- Display updated stat values for both characters ---
    ; SetTextCursor at col 8, row 5 -- position for char A stat display
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    ; PrintfNarrow: display self stat = original delta + new cap
    move.w  -$32(a6), d0
    ; -$32(a6) = self stat delta (computed at function entry)
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ; a2[+$03] = new cap value (just written)
    ext.l   d1
    add.l   d1, d0
    ; d0 = delta + cap = absolute stat value to display
    move.l  d0, -(a7)
    pea     ($0003F84C).l
    ; $3F84C = format string for char A stat line (narrow font)
    jsr PrintfNarrow
    ; SetTextCursor at col 8, row $15 -- position for char B stat display
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $20(a7), a7
    ; PrintfNarrow: display partner stat = partner delta + new cap
    move.w  -$34(a6), d0
    ; -$34(a6) = partner stat delta
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F848).l
    ; $3F848 = format string for char B stat line (narrow font)
.l158e8:
    jsr PrintfNarrow
    addq.l  #$8, a7
    bra.w   .l15bc8
    ; jump to exit sequence (selection confirmed, done)
; --- B Button: Cancel (Revert to Original Selection) ---
.l158f4:
    ; Reset input/display state
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    ; Move cursor to col $10, row $0E (counter position) to show reverted value
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    addq.l  #$8, a7
    ; GetLowNibble: re-read the original selection from the char stat record
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    ; d0 = original low-nibble value (reverted selection)
    move.l  d0, -(a7)
    pea     ($0003F844).l
    ; $3F844 = format string for reverted selection display (narrow font)
    bra.b   .l158e8
    ; shared tail: print and jump to exit
; --- Up Button: Scroll Stat Bar Up (Decrease Selection) ---
.l15924:
    move.w  #$1, ($00FF13FC).l
    ; $FF13FC = input_mode_flag: set 1
    subq.w  #$1, d3
    ; d3-- = move selection up
    ; Check if arrow needs to be shown (same guard as RenderPlayerInterface Up handler)
    move.w  (a5), d0
    ext.l   d0
    ; d0 = partner count
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   .l15972
    ; d0 <= 0: at or past top, no scroll
    cmpi.w  #$1, (a5)
    ble.b   .l15972
    ; only 1 option total
    tst.w   -$30(a6)
    bne.b   .l15972
    ; -$30(a6) already 1 = up-arrow visible, skip redraw
    ; Show up-arrow tile ($71A14) at (d7, col $0A)
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
    ; -$30(a6) = 1: up-arrow now visible
.l15972:
    ; DiagonalWipe: animate scroll reveal upward if d3 > 0
    tst.w   d3
    ble.b   .l1598e
    clr.l   -(a7)
    ; mode 0 = upward reveal
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l1598e:
    ; Clamp d3 to minimum 1
    cmpi.w  #$1, d3
    ble.b   .l1599a
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1599c
.l1599a:
    moveq   #$1,d0
.l1599c:
    move.w  d0, d3
    ; d3 = clamped selection (min 1)
    ; SetTextCursor at (d7+2, col 4) for newly highlighted stat row
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    ; Print stat value: a3[+$01] - d3
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F840).l
    ; $3F840 = format string for Up-scroll stat value (wide font)
    jsr PrintfWide
    ; --- Recompute compatibility bar after Up scroll ---
    ; score * d3 / 20, capped to 7
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $14(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    ; d6 = new bar fill
    move.w  d0, d6
    ; Compute overflow (d6 - 7) for second bar row
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    ble.b   .l159fe
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15a00
.l159fe:
    moveq   #$0,d5
    ; d5 = 0: no overflow
.l15a00:
    ; Draw (7 - d5) blank tiles in second bar row at row $10 (clear excess overflow)
    cmpi.w  #$7, d5
    bge.b   .l15a36
    pea     ($077E).w
    ; $077E = blank tile
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    ; row $10 = second compat bar row (DrawScreenElement uses row $10/$0F vs $0C/$0B)
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
.l15a36:
    ; Clamp d6 to 7 for first-row clear computation
    cmpi.w  #$7, d6
    bge.b   .l15a42
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15a44
.l15a42:
    moveq   #$7,d5
.l15a44:
    ; Draw (7 - d5) blank tiles in first bar row at row $0F (clear old fill)
    cmpi.w  #$7, d5
    bge.w   .l15bb4
    pea     ($077E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000F).w
    ; row $0F = first compat bar row
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
.l15a6e:
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l15bb4
; --- Down Button: Scroll Stat Bar Down (Increase Selection) ---
.l15a80:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d3
    ; d3++ = advance selection one row down
    cmp.w   (a5), d3
    bgt.b   .l15aa6
    ; if d3 <= partner_count: DiagonalWipe for downward scroll reveal
    pea     ($0001).w
    ; mode 1 = downward reveal
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l15aa6:
    ; Clamp d3 to maximum partner count
    cmp.w   (a5), d3
    bge.b   .l15aae
    move.w  d3, d0
    bra.b   .l15ab0
.l15aae:
    move.w  (a5), d0
    ; d0 = partner_count (clamp)
.l15ab0:
    ext.l   d0
    move.w  d0, d3
    ; SetTextCursor at (d7+2, col 4) for new stat row
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    ; Print stat value: a3[+$01] - d3
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F83C).l
    ; $3F83C = format string for Down-scroll stat value (wide font)
    jsr PrintfWide
    lea     $10(a7), a7
    ; Check if up-arrow should be hidden (at bottom of list)
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ; d0 = partner_count - d3: if <= 0, at bottom
    bgt.b   .l15b24
    cmpi.w  #$1, -$30(a6)
    bne.b   .l15b24
    ; -$30(a6) = 1: arrow is shown; hide it now
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
    ; -$30(a6) = 0: up-arrow hidden
.l15b24:
    ; --- Recompute filled bar tiles (Down scroll) ---
    ; Draw d5 filled segments ($033E) at row $0F (first bar row)
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    ; d6 = new bar fill count
    move.w  d0, d6
    cmpi.w  #$7, d6
    bge.b   .l15b4e
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15b50
.l15b4e:
    moveq   #$7,d5
    ; d5 = 7 (capped)
.l15b50:
    ; Draw d5 filled bar tiles at row $0F, col $14
    pea     ($033E).w
    ; $033E = filled bar segment tile
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    ; row $0F = first compat bar row
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    ; Compute overflow for second bar row
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    moveq   #$7,d0
    cmp.l   d5, d0
    ble.b   .l15b88
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15b8a
.l15b88:
    moveq   #$7,d5
    ; d5 = 7 (capped overflow)
.l15b8a:
    tst.w   d5
    ble.b   .l15bb4
    ; d5 <= 0: no overflow, skip second bar row
    ; Draw d5 filled overflow tiles at row $10, col $14 via shared tail
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    ; row $10 = second compat bar row (overflow)
    pea     ($0014).w
    bra.w   .l15a6e
    ; shared tail: draw tiles then go to idle
; --- No Relevant Button: Idle ---
.l15ba8:
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear (no action)
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear
.l15bb4:
    ; Wait 3 frames then restart blink loop (paces UI to ~20fps)
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
.l15bc0:
    ; Loop condition: d4 == $FF means exit (set by confirm path)
    cmpi.w  #$ff, d4
    bne.w   .l156e2
    ; d4 != $FF: continue looping
.l15bc8:
    ; --- Phase: Epilogue -- Commit and Show Relation Results ---
    ; GameCmd16 #$39: clear sprite layer before showing results
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    ; ShowRelationAction: display the action taken for this pairing (col $10, row $09, mode 1)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    ; a2 = char stat record (passed for character identity lookup)
    jsr ShowRelationAction
    ; ShowRelationResult: display the outcome/result of the pairing action (col $10, row $0D, mode 1)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationResult
    lea     $30(a7), a7
    ; GameCommand #$1A: clear the result display area ($12 wide, $20 tall, from col 0)
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    ; GameCommand #$1A: clear same area with alternate fill ($0001 variant)
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    ; Restore callee-saved registers and return
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts
