; ============================================================================
; ProcessCharTrade -- Runs the character trade screen: decompresses the trade background, places the cursor sprite, calls InitFlightDisplay/UpdateFlightSlots, then processes a directional+button input loop supporting cursor movement (D-pad), character browsing (B), character selection (A), player info view (Start), and exit (C/back), animating flight paths between inputs.
; 1340 bytes | $01C646-$01CB81
; ============================================================================
; Register map (for the entire function):
;   d5  = cursor Y pixel position (screen row * 8 + $16; range $16-$18)
;   d6  = cursor X pixel position (screen col * 3 + $E;  range $E-$1D)
;   d7  = trade partner slot index (word; $8000 bit set = cancel/back)
;   a2  = pointer to current player index word (caller-supplied)
;   a3  = $FF13FC (input_mode_flag: 1=input active, 0=idle)
;   a4  = $000D64 (GameCommand dispatcher)
;   a5  = $FFA7D8 (input_init_flag: 1=countdown started)
; ============================================================================
ProcessCharTrade:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7             ; d7 = caller param: initial trade partner slot index
    movea.l $c(a6), a2              ; a2 = ptr to current player index (word)
    movea.l  #$00FF13FC,a3          ; a3 -> input_mode_flag ($FF13FC)
    movea.l  #$00000D64,a4          ; a4 -> GameCommand dispatcher ($0D64)
    movea.l  #$00FFA7D8,a5          ; a5 -> input_init_flag ($FFA7D8)

; --- Phase: Compute initial cursor position from slot index ---
; Slot index d7 maps to a grid: 6 columns x N rows.
; X cell = slot mod 6, each cell is 3 units wide, base offset $E.
; Y cell = slot div 6, each cell is 2 units tall, base offset $16.
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedMod                   ; d0 = d7 mod 6  (column 0-5)
    move.l  d0, d6
    mulu.w  #$3, d6                 ; d6 = col * 3   (3 pixels per column)
    addi.w  #$e, d6                 ; d6 = col * 3 + $E  -> X pixel pos
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedDiv                   ; d0 = d7 / 6   (row)
    move.l  d0, d5
    add.w   d5, d5                  ; d5 = row * 2   (2 pixels per row)
    addi.w  #$16, d5                ; d5 = row * 2 + $16 -> Y pixel pos

; --- Phase: Decompress and render trade background ---
; $A1B54 holds a ROM pointer to the LZ-compressed trade screen tile data.
    move.l  ($000A1B54).l, -(a7)    ; push src: ROM ptr to LZ-compressed trade background
    pea     ($00FF1804).l           ; push dst: save_buf_base ($FF1804)
    jsr LZ_Decompress               ; unpack trade background tilemap into save buffer
; Place the decompressed tilemap on screen.
; CmdPlaceTile args: src_buf, tile_count=$02E1, tile_base=$0047
    pea     ($0047).w               ; tile_base VRAM index
    pea     ($02E1).w               ; tile count = 737
    pea     ($00FF1804).l           ; source buffer
    jsr CmdPlaceTile
; GameCommand $001B: draw the outer frame/border box.
; Args (pushed right-to-left): cmd=$1B, 0, y=$D, x=$15, w=$12, h=$4, attr=$72DCC
    pea     ($00072DCC).l           ; tile attribute word for border
    pea     ($0004).w               ; height = 4 tiles
    pea     ($0012).w               ; width = 18 tiles
    pea     ($0015).w               ; x position
    pea     ($000D).w               ; y position
    clr.l   -(a7)                   ; 0 (unused param)
    pea     ($001B).w               ; GameCommand $1B = draw box
    jsr     (a4)                    ; dispatch GameCommand
    lea     $30(a7), a7

; --- Phase: Place cursor sprite at computed grid position ---
; TilePlacement args: tile_id=$0740, 0, X=(d6<<3), Y=(d5<<3), scale=2, scale=2, attr=$8000
    move.l  #$8000, -(a7)           ; sprite attribute ($8000 = high-priority)
    pea     ($0002).w               ; Y scale factor = 2
    pea     ($0002).w               ; X scale factor = 2
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; Y pixel = d5 * 8 (convert tile row to pixel)
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; X pixel = d6 * 8 (convert tile col to pixel)
    move.l  d0, -(a7)
    clr.l   -(a7)                   ; 0 (unused)
    pea     ($0740).w               ; tile_id $0740 = cursor sprite tile
    jsr TilePlacement
; GameCommand $000E: flush/display the rendered frame.
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand $0E = display update/flush
    jsr     (a4)

; --- Phase: Initialize flight display and prime slots ---
    jsr ResourceUnload
    jsr InitFlightDisplay           ; set up flight path display state
    pea     ($0001).w
    move.w  (a2), d0                ; d0 = current player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots           ; populate flight slots for the current player
; Initial auto-animate: read input to determine if a button is held on entry.
    clr.l   -(a7)
    jsr ReadInput                   ; d0 = current button state bitmask
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_1c73e
    moveq   #$1,d4                  ; d4 = 1: button held on entry -> animate immediately
    bra.b   l_1c740
l_1c73e:
    moveq   #$0,d4                  ; d4 = 0: no button held on entry
l_1c740:
    clr.w   d3                      ; d3 = last button state (for debounce comparison)
    clr.w   (a3)                    ; input_mode_flag = 0 (idle, no active input session)
    clr.w   (a5)                    ; input_init_flag = 0 (countdown not started)

; ============================================================================
; --- Phase: Main input loop ---
; Each iteration: animate flight paths while button held, then read new input
; and dispatch to the appropriate action handler.
; ============================================================================
l_1c746:
; --- Sub-phase: Drain held button by animating until released ---
    tst.w   d4                      ; d4 != 0 => button was held on entry or previous iter
    beq.b   l_1c774                 ; no -> skip drain loop, go read new input
.drain_held:
    clr.l   -(a7)
    jsr ReadInput                   ; poll button state
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_1c774                 ; button released -> proceed to new input
    move.w  (a2), d0                ; d0 = current player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths          ; animate one frame of flight paths
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand $0E = flush display
    jsr     (a4)
    lea     $c(a7), a7
    bra.b   l_1c746                 ; loop until button released

; --- Sub-phase: Debounce / input stability wait ---
; If input_mode_flag==1 and input_init_flag==0, require 10 identical frames
; before accepting input (prevents accidental double-triggers).
l_1c774:
    clr.w   d4                      ; d4 = 0 (button-held flag reset)
    cmpi.w  #$1, (a3)               ; input_mode_flag == 1?
    bne.b   l_1c7be                 ; no -> skip debounce, read input immediately
    tst.w   (a5)                    ; input_init_flag == 0?
    bne.b   l_1c7be                 ; already armed -> skip debounce
    moveq   #$A,d2                  ; d2 = 10 (debounce frame counter)
    bra.b   l_1c7b6                 ; enter debounce loop (first iter: decrement first)
l_1c784:
    clr.l   -(a7)
    jsr ReadInput                   ; read current input
    addq.l  #$4, a7
    andi.l  #$ffff, d0              ; zero-extend to long for compare
    move.w  d3, d1
    ext.l   d1                      ; d1 = last stable button state
    cmp.l   d1, d0                  ; same button pattern as last frame?
    bne.b   l_1c7be                 ; changed -> accept input immediately (break debounce)
    move.w  (a2), d0                ; animate during debounce wait
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w               ; flush display
    jsr     (a4)
    lea     $c(a7), a7
l_1c7b6:
    move.l  d2, d0
    subq.w  #$1, d2                 ; decrement debounce counter
    tst.w   d0
    bne.b   l_1c784                 ; loop until counter reaches 0
; Debounce complete. If input_mode_flag is still 1, arm the countdown (input_init_flag=1).
l_1c7be:
    cmpi.w  #$1, (a3)              ; input_mode_flag == 1?
    bne.b   l_1c7c8
    move.w  #$1, (a5)              ; input_init_flag = 1 (ProcessInputLoop countdown armed)

; --- Sub-phase: Read new input and dispatch ---
l_1c7c8:
    clr.l   -(a7)
    jsr ReadInput                   ; d0 = button bitmask (raw, single-frame)
    addq.l  #$4, a7
    move.w  d0, d3                  ; d3 = save for debounce comparison next iter
    ext.l   d0
; Button dispatch (button bits in d0):
;   $08 = Right D-pad  -> move cursor right (X + 3, max $1D)
;   $04 = Left D-pad   -> move cursor left  (X - 3, min $0E)
;   $02 = Down D-pad   -> move cursor down  (Y + 2, max $18)
;   $01 = Up D-pad     -> move cursor up    (Y - 2, min $16)
;   $20 = A button     -> select character at cursor position
;   $40 = C button     -> cancel/exit trade screen
;   $80 = B button     -> open character browser UI
;   $10 = Start button -> view player info panel
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.b   l_1c814                 ; Right D-pad
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.b   l_1c834                 ; Left D-pad
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_1c850                 ; Down D-pad
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1c870                 ; Up D-pad
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   l_1c88c                 ; A button (select)
    moveq   #$40,d1
    cmp.w   d1, d0
    beq.w   l_1c8de                 ; C button (cancel/back)
    cmpi.w  #$80, d0
    beq.w   l_1c8e8                 ; B button (character browser)
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1c9d8                 ; Start button (player info)
    bra.w   l_1cb14                 ; no recognized button -> clear flags, redraw cursor

; ============================================================================
; --- Phase: Cursor movement handlers ---
; Each clamps the new position to the valid grid range, then falls through
; to l_1cb18 (redraw cursor at new position and continue main loop).
; ============================================================================

; Right: X += 3, clamp to max $1D (rightmost column * 3 + $E = 5*3+$E = $1D)
l_1c814:
    move.w  #$1, (a3)               ; input_mode_flag = 1 (input accepted)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0                 ; tentative new X = current + 3
    moveq   #$1D,d1
    cmp.l   d0, d1
    ble.b   l_1c82c                 ; new X <= $1D? -> use $1D (clamp at max)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0                 ; new X is within range, use it
    bra.b   l_1c82e
l_1c82c:
    moveq   #$1D,d0                 ; clamp: X = $1D (rightmost column)
l_1c82e:
    move.w  d0, d6                  ; d6 = new cursor X position
    bra.w   l_1cb18                 ; -> redraw cursor

; Left: X -= 3, clamp to min $0E (leftmost column: col=0 -> 0*3+$E = $E)
l_1c834:
    move.w  #$1, (a3)               ; input_mode_flag = 1
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0                 ; tentative new X = current - 3
    moveq   #$E,d1
    cmp.l   d0, d1
    bge.b   l_1c84c                 ; new X >= $E? -> use $E (clamp at min)
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0                 ; new X is within range, use it
    bra.b   l_1c82e
l_1c84c:
    moveq   #$E,d0                  ; clamp: X = $E (leftmost column)
    bra.b   l_1c82e

; Down: Y += 2, clamp to max $18
l_1c850:
    move.w  #$1, (a3)               ; input_mode_flag = 1
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0                 ; tentative new Y = current + 2
    moveq   #$18,d1
    cmp.l   d0, d1
    ble.b   l_1c868                 ; new Y <= $18? -> clamp
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    bra.b   l_1c86a
l_1c868:
    moveq   #$18,d0                 ; clamp: Y = $18 (bottom row)
l_1c86a:
    move.w  d0, d5                  ; d5 = new cursor Y position
    bra.w   l_1cb18                 ; -> redraw cursor

; Up: Y -= 2, clamp to min $16
l_1c870:
    move.w  #$1, (a3)               ; input_mode_flag = 1
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0                 ; tentative new Y = current - 2
    moveq   #$16,d1
    cmp.l   d0, d1
    bge.b   l_1c888                 ; new Y >= $16? -> clamp
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0
    bra.b   l_1c86a
l_1c888:
    moveq   #$16,d0                 ; clamp: Y = $16 (top row)
    bra.b   l_1c86a

; ============================================================================
; --- Phase: A button -- select character at cursor position ---
; Convert (X, Y) pixel pos back to slot index and call HandleMenuSelection.
; ============================================================================
l_1c88c:
    clr.w   (a3)                    ; input_mode_flag = 0 (close input session)
    clr.w   (a5)                    ; input_init_flag = 0
; Reconstruct row from Y: row = (d5 - $16) / 2  (undo the * 2 + $16 encoding)
    move.w  d5, d0
    ext.l   d0
    subi.l  #$16, d0                ; d0 = Y - $16 (distance from top)
    bge.b   l_1c89e
    addq.l  #$1, d0                 ; round toward zero for signed negative (shouldn't happen in practice)
l_1c89e:
    asr.l   #$1, d0                 ; d0 = row = (Y - $16) >> 1
    move.l  d0, d7
    mulu.w  #$6, d7                 ; d7 = row * 6 (offset to start of row in the 6-wide grid)
; Reconstruct column from X: col = (d6 - $E) / 3
    move.l  d7, -(a7)              ; save row*6 on stack temporarily
    move.w  d6, d0
    ext.l   d0
    subi.l  #$e, d0                 ; d0 = X - $E
    moveq   #$3,d1
    jsr SignedDiv                   ; d0 = col = (X - $E) / 3
    add.l   (a7)+, d0               ; d0 = row*6 + col = slot index
    move.w  d0, d7                  ; d7 = computed slot index
; Push args to HandleMenuSelection: (slot_index, cursor_x, cursor_y)
    move.w  d5, d0
    move.l  d0, -(a7)               ; arg: cursor Y (screen row unit)
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: cursor X (screen col unit)
    move.w  d7, d0
    move.l  d0, -(a7)               ; arg: slot index
    bsr.w HandleMenuSelection       ; run the trade selection handler; d7 = result slot
    lea     $c(a7), a7
; --- Phase: Post-selection cleanup (also reached from C button) ---
l_1c8d2:
    jsr ClearFlightSlots            ; reset flight slot display state
    move.w  d7, d0                  ; d0 = result slot (or $8000 if cancelled)
    bra.w   l_1cb78                 ; -> epilogue/return

; ============================================================================
; --- Phase: C button -- cancel/exit trade screen ---
; ============================================================================
l_1c8de:
    clr.w   (a3)                    ; input_mode_flag = 0
    clr.w   (a5)                    ; input_init_flag = 0
    ori.w   #$8000, d7              ; set bit 15 of d7 to signal "cancelled" to caller
    bra.b   l_1c8d2                 ; -> cleanup and return

; ============================================================================
; --- Phase: B button -- open character browser ---
; Show the character selection UI, then restore the trade screen and continue.
; ============================================================================
l_1c8e8:
    clr.w   (a3)                    ; input_mode_flag = 0
    clr.w   (a5)                    ; input_init_flag = 0
    jsr ClearFlightSlots
; Show a background overlay behind the browser.
; GameCommand $1A: overlay/background layer setup.
    clr.l   -(a7)                   ; 0
    pea     ($0006).w               ; h = 6
    pea     ($0008).w               ; w = 8
    pea     ($0015).w               ; x
    pea     ($0001).w               ; y
    clr.l   -(a7)                   ; 0
    pea     ($001A).w               ; GameCommand $1A = overlay render
    jsr     (a4)
; Launch character browser UI.
; Args: player_index (from a2), and char_mode from $A(a6).
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: current player index
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: char_mode (caller param)
    jsr CharacterBrowser            ; d0 = selected character index, or $FF = cancelled
    move.w  d0, d2
    cmpi.w  #$ff, d2                ; was selection cancelled?
    beq.b   l_1c92e                 ; yes -> don't update player index
    cmp.w   (a2), d2                ; same character as before?
    beq.b   l_1c92e                 ; same -> no change needed
    move.w  d2, (a2)                ; update player index to newly selected character
l_1c92e:
; Return from browser: re-run the main menu for the selected player, then
; re-decompress the trade background and redraw the whole trade screen.
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu               ; re-display the main menu for char_mode
; --- Phase: Restore trade background (after browser/menu) ---
    move.l  ($000A1B54).l, -(a7)    ; ROM ptr to LZ-compressed trade background
    pea     ($00FF1804).l           ; destination: save_buf_base
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0047).w               ; tile_base
    pea     ($02E1).w               ; tile count = 737
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072DCC).l           ; border tile attribute
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w               ; GameCommand $1B = draw box
    jsr     (a4)
    lea     $28(a7), a7
; Redraw cursor at current (d5, d6) position.
    move.l  #$8000, -(a7)           ; sprite attribute (high priority)
    pea     ($0002).w               ; Y scale = 2
    pea     ($0002).w               ; X scale = 2
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; Y pixel = d5 * 8
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; X pixel = d6 * 8
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w               ; cursor tile id
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w               ; flush display
    jsr     (a4)
; Refresh flight slot display for the (possibly updated) player index.
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $2c(a7), a7
    jsr ResourceUnload
    bra.w   l_1cb18                 ; -> post-action animate loop

; ============================================================================
; --- Phase: Start button -- view player info panel ---
; Saves/restores screen_id, loads the player's relation panel and info
; screen, runs a brief input loop (Start or A to exit), then returns.
; ============================================================================
l_1c9d8:
    clr.w   (a3)                    ; input_mode_flag = 0
    clr.w   (a5)                    ; input_init_flag = 0
    jsr ClearFlightSlots
    jsr ResourceLoad
    move.w  #$7, ($00FF9A1C).l      ; screen_id = 7 (LoadScreenGfx marker for info screen)
; GameCommand $10: mode/screen switch setup.
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w               ; GameCommand $10 = screen mode switch
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    jsr CmdSetBackground            ; clear to background color
; LoadScreenGfx args: char_mode, player_index, flag=1
    pea     ($0001).w               ; flag: 1 = load
    clr.l   -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: char_mode (caller param)
    jsr LoadScreenGfx               ; load the info screen graphics for this player
; ShowRelPanel args: player_index, screen_id=$7, display_mode=2
    pea     ($0002).w               ; display_mode = 2
    pea     ($0007).w               ; screen_id = 7
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: char_mode / player index
    jsr ShowRelPanel                ; render the player relation panel
; ShowPlayerInfo arg: player_index
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w ShowPlayerInfo            ; display the player info screen
    lea     $30(a7), a7
    jsr ResourceUnload
; --- Phase: Info screen input loop ---
; Wait for Start ($80) or A ($10) button to exit the info panel.
    clr.w   d3                      ; d3 = ProcessInputLoop input state (0 = fresh)
l_1ca4a:
    move.w  d3, d0
    move.l  d0, -(a7)               ; push current input state for ProcessInputLoop
    pea     ($000A).w               ; timeout = $A (10 frames)
    jsr ProcessInputLoop            ; d0 = accepted button bitmask (after timeout)
    addq.l  #$8, a7
    andi.l  #$90, d0                ; mask: $80 = Start, $10 = A button
    beq.b   l_1ca4a                 ; neither pressed -> keep waiting
; Restore trade screen: load original screen_id back, then reload trade gfx.
    jsr ResourceLoad
    move.w  (a2), ($00FF9A1C).l     ; screen_id = original player index (restore)
; LoadScreen args: player_index, screen_id (from $FF9A1C), flag=1
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: screen_id
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: char_mode
    jsr LoadScreen                  ; reload the original trade background graphics
; ShowRelPanel: restore the trade relation panel.
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
; Re-run main menu for the original player.
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
; Re-decompress and re-render trade background.
    move.l  ($000A1B54).l, -(a7)    ; ROM ptr to LZ-compressed trade background
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w               ; GameCommand $1B = draw box
    jsr     (a4)
; Refresh flight slots for the (restored) player index.
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $24(a7), a7
    jsr ResourceUnload

; ============================================================================
; --- Phase: Unrecognized button / fall-through cleanup ---
; Clear input/countdown flags and fall into the cursor-redraw path.
; ============================================================================
l_1cb14:
    clr.w   (a3)                    ; input_mode_flag = 0
    clr.w   (a5)                    ; input_init_flag = 0

; ============================================================================
; --- Phase: Redraw cursor and post-action flight animation ---
; After any cursor movement or action, redraw the cursor sprite at the current
; (d5, d6) position, then run 4 frames of flight path animation before
; looping back to the main input handler.
; ============================================================================
l_1cb18:
    move.l  #$8000, -(a7)           ; sprite attribute (high priority)
    pea     ($0002).w               ; Y scale = 2
    pea     ($0002).w               ; X scale = 2
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; Y pixel = d5 * 8
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; X pixel = d6 * 8
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w               ; cursor sprite tile id
    jsr TilePlacement               ; place cursor at new position
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand $0E = flush display
    jsr     (a4)
    lea     $24(a7), a7
; Animate 4 frames of flight paths before polling input again.
    clr.w   d2                      ; d2 = animation frame counter (0..3)
l_1cb52:
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths          ; draw one frame of animated flight arcs
    pea     ($0001).w
    pea     ($000E).w               ; flush display
    jsr     (a4)
    lea     $c(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1cb52                 ; loop for 4 frames
    bra.w   l_1c746                 ; -> back to main input loop

; ============================================================================
; --- Phase: Epilogue ---
; ============================================================================
l_1cb78:
    movem.l -$28(a6), d2-d7/a2-a5  ; restore registers (from link frame)
    unlk    a6
    rts
