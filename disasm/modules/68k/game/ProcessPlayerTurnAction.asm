; ============================================================================
; ProcessPlayerTurnAction -- Handle one player turn action: load screen, show char info, evaluate value, confirm purchase and deduct cost
; 808 bytes | $00D764-$00DA8B
; ============================================================================
; Arguments: 8(a6) = player_index (d4), $C(a6) = route_slot_index (d5), $12(a6) = screen_id word
; A4 -> player record ($FF0018 + player_index * $24): used to check/deduct cash
; A3 -> route-slot display entry ($FF0338 + player_index*$20 + slot_index*$08): written on purchase
; -$88(a6) = purchase_flag: 0 = nothing bought, 1 = purchase confirmed
; -$4(a6) = char_value: computed cost of selected character (longword)
; -$86(a6) = sprintf output buffer (134 bytes)
ProcessPlayerTurnAction:
    link    a6,#-$88
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d4          ; d4 = player_index (0-3)
    move.l  $c(a6), d5          ; d5 = route_slot_index (0-3)
    lea     $12(a6), a5         ; a5 -> screen_id word on caller's frame
    clr.w   -$88(a6)            ; purchase_flag = 0 (no purchase yet)
; --- Phase: Setup player and slot pointers ---
; Compute pointer to this player's record: $FF0018 + player_index * $24
    move.w  d4, d0
    mulu.w  #$24, d0            ; player_index * 36 (player_record stride)
    movea.l  #$00FF0018,a0      ; player_records base
    lea     (a0,d0.w), a0
    movea.l a0, a4              ; a4 -> player_record[player_index]
; Compute pointer to route-slot display entry in $FF0338 working table:
; offset = player_index * $20 + slot_index * $08
    move.w  d4, d0
    lsl.w   #$5, d0             ; player_index * 32
    move.w  d5, d1
    lsl.w   #$3, d1             ; slot_index * 8
    add.w   d1, d0
    movea.l  #$00FF0338,a0      ; route-slot display table base
    lea     (a0,d0.w), a0
    movea.l a0, a3              ; a3 -> slot display entry for (player, slot)
; --- Phase: Initial screen setup ---
    jsr ResourceLoad             ; load display resources
; GameCommand #$1A: draw the main action dialog box
; tile=$077E (standard dialog frame), at col=$02, row=$13, w=$1C, h=$06, priority=$01
    pea     ($077E).w           ; dialog background tile (framed box)
    pea     ($0006).w           ; height = 6 rows
    pea     ($001C).w           ; width  = 28 columns
    pea     ($0013).w           ; top row = 19
    pea     ($0002).w           ; left column = 2
    pea     ($0001).w           ; priority flag = 1
    pea     ($001A).w           ; GameCommand #$1A = DrawBox
    jsr GameCommand
; Load and show the route slot screen
    pea     ($0001).w
    move.w  (a5), d0            ; screen_id from caller's stack frame
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen               ; load city/route screen (screen_id, player_index)
    lea     $28(a7), a7
; Show the character relation panel for this slot context (mode 2)
    pea     ($0002).w
    move.w  (a5), d0            ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel             ; display character affinities/relations for context
    lea     $c(a7), a7
    bra.w   l_0da52             ; jump to destination select entry point
; --- Phase: SelectRouteDestination returned a valid choice ---
; d2 = selected char/destination index; d7 = first-iteration flag (1 on first pass)
l_0d804:
    moveq   #$1,d7              ; d7 = 1 = first pass (no prior selection made this turn)
    clr.w   d3                  ; d3 = sub-index within chosen row
    bra.w   l_0d9d2             ; jump to DisplayRouteDestChoice call
; --- Phase: Inner selection loop body ---
; d2 = selection row, d3 = column within row
l_0d80c:
    clr.w   d7                  ; d7 = 0 = not first pass
; Determine which char lookup table to use based on row:
; d2 < $20 = domestic/local char table at $FF0420/$FF1704 (stride 6)
; d2 >= $20 = international/alliance char table at $FF0460/$FF15A0 (stride 4)
    cmpi.w  #$20, d2
    bge.b   l_0d83c             ; >= $20 = international table
; --- Domestic character table ---
; $FF1704: byte array of char IDs, stride 6 per row
; $FF0420: corresponding char stat records
    move.w  d2, d0
    mulu.w  #$6, d0             ; row * 6 (stride for domestic table)
    add.w   d3, d0              ; + column offset
    movea.l  #$00FF1704,a0      ; domestic char ID table
    move.b  (a0,d0.w), d6       ; d6 = char ID byte
    andi.l  #$ff, d6
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d3, d0
    movea.l  #$00FF0420,a0      ; domestic char stat record base
    bra.b   l_0d85e
; --- International/alliance character table ---
; $FF15A0: byte array of char IDs, stride 4 per row
; $FF0460: corresponding char stat records
l_0d83c:
    move.w  d2, d0
    lsl.w   #$2, d0             ; row * 4 (stride for international table)
    add.w   d3, d0              ; + column offset
    movea.l  #$00FF15A0,a0      ; international char ID table
    move.b  (a0,d0.w), d6       ; d6 = char ID byte
    andi.l  #$ff, d6
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d3, d0
    movea.l  #$00FF0460,a0      ; international char stat record base
l_0d85e:
    lea     (a0,d0.w), a0
    movea.l a0, a2              ; a2 -> char stat record for this selection
; --- Phase: Evaluate character value and check player can afford it ---
; CalcCharValue: computes cost of character d6 for player d4 in slot d2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)           ; char_id
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)           ; row/slot index
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)           ; player_index
    jsr (CalcCharValue,PC)       ; returns longword cost in d0
    nop
    lea     $c(a7), a7
    move.l  d0, -$4(a6)         ; store char_value cost
; Compare char_value against player cash (player_record+$06 = cash longword, DATA_STRUCTURES.md)
    move.l  $6(a4), d0          ; d0 = player_record.cash
    cmp.l   -$4(a6), d0         ; can player afford this character?
    blt.w   l_0d9ae             ; cash < cost: show "can't afford" dialog
; --- Phase: Player can afford -- show confirm purchase dialog ---
; Format "Purchase <char_name> for <cost>?" string
    move.w  d6, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0      ; ROM char name pointer table
    move.l  (a0,d0.w), -(a7)   ; char name string pointer
    move.l  ($00047798).l, -(a7) ; "purchase confirm" format string pointer from ROM
    pea     -$86(a6)            ; sprintf output buffer (134 bytes on frame)
    jsr sprintf
; ShowTextDialog: display formatted confirm dialog; returns 1 = Yes, 0 = No
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.w  d5, d0              ; route_slot_index (used as dialog context)
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$86(a6)            ; formatted "buy?" string
    move.w  d4, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
    cmpi.w  #$1, d0             ; did player say Yes?
    bne.w   l_0d9d2             ; No -- loop back to destination choice
; --- Phase: Purchase confirmed -- deduct cost and update records ---
; Deduct char cost from player cash: player_record.cash -= char_value
    move.l  -$4(a6), d0         ; char_value
    sub.l   d0, $6(a4)          ; player_record+$06 (cash) -= char_value
; Write the newly hired character into the route-slot display entry ($FF0338):
; a3 -> slot entry; format: [city_a, type=5, sub_index, sub_category, ticket_price...]
    move.b  #$5, $1(a3)         ; slot entry[1] = type 5 = "hired character" slot type
    move.b  d2, (a3)            ; slot entry[0] = selection row (city_a / char row)
    move.b  d3, $2(a3)          ; slot entry[2] = column / sub-index (d3)
    move.b  #$1, $3(a3)         ; slot entry[3] = 1 = active/confirmed
; Mark char stat record as owned by this player: set high bit of first byte
; High bit ($80) encodes player ownership in the char stat record
    move.b  d4, d0              ; player_index
    ori.b   #$80, d0            ; set bit 7: player N owns this char
    move.b  d0, (a2)            ; write to char stat record byte 0 (ownership+player field)
; Clear sprite layers and reset display
    pea     ($0001).w
    clr.l   -(a7)
    jsr GameCmd16               ; GameCommand #$16: clear sprite layer 1
    pea     ($000A).w
    pea     ($000A).w
    jsr GameCmd16               ; GameCommand #$16: clear sprite layer $0A
    pea     ($000A).w
    pea     ($0028).w
    jsr GameCmd16               ; GameCommand #$16: clear sprite layer $28
    lea     $18(a7), a7
; Redraw the action box at a new position (priority=$8000 = high priority layer)
; GameCommand #$1A: draw box (col=$00, row=$00, w=$20, h=$0A, tile=$8000)
    move.l  #$8000, -(a7)       ; high-priority tile flag
    pea     ($000A).w           ; height = $0A rows
    pea     ($0020).w           ; width  = $20 columns
    pea     ($0005).w           ; top row = 5
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
; Same box again with priority=1 (normal layer) -- creates double-layer box frame
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0005).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
; Load the "purchase confirmed" compressed graphic (index $15=21, at row=$0A, col=$05)
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0015).w
    jsr LoadCompressedGfx        ; decompress and place confirmation graphic
    lea     $28(a7), a7
; Show "Hired!" or "Confirmed!" result dialog
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0              ; route_slot_index
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004779C).l, -(a7) ; "confirmed" message format pointer from ROM
    move.w  d4, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog           ; show confirmation result message
    lea     $18(a7), a7
    move.w  #$1, -$88(a6)       ; purchase_flag = 1 (purchase completed)
    bra.b   l_0da04             ; jump to post-purchase screen reload
; --- Phase: Cannot afford -- show insufficient funds dialog ---
l_0d9ae:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047794).l, -(a7) ; "insufficient funds" message format pointer from ROM
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog           ; inform player they cannot afford this character
    lea     $18(a7), a7
; --- Phase: DisplayRouteDestChoice call ---
; Returns next selection row in d0 ($FF = cancel/done)
l_0d9d2:
    move.w  d3, d0              ; current column offset
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0              ; first-pass flag
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0              ; current row selection
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0              ; route_slot_index
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DisplayRouteDestChoice,PC)  ; interactive destination/char picker; returns row index or $FF
    nop
    lea     $14(a7), a7
    move.w  d0, d3              ; d3 = returned selection row
    cmpi.w  #$ff, d0            ; $FF = user cancelled or done
    bne.w   l_0d80c             ; not done -- process the selection
; --- Phase: Post-action screen restore ---
l_0da04:
    jsr ResourceLoad
    jsr PreLoopInit
; Reload the route slot screen to reflect the (potentially updated) state
    pea     ($0001).w
    move.w  (a5), d0            ; screen_id
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0              ; player_index
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen               ; reload the slot display screen
    lea     $c(a7), a7
; If purchase was just made, skip re-showing the relation panel (screen already updated)
    tst.w   -$88(a6)            ; purchase_flag set?
    bne.b   l_0da4a             ; yes -- skip ShowRelPanel
    pea     ($0002).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel             ; re-show relation panel (no purchase was made)
    lea     $c(a7), a7
l_0da4a:
    cmpi.w  #$1, -$88(a6)       ; was a purchase made this turn?
    beq.b   l_0da78             ; yes -- skip re-entering destination select, go to exit
; --- Phase: SelectRouteDestination loop entry ---
; Unload resources, call SelectRouteDestination; loop until $FF (cancel) or until purchase
l_0da52:
    jsr ResourceUnload           ; release display resources before showing destination picker
    pea     $12(a6)             ; pointer to screen_id word (updated by SelectRouteDestination)
    move.w  d5, d0              ; route_slot_index
    move.l  d0, -(a7)
    move.w  d4, d0              ; player_index
    move.l  d0, -(a7)
    jsr (SelectRouteDestination,PC)  ; run the route/destination selection UI; updates screen_id
    nop
    lea     $c(a7), a7
    move.w  d0, d2              ; d2 = returned selection row
    cmpi.w  #$ff, d0            ; $FF = user cancelled
    bne.w   l_0d804             ; valid selection -- enter per-char evaluation loop
; --- Phase: Return ---
l_0da78:
; Write the final screen_id back to the canonical $FF9A1C (screen_id RAM variable)
; screen_id ($FF9A1C) = word: current screen/scenario index; drives scene transitions
    move.w  (a5), ($00FF9A1C).l ; store screen_id into screen_id RAM variable
    move.w  -$88(a6), d0        ; return purchase_flag: 0 = no purchase, 1 = purchased
    movem.l -$b0(a6), d2-d7/a2-a5
    unlk    a6
    rts
