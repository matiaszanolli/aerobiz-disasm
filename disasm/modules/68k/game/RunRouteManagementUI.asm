; ============================================================================
; RunRouteManagementUI -- Runs the route management UI; calls SelectCharRelation to build available slots, then loops on directional input to scroll char-relation pairs and update sprite and text panel.
; 666 bytes | $01325C-$0134F5
; ============================================================================
RunRouteManagementUI:
; --- Phase: Setup ---
; Args: $8(a6)=player_index, $C(a6)=relation_type, $10(a6)=unused, $14(a6)=data_ptr, $12(a6)=dialog_id
; Returns: D0.W = selected relation index (d2) on A-button confirm, or $FF on cancel
; d3=player_index, d5=redraw_flag, d6=relation_type, d7=last_raw_input
; a2=data_ptr (caller-supplied list pointer), a3=$FF13FC (input_mode_flag)
; a4=$479AE (ROM format string table pointer), a5=local text buffer (stack frame)
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3           ; d3 = player_index (0-3)
    move.l  $c(a6), d6           ; d6 = relation_type (category to display)
    movea.l $14(a6), a2          ; a2 = caller-supplied data list pointer
    movea.l  #$00FF13FC,a3       ; a3 -> input_mode_flag (nonzero = UI countdown active)
    movea.l  #$000479AE,a4       ; a4 -> ROM string/format table for relation display
    lea     -$b6(a6), a5         ; a5 -> local stack buffer for sprintf output

; --- Phase: Build Relation List ---
; Load graphics resources and build the available char-relation pair list
    jsr ResourceLoad             ; load graphics resource for this screen
    jsr ClearTileArea            ; clear the tile area before drawing
; SelectCharRelation: scan route/assignment tables and populate the relation list
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (SelectCharRelation,PC)  ; build list of char-relation pairs for player d3, type d6
    nop
    jsr ResourceUnload           ; release temporary graphics resource

; --- Phase: Initial Display Setup ---
    moveq   #$1,d5               ; d5 = redraw_flag (draw on first iteration)
    move.w  #$ff, d2             ; d2 = current selection index ($FF = none selected yet)
; UpdateSpritePos: place character sprite at the initial position (index 0)
    move.l  a2, -(a7)
    clr.l   -(a7)                ; initial sprite position = 0
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateSpritePos,PC)     ; place char sprite at starting screen position
    nop
    lea     $18(a7), a7
; TilePlacement: place the cursor tile at the initial position
; $0544 = cursor tile index; row = (d2 * $10) + $30, col 2, layer 1
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0              ; d2 * $10 (16 pixels per row entry)
    addi.l  #$30, d0             ; +$30 base row offset
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w            ; tile $544 = selection cursor tile
    jsr TilePlacement
; GameCommand #$E: trigger display update
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand              ; flush tile buffer to display
; Sample input to detect any pre-held button
    clr.l   -(a7)
    jsr ReadInput
    lea     $28(a7), a7
    tst.w   d0
    beq.b   l_1330e
    moveq   #$1,d0               ; button already held: set skip-wait flag
    bra.b   l_13310
l_1330e:
    moveq   #$0,d0               ; no held button
l_13310:
    move.w  d0, -$2(a6)         ; -$2(a6) = "drain input" flag
    clr.w   d7                   ; d7 = last raw direction bits
    clr.w   (a3)                 ; input_mode_flag ($FF13FC) = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag ($FFA7D8) = 0
    clr.w   d2                   ; d2 = current selection index (starts at 0)

; --- Phase: Main Interaction Loop ---
l_13320:
; If redraw_flag is set, show the text panel for the currently selected relation
    tst.w   d5                   ; redraw needed?
    beq.b   l_13348
; ShowTextDialog: display the relation info panel for the current selection
; $12(a6)=dialog_id, $1c(a4)=default format string, d3=player_index
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)            ; dialog variant ID
    move.l  $1c(a4), -(a7)       ; default format string pointer from table
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    jsr ShowTextDialog           ; render the text panel for selected relation
    lea     $18(a7), a7
    clr.w   d5                   ; clear redraw flag

l_13348:
; If drain-input flag set, read one input to flush any held button state
    tst.w   -$2(a6)
    beq.b   l_1335c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_13320              ; still held: loop back without polling

l_1335c:
    clr.w   -$2(a6)
; ProcessInputLoop: poll input with $A-frame timeout; mask to directional + A/B bits
; $33 = bits 0,1,4,5 (up/down/B/A)
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000A).w            ; timeout = $A frames
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0             ; mask: $20=A, $10=B, $02=down, $01=up
    move.w  d0, d7               ; save for next poll cycle
    ext.l   d0

; Dispatch on direction/button bits
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_1339a              ; A button pressed: confirm selection

    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1343c              ; B button pressed: cancel (return $FF)

    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1344a              ; up: cycle backward through relations (mod 3)

    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_134c4              ; down: cycle forward through relations (mod 3)

    bra.w   l_134d0              ; no input: idle tick

; --- Phase: A Button - Confirm Selection ---
l_1339a:
    clr.w   (a3)                 ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
; Check route slot table at $FF9A10 (word per relation, stride 4) for this selection
; If the value is > 0, the slot is filled and we can act on it
    move.w  d2, d0
    lsl.w   #$2, d0              ; d0 = d2*4 (stride-4 table index)
    movea.l  #$00FF9A10,a0
    tst.w   (a0,d0.w)            ; is this relation slot non-empty (has a value)?
    ble.b   l_1342a              ; <= 0: no associated sprite, use fallback format

; FindSpriteByID: look up sprite record for the current relation entry
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)            ; relation index
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)            ; relation_type
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    jsr (FindSpriteByID,PC)      ; find sprite associated with this relation entry
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_133e8              ; sprite found: format with name

; No sprite: clear sprites and return with selection = d2
l_133d2:
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16                ; GameCmd16 (mode 1, param 2): clear char sprite
    addq.l  #$8, a7
    move.w  d2, d0
    bra.w   l_134ec              ; exit: return d2

; Sprite found: format the relation text using found sprite's string + base format
l_133e8:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0              ; d0 = d2*4 (stride into format table)
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7) ; format argument: string pointer for this relation entry
    move.l  $4(a4), -(a7)        ; base format string from ROM table $479AE+$4

l_133f8:
; sprintf into local stack buffer a5; then ShowTextDialog with the formatted result
    move.l  a5, -(a7)            ; destination buffer
    jsr sprintf                  ; format relation name string into a5
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)            ; dialog variant ID
    move.l  a5, -(a7)            ; formatted string pointer
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    jsr ShowTextDialog           ; display formatted relation info panel
    lea     $24(a7), a7
    moveq   #$1,d5               ; set redraw flag for next iteration
    bra.w   l_134d8

; Empty slot: use fallback format string ($18(a4)) instead of named entry
l_1342a:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7) ; same entry argument
    move.l  $18(a4), -(a7)       ; fallback format string (empty slot display)
    bra.b   l_133f8

; --- Phase: B Button - Cancel ---
l_1343c:
    clr.w   (a3)                 ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0
    move.w  #$ff, d2             ; d2 = $FF (cancel sentinel)
    bra.b   l_133d2              ; clear sprite and exit

; --- Phase: Up - Cycle Backward (mod 3) ---
l_1344a:
    move.w  #$1, (a3)            ; input_mode_flag = 1 (activate input countdown)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0              ; d0 = (d2+2) before mod
l_13454:
; Compute new selection: (d0) mod 3 -> cycles through indices 0,1,2 wrapping
    moveq   #$3,d1
    jsr SignedMod                ; d0 = d0 mod 3
    move.w  d0, d2               ; d2 = new selection index (0-2)
; Special case: index 1 maps sprite position to 3 (display quirk)
    cmpi.w  #$1, d2
    bne.b   l_13468
    moveq   #$3,d4               ; d4 = display position 3 when selection=1
    bra.b   l_1346a
l_13468:
    move.w  d2, d4               ; d4 = d2 (display position matches selection)

l_1346a:
; TilePlacement: move cursor tile to new selection's screen position
; row = (d2 * $10) + $20, col 2, layer 1
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0              ; d2 * $10
    addi.l  #$20, d0             ; +$20 base row (different from initial $30)
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w            ; cursor tile $544
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand              ; flush display
    lea     $24(a7), a7
; UpdateSpritePos: reposition the char sprite to match new selection
    move.l  a2, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)            ; display position (d4)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)            ; relation_type
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)            ; player_index
    jsr (UpdateSpritePos,PC)     ; update sprite screen position
    nop
    lea     $10(a7), a7
    bra.b   l_134d8

; --- Phase: Down - Cycle Forward (mod 3) ---
l_134c4:
    move.w  #$1, (a3)            ; input_mode_flag = 1
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0              ; d0 = d2+1 (forward step)
    bra.b   l_13454              ; same mod-3 logic as Up path

; --- Phase: No Input / Idle Tick ---
l_134d0:
    clr.w   (a3)                 ; input_mode_flag = 0 (no active direction)
    clr.w   ($00FFA7D8).l        ; input_init_flag = 0

l_134d8:
; GameCommand #$E mode 3: standard per-frame display/logic tick
    pea     ($0003).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_13320              ; continue main loop

; --- Phase: Return ---
l_134ec:
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts
