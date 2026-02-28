; ============================================================================
; DisplayPlayerStatsScreen -- Loads resources and renders the full player stats screen showing profit/loss, rank, route type summary, and character employment for one player, then waits for a button press.
; 686 bytes | $025E44-$0260F1
;
; Arg (on stack, no link frame -- leaf-like calling convention):
;   $20(a7) = player index (0-3) after movem pushes d2-d4/a2-a5 (7 regs = $1C) + $4 = $20
;
; Registers set up in prologue:
;   a4 = $3B246 (PrintfNarrow function pointer)
;   a5 = $3AB2C (SetTextCursor function pointer)
;   a2 = player_record base (player_records[$FF0018] + player*$24)
;   d3 = region index (from RangeLookup on hub city)
;
; Key RAM:
;   $FF0018 = player_records base. Stride $24 per player. +$01 = hub_city byte.
;   $FF0004 = current year word (incremented each game year).
;   $FF0002 = scenario/turn number word.
;   $FF0270 = unknown per-player table, stride $8 per player, 7 x byte entries.
;   $FF0130 = unknown per-player table, stride $20 per player, 7 x long entries.
;
; Key ROM tables:
;   $5EC84  = region name string pointer table, indexed region*4.
;   $5F6DE  = year-label string pointer table, indexed year*4.
;   $414DA  = "PROFIT/LOSS" header string.
;   $41498  = region display format string.
;   $41476  = below-threshold profit string.
;   $41452  = above-threshold profit string.
;   $41438/$41436/$41434/$41432/$41430 = route-type icon strings (5 single chars).
;   $41418  = employment count format string "%d".
;   $41414  = "none" employment string.
;   $4141C  = special employment string (for entry d2==2).
;   $4142C  = employment row label format string.
;   $4140E  = year display format string.
; ============================================================================
DisplayPlayerStatsScreen:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $20(a7), d2                             ; d2 = player index (0-3)
    movea.l  #$0003B246,a4                          ; a4 = PrintfNarrow function pointer
    movea.l  #$0003AB2C,a5                          ; a5 = SetTextCursor function pointer
    ; --- Phase: Load player record and determine region ---
    move.w  d2, d0
    mulu.w  #$24, d0                                ; player * $24 (player record stride)
    movea.l  #$00FF0018,a0                          ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = player record for this player
    ; Map hub city to region index via RangeLookup
    moveq   #$0,d0
    move.b  $1(a2), d0                              ; player_record[+$01] = hub_city byte
    ext.l   d0
    move.l  d0, -(a7)                               ; push hub city index
    jsr RangeLookup                                 ; d0 = region index (0-7)
    move.w  d0, d3                                  ; d3 = region index
    ; --- Phase: Load screen resources ---
    jsr ResourceLoad                                ; load this screen's graphics resource
    jsr PreLoopInit                                 ; one-time pre-loop initialisation
    ; --- Phase: First ShowPlayerInfo call (sets up the player info bar) ---
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; player index
    jsr ShowPlayerInfo
    ; --- Phase: Load the map screen for this player's region ---
    clr.l   -(a7)                                   ; extra arg = 0
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; region index
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; player index
    jsr LoadScreen                                  ; load the region map screen
    ; --- Phase: Display setup and second ShowPlayerInfo (refreshes after screen load) ---
    pea     ($0010).w                               ; arg
    pea     ($0010).w
    pea     ($0004A598).l                           ; display setup parameter table
    jsr DisplaySetup
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo                              ; refresh player info overlay
    lea     $24(a7), a7
    ; --- Phase: Read current year and draw profit/loss box ---
    move.w  ($00FF0004).l, d4                       ; d4 = current year (from $FF0004)
    addq.w  #$4, d4                                 ; d4 = year + 4 (display offset / threshold)
    pea     ($0017).w                               ; box width = $17 = 23
    pea     ($0018).w                               ; box height = $18 = 24
    pea     ($0001).w                               ; box x = 1
    pea     ($0004).w                               ; box y = 4
    jsr DrawBox
    ; --- Phase: Print "PROFIT/LOSS" header at (x=2, y=6) ---
    pea     ($0002).w                               ; cursor x = 2
    pea     ($0006).w                               ; cursor y = 6
    jsr     (a5)                                    ; SetTextCursor
    pea     ($000414DA).l                           ; "PROFIT/LOSS" header string
    jsr     (a4)                                    ; PrintfNarrow
    ; --- Phase: Set text window and print region name ---
    pea     ($0009).w                               ; window width = 9
    pea     ($0015).w                               ; window right = $15 = 21
    pea     ($0004).w                               ; window top = 4
    pea     ($0006).w                               ; window height = 6
    jsr SetTextWindow
    lea     $2c(a7), a7
    ; Look up region name string and print it
    move.w  d3, d0
    lsl.w   #$2, d0                                 ; region * 4
    movea.l  #$0005EC84,a0                          ; region name pointer table
    move.l  (a0,d0.w), -(a7)                        ; push region name string
    pea     ($00041498).l                           ; format string for region display
    jsr     (a4)                                    ; PrintfNarrow: "Region: <name>"
    ; --- Phase: Print profit/loss value at (x=9, y=6) ---
    pea     ($0009).w
    pea     ($0006).w
    jsr     (a5)                                    ; SetTextCursor
    lea     $10(a7), a7
    ; Branch on year+4 vs threshold 7 for the profit/loss format
    cmpi.w  #$7, d4                                 ; year + 4 >= 7 (i.e. year >= 3)?
    bge.b   .l25f52
    ; Below threshold: print numeric profit/loss
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041476).l                           ; below-threshold profit format string
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l25f5c
.l25f52:
    ; At or above threshold: print "FULL" / max-profit indicator
    pea     ($00041452).l                           ; above-threshold / max profit string
    jsr     (a4)
    addq.l  #$4, a7
.l25f5c:
    ; --- Phase: Print 5 route-type icon characters across row 5 ---
    ; These are single-character icons for each route category.
    pea     ($000B).w                               ; cursor x = $B = 11
    pea     ($0006).w                               ; cursor y = 6
    jsr     (a5)
    pea     ($00041438).l                           ; route-type icon char 5
    jsr     (a4)
    pea     ($0004).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041436).l                           ; route-type icon char 4
    jsr     (a4)
    pea     ($0006).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041434).l                           ; route-type icon char 3
    jsr     (a4)
    pea     ($0009).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041432).l                           ; route-type icon char 2
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($000B).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041430).l                           ; route-type icon char 1
    jsr     (a4)
    ; --- Phase: Expand text window to full area for the employment table ---
    pea     ($0020).w                               ; full width
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $1c(a7), a7
    ; --- Phase: Set up pointers for the 7-row employment loop ---
    ; $FF0270: per-player byte table, stride $8. Bytes hold employment status/count.
    move.w  d2, d0
    lsl.w   #$3, d0                                 ; player * 8
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = $FF0270[player] (byte entries)
    ; $FF0130: per-player long table, stride $20. Longs hold accumulated stat values.
    move.w  d2, d0
    lsl.w   #$5, d0                                 ; player * $20
    movea.l  #$00FF0130,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3                                  ; a3 = $FF0130[player] (long entries)
    clr.w   d2                                      ; d2 = row counter (0..6)
.l25ff2:
    ; --- Employment loop: 7 rows, one per route/employment category ---
    moveq   #$5,d4                                  ; cursor y base = 5
    move.w  d2, d3
    addi.w  #$e, d3                                 ; d3 = cursor x = row + $E = 14..20
    ; Print row label at (x=d3, y=5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)                                    ; SetTextCursor (x=d3, y=5)
    ; Special string for row 2; others look up via $5EC84 region table
    cmpi.w  #$2, d2                                 ; row == 2?
    bne.b   .l26016
    pea     ($0004141C).l                           ; special label for row 2
    bra.b   .l26024
.l26016:
    move.w  d2, d0
    lsl.w   #$2, d0                                 ; row * 4
    movea.l  #$0005EC84,a0                          ; region name/category string table
    move.l  (a0,d0.w), -(a7)                        ; category string for this row
.l26024:
    pea     ($0004142C).l                           ; row label format string
    jsr     (a4)                                    ; PrintfNarrow: print category label
    ; Print employment count/status at (x=d3, y=$16)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$11, d0                                ; y = 5 + $11 = $16 = 22
    move.l  d0, -(a7)
    jsr     (a5)                                    ; SetTextCursor
    lea     $18(a7), a7
    ; Check the long value in $FF0130 for this row -- positive = employed, 0/neg = none
    tst.l   (a3)                                    ; $FF0130[player][row] > 0?
    ble.b   .l2605a
    ; Positive: show the count from $FF0270 byte table
    moveq   #$0,d0
    move.b  (a2), d0                                ; $FF0270[player][row] = employment count byte
    move.l  d0, -(a7)
    pea     ($00041418).l                           ; format string "%d"
    jsr     (a4)                                    ; PrintfNarrow: print count
    addq.l  #$8, a7
    bra.b   .l26064
.l2605a:
    ; Zero or negative: print "none" string
    pea     ($00041414).l                           ; "none" / empty employment string
    jsr     (a4)
    addq.l  #$4, a7
.l26064:
    addq.l  #$1, a2                                 ; advance to next byte in $FF0270
    addq.l  #$4, a3                                 ; advance to next long in $FF0130
    addq.w  #$1, d2                                 ; row++
    cmpi.w  #$7, d2                                 ; all 7 rows done?
    blt.w   .l25ff2
    ; --- Phase: Print current year value ---
    ; Year display offset: ($FF0002 * $F) + $7A3
    move.w  ($00FF0002).l, d2                       ; d2 = scenario/turn number
    mulu.w  #$f, d2                                 ; * 15
    addi.w  #$7a3, d2                               ; + $7A3 = display offset (NOTE: may overflow)
    pea     ($0016).w                               ; cursor x = $16 = 22
    pea     ($0005).w                               ; cursor y = 5
    jsr     (a5)                                    ; SetTextCursor
    move.w  ($00FF0004).l, d0                       ; d0 = current year
    ext.l   d0
    lsl.l   #$2, d0                                 ; year * 4 = longword index
    movea.l  #$0005F6DE,a0                          ; year-label string pointer table
    move.l  (a0,d0.l), -(a7)                        ; push year label string pointer
    jsr     (a4)                                    ; PrintfNarrow: print year label
    ; --- Phase: Print computed year offset value at (x=$16, y=$10) ---
    pea     ($0016).w
    pea     ($0010).w
    jsr     (a5)                                    ; SetTextCursor
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0                                ; d2 + $14 = 20
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004140E).l                           ; year display format string
    jsr     (a4)                                    ; PrintfNarrow
    lea     $20(a7), a7
    ; --- Phase: Unload resources, then wait for A or Start button ---
    jsr ResourceUnload
.l260ce:
    pea     ($0001).w                               ; PollAction arg: mode 1
    pea     ($0003).w                               ; PollAction arg: button mask $3 (A + Start)
    jsr PollAction                                  ; wait for button; d0 = pressed bits
    addq.l  #$8, a7
    andi.l  #$30, d0                                ; test bits $10 (A) and $20 (Start)
    beq.b   .l260ce                                 ; neither pressed -> keep waiting
    ; --- Phase: Reload resources before returning ---
    jsr ResourceLoad
    movem.l (a7)+, d2-d4/a2-a5
    rts
