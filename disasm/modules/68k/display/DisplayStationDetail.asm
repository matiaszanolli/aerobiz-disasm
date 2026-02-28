; ============================================================================
; DisplayStationDetail -- Displays the station/facility detail screen for a given city and player: loads resources, decompresses and renders station graphics to VRAM, shows the char portrait, facility name, ownership string, and optionally animates a facility tile sequence
; 746 bytes | $02BA24-$02BD0D
; ============================================================================
DisplayStationDetail:
    ; --- Phase: Setup ---
    ; Stack args: $8(a6)=player_index(d2), $c(a6)=city_index(d6), $10(a6)=ownership_flag(d5)
    ; d2 = player_index (used to index into player_records and for ShowDialog)
    ; d5 = ownership_flag (1 = player owns facility, else = not owned)
    ; d6 = city_index (indexes into city name table and portrait/stat tables)
    ; a2 = GameCommand ($0D64)
    ; a3 = decompression work buffer ($FF1804, shared VRAM staging area)
    ; a4 = DisplaySetup ($005092)
    ; a5 = LZ_Decompress-wrapper at $01D98C (args: src ptr, dst ptr)
    ; -$2(a6) = tile_attr local variable (word, holds current tile attribute for animation)
    ; -$82(a6) = sprintf output buffer ($82 bytes, used for facility ownership string)
    link    a6,#-$84
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d2           ; d2 = player_index
    move.l  $10(a6), d5          ; d5 = ownership_flag (1 = owned by this player)
    move.l  $c(a6), d6           ; d6 = city_index (identifies which station/facility)
    movea.l  #$00000D64,a2       ; a2 = GameCommand ($000D64)
    movea.l  #$00FF1804,a3       ; a3 = VRAM staging buffer ($FF1804, 64KB work area)
    movea.l  #$00005092,a4       ; a4 = DisplaySetup ($005092)
    movea.l  #$0001D98C,a5       ; a5 = LZ_Decompress dispatch ($01D98C)
    ; --- Phase: Load resources and set up screen ---
    jsr ResourceLoad             ; load display resources needed for station detail screen
    ; GameCommand #$7: initialize display mode with VRAM address $FC00 (tile buffer start)
    clr.l   -(a7)                ; arg 6: 0
    move.l  #$fc00, -(a7)        ; arg 5: VRAM destination = $FC00 (station tile area)
    pea     ($0400).w            ; arg 4: transfer size = $400 (1024 words)
    pea     ($0001).w            ; arg 3: 1
    pea     ($0007).w            ; arg 2: GameCommand #$7 (display buffer init / DMA setup)
    jsr     (a2)                 ; GameCommand #$7
    jsr PreLoopInit              ; initialize per-frame loop state before display loop
    ; a5 (LZ_Decompress wrapper) called with all-zero args to reset decompress state
    clr.l   -(a7)                ; arg 4: 0
    clr.l   -(a7)                ; arg 3: 0
    clr.l   -(a7)                ; arg 2: 0
    clr.l   -(a7)                ; arg 1: 0
    jsr     (a5)                 ; LZ_Decompress reset / null call (all args zero)
    lea     $24(a7), a7          ; clean 5 args (but $24=36, actually 9 words -- accounts for PreLoopInit push too)
    ; Second decompressor call to advance state (src=0, dst=0, mode=1)
    clr.l   -(a7)                ; arg 3: 0
    clr.l   -(a7)                ; arg 2: 0
    clr.l   -(a7)                ; arg 1: 0
    pea     ($0001).w            ; arg 0: mode 1
    jsr     (a5)                 ; LZ_Decompress: prime state
    ; --- Phase: Place cursor tile for station icon ---
    ; tile attr $0866: Priority=0, Palette=0, HFlip=0, VFlip=0, Char#=$066 (station icon tile)
    move.w  #$866, -$2(a6)       ; -$2(a6) = tile_attr = $0866 (station cursor tile attribute)
    pea     ($0001).w            ; arg 3: DisplaySetup mode 1
    clr.l   -(a7)                ; arg 2: 0 (position TBD by caller context)
    pea     -$2(a6)              ; arg 1: &tile_attr (-$2(a6))
    jsr     (a4)                 ; DisplaySetup: place station icon tile on screen
    ; DisplaySetup: set text window bounds ($10 wide x $10 tall) with layout data from ROM $4A0EE
    pea     ($0010).w            ; arg 3: height = $10 (16 tiles)
    pea     ($0010).w            ; arg 2: width = $10 (16 tiles)
    pea     ($0004A0EE).l        ; arg 1: ROM layout descriptor pointer for station tile window
    jsr     (a4)                 ; DisplaySetup: configure text window for station panel
    ; --- Phase: Decompress and DMA-load station background tileset ---
    ; LZ_Decompress: ROM source $4A25E -> decompressed to VRAM staging buffer $FF1804
    pea     ($0004A25E).l        ; arg 2: ROM LZ-compressed station background tileset
    move.l  a3, -(a7)            ; arg 1: destination = $FF1804 (staging buffer)
    jsr LZ_Decompress            ; decompress station background into staging buffer
    lea     $30(a7), a7          ; clean combined stack from the block above
    ; VRAMBulkLoad: transfer staging buffer -> VRAM at char $25, count $3E words
    clr.l   -(a7)                ; arg 5: 0
    clr.l   -(a7)                ; arg 4: 0
    move.l  a3, -(a7)            ; arg 3: source = $FF1804 (decompressed data)
    pea     ($003E).w            ; arg 2: word count = $3E (62 words = 124 bytes)
    pea     ($0025).w            ; arg 1: VRAM char# destination = $25 (tile 37)
    jsr VRAMBulkLoad             ; DMA tile data to VRAM
    ; GameCommand #$1B: render background tiles from ROM layout $4A10E at position ($E,$C) with $3 rows and $C cols
    pea     ($0004A10E).l        ; tile layout data ptr
    pea     ($000C).w            ; width = $C (12 tiles)
    pea     ($000E).w            ; height = $E (14 tiles)
    pea     ($0003).w            ; palette = 3
    clr.l   -(a7)                ; arg: 0
    clr.l   -(a7)                ; arg: 0
    pea     ($001B).w            ; GameCommand #$1B = render tile strip to screen
    jsr     (a2)                 ; GameCommand #$1B
    lea     $30(a7), a7
    ; --- Phase: Decompress and DMA-load station portrait tileset ---
    ; ROM $49F78 = LZ-compressed char/station portrait tile data
    pea     ($00049F78).l        ; ROM source: LZ-compressed portrait tiles
    move.l  a3, -(a7)            ; destination: $FF1804 staging buffer
    jsr LZ_Decompress
    ; VRAMBulkLoad: portrait tiles to VRAM char $1, count $24, mode $1
    pea     ($0001).w            ; arg 5: mode 1
    clr.l   -(a7)                ; arg 4: 0
    move.l  a3, -(a7)            ; arg 3: source = $FF1804
    pea     ($0024).w            ; arg 2: count = $24 (36)
    pea     ($0001).w            ; arg 1: VRAM char# = $1 (tile 1, immediately after tile 0)
    jsr VRAMBulkLoad
    lea     $1c(a7), a7          ; clean 7 args
    ; GameCommand #$1B: draw portrait panel outline from ROM $49DC8 at position ($1,$E) with $3 rows
    pea     ($00049DC8).l        ; ROM layout data for portrait panel border
    pea     ($000C).w            ; width = $C
    pea     ($0012).w            ; height = $12 (18)
    pea     ($0003).w            ; palette = 3
    pea     ($000E).w            ; X position = $E (14)
    pea     ($0001).w            ; Y position = $1 (1)
    pea     ($001B).w            ; GameCommand #$1B
    jsr     (a2)                 ; GameCommand #$1B: draw portrait border
    lea     $1c(a7), a7          ; clean 7 args
    ; --- Phase: Show character portrait ---
    ; d4 = $12 = portrait column (18), d3 = $7 = portrait row (7)
    ; ShowCharPortrait args: city_index(d6), portrait_y(d4=$12), portrait_x(d3=$7), mode=1, 0, player_index(d2)
    moveq   #$12,d4              ; d4 = $12 = portrait display column (screen tile column 18)
    moveq   #$7,d3               ; d3 = $7 = portrait display row (screen tile row 7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 6: player_index (d2)
    clr.l   -(a7)                ; arg 5: 0
    pea     ($0001).w            ; arg 4: mode 1 (full portrait render)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 3: portrait row = d3 ($7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 2: portrait col = d4 ($12)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 1: city_index (d6)
    jsr ShowCharPortrait         ; render character/station portrait tiles to screen
    ; --- Phase: Decompress and DMA-load facility icon tileset ---
    ; ROM $4A514 = LZ-compressed facility icon tiles (airport, hotel, etc.)
    pea     ($0004A514).l        ; ROM source: LZ-compressed facility icons
    move.l  a3, -(a7)            ; destination: $FF1804 staging buffer
    jsr LZ_Decompress
    lea     $20(a7), a7          ; clean ShowCharPortrait (6 args) + LZ (2 args) = 8 args = $20
    ; VRAMBulkLoad: facility icon tiles to VRAM char $63, count $8, mode $1
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a3, -(a7)            ; source: $FF1804
    pea     ($0008).w            ; count = $8 (8 tiles)
    pea     ($0063).w            ; VRAM char# = $63 (tile 99 = facility icon area)
    jsr VRAMBulkLoad
    ; GameCommand #$1B: draw facility icon panel from ROM $4A504 at computed position
    ; Position: col = d4-3 = $12-3 = $F, row = d3+3 = $7+3 = $A
    pea     ($0004A504).l        ; ROM layout data for facility icon strip
    pea     ($0002).w            ; width/cols = 2
    pea     ($0004).w            ; height/rows = 4
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0              ; d0 = d3 + 3 = $A (row = portrait_row + 3)
    move.l  d0, -(a7)            ; arg: row = $A
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0              ; d0 = d4 - 3 = $F (col = portrait_col - 3)
    move.l  d0, -(a7)            ; arg: col = $F
    pea     ($0001).w            ; mode 1
    pea     ($001B).w            ; GameCommand #$1B
    jsr     (a2)                 ; GameCommand #$1B: draw facility icon
    lea     $30(a7), a7          ; clean 8 args (VRAMBulkLoad 5 + GameCmd 8 - shared cleanup)
    ; --- Phase: Unload resources and build ownership dialog string ---
    jsr ResourceUnload           ; release previously loaded graphics resource
    ; Select ownership string: d5==1 -> owned by this player ($4277E), else unowned ($42776)
    cmpi.w  #$1, d5              ; ownership_flag == 1?
    bne.b   l_2bbd0              ; no: push "unowned" string
    pea     ($0004277E).l        ; ROM string: facility owned by current player
    bra.b   l_2bbd6
l_2bbd0:
    pea     ($00042776).l        ; ROM string: facility not owned by current player
l_2bbd6:
    ; Look up owner name from char name table:
    ; $FF1278 = city_owner_tab (byte per city = owner player index)
    ; $5ECFC = ROM player name pointer table (indexed by owner * 4)
    movea.l  #$00FF1278,a0       ; a0 = city_owner_tab ($FF1278): byte[city_index] = owner player index
    move.b  (a0,d6.w), d0        ; d0 = owner player index for this city
    andi.l  #$ff, d0             ; zero-extend byte
    lsl.w   #$2, d0              ; d0 *= 4 (long pointer table index)
    movea.l  #$0005ECFC,a0       ; a0 = ROM player name pointer table ($5ECFC)
    move.l  (a0,d0.w), -(a7)     ; push owner's name string ptr as sprintf arg
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)            ; push ownership_flag as sprintf arg (e.g. for "Owned by %s" / "Open")
    pea     ($00042784).l        ; ROM format string for facility ownership line (e.g. "%s\n%s")
    pea     -$82(a6)             ; destination = local sprintf buffer (-$82(a6))
    jsr sprintf                  ; format ownership/name string into buffer
    ; ShowDialog: display station name + ownership text
    clr.l   -(a7)                ; arg 5: 0
    clr.l   -(a7)                ; arg 4: 0
    pea     ($0001).w            ; arg 3: mode 1
    pea     -$82(a6)             ; arg 2: formatted string
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 1: player_index
    jsr ShowDialog               ; display the station name/ownership dialog
    lea     $28(a7), a7          ; clean sprintf (4) + ShowDialog (5) = 9 args = $24... (combined)
    ; --- Phase: Conditional tile animation (only if flight_active ($FF000A) == 1) ---
    ; If $FF000A == 1, run a 152-frame ($98) animation loop cycling two facility tile variants
    cmpi.w  #$1, ($00FF000A).l   ; $FF000A = flight_active: nonzero = flight in progress
    bne.w   l_2bcca              ; no active flight: skip animation, go to input poll
    clr.l   -(a7)                ; arg: 0
    jsr LoadDisplaySet           ; load additional display resources for the animation
    addq.l  #$4, a7
    clr.w   d2                   ; d2 = animation frame counter = 0
    ; =========================================================
    ; Tile animation loop: 152 frames ($98), cycling between two tile variants every other frame
    ; =========================================================
l_2bc3c:
    ; Call a5 (LZ_Decompress wrapper) to advance animated tile state each frame
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 4: current frame index
    pea     ($0007).w            ; arg 3: mode 7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 2: d3 = portrait row ($7)
    pea     ($0001).w            ; arg 1: 1
    jsr     (a5)                 ; advance animated tile decompress state for this frame
    ; Toggle tile attribute each frame: even frames = $0468, odd frames = $02CC
    ; $0468: char#=$68, palette=0 (facility tile variant A)
    ; $02CC: char#=$CC, palette=0 + bit set (facility tile variant B)
    move.w  d2, d0
    andi.w  #$1, d0              ; odd frame?
    beq.b   l_2bc62              ; no (even): use tile variant A
    move.w  #$2cc, -$2(a6)       ; odd frame: tile_attr = $02CC (facility animation tile B)
    bra.b   l_2bc68
l_2bc62:
    move.w  #$468, -$2(a6)       ; even frame: tile_attr = $0468 (facility animation tile A)
l_2bc68:
    ; Place animated tile using DisplaySetup at col $1C, mode 1
    pea     ($0001).w            ; arg 3: DisplaySetup mode 1
    pea     ($001C).w            ; arg 2: column = $1C (28)
    pea     -$2(a6)              ; arg 1: &tile_attr (current animation tile)
    jsr     (a4)                 ; DisplaySetup: update animation tile on screen
    lea     $1c(a7), a7          ; clean 4 (a5 call) + 3 (DisplaySetup) = 7 args = $1C
    ; --- At frame $4C (76): redraw portrait panel overlay (mid-animation refresh) ---
    cmpi.w  #$4c, d2             ; is this frame $4C?
    bne.b   l_2bca8              ; no: skip overlay redraw
    ; Redraw portrait panel border at same position as initial render
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0              ; row = d3 + 3 (same as initial portrait panel)
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$3, d0              ; col = d4 - 3
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w            ; GameCommand #$1A = ClearTileArea (clear portrait overlay)
    jsr     (a2)                 ; GameCommand #$1A
    lea     $1c(a7), a7
l_2bca8:
    addq.w  #$1, d2              ; advance frame counter
    cmpi.w  #$98, d2             ; reached $98 (152) frames?
    blt.b   l_2bc3c              ; no: continue animation loop
    ; --- Post-animation: page flip and display sync ---
    pea     ($0018).w
    jsr     (a2)                 ; GameCommand #$18 = display page flip
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)                 ; GameCommand #$E: display sync
    pea     ($0018).w
    jsr     (a2)                 ; GameCommand #$18: second page flip (double-buffer complete)
    lea     $10(a7), a7          ; clean 3 calls * 1-2 args each
l_2bcca:
    ; --- Phase: Wait for player input then restore screen ---
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction               ; $01D62C: flush-then-wait input poll (waits for button press)
    ; Reload resources and restore world-map display context
    jsr ResourceLoad             ; reload resources that were unloaded during station display
    ; DisplaySetup: restore layout data from ROM $7651E (world map layout)
    pea     ($0010).w            ; arg 3: $10
    clr.l   -(a7)                ; arg 2: 0
    pea     ($0007651E).l        ; arg 1: ROM world-map layout descriptor pointer
    jsr     (a4)                 ; DisplaySetup: restore world-map tile window configuration
    ; Restore decompressor state: call a5 with mode 7, d3 portrait row, 0, 0
    clr.l   -(a7)                ; arg 4: 0
    pea     ($0007).w            ; arg 3: mode 7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; arg 2: d3 = portrait row ($7)
    pea     ($0001).w            ; arg 1: 1
    jsr     (a5)                 ; restore LZ decompressor state
    jsr ClearBothPlanes          ; $00814A: clear both scroll planes to blank screen for return
    movem.l -$a8(a6), d2-d6/a2-a5
    unlk    a6
    rts
