; ============================================================================
; ReadCharInput -- Handles character salary-quantity input: sets up a dual-column tile display with salary and count tables, shows remaining budget and current total, runs HandleCharInteraction animations, and loops processing up/down input to adjust the quantity until the player confirms or cancels
; 1100 bytes | $02EB86-$02EFD1
; ============================================================================
; --- Phase: Function Prologue -- Register Assignments ---
ReadCharInput:
; local frame: $70 bytes of local space (used as salary tile index table, two arrays)
    link    a6,#-$70
    movem.l d2-d7/a2-a5, -(a7)
; d7 = max quantity (stack arg +$14): the upper bound for item count (e.g. max hires)
    move.l  $14(a6), d7
; a2 = pointer to current quantity (stack arg +$10): points to the word holding current count
    movea.l $10(a6), a2
; a3 = PrintfWide ($03B270): format + display string with 2-tile wide font
    movea.l  #$0003B270,a3
; a4 = SetTextCursor ($03AB2C): set text cursor X/Y position
    movea.l  #$0003AB2C,a4
; a5 = GameCommand ($0D64): central command dispatcher
    movea.l  #$00000D64,a5
; d6 = 1 = left column X position for the first tile column
    moveq   #$1,d6
; d5 = $14 = 20 = Y row for the salary column header tile
    moveq   #$14,d5
; d2 = $15 = 21 = Y row for the count column header tile
    moveq   #$15,d2
; d3 = $A = 10 = X column for the second tile column
    moveq   #$A,d3
; --- Phase: Screen Setup -- Load Graphics and Place Background Tile ---
; DisplaySetup: initialize display with resource table at $76A3E, palette indices $10/$10
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
; LZ_Decompress: decompress graphics from ROM pointer at $A1B04 into save_buf_base ($FF1804)
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
; CmdPlaceTile: place background panel tile at row $11, column $59 from decompressed buffer
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
; --- Phase: Screen Setup -- Draw Column Headers ---
; GameCommand #$1B: place salary-column header tile from $7194C (count=6) at (d3, d2) = (10, $15)
    pea     ($0007194C).l
    pea     ($0006).w
    pea     ($000A).w
; push d3 as column X ($A = 10)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
; push d2 as row Y ($15 = 21)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
; GameCmd16 (GameCommand #16): #$39 = clear/init display widget for salary column
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
; SetTextWindow: define 32×32 rendering window (full screen) at origin (0,0)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
; --- Phase: Screen Setup -- Build Tile Index Tables in Local Frame ---
; First loop: build salary tile ID table at -$70(a6), 36 entries ($24 = 36 items)
; Each entry = $3D94 + index; stored as word at -$70(a6, index*2)
; $3D94 is the base tile ID for salary display tiles in VRAM
    clr.w   d2
.l2ec38:
; d0 = $3D94 + d2 = tile VRAM ID for salary row d2
    move.w  d2, d0
    addi.w  #$3d94, d0
; d1 = d2*2 = byte offset into local word array
    move.w  d2, d1
    add.w   d1, d1
; store tile ID at -$70(a6) + d2*2 (frame-local salary tile array, 36 entries)
    move.w  d0, -$70(a6, d1.w)
    addq.w  #$1, d2
; loop 0..35 ($24 entries): one per salary display slot
    cmpi.w  #$24, d2
    bcs.b   .l2ec38
; Second loop: build count/quantity tile ID table at -$28(a6), 20 entries ($14 = 20 items)
; Each entry = $2D7F + index; stored at -$28(a6, index*2)
; $2D7F is the base tile ID for quantity/count tiles in VRAM
    clr.w   d2
.l2ec50:
; d0 = $2D7F + d2 = tile VRAM ID for count row d2
    move.w  d2, d0
    addi.w  #$2d7f, d0
    move.w  d2, d1
    add.w   d1, d1
; store tile ID at -$28(a6) + d2*2 (frame-local count tile array, 20 entries)
    move.w  d0, -$28(a6, d1.w)
    addq.w  #$1, d2
; loop 0..19 ($14 entries): one per quantity slot
    cmpi.w  #$14, d2
    bcs.b   .l2ec50
; --- Phase: Initial Display -- Render Header Tiles and Budget Values ---
; GameCommand #$1B: place count-column header tile from $71A14 (count=4) at (d6, d5) = (1, $14)
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
; push d5 = $14 (row Y for the count column)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
; push d6 = 1 (column X for left panel)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $2c(a7), a7
; d2 = 1: display mode flag (1 = showing salary column header active)
    moveq   #$1,d2
; SetTextCursor: position cursor at (d5+2, d6+3) = (row $16, col 4) -- budget display row
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
; compute remaining budget: d7 (max) - (a2) (current count) + 1
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
; +1 because we haven't committed the current selection yet
    addq.l  #$1, d0
; PrintfWide: print remaining budget value using format string at $44704
    move.l  d0, -(a7)
    pea     ($00044704).l
    jsr     (a3)
; SetTextCursor: position cursor at ($E, $1B) for label "remaining" below budget figure
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
; PrintfWide: print budget label string at $44700 (e.g. "BUDGET" or "REMAIN")
    pea     ($00044700).l
    jsr     (a3)
; SetTextCursor: position cursor at ($10, $13) for total-cost display
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
; compute total cost = salary_per_unit ($1A(a6)) × current count (a2)
    moveq   #$0,d0
; $1A(a6) = salary/unit-cost stack argument
    move.w  $1a(a6), d0
; (a2) = current selected quantity
    move.w  (a2), d1
    ext.l   d1
; Multiply32: d0 = salary × count (total cost so far)
    jsr Multiply32
; PrintfWide: print total cost at $446FA format string
    move.l  d0, -(a7)
    pea     ($000446FA).l
    jsr     (a3)
    lea     $2c(a7), a7
; GameCommand #$A: flush display command (commit pending tile writes)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a5)
; SetTextCursor: position cursor at (d5+2, d6+3) again -- redraw remaining-budget line
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
; remaining = max_quantity - current_count (no +1 here: pre-decrement context)
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
; PrintfWide: print updated remaining budget at $446F6
    move.l  d0, -(a7)
    pea     ($000446F6).l
    jsr     (a3)
; HandleCharInteraction: animate character portrait / run character interaction; arg=1 = initial display
    pea     ($0001).w
    jsr (HandleCharInteraction,PC)
    nop
; SetTextCursor: position cursor at ($E, $1B) for current-count display
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
; PrintfWide: print current selected count (a2) at $446F2
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446F2).l
    jsr     (a3)
    lea     $2c(a7), a7
; if d7 - 1 > 0: max quantity > 1, so quantity column header stays active (d2 left at 1)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$1, d0
; if max == 1, there's only one possible value -- show the locked tile header instead
    bgt.b   .l2ed7a
; GameCommand #$1B: replace count-column header with locked/unavailable header tile ($719C4)
; count=4, at (d6, d5) -- overwrites active quantity header with a greyed-out variant
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
; d2 = 0: disable salary/quantity column animation flag (max=1, no selection needed)
    clr.w   d2
.l2ed7a:
; --- Phase: Input Loop -- Animation Frame Counter and Periodic Tile Updates ---
; d3 = animation frame counter (used for blinking/cycling tile effects)
    clr.w   d3
.l2ed7c:
    addq.w  #$1, d3
; on frame 1: place both cursor/highlight tiles to initiate the display
    cmpi.w  #$1, d3
    bne.b   .l2edec
; TilePlacement: place tile $772 (up-arrow or highlight A) at VRAM X=$39, Y=$8, count=$AC
; $8000 = high-priority tile attribute
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
; GameCommand #$E with arg 1: advance/flush display after first tile placement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
; TilePlacement: place tile $773 (down-arrow or highlight B) at VRAM X=$3A, Y=$50, count=$AC
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0050).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
; fall into common 1-frame-wait + continue path
.l2edde:
; GameCommand #$E with arg 1: wait 1 frame (sustain current display state)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2ee0c
.l2edec:
; at frame $1F4 = 500: call GameCmd16 #$39 to cycle/refresh tile animation phase
    cmpi.w  #$1f4, d3
    bne.b   .l2ee04
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2edde
; at frame $3E8 = 1000: reset animation counter to restart cycle
.l2ee04:
    cmpi.w  #$3e8, d3
    bne.b   .l2ee0c
; wrap d3 back to 0 so the 500/1000-frame cycle repeats indefinitely
    clr.w   d3
; --- Phase: Input Loop -- Read and Decode Button State ---
.l2ee0c:
; ProcessInputLoop: poll joypad, debounce, return button bits in d0
; d4 is the previous button state passed in; $A = timeout parameter
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
; mask to relevant direction/button bits: $3C = Up|Down|Left|Right
    andi.w  #$3c, d0
; d4 = filtered button state for this frame
    move.w  d0, d4
; bit $20 = B button (cancel/confirm?): if set, exit input loop
    andi.w  #$20, d0
; B pressed: jump to exit/return path
    bne.w   .l2efc6
; bit $10 = A button (confirm/select): if set, call PreLoopInit and exit
    move.w  d4, d0
    andi.w  #$10, d0
    beq.b   .l2ee3c
; A button pressed: finalize selection
    jsr PreLoopInit
    bra.w   .l2efc6
; --- Phase: Input -- Down Arrow: Decrement Quantity ---
.l2ee3c:
; bit $4 = Down button
    move.w  d4, d0
    andi.w  #$4, d0
; not Down: check Up instead
    beq.w   .l2eef6
; already at minimum (1): can't go lower, loop back to next input frame
    cmpi.w  #$1, (a2)
    ble.w   .l2ed7c
; decrement current quantity by 1
    subq.w  #$1, (a2)
; SetTextCursor: position at ($E, $1B) to overwrite count display
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
; PrintfWide: redisplay decremented count value at $446EE
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446EE).l
    jsr     (a3)
; SetTextCursor: position at ($10, $13) for total cost display
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
; recompute total cost = salary × new quantity
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.w  (a2), d1
    ext.l   d1
    jsr Multiply32
; PrintfWide: print updated total cost at $446E8
    move.l  d0, -(a7)
    pea     ($000446E8).l
    jsr     (a3)
    lea     $20(a7), a7
; if d2 is already set (column header active), skip re-placing header tile
    tst.w   d2
    bne.b   .l2eebe
; d2 was 0 (locked header): now that count > 0 is possible, restore active header
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
; mark column header as active again
    moveq   #$1,d2
.l2eebe:
; HandleCharInteraction: update character animation (arg=0 = idle/update tick)
    clr.l   -(a7)
    jsr (HandleCharInteraction,PC)
    nop
; SetTextCursor: reposition at (d5+2, d6+3) to redraw remaining-budget display
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
; remaining = max - current_count; display updated remaining budget
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000446E4).l
; shared tail: print remaining value and loop back to animation counter
.l2eeee:
    jsr     (a3)
    addq.l  #$8, a7
; loop back to animation frame counter (d3 increment)
    bra.w   .l2ed7c
; --- Phase: Input -- Up Arrow: Increment Quantity ---
.l2eef6:
; bit $8 = Up button
    move.w  d4, d0
    andi.w  #$8, d0
; not Up: no recognized direction, loop back to animation frame counter
    beq.w   .l2ed7c
; already at max (d7): can't go higher, loop back
    cmp.w   (a2), d7
    ble.w   .l2ed7c
; increment current quantity by 1
    addq.w  #$1, (a2)
; SetTextCursor: reposition at (d5+2, d6+3) for remaining-budget display
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr     (a4)
; remaining = max - new_count; print updated remaining value at $446E0
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000446E0).l
    jsr     (a3)
; HandleCharInteraction: animate character (arg=1 = new-selection notification)
    pea     ($0001).w
    jsr (HandleCharInteraction,PC)
    nop
    lea     $14(a7), a7
; check if quantity is now at maximum (remaining == 0)
    move.w  d7, d0
    ext.l   d0
    move.w  (a2), d1
    ext.l   d1
    sub.l   d1, d0
; if remaining > 0, column header stays active
    bgt.b   .l2ef84
; remaining == 0 AND column header was active (d2==1): lock down the header tile
    cmpi.w  #$1, d2
    bne.b   .l2ef84
; GameCommand #$1B: replace active count header with locked/greyed-out version ($719C4)
; signals player can't add more (at capacity)
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
; GameCommand #$10: finalize palette/display after placing locked header
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    lea     $28(a7), a7
; d2 = 0: mark header as locked (quantity at max)
    clr.w   d2
.l2ef84:
; SetTextCursor: position at ($E, $1B) to redraw count display after Up press
    pea     ($000E).w
    pea     ($001B).w
    jsr     (a4)
; PrintfWide: print new (incremented) quantity at $446DC
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000446DC).l
    jsr     (a3)
; SetTextCursor: position at ($10, $13) to redraw total cost
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a4)
    lea     $18(a7), a7
; recompute total cost = salary × new quantity
    moveq   #$0,d0
    move.w  $1a(a6), d0
    move.w  (a2), d1
    ext.l   d1
    jsr Multiply32
; PrintfWide: print updated total cost at $446D6, then branch to shared remaining-display tail
    move.l  d0, -(a7)
    pea     ($000446D6).l
; share tail with Down-decrement path: print remaining and loop to animation counter
    bra.w   .l2eeee
; --- Phase: Function Return ---
.l2efc6:
; d0 = final d4 button state returned to caller (so caller knows which button ended the loop)
    move.w  d4, d0
    movem.l -$98(a6), d2-d7/a2-a5
    unlk    a6
    rts
