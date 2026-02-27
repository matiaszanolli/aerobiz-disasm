; ============================================================================
; ManageCharStatsS2 -- Manages post-transfer stat application: computes affordable stat points from salary/budget, shows the upgrade count dialog, then runs a DrawCharPanelS2 loop where the player confirms stat allocation, deducts funds, and updates the character record
; 970 bytes | $02DAA0-$02DE69
; ============================================================================
; --- Phase: Prologue / Argument Capture and Pointer Setup ---
ManageCharStatsS2:
    link    a6,#-$88               ; allocate $88 (136) bytes of local frame space
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4             ; d4 = 1st arg: player_index (0-3), identifies which player is managing stats
    move.l  $c(a6), d7             ; d7 = 2nd arg: character slot index (which character to upgrade)
    movea.l  #$00000D64,a5         ; a5 = GameCommand: central command dispatcher ($000D64)
    ; Locate this player's player_record in $FF0018 array
    move.w  d4, d0
    mulu.w  #$24, d0               ; d0 = player_index * $24 (36-byte stride)
    movea.l  #$00FF0018,a0         ; a0 = player_records base ($FF0018)
    lea     (a0,d0.w), a0
    movea.l a0, a4                 ; a4 = ptr to this player's player_record ($FF0018 + player*$24)
    ; a4+$06 = cash (long): the budget we'll deduct stat costs from
    move.w  #$1, -$2(a6)          ; local -$2: stat-upgrade count (initialized to 1; updated after dialog)
    ; FindCharSlotInGroup: find this character's slot index within the group for the given player
    moveq   #$0,d0
    move.w  d7, d0                 ; d0 = character slot index
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0                 ; d0 = player_index
    move.l  d0, -(a7)
    jsr (FindCharSlotInGroup,PC)   ; find the character's position within the player's group ($FF02E8 table)
    nop
    move.w  d0, -$86(a6)          ; local -$86: group slot index returned by FindCharSlotInGroup
    ; Locate this character's 4-byte entry in $FF02E8 block
    ; $FF02E8: 80-byte block (PackSaveState), purpose TBD; accessed as player*$14 + slot*4
    move.w  d4, d0
    mulu.w  #$14, d0               ; d0 = player_index * $14 (20-byte stride in $FF02E8)
    move.w  -$86(a6), d1          ; d1 = group slot index
    lsl.w   #$2, d1                ; d1 *= 4 (longword stride per slot)
    add.w   d1, d0                 ; d0 = player*$14 + slot*4 = byte offset to this char's entry
    movea.l  #$00FF02E8,a0         ; a0 = $FF02E8 block base
    lea     (a0,d0.w), a0
    movea.l a0, a2                 ; a2 = ptr to this character's 4-byte record in $FF02E8
    ; a2+$00: character identifier byte (type/ID)
    ; a2+$01: primary stat (skill level, most-accessed field from DATA_STRUCTURES.md)
    ; a2+$02: secondary stat (transfer flag / applied-upgrade byte)
    ; Locate this character's entry in event_records ($FFB9E8: 4×32-byte records)
    ; Access pattern: player*$20 + char_slot*2 (stride $20 per player, 2 bytes per char entry)
    move.w  d4, d0
    lsl.w   #$5, d0                ; d0 = player_index * $20 (32-byte stride per player in event_records)
    move.w  d7, d1
    add.w   d1, d1                 ; d1 = char_slot * 2 (word-stride within the 32-byte player block)
    add.w   d1, d0                 ; d0 = combined offset into event_records
    movea.l  #$00FFB9E8,a0         ; a0 = event_records ($FFB9E8: 128 bytes, 4 × $20-byte records)
    lea     (a0,d0.w), a0
    movea.l a0, a3                 ; a3 = ptr to this character's event_records entry (byte = current stat value)
    ; Load the character's stat type index to look up the salary cost per point
    ; bitfield_tab ($FFA6B8 sub-region, stride $C per char_slot): type discriminator byte
    move.w  d7, d0
    mulu.w  #$c, d0                ; d0 = char_slot * $C (12-byte stride in bitfield sub-table)
    movea.l  #$00FFA6B8,a0         ; a0 = $FFA6B8: sub-region of bitfield_tab/entity area, stride $C
    move.b  (a0,d0.w), d5          ; d5 = character type/class byte (used as stat-type discriminator)
    andi.l  #$ff, d5               ; zero-extend byte to longword for comparisons
    ; --- Phase: Compute Affordable Stat Points (d3) ---
    ; CalcWeightedStat: compute the salary/cost-per-stat-point for this character/player pair
    move.w  d7, d0                 ; d0 = character slot index
    move.l  d0, -(a7)
    move.w  d4, d0                 ; d0 = player_index
    move.l  d0, -(a7)
    jsr CalcWeightedStat           ; returns salary-cost-per-stat-point in d0
    move.w  d0, d6                 ; d6 = cost-per-stat-point (salary weight)
    ; Check session_byte_a0 ($FF09A0): if it matches the character type (d5), halve the cost
    ; This implements a discount for a special scenario flag (e.g., budget event or season bonus)
    moveq   #$0,d0
    move.b  ($00FF09A0).l, d0      ; d0 = session_byte_a0 ($FF09A0): session-level scenario flag
    ext.l   d0
    moveq   #$0,d1
    move.w  d5, d1                 ; d1 = character type byte
    cmp.l   d1, d0                 ; does session flag match character type?
    bne.b   .l2db58                ; no match: use full cost
    ; Halve the cost-per-point (discount: divide d6 by 2 with rounding)
    moveq   #$0,d0
    move.w  d6, d0
    bge.b   .l2db54
    addq.l  #$1, d0                ; rounding correction for negative (shouldn't happen but compiler pattern)
.l2db54:
    asr.l   #$1, d0                ; d0 = d6 / 2 (halved cost per stat point)
    move.w  d0, d6                 ; d6 = discounted cost-per-stat-point
.l2db58:
    ; d6 now holds cost-per-stat-point. Compute how many points the player can afford:
    ; d3 = player.cash / cost_per_point  (capped at 10)
    move.l  $6(a4), d0             ; d0 = player_record[+$06] = cash (long): player's treasury balance
    moveq   #$0,d1
    move.w  d6, d1                 ; d1 = cost per stat point
    jsr SignedDiv                  ; d0 = cash / cost_per_point = number of points player can buy
    move.w  d0, d3                 ; d3 = affordable stat points (raw, before caps)
    ; Cap d3 at 10 (maximum purchasable stat points per transfer session)
    cmpi.w  #$a, d3
    bcc.b   .l2db74                ; d3 >= 10: use cap
    moveq   #$0,d0
    move.w  d3, d0                 ; d3 < 10: keep as-is
    bra.b   .l2db76
.l2db74:
    moveq   #$A,d0                 ; clamp to 10 (maximum upgrades allowed per session)
.l2db76:
    move.w  d0, d3                 ; d3 = min(affordable, 10) = upgrade point budget
    ; Apply cap 2: can't exceed (10 - current_skill)
    ; a2+$01 = char record +$01 = primary skill/rating stat (0-10 scale)
    moveq   #$0,d0
    move.b  $1(a2), d0             ; d0 = char primary stat (+$01: current skill level)
    moveq   #$A,d1                 ; d1 = 10 (skill maximum)
    sub.l   d0, d1                 ; d1 = 10 - current_skill = remaining headroom to max
    move.l  d1, d0                 ; d0 = remaining headroom
    moveq   #$0,d1
    move.w  d3, d1                 ; d1 = current d3 (budget after cash cap)
    cmp.l   d1, d0                 ; is headroom <= budget?
    ble.b   .l2db92                ; yes: headroom is the binding cap (can't exceed max stat)
    moveq   #$0,d0
    move.w  d3, d0                 ; no: budget < headroom; keep budget as-is
    bra.b   .l2db9e
.l2db92:
    ; Headroom (10 - current_skill) is smaller: use it as the cap
    moveq   #$0,d0
    move.b  $1(a2), d0             ; reload current skill
    moveq   #$A,d1
    sub.l   d0, d1                 ; d1 = 10 - current_skill (headroom to max)
    move.l  d1, d0                 ; d0 = headroom cap
.l2db9e:
    move.w  d0, d3                 ; d3 = min(budget, headroom) = upgrade points after skill-max cap
    ; Apply cap 3: can't exceed ($63 - event_stat - current_skill)
    ; a3+$00 = event_records entry byte = current event/session stat value for this character
    ; $63 = 99 = absolute stat ceiling across all modifiers
    moveq   #$0,d0
    move.b  (a3), d0               ; d0 = event_records byte: session stat (cumulative upgrades this quarter?)
    moveq   #$63,d1                ; d1 = $63 = 99 = absolute stat ceiling
    sub.l   d0, d1                 ; d1 = 99 - session_stat = remaining room under absolute ceiling
    moveq   #$0,d0
    move.b  $1(a2), d0             ; d0 = char primary stat (+$01)
    sub.l   d0, d1                 ; d1 = 99 - session_stat - current_skill = combined headroom
    move.l  d1, d0                 ; d0 = combined headroom
    moveq   #$0,d1
    move.w  d3, d1                 ; d1 = current d3 (budget after previous caps)
    cmp.l   d1, d0                 ; is combined headroom <= budget?
    ble.b   .l2dbc0                ; yes: combined headroom is binding
    moveq   #$0,d0
    move.w  d3, d0                 ; no: keep budget
    bra.b   .l2dbd2
.l2dbc0:
    ; Combined headroom is smaller: use it as final cap
    moveq   #$0,d0
    move.b  (a3), d0               ; reload event_records session stat
    moveq   #$63,d1                ; 99
    sub.l   d0, d1
    moveq   #$0,d0
    move.b  $1(a2), d0             ; reload current skill
    sub.l   d0, d1                 ; d1 = 99 - session_stat - current_skill
    move.l  d1, d0
.l2dbd2:
    move.w  d0, d3                 ; d3 = final affordable upgrade points (triple-capped: cash, skill-max, absolute)
    ; --- Phase: Initial Upgrade Count Dialog ---
    ; Clear a 5-high × $20-wide window at (row=$13=19, col=0) and show the "how many upgrades?" dialog
    move.l  #$8000, -(a7)           ; priority $8000
    pea     ($0005).w               ; height = 5 rows
    pea     ($0020).w               ; width  = $20 = 32 columns
    pea     ($0013).w               ; top    = row $13 = 19
    clr.l   -(a7)                   ; left   = 0
    clr.l   -(a7)                   ; arg    = 0
    pea     ($001A).w               ; GameCommand #$1A = clear tile area
    jsr     (a5)                    ; clear the dialog area before showing upgrade count prompt
    lea     $2c(a7), a7             ; clean up 11 longwords
    ; Select singular ("1 upgrade") vs plural ("N upgrades") format string based on d3
    moveq   #$0,d0
    move.w  d3, d0                  ; d0 = number of available upgrade points
    subq.l  #$1, d0                 ; d0 == 0 means d3 was exactly 1 → singular form
    beq.b   .l2dc04                 ; d3 == 1: use singular "upgrade" string
    pea     ($000446AE).l           ; d3 > 1: ROM ptr to plural "upgrades available" format string
    bra.b   .l2dc0a
.l2dc04:
    pea     ($000446A8).l           ; d3 == 1: ROM ptr to singular "upgrade available" format string
.l2dc0a:
    ; sprintf: format the upgrade-count message into local frame buffer at -$84(a6)
    moveq   #$0,d0
    move.w  d3, d0                  ; d0 = upgrade point count (numeric arg to format string)
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)   ; ROM: printf format string pointer (loaded from ROM pointer table)
    pea     -$84(a6)                ; dest = local frame buffer at -$84 (132-byte string scratch area)
    jsr sprintf                     ; format "You can purchase N upgrade(s)" into local buffer
    ; ShowCharInfoPageS2: display the character info panel with the formatted upgrade count message
    pea     ($0001).w               ; page mode = 1 (show character info page type 1)
    clr.l   -(a7)                   ; arg = 0 (no extra param)
    clr.l   -(a7)                   ; arg = 0
    pea     -$84(a6)                ; ptr to formatted upgrade-count string in local frame buffer
    moveq   #$0,d0
    move.w  d5, d0                  ; d0 = character type (d5 = type byte loaded at startup)
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)     ; display character panel with upgrade-count dialog overlay
    nop
    ; FinalizeTransfer: commit any pending transfer data for this player before input loop
    pea     ($0050).w               ; arg = $50 (transfer type/mode)
    moveq   #$0,d0
    move.w  d4, d0                  ; d0 = player_index
    move.l  d0, -(a7)
    jsr (FinalizeTransfer,PC)       ; finalize pending transfer state before confirmation loop
    nop
    ; --- Phase: Input Confirmation Gate (wait for player to confirm upgrade count) ---
    ; ReadInput loop: spin until player presses a button to confirm the upgrade count
    clr.l   -(a7)                   ; ReadInput mode = 0 (edge-detect: returns nonzero on new press)
    jsr ReadInput                   ; read joypad via GameCommand #10
    lea     $30(a7), a7             ; clean up $30 bytes (all preceding pushes since ShowCharInfoPageS2)
    tst.w   d0                      ; was a button pressed?
    beq.b   .l2dc5c                 ; no: set d2=0 (no confirmation yet)
    moveq   #$1,d2                  ; yes: d2=1 (button seen, proceed to second ReadInput to debounce)
    bra.b   .l2dc5e
.l2dc5c:
    moveq   #$0,d2                  ; d2=0: no button seen, not yet confirmed
.l2dc5e:
    ; Second confirmation stage: if d2==1, wait for button to be released (held-state clear)
    tst.w   d2                      ; is a button being tracked?
    beq.b   .l2dc7e                 ; no: skip to allocation screen
    clr.l   -(a7)                   ; ReadInput mode = 0
    jsr ReadInput                   ; re-read input to check if button is still held
    addq.l  #$4, a7
    tst.w   d0                      ; is button still held?
    beq.b   .l2dc7e                 ; released: proceed to DrawCharPanelS2
    ; Button still held: run a short GameCommand delay and loop back to check again
    pea     ($0003).w               ; delay count = 3 frames
    pea     ($000E).w               ; GameCommand #$E = wait/delay
    jsr     (a5)                    ; GameCommand: short delay before re-polling
    addq.l  #$8, a7
    bra.b   .l2dc5e                 ; loop: keep waiting for button release
.l2dc7e:
    ; --- Phase: DrawCharPanelS2 Interaction Loop ---
    ; Player selects how many stat points to purchase via the interactive character panel
    clr.w   d2                      ; d2 = 0 (reuse as result/flag for this phase)
    ; Call DrawCharPanelS2: interactive UI where player confirms stat allocation count
    ; Returns a result code in d0 encoding the action taken (bit $20 = confirm, bit $10 = cancel)
    moveq   #$0,d0
    move.w  d6, d0                  ; d0 = cost-per-stat-point (salary weight, computed above)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0                  ; d0 = max affordable upgrade points (final capped value)
    move.l  d0, -(a7)
    pea     -$2(a6)                 ; ptr to local -$2: current selected upgrade count (in/out)
    moveq   #$0,d0
    move.w  -$86(a6), d0            ; d0 = group slot index (FindCharSlotInGroup result)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0                  ; d0 = character slot index (original arg)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0                  ; d0 = player_index
    move.l  d0, -(a7)
    jsr (DrawCharPanelS2,PC)        ; display stat-allocation panel; player navigates up/down to set count
    nop
    lea     $18(a7), a7             ; clean up 6 longwords
    move.w  d0, -$4(a6)            ; local -$4: save DrawCharPanelS2 result code
    ; Check bit $20 of result: if set, player confirmed purchase (pressed OK/A)
    andi.w  #$20, d0                ; test confirmation bit ($20 = player pressed confirm)
    beq.w   .l2ddce                 ; not set: check cancel bit ($10) instead
    ; --- Phase: Confirm Purchase Sub-Loop (bit $20 set: player pressed OK) ---
    ; Clear the confirmation area and display the cost summary ("cost N × $M = total")
    move.l  #$8000, -(a7)           ; priority $8000
    pea     ($0002).w               ; height = 2
    pea     ($000E).w               ; width  = $E = 14
    pea     ($0016).w               ; top    = row $16 = 22
    pea     ($0012).w               ; left   = col $12 = 18
    clr.l   -(a7)                   ; arg = 0
    pea     ($001A).w               ; GameCommand #$1A = clear tile area
    jsr     (a5)                    ; clear the cost confirmation area
    ; Compute total cost = cost_per_point * upgrade_count
    moveq   #$0,d0
    move.w  d6, d0                  ; d0 = cost-per-stat-point (d6)
    moveq   #$0,d1
    move.w  -$2(a6), d1            ; d1 = selected upgrade count (from local -$2, updated by DrawCharPanelS2)
    jsr Multiply32                  ; d0 = total cost = cost_per_point * upgrade_count
    move.l  d0, -(a7)              ; push total cost for sprintf
    ; Select "1 upgrade" vs "N upgrades" plural for cost confirmation string
    moveq   #$0,d0
    move.w  -$2(a6), d0            ; d0 = selected upgrade count
    subq.l  #$1, d0                ; d0 == 0 → count was 1 → singular
    beq.b   .l2dcfc                 ; exactly 1: use singular confirmation string
    pea     ($000446A0).l           ; ROM: "N upgrades for $M" (plural) format string
    bra.b   .l2dd02
.l2dcfc:
    pea     ($0004469A).l           ; ROM: "1 upgrade for $M" (singular) format string
.l2dd02:
    moveq   #$0,d0
    move.w  -$2(a6), d0            ; d0 = selected upgrade count (numeric arg)
    move.l  d0, -(a7)
    move.l  ($0004848E).l, -(a7)   ; ROM: secondary format string ptr from pointer table at $4848E
    pea     -$84(a6)                ; dest = local frame string buffer
    jsr sprintf                     ; format the cost confirmation message into local buffer
    lea     $30(a7), a7             ; clean up 12 longwords
    ; ShowCharInfoPageS2: display confirmation dialog with cost summary
    clr.l   -(a7)                   ; arg = 0
    pea     ($0001).w               ; page mode = 1 (yes/no confirmation overlay)
    clr.l   -(a7)                   ; arg = 0
    pea     -$84(a6)                ; formatted cost string ptr
    moveq   #$0,d0
    move.w  d5, d0                  ; d0 = character type
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)     ; show confirmation: "Purchase N upgrades for $M? YES / NO"
    nop
    lea     $14(a7), a7             ; clean up 5 longwords
    move.w  d0, -$4(a6)            ; save confirmation result code
    ; Result == 1: player chose YES → commit the purchase
    cmpi.w  #$1, -$4(a6)
    bne.b   .l2dd7c                 ; not YES: check for NO or back
    ; --- Apply the stat upgrade and deduct cost ---
    ; Deduct total cost from player cash: player_record[+$06] -= cost_per_point * upgrade_count
    moveq   #$0,d0
    move.w  d6, d0                  ; cost-per-point
    moveq   #$0,d1
    move.w  -$2(a6), d1            ; selected upgrade count
    jsr Multiply32                  ; d0 = total cost
    sub.l   d0, $6(a4)             ; player_record[+$06] (cash) -= total cost; player pays for upgrades
    ; Update character record fields to reflect the stat upgrade
    move.b  d7, (a2)               ; char record [+$00] = character slot index (identifier/type confirm)
    move.b  -$1(a6), d0            ; d0 = local -$1 byte: upgrade delta (set by DrawCharPanelS2 output)
    add.b   d0, $1(a2)             ; char record [+$01] += upgrade delta (primary skill stat increases)
    move.b  #$1, $2(a2)            ; char record [+$02] = 1: transfer/applied flag (marks upgrade as applied)
    ; Prepare to display the purchase success / completion screen
    pea     ($0001).w               ; arg = 1 (success mode)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048492).l, -(a7)   ; ROM: success/completion format string ptr from pointer table $48492
    bra.w   .l2de0a                 ; jump to final ShowCharInfoPageS2 and exit sequence
.l2dd7c:
    ; Result != 1: check if it's 0 (back to allocation screen) or something else
    tst.w   -$4(a6)
    bne.w   .l2dc5e                 ; non-zero (but not 1 = YES): player hit back → loop back to DrawCharPanelS2
    ; Result == 0: player chose NO or cancelled the confirmation → regenerate the initial prompt
    ; Reformat the initial "N upgrades available" message and show it again
    moveq   #$0,d0
    move.w  d3, d0                  ; d0 = total available upgrades (d3 from triple-capped calculation)
    subq.l  #$1, d0                 ; test for singular
    beq.b   .l2dd94
    pea     ($00044692).l           ; ROM: plural "N upgrades available" format (re-show initial prompt)
    bra.b   .l2dd9a
.l2dd94:
    pea     ($0004468C).l           ; ROM: singular "1 upgrade available" format
.l2dd9a:
    moveq   #$0,d0
    move.w  d3, d0                  ; d0 = total available upgrade count
    move.l  d0, -(a7)
    move.l  ($0004848A).l, -(a7)   ; ROM: initial-prompt format string ptr (same as startup)
    pea     -$84(a6)                ; local frame string buffer
    jsr sprintf                     ; re-format the initial upgrade-count message
    ; Re-show the character info page with the initial prompt (no-confirm args)
    clr.l   -(a7)                   ; arg = 0 (no confirm overlay)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$84(a6)                ; re-formatted string
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)     ; redisplay the initial upgrade-count info panel
    nop
    lea     $24(a7), a7             ; clean up 9 longwords
    bra.w   .l2dc5e                 ; loop back to DrawCharPanelS2 for another allocation attempt
.l2ddce:
    ; --- Phase: Cancel Branch (bit $10: player cancelled without confirming) ---
    ; DrawCharPanelS2 result bit $10 = player pressed cancel/B to back out entirely
    move.w  -$4(a6), d0            ; reload DrawCharPanelS2 result code
    andi.w  #$10, d0               ; test cancel bit ($10)
    beq.w   .l2dc5e                ; neither confirm nor cancel: loop back to DrawCharPanelS2
    ; Player pressed cancel: clear the confirmation area and show the cancel/abort message
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000E).w
    pea     ($0016).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                   ; GameCommand #$1A: clear confirmation tile area
    lea     $1c(a7), a7            ; clean up 7 longwords
    ; Push the cancel message args for ShowCharInfoPageS2
    pea     ($0001).w               ; page mode = 1
    clr.l   -(a7)                   ; arg = 0
    clr.l   -(a7)                   ; arg = 0 (no formatted string: use ROM default cancel message)
    move.l  ($00048496).l, -(a7)   ; ROM: "Transaction cancelled" or equivalent string ptr from table $48496
    ; --- Phase: Final Display and Exit (shared by both purchase-success and cancel paths) ---
.l2de0a:
    ; ShowCharInfoPageS2: display the outcome (success or cancel) and wait for acknowledgement
    moveq   #$0,d0
    move.w  d5, d0                  ; d0 = character type
    move.l  d0, -(a7)
    jsr (ShowCharInfoPageS2,PC)     ; show the outcome screen (purchase result or cancel notice)
    nop
    ; Clear the main content area (7-high × $20-wide from row $14) — wipe the stat panel
    move.l  #$8000, -(a7)
    pea     ($0007).w               ; height = 7
    pea     ($0020).w               ; width  = $20 = 32
    pea     ($0014).w               ; top    = row $14 = 20
    clr.l   -(a7)                   ; left   = 0
    clr.l   -(a7)
    pea     ($001A).w               ; GameCommand #$1A = clear tile area
    jsr     (a5)                    ; wipe the stat-allocation panel area
    lea     $30(a7), a7             ; clean up 12 longwords
    ; Clear again with different args (confirms the clear spans the right region — compiler double-clear)
    move.l  #$8000, -(a7)
    pea     ($0007).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w               ; left = 1 (slightly offset from previous clear for border alignment)
    pea     ($001A).w
    jsr     (a5)                    ; second clear pass for border/overlap region
    ; GameCommand #$10: full screen clear (return to blank state after stat management)
    pea     ($0040).w               ; priority $40
    clr.l   -(a7)
    pea     ($0010).w               ; GameCommand #$10 = clear screen
    jsr     (a5)
    ; --- Epilogue ---
    movem.l -$b0(a6), d2-d7/a2-a5  ; restore saved registers (offset: -$88 frame - $28 movem save = -$B0)
    unlk    a6
    rts
