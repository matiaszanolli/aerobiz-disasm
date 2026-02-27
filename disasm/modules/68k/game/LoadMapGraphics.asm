; ============================================================================
; LoadMapGraphics -- Loads and renders the full world-map sequence: decompresses route/city LZ tiles, tiles them to VRAM in chunks, animates a scrolling preview, and loops through all map regions before returning
; 1252 bytes | $03C1B8-$03C69B
; ============================================================================
; --- Phase: Setup ---
; Registers fixed throughout: a2 = GameCommand ($0D64), a3 = 128-byte local work buffer,
;   a4 = $FF1804 (save_buf_base, used as LZ decompress output / tile staging buffer),
;   a5 = $45B2 (ROM function for palette/tile operations)
LoadMapGraphics:
    link    a6,#-$80
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00000D64,a2       ; a2 = GameCommand dispatcher ($0D64, used as JSR target)
    lea     -$80(a6), a3         ; a3 = 128-byte ($80) local work buffer on stack
    movea.l  #$00FF1804,a4       ; a4 = $FF1804 (save_buf_base: LZ output / tile staging area)
    movea.l  #$000045B2,a5       ; a5 = ROM sub at $45B2 (palette/LZ/tile operation helper)
    ; --- Phase: Decompress Route Tiles (Asset 1) ---
    ; LZ_Decompress(src, dest): decompress first route/city map tile set to $FF1804
    move.l  ($000B753C).l, -(a7) ; arg: LZ source pointer (loaded from ROM table at $B753C)
    move.l  a4, -(a7)            ; arg: dest = $FF1804 (save_buf_base / tile staging buffer)
    jsr LZ_Decompress            ; decompress first map tile graphic to $FF1804
    ; CmdPlaceTile($FF1804, tile_count=1, dest_vram=$BF):
    ; Transfer the decompressed tile to VRAM at address $BF (first tile position)
    pea     ($00BF).w            ; arg: VRAM tile destination index $BF
    pea     ($0001).w            ; arg: 1 tile to transfer
    move.l  a4, -(a7)            ; arg: source = $FF1804
    jsr CmdPlaceTile             ; DMA/copy tile data to VRAM
    ; --- Phase: Decompress Route Tiles (Asset 2) ---
    ; Second LZ asset into $FF1804, to be tiled in chunks in the loop below
    move.l  ($000B7540).l, -(a7) ; arg: second LZ source pointer (from ROM table $B7540)
    move.l  a4, -(a7)            ; arg: dest = $FF1804
    jsr LZ_Decompress            ; decompress second map tile graphic set
    lea     $1c(a7), a7          ; clean up all args pushed since before first LZ (7 × 4 = $1C)
    ; --- Phase: Chunk-Transfer Route Tiles to VRAM in $80-Word Chunks ---
    ; The second LZ asset is $2E0 (736) entries total. Loop uploads $80 (128) words at a
    ; time to VRAM, at VRAM base $C0 + offset. CmdPlaceTile(src, vram_dest, count).
    ; GameCommand #$0E between each chunk waits for the DMA to complete safely.
    clr.w   d2                   ; d2 = word offset into decompressed data (0 to $2E0-1)
l_3c208:
    ; Compute chunk size: min($80, remaining) = min(128, $2E0 - d2)
    moveq   #$0,d3
    move.w  d2, d3               ; d3 = current offset
    addi.l  #$80, d3             ; d3 = offset + $80 (next chunk end)
    cmpi.l  #$2e0, d3            ; would we overshoot the total?
    bge.b   l_3c222              ; yes: clip to remaining
    move.l  #$80, d3             ; no: full chunk of $80 words
    bra.b   l_3c22e
l_3c222:
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = current offset
    move.l  #$2e0, d3
    sub.l   d0, d3               ; d3 = remaining words (last partial chunk)
l_3c22e:
    ; CmdPlaceTile(src = $FF1804 + d2*32, vram_dest = $C0 + d2, count = d3)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)            ; arg: word count for this chunk
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$c0, d0             ; d0 = VRAM destination = $C0 + d2 (base $C0 = tile area)
    move.l  d0, -(a7)            ; arg: VRAM tile destination address
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0              ; d0 = d2 * $20 (each VRAM word = $20 bytes in LZ output)
    pea     (a4, d0.l)           ; arg: source = $FF1804 + d2*$20 (pointer into decompressed data)
    jsr CmdPlaceTile             ; DMA chunk to VRAM
    pea     ($0001).w
    pea     ($000E).w            ; GameCommand #$0E = wait for display/DMA sync (V-blank safe)
    jsr     (a2)                 ; dispatch via GameCommand
    lea     $14(a7), a7          ; pop 5 args
    addi.w  #$80, d2             ; advance by $80 words
    cmpi.w  #$2e0, d2            ; done with all $2E0 words?
    bcs.b   l_3c208              ; loop until entire asset uploaded
    ; --- Phase: Decompress City Tiles (Asset 3) and Upload to VRAM $400+ ---
    ; Third LZ asset = city tile graphics. Uploaded in $80-word chunks to VRAM base $400.
    move.l  ($000B7544).l, -(a7) ; arg: third LZ source pointer (from ROM table $B7544)
    move.l  a4, -(a7)            ; arg: dest = $FF1804
    jsr LZ_Decompress            ; decompress city tile graphics
    addq.l  #$8, a7              ; pop 2 args
    ; $200 (512) words total for this asset; same chunking logic as before
    clr.w   d2                   ; d2 = word offset (0 to $200-1)
l_3c27a:
    moveq   #$0,d3
    move.w  d2, d3
    addi.l  #$80, d3
    cmpi.l  #$200, d3            ; $200 = 512 words total in city tile asset
    bge.b   l_3c294
    move.l  #$80, d3             ; full chunk
    bra.b   l_3c2a0
l_3c294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$200, d3
    sub.l   d0, d3               ; final partial chunk
l_3c2a0:
    ; CmdPlaceTile(src, vram_dest = $400 + d2, count = d3)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)            ; arg: word count
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$400, d0            ; VRAM destination: $400 + offset (city tile area)
    move.l  d0, -(a7)            ; arg: VRAM destination
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0              ; d0 = d2 * $20 (byte offset into decompressed data)
    pea     (a4, d0.l)           ; arg: source pointer
    jsr CmdPlaceTile             ; DMA chunk to VRAM
    pea     ($0001).w
    pea     ($000E).w            ; wait for DMA/display sync
    jsr     (a2)
    lea     $14(a7), a7
    addi.w  #$80, d2             ; advance by $80 words
    cmpi.w  #$200, d2            ; done with all 512 words?
    bcs.b   l_3c27a              ; loop until complete
    ; --- Phase: Display Static Map Region Labels / Overlays ---
    ; Several GameCommand #$1B calls render static text labels or graphic overlays
    ; onto the world map at fixed positions. Each is followed by a #$0E sync wait.
    ; GameCommand #$1B = render text/graphic from ROM address at given screen position.
    ; Format: cmd=$1B, col, row=0, w=$20, h=?, row2=?, src_ptr
    ; First overlay: text/graphic at $7486E, row=0, col=$0A, w=$20, h=0 (header label)
    pea     ($0007486E).l        ; source address in ROM ($7486E = first map region label)
    pea     ($000A).w            ; col = $0A
    pea     ($0020).w            ; width = $20 tiles
    clr.l   -(a7)               ; row = 0
    clr.l   -(a7)               ; extra param = 0
    pea     ($0001).w            ; mode = 1
    pea     ($001B).w            ; GameCommand #$1B = place text/tile block from ROM
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w            ; GameCommand #$0E = sync / V-blank wait
    jsr     (a2)
    lea     $24(a7), a7          ; pop args
    ; Second overlay: ROM $74AEE (second region label), positioned at col=0, row=$0A, h=$12
    pea     ($00074AEE).l        ; source = $74AEE (second map label graphic)
    pea     ($0012).w            ; h = $12
    pea     ($0020).w            ; w = $20
    pea     ($000A).w            ; row = $0A
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w            ; GameCommand #$1B
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    ; Third overlay: ROM $7586E at col=$0F, row=0, w=$20, h=$80, x=$80 (left panel?)
    pea     ($0080).w            ; h = $80
    pea     ($0080).w            ; x offset = $80 (horizontal scroll offset for this panel)
    pea     ($0007586E).l        ; source = $7586E (third map panel graphic)
    pea     ($0020).w            ; w = $20
    clr.l   -(a7)               ; extra = 0
    pea     ($000F).w            ; col = $0F (panel column = row position on screen)
    jsr     (a2)                 ; GameCommand via a2
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    ; Fourth overlay: ROM $7596E at col=$0F, row=$20, w=$20, h=$80, x=$100 (right panel?)
    pea     ($0100).w            ; x offset = $100 (second panel, offset right)
    pea     ($0080).w            ; h = $80
    pea     ($0007596E).l        ; source = $7596E (fourth map panel graphic)
    pea     ($0020).w            ; w = $20
    pea     ($0020).w            ; row = $20
    pea     ($000F).w            ; col = $0F
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    ; --- Phase: Load Color Palette Strips into Work Buffer (a3) ---
    ; a5 ($45B2) copies 32-byte color palette strips from ROM into the 128-byte stack buffer a3.
    ; Four strips are loaded into a3+0, a3+$20, a3+$40, a3+$60 (one per map region quadrant).
    pea     ($0020).w            ; count = $20 (32 bytes per strip)
    move.l  a3, -(a7)            ; dest = a3 + 0 (first quadrant color strip)
    pea     ($00076F16).l        ; source = ROM $76F16 (first palette strip: NW quadrant)
    jsr     (a5)                 ; copy 32-byte palette strip
    lea     $2c(a7), a7          ; pop 3 args (count, dest, src) + trailing args from earlier
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0               ; dest = a3 + $20 (second quadrant)
    move.l  d0, -(a7)
    pea     ($00076F36).l        ; source = $76F36 (NE quadrant palette strip)
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$40,d1
    add.l   d1, d0               ; dest = a3 + $40 (third quadrant)
    move.l  d0, -(a7)
    pea     ($00076F96).l        ; source = $76F96 (SW quadrant palette strip)
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$60,d1
    add.l   d1, d0               ; dest = a3 + $60 (fourth quadrant)
    move.l  d0, -(a7)
    pea     ($00076F76).l        ; source = $76F76 (SE quadrant palette strip)
    jsr     (a5)
    lea     $24(a7), a7          ; pop remaining palette-copy args
    ; --- Phase: Initial Color Tileset Render ---
    ; RenderColorTileset(palette_rom=$48D30, buf=a3, extra=0, count=$40, mode=$06):
    ; Applies 4-quadrant color mapping to the map tiles using the loaded palette strips.
    pea     ($0006).w            ; mode = 6 (color tileset rendering mode)
    pea     ($0040).w            ; count = $40 (64 color entries to process)
    clr.l   -(a7)               ; extra param = 0
    move.l  a3, -(a7)            ; 4-strip work buffer with loaded palette data
    pea     ($00048D30).l        ; ROM palette/color table at $48D30 (main map color table)
    bsr.w RenderColorTileset     ; apply initial color scheme to map tiles
    ; Update two strips for the animated scroll preview phase (alternate palette)
    pea     ($0020).w
    move.l  a3, -(a7)            ; dest = a3 + 0 (overwrite first strip for scroll anim)
    pea     ($00076F36).l        ; source = $76F36 (alternate NE palette used during scroll)
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0               ; dest = a3 + $20
    move.l  d0, -(a7)
    pea     ($00076F56).l        ; source = $76F56 (alternate second strip for scroll)
    jsr     (a5)
    lea     $2c(a7), a7          ; pop RenderColorTileset args + 2 palette-copy args
    ; --- Phase: GameCommand #$23 (Animated Map Preview Setup) ---
    ; GameCommand #$23 = initialize scroll/animation for map preview display.
    ; Args: cmd=$23, mode=1, w=$10, h=$10, x=$10, y=$2, count=$10, buf=a3
    move.l  a3, -(a7)            ; arg: color strip work buffer (4 × $20 bytes)
    pea     ($0010).w            ; arg: $10 (tile count or stride)
    pea     ($0002).w            ; arg: y-offset = 2
    pea     ($0010).w            ; arg: height = $10
    pea     ($0010).w            ; arg: width = $10
    pea     ($0001).w            ; arg: mode = 1
    pea     ($0023).w            ; GameCommand #$23 = animated map preview init
    jsr     (a2)
    lea     $1c(a7), a7
    ; --- Phase: Dual-Panel Scroll Animation Loop (128 frames) ---
    ; d2 = frame counter (0..$7F = 128 frames).
    ; Each frame: show left panel (src=$7586E, x=80-d2), then right panel (src=$7596E, x=$100+d2).
    ; WaitForStartButton allows the player to skip (returns nonzero = pressed).
    ; If Start pressed during either panel: jump to game-over screen.
    clr.w   d2                   ; d2 = frame counter (0-127)
l_3c42e:
    ; Left panel: scroll from x=$80 toward 0 as d2 increases (left side reveals)
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = current frame
    move.l  #$80, d1
    sub.l   d0, d1               ; d1 = $80 - frame (decreasing x position: panel slides in)
    move.l  d1, -(a7)            ; arg: x position for this frame
    pea     ($0080).w            ; arg: width = $80
    pea     ($0007586E).l        ; arg: source = $7586E (left map panel graphic)
    pea     ($0020).w            ; arg: stride = $20
    clr.l   -(a7)               ; arg: y = 0
    pea     ($000F).w            ; arg: col = $0F
    jsr     (a2)                 ; GameCommand: render left panel at current scroll position
    pea     ($0002).w            ; arg: wait_frames = 2
    bsr.w WaitForStartButton     ; wait 2 frames; d0 nonzero if Start pressed
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_3c46a              ; not pressed: continue to right panel
l_3c462:
    ; Player pressed Start: abort preview and show game-over / title screen
    bsr.w ShowGameOverScreen     ; display game-over / return-to-title screen
    bra.w   l_3c692              ; jump to function exit
l_3c46a:
    ; Right panel: scroll from x=$100+frame (reveals from right edge inward)
    moveq   #$0,d0
    move.w  d2, d0               ; d0 = current frame
    addi.l  #$100, d0            ; d0 = $100 + frame (increasing x: right panel scrolls in)
    move.l  d0, -(a7)            ; arg: x position
    pea     ($0080).w            ; arg: width = $80
    pea     ($0007596E).l        ; arg: source = $7596E (right map panel graphic)
    pea     ($0020).w            ; arg: stride
    pea     ($0020).w            ; arg: y = $20 (lower half of screen)
    pea     ($000F).w            ; arg: col = $0F
    jsr     (a2)                 ; GameCommand: render right panel at current scroll position
    pea     ($0002).w
    bsr.w WaitForStartButton     ; wait 2 frames
    lea     $1c(a7), a7
    tst.w   d0
    bne.b   l_3c462              ; Start pressed on right panel: also abort
    addq.w  #$1, d2              ; next frame
    cmpi.w  #$80, d2             ; $80 = 128 frames total
    bcs.b   l_3c42e              ; loop until all 128 frames played
    ; --- Phase: Post-Scroll Transition: Clear Screen and Reset Scroll ---
    ; GameCommand #$10 (fade/clear): clear panel with count=$40, mode=0 (fade out)
    pea     ($0040).w            ; count = $40 (64 entries to clear)
    clr.l   -(a7)               ; mode = 0 (clear/fade)
    pea     ($0010).w            ; GameCommand #$10 = screen fade / clear operation
    jsr     (a2)
    ; GameCommand #$1A: clear large tile region (col=0, row=0, w=$20, h=$40, pri=$8000)
    move.l  #$8000, -(a7)       ; priority
    pea     ($0040).w            ; h = $40
    pea     ($0020).w            ; w = $20
    clr.l   -(a7)               ; row = 0
    clr.l   -(a7)               ; col = 0
    clr.l   -(a7)               ; extra = 0
    pea     ($001A).w            ; GameCommand #$1A = clear tile rectangle
    jsr     (a2)
    lea     $28(a7), a7
    ; UpdateScrollRegisters(0, 0, $100): reset scroll to position $100,0,0 (centered)
    pea     ($0100).w            ; scroll X = $100
    clr.l   -(a7)               ; scroll Y = 0
    clr.l   -(a7)               ; extra = 0
    bsr.w UpdateScrollRegisters  ; write H/V scroll values to display registers
    ; --- Phase: Decompress Fourth Asset and Prep Second Map Region ---
    ; LZ asset 4 = world overview map tiles, placed at VRAM $0400, $0120 tiles
    move.l  ($000B7548).l, -(a7) ; arg: fourth LZ source (from ROM table $B7548)
    move.l  a4, -(a7)            ; arg: dest = $FF1804
    jsr LZ_Decompress            ; decompress world overview map tiles
    pea     ($0120).w            ; arg: tile count = $120 (288 tiles)
    pea     ($0400).w            ; arg: VRAM destination = $0400 (second tile bank)
    move.l  a4, -(a7)            ; arg: source = $FF1804
    jsr CmdPlaceTile             ; DMA 288 tiles to VRAM $0400
    lea     $20(a7), a7          ; pop 5 args (both LZ + CmdPlaceTile)
    ; Place a text/graphic overlay from ROM $75A6E at row=0, col=0, w=$20, h=$10
    pea     ($00075A6E).l        ; source = $75A6E (world map header graphic)
    pea     ($0010).w            ; h = $10
    pea     ($0020).w            ; w = $20
    clr.l   -(a7)               ; y = 0
    clr.l   -(a7)               ; x = 0
    clr.l   -(a7)               ; extra = 0
    pea     ($001B).w            ; GameCommand #$1B = place ROM graphic on screen
    jsr     (a2)
    ; LoadDisplaySet($0A): load display set configuration #$0A (route/world map display set)
    pea     ($000A).w            ; display set index $0A
    jsr LoadDisplaySet           ; configure display set for world map view
    lea     $20(a7), a7
    ; --- Phase: Horizontal Scroll Animation Loop (Region 1) ---
    ; d2 = frame counter (0..$17F), d3 = scroll X position (starts at $80, decrements)
    ; Animates the world map scrolling to the left while overlaying city labels.
    ; Each frame: UpdateScrollRegisters, optionally place a region text label, wait 1 frame.
    clr.w   d2                   ; d2 = frame counter
    move.w  #$80, d3             ; d3 = initial scroll X position ($80 = 128 pixels right)
    bra.b   l_3c5aa              ; enter loop at condition check
l_3c52e:
    ; Each frame: set scroll X=d3, Y=0, extra=0
    move.w  d3, d0
    move.l  d0, -(a7)            ; scroll X = d3 (decrements toward 0 each frame)
    clr.l   -(a7)               ; scroll Y = 0
    clr.l   -(a7)               ; extra = 0
    bsr.w UpdateScrollRegisters  ; write scroll position to VDP H/V scroll registers
    lea     $c(a7), a7           ; pop 3 args
    ; At specific scroll milestones, place a region label graphic:
    ;   d3==$150 ($150 = 336): label from $753EE (first region label)
    ;   d3==$1A8 ($1A8 = 424): label from $74F6E (second region label)
    moveq   #$0,d0
    move.w  d3, d0               ; d0 = current scroll position
    cmpi.w  #$150, d0            ; at scroll position $150?
    beq.b   l_3c550              ; yes: place first region label
    cmpi.w  #$1a8, d0            ; at scroll position $1A8?
    beq.b   l_3c558              ; yes: place second region label
    bra.b   l_3c57a              ; no label this frame: go to wait
l_3c550:
    pea     ($000753EE).l        ; first region label graphic (at scroll $150)
    bra.b   l_3c55e
l_3c558:
    pea     ($00074F6E).l        ; second region label graphic (at scroll $1A8)
l_3c55e:
    ; GameCommand #$1B: place label at col=$0A, row=0, w=$20, h=$12
    pea     ($0012).w            ; h = $12
    pea     ($0020).w            ; w = $20
    pea     ($000A).w            ; col = $0A
    clr.l   -(a7)               ; y = 0
    pea     ($0001).w
    pea     ($001B).w            ; GameCommand #$1B = place ROM graphic
    jsr     (a2)
    lea     $1c(a7), a7
l_3c57a:
    ; Wait 2 frames; if Start pressed: abort to game-over screen
    pea     ($0002).w            ; wait_frames = 2
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3c594              ; not pressed: continue scroll
l_3c588:
    ; Start pressed: GameCommand #$18 (clear display) then jump to game-over
    pea     ($0018).w            ; GameCommand #$18 = clear/reset display
    jsr     (a2)
    addq.l  #$4, a7
    bra.w   l_3c462              ; display game-over screen and exit
l_3c594:
    ; Decrement scroll position: d3--. Wrap $0 back to $200 (seamless scroll tile wraparound).
    tst.w   d3
    beq.b   l_3c5a0
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0              ; d3 - 1 (scroll left by one pixel-unit per frame)
    bra.b   l_3c5a6
l_3c5a0:
    move.l  #$200, d0            ; wrap: $200 = scroll tile width (maps wrap-around)
l_3c5a6:
    move.w  d0, d3               ; d3 = updated scroll X
    addq.w  #$1, d2              ; increment frame counter
l_3c5aa:
    cmpi.w  #$180, d2            ; $180 = 384 frames total for this region scroll
    bcs.w   l_3c52e              ; loop until all frames played
    ; --- Phase: Load Second Map Region and Begin Vertical Scroll ---
    ; GameCommand #$18 = transition: fade/reset display for region 2
    pea     ($0018).w            ; GameCommand #$18 = display transition / fade
    jsr     (a2)
    ; LoadDisplaySet($13): switch to display set $13 (second map region layout)
    pea     ($0013).w            ; display set index $13
    jsr LoadDisplaySet           ; configure VDP scroll/plane for second region
    ; GameCommand #$1A: clear wide tile area (col=0, row=0, w=$20, h=$1C, pri=$8000)
    move.l  #$8000, -(a7)
    pea     ($001C).w            ; h = $1C
    pea     ($0020).w            ; w = $20
    clr.l   -(a7)               ; row = 0
    clr.l   -(a7)               ; col = 0
    clr.l   -(a7)               ; extra = 0
    pea     ($001A).w            ; GameCommand #$1A = clear tile rectangle
    jsr     (a2)
    lea     $24(a7), a7
    ; --- Phase: Vertical Scroll Animation Loop (Region 2) ---
    ; d3 = scroll X position, starts at $100 and increments each frame until $200.
    ; At milestone scroll values, a region city label is placed on screen.
    move.w  #$100, d3            ; d3 = initial scroll X ($100 = 256; region 2 start)
l_3c5e4:
    ; Each frame: set scroll X=d3, Y=0
    move.w  d3, d0
    move.l  d0, -(a7)            ; scroll X = d3
    clr.l   -(a7)               ; Y = 0
    clr.l   -(a7)               ; extra = 0
    bsr.w UpdateScrollRegisters  ; apply scroll to VDP
    lea     $c(a7), a7
    ; At specific scroll milestones place city region labels:
    ;   d3==$1B8: label from $75F2E (region 2 label C)
    ;   d3==$160: label from $75ECE (region 2 label B)
    ;   d3==$108: label from $75E6E (region 2 label A)
    moveq   #$0,d0
    move.w  d3, d0
    cmpi.w  #$1b8, d0
    beq.b   l_3c60c
    cmpi.w  #$160, d0
    beq.b   l_3c614
    cmpi.w  #$108, d0
    beq.b   l_3c61c
    bra.b   l_3c63e              ; no label at this scroll position
l_3c60c:
    pea     ($00075F2E).l        ; region 2 label C (at scroll $1B8)
    bra.b   l_3c622
l_3c614:
    pea     ($00075ECE).l        ; region 2 label B (at scroll $160)
    bra.b   l_3c622
l_3c61c:
    pea     ($00075E6E).l        ; region 2 label A (at scroll $108)
l_3c622:
    ; GameCommand #$1B: place label at col=$09, row=$0C, w=$0C, h=$04
    pea     ($0004).w            ; h = 4 tiles
    pea     ($000C).w            ; w = $0C tiles
    pea     ($000C).w            ; col = $0C
    pea     ($0009).w            ; row = 9
    clr.l   -(a7)               ; y = 0
    pea     ($001B).w            ; GameCommand #$1B = place ROM graphic
    jsr     (a2)
    lea     $1c(a7), a7
l_3c63e:
    ; Wait 1 frame; Start press aborts back to game-over
    pea     ($0001).w            ; wait_frames = 1
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3c588              ; Start pressed: abort (jump to GameCommand #$18 + game-over)
    addq.w  #$1, d3              ; d3++ (scroll X advances 1 unit per frame)
    cmpi.w  #$200, d3            ; $200 = end of region 2 scroll (512 = full wrap)
    bcs.b   l_3c5e4              ; loop until scroll reaches $200
    ; --- Phase: Hold Final Frame and Wait for Start ---
    ; Scroll to 0,0,0 and wait up to $40 frames for player to press Start.
    clr.l   -(a7)               ; X = 0
    clr.l   -(a7)               ; Y = 0
    clr.l   -(a7)               ; extra = 0
    bsr.w UpdateScrollRegisters  ; reset scroll to origin
    pea     ($0018).w            ; GameCommand #$18 = display transition
    jsr     (a2)
    pea     ($0040).w            ; wait up to $40 = 64 frames for Start button
    bsr.w WaitForStartButton
    lea     $14(a7), a7
    tst.w   d0
    bne.w   l_3c462              ; Start pressed: jump to game-over screen
    ; --- Phase: Final Cleanup and Return ---
    ; Clear the screen region ($1A command) with high priority, then return.
    move.l  #$8000, -(a7)
    pea     ($001C).w            ; h = $1C
    pea     ($0020).w            ; w = $20
    clr.l   -(a7)               ; row = 0
    clr.l   -(a7)               ; col = 0
    clr.l   -(a7)               ; extra = 0
    pea     ($001A).w            ; GameCommand #$1A = clear tile area
    jsr     (a2)
l_3c692:
    movem.l -$98(a6), d2-d3/a2-a5
    unlk    a6
    rts
