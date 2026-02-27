; ============================================================================
; HandlePlayerMenuInput -- Handles negotiation menu: shows stat bars, processes directional input, confirms char selection
; 2036 bytes | $038E94-$039687
;
; Parameters (pushed on stack, link frame):
;   $a(a6)  = player_index (word) -- the current player whose menu this is
;   $c(a6)  = route_slot ptr (long) -- pointer to the active route_slot struct
;
; Register conventions throughout:
;   a4 = route_slot ptr (copy of $c(a6))
;   a5 = GameCommand dispatcher ($000D64)
;   d4 = current selection cursor index (1-based, clamped to [1, service_quality])
;   d5 = max selectable slot count (service_quality, capped at $E = 14)
;   d6 = start-of-bar index in tile arrays (used for stat bar rendering)
;   d7 = end-of-bar index
;   -$40(a6) .. -$3E(a6) = left stat bar tile word array (up to 15 entries)
;   -$78(a6) .. -$76(a6) = right stat bar tile word array (up to 15 entries)
;   -$7a(a6) = city_a supply (demand value read from city_data[city_a][player].supply)
;   -$7c(a6) = city_b supply (demand value read from city_data[city_b][player].supply)
;   -$2(a6)  = input_ready flag (1 = skip input read this frame, 0 = poll input)
;   -$4(a6)  = last processed input button bitmask
; ============================================================================
HandlePlayerMenuInput:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4                  ; a4 = route_slot ptr
    movea.l  #$00000D64,a5              ; a5 = GameCommand dispatcher

; --- Phase: Show dialog header and check match slots ---
    ; Display the dialog box for this player's negotiation menu.
    ; $48606 = ptr to dialog format string. 5 longword args: 3 nulls + string ptr + player_index.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)        ; ptr to dialog header format string
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; player_index
    jsr ShowDialog
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots               ; check how many route slots can accept a match
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_38ee2                     ; zero match slots: skip match-available notice
    move.l  ($00048612).l, -(a7)        ; ptr to "match available" message
    jsr PrintfNarrow
    addq.l  #$4, a7
l_38ee2:
    pea     ($0020).w                   ; right window edge = 32
    pea     ($0020).w                   ; bottom window edge = 32
    clr.l   -(a7)                       ; left = 0
    clr.l   -(a7)                       ; top = 0
    jsr SetTextWindow

; --- Phase: Compute display bounds for stat bars ---
    ; d5 = min(route_slot.service_quality, $E = 14 max bar slots)
    cmpi.b  #$e, $b(a4)                ; route_slot.service_quality vs max $E
    bcc.b   l_38f04                     ; service_quality >= 14: cap at 14
    moveq   #$0,d5
    move.b  $b(a4), d5                  ; d5 = service_quality (< 14)
    bra.b   l_38f06
l_38f04:
    moveq   #$E,d5                      ; d5 = 14 (capped)
l_38f06:
    ; Clamp current selection (slot+$03 = frequency) to [1, d5]
    moveq   #$0,d0
    move.b  $3(a4), d0                  ; route_slot.frequency (current cursor position)
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0                      ; frequency > d5?
    bge.b   l_38f1c
    moveq   #$0,d0
    move.b  $3(a4), d0                  ; use frequency as-is (it's within range)
    bra.b   l_38f20
l_38f1c:
    move.w  d5, d0                      ; clamp to d5 (service_quality cap)
    ext.l   d0
l_38f20:
    move.b  d0, $3(a4)                  ; route_slot.frequency = clamped value

; --- Phase: Read city demand levels from city_data ---
    ; city_data layout at $FFBA80: 8 bytes per city, stride-2 access per player.
    ; byte[0] = demand, byte[1] = supply. Index: city_idx * 8 + player * 2.
    ; Compute net demand for city_a: demand - supply (city_data[city_a][player])
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a index
    lsl.w   #$3, d0                     ; city_a * 8 (8 bytes per city)
    move.w  $a(a6), d1                  ; player_index
    add.w   d1, d1                      ; player_index * 2 (stride-2 within city entry)
    add.w   d1, d0
    movea.l  #$00FFBA80,a0              ; city_data base
    move.b  (a0,d0.w), d4              ; city_data[city_a][player].demand
    andi.l  #$ff, d4
    moveq   #$0,d0
    move.b  (a4), d0                    ; city_a again (for supply byte at +1)
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0              ; city_data + 1 (supply byte)
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d4                      ; d4 = city_a net demand (demand - supply)

    ; Same for city_b: compute net demand
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b index
    lsl.w   #$3, d0                     ; city_b * 8
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d2              ; city_data[city_b][player].demand
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2                      ; d2 = city_b net demand

    ; d4 = max(city_a net demand, city_b net demand) -- higher demand sets the bar width
    cmp.w   d2, d4
    bge.b   l_38fac                     ; d4 >= d2: keep d4
    move.w  d4, d0
    bra.b   l_38fae
l_38fac:
    move.w  d2, d0                      ; d0 = max(d4, d2)
l_38fae:
    ext.l   d0
    move.w  d0, d4                      ; d4 = max net demand (bar upper bound)

    ; d5 = max(d4, d5) -- ensure bar range covers at least the service_quality
    cmp.w   d4, d5
    bge.b   l_38fba
    move.w  d5, d0
    bra.b   l_38fbc
l_38fba:
    move.w  d4, d0
l_38fbc:
    ext.l   d0
    move.w  d0, d5                      ; d5 = max(service_quality, max_demand)

; --- Phase: Draw initial stat bars (left and right) ---
    ; The stat bar shows route capacity vs demand as a row of filled/empty tile words.
    ; Bar uses tile $8541 (filled left), $8542 (filled right), $8543 (empty), $8000 (blank).
    ; d4 starts at 1 (initial cursor position = slot 1 = minimum).
    moveq   #$1,d4                      ; d4 = current cursor index (starts at 1)
    cmpi.w  #$7, d4                     ; >= 7?
    bge.b   l_38fce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_38fd0
l_38fce:
    moveq   #$7,d0                      ; capped at 7 visible slots per bar half
l_38fd0:
    move.w  d0, -$6(a6)                ; save left bar segment count
    ; GameCommand $1A with tile $033D = draw stat bar segment (left side)
    pea     ($033D).w                   ; tile index for stat bar left tile
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; segment count
    pea     ($000B).w                   ; x position = 11
    pea     ($0014).w                   ; y position = 20
    clr.l   -(a7)
    pea     ($001A).w                   ; GameCommand $1A (draw tile strip)
    jsr     (a5)
    lea     $2c(a7), a7
    ; Right bar: d4 - 7 additional segments if d4 > 7
    move.w  d4, d0
    addi.w  #$fff9, d0                  ; d4 - 7 (overflow segments for right bar)
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.b   l_3902c                     ; no overflow: skip right bar draw
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w                   ; x position = 12 (right side of bar)
    pea     ($0014).w                   ; y position = 20
    clr.l   -(a7)
    pea     ($001A).w                   ; GameCommand $1A
    jsr     (a5)
    lea     $1c(a7), a7
; --- Phase: Build tile word arrays for stat bars ---
    ; Two word arrays are built in the link frame:
    ;   -$40(a6): left bar tiles  (palette 0, up to 15 word entries)
    ;   -$78(a6): right bar tiles (palette 0, up to 15 word entries)
    ; For indices 0..(d4-1): filled with $8541 (left) and $8542 (right) -- selected/active bar
    ; For indices d4..(d5-1): filled with $8000 (left) and $8543 (right) -- empty bar
    ; Terminated with $0000 at index d5.
l_3902c:
    clr.w   d2                          ; d2 = tile array index (0 .. d5)
    move.w  d2, d0
    add.w   d0, d0                      ; d0 = d2 * 2 (word offset)
    lea     -$78(a6, d0.w), a0          ; a3 = right bar tile array base
    movea.l a0, a3
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0          ; a2 = left bar tile array base
    movea.l a0, a2
    bra.b   l_39060
l_39044:
    cmp.w   d4, d2                      ; d2 < d4 (within selected range)?
    bge.b   l_39052
    move.w  #$8541, (a2)               ; left bar: $8541 = filled left-half tile (palette 2)
    move.w  #$8542, (a3)               ; right bar: $8542 = filled right-half tile
    bra.b   l_3905a
l_39052:
    ; d2 >= d4: empty bar slot
    move.w  #$8000, (a2)               ; left bar: $8000 = blank (background tile)
    move.w  #$8543, (a3)               ; right bar: $8543 = empty slot marker tile
l_3905a:
    addq.l  #$2, a2                     ; advance left bar array ptr
    addq.l  #$2, a3                     ; advance right bar array ptr
    addq.w  #$1, d2
l_39060:
    cmp.w   d5, d2                      ; iterated all d5 slots?
    blt.b   l_39044
    ; Null-terminate both arrays
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)             ; null-terminate left bar array at index d5
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)             ; null-terminate right bar array at index d5
    moveq   #$1,d7                      ; d7 = left bar top-left column (x=1)
    moveq   #$E,d6                      ; d6 = right bar bottom-right column (x=14)
    ; DrawBox(x1=d7, y1=4, x2=d6, y2=21): draws the outer border for the stat bar panel
    pea     ($0004).w                   ; y1 = 4 (top edge)
    pea     ($0015).w                   ; y2 = 21 (bottom edge)
    move.w  d6, d0
    move.l  d0, -(a7)                   ; x2 = 14 (right edge)
    move.w  d7, d0
    move.l  d0, -(a7)                   ; x1 = 1 (left edge)
    jsr DrawBox                         ; draw panel border
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow                   ; reset text window to full screen
    ; SetTextCursor(x = d6+1, y = d7+$12): position cursor below the bar panel
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0                     ; x = right_edge + 1 = 15
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$12, d0                    ; y = left_edge + $12 = 19
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $28(a7), a7
    ; Place icon tiles (arrows/brackets) flanking the stat bar at two positions
    move.w  d6, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
    pea     ($000B).w
    pea     ($001D).w
    jsr SetTextCursor
    pea     ($000B).w
    pea     ($001D).w
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
; --- Phase: Cache city supply values for per-frame display ---
    ; Read city_data supply bytes (byte offset +1 in the stride-2 entry) for both cities.
    ; These are cached in link frame vars and added to d4 each frame for running totals.
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a index
    lsl.w   #$3, d0                     ; city_a * 8 (city_data stride)
    move.w  $a(a6), d1                  ; player_index
    add.w   d1, d1                      ; * 2 (stride-2 per player)
    add.w   d1, d0
    movea.l  #$00FFBA81,a0              ; city_data + 1 (supply byte offset)
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$7a(a6)               ; cache: city_a supply value
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b index
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$7c(a6)               ; cache: city_b supply value

; --- Phase: Initial ReadInput to seed input_ready flag ---
    clr.l   -(a7)
    jsr ReadInput
    lea     $2c(a7), a7
    tst.w   d0
    beq.b   l_39158
    moveq   #$1,d0                      ; ReadInput returned nonzero: input ready immediately
    bra.b   l_3915a
l_39158:
    moveq   #$0,d0                      ; no input ready this frame
l_3915a:
    move.w  d0, -$2(a6)                 ; -$2(a6) = input_ready flag
    clr.w   -$4(a6)                     ; -$4(a6) = pending input button mask (cleared)
    clr.w   ($00FF13FC).l               ; input_mode_flag = 0 (reset input counter)
    clr.w   ($00FFA7D8).l               ; input_init_flag = 0 (reset UI input init)
    clr.w   d2                          ; d2 = main loop exit code (0 = loop, $FF = exit)
    clr.w   d3                          ; d3 = animation frame counter (portrait flicker)
    bra.w   l_39676                     ; jump to loop condition check

; --- Phase: Main per-frame display loop ---
    ; This loop refreshes the negotiation menu display every frame until input confirms
    ; a selection (d2 == $FF) or the player navigates away.
    ; d3 cycles 0 -> 1 -> ... -> $1E -> 0, used to time portrait animations.
l_39176:
    addq.w  #$1, d3                     ; advance animation frame counter

    ; On frame 1: place character portrait tiles
    cmpi.w  #$1, d3
    bne.b   l_391e6
    move.l  #$8000, -(a7)               ; flags: $8000
    pea     ($0001).w                   ; count = 1
    pea     ($0001).w                   ; scale = 1
    pea     ($007C).w                   ; palette/priority word = $7C
    pea     ($0008).w                   ; y = 8
    pea     ($0039).w                   ; x = $39 (57)
    pea     ($0772).w                   ; tile index $772 (character portrait tile A)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                         ; GameCommand $E (display step)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($00A0).w                   ; y = $A0 (160, second portrait position)
    pea     ($003A).w                   ; x = $3A (58)
    pea     ($0773).w                   ; tile index $773 (character portrait tile B)
    jsr TilePlacement
    lea     $1c(a7), a7
l_391d8:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                         ; GameCommand $E
    addq.l  #$8, a7
    bra.b   l_39206

    ; On frame $F (15): trigger GameCmd16 (palette reset / mid-cycle refresh)
l_391e6:
    cmpi.w  #$f, d3
    bne.b   l_391fe
    pea     ($0002).w
    pea     ($0039).w                   ; arg: $39
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_391d8

    ; On frame $1E (30): reset frame counter (30-frame portrait animation cycle)
l_391fe:
    cmpi.w  #$1e, d3
    bne.b   l_39206
    clr.w   d3                          ; reset to 0 (30-frame cycle: 0..29)

; --- Phase: Per-frame stat value display ---
    ; Print current selection index (d4) and per-city supply values at fixed cursor positions.
l_39206:
    pea     ($000B).w                   ; cursor col = 11
    pea     ($001B).w                   ; cursor row = 27
    jsr SetTextCursor
    move.w  d4, d0                      ; current selection (frequency cursor)
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FEE).l               ; format: selection index display
    jsr PrintfWide
    pea     ($0004).w                   ; cursor col = 4
    pea     ($0005).w                   ; cursor row = 5
    jsr SetTextCursor
    ; Display: city_a supply + d4 (running total)
    move.w  -$7a(a6), d0               ; city_a supply (saved earlier)
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0                      ; supply + selection offset
    move.l  d0, -(a7)
    pea     ($00044FEA).l               ; narrow format string for city_a stat
    jsr PrintfNarrow
    pea     ($0004).w
    pea     ($0015).w                   ; cursor row = 21
    jsr SetTextCursor
    ; Display: city_b supply + d4
    move.w  -$7c(a6), d0               ; city_b supply
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FE6).l               ; narrow format string for city_b stat
    jsr PrintfNarrow
    lea     $30(a7), a7
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FE2).l
    jsr PrintfWide
    pea     -$40(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $2c(a7), a7
    pea     -$78(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    ; After rendering stat bars: check input_ready flag and read/poll input
    tst.w   -$2(a6)                     ; input_ready == 1 (already have pending input)?
    beq.b   l_39310                     ; no: poll ProcessInputLoop normally
    clr.l   -(a7)
    jsr ReadInput                       ; consume pending input (flush buffer)
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3966a                     ; if new input present: bypass ProcessInputLoop
l_39310:
    clr.w   -$2(a6)                     ; clear input_ready for next frame
    move.w  -$4(a6), d0                 ; previous pending button mask
    move.l  d0, -(a7)
    pea     ($000A).w                   ; ProcessInputLoop repeat delay = 10 frames
    jsr ProcessInputLoop                ; d0 = button(s) pressed this frame
    addq.l  #$8, a7
    andi.w  #$bc, d0                    ; mask to: Up=$20, Down=$10, Left=$4, Right=$8, Start=$80
    move.w  d0, -$4(a6)                 ; save masked input for next frame's repeat logic
    ext.l   d0

; --- Phase: Input dispatch (button bitmask switch) ---
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_3935a                     ; Up ($20) = confirm selection
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_393cc                     ; Down ($10) = cancel / back
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_3941e                     ; Left ($4) = decrement cursor (d4--)
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39538                     ; Right ($8) = increment cursor (d4++)
    cmpi.w  #$80, d0
    beq.w   l_395c6                     ; Start ($80) = commit/select with partner browse
    bra.w   l_3965e                     ; no matching button: no-op

; --- Handler: Up button -- confirm current selection ---
l_3935a:
    clr.w   ($00FF13FC).l               ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l               ; input_init_flag = 0
    move.b  d4, $3(a4)                  ; write confirmed frequency to route_slot.frequency
    moveq   #$3,d2                      ; d2 = $3 (exit code for "selection confirmed")
l_3936c:
    ; Animate a 3-frame flash of the confirmed selection, then exit the loop
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w                   ; width = $E (14 tiles)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w                   ; GameCommand $1A (draw tile strip)
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0018).w
    jsr     (a5)                         ; GameCommand $18 (commit/sync display)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16                       ; GameCmd16(2, $39) - display cleanup
    lea     $28(a7), a7
    move.w  d2, d0                      ; d0 = 3 (exit code)
    bra.w   l_3967e                     ; exit main loop

; --- Handler: Down button -- cancel and return ---
l_393cc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$5,d2                      ; d2 = $5 (exit code for "cancelled")
    ; Show cancel animation with tile $077E at two positions
    pea     ($077E).w                   ; cancel tile index
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3936c                     ; jump to confirmation animation then exit

; --- Handler: Left button -- decrement cursor position (d4--) ---
l_3941e:
    move.w  #$1, ($00FF13FC).l          ; input_mode_flag = 1 (scrolling active)
    subq.w  #$1, d4                     ; d4-- (move cursor left / decrease frequency)
    cmpi.w  #$1, d4                     ; clamp to minimum 1
    ble.b   l_39434
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39436
l_39434:
    moveq   #$1,d0                      ; floor at 1
l_39436:
    move.w  d0, d4
    ; Update tile array: mark the vacated slot as empty
    cmpi.w  #$1, d5                     ; if max is 1, no bar to clear
    ble.b   l_39452
    move.w  d4, d0
    add.w   d0, d0                      ; d0 = d4 * 2 (word offset)
    move.w  #$8000, -$40(a6, d0.w)     ; clear left bar tile at new cursor position
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)     ; set right bar tile to empty marker at new position
l_39452:
    ; Redraw left-side segment strip (tiles 1..7)
    cmpi.w  #$7, d4
    bne.b   l_3947c
    pea     ($033E).w                   ; tile $033E (left bar segment)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    subq.l  #$7, d0                     ; count = d5 - 7 (overflow segments)
    move.l  d0, -(a7)
    pea     ($000C).w                   ; x = 12
    pea     ($0014).w                   ; y = 20
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_3947c:
    ; Redraw overflow segment strip if d4 > 7
    cmpi.w  #$7, d4
    ble.b   l_394c2
    move.w  d4, d0
    addi.w  #$fff9, d0                  ; d4 - 7 = overflow count
    move.w  d0, -$6(a6)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0                      ; remaining = d5 - overflow
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($000C).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0                    ; x offset = overflow + $14
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_394c2:
    cmpi.w  #$7, d4
    bge.b   l_394ce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_394d0
l_394ce:
    moveq   #$7,d0
l_394d0:
    move.w  d0, -$6(a6)
    cmpi.w  #$7, -$6(a6)
    bge.w   l_3966a
    cmpi.w  #$7, d5
    bge.b   l_394ea
    move.w  d5, d0
    ext.l   d0
    bra.b   l_394ec
l_394ea:
    moveq   #$7,d0
l_394ec:
    move.w  d0, -$8(a6)
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    ble.w   l_3966a
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000B).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_39528:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3966a
; --- Handler: Right button -- increment cursor position (d4++) ---
l_39538:
    move.w  #$1, ($00FF13FC).l          ; input_mode_flag = 1 (scrolling active)
    addq.w  #$1, d4                     ; d4++ (move cursor right / increase frequency)
    cmp.w   d5, d4                      ; clamp to max d5
    bge.b   l_3954a
    move.w  d4, d0
    bra.b   l_3954c
l_3954a:
    move.w  d5, d0                      ; cap at d5 (service_quality max)
l_3954c:
    ext.l   d0
    move.w  d0, d4
    ; Update tile array: fill the newly occupied slot as selected
    add.w   d0, d0                      ; d0 = d4 * 2
    move.w  #$8541, -$42(a6, d0.w)     ; left bar: $8541 = filled left half (-$40 + 2 = -$3E, index d4)
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)     ; right bar: $8542 = filled right half
    ; Redraw left bar segment strip (0..7, clamp to 7 max)
    cmpi.w  #$7, d4
    bge.b   l_3956e
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39570
l_3956e:
    moveq   #$7,d0                      ; cap at 7 (first bar group max)
l_39570:
    move.w  d0, -$6(a6)                ; save left bar segment count
    pea     ($033D).w                   ; tile $033D (filled bar tile)
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)                   ; segment count
    pea     ($000B).w                   ; x = 11
    pea     ($0014).w                   ; y = 20
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                         ; GameCommand $1A: draw left bar strip
    lea     $1c(a7), a7
    ; Redraw overflow segments if d4 > 7
    move.w  d4, d0
    addi.w  #$fff9, d0                  ; d4 - 7 (overflow count)
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.w   l_3966a                     ; no overflow: skip right-side redraw
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w                   ; x = 12 (right bar group)
    pea     ($0014).w
    bra.w   l_39528                     ; shared GameCommand $1A call

; --- Handler: Start button -- browse partner list (if match slots available) ---
l_395c6:
    clr.w   ($00FF13FC).l               ; clear input_mode_flag
    move.w  $a(a6), d0                  ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots               ; check available match slots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_3966a                     ; no match slot available: ignore Start press
    ; Launch partner browse UI for city_a + city_b of this route slot
    moveq   #$0,d0
    move.b  $1(a4), d0                  ; route_slot.city_b
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0                    ; route_slot.city_a
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0                  ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners                  ; show partner selection UI for this route pair
    ; After browsing, redraw the menu
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                         ; redraw menu area
    lea     $28(a7), a7
    ; Re-show dialog header after returning from BrowsePartners
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)        ; ptr to dialog format string
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.l  ($00048612).l, -(a7)        ; ptr to match-available notice
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    bra.b   l_3966a

; --- No-op handler (unknown or unmapped button) ---
l_3965e:
    clr.w   ($00FF13FC).l               ; clear input mode flags
    clr.w   ($00FFA7D8).l

; --- Phase: Per-frame end-of-loop sync ---
l_3966a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)                         ; GameCommand $E (display sync step)
    addq.l  #$8, a7

; --- Loop condition: continue until d2 == $FF ---
l_39676:
    cmpi.w  #$ff, d2                    ; exit code $FF = loop indefinitely (normal frame)
    bne.w   l_39176                     ; d2 != $FF: continue loop
    ; d2 set to 3 (confirm), 5 (cancel), or returned by caller sub-dispatch sets d0

l_3967e:
    movem.l -$a4(a6), d2-d7/a2-a5      ; restore saved registers
    unlk    a6
    rts
