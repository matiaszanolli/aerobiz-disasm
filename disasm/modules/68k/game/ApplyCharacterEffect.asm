; ============================================================================
; ApplyCharacterEffect -- Interactive UI for applying a char effect to a target slot; shows match slots, runs Up/Down/A/B input loop for target selection, calls BrowsePartners on B, returns selected slot index.
; 698 bytes | $014AAA-$014D63
; ============================================================================
ApplyCharacterEffect:
    ; --- Phase: Setup ---
    link    a6,#-$4            ; 4 bytes local: -$2(a6)=tile_attr_A, -$4(a6)=tile_attr_B
    movem.l d2-d4/a2-a5, -(a7)
    ; Stack args: $8(a6)=slot_type, $c(a6)=initial_slot_index, $10(a6)=char_record_ptr
    move.l  $c(a6), d2         ; d2 = current selection cursor index
    move.l  $8(a6), d4         ; d4 = slot/effect type (passed to CheckMatchSlots, BrowsePartners)
    movea.l $10(a6), a2        ; a2 = char stat record ptr (+$00=base id, +$01=primary stat)
    movea.l  #$00FF13FC,a3     ; a3 = &input_mode_flag ($FF13FC): nonzero = UI-input countdown active
    movea.l  #$00005092,a4     ; a4 = DisplaySetup ($005092)
    movea.l  #$00000D64,a5     ; a5 = GameCommand ($000D64): central command dispatcher
    ; --- Phase: Initial match-slot check ---
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots        ; $038544: scan $FF8804 for non-$FF slot matching type; d0=1 if found
    addq.l  #$4, a7
    tst.w   d0                 ; d0=0 means no matching slots exist
    beq.b   .l14b1a            ; skip dialog if no matches
    ; Draw framed dialog box and print slot-selection prompt
    pea     ($0004).w          ; DrawBox: border style arg
    pea     ($001C).w          ; DrawBox: box width = 28 tiles
    pea     ($0014).w          ; DrawBox: box height = 20 tiles
    pea     ($0001).w          ; DrawBox: starting column = 1
    jsr DrawBox                ; $005A04: draw bordered dialog box (corners + edges)
    pea     ($0003F7D8).l      ; ROM string: slot-selection prompt text
    jsr PrintfNarrow           ; $03B246: format + display narrow-font string
    pea     ($0020).w          ; SetTextWindow: width = 32 (full screen)
    pea     ($0020).w          ; SetTextWindow: height = 32
    clr.l   -(a7)              ; x = 0
    clr.l   -(a7)              ; y = 0
    jsr SetTextWindow          ; $03A942: reset text window bounds to full screen
    lea     $24(a7), a7
.l14b1a:
    ; --- Phase: Draw initial cursor highlight tile ---
    ; Tile attribute word: %PCCVHNNNNNNNNNNN (Priority|ColorPalette|VFlip|HFlip|CharNum)
    move.w  #$88a, -$2(a6)    ; tile_attr_A = $088A: selection-highlight tile (palette 0, char $8A)
    move.w  #$448, -$4(a6)    ; tile_attr_B = $0448: deselect/erase tile (palette 0, char $48)
    pea     ($0001).w          ; DisplaySetup: mode = 1
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; screen row = slot_index + $29 ($29=41: base row of slot list)
    move.l  d0, -(a7)
    pea     -$2(a6)            ; &tile_attr_A: highlight tile attribute
    jsr     (a4)               ; DisplaySetup: place cursor tile on screen
    lea     $c(a7), a7
    ; --- Phase: Flush stale joypad input before entering event loop ---
.l14b40:
    clr.l   -(a7)              ; ReadInput mode = 0 (raw, no repeat)
    jsr ReadInput              ; $01E1EC: read joypad via GameCmd #10
    addq.l  #$4, a7
    andi.w  #$fff, d0          ; nonzero = at least one button still held
    bne.b   .l14b40            ; spin until all buttons released
    ; --- Phase: Event loop initialisation ---
    clr.w   d3                 ; d3 = accumulated input state (fed back to ProcessInputLoop each call)
    clr.w   (a3)               ; input_mode_flag ($FF13FC) = 0: fresh countdown
    clr.w   ($00FFA7D8).l      ; input_init_flag ($FFA7D8) = 0: reset per-UI-context init guard
    ; =========================================================
    ; Main render-and-poll loop:
    ;   Draw cursor -> poll input -> dispatch on button -> repeat
    ;   Exits via .l14bdc which returns d2 (selected index or $FF)
    ; =========================================================
.l14b5a:
    ; Redraw cursor highlight for current slot at the top of every iteration
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; screen row = slot_index + $29
    move.l  d0, -(a7)
    pea     -$2(a6)            ; &tile_attr_A: highlight tile
    jsr     (a4)               ; DisplaySetup: draw selection cursor
    lea     $c(a7), a7
.l14b74:
    ; Poll for directional/action buttons with auto-repeat
    move.w  d3, d0             ; pass previous accumulated state to enable repeat-rate logic
    move.l  d0, -(a7)
    pea     ($0014).w          ; repeat interval = $14 = 20 frames per repeat tick
    jsr ProcessInputLoop       ; $01E290: auto-repeat handler; returns new button bitmask in d0
    addq.l  #$8, a7
    move.w  d0, d3             ; save new accumulated state for next poll
    andi.l  #$bc, d0           ; $BC = %10111100: Up($80)|Down($40)|A($08)|B($04) action mask
    beq.b   .l14b74            ; no actionable input -- keep polling
    ; --- Phase: Button dispatch ---
    move.w  d3, d0
    ext.l   d0
    moveq   #$20,d1            ; $20 = Left d-pad bit
    cmp.w   d1, d0
    beq.b   .l14bb8            ; Left -> confirm / accept selection
    moveq   #$10,d1            ; $10 = Right d-pad bit
    cmp.w   d1, d0
    beq.b   .l14be2            ; Right -> cancel (return $FF sentinel)
    moveq   #$8,d1             ; $08 = Down d-pad bit
    cmp.w   d1, d0
    beq.b   .l14bea            ; Down -> cursor down (increment slot index)
    moveq   #$4,d1             ; $04 = Up d-pad bit
    cmp.w   d1, d0
    beq.w   .l14c3a            ; Up -> cursor up (decrement slot index)
    cmpi.w  #$80, d0           ; $80 = B button
    beq.w   .l14c7c            ; B -> open BrowsePartners partner browser
    bra.w   .l14d4a            ; any other button: fall through to display sync + redraw

    ; --- Handler: Left/confirm -- clear UI, return chosen slot index ---
.l14bb8:
    clr.w   (a3)               ; input_mode_flag = 0: deactivate input mode
    ; GameCommand #$1A: clear the selection highlight tile region
    move.l  #$8000, -(a7)      ; priority flag $8000 (high-priority blank clear)
    pea     ($0004).w
    pea     ($001C).w          ; col 28
    pea     ($0014).w          ; row 20
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w          ; GameCommand #$1A = ClearTileArea
    jsr     (a5)               ; GameCommand
    lea     $1c(a7), a7
.l14bdc:
    move.w  d2, d0             ; d0 = return value: selected slot index (or $FF if cancelled)
    bra.w   .l14d5a            ; jump to function epilogue

    ; --- Handler: Right -- cancel; set return value to $FF ("no selection") ---
.l14be2:
    clr.w   (a3)               ; input_mode_flag = 0
    move.w  #$ff, d2           ; d2 = $FF: caller treats as "no slot selected"
    bra.b   .l14bdc            ; return $FF

    ; --- Handler: Down -- cursor down one slot; clamp at max index 6 ---
.l14bea:
    move.w  #$1, (a3)          ; input_mode_flag = 1: UI input active (enables repeat countdown)
    cmpi.w  #$6, d2            ; already at bottom slot (index 6)?
    bge.b   .l14c26            ; yes -- skip erase+draw, just re-clamp
    ; Erase old highlight tile at current row
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; old row = slot_index + $29
    move.l  d0, -(a7)
    pea     -$4(a6)            ; &tile_attr_B: erase/deselect tile
    jsr     (a4)               ; DisplaySetup: clear old cursor tile
    addq.w  #$1, d2            ; increment cursor one slot down
    ; Draw new highlight tile at incremented row
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; new row = (slot_index+1) + $29
    move.l  d0, -(a7)
    pea     -$2(a6)            ; &tile_attr_A: selection highlight tile
    jsr     (a4)               ; DisplaySetup: draw new cursor tile
    lea     $18(a7), a7
.l14c26:
    ; Clamp d2 to maximum slot index = 6
    cmpi.w  #$6, d2
    bge.b   .l14c32
.l14c2c:
    move.w  d2, d0             ; d2 in range [0,6]: pass through unchanged
    ext.l   d0
    bra.b   .l14c34
.l14c32:
    moveq   #$6,d0             ; clamp to maximum slot 6
.l14c34:
    move.w  d0, d2             ; store clamped slot index
    bra.w   .l14d4a            ; display sync and loop

    ; --- Handler: Up -- cursor up one slot; clamp at minimum index 0 ---
.l14c3a:
    move.w  #$1, (a3)          ; input_mode_flag = 1: UI input active
    tst.w   d2                 ; already at top slot (index 0)?
    ble.b   .l14c74            ; yes -- skip erase+draw, clamp to 0
    ; Erase old highlight tile
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; old row
    move.l  d0, -(a7)
    pea     -$4(a6)            ; &tile_attr_B: erase tile
    jsr     (a4)
    subq.w  #$1, d2            ; move cursor up one slot
    ; Draw new highlight tile
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0           ; new row
    move.l  d0, -(a7)
    pea     -$2(a6)            ; &tile_attr_A: highlight tile
    jsr     (a4)
    lea     $18(a7), a7
.l14c74:
    tst.w   d2
    bgt.b   .l14c2c            ; d2 > 0: within range, pass through
    moveq   #$0,d0             ; clamp to 0 (minimum slot index)
    bra.b   .l14c34

    ; --- Handler: B button -- open BrowsePartners interactive partner browser ---
.l14c7c:
    clr.w   (a3)               ; input_mode_flag = 0: suspend input mode during browse
    ; GameCommand #$1A: clear overlay area for the partner browser panel
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($001E).w          ; col 30
    pea     ($0012).w          ; row 18
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w          ; GameCommand #$1A = ClearTileArea
    jsr     (a5)
    ; Push char record fields as BrowsePartners arguments
    moveq   #$0,d0
    move.b  $1(a2), d0         ; per-player stat record +$01: primary skill/rating stat (DATA_STRUCTURES.md)
    ext.l   d0
    move.l  d0, -(a7)          ; arg: secondary char field (skill)
    moveq   #$0,d0
    move.b  (a2), d0           ; per-player stat record +$00: base field (character type/identifier)
    ext.l   d0
    move.l  d0, -(a7)          ; arg: primary char field
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)          ; arg: slot/effect type
    jsr BrowsePartners         ; $01A2CE: interactive player browser with input loop
    lea     $28(a7), a7
    ; Clear partner browser overlay after it returns
    move.l  #$8000, -(a7)
    pea     ($000A).w          ; height 10
    pea     ($001E).w          ; col 30
    pea     ($0012).w          ; row 18
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w          ; GameCommand #$1A = ClearTileArea
    jsr     (a5)
    ; Reset text window to full screen after closing the overlay
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; Re-check match slots (state may have changed during browse)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots
    lea     $30(a7), a7
    tst.w   d0                 ; matching slots still available?
    beq.b   .l14d3a            ; no: skip redrawing the selection dialog
    ; Redraw dialog with post-browse prompt string (slightly different from initial $3F7D8)
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0003F7B4).l      ; alternate slot-selection prompt string (post-browse variant)
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
.l14d3a:
    ; Flush input before resuming event loop
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l14d3a            ; spin until all buttons released
    ; --- Phase: Display sync and loop back ---
.l14d4a:
    ; GameCommand #$E: display refresh / frame sync
    pea     ($0003).w          ; arg: mode $03
    pea     ($000E).w          ; GameCommand #$E = display sync/wait
    jsr     (a5)               ; GameCommand
    addq.l  #$8, a7
    bra.w   .l14b5a            ; restart render-and-poll loop
    ; --- Phase: Epilogue ---
.l14d5a:
    movem.l -$20(a6), d2-d4/a2-a5
    unlk    a6
    rts
