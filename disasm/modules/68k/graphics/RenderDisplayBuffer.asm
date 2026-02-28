; ============================================================================
; RenderDisplayBuffer -- Renders the main world-map display buffer for a given player/mode: copies layout data, resolves up to 7 visible players' screen positions from RAM tables, decompresses the background tileset and DMA-loads it to VRAM, iterates 4 route slots placing airline icons at computed tile coordinates, then prints the current year/quarter string in a text window.
; 700 bytes | $01CB82-$01CE3D
; ============================================================================
RenderDisplayBuffer:
    ; --- Phase: Setup ---
    ; Stack args: $8(a6)=player_index(d5), $c(a6)=display_mode(d6)
    ; d5 = player_index (0-6): selects which player's data and position to use
    ; d6 = display_mode: controls which city/slot filter to apply to route icons
    ; a4 = ROM display layout data base ($4A5B8): contains layout params, compressed tileset, etc.
    ; a5 = -$1E(a6): local 14-byte player position array (word per player, 7 players = $E bytes)
    ; -$10(a6): MemCopy destination (receives layout data from a4+$12)
    ; -$20(a6): current player's position word (from player_word_tab $FF0118)
    link    a6,#-$40
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d5           ; d5 = player_index
    move.l  $c(a6), d6           ; d6 = display_mode / active city filter
    movea.l  #$0004A5B8,a4       ; a4 = ROM display layout base ($4A5B8): world-map display descriptor block
    lea     -$1e(a6), a5         ; a5 = local player position array ($1E bytes below frame = 14 words for 7 players)
    ; --- Phase: Copy layout data from ROM block to local stack frame ---
    ; Copy $10 (16) bytes starting at a4+$12 into -$10(a6) (layout param copy)
    pea     ($0010).w            ; arg 5: byte count = $10 (16 bytes)
    pea     -$10(a6)             ; arg 4: destination = -$10(a6) (local layout area)
    clr.l   -(a7)                ; arg 3: 0
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0               ; d0 = a4 + $12 (source = ROM layout block + $12 byte offset)
    move.l  d0, -(a7)            ; arg 2: source ptr = a4 + $12
    clr.l   -(a7)                ; arg 1: 0
    jsr MemCopy                  ; copy 16 bytes of layout params to local frame
    ; --- Phase: Resolve up to 7 player screen positions ---
    ; For each player 0-6: check if player's bit is set in bitfield_tab ($FFA6A0) for current player d5.
    ; If so, copy player's position word from player_word_tab ($FF0118) into local array a5.
    ; bitfield_tab ($FFA6A0) is indexed by player*4 -> gives a 32-bit presence bitmask
    ; $5ECDC is a ROM bitmask table (word per player) used to isolate each player's bit
    ; player_word_tab ($FF0118) is indexed by player*2 -> gives a word position value
    clr.w   d2                   ; d2 = player loop index (0-6)
l_1cbb8:
    ; Load bitfield_tab entry for current display player (d5)
    move.w  d5, d0
    lsl.w   #$2, d0              ; d0 = d5 * 4 (bitfield_tab stride = 4 bytes per player)
    movea.l  #$00FFA6A0,a0       ; a0 = bitfield_tab ($FFA6A0): per-player 32-bit presence bitfields
    move.l  (a0,d0.w), d0        ; d0 = bitfield_tab[d5] (presence bits for player d5's view)
    ; AND with ROM bitmask for player d2 to test if player d2 is visible in player d5's view
    move.w  d2, d1
    lsl.w   #$2, d1              ; d1 = d2 * 4 (ROM bitmask table stride)
    movea.l  #$0005ECDC,a0       ; a0 = ROM player visibility bitmask table ($5ECDC, 4 bytes per player)
    and.l   (a0,d1.w), d0        ; d0 &= bitmask for player d2 (nonzero = player d2 visible)
    beq.b   l_1cbec              ; zero: player d2 not visible in this view, skip
    ; Player d2 is visible: fetch their position from player_word_tab and store in local array
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2 (word index into player_word_tab)
    movea.l  #$00FF0118,a0       ; a0 = player_word_tab ($FF0118): word per player = screen position
    move.w  (a0,d0.w), d0        ; d0 = player_word_tab[d5]: current player's position word
    move.w  d2, d1
    add.w   d1, d1               ; d1 = d2 * 2 (word offset into local a5 array)
    move.w  d0, -$10(a6, d1.w)   ; store position at local_array[d2] (local frame, indexed by loop var)
l_1cbec:
    addq.w  #$1, d2              ; advance player loop
    cmpi.w  #$7, d2              ; processed all 7 players?
    blt.b   l_1cbb8              ; no: continue
    ; --- Phase: Configure DisplaySetup from ROM layout block ---
    ; DisplaySetup with mode $10, size $30, source = a4+$2 (layout data offset 2)
    pea     ($0010).w            ; arg 3: mode $10
    pea     ($0030).w            ; arg 2: size $30 (48)
    move.l  a4, d0
    addq.l  #$2, d0              ; d0 = a4 + $2: ROM layout block at offset 2
    move.l  d0, -(a7)            ; arg 1: layout data ptr
    jsr DisplaySetup             ; set up display parameters from ROM descriptor
    ; --- Phase: LZ_Decompress background tileset from ROM block ---
    ; ROM compressed tileset starts at a4+$82 (block offset $82)
    move.l  a4, d0
    addi.l  #$82, d0             ; d0 = a4 + $82: ROM LZ-compressed world-map background tiles
    move.l  d0, -(a7)            ; arg 2: ROM LZ source ptr
    pea     ($00FF1804).l        ; arg 1: destination = $FF1804 (VRAM staging buffer)
    jsr LZ_Decompress            ; decompress world-map background tileset into staging buffer
    lea     $28(a7), a7          ; clean DisplaySetup(3) + LZ(2) args = 5 * 4 = $14... (combined $28 = also covers extra)
    ; --- Phase: VRAMBulkLoad background tileset to VRAM ---
    ; Load $330 words starting at char $25 from staging buffer $FF1804
    clr.l   -(a7)                ; arg 6: 0
    clr.l   -(a7)                ; arg 5: 0
    pea     ($00FF1804).l        ; arg 4: source = staging buffer
    pea     ($0025).w            ; arg 3: VRAM char# = $25 (tile 37: world-map tile area start)
    pea     ($0330).w            ; arg 2: word count = $330 (816 words = 1632 bytes of tile data)
    jsr VRAMBulkLoad             ; DMA-load background tiles to VRAM
    ; --- Phase: GameCommand #$1B -- place tile strip from ROM block at a4+$22 ---
    ; Renders world-map tile strip: 1 row, $15 cols wide, $8 height, palette 6, at position in a4+$22
    move.l  a4, d0
    moveq   #$22,d1
    add.l   d1, d0               ; d0 = a4 + $22: ROM tile strip descriptor at block offset $22
    move.l  d0, -(a7)            ; arg 7: tile strip data ptr
    pea     ($0006).w            ; arg 6: palette = 6
    pea     ($0008).w            ; arg 5: height = 8
    pea     ($0015).w            ; arg 4: width = $15 (21 tiles)
    pea     ($0001).w            ; arg 3: 1
    clr.l   -(a7)                ; arg 2: 0
    pea     ($001B).w            ; arg 1: GameCommand #$1B = render tile strip
    jsr GameCommand
    lea     $30(a7), a7          ; clean VRAMBulkLoad(5)+GameCmd(7) args
    ; --- Phase: DisplaySetup with player position data ---
    pea     ($0008).w            ; arg 3: mode $08
    pea     ($0038).w            ; arg 2: size $38 (56)
    pea     -$10(a6)             ; arg 1: local layout area (filled by MemCopy above)
    jsr DisplaySetup
    ; MemFillByte: clear local player position array a5 ($E bytes) to 0
    pea     ($000E).w            ; arg 3: byte count = $E (14 bytes = 7 words)
    clr.l   -(a7)                ; arg 2: fill value = 0
    move.l  a5, -(a7)            ; arg 1: destination = local player position array
    jsr MemFillByte              ; zero-initialize the 7-slot position array
    ; Place current player's own position into local array's -$20(a6) slot
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2 (word index into player_word_tab)
    movea.l  #$00FF0118,a0       ; a0 = player_word_tab ($FF0118)
    move.w  (a0,d0.w), -$20(a6) ; -$20(a6) = current player's own position word
    ; DisplaySetup mode $F: apply current player's position (self-marker on world map)
    pea     ($0001).w
    pea     ($000F).w            ; mode $F: place player self-position marker
    pea     -$20(a6)             ; &current_player_position
    jsr DisplaySetup
    lea     $24(a7), a7          ; clean DisplaySetup(3)+MemFillByte(3)+DisplaySetup(3) args
    ; --- Phase: Resolve route slot icon positions ---
    ; $FF0338 = route_slot_display_tab: 8-byte records for up to 4 route display slots per player
    ; Each record: +$00 = city_id, +$01 = slot_type ($00=empty/placeholder, $06=special/find-bit)
    ; a2 = pointer to first of 4 route records for this player (player_index * $20 offset)
    ; d3 = route slot loop index (0-3); d4 = placeholder icon counter
    move.w  d5, d0
    lsl.w   #$5, d0              ; d0 = d5 * $20 (route_slot_display_tab stride = $20 bytes per player = 4 * 8)
    movea.l  #$00FF0338,a0       ; a0 = route_slot_display_tab ($FF0338)
    lea     (a0,d0.w), a0        ; a0 = &route_slot_display_tab[player_index]
    movea.l a0, a2               ; a2 = current route record ptr
    clr.w   d3                   ; d3 = route slot loop index (0-3)
    clr.w   d4                   ; d4 = placeholder icon offset counter (for empty slots)
    bra.w   l_1cdc2              ; jump to loop condition (test first)
    ; =========================================================
    ; Route slot icon placement loop: 4 iterations (d3 = 0-3)
    ; =========================================================
l_1ccc0:
    ; Check slot_type: +$01 == 0 means empty/placeholder (place a generic blank icon)
    tst.b   $1(a2)               ; route_record +$01 = slot_type: 0 = empty placeholder
    bne.b   l_1cd10              ; nonzero slot_type: place a real city/route icon
    ; --- Placeholder slot: place generic blank icon at offset based on d4 ---
    ; TilePlacement args: tile char# $544, Y = d3+$3B, X = d4*8+$48, palette 1, count 2, priority 0
    clr.l   -(a7)                ; arg 7: 0
    pea     ($0002).w            ; arg 6: count = 2
    pea     ($0001).w            ; arg 5: palette = 1
    pea     ($00A8).w            ; arg 4: tile attr = $00A8
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0              ; d0 = d4 * 8 (icon spacing = 8 pixels per placeholder slot)
    addi.l  #$48, d0             ; d0 += $48 (base X for placeholder icons = $48)
    move.l  d0, -(a7)            ; arg 3: X screen position
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0             ; d0 = d3 + $3B (Y = route index + $3B base row = 59)
    move.l  d0, -(a7)            ; arg 2: Y screen position
    pea     ($0544).w            ; arg 1: tile char# $544 (placeholder/blank route icon)
    jsr TilePlacement            ; $01E044: compute tile params and call GameCmd #$F
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand              ; GameCommand #$E: display sync after tile placement
    lea     $24(a7), a7          ; clean TilePlacement(7) + GameCmd(2) args... ($24=36)
    addq.w  #$1, d4              ; advance placeholder icon counter
    bra.w   l_1cdbe              ; advance a2 and d3, continue loop
l_1cd10:
    ; --- Active route slot: resolve city display index ---
    ; slot_type $06 = "special" route: use FindBitInField to map to city index
    ; other slot_types: use RangeLookup to convert city_id to display range index
    cmpi.b  #$6, $1(a2)         ; slot_type == $6 (special/bit-field route)?
    beq.b   l_1cd2e              ; yes: use FindBitInField
    ; Regular slot: city_id from record +$00; RangeLookup maps it to a display range bucket
    moveq   #$0,d2
    move.b  (a2), d2             ; d2 = city_id (route_record +$00)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg: city_id
    jsr RangeLookup              ; map city_id to range/display bucket index; result in d0
    addq.l  #$4, a7
    move.w  d0, d2               ; d2 = resolved city display index
    bra.b   l_1cd46
l_1cd2e:
    ; Special slot (type $6): city_id from record +$00; use FindBitInField with player/mode args
    moveq   #$0,d2
    move.b  (a2), d2             ; d2 = city_id (raw)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 3: display_mode (d6)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 2: player_index (d5)
    jsr FindBitInField           ; find bit position for this city in player's bitfield; result = display index in d0
    addq.l  #$8, a7
l_1cd46:
    ; If resolved city index == d6 (display_mode filter), skip placing icon for this slot
    cmp.w   d6, d2               ; d2 == d6 (filtered out)?
    beq.b   l_1cdbe              ; yes: skip icon, advance to next slot
    ; Fetch icon descriptor from ROM table $5F088 (2-byte entries, indexed by city display index)
    ; $5F088 entry: +$00 = X base offset byte, +$01 = Y row offset byte
    move.w  d2, d0
    add.w   d0, d0               ; d0 = d2 * 2 (word index into $5F088)
    movea.l  #$0005F088,a0       ; a0 = ROM city icon descriptor table ($5F088)
    lea     (a0,d0.w), a0        ; a0 = &icon_descriptor[d2]
    movea.l a0, a3               ; a3 = icon descriptor ptr
    ; TilePlacement: place airline/route icon at computed position
    ; X = icon_descriptor[+$01] + $A8 + player_position_array[d2*2] + $8
    ; Y = d3 + $3B (route slot row)
    clr.l   -(a7)                ; arg 7: 0
    pea     ($0002).w            ; arg 6: count = 2
    pea     ($0001).w            ; arg 5: palette = 1
    moveq   #$0,d0
    move.b  $1(a3), d0           ; icon_descriptor +$01 = Y row offset byte
    addi.l  #$a8, d0             ; d0 += $A8 (base X coordinate = $A8 = 168)
    move.l  d0, -(a7)            ; arg 4: base X + descriptor offset
    ; Add player's accumulated position offset from local array a5 (indexed by d2*2)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0               ; d0 = d2 * 2 (word offset into local position array)
    movea.l d0, a0               ; use as address register for indexed access
    move.w  (a5,a0.l), d0        ; d0 = player_pos_array[d2*2] (local position accumulator for this city)
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1             ; icon_descriptor +$00 = X base offset byte
    add.l   d1, d0               ; d0 += X base offset from descriptor
    addq.l  #$8, d0              ; d0 += $8 (final X = base + descriptor + accumulated + 8)
    move.l  d0, -(a7)            ; arg 3: final X screen position
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0             ; d0 = d3 + $3B (Y = route_slot_index + 59 = row in route display)
    move.l  d0, -(a7)            ; arg 2: Y screen position
    pea     ($0544).w            ; arg 1: tile char# $544 (airline route icon)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand              ; GameCommand #$E: display sync
    lea     $24(a7), a7          ; clean 9 args
    ; Advance position accumulator for this city slot: add 3 to separate icons for multiple routes
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0               ; d0 = d2 * 2
    movea.l d0, a0
    addq.w  #$3, (a5,a0.l)      ; player_pos_array[d2*2] += 3 (shift next icon right by 3 pixels)
l_1cdbe:
    addq.l  #$8, a2              ; advance to next 8-byte route record
    addq.w  #$1, d3              ; increment slot loop index
l_1cdc2:
    cmpi.w  #$4, d3              ; processed all 4 route slots?
    blt.w   l_1ccc0              ; no: continue
    ; --- Phase: Compute and print year/quarter string ---
    ; frame_counter ($FF0006) encodes game time: quarter = frame_counter mod 4, year = frame_counter / 4
    ; quarter display string indexed from ROM $5F096 (pointer table, 4 entries * 4 bytes)
    ; year = (frame_counter / 4) + $7A3 (base year, 1987 in game)
    move.w  ($00FF0006).l, d0    ; d0 = frame_counter ($FF0006): game clock (increments each quarter)
    ext.l   d0
    moveq   #$4,d1               ; divisor = 4 (4 quarters per year)
    jsr SignedMod                ; d0 = frame_counter mod 4 = quarter index (0-3)
    move.l  d0, d2               ; d2 = quarter index
    mulu.w  #$3, d2              ; d2 *= 3 (quarter display offset; may be used as string table stride)
    ; Compute year number: year = (frame_counter + (3 if negative, else 0)) >> 2
    ; The adjustment handles proper rounding for negative values (shouldn't occur in practice)
    move.w  ($00FF0006).l, d0    ; reload frame_counter
    ext.l   d0
    bge.b   l_1cdec              ; non-negative: no adjustment needed
    addq.l  #$3, d0              ; negative frame: add 3 before shift (round-towards-zero correction)
l_1cdec:
    asr.l   #$2, d0              ; d0 = frame_counter >> 2 = year index (arithmetic right shift = floor div)
    addi.w  #$7a3, d0            ; d0 += $7A3 = $7A3 decimal... actually $7A3 = 1955: base year offset
    move.w  d0, d3               ; d3 = display year number (e.g. frame 0 -> year $7A3 = 1955... game-specific)
    ; SetTextWindow to full screen ($20 x $20) at origin (0,0) for year/quarter text
    pea     ($0020).w            ; arg 4: width = $20 (32 tiles = full screen width)
    pea     ($0020).w            ; arg 3: height = $20 (32 tiles = full screen height)
    clr.l   -(a7)                ; arg 2: Y = 0
    clr.l   -(a7)                ; arg 1: X = 0
    jsr SetTextWindow            ; set text window to full screen
    pea     ($0015).w            ; arg 2: row = $15 (21: bottom area of screen)
    pea     ($0001).w            ; arg 1: col = $01 (1: left margin)
    jsr SetTextCursor            ; position text cursor for year/quarter display
    ; Print year + quarter string: format $4116C, args = quarter_string_ptr + year_number
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 3: year number (e.g. 1955 + frame/4)
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2 * 4 (pointer table index for quarter string)
    movea.l  #$0005F096,a0       ; a0 = ROM quarter name pointer table ($5F096): 4 season/quarter strings
    move.l  (a0,d0.w), -(a7)     ; arg 2: quarter string ptr (e.g. "Q1", "Q2", etc.)
    pea     ($0004116C).l        ; arg 1: ROM format string (e.g. "%s %d" for "Q2 1991")
    jsr PrintfNarrow             ; $03B246: format and display the year/quarter string
    movem.l -$64(a6), d2-d6/a2-a5
    unlk    a6
    rts
