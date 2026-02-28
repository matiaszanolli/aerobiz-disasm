; ============================================================================
; RunPortfolioManagement -- Reset player records, display portfolio options menu, handle cursor navigation and player count confirmation
; 742 bytes | $00AA1C-$00AD01
; ============================================================================
; No arguments passed on stack. Uses global RAM state.
; A3 = GameCommand entry ($0D64)
; A4 = -$20(a6): local display/state buffer (32 bytes, used for TilePlacement highlight data)
; A5 = $FF13FC (input_mode_flag): countdown-mode gate flag
; d3 = currently highlighted player count option (1-4, cursor position)
; d4 = previously highlighted option (tracks change for cursor redraw)
; d5 = accumulated input word from ProcessInputLoop
; Returns: d0 = purchase_type (0=none, 1=confirmed), stored in $FF0A34 ui_active_flag
RunPortfolioManagement:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00000D64,a3      ; a3 = GameCommand entry point
    lea     -$20(a6), a4        ; a4 = local state buffer (32 bytes)
    movea.l  #$00FF13FC,a5      ; a5 = input_mode_flag ($FF13FC): nonzero = UI input mode active
; --- Phase: Reset all 4 player records to inactive state ---
; Clear active_flag (+$00 = 0 = inactive) and set hub_city (+$01 = $FF = no hub) for all 4 players
    movea.l  #$00FF0018,a2      ; player_records base
    clr.w   d2                  ; player index
.l0aa3c:
    clr.b   (a2)                ; player_record+$00 = active_flag = 0 (player inactive)
    move.b  #$ff, $1(a2)        ; player_record+$01 = hub_city = $FF (no hub city assigned)
    moveq   #$24,d0
    adda.l  d0, a2              ; advance to next player_record (36 bytes/record)
    addq.w  #$1, d2
    cmpi.w  #$4, d2             ; cleared all 4 players?
    blt.b   .l0aa3c
; --- Phase: Display portfolio selection screen ---
; GameCommand #$1A: clear full-screen area (priority=$8000, 17 rows × 32 cols at row 0)
    move.l  #$8000, -(a7)       ; high-priority tile
    pea     ($0011).w           ; height = $11 = 17 rows
    pea     ($0020).w           ; width  = $20 = 32 columns
    clr.l   -(a7)               ; top row = 0
    clr.l   -(a7)               ; left col = 0
    clr.l   -(a7)
    pea     ($001A).w           ; GameCommand #$1A = DrawBox / clear area
    jsr     (a3)
; Load portfolio background tiles: $76A5E = ROM data, $30 tiles to VRAM at index $10
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l       ; ROM tileset address for portfolio screen background
    jsr DisplaySetup             ; DMA tileset to VRAM
; Decompress and place the portfolio panel graphic
; $A1B0C = ROM longword pointer to LZ-compressed portfolio panel tiles
    move.l  ($000A1B0C).l, -(a7) ; LZ-compressed source pointer (indirected via ROM table)
    pea     ($00FF1804).l       ; output buffer = save_buf_base ($FF1804)
    jsr LZ_Decompress            ; decompress portfolio panel tiles to $FF1804
    lea     $30(a7), a7
; CmdPlaceTile: place the decompressed tile at pixel (x=$010F, y=$55) in VRAM
    pea     ($0055).w           ; y position = $55
    pea     ($010F).w           ; x position = $010F
    pea     ($00FF1804).l       ; tile data source (decompressed)
    jsr CmdPlaceTile             ; render portfolio panel graphic to screen
; GameCommand #$1B: stamp tile data block from ROM $71D24
; (col=$00, row=$02, w=$07, h=$12, plane=$0F) = draws option list frame
    pea     ($00071D24).l       ; ROM tile block for portfolio menu frame
    pea     ($000F).w           ; height = $0F = 15
    pea     ($0012).w           ; width  = $12 = 18
    pea     ($0002).w           ; top row = 2
    pea     ($0007).w           ; left col = 7
    clr.l   -(a7)
    pea     ($001B).w           ; GameCommand #$1B = place tile block
    jsr     (a3)
    lea     $28(a7), a7
; Display a message using the format string at $3E578 (player count prompt)
; DisplayMessageWithParams: 5 args (all zero except format ptr = no variables)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003E578).l       ; ROM format string: "Select number of players" (or similar)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
; Read input to detect player 2 presence (ReadInput mode 0)
    clr.l   -(a7)               ; mode = 0
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0aaf2
    moveq   #$1,d2              ; d2 = 1: two-player input mode detected
    bra.b   .l0aaf4
.l0aaf2:
    moveq   #$0,d2              ; d2 = 0: single-player only
; --- Phase: Initialise cursor state ---
.l0aaf4:
    clr.w   d5                  ; d5 = accumulated input word (last ProcessInputLoop result)
    clr.w   (a5)                ; input_mode_flag ($FF13FC) = 0
    clr.w   ($00FFA7D8).l       ; input_init_flag ($FFA7D8) = 0: reset input state machine
    moveq   #$1,d3              ; d3 = current cursor position (1 = "1 player" option)
    clr.w   d4                  ; d4 = previous cursor position (0 = no prior highlight)
; --- Phase: Cursor render loop ---
; Each option row: render an unselected tile at x=(d3*$10 + $30), y=$48
; Tile $0544 = unselected option tile; $0546/$0548 = selected/highlighted variants
.l0ab02:
; Render the current cursor tile at the row corresponding to d3 (player count 1-4)
; x pixel = d3 * $10 + $30 (each option is $10=16 pixels apart, base at $30)
    clr.l   -(a7)
    pea     ($0002).w           ; palette index 2
    pea     ($0001).w           ; height = 1
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0             ; d3 * 16
    addi.l  #$30, d0            ; + $30 base offset
    move.l  d0, -(a7)           ; x pixel position for this option row
    pea     ($0048).w           ; y pixel = $48 (option column x-coordinate)
    pea     ($0002).w           ; width = 2
    pea     ($0544).w           ; tile $0544 = unselected option marker
    jsr TilePlacement            ; render the option tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)                 ; GameCommand #$E = display sync
    lea     $24(a7), a7
; Check if cursor position changed (d4 != d3 and d4 not special) to trigger highlight update
    tst.w   d4                  ; d4 == 0 means no prior selection (first iteration)
    bne.b   .l0ab44
    cmpi.w  #$4, d4             ; d4 == 4 means "confirmed/done" state
    beq.b   .l0ab9a
.l0ab44:
    cmp.w   d3, d4              ; has cursor moved?
    beq.b   .l0ab9a             ; same position: skip highlight update
; Cursor moved: update the local highlight data array at a4+$12
; a4+$12 = local display buffer: 5 words, one per option slot (1-5 rows)
; Write $40 (default dim) to all 5 slots, then $60 (bright) to the current selection
    move.w  #$40, $12(a4)       ; row 1 = dim
    move.w  #$40, $14(a4)       ; row 2 = dim
    move.w  #$40, $16(a4)       ; row 3 = dim
    move.w  #$40, $18(a4)       ; row 4 = dim
    move.w  #$40, $1a(a4)       ; row 5 = dim
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0              ; d3 * 2 (word stride into highlight array)
    movea.l d0, a0
    move.w  #$60, $12(a4, a0.l) ; current row = $60 (bright/selected)
; DisplaySetup: update the palette/brightness display for the 5 option rows
    pea     ($0005).w           ; 5 entries
    pea     ($0039).w           ; VRAM destination index
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0
    move.l  d0, -(a7)           ; source = a4+$12 (the brightness word array)
    jsr DisplaySetup             ; DMA the brightness values to VRAM palette
    move.w  d3, d4              ; update d4 = previous cursor position
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)                 ; GameCommand #$E: display sync after palette update
    lea     $14(a7), a7
; Check 2P input (if d2==1) -- if P2 presses anything, redraw cursor and loop
.l0ab9a:
    tst.w   d2                  ; two-player mode?
    beq.b   .l0abbc             ; single-player: skip 2P check
    clr.l   -(a7)
    jsr ReadInput                ; read P2 input (mode 0)
    addq.l  #$4, a7
    tst.w   d0                  ; any 2P input?
    beq.b   .l0abbc             ; none: proceed to main input polling
    pea     ($0002).w
; GameCommand #$E: display update (also serves as delay)
.l0abb0:
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l0ab02             ; redraw cursor and loop
; --- Phase: Main input polling (ProcessInputLoop) ---
.l0abbc:
    clr.w   d2                  ; clear 2P input flag for this iteration
    move.w  d5, d0              ; carry forward accumulated input
    move.l  d0, -(a7)
    pea     ($000A).w           ; timeout = $0A frames
    jsr ProcessInputLoop         ; wait for directional or button input
    addq.l  #$8, a7
; Mask to d-pad + A/B buttons: $33 = Up/Down/Left/Right
    andi.w  #$33, d0
    move.w  d0, d5              ; d5 = filtered input
; Check for A or B button (confirm/cancel): bits $30 and $20
    andi.w  #$30, d0
    beq.w   .l0ac68             ; no confirm/cancel: check directional input
; A or B pressed: determine confirm vs cancel
    clr.w   (a5)                ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0            ; bit 5 = B button (confirm/OK)
    beq.b   .l0ac64             ; not B: must be A (cancel)
; --- B button: confirm selection, show "confirmed" tiles ---
; Place "confirmed" tile ($0546) at current cursor position x, then tile $0548 just after
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2              ; d2 = x position for current cursor (1-based, step $10)
    ext.l   d2
    lsl.l   #$4, d2
    addi.l  #$30, d2            ; x pixel = d3 * 16 + $30
    move.l  d2, -(a7)
    pea     ($0048).w           ; y pixel = $48
    pea     ($0002).w
    pea     ($0546).w           ; tile $0546 = "confirmed" option tile (darker fill)
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)                 ; display sync
    lea     $24(a7), a7
; Place the second confirmed tile ($0548) at the same position (hover/flash effect)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)           ; same x position
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0548).w           ; tile $0548 = second confirmed state (final highlight)
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    moveq   #$1,d4              ; d4 = 1: purchase/confirm path chosen
; Fall through to GameCommand sync and then to confirmation phase
.l0ac52:
    pea     ($0040).w           ; GameCommand #$40 = palette reset
    clr.l   -(a7)
    pea     ($0010).w           ; GameCommand #$10 = sync wait
    jsr     (a3)
    lea     $c(a7), a7
    bra.b   .l0acb4             ; jump to final confirmation setup
; --- A button: cancel / no selection ---
.l0ac64:
    clr.w   d4                  ; d4 = 0: no purchase (cancel)
    bra.b   .l0ac52             ; sync display and exit
; --- Phase: Directional input (d-pad Up/Down) ---
.l0ac68:
    move.w  d5, d0
    andi.w  #$1, d0             ; bit 0 = Up button
    beq.b   .l0ac88             ; not Up: check Down
; Up: decrement cursor (wrap at 0 -> clamp at 0 or stay at 1)
    move.w  #$1, (a5)           ; input_mode_flag = 1: activate input gate
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0             ; d3 - 1
    ble.b   .l0ac84             ; <= 0: clamp to 1 (minimum 1 player)
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0             ; d3 - 1 (valid decrement)
    bra.b   .l0acaa
.l0ac84:
    moveq   #$0,d0              ; clamp to 0 (will be stored as d3 = 0, shows 1)
    bra.b   .l0acaa
; Down: increment cursor (clamp at 4 = maximum 4 players)
.l0ac88:
    move.w  d5, d0
    andi.w  #$2, d0             ; bit 1 = Down button
    beq.b   .l0acac             ; not Down: no directional input
    move.w  #$1, (a5)           ; input_mode_flag = 1
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0             ; d3 + 1
    moveq   #$4,d1
    cmp.l   d0, d1              ; is d3+1 > 4?
    ble.b   .l0aca8             ; <= 4: use incremented value
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0             ; valid increment
    bra.b   .l0acaa
.l0aca8:
    moveq   #$4,d0              ; clamp to 4 (maximum 4 players)
.l0acaa:
    move.w  d0, d3              ; update cursor position d3
.l0acac:
    pea     ($0004).w           ; GameCommand mode (display update delay)
    bra.w   .l0abb0             ; GameCommand #$E and loop back
; --- Phase: Confirm selection and activate players ---
; GameCommand #$1A: final confirmation box at (col=$00, row=$02, w=$12, h=$0F, tile=$8000)
.l0acb4:
    move.l  #$8000, -(a7)
    pea     ($000F).w           ; height = $0F
    pea     ($0012).w           ; width  = $12
    pea     ($0002).w           ; top row = 2
    pea     ($0007).w           ; left col = 7
    clr.l   -(a7)
    pea     ($001A).w           ; GameCommand #$1A = redraw/clear selection area
    jsr     (a3)
; Activate exactly d3 players: set active_flag = 1 for players 0..d3-1
    movea.l  #$00FF0018,a2      ; player_records base
    clr.w   d2                  ; player index
    bra.b   .l0ace6
.l0acdc:
    move.b  #$1, (a2)           ; player_record+$00 = active_flag = 1 (player is active)
    moveq   #$24,d0
    adda.l  d0, a2              ; advance to next player record
    addq.w  #$1, d2
.l0ace6:
    cmp.w   d3, d2              ; activated d3 players yet?
    blt.b   .l0acdc
; Write final player count to ui_active_flag ($FF0A34) with high bit set:
; $FF0A34 = ui_active_flag: nonzero = UI/input system active; high byte = player count
; Format: d3 | $8000 -- bit 15 set signals "portfolio confirmed with N players"
    move.w  d3, d0              ; d3 = selected player count (1-4)
    ori.w   #$8000, d0          ; set bit 15 = "confirmed" flag for caller
    move.w  d0, ($00FF0A34).l   ; ui_active_flag = (player_count | $8000)
    move.w  d4, d0              ; d0 = purchase_type (0=cancel, 1=confirm)
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts
