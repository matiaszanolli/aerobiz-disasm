; ============================================================================
; ShowRouteDetailsDialog -- Draws a pop-up dialog showing route details; fills tile rectangles for text rows and renders city-pair info.
; 730 bytes | $011014-$0112ED
;
; Args:
;   $8(a6)  = d4: player index (0-3)
;   $c(a6)  = d3: slot index within player's $FF0338 table (0-3)
;
; Registers set up in prologue:
;   a3 = $3B246 (PrintfNarrow function pointer)
;   a4 = $3AB2C (SetTextCursor function pointer)
;   a5 = $1E0B8 (GameCmd16 function pointer -- thin wrapper for GameCommand #16)
;
; Key RAM / ROM:
;   $FF0338 = player event/slot table, stride $20 per player, $8 per slot.
;             Slot fields: +$0=city_a, +$1=type/state, +$2=subtype, +$3=extra,
;                          +$6=slot_field_6 (compared to #3 for RangeLookup branch).
;   $5EC84  = region name string pointer table, indexed region*4.
;   $47818  = char name string pointer table for portrait display.
;   $477E8  = route-type name string pointer table.
; ============================================================================
ShowRouteDetailsDialog:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    ; --- Phase: Load arguments ---
    move.l  $c(a6), d3                              ; d3 = slot index (0-3)
    move.l  $8(a6), d4                              ; d4 = player index (0-3)
    movea.l  #$0003B246,a3                          ; a3 = PrintfNarrow function pointer
    movea.l  #$0003AB2C,a4                          ; a4 = SetTextCursor function pointer
    movea.l  #$0001E0B8,a5                          ; a5 = GameCmd16 (clear/place via cmd #16)
    ; --- Phase: Clear dialog background area via GameCommand #$1A ---
    ; GameCommand #$1A = ClearTileArea: args (priority, height, width, y, x, 0, cmd)
    ; $8000 = priority bit set (clears in foreground plane)
    move.l  #$8000, -(a7)                           ; priority = $8000
    pea     ($0008).w                               ; height = 8 rows
    pea     ($0008).w                               ; width = 8 cols
    pea     ($0009).w                               ; y = 9
    pea     ($0004).w                               ; x = 4
    clr.l   -(a7)                                   ; extra = 0
    pea     ($001A).w                               ; GameCommand #$1A = ClearTileArea
    jsr GameCommand
    lea     $1c(a7), a7                             ; pop 7 longwords
    ; --- Phase: Fill tile rectangles for 3 dialog text rows ---
    ; FillTileRect args: tile_id, height, 0, width, col, row, 1, 1
    ; Row 1: tile $075C at row 9, col 1, 4 wide x 11 tall
    pea     ($075C).w                               ; tile $075C = dialog background row 1
    pea     ($0002).w                               ; height = 2
    clr.l   -(a7)
    pea     ($0004).w                               ; width = 4
    pea     ($000B).w                               ; col = 11
    pea     ($0009).w                               ; row = 9
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    ; Row 2: tile $075D at row 13
    pea     ($075D).w                               ; tile $075D = dialog background row 2
    pea     ($000A).w                               ; height = 10
    clr.l   -(a7)
    pea     ($0002).w                               ; width = 2
    pea     ($000B).w                               ; col = 11
    pea     ($000D).w                               ; row = 13
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    ; Row 3: tile $075E at row 15
    pea     ($075E).w                               ; tile $075E = dialog background row 3
    pea     ($000B).w                               ; height = 11
    clr.l   -(a7)
    pea     ($0002).w                               ; width = 2
    pea     ($000B).w                               ; col = 11
    pea     ($000F).w                               ; row = 15
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    ; --- Phase: Decompress and place route icon graphic ---
    move.l  ($000A1B2C).l, -(a7)                   ; push compressed data pointer from $A1B2C
    pea     ($00FF1804).l                           ; decompress into save_buf_base ($FF1804)
    jsr LZ_Decompress
    lea     $28(a7), a7
    ; --- Place decompressed tile graphic: 18 tiles wide, at tile index $3E1 ---
    pea     ($0012).w                               ; width = $12 = 18 tiles
    pea     ($03E1).w                               ; VRAM tile index $3E1
    pea     ($00FF1804).l                           ; source: decompressed data at $FF1804
    jsr CmdPlaceTile
    ; --- Phase: Place 3 text labels at fixed dialog positions via GameCommand #$1B ---
    ; GameCommand #$1B = SetTextCursor + print string at (x,y,width,height)
    pea     ($00072658).l                           ; string ptr: route label 1 text
    pea     ($0002).w                               ; width
    pea     ($0003).w                               ; height
    pea     ($0009).w                               ; y = 9 (row 1)
    pea     ($0001).w                               ; x = 1
    clr.l   -(a7)
    pea     ($001B).w                               ; GameCommand #$1B = DrawText
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($00072664).l                           ; string ptr: route label 2 text
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000D).w                               ; y = 13 (row 2)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($00072670).l                           ; string ptr: route label 3 text
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000F).w                               ; y = 15 (row 3)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    ; --- Phase: Clear sprites (#$37) via GameCmd16 ---
    pea     ($0002).w                               ; arg2
    pea     ($0037).w                               ; cmd $37 = clear char sprites
    jsr     (a5)                                    ; GameCmd16 ($1E0B8)
    lea     $24(a7), a7
    ; --- Phase: Check whether this player/slot has a valid roster entry ---
    cmpi.w  #$4, d3                                 ; slot >= 4?
    bge.w   l_112dc                                 ; yes -> nothing to render, early exit
    ; Compute pointer into $FF0338 for this player/slot
    ; Layout: player_stride=$20, slot_stride=$8
    move.w  d4, d0
    lsl.w   #$5, d0                                 ; player * $20
    move.w  d3, d1
    lsl.w   #$3, d1                                 ; slot * $8
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2                                  ; a2 = slot entry for (player, slot)
    tst.b   $1(a2)                                  ; slot +$1 = state byte (0 = empty)
    beq.w   l_112dc                                 ; empty slot -> early exit
    ; --- Phase: Set text window for char info display ---
    pea     ($0006).w                               ; window width
    pea     ($0009).w                               ; window x
    pea     ($000B).w                               ; window y
    pea     ($0004).w                               ; window height
    jsr SetTextWindow
    ; --- Clear sprites again before placing portrait ---
    pea     ($0002).w
    pea     ($0037).w
    jsr     (a5)                                    ; GameCmd16: clear sprites
    lea     $18(a7), a7
    ; --- Branch: slot +$1 == 6 means use RangeLookup path, else direct char display ---
    cmpi.b  #$6, $1(a2)                             ; state byte == 6?
    beq.b   l_11210                                 ; yes -> RangeLookup branch
    ; --- Direct path: place char portrait sprite ---
    pea     ($0001).w                               ; arg: flag 1
    pea     ($0640).w                               ; Y position $640
    clr.l   -(a7)
    pea     ($0058).w                               ; X position $58
    pea     ($0008).w                               ; palette index 8
    moveq   #$0,d0
    move.b  (a2), d0                                ; slot +$0 = city/char code
    ext.l   d0
    move.l  d0, -(a7)                               ; char index for portrait
    jsr PlaceCharSprite                             ; decompress and place portrait sprite
    pea     ($0009).w                               ; cursor x = 9
    pea     ($0004).w                               ; cursor y = 4
    jsr     (a4)                                    ; SetTextCursor
    lea     $20(a7), a7
    ; --- Print char name via pointer table at $47818 ---
    moveq   #$0,d0
    move.b  (a2), d0                                ; city/char code from slot +$0
    lsl.w   #$2, d0                                 ; * 4 = longword index into name table
    movea.l  #$00047818,a0                          ; char name pointer table
    move.l  (a0,d0.w), -(a7)                        ; push name string pointer
    jsr PrintfWide                                  ; print char name in wide font
l_1120c:
    addq.l  #$4, a7
    bra.b   l_11274                                 ; -> print route type name
l_11210:
    ; --- RangeLookup path: slot +$1 == 6, slot +$6 == 3 means use RangeLookup ---
    cmpi.w  #$3, $6(a2)                             ; field +$6 == 3?
    bne.b   l_1122a
    moveq   #$0,d0
    move.b  (a2), d0                                ; city/char code from slot +$0
    move.l  d0, -(a7)
    jsr RangeLookup                                 ; map city code to region index (0-7)
    addq.l  #$4, a7
    move.w  d0, d2                                  ; d2 = region index
    bra.b   l_1122e
l_1122a:
    ; --- Field +$6 != 3: use city code directly as display index ---
    moveq   #$0,d2
    move.b  (a2), d2                                ; d2 = city/char code directly
l_1122e:
    ; --- Set text cursor for the text area ---
    pea     ($0009).w                               ; cursor x = 9
    pea     ($0004).w                               ; cursor y = 4
    jsr     (a4)                                    ; SetTextCursor
    addq.l  #$8, a7
    ; --- Select and print the appropriate region/city string ---
    cmpi.w  #$3, d2                                 ; region index == 3?
    bne.b   l_1124a
    pea     ($0003F116).l                           ; string for region 3
l_11246:
    jsr     (a3)                                    ; PrintfNarrow
    bra.b   l_1120c
l_1124a:
    cmpi.w  #$2, d2                                 ; region index == 2?
    bne.b   l_11258
    pea     ($0003F10A).l                           ; string for region 2
    bra.b   l_11246
l_11258:
    ; --- Other region: look up in region name table $5EC84 ---
    move.w  d2, d0
    lsl.w   #$2, d0                                 ; region * 4
    movea.l  #$0005EC84,a0                          ; region name string pointer table
    move.l  (a0,d0.w), -(a7)                        ; push region name string
    pea     ($0003F106).l                           ; format string prefix
    jsr PrintfWide                                  ; print "Region: <name>" wide font
    addq.l  #$8, a7
l_11274:
    ; --- Phase: Print route type name (from slot +$1, zero-based -> display index) ---
    moveq   #$0,d2
    move.b  $1(a2), d2                              ; slot +$1 = state/type byte
    addi.w  #$ffff, d2                              ; d2 -= 1 (convert to 0-based index)
    pea     ($000D).w                               ; cursor x = $D = 13
    pea     ($0004).w                               ; cursor y = 4
    jsr     (a4)                                    ; SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0                                 ; route type index * 4
    movea.l  #$000477E8,a0                          ; route-type name string pointer table
    move.l  (a0,d0.w), -(a7)                        ; push route type name string
    jsr     (a3)                                    ; PrintfNarrow: print route type name
    ; --- Phase: Compute and display route revenue via CalcRouteRevenue ---
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; slot index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; player index
    jsr (CalcRouteRevenue,PC)                       ; calculate revenue for this route slot
    nop
    move.w  d0, d3                                  ; d3 = revenue result
    pea     ($000F).w                               ; cursor x = $F = 15
    pea     ($0004).w                               ; cursor y = 4
    jsr     (a4)                                    ; SetTextCursor
    lea     $1c(a7), a7
    ; --- Branch on revenue threshold: $C = 12 is the max-profit cutoff ---
    cmpi.w  #$c, d3                                 ; revenue <= $C (within range)?
    bgt.b   l_112d0
    ; --- Revenue in range: print numeric value ---
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)                               ; revenue value
    pea     ($0003F0FA).l                           ; format string "%d" for numeric revenue
    jsr     (a3)                                    ; PrintfNarrow
    bra.b   l_112e4
l_112d0:
    ; --- Revenue > $C: print "FULL" or maximum indicator string ---
    pea     ($0003F0EC).l                           ; string "FULL" or profit-max indicator
    jsr     (a3)                                    ; PrintfNarrow
    addq.l  #$4, a7
    bra.b   l_112e4
l_112dc:
    ; --- Early exit: slot invalid or empty -- show blank with sprite clear ---
    pea     ($0002).w
    clr.l   -(a7)
    jsr     (a5)                                    ; GameCmd16 with 0: final sprite clear
l_112e4:
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts
