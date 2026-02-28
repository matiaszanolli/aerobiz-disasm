; ============================================================================
; BrowseMapPages -- Draws a paginated character/city map list with two tile columns per entry and runs a navigation loop; returns the selected index or -1 for cancel
; ============================================================================
; Arg: $0028(sp) = browse_flags (d6): 0 = require checksum validation on select, nonzero = skip validation
; Returns: d0.w = selected item index (d3), or -1 ($FFFF) on cancel
;
; Register map:
;   a2 = $0D64        -- GameCommand (cached)
;   a3 = $00FF13FC    -- input_mode_flag: nonzero = countdown/input-mode active
;   a4 = $0001E044    -- TilePlacement (cached)
;   a5 = $0004C974    -- ROM graphics descriptor base (background tile table)
;   d3 = current page/item index (0 = first page, 1 = second page; used as result)
;   d4 = secondary input flag (1 = two-input mode, reads second controller)
;   d5 = last button-word from ProcessInputLoop (accumulated d-pad state)
;   d6 = browse_flags (arg, preserved)
BrowseMapPages:                                                  ; $017566
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d6            ; d6 = browse_flags arg
    movea.l #$0d64,a2               ; a2 = GameCommand ($0D64)
    movea.l #$00ff13fc,a3           ; a3 = input_mode_flag ($FF13FC)
    movea.l #$0001e044,a4           ; a4 = TilePlacement ($01E044)
    movea.l #$0004c974,a5           ; a5 = ROM graphics table base
    ; --- Phase: Draw background and main panel ---
    pea     ($0010).w               ; height = $10
    pea     ($0010).w               ; width = $10
    move.l  a5,d0
    addq.l  #$2,d0                  ; d0 = a5+2: adjusted pointer into graphics table
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092): set up background display
    ; GameCommand #$1B: draw map list panel tile block
    move.l  a5,d0
    moveq   #$22,d1
    add.l   d1,d0                   ; d0 = a5+$22: panel tile descriptor
    move.l  d0,-(sp)
    pea     ($001C).w               ; height = $1C
    pea     ($0020).w               ; width = $20
    clr.l   -(sp)                   ; Y = 0
    clr.l   -(sp)                   ; X = 0
    pea     ($0001).w               ; arg: 1
    pea     ($001B).w               ; GameCommand #$1B = place tile block
    jsr     (a2)                    ; GameCommand
    ; LZ decompress city/map icon tiles to save buffer
    move.l  a5,d0
    addi.l  #$0722,d0               ; d0 = a5+$722: compressed map tile data in ROM
    move.l  d0,-(sp)
    pea     ($00FF1804).l           ; save_buf_base: decompression output
    dc.w    $4eb9,$0000,$3fec       ; jsr LZ_Decompress: decompress map tiles
    lea     $0030(sp),sp            ; clean up $30 ($C args)
    ; VRAMBulkLoad: DMA map tiles to VRAM
    pea     ($0001).w               ; flags
    clr.l   -(sp)                   ; offset = 0
    pea     ($00FF1804).l           ; tile buffer
    pea     ($0104).w               ; $104 = 260 tiles
    pea     ($0001).w               ; mode 1
    dc.w    $4eb9,$0001,$d568       ; jsr VRAMBulkLoad ($01D568)
    dc.w    $4eb9,$0001,$d748       ; jsr ResourceUnload ($01D748)
    ; SetTextWindow: full-screen window for city list display
    pea     ($0020).w               ; height = $20 rows
    pea     ($0020).w               ; width = $20 cols
    clr.l   -(sp)                   ; Y = 0
    clr.l   -(sp)                   ; X = 0
    dc.w    $4eb9,$0003,$a942       ; jsr SetTextWindow ($03A942)
    ; ReadInput: initial button read to determine d4 (secondary input mode)
    clr.l   -(sp)                   ; mode = 0
    dc.w    $4eb9,$0001,$e1ec       ; jsr ReadInput ($01E1EC): read joypad via GameCmd #10
    lea     $0028(sp),sp            ; clean up $A args
    ; d4 = secondary input flag: 1 if input was pressed (nonzero), else 0
    tst.w   d0
    beq.b   .l17618                 ; d0 == 0 -> d4 = 0
    moveq   #$1,d4                  ; button held on entry -> two-input mode
    bra.b   .l1761a
.l17618:                                                ; $017618
    moveq   #$0,d4                  ; no button -> single-input mode
.l1761a:                                                ; $01761A
    ; --- Phase: Initialize navigation loop state ---
    clr.w   d5                      ; d5 = accumulated button state
    clr.w   (a3)                    ; input_mode_flag = 0 (clear countdown mode)
    clr.w   ($00FFA7D8).l           ; input_init_flag = 0 ($FFA7D8): reset ProcessInputLoop countdown
    clr.w   d3                      ; d3 = current page index (0 = first page)
.l17626:                                                ; $017626
    ; --- Phase: Draw current page entries (two tile columns per entry) ---
    ; Compute X column for page d3: column = d3 * $B + 3
    move.w  d3,d2
    ext.l   d2
    move.l  d2,d0
    moveq   #$b,d1                  ; stride = $B cols per page
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = d3 * $B
    move.l  d0,d2
    addq.l  #$3,d2                  ; d2 = d3*$B + 3 (left column offset)
    ; SetTextCursor: position text cursor at column d2, row 2
    move.l  d2,-(sp)                ; X = d2
    pea     ($0002).w               ; Y = 2
    dc.w    $4eb9,$0003,$ab2c       ; jsr SetTextCursor ($03AB2C)
    ; TilePlacement: place first tile column at left position
    ; tile_char=$544 (first column icon), X = d2*8, Y=$10, width=2, priority=$8000
    move.l  #$8000,-(sp)            ; priority = $8000 (high priority)
    pea     ($0002).w               ; tile width = 2
    pea     ($0001).w               ; tile height = 1
    move.l  d2,d0
    lsl.l   #$3,d0                  ; d0 = d2 * 8 (pixel X from tile column)
    move.l  d0,-(sp)                ; X pixel position
    pea     ($0010).w               ; Y pixel position = $10 = 16
    clr.l   -(sp)                   ; tile pattern offset = 0
    pea     ($0544).w               ; tile char = $544 (first column icon)
    jsr     (a4)                    ; TilePlacement
    pea     ($0001).w               ; arg: 1
    pea     ($000E).w               ; GameCommand #$E = flush
    jsr     (a2)                    ; GameCommand
    lea     $002c(sp),sp            ; clean up $2C ($B args)
    ; --- Phase: Secondary input check (d4=1 reads two controllers) ---
    tst.w   d4                      ; secondary input mode?
    beq.b   .l17692                 ; no -> go straight to ProcessInputLoop
    clr.l   -(sp)                   ; mode = 0
    dc.w    $4eb9,$0001,$e1ec       ; jsr ReadInput: read secondary controller
    addq.l  #$4,sp
    tst.w   d0                      ; any input?
    beq.b   .l17692                 ; no -> fall through to ProcessInputLoop
    ; Input detected from secondary controller: use mode $3 (immediate)
    pea     ($0003).w
.l17688:                                                ; $017688
    ; GameCommand #$E with mode arg (from d-pad scroll or secondary input)
    pea     ($000E).w               ; GameCommand #$E
    jsr     (a2)                    ; GameCommand
    addq.l  #$8,sp                  ; clean up 2 args
    bra.b   .l17626                 ; redraw page
.l17692:                                                ; $017692
    ; --- Phase: Wait for d-pad input via ProcessInputLoop ---
    clr.w   d4                      ; reset secondary input flag
    move.w  d5,d0
    move.l  d0,-(sp)                ; push previous button state
    pea     ($000A).w               ; timeout = $A frames
    dc.w    $4eb9,$0001,$e290       ; jsr ProcessInputLoop ($01E290): block until input or timeout
    addq.l  #$8,sp
    andi.w  #$33,d0                 ; mask: $33 = bits 0,1,4,5 (Up/Down/Left/Right d-pad bits)
    move.w  d0,d5                   ; d5 = masked button word (d-pad only)
    andi.w  #$30,d0                 ; check Left/Right bits ($30 = bit4+bit5)
    beq.w   .l1774a                 ; no left/right -> check up/down
    ; Left or Right pressed -> clear input state, check confirm or page flip
    clr.w   (a3)                    ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l           ; input_init_flag = 0
    ; Check if Right was pressed (bit5 = $20)
    move.w  d5,d0
    andi.w  #$20,d0                 ; Right d-pad?
    beq.w   .l17746                 ; no Right -> return -1 (cancel)
    ; Right pressed: validate or directly confirm selection
    tst.w   d6                      ; browse_flags: skip validation?
    bne.b   .l176da                 ; nonzero -> skip VerifyChecksum
    ; Validate selection via VerifyChecksum
    move.w  d3,d0
    move.l  d0,-(sp)                ; push current page/item index
    dc.w    $4eb9,$0000,$f552       ; jsr VerifyChecksum ($00F552): validate data at d3
    addq.l  #$4,sp
    tst.w   d0                      ; valid?
    beq.w   .l177a4                 ; failed -> loop (don't advance)
.l176da:                                                ; $0176DA
    ; --- Phase: Selection confirmed -- show second (right) column tile ---
    ; First tile column placement for selected entry (same tile index $546)
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c       ; jsr Multiply32: d0 = d3 * $B
    addq.l  #$3,d0                  ; d0 = d3*$B + 3
    move.l  d0,d2                   ; d2 = column offset for this entry
    lsl.l   #$3,d0                  ; d0 = column * 8 (pixel X)
    move.l  d0,-(sp)
    pea     ($0010).w               ; Y = $10
    clr.l   -(sp)
    pea     ($0546).w               ; tile char = $546 (selected/highlighted icon)
    jsr     (a4)                    ; TilePlacement: first column
    pea     ($000F).w               ; arg: $F
    pea     ($000E).w               ; GameCommand #$E
    jsr     (a2)
    lea     $0024(sp),sp
    ; Second tile column (tile $548, adjacent column)
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2,d0
    lsl.l   #$3,d0                  ; pixel X for second column
    move.l  d0,-(sp)
    pea     ($0010).w               ; Y = $10
    clr.l   -(sp)
    pea     ($0548).w               ; tile char = $548 (second column of selection icon)
    jsr     (a4)                    ; TilePlacement: second column
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    bra.b   .l177ac                 ; -> finalize and return d3
.l17746:                                                ; $017746
    ; Left pressed (bit4=$10) or cancel -- return -1
    moveq   #-$1,d0                 ; d0 = -1 (cancel)
    bra.b   .l177be                 ; -> return
.l1774a:                                                ; $01774A
    ; --- Phase: Up/Down navigation (bits $01/$02) ---
    move.w  d5,d0
    andi.w  #$1,d0                  ; Up button (bit 0)?
    beq.b   .l17778                 ; no -> check Down
    ; Up pressed: wrap to page 0 (first entry)
    move.w  #$1,(a3)               ; input_mode_flag = 1 (start countdown)
    clr.w   d3                      ; d3 = 0 (first page/item)
    ; GameCommand #$1A: scroll/clear with params for page wrap animation
    clr.l   -(sp)                   ; arg 0
    pea     ($0002).w               ; arg 2
    pea     ($0001).w               ; arg 1
    pea     ($000E).w               ; arg $E
    pea     ($0002).w               ; arg 2
    clr.l   -(sp)                   ; arg 0
    pea     ($001A).w               ; GameCommand #$1A (scroll plane clear)
    jsr     (a2)
    lea     $001c(sp),sp
    bra.b   .l177a4                 ; -> redraw
.l17778:                                                ; $017778
    ; Down button (bit 1)?
    move.w  d5,d0
    andi.w  #$2,d0
    beq.b   .l177a4                 ; no input -> redraw without advancing
    ; Down pressed: advance to page 1 (second entry)
    move.w  #$1,(a3)               ; input_mode_flag = 1
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0003).w               ; direction arg = 3 (scroll down)
    pea     ($0002).w
    clr.l   -(sp)
    pea     ($001A).w               ; GameCommand #$1A
    jsr     (a2)
    lea     $001c(sp),sp
    moveq   #$1,d3                  ; d3 = 1 (second page/item)
.l177a4:                                                ; $0177A4
    ; Redraw with mode 5 (soft refresh/animation step)
    pea     ($0005).w               ; mode 5
    bra.w   .l17688                 ; -> GameCommand #$E + loop back
.l177ac:                                                ; $0177AC
    ; --- Phase: Return selected index -- finalize display ---
    ; GameCommand #$40 with args 0, $10: final display commit
    pea     ($0040).w               ; GameCommand #$40 arg
    clr.l   -(sp)                   ; arg 0
    pea     ($0010).w               ; arg $10
    jsr     (a2)                    ; GameCommand
    lea     $000c(sp),sp
    move.w  d3,d0                   ; d0 = selected item index (return value)
.l177be:                                                ; $0177BE
    movem.l (sp)+,d2-d6/a2-a5
    rts
