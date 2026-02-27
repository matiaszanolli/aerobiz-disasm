; ============================================================================
; RenderGameplayScreen -- Main map interaction loop: handles cursor, tile selection, char comparison, and dialog display
; 1638 bytes | $037162-$0377C7
; ============================================================================
; --- Phase: Setup ---
; Stack frame allocates $B8 (184) bytes of local storage.
; arg $8(a6) = player index (0-3), arg $10(a6) = char code of current player's character
RenderGameplayScreen:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3               ; d3 = char code / character type of current player
    move.l  $8(a6), d5                ; d5 = player index (0-3)
    movea.l  #$00000D64,a5            ; a5 = GameCommand dispatcher (cached for repeated calls)
    move.w  #$1, -$b8(a6)            ; local flag at -$B8(a6) = 1 (first-entry / dirty flag)
    move.w  d5, d0
    mulu.w  #$24, d0                  ; d0 = player_index * $24 (stride into player_records at $FF0018)
    movea.l  #$00FF0018,a0            ; a0 = base of player_records array
    lea     (a0,d0.w), a0             ; a0 = &player_records[player_index]
    movea.l a0, a4                    ; a4 = current player's record (kept for later field accesses)
    move.w  #$ff, d6                  ; d6 = $FF = "no previous tile selected" sentinel
    move.w  #$ff, d4                  ; d4 = $FF = "no current tile selected" sentinel
    movea.l  #$00FFBD64,a2            ; a2 = charlist_ptr ($FFBD64) — BrowseCharList cursor/selection state
; --- Phase: Initial Screen Render ---
; GameCmd $1A = clear tile region. Two calls clear the main screen area
; (col 6, row 19/$13, width 28/$1C, height 6) with different tile patterns.
    pea     ($077E).w                 ; tile value $077E (map background tile)
    pea     ($0006).w                 ; col = 6
    pea     ($001C).w                 ; width = 28
    pea     ($0013).w                 ; row = 19
    pea     ($0002).w                 ; height = 2
    pea     ($0001).w                 ; plane = 1
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w                 ; tile value $077E (same map background tile)
    pea     ($0006).w                 ; col = 6
    pea     ($001C).w                 ; width = 28
    pea     ($0013).w                 ; row = 19
    pea     ($0002).w                 ; height = 2
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle (clears second plane)
    jsr     (a5)
    ; Draw the current player's stat display in the info panel (col $37, row $13)
    pea     ($0037).w                 ; col = $37 (info panel column)
    pea     ($0013).w                 ; row = $13
    clr.l   -(a7)                     ; param = 0
    pea     ($0001).w                 ; mode = 1
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player's char code)
    jsr DrawStatDisplay               ; draw stat bar/panel for the current player character
    lea     $30(a7), a7
    ; Poll for initial input to determine whether button was held on entry
    clr.l   -(a7)                     ; mode = 0 (standard read)
    jsr ReadInput                     ; read joypad — returns 0 if no button pressed
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3720c                   ; no button held — clear the action flag
    moveq   #$1,d2                    ; d2 = 1 = button was held on entry (suppress confirm on first frame)
    bra.b   l_3720e
l_3720c:
    moveq   #$0,d2                    ; d2 = 0 = no button held
l_3720e:
; --- Phase: Main Interaction Loop ---
    clr.w   d7                        ; d7 = accumulated input bits (direction + button flags)
    clr.w   ($00FF13FC).l             ; $FF13FC = input_mode_flag: clear countdown/UI-input mode
    clr.w   ($00FFA7D8).l             ; $FFA7D8 = input_init_flag: clear ProcessInputLoop countdown started flag
; Top of map interaction loop — renders map cursor tile and reads input each iteration
l_3721c:
    ; Place the map cursor tile at the current cursor position (from charlist state in a2)
    ; a2 = $FFBD64 (charlist_ptr): (a2) = cursor X, $2(a2) = cursor Y
    move.l  #$8000, -(a7)             ; tile attr $8000 (high-priority bit set)
    pea     ($0002).w                 ; scale/size param = 2
    pea     ($0002).w                 ; param = 2
    moveq   #$0,d0
    move.w  $2(a2), d0                ; d0 = cursor Y from charlist_ptr+$2
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0                  ; d0 = cursor X from charlist_ptr
    move.l  d0, -(a7)
    clr.l   -(a7)                     ; Z offset = 0
    pea     ($0740).w                 ; tile index $0740 = cursor tile graphic
    jsr TilePlacement                 ; place cursor tile at (X, Y) on screen
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                      ; GameCmd #$E = wait/sync one frame (display update)
    lea     $24(a7), a7
    tst.w   d2
    beq.b   l_37272                   ; d2 = 0 means no held-button suppression needed, proceed
    ; d2 != 0: button was held on entry — wait until it is released before accepting input
    clr.l   -(a7)
    jsr ReadInput                     ; re-read input
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_37272                   ; button released — proceed to normal input handling
    pea     ($0003).w                 ; still held — clear tile and loop back
l_37268:
    pea     ($000E).w
    jsr     (a5)                      ; GameCmd #$E = frame sync while waiting for release
    addq.l  #$8, a7
    bra.b   l_3721c                   ; repeat loop until button released
l_37272:
    clr.w   d2                        ; d2 = 0 (button-suppression cleared now that input is live)
    ; Run the d-pad / button input accumulator — collects direction held + button presses
    move.w  d7, d0                    ; d0 = previous accumulated input state
    move.l  d0, -(a7)
    pea     ($000A).w                 ; mode = $A
    jsr ProcessInputLoop              ; accumulates d-pad input over time, returns button/dir flags
    addq.l  #$8, a7
    andi.w  #$bf, d0                  ; mask out bit 6 (e.g. select button) from input flags
    move.w  d0, d7                    ; d7 = updated accumulated input bits
    tst.w   -$b8(a6)                  ; check local dirty/first-entry flag at -$B8(a6)
    beq.w   l_37480                   ; flag = 0 means no tile selection update needed — skip to button tests
    ; --- Phase: Tile Hit Test and Character Comparison ---
    ; The dirty flag is set: run hit-test to determine which map city tile the cursor is over
    move.w  $e(a6), d0                ; $E(a6) = current character selection index (from stack frame)
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)                 ; a2 = charlist_ptr cursor state
    jsr HitTestMapTile                ; test cursor (X,Y) from a2 against city hit-box table — returns city index or $FF
    addq.l  #$8, a7
    move.w  d0, d4                    ; d4 = hit city index (or $FF if cursor not on any city)
    cmpi.w  #$ff, d0
    beq.w   l_37428                   ; d0 = $FF: cursor not on a city tile — handle as deselect
    cmp.w   d4, d6                    ; compare new tile (d4) with previous tile (d6)
    beq.w   l_3747c                   ; same tile as last frame — no update needed
    ; New city tile selected — redraw both stat panels (current player and target city)
    pea     ($0037).w                 ; col = $37
    pea     ($0013).w                 ; row = $13
    clr.l   -(a7)                     ; param = 0
    pea     ($0001).w                 ; mode = 1
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    jsr DrawStatDisplay               ; redraw current player's stat panel on left side
    pea     ($0039).w                 ; col = $39 (right panel column)
    pea     ($0013).w                 ; row = $13
    pea     ($0001).w                 ; param = 1
    pea     ($0001).w                 ; mode = 1
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (newly-selected city/char index)
    jsr DrawStatDisplay               ; draw target city/char stat panel on right side
    pea     ($0017).w                 ; col = $17
    pea     ($0002).w                 ; row = 2
    jsr SetTextCursor                 ; position text cursor in info area between the two panels
    lea     $30(a7), a7
    ; Compute compatibility between the current player character and the selected city character
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (target city char code)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    jsr CharCodeCompare               ; returns compatibility category index, or 0/$FFFF if incompatible
    addq.l  #$8, a7
    move.w  d0, d6                    ; d6 = compatibility result (0=$FFFF=none, 1-N=compatible category)
    cmpi.w  #$ffff, d6
    beq.b   l_37388                   ; $FFFF = no valid comparison (same char type or unrelated) — show plain info
    tst.w   d6
    beq.b   l_37388                   ; 0 = incompatible — show plain info without relation value
    ; Compatible pair found — render the relation info panel and print scores
    ; First, clear the info window area (col $17, row 2, width $1C, height 2)
    move.l  #$8000, -(a7)             ; tile attr (high priority)
    pea     ($0002).w                 ; height = 2
    pea     ($001C).w                 ; width = 28
    pea     ($0017).w                 ; col = $17
    pea     ($0002).w                 ; row = 2
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle (clear info area)
    jsr     (a5)
    ; Print the compatibility category index (d6) using format string at $44F76
    moveq   #$0,d0
    move.w  d6, d0                    ; d0 = compatibility category (1-N)
    move.l  d0, -(a7)
    pea     ($00044F76).l             ; format string for compatibility label
    jsr PrintfNarrow                  ; display category name in narrow font
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor                 ; reposition cursor to start of info row
    lea     $2c(a7), a7
    ; Compute and print the numeric relation value for this char pair
    pea     ($0003).w                 ; mode = 3 (relation value mode)
    move.w  d4, d0
    move.l  d0, -(a7)                 ; arg = d4 (target city index)
    move.w  d3, d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    jsr CalcRelationValue             ; compute numeric relation score for char pair (d3, d4)
    lea     $c(a7), a7
    move.l  d0, -(a7)                 ; result = relation score
    pea     ($00044F6C).l             ; format string (e.g. "REL: %d")
    jsr PrintfNarrow                  ; display numeric relation value
    addq.l  #$8, a7
    bra.w   l_37424                   ; done with tile-changed update
; --- Phase: Incompatible / Same-Char Info Display ---
; Reached when CharCodeCompare returned 0 or $FFFF (no valid relationship)
l_37388:
    ; Clear the info panel area first (same rectangle as compatible path)
    move.l  #$8000, -(a7)             ; tile attr high priority
    pea     ($0002).w                 ; height = 2
    pea     ($001C).w                 ; width = 28
    pea     ($0017).w                 ; col = $17
    pea     ($0002).w                 ; row = 2
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill (clear info area)
    jsr     (a5)
    lea     $1c(a7), a7
    ; Check if cursor is on the same city tile as the current player (d4 == d3)
    cmp.w   d3, d4
    bne.b   l_373e8                   ; different city — show generic "no relation" message
    ; d4 == d3: cursor is over the current player's own hub city — print player name
    pea     ($0003).w                 ; window depth = 3
    pea     ($001C).w                 ; window width = 28
    pea     ($0017).w                 ; window col = $17
    pea     ($0002).w                 ; window row = 2
    jsr SetTextWindow                 ; define text window for the info area
    ; Look up the player's name string from the pointer table at $5E680
    ; Table at $5E680: 4 longword pointers, one per player, indexed by player_index * 4
    move.w  d3, d0
    lsl.w   #$2, d0                   ; d0 = player_index * 4 (longword pointer stride)
    movea.l  #$0005E680,a0            ; a0 = base of player name pointer table
    movea.l (a0,d0.w), a3            ; a3 = pointer to player name string
    move.l  a3, -(a7)                 ; arg: player name string (×2, format uses it twice)
    move.l  a3, -(a7)
    pea     ($00044F46).l             ; format string: player's own city (e.g. "%s Hub: %s")
    jsr PrintfNarrow                  ; display player name/hub city label
    lea     $1c(a7), a7
    bra.b   l_3740e
l_373e8:
    ; Different city but no valid relation — display a generic info/relation message
    pea     ($0003).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($00044F12).l             ; format string for "no relation" info text
    jsr PrintfNarrow                  ; display the no-relation message
    lea     $14(a7), a7
l_3740e:
    ; After showing city info, reset the text window to full-screen (col 0, row 0, w $20, h $20)
    pea     ($0020).w                 ; height = $20
    pea     ($0020).w                 ; width = $20
    clr.l   -(a7)                     ; col = 0
    clr.l   -(a7)                     ; row = 0
    jsr SetTextWindow                 ; restore default full-screen text window
    lea     $10(a7), a7
l_37424:
    move.w  d4, d6                    ; d6 = d4: remember current tile as "previously displayed"
    bra.b   l_3747c
; --- Phase: Deselect / No City Under Cursor ---
; Cursor moved off all cities (d0 was $FF from HitTestMapTile)
l_37428:
    cmpi.w  #$ff, d6
    beq.b   l_3747c                   ; already no city selected (d6=$FF) — nothing to clear
    ; Clear the info panels that were previously showing a city comparison
    clr.l   -(a7)                     ; tile = 0 (blank)
    pea     ($0006).w                 ; col = 6
    pea     ($001C).w                 ; width = 28
    pea     ($0013).w                 ; row = $13
    pea     ($0002).w                 ; height = 2
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill (blank out old info panel)
    jsr     (a5)
    pea     ($0004).w                 ; param = 4
    pea     ($0037).w                 ; col = $37 (right-side stat panel position)
    jsr GameCmd16                     ; clear the right-hand stat panel tile area
    lea     $24(a7), a7
    move.w  #$ff, d6                  ; d6 = $FF: mark no city currently selected
    ; Redraw current player's stat display (left panel) without a comparison target
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    jsr DrawStatDisplay               ; restore solo stat panel for current player
    lea     $14(a7), a7
l_3747c:
    clr.w   -$b8(a6)                  ; clear dirty/first-entry flag — tile update handled
l_37480:
; --- Phase: Button A / Confirm — Alliance / Char-Pair Action ---
; Bit 5 ($20) of d7 = A button pressed
    move.w  d7, d0
    andi.w  #$20, d0
    beq.w   l_3769c                   ; A button not pressed — check next button
    ; A button pressed: reset input state and begin alliance/interaction sequence
    clr.w   ($00FF13FC).l             ; $FF13FC = input_mode_flag: reset for new interaction
    clr.w   ($00FFA7D8).l             ; $FFA7D8 = input_init_flag: reset countdown flag
    ; Re-place cursor tile at current position to anchor the selection visually
    move.l  #$8000, -(a7)             ; high-priority tile attr
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0                ; cursor Y
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0                  ; cursor X
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w                 ; cursor tile index $0740
    jsr TilePlacement                 ; stamp cursor tile at selection position
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                      ; GameCmd #$E = frame sync
    lea     $24(a7), a7
    cmpi.w  #$ff, d4
    beq.w   l_37694                   ; d4=$FF = no city selected, nothing to confirm — go back
    ; A city IS selected (d4 != $FF) — place a confirm-cursor there
    pea     ($0001).w
    moveq   #$0,d0
    move.w  $2(a2), d0                ; cursor Y
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0                  ; cursor X
    move.l  d0, -(a7)
    jsr PlaceCursor                   ; draw animated selection cursor at the confirmed city
    lea     $c(a7), a7
    ; Check if the player selected their own hub city (d3 == d4)
    cmp.w   d3, d4
    beq.w   l_375f0                   ; same city as self — go to "own city" dialog branch
    ; Different city selected — check if there's already a relation record for this pair
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (target city index)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index)
    jsr FindRelationRecord            ; search $FF9A20 relation entries for (char d3, city d4) pair
    lea     $c(a7), a7
    tst.l   d0
    bne.w   l_375d8                   ; d0 != 0: relation already exists — show existing-relation dialog
    ; No existing relation — check whether the alliance is legally permitted
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (target city)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current char)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index)
    jsr (CheckAlliancePermission,PC)  ; check if this alliance is allowed by rules/game state
    nop
    lea     $c(a7), a7
    tst.w   d0
    beq.w   l_375c2                   ; d0 = 0: permission denied — show refusal dialog
    ; Alliance permitted — compute relation value and compare against player's cash threshold
    pea     ($0003).w                 ; mode = 3
    move.w  d4, d0
    move.l  d0, -(a7)                 ; arg = d4 (target city)
    move.w  d3, d0
    move.l  d0, -(a7)                 ; arg = d3 (current char)
    jsr CalcRelationValue             ; compute the relation/alliance cost value
    lea     $c(a7), a7
    cmp.l   $6(a4), d0                ; compare cost against player record +$6 = cash field
    bgt.b   l_37576                   ; cost > cash: player can't afford — show insufficient funds dialog
    ; Affordable and permitted — proceed with alliance creation
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d4 (target city)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current char)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index)
    jsr MatchCharSlots                ; cross-range char matching — allocate alliance slot
    lea     $c(a7), a7
    bra.w   l_377bc                   ; alliance established — return to caller
; --- Insufficient Funds Dialog ---
l_37576:
    jsr (ClearCharSprites,PC)         ; clear any character portrait sprites before dialog
    nop
    ; Show "insufficient funds" dialog (player cannot afford the alliance cost)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w                 ; dialog mode 2
    move.l  ($00048642).l, -(a7)     ; pointer to dialog text data (cost-too-high message)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index, for name substitution)
    jsr ShowDialog                    ; display "not enough funds" dialog with player name
    ; Format the player name into local string buffer at -$B6(a6) using sprintf
    move.w  d3, d0
    lsl.w   #$2, d0                   ; d0 = player_index * 4
    movea.l  #$0005E680,a0            ; a0 = player name pointer table
    move.l  (a0,d0.w), -(a7)         ; arg = player name string
    move.l  ($000485F6).l, -(a7)     ; arg = format string for cost message
    pea     -$b6(a6)                  ; output buffer in stack frame
    jsr sprintf                       ; format message into local buffer
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    bra.b   l_37622                   ; jump to ShowDialog for the formatted message
; --- Permission Denied Dialog ---
l_375c2:
    jsr (ClearCharSprites,PC)         ; clear character sprites
    nop
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00044EDC).l             ; pointer to "alliance not permitted" message string
    bra.b   l_37626                   ; display refusal dialog
; --- Already Has Relation Dialog ---
l_375d8:
    jsr (ClearCharSprites,PC)         ; clear character sprites
    nop
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w                 ; mode = 2
    move.l  ($00048636).l, -(a7)     ; pointer to "relation already exists" message
    bra.b   l_37626
; --- Own Hub City Dialog ---
; Player confirmed on their own hub city — show a flavor/status message about it
l_375f0:
    jsr (ClearCharSprites,PC)         ; clear character sprites
    nop
    ; Format the player's own name into the local stack buffer
    move.w  d3, d0
    lsl.w   #$2, d0                   ; d0 = player_index * 4
    movea.l  #$0005E680,a0            ; a0 = player name pointer table
    move.l  (a0,d0.w), -(a7)         ; arg = player name string
    move.l  ($0004861A).l, -(a7)     ; format string for "own hub" message
    pea     -$b6(a6)                  ; output buffer in stack frame
    jsr sprintf                       ; format message into local buffer
    lea     $c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
l_37622:
    pea     -$b6(a6)                  ; push formatted local buffer as the message to display
; Common dialog display for all "cannot proceed" paths
l_37626:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index, for portrait/name in dialog)
    jsr ShowDialog                    ; display the dialog with optional input wait
    ; After dialog: restore the map display panels (re-fill both planes with map background tile)
    move.l  #$8000, -(a7)             ; high-priority tile
    pea     ($0006).w                 ; col = 6
    pea     ($001C).w                 ; width = 28
    pea     ($0013).w                 ; row = $13
    pea     ($0002).w                 ; height = 2
    clr.l   -(a7)                     ; plane = 0
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle
    jsr     (a5)
    lea     $30(a7), a7
    ; Restore plane 1 with map tile $077E (the background map fill tile)
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w                 ; plane = 1
    pea     ($001A).w                 ; GameCmd #$1A = fill plane 1
    jsr     (a5)
    lea     $1c(a7), a7
; Redraw current player's stat panel after returning from dialog/confirmation sequence
l_37676:
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d3 (current player char code)
    jsr DrawStatDisplay               ; refresh current player's stat panel
    lea     $14(a7), a7
l_37694:
    pea     ($0002).w
    bra.w   l_37268                   ; loop back to top of map interaction loop
; --- Phase: Button B / Cancel --- (bit 4 = $10 of d7)
l_3769c:
    move.w  d7, d0
    andi.w  #$10, d0
    beq.b   l_376b8                   ; bit 4 not set — not the B button, check next
    ; B button pressed: cancel / return from map interaction
    clr.w   ($00FF13FC).l             ; $FF13FC = input_mode_flag: reset input mode
    clr.w   ($00FFA7D8).l             ; $FFA7D8 = input_init_flag: reset countdown flag
    move.w  #$ff, d4                  ; d4 = $FF: deselect all tiles
    bra.w   l_377bc                   ; return to caller with d4=$FF (no selection)
; --- Phase: Button C / Character Browser --- (bit 7 = $80 of d7)
l_376b8:
    move.w  d7, d0
    andi.w  #$80, d0
    beq.w   l_37796                   ; bit 7 not set — not C button, check d-pad scroll
    ; C button pressed: open the full-screen character browser to select a character
    ; First clear the lower map display area before overlaying the browser
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w                 ; GameCmd #$1A = fill (clear area before browser opens)
    jsr     (a5)
    clr.w   ($00FF13FC).l             ; reset input_mode_flag
    clr.w   ($00FFA7D8).l             ; reset input_init_flag
    move.w  $e(a6), d0                ; $E(a6) = currently selected character index
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = current char index (pre-selects browser cursor)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d5 (player index, filters available chars)
    jsr CharacterBrowser              ; run full-screen character selection UI — returns chosen char index or $FF
    lea     $24(a7), a7
    move.w  d0, -$2(a6)              ; save browser result into local var at -$2(a6)
    cmpi.w  #$ff, -$2(a6)
    beq.b   l_37720                   ; $FF = user cancelled, no change
    move.w  -$2(a6), d0
    cmp.w   $e(a6), d0
    beq.b   l_37720                   ; same character as before — no change to $E(a6)
    move.w  -$2(a6), $e(a6)          ; update $E(a6) with the newly selected character index
l_37720:
    ; Restore screen after character browser: re-fill plane 1 with map background tile
    pea     ($077E).w                 ; tile $077E = map background
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w                 ; plane = 1
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    ; Load and display the character info panel graphics for the newly selected character
    ; GameCmd #$1B = load compressed tile data into VRAM at specified position
    pea     ($0004DD9C).l             ; pointer to character panel tile data in ROM
    pea     ($0009).w                 ; height = 9
    pea     ($001E).w                 ; width = $1E
    pea     ($0012).w                 ; row = $12
    pea     ($0001).w                 ; plane = 1
    clr.l   -(a7)                     ; col = 0
    pea     ($001B).w                 ; GameCmd #$1B = place compressed tile block
    jsr     (a5)
    ; Decompress portrait/stat graphics for the newly selected character into save_buf_base ($FF1804)
    pea     ($0004DFB8).l             ; compressed portrait data address in ROM
    pea     ($00FF1804).l             ; $FF1804 = save_buf_base (decompression staging buffer)
    jsr LZ_Decompress                 ; decompress character portrait graphics to $FF1804
    lea     $24(a7), a7
    ; DMA the decompressed portrait tiles to VRAM at tile index $02E1, count $F tiles
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l             ; source = decompressed tile data
    pea     ($000F).w                 ; tile count = $F
    pea     ($02E1).w                 ; VRAM tile index destination = $02E1
    jsr VRAMBulkLoad                  ; DMA $F tiles from $FF1804 to VRAM tile $02E1
    lea     $14(a7), a7
    bra.w   l_37676                   ; redraw stat panel and loop
; --- Phase: D-Pad Scroll ---
; No button (A/B/C) pressed — treat accumulated d7 as a scroll direction
l_37796:
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)                 ; arg = d7 (d-pad direction bits)
    move.l  a2, -(a7)                 ; arg = a2 (charlist_ptr — cursor X/Y to be updated)
    jsr AdjustScrollPos               ; move the cursor by d-pad, clamp to map bounds; updates (a2)
    addq.l  #$8, a7
    move.w  #$1, ($00FF13FC).l        ; $FF13FC = input_mode_flag: set to 1 (countdown active)
    move.w  #$1, -$b8(a6)            ; set dirty flag so tile hit-test runs next iteration
    pea     ($0001).w
    bra.w   l_37268                   ; loop back to redraw cursor at new position
; --- Phase: Return ---
; All button checks handled — return the selected tile index to caller in d0
l_377bc:
    move.w  d4, d0                    ; d0 = d4 = final selected city index (or $FF if none)
    movem.l -$e0(a6), d2-d7/a2-a5    ; restore callee-saved registers from link frame
    unlk    a6
    rts
