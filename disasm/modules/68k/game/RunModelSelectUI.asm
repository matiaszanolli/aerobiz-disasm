; ============================================================================
; RunModelSelectUI -- Full player hub city selection screen: show map with labels, select via BrowseCharList, confirm via dialog
; 856 bytes | $00B3F4-$00B74B
; ============================================================================
; --- Phase: Setup ---
; Arguments: 8(a6) = player_index (d3), $C(a6) = allowed_selection_mask (d4)
; A3 = pointer to this player's record in player_records ($FF0018, stride $24)
; A4 = local string scratch buffer (84 bytes on frame: -$52 .. 0)
; A5 = GameCommand jump address ($0D64), held for repeated direct calls
RunModelSelectUI:
    link    a6,#-$54
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d3          ; d3 = player_index (0-3)
    move.l  $c(a6), d4          ; d4 = selection bitmask (bit N set = city N already owned)
    lea     -$52(a6), a4        ; a4 -> local text/sprintf scratch buffer
    movea.l  #$00000D64,a5      ; a5 = GameCommand entry (used for direct jsr (a5) calls)
; Compute a pointer to this player's record: $FF0018 + player_index * $24
    move.w  d3, d0
    mulu.w  #$24, d0            ; offset = player_index * 36 (player_record stride)
    movea.l  #$00FF0018,a0      ; base of player_records array
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> player record for this player
; Initialise the cursor working-state words at $FFBD64/$FFBD66 to $80
; $FFBD64 = charlist_ptr (BrowseCharList A2 base); $80 seeds the default scroll position
    move.w  #$80, ($00FFBD64).l
    move.w  #$80, ($00FFBD66).l
; --- Phase: Initial map render ---
; Load display resources and render the world map with player name labels
    jsr ResourceLoad             ; ensure graphics resources are in VRAM
    jsr PreLoopInit              ; one-shot pre-loop initialisation (called 57 times project-wide)
    pea     ($0040).w            ; GameCommand #$40 = clear/reset palette
    clr.l   -(a7)
    pea     ($0010).w            ; GameCommand #$10 = sync/wait
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground         ; clear both scroll planes to background tile
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0004).w
    jsr LoadScreenGfx            ; load city-map screen graphics (index 4, page 1, mode 1)
    pea     ($0007).w
    bsr.w PlacePlayerNameLabels  ; render player name labels over map (mode 7 = all 4 players)
    lea     $20(a7), a7          ; balance pea stack from PlacePlayerNameLabels call
    jsr ResourceUnload           ; release graphics resources after blit
; A2 = pointer to a ROM table of destination-city name string pointers ($475E8)
    movea.l  #$000475E8,a2
; --- Phase: Destination select outer loop ---
; Outer loop: re-entered when player cancels back to map selection
.l0b47a:
; Format the player prompt string: "Player N:" using sprintf into local buffer (a4)
; $3E5D2 = format string address in ROM (e.g. "PLAYER %d")
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0             ; display player number 1-based (player_index + 1)
    move.l  d0, -(a7)
    pea     ($0003E5D2).l       ; ROM format string: player label template
    move.l  (a2), -(a7)         ; first name string pointer from table at $475E8
    move.l  a4, -(a7)           ; output buffer
    jsr sprintf                  ; build formatted string into a4
; Display the formatted player label string on screen (mode = no selection, info only)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
; --- Phase: Destination selection input loop ---
; Call RunDestSelectLoop until the player makes a valid selection (not $FF = cancel)
.l0b4a2:
    jsr (RunDestSelectLoop,PC)   ; run interactive destination picker; returns chosen city index or $FF
    nop
    move.w  d0, -$2(a6)         ; store selected destination (city index) on frame
    cmpi.w  #$ff, d0            ; $FF = user pressed cancel / made no choice
    beq.b   .l0b4a2             ; loop until a real selection is made
; --- Phase: Load destination screen ---
; Player chose a destination city; load the screen and show the relation panel for it
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  -$2(a6), d0         ; selected destination city index
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen               ; load destination city screen (screen_id = dest, player = d3)
    lea     $30(a7), a7
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel             ; show character relationship panel for destination city (mode 3)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w PlacePlayerNameLabels  ; redraw player name labels for new screen context
    jsr ResourceUnload
; Build a second formatted string using a different template ($3E5CC = destination label format)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5CC).l       ; ROM format string: destination/city label template
    move.l  (a2), -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $20(a7), a7
; Display destination label message
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
; GameCommand #$1A: draw a dialog box at (col=$02, row=$13, w=$1C, h=$06, tile=$0000)
; This creates the confirmation/selection panel frame before BrowseCharList
    clr.l   -(a7)
    pea     ($0006).w           ; height = 6 rows
    pea     ($001C).w           ; width  = 28 columns
    pea     ($0013).w           ; top row = 19
    pea     ($0002).w           ; left column = 2
    clr.l   -(a7)
    pea     ($001A).w           ; GameCommand #$1A = DrawBox
    jsr     (a5)
    lea     $30(a7), a7
; --- Phase: Character list selection inner loop ---
; BrowseCharList runs the scrollable city/character list; d2 receives the selection
.l0b550:
    pea     -$2(a6)             ; pass pointer to current selection word (dest city)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    jsr BrowseCharList           ; scrollable list UI; returns selected index in d0 or $FF/$20+ for special
    addq.l  #$8, a7
    move.w  d0, d2              ; d2 = returned selection index
; Entries $20 and above are non-city (alliance/special); route below handles those
    cmpi.w  #$20, d2
    bge.w   .l0b670             ; branch if selection >= $20 (alliance/special row)
; Valid city index: clear sprites first (GameCmd16 #$37, mode 2 = clear char sprite layer)
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16                ; GameCommand #$16 wrapper: clear character portrait sprites
    addq.l  #$8, a7
; Test if this city bit is already set in the selection bitmask (d4):
; d0 = 1 << city_index; if (d0 & d4) != 0 the city is already owned by this player
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1              ; d1 = 1 << city_index
    move.l  d1, d0
    and.l   d4, d0              ; test ownership bitmask
    bne.w   .l0b60c             ; city already owned -- show "already have" message branch
; --- Phase: Unowned city selected -- show confirm dialog ---
; City not yet owned: format and display confirmation prompt
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0      ; ROM table: city name string pointers (word-indexed)
    move.l  (a0,d0.w), -(a7)   ; push city name string pointer
    move.l  ($000475F0).l, -(a7) ; push secondary format arg from ROM pointer table
    move.l  a4, -(a7)           ; output buffer
    jsr sprintf                  ; format: "Do you want to go to <city>?"
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $20(a7), a7
; DisplayMessageWithParams returns selection in d0: 1 = Yes, 0 = No
    cmpi.w  #$1, d0             ; did player confirm?
    beq.b   .l0b5dc             ; yes -- proceed to confirm branch
    move.w  #$ff, d2            ; no -- treat as cancel (d2 = $FF)
; Clear sprites and return to GameCmd16 box draw (cancel path)
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.w   .l0b6c0             ; go redraw the dialog box
; --- Phase: Confirm city selection ---
.l0b5dc:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16                ; clear portrait sprites before showing confirmed screen
; Redraw the dialog box with the "confirmed" layout (same dimensions as before)
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w            ; GameCommand #$1A = DrawBox
    jsr     (a5)
    lea     $24(a7), a7
    bra.w   .l0b6e6              ; jump to exit path (confirmed -- leave inner loop)
; --- Phase: City already owned message ---
.l0b60c:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16                ; clear portrait sprites
; Format "already selected" message using city name and different ROM string ($475FC = "already" template)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0      ; city name pointer table
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475FC).l, -(a7) ; "already owned" format string pointer
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $28(a7), a7
; Redraw dialog box after "already owned" message
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d2             ; mark as cancelled so inner loop continues
    bra.b   .l0b6de
; --- Phase: Alliance/special row handling (d2 >= $20) ---
.l0b670:
    cmpi.w  #$20, d2             ; is it exactly a "special" row but below $FF?
    blt.b   .l0b6de              ; (should not be reached given bge.w above, safety guard)
    cmpi.w  #$ff, d2             ; $FF = explicit cancel from BrowseCharList
    beq.b   .l0b6de              ; treat cancel normally
; Alliance city row: show "alliance" message using ROM format string at $475EC
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16                ; clear sprites
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475EC).l, -(a7) ; "alliance city" format string pointer
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $28(a7), a7
    move.w  #$ff, d2             ; cancel -- user cannot select alliance cities here
; --- Phase: Redraw dialog box and loop ---
.l0b6c0:
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w            ; GameCommand #$1A = redraw selection box
    jsr     (a5)
    lea     $1c(a7), a7
; Loop condition: if d2 == $FF (cancel/no valid pick), stay in inner loop
.l0b6de:
    cmpi.w  #$ff, d2
    bne.w   .l0b550              ; valid selection made -- advance to exit
; --- Phase: Outer cancel (back to map) ---
; d2 still $FF after inner loop exit: check if we should go back to the map-level loop
.l0b6e6:
    cmpi.w  #$ff, d2
    bne.b   .l0b72e              ; non-FF = confirmed selection, skip map redraw
; Cancel confirmed -- restore map view and restart the outer destination-select loop
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0004).w
    jsr LoadScreenGfx            ; reload world map (index 4, no palette, no player page)
    pea     ($0007).w
    bsr.w PlacePlayerNameLabels  ; redraw all name labels on the map
    lea     $20(a7), a7
    jsr ResourceUnload
; --- Phase: Exit (city confirmed) ---
.l0b72e:
    cmpi.w  #$ff, d2
    beq.w   .l0b47a              ; still cancelled -- go back to outer loop (map)
; City d2 confirmed: write hub city index into player record field +$01
; player_record+$01 = hub_city byte (DATA_STRUCTURES.md: player record layout)
    move.b  d2, $1(a3)           ; store selected city as hub_city for this player
    jsr ResourceLoad             ; load resources for next screen
    move.w  d2, d0               ; return selected city index in d0
    movem.l -$70(a6), d2-d4/a2-a5
    unlk    a6
    rts
