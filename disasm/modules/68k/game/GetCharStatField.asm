; ============================================================================
; GetCharStatField -- Interactive character stat browser; displays stats across relation slots with arrow-key navigation and page scrolling, returning the selected stat value.
; 710 bytes | $012B3E-$012E03
; ============================================================================
GetCharStatField:
; --- Phase: Setup ---
; Args: $8(a6)=player_index, $E(a6)=mode_flag (0=simple A/B wait, >=2=full direction nav)
; Returns: D0.W = selected relation slot index, or $20 if A-button confirm
; d2=current_slot_index (within player's 40 slots), d3=animation_counter
; d4=direction_flag (0=backward,1=forward), d5=player_index
; d6=last_raw_input, d7=first_draw_flag (1=initial draw pending)
; a2=current slot pointer, a3=player slot base, a4=last drawn slot pointer
; a5=GameCommand ($D64)
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5           ; d5 = player_index
    movea.l  #$00000D64,a5       ; a5 = GameCommand indirect call pointer

; --- Phase: Pre-Loop Init ---
    clr.w   d4                   ; d4 = direction_flag: 0=scroll backward, 1=forward
    moveq   #$1,d7               ; d7 = first_draw_flag (1 = initial panel draw pending)
    jsr PreLoopInit              ; one-time pre-loop setup (display/timer init)

; Compute base pointer into player's route slot array:
; route_slots($FF9A20) + player*$320; a2 = player's slot 0
    move.w  d5, d0
    mulu.w  #$320, d0            ; player offset: $320 (800) bytes per player
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 = base of player's route slots (slot 0)

; Sample current input to detect pre-held button
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l12b7e
    moveq   #$1,d0               ; button held: skip first wait tick
    bra.b   .l12b80
.l12b7e:
    moveq   #$0,d0               ; no button held
.l12b80:
    move.w  d0, -$2(a6)         ; -$2(a6) = "drain input" flag

    clr.w   d6                   ; d6 = last raw input bits (no prior input)
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0 (reset UI countdown state)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0 (reset input countdown)
    jsr ResourceLoad             ; load graphics resource for stat display
    moveq   #$0,d0
    movea.l d0, a4               ; a4 = last drawn slot pointer (NULL = not yet drawn)
    clr.w   d2                   ; d2 = current slot index within player array (0-39)
    clr.w   d3                   ; d3 = animation frame counter

; --- Phase: Main Loop Top - Resolve Current Slot Pointer ---
.l12ba0:
; Recompute player base pointer each iteration (defensive: player may not change)
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 = player slot base (slot 0 pointer)

; --- Phase: Find Next Valid Slot (skip pending/flagged slots) ---
; Walk d2 forward or backward until finding a slot with status_flags bit 7 ($80) set.
; Slots with bit 7 clear are "pending update" and should be skipped in the browser.
; Wrap d2 at bounds: 0..$27 (40 slots); a2 computed as a3 + d2*$14.
.l12bb2:
; Wrap-forward: if d2 >= $28 (40), reset to slot 0
    cmpi.w  #$28, d2
    blt.b   .l12bbc
    movea.l a3, a2               ; wrap: reset a2 to slot 0
    clr.w   d2                   ; d2 = 0
.l12bbc:
; Wrap-backward: if d2 < 0, reset to slot $27 (39)
    tst.w   d2
    bge.b   .l12bc8
    movea.l a3, a2
    lea     $30c(a2), a2         ; $30C = $27 * $14: offset to last slot (39 * 20)
    moveq   #$27,d2              ; d2 = 39 (last valid slot index)
.l12bc8:
; Check route_slot+$0A (status_flags): bit 7 ($80) must be set to show this slot
    move.b  $a(a2), d0
    btst    #$7, d0              ; bit 7 = slot is valid/established for display?
    bne.b   .l12be8              ; set: this slot is displayable, proceed

; Bit 7 clear: slot not displayable, advance in current direction
    cmpi.w  #$1, d4              ; direction_flag = 1 = forward?
    bne.b   .l12be0
    moveq   #$14,d0
    adda.l  d0, a2               ; advance a2 forward by one slot ($14 bytes)
    addq.w  #$1, d2
    bra.b   .l12bb2              ; re-check next slot
.l12be0:
    moveq   #$14,d0
    suba.l  d0, a2               ; step a2 backward by one slot
    subq.w  #$1, d2
    bra.b   .l12bb2

; --- Phase: Display Slot Panel ---
.l12be8:
; Only redraw if the slot pointer has changed (a2 != a4)
    cmpa.l  a2, a4               ; a4 = last drawn slot pointer
    beq.b   .l12c66              ; same slot: skip redraw

; Clear two tile areas to make room for the new panel (GameCommand #$1A = ClearTileArea)
; First clear: cols $D-$1E, rows 2-1 (top panel area), priority $8000
    move.l  #$8000, -(a7)
    pea     ($000D).w            ; width = $D columns
    pea     ($001E).w            ; height = $1E rows
    pea     ($0002).w            ; col = 2
    pea     ($0001).w            ; row = 1
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                 ; GameCommand #$1A: clear top tile region
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand #$E: display update
    lea     $24(a7), a7

; Second clear: same region + 1 extra row (col $1, variant region), priority $8000
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)                 ; GameCommand #$1A: clear overlapping region
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand #$E: display update
    lea     $24(a7), a7

; FormatRelationDisplay: format and draw the stat panel for the current slot
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    move.l  a2, -(a7)            ; current slot pointer
    jsr FormatRelationDisplay    ; draw stat field panel for this slot
    lea     $14(a7), a7
    movea.l a2, a4               ; update last-drawn pointer to current slot

; --- Phase: Initial Draw Gate (first pass only) ---
.l12c66:
; On first draw (d7==1): unload resource and show initial dialog before entering input loop
    cmpi.w  #$1, d7
    bne.b   .l12c90              ; not first draw: skip
    jsr ResourceUnload           ; release graphics resource after first render
; ShowDialog: display the initial context dialog (ROM string $3F268)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003F268).l        ; ROM pointer: dialog text for stat browser intro
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    jsr ShowDialog               ; show intro dialog; waits for A/B before continuing
    lea     $14(a7), a7
    clr.w   d7                   ; d7 = 0 (first draw complete, normal input mode now)

; --- Phase: Input Drain (if held from prior frame) ---
.l12c90:
    tst.w   -$2(a6)              ; drain-input flag set?
    beq.b   .l12ca6
    clr.l   -(a7)
    jsr ReadInput                ; drain one held-button sample
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l12ba0              ; still held: restart loop

; --- Phase: Mode Branch (simple vs full nav) ---
.l12ca6:
    clr.w   -$2(a6)
; $E(a6) mode_flag: < 2 = simple A/B-only mode; >= 2 = full direction navigation
    cmpi.w  #$2, $e(a6)
    bge.b   .l12cd6              ; mode >= 2: full navigation loop

; Simple mode: poll until A or B button pressed (bits $10/$20)
.l12cb2:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; wait up to 3 ticks for button press
    addq.l  #$8, a7
    andi.l  #$30, d0             ; mask: $20=A, $10=B
    beq.b   .l12cb2              ; neither pressed: keep waiting
; Both A ($20) and B ($10) cause exit in simple mode
    cmpi.w  #$20, d6             ; was A pressed?
    bne.w   .l12dfa              ; B: exit immediately
    bra.w   .l12dfa              ; A: also exit (same result in simple mode)

; --- Phase: Full Navigation Input Loop ---
.l12cd6:
; Animation sequencer: increment frame counter d3 to drive tile animation
    addq.w  #$1, d3
    cmpi.w  #$1, d3              ; first animation tick?
    bne.b   .l12d46
; d3==1: place first tile pair (tiles $770/$771 = left/right scroll indicators)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0008).w            ; width = 8
    pea     ($0078).w            ; height = $78
    pea     ($0039).w            ; row = $39
    pea     ($0770).w            ; tile $770 = left scroll indicator
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand #$E: display update
    lea     $24(a7), a7
; Second scroll indicator: tile $771 (right arrow), same dimensions
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0078).w
    pea     ($0078).w
    pea     ($003A).w            ; row = $3A
    pea     ($0771).w            ; tile $771 = right scroll indicator
    jsr TilePlacement
    lea     $1c(a7), a7
.l12d38:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand #$E: update display after placing tile
    addq.l  #$8, a7
    bra.b   .l12d66              ; proceed to input polling

.l12d46:
; d3==15: clear scroll indicator sprite (GameCmd16 mode 2, sprite $39)
    cmpi.w  #$f, d3
    bne.b   .l12d5e
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16                ; clear scroll indicator at sprite slot $39
    addq.l  #$8, a7
    bra.b   .l12d38

.l12d5e:
; d3==30: reset animation counter (30-frame animation cycle)
    cmpi.w  #$1e, d3
    bne.b   .l12d66
    clr.w   d3                   ; reset cycle counter

; --- Phase: Direction Input Dispatch ---
.l12d66:
; ProcessInputLoop: poll for $A frames; mask $33 = up/down/A/B bits
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0             ; $20=A, $10=B, $02=down, $01=up
    move.w  d0, d6               ; save raw bits for next cycle

    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l12d98              ; A button: confirm, return d2

    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l12daa              ; B button: cancel, return 0

    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   .l12dba              ; up: scroll backward to previous slot

    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   .l12dcc              ; down: scroll forward to next slot

    bra.b   .l12dde              ; no input: idle

; A button: confirm - return current slot index
.l12d98:
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
    moveq   #$1,d2               ; d2 = 1 (return value for A-confirm)
.l12da6:
    move.w  d2, d0               ; D0 = return value
    bra.b   .l12dfa

; B button: cancel - return 0
.l12daa:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2                   ; d2 = 0 (cancelled)
    bra.b   .l12da6

; Up: scroll backward (d4=0 = backward direction)
.l12dba:
    move.w  #$1, ($00FF13FC).l   ; input_mode_flag = 1 (activate countdown)
    clr.w   d4                   ; direction_flag = 0 (backward)
    moveq   #$14,d0
    suba.l  d0, a2               ; step a2 back by one slot ($14 bytes)
    subq.w  #$1, d2              ; decrement slot index
    bra.b   .l12dea

; Down: scroll forward (d4=1 = forward direction)
.l12dcc:
    move.w  #$1, ($00FF13FC).l   ; input_mode_flag = 1
    moveq   #$1,d4               ; direction_flag = 1 (forward)
    moveq   #$14,d0
    adda.l  d0, a2               ; advance a2 by one slot
    addq.w  #$1, d2              ; increment slot index
    bra.b   .l12dea

; No input: reset input countdown flags
.l12dde:
    clr.w   ($00FF13FC).l        ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0

.l12dea:
; GameCommand #$E mode 5: per-frame display tick (idle update)
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l12ba0              ; continue main loop

; --- Phase: Return ---
.l12dfa:
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
