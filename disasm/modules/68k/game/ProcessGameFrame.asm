; ============================================================================
; ProcessGameFrame -- Displays the end-of-turn/end-of-game summary for a player: branches on the player state byte ($22: $63=won, $62=bankrupt, $61=special) to show sprintf-formatted outcome messages, then shows profitable-route count and total character value if applicable
; 564 bytes | $02FD90-$02FFC3
; ============================================================================
; Arg: $8(a6) = player_index (d5)
; a4 = ShowText ($02FBD6) -- cached function pointer for all text display calls
; a5 = $00047C40 -- ROM table of format string longword pointers for this function
;   a5+$00: pointer to default/fallback format string
;   a5+$04: pointer to bankrupt format string
;   a5+$08: pointer to winner player_name argument? (indexed by player)
;   a5+$0C: pointer to bankrupt outcome string
;   a5+$10: pointer to special format string (arg, uses player name sub-field)
;   a5+$14: pointer to special secondary format string
;   a5+$18: pointer to special tertiary format string
;   a5+$1C: pointer to route summary format string
;   a5+$20: pointer to character productivity format string
;   a5+$24: pointer to profitable-route count format string (plural)
;   a5+$28: pointer to total character value format string
ProcessGameFrame:
    link    a6,#-$A0               ; $A0 = 160 bytes of local scratch (a3 = text buffer)
    movem.l d2-d6/a2-a5, -(a7)
    ; --- Phase: Setup ---
    move.l  $8(a6), d5              ; d5 = player_index (arg)
    lea     -$a0(a6), a3            ; a3 = local text buffer (160 bytes in frame)
    movea.l  #$0002FBD6,a4          ; a4 = ShowText: display formatted text string
    movea.l  #$00047C40,a5          ; a5 = format string pointer table base
    ; Compute player record offset: player_index * $24 (36 bytes/record)
    ; d0 = player_index * (8+1) * 4 = player_index * 36
    move.w  d5, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0                 ; d0 = player_index * 8
    add.l   d1, d0                  ; d0 = player_index * 9
    lsl.l   #$2, d0                 ; d0 = player_index * 36 = player_index * $24
    move.l  d0, d6                  ; d6 = player record byte offset (saved for later use)
    movea.l  #$00FF0018,a0          ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a2                  ; a2 = &player_record[player_index]
    ; --- Phase: Dispatch on player outcome code (byte at +$22 = approval/state) ---
    moveq   #$0,d0
    move.b  $22(a2), d0             ; d0 = player_record[+$22]: outcome/approval byte
    moveq   #$63,d1                 ; $63 = 99 decimal = win condition code
    cmp.b   d1, d0
    beq.b   l_2fde2                 ; outcome == $63 -> player won
    moveq   #$62,d1                 ; $62 = 98 decimal = bankruptcy condition code
    cmp.b   d1, d0
    beq.b   l_2fe1c                 ; outcome == $62 -> player bankrupt
    moveq   #$61,d1                 ; $61 = 97 decimal = special event condition
    cmp.b   d1, d0
    beq.b   l_2fe3c                 ; outcome == $61 -> special event path
    bra.w   l_2fe86                 ; otherwise -> default/fallback message
l_2fde2:
    ; --- Phase: Win path ($63) -- show victory message with player name ---
    pea     ($0002).w               ; ShowText mode 2 (center display)
    move.l  ($00047C40).l, -(a7)    ; push ROM string pointer for win title
    pea     ($0004).w               ; ShowText mode 4 (player name lookup)
    move.w  d5, d0
    move.l  d0, -(a7)               ; push player_index for name lookup
    jsr     (a4)                    ; ShowText(player_index, 4): show player name
    ; Format win message using player name from $FF00A8[player_index * $10]
    move.w  d5, d0
    lsl.w   #$4, d0                 ; d0 = player_index * $10 (16 bytes per player name slot)
    movea.l  #$00FF00A8,a0          ; $FF00A8 = unknown block (likely player name buffer)
    pea     (a0, d0.w)              ; push pointer to this player's name string
    move.l  $8(a5), -(a7)           ; push win message format string
    move.l  a3, -(a7)               ; push output buffer
    jsr sprintf                     ; sprintf(buf, fmt, player_name)
    lea     $1c(a7), a7             ; clean up 7 args (pea + 3 + 3 for sprintf)
    pea     ($0002).w               ; ShowText mode 2
    move.l  a3, -(a7)               ; push formatted win message
    bra.b   l_2fe90                 ; -> common ShowText+route summary tail
l_2fe1c:
    ; --- Phase: Bankrupt path ($62) -- show bankruptcy message ---
    pea     ($0002).w               ; ShowText mode 2
    move.l  $4(a5), -(a7)           ; push bankruptcy title string pointer
    pea     ($0004).w               ; ShowText mode 4
    move.w  d5, d0
    move.l  d0, -(a7)               ; push player_index
    jsr     (a4)                    ; ShowText: show player name
    lea     $10(a7), a7             ; clean up 4 args
    pea     ($0002).w               ; ShowText mode 2
    move.l  $c(a5), -(a7)           ; push bankrupt outcome message string
    bra.b   l_2fe90                 ; -> tail
l_2fe3c:
    ; --- Phase: Special event path ($61) -- show 3-part special message ---
    ; First, format a player-name-parameterized string
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0          ; player name buffer
    pea     (a0, d0.w)              ; push player name pointer
    move.l  $10(a5), -(a7)          ; push special format string 1
    move.l  a3, -(a7)               ; output buffer
    jsr sprintf                     ; sprintf(buf, special_fmt1, player_name)
    ; Display formatted string + player name header
    pea     ($0002).w
    move.l  a3, -(a7)               ; push formatted string
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText(player_index, 4) -- player name header
    ; Second special string (no param)
    pea     ($0002).w
    move.l  $14(a5), -(a7)          ; push special format string 2
    pea     ($0004).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText
    lea     $2c(a7), a7             ; clean up 11 args
    pea     ($0002).w
    move.l  $18(a5), -(a7)          ; push special format string 3
    bra.b   l_2fe90                 ; -> common tail
l_2fe86:
    ; --- Phase: Default/fallback path -- show generic end-of-turn message ---
    pea     ($0002).w
    move.l  ($00047C40).l, -(a7)    ; push default format string (same as a5+$00)
l_2fe90:
    ; --- Phase: Common tail -- display primary text + route summary ---
    pea     ($0004).w               ; ShowText mode 4 (player name)
    move.w  d5, d0
    move.l  d0, -(a7)               ; player_index
    jsr     (a4)                    ; ShowText: player name
    ; Format route summary string
    move.l  $1c(a5), -(a7)          ; route summary format string
    move.l  a3, -(a7)               ; output buffer
    jsr sprintf                     ; sprintf(buf, route_summary_fmt)
    ; Display route summary
    clr.l   -(a7)                   ; arg = 0 (no param)
    move.l  a3, -(a7)               ; formatted summary string
    clr.l   -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText
    ; Sum player stat array ($FFB9E8[player*32]) for productivity display
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr SumPlayerStats              ; sum 16 bytes from event_records for player -> d0
    lea     $2c(a7), a7
    tst.w   d0
    ble.b   l_2ff2a                 ; sum == 0 -> skip productivity display
    ; --- Phase: Compute and display character productivity score ---
    moveq   #$0,d3                  ; d3 = productivity accumulator (long)
    clr.w   d2                      ; d2 = stat slot index (0..15)
l_2fec8:
    ; For each of 16 stat slots: score += CalcCharScore(d2) * weight[d2]
    move.w  d5, d0
    lsl.w   #$5, d0                 ; d0 = player_index * 32
    move.w  d2, d1
    add.w   d1, d1                  ; d1 = slot_index * 2 (stride 2 in event_records)
    add.w   d1, d0                  ; d0 = player_index*32 + slot_index*2
    movea.l  #$00FFB9E9,a0          ; event_records base + 1 (odd byte = weight/importance)
    move.b  (a0,d0.w), d4           ; d4 = importance weight for this stat slot
    andi.l  #$ff, d4
    ; CalcCharScore(d2): quarter-scaled score for character slot d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcCharScore               ; -> d0 = score for this slot
    addq.l  #$4, a7
    andi.l  #$ffff, d0              ; zero-extend to long
    moveq   #$0,d1
    move.w  d4, d1                  ; d1 = importance weight
    jsr Multiply32                  ; d0 = score * weight (32-bit)
    add.l   d0, d3                  ; accumulate into d3
    addq.w  #$1, d2
    cmpi.w  #$10, d2                ; processed all 16 slots?
    blt.b   l_2fec8
    ; Display total productivity score
    move.l  d3, -(a7)               ; push total score
    move.l  $20(a5), -(a7)          ; push productivity format string
    move.l  a3, -(a7)               ; output buffer
    jsr sprintf                     ; sprintf(buf, prod_fmt, total_score)
    clr.l   -(a7)
    move.l  a3, -(a7)               ; formatted productivity string
    pea     ($0002).w
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText(player_index, 2, buf)
    lea     $1c(a7), a7
l_2ff2a:
    ; --- Phase: Show profitable-route count if player has any routes ---
    movea.l  #$00FF0018,a0
    lea     (a0,d6.w), a2           ; a2 = player_record (use d6 saved offset)
    moveq   #$0,d0
    move.b  $4(a2), d0              ; d0 = player_record.domestic_slots
    moveq   #$0,d1
    move.b  $5(a2), d1              ; d1 = player_record.intl_slots
    add.w   d1, d0                  ; d0 = total route slots
    ble.b   l_2ff8e                 ; no routes -> skip
    ; Count profitable relations for this player
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CountProfitableRelations    ; count $FF9A20 relations where revenue > cost
    addq.l  #$4, a7
    move.w  d0, d2                  ; d2 = profitable route count
    tst.w   d2
    ble.b   l_2ff8e                 ; 0 profitable routes -> skip
    ; Choose singular ("1 route") or plural ("N routes") format string
    cmpi.w  #$1, d2
    bne.b   l_2ff64
    pea     ($00044762).l           ; singular: "1 profitable route"
    bra.b   l_2ff6a
l_2ff64:
    pea     ($0004475A).l           ; plural: "%d profitable routes"
l_2ff6a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)               ; push count
    move.l  $24(a5), -(a7)          ; push profitable-route format string
    move.l  a3, -(a7)               ; output buffer
    jsr sprintf                     ; sprintf(buf, fmt, count)
    clr.l   -(a7)
    move.l  a3, -(a7)               ; formatted string
    pea     ($0001).w               ; ShowText mode 1
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText
    lea     $20(a7), a7
l_2ff8e:
    ; --- Phase: Show total character value if nonzero ---
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcTotalCharValue          ; sum character values across all slots -> d0
    addq.l  #$4, a7
    move.l  d0, d2                  ; d2 = total char value
    beq.b   l_2ffba                 ; zero -> skip display
    move.l  d2, -(a7)               ; push total char value
    move.l  $28(a5), -(a7)          ; push char value format string
    move.l  a3, -(a7)               ; output buffer
    jsr sprintf                     ; sprintf(buf, fmt, total_value)
    clr.l   -(a7)
    move.l  a3, -(a7)               ; formatted string
    pea     ($0003).w               ; ShowText mode 3
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr     (a4)                    ; ShowText
l_2ffba:
    movem.l -$c4(a6), d2-d6/a2-a5
    unlk    a6
    rts


; === Translated block $02FFC4-$030000 ===
; 1 functions, 60 bytes
