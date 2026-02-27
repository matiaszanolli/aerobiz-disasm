; ============================================================================
; TransferCharacter -- Runs the character hire/transfer negotiation UI: shows the transfer screen with stat comparison, loops reading input (A to negotiate, B to cancel, up/down to scroll), checks salary cap and age limit conditions, shows result dialogs, and returns the hired slot index or $FF on cancel
; 1268 bytes | $02D40C-$02D8FF
;
; Args (via link frame, a6):
;   $8(a6)  = player_index          -- hiring player (0-3)
;   $c(a6)  = (unknown/padding)
;   $e(a6)  = candidate_char_index  -- char being evaluated for hire (d4)
;   $12(a6) = load_resources flag   -- 1 = load graphics; 0 = already loaded
;
; Frame locals:
;   -$2(a6) = max_char_index        -- upper bound for d4 scroll (wraps at -$2)
;   -$4(a6) = input_state           -- ProcessInputLoop result (button bits)
;   -$86(a6)= slot_result           -- FindCharSlotInGroup result
;   -$88(a6)= eligible_count        -- number of eligible chars in group
;   -$84(a6) through -$5(a6): sprintf text buffer (132 bytes, $84 = 132 decimal)
;
; Register map (after prologue):
;   a5 = $0004848A  -- ROM pointer table base (14 function pointers / dialog strings)
;   a4 = player record ($FF0018 + player*$24)
;   a2 = char slot entry ($FFA6B8 + candidate*$C)
;   a3 = event_records entry ($FFB9E8 + player*$20*2 + candidate*2)  [set later]
;   d5 = player_index
;   d4 = candidate_char_index (scrollable cursor)
;   d3 = char_type / group ID read from (a2)[+$00]
;   d2 = weighted stat score (CalcWeightedStat result)
;   d6 = animation frame counter for the "negotiating" pulse tiles
;   d7 = negotiation result flag: 0=pending, 1=blocked
;
; Returns (d0.w): hired char index, or $FF on cancel/failure
; ============================================================================
TransferCharacter:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)

; --- Phase: Prologue -- resolve player record and initial char-slot entry ---
    move.l  $8(a6), d5          ; d5 = player_index
    movea.l  #$0004848A,a5      ; a5 = ROM table base $0004848A (dialog string ptrs)
    ; Locate the player record: base $FF0018 + player*$24 (36 bytes/player)
    move.w  d5, d0
    mulu.w  #$24, d0            ; player_index * $24 = byte offset into player_records
    movea.l  #$00FF0018,a0      ; player_records base ($FF0018)
    lea     (a0,d0.w), a0
    movea.l a0, a4              ; a4 = player record for hiring player
    move.w  $e(a6), d4          ; d4 = candidate_char_index (from arg $E)
    ; Locate the char slot entry: base $FFA6B8 + candidate*$0C (12 bytes/entry).
    ; $FFA6B8 is within the bitfield_tab/aircraft region; stride $0C = char slot record.
    move.w  d4, d0
    mulu.w  #$c, d0             ; candidate * $0C (char slot stride)
    movea.l  #$00FFA6B8,a0      ; char_slot_base ($FFA6B8)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = char slot entry for candidate
    moveq   #$0,d3
    move.b  (a2), d3            ; d3 = char_type (group ID), char_slot[+$00]
    ; Load max_char_index: a word table at $FF880C indexed by char_type*2.
    ; This gives the upper bound for the scroll cursor (wraps at this value).
    move.w  d3, d0
    add.w   d0, d0              ; char_type * 2 (word stride)
    movea.l  #$00FF880C,a0      ; char_type_max_tab ($FF880C)
    move.w  (a0,d0.w), -$2(a6) ; frame var -$2 = max_char_index for this group

; --- Phase: Optional resource load (flag $12(a6) == 1) ---
    cmpi.w  #$1, $12(a6)
    bne.w   .l2d4ec             ; load_resources == 0 -> skip resource load

    ; Full resource load path: load graphics, run PreLoopInit, render initial screen.
    jsr ResourceLoad
    jsr PreLoopInit
    ; RenderCharTransfer(player_index, candidate, 1, 1): draw the transfer comparison
    ; screen with graphics loaded (mode 1 = full redraw).
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)           ; arg: candidate_char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)           ; arg: player_index
    jsr (RenderCharTransfer,PC)
    nop
    lea     $10(a7), a7
    jsr ResourceUnload

    ; Check salary cap: session_byte_a0 ($FF09A0) vs char_type (d3).
    ; $FF09A0 = session_byte_a0 -- stores the maximum allowed char_type for hire.
    ; If the candidate's char_type == session_byte_a0, they are already at the cap.
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0   ; session_byte_a0 = max hirable char_type
    moveq   #$0,d1
    move.w  d3, d1              ; d1 = candidate char_type
    cmp.l   d1, d0              ; is candidate AT the salary cap?
    bne.b   .l2d4c2             ; no -> show normal char info page

    ; Candidate is AT the cap: show "at capacity" info page (no text substitution).
    ; a5+$2C = 4th dialog string pointer (index 11 = "slot full" / capacity msg).
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $2c(a5), -(a7)      ; a5+$2C = dialog string ptr [index 11]
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)           ; char_type for page display
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    bra.b   .l2d506

.l2d4c2:
    ; Candidate is below the cap: format a salary/status string via sprintf and
    ; show a dialog page with the formatted text.
    ; a5+$10 = dialog format string pointer; $000484BA = format data long.
    move.l  $10(a5), -(a7)      ; a5+$10 = dialog string ptr (sprintf format)
    move.l  ($000484BA).l, -(a7) ; ROM format argument data at $000484BA
    pea     ($00044662).l        ; sprintf format string at ROM $00044662
    pea     -$84(a6)            ; output buffer: frame local -$84(a6) (132 bytes)
    jsr sprintf
    lea     $10(a7), a7
    ; Pass the formatted buffer as the dialog text for ShowCharInfoPageS2.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)            ; formatted text buffer
    bra.b   .l2d510

.l2d4ec:
    ; No resource load: just render the transfer screen with existing graphics.
    ; RenderCharTransfer(player_index, candidate, 0, 0): lightweight mode.
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)           ; candidate_char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)           ; player_index
    jsr (RenderCharTransfer,PC)
    nop
    lea     $10(a7), a7

.l2d506:
    ; Common path: set up args for ShowCharInfoPageS2 with default dialog string.
    ; a5+$10 = default "char info" string ptr.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $10(a5), -(a7)      ; a5+$10 = default dialog string ptr

.l2d510:
    ; ShowCharInfoPageS2(char_type, dialog_ptr, 0, 0, 0): render the character
    ; info page for the transfer candidate (right-side panel).
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)           ; char_type / group index
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7

; --- Phase: Count eligible chars in group (salary/cap pre-check) ---
    ; Scan all 16 ($10) char slots to count how many are eligible for this
    ; candidate's char_type (d3). The count is stored in frame var -$88(a6).
    ; A slot is eligible if: (a) its $FF17C8 flag word == 1 (slot active/available)
    ; AND (b) its char_type byte (FFA6B8 + slot*$C)[+$00] == d3 (same group).
    clr.w   d2                  ; d2 = slot index (0 to $F)
    clr.w   -$88(a6)            ; -$88(a6) = eligible_count = 0
    bra.b   .l2d55e
.l2d528:
    ; Check if slot d2 is active: $FF17C8 is a word array, entry = slot*2.
    move.w  d2, d0
    add.w   d0, d0              ; slot_index * 2 (word stride)
    movea.l  #$00FF17C8,a0      ; slot_active_tab ($FF17C8)
    cmpi.w  #$1, (a0,d0.w)     ; is this slot active (== 1)?
    bne.b   .l2d55c             ; no -> skip
    ; Check if the slot's char_type matches d3 (same group as candidate).
    move.w  d2, d0
    mulu.w  #$c, d0             ; slot * $0C
    movea.l  #$00FFA6B8,a0      ; char_slot_base
    move.b  (a0,d0.w), d0       ; char_slot[slot][+$00] = char_type
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1              ; d1 = candidate char_type
    cmp.l   d1, d0              ; same group?
    bne.b   .l2d55c             ; no -> skip
    addq.w  #$1, -$88(a6)      ; eligible_count++
.l2d55c:
    addq.w  #$1, d2
.l2d55e:
    cmpi.w  #$10, d2            ; scanned all 16 slots?
    bcs.b   .l2d528
    clr.w   d6                  ; d6 = animation frame counter = 0

; --- Phase: Main negotiation loop ---
; Each iteration: compute weighted stat, optionally render update, show pulse
; animation tiles if eligible_count > 1, then poll input.
.l2d566:
    ; GameCommand(4, $E): tick frame / advance animation state
    pea     ($0004).w
    pea     ($000E).w
    jsr GameCommand
    ; CalcWeightedStat(player_index, candidate): compute the hire offer value.
    ; Returns a signed word representing the quality/cost of this char for this player.
    move.w  d4, d0
    move.l  d0, -(a7)           ; candidate_char_index
    move.w  d5, d0
    move.l  d0, -(a7)           ; player_index
    jsr CalcWeightedStat
    lea     $10(a7), a7
    move.w  d0, d2              ; d2 = weighted_stat_score

    ; If session_byte_a0 ($FF09A0) == char_type (d3), apply the "at-cap" halving:
    ; the offer is halved (arithmetic right shift) because the player is already
    ; using a slot of this char_type. Signed rounding: if negative, add 1 before shift.
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0   ; session_byte_a0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1              ; char_type
    cmp.l   d1, d0              ; at cap?
    bne.b   .l2d5a6             ; no -> use full score
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2d5a2             ; d2 >= 0 -> skip rounding
    addq.l  #$1, d0             ; add 1 for signed right-shift rounding
.l2d5a2:
    asr.l   #$1, d0             ; halve: score /= 2 (arithmetic)
    move.w  d0, d2              ; d2 = halved score

.l2d5a6:
    ; Check if the current candidate (d4) has changed from the displayed candidate.
    ; $FF17C6 is a word that tracks which candidate was last rendered.
    cmp.w   ($00FF17C6).l, d4   ; same candidate as last render?
    beq.b   .l2d60e             ; yes -> skip re-render

    ; Candidate changed (user scrolled): reload the char slot entry and re-render.
    move.w  d4, d0
    mulu.w  #$c, d0             ; new candidate * $0C
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = new char slot entry
    moveq   #$0,d3
    move.b  (a2), d3            ; d3 = new candidate's char_type
    ; Recompute weighted stat for the new candidate.
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    move.w  d0, d2
    ; Apply cap-halving for the new candidate too.
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d5f2
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2d5ee
    addq.l  #$1, d0
.l2d5ee:
    asr.l   #$1, d0
    move.w  d0, d2
.l2d5f2:
    ; RenderCharTransfer(player_index, candidate, 1, 0): redraw comparison screen
    ; for the newly scrolled-to candidate (mode 1 = partial/quick refresh).
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)           ; new candidate_char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)           ; player_index
    jsr (RenderCharTransfer,PC)
    nop
    lea     $18(a7), a7

.l2d60e:
    ; --- Sub-phase: Negotiation pulse animation ---
    ; If eligible_count > 1, cycle a pair of "negotiating" tile overlays using
    ; TilePlacement at fixed screen positions. Tiles $0770/$0771 flash at rates
    ; controlled by d6 (frame counter):
    ;   d6 == 1:   place both tiles (start of pulse)
    ;   d6 == $64: GameCmd16 clear (mid-pulse, 100 frames)
    ;   d6 == $C8: reset d6 to 0 (end of 200-frame cycle)
    cmpi.w  #$1, -$88(a6)       ; eligible_count > 1?
    bls.w   .l2d6b0             ; no (0 or 1) -> skip animation, go to input
    addq.w  #$1, d6             ; d6++
    cmpi.w  #$1, d6
    bne.b   .l2d690             ; not frame 1 -> check mid/end cycle

    ; Frame 1 of cycle: place both pulse tiles.
    ; TilePlacement($0770, $39, $7C, $50, 1, 1, $8000): left pulse tile
    ; Tile $0770 = "negotiating" icon A; position ($50, $7C) = screen coords
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0050).w           ; y = $50
    pea     ($007C).w           ; x = $7C
    pea     ($0039).w
    pea     ($0770).w           ; tile ID $0770 = negotiation icon A
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    ; TilePlacement($0771, $3A, $7C, $98, 1, 1, $8000): right pulse tile
    ; Tile $0771 = "negotiating" icon B; position ($98, $7C) = screen coords
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w           ; y = $98
    pea     ($007C).w           ; x = $7C
    pea     ($003A).w
    pea     ($0771).w           ; tile ID $0771 = negotiation icon B
    jsr TilePlacement
    lea     $1c(a7), a7
.l2d67e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand             ; GameCommand($E, 1): commit tile update
    addq.l  #$8, a7
    bra.b   .l2d6b0

.l2d690:
    cmpi.w  #$64, d6            ; frame 100 of cycle?
    bne.b   .l2d6a8
    ; Mid-cycle (frame 100): clear the pulse tiles.
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16               ; GameCmd16(2,$39): clear tile area
    addq.l  #$8, a7
    bra.b   .l2d67e

.l2d6a8:
    cmpi.w  #$c8, d6            ; frame 200 of cycle?
    bne.b   .l2d6b0
    clr.w   d6                  ; reset cycle counter

; --- Phase: Input poll for negotiation ---
.l2d6b0:
    ; ProcessInputLoop(prev_state, $A): read joypad with repeat.
    ; The prior input state (-$4(a6)) is passed to handle auto-repeat.
    ; Returns button bits in d0; mask $33 = select only relevant buttons:
    ;   bit 0 ($01) = up, bit 1 ($02) = down, bit 4 ($10) = B, bit 5 ($20) = A
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w           ; repeat threshold = $A frames
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0            ; mask: up/down + A/B buttons ($01|$02|$10|$20)
    move.w  d0, -$4(a6)        ; save filtered input state
    andi.w  #$20, d0            ; test bit 5 = A button (confirm/negotiate)
    beq.w   .l2d822             ; A not pressed -> check B/direction

; --- Phase: A button pressed -- run negotiation checks ---
    ; A pressed: attempt to hire. Perform slot lookup then cascade of rejection checks.
    clr.w   d7                  ; d7 = negotiation result flag (0 = pending)
    ; FindCharSlotInGroup(player_index, candidate): find which hiring slot this
    ; char would fill. Returns slot index, or $5 if no slot is available.
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)           ; candidate_char_index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)           ; player_index
    jsr (FindCharSlotInGroup,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, -$86(a6)        ; -$86(a6) = slot_result (index or $5)

    ; Compute pointer into the char placement table ($FF02E8):
    ; address = $FF02E8 + player*$14*4 + slot*4
    move.w  d5, d0
    mulu.w  #$14, d0            ; player * $14 (20 entries per player)
    move.w  -$86(a6), d1
    lsl.w   #$2, d1             ; slot * 4 (longword stride)
    add.w   d1, d0
    movea.l  #$00FF02E8,a0      ; char placement table ($FF02E8)
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 = placement entry for this player+slot

    ; Compute pointer into event_records ($FFB9E8):
    ; address = $FFB9E8 + player*(32*2) + candidate*2
    ; event_records is 4 records * 32 bytes; stride-2 access (one live byte per pair).
    move.w  d5, d0
    lsl.w   #$5, d0             ; player * $20 (32 bytes per record)
    move.w  d4, d1
    add.w   d1, d1              ; candidate * 2 (stride-2)
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0      ; event_records base ($FFB9E8)
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 = event_records entry for this player+candidate

    ; --- Rejection check 1: no available slot (slot_result == $5) ---
    cmpi.w  #$5, -$86(a6)       ; slot_result == 5 means no slot found
    bne.b   .l2d734             ; slot available -> continue checks
    ; Reject: "no slot" dialog. a5+$14 = "no slot available" string ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $14(a5), -(a7)      ; a5+$14 = "no slot" dialog string ptr [index 5]
    bra.w   .l2d7c6             ; -> show rejection dialog

.l2d734:
    ; --- Rejection check 2: age limit (salary byte >= $A = 10) ---
    ; Placement entry [+$01] = salary/seniority byte. If >= 10, char is too senior.
    cmpi.b  #$a, $1(a2)         ; char_slot[+$01] = seniority >= $A?
    bcs.b   .l2d790             ; seniority < 10 -> pass age check
    ; Reject: "too senior" dialog. a5+$18 = "age limit" string ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $18(a5), -(a7)      ; a5+$18 = "too old/senior" dialog string ptr [index 6]
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)           ; char_type for page display
    jsr (ShowCharInfoPageS2,PC)
    nop
    ; Format aircraft name string for this char. $FF1278 byte[d4] = aircraft model
    ; index; AircraftModelPtrs ($05ECFC) maps model -> name string.
    movea.l  #$00FF1278,a0      ; aircraft_type_tab ($FF1278)
    move.b  (a0,d4.w), d0       ; aircraft type for candidate d4
    andi.l  #$ff, d0
    lsl.w   #$2, d0             ; * 4 (longword ptr stride)
    movea.l  #$0005ECFC,a0      ; AircraftModelPtrs ($05ECFC)
    move.l  (a0,d0.w), -(a7)    ; -> ptr to aircraft model name string
    move.l  $28(a5), -(a7)      ; a5+$28 = sprintf format string ptr [index 10]
    pea     -$84(a6)            ; output buffer (frame local, 132 bytes)
    jsr sprintf
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)            ; formatted string as dialog text
    bra.b   .l2d7c6

.l2d790:
    ; --- Rejection check 3: salary exceeds player cash ---
    ; d2 = weighted_stat_score (the negotiated salary cost).
    ; player_record[+$06] = cash (long). If cost > cash, reject.
    moveq   #$0,d0
    move.w  d2, d0              ; d0 = hire cost (salary)
    cmp.l   $6(a4), d0          ; player_record[+$06] = cash -- can afford?
    ble.b   .l2d7a8             ; cost <= cash -> pass salary check
    ; Reject: "insufficient funds" dialog. a5+$1C = "can't afford" string ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $1c(a5), -(a7)      ; a5+$1C = "insufficient funds" string ptr [index 7]
    bra.b   .l2d7c6

.l2d7a8:
    ; --- Rejection check 4: char slots already at cap (salary + seniority > $63) ---
    ; Sum: event_records[a3][+$00] (current slots used) + char_slot[a2][+$01] (seniority).
    ; If sum >= $63 (99 decimal), the player has hit the annual hire cap.
    moveq   #$0,d0
    move.b  (a3), d0            ; event_records[player+candidate] = current slots used
    moveq   #$0,d1
    move.b  $1(a2), d1          ; char_slot[+$01] = seniority cost
    add.l   d1, d0              ; total = slots_used + seniority
    moveq   #$63,d1             ; $63 = 99 (hire cap threshold)
    cmp.l   d0, d1              ; cap - total > 0 ?
    bgt.b   .l2d7d8             ; still under cap -> approve hire
    ; Reject: "over cap" dialog. a5+$20 = "at roster limit" string ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $20(a5), -(a7)      ; a5+$20 = "roster cap reached" string ptr [index 8]

.l2d7c6:
    ; Show rejection dialog: ShowCharInfoPageS2(char_type, dialog_ptr, 0, 0, 0)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)           ; char_type
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    moveq   #$1,d7              ; d7 = 1 -> negotiation blocked (reject)

.l2d7d8:
    ; If d7 == 1 (rejected), loop back to .l2d566 to re-poll input.
    ; d7 == 0 means hire was approved -> fall into DrawCharStatus path.
    cmpi.w  #$1, d7
    bne.b   .l2d7fc             ; d7 != 1 -> approved, proceed to status draw

.l2d7de:
    ; Rejection re-enter: show default char info page and return to negotiate.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $10(a5), -(a7)      ; a5+$10 = default dialog string ptr
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)           ; char_type
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    bra.w   .l2d566             ; back to negotiation loop

.l2d7fc:
    ; All checks passed. DrawCharStatus(candidate) -- render the "hire confirmed"
    ; status panel for the candidate.
    ; Returns: 1 = hire confirmed, 0 = loop again, other = cancel
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)           ; candidate_char_index
    jsr (DrawCharStatus,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, -$4(a6)        ; save DrawCharStatus result in -$4(a6)
    cmpi.w  #$1, -$4(a6)
    beq.w   .l2d8f4             ; result == 1 -> hire confirmed -> return d4
    tst.w   -$4(a6)
    bne.w   .l2d8e0             ; result != 0 (and != 1) -> cancel -> redo display
    bra.b   .l2d7de             ; result == 0 -> not resolved -> loop

; --- Phase: B button / direction -- B = cancel, up/down = scroll candidate ---
.l2d822:
    ; Check B button (bit 4 = $10 of filtered input in -$4(a6)).
    move.w  -$4(a6), d0
    andi.w  #$10, d0            ; bit 4 = B button
    beq.b   .l2d850             ; not B -> check direction

    ; B pressed: cancel the transfer entirely. Show "cancel" dialog and return $FF.
    ; a5+$24 = "transfer cancelled" string ptr.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $24(a5), -(a7)      ; a5+$24 = "transfer cancelled" dialog string ptr [index 9]
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)
    nop
    lea     $14(a7), a7
    move.w  #$ff, d4            ; return $FF = cancelled
    bra.w   .l2d8f4

.l2d850:
    ; Check direction: bit 0 = up ($01) in filtered input.
    move.w  -$4(a6), d0
    andi.w  #$1, d0             ; bit 0 = up direction
    beq.b   .l2d898             ; not up -> check down

    ; --- Sub-phase: Scroll up -- find previous valid candidate in same group ---
    ; Walk backward through candidate indices (wrapping at -$2(a6) = max_char_index).
    ; Skip any candidate whose char_type (FFA6B8 + idx*$C)[+$00] != d3, and skip
    ; those whose slot_active flag ($FF17C8 + idx*2) != 1.
.l2d85a:
    cmp.w   -$2(a6), d4         ; d4 == max_char_index?
    bne.b   .l2d864
    moveq   #$F,d4              ; wrap: max index wraps to 15 ($F)
    bra.b   .l2d866
.l2d864:
    subq.w  #$1, d4             ; d4-- (scroll up)
.l2d866:
    ; Check char_type of new d4 against d3 (must be same group).
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0       ; char_slot[d4][+$00] = char_type
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0              ; same group?
    bne.b   .l2d85a             ; no -> keep scrolling
    ; Check slot_active flag: $FF17C8[d4*2] must == 1.
    move.w  d4, d0
    add.w   d0, d0              ; d4 * 2
    movea.l  #$00FF17C8,a0
    cmpi.w  #$1, (a0,d0.w)     ; slot active?
    bne.b   .l2d85a             ; no -> keep scrolling
    bra.b   .l2d8e0             ; found valid candidate -> redo display

.l2d898:
    ; Check down direction: bit 1 ($02) of filtered input.
    move.w  -$4(a6), d0
    andi.w  #$2, d0             ; bit 1 = down direction
    beq.b   .l2d8e0             ; not down -> fall through to display refresh

    ; --- Sub-phase: Scroll down -- find next valid candidate in same group ---
.l2d8a2:
    cmpi.w  #$f, d4             ; d4 == 15?
    bne.b   .l2d8ae
    move.w  -$2(a6), d4        ; wrap: 15 wraps to min (max_char_index lower bound)
    bra.b   .l2d8b0
.l2d8ae:
    addq.w  #$1, d4             ; d4++ (scroll down)
.l2d8b0:
    ; Same group + active checks as scroll-up.
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    move.b  (a0,d0.w), d0       ; char_slot[d4][+$00] = char_type
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bne.b   .l2d8a2
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF17C8,a0
    cmpi.w  #$1, (a0,d0.w)
    bne.b   .l2d8a2

.l2d8e0:
    ; After any direction change: tick the display loop by calling GameCommand($E, 4).
    pea     ($0004).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l2d566             ; back to main negotiation loop

; --- Phase: Epilogue -- return hired candidate index or $FF ---
.l2d8f4:
    ; d4 holds either the hired candidate index (approved) or $FF (cancelled).
    move.w  d4, d0              ; return value = hired char index or $FF
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
