; ============================================================================
; DisplayRouteDestChoice -- Display selectable destination slots for a route type, handle scrolling navigation and selection input
; 1308 bytes | $00DB72-$00E08D
; ============================================================================
; --- Phase: Frame Setup and Slot-Count Detection ---
; Arguments (from stack frame):
;   $8(a6)  = (not used here, likely caller context)
;   $a(a6)  = player index
;   $e(a6)  = dialog/panel mode
;   $10(a6) = route type index (d7): < $20 = domestic route type, >= $20 = international type
;   $1a(a6) = initial cursor position (d3)
;   $16(a6) = reload flag (1 = reload screen graphics)
; Local frame: -$2(a6)=has_input_flag, -$4(a6)=last_input, -$5E(a6)=sprintf buffer (96 bytes)
; a2 = destination city slot array base, a4 = assignment status array base.
; d2 = usable slot count (how many slots have a valid city, < $0F sentinel).
DisplayRouteDestChoice:
    link    a6,#-$60              ; allocate $60 = 96 bytes (includes sprintf buffer at -$5E)
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7           ; d7 = route type index ($10 = 16th stack byte)
    movea.l  #$00000D64,a5        ; a5 = GameCommand dispatcher ($000D64)
; Select slot table based on route type: domestic (< $20) vs international (>= $20)
    cmpi.w  #$20, d7              ; is route type >= $20 (international)?
    bge.b   l_0dbc4               ; yes: use international slot tables
; --- Domestic route tables: stride 6, up to 6 slots ---
; $FF1704: domestic destination city array (stride 6, indexed by route type)
; $FF0420: domestic assignment status array (stride 6, matches city array layout)
    move.w  d7, d0
    mulu.w  #$6, d0               ; d0 = route_type * 6 (stride into domestic table)
    movea.l  #$00FF1704,a0        ; a0 -> domestic city slot array base ($FF1704)
    lea     (a0,d0.w), a0         ; a0 -> this route type's city slot entry
    movea.l a0, a2                ; a2 = base of city slot array for this route
    move.w  d7, d0
    mulu.w  #$6, d0               ; d0 = route_type * 6
    movea.l  #$00FF0420,a0        ; a0 -> domestic assignment status array ($FF0420, $C0 bytes)
    lea     (a0,d0.w), a0
    movea.l a0, a4                ; a4 = base of assignment status array for this route
; Count valid destination slots (entries < $0F = valid city; $0F+ = sentinel/empty)
    clr.w   d2                    ; d2 = slot scan index
l_0dbb0:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)       ; is this slot sentinel ($0F or higher = no more cities)?
    bcc.b   l_0dbf8               ; yes: stop counting, d2 = usable slot count
    addq.w  #$1, d2               ; advance to next slot
    cmpi.w  #$6, d2               ; scanned all 6 domestic slots?
    blt.b   l_0dbb0               ; no: continue scanning
    bra.b   l_0dbf8               ; yes: all 6 slots valid (d2 = 6)

; --- International route tables: stride 4, up to 4 slots ---
; $FF15A0: international destination city array (stride 4)
; $FF0460: international assignment status array (stride 4)
l_0dbc4:
    move.w  d7, d0
    lsl.w   #$2, d0               ; d0 = route_type * 4 (stride into international table)
    movea.l  #$00FF15A0,a0        ; a0 -> international city slot array ($FF15A0)
    lea     (a0,d0.w), a0
    movea.l a0, a2                ; a2 = international city slot array for this route type
    move.w  d7, d0
    lsl.w   #$2, d0               ; d0 = route_type * 4
    movea.l  #$00FF0460,a0        ; a0 -> international assignment status array ($FF0460)
    lea     (a0,d0.w), a0
    movea.l a0, a4                ; a4 = international assignment status array for this route type
    clr.w   d2                    ; d2 = slot scan index
l_0dbe6:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)       ; is this slot sentinel?
    bcc.b   l_0dbf8               ; yes: stop scanning
    addq.w  #$1, d2               ; advance to next slot
    cmpi.w  #$4, d2               ; scanned all 4 international slots?
    blt.b   l_0dbe6               ; no: continue
; --- Phase: Screen Load and Initial Panel Display ---
; If the reload flag ($16(a6) == 1), load the game screen for this route type and
; unload the previous resource. Then draw the route destination choice dialog.
l_0dbf8:
    cmpi.w  #$1, $16(a6)         ; is the reload flag set?
    bne.b   l_0dc12              ; no: screen is already loaded, skip reload
    move.w  d7, ($00FFA6B0).l    ; $FFA6B0 = route type index (used by ShowGameScreen for background selection)
    jsr ShowGameScreen            ; load and display the appropriate background screen
    jsr ResourceUnload            ; release previous resource to free memory
; Display the route destination choice header dialog
l_0dc12:
    pea     ($0001).w             ; wait for input = 1
    clr.l   -(a7)                 ; arg padding
    clr.l   -(a7)                 ; arg padding
    move.w  $e(a6), d0           ; $e(a6) = dialog panel mode / column index
    ext.l   d0
    move.l  d0, -(a7)            ; push panel mode
    move.l  ($0004778C).l, -(a7) ; pointer to route destination choice dialog title text
    move.w  $a(a6), d0           ; $a(a6) = player index
    ext.l   d0
    move.l  d0, -(a7)            ; push player index
    jsr ShowTextDialog            ; display the route-choice header dialog
    lea     $18(a7), a7           ; pop 6 args = $18
; Clear the destination list panel area (6 tall x $17 wide at row 2, col $13)
    clr.l   -(a7)
    pea     ($0006).w             ; height = 6 tiles
    pea     ($0017).w             ; width = $17 = 23 tiles
    pea     ($0013).w             ; row = $13 = 19
    pea     ($0002).w             ; col = 2
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a5)                  ; clear the destination list display area
; d6 = initial cursor tile column, d5 = initial cursor tile row (computed from slot layout)
; These are fixed starting coordinates for the 2-column destination grid.
    moveq   #$D,d6               ; d6 = $D = 13 (base tile column for left column of destination grid)
    moveq   #$5,d5               ; d5 = 5 (base tile row for destination grid)
; Sample initial joypad state to detect buttons held at entry
    clr.l   -(a7)
    jsr ReadInput                 ; read joypad (7 words of args already cleared by previous push)
    lea     $20(a7), a7           ; pop 8 args (including the clr.l padding above)
    tst.w   d0                   ; any button held at entry?
    beq.b   l_0dc6c
    moveq   #$1,d0               ; d0 = 1 = button held flag (drain before acting)
    bra.b   l_0dc6e
l_0dc6c:
    moveq   #$0,d0               ; d0 = 0 = no button held
l_0dc6e:
    move.w  d0, -$2(a6)         ; -$2(a6) = has_input_flag (1 = button held at entry, drain first)
    clr.w   -$4(a6)              ; -$4(a6) = last_input state = 0
    clr.w   ($00FF13FC).l        ; $FF13FC = input_mode_flag = 0 (reset UI countdown)
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0 (reset auto-repeat state)
    move.w  $1a(a6), d3          ; d3 = initial cursor slot index (from caller: $1a(a6))
    move.w  #$ff, d4             ; d4 = $FF = "no slot previously highlighted" sentinel
; --- Phase: Main Per-Frame Loop ---
; Each iteration: if d3 != d4 (cursor moved), redraw the destination display.
; d3 = current cursor slot, d4 = previously-drawn slot (used to detect changes).
; The slot grid has 2 columns: even slots on the left, odd slots on the right.
; Tile column: d6 = (d3 / 2) * 6 + $D. Tile row: d5 = (d3 & 1) * 5 + 5.
l_0dc8a:
    cmp.w   d3, d4               ; has the cursor slot changed since last frame?
    beq.w   l_0de02              ; no: skip redraw, go straight to input polling
; Cursor changed: redraw the destination grid display
; First clear the selection highlight area (5 high x 6 wide at cursor's tile position)
    move.l  #$8000, -(a7)        ; priority flag = $8000
    pea     ($0005).w             ; height = 5 tiles
    pea     ($0006).w             ; width = 6 tiles
    move.w  d5, d0               ; d5 = tile row for cursor (computed after this block)
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0               ; d6 = tile column for cursor
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w             ; col = 1
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a5)                  ; clear old cursor highlight area
    lea     $1c(a7), a7
; Clear the left column header strip (4 tall x $C wide at row 0 col $F)
    move.l  #$8000, -(a7)
    pea     ($0004).w             ; height = 4 tiles
    pea     ($000C).w             ; width = $C = 12 tiles
    pea     ($000F).w             ; row = $F = 15
    clr.l   -(a7)                 ; col = 0
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A
    jsr     (a5)                  ; clear left header strip
    lea     $1c(a7), a7
; Clear the right column header strip (4 tall x $C wide at row 0 col $F+$14)
    move.l  #$8000, -(a7)
    pea     ($0004).w             ; height = 4 tiles
    pea     ($000C).w             ; width = $C = 12 tiles
    pea     ($000F).w             ; row = $F = 15
    pea     ($0014).w             ; col = $14 = 20 (right column offset)
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A
    jsr     (a5)                  ; clear right header strip
    lea     $1c(a7), a7
; Compute tile position for the new cursor slot (2-column grid layout):
;   Left column  = even slot indices (0, 2, 4...), right column = odd (1, 3, 5...)
;   Tile column d6 = (d3 >> 1) * 6 + $D
;   Tile row    d5 = (d3 & 1) * 5 + 5
    move.w  d3, d6
    ext.l   d6
    asr.l   #$1, d6              ; d6 = d3 / 2 (row of 2-up grid: pair index)
    mulu.w  #$6, d6              ; d6 = pair * 6 (6 tiles per column pair)
    addi.w  #$d, d6              ; d6 = tile column = pair*6 + $D (offset from left edge)
    move.w  d3, d5
    andi.w  #$1, d5              ; d5 = d3 & 1 (0 = left col, 1 = right col)
    mulu.w  #$5, d5              ; d5 = 0 or 5 (5 tiles column width)
    addq.w  #$5, d5              ; d5 = tile row = (d3&1)*5 + 5 (base row offset)
; Place the selection cursor tile at the computed pixel position.
; Pixel X = d5 * 8 + $10 (left margin), Pixel Y = d6 * 8 + $20 (top margin).
; Tile $0544 is the cursor/highlight tile graphic.
    clr.l   -(a7)
    pea     ($0002).w             ; flip flags
    pea     ($0001).w             ; palette
    move.w  d5, d0               ; d5 = column position (tile unit)
    ext.l   d0
    lsl.l   #$3, d0              ; * 8 (convert tile coord to pixel)
    addi.l  #$10, d0             ; + $10 pixel left margin
    move.l  d0, -(a7)            ; X pixel position
    move.w  d6, d0               ; d6 = row position
    ext.l   d0
    lsl.l   #$3, d0              ; * 8 (tile to pixel)
    addi.l  #$20, d0             ; + $20 pixel top margin
    move.l  d0, -(a7)            ; Y pixel position
    clr.l   -(a7)
    pea     ($0544).w             ; tile index $0544 = selection cursor/highlight tile
    jsr TilePlacement             ; place the cursor sprite tile at the computed position
; Wait one frame for display sync
    pea     ($0001).w
    pea     ($000E).w             ; GameCommand #$0E = frame sync
    jsr     (a5)
    lea     $24(a7), a7           ; pop TilePlacement ($1C) + GameCmd ($8) = $24
; Check if the current slot contains a valid city (< $0F = valid; >= $0F = empty/sentinel)
    lea     (a2,d3.w), a0         ; a0 -> city slot for current cursor position (a2 base + d3 byte offset)
    movea.l a0, a3                ; a3 = pointer to current slot's city byte in city array
    cmpi.b  #$f, (a0)            ; is slot a sentinel (no city assigned)?
    bcc.w   l_0de00              ; yes: slot is empty, skip city info display
; --- Render City Info for Current Slot ---
; Slot has a valid city. Set up the text window and display the city name + char value.
; CalcCharValue computes a player-specific "value" score for the city.
    pea     ($0020).w             ; text window width = 32
    pea     ($0020).w             ; text window height = 32
    clr.l   -(a7)                 ; left = 0
    clr.l   -(a7)                 ; top = 0
    jsr SetTextWindow             ; configure full-screen text viewport
; Calculate character value for this city slot
    moveq   #$0,d0
    move.b  (a3), d0             ; d0 = city index from current slot (byte[0] of slot = city_a)
    move.l  d0, -(a7)            ; push city index
    move.w  d7, d0               ; d7 = route type index
    ext.l   d0
    move.l  d0, -(a7)            ; push route type
    move.w  $a(a6), d0           ; $a(a6) = player index
    ext.l   d0
    move.l  d0, -(a7)            ; push player index
    jsr (CalcCharValue,PC)        ; compute value score for city/player/route combo; d0 = value
    nop
    lea     $1c(a7), a7           ; pop SetTextWindow ($10) + CalcCharValue ($C) = $1C
    move.l  d0, d4               ; d4 = city value score (saved for printing below)
; Clear the city info panel area (2 tall x $1F wide at row 1 col $10)
    move.l  #$8000, -(a7)
    pea     ($0002).w             ; height = 2 tiles
    pea     ($001F).w             ; width = $1F = 31 tiles
    pea     ($0010).w             ; row = $10 = 16
    pea     ($0001).w             ; col = 1
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a5)                  ; clear city info display area
; Print city name at cursor position ($10, 1)
    pea     ($0010).w             ; cursor X = $10 = 16
    pea     ($0001).w             ; cursor Y = 1
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a3), d0             ; d0 = city index (slot city_a field)
    lsl.w   #$2, d0              ; * 4 (long pointer table index)
    movea.l  #$0005E2A2,a0       ; a0 -> city name string pointer table
    move.l  (a0,d0.w), -(a7)    ; push city name string pointer
    pea     ($0003E8CC).l        ; push "%s" city-name format string
    jsr PrintfWide                ; print city name in wide font
    lea     $2c(a7), a7           ; pop SetTextWindow($10) + SetTextCursor($8) + PrintfWide($8) = ... accumulative = $2C total
; Print city value score at cursor position ($10, $14)
    pea     ($0010).w             ; cursor X = $10 = 16
    pea     ($0014).w             ; cursor Y = $14 = 20
    jsr SetTextCursor
    move.l  d4, -(a7)            ; push city value score
    pea     ($0003E8C6).l        ; push format string for numeric value display (e.g. "%d")
    jsr PrintfWide                ; print value score
    lea     $10(a7), a7          ; pop SetTextCursor($8) + PrintfWide($8) = $10
l_0de00:
    move.w  d3, d4               ; d4 = last-drawn slot = current cursor (clear "cursor moved" condition)

; --- Phase: Input Drain and ProcessInputLoop ---
; Drain held buttons (if -$2(a6) set), then poll for new button presses.
; A button ($20) = confirm selection. B/back ($10) = cancel. D-pad = move cursor.
l_0de02:
    tst.w   -$2(a6)              ; was a button held at entry (or previous frame)?
    beq.b   l_0de26              ; no: skip drain, poll normally
; Drain: read and discard one joypad frame to avoid held-button false triggers
    clr.l   -(a7)
    jsr ReadInput                 ; sample current raw input
    addq.l  #$4, a7
    tst.w   d0                   ; still holding a button?
    beq.b   l_0de26              ; no longer held: proceed to normal input
; Still held: wait 2 frames and loop back to redraw (keep draining)
    pea     ($0002).w             ; wait 2 frames
l_0de1a:
    pea     ($000E).w             ; GameCommand #$0E = frame sync
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   l_0dc8a              ; restart the display loop (slot not changed)
l_0de26:
    clr.w   -$2(a6)              ; clear the held-button drain flag
; Poll debounced input
    move.w  -$4(a6), d0         ; -$4(a6) = last_input (auto-repeat state)
    move.l  d0, -(a7)
    pea     ($000A).w            ; auto-repeat threshold = 10 frames
    jsr ProcessInputLoop          ; d0 = new debounced button bits
    addq.l  #$8, a7
    move.w  d0, -$4(a6)         ; save new input state for next frame
    andi.w  #$20, d0             ; test A button ($20)
    beq.w   l_0df84              ; A not pressed: check other buttons
; --- A Button: Confirm Destination Selection ---
; A-button pressed on a valid slot. Replace cursor tile with "selected" tile ($0546),
; then validate the slot and assignment status before returning the selected index.
    clr.w   ($00FF13FC).l        ; $FF13FC = input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0
; Place the "confirmed selection" tile at the cursor position (tile $0546 vs $0544)
    clr.l   -(a7)
    pea     ($0002).w             ; flip flags
    pea     ($0001).w             ; palette
    move.w  d5, d0               ; d5 = column
    ext.l   d0
    lsl.l   #$3, d0              ; * 8 (pixel)
    addi.l  #$10, d0             ; + $10 left margin
    move.l  d0, -(a7)            ; X pixel
    move.w  d6, d0               ; d6 = row
    ext.l   d0
    lsl.l   #$3, d0              ; * 8 (pixel)
    addi.l  #$20, d0             ; + $20 top margin
    move.l  d0, -(a7)            ; Y pixel
    clr.l   -(a7)
    pea     ($0546).w             ; tile index $0546 = "selected" cursor tile (filled)
    jsr TilePlacement             ; place the confirmed-selection tile
; Wait 2 frames for the visual confirmation
    pea     ($0002).w             ; 2 frames
    pea     ($000E).w             ; GameCommand #$0E
    jsr     (a5)
    lea     $24(a7), a7
; Validate selection: slot must have a city (< $0F) and an available assignment slot
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)      ; is current slot empty (city byte >= $0F)?
    bcc.w   l_0df84              ; yes: slot is empty, treat as no selection
    movea.w d3, a0
    cmpi.b  #$ff, (a4,a0.w)     ; is assignment status byte $FF (slot fully assigned)?
    bne.b   l_0deb6              ; no: not $FF, fall through to assignment check
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)      ; is city byte valid (< $0F)?
    bcs.w   l_0e05e              ; yes: city is valid, proceed to return selection
; --- Slot Already Assigned: Format Assignment Description ---
; The assignment status byte (a4[d3]) is not $FF, meaning this slot has a player
; assignment. Check if the assigning player is the current player or another.
; If same player: format "City: <city name>" string.
; If other player: look up the player's name from $FF00A8 table and format "City: <name> <city>".
l_0deb6:
    lea     (a4,d3.w), a0         ; a0 -> assignment status byte for current slot
    movea.l a0, a3                ; a3 = assignment status pointer
    move.b  (a0), d0             ; d0 = raw assignment byte (bit 7 flag + player index in low 7 bits)
    andi.l  #$7f, d0             ; mask off bit 7 to get assigning player index
    move.w  $a(a6), d1           ; d1 = current player index
    ext.l   d1
    cmp.l   d1, d0               ; is slot assigned to current player?
    bne.b   l_0defc              ; no: assigned to another player, use full-name format
; Assigned to current player: format "City: <city name>" (no player name prefix)
    movea.w d3, a0
    move.b  (a2,a0.w), d0        ; d0 = city index from city slot array
    andi.l  #$ff, d0             ; zero-extend to long
    lsl.w   #$2, d0              ; * 4 (long pointer table index)
    movea.l  #$0005E2A2,a0       ; a0 -> city name pointer table
    move.l  (a0,d0.w), -(a7)    ; push city name string pointer
    move.l  ($000477A0).l, -(a7) ; push "assigned to you: %s" format string
    pea     -$5e(a6)             ; push output buffer (96-byte frame local at -$5E(a6))
    jsr sprintf                   ; format assignment description into buffer
    lea     $c(a7), a7            ; pop 3 args
    bra.b   l_0df3a              ; show the formatted dialog
l_0defc:
; Assigned to another player: format "<player name>, <city name>" description
    move.b  (a3), d0             ; d0 = raw assignment byte
    andi.w  #$7f, d0             ; strip bit 7 = assigning player index (0-3)
    lsl.w   #$4, d0              ; * 16 (stride into player name table at $FF00A8)
    movea.l  #$00FF00A8,a0       ; a0 -> player name table ($FF00A8, stride $10, 16 bytes per entry)
    pea     (a0, d0.w)           ; push pointer to assigning player's name string
    movea.w d3, a0
    move.b  (a2,a0.w), d0        ; d0 = city index
    andi.l  #$ff, d0
    lsl.w   #$2, d0              ; * 4
    movea.l  #$0005E2A2,a0       ; a0 -> city name pointer table
    move.l  (a0,d0.w), -(a7)    ; push city name string pointer
    move.l  ($00047790).l, -(a7) ; push "%s - %s" or "assigned to %s: %s" format string
    pea     -$5e(a6)             ; push output buffer
    jsr sprintf                   ; format "PlayerName, CityName" into buffer
    lea     $10(a7), a7          ; pop 4 args (player name + city name + format + buffer)
; Show the formatted assignment-info dialog
l_0df3a:
    pea     ($0001).w             ; wait for input
    clr.l   -(a7)
    pea     ($0002).w             ; dialog mode 2
    move.w  $e(a6), d0           ; $e(a6) = panel mode
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$5e(a6)             ; formatted buffer string (local frame)
    move.w  $a(a6), d0           ; player index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog            ; show the assignment description to the player
; Redisplay the route-choice title dialog (restore after the sub-dialog)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $e(a6), d0           ; panel mode
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004778C).l, -(a7) ; main title dialog text pointer
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog            ; restore the main route-choice header dialog
    lea     $30(a7), a7           ; pop both ShowTextDialog call stacks
; --- Phase: D-Pad Navigation (non-A buttons) ---
; Test remaining button bits for B (cancel) and d-pad directions.
; The destination grid is 2 columns wide; d-pad maps:
;   down ($08)  = move to slot index +2 (next pair row)
;   up   ($04)  = move to slot index -2 (prev pair row, clamped)
;   right($02)  = move to slot index | 1 (right column within current row)
;   left ($01)  = move to slot index & ~1 (left column within current row)
l_0df84:
    move.w  -$4(a6), d0         ; reload last_input
    andi.w  #$10, d0            ; test B button ($10)
    beq.b   l_0dfa2             ; not B: check d-pad
; B button: cancel / return $FF (no selection)
    clr.w   ($00FF13FC).l       ; $FF13FC = input_mode_flag = 0
    clr.w   ($00FFA7D8).l       ; $FFA7D8 = input_init_flag = 0
    move.w  #$ff, d3            ; d3 = $FF = "cancelled" return value
    bra.w   l_0e05e             ; return d3 to caller
l_0dfa2:
    move.w  -$4(a6), d0
    andi.w  #$f, d0             ; test all 4 d-pad bits ($0F = up|down|left|right)
    beq.w   l_0e056             ; no d-pad: skip navigation, wait next frame
; Down d-pad ($08): advance cursor by 2 (move down one pair-row in 2-column grid)
    move.w  -$4(a6), d0
    andi.w  #$8, d0             ; test down bit
    beq.b   l_0dfd0             ; not down: skip
    move.w  #$1, ($00FF13FC).l  ; $FF13FC = 1 = start input countdown (auto-repeat)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$2, d0             ; candidate = d3 + 2
    move.w  d2, d1              ; d2 = usable slot count
    ext.l   d1
    cmp.l   d1, d0              ; would new index exceed count?
    bge.b   l_0dfd0             ; yes: clamp (don't move beyond last valid slot)
    addq.w  #$2, d3             ; advance cursor by 2 (next row)
l_0dfd0:
; Up d-pad ($04): retreat cursor by 2 (move up one pair-row), clamp to row 0
    move.w  -$4(a6), d0
    andi.w  #$4, d0             ; test up bit
    beq.b   l_0e006             ; not up: skip
    move.w  #$1, ($00FF13FC).l  ; start auto-repeat
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0             ; candidate = d3 - 2
    move.w  d3, d1
    andi.l  #$1, d1             ; d1 = d3 & 1 (current column: 0=left, 1=right)
    cmp.l   d1, d0              ; would new index go below 0 (or below column bias)?
    ble.b   l_0dffc             ; yes: clamp to column position (stay at row 0)
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0             ; safe to move up
    bra.b   l_0e004
l_0dffc:
    move.w  d3, d0
    andi.l  #$1, d0             ; d0 = d3 & 1 (minimum slot = 0 for left, 1 for right col)
l_0e004:
    move.w  d0, d3              ; update cursor
l_0e006:
; Right d-pad ($02): move cursor to odd-indexed slot (right column) of current row
    move.w  -$4(a6), d0
    andi.w  #$2, d0             ; test right bit
    beq.b   l_0e040             ; not right: skip
    move.w  #$1, ($00FF13FC).l  ; start auto-repeat
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0             ; set bit 0 = move to right column (odd index)
    move.w  d2, d1              ; d2 = slot count
    ext.l   d1
    subq.l  #$1, d1             ; d1 = max valid index (count - 1)
    cmp.l   d1, d0              ; would right-column index exceed max?
    bge.b   l_0e038             ; yes: clamp to last valid slot
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0             ; move to right column
    bra.b   l_0e03e
l_0e038:
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0             ; clamp to last valid index
l_0e03e:
    move.w  d0, d3
l_0e040:
; Left d-pad ($01): move cursor to even-indexed slot (left column) of current row
    move.w  -$4(a6), d0
    andi.w  #$1, d0             ; test left bit
    beq.b   l_0e056             ; not left: skip
    move.w  #$1, ($00FF13FC).l  ; start auto-repeat
    andi.w  #$fe, d3            ; clear bit 0 = move to left column (even index)
l_0e056:
; Wait 4 frames and loop back to redraw (after any navigation)
    pea     ($0004).w            ; 4 frames delay before updating cursor display
    bra.w   l_0de1a             ; merge into frame-wait path (GameCmd #$0E x2, then loop)
; --- Epilog: Clear Cursor and Return Selected Slot ---
; Clear the cursor tile from the screen before returning.
; d3 = selected slot index, or $FF if cancelled (set by B-button handler).
; Return value in d0 = d3 (the caller reads d0 for the selected destination).
l_0e05e:
    move.l  #$8000, -(a7)        ; priority = $8000
    pea     ($0005).w             ; height = 5 tiles (same as cursor tile size)
    pea     ($0006).w             ; width = 6 tiles
    move.w  d5, d0               ; cursor tile column
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0               ; cursor tile row
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w             ; col = 1
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea (erase cursor tile)
    jsr     (a5)                  ; clear the cursor tile from the screen
    move.w  d3, d0               ; d0 = selected slot index (or $FF = cancelled)
    movem.l -$88(a6), d2-d7/a2-a5 ; restore saved registers from link frame
    unlk    a6                    ; restore A6 and deallocate frame
    rts
