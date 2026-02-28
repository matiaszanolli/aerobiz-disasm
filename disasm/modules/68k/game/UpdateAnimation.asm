; ============================================================================
; UpdateAnimation -- Renders the animation bar chart for a city slot: computes the peak traffic value across all active player/city combinations, then scales each player's bar height by dividing total traffic by a year-difficulty factor and renders each bar as a tile column via TilePlacement and GameCommand, printing the numeric value and a row icon alongside.
; 534 bytes | $01F13C-$01F351
; ============================================================================
; Arg: $28(a7) = city_slot_index (d6, pushed before call with no link frame)
; Returns: nothing (renders bar chart directly to VDP)
UpdateAnimation:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d6             ; d6 = city_slot_index (arg)
    movea.l  #$00FF0002,a4          ; a4 = $FF0002: scenario/year difficulty word
    ; --- Phase: Guard -- only run if flight_active is set ---
    cmpi.w  #$1, ($00FF000A).l      ; flight_active ($FF000A): nonzero = route operation active
    bne.w   l_1f34c                 ; not active -> skip entire bar chart render
    ; --- Phase: Find peak traffic value across all player/city combinations ---
    clr.w   d5                      ; d5 = running max traffic value
    cmpi.w  #$7, d6                 ; city_slot_index >= 7?
    bcc.b   l_1f1a6                 ; >= 7 -> use route slot frequency sum path
    ; --- Path A: city_slot_index < 7 -- scan via BitFieldSearch ---
    clr.w   d3                      ; d3 = player index (0..3)
l_1f160:
    ; BitFieldSearch(d6=city_slot, d3=player) -> d0 = bit position found
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; arg: city_slot_index
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)               ; arg: player_index
    jsr BitFieldSearch              ; scan $FFA6A0 bitfield for city_slot bit
    addq.l  #$8, a7
    move.w  d0, d2                  ; d2 = bit position found (>=$20 = not found)
    cmpi.w  #$20, d2
    bcc.b   l_1f19c                 ; >= $20 -> no match for this player -> skip
    ; Look up traffic value in city_data ($FFBA80): stride 8 per city, offset 2 per player
    ; Index: city_bit_pos*8 + player*2
    move.w  d2, d0
    lsl.w   #$3, d0                 ; d0 = bit_pos * 8
    move.w  d3, d1
    add.w   d1, d1                  ; d1 = player * 2
    add.w   d1, d0                  ; d0 = city_bit_pos*8 + player*2
    movea.l  #$00FFBA81,a0          ; city_data + 1: byte at odd stride within city entry
    move.b  (a0,d0.w), d4           ; d4 = traffic/demand value for this city+player
    andi.l  #$ff, d4
    cmp.w   d5, d4                  ; new max?
    bls.b   l_1f19c                 ; d4 <= d5 -> no update
    move.w  d4, d5                  ; d5 = new peak traffic
l_1f19c:
    addq.w  #$1, d3                 ; next player
    cmpi.w  #$4, d3                 ; all 4 players done?
    bcs.b   l_1f160
    bra.b   l_1f1f4                 ; -> difficulty scaling
l_1f1a6:
    ; --- Path B: city_slot_index >= 7 -- sum route slot frequency per player ---
    movea.l  #$00FF0018,a3          ; a3 = player_records base
    clr.w   d3                      ; d3 = player index (0..3)
l_1f1ae:
    clr.w   d4                      ; d4 = frequency accumulator for this player
    ; Point a2 at this player's route slot 0
    move.w  d3, d0
    mulu.w  #$320, d0               ; d0 = player_index * $320 (800 bytes)
    movea.l  #$00FF9A20,a0          ; route_slots base
    lea     (a0,d0.w), a0
    movea.l a0, a2                  ; a2 = player's first route slot
    clr.w   d2                      ; d2 = slot counter
    bra.b   l_1f1d4
l_1f1c6:
    ; Sum frequency from each slot's +$3 byte
    moveq   #$0,d0
    move.b  $3(a2), d0              ; route_slot[+3] = frequency (0..$0E)
    add.w   d0, d4                  ; accumulate total frequency
    moveq   #$14,d0
    adda.l  d0, a2                  ; next slot (+$14 = 20 bytes)
    addq.w  #$1, d2
l_1f1d4:
    ; Loop: d2 < player_record.domestic_slots
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1              ; player_record[+4] = domestic_slots count
    cmp.l   d1, d0
    blt.b   l_1f1c6
    cmp.w   d5, d4                  ; new max frequency sum?
    bls.b   l_1f1e8
    move.w  d4, d5                  ; d5 = new peak
l_1f1e8:
    moveq   #$24,d0
    adda.l  d0, a3                  ; advance to next player record (+$24)
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_1f1ae                 ; < 4 players -> continue
l_1f1f4:
    ; --- Phase: Map difficulty year to divisor d2 ---
    ; $FF0002 = scenario difficulty/year index
    tst.w   (a4)                    ; year == 0?
    bne.b   l_1f200
    move.l  #$c0, d2                ; year 0: divisor = $C0 = 192
    bra.b   l_1f222
l_1f200:
    cmpi.w  #$1, (a4)               ; year == 1?
    bne.b   l_1f20e
    move.l  #$190, d2               ; year 1: divisor = $190 = 400
    bra.b   l_1f222
l_1f20e:
    cmpi.w  #$2, (a4)               ; year == 2?
    bne.b   l_1f21c
    move.l  #$1a0, d2               ; year 2: divisor = $1A0 = 416
    bra.b   l_1f222
l_1f21c:
    move.l  #$320, d2               ; year >= 3: divisor = $320 = 800
l_1f222:
    ; --- Phase: Compute bar scale factor = (peak_traffic * 12) * divisor ---
    ; d0 = peak_traffic * 3 * 4 = peak_traffic * 12
    moveq   #$0,d0
    move.w  d5, d0                  ; d0 = peak_traffic (d5)
    move.l  d0, d1
    add.l   d0, d0                  ; d0 = peak*2
    add.l   d1, d0                  ; d0 = peak*3
    lsl.l   #$2, d0                 ; d0 = peak*12
    move.l  d2, d1                  ; d1 = year divisor
    jsr Multiply32                  ; d0 = peak*12 * divisor (32-bit multiply)
    move.l  d0, d4                  ; d4 = scale denominator
    ; Clamp d4 to minimum 1 (avoid divide by zero)
    moveq   #$1,d0
    cmp.l   d4, d0
    bcc.b   l_1f242                 ; 1 >= d4 -> use 1
    move.l  d4, d0                  ; d0 = d4
    bra.b   l_1f244
l_1f242:
    moveq   #$1,d0                  ; clamp to 1
l_1f244:
    move.l  d0, d4                  ; d4 = clamped scale denominator
    ; --- Phase: Set text window for bar chart display ---
    pea     ($001B).w               ; height = $1B rows
    pea     ($0020).w               ; width = $20 columns
    clr.l   -(a7)                   ; top = 0
    clr.l   -(a7)                   ; left = 0
    jsr SetTextWindow               ; define display region
    lea     $10(a7), a7
    ; --- Phase: Initialize per-player rendering loop ---
    clr.w   d3                      ; d3 = player index (0..3)
    ; Compute a2 = pointer into $FF01B0 stat block for player 0 + city slot
    ; $FF01B0 is an 128-byte block (stride-$20 per player, +city*4 column offset)
    move.w  d3, d0
    lsl.w   #$5, d0                 ; d0 = player * $20 (32 bytes per player row)
    move.w  d6, d1
    lsl.w   #$2, d1                 ; d1 = city_slot * 4
    add.w   d1, d0
    movea.l  #$00FF01B0,a0          ; $FF01B0 = unknown block (per-player stat data)
    lea     (a0,d0.w), a0
    movea.l a0, a2                  ; a2 = stat entry for player 0, city d6
    ; d5 = column X position for player 0: player*5+5
    moveq   #$0,d5
    move.w  d3, d5                  ; d5 = player (0)
    move.l  d5, d0
    lsl.l   #$2, d5                 ; d5 = player*4
    add.l   d0, d5                  ; d5 = player*5
    addq.l  #$5, d5                 ; d5 = player*5+5 = text column X
    ; d7 = pixel X position for bar column: player*(4+1)*8 + $18 = player*40+24
    moveq   #$0,d7
    move.w  d3, d7
    move.l  d7, d0
    lsl.l   #$2, d7                 ; d7 = player*4
    add.l   d0, d7                  ; d7 = player*5
    lsl.l   #$3, d7                 ; d7 = player*40
    addi.l  #$18, d7                ; d7 = player*40+24 = pixel X column
l_1f292:
    ; --- Phase: Compute bar height for this player ---
    ; bar_height = (stat_value * 12) / d4, then clamped to [$0, $A0], offset by $40
    move.l  (a2), d0                ; d0 = stat value (longword from $FF01B0)
    ; scale: d0 * 12 = d0 * 5 * 4 * ... = (d0 * (4+1)) * 4 * 3
    move.l  d0, d1
    lsl.l   #$2, d0                 ; d0 = val * 4
    add.l   d1, d0                  ; d0 = val * 5
    lsl.l   #$2, d0                 ; d0 = val * 20
    lsl.l   #$3, d0                 ; d0 = val * 160
    move.l  d4, d1                  ; d1 = scale denominator
    jsr UnsignedDivide              ; d0 = (val*160) / d4 (unsigned 32/32)
    move.w  d0, d2                  ; d2 = raw bar height
    ; Clamp to max $A0 (160 pixels)
    cmpi.w  #$a0, d2
    bcc.b   l_1f2b4
    moveq   #$0,d0
    move.w  d2, d0                  ; d0 = bar height (in range)
    bra.b   l_1f2ba
l_1f2b4:
    move.l  #$a0, d0                ; cap at $A0 = 160
l_1f2ba:
    addi.w  #$40, d0                ; add $40 baseline offset (top of bar area)
    move.w  d0, d2                  ; d2 = final tile Y position for bar top
    move.w  d7, d6                  ; d6 = pixel X (from d7)
    ; TilePlacement: draw vertical bar column
    ; Args: tile_char, col_idx (d3+$3B), bar_height (d2), tile_width=2, tile_count=2, priority=$8000
    move.l  #$8000, -(a7)           ; priority word = $8000 (high priority)
    pea     ($0002).w               ; tile width = 2
    pea     ($0002).w               ; tile height/count = 2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)               ; X pixel position (column)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)               ; Y position (bar height, clamped)
    moveq   #$0,d0
    move.w  d3, d0
    addi.l  #$3b, d0                ; tile char = player + $3B (bar tile base index)
    move.l  d0, -(a7)
    pea     ($0750).w               ; VRAM tile pattern address $0750
    jsr TilePlacement               ; place bar tile block
    pea     ($0002).w               ; GameCommand #2 arg
    pea     ($000E).w               ; GameCommand #$E = flush display update
    jsr GameCommand                 ; commit tile placement
    ; --- Phase: Print numeric value and icon ---
    move.l  d5, -(a7)               ; cursor X column
    pea     ($0013).w               ; cursor Y row = $13 = 19 (below bar area)
    jsr SetTextCursor               ; position text cursor for numeric label
    lea     $2c(a7), a7             ; clean up TilePlacement args ($7 x 4 = $1C) + GameCmd ($8) + SetTextCursor ($8)
    move.l  (a2), -(a7)             ; stat value (numeric)
    pea     ($000411F2).l           ; format string: "%d" (decimal number)
    jsr PrintfNarrow                ; print value label below bar
    ; Place row icon to the right of the label
    move.w  d5, d0
    move.l  d0, -(a7)               ; icon X position
    pea     ($001D).w               ; icon Y row = $1D = 29
    pea     ($0001).w               ; icon count = 1
    pea     ($0001).w               ; icon type = 1
    jsr PlaceIconTiles              ; place player/city icon tile
    lea     $18(a7), a7             ; clean up 6 args
    ; --- Phase: Advance loop variables ---
    moveq   #$28,d0
    add.l   d0, d7                  ; d7 += $28 (advance pixel X by 40 per player column)
    addq.l  #$5, d5                 ; d5 += 5 (advance text cursor X by 5)
    moveq   #$20,d0
    adda.l  d0, a2                  ; a2 += $20 (next player's stat row, 32 bytes)
    addq.w  #$1, d3                 ; d3++ (next player)
    cmpi.w  #$4, d3                 ; all 4 players rendered?
    bcs.w   l_1f292                 ; no -> next player
l_1f34c:
    movem.l (a7)+, d2-d7/a2-a4
    rts
