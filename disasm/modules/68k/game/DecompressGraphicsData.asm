; ============================================================================
; DecompressGraphicsData -- Decompress and display character graphics and stats for the route graphics view: char portraits, compatibility tiles, and relationship values with conditional VRAM placement.
; 876 bytes | $0246DE-$024A49
; ============================================================================
; --- Phase: Setup -- allocate frame, save registers, resolve route slot pointer ---
DecompressGraphicsData:
    link    a6,#-$10
    movem.l d2-d6/a2-a5, -(a7)
    ; a3 = save_buf_base ($FF1804): decompression scratch buffer for LZ output
    movea.l  #$00FF1804,a3
    ; a4 = GameCommand dispatcher ($000D64): called via jsr (a4) throughout
    movea.l  #$00000D64,a4
    ; a5 = graphics descriptor table base at $4E0F4 (ROM, portrait/tile index data)
    movea.l  #$0004E0F4,a5
    ; args: $a(a6) = player index, $e(a6) = slot index
    ; compute route_slots offset: player * $320 + slot * $14
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    move.w  $e(a6), d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    ; a2 -> route slot record (20 bytes) for this player/slot pair
    movea.l a0, a2
    ; d6 = row base (1) for VRAM tile placement; d5 = column base (3) for tile placement
    moveq   #$1,d6
    moveq   #$3,d5
    ; --- Phase: Background graphics load -- decompress base portrait tiles to VRAM ---
    ; DisplaySetup: load resource at (a5+2) with size $10 to dest $20
    ; $10 = resource size in tiles, $20 = dest tile index, a5+2 = compressed resource ptr
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; DisplaySetup: copy ROM resource into tile buffer and optionally reinit display
    jsr DisplaySetup
    ; LZ_Decompress: decompress portrait data from ROM offset a5+$9A into save_buf $FF1804
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    ; LZ_Decompress: decompress compressed graphics stream to a3 ($FF1804)
    jsr LZ_Decompress
    ; VRAMBulkLoad: DMA the decompressed data from $FF1804 to VRAM tile $0375 (893 decimal)
    ; $0375 = VRAM tile index for portrait slot; count = 1 chunk; src = a3 ($FF1804)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    ; VRAMBulkLoad: chunked DMA of decompressed portrait tiles to VRAM
    jsr VRAMBulkLoad
    lea     $28(a7), a7
    ; GameCommand #$1A: clear tile area -- 8 wide, $20 (32) tall at (0,0), no flags, sub-cmd 3
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    ; GameCommand #$1A = ClearTileArea: erases a region of the tilemap to blank tiles
    jsr     (a4)
    lea     $1c(a7), a7
    ; GameCommand #$1A again with priority flag $8000: clear overlapping region at same pos
    move.l  #$8000, -(a7)
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    ; SetTextWindow: set text rendering window to full-screen ($20 wide, $20 tall, origin 0,0)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    ; SetTextWindow: defines the active text rendering region (left/top/width/height)
    jsr SetTextWindow
    lea     $2c(a7), a7
    ; --- Phase: Per-slot loop -- iterate up to 4 route slots, display char portrait + stats ---
    ; d4 = slot loop counter (0 to 3); a2 advances by $14 (route slot stride) each iteration
    clr.w   d4
.l247ac:
    ; route slot +$00 = city_a (source city); $FF sentinel = end of valid slot list
    cmpi.b  #$ff, (a2)
    beq.w   .l24a40
    ; check whether the two city codes (city_a and city_b) are in the same char-type range
    ; route slot +$01 = city_b (destination city)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    ; RangeMatch: returns nonzero if both char codes map to same range bucket (same affinity)
    jsr RangeMatch
    addq.l  #$8, a7
    tst.w   d0
    ; if city codes are NOT in the same range, use the alternate (generic) portrait path
    beq.b   .l24838
    ; --- sub-path: same-range cities -- load specific char portrait (a5+$22 resource) ---
    pea     ($0010).w
    pea     ($0020).w
    move.l  a5, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    ; DisplaySetup: reload portrait resource into tile buffer (same resource as above)
    jsr DisplaySetup
    ; GameCommand #$1B at (row=d6, col=d5+d4*2): place tile block for same-range portrait
    ; column = d5 + d4*2 positions the portrait for the current slot (slots laid out left-right)
    move.l  a5, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($001E).w
    ; tile column = d5 + d4*2 (d4 = slot index, 2 columns per slot)
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    ; GameCommand #$1B: place tile block at specified row/col (portrait tile placement)
    jsr     (a4)
    ; LZ_Decompress: decompress char portrait from a5+$9A to $FF1804 scratch buffer
    move.l  a5, d0
    addi.l  #$9a, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    ; VRAMBulkLoad to VRAM tile $0375: same portrait slot, same-range char graphic
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($0375).w
    bra.b   .l24886
.l24838:
    ; --- sub-path: different-range cities -- use generic/fallback portrait at $4E056 ---
    ; $4E056 = ROM address of generic char portrait compressed data
    pea     ($0004E056).l
    pea     ($0002).w
    pea     ($001E).w
    ; same column calculation: tile column = d5 + d4*2
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001B).w
    ; GameCommand #$1B: place generic portrait tile block at slot position
    jsr     (a4)
    ; LZ_Decompress: decompress fallback portrait from $4E0CE to $FF1804
    pea     ($0004E0CE).l
    move.l  a3, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    ; VRAMBulkLoad to VRAM tile $036F (different tile index for non-matching chars)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($0006).w
    pea     ($036F).w
.l24886:
    ; VRAMBulkLoad: DMA portrait data to VRAM (common tail for both same/different-range paths)
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    ; --- Phase: Decode status_flags to VRAM tile offset for compatibility indicator ---
    ; d3 = tile base offset for the compatibility/relationship indicator icon
    ; default: d3 = -1 (no indicator)
    moveq   #-$1,d3
    ; read route status_flags: +$0A in route slot record (accessed via a2)
    move.b  $a(a2), d0
    ; bit 2 of status_flags = ESTABLISHED flag; if set, use tile $0000 (first icon set)
    btst    #$2, d0
    beq.b   .l248a0
    ; ESTABLISHED: compatibility indicator starts at tile $0 in icon strip
    clr.w   d3
    bra.b   .l248ba
.l248a0:
    move.b  $a(a2), d0
    ; bit 1 = SUSPENDED flag; if set, use tile $10 (second icon strip, 16 tiles in)
    btst    #$1, d0
    beq.b   .l248ae
    ; SUSPENDED: $10 = 16, second icon group
    moveq   #$10,d3
    bra.b   .l248ba
.l248ae:
    move.b  $a(a2), d0
    ; bit 0 = pending-update flag; if set, use tile $8 (third icon strip)
    btst    #$0, d0
    beq.b   .l248ba
    ; pending-update: $8 = 8 tiles offset into icon strip
    moveq   #$8,d3
.l248ba:
    ; if d3 == -1 (no flag set), skip tile placement for compatibility indicator
    move.w  d3, d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    bge.b   .l24916
    ; --- Phase: Build 8-entry tile sequence for compatibility/status icon strip ---
    ; start tile ID = $637B + d3 (d3 is tile-strip offset 0/$8/$10)
    clr.w   d2
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    ; $637B = base VRAM tile index for the compatibility status icon strip
    addi.l  #$637b, d0
    move.l  d0, d3
.l248d8:
    ; write 8 consecutive tile IDs into frame temp array -$10(a6): used as inline tile data
    move.w  d2, d0
    add.w   d0, d0
    move.w  d3, -$10(a6, d0.w)
    addq.l  #$1, d3
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   .l248d8
    ; GameCommand #$1B: place 8-tile icon strip at (row=d6, col=d5+d4*2, width=4, height=2)
    pea     -$10(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    ; GameCommand #$1B: place compatibility indicator tile block
    jsr     (a4)
    lea     $1c(a7), a7
.l24916:
    ; --- Phase: Display city-code names and relationship value for this slot ---
    ; reset text window to full screen before printing slot text
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; set cursor to (col=d5+d4*2, row=d6+4): 4 rows below the portrait tile area
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    ; print city_a name: route slot +$00 = city_a index; look up name pointer from $5E7E4 table
    ; $5E7E4 = ROM char-name string pointer table (index * 4 -> longword address)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    ; $41368 = format string for city name display (PrintfWide format)
    pea     ($00041368).l
    ; PrintfWide: render city_a name at cursor position using 2-tile wide font
    jsr PrintfWide
    ; set cursor to (col=d5+d4*2, row=d6+$F): $F = 15 rows down, for city_b name line
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    ; $F = 15 decimal -- city_b name is printed 15 rows below portrait row
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    ; print city_b name: route slot +$01 = city_b index; same name table
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    ; $41364 = format string for city_b name line
    pea     ($00041364).l
    ; PrintfWide: render city_b name
    jsr PrintfWide
    lea     $30(a7), a7
    ; --- Phase: Compute and display relationship-value percentage ---
    ; GetByteField4: extract lower nibble of +$04 field (char-slot category) from route slot a2
    move.l  a2, -(a7)
    ; GetByteField4: returns bits [3:0] of a2+4, the char-slot category index
    jsr GetByteField4
    ; d2 = category index; multiply by $C (12) to index into $FFA6B9 compatibility table
    move.w  d0, d2
    mulu.w  #$c, d0
    ; $FFA6B9 = per-category compatibility multiplier table (byte per category)
    movea.l  #$00FFA6B9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ; scale compatibility byte by $A = 10 to get base weighting factor
    mulu.w  #$a, d0
    move.w  d0, d2
    ; MulDiv: compute (compatibility_weight * $64 * actual_revenue) / $64
    ; route slot +$10 = passenger_count (runtime field); used as revenue proxy
    move.l  d0, -(a7)
    pea     ($0064).w
    move.w  $10(a2), d0
    move.l  d0, -(a7)
    ; MulDiv: (a * b * c) / d three-operand scale -- result is compatibility-weighted %
    jsr MulDiv
    ; d2 = computed relationship value (percentage 0-100, may exceed 100)
    move.w  d0, d2
    ; set cursor to (col=d5+d4*2, row=d6+$1A): $1A = 26 rows, relationship value line
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    ; $1A = 26 decimal -- relationship percentage printed at row 26 relative to portrait
    addi.l  #$1a, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    ; choose display format based on value: <= $64 (100) uses normal format, > 100 uses capped
    cmpi.w  #$64, d2
    bgt.b   .l24a0e
    ; value <= 100: display as-is with format $4135E (normal % string)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    ; $4135E = format string for relationship percentage (value fits in 0-100 range)
    pea     ($0004135E).l
    bra.b   .l24a28
.l24a0e:
    ; value > 100: cap display at $64 (100%) -- route is at maximum relationship
    cmpi.w  #$64, d2
    bge.b   .l24a1a
    move.w  d2, d0
    ext.l   d0
    bra.b   .l24a1c
.l24a1a:
    ; clamp to $64 = 100 for display purposes
    moveq   #$64,d0
.l24a1c:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    ; $41358 = format string for capped/overflow relationship value (">100%" or special indicator)
    pea     ($00041358).l
.l24a28:
    ; PrintfWide: render relationship percentage at cursor position
    jsr PrintfWide
    lea     $20(a7), a7
    ; advance a2 to next route slot record ($14 = 20 bytes per slot)
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d4
    ; loop while d4 < 4 (up to 4 route slots displayed per player)
    cmpi.w  #$4, d4
    blt.w   .l247ac
.l24a40:
    movem.l -$34(a6), d2-d6/a2-a5
    unlk    a6
    rts
