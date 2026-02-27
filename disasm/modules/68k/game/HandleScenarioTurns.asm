; ============================================================================
; HandleScenarioTurns -- Display scenario selection menu for all 4 players with navigation and confirmation, return chosen scenario index
; 1080 bytes | $00A5E4-$00AA1B
; ============================================================================
; Implements the scenario/opponent selection screen shown before a game starts.
; Iterates 4 player slots, renders each player's name and team info in a two-row
; text block. The player can navigate Up/Down to highlight a row and press A to
; confirm, triggering a detailed confirmation panel with full team info. C button
; or B button cancel back to the list. Returns the selected scenario/player index.
;
; Register map (for the entire function):
;   d2  = player list iterator (0-3) / scenario index
;   d3  = current text cursor row (starts at $5, advances by $3 per player)
;   d4  = held-button drain flag (1 = button held on entry, drain before accepting input)
;   d5  = ProcessInputLoop state carry / masked button bitmask
;   a2  = $FF0002 (month_counter / current player selection index word)
;   a3  = $0003B246 (PrintfNarrow -- 2-arg print: cmd, string_ptr)
;   a4  = $00000D64 (GameCommand dispatcher)
;   a5  = $00047630 (ScenarioDescPtrs -- 4 longword ptrs to player description strings)
; ============================================================================
HandleScenarioTurns:
    link    a6,#-$80                ; frame: $80 bytes local (for sprintf output at -$80(a6))
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0002,a2          ; a2 -> month_counter ($FF0002) = current selection index
    movea.l  #$0003B246,a3          ; a3 -> PrintfNarrow ($03B246)
    movea.l  #$00000D64,a4          ; a4 -> GameCommand dispatcher ($0D64)
    movea.l  #$00047630,a5          ; a5 -> ScenarioDescPtrs ($047630): 4 longword ptrs

; ============================================================================
; --- Phase: Render scenario list panel ---
; Clear screen, draw the outer box, set full text window, then render a
; 2-row text block for each of the 4 players:
;   Row 0 (d3+0, col 2): player index + 1 and player name string
;   Row 1 (d3+1, col 6): player detail/description string
; Rows start at d3=$5 and advance by $3 per player (two text rows + 1 gap).
; ============================================================================
    clr.l   -(a7)
    jsr CmdSetBackground            ; clear screen to background color
    moveq   #$5,d3                  ; d3 = first text row (players listed from row $5 down)
    pea     ($000D).w               ; box height = $D tiles
    pea     ($0020).w               ; box width = $20 tiles (full width)
    pea     ($0004).w               ; box y position = $4
    clr.l   -(a7)                   ; box x position = 0
    jsr DrawBox                     ; draw the player list panel border
    pea     ($0020).w               ; text window width = $20
    pea     ($0020).w               ; text window height = $20
    clr.l   -(a7)                   ; x = 0
    clr.l   -(a7)                   ; y = 0
    jsr SetTextWindow               ; set full-screen text window for list rendering
    lea     $24(a7), a7
    clr.w   d2                      ; d2 = player iterator (0..3)

; --- Sub-phase: Player list render loop ---
; For each player 0-3: print player number + name (row d3), then description (row d3+1).
; ScenarioDescPtrs ($047630) is a table of 4 longword pointers (stride 4), one per player.
; Parallel sub-table at a5+$10 offset per entry holds description line 2 string pointers.
.l0a63a:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)               ; arg: text row = d3
    pea     ($0002).w               ; arg: text col = 2
    jsr SetTextCursor
; Load name string ptr from ScenarioDescPtrs[$047630]: index = d2 * 4
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0                 ; d0 = d2 * 4 (longword stride in ptr table)
    movea.l d0, a0                  ; a0 = table offset (used as index register)
    move.l  (a5,a0.l), -(a7)       ; arg: player name string ptr from ScenarioDescPtrs[d2]
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0                 ; d0 = player index + 1 (1-based for display: "1 AIRLINE")
    move.l  d0, -(a7)               ; arg: player number (1-4)
    pea     ($0003E570).l           ; arg: format string at $03E570 ("%d %s" or similar)
    jsr     (a3)                    ; PrintfNarrow: print "N name" at (row, col)
; Print description line at row d3+1, col 6.
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0                 ; next row = d3 + 1
    move.l  d0, -(a7)
    pea     ($0006).w               ; col = 6 (indented under the name)
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0                 ; d2 * 4
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)   ; arg: description ptr from ScenarioDescPtrs+$10[d2]
                                    ; (parallel sub-table: each entry at stride $10 within a5)
    jsr     (a3)                    ; PrintfNarrow: print description line
    lea     $20(a7), a7
    addq.w  #$3, d3                 ; d3 += 3: advance to next player's text rows (2 rows + 1 gap)
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a63a                 ; loop for all 4 players

; --- Phase: Post-list display sync ---
    jsr ResourceUnload              ; release any held rendering resources

; DisplayMessageWithParams: show an initial prompt/instruction message.
; Args: 0, msg_ptr (from ScenarioStrPtrs[$0475DC]), 0, 0, 0
    clr.l   -(a7)                   ; arg5: 0
    clr.l   -(a7)                   ; arg4: 0
    clr.l   -(a7)                   ; arg3: 0
    move.l  ($000475DC).l, -(a7)    ; arg2: msg ptr from ScenarioStrPtrs ($0475DC) -> "SELECT PLAYER"
    clr.l   -(a7)                   ; arg1: 0 (display mode)
    jsr (DisplayMessageWithParams,PC)
    nop

; --- Phase: Drain held button on entry ---
; Read one frame of input to see if a button is already held (e.g. from previous screen).
    clr.l   -(a7)
    jsr ReadInput                   ; d0 = current button state
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0a6c2
    moveq   #$1,d4                  ; d4 = 1: button held on entry -> will drain before accepting
    bra.b   .l0a6c4
.l0a6c2:
    moveq   #$0,d4                  ; d4 = 0: no button held
.l0a6c4:
    clr.w   d5                      ; d5 = ProcessInputLoop carry state (start fresh)
    clr.w   ($00FF13FC).l           ; input_mode_flag = 0 (clear UI input session flag)
    clr.w   ($00FFA7D8).l           ; input_init_flag = 0 (clear countdown armed flag)
    clr.w   (a2)                    ; $FF0002 = 0 (current selection starts at player 0)

; ============================================================================
; --- Phase: Main selection loop ---
; Each iteration:
;   1. Compute cursor row from current selection (a2) and place cursor tile.
;   2. Drain held button with AnimateFlightPaths (here: just GameCommand $0E ticks).
;   3. Call ProcessInputLoop to read a button press.
;   4. Dispatch on button: A=confirm, B=scroll up, C=cancel?, Up=prev, Down=next.
; ============================================================================
.l0a6d4:
; Compute text cursor row for the current selection.
; Row formula: d3 = (a2) * 3 + 4
;   move.w (a2),d3; d3 = d3*2 + d3 (i.e. d3*3); d3 += 4
    move.w  (a2), d3                ; d3 = current player index (0-3)
    add.w   d3, d3                  ; d3 *= 2
    add.w   (a2), d3                ; d3 += (a2) -> d3 = index * 3
    addq.w  #$4, d3                 ; d3 += 4 -> cursor row for player index

; Place cursor tile at the selection row.
; TilePlacement args: tile_id=$0544, col=2, row=d3, y_px=(d3*8+9), x_px=2*8, scale=1, scale=1, 0
    clr.l   -(a7)                   ; 0
    pea     ($0002).w               ; X scale = 1 (but arg order: x_col=2)
    pea     ($0001).w               ; Y scale = 1
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0                 ; Y pixel = d3 * 8 (convert tile row to pixel)
    addi.l  #$9, d0                 ; Y pixel += 9 (fine-tune for centering on the row)
    move.l  d0, -(a7)
    pea     ($0011).w               ; X pixel = $11 (17 = cursor left-margin)
    pea     ($0002).w               ; sprite attribute (palette)
    pea     ($0544).w               ; tile_id $544 = selection cursor arrow tile
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand $0E = flush display
    jsr     (a4)
    lea     $24(a7), a7

; --- Sub-phase: Drain held button (animate until button released) ---
    tst.w   d4                      ; d4 = 1 -> button held on entry or previous iter
    beq.b   .l0a734                 ; no held button -> go directly to ProcessInputLoop
    clr.l   -(a7)
    jsr ReadInput                   ; poll input
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0a734                 ; button released -> proceed to input processing
    pea     ($0002).w               ; flush arg = 2 (double flush for held-button drain)
.l0a72a:
    pea     ($000E).w               ; GameCommand $0E = flush
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l0a6d4                 ; loop back to top (keeps draining while held)

; --- Sub-phase: Read player input ---
.l0a734:
    clr.w   d4                      ; d4 = 0 (held-button drain complete)
    move.w  d5, d0
    move.l  d0, -(a7)               ; ProcessInputLoop carry state
    pea     ($000A).w               ; timeout = $A (10-frame countdown)
    jsr ProcessInputLoop            ; d0 = accepted button bitmask after countdown
    addq.l  #$8, a7
    andi.w  #$33, d0                ; mask: $20(A), $10(B), $02(Down), $01(Up)
    move.w  d0, d5                  ; d5 = masked button bitmask
    andi.w  #$20, d0                ; A button pressed?
    beq.w   .l0a99c                 ; no -> check other buttons

; ============================================================================
; --- Phase: A button -- show confirmation panel for selected player ---
; Clear input state, draw a confirmation box with full player info,
; then ask the player to confirm or cancel. On confirm, return selection.
; ============================================================================
    clr.w   ($00FF13FC).l           ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l           ; input_init_flag = 0
; Remove the old cursor tile (place blank tile at same position).
; Tile $0546 = blank/cursor-clear tile.
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2                  ; d2 = cursor row (saved from selection row calc above)
    ext.l   d2
    lsl.l   #$3, d2                 ; d2 = cursor row * 8 (pixel Y)
    addi.l  #$9, d2                 ; fine-tune offset
    move.l  d2, -(a7)
    pea     ($0011).w               ; X pixel = $11
    pea     ($0002).w
    pea     ($0546).w               ; tile $546 = cursor-clear (blank) tile
    jsr TilePlacement               ; erase the selection cursor from the list
    pea     ($000F).w
    pea     ($000E).w               ; GameCommand $0E flush x 2
    jsr     (a4)
    lea     $24(a7), a7
; Place filled cursor tile ($0548) at the same row to show the selected state.
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)              ; same pixel Y as before
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0548).w               ; tile $548 = selected/filled cursor tile
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a4)

; GameCmd16: mode switch for the confirmation panel ($1, $2).
    pea     ($0001).w               ; param2
    pea     ($0002).w               ; param1
    jsr GameCmd16                   ; configure display for the confirmation detail box
    lea     $2c(a7), a7

; Draw the confirmation detail box.
; GameCommand $1A: overlay panel args: cmd=$1A, 0, 0, y=$4, w=$20, h=$D, attr=$8000
    move.l  #$8000, -(a7)
    pea     ($000D).w               ; h = $D
    pea     ($0020).w               ; w = $20
    pea     ($0004).w               ; y = $4
    clr.l   -(a7)                   ; x = 0
    clr.l   -(a7)                   ; 0
    pea     ($001A).w               ; GameCommand $1A = overlay panel
    jsr     (a4)

; DrawBox: confirmation border box at (x=$1, y=$1E, w=$1E, h=$11).
    pea     ($0011).w               ; h = $11
    pea     ($001E).w               ; w = $1E
    pea     ($0001).w               ; y = 1
    pea     ($0001).w               ; x = 1
    jsr DrawBox
    lea     $2c(a7), a7

; --- Phase: Render full player details in confirmation box ---
; Print player number+name at format $03E562 (e.g. "PLAYER N: NAME").
    move.w  (a2), d0                ; d0 = current selection index (0-3)
    ext.l   d0
    addq.l  #$1, d0                 ; 1-based player number
    move.l  d0, -(a7)
    pea     ($0003E562).l           ; format string: player number label
    jsr     (a3)                    ; PrintfNarrow

; Print player's primary description string (from ScenarioDescPtrs[$047630]).
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0                 ; index * 4 (longword stride)
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)       ; arg: name string ptr from ScenarioDescPtrs[index]
    pea     ($0003E55E).l           ; format string: name display format
    jsr     (a3)

; Print player's secondary description string (parallel sub-table at a5+$10 stride).
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)   ; description line 2 ptr
    pea     ($0003E55A).l           ; format string: description line format
    jsr     (a3)

; Set text window for the detail section (columns $10-$1B, rows 1-2).
    pea     ($0010).w               ; w = $10
    pea     ($001B).w               ; h = $1B
    pea     ($0002).w               ; y = 2
    pea     ($0002).w               ; x = 2
    jsr SetTextWindow
    pea     ($0007).w               ; cursor row = 7
    pea     ($0002).w               ; cursor col = 2
    jsr SetTextCursor
    lea     $30(a7), a7

; Print the player's hub city string.
; A separate pointer table at $047650 provides hub-city strings.
; Indexed by (a2) * 4 (longword stride), same as ScenarioDescPtrs.
    move.w  (a2), d0
    lsl.w   #$2, d0                 ; index * 4
    movea.l  #$00047650,a0          ; a0 -> hub city string ptr table ($047650)
    move.l  (a0,d0.w), -(a7)       ; arg: hub city string ptr
    pea     ($0003E556).l           ; format string at $03E556 (e.g. "HUB: %s")
    jsr     (a3)

; Print the player's region or secondary info string (from $047660 table).
    pea     ($000D).w               ; cursor row = $D
    pea     ($0002).w               ; cursor col = 2
    jsr SetTextCursor
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047660,a0          ; a0 -> region/secondary info ptr table ($047660)
    move.l  (a0,d0.w), -(a7)       ; arg: region info string ptr
    pea     ($0003E538).l           ; format string at $03E538
    jsr     (a3)

; Format and display an additional parameter line using sprintf.
; Format at $03E52A (e.g. "BUDGET: %d") with a value from ScenarioStrPtrs ($0475F0).
    pea     ($0003E52A).l           ; format string at $03E52A
    move.l  ($000475F0).l, -(a7)   ; parameter from ScenarioStrPtrs+$14 offset ($0475F0)
    pea     -$80(a6)                ; output buffer: -$80(a6), 128 bytes local
    jsr sprintf                     ; format the numeric parameter into local buffer
    lea     $24(a7), a7

; DisplayMessageWithParams: show the formatted parameter string in the detail box.
    clr.l   -(a7)
    pea     ($0001).w               ; flag = 1 (show in overlay)
    clr.l   -(a7)
    pea     -$80(a6)                ; formatted string buffer
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $14(a7), a7
    tst.w   d0                      ; DisplayMessageWithParams return: 0 = confirmed, nonzero = cancel
    bne.w   .l0aa0e                 ; nonzero -> player confirmed (proceed to return)

; --- Phase: Player cancelled confirmation -- rebuild the list ---
; Clear the confirmation panel, redraw the scenario list, and loop back.
    clr.l   -(a7)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w               ; GameCommand $1A: hide the overlay panel
    jsr     (a4)
    moveq   #$5,d3                  ; reset text row counter to $5 (first player)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    jsr DrawBox                     ; redraw the list border box
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d2                      ; d2 = player iterator (restart from 0)

; Rebuild the player list (same logic as initial render above).
.l0a926:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0                 ; d2 * 4
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)       ; player name string ptr
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0                 ; 1-based player number
    move.l  d0, -(a7)
    pea     ($0003E522).l           ; format string for player list entry (rebuild path uses $E522)
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)   ; description string ptr
    jsr     (a3)
    lea     $20(a7), a7
    addq.w  #$3, d3                 ; advance 3 rows
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a926                 ; loop for all 4 players

; Show the "SELECT PLAYER" prompt again after rebuilding the list.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475DC).l, -(a7)    ; ScenarioStrPtrs[$0475DC] -> "SELECT PLAYER" message
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $14(a7), a7
    bra.w   .l0a6d4                 ; -> back to main selection loop

; ============================================================================
; --- Phase: Non-A button dispatch ---
; ============================================================================
.l0a99c:
; B button ($10): cancel selection, return d2=0 (default first player).
    move.w  d5, d0
    andi.w  #$10, d0                ; bit $10 = B button
    beq.b   .l0a9ba                 ; not B -> check Up/Down

; B: clear input state, load default resources, return index 0.
    clr.w   ($00FF13FC).l           ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l           ; input_init_flag = 0
    clr.w   d2                      ; d2 = 0 (default selection: player 0)
    jsr ResourceLoad                ; load display resources for return
    bra.b   .l0aa10                 ; -> return

; Down button ($02): advance selection to next player (clamp at max 3).
.l0a9ba:
    move.w  d5, d0
    andi.w  #$2, d0                 ; bit $02 = Down D-pad
    beq.b   .l0a9e2                 ; not Down -> check Up

; Down: set input_mode_flag=1, then increment (a2) clamped to 3.
    move.w  #$1, ($00FF13FC).l      ; input_mode_flag = 1 (input accepted)
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0                 ; tentative next = current + 1
    moveq   #$3,d1
    cmp.l   d0, d1
    ble.b   .l0a9de                 ; d0 <= 3 -> clamp to 3 (wrap-around prevention)
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0                 ; new value is in range, use it
    bra.b   .l0a9e0
.l0a9de:
    moveq   #$3,d0                  ; clamp: max player index = 3
.l0a9e0:
    move.w  d0, (a2)                ; update current selection in $FF0002

; Up button ($01): decrement selection (clamp at min 0).
.l0a9e2:
    move.w  d5, d0
    andi.w  #$1, d0                 ; bit $01 = Up D-pad
    beq.b   .l0aa06                 ; not Up -> go flush display and loop

; Up: set input_mode_flag=1, then decrement (a2) clamped to 0.
    move.w  #$1, ($00FF13FC).l      ; input_mode_flag = 1
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0                 ; tentative prev = current - 1
    ble.b   .l0aa02                 ; d0 <= 0 -> clamp to 0
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0                 ; new value is in range, use it
    bra.b   .l0aa04
.l0aa02:
    moveq   #$0,d0                  ; clamp: min player index = 0
.l0aa04:
    move.w  d0, (a2)                ; update current selection in $FF0002

; --- Phase: Display flush after navigation (Up/Down or unhandled input) ---
.l0aa06:
    pea     ($0005).w               ; flush param = 5 (navigation update)
    bra.w   .l0a72a                 ; -> flush display and loop back to .l0a6d4

; ============================================================================
; --- Phase: Epilogue -- return selection index to caller ---
; d2 = selected player/scenario index (0-3), or 1 if B was pressed.
; ============================================================================
.l0aa0e:
    moveq   #$1,d2                  ; confirmed: default return value = 1 (player confirmed)
.l0aa10:
    move.w  d2, d0                  ; d0 = return value
    movem.l -$a0(a6), d2-d5/a2-a5  ; restore registers (from link frame)
    unlk    a6
    rts
