; ============================================================================
; ShowQuarterSummary -- Displays the end-of-quarter summary screen; calls route-selection and profit helpers, shows a summary dialog with route results and financial totals.
; Called: ?? times.
; 840 bytes | $012E92-$0131D9
; ============================================================================
; --- Phase: Setup -- allocate frame, save registers, load player context ---
; No explicit arguments (uses global state from RAM):
;   $FF0016 = current_player (byte): which player's turn is ending
;   $FF9A1C = screen_id (word): current screen/scenario index (drives display variant)
;   $FF0018 + player*$24 = player record (36 bytes per player)
;
; Purpose: drives the complete end-of-quarter summary UI flow for the current player.
; Checks for available routes, lets the player select one for review, evaluates
; profitability, shows a result dialog, and handles the buy/skip decision loop.
ShowQuarterSummary:                                                  ; $012E92
    link    a6,#-$70
    movem.l d2-d6/a2-a5,-(sp)
    ; a4 = local text buffer for sprintf (-$6E bytes from frame base, 110 bytes)
    lea     -$006e(a6),a4
    ; a5 = smaller scratch buffer (-$1E from frame, 30 bytes) for short strings/lists
    lea     -$001e(a6),a5
    ; d2 = current player index (0-3) from $FF0016 (current_player)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    ; d3 = screen_id from $FF9A1C (determines which summary variant to display)
    move.w  ($00FF9A1C).l,d3
    ; locate player record: player_records base $FF0018, stride $24 (36 bytes)
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    ; a3 -> current player's record (36 bytes); used to read/write financial fields
    movea.l a0,a3
    ; --- Phase: Resource init -- prepare display and clear sprite layer ---
    ; GameCmd16 ($01E0B8): GameCommand #$16 thin wrapper
    ; call with args (1, 0): enable sprite layer / init display subsystem
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    ; call with args ($3B=59, 4): set display mode parameter (sprite count or page select)
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    ; call $0131DA(screen_id): screen-variant setup sub-function
    ; returns: 1 = there are routes available for this player to review, other = different state
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02f6                                 ; jsr $0131DA
    nop
    lea     $0014(sp),sp
    ; if return != 1: no routes available or wrong screen -- show alternative summary dialog
    cmpi.w  #$1,d0
    bne.w   .l13142
    ; --- Phase: Route-available path -- check if player has any profitable routes ---
    ; call $0136F8(player=d2, screen=d3): count profitable routes for this player
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$07f6                                 ; jsr $0136F8
    nop
    addq.l  #$8,sp
    ; d0 = profitable route count; if 0 or negative, show "no profitable routes" dialog
    tst.w   d0
    ble.w   .l1310c
    ; --- Phase: Build route summary list for player selection ---
    ; MemFillByte($01D520): zero $1E bytes of buffer a5 (clear route list scratch area)
    pea     ($001E).w
    clr.l   -(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    ; call $013614(buf=a5, player=d2, screen=d3): populate route list into a5 scratch buffer
    move.l  a5,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$06e8                                 ; jsr $013614
    nop
    ; call $013E62(player=d2, buf=a5): evaluate/filter route list, returns selection state
    move.l  a5,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0f28                                 ; jsr $013E62
    nop
    lea     $0020(sp),sp
    ; if != 1: player declined or no valid selection -- fall through to no-route-selected path
    cmpi.w  #$1,d0
    bne.w   .l130d6
; --- Phase: Route selection inner loop -- load screen, pick slot, show result ---
.l12f4a:                                                ; $012F4A
    ; ResourceUnload ($01D748): release any previously loaded graphics resource
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    ; ManageRouteSlots ($0112EE) with mode=3 and player=d2: let player select a route slot
    ; returns d4 = selected route slot index, or $FF if player cancelled
    pea     ($0003).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    ; d4 = selected slot index
    move.w  d0,d4
    ; $FF = no slot selected (player backed out) -- jump to final screen load and exit
    cmpi.w  #$ff,d0
    beq.w   .l1319a
.l12f6c:                                                ; $012F6C
    ; ResourceLoad ($01D71C): load graphics resource for the selected route's screen
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    ; LoadScreen ($006A2E) with mode=1, screen=d3, player=d2: load and init the summary screen
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    ; call $01325C(player=d2, screen=d3, slot=d4, buf=a5): evaluate selected route slot
    ; returns d5 = action code (what the player chose to do with this route)
    move.l  a5,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02be                                 ; jsr $01325C
    nop
    lea     $001c(sp),sp
    ; d5 = action code from route evaluation
    move.w  d0,d5
    ; $FF = go back to slot selection (player wants to pick a different route)
    cmpi.w  #$ff,d0
    beq.b   .l12f4a
    ; normalize action code: if d5 == 1, map to 3 (purchase/confirm action)
    cmpi.w  #$1,d5
    bne.b   .l12fb8
    ; action code 1 -> 3: "confirm" gets remapped to the standard purchase action value
    moveq   #$3,d6
    bra.b   .l12fba
.l12fb8:                                                ; $012FB8
    ; action code != 1: use as-is (2=skip, 3=buy, etc.)
    move.w  d5,d6
.l12fba:                                                ; $012FBA
    ; call $013EF2(player=d2, screen=d3, action=d6): apply the player's selected action
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0f24                                 ; jsr $013EF2
    nop
    ; ShowTextDialog ($01183A): show result dialog for chosen action
    ; args: player=d2, string=table[$479F6 + d5*4], slot=d4, confirm=1, 0, 0
    ; $479F6 = ROM action-result message pointer table, indexed by action code d5
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$000479f6,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; ShowTextDialog: displays action-result message and waits for player confirmation
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    ; --- Phase: Update $FF0338 route-display record for this player/slot ---
    ; $FF0338 = per-player route-display record table; stride $20 (32) per player, $8 per slot
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d4,d1
    lsl.w   #$3,d1
    add.w   d1,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    ; a2 -> route display record for (player=d2, slot=d4)
    movea.l a0,a2
    ; set +$01 = $06: route display type/icon code 6
    move.b  #$06,$0001(a2)
    ; +$06 = action code d5 (result of this turn's route action)
    move.w  d5,$0006(a2)
    ; +$00 = screen_id d3 (identifies which scenario/screen this summary belongs to)
    move.b  d3,(a2)
    ; call $01377E(player=d2, screen=d3, slot=d4): compute financial outcome for this route
    ; returns d6 = profit/loss delta for this route this quarter
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$074e                                 ; jsr $01377E
    nop
    lea     $0030(sp),sp
    ; d6 = profit/loss result; if <= 0, route was not profitable -- clear slot and re-select
    move.l  d0,d6
    ble.w   .l130c6
    ; --- Phase: Profitable route -- show profit message and offer purchase/upgrade dialog ---
    ; sprintf($03B22C): format profit message using result-category string from $5E296 table
    ; $5E296 = ROM profit-category string pointer table (action code * 4)
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$0005e296,a0
    move.l  (a0,d0.l),-(sp)
    ; $479C2 = indirected pointer to profit message format string
    move.l  ($000479C2).l,-(sp)
    move.l  a4,-(sp)
    ; sprintf: format "you earned X this quarter" style message into a4 buffer
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    ; ShowTextDialog: display the profit confirmation message with purchase option
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; ShowTextDialog with pre-formatted string in a4; returns 1 if player confirms purchase
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    ; if player did not confirm, fall through to slot-clear path
    cmpi.w  #$1,d0
    bne.b   .l130c6
    ; --- Phase: Player confirmed purchase -- apply financial deduction and show graphic ---
    ; set route display record +$03 = $04: mark slot as "purchase confirmed" state
    move.b  #$04,$0003(a2)
    ; deduct d6 (route cost) from player's cash:
    ; player record +$06 = cash (longword); a3 -> current player record
    sub.l   d6,$0006(a3)
    ; LoadCompressedGfx ($005FF6) with args ($13=19, $0A=10, 5): load purchase-confirm graphic
    ; $13/$0A/$5 = tile index, palette, and resource ID for the purchase confirmation animation
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0013).w
    dc.w    $4eb9,$0000,$5ff6                           ; jsr $005FF6
    ; ShowTextDialog: show final purchase-complete message ($479D6 format, slot=d4)
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; $479D6 = indirected pointer to "purchase complete" message format string
    move.l  ($000479D6).l,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; ShowTextDialog: confirm the deduction to the player
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    ; loop back to slot selection (let player choose another route to review)
    bra.w   .l12f4a
.l130c6:                                                ; $0130C6
    ; route was not profitable or player declined -- invalidate this display record and retry
    ; clear route display record: +$01 = 0, +$06 = 0, +$00 = $FF (empty sentinel)
    clr.b   $0001(a2)
    clr.w   $0006(a2)
    move.b  #$ff,(a2)
    ; re-enter the slot display/result loop for the same slot (try again)
    bra.w   .l12f6c
; --- Phase: Alternative dialogs -- no profitable routes, player skipped, or no routes ---
.l130d6:                                                ; $0130D6
    ; player skipped route selection: show "no selection made" summary screen
    ; GameCommand #$1A: clear tile area (cols $20 wide, rows $D tall, at row $13, col 0)
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    ; GameCommand #$1A = ClearTileArea: erase summary region before showing alternate text
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    ; look up screen-variant string for this screen_id from $5EC84 table
    ; $5EC84 = ROM screen-type string pointer table (screen_id * 4)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    ; $479CE = indirected pointer to "no routes selected" summary format string
    move.l  ($000479CE).l,-(sp)
    bra.b   .l13176
.l1310c:                                                ; $01310C
    ; no profitable routes for this player this quarter
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    ; GameCommand #$1A: clear the same summary tile region
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    ; screen-variant string for "no profitable routes" message
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    ; $479AE = indirected pointer to "no profitable routes this quarter" format string
    move.l  ($000479AE).l,-(sp)
    bra.b   .l13176
.l13142:                                                ; $013142
    ; no routes available at all (screen variant check failed): show generic summary
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    ; GameCommand #$1A: clear summary tile area for the fallback message
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    ; screen-variant string: same $5EC84 table lookup
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    ; $479DA = indirected pointer to "no routes available" generic summary message
    move.l  ($000479DA).l,-(sp)
.l13176:                                                ; $013176
    ; --- common tail for all three "no-action" paths ---
    ; sprintf($03B22C): format the chosen message string into a4 buffer
    move.l  a4,-(sp)
    ; sprintf: format message (format ptr and arg already on stack from above)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    ; ShowDialog ($007912): display the formatted summary message and wait for player input
    ; args: player=d2, buf=a4, mode=2, confirm=1, 0, 0
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.l  a4,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; ShowDialog: display text dialog with optional player confirmation button
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0020(sp),sp
; --- Phase: Final screen load -- show character relationship panel to conclude summary ---
.l1319a:                                                ; $01319A
    ; ResourceLoad ($01D71C): load graphics for the final summary relationship panel
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    ; LoadScreen ($006A2E) with mode=1, screen=d3, player=d2: load the end-of-summary screen
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; LoadScreen: initialise and display the relationship/portfolio screen
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    ; ShowRelPanel ($006B78): display character relationship/affinity panel
    ; args: player=d2, screen=screen_id (re-read from $FF9A1C), mode=2
    pea     ($0002).w
    ; re-read screen_id from $FF9A1C in case it was updated during the loop
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    ; ShowRelPanel: shows the player's character relationship panel as the final summary view
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0094(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $0131DA-$0140DC ===
; 10 functions, 3842 bytes
