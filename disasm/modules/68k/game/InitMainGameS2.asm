; ============================================================================
; InitMainGameS2 -- Run the main game S2 route assignment screen: display route map with aircraft tiles and slot text, handle char selection and slot navigation input, and show char comparison on confirm.
; 1446 bytes | $025254-$0257F9
;
; Args: $8(a6) = player_index (long)
;       $C(a6) = region_or_char_category (long)  [d2 throughout = "char class"]
; Frame layout:
;   a6-$02 : last ProcessInputLoop result (a5 = ptr to this)
;   a6-$20 : char-occupancy buffer (30 bytes; a4 = ptr)
;   a6-$22 : blink/animation frame counter
;   a6-$24 : link frame top
; Register usage:
;   D2 = char_class / region index (from $C(a6))
;   D3 = redraw flag: 1=full redraw, 0=skip to input phase
;   D4 = player_index (from $8(a6))
;   D5 = slot selector index (0-4, cycles via SignedMod 5)
;   D6 = route-map slot count returned by LoadRouteMapDisplay (0 = no slots)
;   D7 = input-received flag (1 = got input this frame, clears after redraw)
;   A3 = GameCommand dispatcher ($000D64)
;   A4 = char-occupancy buffer (a6-$20)
;   A5 = ptr to last ProcessInputLoop result word (a6-$02)
; ============================================================================
InitMainGameS2:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d2                  ; d2 = char_class / region index
    move.l  $8(a6), d4                  ; d4 = player_index
    movea.l  #$00000D64,a3              ; a3 = GameCommand dispatcher
    lea     -$20(a6), a4                ; a4 = char-occupancy buffer (30 bytes)
    lea     -$2(a6), a5                 ; a5 = ptr to ProcessInputLoop result word
    moveq   #$1,d3                      ; d3 = 1: force full redraw on first iteration

; --- Phase: One-time setup -- clear occupancy buffer and seed input state ---
    jsr PreLoopInit
    pea     ($001E).w                   ; count = 30 bytes
    clr.l   -(a7)                       ; fill value = 0
    move.l  a4, -(a7)
    jsr MemFillByte                     ; zero char-occupancy buffer at a4
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharOccupancy,PC)        ; populate occupancy buffer for this player/class
    nop
    clr.l   -(a7)
    jsr ReadInput                       ; drain any pending input before loop begins
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   .l252b0
    moveq   #$1,d7                      ; d7 = 1: input was pending, trigger early redraw
    bra.b   .l252b2
.l252b0:
    moveq   #$0,d7                      ; d7 = 0: no pending input
.l252b2:
    clr.w   (a5)                        ; clear ProcessInputLoop result
    clr.w   ($00FF13FC).l               ; input_mode_flag = 0 (no countdown active)
    clr.w   ($00FFA7D8).l               ; input_init_flag = 0
    clr.w   d5                          ; d5 = slot selector = 0 (first slot)
    clr.w   -$22(a6)                    ; blink frame counter = 0

; ============================================================================
; --- Phase: Main display/input loop ---
; ============================================================================
.l252c6:
    cmpi.w  #$1, d3                     ; check redraw flag
    bne.w   .l2541c                     ; skip full redraw if d3 != 1

; --- Phase: Full screen redraw (d3 == 1) ---
    ; GameCommand $1A: set up display layer parameters
    ; Args: cmd=$1A, 0, 0, mode=$03, height=$20, width=$07, flags=$8000
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                        ; GameCommand $1A: configure display layer
    jsr ResourceLoad
    pea     ($0002).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_class
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index
    jsr LoadScreen                      ; load background tilemap for this player/class
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo                  ; draw player name/status banner
    lea     $2c(a7), a7

    ; Set text window covering full screen (row 0-31, col 0-31)
    pea     ($0020).w                   ; width = 32 tiles
    pea     ($0020).w                   ; height = 32 tiles
    clr.l   -(a7)                       ; x = 0
    clr.l   -(a7)                       ; y = 0
    jsr SetTextWindow
    pea     ($0001).w                   ; row = 1
    pea     ($0003).w                   ; col = 3
    jsr SetTextCursor
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$2, d0                     ; d5 * 4 = longword index into pointer table
    movea.l  #$0005F912,a0             ; ROM pointer table: slot-header format strings
    move.l  (a0,d0.l), -(a7)           ; select format string for current slot selector d5
    jsr PrintfWide                      ; print slot header text in wide font
    lea     $1c(a7), a7

    ; GameCommand $1A: configure slot-list display region
    ; Rows 1-9 (y=$01, height=$09), cols 1-23 (x=$01, width=$17)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                        ; GameCommand $1A: configure slot-list region

    ; Load aircraft tile graphics for slot list (char_class, player, rows 1-23)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_class
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics                ; decompress and load aircraft slot graphics

    ; Place left aircraft icon tile (tile $0770 = aircraft type A icon)
    ; TilePlacement args: tile_id, x, y, palette, width, height, flags
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w                   ; height = 1
    pea     ($0001).w                   ; width = 1
    pea     ($0007).w                   ; palette 7
    pea     ($00B8).w                   ; y = $B8 (screen pixel Y)
    pea     ($0004).w                   ; x = 4 (tile column)
    pea     ($0770).w                   ; tile $0770 = aircraft class A icon
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E: commit tile to display
    lea     $24(a7), a7

    ; Place right aircraft icon tile (tile $0771 = aircraft type B icon)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w                   ; palette $0F
    pea     ($00B8).w                   ; y = $B8
    pea     ($0005).w                   ; x = 5 (tile column)
    pea     ($0771).w                   ; tile $0771 = aircraft class B icon
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E: commit tile to display
    lea     $24(a7), a7
    jsr ResourceUnload

    ; Draw the route map with current slot selection
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; redraw_flag (d3)
    move.l  a4, -(a7)                   ; char-occupancy buffer
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; slot selector index (d5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_class (d2)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index (d4)
    jsr (LoadRouteMapDisplay,PC)        ; draw route map; returns slot count in D0
    nop
    lea     $14(a7), a7
    move.w  d0, d6                      ; d6 = slot count (0 = no active routes)
    clr.w   d3                          ; clear redraw flag -- screen is now up to date

; --- Phase: Input polling / per-frame update (always executed) ---
.l2541c:
    tst.w   d7                          ; d7 = pending input from earlier frame?
    beq.b   .l2543e
    clr.l   -(a7)
    jsr ReadInput                       ; drain one more input frame
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l2543e
    ; Got another input event while d7 was set -- re-dispatch command $0E
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E
    addq.l  #$8, a7
    bra.w   .l252c6                     ; full redraw on next iteration
.l2543e:
    clr.w   d7

; --- Phase: Blink/animation cycle control ---
    ; Counter at a6-$22 drives a 3-phase tile blink:
    ;   frame 1:    show highlight tiles $0772/$0773
    ;   frame $28A: clear highlight (GameCmd16)
    ;   frame $514: reset counter (wrap back to 0)
    addq.w  #$1, -$22(a6)              ; increment blink frame counter
    cmpi.w  #$1, -$22(a6)
    bne.b   .l254b4
    ; --- Blink phase 1: place slot-selection highlight tiles ---
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000C).w                   ; palette $0C
    pea     ($0010).w                   ; y = $10
    pea     ($0039).w                   ; x = $39 (tile col 57)
    pea     ($0772).w                   ; tile $0772 = slot highlight A
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E: commit tile
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000C).w
    pea     ($00B0).w                   ; y = $B0
    pea     ($003A).w                   ; x = $3A (tile col 58)
    pea     ($0773).w                   ; tile $0773 = slot highlight B
    jsr TilePlacement
    lea     $1c(a7), a7
.l254a6:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E: commit tile
    addq.l  #$8, a7
    bra.b   .l254da                     ; proceed to ProcessInputLoop

.l254b4:
    ; --- Blink phase 2 (frame $28A = 650): clear highlight ---
    cmpi.w  #$28a, -$22(a6)            ; $28A = 650 frames: end of blink-on period
    bne.b   .l254ce
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16                       ; GameCmd16($39,$02): clear highlight sprites
    addq.l  #$8, a7
    bra.b   .l254a6

.l254ce:
    ; --- Blink phase 3 (frame $514 = 1300): wrap counter ---
    cmpi.w  #$514, -$22(a6)            ; $514 = 1300 frames: full blink cycle complete
    bne.b   .l254da
    clr.w   -$22(a6)                    ; reset counter to 0 (restart blink cycle)

; --- Phase: Poll input and decode button bits ---
.l254da:
    move.w  -$2(a6), d0                ; previous ProcessInputLoop result
    move.l  d0, -(a7)
    pea     ($000A).w                   ; mode = $0A (standard joypad decode)
    jsr ProcessInputLoop                ; returns button state in D0
    addq.l  #$8, a7
    andi.w  #$3f, d0                    ; mask to 6 directional/action bits
    move.w  d0, (a5)                    ; store decoded buttons at a5 (a6-$02)
    andi.w  #$20, d0                    ; test bit 5 = A/Start button (confirm/select)
    beq.w   .l25738                     ; branch if not pressed

; ============================================================================
; --- Phase: Confirm/Select button (A/Start) pressed ---
; ============================================================================
    clr.w   ($00FF13FC).l               ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l               ; input_init_flag = 0
    tst.w   d6                          ; d6 = slot count from LoadRouteMapDisplay
    ble.w   .l2570c                     ; no active route slots -- skip to redraw

; --- Phase: Set up char-compare window (active routes exist) ---
    ; GameCommand $1A: define char-compare display region
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                        ; GameCommand $1A: configure char-compare region

    ; GameCommand $10: set display palette
    pea     ($0001).w
    pea     ($0004).w
    pea     ($0010).w
    jsr     (a3)                        ; GameCommand $10, mode=$04
    lea     $28(a7), a7
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0010).w
    jsr     (a3)                        ; GameCommand $10, mode=$05

    ; Draw compare window border
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    pea     ($0017).w
    jsr SetTextWindow                   ; window: rows 1-2, cols 1-23
    lea     $1c(a7), a7

    ; Print region or player heading above char compare
    cmpi.w  #$2, d2                     ; char_class == 2? (special case: full-name format)
    bne.b   .l2557a
    pea     ($000413D8).l               ; ROM: format string for class-2 heading (no arg)
    jsr PrintfNarrow
    addq.l  #$4, a7
    bra.b   .l25596
.l2557a:
    ; General case: look up region name from RegionNamePtrs table, print with format
    move.w  d2, d0
    lsl.w   #$2, d0                     ; char_class * 4 = longword index
    movea.l  #$0005EC84,a0             ; RegionNamePtrs ($05EC84): 14 entries x 4 bytes
    move.l  (a0,d0.w), -(a7)           ; push ptr to region name string
    pea     ($000413D4).l               ; ROM: "%s" format string for region heading
    jsr PrintfNarrow                    ; print "Region: <name>"
    addq.l  #$8, a7

; --- Phase: Collect available chars and run slot selection sub-screen ---
.l25596:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; slot selector index
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_class
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index
    jsr CollectPlayerChars              ; scan route slots, collect chars for this player
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; slot count
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index
    jsr (HandleRouteSelectionS2,PC)     ; interactive sub-screen: returns selected slot index in D0
    nop
    lea     $14(a7), a7
    move.w  d0, d6                      ; d6 = selected slot index ($FF = cancelled)
    cmpi.w  #$ff, d0                    ; $FF means user cancelled without selection
    beq.w   .l25664

; --- Phase: User confirmed a char slot selection -- show char comparison ---
    ; Address char record at $FF1A04 + slot * $14 (20-byte stride)
    ; $FF1A04 is a working buffer populated by HandleRouteSelectionS2
    move.w  d6, d0
    mulu.w  #$a, d0                     ; slot * 10
    add.w   d0, d0                      ; * 2 = slot * 20 ($14) bytes per entry
    movea.l  #$00FF1A04,a0             ; base of char selection result table
    lea     (a0,d0.w), a0
    movea.l a0, a2                      ; a2 = ptr to selected slot entry
    ; Entry layout: word[0]=char_code_A, word[2]=char_code_B, word[4]=char_code_C
    move.w  $4(a2), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_code_C (arg 4)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_code_B (arg 3)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_code_A (arg 2)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index (arg 1)
    jsr ShowCharCompare                 ; display side-by-side char stat comparison
    lea     $10(a7), a7
    moveq   #$1,d3                      ; request full redraw after compare dismissed

; --- Phase: Wait for all buttons released before accepting confirm ---
.l2560a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0                   ; any of the 12 tracked buttons still held?
    bne.b   .l2560a                     ; spin until all released

; --- Phase: Wait for A or B button press to dismiss compare screen ---
.l2561a:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction                      ; flush-then-wait: mode=$03 (A/B buttons)
    addq.l  #$8, a7
    andi.l  #$30, d0                    ; bits 4-5 = A/B buttons
    beq.b   .l2561a                     ; loop until A or B pressed

; --- Phase: Reload resources and redraw slot graphics after compare dismissed ---
    jsr ResourceLoad
    ; GameCommand $1A: restore full-screen display region
    move.l  #$8000, -(a7)
    pea     ($0013).w                   ; height = $13 (19 rows)
    pea     ($0020).w                   ; width = 32 cols
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                        ; GameCommand $1A: restore display
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)                        ; GameCommand $10: restore palette state
    lea     $28(a7), a7
    bra.b   .l2566c

; --- User cancelled selection (d0 == $FF) ---
.l25664:
    moveq   #$1,d3                      ; set redraw flag (full redraw next iteration)
    jsr ResourceLoad

; --- Phase: Restore slot display after compare or cancel ---
.l2566c:
    ; GameCommand $1A: reconfigure slot-list display region (rows 1-8, cols 1-23)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0017).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)                        ; GameCommand $1A
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0017).w
    jsr LoadSlotGraphics                ; reload aircraft slot tile graphics
    lea     $2c(a7), a7
    ; Re-place aircraft class A icon
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0007).w
    pea     ($00B8).w
    pea     ($0004).w
    pea     ($0770).w                   ; tile $0770 = aircraft class A icon
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E
    lea     $24(a7), a7
    ; Re-place aircraft class B icon
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($000F).w
    pea     ($00B8).w
    pea     ($0005).w
    pea     ($0771).w                   ; tile $0771 = aircraft class B icon
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $0E
    lea     $24(a7), a7
    bra.b   .l2570e

; --- No active route slots: fall through to redraw with d3=1 ---
.l2570c:
    moveq   #$1,d3                      ; force redraw (slot list is empty)

; --- Phase: Redraw route map after confirm-path or empty-slot path ---
.l2570e:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; redraw_flag
    move.l  a4, -(a7)                   ; char-occupancy buffer
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; slot selector (d5)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; char_class (d2)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index (d4)
    jsr (LoadRouteMapDisplay,PC)        ; redraw route map
    nop
    lea     $14(a7), a7
    move.w  d0, d6                      ; update slot count
    bra.w   .l252c6                     ; back to top of main loop

; ============================================================================
; --- Phase: Directional input handling (A/Start not pressed) ---
; ============================================================================
.l25738:
    ; Test bit 4 = B button (back/exit)
    move.w  (a5), d0
    andi.w  #$10, d0
    beq.b   .l25750
    ; --- B button: exit this screen ---
    clr.w   ($00FF13FC).l               ; clear input_mode_flag
    clr.w   ($00FFA7D8).l               ; clear input_init_flag
    bra.w   .l257f0                     ; return from function

.l25750:
    ; Test bit 3 = Right (D-pad right)
    move.w  (a5), d0
    andi.w  #$8, d0
    beq.b   .l25776
    ; --- D-pad Right: advance slot selector forward by 1 ---
    move.w  #$1, ($00FF13FC).l          ; mark input consumed
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0                     ; d5 + 1
.l25766:
    moveq   #$5,d1                      ; modulus = 5 (slots 0-4)
    jsr SignedMod                       ; d0 = (d0) mod 5  [wraps 0-4]
    move.w  d0, d5                      ; update slot selector
.l25770:
    moveq   #$1,d3                      ; trigger full redraw
    bra.w   .l252c6

.l25776:
    ; Test bit 2 = Left (D-pad left)
    move.w  (a5), d0
    andi.w  #$4, d0
    beq.b   .l2578e
    ; --- D-pad Left: move slot selector back by 1 (wrap via +4 mod 5) ---
    move.w  #$1, ($00FF13FC).l
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0                     ; d5 + 4 mod 5 = d5 - 1 (unsigned wrap idiom)
    bra.b   .l25766                     ; apply SignedMod 5

.l2578e:
    ; Test bit 1 = Down (D-pad down)
    move.w  (a5), d0
    andi.w  #$2, d0
    beq.b   .l257d6
    ; --- D-pad Down: advance char_class forward by 1 (mod 7) ---
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0                     ; char_class + 1
.l257a4:
    moveq   #$7,d1                      ; modulus = 7 (char classes 0-6)
    jsr SignedMod                       ; d0 = (d0) mod 7
    move.w  d0, d2                      ; update char_class
    ; Rebuild occupancy buffer for new char_class
    pea     ($001E).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte                     ; clear occupancy buffer
    move.l  a4, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; new char_class
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index
    jsr (UpdateCharOccupancy,PC)        ; repopulate for new char_class
    nop
    lea     $18(a7), a7
    bra.b   .l25770                     ; trigger full redraw

.l257d6:
    ; Test bit 0 = Up (D-pad up)
    move.w  (a5), d0
    andi.w  #$1, d0
    beq.w   .l252c6                     ; no recognized input -- loop
    ; --- D-pad Up: move char_class back by 1 (wrap via +6 mod 7) ---
    move.w  #$1, ($00FF13FC).l
    move.w  d2, d0
    ext.l   d0
    addq.l  #$6, d0                     ; char_class + 6 mod 7 = char_class - 1 (wrap idiom)
    bra.b   .l257a4                     ; apply SignedMod 7 and rebuild occupancy

; --- Phase: Function exit ---
.l257f0:
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts
