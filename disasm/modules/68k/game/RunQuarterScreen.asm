; ============================================================================
; RunQuarterScreen -- Run the main quarterly review screen with full input handling: navigate players/chars/slots, dispatch trade prep, and player info sub-screens.
; Called: ?? times.
; 1188 bytes | $023EA8-$02434B
; ============================================================================
; Register usage throughout:
;   a3 = GameCommand dispatcher ($0D64)
;   a4 = input_mode_flag ($FF13FC) -- nonzero = countdown UI active
;   a5 = $01E044 (display sub-function, player indicator)
;   d2 = current player index (0-3, loaded from current_player $FF0016)
;   d3 = char code / display slot index (initialized to $E = 14)
;   d4 = state flag: 0 = normal loop, 1 = trigger refresh/redraw cycle
;   d5 = animation frame counter (0-$1E, cycles at $1E=$30)
;   d6 = sub-screen mode (0 = root, 1+ = sub-screen index from d6 dispatch table)
;   d7 = screen_id ($FF9A1C) snapshot on entry
; Stack frame locals:
;   -$0002(a6) = input-pending flag (1 = waiting for button after intro, 0 = done)
;   -$0004(a6) = accumulated input state / button history word
RunQuarterScreen:                                                  ; $023EA8
    link    a6,#-$4
    movem.l d2-d7/a2-a5,-(sp)
    movea.l #$0d64,a3                   ; a3 = GameCommand ($0D64) dispatcher
    movea.l #$00ff13fc,a4               ; a4 = input_mode_flag ($FF13FC)
    movea.l #$0001e044,a5               ; a5 = display sub-function ($01E044)
    clr.w   d4                          ; d4 = state flag (0 = normal)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2            ; d2 = current_player (0-3)
    move.w  ($00FF9A1C).l,d7            ; d7 = screen_id (scenario/screen index)

; --- Phase: screen initialization -- clear display, sync audio, show quarter header ---
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8           ; jsr $01E0B8  -- clear/init display area (mode=1, param=0)
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8           ; jsr $01E0B8  -- init second display region (mode=4, y=$3B)
    dc.w    $4eb9,$0001,$d71c           ; jsr $01D71C  -- VBlank sync
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e           ; jsr $00538E  -- audio tick (param=0)

; Load and validate char code for current player
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: player index
    dc.w    $4eb9,$0001,$c43c           ; jsr $01C43C  -- lookup char code for this player
    lea     $0018(sp),sp
    bsr.w ValidateCharCode              ; validate / clamp char code (modifies d3)

; Display player portrait / indicator tile
    moveq   #$e,d3                      ; d3 = initial display slot index ($E = 14)
    move.l  #$8000,-(sp)               ; arg: tile attribute flags ($8000 = priority)
    pea     ($0002).w                   ; arg: col
    pea     ($0002).w                   ; arg: row
    pea     ($00C0).w                   ; arg: tile base ($C0)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0                      ; d3 * 8 (bytes per portrait entry)
    move.l  d0,-(sp)                    ; arg: portrait data offset
    clr.l   -(sp)
    pea     ($0740).w                   ; arg: VRAM dest tile index ($0740)
    jsr     (a5)                        ; display player portrait/indicator
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E (cmd=$E = 14): confirm display ready

; Wait for initial input (confirms player is ready to proceed)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec           ; jsr $01E1EC  -- wait for input (timeout=0)
    lea     $0028(sp),sp
    tst.w   d0                          ; d0 = 0 if no input / timeout
    beq.b   .l23f50
    moveq   #$1,d0                      ; input received
    bra.b   .l23f52
.l23f50:                                                ; $023F50
    moveq   #$0,d0                      ; no input
.l23f52:                                                ; $023F52
    move.w  d0,-$0002(a6)              ; input_pending = d0 (1 if input, 0 if timeout)
    clr.w   -$0004(a6)                 ; accumulated input state = 0
    clr.w   (a4)                        ; input_mode_flag ($FF13FC) = 0
    clr.w   ($00FFA7D8).l              ; input_init_flag ($FFA7D8) = 0
    dc.w    $4eb9,$0001,$d748           ; jsr $01D748  -- VBlank sync
    clr.w   d6                          ; d6 = sub-screen mode (0 = root/main)
    clr.w   d5                          ; d5 = animation frame counter

; --- Phase: main per-frame loop ---
; Handles redraw on state change (d4==1), input polling, animation tick,
; and button dispatch (bit-dispatch table at $240A0).
.l23f6c:                                                ; $023F6C
    cmpi.w  #$1,d4                      ; d4==1 -> forced redraw/refresh requested?
    bne.w   .l23ffe                     ; no -> check input_pending
    dc.w    $4eb9,$0001,$d71c           ; jsr $01D71C  -- VBlank sync

; Finalize revenue + expenses for current player (called on display refresh)
    pea     ($0001).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: screen_id
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0            ; current_player
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: player index
    dc.w    $4eb9,$0000,$6a2e           ; jsr $006A2E  -- finalize revenue (quarter_accum_a)
    pea     ($0002).w
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78           ; jsr $006B78  -- finalize expenses (quarter_accum_b)

; Refresh char code and re-draw portrait after finance update
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$c43c           ; jsr $01C43C  -- refresh char code for player
    lea     $001c(sp),sp
    bsr.w ValidateCharCode
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00C0).w
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w
    jsr     (a5)                        ; re-draw player portrait at tile $0740
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E: confirm redraw
    lea     $0024(sp),sp
    clr.w   d4                          ; clear redraw flag
    dc.w    $4eb9,$0001,$d748           ; jsr $01D748  -- VBlank sync

; Check input_pending flag -- poll if pending
.l23ffe:                                                ; $023FFE
    tst.w   -$0002(a6)                  ; input_pending?
    beq.b   .l24014                     ; no -> continue to button processing
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec           ; jsr $01E1EC  -- poll for more input
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l23f6c                     ; still active -> stay in loop

; --- Phase: input ended or timed out -- advance animation tick and process button ---
.l24014:                                                ; $024014
    clr.w   -$0002(a6)                  ; clear input_pending
    addq.w  #$1,d5                      ; d5++ (animation / blink counter)

; At tick 1: draw initial two tile overlays (intro animation keyframe)
    cmpi.w  #$1,d5
    bne.b   .l24080
    move.l  #$8000,-(sp)               ; tile priority flag
    pea     ($0001).w                   ; scale
    pea     ($0001).w                   ; col
    pea     ($00C5).w                   ; tile source offset ($C5)
    pea     ($0048).w                   ; x position
    pea     ($0039).w                   ; y position ($39 = row 57)
    pea     ($0770).w                   ; VRAM dest ($0770)
    jsr     (a5)                        ; draw overlay tile A at ($0039, $0048)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00D2).w                   ; tile source offset ($D2)
    pea     ($0048).w
    pea     ($003A).w                   ; y position ($3A = row 58)
    pea     ($0771).w                   ; VRAM dest ($0771)
    jsr     (a5)                        ; draw overlay tile B at ($003A, $0048)
    lea     $001c(sp),sp
.l24072:                                                ; $024072
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                        ; GameCommand $E: finalize tile update
    addq.l  #$8,sp
    bra.b   .l240a0                     ; -> button dispatch

; At tick $F (15): trigger a display refresh call
.l24080:                                                ; $024080
    cmpi.w  #$f,d5                      ; animation tick == 15?
    bne.b   .l24098
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8           ; jsr $01E0B8  -- partial display refresh (mode=2, y=$39)
    addq.l  #$8,sp
    bra.b   .l24072

; At tick $1E (30): wrap counter back to 0
.l24098:                                                ; $024098
    cmpi.w  #$1e,d5                     ; animation tick == 30?
    bne.b   .l240a0
    clr.w   d5                          ; reset animation counter

; --- Phase: button dispatch -- read input and decode action ---
; Calls $01E290 (ProcessInput) with accumulated state (-$0004(a6)) and 10-frame timeout.
; Returns button bitmask AND'd to $3F. Dispatches on individual bit values:
;   $10 (bit 4) -> beq $024298  (confirm/A button: accept selection)
;   $20 (bit 5) -> .l240ee      (B/start button: open sub-screens)
;   $08 (bit 3) -> beq $0241D2  (right: navigate right)
;   $04 (bit 2) -> beq $024232  (down: navigate down)
;   $01 (bit 0) -> beq $02424E  (left: navigate left)
;   $02 (bit 1) -> beq $024274  (up: navigate up)
;   none        -> bra $024280  (no input / timeout)
.l240a0:                                                ; $0240A0
    move.w  -$0004(a6),d0              ; accumulated button state
    move.l  d0,-(sp)                    ; arg: previous state
    pea     ($000A).w                   ; arg: $A = 10-frame timeout
    dc.w    $4eb9,$0001,$e290           ; jsr $01E290  -- ProcessInput: read buttons
    addq.l  #$8,sp
    andi.w  #$3f,d0                     ; mask to 6 action bits
    move.w  d0,-$0004(a6)              ; update accumulated state
    ext.l   d0
    moveq   #$10,d1
    cmp.w   d1,d0
    dc.w    $6700,$01d6                 ; beq.w $024298  -- Confirm/A: accept selection
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l240ee                     ; B/Start: open sub-screen or player info
    moveq   #$8,d1
    cmp.w   d1,d0
    dc.w    $6700,$0102                 ; beq.w $0241D2  -- Right: move cursor right
    moveq   #$4,d1
    cmp.w   d1,d0
    dc.w    $6700,$015a                 ; beq.w $024232  -- Down: move cursor down
    moveq   #$1,d1
    cmp.w   d1,d0
    dc.w    $6700,$016e                 ; beq.w $02424E  -- Left: move cursor left
    moveq   #$2,d1
    cmp.w   d1,d0
    dc.w    $6700,$018c                 ; beq.w $024274  -- Up: move cursor up
    dc.w    $6000,$0194                 ; bra.w $024280  -- No input: idle/timeout path

; --- B/Start button: dispatch to sub-screen or initiate trade prep ---
.l240ee:                                                ; $0240EE
    clr.w   (a4)                        ; clear input_mode_flag ($FF13FC)
    clr.w   ($00FFA7D8).l              ; clear input_init_flag ($FFA7D8)
    tst.w   d6                          ; d6 = sub-screen mode (0 = root)
    bne.b   .l24132                     ; d6 nonzero -> dispatch sub-screen table

; d6==0 (root screen): check if player has any route slots before allowing trade
    move.w  d2,d0
    mulu.w  #$24,d0                     ; player * $24 (player record stride)
    movea.l #$00ff0018,a0              ; player_records base
    lea     (a0,d0.w),a0
    movea.l a0,a2                       ; a2 = player record
    moveq   #$0,d0
    move.b  $0004(a2),d0               ; player_record.domestic_slots
    moveq   #$0,d1
    move.b  $0005(a2),d1               ; player_record.intl_slots
    add.l   d1,d0                       ; total_slots = domestic + international
    dc.w    $6f00,$016c                 ; ble.w $024288  -- no slots -> jump to idle (can't trade)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)                    ; arg: player index
    dc.w    $4eba,$021e                 ; jsr $024344  -- InitiateTradePrep (trade setup screen)
    nop
    addq.l  #$4,sp
    moveq   #$1,d4                      ; d4 = 1: trigger display refresh on next frame
    dc.w    $6000,$0158                 ; bra.w $024288  -- -> idle/loop back

; d6 nonzero: dispatch to one of 5 sub-screen handlers via a jump table
.l24132:                                                ; $024132
; d6 encodes the active sub-screen (1-5 valid range).
; Dispatch: (d6 - 1) * 2 -> jump table offset (5 entries × word offsets)
    move.w  d6,d0
    ext.l   d0
    subq.l  #$1,d0                      ; d0 = d6 - 1 (0-based)
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$014a                 ; bhi.w $024288  -- d6 > 5 -> idle (out of range)
    add.l   d0,d0                       ; d0 * 2 = word offset into jump table
    move.w  $2414a(pc,d0.l),d0         ; load signed word displacement from table at $02414A
    jmp     $2414a(pc,d0.w)            ; PC-relative jump: dispatch to sub-screen handler
    ; WARNING: 514 undecoded trailing bytes at $02414A
    ; Jump table (5 entries × word = 10 bytes, then handler code follows):
    ;   entry 0 ($000A): sub-screen 1 handler -- player info / char list view
    ;   entry 1 ($0040): sub-screen 2 handler
    ;   entry 2 ($004E): sub-screen 3 handler
    ;   entry 3 ($005C): sub-screen 4 handler
    ;   entry 4 ($0070): sub-screen 5 handler
    dc.w    $000a
    dc.w    $0040
    dc.w    $004e
    dc.w    $005c
    dc.w    $0070
    dc.w    $4878
    dc.w    $077d
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $0016
    dc.w    $4878
    dc.w    $0017
    dc.w    $4878
    dc.w    $0009
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $001a
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $001c
    dc.w    $4878
    dc.w    $0004
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $12ee
    dc.w    $508f
    dc.w    $60a2
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $0d68
    dc.w    $4e71
    dc.w    $6092
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $08aa
    dc.w    $4e71
    dc.w    $6084
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $10a0
    dc.w    $4e71
    dc.w    $60cc
    dc.w    $3002
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eba
    dc.w    $1c82
    dc.w    $4e71
    dc.w    $588f
    dc.w    $4eba
    dc.w    $1f28
    dc.w    $4e71
    dc.w    $6000
    dc.w    $ff5c
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5680
    dc.w    $721d
    dc.w    $b280
    dc.w    $6f08
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5680
    dc.w    $6002
    dc.w    $701d
    dc.w    $3600
    dc.w    $48c0
    dc.w    $0480
    dc.w    $0000
    dc.w    $000e
    dc.w    $7203
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $e08a
    dc.w    $3c00
    dc.w    $2f3c
    dc.w    $0000
    dc.w    $8000
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $0002
    dc.w    $4878
    dc.w    $00c0
    dc.w    $3003
    dc.w    $48c0
    dc.w    $e788
    dc.w    $2f00
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0740
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $0024
    dc.w    $6056
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5780
    dc.w    $720e
    dc.w    $b280
    dc.w    $6c08
    dc.w    $3003
    dc.w    $48c0
    dc.w    $5780
    dc.w    $60a2
    dc.w    $700e
    dc.w    $609e
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3002
    dc.w    $48c0
    dc.w    $5680
    dc.w    $7204
    dc.w    $4eb9
    dc.w    $0003
    dc.w    $e146
    dc.w    $3400
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $c43c
    dc.w    $588f
    dc.w    $6100
    dc.w    $fbd0
    dc.w    $6014
    dc.w    $38bc
    dc.w    $0001
    dc.w    $3002
    dc.w    $48c0
    dc.w    $5280
    dc.w    $60d8
    dc.w    $4254
    dc.w    $4279
    dc.w    $00ff
    dc.w    $a7d8
    dc.w    $4878
    dc.w    $0003
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $508f
    dc.w    $6000
    dc.w    $fcd6
    dc.w    $4254
    dc.w    $4279
    dc.w    $00ff
    dc.w    $a7d8
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0001
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $42a7
    dc.w    $4e95
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $000e
    dc.w    $4e93
    dc.w    $4fef
    dc.w    $0024
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $b042
    dc.w    $6748
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $4878
    dc.w    $0001
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6a2e
    dc.w    $4878
    dc.w    $0002
    dc.w    $3007
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $7000
    dc.w    $1039
    dc.w    $00ff
    dc.w    $0016
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6b78
    dc.w    $4fef
    dc.w    $0018
    dc.w    $6100
    dc.w    $fb2e
    dc.w    $6024
    dc.w    $42a7
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $538e
    dc.w    $4878
    dc.w    $077d
    dc.w    $4878
    dc.w    $0009
    dc.w    $4878
    dc.w    $0020
    dc.w    $4878
    dc.w    $0014
    dc.w    $42a7
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $001a
    dc.w    $4e93
    dc.w    $4cee
    dc.w    $3cfc
    dc.w    $ffd4
    dc.w    $4e5e
    dc.w    $4e75
    dc.w    $4e56
    dc.w    $fff8
    dc.w    $48e7
    dc.w    $3f3c
; === Translated block $02434C-$026270 ===
; 14 functions, 7972 bytes
