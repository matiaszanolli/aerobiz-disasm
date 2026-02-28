; ============================================================================
; UpdateCharDisplayS2 -- Displays the purchase confirmation UI for a character slot: renders the char portrait and score panel, calls ReadCharInput for user input, deducts the total cost from the player's funds on confirm, updates the char age/salary record, and refreshes the panel
; 686 bytes | $02E8D8-$02EB85
;
; Args:
;   $8(a6)  = d5: player index (0-3)
;   $c(a6)  = d4: char slot index within player's event_records entry
;
; Registers set up in prologue:
;   a4 = -$2(a6): local word holding transaction count / confirmation flag
;   a5 = -$52(a6): local 82-byte string work buffer (for sprintf)
;
; Key RAM:
;   $FFB9E8 = event_records base. Index: player*$20 + slot*2.
;             Byte +$1 of entry = d6 (used as "salary base" for cost calc).
;   $FF0018 = player_records base. Stride $24 per player.
;             Field +$06 (long) = player.cash (treasury balance).
;
; ReadCharInput return bits:
;   bit $20 = B-button confirm (purchase)
;   bit $10 = back / cancel
; ============================================================================
UpdateCharDisplayS2:
    link    a6,#-$54
    movem.l d2-d6/a2-a5, -(a7)
    ; --- Phase: Load arguments ---
    move.l  $c(a6), d4                              ; d4 = char slot index
    move.l  $8(a6), d5                              ; d5 = player index
    lea     -$2(a6), a4                             ; a4 -> local confirmation/count word
    lea     -$52(a6), a5                            ; a5 -> local string buffer (82 bytes)
    ; --- Phase: Index into event_records for (player, slot) ---
    ; event_records[$FFB9E8]: stride $20 per player, $2 per slot
    move.w  d5, d0
    lsl.w   #$5, d0                                 ; player * $20
    move.w  d4, d1
    add.w   d1, d1                                  ; slot * 2
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0                          ; event_records base
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = event_records entry for (player, slot)
    ; --- Initialise transaction count to 1 ---
    move.w  #$1, (a4)                               ; (a4) = count = 1 (initial purchase qty)
    moveq   #$0,d6
    move.b  $1(a2), d6                              ; d6 = event_records[+$1] (salary/cost base)
    ; --- Compute char score via CalcCharScore ---
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)                               ; push slot index as arg
    jsr (CalcCharScore,PC)                          ; d0 = char score (unit cost)
    nop
    move.w  d0, d3                                  ; d3 = unit_cost (char score)
    ; --- Index into player_records for this player ---
    ; player_records[$FF0018]: stride $24 per player
    move.w  d5, d0
    mulu.w  #$24, d0                                ; player * $24
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                                  ; a3 = player record base
    ; --- Phase: Clear two tile zones for the confirmation UI ---
    ; First ClearTileArea: clears the score/cost panel region (priority $8000, plane A)
    move.l  #$8000, -(a7)                           ; priority bit
    pea     ($0011).w                               ; height = $11 = 17
    pea     ($0020).w                               ; width = $20 = 32
    pea     ($000A).w                               ; y = 10
    clr.l   -(a7)
    pea     ($0001).w                               ; x = 1
    pea     ($001A).w                               ; GameCommand #$1A = ClearTileArea
    jsr GameCommand
    lea     $20(a7), a7
    ; Second ClearTileArea: clears the same area (plane B / no priority)
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)                                   ; x = 0 (second plane clear)
    pea     ($001A).w
    jsr GameCommand
    ; --- Phase: Draw the dialog box frame ---
    pea     ($000A).w                               ; box height = $A = 10
    pea     ($0010).w                               ; box width = $10 = 16
    pea     ($000A).w                               ; box y = 10
    pea     ($0001).w                               ; box x = 1
    jsr DrawBox
    lea     $2c(a7), a7
    ; --- Phase: Display character portrait ---
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    pea     ($0007).w                               ; y position = 7
    clr.l   -(a7)                                   ; x = 0
    pea     ($000B).w                               ; palette = $B
    pea     ($0002).w                               ; arg = 2
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)                               ; char slot index
    jsr ShowCharPortrait                            ; decompress + place portrait LZ graphic
    lea     $18(a7), a7
    ; =========================================================================
    ; Main loop: show score panel, wait for input, handle confirm/cancel
    ; =========================================================================
.l2e9b4:
    ; --- Format score value into string buffer ---
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)                               ; unit_cost value
    move.l  ($000484CE).l, -(a7)                   ; format string pointer (score format)
    move.l  a5, -(a7)                               ; output buffer
    jsr sprintf
    ; --- Show score panel (ShowCharInfoPageS2): display formatted score, 3 blank lines ---
    clr.l   -(a7)                                   ; arg = 0
    clr.l   -(a7)                                   ; arg = 0
    clr.l   -(a7)                                   ; arg = 0
    move.l  a5, -(a7)                               ; formatted score string
    pea     ($000B).w                               ; panel line = $B = 11
    jsr (ShowCharInfoPageS2,PC)                     ; render info panel at row $B
    nop
    lea     $20(a7), a7
    ; --- Call ReadCharInput to get player input ---
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)                               ; unit_cost
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)                               ; salary base from event_records[+$1]
    pea     -$2(a6)                                 ; push pointer to count word (a4)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)                               ; char slot
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    jsr (ReadCharInput,PC)                          ; read joypad; returns status bits in d0
    nop
    lea     $14(a7), a7
    move.w  d0, d2                                  ; d2 = raw input result word
    andi.w  #$20, d0                                ; test bit $20 = B-button confirm
    beq.w   .l2eb6e                                 ; not pressed -> check cancel
    ; =========================================================================
    ; B-button pressed: show quantity confirmation panel
    ; =========================================================================
    ; Compute total cost = count * unit_cost via Multiply32
    moveq   #$0,d0
    move.w  (a4), d0                                ; d0 = count (from local word)
    moveq   #$0,d1
    move.w  d3, d1                                  ; d1 = unit_cost
    jsr Multiply32                                  ; d0 = count * unit_cost (total cost)
    move.l  d0, -(a7)                               ; push total cost for sprintf
    moveq   #$0,d0
    move.w  (a4), d0                                ; count again
    move.l  d0, -(a7)
    move.l  ($000484D2).l, -(a7)                   ; format string (cost confirmation fmt)
    move.l  a5, -(a7)
    jsr sprintf                                     ; format "Count x Cost = Total"
    ; --- Show confirmation panel with total cost ---
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)                     ; render confirmation panel
    nop
    lea     $24(a7), a7
    move.w  d0, d2                                  ; d2 = ShowCharInfoPageS2 result (user choice)
    cmpi.w  #$1, d2                                 ; user confirmed (result == 1)?
    bne.w   .l2eb64                                 ; no -> check other result values
    ; =========================================================================
    ; User confirmed purchase: deduct cost and update records
    ; =========================================================================
    ; First clear the UI zone where result will be displayed
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand                                 ; ClearTileArea for result display zone
    lea     $1c(a7), a7
    ; --- Deduct total cost from player.cash ---
    moveq   #$0,d0
    move.w  (a4), d0                                ; count
    moveq   #$0,d1
    move.w  d3, d1                                  ; unit_cost
    jsr Multiply32                                  ; d0 = total cost
    add.l   d0, $6(a3)                              ; player_record[+$06] (cash) += total_cost
                                                    ; NOTE: adding positive value here -- cost is
                                                    ; represented as negative or this is income? TBD.
    ; --- Update event_record counters (age/contract fields) ---
    move.b  $1(a4), d0                              ; high byte of count word = delta value
    sub.b   d0, (a2)                                ; event_records[+$0] -= delta
    move.b  $1(a4), d0
    sub.b   d0, $1(a2)                              ; event_records[+$1] -= delta
    ; --- Clear the confirmation panel area ---
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand                                 ; ClearTileArea (plane B)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand                                 ; ClearTileArea (plane A)
    ; --- Refresh char panel display after purchase ---
    pea     ($0040).w                               ; GameCommand arg
    clr.l   -(a7)
    pea     ($0010).w                               ; GameCommand #$10
    jsr GameCommand
    pea     ($0003).w                               ; RefreshCharPanel arg
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    jsr (RefreshCharPanel,PC)                       ; refresh the panel for this player
    nop
    lea     $30(a7), a7
    ; --- Select string for quantity indicator (1 vs 2+) ---
    moveq   #$0,d0
    move.w  (a4), d0                                ; count
    subq.l  #$1, d0                                 ; count - 1
    beq.b   .l2eb14                                 ; count == 1 -> singular string
    pea     ($000446D2).l                           ; plural format string
    bra.b   .l2eb1a
.l2eb14:
    pea     ($000446D0).l                           ; singular format string
.l2eb1a:
    ; --- Look up a category string based on char slot index ---
    movea.l  #$00FF1278,a0                          ; character type lookup table ($FF1278)
    move.b  (a0,d4.w), d0                           ; fetch category byte for this slot
    andi.l  #$ff, d0
    lsl.w   #$2, d0                                 ; * 4 = longword index
    movea.l  #$0005ECFC,a0                          ; category string pointer table
    move.l  (a0,d0.w), -(a7)                        ; push category name string
    moveq   #$0,d0
    move.w  (a4), d0                                ; count
    move.l  d0, -(a7)
    move.l  ($000484D6).l, -(a7)                   ; format string (result panel fmt)
    move.l  a5, -(a7)
    jsr sprintf                                     ; format result message
    ; --- Show final result panel ---
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($000B).w
    jsr (ShowCharInfoPageS2,PC)                     ; display purchase result
    nop
    lea     $28(a7), a7
    bra.b   .l2eb7a                                 ; -> epilogue
.l2eb64:
    ; --- ShowCharInfoPageS2 returned value != 1: loop back or stay ---
    tst.w   d2                                      ; result == 0?
    bne.w   .l2e9b4                                 ; non-zero -> re-enter main display loop
    bra.w   .l2e9b4                                 ; zero -> also re-enter (wait for input)
.l2eb6e:
    ; --- Bit $20 not set: check bit $10 (cancel/back button) ---
    move.w  d2, d0
    andi.w  #$10, d0                                ; test bit $10 = cancel
    beq.w   .l2e9b4                                 ; neither confirm nor cancel -> loop
    clr.w   (a4)                                    ; count = 0 (signal cancellation)
.l2eb7a:
    move.w  (a4), d0                                ; return count (0 = cancelled, 1+ = confirmed)
    movem.l -$78(a6), d2-d6/a2-a5
    unlk    a6
    rts
