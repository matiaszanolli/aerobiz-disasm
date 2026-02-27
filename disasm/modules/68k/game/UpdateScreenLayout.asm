; ============================================================================
; UpdateScreenLayout -- Computes bar-chart display parameters from two characters' stats and renders a score comparison panel with navigation loop
; 1940 bytes | $015C4E-$0163E1
;
; Args:
;   $A(a6) = player_index (word) -- selects column within city_data row
;   $C(a6) = char_pair_ptr (long ptr) -- points to a pair descriptor:
;              byte[0] = city_a index (first character's city)
;              byte[1] = city_b index (second character's city)
;              byte[3] = current bar position / cursor value (updated in place)
;              byte[$B] = initial bar maximum hint
;
; Frame layout (a6-relative):
;   -$02 : ProcessInputLoop accumulated button state (word)
;   -$06 : (a5 base) bar scroll window register (word): current visible-window start
;   -$08 : clamped d4 (bar count up to 7) for scroll arithmetic (word)
;   -$79 : saved city_a raw stat byte (byte, read by A button handler)
;   -$7a : char_a display value (city_a stat - bar_min; word)
;   -$7c : animation/blink counter (word; drives TilePlacement and GameCmd16 timing)
;   -$40..-$02(a6) : bar tile array A (words; one per bar slot; $3E bytes = 31 words max)
;   -$78..-$42(a6) : bar tile array B (words; one per bar slot; $36 bytes = 27 words max)
;
; Register map during main loop:
;   D3 = current bar position (cursor / selected index, 1-based)
;   D4 = total bar count (number of comparison bars)
;   D5 = column coordinate ($12 = 18, for GameCommand calls)
;   D6 = row coordinate (1, top row of comparison panel)
;   D7 = char_b display value (city_b stat - bar_min; kept live throughout loop)
;   A4 = char_pair_ptr (arg from $C(a6))
;   A5 = ptr to -$06(a6): bar scroll window word
;
; city_data 2D index formula:
;   byte offset = city_index * 8 + player_index * 2
;   Byte at ($FFBA80 + offset)   = raw popularity component A
;   Byte at ($FFBA81 + offset)   = popularity component B (subtracted from A)
;   Net stat = component_A - component_B
;
; BAT tile word encoding (Genesis VDP):
;   $8541 = %1000 0101 0100 0001 -- priority=1, palette=0, tile=$141 (filled bar A)
;   $8542 = %1000 0101 0100 0010 -- priority=1, palette=0, tile=$142 (filled bar B)
;   $8543 = %1000 0101 0100 0011 -- priority=1, palette=0, tile=$143 (empty bar)
;   $8000 = %1000 0000 0000 0000 -- priority=1, tile=0 (blank/transparent)
; ============================================================================
UpdateScreenLayout:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4                 ; a4 = char_pair_ptr
    lea     -$6(a6), a5                ; a5 = bar scroll window word ptr (-$06(a6))

; --- Phase: Compute net city stats for both characters ---
    ; city_data index: city_index * 8 + player_index * 2
    ; Read two bytes per entry: byte[$FFBA80+idx] - byte[$FFBA81+idx] = net stat.

    ; Character A net stat (city_a = char_pair_ptr byte[0])
    moveq   #$0,d0
    move.b  (a4), d0                   ; d0 = city_a index (char_pair_ptr+$00)
    lsl.w   #$3, d0                    ; d0 = city_a * 8 (city_data row stride = 8 bytes)
    move.w  $a(a6), d1                 ; d1 = player_index ($A(a6) argument)
    add.w   d1, d1                     ; d1 = player_index * 2 (column offset)
    add.w   d1, d0                     ; d0 = city_a*8 + player*2 (2D index)
    movea.l  #$00FFBA80,a0             ; city_data base ($FFBA80): 89 cities * 8 bytes each
    move.b  (a0,d0.w), d2              ; d2 = city_a popularity component A
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  (a4), d0                   ; repeat index for component B
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0             ; city_data +1 offset: component B column
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2                     ; d2 = city_a net stat (A - B)

    ; Character B net stat (city_b = char_pair_ptr byte[1])
    moveq   #$0,d0
    move.b  $1(a4), d0                 ; d0 = city_b index (char_pair_ptr+$01)
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d3              ; d3 = city_b popularity component A
    andi.l  #$ff, d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d3                     ; d3 = city_b net stat (A - B)

; --- Phase: Compute bar chart scale parameters ---
    ; Find min of the two stats to use as the range base
    cmp.w   d3, d2
    bge.b   .l15ce6
    move.w  d2, d0                     ; d2 < d3: d0 = d2 (smaller value)
    bra.b   .l15ce8
.l15ce6:
    move.w  d3, d0                     ; d2 >= d3: d0 = d3
.l15ce8:
    ext.l   d0
    move.w  d0, d2                     ; d2 = min(city_a_stat, city_b_stat) = range base

    ; Add char_pair_ptr+$03 (current bar cursor) to get working range
    moveq   #$0,d0
    move.b  $3(a4), d0                 ; d0 = current bar position byte (char_pair_ptr+$03)
    add.w   d0, d2                     ; d2 = range_base + bar_position

    ; d4 = min(char_pair_ptr+$0B, $E): bar max hint capped at 14
    moveq   #$0,d4
    move.b  $b(a4), d4                 ; d4 = bar max hint (char_pair_ptr+$0B)
    cmpi.w  #$e, d4                    ; cap at $E = 14
    bge.b   .l15d06
    move.w  d4, d0
    ext.l   d0
    bra.b   .l15d08
.l15d06:
    moveq   #$E,d0                     ; clamped to 14
.l15d08:
    move.w  d0, d4                     ; d4 = effective bar maximum (capped at 14)

    ; d4 = max(d4, d2): bar range must cover both stats
    cmp.w   d2, d4
    bge.b   .l15d12
    move.w  d4, d0                     ; d4 >= d2: take d4
    bra.b   .l15d14
.l15d12:
    move.w  d2, d0                     ; d4 < d2: take d2
.l15d14:
    ext.l   d0
    move.w  d0, d4                     ; d4 = final bar range = max(hint, stat_span)

    ; Persist max(char_pair_ptr+$03, d4) back to char_pair_ptr+$03
    moveq   #$0,d2
    move.b  $3(a4), d2
    cmp.w   d4, d2
    bge.b   .l15d26
    move.w  d2, d0                     ; d2 < d4: store d2
    bra.b   .l15d28
.l15d26:
    move.w  d4, d0                     ; d2 >= d4: store d4
.l15d28:
    ext.l   d0
    move.b  d0, $3(a4)                 ; char_pair_ptr+$03 = updated bar cursor

    ; d3 = max(char_pair_ptr+$03, 1): live bar position, minimum 1
    cmpi.b  #$1, $3(a4)
    bls.b   .l15d3e
    moveq   #$0,d3
    move.b  $3(a4), d3                 ; d3 = bar position (>= 2)
    bra.b   .l15d40
.l15d3e:
    moveq   #$1,d3                     ; clamped to 1
.l15d40:
    ; Clamp d3 to visible window max of 7
    cmpi.w  #$7, d3
    bge.b   .l15d4c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l15d4e
.l15d4c:
    moveq   #$7,d0                     ; clamped to 7
.l15d4e:
    move.w  d0, (a5)                   ; -$06(a6) = bar scroll window = min(d3, 7)

; --- Phase: Draw bar chart background tiles via GameCommand $1A ---
    ; First call: tile $033D at row=$F, col=$14, count=scroll_window
    ; $033D = BAT tile for filled bar background graphic
    pea     ($033D).w                  ; tile_id = $033D (filled bar background)
    pea     ($0001).w                  ; flag = 1
    move.w  (a5), d0                   ; d0 = scroll window start
    ext.l   d0
    move.l  d0, -(a7)                  ; scroll_position
    pea     ($000F).w                  ; row = $F (15)
    pea     ($0014).w                  ; col = $14 (20)
    pea     ($0001).w                  ; 1
    pea     ($001A).w                  ; GameCommand $1A (tile strip render)
    jsr GameCommand
    lea     $1c(a7), a7                ; pop 7 args

    ; Second call: draw overflow segment if d3 > 7 (bar extends past window)
    ; overflow = d3 - 7; tile $033D at row=$10, col=$14
    move.w  d3, d0
    addi.w  #$fff9, d0                 ; d0 = d3 + (-7) = d3 - 7 (overflow count)
    move.w  d0, (a5)                   ; save overflow to scroll window
    tst.w   (a5)
    ble.b   .l15dac                    ; no overflow: skip

    pea     ($033D).w                  ; tile_id = $033D
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)                  ; overflow extent
    pea     ($0010).w                  ; row = $10 (16): below main bar row
    pea     ($0014).w                  ; col = $14 (20)
    pea     ($0001).w
    pea     ($001A).w                  ; GameCommand $1A
    jsr GameCommand
    lea     $1c(a7), a7

; --- Phase: Build bar tile arrays in link frame ---
    ; Array A at -$40(a6): upper bar strip BAT words
    ; Array B at -$78(a6): lower bar strip BAT words
    ; Slot index 0..d3-1: filled tiles ($8541/$8542)
    ; Slot index d3..d4-1: empty/blank tiles ($8000/$8543)
    ; Slot d4: cleared word sentinel
.l15dac:
    clr.w   d2                         ; d2 = slot index (starts at 0)
    move.w  d2, d0
    add.w   d0, d0                     ; d0 = slot * 2 (word array offset)
    lea     -$78(a6, d0.w), a0         ; a0 = &array_B[slot]
    movea.l a0, a3                     ; a3 = walking ptr into bar tile array B
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0         ; a0 = &array_A[slot]
    movea.l a0, a2                     ; a2 = walking ptr into bar tile array A
    bra.b   .l15de0                    ; -> check loop condition first

.l15dc4:
    cmp.w   d3, d2                     ; slot < cursor (d3)?
    bge.b   .l15dd2
    move.w  #$8541, (a2)               ; filled bar tile A (active bar segment)
    move.w  #$8542, (a3)               ; filled bar tile B (active bar segment)
    bra.b   .l15dda
.l15dd2:
    move.w  #$8000, (a2)               ; blank tile (slot >= cursor: inactive)
    move.w  #$8543, (a3)               ; empty bar marker tile B
.l15dda:
    addq.l  #$2, a2                    ; advance array A ptr (+2 bytes)
    addq.l  #$2, a3                    ; advance array B ptr (+2 bytes)
    addq.w  #$1, d2                    ; slot_index++
.l15de0:
    cmp.w   d4, d2                     ; loop while slot_index < d4 (total bars)
    blt.b   .l15dc4
    ; Write null-word sentinels at position d4 to terminate both arrays
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)             ; array A[d4] = 0 (null terminator)
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)             ; array B[d4] = 0 (null terminator)

; --- Phase: Draw comparison panel frame ---
    moveq   #$1,d6                     ; d6 = top row of panel = 1
    moveq   #$12,d5                    ; d5 = right column of panel = $12 (18)

    ; DrawBox(top=d6, right=d5, width=$14, height=$04)
    pea     ($0004).w                  ; height = 4 rows
    pea     ($0014).w                  ; width = $14 (20) columns
    move.w  d5, d0
    move.l  d0, -(a7)                  ; right col = d5 ($12)
    move.w  d6, d0
    move.l  d0, -(a7)                  ; top row = d6 (1)
    jsr DrawBox

    ; SetTextWindow(left=0, top=0, right=$20, bottom=$20)
    pea     ($0020).w                  ; right = $20 (32)
    pea     ($0020).w                  ; bottom = $20 (32)
    clr.l   -(a7)                      ; top = 0
    clr.l   -(a7)                      ; left = 0
    jsr SetTextWindow

    ; SetTextCursor(col=d5+1, row=d6+$12)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)                  ; col = d5 + 1 = $13 (19)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$12, d0                   ; row = d6 + $12 = $13 (19)
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $28(a7), a7                ; pop DrawBox + SetTextWindow + SetTextCursor args

    ; PlaceIconTiles(col=d5+1, row=d6+$12, palette=2, tile_bank=3)
    move.w  d5, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)                  ; col = d5 + 1
    move.w  d6, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)                  ; row = d6 + $12
    pea     ($0002).w                  ; palette = 2
    pea     ($0003).w                  ; tile_bank = 3
    jsr PlaceIconTiles

; --- Phase: Compute per-character relative display values ---
    ; Relative value = city_data[city][player] component B - d3 (bar_min)
    ; These are stored in frame locals and kept in D7 throughout the main loop.

    ; char_a relative display value -> -$7A(a6)
    moveq   #$0,d0
    move.b  (a4), d0                   ; city_a index
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0             ; city_data component B column
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d3, d0                     ; subtract bar_min for relative display
    move.w  d0, -$7a(a6)              ; save char_a display value

    ; char_b relative display value -> D7 (live register)
    moveq   #$0,d0
    move.b  $1(a4), d0                 ; city_b index
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d7
    andi.l  #$ff, d7
    sub.w   d3, d7                     ; d7 = char_b display value (kept live in D7)

; --- Phase: Initialize input state before main loop ---
    ; ReadInput: check if any button is already held entering the loop.
    ; If held (d0 != 0), set d2=1 to suppress first-frame input read.
    clr.l   -(a7)                      ; arg: 0 = normal mode
    jsr ReadInput
    lea     $14(a7), a7                ; ReadInput uses 5 longword arg slots
    tst.w   d0
    beq.b   .l15eb4
    moveq   #$1,d2                     ; d2 = 1: button held, skip first read
    bra.b   .l15eb6
.l15eb4:
    moveq   #$0,d2                     ; d2 = 0: no button held
.l15eb6:
    clr.w   -$2(a6)                    ; clear accumulated button state
    clr.w   ($00FF13FC).l              ; input_mode_flag ($FF13FC) = 0
    clr.w   ($00FFA7D8).l              ; input_init_flag ($FFA7D8) = 0
    moveq   #$0,d0
    move.w  d0, -$7c(a6)              ; blink_counter = 0
    andi.l  #$ffff, d0

; ============================================================================
; Main render/input loop -- redraws panel and polls buttons each iteration
; ============================================================================
.l15ed2:
; --- Phase: Render score panel text ---
    ; Print char_a stat value at cursor (col=8, row=5)
    pea     ($0008).w                  ; col = 8
    pea     ($0005).w                  ; row = 5
    jsr SetTextCursor
    move.w  -$7a(a6), d0              ; char_a relative display value
    ext.l   d0
    move.w  d3, d1                     ; d1 = bar_min (current bar position d3)
    ext.l   d1
    add.l   d1, d0                     ; restore absolute: display_value + bar_min
    move.l  d0, -(a7)                  ; stat value to print
    pea     ($0003F870).l              ; format string at ROM $03F870 (narrow printf fmt A)
    jsr PrintfNarrow

    ; Print char_b stat value at cursor (col=8, row=$15)
    pea     ($0008).w                  ; col = 8
    pea     ($0015).w                  ; row = $15 (21)
    jsr SetTextCursor
    move.w  d7, d0                     ; d7 = char_b relative display value
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0                     ; restore absolute value
    move.l  d0, -(a7)
    pea     ($0003F86C).l              ; format string at ROM $03F86C (narrow printf fmt B)
    jsr PrintfNarrow

    ; Print bar position (d3) at cursor (col=$F, row=$1B) using wide font
    pea     ($000F).w                  ; col = $F (15)
    pea     ($001B).w                  ; row = $1B (27)
    jsr SetTextCursor
    move.w  d3, d0                     ; d3 = current bar position
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F868).l              ; format string at ROM $03F868 (wide bar pos fmt)
    jsr PrintfWide
    lea     $30(a7), a7                ; pop all printf args ($30 = 6 * 4 * 2 calls)

    ; Print second bar label at (col=d5+1, row=d6+$10) using wide font
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)                  ; col = d5 + 1
    move.w  d6, d0
    ext.l   d0
    addi.l  #$10, d0                   ; row = d6 + $10 (16)
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F864).l              ; format string at ROM $03F864 (wide bar label fmt)
    jsr PrintfWide

; --- Phase: Blit bar tile arrays via GameCommand $1B ---
    ; GameCommand $1B: write a word array as a tile strip to screen position.

    ; Array A (upper strip): -$40(a6), count=d4, col=d5+1, row=d6+1
    pea     -$40(a6)                   ; ptr to bar tile array A (frame local)
    pea     ($0001).w                  ; flag = 1
    move.w  d4, d0                     ; d4 = total bar count
    ext.l   d0
    move.l  d0, -(a7)                  ; strip count
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)                  ; col = d5 + 1
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)                  ; row = d6 + 1
    clr.l   -(a7)                      ; offset = 0
    pea     ($001B).w                  ; GameCommand $1B (tile strip blit)
    jsr GameCommand
    lea     $2c(a7), a7

    ; Array B (lower strip): -$78(a6), count=d4, col=d5+2, row=d6+1
    pea     -$78(a6)                   ; ptr to bar tile array B (frame local)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                  ; strip count
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)                  ; col = d5 + 2 (one col right of array A)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)                  ; row = d6 + 1
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7

; --- Phase: Optional second ReadInput if button was held on entry (d2=1) ---
    tst.w   d2
    beq.b   .l15ff2                    ; d2 = 0: skip extra read
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l15ff2                    ; no button still held: proceed normally

; --- Send GameCommand $E (clear element) and return to render top ---
.l15fde:
    pea     ($0003).w                  ; arg2 = 3
    pea     ($000E).w                  ; GameCommand $E (clear display element)
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l15ed2                    ; back to render loop top

; --- Phase: Blink counter update and timed tile/palette effects ---
.l15ff2:
    clr.w   d2                         ; d2 = 0 (clear held-button flag)
    addq.w  #$1, -$7c(a6)             ; blink_counter++

    cmpi.w  #$1, -$7c(a6)
    bne.b   .l16070
    ; First tick (blink_counter == 1): place both character portrait tiles
    ; TilePlacement args: tile_id, y, x, width, height, count, flags
    ; $0772 = char_a portrait tile; placed at x=$98, y=$3A
    move.l  #$8000, -(a7)              ; flags = $8000 (high priority)
    pea     ($0001).w                  ; count = 1
    pea     ($0001).w                  ; height = 1
    pea     ($007C).w                  ; width = $7C (124 pixels)
    pea     ($0098).w                  ; x = $98 (152)
    pea     ($0039).w                  ; y = $39 (57)
    pea     ($0772).w                  ; tile_id = $0772 (char_a portrait)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w                  ; GameCommand $E (clear after first portrait)
    jsr GameCommand
    lea     $24(a7), a7                ; pop TilePlacement ($1C) + GameCommand ($8) args
    ; $0773 = char_b portrait tile; placed at x=$F0 (adjacent to char_a)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w                  ; same width
    pea     ($00F0).w                  ; x = $F0 (240): char_b position
    pea     ($003A).w                  ; y = $3A (58)
    pea     ($0773).w                  ; tile_id = $0773 (char_b portrait, adjacent tile)
    jsr TilePlacement
    lea     $1c(a7), a7                ; pop second TilePlacement args

.l1605e:
    pea     ($0001).w
    pea     ($000E).w                  ; GameCommand $E (finalize portrait render)
    jsr GameCommand
    addq.l  #$8, a7
    bra.b   .l16096                    ; -> input dispatch

.l16070:
    cmpi.w  #$f, -$7c(a6)             ; blink_counter == $F (15)?
    bne.b   .l1608a
    ; 15th tick: GameCmd16 color cycle effect
    pea     ($0002).w                  ; arg2 = 2 (palette cycle type)
    pea     ($0039).w                  ; arg1 = $39 (57): color register index
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l1605e                    ; clear portrait area and dispatch

.l1608a:
    cmpi.w  #$1e, -$7c(a6)            ; blink_counter == $1E (30)?
    bne.b   .l16096
    clr.w   -$7c(a6)                   ; reset to 0 (30-frame blink cycle)

; --- Phase: Input dispatch via ProcessInputLoop ---
.l16096:
    move.w  -$2(a6), d0                ; accumulated button state from previous frame
    move.l  d0, -(a7)
    pea     ($000A).w                  ; repeat_rate = $A (10 frames auto-repeat)
    jsr ProcessInputLoop               ; d0 = decoded button event word
    addq.l  #$8, a7
    andi.w  #$3c, d0                   ; keep only directional bits: $3C = up/down/left/right
    move.w  d0, -$2(a6)               ; store masked state back
    ext.l   d0
    ; Dispatch table (button bits):
    ;   $20 = A button -> commit/confirm changes
    ;   $10 = B button -> show relation detail panel
    ;   $04 = left/up  -> decrement bar position
    ;   $08 = right/down -> increment bar position
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l160d2                    ; A button: commit
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l1612a                    ; B button: detail view
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l161d6                    ; left/up: decrement
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l162f2                    ; right/down: increment
    bra.w   .l1637c                    ; no recognized input: idle

; --- A button: commit current bar position; write updated stats to city_data ---
.l160d2:
    clr.w   ($00FF13FC).l              ; input_mode_flag = 0 (release input mode)
    clr.w   ($00FFA7D8).l              ; input_init_flag = 0 (clear display state)
    move.b  d3, $3(a4)                 ; persist bar position to char_pair_ptr+$03

    ; Write char_a updated stat back to city_data[$FFBA81 + city_a*8 + player*2]
    ; Uses exg trick to temporarily borrow D7 as an address register (D7 = char_b value).
    move.b  -$79(a6), d0              ; d0 = saved city_a raw stat byte (-$79(a6))
    add.b   d3, d0                     ; d0 = raw_stat + bar_min (restore absolute)
    moveq   #$0,d1
    move.b  (a4), d1                   ; d1 = city_a index
    lsl.w   #$3, d1                    ; d1 = city_a * 8
    movea.l d7, a0                     ; save d7 (char_b display value) into A0
    move.w  $a(a6), d7                 ; d7 = player_index (temporarily reuse D7)
    add.w   d7, d7                     ; d7 = player_index * 2
    exg     d7, a0                     ; restore d7=char_b value, a0=player_index*2
    add.w   a0, d1                     ; d1 = city_a*8 + player*2 (2D index)
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)             ; city_data[city_a][player] component B = updated stat

    ; Write char_b updated stat back to city_data[$FFBA81 + city_b*8 + player*2]
    move.b  d7, d0                     ; d0 = char_b display value (D7 restored above)
    add.b   d3, d0                     ; + bar_min
    moveq   #$0,d1
    move.b  $1(a4), d1                 ; d1 = city_b index
    lsl.w   #$3, d1
    movea.l d7, a0                     ; save d7 again
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)             ; city_data[city_b][player] component B = updated stat
    bra.w   .l1638c                    ; -> exit/finalize

; --- B button: show relation detail panel (only if bar position changed) ---
.l1612a:
    clr.w   ($00FF13FC).l              ; clear input_mode_flag
    clr.w   ($00FFA7D8).l              ; clear input_init_flag
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a4), d1                 ; d1 = stored bar position (char_pair_ptr+$03)
    cmp.l   d1, d0                     ; current == stored?
    beq.w   .l1638c                    ; unchanged: skip detail view

    ; Show relation detail panel
    clr.l   -(a7)                      ; flag = 0
    pea     ($0001).w
    pea     ($000D).w                  ; arg = $D (13)
    pea     ($0010).w                  ; arg = $10 (16)
    move.l  a4, -(a7)                  ; char_pair_ptr
    jsr ShowRelationResult

    ; Print char_a value at (col=8, row=5)
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F860).l              ; format string at ROM $03F860 (relation detail char_a)
    jsr PrintfNarrow

    ; Print char_b value at (col=8, row=$15)
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $2c(a7), a7                ; pop ShowRelationResult + SetTextCursor args
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F85C).l              ; format string at ROM $03F85C (relation detail char_b)
    jsr PrintfNarrow

    ; Print bar position at (col=$F, row=$1B)
    pea     ($000F).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F858).l              ; format string at ROM $03F858 (relation bar pos)
    jsr PrintfWide
    lea     $18(a7), a7
    bra.w   .l1638c                    ; -> exit/finalize

; --- Left/up button: decrement bar position ---
.l161d6:
    move.w  #$1, ($00FF13FC).l         ; input_mode_flag = 1 (mark input active)
    subq.w  #$1, d3                    ; d3-- (move cursor left/up)
    cmpi.w  #$1, d3
    ble.b   .l161ec                    ; clamp to minimum 1
    move.w  d3, d0
    ext.l   d0
    bra.b   .l161ee
.l161ec:
    moveq   #$1,d0                     ; clamped to 1
.l161ee:
    move.w  d0, d3                     ; d3 = updated bar position

    ; If more than 1 bar: mark the vacated slot as empty in tile arrays
    cmpi.w  #$1, d4
    ble.b   .l1620a                    ; d4 <= 1: nothing to update
    move.w  d3, d0
    add.w   d0, d0                     ; d0 = d3 * 2 (word offset into arrays)
    move.w  #$8000, -$40(a6, d0.w)    ; array_A[d3] = blank (cursor moved left)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)    ; array_B[d3] = empty marker

.l1620a:
    ; At window boundary (d3 == 7): scroll back via GameCommand $1A
    cmpi.w  #$7, d3
    bne.b   .l1623a
    ; count = d4 - 7: number of bars beyond visible window to scroll back
    pea     ($033E).w                  ; tile_id = $033E (scroll-back tile)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    subq.l  #$7, d0                    ; count = d4 - 7
    move.l  d0, -(a7)
    pea     ($0010).w                  ; row = $10 (16)
    pea     ($0014).w                  ; col = $14 (20)
    pea     ($0001).w
    pea     ($001A).w                  ; GameCommand $1A
    jsr GameCommand
    lea     $1c(a7), a7

.l1623a:
    ; If d3 > 7: update scroll window for out-of-view overflow
    cmpi.w  #$7, d3
    ble.b   .l16280
    move.w  d3, d0
    addi.w  #$fff9, d0                 ; overflow = d3 - 7
    move.w  d0, (a5)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0                     ; visible_count = d4 - overflow
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0                   ; col = overflow + $14
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w                  ; GameCommand $1A (scroll area update)
    jsr GameCommand
    lea     $1c(a7), a7

.l16280:
    ; Clamp scroll window to min(d3, 7) and re-draw if within visible range
    cmpi.w  #$7, d3
    bge.b   .l1628c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1628e
.l1628c:
    moveq   #$7,d0                     ; clamped to 7
.l1628e:
    move.w  d0, (a5)                   ; update scroll window
    cmpi.w  #$7, (a5)
    bge.w   .l15fde                    ; >= 7: send clear and re-loop

    ; Check if overflow bars exist beyond visible window
    cmpi.w  #$7, d4
    bge.b   .l162a4
    move.w  d4, d0
    ext.l   d0
    bra.b   .l162a6
.l162a4:
    moveq   #$7,d0
.l162a6:
    move.w  d0, -$8(a6)               ; save clamped d4 to frame (-$08(a6))
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0                     ; overflow_count = clamped_d4 - scroll_window
    ble.w   .l15fde                    ; no overflow: send clear and re-loop

    ; Draw overflow area
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0                     ; overflow count = clamped_d4 - window
    move.l  d0, -(a7)
    pea     ($000F).w                  ; row = $F (15)
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0                   ; col = scroll_window + $14
    move.l  d0, -(a7)
.l162dc:
    pea     ($0001).w
    pea     ($001A).w                  ; GameCommand $1A
    jsr GameCommand
    lea     $1c(a7), a7
    bra.w   .l15fde                    ; -> send clear command and re-loop

; --- Right/down button: increment bar position ---
.l162f2:
    move.w  #$1, ($00FF13FC).l         ; input_mode_flag = 1 (mark input active)
    addq.w  #$1, d3                    ; d3++ (move cursor right/down)
    ; Clamp to d4 maximum
    cmp.w   d4, d3
    bge.b   .l16304                    ; d3 >= d4: clamp
    move.w  d3, d0
    bra.b   .l16306
.l16304:
    move.w  d4, d0                     ; clamped to bar maximum
.l16306:
    ext.l   d0
    move.w  d0, d3                     ; d3 = clamped updated bar position
    add.w   d0, d0                     ; d0 = d3 * 2 (word offset)
    move.w  #$8541, -$42(a6, d0.w)    ; array_A[d3] = filled bar A (cursor moved right)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)    ; array_B[d3] = filled bar B

    ; Update scroll window: min(d3, 7)
    cmpi.w  #$7, d3
    bge.b   .l16328
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1632a
.l16328:
    moveq   #$7,d0
.l1632a:
    move.w  d0, (a5)                   ; scroll_window = min(d3, 7)

    ; Draw scroll-forward: tile $033D, count=scroll_window, row=$F, col=$14
    pea     ($033D).w                  ; tile_id = $033D (forward-scroll filled tile)
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)                  ; count = scroll_window
    pea     ($000F).w                  ; row = $F (15)
    pea     ($0014).w                  ; col = $14 (20)
    pea     ($0001).w
    pea     ($001A).w                  ; GameCommand $1A
    jsr GameCommand
    lea     $1c(a7), a7

    ; If d3 > 7: draw overflow tile strip at row=$10
    move.w  d3, d0
    addi.w  #$fff9, d0                 ; overflow = d3 - 7
    move.w  d0, (a5)
    tst.w   (a5)
    ble.w   .l15fde                    ; no overflow: send clear and re-loop

    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)                  ; overflow count
    pea     ($0010).w                  ; row = $10 (16)
    pea     ($0014).w                  ; col = $14 (20)
    bra.w   .l162dc                    ; shared tail: push $1A args and dispatch

; --- No-input idle: clear UI flags and re-loop ---
.l1637c:
    clr.w   ($00FF13FC).l              ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l              ; input_init_flag = 0
    bra.w   .l15fde                    ; send clear command and re-loop

; --- Exit/finalize: GameCmd16 cleanup + two GameCommand $1A clears ---
.l1638c:
    ; GameCmd16($39, 2): audio/display finalize (palette cycle cleanup)
    pea     ($0002).w                  ; arg2 = 2
    pea     ($0039).w                  ; arg1 = $39 (57): color register
    jsr GameCmd16

    ; GameCommand $1A: clear main layout area (col=$20, row=$D, size=$12, flags=0,0)
    clr.l   -(a7)                      ; arg7 = 0
    pea     ($000D).w                  ; arg6 = $D (13)
    pea     ($0020).w                  ; arg5 = col = $20 (32)
    pea     ($0012).w                  ; arg4 = $12 (18)
    clr.l   -(a7)                      ; arg3 = 0
    clr.l   -(a7)                      ; arg2 = 0
    pea     ($001A).w                  ; GameCommand $1A
    jsr GameCommand
    lea     $24(a7), a7

    ; GameCommand $1A: clear secondary layout area (flag=1)
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w                  ; flag = 1 (secondary clear)
    pea     ($001A).w
    jsr GameCommand
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts
