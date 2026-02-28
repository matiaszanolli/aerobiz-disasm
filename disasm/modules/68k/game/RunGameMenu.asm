; ============================================================================
; RunGameMenu -- Draws the main menu screen (background, logo, portrait) then dispatches to sub-menus (aircraft, routes, staff, finance, end-turn) via a jump-table loop
; ============================================================================
; Register map:
;   a2 = $0001725A -- address of sub-menu function table (5 entries)
;   a3 = $00FFA792 -- working copy of current_player (stored here as word for menu use)
;   a4 = $00017C9E -- (unused by name, function pointer table for sub-menu related calls)
;   a5 = $0D64     -- GameCommand (cached for repeated calls)
;   d2 = last menu selection result
;   d3 = loop state (cleared at init)
;   d4 = current highlighted menu item index (0-4), init = 4 (bottom = end-turn)
RunGameMenu:                                                  ; $016F9E
    movem.l d2-d4/a2-a5,-(sp)
    movea.l #$0001725a,a2           ; a2 = sub-menu dispatch table (5 function pointers)
    movea.l #$00ffa792,a3           ; a3 = $FFA792 (working player/menu state word)
    movea.l #$00017c9e,a4           ; a4 = secondary function table
    movea.l #$0d64,a5               ; a5 = GameCommand ($0D64)
    ; --- Phase: Store current player index into menu state ---
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0        ; d0 = current_player ($FF0016): 0-3
    move.w  d0,(a3)                 ; ($FFA792) = current_player (for dialog title lookup)
    ; --- Phase: Load resources and set up display ---
    dc.w    $4eb9,$0001,$d71c       ; jsr ResourceLoad ($01D71C): load required graphics resource
    dc.w    $4eb9,$0001,$e398       ; jsr PreLoopInit ($01E398): one-time pre-loop state init
    ; DisplaySetup: set up background tilemap at palette 0x10, size 0x10
    pea     ($0010).w               ; height param
    pea     ($0010).w               ; width param
    pea     ($0004C976).l           ; ROM pointer to background tile data / display descriptor
    dc.w    $4eb9,$0000,$5092       ; jsr DisplaySetup ($005092): init title/BG display
    ; GameCommand #$1B: draw tile block for main menu panel
    pea     ($0004C996).l           ; tile data pointer for menu panel
    pea     ($001C).w               ; height = $1C rows
    pea     ($0020).w               ; width = $20 cols
    clr.l   -(sp)                   ; Y start = 0
    clr.l   -(sp)                   ; X start = 0
    pea     ($0001).w               ; arg: 1
    pea     ($001B).w               ; GameCommand #$1B = draw tile block
    jsr     (a5)                    ; GameCommand
    ; LZ decompress logo/portrait graphics to save buffer $FF1804
    pea     ($0004D096).l           ; compressed data source pointer (ROM logo data)
    pea     ($00FF1804).l           ; save_buf_base: decompression output buffer
    dc.w    $4eb9,$0000,$3fec       ; jsr LZ_Decompress ($003FEC): decompress logo tiles
    lea     $0030(sp),sp            ; clean up $30 (12 args x 4)
    ; VRAMBulkLoad: DMA logo tiles to VRAM
    pea     ($0001).w               ; flags: 1
    clr.l   -(sp)                   ; DMA source offset = 0
    pea     ($00FF1804).l           ; source = decompressed tile buffer
    pea     ($0104).w               ; VRAM tile count = $104 (260 tiles)
    pea     ($0001).w               ; DMA channel / mode = 1
    dc.w    $4eb9,$0001,$d568       ; jsr VRAMBulkLoad ($01D568): chunked DMA to VRAM
    dc.w    $4eb9,$0001,$d748       ; jsr ResourceUnload ($01D748): unload graphics resource
    ; TilePlacement: place logo tile at position 0,0 with 1x1 dimensions
    clr.l   -(sp)                   ; priority = 0
    pea     ($0001).w               ; tile count Y = 1
    pea     ($0001).w               ; tile count X = 1
    clr.l   -(sp)                   ; X pos = 0
    clr.l   -(sp)                   ; Y pos = 0
    clr.l   -(sp)                   ; tile index = 0
    clr.l   -(sp)                   ; tile data address = 0
    dc.w    $4eb9,$0001,$e044       ; jsr TilePlacement ($01E044): place logo tile
    lea     $0030(sp),sp            ; clean up $30
    ; GameCommand #$E: commit display update
    pea     ($0001).w
    pea     ($000E).w               ; GameCommand #$E = flush display buffer
    jsr     (a5)
    ; GameCmd16 (#$10): clear sprite layer via command 4, row $3B
    pea     ($0004).w               ; arg: 4 (clear mode)
    pea     ($003B).w               ; arg: $3B (row limit for sprite clear)
    dc.w    $4eb9,$0001,$e0b8       ; jsr GameCmd16 ($01E0B8): clear sprites in range
    ; GameCommand #$E again: finalize display
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $0018(sp),sp            ; clean up $18 (3 pea pairs x2 x4 = $18)
    ; --- Phase: Initialize menu loop state ---
    moveq   #$4,d4                  ; d4 = initial menu cursor = 4 (last item = end-turn)
    clr.w   d3                      ; d3 = loop state
    clr.w   ($00FF1296).l           ; scenario_flag = 0 (clear scenario UI state flag)
    ; --- Phase: Menu loop -- show dialog then dispatch ---
    dc.w    $6000,$00dc             ; bra.w $017160 (branch to main loop condition/display)
    ; ---- Menu loop body (entered from bra.w above, at $017080) ----
    ; Show the main menu dialog: blank args, dialog table $47A5E, player as title
    clr.l   -(sp)                   ; dialog arg 3 = 0
    clr.l   -(sp)                   ; dialog arg 2 = 0
    clr.l   -(sp)                   ; dialog arg 1 = 0
    pea     ($00047A5E).l           ; ROM: menu item string table (aircraft/routes/staff/finance/end-turn)
    move.w  (a3),d0                 ; d0 = current_player (from a3 = $FFA792)
    ext.l   d0
    move.l  d0,-(sp)                ; push player_index for dialog header
    dc.w    $4eb9,$0000,$7912       ; jsr ShowDialog ($007912): show menu with player name header
    ; SelectMenuItem: get user selection with scroll cursor at current d4 position
    pea     ($0005).w               ; 5 menu items
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)                ; current highlighted item
    dc.w    $4eba,$02bc             ; jsr $017366 (SelectMenuItem helper, PC-relative)
    nop
    lea     $001c(sp),sp            ; clean up 7 args ($1C)
    move.w  d0,d2                   ; d2 = selection result (0-4 or -1 = cancel / $FF = no change)
    ext.l   d0
    moveq   #-$1,d1                 ; -1 = cancel code
    cmp.l   d0,d1
    dc.w    $6700,$00b0             ; beq.w $01716C (cancel -> exit loop)
    ; --- Phase: Update cursor position ---
    cmpi.w  #$ff,d2                 ; $FF = "no change to cursor" result?
    beq.b   .l170ca                 ; yes -> keep d4 as-is
    ; Update d4: new cursor position formula: d2*2 + 4
    move.w  d2,d4
    add.w   d4,d4                   ; d4 = d2 * 2
    addq.w  #$4,d4                  ; d4 = d2*2 + 4 (cursor advancement weight)
.l170ca:                                                ; $0170CA
    ; --- Phase: Range-check selection and dispatch via jump table ---
    move.w  d2,d0
    ext.l   d0
    moveq   #$4,d1                  ; max menu index = 4
    cmp.l   d1,d0
    dc.w    $6200,$0092             ; bhi.w $017166 (d0 > 4 -> out of range, loop back)
    ; PC-relative jump table dispatch: 5 cases (0=aircraft, 1=routes, 2=staff, 3=finance, 4=end-turn)
    add.l   d0,d0                   ; d0 = selection * 2 (word offset into table)
    move.w  $170e0(pc,d0.l),d0     ; d0 = signed word offset from jump table at $170E0
    jmp     $170e0(pc,d0.w)         ; jump to case handler via PC-relative dispatch
    ; Jump table at $0170E0 (5 entries x word = 10 bytes):
    ;   entry 0 (+$000A): case 0 = aircraft menu  ($0170EA)
    ;   entry 1 (+$002E): case 1 = routes menu    ($017110)
    ;   entry 2 (+$0036): case 2 = staff menu     ($017116... approx)
    ;   entry 3 (+$0054): case 3 = finance menu
    ;   entry 4 (+$0072): case 4 = end-turn / exit
    ; WARNING: 212 undecoded trailing bytes at $0170E0
    ; These bytes are the jump table entries and case handlers encoded as dc.w.
    ; Each case: loads args ($10, $18, $01, $05), calls (a4) = sub-menu function,
    ; unwinds stack ($10), then BRA back to loop top or falls through to exit.
    dc.w    $000a                   ; jtab[0]: offset +$A -> case 0: aircraft menu
    dc.w    $002e                   ; jtab[1]: offset +$2E -> case 1: routes menu
    dc.w    $0036                   ; jtab[2]: offset +$36 -> case 2: staff menu
    dc.w    $0054                   ; jtab[3]: offset +$54 -> case 3: finance menu
    dc.w    $0072                   ; jtab[4]: offset +$72 -> case 4: end-turn
    ; --- Case 0: Aircraft menu ---
    dc.w    $4eb9,$0001,$d71c       ; jsr ResourceLoad: load aircraft graphics
    dc.w    $4878,$0010             ; pea ($0010).w -- arg: mode $10
    dc.w    $4878,$0018             ; pea ($0018).w -- arg: type $18
    dc.w    $4878,$0001             ; pea ($0001).w -- arg: 1
    dc.w    $4878,$0005             ; pea ($0005).w -- arg: 5 (aircraft sub-menu index?)
    dc.w    $4e94                   ; jsr (a4) -- call aircraft sub-menu
    dc.w    $4fef,$0010             ; lea $10(sp),sp -- clean up 4 args
    dc.w    $4eba,$039a             ; jsr PC+$039A (helper: post-aircraft cleanup)
    dc.w    $4e71                   ; nop
    dc.w    $6052                   ; bra.b $+$54 (back to loop top)
    ; --- Case 1: Routes menu ---
    dc.w    $4eba,$070c             ; jsr PC+$070C (routes sub-menu)
    dc.w    $4e71                   ; nop
    dc.w    $6050                   ; bra.b (back to loop top)
    ; --- Case 2: Staff menu ---
    dc.w    $4878,$0010             ; pea ($0010).w
    dc.w    $4878,$0018             ; pea ($0018).w
    dc.w    $4878,$0001             ; pea ($0001).w
    dc.w    $4878,$0005             ; pea ($0005).w
    dc.w    $4e94                   ; jsr (a4)
    dc.w    $4fef,$0010             ; lea $10(sp),sp
    dc.w    $4eba,$0086             ; jsr PC+$86 (staff post-handler)
    dc.w    $4e71                   ; nop
    dc.w    $602c                   ; bra.b (back to loop top)
    ; --- Case 3: Finance menu ---
    dc.w    $4878,$0010
    dc.w    $4878,$0018
    dc.w    $4878,$0001
    dc.w    $4878,$0005
    dc.w    $4e94                   ; jsr (a4)
    dc.w    $4fef,$0010
    dc.w    $4eba,$07ba             ; jsr PC+$7BA (finance sub-menu handler)
    dc.w    $4e71                   ; nop
    dc.w    $600e                   ; bra.b (back to loop top)
    ; --- Case 4: End-turn -- validate and exit loop ---
    dc.w    $4eba,$0a16             ; jsr PC+$A16 (end-turn validation helper at ~$017B10)
    dc.w    $4e71                   ; nop
    ; End-turn confirmation check
    dc.w    $0c40,$0001             ; cmpi.w #$1,d0 (did validation pass?)
    dc.w    $6602                   ; bne.b $+4 (no -> skip)
    dc.w    $7601                   ; moveq #1,d3 (d3=1: signal exit from loop)
    ; Call sub-function pointer from a2 dispatch table with 0 arg
    dc.w    $42a7                   ; clr.l -(sp)
    dc.w    $4e92                   ; jsr (a2) -- call end-turn sub-menu entry
    dc.w    $588f                   ; addq.l #4,sp
    dc.w    $4a43                   ; tst.w d3 (loop exit requested?)
    dc.w    $6700,$ff1c             ; beq.w $017080 (no -> back to loop top)
    ; --- Phase: Exit path -- unload resource and restore scenario_flag ---
    dc.w    $4eb9,$0001,$d71c       ; jsr ResourceLoad (called again before exit? NOTE: may be ResourceUnload)
    ; LoadScreen: reload main game screen before returning
    dc.w    $42a7                   ; clr.l -(sp)
    dc.w    $3039,$00ff,$9a1c       ; move.w ($FF9A1C).l,d0 -- screen_id
    dc.w    $48c0                   ; ext.l d0
    dc.w    $2f00                   ; move.l d0,-(sp) -- push screen_id
    dc.w    $3013                   ; move.w (a3),d0 -- current_player from $FFA792
    dc.w    $48c0                   ; ext.l d0
    dc.w    $2f00                   ; move.l d0,-(sp) -- push player_index
    dc.w    $4eb9,$0000,$6a2e       ; jsr LoadScreen ($006A2E): load and init game screen
    pea     ($0002).w               ; mode 2
    dc.w    $3039,$00ff,$9a1c       ; move.w ($FF9A1C).l,d0 -- screen_id
    dc.w    $48c0                   ; ext.l d0
    dc.w    $2f00                   ; push screen_id
    dc.w    $3013                   ; move.w (a3),d0 -- current_player
    dc.w    $48c0                   ; ext.l d0
    dc.w    $2f00                   ; push player_index
    dc.w    $4eb9,$0000,$6b78       ; jsr ShowRelPanel ($006B78): show relation/status panel
    dc.w    $4fef,$0018             ; lea $18(sp),sp -- clean up args
    dc.w    $3039,$00ff,$1296       ; move.w ($FF1296).l,d0 -- scenario_flag: restore original value
    dc.w    $4cdf,$3c1c             ; movem.l (sp)+,d2-d4/a2-a5
    dc.w    $4e75                   ; rts
; === Translated block $0171B4-$017566 ===
; 4 functions, 946 bytes
