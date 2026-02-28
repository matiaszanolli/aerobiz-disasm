; ============================================================================
; HandleRouteSelectionS2 -- Handles the interactive route-selection screen: reads directional input, scrolls the route list with highlight cursor, and returns the selected route index or a back-button code.
; 738 bytes | $025B62-$025E43
; ============================================================================
; --- Phase: Setup and Input Pre-Read ---
HandleRouteSelectionS2:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    ; d4 = total number of routes to display (arg from $C(a6))
    move.l  $c(a6), d4
    ; a2 = GameCommand function pointer ($D64) -- called via register for speed
    movea.l  #$00000D64,a2
    ; a3 = TilePlacement function pointer ($1E044) -- called via register
    movea.l  #$0001E044,a3
    ; a4 = input_mode_flag ($FF13FC): nonzero = countdown/UI-input mode active
    movea.l  #$00FF13FC,a4
    ; a5 = local work area at -$C(a6) (stores scroll window size)
    lea     -$c(a6), a5
    ; d7 = redraw flag: 1 = force full redraw of route list this frame
    moveq   #$1,d7
    ; Pre-read input to detect if a button is already held (for auto-advance)
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    ; Store whether input was already active: -$A(a6) = 1 if button held, 0 if not
    tst.w   d0
    beq.b   .l25b98
    moveq   #$1,d0
    bra.b   .l25b9a
.l25b98:
    moveq   #$0,d0
.l25b9a:
    ; Save pre-read input state (used later to skip first input cycle if held)
    move.w  d0, -$a(a6)
    ; d5 = current input button bitfield (accumulated for this frame)
    clr.w   d5
    ; Clear input_mode_flag: entering fresh input loop
    clr.w   (a4)
    ; Clear input_init_flag ($FFA7D8): no countdown started yet
    clr.w   ($00FFA7D8).l
    ; d3 = page scroll offset (which group of 5 slots is the window showing)
    clr.w   d3
    ; d2 = cursor position within the current 5-slot window (0..4 or 0..total-1)
    clr.w   d2
    ; d6 = animation frame/blink counter for the highlight cursor
    clr.w   d6
    ; --- Precompute page layout for the route list ---
    ; -$4(a6) = number of full pages of 5 routes: (d4 / 5) * 5
    ; This gives the first slot index of the last complete page
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
    ; Quotient * 5 = slot index of last full page start
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    move.l  d0, -$4(a6)
    ; -$8(a6) = remainder - 1: how many slots are in the partial last page (or -1 if exact)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
    move.l  d0, -$8(a6)
; --- Phase: Main Display/Input Loop ---
.l25bd6:
    ; If d7 == 1: full redraw requested (page change or first frame)
    cmpi.w  #$1, d7
    bne.b   .l25c10
    ; Clear the route list display area with TilePlacement (all-zero args = blank)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    ; GameCommand #$E arg 1: flush display tiles
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    ; RenderPlayerDataDisplay: draws all visible route rows for the current page
    ; args: total_routes=d4, page_offset=d3
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RenderPlayerDataDisplay
    lea     $2c(a7), a7
    ; Clear redraw flag -- next frame only draws the cursor
    clr.w   d7
.l25c10:
    ; GameCommand #$E arg 3: sync display state
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    ; --- Draw Highlight Cursor ---
    ; Cursor tile $0773 placed at vertical position d2*$10 + $58 (screen Y offset)
    ; $8000 flag = priority bit (draw cursor on top of route tiles)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    ; Y position: (d2 * 16) + 88 pixels -- each route row is 16 pixels tall, first at row 88
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$58, d0
    move.l  d0, -(a7)
    ; X position = 8, tile $0773 = highlight cursor graphic
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr     (a3)
    ; Flush cursor tile to display
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $2c(a7), a7
    ; If input was pre-held at entry: consume it and loop (avoid instant selection)
    tst.w   -$a(a6)
    beq.b   .l25c66
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    ; If button still held, keep looping without processing navigation
    tst.w   d0
    bne.w   .l25bd6
; --- Phase: Scroll Indicator Animation ---
.l25c66:
    ; Clear the pre-held flag now that we've consumed it
    clr.w   -$a(a6)
    ; If 5 or fewer routes: no scrolling needed, skip scroll indicators
    cmpi.w  #$5, d4
    ble.w   .l25d14
    ; Compute how many routes are below the current page (for scroll-down indicator)
    move.w  d4, d0
    sub.w   d3, d0
    ; Clamp to 5 maximum (can only display 5 at a time)
    move.w  d0, (a5)
    cmpi.w  #$5, (a5)
    ble.b   .l25c82
    move.w  #$5, (a5)
.l25c82:
    ; Animate scroll arrows: d6 is a blink frame counter
    addq.w  #$1, d6
    ; First frame: draw both scroll arrows (up arrow at $0770, down arrow at $0771)
    cmpi.w  #$1, d6
    bne.b   .l25cf4
    ; Draw up-scroll arrow tile ($0770) at fixed top position ($39 = row 57, $F0 = col 240)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w
    pea     ($00F0).w
    pea     ($0039).w
    pea     ($0770).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    ; Draw down-scroll arrow tile ($0771) at position below the last visible route
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    ; Y position of down arrow = (visible_count * 16) + $54
    move.w  (a5), d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$54, d0
    move.l  d0, -(a7)
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0771).w
    jsr     (a3)
    lea     $1c(a7), a7
.l25ce6:
    ; Flush tiles after drawing arrows
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   .l25d14
.l25cf4:
    ; At frame 15: erase scroll arrows (GameCmd16 #$39 = clear sprites at position 2)
    cmpi.w  #$f, d6
    bne.b   .l25d0c
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l25ce6
.l25d0c:
    ; At frame 30: reset blink counter to repeat the animation
    cmpi.w  #$1e, d6
    bne.b   .l25d14
    clr.w   d6
; --- Phase: Input Processing ---
.l25d14:
    ; ProcessInputLoop: reads joypad with 10-frame debounce/repeat timer
    ; Returns button bits: $01=Up $02=Down $10=A $20=B/Start
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    ; Mask to only direction bits ($03) and confirm/cancel ($30); store in d5
    andi.w  #$33, d0
    move.w  d0, d5
    ; Check for A/B/Start (confirm or cancel): bits $10 and $20
    andi.w  #$30, d0
    beq.b   .l25d4c
    ; --- Confirm or Cancel ---
    ; Clear input_mode_flag and input_init_flag (end of input loop)
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    ; Check bit $20 (B or Start = confirm selection)
    move.w  d5, d0
    andi.w  #$20, d0
    beq.w   .l25df6
    ; Confirm: absolute selection = page_offset (d3) + cursor (d2)
    move.w  d3, d0
    add.w   d2, d0
    move.w  d0, d2
    bra.w   .l25dfa
.l25d4c:
    ; --- Down arrow: bit $02 ---
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l25dc2
    ; Activate input countdown mode (delays auto-repeat)
    move.w  #$1, (a4)
    addq.w  #$1, d2
    ; If cursor still within current 5-slot window and not past last route: accept
    cmpi.w  #$4, d2
    bgt.b   .l25d74
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l25db8
.l25d74:
    ; Cursor went past end of page or past last route
    ; If more than 5 routes: scroll to next page
    cmpi.w  #$5, d4
    ble.b   .l25d8c
    ; Advance page: d3 += 5, wrap to 0 if past total
    clr.w   d2
    addq.w  #$5, d3
    cmp.w   d4, d3
    ble.b   .l25d86
    clr.w   d3
    clr.w   d2
.l25d86:
    ; Request full redraw (page changed)
    moveq   #$1,d7
    bra.w   .l25bd6
.l25d8c:
    ; 5 or fewer routes: clamp cursor to last valid route
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   .l25dac
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l25db2
.l25dac:
    ; Clamp: cursor = total_routes - 1
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l25db2:
    move.w  d0, d2
    bra.w   .l25bd6
.l25db8:
    ; Cursor is within bounds for small list -- just loop
    cmpi.w  #$5, d4
    bge.w   .l25bd6
    bra.b   .l25d8c
.l25dc2:
    ; --- Up arrow: bit $01 ---
    move.w  d5, d0
    andi.w  #$1, d0
    beq.w   .l25bd6
    move.w  #$1, (a4)
    subq.w  #$1, d2
    ; If cursor >= 0: still within page, just redraw cursor
    tst.w   d2
    bge.w   .l25bd6
    ; Cursor went above top of page
    cmpi.w  #$5, d4
    ble.b   .l25df0
    ; Scroll to previous page: d3 -= 5
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
    bge.b   .l25d86
    ; Wrapped past page 0: use precomputed last-page values
    ; -$2(a6) = last page start row, -$6(a6) = last page cursor
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
    bra.b   .l25d86
.l25df0:
    ; Small list: wrap cursor to slot 0
    clr.w   d2
    bra.w   .l25bd6
; --- Phase: Cancel/Back Button ---
.l25df6:
    ; Return value $FF = back/cancel (bit $10 = A button = cancel in this context)
    move.w  #$ff, d2
; --- Phase: Return Selected Index ---
.l25dfa:
    ; Clear the route list display (blank all slot tiles before returning)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    ; GameCommand #$1A: clear a 9x32 tile region (the route list area)
    ; with priority $8000, at row 9, column 32
    move.l  #$8000, -(a7)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0009).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    ; Return d2: selected route index (0..N-1), or $FF for cancel
    move.w  d2, d0
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
