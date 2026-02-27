; ============================================================================
; AddCharToTeam -- Adds a character to a player's team: shows the character profile panel and hire dialog with age/salary info, runs an input loop (up/down to browse slots, A to confirm, B to cancel), shows cost/rejection dialogs, and returns the assigned slot index
; 1138 bytes | $02E466-$02E8D7
; ============================================================================
; Register map (for the entire function):
;   d2  = current character slot index (0-$F; browsed with Up/Down)
;   d3  = animation tick counter (drives periodic sprite refresh)
;   d4  = team slot availability counter (number of occupied slots)
;   d5  = ProcessInputLoop state carry / button bitmask
;   d6  = player index (0-3), from caller arg $8(a6)
;   d7  = team-full flag (0 = team has an open slot, 1 = team is full)
;   a3  = $000484BA (ROM ptr to dialogue string block; offsets +$4,$8,$C,$10,$28,$2C)
;   a4  = $0002F34A (PrintfNarrow / 2-arg display formatter at $03B246)
;   a5  = $00000D64 (GameCommand dispatcher)
;   -$2(a6) = current_age: frame_counter / 4 + $37 (age threshold for hire)
;   -$82(a6) = 130-byte local sprintf output buffer
; ============================================================================
; Caller args (on stack above a6):
;   $8(a6) = player_index (long, low word used)
;   $A(a6) ... additional args accessed below
;   $E(a6) = initial character slot index (d2 on entry)
;   $12(a6) = display_mode flag (1 = first display, else refresh)
; ============================================================================
AddCharToTeam:
    link    a6,#-$84                ; frame: -$84 bytes local (-$2 = age, -$82 = fmt buf)
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6              ; d6 = player_index (0-3)
    movea.l  #$000484BA,a3          ; a3 -> dialogue string block in ROM at $484BA
    movea.l  #$0002F34A,a4          ; a4 -> PrintfNarrow ($03B246, 2-arg formatted print)
    movea.l  #$00000D64,a5          ; a5 -> GameCommand dispatcher ($0D64)

; --- Phase: Compute current age from frame counter ---
; Age is derived from frame_counter ($FF0006): age = (frame_counter / 4) + $37.
; The /4 converts from frames to "seasons" and $37 = 55 is the base age offset.
; Division is done with an arithmetic right shift after sign-correcting for
; negative values (sign extension to long, then +3 if negative to round toward 0).
    move.w  ($00FF0006).l, d0       ; d0 = frame_counter (word)
    ext.l   d0                      ; sign-extend to long (frame_counter is signed here)
    bge.b   .l2e490                 ; positive -> no rounding needed
    addq.l  #$3, d0                 ; negative: add 3 before shift to round toward zero
.l2e490:
    asr.l   #$2, d0                 ; d0 = frame_counter / 4 (arithmetic right shift)
    addi.w  #$37, d0                ; d0 = age = (frame_counter / 4) + 55
    move.w  d0, -$2(a6)             ; save age to link frame local variable

; --- Phase: Count occupied slots in event_records for this player ---
; event_records ($FFB9E8): 4 players * $20 (32) bytes, stride $20 per player.
; Each player has $10 (16) slots at stride 2 within their 32-byte record.
; A slot is occupied if its first byte (offset 0) is non-zero.
; d4 counts how many slots are occupied (needed to decide team-full flag d7).
    clr.w   d4                      ; d4 = occupied slot count
    clr.w   d2                      ; d2 = slot iterator (0..15)
.l2e49e:
; Compute byte offset into event_records for player d6, slot d2:
; offset = d6 * $20 + d2 * 2  (stride $20 per player, stride 2 per slot)
    move.w  d6, d0
    lsl.w   #$5, d0                 ; d0 = player_index * $20 (player stride in event_records)
    move.w  d2, d1
    add.w   d1, d1                  ; d1 = slot * 2 (stride 2 per slot entry)
    add.w   d1, d0                  ; d0 = total byte offset
    movea.l  #$00FFB9E8,a0          ; a0 -> event_records base ($FFB9E8)
    tst.b   (a0,d0.w)               ; is this slot's first byte non-zero? (occupied?)
    beq.b   .l2e4b6                 ; no -> skip count
    addq.w  #$1, d4                 ; yes -> increment occupied count
.l2e4b6:
    addq.w  #$1, d2
    cmpi.w  #$10, d2                ; iterated all 16 slots?
    bcs.b   .l2e49e

; --- Phase: Determine team-full flag ---
; d7 = 0 if team has more than 1 occupied slot (can accept new member),
; d7 = 1 if team has 0 or 1 occupied slot (team is "full" from a trade standpoint).
; Threshold is >1 occupied: if d4 > 1, team has room so d7=0; else d7=1.
    cmpi.w  #$1, d4
    bls.b   .l2e4c8                 ; d4 <= 1 -> team full (d7 = 1)
    moveq   #$0,d7                  ; d7 = 0: team has room for a new member
    bra.b   .l2e4ca
.l2e4c8:
    moveq   #$1,d7                  ; d7 = 1: team is full (no open trade slot)
.l2e4ca:

; --- Phase: Load initial character slot index ---
    move.w  $e(a6), d2              ; d2 = initial character slot index from caller

; --- Phase: First-display vs. refresh branch ---
; $12(a6) = display_mode: 1 = first time showing this character (ResourceLoad/PreLoopInit),
; else = returning from a navigation action (no reload needed, just redraw profile).
    cmpi.w  #$1, $12(a6)
    bne.b   .l2e546                 ; not first display -> skip resource load, go to refresh path

; ============================================================================
; --- Phase: First-time display setup ---
; Load resources, format the character name/age string, show the profile panel.
; ============================================================================
    jsr ResourceLoad                ; load display assets for character profile
    jsr PreLoopInit                 ; initialize the display loop state
    jsr ResourceUnload

; Build the hire dialog header string using sprintf.
; Format at $446CA: character name + age string (e.g. "JOHN SMITH  AGE: 25").
; Args to sprintf: output_buf, format_ptr, name_ptr, age_value.
;   $4(a3) = ptr to character name string within dialogue block
;   ($484BA).l = the dialogue block longword (loaded as name argument)
;   $446CA = format string for the name+age display
    move.l  $4(a3), -(a7)           ; arg4: name string ptr (dialogue block +$4)
    move.l  ($000484BA).l, -(a7)    ; arg3: dialogue block base (character data longword)
    pea     ($000446CA).l           ; arg2: format string "%-16s%2d" or similar
    pea     -$82(a6)                ; arg1: output buffer (local, -$82(a6), 130 bytes)
    jsr sprintf                     ; format: name_string -> local buffer
; Display the formatted string using PrintfNarrow via a4.
; a4 ($02F34A) = PrintfNarrow: takes cmd=$B, string_ptr, and 3 zero args.
    clr.l   -(a7)                   ; arg5: 0
    clr.l   -(a7)                   ; arg4: 0
    clr.l   -(a7)                   ; arg3: 0
    pea     -$82(a6)                ; arg2: formatted string buffer
    pea     ($000B).w               ; cmd: $B = print string
    jsr     (a4)                    ; PrintfNarrow: display formatted string
    lea     $24(a7), a7
; ShowCharProfile args: player_index=d6, char_slot=d2, display_mode=1, x=$A, y=$2
    pea     ($0002).w               ; y = 2 (tile row)
    pea     ($0001).w               ; x = 1 (tile col)
    pea     ($000A).w               ; display_mode: $A = full profile render
    pea     ($0001).w               ; flag = 1 (first display)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)               ; arg: char_slot index
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: player_index
    jsr ShowCharProfile             ; render the character portrait + stat panel
    lea     $18(a7), a7
    move.w  d2, ($00FF17C6).l       ; $FF17C6 = last-displayed char slot (dirty tracking)
    bra.w   .l2e5d0                 ; -> check for stat panel update

; ============================================================================
; --- Phase: Refresh-mode display setup (returning to profile after navigation) ---
; No resource reload needed; just set up the panel background and re-show profile.
; ============================================================================
.l2e546:
; GameCommand $1A: overlay/background panel (2 separate calls for two panel sections).
; First call: args = cmd=$1A, 0, 0, y=$A, w=$20, h=$E, attr=$8000
    move.l  #$8000, -(a7)           ; attr: $8000 = high-priority tile
    pea     ($000E).w               ; height = $E tiles
    pea     ($0020).w               ; width = $20 tiles (full width)
    pea     ($000A).w               ; y position = $A
    clr.l   -(a7)                   ; 0
    clr.l   -(a7)                   ; 0
    pea     ($001A).w               ; GameCommand $1A = draw overlay panel
    jsr     (a5)                    ; dispatch via GameCommand
    lea     $1c(a7), a7
; Second call: args = cmd=$1A, 1, 0, y=$A, w=$20, h=$E, attr=$8000
    move.l  #$8000, -(a7)
    pea     ($000E).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w               ; flag = 1 (second panel section)
    pea     ($001A).w               ; GameCommand $1A
    jsr     (a5)
; GameCommand $10: display/scroll mode reset.
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w               ; GameCommand $10 = display mode reset
    jsr     (a5)
    lea     $28(a7), a7
; ShowCharProfile (refresh): same args as first-time but using refresh mode.
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)               ; arg: char_slot index
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: player_index
    jsr ShowCharProfile
    move.w  d2, ($00FF17C6).l       ; update dirty-tracking slot word
; Display dialogue string header via PrintfNarrow ($02F34A).
; Args: cmd=$B, name_ptr=$4(a3), 0, 0, 0 (PrintfNarrow 2-arg form)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a3), -(a7)           ; ptr to character name string
    pea     ($000B).w               ; cmd: $B = print string
    jsr     (a4)                    ; PrintfNarrow
    lea     $2c(a7), a7

; ============================================================================
; --- Phase: Conditional stat panel update ---
; Only call ShowCharStats if the displayed slot changed (dirty check via $FF17C6).
; ============================================================================
.l2e5d0:
    cmp.w   ($00FF17C6).l, d2       ; current slot == last displayed slot?
    beq.b   .l2e600                 ; same -> skip ShowCharStats (no redraw needed)
; ShowCharStats args: player_index=d6, char_slot=d2, display_mode=1, y=2
    pea     ($0002).w               ; display_mode = 2
    pea     ($000A).w               ; y position = $A (tile row)
    pea     ($0001).w               ; x position = 1
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)               ; arg: char_slot
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: player_index
    jsr ShowCharStats               ; render the character stats panel
    lea     $14(a7), a7
    move.w  d2, ($00FF17C6).l       ; update dirty-tracking slot word

; ============================================================================
; --- Phase: Render hire dialog (text window + icon tiles + score) ---
; Draw the "hire?" confirmation text window at the bottom of the screen.
; ============================================================================
.l2e600:
; SetTextWindow args: w=$20, h=$20, x=0, y=0 (full-screen text window)
    pea     ($0020).w               ; width = $20
    pea     ($0020).w               ; height = $20
    clr.l   -(a7)                   ; x = 0
    clr.l   -(a7)                   ; y = 0
    jsr SetTextWindow
    pea     ($0014).w               ; cursor row = $14 (20)
    pea     ($001D).w               ; cursor col = $1D (29)
    jsr SetTextCursor
; PrintfWide: display the hire prompt string at $446C6 (e.g. "HIRE?")
    pea     ($0001).w               ; wide font flag = 1
    pea     ($000446C6).l           ; ptr to "HIRE?" prompt string
    jsr PrintfWide
; PlaceIconTiles args: y=$1E, x=$14, button_id=3, tile_base=2
; Draws the A-button icon graphic at the hire prompt position.
    pea     ($0014).w               ; x position for icon tile
    pea     ($001E).w               ; y position for icon tile
    pea     ($0002).w               ; tile_base
    pea     ($0003).w               ; button_id: 3 = A button icon
    jsr PlaceIconTiles
    lea     $30(a7), a7

; RefreshCharPanel: update the character info panel for player d6.
    pea     ($0004).w               ; display_mode = 4
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: player_index
    jsr (RefreshCharPanel,PC)
    nop
    addq.l  #$8, a7
    clr.w   d3                      ; d3 = animation tick counter (reset)

; ============================================================================
; --- Phase: Hire dialog input loop ---
; Each iteration: flush display, refresh stats if needed, compute and show
; character score, animate tile transitions, then call ProcessInputLoop to
; read a button press. Button dispatch:
;   $20 = A button: confirm hire
;   $10 = B button: cancel (return $FF)
;   $01 = Up: previous slot (wrap from 0 -> $F)
;   $02 = Down: next slot (wrap from $F -> 0)
; ============================================================================
.l2e65e:
; GameCommand $0E: display flush/sync.
    pea     ($0004).w
    pea     ($000E).w               ; GameCommand $0E = display update
    jsr     (a5)
    addq.l  #$8, a7
; Dirty check: redisplay char stats only if slot changed since last render.
    cmp.w   ($00FF17C6).l, d2
    beq.b   .l2e69a
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr ShowCharStats               ; redraw stats for newly browsed slot
    lea     $14(a7), a7
    move.w  d2, ($00FF17C6).l       ; update dirty-tracking slot

; --- Phase: Compute and display character score ---
; CalcCharScore returns a combined score for slot d2; shown in the hire dialog.
.l2e69a:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)               ; arg: char_slot index
    jsr (CalcCharScore,PC)          ; d0 = score (0-100 or similar)
    nop
    move.w  d0, d4                  ; d4 = character score
; Display the score value at text position (col=$13, row=$16) in a $20x$20 window.
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0016).w               ; row = $16
    pea     ($0013).w               ; col = $13
    jsr SetTextCursor
; PrintfWide: display score value using format at $446C0 (e.g. "%3d").
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)               ; arg: score value
    pea     ($000446C0).l           ; format: "%3d" or similar numeric format
    jsr PrintfWide
    lea     $24(a7), a7

; --- Phase: Periodic sprite refresh (team-full case only) ---
; If d7 == 0 (team has room), run a periodic tile animation on a counter.
; Counter d3 drives three events:
;   d3 == 1:   place "slot A" tile at ($50, $7C) and "slot B" tile at ($98, $7C)
;   d3 == $50: call GameCmd16(mode=$39, $2) to toggle slot graphics
;   d3 == $A0: reset counter to 0
    tst.w   d7                      ; d7 = 1 means team full (skip animation)
    bne.w   .l2e774                 ; team full -> skip tile animation, go to ProcessInputLoop
    addq.w  #$1, d3                 ; increment animation tick counter
    cmpi.w  #$1, d3
    bne.b   .l2e754                 ; not tick 1 -> check other thresholds
; Tick 1: place two slot indicator tiles (slot A and slot B visual feedback).
; TilePlacement args: tile_id=$0770, 0, x=$39, y=$7C, scale=1, scale=1, attr=$8000
    move.l  #$8000, -(a7)
    pea     ($0001).w               ; Y scale = 1
    pea     ($0001).w               ; X scale = 1
    pea     ($0050).w               ; Y pixel = $50
    pea     ($007C).w               ; X pixel = $7C
    pea     ($0039).w               ; sprite attribute
    pea     ($0770).w               ; tile_id $770 = slot A indicator tile
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w               ; flush display
    jsr     (a5)
    lea     $24(a7), a7
; Second slot indicator tile (slot B) at offset +$28 from A.
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w               ; Y pixel = $98 (second slot position)
    pea     ($007C).w               ; X pixel = $7C (same column)
    pea     ($003A).w               ; sprite attribute
    pea     ($0771).w               ; tile_id $771 = slot B indicator tile
    jsr TilePlacement
    lea     $1c(a7), a7
.l2e746:
    pea     ($0001).w
    pea     ($000E).w               ; flush display
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l2e774                 ; -> ProcessInputLoop

.l2e754:
    cmpi.w  #$50, d3                ; tick $50 (80 frames): toggle slot graphic mode
    bne.b   .l2e76c
; GameCmd16 args: mode=$39, param=$2 (toggle which graphic is shown for the slot)
    pea     ($0002).w
    pea     ($0039).w               ; mode = $39
    jsr GameCmd16                   ; update slot display graphic
    addq.l  #$8, a7
    bra.b   .l2e746

.l2e76c:
    cmpi.w  #$a0, d3                ; tick $A0 (160 frames): reset counter
    bne.b   .l2e774
    clr.w   d3                      ; d3 = 0 (restart animation cycle)

; --- Phase: Read player input via ProcessInputLoop ---
; ProcessInputLoop manages the input_mode countdown; returns a button bitmask.
; Mask with $33 = bits $20,$10,$02,$01 (A, B, Down, Up).
.l2e774:
    move.w  d5, d0
    move.l  d0, -(a7)               ; arg: previous ProcessInputLoop state (carry)
    pea     ($000A).w               ; timeout = $A (10 frames countdown)
    jsr ProcessInputLoop            ; d0 = accepted button bitmask
    addq.l  #$8, a7
    andi.w  #$33, d0                ; mask: keep $20(A), $10(B), $02(Down), $01(Up)
    move.w  d0, d5                  ; d5 = masked button state for this iteration
    andi.w  #$20, d0                ; A button pressed?
    beq.w   .l2e844                 ; no -> check other buttons

; ============================================================================
; --- Phase: A button -- confirm hire ---
; Check if the slot is available (event_records byte) and if the character
; passes the age eligibility check, then show the appropriate hire dialog.
; ============================================================================
; Compute event_records offset for player d6, slot d2 (same formula as above).
; Check BYTE +1 of the slot (FFB9E9 base): if zero, slot is unavailable.
    move.w  d6, d0
    lsl.w   #$5, d0                 ; d0 = player_index * $20
    move.w  d2, d1
    add.w   d1, d1                  ; d1 = slot * 2
    add.w   d1, d0                  ; d0 = offset
    movea.l  #$00FFB9E9,a0          ; $FFB9E9 = event_records + 1 (availability byte)
    tst.b   (a0,d0.w)               ; is slot availability byte non-zero?
    bne.b   .l2e7c0                 ; yes -> slot available, check age
; Slot unavailable: show "not available" dialogue string.
; Dialogue is from ROM data block at a3 ($484BA), offset +$28 (unavailable msg ptr).
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $28(a3), -(a7)          ; ptr to "slot unavailable" dialogue string
.l2e7b2:
    pea     ($000B).w               ; PrintfNarrow cmd $B = print string
    jsr     (a4)                    ; display the dialogue message
    lea     $14(a7), a7
    bra.w   .l2e65e                 ; -> back to hire dialog loop (no hire)

; --- Phase: Age eligibility check ---
; char stat record for slot d2 is at: $FFA6B8 + d2 * $C
;   +$6 = hire_date (start period / entry season for this character type)
;   +$7 = contract_expiry (age limit / expiry season)
; Check 1: current_age < hire_date -> character too young, show rejection.
; Check 2: current_age - hire_date >= 15 -> character too old, show different rejection.
; Check 3: within range -> show success hire dialog.
.l2e7c0:
    move.w  d2, d0
    mulu.w  #$c, d0                 ; d0 = d2 * $C (char record stride at $FFA6B8)
    movea.l  #$00FFA6B8,a0          ; a0 -> char type/skill descriptor table ($FFA6B8)
    lea     (a0,d0.w), a0           ; a0 -> char descriptor entry for slot d2
    movea.l a0, a2                  ; a2 = descriptor ptr (keep for field access)
    moveq   #$0,d0
    move.b  $7(a2), d0              ; d0 = contract_expiry byte (+$7: age limit)
    cmp.w   -$2(a6), d0             ; compare age_limit with current_age (-$2(a6))
    bcc.b   .l2e7ec                 ; age_limit >= current_age -> not too young, check upper bound
; Character is too young (current_age > age_limit): show "too young" rejection dialog.
; Dialogue at $10(a3) = "this character is not yet eligible" message ptr.
    clr.l   -(a7)
    pea     ($0001).w               ; flag = 1 (single message)
    clr.l   -(a7)
    move.l  $10(a3), -(a7)          ; ptr to "too young" rejection dialogue string
    bra.b   .l2e81c                 ; -> display rejection message

; --- Phase: Check if character is too old ---
; Compute age difference: current_age - hire_date (+$6).
; If difference >= 15 ($F), character is too old.
.l2e7ec:
    move.w  -$2(a6), d0             ; d0 = current_age
    ext.l   d0
    moveq   #$0,d1
    move.b  $6(a2), d1              ; d1 = hire_date (+$6: start period for this char type)
    ext.l   d1
    sub.l   d1, d0                  ; d0 = current_age - hire_date (age above minimum)
    moveq   #$F,d1
    cmp.l   d0, d1                  ; $F (15) < age_difference?
    bgt.b   .l2e810                 ; $F > diff -> within range -> show hire success dialog
; Age difference >= 15: character is too old.
; Dialogue at $C(a3) = "too old" rejection message ptr.
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  $c(a3), -(a7)           ; ptr to "too old" rejection dialogue string
    bra.b   .l2e81c                 ; -> display rejection message

; --- Phase: Age check passed -- show hire confirm dialog ---
; Dialogue at $8(a3) = normal hire/cost confirmation message ptr.
.l2e810:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  $8(a3), -(a7)           ; ptr to "confirm hire?" dialogue string (with cost)

; Display the dialogue via GameCommand and check response.
; GameCommand $0B = modal dialogue box (shows text, waits for button).
; Returns d0 = 0 (confirmed), 1 (rejected/B), or other.
.l2e81c:
    pea     ($000B).w               ; GameCommand $B = modal dialogue
    jsr     (a4)                    ; display dialogue and wait for button
    lea     $14(a7), a7
    move.w  d0, d5                  ; d5 = dialogue response (0=confirm, 1=reject, other)
    cmpi.w  #$1, d5
    beq.w   .l2e8cc                 ; response == 1 -> confirmed -> return slot d2 (hire)
    tst.w   d5
    bne.w   .l2e8bc                 ; response != 0 -> go to display flush and loop
; response == 0: player cancelled at cost dialog -> re-display profile and loop.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a3), -(a7)           ; ptr to name string (re-show character header)
    bra.w   .l2e7b2                 ; -> back to print-name + loop

; ============================================================================
; --- Phase: Non-A button dispatch ---
; ============================================================================
.l2e844:
; B button ($10): cancel -- return d2=$FF to caller to signal "no hire".
    move.w  d5, d0
    andi.w  #$10, d0                ; bit $10 = B button
    beq.b   .l2e868                 ; not B -> check navigation buttons
; Show cancel confirmation dialogue at $2C(a3) = "cancel hire?" message ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $2c(a3), -(a7)          ; ptr to "cancel hire" dialogue string
    pea     ($000B).w               ; GameCommand $B = modal dialogue
    jsr     (a4)
    lea     $14(a7), a7
    move.w  #$ff, d2                ; d2 = $FF = "cancelled" sentinel (no slot assigned)
    bra.b   .l2e8cc                 ; -> return d2 to caller

; Up button ($01): move to previous occupied slot (wrap from 0 -> $F).
.l2e868:
    move.w  d5, d0
    andi.w  #$1, d0                 ; bit $01 = Up D-pad
    beq.b   .l2e892                 ; not Up -> check Down

; --- Phase: Up -- scan backwards for the previous occupied slot ---
; Wraps from slot 0 to $F. Skips unoccupied slots (event_records byte == 0).
.l2e870:
    tst.w   d2
    bne.b   .l2e878
    moveq   #$F,d2                  ; wrap: slot 0 -> slot $F
    bra.b   .l2e87a
.l2e878:
    subq.w  #$1, d2                 ; decrement slot index
.l2e87a:
; Check if slot d2 is occupied (event_records first byte non-zero).
    move.w  d6, d0
    lsl.w   #$5, d0                 ; player_index * $20
    move.w  d2, d1
    add.w   d1, d1                  ; slot * 2
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0          ; $FFB9E8 = event_records base
    tst.b   (a0,d0.w)               ; occupied?
    beq.b   .l2e870                 ; no -> keep scanning backwards
    bra.b   .l2e8bc                 ; yes -> use this slot (redraw)

; Down button ($02): move to next occupied slot (wrap from $F -> 0).
.l2e892:
    move.w  d5, d0
    andi.w  #$2, d0                 ; bit $02 = Down D-pad
    beq.b   .l2e8bc                 ; not Down -> go to display flush and loop

; --- Phase: Down -- scan forward for the next occupied slot ---
; Wraps from slot $F to 0. Skips unoccupied slots.
.l2e89a:
    cmpi.w  #$f, d2
    bne.b   .l2e8a4
    clr.w   d2                      ; wrap: slot $F -> slot 0
    bra.b   .l2e8a6
.l2e8a4:
    addq.w  #$1, d2                 ; increment slot index
.l2e8a6:
; Check if slot d2 is occupied.
    move.w  d6, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    tst.b   (a0,d0.w)               ; occupied?
    beq.b   .l2e89a                 ; no -> keep scanning forward

; --- Phase: Display flush after navigation ---
; After Up/Down slot change, flush the display and loop back to redraw.
.l2e8bc:
    pea     ($0004).w
    pea     ($000E).w               ; GameCommand $0E = display update
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l2e65e                 ; -> back to top of hire dialog loop

; ============================================================================
; --- Phase: Epilogue -- return slot index to caller ---
; d2 = assigned slot index (0-$F), or $FF if hire was cancelled.
; ============================================================================
.l2e8cc:
    move.w  d2, d0                  ; d0 = return value (slot index or $FF)
    movem.l -$ac(a6), d2-d7/a2-a5  ; restore registers (from link frame)
    unlk    a6
    rts
