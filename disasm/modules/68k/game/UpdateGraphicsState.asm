; ============================================================================
; UpdateGraphicsState -- Manages the player-select screen: cycles the active player display (mod 4), calls LoadScreen, ShowRelPanel, and RunMainMenu each iteration, polls for input (D-pad to browse chars via CharacterBrowser, Enter to select, Back to exit), updates the relation text window, and stores the final selection in $FF9A1C before returning.
; 648 bytes | $01CE3E-$01D0C5
; ============================================================================
; --- Phase: Setup ---
; Stack args: param at +$1C (player index / initial selection), param at +$20 (screen_id or context)
; d2 = current display player index (cycles mod 4)
; d3 = current char selection index
; d4 = poll result / input bits (loop state)
; d5 = candidate selection returned by CharacterBrowser / NopStub
; d6 = original initial player index (saved for "no-change" restore path)
; a2 = cached pointer to GameCommand ($000D64)
UpdateGraphicsState:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d3                        ; d3 = initial char selection index (stack arg +$20 after push)
    move.l  $1c(a7), d6                        ; d6 = initial player index (stack arg +$1C); saved for exit comparison
    movea.l  #$00000D64,a2                     ; a2 = GameCommand ($000D64), cached for in-loop calls
    move.w  d6, d2                             ; d2 = current display player (starts equal to initial)
    move.w  #$80, d4                           ; d4 = seed input bits with bit 7 set to force first loop body entry

; --- Phase: Main Display / Input Loop ---
; Each iteration: advance player index mod 4, render screen + relation panel + menu, poll input.
; Bit 7 of d4 ($80): "screen needs refresh" sentinel; real joypad bits use $10/$20/$90.
l_1ce56:
    move.w  d4, d0
    andi.w  #$80, d0                           ; test bit 7: synthetic "refresh" flag (set on first entry and after char select)
    beq.w   l_1cf0a                            ; if clear, skip the screen-render block and go straight to input poll

    ; Advance current display player index: d2 = (d2 + 1) mod 4
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0                            ; increment player index
    moveq   #$4,d1
    jsr SignedMod                              ; d0 = (d2+1) mod 4 -- wraps player display 0-3
    move.w  d0, d2                             ; d2 = new current display player

    ; Call LoadScreen(player_index=d2, screen_id=d3, mode=1)
    pea     ($0001).w                          ; arg: mode = 1 (load)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: screen_id / char selection
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player_index = d2
    jsr LoadScreen                             ; load the screen for this player

    ; Call ShowRelPanel(player_index=d2, screen_id=d3, mode=2) -- displays relationship/affinity panel
    pea     ($0002).w                          ; arg: mode = 2
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: screen_id / char selection
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player_index = d2
    jsr ShowRelPanel                           ; render relation/affinity panel for player

    ; Call RunMainMenu(player_index=d2) -- renders the per-player main menu
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player_index
    bsr.w RunMainMenu
    lea     $1c(a7), a7                        ; clean up 7 pushed longs (LoadScreen×3 + ShowRelPanel×3 + RunMainMenu×1 = $1C)

    ; --- Relation text window display ---
    ; Check $FF0130[d2*$20 + d3*4] -- relation record table indexed by (player, char)
    ; If nonzero, show the relation name in the text window
    move.w  d2, d0
    lsl.w   #$5, d0                            ; d0 = d2 * 32 (player stride in $FF0130)
    move.w  d3, d1
    lsl.w   #$2, d1                            ; d1 = d3 * 4  (char stride)
    add.w   d1, d0                             ; d0 = player*32 + char*4 = slot offset
    movea.l  #$00FF0130,a0                     ; $FF0130 = unknown block (PackSaveState, possibly relation map)
    tst.l   (a0,d0.w)                          ; is there a relation entry at this slot?
    beq.b   l_1cf0a                            ; if zero, no relation to display -- skip to input

    ; Set up text window (full width, near top) and cursor, then print relation name
    pea     ($0020).w                          ; arg: width  = $20 (32 tiles, full width)
    pea     ($0020).w                          ; arg: height = $20
    clr.l   -(a7)                              ; arg: top = 0
    clr.l   -(a7)                              ; arg: left = 0
    jsr SetTextWindow                          ; define text rendering area

    pea     ($0015).w                          ; cursor Y = $15 (row 21)
    pea     ($000E).w                          ; cursor X = $0E (col 14)
    jsr SetTextCursor                          ; position text cursor for relation label

    ; Compute index into $FF0270 relation-name lookup: d2*8 + d3
    move.w  d2, d0
    lsl.w   #$3, d0                            ; d0 = d2 * 8
    add.w   d3, d0                             ; d0 = player*8 + char
    movea.l  #$00FF0270,a0                     ; $FF0270 = unknown block (likely relation name indices)
    move.b  (a0,d0.w), d0                      ; d0.b = relation name index byte
    andi.l  #$ff, d0                           ; zero-extend byte
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: relation name index
    pea     ($00041180).l                       ; arg: format string pointer (ROM text table)
    jsr PrintfWide                             ; display wide-font relation name
    lea     $20(a7), a7                        ; clean up: SetTextWindow×4 + SetTextCursor×2 + PrintfWide×2 = 8 longs = $20

; --- Phase: Input Poll ---
; Poll joypad; repeat until a recognised button is pressed.
; d4 bits: $10 = Enter/A (confirm), $20 = D-pad left/right (navigate), $80 = refresh flag (synthetic)
l_1cf0a:
    ; GameCommand(#$E, #$4) = command $0E with arg $4 -- likely a frame-wait / display update
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)                               ; GameCommand #$0E arg $4: display update / wait-for-VBlank
    addq.l  #$8, a7
l_1cf16:
    clr.l   -(a7)                              ; arg: flags = 0
    pea     ($0003).w                          ; arg: mode = 3
    jsr PollAction                             ; flush then wait: returns joypad state in d0
    addq.l  #$8, a7
    move.w  d0, d4                             ; save full button result
    andi.l  #$90, d0                           ; test bits $80 (refresh) | $10 (Enter/A confirm)
    beq.b   l_1cf16                            ; neither pressed -- keep polling

    ; A button pressed ($10) or D-pad ($80 from scroll)?
    move.w  d4, d0
    andi.w  #$10, d0                           ; test bit 4 = Enter/A (confirm selection)
    bne.w   l_1d05c                            ; Enter pressed: handle selection commit

    move.w  d4, d0
    andi.w  #$20, d0                           ; test bit 5 = B/Back or D-pad lateral nav
    beq.w   l_1ce56                            ; not pressed: loop back for next player cycle

    ; --- Phase: Character Browser ---
    ; D-pad lateral: open CharacterBrowser to let user browse chars for this player
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_1cf98                            ; if still clear, fall to NopStub path (should not reach here)

    ; GameCommand(#$1A, $0001, 0, $15, $8, $6, 0) = clear/set up tile area for browser panel
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)                               ; GameCommand #$1A: clear tile area (x=$01,y=$15,w=$8,h=$6)

    ; CharacterBrowser(player_index=d2, screen_id=d3) -- full-screen char selection UI
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: screen_id
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player_index
    jsr CharacterBrowser                       ; returns selected char index in d0 ($FF = cancelled)
    lea     $24(a7), a7                        ; clean up: GameCmd×7 + CharBrowser×2 = 9 longs = $24
    move.w  d0, d5                             ; d5 = browser result (char index or $FF)

    ; GameCommand(#$1A, $0001, 0, $12, $20, 0, 0) = restore/clear browser panel area
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)                               ; GameCommand #$1A: clear tile area for browser panel restore
    lea     $1c(a7), a7
    bra.b   l_1cfb6                            ; evaluate the browser result

l_1cf98:
    ; NopStub path: called when bit $20 was NOT set (edge case; NopStub always returns 0 in d0)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: input bits
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: char index
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player index
    jsr NopStub                                ; no-op stub -- returns 0 in d0
    lea     $c(a7), a7
    move.w  d0, d5                             ; d5 = 0 (no-op result)

; --- Phase: Selection Validation ---
l_1cfb6:
    cmpi.w  #$ff, d5                           ; d5 == $FF means browser was cancelled
    beq.w   l_1d046                            ; cancelled -- keep old selection, re-render loop
    cmp.w   d3, d5                             ; d5 == d3 means same char selected again
    beq.w   l_1d046                            ; no change -- skip update

    move.w  d5, d3                             ; d3 = new char selection index

    ; Check relation record again for new selection
    move.w  d2, d0
    lsl.w   #$5, d0                            ; player stride * $20
    move.w  d3, d1
    lsl.w   #$2, d1                            ; char stride * 4
    add.w   d1, d0
    movea.l  #$00FF0130,a0                     ; relation map base
    tst.l   (a0,d0.w)                          ; is there a relation entry for new selection?
    beq.b   l_1d028                            ; no relation: go to plain tile-display path

    ; Relation exists: update relation text window with new char's relation label
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($000E).w
    jsr SetTextCursor

    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0                      ; relation name index for new (player, char) pair
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041172).l                       ; format string (ROM): relation label variant
    jsr PrintfWide                             ; print updated relation name
    lea     $20(a7), a7
    bra.b   l_1d046                            ; proceed to re-render loop

l_1d028:
    ; No relation for new selection: use GameCommand #$1A to place plain tile block
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0006).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)                               ; GameCommand #$1A: write tile block at (x=$0E,y=$15,w=$6,h=$2)
    lea     $1c(a7), a7

l_1d046:
    ; Re-render: call RenderDisplayBuffer(player_index=d2, char_index=d3) then loop
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: char index
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                          ; arg: player index
    bsr.w RenderDisplayBuffer                  ; refresh display buffer for current player/char combo
    addq.l  #$8, a7
    bra.w   l_1ce56                            ; restart main display loop (d4 still has old bits; bit $80 test)

; --- Phase: Confirm Selection (Enter pressed) ---
l_1d05c:
    ; Enter was pressed: if d2 == d6 (current player == original player), no screen reload needed
    cmp.w   d2, d6                             ; compare current player with original player
    beq.b   l_1d09c                            ; same player: skip LoadScreen/ShowRelPanel/RunMainMenu

    ; Different player: restore original player's screen (undo cycled display)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen                             ; reload screen for original player d6

    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel                           ; restore relation panel for original player

    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu                          ; restore main menu for original player
    lea     $1c(a7), a7
    bra.b   l_1d0ba                            ; commit and exit

l_1d09c:
    ; Same player selected: just clear the panel tile area (no need to reload screen)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)                               ; GameCommand #$1A: clear panel tile rect
    lea     $1c(a7), a7

; --- Phase: Commit and Return ---
l_1d0ba:
    move.w  d3, ($00FF9A1C).l                  ; screen_id ($FF9A1C) = final selected char index
                                               ; $FF9A1C = screen_id: current screen/scenario index
    movem.l (a7)+, d2-d6/a2
    rts
