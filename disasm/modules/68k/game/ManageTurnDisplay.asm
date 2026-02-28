; ============================================================================
; ManageTurnDisplay -- Iterates pending turn-display events per player (state=5), loads city/char resource, draws facility-level summary box with turn counter dialog, clears the event slot when done
; 640 bytes | $02ADEC-$02B06B
;
; Arg:
;   $8(a6) = d5: player index (0-3)
;
; Registers set up in prologue:
;   a3 = player_records[$FF0018 + player*$24] -- player record for this player
;   a2 = player event/slot table [$FF0338 + player*$20] -- 4 slots, stride $8
;
; Key RAM:
;   $FF0018 = player_records base. Stride $24. +$0 = active_flag byte.
;   $FF0338 = player event/slot table. Stride $20 per player, $8 per slot.
;             Slot bytes: +$0=city_code, +$1=state, +$2=facility_level, +$3=countdown,
;                         +$4/$5=word field (cleared at end).
;   $FF0420 = domestic char assignment table (city < $20).
;             Indexed: city*4 + subtype (writes player index d5).
;   $FF1704 = domestic char lookup table base.
;   $FF0460 = alliance char assignment table (city >= $20).
;             Indexed: city*4 + subtype (writes player index d5).
;   $FF15A0 = alliance char lookup table base.
;   $FF9A1C = screen_id: current screen index (compared with region to avoid redundant load).
;
; Key ROM tables:
;   $5E680  = char name/string pointer table, indexed char_type*4.
;   $5E2A2  = facility-type string pointer table, indexed facility_level*4.
;   $483CC  = dialog string pointer table, indexed facility_category*4 (d4).
;   $424AC/$424AE = singular/plural "turn" format string.
;   $424B2  = turn dialog format string.
;   $424C9  = facility label string.
;
; Facility level -> category mapping (d2 -> d4):
;   d2 < 3          -> d4 = 0
;   3 <= d2 < 6     -> d4 = 1
;   6 <= d2 < $A    -> d4 = 0 (falls back -- NOTE: unusual)
;   $A <= d2 < $D   -> d4 = 2
;   d2 == $D        -> d4 = 3
;   d2 > $D         -> d4 = 4
; ============================================================================
ManageTurnDisplay:
    link    a6,#-$80
    movem.l d2-d7/a2-a3, -(a7)
    ; --- Phase: Load arg and set up base pointers ---
    move.l  $8(a6), d5                              ; d5 = player index
    ; Index into player_records: stride $24 per player
    move.w  d5, d0
    mulu.w  #$24, d0                                ; player * $24
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                                  ; a3 = player record ($FF0018 + player*$24)
    ; Index into $FF0338 event/slot table: stride $20 per player
    move.w  d5, d0
    lsl.w   #$5, d0                                 ; player * $20
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = player's slot block (4 slots x $8 bytes)
    clr.w   d6                                      ; d6 = slot loop counter (0..3)
    ; =========================================================================
    ; Main loop: iterate 4 event slots for this player
    ; =========================================================================
.l2ae1c:
    ; --- Check slot state byte: must equal 5 to process ---
    moveq   #$0,d0
    move.b  $1(a2), d0                              ; slot +$1 = state byte
    cmpi.w  #$5, d0                                 ; state == 5 (pending turn display)?
    bne.w   .l2b056                                 ; no -> advance to next slot
    ; --- Decrement countdown and skip if not yet zero ---
    subq.b  #$1, $3(a2)                             ; slot +$3 = countdown timer; decrement
    tst.b   $3(a2)
    bne.w   .l2b056                                 ; countdown not zero -> not ready yet
    ; --- Countdown reached zero: read city code and facility sub-index ---
    moveq   #$0,d3
    move.b  (a2), d3                                ; d3 = city_code (slot +$0)
    moveq   #$0,d2
    move.b  $2(a2), d2                              ; d2 = facility_level (slot +$2)
    ; --- Branch: city < $20 = domestic, city >= $20 = alliance ---
    cmpi.w  #$20, d3                                ; domestic city?
    bcc.b   .l2ae6c                                 ; carry clear -> >= $20 (alliance path)
    ; --- Domestic path: compute slot index as city*4 + facility_level ---
    ; Write player index into $FF0420 assignment table
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0                                  ; city * 2
    add.l   d1, d0                                  ; city * 3
    add.l   d0, d0                                  ; city * 4 (stride 4 per city)
    move.l  d0, d7                                  ; d7 = city * 4 (base index)
    add.w   d2, d0                                  ; + facility_level (subtype)
    movea.l  #$00FF0420,a0                          ; domestic char assignment table
    move.b  d5, (a0,d0.w)                           ; write player index to slot
    ; Resolve char lookup index from $FF1704
    move.w  d7, d0
    add.w   d2, d0
    movea.l  #$00FF1704,a0                          ; domestic char lookup table
    bra.b   .l2ae88
.l2ae6c:
    ; --- Alliance path: city >= $20, index as city*4 + facility_level ---
    move.w  d3, d0
    lsl.w   #$2, d0                                 ; city * 4
    add.w   d2, d0                                  ; + facility_level
    movea.l  #$00FF0460,a0                          ; alliance char assignment table
    move.b  d5, (a0,d0.w)                           ; write player index to slot
    move.w  d3, d0
    lsl.w   #$2, d0
    add.w   d2, d0
    movea.l  #$00FF15A0,a0                          ; alliance char lookup table
.l2ae88:
    ; --- Fetch facility level value from the appropriate lookup table ---
    move.b  (a0,d0.w), d0                           ; d0 = facility level from table
    andi.l  #$ff, d0
    move.w  d0, d2                                  ; d2 = resolved facility level
    ; --- Initialise the char record for this city slot ---
    pea     ($0001).w                               ; InitCharRecord mode = 1
    move.w  d3, d0
    move.l  d0, -(a7)                               ; city_code
    jsr InitCharRecord                              ; initialise char stat record for city d3
    addq.l  #$8, a7
    ; --- If player is active (active_flag == 1), check region and load screen ---
    cmpi.b  #$1, (a3)                              ; player_record[+$0] = active_flag
    bne.w   .l2b044                                 ; not active -> skip screen load
    ; Map city_code to region index
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup                                 ; d0 = region index (0-7) for this city
    addq.l  #$4, a7
    cmp.w   ($00FF9A1C).l, d0                       ; screen_id == region? (already correct screen?)
    beq.b   .l2aef4                                 ; yes -> skip redundant screen load
    ; Load the region-specific map screen
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr RangeLookup                                 ; get region index again for LoadScreen arg
    addq.l  #$4, a7
    ext.l   d0
    move.l  d0, -(a7)                               ; region index
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    jsr LoadScreen                                  ; load the region map for this city
    lea     $c(a7), a7
    jsr ResourceUnload
.l2aef4:
    ; --- Phase: Map facility level d2 to display category d4 ---
    ; Category drives which dialog string set is used.
    cmpi.w  #$3, d2                                 ; d2 < 3?
    bcc.b   .l2aefe
.l2aefa:
    clr.w   d4                                      ; d4 = category 0
    bra.b   .l2af24
.l2aefe:
    cmpi.w  #$6, d2                                 ; d2 < 6?
    bcc.b   .l2af08
    moveq   #$1,d4                                  ; d4 = category 1 (3 <= d2 < 6)
    bra.b   .l2af24
.l2af08:
    cmpi.w  #$a, d2                                 ; d2 < $A?
    bcs.b   .l2aefa                                 ; 6 <= d2 < $A -> fall back to category 0
    cmpi.w  #$d, d2                                 ; d2 < $D?
    bcc.b   .l2af18
    moveq   #$2,d4                                  ; d4 = category 2 ($A <= d2 < $D)
    bra.b   .l2af24
.l2af18:
    cmpi.w  #$d, d2                                 ; d2 == $D?
    bne.b   .l2af22
    moveq   #$3,d4                                  ; d4 = category 3
    bra.b   .l2af24
.l2af22:
    moveq   #$4,d4                                  ; d4 = category 4 (d2 > $D)
.l2af24:
    ; --- Phase: Select menu entry and draw dialog box ---
    clr.l   -(a7)
    pea     ($000E).w                               ; menu entry index $E = 14
    jsr MenuSelectEntry                             ; update menu selection to entry 14
    pea     ($0009).w                               ; box x = 9
    pea     ($000C).w                               ; box y = $C = 12
    pea     ($0007).w                               ; box width = 7
    pea     ($000A).w                               ; box height = $A = 10
    jsr DrawBox                                     ; draw bordered dialog box
    ; --- Print facility label string ---
    pea     ($000424C9).l                           ; facility label string
    jsr PrintfNarrow
    ; --- Phase: Show facility summary dialog (ShowFacilityMenu) ---
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)                               ; facility level d2
    jsr (ShowFacilityMenu,PC)                       ; render facility-level info panel
    nop
    lea     $20(a7), a7
    ; --- Phase: Build and display turn count dialog string ---
    ; Format: "<city_name> has <facility_type>. <count> turn(s) remain."
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0                          ; char name string pointer table
    move.l  (a0,d0.w), -(a7)                        ; push city/char name string
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0                          ; facility-type string pointer table
    move.l  (a0,d0.w), -(a7)                        ; push facility-type string
    ; Choose singular ("turn") vs plural ("turns") based on d2
    tst.w   d2                                      ; d2 == 0?
    beq.b   .l2af88
    cmpi.w  #$7, d2                                 ; d2 == 7?
    bne.b   .l2af90
.l2af88:
    pea     ($000424AE).l                           ; singular "turn" string
    bra.b   .l2af96
.l2af90:
    pea     ($000424AC).l                           ; plural "turns" string
.l2af96:
    pea     ($000424B2).l                           ; turn count format string
    pea     -$80(a6)                                ; local 128-byte string buffer
    jsr sprintf                                     ; format the full dialog string
    ; --- Phase: Show the formatted turn dialog via ShowTextDialog ---
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)                               ; slot index d6
    pea     -$80(a6)                                ; formatted string
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    jsr ShowTextDialog                              ; display the turn count dialog
    lea     $2c(a7), a7
    ; --- Phase: Show facility-category dialog (additional info from $483CC table) ---
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)                               ; slot index
    move.w  d4, d0
    lsl.w   #$2, d0                                 ; category * 4
    movea.l  #$000483CC,a0                          ; dialog string pointer table (by category)
    move.l  (a0,d0.w), -(a7)                        ; push dialog string for this facility category
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)                               ; player index
    jsr ShowTextDialog
    lea     $18(a7), a7
    ; --- Phase: Clear the dialog box area ---
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand                                 ; ClearTileArea: erase dialog box
    lea     $1c(a7), a7
    ; --- Phase: Also clear the main dialog box region ---
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($000C).w
    pea     ($0007).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand                                 ; ClearTileArea: erase facility box
    ; --- Advance menu selection by 7 ---
    pea     ($0007).w
    jsr SelectMenuItem
    lea     $20(a7), a7
.l2b044:
    ; --- Phase: Clear this event slot (zero all 6 bytes) ---
    clr.b   (a2)                                    ; slot +$0 = city_code = 0
    clr.b   $1(a2)                                  ; slot +$1 = state = 0
    clr.b   $2(a2)                                  ; slot +$2 = facility_level = 0
    clr.b   $3(a2)                                  ; slot +$3 = countdown = 0
    clr.w   $4(a2)                                  ; slot +$4/$5 = word field = 0
.l2b056:
    ; --- Advance to next slot ---
    addq.l  #$8, a2                                 ; next 8-byte slot entry
    addq.w  #$1, d6                                 ; slot counter++
    cmpi.w  #$4, d6                                 ; all 4 slots checked?
    bcs.w   .l2ae1c                                 ; not yet -> loop
    movem.l -$a0(a6), d2-d7/a2-a3
    unlk    a6
    rts
