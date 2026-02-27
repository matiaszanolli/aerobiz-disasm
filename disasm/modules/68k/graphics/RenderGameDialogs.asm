; ============================================================================
; RenderGameDialogs -- Runs the negotiation/dialog UI loop for a match slot; handles Up/Down offer adjustment, partner browsing, and confirm/cancel input
; 1878 bytes | $039688-$039DDD
; ============================================================================
; --- Phase: Setup and Compatibility Score Calculation ---
RenderGameDialogs:
    link    a6,#-$C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    ; a2 = pointer to char stat record (per-player stat, $FF05C4-based)
    movea.l  #$00000D64,a3
    ; a3 = GameCommand dispatcher (cached)
    lea     -$8(a6), a4
    ; a4 = pointer to local word var -$8(a6): current negotiation offer (adjusted score)
    lea     -$4(a6), a5
    ; a5 = pointer to local word var -$4(a6): base compatibility score from CharCodeScore
    ; d7 = $033A = base tile offset for the negotiation offer bar
    move.w  #$33a, d7
    ; d6 = starting column offset for the offer bar (initialized 0)
    clr.w   d6
    ; ShowDialog: display the dialog panel for this match slot (uses table $4860A variant)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    ; $4860A = ROM pointer to dialog descriptor table for the negotiation screen
    ; (differs from $48602 used in RenderPlayerInterface -- different dialog variant)
    move.w  $a(a6), d0
    ext.l   d0
    ; d0 = match slot index (second argument, +$0A(a6))
    move.l  d0, -(a7)
    jsr ShowDialog
    ; CheckMatchSlots: verify available match slots for this index
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_396e4
    ; valid matches found: print availability message
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_396e4:
    ; SetTextWindow: full-screen ($20×$20) to clear any scroll constraints
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; --- Compute base compatibility score between the two negotiating characters ---
    ; CharCodeScore: percentage match score for two character codes (returns 0-100)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; a2[+$01] = partner character type (primary skill/rating stat)
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ; a2[+$00] = self character type
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    ; d0 = compatibility percentage (0-100)
    move.w  d0, (a5)
    ; (a5) = -$4(a6) = base compatibility score; stored as negotiation floor
    ; --- Scale score: offer = score * 100 / 150 (MulDiv) ---
    ; This scales the raw compatibility % to a usable offer value range
    pea     ($0064).w
    ; $64 = 100 (numerator multiplier)
    pea     ($0096).w
    ; $96 = 150 (denominator)
    move.w  -$4(a6), d0
    ; d0 = base compatibility score
    move.l  d0, -(a7)
    jsr MulDiv
    ; d0 = score * 100 / 150 = scaled initial offer value
    lea     $24(a7), a7
    move.w  d0, -$6(a6)
    ; -$6(a6) = maximum negotiation offer cap (scaled from compatibility)
    ; a2[+$04] = route slot field (clear to indicate no slot committed yet)
    clr.w   $4(a2)
    ; d2 = $32 (50) = initial offer value (midpoint of 0-100 range)
    moveq   #$32,d2
    ; --- Draw the negotiation dialog box ---
    ; DrawBox: bordered dialog box at col 1, row $0E, width $1E, height $04
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    jsr DrawBox
    ; SetTextWindow: restore full-screen window after DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; -$c(a6) = "first display" flag: 1 = first time rendering offer text
    move.w  #$1, -$c(a6)
    ; ReadInput mode 0: detect if button was held (auto-repeat state)
    clr.l   -(a7)
    jsr ReadInput
    lea     $24(a7), a7
    tst.w   d0
    beq.b   l_39774
    moveq   #$1,d0
    ; d0 = 1: input held -- enable auto-repeat
    bra.b   l_39776
l_39774:
    moveq   #$0,d0
l_39776:
    move.w  d0, -$2(a6)
    ; -$2(a6) = auto-repeat enable flag
    clr.w   -$a(a6)
    ; -$a(a6) = saved ProcessInputLoop state
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear
    move.w  (a5), (a4)
    ; (a4) = -$8(a6) = current offer value; initialized to base compatibility score
    clr.w   d5
    ; d5 = animation / blink frame counter (starts at 0)
; --- Phase: Offer Display and Blink Animation Loop ---
l_3978e:
    addq.w  #$1, d5
    ; d5 = blink frame counter (same 30-frame cycle pattern)
    cmpi.w  #$1, d5
    bne.b   l_397fe
    ; --- Frame 1: draw offer highlight cursor tiles ---
    ; TilePlacement: place cursor tile at ($80 px X, $10 px Y), tile $0772 (cursor top)
    move.l  #$8000, -(a7)
    ; $8000 = high-priority sprite flag
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    ; $80 = 128 pixels = X position for the offer bar cursor
    pea     ($0010).w
    ; $10 = 16 pixels = Y position for top of cursor
    pea     ($0039).w
    pea     ($0772).w
    ; $0772 = cursor highlight tile (top half)
    jsr TilePlacement
    ; Wait 1 frame
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    ; TilePlacement: place cursor bottom tile at same X, +$68 pixels down
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0080).w
    pea     ($0068).w
    ; $68 = 104 pixels = Y for cursor bottom (13 rows below top)
    pea     ($003A).w
    pea     ($0773).w
    ; $0773 = cursor highlight tile (bottom half)
    jsr TilePlacement
    lea     $1c(a7), a7
l_397f0:
    ; Wait 1 frame (blink pacing)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   l_3981e
l_397fe:
    cmpi.w  #$f, d5
    bne.b   l_39816
    ; --- Frame 15: erase cursor (GameCmd16 #$39) ---
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_397f0
l_39816:
    cmpi.w  #$1e, d5
    bne.b   l_3981e
    ; --- Frame 30: reset counter for next blink cycle ---
    clr.w   d5
; --- Phase: Render Offer Bar and Offer Text ---
l_3981e:
    ; --- Clamp d2 (offer value) to [0, 100] ---
    tst.w   d2
    ble.b   l_39828
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3982a
l_39828:
    moveq   #$0,d0
    ; d2 = 0 (floor: offer can't go below 0%)
l_3982a:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   l_39838
    move.w  d2, d0
    ext.l   d0
    bra.b   l_3983a
l_39838:
    moveq   #$64,d0
    ; d2 = 100 (ceiling: offer can't exceed 100%)
l_3983a:
    move.w  d0, d2
    ; d2 = clamped offer value in [0..100]
    ; SetTextCursor at col $0F, row $0F -- position for offer value text
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    addq.l  #$8, a7
    ; --- Determine offer direction relative to neutral (50 = $32) ---
    ; d2 - $32: negative = offer below midpoint (unfavorable), positive = above, zero = exact
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    ; d0 = d2 - 50 (signed)
    beq.w   l_398ea
    ; d0 == 0: offer is exactly 50 -- show neutral/equilibrium state
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    bge.b   l_398b0
    ; d0 < 0: offer is below 50 -- unfavorable (low offer)
    ; SetTextCursor again (re-position after the comparison computation)
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    ; PrintfWide: display low-offer indicator: amount below 50 = ($32 - d2)
    move.w  d2, d0
    ext.l   d0
    neg.l   d0
    addi.l  #$32, d0
    ; d0 = 50 - d2 = how far below neutral (displayed as negative offset)
    move.l  d0, -(a7)
    pea     ($0004502C).l
    ; $4502C = format string for below-midpoint offer (e.g. "-N%" indicator)
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.w   l_3991c
    ; -$c(a6) == 1: first frame -- also print the offer-type label
    pea     ($0004501E).l
    ; $4501E = format string for low offer label (e.g. "OFFER LOW" or directional arrow)
l_398a2:
    jsr PrintfWide
    addq.l  #$4, a7
    clr.w   -$c(a6)
    ; clear "first display" flag after initial render
    bra.b   l_3991c
l_398b0:
    ; d0 > 0: offer is above 50 -- favorable (high offer)
    pea     ($000F).w
    pea     ($000F).w
    jsr SetTextCursor
    ; PrintfWide: display high-offer indicator: amount above 50 = (d2 - 50)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    ; d0 = d2 - 50 = how far above neutral
    move.l  d0, -(a7)
    pea     ($0004501A).l
    ; $4501A = format string for above-midpoint offer (e.g. "+N%" indicator)
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, -$c(a6)
    bne.b   l_3991c
    pea     ($0004500C).l
    ; $4500C = format string for high offer label (first-frame only)
    bra.b   l_398a2
    ; shared tail: print label, clear first-frame flag
l_398ea:
    ; --- Offer exactly at 50 (equilibrium): render "balanced" state and reset offer ---
    ; GameCommand #$1A: clear the offer direction indicator area
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0007).w
    pea     ($000F).w
    pea     ($0017).w
    ; clear region: col $0F, row $17, width $07, height $02
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    ; PrintfWide: display the "EQUAL" or equilibrium offer string
    pea     ($00044FFE).l
    ; $44FFE = format string for balanced offer state (e.g. "EQUAL" or dash)
    jsr PrintfWide
    lea     $20(a7), a7
    ; Sync (a4) to current (a5): offer is now anchored at the base compatibility score
    move.w  (a4), (a5)
    ; (a5) = -$4(a6) = base score; updated to match current offer
    move.w  #$1, -$c(a6)
    ; -$c(a6) = 1: reset "first display" flag so next render reprints the label
; --- Phase: Draw the Offer Bargaining Bar ---
; The offer bar is a 10-cell horizontal strip representing the offer value (0-100).
; d2 / 10 = number of filled cells (d3), d2 % 10 = partial cell width (d4).
; d6 = bar column offset, d7 = base tile index for bar cells ($033A).
l_3991c:
    ; SetTextCursor at col $09, row $19 -- position for current offer score label
    pea     ($0009).w
    pea     ($0019).w
    jsr SetTextCursor
    ; PrintfNarrow: display (a4) = current adjusted offer score
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF8).l
    ; $44FF8 = format string for offer score number (narrow font)
    jsr PrintfNarrow
    ; SetTextCursor at col $0A, row $19 -- position for offer percentage delta label
    pea     ($000A).w
    pea     ($0019).w
    jsr SetTextCursor
    ; PrintfNarrow: display d2 - $32 = (offer - 50) percentage offset
    ; $FFCE = -50 as signed word; addi converts to signed relative value
    move.w  d2, d0
    addi.w  #$ffce, d0
    ; d0 = d2 - 50 (signed offset from neutral, displayed as +/- value)
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FF2).l
    ; $44FF2 = format string for percentage offset label (narrow font)
    jsr PrintfNarrow
    lea     $20(a7), a7
    ; --- Decompose d2 into bar fill: d3 = full cells, d4 = remainder ---
    ; d3 = d2 / 10 = number of completely filled bar cells (0-10)
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d3
    ; d4 = d2 % 10, clamped to minimum 1 (for the partial fill cell)
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    ; d0 = d2 mod 10
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   l_39992
    ; if mod result < 1: use the actual mod value
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   l_39994
l_39992:
    moveq   #$1,d0
    ; partial cell width = 1 (minimum, so bar always has a tip)
l_39994:
    move.w  d0, d4
    ; d4 = partial fill width (1-10); controls the fractional bar tip cell
    ; --- Draw d3 full bar cells: two rows (top and bottom) of solid tile $033A ---
    ; Each full cell: GameCommand #$1A with tile (d7 + d6) at rows $0A (top) and $03 (bottom)
    tst.w   d3
    ble.b   l_399f2
    ; d3 == 0: no full cells to draw
    ; Draw d3 filled cells, top row
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    ; d0 = d6 + d7 = tile index base for this bar column (d6=col offset, d7=$033A base)
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; d3 = number of full cells
    pea     ($000A).w
    ; row $0A = top row of bar
    pea     ($0014).w
    ; col $14 = bar start column
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; Draw d3 filled cells, bottom row (row $03)
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    ; row $10 = bottom row of bar
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_399f2:
    ; --- Draw d4 partial fill cell (the fractional tip of the bar) ---
    tst.w   d4
    beq.b   l_39a5a
    ; d4 == 0: no partial cell (offer is exactly on a 10% boundary)
    ; Draw partial tip cell top row: at column (d3 + $14 + 1), width d4
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    ; +1: partial cell is one step beyond the last full cell
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    ; height = 1 cell
    pea     ($000A).w
    ; row $0A = top row of bar
    move.w  d3, d0
    ext.l   d0
    addi.l  #$14, d0
    ; col = d3 + $14 = position immediately after the last full cell
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; Draw partial tip cell bottom row: same column, row $10
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0010).w
    ; row $10 = bottom row of bar
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    ; col = d3 + 3 (slight offset for bottom partial cell alignment)
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_39a5a:
    ; --- Draw the empty remainder of the bar (10 - d3 - d4 cells) ---
    ; Compute remaining empty cells: 10 - d3 - d4
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    ; d1 = 10 - d3
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    ; d1 = 10 - d3 - d4 = number of empty cells
    ble.w   l_39af4
    ; d1 <= 0: bar is full, no empty cells to draw
    ; Draw empty cells top row (tile d6+d7+2 = blank/empty bar segment)
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    ; tile index +2 = empty bar segment tile variant
    move.l  d0, -(a7)
    pea     ($0001).w
    ; compute empty count: 10 - d3 - d4 (recomputed for push)
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    ; d1 = empty cell count
    pea     ($000A).w
    ; row $0A = top row of bar
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addi.l  #$14, d0
    ; col = d3 + d4 + $14 = start of empty region
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; Draw empty cells bottom row
    move.w  d6, d0
    ext.l   d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    ; same empty count
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.w  d4, d0
    ext.l   d0
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    ; row $10 = bottom row of bar
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
; --- Phase: Input Check and Button Dispatch ---
l_39af4:
    ; Check auto-repeat (same pattern as other two functions)
    tst.w   -$2(a6)
    beq.b   l_39b18
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_39b18
    ; input still held -- fall through to loop-back tail
l_39b08:
    ; Wait 3 frames then re-enter blink/offer loop
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   l_3978e
    ; restart blink animation and offer render loop
l_39b18:
    clr.w   -$2(a6)
    ; d2 auto-repeat flag cleared; proceed to fresh button read
    ; ProcessInputLoop: poll joypad with $0A frame timeout
    move.w  -$a(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    ; $BC mask = Up/Down/A/B/Start (same as RenderPlayerInterface)
    move.w  d0, -$a(a6)
    ext.l   d0
    ; --- Button dispatch for negotiation controls ---
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_39b62
    ; $20 = A button: confirm negotiation offer (accept deal)
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_39bcc
    ; $10 = B button: cancel / reject deal
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_39c52
    ; $04 = Up: decrease offer value (lower your proposal)
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39ca4
    ; $08 = Down: increase offer value (raise your proposal)
    cmpi.w  #$80, d0
    beq.w   l_39cda
    ; $80 = Start: browse partners
    bra.w   l_39dc4
    ; no relevant button -- idle path
; --- A Button: Accept / Confirm Offer ---
l_39b62:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    ; Commit the current offer: write -$8(a6) (adjusted offer score) into a2[+$04]
    move.w  -$8(a6), $4(a2)
    ; a2[+$04] = route_slot.ticket_price field: stores the agreed negotiation value
    ; GameCommand #$18: play confirmation sound/animation
    pea     ($0018).w
    jsr     (a3)
    ; GameCommand #$1A: clear dialog box area (first pass, blank fill)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $20(a7), a7
    ; GameCommand #$1A: clear dialog box area (second pass, alternate fill variant)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    ; GameCmd16 #$39: clear sprite layer (cursor tiles)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    ; return code 4 = deal accepted
    moveq   #$4,d0
    bra.w   l_39dd4
; --- B Button: Reject / Cancel Offer ---
l_39bcc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    ; GameCommand #$1A: display "rejected" tile strip
    ; tile $0328 at col 1, row $09, width $14, height $0A, count $02 -- rejection animation tile
    pea     ($0328).w
    ; $0328 = rejection marker tile index
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0009).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    ; GameCommand #$18: play rejection sound/animation
    pea     ($0018).w
    jsr     (a3)
    lea     $20(a7), a7
    ; GameCommand #$1A: clear dialog area (blank pass)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
    ; GameCommand #$1A: clear dialog area (alternate fill pass)
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($001E).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    ; GameCmd16 #$39: clear sprite layer
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
    ; return code 2 = deal rejected
    moveq   #$2,d0
    bra.w   l_39dd4
; --- Up Button: Lower Offer Value ---
l_39c52:
    move.w  #$1, ($00FF13FC).l
    ; $FF13FC = input_mode_flag: set to 1
    subq.w  #$5, d2
    ; d2 -= 5: decrease offer by 5 percentage points per press
    ; --- Recompute adjusted offer score (a4): score * (d2-50) / 100 + base_score ---
    ; Formula: new_offer = base_score + base_score * (d2 - 50) / 100
    ; This scales the offer relative to the compatibility midpoint
    move.w  (a5), d0
    ; d0 = (a5) = base compatibility score
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    ; d1 = d2 - 50 (signed offset from neutral)
    jsr Multiply32
    ; d0 = base_score * (d2 - 50)
    moveq   #$64,d1
    jsr SignedDiv
    ; d0 = base_score * (d2 - 50) / 100 = proportional adjustment
    add.w   (a5), d0
    ; d0 = base_score + adjustment = new adjusted offer score
    move.w  d0, (a4)
    ; (a4) = -$8(a6) = updated adjusted offer score
    ; --- Clamp adjusted offer to floor: max(floor, base_score/2) ---
    ; Floor is computed as: if base_score >= 0: base_score >> 1, else (base_score+1) >> 1
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c84
    addq.l  #$1, d0
    ; +1 before shift for correct rounding of negative values
l_39c84:
    asr.l   #$1, d0
    ; d0 = floor = base_score / 2 (arithmetic right shift)
    move.w  (a4), d1
    ext.l   d1
    cmp.l   d1, d0
    ; compare floor with new adjusted offer
    bge.b   l_39c94
    ; floor >= new offer: use the new offer (no clamping needed)
l_39c8e:
    move.w  (a4), d0
    ; d0 = current adjusted offer (already below floor? use it as-is)
l_39c90:
    ext.l   d0
    bra.b   l_39c9e
l_39c94:
    ; floor < new offer: clamp to floor value
    move.w  (a5), d0
    ext.l   d0
    bge.b   l_39c9c
    addq.l  #$1, d0
l_39c9c:
    asr.l   #$1, d0
    ; d0 = floor (base_score / 2)
l_39c9e:
    move.w  d0, (a4)
    ; (a4) = clamped adjusted offer score
    bra.w   l_39b08
    ; return to loop tail (3-frame wait then restart)
; --- Down Button: Raise Offer Value ---
l_39ca4:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$5, d2
    ; d2 += 5: increase offer by 5 percentage points per press
    ; Same adjustment formula as Down handler: base_score * (d2-50) / 100 + base_score
    move.w  (a5), d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    ; d1 = d2 - 50 (now positive or larger positive value)
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   (a5), d0
    move.w  d0, (a4)
    ; (a4) = new adjusted offer (higher than before)
    ; Clamp to ceiling: -$6(a6) = maximum offer cap (scaled from compatibility at entry)
    cmp.w   -$6(a6), d0
    blt.b   l_39c8e
    ; if new offer < cap: use new offer (no clamping)
    move.w  -$6(a6), d0
    ; d0 = cap value (upper limit from CalcCompatScore * 100/150)
    bra.b   l_39c90
    ; l_39c90: write clamped value to (a4) and continue
; --- Start Button: Browse Partners During Negotiation ---
l_39cda:
    clr.w   ($00FF13FC).l
    ; Clear input mode flag before browsing
    ; Verify match slots are valid before launching browse
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_39b08
    ; CheckMatchSlots != 1 = no valid partners; skip browse, loop back
    ; BrowsePartners: launch full interactive partner browser
    moveq   #$0,d0
    move.b  $1(a2), d0
    ; a2[+$01] = partner character type
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ; a2[+$00] = self character type
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    ; BrowsePartners: interactive full-screen partner selection
    ; GameCommand #$1A: clear partner browser area ($12 wide, $1E tall)
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    ; GameCommand #$1A: clear offer area to restore dialog bg ($0F×$0F region)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($000F).w
    pea     ($000F).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    ; ShowDialog: redisplay the negotiation dialog after returning from browse
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($0004860A).l, -(a7)
    ; $4860A = negotiation dialog descriptor table pointer
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $30(a7), a7
    ; Reprint the match slot availability message
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    ; PollAction: wait for input confirmation (mode 1, 3-frame timeout)
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    ; GameCommand #$1A: clear the expanded browse region ($06×$1C at col 2)
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $28(a7), a7
    ; Restore full-screen text window
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  #$1, -$c(a6)
    ; -$c(a6) = 1: reset "first display" flag so offer text reprints on next frame
    bra.w   l_39b08
    ; return to loop tail to restart
; --- No Relevant Button: Idle ---
l_39dc4:
    clr.w   ($00FF13FC).l
    ; $FF13FC = input_mode_flag: clear
    clr.w   ($00FFA7D8).l
    ; $FFA7D8 = input_init_flag: clear
    bra.w   l_39b08
    ; return to loop tail (3-frame wait, restart)
; --- Epilogue ---
l_39dd4:
    ; Restore callee-saved registers and return to caller
    movem.l -$34(a6), d2-d7/a2-a5
    unlk    a6
    rts
