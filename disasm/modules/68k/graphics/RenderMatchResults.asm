; ============================================================================
; RenderMatchResults -- Shows match result screen with compatible char list; handles char selection and pairing input
; 1350 bytes | $037FFE-$038543
; ============================================================================
; --- Phase: Frame Setup and Screen Clear ---
; Stack frame: -$2(a6) = max_compatible_index, -$22(a6) to -$28(a6) = compatible char list (words).
; d5 = player index, a3 = char pair record pointer (byte[0]=char A code, byte[1]=char B code).
; a4 = GameCommand dispatcher ($000D64), a5 = $FF13FC (input_mode_flag).
RenderMatchResults:
    link    a6,#-$28              ; allocate 40 bytes of local frame storage
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5            ; d5 = player index (first argument)
    movea.l $c(a6), a3            ; a3 -> char pair record: byte[0]=charA code, byte[1]=charB code
    movea.l  #$00000D64,a4        ; a4 = GameCommand entry point (central dispatcher)
    movea.l  #$00FF13FC,a5        ; a5 = $FF13FC = input_mode_flag (nonzero = UI/countdown active)
    move.w  #$2, -$2(a6)         ; -$2(a6) = 2 (initial panel slot / column index)
; Clear the top banner area (5-tile-high block at row $0D, col $20, 32 wide) via GameCommand #$1A
    clr.l   -(a7)
    pea     ($0005).w             ; height = 5 tiles
    pea     ($0020).w             ; width = 32 tiles
    pea     ($000D).w             ; row = 13
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a4)                  ; clear the top panel region
    lea     $1c(a7), a7           ; clean up 7 args (7 * 4 = $1C bytes)
; Clear the right-side info panel area (1-tile high at row $01, col $20, 32 wide)
    clr.l   -(a7)
    pea     ($0012).w             ; height = $12 = 18 tiles
    pea     ($0020).w             ; width = 32 tiles
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w             ; row = 1
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a4)                  ; clear the side panel region
    lea     $1c(a7), a7
; --- Phase: Scan event_records for Compatible Characters ---
; $FFB9E8 = event_records: 4 players x $20 (32) bytes. Each player's block contains
; up to 16 character slots (stride 2). Here we scan the current player's 16-slot block,
; checking each occupied slot for compatibility with the char pair (a3).
; Compatible chars are collected into a local list at -$22(a6) (up to 16 entries).
    move.w  d5, d0
    lsl.w   #$5, d0               ; d0 = player_index * 32 (stride into event_records)
    movea.l  #$00FFB9E8,a0        ; a0 -> event_records base ($FFB9E8)
    lea     (a0,d0.w), a0         ; a0 -> this player's event_record block
    movea.l a0, a2                ; a2 = scanning pointer (advances by 2 per slot)
    clr.w   d4                    ; d4 = count of compatible characters found so far
    clr.w   d2                    ; d2 = slot index (0-15)
l_3806c:
    tst.b   (a2)                  ; is this slot empty (byte = 0)?
    beq.b   l_380a2               ; yes: skip to next slot
; Call CheckCharCompat(slot_index, charA_code, charB_code) to test compatibility
    moveq   #$0,d0
    move.b  $1(a3), d0            ; d0 = charB code (byte[1] of pair record)
    ext.l   d0
    move.l  d0, -(a7)             ; push charB code
    moveq   #$0,d0
    move.b  (a3), d0              ; d0 = charA code (byte[0] of pair record)
    ext.l   d0
    move.l  d0, -(a7)             ; push charA code
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)             ; push slot index
    jsr CheckCharCompat           ; returns d0=1 if compatible, else 0 or 2
    lea     $c(a7), a7            ; pop 3 args
    moveq   #$1,d1
    cmp.l   d0, d1                ; was result exactly 1 (compatible)?
    bne.b   l_380a2               ; no: not compatible, skip
; Compatible: add this slot index to the local compatible-char list
    move.w  d4, d0
    add.w   d0, d0                ; d0 = d4 * 2 (word offset into list)
    move.w  d2, -$22(a6, d0.w)   ; -$22(a6)[d4] = slot index of compatible char
    addq.w  #$1, d4               ; increment compatible-char count
l_380a2:
    addq.l  #$2, a2               ; advance to next event_record slot (stride 2)
    addq.w  #$1, d2               ; increment slot index
    cmpi.w  #$10, d2              ; checked all 16 slots?
    blt.b   l_3806c               ; no: continue scanning
; Did we find any compatible chars?
    tst.w   d4
    ble.b   l_380bc               ; no compatible chars: show "no partner" dialog and return -1
    move.w  d4, d0
    addi.w  #$ffff, d0            ; -$26(a6) = max index = count - 1 (last valid list index)
    move.w  d0, -$26(a6)          ; store last-valid-index for cursor clamping
    bra.b   l_380e4               ; continue to show the match-results dialog
; --- No Compatible Characters: Show Error Dialog and Return ---
l_380bc:
; Push ShowDialog args: player_index, dialog_text_ptr, mode=2, 0, confirm=1
    pea     ($0001).w             ; wait for confirm button
    clr.l   -(a7)
    pea     ($0002).w             ; dialog mode 2 (error/no-options style)
    move.l  ($0004863A).l, -(a7) ; pointer to "no compatible partner" dialog text string
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowDialog                ; display "no compatible character found" message
    lea     $14(a7), a7
    move.w  #$ff, d0             ; return value $FF = no selection / cancelled
    bra.w   l_3853a              ; jump to epilog (restore regs, unlk, rts)
; --- Phase: Initial Panel Display ---
; Show the match-results dialog box and check if any match slots are already filled.
; If slots are taken, display a "slots full" warning via PrintfNarrow.
l_380e4:
; Show the main match-results dialog (compatible chars exist)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7) ; pointer to "select partner" dialog text string
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowDialog                ; display the match-results selection dialog
; Check if any match slots are currently full for this player
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr (CheckMatchSlots,PC)      ; scan $FF8804 for a non-$FF slot; returns d0=1 if any slot taken
    nop
    lea     $18(a7), a7           ; pop 6 args total (dialog + CheckMatchSlots)
    cmpi.w  #$1, d0              ; was a match slot already filled?
    bne.b   l_38120              ; no: skip the warning
; Print "match slot occupied" warning message in narrow font
    move.l  ($00048612).l, -(a7) ; pointer to "slot is full" narrow-font warning string
    jsr PrintfNarrow              ; print warning at current cursor position
    addq.l  #$4, a7
; --- Phase: Render Character Detail Panel and Stat Comparison ---
; Draw the char detail panel (portrait + info) for the current cursor selection,
; then print compatibility stats and names for both chars in the pair.
l_38120:
; Draw the character detail panel at panel slot -$2(a6) for the current player
    pea     ($0003).w             ; panel width/type argument
    move.w  -$2(a6), d0          ; -$2(a6) = current detail-panel slot index (starts at 2)
    ext.l   d0
    move.l  d0, -(a7)            ; panel slot index
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr DrawCharDetailPanel       ; render char portrait + stats into the detail panel area
; Set up text window for the main info region (full-screen, 32x32 cells)
    pea     ($0020).w             ; width = 32 cells
    pea     ($0020).w             ; height = 32 cells
    clr.l   -(a7)                 ; left = 0
    clr.l   -(a7)                 ; top = 0
    jsr SetTextWindow             ; configure the text rendering viewport
; Print charA's name at text cursor (1,1)
    pea     ($0001).w             ; cursor Y = 1
    pea     ($0001).w             ; cursor X = 1
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a3), d0             ; d0 = charA code (byte[0] of pair record)
    lsl.w   #$2, d0              ; * 4 (each entry in name-pointer table is a long)
    movea.l  #$0005E7E4,a0       ; a0 -> char name string pointer table
    move.l  (a0,d0.w), -(a7)    ; push charA name string pointer
    pea     ($00044FB2).l        ; push format string "%s" for name display
    jsr PrintfWide                ; print charA's name in wide font
    lea     $2c(a7), a7          ; pop all SetTextWindow + SetTextCursor + PrintfWide args
; Place UI icon pairs (heart / compatibility markers) on the panel
    pea     ($0001).w             ; icon palette / set index
    pea     ($000C).w             ; tile position argument (col $C)
    clr.l   -(a7)
    jsr PlaceIconPair             ; place left heart/icon at column $C row 1
    pea     ($0001).w
    pea     ($0013).w             ; tile position argument (col $13)
    pea     ($0001).w
    jsr PlaceIconPair             ; place right heart/icon at column $13 row 1
    pea     ($0001).w
    pea     ($0012).w             ; tile column $12
    pea     ($0002).w             ; tile width 2
    pea     ($0002).w             ; tile height 2
    jsr PlaceIconTiles            ; place 2x2 icon block at ($12,$01)
; Print compatibility score at cursor (1, $D)
    pea     ($0001).w             ; cursor X = 1
    pea     ($000D).w             ; cursor Y = $D = 13
    jsr SetTextCursor
    lea     $30(a7), a7           ; pop accumulated PlaceIcon + SetTextCursor args
; Call CharCodeCompare(charA_code, charB_code) to get compatibility score (0-100%)
    moveq   #$0,d0
    move.b  $1(a3), d0           ; charB code
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0             ; charA code
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare           ; d0 = compatibility index (0-6 per category, packed)
    addq.l  #$8, a7
    andi.l  #$ffff, d0           ; zero-extend result word
    move.l  d0, -(a7)            ; push compat score for format string
    pea     ($00044FAE).l        ; push format string for compatibility percentage display
    jsr PrintfWide                ; print compatibility score (e.g. "74%")
; Print charB's name at cursor (1, $14)
    pea     ($0001).w             ; cursor X = 1
    pea     ($0014).w             ; cursor Y = $14 = 20
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0           ; d0 = charB code (byte[1] of pair record)
    lsl.w   #$2, d0              ; * 4 (long pointer offset)
    movea.l  #$0005E7E4,a0       ; a0 -> char name string pointer table
    move.l  (a0,d0.w), -(a7)    ; push charB name string pointer
    pea     ($00044FAA).l        ; push format string "%s" for name display
    jsr PrintfWide                ; print charB's name in wide font
; Determine single-choice mode: if max_compatible_index == 0, only one char is available
    tst.w   -$26(a6)             ; is max index == 0? (only 1 compatible char)
    bne.b   l_3822a              ; no: multiple options, allow scrolling
    move.w  #$1, -$28(a6)       ; -$28(a6) = 1 = single-choice mode (auto-confirm on B)
    bra.b   l_3822e
l_3822a:
    clr.w   -$28(a6)            ; -$28(a6) = 0 = multi-choice mode (cursor navigation enabled)
l_3822e:
; --- Phase: Input State Init ---
; Sample initial joypad state to seed the "was a button held at entry?" flag.
; d7 = 1 if a button was already held when we entered (skip first input cycle).
    clr.l   -(a7)
    jsr ReadInput                 ; read joypad (GameCommand #$0A); d0 = current button state
    lea     $1c(a7), a7           ; pop arg (7 words = $1C)
    tst.w   d0                   ; any button held?
    beq.b   l_38242
    moveq   #$1,d7               ; d7 = 1 = button was held at entry, skip first poll
    bra.b   l_38244
l_38242:
    moveq   #$0,d7               ; d7 = 0 = no button held, process input normally
l_38244:
; Initialize input/animation loop state variables
    clr.w   -$24(a6)             ; -$24(a6) = last_input = 0 (no button pressed yet)
    clr.w   (a5)                  ; $FF13FC = input_mode_flag = 0 (reset input countdown mode)
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0 (ProcessInputLoop: reset countdown)
    moveq   #$1,d6               ; d6 = 1 = redraw_needed flag (force initial stats redraw)
    clr.w   d2                   ; d2 = selection result (0 = pending, $FF = cancelled, 1 = confirmed)
    clr.w   d4                   ; d4 = current cursor position in compatible-char list
    clr.w   d3                   ; d3 = animation frame counter (blink/cycle counter)
    bra.w   l_38532              ; jump to loop-entry check (tests d2 == $FF to exit)
; --- Phase: Main Input/Animation Loop ---
; This is the per-frame body. d3 counts animation frames (0-29, then resets).
; Every 30 frames (d3==0 or d3==$1E): redraw/blink the selection cursor sprite.
; Every 15 frames (d3==$0F): flip the sprite to show blink effect.
; Input is polled each iteration to handle d-pad cursor movement and button presses.
l_3825c:
    addq.w  #$1, d3              ; increment animation frame counter
    cmpi.w  #$1, d3              ; is this the first frame of a new 30-frame cycle?
    bne.b   l_382cc              ; no: skip cursor redraw
; Frame 1 of cycle: place the "cursor top" and "cursor bottom" tiles to show current selection
    move.l  #$8000, -(a7)        ; priority flag = $8000 (high priority tile)
    pea     ($0001).w             ; palette
    pea     ($0001).w             ; flip flags
    pea     ($0040).w             ; tile count = $40 = 64
    pea     ($0008).w             ; Y pixel position = 8
    pea     ($0039).w             ; X pixel position = $39 = 57
    pea     ($0772).w             ; tile index $0772 = cursor-top sprite tile
    jsr TilePlacement             ; place the top half of the selection cursor sprite
    pea     ($0001).w             ; GameCommand #$0E = wait-for-frame / sync
    pea     ($000E).w
    jsr     (a4)                  ; wait one frame
    lea     $24(a7), a7           ; pop TilePlacement args (9 args * 4 = $24... actually 7 = $1C, then +$8 for GameCmd)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0040).w
    pea     ($00F0).w             ; Y pixel position = $F0 = 240 (bottom half of cursor)
    pea     ($003A).w             ; X pixel position = $3A = 58
    pea     ($0773).w             ; tile index $0773 = cursor-bottom sprite tile
    jsr TilePlacement             ; place the bottom half of the selection cursor sprite
    lea     $1c(a7), a7           ; pop 7 args = $1C
l_382be:
    pea     ($0001).w             ; GameCommand #$0E = frame sync / wait
    pea     ($000E).w
    jsr     (a4)                  ; wait one frame for display sync
    addq.l  #$8, a7
    bra.b   l_382ec               ; go to input processing
l_382cc:
    cmpi.w  #$f, d3              ; is this frame 15 (mid-cycle blink off)?
    bne.b   l_382e4
; Frame 15: clear cursor sprite to create blink effect (hide for second half of cycle)
    pea     ($0002).w             ; arg: clear mode
    pea     ($0039).w             ; sprite slot $39 = 57
    jsr GameCmd16                 ; GameCommand #$10 with args: clear sprite at slot $39
    addq.l  #$8, a7
    bra.b   l_382be               ; wait one frame then continue
l_382e4:
    cmpi.w  #$1e, d3             ; is this frame 30 ($1E = end of cycle)?
    bne.b   l_382ec
    clr.w   d3                   ; reset frame counter to 0 for next 30-frame blink cycle
; --- Phase: Redraw Character Stats Panel (if dirty) ---
; d6 = redraw_needed flag. Set to 1 whenever the cursor moves.
; ShowCharStats renders the stat bar for the currently highlighted compatible char.
l_382ec:
    cmpi.w  #$1, d6              ; is a redraw needed?
    bne.b   l_38320              ; no: skip stat panel redraw
; Redraw: ShowCharStats(player_index, char_slot, panel_column)
    pea     ($0002).w             ; panel column = 2
    pea     ($0003).w             ; panel row = 3
    move.w  -$2(a6), d0         ; -$2(a6) = current detail panel slot
    ext.l   d0
    move.l  d0, -(a7)            ; panel slot index
    move.w  d4, d0               ; d4 = current cursor position in compatible list
    add.w   d0, d0               ; * 2 (word offset)
    move.w  -$22(a6, d0.w), d0  ; load char slot index from compatible list at cursor d4
    ext.l   d0
    move.l  d0, -(a7)            ; char slot index
    move.w  d5, d0               ; d5 = player index
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowCharStats             ; render character stat bars for the highlighted char
    lea     $14(a7), a7           ; pop 5 args = $14
    clr.w   d6                   ; clear redraw flag (panel is now up to date)
; --- Phase: Check Selected Character Still Present in event_records ---
; The char at the current cursor position must still have a valid entry in
; the player's event_records block ($FFB9E9). If it has been removed, call
; GameLoopExit to clean up and break out of the interaction loop.
l_38320:
    move.w  d5, d0
    lsl.w   #$5, d0              ; d0 = player_index * 32 (event_record stride)
    move.w  d4, d1
    add.w   d1, d1               ; d1 = cursor * 2 (word offset into compatible list)
    move.w  -$22(a6, d1.w), d1  ; d1 = char slot index for current cursor position
    add.w   d1, d1               ; * 2 (stride within event_record, stride-2 layout)
    add.w   d1, d0               ; d0 = player_offset + slot_offset
    movea.l  #$00FFB9E9,a0       ; a0 -> $FFB9E9 (event_records base + 1, odd byte = char presence byte)
    tst.b   (a0,d0.w)            ; is this character still present in the event record?
    bne.b   l_38354              ; yes: char is still valid, continue to input polling
; Character is gone (slot cleared externally): gracefully exit the interaction
    pea     ($0001).w
    pea     ($000A).w            ; GameCommand #$0A arg (frame delay count?)
    pea     ($001D).w            ; mode $1D
    clr.l   -(a7)
    jsr (GameLoopExit,PC)        ; clean up sprites/UI and signal loop exit
    nop
    lea     $10(a7), a7
; --- Phase: Input Polling and Button Dispatch ---
; If d7=1 (button was held at entry), drain one input read before processing.
; ProcessInputLoop returns a debounced button mask; we dispatch on each recognized button.
; Button mask layout (after AND $BC): $20=A, $10=B, $08=down, $04=up, $02=right, $01=left, $80=C.
l_38354:
    tst.w   d7                   ; was a button held when we entered this loop iteration?
    beq.b   l_38368              ; no: go straight to ProcessInputLoop
; Drain the held-button state: poll and discard one input, but exit if still held
    clr.l   -(a7)
    jsr ReadInput                 ; read current raw joypad state
    addq.l  #$4, a7
    tst.w   d0                   ; is any button still held?
    bne.w   l_38526              ; yes: continue draining (jump to frame-end without acting)
l_38368:
    clr.w   d7                   ; clear the "button held at entry" flag
; Poll debounced input via ProcessInputLoop (handles auto-repeat timing)
    move.w  -$24(a6), d0        ; -$24(a6) = last_input state (used for auto-repeat)
    move.l  d0, -(a7)
    pea     ($000A).w            ; repeat threshold = $0A = 10 frames
    jsr ProcessInputLoop          ; returns d0 = new debounced button bits
    addq.l  #$8, a7
    andi.w  #$bc, d0             ; mask to: A($20), B($10), up($04), down($08), C($80) -- ignore L/R/start
    move.w  d0, -$24(a6)        ; save button state for next frame auto-repeat
    ext.l   d0
; Dispatch on button pressed
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_383b0              ; A button: confirm selection (pair the chars)
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_38448              ; B button: cancel / go back (return $FF)
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_38456              ; up: move cursor up in compatible-char list
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_3846c              ; down: move cursor down in compatible-char list
    cmpi.w  #$80, d0
    beq.w   l_38482              ; C button: browse partner (open BrowsePartners UI)
    bra.w   l_38514              ; no recognized button: clear highlight and loop
; --- A Button: Confirm Char Pairing ---
; A-press: verify the selected char is still valid, then commit the pairing.
; SetHighNibble records the chosen char into the pair record, then return result 1.
l_383b0:
    clr.w   (a5)                  ; $FF13FC = input_mode_flag = 0 (end input countdown)
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0 (reset auto-repeat state)
; Recompute presence check for current cursor (same as l_38320)
    move.w  d5, d0
    lsl.w   #$5, d0              ; player_index * 32
    move.w  d4, d1
    add.w   d1, d1               ; cursor * 2
    move.w  -$22(a6, d1.w), d1  ; char slot index at cursor
    add.w   d1, d1               ; * 2 (stride-2 event_record)
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    tst.b   (a0,d0.w)            ; is char still present in event_record?
    beq.b   l_38402              ; gone: show "slot gone" dialog instead of confirming
; Commit the pairing: write the selected char slot index into the pair record's high nibble
    move.w  d4, d0
    add.w   d0, d0               ; cursor * 2
    move.w  -$22(a6, d0.w), d0  ; char slot index for current cursor
    ext.l   d0
    move.l  d0, -(a7)            ; push selected char slot index
    move.l  a3, -(a7)            ; push pair record pointer (byte[0]=charA, byte[1]=charB)
    jsr SetHighNibble             ; record selected slot into high nibble of pair record byte
    addq.l  #$8, a7
    moveq   #$1,d2               ; d2 = 1 = confirmed/selected result code
l_383ec:
; Clear the cursor sprite and return the result
    pea     ($0002).w             ; clear sprite mode
    pea     ($0039).w             ; sprite slot $39 = 57
    jsr GameCmd16                 ; GameCommand #$10: clear cursor sprite
    addq.l  #$8, a7
    move.w  d2, d0               ; d0 = return value (1 = confirmed, $FF = cancelled)
    bra.w   l_3853a              ; jump to epilog
; --- A-button Confirm Failed: Char Slot Gone Dialog ---
; The char was present when we checked compatibility but is now gone.
; Show an error dialog, wait, then redisplay the selection screen and resume.
l_38402:
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w             ; dialog mode 2 (error / acknowledge style)
    move.l  ($00048646).l, -(a7) ; pointer to "character unavailable" error text
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowDialog                ; display error message
    pea     ($001E).w             ; frame count = $1E = 30
    jsr PollInputChange           ; wait up to 30 frames or until input changes state
; Redisplay the main selection dialog after the error
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7) ; pointer to "select partner" main dialog text
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowDialog                ; redisplay match-results selection screen
    lea     $2c(a7), a7           ; pop all accumulated args
    clr.w   d6                   ; mark panel dirty (char list may have changed)
    bra.w   l_3851c              ; resume loop

; --- B Button: Cancel / Return $FF ---
l_38448:
    clr.w   (a5)                  ; $FF13FC = input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0
    move.w  #$ff, d2             ; d2 = $FF = cancelled result code
    bra.b   l_383ec              ; clear sprite and return

; --- Up D-Pad: Move Cursor Up in Compatible-Char List ---
l_38456:
    move.w  #$1, (a5)            ; $FF13FC = 1 = input countdown active (start auto-repeat timer)
    moveq   #$1,d6               ; d6 = 1 = panel needs redraw
    subq.w  #$1, d4              ; cursor -= 1 (move up)
    tst.w   d4                   ; did cursor go below 0?
    bge.w   l_3851c              ; no: cursor still valid, continue
    move.w  -$26(a6), d4        ; yes: wrap to max index (bottom of compatible-char list)
    bra.w   l_3851c

; --- Down D-Pad: Move Cursor Down in Compatible-Char List ---
l_3846c:
    move.w  #$1, (a5)            ; $FF13FC = 1 = input countdown active
    moveq   #$1,d6               ; d6 = 1 = panel needs redraw
    addq.w  #$1, d4              ; cursor += 1 (move down)
    cmp.w   -$26(a6), d4        ; did cursor exceed max index?
    ble.w   l_3851c              ; no: cursor still valid, continue
    clr.w   d4                   ; yes: wrap to 0 (top of compatible-char list)
    bra.w   l_3851c
; --- C Button: Browse Partners UI ---
; C-button opens BrowsePartners, a full-screen interactive browser for selecting
; a partner player. Only permitted if a match slot is currently available.
l_38482:
    clr.w   (a5)                  ; $FF13FC = input_mode_flag = 0 (clear before sub-UI)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr (CheckMatchSlots,PC)      ; scan $FF8804: is at least one match slot open?
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0              ; d0=1 means a slot is available
    bne.w   l_3851c              ; no open slot: skip BrowsePartners, just loop
; Open the BrowsePartners UI (full-screen player browser)
    moveq   #$0,d0
    move.b  $1(a3), d0           ; charB code
    ext.l   d0
    move.l  d0, -(a7)            ; push charB code
    moveq   #$0,d0
    move.b  (a3), d0             ; charA code
    ext.l   d0
    move.l  d0, -(a7)            ; push charA code
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; push player index
    jsr BrowsePartners            ; interactive partner browser; updates pair record on selection
; After BrowsePartners: refresh the display area (clear and redraw the panel region)
    clr.l   -(a7)
    pea     ($000A).w             ; height = $0A = 10 tiles
    pea     ($001E).w             ; width = $1E = 30 tiles
    pea     ($0012).w             ; row = $12 = 18
    pea     ($0001).w             ; col = 1
    clr.l   -(a7)
    pea     ($001A).w             ; GameCommand #$1A = ClearTileArea
    jsr     (a4)                  ; clear the panel region
    lea     $28(a7), a7           ; pop BrowsePartners args (3 longs = $C) + GameCmd args ($1C) = $28
; Redisplay the main selection dialog and refresh state
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000485FE).l, -(a7) ; "select partner" dialog text
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player index
    jsr ShowDialog                ; redisplay selection dialog (refreshes after sub-UI)
    move.l  ($00048612).l, -(a7) ; "slot full" / status line text for PrintfNarrow
    jsr PrintfNarrow              ; print status line
; Reset text window to full screen
    pea     ($0020).w             ; width = 32
    pea     ($0020).w             ; height = 32
    clr.l   -(a7)                 ; left = 0
    clr.l   -(a7)                 ; top = 0
    jsr SetTextWindow
    lea     $28(a7), a7           ; pop ShowDialog args ($14) + PrintfNarrow ($4) + SetTextWindow ($10) = $28
    moveq   #$1,d6               ; d6 = 1 = force panel redraw on next frame
    bra.b   l_3851c              ; continue main loop

; --- No Button / Unrecognized Input ---
l_38514:
    clr.w   (a5)                  ; $FF13FC = input_mode_flag = 0 (cancel any countdown)
    clr.w   ($00FFA7D8).l        ; $FFA7D8 = input_init_flag = 0 (reset auto-repeat state)

; --- Loop Tail: Single-Choice Auto-Confirm and Frame Sync ---
l_3851c:
    cmpi.w  #$1, -$28(a6)       ; are we in single-choice mode (only 1 compatible char)?
    bne.b   l_38526
    clr.w   d6                   ; yes: suppress redraw in single-choice mode (no cursor to move)
l_38526:
; Wait 3 frames before next loop iteration (GameCommand #$0E, 3 times)
    pea     ($0003).w             ; frame count = 3
    pea     ($000E).w             ; GameCommand #$0E = frame sync / wait
    jsr     (a4)                  ; wait 3 frames
    addq.l  #$8, a7

; --- Loop Entry Point: Check for Loop Exit ---
l_38532:
    cmpi.w  #$ff, d2             ; has a button set d2 to $FF (cancel) or 1 (confirm)?
    bne.w   l_3825c              ; no: d2 still 0 (pending), loop back to frame body
; --- Epilog: Restore and Return ---
; d0 already holds the return value: 1 = char paired, $FF = cancelled, other = undefined.
l_3853a:
    movem.l -$50(a6), d2-d7/a2-a5 ; restore saved registers from link frame
    unlk    a6                    ; restore A6 and deallocate local frame
    rts
