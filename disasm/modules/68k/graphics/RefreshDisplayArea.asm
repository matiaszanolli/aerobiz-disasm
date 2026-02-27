; ============================================================================
; RefreshDisplayArea -- Scores a character pair, formats the result as percent offset from 50, draws info box, and processes directional input; calls ProcessCityChange on value change
; 1158 bytes | $0163E2-$016867
;
; Arg $c(a6): pointer to a 6-byte record (a2):
;   +$00  byte  char_code_A    -- first character code
;   +$01  byte  char_code_B    -- second character code
;   +$02  (padding)
;   +$04  word  display_value  -- the current displayed "offset" value (0-100, center=50)
;
; Register map:
;   a2 = record ptr (from $c(a6))
;   a3 = $000D64  GameCommand dispatcher
;   a4 = $00FF13FC  input_mode_flag (word; written 0 or 1 to signal UI context)
;   a5 = $0003AB2C  caller function pointer (used for position/text-draw calls)
;   d2 = working "display position" value (0-100, snapped to multiples of 5)
;   d3 = new_value (candidate for display_value update; compared with $4(a2))
;   d4 = CharCodeScore raw result (compatibility score from char pair)
;   d5 = previous d2 (used to detect changes and skip redundant redraws)
;   d6 = raw ProcessInputLoop button word (saved for next call)
;   d7 = d2 / $A (integer tens digit, passed to ProcessCityChange)
;   -$2(a6) = has_input flag: 1 if ReadInput returned non-zero (A button held)
;   -$4(a6) = scaled ceiling: MulDiv(d4, $96, $64) = d4 * 150 / 100 = d4 * 1.5
;             also used as max_display_value cap for Up/Down scrolling
;
; Overview of the "offset from 50" scoring system:
;   1. CharCodeScore(charA, charB) -> raw_score d4 (0-$96 = 0-150 typical range)
;   2. Scale to [0,100]: MulDiv(d4, $64=100, $96=150) -> ceiling stored in -$4(a6)
;   3. Compute display position:
;      d2 = ($4(a2) - d4) * 100 / d4 + $32  (offset relative to midpoint 50)
;   4. Snap d2 to nearest multiple of 5 (round toward 5 boundaries)
;   5. Clamp d2 to [0, $64=100]
;   The center value $32 (50) means "exactly at score", positive = above, negative = below.
; ============================================================================
RefreshDisplayArea:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)

; --- Phase: Prologue -- set up register aliases and score the char pair ---
    movea.l $c(a6), a2          ; a2 = record ptr (char pair + display state)
    movea.l  #$00000D64,a3      ; a3 = GameCommand dispatcher ($000D64)
    movea.l  #$00FF13FC,a4      ; a4 = input_mode_flag ($FF13FC)
    movea.l  #$0003AB2C,a5      ; a5 = text-position/draw caller

    ; CharCodeScore(char_code_A, char_code_B): compute raw compatibility score.
    ; The two character codes are stored at a2[+$00] and a2[+$01].
    moveq   #$0,d0
    move.b  $1(a2), d0          ; a2[+$01] = char_code_B
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0            ; a2[+$00] = char_code_A
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore           ; -> d0 = raw_score (compatibility 0-$96)
    move.w  d0, d4              ; d4 = raw_score

    ; Scale raw_score to a ceiling: MulDiv(d4, $96=150, $64=100) = d4 * 1.5.
    ; This gives the theoretical maximum for the display_value range (0 to ceiling).
    pea     ($0064).w           ; dividend = $64 (100)
    pea     ($0096).w           ; divisor = $96 (150)
    move.w  d4, d0
    move.l  d0, -(a7)           ; value = raw_score
    jsr MulDiv                  ; -> d0 = d4 * 100 / 150 (scaled ceiling)
    move.w  d0, -$4(a6)        ; -$4(a6) = display_ceiling (max scrollable value)

    ; Compute initial display position d2:
    ; d2 = (display_value - raw_score) * 100 / raw_score + $32
    ; This converts the absolute display_value to a "% deviation from score center".
    ; $4(a2) = display_value (the current committed display position word).
    moveq   #$0,d0
    move.w  $4(a2), d0          ; d0 = display_value
    move.w  d4, d1
    ext.l   d1                  ; d1 = raw_score
    sub.l   d1, d0              ; d0 = display_value - raw_score
    moveq   #$64,d1             ; * 100
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1                  ; d1 = raw_score (divisor)
    jsr SignedDiv               ; d0 = (display_value - raw_score) * 100 / raw_score
    addi.l  #$32, d0            ; + $32 (50): shift to center around 50
    move.l  d0, d2              ; d2 = raw centered value

    ; Snap d2 to the nearest multiple of 5.
    ; Algorithm: r = d2 mod 5. If r == 0: already on boundary.
    ; If r < 3: round down (d2 -= r). If r >= 3: round up (d2 += 5-r).
    ; This prevents the display from showing fractional-5 positions.
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod               ; d0 = d2 mod 5
    move.w  d0, d3              ; d3 = remainder
    beq.b   .l16474             ; remainder == 0 -> already snapped
    cmpi.w  #$3, d3
    bge.b   .l1646e             ; r >= 3 -> round up
    sub.w   d3, d2              ; round down: d2 -= r
    bra.b   .l16474
.l1646e:
    moveq   #$5,d0
    sub.w   d3, d0              ; 5 - r
    add.w   d0, d2              ; round up: d2 += (5 - r)

; --- Phase: Draw info box and initialize display loop state ---
.l16474:
    ; DrawBox(1, $12, $1E, 4): draw the stat comparison box.
    ; Box spans columns 4-$1E (left-right) and rows 1-$12 (top-bottom).
    pea     ($0004).w           ; left
    pea     ($001E).w           ; right
    pea     ($0012).w           ; bottom
    pea     ($0001).w           ; top
    jsr DrawBox
    lea     $24(a7), a7

    ; SetTextWindow(0, 0, $20, $20): set text window to full screen for ReadInput.
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow

    ; ReadInput(0): check if A button is already held (non-zero = held).
    ; Stores result as a binary flag in -$2(a6) (1=held, 0=not held).
    ; This gates whether ReadInput re-checking is done each display iteration.
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l164b4
    moveq   #$1,d0              ; A is held
    bra.b   .l164b6
.l164b4:
    moveq   #$0,d0              ; A not held
.l164b6:
    move.w  d0, -$2(a6)        ; -$2(a6) = has_input flag (1 = A held)
    clr.w   d6                  ; d6 = saved input state for ProcessInputLoop = 0
    clr.w   (a4)                ; input_mode_flag ($FF13FC) = 0 (idle)
    clr.w   ($00FFA7D8).l       ; input_init_flag ($FFA7D8) = 0 (reset)
    moveq   #-$1,d5             ; d5 = $FFFF -- "no previous value" sentinel

    ; GameCommand($0B, $39, 2, $20, 0, 0, 1, $047A26): draw the text panel header.
    ; $047A26 is a ROM string pointer for the panel title.
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l        ; ROM string: panel title text
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)                 ; GameCommand($0B, ...)
    lea     $20(a7), a7
    move.w  $4(a2), d0          ; restore display_value from record
    move.w  d0, d3              ; d3 = current display_value (used in Up/Down handlers)
    ext.l   d0

; --- Phase: Display value loop -- clamp, check change, redraw ---
; This is the top of the "redisplay on change" loop.
; d2 enters as the new candidate display position (0-100, multiple of 5).
.l164f2:
    ; Clamp d2 to [0, $64=100].
    tst.w   d2
    ble.b   .l164fc
    move.w  d2, d0
    ext.l   d0
    bra.b   .l164fe
.l164fc:
    moveq   #$0,d0              ; d2 < 0 -> clamp to 0
.l164fe:
    move.w  d0, d2
    cmpi.w  #$64, d2            ; d2 > $64 (100)?
    bge.b   .l1650c
    move.w  d2, d0
    ext.l   d0
    bra.b   .l1650e
.l1650c:
    moveq   #$64,d0             ; clamp to 100
.l1650e:
    move.w  d0, d2              ; d2 = clamped value [0, 100]

    ; Skip redraw if d2 hasn't changed since last iteration.
    cmp.w   d5, d2              ; same as previously drawn value?
    beq.w   .l16600             ; no change -> skip to input handling

    ; Value changed: position cursor and draw the score text.
    ; a5($3AB2C)($F, $13): position text cursor to row $F, col $13.
    pea     ($0013).w           ; column
    pea     ($000F).w           ; row
    jsr     (a5)
    addq.l  #$8, a7

    ; Format and print the compatibility score string.
    ; d2 == $32 (50) means exactly at score (no deviation). Otherwise format as +N or -N.
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0            ; d0 = d2 - 50 (signed deviation from center)
    beq.b   .l1656c             ; deviation == 0 -> print "even" format

    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0            ; recompute deviation (same value)
    bge.b   .l16558             ; deviation >= 0 -> print positive format

    ; Negative deviation (below score): negate and print with negative format string.
    ; Format string at $03F8AE = "-%d" style (e.g., "-15").
    move.w  d2, d0
    ext.l   d0
    neg.l   d0                  ; abs(deviation)
    addi.l  #$32, d0            ; back to (50 - d2) for display = abs offset
    move.l  d0, -(a7)           ; arg: magnitude
    pea     ($0003F8AE).l        ; ROM format string: negative-offset format "%d" with prefix
.l1654e:
    jsr PrintfWide              ; print wide-font formatted value
    addq.l  #$8, a7
    bra.b   .l1657a

.l16558:
    ; Positive deviation (above score): print with positive format string.
    ; Format string at $03F89C = "+%d" style (e.g., "+10").
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0            ; d0 = d2 - 50 (offset above center)
    move.l  d0, -(a7)
    pea     ($0003F89C).l        ; ROM format string: positive-offset format
    bra.b   .l1654e

.l1656c:
    ; Zero deviation: print the "exactly at score" string (no number needed).
    ; Format string at $03F88C = centered/neutral display text.
    pea     ($0003F88C).l        ; ROM string: neutral/even compatibility text
    jsr PrintfWide
    addq.l  #$4, a7

.l1657a:
    ; Print the raw display_value ($4(a2)) at row $D, col $19 using narrow font.
    ; This shows the raw tick position for reference.
    ; Format string at $03F886 = "%d" for the raw value.
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)                 ; position cursor: row $D, col $19
    move.w  d3, d0              ; d3 = display_value ($4(a2))
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F886).l        ; ROM format string: raw value "%d"
    jsr PrintfNarrow

    ; Print the offset value (d2 - $32) at row $E, col $19 using narrow font.
    ; This shows "+N" or "-N" as a narrow string below the wide version.
    ; Format string at $03F880 = "%d" signed offset.
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)                 ; position cursor: row $E, col $19
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0            ; d0 = d2 - 50 (signed offset)
    move.l  d0, -(a7)
    pea     ($0003F880).l        ; ROM format string: signed offset "%d"
    jsr PrintfNarrow

    ; Compute ProcessCityChange args from d2:
    ;   d7 = d2 / $A  (tens digit: 0-10, which "decade bucket" [0,10,..,100])
    ;   d5 = max(1, d2 mod $A)  (units within decade, clamped to minimum 1)
    ; These are passed to ProcessCityChange to update any city-display side effects
    ; based on the compatibility score position.
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv               ; d0 = d2 / 10
    move.w  d0, d7              ; d7 = tens digit
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod               ; d0 = d2 mod 10
    moveq   #$1,d1
    cmp.l   d0, d1              ; 1 > (d2 mod 10)?
    ble.b   .l165e6
    ; d2 mod 10 < 1: clamp units to the mod value itself (avoid 0).
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l165e8
.l165e6:
    moveq   #$1,d0              ; minimum units = 1
.l165e8:
    move.w  d0, d5              ; d5 = units (clamped to >= 1)
    ext.l   d0
    move.l  d0, -(a7)           ; arg: units within decade
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: tens digit
    jsr (ProcessCityChange,PC)  ; update city display based on score position
    nop
    lea     $28(a7), a7
    move.w  d2, d5              ; d5 = d2 (remember current displayed value)

; --- Phase: Optional A-held re-check ---
.l16600:
    ; If has_input flag is set (-$2(a6) != 0), check if A is still held.
    ; If it's still held (ReadInput returns nonzero), loop back to re-draw
    ; with the same d2 -- this keeps redisplaying while A is pressed.
    tst.w   -$2(a6)             ; A button was held at entry?
    beq.b   .l16616             ; no -> proceed to input poll
    clr.l   -(a7)
    jsr ReadInput               ; still held?
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l164f2             ; yes -> loop back to redraw

; --- Phase: Input dispatch -- ProcessInputLoop + button routing ---
.l16616:
    clr.w   -$2(a6)            ; clear has_input flag
    ; ProcessInputLoop(prev_state=$d6, repeat=$A): get current button edges/holds.
    ; d6 preserves the previous input word for auto-repeat detection.
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w           ; repeat threshold
    jsr ProcessInputLoop
    addq.l  #$8, a7
    ; Mask to directional + confirm bits: $3C = bits 2,3,4,5 = left/right/down/up
    andi.w  #$3c, d0
    move.w  d0, d6              ; save for next iteration
    ext.l   d0
    ; Dispatch on button value:
    ;   $20 = Start/confirm  -> commit and exit
    ;   $10 = left           -> decrease d2 toward score
    ;   $04 = right          -> decrease d2 further (confusingly named, see below)
    ;   $08 = up/down        -> increase d2 toward score
    ;   other                -> no input, loop with no change
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   .l167c6             ; $20 = Start -> confirm and exit
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l16654             ; $10 = left (decrease toward display_value)
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l1673a             ; $04 = down (decrease by 5)
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l16788             ; $08 = up (increase by 5)
    bra.w   .l167ba             ; no recognized input -> idle loop

; --- Phase: Left button ($10) -- snap display toward current display_value ---
; This recomputes d2 from the CURRENT $4(a2) using the same scoring formula
; as the prologue, effectively "resetting" d2 to match display_value.
.l16654:
    clr.w   (a4)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0
    move.w  d3, d0              ; d3 = current display_value read from $4(a2) at entry
    ext.l   d0
    moveq   #$0,d1
    move.w  $4(a2), d1          ; $4(a2) = committed display_value
    cmp.l   d1, d0              ; d3 == $4(a2)?
    beq.w   .l167d2             ; already matches -> go to commit/teardown

    ; Recompute the position from the stored display_value (same formula as prologue).
    moveq   #$0,d0
    move.w  $4(a2), d0          ; display_value
    move.w  d4, d1
    ext.l   d1                  ; raw_score
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1
    jsr SignedDiv
    addi.l  #$32, d0            ; + 50
    move.l  d0, d2
    ; Snap to multiple of 5 (same algorithm as prologue).
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d3
    beq.b   .l166b0
    cmpi.w  #$3, d3
    bge.b   .l166aa
    sub.w   d3, d2
    bra.b   .l166b0
.l166aa:
    moveq   #$5,d0
    sub.w   d3, d0
    add.w   d0, d2

.l166b0:
    ; Recompute ProcessCityChange args for the snapped position.
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l166de
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l166e0
.l166de:
    moveq   #$1,d0
.l166e0:
    move.w  d0, d5              ; d5 = units
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCityChange,PC)  ; update city display for snapped position
    nop
    ; Print the raw display_value at row $D, col $19.
    ; Format string at $03F87A = "%d" for the raw/original value.
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  $4(a2), d0          ; original display_value
    move.l  d0, -(a7)
    pea     ($0003F87A).l        ; ROM format string: raw value display
    jsr PrintfNarrow
    ; Print offset at row $E, col $19.
    ; Format string at $03F874 = "%d" signed offset from center.
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0            ; signed offset
    move.l  d0, -(a7)
    pea     ($0003F874).l        ; ROM format string: signed offset display
    jsr PrintfNarrow
    lea     $28(a7), a7
    bra.w   .l167d2             ; -> teardown/commit

; --- Phase: Down button ($04) -- decrease d2 by 5, recompute d3 ---
; Moving "down" (toward lower score) decreases d2 by 5 ticks.
; d3 is recalculated as: d3 = d4 + (d2-50)*d4/100
; i.e., the raw display value corresponding to the new position.
.l1673a:
    move.w  #$1, (a4)           ; input_mode_flag = 1 (scrolling active)
    subq.w  #$5, d2             ; d2 -= 5 (move down one step)
    ; d3 = d4 + d4 * (d2 - 50) / 100
    move.w  d4, d0
    ext.l   d0                  ; d0 = raw_score
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1            ; d1 = d2 - 50 (signed offset from center)
    jsr Multiply32              ; d0 = raw_score * (d2-50)
    moveq   #$64,d1
    jsr SignedDiv               ; d0 = raw_score * (d2-50) / 100
    add.w   d4, d0              ; d3 = d4 + above = base + delta
    move.w  d0, d3

    ; Compute lower bound: raw_score / 2 (rounded signed).
    ; d3 must stay >= raw_score/2 (floor at half-score).
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16768
    addq.l  #$1, d0             ; rounding for negative
.l16768:
    asr.l   #$1, d0             ; floor = raw_score / 2
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0              ; floor >= d3?
    bge.b   .l16778             ; yes -> clamp d3 to floor

    ; d3 is above floor; also cap it at display_ceiling (-$4(a6)).
.l16772:
    move.w  d3, d0
.l16774:
    ext.l   d0
    bra.b   .l16782
.l16778:
    ; d3 < floor: clamp d3 to floor (raw_score/2, rounded).
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16780
    addq.l  #$1, d0
.l16780:
    asr.l   #$1, d0             ; floor = raw_score/2

.l16782:
    move.w  d0, d3              ; d3 = clamped display value
    bra.w   .l164f2             ; back to clamp+redraw loop

; --- Phase: Up button ($08) -- increase d2 by 5, recompute d3 ---
; Moving "up" (toward higher score) increases d2 by 5 ticks.
; Same d3 recalculation as Down, but with ceiling cap at -$4(a6).
.l16788:
    move.w  #$1, (a4)           ; input_mode_flag = 1
    addq.w  #$5, d2             ; d2 += 5 (move up one step)
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1            ; d1 = d2 - 50
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   d4, d0              ; d3 = d4 + d4*(d2-50)/100
    move.w  d0, d3
    ; Cap d3 at display_ceiling (-$4(a6) = MulDiv(raw_score, 150, 100)).
    cmp.w   -$4(a6), d3
    blt.b   .l16772             ; d3 < ceiling -> use as-is
    move.w  -$4(a6), d0         ; clamp to ceiling
    bra.b   .l16774

; --- Phase: No input ($0) -- idle, loop back without state change ---
.l167ba:
    clr.w   (a4)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0
    bra.w   .l164f2             ; loop back (no change to d2)

; --- Phase: Start button ($20) -- confirm d3 as new display_value and exit ---
.l167c6:
    clr.w   (a4)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0
    move.w  d3, $4(a2)          ; commit: store d3 into record[+$04] (display_value)

; --- Phase: Epilogue -- clear panel and draw final display state ---
.l167d2:
    ; GameCommand($0B, $39, 2, $20, 0, 0, 0, $047A26): redraw the panel header to clear text.
    ; This erases the formatted score text drawn in the loop above.
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l        ; ROM string: panel title
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)

    ; GameCommand($10, $39, 2): commit the display buffer.
    pea     ($0002).w
    pea     ($0039).w
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7

    ; GameCommand($0E, 1): frame sync / flush.
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)

    ; GameCommand($1A, 0, 0, $20, $D, 0, $8000): clear the left column area.
    ; This erases the text left behind by PrintfWide/PrintfNarrow calls.
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7

    ; GameCommand($1A, 1, 0, $20, $D, 0, $8000): redraw the right column area.
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)

    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
