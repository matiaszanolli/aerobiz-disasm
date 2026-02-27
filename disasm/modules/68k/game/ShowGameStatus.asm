; ============================================================================
; ShowGameStatus -- Renders the global game-status screen: builds the background with city-column headers, displays each player's city count and rank tokens, places character portraits with their current rankings, and shows total route counts.
; Called: ?? times.
; 1072 bytes | $0271C6-$0275F5
; ============================================================================
; --- Phase: Prologue / Background Setup ---
ShowGameStatus:                                                  ; $0271C6
    link    a6,#-$e4                ; allocate $E4 (228) bytes of local frame space
    movem.l d2-d5/a2-a5,-(sp)
    ; Initialize two local-frame display words used as DisplaySetup data sources
    move.w  #$7c00,-$0002(a6)       ; local -$2: $7C00 = tile attribute word (palette 3, priority, no flip)
    clr.w   -$0004(a6)              ; local -$4: 0 (secondary display parameter, cleared)
    dc.w    $4eb9,$0001,$d71c       ; jsr ResourceLoad ($01D71C): load game-status screen resource if not loaded
    ; GameCommand #$10: clear screen (scroll planes)
    pea     ($0040).w               ; priority flag $40
    clr.l   -(sp)                   ; arg = 0
    pea     ($0010).w               ; GameCommand #$10 = clear screen
    dc.w    $4eb9,$0000,$0d64       ; jsr GameCommand ($000D64)
    ; ClearScreen ($00538E): second screen clear (clears both BG planes)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e       ; jsr ClearScreen ($00538E)
    ; LoadScreen ($006A2E/near): load and initialize the game-status screen (screen index 4)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0004).w               ; screen index 4 = game status screen
    dc.w    $4eb9,$0000,$68ca       ; jsr LoadScreen ($0068CA): loads gfx/tileset for game status screen
    ; SetTextWindow: define 27-row × 32-col text window at origin (0,0)
    pea     ($001B).w               ; window height = $1B = 27
    pea     ($0020).w               ; window width  = $20 = 32
    clr.l   -(sp)                   ; top  = 0
    clr.l   -(sp)                   ; left = 0
    dc.w    $4eb9,$0003,$a942       ; jsr SetTextWindow ($03A942)
    lea     $002c(sp),sp            ; clean up 11 longwords
    ; DisplaySetup (×4): configure 4 display parameter blocks for the status screen
    ; Block 1: height=4, width=$21 (33), data = player_word_tab ($FF0118)
    pea     ($0004).w               ; height = 4
    pea     ($0021).w               ; width  = $21 = 33 columns
    pea     ($00FF0118).l           ; player_word_tab: 4 words, one per player (indices/flags)
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092)
    ; Block 2: height=1, width=$25 (37), data = local -$2 ($7C00 tile attribute word)
    pea     ($0001).w               ; height = 1
    pea     ($0025).w               ; width  = $25 = 37
    pea     -$0002(a6)              ; &local -$2: $7C00 tile attr (palette 3, priority flag set)
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092)
    ; Block 3: height=1, width=$26 (38), data = local -$4 (0)
    pea     ($0001).w
    pea     ($0026).w               ; width = $26 = 38
    pea     -$0004(a6)              ; &local -$4: 0 (clear parameter)
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092)
    ; Block 4: height=$10 (16), width=$30 (48), data = ROM layout at $76A9E
    pea     ($0010).w               ; height = $10 = 16
    pea     ($0030).w               ; width  = $30 = 48
    pea     ($00076A9E).l           ; ROM: display tile-layout descriptor for game status BG
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092)
    lea     $0030(sp),sp            ; clean up 12 longwords
    ; LZ decompress top banner graphic and place into VRAM
    move.l  ($000A1B68).l,-(sp)     ; ROM compressed data ptr from pointer table at $A1B68
    pea     ($00FF1804).l           ; dest = save_buf_base ($FF1804): staging buffer
    dc.w    $4eb9,$0000,$3fec       ; jsr LZ_Decompress ($003FEC): decompress banner graphic
    ; CmdPlaceTile: place the banner tiles at row $15, attribute word $030F
    pea     ($0015).w               ; tile row = $15 = 21
    pea     ($030F).w               ; tile attribute: palette 0, priority 1, char# offset
    pea     ($00FF1804).l           ; src = decompressed tile data in staging buffer
    dc.w    $4eb9,$0000,$4668       ; jsr CmdPlaceTile ($004668): DMA tile data to VRAM
    ; GameCommand #$1B: draw the status-screen border box
    pea     ($00073378).l           ; ROM: border tile pattern for status screen frame
    pea     ($0002).w               ; box height = 2
    pea     ($001E).w               ; box width  = $1E = 30
    pea     ($0001).w               ; arg
    pea     ($0001).w               ; box top row = 1
    pea     ($0001).w               ; box left col = 1
    pea     ($001B).w               ; GameCommand #$1B = draw bordered rectangle
    dc.w    $4eb9,$0000,$0d64       ; jsr GameCommand ($000D64)
    lea     $0030(sp),sp            ; clean up 12 longwords
    ; --- Phase: Compute Tile Base Index and Print Screen Title ---
    ; Same frame_counter→tile-index computation as RenderQuarterReport (shared pattern)
    move.w  ($00FF0006).l,d0        ; d0 = frame_counter ($FF0006)
    ext.l   d0
    bge.b   .l272c4
    addq.l  #$3,d0                  ; rounding correction for negative frame_counter
.l272c4:                                                ; $0272C4
    asr.l   #$2,d0                  ; d0 = frame_counter / 4 = current quarter index
    addi.w  #$07a3,d0               ; d0 += $7A3 = 1955: tile char# offset for status screen font
    move.w  d0,d2                   ; d2 = computed tile base index (used for text rendering throughout)
    ; SetTextCursor at (col=1, row=5) for screen title
    pea     ($0001).w               ; cursor X = col 1
    pea     ($0005).w               ; cursor Y = row 5
    dc.w    $4eb9,$0003,$ab2c       ; jsr SetTextCursor ($03AB2C)
    ; PrintfWide: render the screen title using the computed tile base index
    moveq   #$0,d0
    move.w  d2,d0                   ; d0 = tile base index
    move.l  d0,-(sp)               ; numeric arg for title format
    pea     ($00041598).l           ; ROM: "Game Status" screen title format string
    dc.w    $4eb9,$0003,$b270       ; jsr PrintfWide ($03B270)
    lea     $0010(sp),sp            ; clean up 4 longwords
    ; --- Phase: City Column Header Loop (7 city columns across the top) ---
    ; $5FAA6 = ROM table of city column descriptor bytes: byte[0]=col tile X, byte[1]=col tile width
    movea.l #$0005faa6,a2           ; a2 = ROM city-column descriptor table (2 bytes per city column)
    clr.w   d3                      ; d3 = city column loop counter (0..6, 7 columns total)
    ; Compute initial position in local tile data buffer for column 0
    move.w  d3,d0
    lsl.w   #$5,d0                  ; d0 = d3 * $20 = 0 (column 0 offset in local frame buffer)
    lea     -$00e4(a6),a0           ; a0 = local frame buffer base (228-byte allocation at -$E4)
    lea     (a0,d0.w),a1            ; a1 = start of this column's buffer section
    movea.l a1,a3                   ; a3 = working tile-data buffer ptr for current column
    moveq   #$0,d5
    move.w  d3,d5
    lsl.l   #$4,d5                  ; d5 = d3 * $10 = 0 (initial tile char# base for column 0)
    addi.l  #$0640,d5               ; d5 += $640 = 1600: tile char# starting offset for city header row
.l27312:                                                ; $027312
    ; Fill 16 sequential tile words into local buffer for this column's header row
    ; Each word = sequential tile char# (d5, d5+1, ... d5+$F)
    clr.w   d2                      ; d2 = inner loop counter (0..15 = $10 tiles per column)
    move.w  d2,d4
    ext.l   d4
    add.l   d5,d4                   ; d4 = tile char# starting value for this column (d5 + 0)
.l2731a:                                                ; $02731A
    ; Store tile char# d4 at word position d2*2 in local buffer a3
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0                   ; d0 = d2 * 2 (byte offset for this tile word in buffer)
    movea.l d0,a0
    move.w  d4,(a3,a0.l)            ; write tile char# d4 into buffer[d2]
    addq.l  #$1,d4                  ; next sequential tile char#
    addq.w  #$1,d2                  ; d2++ inner counter
    cmpi.w  #$10,d2                 ; filled all 16 tile words?
    blt.b   .l2731a                 ; no: continue filling
    ; GameCommand #$1B: place the 16-tile city column header from the local buffer
    move.l  a3,-(sp)               ; tile data buffer ptr
    pea     ($0002).w               ; height = 2 rows
    pea     ($0008).w               ; width  = 8 columns
    ; Column X position = ROM descriptor byte[1] (tile width/offset byte) - 2
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; d0 = descriptor byte 1 = column tile X position
    addi.w  #$fffe,d0               ; d0 -= 2 (adjust to left edge of column header)
    ext.l   d0
    move.l  d0,-(sp)               ; X position
    ; Column Y (row) position = ROM descriptor byte[0] (tile row)
    moveq   #$0,d0
    move.b  (a2),d0                 ; d0 = descriptor byte 0 = column tile Y row
    ext.l   d0
    move.l  d0,-(sp)               ; Y position
    clr.l   -(sp)                   ; arg = 0
    pea     ($001B).w               ; GameCommand #$1B = draw bordered tile block
    dc.w    $4eb9,$0000,$0d64       ; jsr GameCommand ($000D64)
    ; LZ decompress the portrait/icon graphic for this city column
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$2,d0                  ; d0 = d3 * 4 (longword stride into pointer table)
    movea.l #$000a1ac8,a0           ; a0 = ROM city-column graphics pointer table at $A1AC8
    move.l  (a0,d0.l),-(sp)        ; push compressed graphics ptr for this city column
    pea     ($00FF899C).l           ; dest = screen_buf ($FF899C: $3A4-byte tile staging buffer)
    dc.w    $4eb9,$0000,$3fec       ; jsr LZ_Decompress ($003FEC): decompress column icon graphic
    ; Place decompressed tiles: height=$10, tile_char_base=d5, dest=screen_buf
    pea     ($0010).w               ; height = $10 = 16 tiles
    move.l  d5,-(sp)               ; tile char# base for this column (computed above)
    pea     ($00FF899C).l           ; src = screen_buf (decompressed tile data)
    dc.w    $4eb9,$0000,$45e6       ; jsr VRAMBulkLoad ($0045E6): DMA tiles to VRAM at char# d5
    lea     $0030(sp),sp            ; clean up 12 longwords
    ; Advance to next city column
    addq.l  #$2,a2                  ; a2 += 2: next 2-byte city column descriptor
    moveq   #$10,d0
    add.l   d0,d5                   ; d5 += $10: tile char# advances by 16 (one column's worth)
    moveq   #$20,d0
    adda.l  d0,a3                   ; a3 += $20: next 32-byte section of local frame buffer
    addq.w  #$1,d3                  ; d3++: next column
    cmpi.w  #$7,d3                  ; processed all 7 city columns?
    bcs.w   .l27312                 ; no: loop
    ; --- Phase: Player × City Grid Loop (4 players × 7 city columns) ---
    ; Outer loop: d2 = player index (0..3)
    ; Inner loop: d3 = city column index (0..6)
    ; Renders city ownership tokens and character rank indicators for each player
    movea.l #$00ff0018,a5           ; a5 = player_records base ($FF0018): stride $24, 4 players
    clr.w   d2                      ; d2 = player index (outer loop counter, 0..3)
.l273aa:                                                ; $0273AA
    ; RangeLookup: map hub_city (player_record[+$01]) to a city range index (0-7)
    moveq   #$0,d0
    move.b  $0001(a5),d0            ; d0 = player_record[+$01] = hub_city index (0-88, $FF = none)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648       ; jsr RangeLookup ($00D648): map hub_city → range category 0-7
    addq.l  #$4,sp
    move.w  d0,d4                   ; d4 = hub_city range category (used to identify player's "home column")
    ; Set up city-column descriptor pointer and two RAM table pointers for this player
    movea.l #$0005faa6,a2           ; a2 = ROM city-column descriptor table (2 bytes per column)
    ; $FF0270: 32-byte block, purpose TBD; indexed player*8 (stride 8): per-player city-slot occupancy byte
    move.w  d2,d0
    lsl.w   #$3,d0                  ; d0 = player_index * 8 (stride 8 into $FF0270 block)
    movea.l #$00ff0270,a0           ; a0 = $FF0270 block (32 bytes, PackSaveState, purpose TBD)
    lea     (a0,d0.w),a0
    movea.l a0,a3                   ; a3 = ptr to this player's 8-byte slot in $FF0270 (city count/slot byte)
    ; $FF0130: 128-byte block, purpose TBD; indexed player*$20 (stride $20): per-player bitfield / slot records
    move.w  d2,d0
    lsl.w   #$5,d0                  ; d0 = player_index * $20 (stride $20 = 32 bytes into $FF0130)
    movea.l #$00ff0130,a0           ; a0 = $FF0130 block (128 bytes, PackSaveState, purpose TBD)
    lea     (a0,d0.w),a0
    movea.l a0,a4                   ; a4 = ptr to this player's 32-byte section in $FF0130 (slot/rank records)
    clr.w   d3                      ; d3 = city column index (inner loop counter, 0..6)
.l273e6:                                                ; $0273E6
    ; Check whether this player has any data for this city column slot
    tst.l   (a4)                    ; is this player's city-slot record non-zero?
    beq.w   .l27492                 ; zero: player has no presence in this city column; draw blank token

    ; Player has a city slot here: draw the rank token with player color
    ; Compute tile char# for player name tile (d2 + $754)
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0               ; d0 = player tile char# base ($754 + player_index)
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0                  ; d0 = player_index + 1 (tile sequence count)
    move.l  d0,-(sp)
    clr.l   -(sp)                   ; tile fill arg = 0
    pea     ($0001).w               ; rect height = 1
    pea     ($0008).w               ; rect width  = 8 (token occupies 8 columns)
    ; Compute X position: descriptor byte 1 (tile X) + city-slot byte (a3) - 1
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; d0 = column descriptor: tile X position
    moveq   #$0,d1
    move.b  (a3),d1                 ; d1 = city slot byte from $FF0270 (slot column within city band)
    add.w   d1,d0                   ; d0 = base X + slot offset
    addi.w  #$ffff,d0               ; d0 -= 1 (adjust to token left edge)
    ext.l   d0
    move.l  d0,-(sp)               ; X position
    moveq   #$0,d0
    move.b  (a2),d0                 ; d0 = column descriptor byte 0: tile Y (row)
    ext.l   d0
    move.l  d0,-(sp)               ; Y position
    pea     ($0001).w               ; attr = 1 (palette 0)
    dc.w    $4eb9,$0000,$6760       ; jsr FillTileRect ($006760): draw filled tile token for this player/city
    ; SetTextCursor at same position for rank number overlay
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; column tile X
    moveq   #$0,d1
    move.b  (a3),d1                 ; slot offset
    add.w   d1,d0
    addi.w  #$ffff,d0               ; -1 to align
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0                 ; column tile Y (row)
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c       ; jsr SetTextCursor ($03AB2C)
    ; PrintfNarrow: render the rank value (city count) from this player's slot record
    move.l  (a4),-(sp)             ; city-slot value (rank or city count) from $FF0130 record
    pea     ($00041592).l           ; ROM: narrow-font format string for rank number
    dc.w    $4eb9,$0003,$b246       ; jsr PrintfNarrow ($03B246): render rank in narrow font
    lea     $0030(sp),sp            ; clean up 12 longwords
    ; PlaceIconPair ($00595E): place a small 1×1 icon 7 rows below the token (sub-indicator)
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; column tile X
    moveq   #$0,d1
    move.b  (a3),d1                 ; slot offset
    add.w   d1,d0
    addi.w  #$ffff,d0               ; -1 to align
    move.l  d0,-(sp)               ; X position
    moveq   #$0,d0
    move.b  (a2),d0                 ; column tile Y (row)
    addq.w  #$7,d0                  ; row + 7 (sub-indicator appears 7 rows below main token)
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$595e       ; jsr PlaceIconPair ($00595E): place sub-indicator icon
    lea     $0010(sp),sp
    bra.b   .l274ce                 ; skip blank-token path, go to hub-city portrait check
.l27492:                                                ; $027492
    ; Player has no presence here: draw blank/empty city token placeholder
    pea     ($075C).w               ; tile char# $75C = empty city slot tile
    pea     ($0005).w               ; tile width = 5 (blank token is narrower)
    clr.l   -(sp)                   ; tile fill arg = 0
    pea     ($0001).w               ; rect height = 1
    pea     ($0008).w               ; rect width  = 8
    ; Same X/Y computation as filled token (descriptor bytes + slot offset - 1)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d0
    addi.w  #$ffff,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760       ; jsr FillTileRect ($006760): draw empty city-slot placeholder
    lea     $0020(sp),sp
.l274ce:                                                ; $0274CE
    ; Check whether this city column is the player's hub city column (d4 = hub range category)
    cmp.w   d4,d3                   ; is current city column (d3) the player's hub category (d4)?
    bne.b   .l27522                 ; no: no portrait, advance to next column
    ; This city column is the player's hub: place the character portrait sprite here
    ; TilePlacement ($01E044): place a portrait tile at the hub column position
    clr.l   -(sp)                   ; tile char# = 0 (portrait base)
    pea     ($0001).w               ; height = 1
    pea     ($0001).w               ; width  = 1
    ; Portrait X = (col_X + slot) * 8 - 8 (pixel coords from tile coords × 8, offset -$F8 = -8 relative)
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; column tile X
    moveq   #$0,d1
    move.b  (a3),d1                 ; slot byte
    add.w   d1,d0
    lsl.w   #$3,d0                  ; ×8 (convert tile → pixel X)
    addi.w  #$fff8,d0               ; -8 = pixel correction to align portrait within cell
    ext.l   d0
    move.l  d0,-(sp)               ; pixel X
    moveq   #$0,d0
    move.b  (a2),d0                 ; column tile Y
    lsl.w   #$3,d0                  ; ×8 (convert tile → pixel Y)
    addi.w  #$fff8,d0               ; -8 pixel correction
    ext.l   d0
    move.l  d0,-(sp)               ; pixel Y
    moveq   #$0,d0
    move.w  d2,d0                   ; d0 = player_index (selects palette/sprite for this player)
    move.l  d0,-(sp)
    pea     ($0760).w               ; tile char# $760 = character portrait tile base
    dc.w    $4eb9,$0001,$e044       ; jsr TilePlacement ($01E044): place portrait tile at computed coords
    ; GameCommand #$E (= #14): request display update / commit tiles to screen
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand #$E = display update / refresh
    dc.w    $4eb9,$0000,$0d64       ; jsr GameCommand ($000D64)
    lea     $0024(sp),sp
.l27522:                                                ; $027522
    ; Advance inner loop: a2+=2 (next descriptor), a3+=1 (next slot byte), a4+=4 (next slot record)
    addq.l  #$2,a2                  ; next city-column descriptor (2 bytes per entry)
    addq.l  #$1,a3                  ; next per-player slot byte in $FF0270 block
    addq.l  #$4,a4                  ; next longword slot record in $FF0130 block
    addq.w  #$1,d3                  ; d3++: next city column
    cmpi.w  #$7,d3                  ; processed all 7 city columns for this player?
    bcs.w   .l273e6                 ; no: loop inner
    ; Advance outer loop: a5 += $24 (next player record), d2++ (next player)
    moveq   #$24,d0
    adda.l  d0,a5                   ; a5 → next player record (stride $24 = 36 bytes)
    addq.w  #$1,d2                  ; d2++: next player
    cmpi.w  #$4,d2                  ; processed all 4 players?
    bcs.w   .l273aa                 ; no: outer loop back
    ; --- Phase: Player Route-Count Row (4 players across bottom of status screen) ---
    ; Draws each player's route count / name token in the bottom row of the status grid
    ; $5FAB4 = alternate ROM city-column descriptor table variant (same 2-byte stride, different offsets)
    movea.l #$0005fab4,a2           ; a2 = ROM city-column descriptor table variant B
    clr.w   d2                      ; d2 = player index (0..3)
    ; $FF0277 = byte within $FF0270 block at offset +$07: route-count column positioning bytes
    move.w  d2,d0
    lsl.w   #$3,d0                  ; d0 = player_index * 8
    movea.l #$00ff0277,a0           ; a0 = $FF0277 (= $FF0270 + $07): stride-8 table, player route-count positions
    lea     (a0,d0.w),a0
    movea.l a0,a3                   ; a3 = ptr to player 0's route-count position byte
.l27558:                                                ; $027558
    ; Draw the route-count tile block for this player
    ; Tile char# = player_index + $754 (player-name tile), count = player_index + 1
    moveq   #$0,d0
    move.w  d2,d0
    addi.l  #$0754,d0               ; tile char# base for player name (same as city column loop)
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0                  ; tile count = player_index + 1
    move.l  d0,-(sp)
    clr.l   -(sp)                   ; arg = 0
    pea     ($0002).w               ; height = 2 rows
    pea     ($0007).w               ; width  = 7 columns
    ; X position: descriptor byte 1 (tile X) + slot_byte * 2 - 2
    ; slot_byte × 2: each route slot occupies 2 tile columns
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; descriptor tile X
    moveq   #$0,d1
    move.b  (a3),d1                 ; route-count position byte
    add.w   d1,d1                   ; × 2 (2 tile columns per slot)
    add.w   d1,d0
    addi.w  #$fffe,d0               ; -2 (adjust to left edge)
    ext.l   d0
    move.l  d0,-(sp)               ; X
    moveq   #$0,d0
    move.b  (a2),d0                 ; descriptor tile Y (row)
    ext.l   d0
    move.l  d0,-(sp)               ; Y
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760       ; jsr FillTileRect ($006760): draw player route-count token
    ; SetTextCursor at same computed position for text overlay
    moveq   #$0,d0
    move.b  $0001(a2),d0            ; descriptor tile X
    moveq   #$0,d1
    move.b  (a3),d1
    add.w   d1,d1                   ; × 2
    add.w   d1,d0
    addi.w  #$fffe,d0               ; -2
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c       ; jsr SetTextCursor ($03AB2C)
    ; PrintfWide: print player name from $FF00A8 display-name buffer (16-byte stride per player)
    move.w  d2,d0
    lsl.w   #$4,d0                  ; d0 = player_index * $10 (16-byte stride into $FF00A8 name buffer)
    movea.l #$00ff00a8,a0           ; a0 = $FF00A8: player display name buffer (64 bytes, 4 × 16)
    pea     (a0,d0.w)               ; ptr to this player's 16-byte name entry
    dc.w    $4eb9,$0003,$b270       ; jsr PrintfWide ($03B270): render player name at cursor
    lea     $002c(sp),sp            ; clean up 11 longwords
    ; Advance to next player
    addq.l  #$8,a3                  ; a3 += 8 (stride to next player's route-count position byte)
    addq.w  #$1,d2                  ; d2++: next player
    cmpi.w  #$4,d2                  ; done all 4 players?
    bcs.w   .l27558                 ; no: loop
    ; --- Phase: Epilogue ---
    dc.w    $4eb9,$0001,$d748       ; jsr ResourceUnload ($01D748): unload game-status screen resources
    movem.l -$0104(a6),d2-d5/a2-a5 ; restore saved registers (offset -$104 = -$E4 frame - $20 movem save)
    unlk    a6
    rts
; === Translated block $0275F6-$027AA4 ===
; 4 functions, 1198 bytes
