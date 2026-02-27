; ============================================================================
; ExecMenuCommand -- Executes a menu command for a selected city: initialises the route-map display, polls directional and button input in a loop, dispatches to CharacterBrowser (B), UpdateCharRelation (A on same city), or DrawStatDisplay/DisplayMenuOption (cursor), and returns the selected city index or an exit code.
; 1730 bytes | $01BBCC-$01C28D
;
; Args (via link frame, a6):
;   $8(a6)  = player_index  (d6) -- current player (0-3)
;   $c(a6)  = region_id     (d5) -- target region / city category
;   $e(a6)  -- additional parameter (not used directly here)
;
; Register map (after prologue):
;   a5 = $000D64  GameCommand dispatcher
;   a2 = $FFBD64  charlist_ptr -- scroll/cursor state for character browser
;   a3 = player record ($FF0018 + player*$24)
;   d5 = region_id (arg $c)
;   d6 = player_index (arg $8)
;   d2 = current hit-test city index ($FF = none under cursor)
;   d3 = previously selected city index ($FF = no selection)
;   d7 = previous hit-test city index (tracks last hover position)
;   d4 = raw PollAction button word
;
; Returns (d0): selected city index, or exit code set by exit path
; ============================================================================
ExecMenuCommand:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)

; --- Phase: Prologue -- resolve player record and check hub-city region ---
    move.l  $c(a6), d5          ; d5 = region_id (map region to filter cities)
    move.l  $8(a6), d6          ; d6 = player_index
    movea.l  #$00000D64,a5      ; a5 = GameCommand dispatcher ($000D64)
    move.w  d6, d0
    mulu.w  #$24, d0            ; player_index * $24 (player record stride = 36 bytes)
    movea.l  #$00FF0018,a0      ; player_records base ($FF0018)
    lea     (a0,d0.w), a0       ; -> player record for active player
    movea.l a0, a3              ; a3 = player record ptr
    movea.l  #$00FFBD64,a2      ; a2 = charlist_ptr ($FFBD64) -- scroll state for char browser

    ; Check if the player's hub city belongs to the requested region.
    ; RangeLookup(hub_city) -> region category. If it matches d5, pre-load
    ; the portrait scroll position from CharPortraitPos table ($05E9FA) so
    ; the initial map view is centred on the hub city.
    moveq   #$0,d0
    move.b  $1(a3), d0          ; player_record[+$01] = hub_city index
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup             ; -> d0 = region category for hub_city
    cmp.w   d5, d0              ; does hub city match requested region?
    bne.b   l_1bc44             ; no -> skip portrait-position init
    ; Hub city IS in the target region: load its portrait screen (x,y) from
    ; CharPortraitPos ($05E9FA) -- word[0]=x at $5E9FA + hub*4,
    ; word[1]=y at $5E9FB + hub*4 (byte-offset access into word table).
    moveq   #$0,d0
    move.b  $1(a3), d0          ; hub_city index again
    add.w   d0, d0              ; *2 -> word-stride into table
    movea.l  #$0005E9FA,a0      ; CharPortraitPos x-column ($05E9FA)
    move.b  (a0,d0.w), d0       ; load x scroll byte
    andi.l  #$ff, d0
    move.w  d0, (a2)            ; charlist_ptr[+$00] = x scroll position
    moveq   #$0,d0
    move.b  $1(a3), d0          ; hub_city index
    add.w   d0, d0
    movea.l  #$0005E9FB,a0      ; CharPortraitPos y-column ($05E9FB = x+1, interleaved)
    move.b  (a0,d0.w), d0       ; load y scroll byte
    andi.l  #$ff, d0
    move.w  d0, $2(a2)          ; charlist_ptr[+$02] = y scroll position

; --- Phase: Display init -- clear state and draw route-map tile background ---
l_1bc44:
    move.w  #$ff, d3            ; d3 = $FF -- no city selected yet
    move.w  #$ff, d0
    move.w  d0, d7              ; d7 = $FF -- previous hover city (none)
    move.w  d0, -$2(a6)        ; frame var -$2 = $FF -- last hit-test result (none)

    ; GameCmd16(4, $3B): set up display window / scroll mode for map view
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16

    ; GameCommand($1A, 0, $14, $20, $0A, 0): draw background for map area
    ; GameCommand $1A = draw tile block / fill rect
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $28(a7), a7

    ; GameCommand($1A, 1, 0, $20, $13, 0, $077F): draw top-of-screen tile row
    ; tile ID $077F = horizontal rule / header bar graphic
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7

    ; GameCommand($1A, 1, 0, $20, $14, 8, $077D): draw bottom-of-screen tile row
    ; tile ID $077D = footer bar graphic
    pea     ($077D).w
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7

    ; TilePlacement($0740, 0, x, y, 2, 2, $8000): place route-map tile at
    ; the hub city scroll position. Tile $0740 = world-map icon.
    ; x = charlist_ptr[+$00], y = charlist_ptr[+$02]
    move.l  #$8000, -(a7)       ; flags: $8000 = display immediately
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0          ; y = charlist_ptr[+$02]
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0            ; x = charlist_ptr[+$00]
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w            ; tile ID $0740 = world-map / city-dot icon
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand($0E, 1): commit/flush tile update
    lea     $24(a7), a7

    ; GameCommand($1A, 1, 2, $1C, $13, 6, $077E): draw character-list panel border
    ; tile ID $077E = side border graphic
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7

    ; GameCommand($1B, 0, $12, $1E, 9, 1, $4DD9C): load character-list resource
    ; ROM data at $04DD9C (char list graphics/data block)
    pea     ($0004DD9C).l        ; ROM data block for character list display
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)

    ; LZ_Decompress($4DFB8 -> $FF1804): decompress world-map tile graphics
    ; $04DFB8 = LZ-compressed world-map tileset; $FF1804 = save_buf_base (temp buffer)
    pea     ($0004DFB8).l        ; LZ-compressed world-map tileset in ROM
    pea     ($00FF1804).l        ; decompress into save_buf_base ($FF1804)
    jsr LZ_Decompress
    lea     $24(a7), a7

    ; VRAMBulkLoad($02E1, $0F, $FF1804, 0, 0): DMA the decompressed world-map
    ; tiles to VRAM at tile index $02E1, count=$0F tiles
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l        ; source: decompressed tile data in work RAM
    pea     ($000F).w            ; tile count = 15 tiles
    pea     ($02E1).w            ; VRAM tile destination index $02E1
    jsr VRAMBulkLoad
    lea     $14(a7), a7

; --- Phase: Wait-for-idle loop -- drain any residual button presses before main input loop ---
l_1bd64:
    ; Spin until PollAction(3) returns no direction or fire bits ($C0 mask).
    ; Bits $40 and $80 are the two action buttons (A and B); wait for both released.
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$c0, d0            ; test button bits: $40=B, $80=A
    bne.b   l_1bd64             ; still held -- keep spinning
    movea.l  #$0004DFB8,a3     ; a3 = ptr to world-map tileset (for ResourceUnload)
    movea.l  #$0004DD9C,a4     ; a4 = ptr to char-list data block (for ResourceUnload)

; --- Phase: Main dispatch loop -- hover city tracking + input processing ---
l_1bd84:
    ; Each pass through this loop:
    ;   1. Unload any previously loaded resource
    ;   2. Hit-test current scroll position -> d2 = city index under cursor
    ;   3. On cursor move: redraw stat display and compatibility score
    ;   4. Redraw city-dot tile at new position
    ;   5. Poll input; dispatch on direction (scroll) or button (action)
    jsr ResourceUnload           ; release any resource loaded in previous pass

    ; HitTestMapTile(scroll_state, region_id) -> d0 = city index under cursor,
    ; or $FF if scroll position does not land on any city in region d5.
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: region_id
    move.l  a2, -(a7)           ; arg: charlist_ptr (current scroll x/y)
    jsr HitTestMapTile
    addq.l  #$8, a7
    move.w  d0, d2              ; d2 = hit city index ($FF = no city at cursor)

    ; Skip repaint if the cursor is still over the same city as last frame.
    cmp.w   -$2(a6), d2         ; same as last hit-test result?
    beq.b   l_1bdfe             ; yes -> skip to button-scroll block

    ; Cursor moved onto a new tile. If no city was previously selected (d3=$FF)
    ; and cursor is over a real city (d2 != $FF), draw its stat bar.
    cmpi.w  #$ff, d3            ; is a city already selected?
    bne.b   l_1bdfa             ; yes -> skip first-hover paint
    cmpi.w  #$ff, d2            ; cursor over a real city?
    beq.b   l_1bdce             ; no -> erase stat area and proceed

    ; First hover over a city with no prior selection: draw stat display for
    ; the hovered city (d2) in the stat panel.
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; city index = d2
    jsr DrawStatDisplay          ; draw stat bar for hovered city
    lea     $14(a7), a7
    bra.b   l_1bdfa

l_1bdce:
    ; Cursor moved off all cities: clear the stat panel and redraw blank border.
    ; GameCommand($1A, 0, 4, $D, $13, 2): clear stat display area
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    ; GameCmd16(2, $37): commit cleared stat area
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    lea     $24(a7), a7

l_1bdfa:
    move.w  d2, -$2(a6)        ; update frame var: last hit-test result

; Redraw city selection UI if hover city (d2) differs from previously rendered city (d7).
l_1bdfe:
    cmp.w   d2, d7              ; did hover city change since last full repaint?
    beq.w   l_1beba             ; no -> skip repaint, go to tile update
    cmpi.w  #$ff, d3
    beq.w   l_1beb8             ; no selection yet -> skip compat score, just track hover
    cmpi.w  #$ff, d2
    beq.b   l_1be66             ; cursor left all cities -> erase compat display

    ; Cursor moved over a new city AND a city (d3) is already selected.
    ; Show stat bar for new hover city and compute compatibility score
    ; between selected city (d3) and hovered city (d2) for this player (d6).
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; city index = d2 (hover)
    jsr DrawStatDisplay          ; draw stat bar for hovered city
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: hover city (d2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: selected city (d3)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: player_index (d6)
    jsr (ShowCompatibilityScore,PC)  ; show how well the two cities pair
    nop
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: selected city (d3) -- redraw its menu option
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: player_index
    bsr.w DisplayMenuOption      ; redraw selected-city menu option row
    lea     $30(a7), a7
    bra.b   l_1beb8

l_1be66:
    ; Cursor left all cities while a selection (d3) existed: erase compat panel
    ; and redraw empty selection box.
    ; GameCommand($1A, 0, $E, $10, $13, 2): clear compat score area
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    ; GameCommand($1A, 0, $D, $11, $15, 4): clear city-name text line
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0011).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    ; GameCmd16(2, $39): commit cleared city-name area
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7

l_1beb8:
    move.w  d2, d7              ; d7 = current hover city (track for next frame)

; --- Phase: Tile placement -- redraw world-map city dot at current scroll position ---
l_1beba:
    ; Place city-dot tile ($0740) at the scroll position in charlist_ptr.
    ; This redraws the position indicator each frame even if the city didn't change.
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0          ; y = charlist_ptr[+$02]
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0            ; x = charlist_ptr[+$00]
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w            ; tile ID $0740 = world-map city dot
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand($0E, 1): commit tile
    lea     $24(a7), a7

; --- Phase: Input poll -- wait for any button or direction input ---
l_1bef0:
    ; Spin until PollAction(3) returns a nonzero byte (any button or dpad).
    ; Low byte = direction bits; high byte = button bits.
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4              ; d4 = full button word (save for dispatch)
    andi.l  #$ff, d0            ; test low byte = any input at all?
    beq.b   l_1bef0             ; nothing yet -- keep waiting

; --- Phase: Input dispatch -- route on direction vs button bits ---

    ; Test direction bits (low nibble $F = dpad: up/down/left/right).
    move.w  d4, d0
    andi.w  #$f, d0             ; isolate direction bits
    beq.b   l_1bf48             ; no direction -> go to button dispatch

    ; D-pad pressed: scroll the map. Call AdjustScrollPos twice (interlaced
    ; display update) then loop back to redraw.
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: direction word
    move.l  a2, -(a7)           ; arg: charlist_ptr (scroll state)
    jsr AdjustScrollPos          ; update scroll position
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand($0E, 1): flush first half
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos          ; second scroll update (interlaced)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)                 ; GameCommand($0E, 1): flush second half
    lea     $20(a7), a7
    bra.w   l_1bd84              ; back to hit-test loop

; --- Phase: Button A ($40) -- open CharacterBrowser for this region ---
l_1bf48:
    move.w  d4, d0
    andi.w  #$40, d0            ; bit 6 = button A
    beq.b   l_1bf80             ; not A -> try button B

    ; A pressed with no prior selection: clear any pending DisplayMenuOption
    ; then fall through to exit path (return region without character chosen).
    cmpi.w  #$ff, d3
    beq.b   l_1bf72             ; no selected city -> skip menu deselect
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; selected city d3
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    bsr.w DisplayMenuOption      ; deselect the previously selected menu row
    lea     $10(a7), a7

l_1bf72:
    ; Return path: exit with exit code $17 (cancel / A-without-city).
    ; Falls into exit epilogue at l_1c26c.
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0017).w            ; exit code $17 = cancelled from map (A button)
    bra.w   l_1c26c

; --- Phase: Button B ($80) -- open CharacterBrowser ---
l_1bf80:
    move.w  d4, d0
    andi.w  #$80, d0            ; bit 7 = button B
    beq.w   l_1c05a             ; not B -> try Start ($20)

    ; B pressed: push character browser overlay for this player+region.
    ; First shrink the map panel to make room.
    ; GameCommand($1A, 0, 1, $15, 8, 6): clear area for char browser window
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    ; Open the character browser modal (full-screen list of chars in region d5).
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; arg: player_index
    jsr CharacterBrowser         ; -> d0 = selected char index, or $FF on cancel
    lea     $24(a7), a7
    move.w  d0, d2              ; d2 = browser result (city/char selection)

    ; Restore map display after browser closes.
    ; GameCommand($1A, 1, 2, $1C, $13, 6, $077E): redraw char-list panel border
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7

    ; Reload char-list data block ($04DD9C) and re-decompress world-map tiles.
    ; This restores the display state that the character browser may have destroyed.
    move.l  a4, -(a7)           ; a4 = $04DD9C char-list data block
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)           ; a3 = $04DFB8 world-map tileset
    pea     ($00FF1804).l        ; decompress into save_buf_base
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad             ; DMA restored tiles to VRAM
    lea     $14(a7), a7

    ; If browser returned a valid city (d2 != $FF) and a selection exists (d3 != $FF),
    ; update d5 (region_id) to the browser result and redraw the stat panel.
    cmpi.w  #$ff, d2
    beq.b   l_1c052             ; browser cancelled -> just force hover redraw
    move.w  d2, d5              ; update region_id to browser result
    cmpi.w  #$ff, d3
    beq.b   l_1c052             ; no prior selection -> skip stat redraw
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; draw stat bar for previously selected city (d3)
    jsr DrawStatDisplay
    lea     $14(a7), a7

l_1c052:
    ; Force redraw on next pass by invalidating previous hover tracker.
    move.w  #$ff, d7            ; d7=$FF -> triggers full repaint at l_1bdfe
    bra.w   l_1bd84

; --- Phase: Button Start ($20) -- confirm city selection or first-select ---
l_1c05a:
    move.w  d4, d0
    andi.w  #$20, d0            ; bit 5 = Start button
    beq.w   l_1c1ae             ; not Start -> try C ($10)

    cmpi.w  #$ff, d2
    beq.w   l_1bd84             ; cursor not over any city -> ignore Start

    cmpi.w  #$ff, d3
    bne.b   l_1c0c2             ; city already selected -> confirm/relate path

    ; --- Sub-phase: First city selection (d3 was $FF) ---
    ; Place cursor on the newly selected city and show its menu option row.
    pea     ($0001).w
    move.w  $2(a2), d0          ; y scroll
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0            ; x scroll
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor              ; position on-screen cursor at scroll (x,y)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; city index (d2)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    bsr.w DisplayMenuOption      ; highlight selected city's menu row
    lea     $1c(a7), a7
    move.w  d2, d3              ; d3 = newly selected city (first pick)

    ; Wait for Start to be released before resuming main loop to avoid re-triggering.
l_1c0aa:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$20, d0            ; Start still held?
    bne.b   l_1c0aa             ; yes -> keep waiting
    bra.w   l_1bd84

l_1c0c2:
    ; --- Sub-phase: Second selection -- confirm route (same city) or relate cities ---
    ; Start pressed again with d3 already set.
    ; If d2 == d3 (player selected the same city twice), call UpdateCharRelation
    ; to modify the relation between the player and the city (e.g., open a route).
    cmp.w   d2, d3              ; same city selected again?
    bne.w   l_1bd84             ; different city -> ignore (require same-city confirm)

    ; Same city confirmed: place cursor and invoke UpdateCharRelation.
    clr.l   -(a7)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)           ; y scroll
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)           ; x scroll
    jsr PlaceCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; confirmed city (d2 == d3)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    jsr (UpdateCharRelation,PC)  ; update relationship / open route for selected city
    nop
    ; Redraw map mode after relation update.
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16               ; GameCmd16(4,$3B): restore map display mode
    lea     $20(a7), a7

    ; Restore char-list data and world-map tiles as after CharacterBrowser.
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a4, -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    ; Redraw stat bar for the confirmed city.
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $28(a7), a7
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption      ; redraw selected city's menu option row
    lea     $10(a7), a7
    bra.w   l_1c052             ; force repaint and continue

; --- Phase: Button C ($10) -- deselect / cancel current selection ---
l_1c1ae:
    move.w  d4, d0
    andi.w  #$10, d0            ; bit 4 = button C
    beq.w   l_1bd84             ; not C -> no recognized button, loop back

    cmpi.w  #$ff, d3
    beq.w   l_1c262             ; no selection to cancel -> exit with code $19

    ; C pressed with a selection: deselect (clear stat panel and menu row).
    ; GameCmd16(2, $39): clear old stat area before redraw
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)           ; previously selected city (d3)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)           ; region_id
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    bsr.w DisplayMenuOption      ; unhighlight / clear the deselected menu row
    lea     $18(a7), a7

    cmp.w   d3, d2              ; was cursor on the city being deselected?
    bne.b   l_1c212             ; no -> redraw blank state for a different city

    ; Cursor IS on the city being deselected. Erase it with an inline panel.
    ; GameCommand($1A, 0, $13, $B, $13, 6): draw blank-city overlay
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($000B).w
    pea     ($0013).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d7            ; force full repaint
    bra.b   l_1c246

l_1c212:
    ; Cursor on a different city: draw blank selection box and char-list panel.
    ; GameCmd16(2, $37): clear stat area
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    ; GameCommand($1A, 0, 2, $1C, $13, 6): redraw char-list border panel
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    move.w  #$ff, d7            ; force full repaint
    move.w  d7, -$2(a6)        ; clear last hit-test result too

l_1c246:
    move.w  #$ff, d3            ; d3 = $FF -> no city selected any more

    ; Wait for C button to be released before continuing.
l_1c24a:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$10, d0            ; C still held?
    bne.b   l_1c24a
    bra.w   l_1bd84

; --- Phase: Exit paths ---

l_1c262:
    ; C pressed with no selection (d3=$FF): exit with code $19 (cancel / empty).
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0019).w            ; exit code $19 = cancelled with no city selected

l_1c26c:
    ; Common exit epilogue. Stack holds (exit_code_word, exit_code_word, ?, ?).
    ; GameCommand($1A, 0, 4, $13): draw exit/clear overlay then clean up sprites.
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    jsr ClearCharSprites         ; remove any character portrait sprites from OAM
    move.w  d5, d0              ; return value = region_id / selected city in d5
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

PrepareRelationPush:                                         ; $01C28E
    dc.w    $2F02                                            ; move.w d1,-(sp) [thunk before callee]

; === Translated block $01C290-$01C43C ===
; 2 functions, 428 bytes
