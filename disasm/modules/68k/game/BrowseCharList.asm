; ============================================================================
; BrowseCharList -- Scrollable character list loop with up/down navigation, stat preview on hover, and confirm or cancel
; Called: ?? times.
; 744 bytes | $008E0C-$0090F3
; ============================================================================
; Arguments: $C(a6) = list_config_ptr (a3): pointer to list state word (current selection)
;            $A(a6) = player_index word: used as CharacterBrowser arg when B is pressed
; A4 = GameCommand ($0D64)
; A5 = $FF13FC (input_mode_flag)
; A2 = $FFBD64 (charlist_ptr): cursor scroll state -- word[0] = current index, word[1] = scroll base
; d2 = two_player_mode flag (1 = P2 present)
; d3 = hit_index: result of last HitTestMapTile (tile under cursor, or $FF)
; d4 = prev_hit_index: previously highlighted tile (tracks hover changes)
; d5 = accumulated input word
; d6 = CharacterBrowser result (selected char index from full browser)
; Returns: d0 = selected char index or $FF (cancel) or $20+ (special row)
BrowseCharList:                                                  ; $008E0C
    link    a6,#$0
    movem.l d2-d6/a2-a5,-(sp)
    movea.l $000c(a6),a3        ; a3 = list_config_ptr (word: current selection state)
    movea.l #$0d64,a4           ; a4 = GameCommand entry
    movea.l #$00ff13fc,a5       ; a5 = input_mode_flag ($FF13FC)
    move.w  #$ff,d4             ; d4 = prev_hit_index = $FF (no prior hover)
; $FFBD64 = charlist_ptr: two-word scroll state block:
;   [0] = current char index, [1] = scroll base row offset
    movea.l #$00ffbd64,a2       ; a2 -> charlist cursor/scroll state
; ReadInput mode 0: detect player 2 presence
    clr.l   -(sp)               ; mode = 0
    dc.w    $4eb9,$0001,$e1ec                           ; jsr ReadInput ($01E1EC)
    tst.w   d0
    beq.b   .l8e3e
    moveq   #$1,d2              ; d2 = 1: two-player mode
    bra.b   .l8e40
.l8e3e:                                                 ; $008E3E
    moveq   #$0,d2              ; d2 = 0: single-player mode
; --- Phase: Main list display loop ---
.l8e40:                                                 ; $008E40
    clr.w   d5                  ; d5 = input accumulator (cleared each iteration)
    clr.w   (a5)                ; input_mode_flag = 0: normal input mode
    clr.w   ($00FFA7D8).l       ; input_init_flag = 0: reset countdown state machine
; HitTestMapTile: test the current cursor position against the list's hit-test table
; ($5E9FA/$5ECBC range table). Returns tile index under cursor, or $FF if none.
    move.w  (a3),d0             ; list state word (current index used as test value)
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)            ; charlist_ptr (scroll state)
    bsr.w HitTestMapTile         ; test cursor position vs list hit-zones
    lea     $000c(sp),sp
    move.w  d0,d3               ; d3 = hit_index (tile under cursor, or $FF)
    cmpi.w  #$ff,d0             ; no item under cursor?
    beq.b   .l8e86              ; nothing hit: handle hover-clear
    cmp.w   d3,d4               ; same item as last frame?
    beq.b   .l8e82              ; same: skip redraw of stat panel
; New item hovered: show its stat display
; DrawStatDisplay: renders char stat row at (col=$13, row=$37) for item d3
    pea     ($0037).w           ; screen row = $37
    pea     ($0013).w           ; screen column = $13
    clr.l   -(sp)
    pea     ($0001).w           ; display mode = 1 (single stat row)
    move.w  d3,d0               ; item index to display
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w DrawStatDisplay        ; render stat preview for hovered list item
    lea     $0014(sp),sp
.l8e82:                                                 ; $008E82
    move.w  d3,d4               ; update prev_hit_index
    bra.b   .l8ebe              ; go to cursor tile placement
; Hover moved off a valid item: clear the stat preview panel
.l8e86:                                                 ; $008E86
    cmpi.w  #$ff,d4             ; was any item previously hovered?
    beq.b   .l8ebe              ; no prior hover: nothing to clear
; GameCommand #$1A: clear stat preview panel area
; (tile=$077E, col=$00, row=$13, w=$0D, h=$02, priority=0)
    pea     ($077E).w           ; clear tile ($077E = blank)
    pea     ($0002).w           ; height = 2
    pea     ($000D).w           ; width  = $0D = 13
    pea     ($0013).w           ; top row = $13 = 19
    pea     ($0004).w           ; left col = 4
    clr.l   -(sp)
    pea     ($001A).w           ; GameCommand #$1A = DrawBox/clear
    jsr     (a4)
; GameCmd16 #$37, mode 2: clear stat preview sprite layer
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr GameCmd16 ($01E0B8)
    lea     $0024(sp),sp
    move.w  #$ff,d4             ; clear prev_hit_index (no item highlighted now)
; --- Phase: Render cursor tile on list ---
; TilePlacement: place cursor tile $0740 at current scroll position
; A2[0] = current scroll index (word), A2[2] = y pixel base
.l8ebe:                                                 ; $008EBE
    move.l  #$8000,-(sp)        ; high-priority tile flag
    pea     ($0002).w           ; palette index 2
    pea     ($0002).w           ; height = 2 rows
    moveq   #$0,d0
    move.w  $0002(a2),d0        ; charlist_ptr[1] = y scroll pixel position
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  (a2),d0             ; charlist_ptr[0] = x / current index
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0740).w           ; tile $0740 = list cursor indicator tile
    dc.w    $4eb9,$0001,$e044                           ; jsr TilePlacement ($01E044)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)                 ; GameCommand #$E = display sync
    lea     $0024(sp),sp
; Check 2P input (if two-player mode): if P2 active, do display update and loop
    tst.w   d2                  ; two-player mode?
    beq.b   .l8f14              ; single-player: skip 2P check
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr ReadInput ($01E1EC)
    addq.l  #$4,sp
    tst.w   d0                  ; any 2P input?
    beq.b   .l8f14              ; no: proceed to main input polling
    pea     ($0003).w           ; GameCommand mode = 3 (display update with slight delay)
.l8f0a:                                                 ; $008F0A
    pea     ($000E).w           ; GameCommand #$E = display sync
    jsr     (a4)
    addq.l  #$8,sp
    bra.b   .l8ebe              ; loop back to cursor render
; --- Phase: Main input polling ---
.l8f14:                                                 ; $008F14
    clr.w   d2                  ; clear 2P flag for this iteration
    move.w  d5,d0               ; carry accumulated input
    move.l  d0,-(sp)
    pea     ($000A).w           ; timeout = $0A frames
    dc.w    $4eb9,$0001,$e290                           ; jsr ProcessInputLoop ($01E290)
    addq.l  #$8,sp
; Mask to relevant buttons: $BF = all bits except bit 6
    andi.w  #$bf,d0
    move.w  d0,d5               ; d5 = filtered input
; Check bit 5 = A button (confirm selection)
    andi.w  #$20,d0
    beq.b   .l8f60              ; not A: check other buttons
; --- A button: confirm current selection ---
    clr.w   (a5)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l
; PlaceCursor ($009CEC): place selection cursor at the current scroll position
    clr.l   -(sp)
    move.w  $0002(a2),d0        ; y pixel (charlist_ptr[1])
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a2),d0             ; x/index (charlist_ptr[0])
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0da0                                 ; jsr PlaceCursor ($009CEC)
    nop
    lea     $000c(sp),sp
    cmpi.w  #$ff,d3             ; no item highlighted? ($FF = cursor not on valid item)
    beq.w   .l8ebe              ; no selection: loop back
    bra.w   .l90e8              ; valid item selected: exit with d3
; --- B button (bit 4): cancel / return $FF ---
.l8f60:                                                 ; $008F60
    move.w  d5,d0
    andi.w  #$10,d0             ; bit 4 = B button (cancel)
    beq.b   .l8f78              ; not B: check Start/C
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  #$ff,d3             ; d3 = $FF: cancel (no item selected)
    bra.w   .l90e8              ; exit
; --- Start/C button (bit 7): open CharacterBrowser full-screen browser ---
.l8f78:                                                 ; $008F78
    move.w  d5,d0
    andi.w  #$80,d0             ; bit 7 = Start or C button
    beq.w   .l9052              ; not Start/C: check d-pad
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5,d0
    andi.w  #$80,d0             ; double-check Start/C bit (compiler redundancy)
    beq.w   .l901a              ; no longer set (safety guard)
; Invoke CharacterBrowser: full-screen char selection with portrait + detail panels
; Args: player_index (from $A(a6)), current list index (from list_config_ptr word)
    move.w  (a3),d0             ; current list state word (char index context)
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0        ; player_index from caller's frame arg
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w CharacterBrowser       ; full-screen char browser; returns selected char index in d0
    move.w  d0,d6               ; d6 = CharacterBrowser result char index (or $FF)
; Redraw the main list view after CharacterBrowser returns
; GameCommand #$1A: restore list dialog box (tile=$077E, col=$01, row=$13, w=$1C, h=$06, pri=1)
    pea     ($077E).w
    pea     ($0006).w           ; height = 6
    pea     ($001C).w           ; width  = $1C = 28
    pea     ($0013).w           ; top row = $13 = 19
    pea     ($0002).w           ; left col = 2
    pea     ($0001).w           ; priority = 1
    pea     ($001A).w
    jsr     (a4)
    lea     $0024(sp),sp
; GameCommand #$1B: stamp list tile block from ROM $4DD9C
; (col=$01, row=$12, w=$1E, h=$09, plane=$00) = character list rows
    pea     ($0004DD9C).l       ; ROM tile data block: character list row tiles
    pea     ($0009).w           ; height = 9
    pea     ($001E).w           ; width  = $1E = 30
    pea     ($0012).w           ; top row = $12 = 18
    pea     ($0001).w           ; left col = 1
    clr.l   -(sp)
    pea     ($001B).w           ; GameCommand #$1B = place tile block
    jsr     (a4)
; Decompress the list portrait tiles from ROM $4DFB8 to save_buf_base ($FF1804)
    pea     ($0004DFB8).l       ; LZ-compressed list portrait tiles (ROM address)
    pea     ($00FF1804).l       ; output = save_buf_base
    dc.w    $4eb9,$0000,$3fec                           ; jsr LZ_Decompress ($003FEC)
    lea     $0024(sp),sp
; VRAMBulkLoad: DMA $0F tiles from $FF1804 to VRAM at index $02E1 (list portrait area)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($000F).w           ; tile count = $0F = 15
    pea     ($02E1).w           ; VRAM tile destination index
    dc.w    $4eb9,$0001,$d568                           ; jsr VRAMBulkLoad ($01D568)
    lea     $0014(sp),sp
; CharacterBrowser result handling
.l901a:                                                 ; $00901A
    cmpi.w  #$ff,d6             ; did CharacterBrowser return $FF (no selection / cancel)?
    beq.b   .l904a              ; yes: skip updating list state
    cmp.w   (a3),d6             ; same char as already selected in list?
    beq.b   .l904a              ; same: no update needed
; Update the list selection to the char chosen in CharacterBrowser
    move.w  d6,(a3)             ; list_config_ptr word = CharacterBrowser result
; Re-stamp the list overlay tiles (same pattern as DrawBox below)
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $001c(sp),sp
    move.w  #$ff,d3             ; reset hover index (new item displayed)
.l904a:                                                 ; $00904A
    pea     ($0002).w           ; GameCommand mode delay
    bra.w   .l8f0a              ; GameCommand #$E and loop
; --- D-pad input: scroll the list ---
.l9052:                                                 ; $009052
    move.w  d5,d0
    andi.w  #$f,d0              ; bits 0-3 = d-pad (Up/Down/Left/Right)
    beq.w   .l8ebe              ; no d-pad: redraw cursor and loop
    move.w  #$1,(a5)            ; input_mode_flag = 1: activate countdown input gate
; AdjustScrollPos: update scroll position in a2 based on d-pad bits in d5
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)            ; charlist scroll state
    bsr.w AdjustScrollPos        ; adjust charlist_ptr based on d-pad direction
; After scrolling, re-run HitTestMapTile to update hover state
    move.w  (a3),d0             ; list state word
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w HitTestMapTile         ; test new scroll position for hit
    lea     $0010(sp),sp
    move.w  d0,d3               ; d3 = new hit_index
    cmpi.w  #$ff,d0             ; no item under cursor after scroll?
    beq.b   .l90a8              ; nothing hit
    cmp.w   d3,d4               ; same item as before?
    beq.b   .l90a4              ; same: no stat panel update
; New item in hover after scroll: redraw stat preview
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w DrawStatDisplay        ; show stat panel for new hovered item
    lea     $0014(sp),sp
.l90a4:                                                 ; $0090A4
    move.w  d3,d4               ; update prev_hit_index
    bra.b   .l90e0              ; go to cursor render (skip clearing panel)
; Scrolled off any item: clear stat panel
.l90a8:                                                 ; $0090A8
    cmpi.w  #$ff,d4             ; was any item hovered before scroll?
    beq.b   .l90e0              ; no: skip panel clear
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)                 ; clear stat preview area
    pea     ($0002).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr GameCmd16: clear preview sprites
    lea     $0024(sp),sp
    move.w  #$ff,d4             ; prev_hit_index = $FF (no hover)
.l90e0:                                                 ; $0090E0
    pea     ($0001).w           ; GameCommand mode delay = 1
    bra.w   .l8f0a              ; GameCommand #$E and loop back
; --- Exit: return selected index ---
.l90e8:                                                 ; $0090E8
    move.w  d3,d0               ; d0 = selected char index (or $FF for cancel)
    movem.l -$0024(a6),d2-d6/a2-a5
    unlk    a6
    rts
