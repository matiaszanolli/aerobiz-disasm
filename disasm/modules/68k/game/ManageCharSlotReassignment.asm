; ============================================================================
; ManageCharSlotReassignment -- Manages the char-reassignment screen for a player: allows selection of a char and shifting its assignment count across slots using directional input, confirming or cancelling with dialog prompts.
; 814 bytes | $028576-$0288A3
; ============================================================================
; --- Phase: Setup and Initial Screen Load ---
ManageCharSlotReassignment:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    ; d3 = player_index (arg1 from $8(a6))
    move.l  $8(a6), d3
    ; a4 = ShowDialog function pointer ($7912) -- called repeatedly for dialog prompts
    movea.l  #$00007912,a4
    ; a5 = ROM data block pointer ($48330): holds 4 longword entries used as dialog text pointers
    ; a5[0] = first dialog string ptr, a5[4..C] = other strings
    movea.l  #$00048330,a5
    ; d5 = redraw flag (1 = needs full screen reload, 0 = use cached screen)
    clr.w   d5
    ; Load resources and show the initial relation/character screen
    jsr ResourceLoad
    ; LoadScreen: set up the main background for the reassignment interface
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    ; ShowRelPanel: draw the character relationship/alliance panel overlay
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
; --- Phase: Main Selection Loop ---
l_285d0:
    ; If d5 == 1: screen needs refresh (after a reassignment was confirmed or cancelled)
    cmpi.w  #$1, d5
    bne.b   l_2861e
    ; Reload graphics and redisplay the current state
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
    ; Clear redraw flag after completing the refresh
    clr.w   d5
l_2861e:
    ; --- Display the Assignment Selection Dialog ---
    ; ShowDialog (a4=$7912): present dialog with first string from a5[0] ($48330)
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048330).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    ; GameCommand #$1A: clear 6-column × 6-row tile area at (col=2, row=$13=19)
    ; This clears the character list area before populating it
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $30(a7), a7
    ; SetTextWindow: define text region (col=0, row=0, width=$20=32, height=$20=32)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; SetTextCursor: position cursor at (col=2, row=$17=23) for char list display
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    ; BrowseCharList: interactive character list browser; returns selected char index or $FF=cancel
    ; $E(a6) = pointer to char list data to browse
    pea     $e(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $20(a7), a7
    ; d4 = selected character index
    move.w  d0, d4
    ; If $FF: user cancelled (Back button) -- exit to return
    cmpi.w  #$ff, d4
    beq.w   l_28896
    ; --- Phase: Lookup Selected Character Data ---
    ; Clear char sprites for this slot (GameCmd16 #$37 = clear, arg=2)
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    ; a3 = tab32_8824 ($FF8824) entry for char d4 (stride-2: d4 * 2)
    ; tab32_8824 stores current/max slot counts for each character
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a2 = city_data ($FFBA80) entry for char d4 and player d3
    ; city_data index: char_d4 * 8 + player_d3 * 2
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; If city_data byte[0] == 0: character has no active slots -- show unavailable dialog
    tst.b   (a2)
    beq.w   l_28886
    ; --- Phase: Compute Available Slot Count ---
    ; d2 = city_data[0] - city_data[1]: how many slots are free for reassignment
    ; city_data[0] = total assigned count, city_data[1] = already used/locked count
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    ; Clamp d2 to max $E (14): RunSlotCountPicker supports at most 14 steps
    cmpi.w  #$e, d2
    bge.b   l_286e8
    move.w  d2, d0
    ext.l   d0
    bra.b   l_286ea
l_286e8:
    ; d2 >= $E: cap the picker range at $E (14 slots max)
    moveq   #$E,d0
l_286ea:
    ; d2 = clamped available slot count (0..$E)
    move.w  d0, d2
    ; If d2 == 0: no movable slots -- show "zero available" dialog and loop back
    tst.w   d2
    ble.w   l_28868
    ; --- Phase: Show Character Info Screen and Slot Count Picker ---
    ; Clear the screen and display the selected character's info panel
    jsr ClearBothPlanes
    ; Tag d4 (char index) with $8000 flag and write to $FFA6B0 so ShowGameScreen
    ; knows which character's portrait and stats to display
    move.w  d4, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    ; ShowGameScreen: render the character detail screen for the reassignment view
    jsr ShowGameScreen
    jsr ResourceUnload
    ; ShowDialog (a4): show the "how many slots to reassign?" prompt (a5[4] = second string)
    ; Args: player_index, string ptr (a5[4]), 0, 0, 1
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a5), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    ; RunSlotCountPicker: interactive dial/spinner for choosing how many slots to shift
    ; Arg: max count = d2 (clamped available slots); returns chosen count in d0
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunSlotCountPicker,PC)
    nop
    lea     $18(a7), a7
    ; d2 = chosen slot count from picker (0 = user cancelled / picked zero)
    move.w  d0, d2
    ; If d2 <= 0: user cancelled the picker -- skip to redraw loop
    ble.w   l_28862
    ; --- Phase: Show Reassignment Confirmation Dialog ---
    ; Build a confirmation string: "PlayerName reassigns N slot(s)" using sprintf
    ; Look up char name pointer from $5E680 (ROM char name table, stride 4): char d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; Choose singular ($41ACE = "slot") vs plural ($41AC8 = "slots") format string
    cmpi.w  #$1, d2
    bne.b   l_28754
    ; d2 == 1: use singular "slot" template
    pea     ($00041ACE).l
    bra.b   l_2875a
l_28754:
    ; d2 > 1: use plural "slots" template
    pea     ($00041AC8).l
l_2875a:
    ; sprintf: format "CharName: N slot(s)" into local buffer at -$50(a6)
    ; Args: buf, format_string(a5[8]), count(d2), singular/plural_word, char_name
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; a5[8] ($48338) = format string template for the reassignment count message
    move.l  $8(a5), -(a7)
    ; -$50(a6) = 80-byte local string buffer (link frame allocates $50 bytes)
    pea     -$50(a6)
    jsr sprintf
    ; ShowDialog (a4): present the formatted confirmation string with a Yes/No prompt
    ; Returns 1 if player confirmed, other if cancelled
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    ; If player did not confirm (d0 != 1): abandon reassignment, redraw and loop
    cmpi.w  #$1, d0
    bne.w   l_28862
    ; --- Phase: Apply Slot Decrements (Reassignment Loop) ---
    ; Player confirmed: set full text window and begin decrement loop
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    ; d5 = total slots decremented (used later for plural/singular in result dialog)
    ; d2 = loop counter; begin loop at bottom (bra to l_28810 = pre-decrement entry)
    move.w  d2, d5
    bra.b   l_28810
    ; --- Loop Body: decrement city_data and tab32_8824 for each confirmed slot ---
l_287a8:
    ; SetTextCursor: position at col=$11=17, row = player_index*4 + $F
    ; Places update text in the player's column of the reassignment display
    pea     ($0011).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    ; Decrement city_data[0] (active assignment count for this char/player)
    subq.b  #$1, (a2)
    ; PrintfNarrow: print updated city_data[0] using format string at $41AC4
    ; Shows the new slot count in the city_data entry column
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC4).l
    jsr PrintfNarrow
    ; Decrement tab32_8824[1] (the char's used-slot counter in the global char table)
    subq.b  #$1, $1(a3)
    ; SetTextCursor: reposition at col=$11=17, row=$01 for the global char count line
    pea     ($0011).w
    pea     ($0001).w
    jsr SetTextCursor
    ; PrintfNarrow: print updated tab32_8824[1] using format string at $41AC0
    ; Shows the new global slot count for this character
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC0).l
    jsr PrintfNarrow
    ; GameCommand #$E: flush/refresh the display after updating the counter text
    pea     ($0005).w
    pea     ($000E).w
    jsr GameCommand
    lea     $28(a7), a7
l_28810:
    ; Decrement loop counter d2; loop back while d2 >= 0 (runs d2 original times)
    subq.w  #$1, d2
    bge.b   l_287a8
    ; --- Phase: Show Reassignment Result Dialog ---
    ; All chosen slots have been decremented; show the summary confirmation dialog
    ; Look up char name pointer for d4 from $5E680 (stride 4)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    ; Choose singular ($41AB6 = "slot was") vs plural ($41AAA = "slots were") for result text
    cmpi.w  #$1, d5
    bne.b   l_28830
    ; d5 == 1: singular result string
    pea     ($00041AB6).l
    bra.b   l_28836
l_28830:
    ; d5 > 1: plural result string
    pea     ($00041AAA).l
l_28836:
    ; sprintf: format "N slot(s) reassigned for CharName" into -$50(a6)
    ; a5[$C] ($4833C) = format string for the result summary message
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $c(a5), -(a7)
    pea     -$50(a6)
    jsr sprintf
    ; ShowDialog (a4): display the formatted result summary to the player
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
l_28862:
    ; --- Return to Main Loop (with screen redraw) ---
    ; Set d5 = 1 to trigger a full screen reload on the next iteration of l_285d0
    moveq   #$1,d5
    bra.w   l_285d0
l_28868:
    ; --- Path: Zero Movable Slots ---
    ; d2 was 0 after clamping: no slots available to reassign
    ; ShowDialog (a4): show "no slots available" message (a5[$14] = fifth string ptr)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $14(a5), -(a7)
l_28876:
    ; Common ShowDialog call tail shared by l_28868 and l_28886
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    ; Return to main selection loop (no screen redraw needed -- d5 unchanged)
    bra.w   l_285d0
l_28886:
    ; --- Path: Character Has No Active Slots at All ---
    ; city_data[0] == 0: this character is not currently assigned anywhere
    ; ShowDialog (a4): show "character unavailable" message (a5[$10] = fourth string ptr)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $10(a5), -(a7)
    ; Fall through to shared ShowDialog call at l_28876
    bra.b   l_28876
l_28896:
    ; --- Phase: Return ---
    ; User pressed Back at the char selection list -- exit the reassignment screen
    ; Return value in d0: $e(a6) = arg2 (used by caller to know which screen to restore)
    move.w  $e(a6), d0
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts
