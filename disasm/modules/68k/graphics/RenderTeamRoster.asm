; ============================================================================
; RenderTeamRoster -- Displays team roster screen with portraits and stats; routes input to sub-screens
; 1474 bytes | $037A3C-$037FFD
; ============================================================================
; --- Phase: Setup ---
; Stack frame: $2c(a7) = player_index (long), $30(a7) = pointer to match-data struct (a2)
; a4 = GameCommand ($0D64): the central 47-handler command dispatcher, cached for fast calls
; a5 = $FF1804 = save_buf_base: LZ output staging / VRAM upload scratch buffer
; d5 will hold the "did swap" flag; start cleared
; a3 = pointer to this player's record ($FF0018 + player_index * $24)
RenderTeamRoster:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d3
    ; d3 = player_index (0-3)
    movea.l $30(a7), a2
    ; a2 = match-data struct pointer (char_a at +$00, char_b at +$01)
    movea.l  #$00000D64,a4
    ; a4 = GameCommand: cached pointer to central command dispatcher
    movea.l  #$00FF1804,a5
    ; a5 = $FF1804 = save_buf_base: decompression / VRAM DMA scratch buffer
    clr.w   d5
    ; d5 = 0: swap-occurred flag (set to 1 if a character trade is committed)
    move.w  d3, d0
    mulu.w  #$24, d0
    ; d0 = player_index * $24 = byte offset into player_records array
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    ; a0 = $FF0018 + offset = pointer to this player's record (36-byte struct)
    movea.l a0, a3
    ; a3 = player record (preserved copy; a0 will be reused)
    ; load any needed resources for this screen
    jsr ResourceLoad
    ; one-time pre-main-loop initialization (clears flags, sets up state)
    jsr PreLoopInit
    ; decompress background tile graphics for the roster screen into save_buf_base
    pea     ($0004DCE8).l
    ; $0004DCE8 = ROM address of LZ-compressed background tileset
    move.l  a5, -(a7)
    ; output buffer = $FF1804 (save_buf_base)
    jsr LZ_Decompress
    ; transfer decompressed tiles to VRAM: 1 chunk, source $FF1804, cmd $1A, size $0328 words
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($001A).w
    ; $1A = GameCommand #$1A: bulk VRAM clear/fill
    pea     ($0328).w
    ; $0328 = 808 words = tile count for background plane
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    ; release the resource lock acquired by ResourceLoad above
    jsr ResourceUnload
    ; d2 = screen sub-state / sub-screen selector (0 = initial, 1 = player1 pane, 2-5 = sub-screens)
    clr.w   d2
; --- Phase: Main Dispatch Loop ---
; d2 encodes which sub-screen is active:
;   0 = initial: show match results pane
;   1 = player-1 detail panel (portrait + stats)
;   2 = HandlePlayerMenuInput
;   3 = RenderGameDialogs
;   4 = trade/swap confirmation dialog
;   5 = (same path as 1: re-enter player-1 pane)
; Returns d0 sub-state for the next iteration; $FF = done/exit
l_37aa4:
    tst.w   d2
    ; if d2 != 0, we are already in a sub-screen; skip initial match-results render
    bne.b   l_37ad4
    ; --- Initial render: show match results screen ---
    ; GameCommand #$10 with $40: set up display for match-results panel (palette/mode)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    ; RenderMatchResults(player_index, match_data_ptr) -> d0 = next sub-state
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderMatchResults,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    ; d2 = next sub-state returned by RenderMatchResults
    cmpi.w  #$ff, d0
    ; $FF = user chose to exit roster screen entirely -- skip loop and fall to return
    bne.w   l_37fee
    bra.w   l_37ff6
l_37ad4:
    ; sub-states 1 and 5 both enter the "player detail panel" rendering path
    cmpi.w  #$1, d2
    beq.b   l_37ae2
    cmpi.w  #$5, d2
    ; all other sub-states (2, 3, 4) handled further below
    bne.w   l_37d30
; --- Phase: Player Detail Panel (sub-state 1 only -- tile + portrait setup) ---
l_37ae2:
    cmpi.w  #$1, d2
    ; sub-state 5 jumps directly to the shared text-print path (no new tile/portrait setup)
    bne.w   l_37c50
    ; GameCommand #$10 with $40: configure display mode for detail panel
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    ; GameCommand #$1A: clear 18-row × 32-col tile region for first text pane
    clr.l   -(a7)
    pea     ($0012).w
    ; $12 = 18 tile rows
    pea     ($0020).w
    ; $20 = 32 tile columns
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    ; GameCommand #$1A: clear second region at priority $0001 (foreground plane)
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    ; RangeMatch: check if char_a and char_b belong to the same compatibility range group
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; d0 = char_b code (match-data +$01)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = char_a code (match-data +$00)
    move.l  d0, -(a7)
    ; RangeMatch returns nonzero if both map to the same range bucket (compatible types)
    jsr RangeMatch
    tst.w   d0
    beq.b   l_37b48
    ; characters are range-compatible: load the "matched" graphic variant
    move.l  ($000A1B50).l, -(a7)
    ; $A1B50 = ROM pointer to matched-pair LZ tile data
    bra.b   l_37b4e
l_37b48:
    ; characters differ in range: load the "unmatched" graphic variant
    move.l  ($000A1B4C).l, -(a7)
    ; $A1B4C = ROM pointer to unmatched-pair LZ tile data
l_37b4e:
    ; decompress chosen compat graphic into save_buf_base ($FF1804)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $2c(a7), a7
    ; place decompressed tile at VRAM index $0010, palette 1
    pea     ($0010).w
    pea     ($0001).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    ; DisplaySetup: 16-wide × 16-tall tile window using resource table $7651E
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007651E).l
    jsr DisplaySetup
    lea     $18(a7), a7
    ; GameCommand #$1B: blit panel frame strip from ROM $72AC0 at (col $001E, row $000D)
    pea     ($00072AC0).l
    ; $72AC0 = ROM address of panel-frame tile strip
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    ; #$1B = GameCommand tile-blit handler
    jsr     (a4)
    ; DisplaySetup: 16-wide × 48-tall window for portrait area
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007651E).l
    jsr DisplaySetup
    ; decompress portrait background graphic ($A1AE4) into save_buf_base
    move.l  ($000A1AE4).l, -(a7)
    ; $A1AE4 = ROM pointer to portrait background LZ data
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    ; place portrait background at VRAM $0020, palette/flag $0694
    pea     ($0020).w
    pea     ($0694).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    ; GameCommand #$1B: blit top icon strip from $70F38 at (col $0005, row $0010)
    pea     ($00070F38).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0005).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $28(a7), a7
    ; GameCommand #$1B: blit bottom icon strip from $70F58 at (col $0009, row $0010)
    pea     ($00070F58).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    ; extract assigned character index from match-data struct via GetByteField4
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; args: field $0007, sub-field $0005, row $0002, struct ptr a2
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0002).w
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    ; d0 = character index (masked to word range)
    move.l  d0, -(a7)
    ; ShowCharPortrait: decompress and render the character's portrait tiles + palette
    jsr (ShowCharPortrait,PC)
    nop
    lea     $18(a7), a7
; --- Phase: Shared Text Print Path (sub-states 1 and 5) ---
; Prints char_a name at top row, char_b name at row $15, then calls RenderPlayerInterface
l_37c50:
    ; set up 32×32 text window at (0,0) for name labels
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; position cursor at column 4, row 5 for char_a name
    pea     ($0004).w
    pea     ($0005).w
    jsr SetTextCursor
    ; compute city_data index for char_a: char_a_code * 8 + player_index * 2
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = char_a code (a2+$00)
    lsl.w   #$3, d0
    ; d0 *= 8: city stride in city_data
    move.w  d3, d1
    add.w   d1, d1
    ; d1 = player_index * 2
    add.w   d1, d0
    ; d0 = base index into city_data ($FFBA80): char_a_code*8 + player*2
    movea.l  #$00FFBA80,a0
    ; $FFBA80 = city_data: 89 cities × 4 entries × 2 bytes (stride-2 storage)
    move.b  (a0,d0.w), d0
    ; d0 = city_data[char_a][player] first byte = primary name/stat byte
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    ; compute city_data +1 byte for char_a (secondary name byte)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    ; $FFBA81 = city_data +1: second byte of same entry (stride-2, so +1 from base)
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    ; PrintfNarrow with format $44FA0: print char_a city name using narrow 1-tile font
    pea     ($00044FA0).l
    ; $44FA0 = format string for char_a name display
    jsr PrintfNarrow
    ; reposition cursor to column 4, row $15 ($15=21) for char_b name
    pea     ($0004).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    ; compute city_data index for char_b (same formula, using +$01 byte of a2)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; d0 = char_b code (a2+$01)
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    ; PrintfNarrow with format $44F96: print char_b city name using narrow font
    pea     ($00044F96).l
    jsr PrintfNarrow
    lea     $c(a7), a7
    ; RenderPlayerInterface(player_index, match_data_ptr) -> d0 = next sub-state
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderPlayerInterface,PC)
    nop
; shared landing for sub-states 2 and 3 as well (d0 holds next sub-state from callee)
l_37d28:
    addq.l  #$8, a7
    move.w  d0, d2
    ; d2 = next sub-state; loop back to l_37aa4
    bra.w   l_37fee
; --- Sub-state 2: Player Menu Input ---
l_37d30:
    cmpi.w  #$2, d2
    bne.b   l_37d46
    ; HandlePlayerMenuInput(player_index, match_data_ptr) -> d0 = next sub-state
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (HandlePlayerMenuInput,PC)
    nop
    bra.b   l_37d28
; --- Sub-state 3: Game Dialog Rendering ---
l_37d46:
    cmpi.w  #$3, d2
    bne.b   l_37d5c
    ; RenderGameDialogs(player_index, match_data_ptr) -> d0 = next sub-state
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderGameDialogs,PC)
    nop
    bra.b   l_37d28
; --- Sub-state 4: Character Swap / Trade Confirmation Dialog ---
l_37d5c:
    cmpi.w  #$4, d2
    ; unknown d2 value: skip the whole swap path and loop back
    bne.w   l_37fee
    ; GameCommand #$1A: clear $0F-row × $20-col region at row 13 to make room for dialog box
    clr.l   -(a7)
    pea     ($000D).w
    ; $0D = 13 tile rows from top
    pea     ($0020).w
    ; $20 = 32 tile columns
    pea     ($000F).w
    ; $0F = 15 rows tall
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    ; ShowDialog: display the swap/trade confirmation prompt
    ; args: player_index, dialog_string_ptr $4860E, choice_count 1, ok_flag 0, clear_flag 0
    clr.l   -(a7)
    pea     ($0001).w
    ; 1 = single-choice confirm dialog
    clr.l   -(a7)
    move.l  ($0004860E).l, -(a7)
    ; $4860E = ROM pointer to swap confirmation dialog string table
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; ShowDialog: modal yes/no dialog, returns 1 if player confirmed
    jsr ShowDialog
    lea     $30(a7), a7
    cmpi.w  #$1, d0
    ; player cancelled: revert to initial sub-state
    bne.w   l_37fe6
    ; --- Phase: Execute Character Swap ---
    ; Player confirmed swap. Commit the trade: update route slots, bitmasks, and records.
    clr.w   $e(a2)
    ; clear match-data +$0E (actual_revenue field reused here: zero after swap)
    clr.w   $6(a2)
    ; clear match-data +$06 (revenue_target: reset on new assignment)
    ; map char_a code to range bucket (0-7) for bitmask indexing
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = char_a code
    ext.l   d0
    move.l  d0, -(a7)
    ; RangeLookup: map value to range category 0-7 via cumulative threshold table
    jsr RangeLookup
    move.w  d0, d2
    ; d2 = range bucket index for char_a
    ; map char_b code to range bucket
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; d0 = char_b code
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d5
    ; d5 = range bucket index for char_b
    moveq   #$0,d4
    move.b  (a2), d4
    ; d4 = raw char_a code (preserved for later bitmask ops)
    moveq   #$0,d6
    move.b  $1(a2), d6
    ; d6 = raw char_b code (preserved)
    cmp.w   d5, d2
    ; if both characters are in the same range bucket, handle same-bucket swap
    beq.b   l_37e46
    ; --- Cross-bucket swap: set presence bits for both characters in bitfield_tab ---
    ; set bit (1 << char_a_code) in bitfield_tab[$FFA6A0][player]
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    ; d1 = 1 << char_a_code: bitmask for char_a in entity bitfield
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    ; d1 = player_index * 4: longword offset into bitfield_tab per player
    movea.l  #$00FFA6A0,a0
    ; $FFA6A0 = bitfield_tab: entity longword bitmask array indexed by player
    or.l    d0, (a0,d1.w)
    ; mark char_a as present in this player's entity bitfield
    ; set bit (1 << char_b_code) in bitfield_tab for this player
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    ; d1 = 1 << char_b_code
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    ; mark char_b as present in this player's entity bitfield
    ; compute cross-bucket routing bitmask for char_b's bucket and write to $FFA7BC
    ; $FFA7BC is a per-(player,bucket) relation tracking byte array
    ; d0 = 1 << d5 (char_b bucket bit)
    moveq   #$1,d0
    lsl.b   d5, d0
    move.l  d0, -(a7)
    ; compute player's base offset: player_index * 7 (= *8 - *1)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    ; d0 = player * 8
    sub.l   d1, d0
    ; d0 = player * 7
    move.l  d0, d4
    add.w   d2, d0
    ; d0 = player*7 + char_a_bucket: index into $FFA7BC array
    move.l  (a7)+, d1
    movea.l  #$00FFA7BC,a0
    or.b    d1, (a0,d0.w)
    ; OR char_b bucket bit into $FFA7BC[player*7 + char_a_bucket]
    moveq   #$1,d0
    lsl.b   d2, d0
    ; d0 = 1 << char_a_bucket (inverse direction bitmask)
    move.w  d4, d1
    add.w   d5, d1
    ; d1 = player*7 + char_b_bucket
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    ; OR char_a bucket bit into $FFA7BC[player*7 + char_b_bucket]
    addq.b  #$1, $4(a3)
    ; player_record[+$04] (domestic_slots) += 1: one more domestic slot used
    bra.w   l_37efa
; --- Same-bucket swap path ---
; Both chars are in the same range bucket (d2 == d5). Handle differently by code threshold.
l_37e46:
    cmpi.w  #$20, d4
    ; $20 = 32: threshold distinguishing "young" vs "experienced" character codes
    bge.b   l_37e66
    ; char_a code < 32: low-range character -- just set presence bit, no slot reorg
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    ; $FFA6A0 = bitfield_tab: mark char_a present in player's entity bitfield
    or.l    d0, (a0,d1.w)
    bra.b   l_37e9e
l_37e66:
    ; char_a code >= 32: experienced character -- look up bucket threshold and compute slot bitmask
    move.w  d2, d0
    lsl.w   #$2, d0
    ; d0 = range_bucket * 4: word offset into threshold table at $5ECBE
    movea.l  #$0005ECBE,a0
    ; $5ECBE = ROM range threshold table (byte per bucket entry, stride 4)
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ; d0 = threshold for this bucket (number of fixed-slot chars in range)
    move.w  d4, d1
    sub.w   d0, d1
    move.w  d1, d4
    ; d4 = char_a_code - threshold = relative position within bucket
    moveq   #$1,d0
    lsl.w   d4, d0
    ; d0 = 1 << relative_position: bitmask for this char's slot in the bucket
    move.w  d3, d1
    mulu.w  #$e, d1
    ; d1 = player_index * 14: row stride in $FFBD6C slot-assignment table
    move.w  d2, d7
    add.w   d7, d7
    add.w   d7, d1
    ; d1 += bucket * 2: column offset (word per bucket)
    movea.l  #$00FFBD6C,a0
    ; $FFBD6C = per-player per-bucket slot assignment word array
    or.w    d0, (a0,d1.w)
    ; mark this slot as assigned in the bucket word
    addq.b  #$1, $3(a3)
    ; player_record[+$03] (route_type_b / intl count) += 1
l_37e9e:
    ; same check for char_b (d6 = char_b code, d5 = char_b bucket)
    cmpi.w  #$20, d6
    bge.b   l_37ec0
    ; char_b code < 32: just set presence bit
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   l_37ef6
l_37ec0:
    ; char_b code >= 32: look up threshold and compute bucket bitmask for char_b
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d6, d4
    sub.w   d0, d4
    ; d4 = char_b relative position within its bucket
    moveq   #$1,d0
    lsl.w   d4, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    move.w  d5, d7
    add.w   d7, d7
    add.w   d7, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    ; mark char_b's slot in the bucket assignment table
    addq.b  #$1, $3(a3)
    ; player_record[+$03] (route_type_b) += 1 again (second char in same bucket)
l_37ef6:
    addq.b  #$1, $5(a3)
    ; player_record[+$05] (intl_slots) += 1: one more international slot used
l_37efa:
    clr.b   $2(a3)
    ; player_record[+$02] (route_type_a) = 0: reset domestic route count after swap
    clr.w   d2
    ; d2 = 0: use as counter for the 32-char presence-count loop below
; --- Phase: Count Presence Bits (loop over all 32 entity slots) ---
; Scan bits 0-31 of this player's bitfield_tab longword.
; For each bit that is set, increment player_record[+$02] (route_type_a count).
l_37f00:
    move.w  d2, d0
    ext.l   d0
    ; d0 = current slot index (0-31)
    moveq   #$1,d1
    lsl.l   d0, d1
    ; d1 = 1 << slot_index: probe bitmask for this slot
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    ; d1 = player_index * 4: longword offset in bitfield_tab
    movea.l  #$00FFA6A0,a0
    ; $FFA6A0 = bitfield_tab: entity presence bitmask per player
    and.l   (a0,d1.w), d0
    ; test if this slot is occupied in the player's bitfield
    beq.b   l_37f1e
    addq.b  #$1, $2(a3)
    ; player_record[+$02] (route_type_a) += 1 for each occupied slot
l_37f1e:
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    ; loop until all 32 ($20) slots checked
    blt.b   l_37f00
    ; --- Phase: Commit Swap Financial Effects ---
    ; CalcRelationValue(char_a, char_b, mode=3): compute money value of the relation
    pea     ($0003).w
    ; mode 3 = financial/relation mode for CalcRelationValue
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; d0 = char_b code
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ; d0 = char_a code
    move.l  d0, -(a7)
    ; CalcRelationValue: multi-mode character value calculator -- returns cash impact
    jsr CalcRelationValue
    sub.l   d0, $6(a3)
    ; player_record[+$06] (cash) -= relation value: pay cost of the swap
    ; GetByteField4: get the char's field index for event_records lookup
    move.l  a2, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    add.l   d0, d0
    ; d0 *= 2: byte offset into event_records per character (stride 2)
    move.w  d3, d1
    lsl.w   #$5, d1
    ; d1 = player_index * 32: 32-byte record stride in event_records
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    ; $FFB9E9 = event_records[0] + 1: secondary byte of first event record
    adda.l  d0, a0
    movea.l a0, a3
    ; a3 = pointer to this character's byte within event_records for this player
    ; GetLowNibble(a2): extract low nibble from match struct (swap adjustment value)
    move.l  a2, -(a7)
    jsr GetLowNibble
    sub.b   d0, (a3)
    ; event_records[char][player] -= low_nibble: deduct swap penalty from event byte
    ; update city_data ($FFBA81) for char_a: add match bonus ($3(a2))
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    ; d0 = char_a_code * 8 + player_index * 2: index into city_data (stride-2 secondary byte)
    move.b  $3(a2), d1
    ; d1 = match-data +$03: relation bonus amount to apply
    movea.l  #$00FFBA81,a0
    ; $FFBA81 = city_data secondary byte (stride-2 +1 entry)
    add.b   d1, (a0,d0.w)
    ; add relation bonus to char_a's city_data entry for this player
    ; same update for char_b
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; d0 = char_b code
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a2), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    ; add same relation bonus to char_b's city_data entry
    move.b  #$4, $a(a2)
    ; match-data +$0A: reset status_flags to $04 (ESTABLISHED) after swap
    ; record the new relation pair in the sorted relation table
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; InsertRelationRecord(player_index, match_data): insert char pair into sorted relation table
    jsr InsertRelationRecord
    lea     $24(a7), a7
    moveq   #$1,d5
    ; d5 = 1: swap-occurred flag -- will be returned to caller
    cmpi.w  #$1, ($00FF000A).l
    ; $FF000A = flight_active: nonzero when a route/flight operation is live
    bne.b   l_37ff6
    ; flight active: animate the world map to show the new route/assignment
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; RunWorldMapAnimation(player_index): play map animation showing new route connection
    jsr (RunWorldMapAnimation,PC)
    nop
    move.w  ($00FF9A1C).l, d0
    ; $FF9A1C = screen_id: current screen/scenario index
    ext.l   d0
    move.l  d0, -(a7)
    ; SelectMenuItem(screen_id): update menu selection state for the new screen
    jsr SelectMenuItem
    addq.l  #$8, a7
    bra.b   l_37ff6
; --- Player cancelled swap: reset sub-state and reinit ---
l_37fe6:
    clr.w   d2
    ; d2 = 0: return to initial sub-state (match results screen)
    ; PreLoopInit: reinitialize loop state (clear flags, reset display)
    jsr PreLoopInit
; --- Loop-back check ---
l_37fee:
    cmpi.w  #$ff, d2
    ; $FF = sentinel meaning "exit cleanly without swap"; loop back for any other value
    bne.w   l_37aa4
; --- Phase: Return ---
l_37ff6:
    move.w  d5, d0
    ; d0 = swap-occurred flag (0 = no swap, 1 = swap committed): return value
    movem.l (a7)+, d2-d7/a2-a5
    rts
