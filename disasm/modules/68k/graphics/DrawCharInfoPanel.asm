; ============================================================================
; DrawCharInfoPanel -- Draw a character info panel with tile graphics, stat bar, and scroll bar overlays
; Called: ?? times.
; 804 bytes | $00643C-$00675F
; ============================================================================
; --- Phase: Setup -- Decode Arguments ---
DrawCharInfoPanel:                                                  ; $00643C
    link    a6,#-$34
    movem.l d2-d7/a2-a5,-(sp)
    ; d4 = slot/position index (arg3, $10(a6))
    move.l  $0010(a6),d4
    ; d5 = stat value A (arg1, $8(a6)) -- e.g., primary rating stat
    move.l  $0008(a6),d5
    ; d6 = stat value B (arg7, $18(a6)) -- e.g., secondary stat/type
    move.l  $0018(a6),d6
    ; a3 = GameCommand function pointer ($D64) -- called frequently via register
    movea.l #$0d64,a3
    ; a4 = local tile data buffer at -$30(a6) (scratch for sequential word fill)
    lea     -$0030(a6),a4
    ; a5 = ROM data pointer at $4743C (tile/scroll bar configuration tables)
    movea.l #$0004743c,a5
    ; --- Determine panel column offset based on display mode ---
    ; $22(a6) = panel mode: nonzero = right-side panel (wide layout), 0 = left-side
    tst.w   $0022(a6)
    beq.b   .l646a
    ; Right-side mode: start column $19 (25)
    moveq   #$19,d0
    bra.b   .l646c
.l646a:                                                 ; $00646A
    ; Left-side mode: start column $2 (2)
    moveq   #$2,d0
.l646c:                                                 ; $00646C
    ; Store column offset at -$32(a6) for later tile addressing
    move.w  d0,-$0032(a6)
    ; --- Determine scroll bar mode ---
    tst.w   $0022(a6)
    beq.b   .l647a
    ; Right-side: scroll bar mode 2
    moveq   #$2,d3
    bra.b   .l647c
.l647a:                                                 ; $00647A
    ; Left-side: scroll bar mode 7
    moveq   #$7,d3
.l647c:                                                 ; $00647C
    ; --- Determine row offset based on arg6 ($1E(a6)) ---
    ; Nonzero = secondary row ($13=19), zero = primary row ($02=2)
    tst.w   $001e(a6)
    beq.b   .l6486
    moveq   #$13,d2
    bra.b   .l6488
.l6486:                                                 ; $006486
    moveq   #$2,d2
.l6488:                                                 ; $006488
    ; --- Phase: Clamp Stats to Display Ranges ---
    ; SignedMod: d5 mod $36 (54) -- clamp stat A to 0..53 (fits in panel bar)
    moveq   #$0,d0
    move.w  d5,d0
    moveq   #$36,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d5
    ; SignedMod: d4 mod 4 -- clamp slot index to 0..3 (4 palette columns)
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    ; SignedMod: d6 mod 3 -- clamp stat B to 0..2 (3 types in scroll bar table)
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d6
    ; --- Phase: Decompress and DMA Background Tiles ---
    ; LZ_Decompress: expand tile graphics from ROM $4DFB8 into save_buf_base ($FF1804)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    ; VRAMBulkLoad: DMA the decompressed tiles to VRAM at tile index $2E1
    ; $F = chunk size in 16-byte units, $02E1 = starting tile number in VRAM
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    ; GameCommand #$E arg 1: flush pending display update
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    ; --- Phase: Draw Panel Background and Stat Bar ---
    ; GameCommand #$1B: place ROM tile block from $4DD9C
    ; at position (col=$1E=30, row=$9=9, height=d2-1)
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    moveq   #$0,d0
    move.w  d2,d0
    subq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    ; --- Place stat bar tile ($077E = horizontal bar graphic) ---
    ; GameCommand #$1A: clear/fill area at (col=1, row=$1C=28, width=6) to row d2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0024(sp),sp
    ; --- Phase: Set Text Window for Stat Display ---
    ; SetTextWindow: define the text rendering region (col=d2, row=d3, width=6, height=$17=23)
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    ; --- Place another bar tile ($077E) with GameCommand #$1A for the stat value display ---
    ; Width=6, height=$17, at col=d2, row=d3 (same window position)
    pea     ($077E).w
    pea     ($0006).w
    pea     ($0017).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $002c(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    ; --- Phase: Load Tile Graphics (First Pass) ---
    ; LoadTileGraphics (jsr $005F00): decompress and place the char portrait tile set
    ; Args: stat_a (d5), col_offset (-$32), d2 (row), d4 (slot_mod4), $E(a6), $16(a6)
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  -$0032(a6),d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    ; LoadTileGraphics: LZ decompress + tile placement from $AE0C4 index table
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    ; --- Decompress char portrait sprite to screen_buf ($FF899C) ---
    ; $AE19C is a ROM pointer table indexed by stat_a (d5) mod 54
    moveq   #$0,d0
    move.w  d5,d0
    lsl.l   #$2,d0
    movea.l #$000ae19c,a0
    move.l  (a0,d0.l),-(sp)
    ; LZ_Decompress: expand portrait graphics to screen_buf ($FF899C)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $002c(sp),sp
    ; CmdPlaceTile2: send screen_buf ($FF899C) to VRAM at tile $7E8 ($24 = 24 tiles wide)
    pea     ($0018).w
    pea     ($07E8).w
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    ; --- Build Sequential Tile Index Buffer (a4) for the stat bar ---
    ; FillSequentialWords: fill a4 buffer with sequential values starting at (d4<<13 | $7E8)
    ; This creates a row of consecutive tile IDs pointing to the portrait tile block
    pea     ($0018).w
    move.w  d4,d0
    ; Shift d4 (palette slot 0-3) into bits [13:13] of VDP tile attribute word
    moveq   #$d,d1
    lsl.w   d1,d0
    ori.w   #$07e8,d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    ; FillSequentialWords: populate a4 with 24 sequential tile entries
    dc.w    $4eb9,$0000,$5ede                           ; jsr $005EDE
    lea     $0018(sp),sp
    ; --- Phase: Configure First Scroll Bar (Stat A / main rating bar) ---
    ; Compute BAT write address for the first scroll bar row
    ; bat_base_word ($FF88D6) = base VRAM tile address for the display window
    ; Row offset = (d2 + 2) * display_param2 ($FFA77E) * 2 + col_offset * 2
    move.w  -$0032(a6),d3
    move.w  d2,d7
    ; Row = d2 + 2 (two rows below the stat text)
    addq.w  #$2,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    ; Multiply row by display_param2 (tile-row byte stride for BAT)
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    ; Multiply32: row * display_param2 = byte offset from BAT base
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    ; Add column offset (d3) and multiply by 2 (words in BAT)
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    ; a2 = final BAT write address for stat bar row
    adda.l  d0,a2
    ; ConfigScrollBar: configure the first scroll bar (stat_a) using $4743C table entry
    ; a5+d6*8 = pointer to scroll bar config struct for this type
    ; Args: mode=1, col=$C=12, width=4, height=5, tile_data=a4, bat_addr=a2, config=a5+d6*8
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($0001).w
    ; ConfigScrollBar: draw the horizontal stat bar at the computed BAT address
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    ; --- Phase: Configure Second Scroll Bar (Secondary rating / sub-stat bar) ---
    ; Row = d2 + 4 (two rows below the first bar)
    move.w  -$0032(a6),d3
    addq.w  #$1,d3
    move.w  d2,d7
    addq.w  #$4,d7
    moveq   #$0,d0
    move.w  ($00FF88D6).l,d0
    movea.l d0,a2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l,d1
    ; Multiply32 for second bar row offset
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d0
    add.l   d0,d0
    adda.l  d0,a2
    ; a5+$18 = second config block in the ROM table (offset 24 bytes from base)
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    ; a4+$1E = second tile data section (offset 30 bytes from a4 base)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    ; ConfigScrollBar: 8 tiles wide, 4 columns, 3 rows -- secondary sub-stat bar
    pea     ($0003).w
    pea     ($0004).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    ; PrintfNarrow: print a short label from ROM $3E182 next to the secondary bar
    move.l  $0024(a6),-(sp)
    pea     ($0003E182).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0028(sp),sp
    ; --- Phase: Configure Third Scroll Bar (Tertiary / background overlay bar) ---
    ; Uses same BAT address (a2) as second bar but different config offsets
    move.l  a2,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$3,d0
    pea     (a5,d0.l)
    move.l  a4,-(sp)
    pea     ($0005).w
    pea     ($0004).w
    ; Width $10 = 16 (wider bar for this layer)
    pea     ($0010).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    ; Fourth ConfigScrollBar call: uses same a2/a4 offsets as the second bar
    move.l  a2,-(sp)
    move.l  a5,d0
    moveq   #$18,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.l  a4,d0
    moveq   #$1e,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    ; 10-tile bar ($A wide), 4 cols, 3 rows
    pea     ($0003).w
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$6298                           ; jsr $006298
    lea     $0020(sp),sp
    ; --- Phase: Second LoadTileGraphics Pass (Final Portrait Composite) ---
    ; This second call composites a foreground detail layer on top of the portrait
    move.w  $0016(a6),d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    ; Recompute column offset (same logic as entry: right=$19, left=$2)
    tst.w   $0022(a6)
    beq.b   .l6748
    moveq   #$19,d0
    bra.b   .l674a
.l6748:                                                 ; $006748
    moveq   #$2,d0
.l674a:                                                 ; $00674A
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    ; LoadTileGraphics: second pass to overlay detail/shadow tiles
    dc.w    $4eb9,$0000,$5f00                           ; jsr $005F00
    movem.l -$005c(a6),d2-d7/a2-a5
    unlk    a6
    rts
