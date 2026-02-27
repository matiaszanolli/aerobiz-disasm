; ============================================================================
; ShowRelationResult -- Draws the relation result screen: computes percent outcome from char-pair score, splits it into filled/partial/empty tile runs, and renders three horizontal icon bars plus optional portrait
; Called: ?? times.
; 1256 bytes | $019DE6-$01A2CD
; ============================================================================
; --- Phase: Setup / Argument Unpacking ---
; Stack args: $8(a6) = ptr to char-pair stat record (a2)
;             $12(a6) = word: column / X position for icon bar output (a5 alias)
;             $16(a6) = word: row / Y position for icon bar output (a4 alias)
;             $1A(a6) = word: portrait-enable flag (1 = show portrait, 0 = skip)
;             $E(a6)  = word: screen row base for result display
ShowRelationResult:                                                  ; $019DE6
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2              ; a2 = ptr to char-pair stat record (char code bytes, score fields)
    movea.l #$0d64,a3                 ; a3 = GameCommand dispatcher
    lea     $0016(a6),a4              ; a4 = ptr to $16(a6): icon bar row/Y position word
    lea     $0012(a6),a5              ; a5 = ptr to $12(a6): icon bar column/X position word
    ; Conditional portrait load: only if flag $1A(a6) == 1
    cmpi.w  #$1,$001a(a6)
    bne.b   .l19e58                   ; portrait flag != 1 — skip portrait load
    ; --- Load and display character portrait for this char pair ---
    ; Decompress the portrait graphic from the pointer in ROM table at $A1AE4
    move.l  ($000A1AE4).l,-(sp)      ; ROM pointer: character portrait compressed data
    pea     ($00FF1804).l             ; dest = $FF1804 (save_buf_base staging buffer)
    dc.w    $4eb9,$0000,$3fec         ; jsr LZ_Decompress ($003FEC): decompress portrait to $FF1804
    ; DMA portrait tiles to VRAM: tile $0694, count $20 tiles
    pea     ($0020).w                 ; tile count = $20 (32 tiles — portrait graphic)
    pea     ($0694).w                 ; VRAM tile destination = $0694
    pea     ($00FF1804).l             ; source = $FF1804 (decompressed portrait)
    dc.w    $4eb9,$0000,$4668         ; jsr $004668 (VRAMBulkLoad variant): DMA portrait to VRAM
    ; Place portrait sprite tile block on screen (GameCmd #$1B)
    pea     ($00070F58).l             ; compressed tile metadata for portrait frame
    pea     ($0004).w                 ; height = 4
    pea     ($0004).w                 ; width = 4
    move.w  (a5),d0                   ; d0 = column X (from $12(a6))
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0              ; d0 = screen row base from $E(a6)
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w                 ; plane = 1
    pea     ($001B).w                 ; GameCmd #$1B = place compressed tile block
    jsr     (a3)
    lea     $0030(sp),sp
; --- Phase: Score Computation ---
; Compute the char-pair compatibility percentage score and derive tile counts.
.l19e58:                                                ; $019E58
    ; SetTextWindow: define a $20×$20 window at (0,0) — full screen for icon bar rendering
    pea     ($0020).w                 ; height = $20
    pea     ($0020).w                 ; width = $20
    clr.l   -(sp)                     ; col = 0
    clr.l   -(sp)                     ; row = 0
    dc.w    $4eb9,$0003,$a942         ; jsr SetTextWindow ($03A942): set full-screen text window
    ; Load register constants for the icon bar rendering positions
    move.w  $000e(a6),d7              ; d7 = screen row base from $E(a6)
    addq.w  #$4,d7                    ; d7 += 4 (offset icon bars 4 rows below the base)
    move.w  (a5),d6                   ; d6 = icon bar column X from $12(a6)
    clr.w   d5                        ; d5 = 0 (icon bar type selector / running index)
    ; Compute the raw compatibility percentage score for this char pair
    ; a2+$00 = char A code byte, a2+$01 = char B code byte
    moveq   #$0,d0
    move.b  $0001(a2),d0              ; d0 = char B code (a2+1)
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0                   ; d0 = char A code (a2+0)
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$70dc         ; jsr CharCodeScore ($0070DC): compute % match for (charA, charB)
    move.w  d0,d2                     ; d2 = raw compatibility score (0..100-ish percent)
    ; Clamp the score to [0, $96] ($96 = 150 — the scale max before normalization)
    pea     ($0064).w                 ; min clamp = $64 (100)
    pea     ($0096).w                 ; max clamp = $96 (150)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c         ; jsr $01E11C: clamp d0 to [min, max] passed on stack
    lea     $0024(sp),sp
    ; Compute number of filled icon tiles: d4 = d2 / $14 ($14=20 = scale divisor)
    ; This converts the score into a count out of 10 filled tiles
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1                   ; divisor = $14 (20)
    dc.w    $4eb9,$0003,$e08a         ; jsr SignedDiv ($03E08A): d0 = score / 20 = filled tile count
    move.w  d0,d4                     ; d4 = number of fully-filled icon tiles (0..7)
    ; --- Phase: Bonus Score Adjustment ---
    ; a2+$04 = a word: historical/prior score. If nonzero, compute a trend-bonus for d3.
    ; d3 will hold the adjusted percentage displayed in the result bar (centered at $32=50).
    tst.w   $0004(a2)                 ; check a2+$04 = prior relation score (0 = no prior)
    beq.b   .l19f02                   ; prior score = 0: skip bonus, d3 will be set by later clamp
    ; Prior score exists — compute trend: is current score (d2) > or < prior score?
    moveq   #$0,d0
    move.w  $0004(a2),d0              ; d0 = prior score (a2+4)
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0                     ; compare prior (d0) vs current (d2/d1)
    ble.b   .l19ee4                   ; prior <= current: score improved, go to negative-bonus path
    ; Prior score EXCEEDS current: relationship deteriorated
    ; d3 = ((prior - current) / d4) * 5 + $32
    moveq   #$0,d0
    move.w  $0004(a2),d0              ; d0 = prior score
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0                     ; d0 = prior - current (positive = deterioration gap)
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a         ; jsr SignedDiv: d0 = (prior - current) / d4 (normalize by tile count)
    move.l  d0,d3
    mulu.w  #$5,d3                    ; d3 = normalized_gap * 5 (scale to display range)
    addi.w  #$32,d3                   ; d3 += $32 (50) = center the range at 50 (above 50 = worse)
    bra.b   .l19f02
.l19ee4:                                                ; $019EE4
    ; Current score EQUALS or EXCEEDS prior: relationship improved or held steady
    ; d3 = $32 - ((current - prior) / d4) * 5
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.w  $0004(a2),d1             ; d1 = prior score
    sub.l   d1,d0                     ; d0 = current - prior (positive = improvement gap)
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a         ; jsr SignedDiv: d0 = (current - prior) / d4
    mulu.w  #$5,d0                    ; d0 = normalized_gap * 5
    moveq   #$32,d3                   ; d3 = $32 (50 = baseline center)
    sub.w   d0,d3                     ; d3 = 50 - scaled_gap (below 50 = improvement shown)
; --- Phase: Icon Tile Count Derivation ---
; d3 is the adjusted display percentage (0..$64=100 range).
; Clamp d3 to [0, $64] (0–100), then derive filled and partial tile counts.
.l19f02:                                                ; $019F02
    ; Clamp d3 to maximum of $64 (100%)
    cmpi.w  #$64,d3
    bge.b   .l19f0e                   ; d3 >= 100: use 100
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19f10
.l19f0e:                                                ; $019F0E
    moveq   #$64,d0                   ; d0 = $64 (cap at 100%)
.l19f10:                                                ; $019F10
    move.w  d0,d3                     ; d3 = clamped percentage [0..100]
    ; Clamp d3 to minimum of 0
    tst.w   d3
    ble.b   .l19f1c                   ; d3 <= 0: use 0
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19f1e
.l19f1c:                                                ; $019F1C
    moveq   #$0,d0                    ; d0 = 0 (floor at 0%)
.l19f1e:                                                ; $019F1E
    move.w  d0,d3                     ; d3 = final clamped percentage [0..100]
    ; d2 = d3 / 10 = number of fully-filled icon tiles (0..10)
    ext.l   d0
    moveq   #$a,d1                    ; divisor = $A (10)
    dc.w    $4eb9,$0003,$e08a         ; jsr SignedDiv ($03E08A): d0 = d3 / 10
    move.w  d0,d2                     ; d2 = filled tile count (0..10, each tile = 10%)
    ; d4 = d3 mod 10 = fractional remainder for the partial tile
    ; Use SignedMod ($03E146) then compute partial tile index
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1                    ; divisor = $A (10)
    dc.w    $4eb9,$0003,$e146         ; jsr SignedMod ($03E146): d0 = d3 mod 10 (0..9 remainder)
    ; Map the modulo to a partial tile index: if remainder > 1, use it directly; else use 1 as minimum
    moveq   #$1,d1
    cmp.l   d0,d1
    ble.b   .l19f4c                   ; remainder <= 1: use 1 (minimum partial tile)
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146         ; jsr SignedMod: recompute remainder
    bra.b   .l19f4e
.l19f4c:                                                ; $019F4C
    moveq   #$1,d0                    ; d0 = 1 (minimum partial tile index)
.l19f4e:                                                ; $019F4E
    move.w  d0,d4                     ; d4 = partial tile index (1..9, selects partially-filled icon)
; --- Phase: Icon Bar Rendering (Row 1) ---
; Render the first horizontal icon bar (relation score bar, row d7).
; The bar consists of up to 10 tile cells:
;   - d2 filled tiles (tile $033A = full icon)
;   - d4 partial tiles (tile $033B = partial icon at index d4)
;   - (10 - d2 - d4) empty tiles (tile $033C = empty icon)
; GameCmd $1A with tile index = place a repeated tile strip of 'count' tiles.
; Column x = d6+1, row y = d7, strip starts at tile (d5 + tile_type_offset)

    ; Draw d2 filled icon tiles starting at column d6+1, row d7
    tst.w   d2
    ble.b   .l19f88                   ; d2 = 0: no filled tiles, skip
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033a,d0                 ; d0 = d5 + $033A = tile index for "fully filled" icon
    move.l  d0,-(sp)                  ; arg: tile index
    pea     ($0001).w                 ; arg: plane = 1
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; arg: count = d2 (number of filled tiles)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)                  ; arg: column = d6+1 (start 1 past icon-bar left edge)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; arg: row = d7
    move.w  (a4),d0                   ; d0 = (a4) = row Y value from $16(a6)
    ext.l   d0
    move.l  d0,-(sp)                  ; arg: Y/height
    pea     ($001A).w                 ; GameCmd #$1A = fill tile rectangle (horizontal strip)
    jsr     (a3)                      ; draw filled icon strip
    lea     $001c(sp),sp
.l19f88:                                                ; $019F88
    ; Draw 1 partial icon tile at position immediately after the filled tiles
    tst.w   d4
    beq.b   .l19fc4                   ; d4 = 0: no partial tile (exact multiple of 10%), skip
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033b,d0                 ; d0 = d5 + $033B = tile index for "partial" icon
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w                 ; count = 1 (just one partial tile)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)                  ; column = d6+1 (left edge of icon bar)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0                     ; row offset += d2 (place partial tile after filled tiles)
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw the single partial icon tile
    lea     $001c(sp),sp
.l19fc4:                                                ; $019FC4
    ; Draw empty icon tiles for the remainder: count = 10 - d2 - d4
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1                     ; d1 = 10 - d2 (remaining after filled tiles)
    move.w  d4,d0
    ext.l   d0
    sub.l   d0,d1                     ; d1 = 10 - d2 - d4 = number of empty tiles
    ble.b   .l1a01e                   ; d1 <= 0: no empty tiles needed, skip
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033c,d0                 ; d0 = d5 + $033C = tile index for "empty" icon
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.w  d4,d0
    ext.l   d0
    sub.l   d0,d1                     ; d1 = recomputed empty count
    move.l  d1,-(sp)                  ; arg: count = empty tile count
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)                  ; arg: column = d6+1
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0                     ; offset by filled count
    move.w  d4,d1
    ext.l   d1
    add.l   d1,d0                     ; offset by partial count = place empty tiles after partial
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw the empty icon strip
    lea     $001c(sp),sp
; --- Phase: Print Score Text Labels ---
; Print numeric labels below the icon bars: the prior score and the delta/trend value.
.l1a01e:                                                ; $01A01E
    ; Position text cursor for the prior-score label
    ; Column = (a5) = $12(a6), Row = $E(a6) + 9
    move.w  (a5),d0                   ; d0 = column X from $12(a6)
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0              ; d0 = row base from $E(a6)
    ext.l   d0
    addi.l  #$9,d0                    ; d0 += 9 (move below the icon bars)
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c         ; jsr SetTextCursor ($03AB2C): position cursor at (col, row+9)
    ; Print the prior score (a2+4) using format string at $41128 (e.g. "PREV:%d")
    moveq   #$0,d0
    move.w  $0004(a2),d0              ; d0 = prior score from a2+$04 char stat record field
    move.l  d0,-(sp)
    pea     ($00041128).l             ; format string for prior score label (e.g. "PREV: %d")
    dc.w    $4eb9,$0003,$b246         ; jsr PrintfNarrow ($03B246): print prior score value
    ; Position cursor one column to the right for the trend/delta label
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0                    ; col += 1 (next cell right)
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addi.l  #$9,d0                    ; same row
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c         ; jsr SetTextCursor ($03AB2C)
    ; Compute trend delta: d3 was adjusted percentage, subtract $32 (50) to center
    ; Positive delta = score improved vs prior; negative = score declined
    subi.w  #$32,d3                   ; d3 -= 50: d3 = signed trend delta relative to baseline
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($00041122).l             ; format string for trend delta (e.g. "+%d" or "-%d")
    dc.w    $4eb9,$0003,$b246         ; jsr PrintfNarrow ($03B246): print trend delta
    lea     $0020(sp),sp
; --- Phase: Icon Bar Rendering (Row 2 — Primary Stat Bar) ---
; a2+$0B = char stat record field +$0B = "computed/cached stat value" (0..$0E max 14)
; This bar shows the character's primary stat level, clamped to [0, 7] for the filled icon count
; and filling 7 - filled for empty icons (total bar width = 7 tiles).
    cmpi.b  #$0e,$000b(a2)            ; check if stat at a2+$0B >= $E (14 = cap)
    bcc.b   .l1a092                   ; stat >= cap: use maximum (d4=$E)
    moveq   #$0,d4
    move.b  $000b(a2),d4              ; d4 = raw stat value from a2+$0B (0..13)
    bra.b   .l1a094
.l1a092:                                                ; $01A092
    moveq   #$e,d4                    ; d4 = $E (14, the stat cap)
.l1a094:                                                ; $01A094
    ; Clamp d4 to maximum of 7 for the icon bar (7 is the visual max width of this bar)
    cmpi.w  #$7,d4
    bge.b   .l1a0a0
    move.w  d4,d2
    ext.l   d2                        ; d2 = d4 (stat value, within bar width)
    bra.b   .l1a0a2
.l1a0a0:                                                ; $01A0A0
    moveq   #$7,d2                    ; d2 = 7 (cap at full bar width)
.l1a0a2:                                                ; $01A0A2
    ; Draw d2 filled stat-icon tiles (tile $033E = stat-filled icon) at row d7, col d6+2
    ; Row 2 of the icon display is offset by +2 from the base column
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033e,d0                 ; tile index = d5 + $033E (stat bar filled icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; count = d2 (filled tile count for this stat)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0                    ; col = d6+2 (second icon bar row column offset)
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; row = d7
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw filled portion of primary stat bar
    lea     $001c(sp),sp
    ; Draw (7 - d2) empty stat-icon tiles to fill out the bar to 7 wide
    cmpi.w  #$7,d2
    bge.b   .l1a11a                   ; bar is already full (d2=7), skip empty tiles
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0                 ; tile index = d5 + $0328 (stat bar empty icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1                     ; d1 = 7 - d2 = empty tile count
    move.l  d1,-(sp)                  ; count = empty tile count
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0                    ; col = d6+2
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0                     ; row offset = d7 + d2 (place empties after filled)
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw empty portion of stat bar
    lea     $001c(sp),sp
.l1a11a:                                                ; $01A11A
; --- Phase: Icon Bar Rendering (Row 2 — Secondary Stat Bar, Tile $033D) ---
; a2+$03 = char stat record field +$03 = "cap/limit value or alternative rating"
; This draws a separate 7-tile bar alongside the primary stat bar using a different tile ($033D)
    cmpi.b  #$07,$0003(a2)            ; check if a2+$03 (secondary stat) >= 7 (bar cap)
    bcc.b   .l1a12a
    moveq   #$0,d2
    move.b  $0003(a2),d2              ; d2 = secondary stat value from a2+$03
    bra.b   .l1a12c
.l1a12a:                                                ; $01A12A
    moveq   #$7,d2                    ; d2 = 7 (cap at full bar width)
.l1a12c:                                                ; $01A12C
    ; Draw d2 filled secondary-stat icon tiles (tile $033D = secondary stat filled icon)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033d,d0                 ; tile index = d5 + $033D (secondary stat icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; count = d2
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0                    ; col = d6+2
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; row = d7
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw secondary stat bar
    lea     $001c(sp),sp
    ; --- Phase: Icon Bar Rendering (Row 3 — Overflow Stat / Extra Bar) ---
    ; d4 = stat raw value from a2+$0B. Compute overflow beyond 7: d2 = d4 - 7
    ; If d4 > 7, there's a third bar to fill (the "excess" portion)
    move.w  d4,d2
    addi.w  #$fff9,d2                 ; d2 = d4 + (-7) = d4 - 7 (signed: negative if d4 < 7)
    tst.w   d2
    ble.b   .l1a170                   ; d2 <= 0: no overflow (d4 was <= 7), skip
    move.w  d2,d0
    ext.l   d0
    bra.b   .l1a172
.l1a170:                                                ; $01A170
    moveq   #$0,d0                    ; d0 = 0 (no overflow tiles)
.l1a172:                                                ; $01A172
    move.w  d0,d2                     ; d2 = overflow count (0 if d4 <= 7)
    tst.w   d2
    ble.b   .l1a1f0                   ; no overflow to draw, skip to empty-tile phase
    ; Draw d2 overflow stat-icon tiles (tile $033E) at row 3 (col d6+3)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033e,d0                 ; tile index = d5 + $033E (overflow filled icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; count = d2 (overflow tile count)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0                    ; col = d6+3 (third icon bar row column offset)
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw overflow filled tile strip at row 3
    lea     $001c(sp),sp
    ; Draw empty tiles for remainder of row 3 (7 - d2 empty tiles)
    cmpi.w  #$7,d2
    bge.b   .l1a1f0                   ; d2 >= 7: row 3 is full, skip empty tiles
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0                 ; tile index = d5 + $0328 (empty icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1                     ; d1 = 7 - d2
    move.l  d1,-(sp)                  ; count = empty tile count for row 3
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0                    ; col = d6+3
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0                     ; place empties after filled overflow tiles
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw empty tile strip for row 3
    lea     $001c(sp),sp
; If d2 was 0 (no overflow), still need to draw 7 empty tiles for row 3
.l1a1f0:                                                ; $01A1F0
    cmpi.w  #$7,d2
    bge.b   .l1a234                   ; d2 >= 7: row 3 already filled, skip
    ; Draw the 7 empty tiles for row 3 when there were no overflow tiles (d2=0)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0                 ; tile index = d5 + $0328 (empty icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1                     ; d1 = 7 - d2 (all 7 are empty when d2=0)
    move.l  d1,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0                     ; start col offset (0 when d2=0)
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw all-empty row 3 icon bar
    lea     $001c(sp),sp
; --- Phase: Icon Bar Rendering (Row 3 — Secondary Stat Overflow, Tile $033D) ---
; Draw overflow tiles for the secondary stat bar (a2+$03) at row 3 (col d6+3).
; Only drawn if a2+$03 > 7 (secondary stat exceeds the 7-tile bar cap).
.l1a234:                                                ; $01A234
    moveq   #$0,d2
    move.b  $0003(a2),d2              ; d2 = secondary stat from a2+$03
    addi.w  #$fff9,d2                 ; d2 += -7 = d2 - 7 (negative if stat <= 7)
    tst.w   d2
    ble.b   .l1a276                   ; <= 0: secondary stat <= 7, no overflow to draw
    ; Draw d2 overflow secondary-stat tiles (tile $033D) at row 3
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033d,d0                 ; tile index = d5 + $033D (secondary overflow icon)
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; count = d2 (overflow count for secondary stat)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0                    ; col = d6+3 (row 3)
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)                      ; draw secondary stat overflow strip at row 3
    lea     $001c(sp),sp
; --- Phase: Print Secondary Stat Label and Final Display ---
; Print the secondary stat value (a2+$03) as text below the icon bars,
; then display the final relation result panel graphic.
.l1a276:                                                ; $01A276
    ; Position text cursor: col = $12(a6)+2, row = $E(a6)+$A
    move.w  (a5),d0                   ; d0 = col X from $12(a6)
    ext.l   d0
    addq.l  #$2,d0                    ; col += 2 (right of portrait area)
    move.l  d0,-(sp)
    move.w  $000e(a6),d0              ; d0 = row from $E(a6)
    ext.l   d0
    addi.l  #$a,d0                    ; row += $A (below the three icon bars)
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c         ; jsr SetTextCursor ($03AB2C): position below icon bars
    ; Print secondary stat value (a2+$03) using format string at $4111C
    moveq   #$0,d0
    move.b  $0003(a2),d0              ; d0 = secondary stat from a2+$03 (cap/limit field)
    move.l  d0,-(sp)
    pea     ($0004111C).l             ; format string for secondary stat label
    dc.w    $4eb9,$0003,$b270         ; jsr PrintfWide ($03B270): print in wide (2-tile) font
    ; Position cursor for the final result value display: col = $12(a6)+2, row = $E(a6)+$D
    move.w  (a5),d0
    addq.w  #$2,d0                    ; col = $12(a6)+2
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    addi.w  #$d,d0                    ; row = $E(a6) + $D (lowest row, below all bars and labels)
    move.l  d0,-(sp)
    ; Display the final relation result using $595E — likely a sprite/icon placement function
    pea     ($0002).w                 ; param = 2
    pea     ($0003).w                 ; param = 3 (result type / display mode)
    dc.w    $4eb9,$0000,$595e         ; jsr $00595E: place/render final relation result indicator
    movem.l -$0028(a6),d2-d7/a2-a5   ; restore callee-saved registers
    unlk    a6
    rts
