; ============================================================================
; GameUpdate2 -- Main per-turn update loop: selects active player order, iterates all four players running their menu or AI strategy, manages resource load/unload, shows relation panels and player info, and handles scenario events and post-turn screen transitions.
; 1152 bytes | $01B49A-$01B919
; ============================================================================
; --- Phase: Setup ---
GameUpdate2:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0016,a5
    ; a5 = &current_player ($FF0016); used throughout to read active player index
    clr.w   d5
    ; d5 = "human turn took place" flag (0 = not yet; set to 1 if human player acted)
    move.w  #$80, ($00FFBD64).l
    ; reset charlist_ptr to $80 (neutral cursor position before any player loop)
    move.w  #$80, ($00FFBD66).l
    ; reset second cursor state word to $80 (same init, mirrors charlist_ptr)

; --- Phase: First-Frame Scenario Events ---
    tst.w   ($00FF17C4).l
    ; work_flag: nonzero means a player's turn is already in progress (mid-sequence re-entry)
    bne.b   l_1b4c8
    ; if already mid-turn, skip the first-frame event trigger
    jsr RunEventSequence
    ; fire any pending scenario events (cutscenes, story triggers) at turn start
l_1b4c8:
    tst.w   ($00FF17C4).l
    bne.b   l_1b52e
    ; if mid-turn, skip player-order randomisation and go straight to the saved starting player

; --- Phase: Randomise Turn Order (new turn only) ---
    move.w  #$fffe, ($00FF0A32).l
    ; session_word_a32 = $FFFE: sentinel marking "scenario menu already shown this turn"
    jsr RunScenarioMenu
    ; show scenario selection/event menu at turn start (only runs once per turn)
    jsr ResourceUnload
    ; free graphics resources loaded for the scenario menu
    clr.w   d2
    ; d2 = count of players placed in the turn-order list so far
    clr.w   d3
    ; d3 = bitmask of player indices already assigned to the turn order (bits 0-3)
    bra.b   l_1b524
; Shuffle loop: pick players 0-3 in random order without repetition
; Uses a rejection-sampling approach: pick a random index; if already used, retry.
l_1b4ea:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    ; d0 = random player index in [0, 3]
    addq.l  #$8, a7
    move.b  d0, (a5)
    ; write candidate player index to current_player ($FF0016) temporarily
    moveq   #$0,d0
    move.b  (a5), d0
    ; d0 = candidate player index (zero-extended)
    moveq   #$1,d1
    lsl.l   d0, d1
    ; d1 = 1 << player_index  (bitmask for this candidate)
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    ; d1 = already-assigned bitmask
    and.l   d1, d0
    bne.b   l_1b524
    ; candidate bit already set in d3 -> this player was already placed; retry (skip add)
    moveq   #$0,d0
    move.b  (a5), d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    ; d0 = bit for this player
    or.w    d0, d3
    ; mark player as assigned in the used-set bitmask
    movea.l  #$00FF0012,a0
    move.b  (a5), (a0,d2.w)
    ; save_block_12[d2] = player index -> append this player to turn-order list
    addq.w  #$1, d2
    ; advance list position
l_1b524:
    cmpi.w  #$4, d2
    blt.b   l_1b4ea
    ; loop until all 4 players placed
    clr.w   d2
    ; d2 = 0: start iterating turn-order list from slot 0
    bra.b   l_1b544
; --- Phase: Resume Mid-Turn (work_flag was set) ---
; Turn order was already decided; find where we left off.
l_1b52e:
    clr.w   d2
    ; d2 = search index into save_block_12
    move.b  (a5), d3
    ; d3 = current_player (the player whose turn was interrupted)
    bra.b   l_1b536
l_1b534:
    addq.w  #$1, d2
    ; advance to next slot
l_1b536:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), d0
    ; load turn-order list entry at index d2
    cmp.b   d3, d0
    bne.b   l_1b534
    ; scan until we find the current player's slot in the list
    ; d2 now holds the slot index where this player sits in the turn-order list

; --- Phase: Per-Player Outer Loop Initialise ---
l_1b544:
    clr.w   ($00FF9A1C).l
    ; screen_id = 0: clear carried-over screen state before player loop begins
    move.w  -$2(a6), d4
    ; d4 = saved display parameter (player_word_tab entry from previous frame, if any)
    lea     -$2(a6), a4
    ; a4 = pointer to the link-frame slot holding d4 (passed to DisplaySetup)
    bra.w   l_1b892
    ; jump to loop-condition check (d2 vs 4) to enter the per-player iteration
; --- Phase: Per-Player Turn Body ---
; Executed once per player per turn, in the randomised order built above.
l_1b556:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), (a5)
    ; current_player = save_block_12[d2]: make this turn-slot's player the active one
    moveq   #$0,d0
    move.b  (a5), d0
    ; d0 = player index (0-3)
    mulu.w  #$24, d0
    ; d0 = player_index * $24 (player record stride = 36 bytes)
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    ; a3 = &player_records[player_index] (base of this player's 36-byte record)

; Check whether this player's screen was already fully shown this turn (screen_id == 7)
    cmpi.w  #$7, ($00FF9A1C).l
    ; screen_id == 7 means LoadScreenGfx already ran and set the state
    beq.w   l_1b62a
    ; if so, skip the first-time setup and go directly to the "already-loaded" path

; --- Phase: First-Time Screen Setup (screen_id != 7) ---
    jsr ResourceLoad
    ; load graphics resources needed for this player's turn screen
    jsr PreLoopInit
    ; one-time pre-loop initialisation (clears display state, resets subsystems)
    moveq   #$0,d0
    move.b  (a5), d0
    ; d0 = player index
    add.w   d0, d0
    ; d0 = player_index * 2 (word-sized table stride)
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    ; d4 = player_word_tab[player_index] (per-player display parameter word)
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    ; args: display_flag=1, mode=$F, param_ptr=a4 (-> link frame word)
    jsr DisplaySetup
    ; initialise display hardware and tile buffer for this player's screen
    pea     ($0007).w
    jsr SelectMenuItem
    ; pre-select menu item 7 (sets $FFBD52 = 7 as default menu highlight)
    pea     ($0001).w
    jsr CmdSetBackground
    ; set background layer 1 (GameCommand #1B variant)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    ; GameCommand $10 ($0040 priority, 0 param): trigger display update / flip
    clr.l   -(a7)
    jsr CmdSetBackground
    ; clear/set background with param=0 (reset to default)
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    ; push player index for LoadScreenGfx
    jsr LoadScreenGfx
    ; decompress and DMA player-specific screen graphics to VRAM
    lea     $30(a7), a7
    ; clean up 6 longword args (DisplaySetup=3, SelectMenuItem=1, CmdSetBg×2=1 each + LoadScreenGfx=3)
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    ; display the relationship/affinity panel for this player (mode=2, slot=7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    ; show this player's info overlay (cash, routes, approval rating)
    nop
    lea     $10(a7), a7
    ; clean up ShowRelPanel (3 args) + ShowPlayerInfo (1 arg) = 4 longs
    move.w  #$7, ($00FF9A1C).l
    ; screen_id = 7: mark that the full screen-setup sequence completed for this player
    jsr ResourceUnload
    ; release graphics resources now that the screen is shown
    bra.w   l_1b7a6
    ; continue to the AI/human turn-dispatch block
; --- Phase: Screen-Already-Loaded Path (screen_id == 7) ---
; Re-show the player's screen without the full first-time graphics setup.
l_1b62a:
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.b  (a5), d0
    ; d0 = player index
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    ; d4 = player_word_tab[player_index] (display parameter)
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    ; re-init display (no SelectMenuItem call this time — menu stays at saved index)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    ; GameCommand $10: trigger display flip / update
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    ; reload screen graphics (resources were unloaded after the first-time setup)
    lea     $28(a7), a7
    ; clean up (4 args fewer than first-time path: SelectMenuItem omitted)
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    ; redisplay relationship panel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    ; redisplay player info overlay
    nop
    lea     $10(a7), a7
    jsr ResourceUnload

; Check if this player is active (active_flag == 1 at player_record+$00)
    cmpi.b  #$1, (a3)
    ; player_record.active_flag: $01 = active human/AI player
    bne.w   l_1b7a6
    ; inactive player: nothing more to show; skip to turn dispatch

; --- Phase: Scenario Event Panel (active player only) ---
; Show timed event tiles if the player has an event scheduled.
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; d0 = player_record.hub_city (city index for range lookup)
    add.w   d0, d0
    ; d0 = hub_city * 2 (word stride into event tile coordinate table)
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    ; a2 = ROM table entry at $5E948[hub_city*2] — event tile position record
    clr.w   d3
    ; d3 = event tile iteration counter (0..4, loop shows 5 tiles)
; Loop: place the event tile indicator 5 times (animated blink), then show final tile + wait for input.
l_1b6d2:
    move.l  #$8000, -(a7)
    ; priority flag $8000 (high-priority tile, placed on foreground layer)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    ; Y = event_tile_record[1] - 4 (tile screen row, adjusted from map coord)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    ; X = event_tile_record[0] - 4 (tile screen column, adjusted)
    pea     ($0001).w
    pea     ($0766).w
    ; tile ID $0766 = event marker tile graphic
    jsr TilePlacement
    ; place the event marker tile at the adjusted position
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    ; GameCommand $E: wait for V-blank / frame sync (one frame delay)
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    ; GameCommand $10 via thin wrapper: trigger display update
    lea     $2c(a7), a7
    ; clean up TilePlacement (7 args) + GameCommand ($E) (2) + GameCmd16 (2) args
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    ; second frame-sync wait
    addq.l  #$8, a7
    addq.w  #$1, d3
    cmpi.w  #$5, d3
    blt.b   l_1b6d2
    ; repeat tile-blink animation 5 times

; Final tile placement + input wait (player must press button to dismiss event)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr TilePlacement
    ; place event tile one final time (stays on screen while waiting)
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    ; frame sync
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    ; block until player presses button (mode=3 = button-press wait, no repeat)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    ; update display after input
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    ; final frame sync
    lea     $10(a7), a7
; --- Phase: AI vs Human Turn Dispatch ---
l_1b7a6:
    tst.w   ($00FF17C4).l
    ; work_flag: nonzero = human turn already in progress (re-entering mid-turn)
    bne.b   l_1b7c6
    ; if mid-turn re-entry, skip AI and go to PreLoopInit only

    jsr RunAITurn
    ; run this player's AI logic (city/route decisions, purchasing)
    cmpi.w  #$ffff, ($00FF0A32).l
    ; session_word_a32 == $FFFF means scenario menu was not yet shown after AI turn
    beq.b   l_1b7cc
    ; already shown — skip RunScenarioMenu
    jsr RunScenarioMenu
    ; show post-AI-turn scenario/event menu
    bra.b   l_1b7cc

l_1b7c6:
    jsr PreLoopInit
    ; human turn re-entry: just re-init loop state, fall through to human menu

; --- Phase: Human Player Main Menu ---
l_1b7cc:
    cmpi.b  #$1, (a3)
    ; player_record.active_flag: $01 = active (human or AI-flagged) player
    bne.w   l_1b864
    ; player not active (AI-only turn path?) -> skip human menu, go to AI strategy block

    jsr ResourceLoad
    ; load graphics for the main turn menu
    moveq   #$0,d0
    move.b  $1(a3), d0
    ; d0 = player_record.hub_city (city index)
    move.l  d0, -(a7)
    jsr RangeLookup
    ; map hub_city to a region index (0-7)
    move.w  d0, ($00FF9A1C).l
    ; screen_id = region index (used to select which screen/map to display)
    ext.l   d0
    move.l  d0, -(a7)
    jsr SelectMenuItem
    ; set default menu highlight to the region-based screen index
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    ; load the per-region screen layout and tilemap for this player
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    ; show relationship panel (mode=2, region screen)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunMainMenu,PC)
    ; run the interactive main turn menu (routes, hiring, purchases)
    nop
    jsr ResourceUnload
    ; release resources used by the main menu
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ValidateMenuInput,PC)
    ; validate and commit the player's menu selection (checks legality, applies result)
    nop
    lea     $2c(a7), a7
    ; clean up all stacked args from RangeLookup through ValidateMenuInput
    moveq   #$1,d5
    ; d5 = 1: record that a human player took their turn this round
    bra.b   l_1b88a
    ; skip the AI-strategy path
; --- Phase: AI-Only Strategy Path ---
; Runs when active_flag != 1 (non-human or AI-driven player turn).
l_1b864:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    ; GameCommand $10 ($0040 priority): trigger display update / flip before AI runs
    jsr RunAIStrategy
    ; execute the full AI strategic decision pipeline (route evaluation, hiring etc.)
    pea     ($003C).w
    jsr PollInputChange
    ; $3C = 60: wait up to 60 frames for any input change (lets player observe AI turn)
    lea     $10(a7), a7
    ; clean up 3 GameCommand args + 1 PollInputChange arg
    clr.w   d5
    ; d5 = 0: this was an AI turn, no human input occurred

; --- Phase: Per-Player Loop Footer ---
l_1b88a:
    clr.w   ($00FF17C4).l
    ; work_flag = 0: this player's turn is complete; clear mid-turn flag
    addq.w  #$1, d2
    ; advance to next slot in the turn-order list

; Loop condition: iterate until all 4 players have had their turn
l_1b892:
    cmpi.w  #$4, d2
    blt.w   l_1b556
    ; d2 < 4: more players remain; jump back to turn body

; --- Phase: Post-Turn Screen Transition ---
; All 4 players done. Show end-of-turn screen if a human player acted.
    move.w  d4, -$2(a6)
    ; save updated display parameter (player_word_tab value) back into link frame
    cmpi.w  #$1, d5
    bne.b   l_1b900
    ; d5 == 1: a human player took their turn -> show the post-turn summary screen

; Human turn happened: show transition screen with map graphic (scene index 4)
    jsr ResourceLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    ; SetTextWindow(0, 0, $20, $20): set text area to full 32x32 tile screen
    pea     ($0007).w
    jsr SelectMenuItem
    ; pre-select item 7 for the transition screen
    jsr PreLoopInit
    ; reset display subsystem
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    ; GameCommand $10: display flip
    clr.l   -(a7)
    jsr CmdSetBackground
    ; clear background
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    ; load screen graphics for scene index 4 (post-turn map/transition screen)
    lea     $30(a7), a7
    ; clean up all stacked args
    jsr ResourceUnload
    ; release loaded graphics
    bra.b   l_1b910

; No human turn: just do a display flip and return
l_1b900:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    ; GameCommand $10: ensure display is flushed before returning

; --- Phase: Teardown ---
l_1b910:
    movem.l -$40(a6), d2-d5/a2-a5
    ; restore callee-saved registers from link frame
    unlk    a6
    rts
