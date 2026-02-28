; ============================================================================
; InitGraphicsMemory -- Initialize and run the main character management screen: build owned char list, enter full navigation loop with page management, and dispatch to sub-screens.
; 858 bytes | $024EFA-$025253
; ============================================================================
InitGraphicsMemory:
; --- Phase: Setup ---
; Frame layout: -$2C bytes of locals; a5 = pointer to local char index array (max 16 entries)
    link    a6,#-$2C
    movem.l d2-d7/a2-a5, -(a7)
; d7 = player_index argument passed by caller
    move.l  $8(a6), d7
; a4 = GameCommand dispatch address ($000D64) -- cached for all subsequent indirect calls
    movea.l  #$00000D64,a4
; a5 = -$2C(a6): local frame buffer used as owned-char list (up to 16 word entries)
    lea     -$2c(a6), a5
; d5 = 1: resource ID (loaded before entering the char management UI)
    moveq   #$1,d5
; ResourceLoad: load resource #1 into VRAM (character graphics / font asset)
    jsr ResourceLoad
; PreLoopInit: one-time per-screen initialization (palette, scroll regs, etc.)
    jsr PreLoopInit
; ShowPlayerInfo(player_index): display the player status bar / name panel
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    addq.l  #$4, a7
; --- Phase: Build Owned Char List ---
; Compute pointer into event_records: $FFB9E8 + player_index * $20
; event_records = 4 records * $20 bytes each; player_index selects this player's record
    move.w  d7, d0
    lsl.w   #$5, d0
; a3 = &event_records[player_index] ($FFB9E8-based, stride $20 = 32 bytes)
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
; d4 = count of chars found and added to the list (output index into a5 buffer)
    clr.w   d4
; d2 = char slot index being scanned (0..15)
    clr.w   d2
.l24f40:
; Check if this char entry is in the event record (nonzero byte = present)
    tst.b   (a3)
    beq.b   .l24f54
; Char is in event record: record its char index d2 into the local list at a5
.l24f44:
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
; a5[d4] = d2 (char slot index); stride 2 words in the local buffer
    movea.l d0, a0
    move.w  d2, (a5,a0.l)
    addq.w  #$1, d4
    bra.b   .l24f7c
.l24f54:
; Char not directly in event record: check assigned char slots ($FF02E8 table)
; $FF02E8 + player_index * $14: per-player assignment block (5 slots * 4 bytes)
    move.w  d7, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
.l24f68:
; Each slot in the assignment block: byte[0]=char_index, byte[1]=active_flag
; If char_index matches d2 AND active_flag != 0, include this char
    cmp.b   (a2), d2
    bne.b   .l24f72
    tst.b   $1(a2)
    bne.b   .l24f44
.l24f72:
; Advance to next assignment slot (4 bytes per slot)
    addq.l  #$4, a2
    addq.w  #$1, d3
; Check up to 5 assignment slots
    cmpi.w  #$5, d3
    blt.b   .l24f68
.l24f7c:
; Advance to next event record entry (stride 2 bytes: stride-2 storage pattern)
    addq.l  #$2, a3
    addq.w  #$1, d2
; Scan 16 char slots total
    cmpi.w  #$10, d2
    blt.b   .l24f40
; If no chars owned at all, jump straight to exit
    tst.w   d4
    ble.w   .l2524a
; --- Phase: Initial Page Setup ---
; Call OrchestrateGraphicsPipeline(player_index, 0, total_chars, list_ptr)
; Sets up the initial screen layout showing the first page of owned chars
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w OrchestrateGraphicsPipeline
; ResourceUnload: release the resource loaded earlier now that graphics are set up
    jsr ResourceUnload
; ReadInput(mode=0): get current button state; tests whether any button is held
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l24fba
; Input held: set -$A(a6) = 1 (flag: wait for release before accepting new input)
    moveq   #$1,d0
    bra.b   .l24fbc
.l24fba:
    moveq   #$0,d0
.l24fbc:
; -$A(a6) = wait_for_release flag
    move.w  d0, -$a(a6)
; d6 = 0: scroll row offset (which row in the current page is highlighted)
    clr.w   d6
; Clear input_mode_flag ($FF13FC): allows ProcessInputLoop to accept new input
    clr.w   ($00FF13FC).l
; Clear input_init_flag ($FFA7D8): resets the 60-frame countdown for this UI context
    clr.w   ($00FFA7D8).l
; d2 = column within 5-wide page (0-4), d3 = page index
    clr.w   d2
    clr.w   d3
; Compute initial page layout: d4 (total chars) / 5 = number of full pages (d0=quotient)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
; -$4(a6) = page_count * 5 (= page_count_x5, total full-page chars, for boundary checks)
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
; d0 = quotient * 5 (quick multiply: quotient * 4 + quotient = quotient * 5)
    move.l  d0, -$4(a6)
; Compute -$8(a6): (total_chars % 5) - 1 = last column index on the final partial page
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
; -$8(a6) = remainder - 1 (max column index for last page; -1 if evenly divisible)
    move.l  d0, -$8(a6)
; --- Phase: Main Navigation Loop ---
.l24ffa:
; Render cursor/highlight tile at the current selection position (d2=col, d3=page?row)
; TilePlacement args: tile=$0773 (cursor tile), x=0, y=0, col=d2*$10+$1D, row=8, priority=$8000
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
; Tile $0773 = cursor highlight tile for the selected character slot
    pea     ($0773).w
    jsr TilePlacement
; GameCommand #$E (via a4 indirect): flush/enable display -- show the rendered frame
; GameCommand #3 = ? (display enable sub-command)
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
; If wait_for_release is set, poll until all buttons are released before accepting input
    tst.w   -$a(a6)
    beq.b   .l25048
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
; If any button still held, loop back and redraw (don't advance yet)
    tst.w   d0
    bne.b   .l24ffa
.l25048:
; Clear wait flag -- input is now clean
    clr.w   -$a(a6)
; ProcessInputLoop(d6, timeout=$A): poll for directional/button input with 10-frame debounce
; Returns d0 = button bitmask ($10=B/cancel, $20=A/confirm, $1=left, $2=right)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
; Mask to relevant bits: $33 = $20(A) | $10(B) | $02(right) | $01(left)
    andi.w  #$33, d0
    move.w  d0, d6
; Check for A button ($20) = confirm/select this character
    andi.w  #$20, d0
    beq.w   .l25116
; --- A Button: Show Character Profile ---
; Clear input gate flags before entering sub-screen
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
; If d5 (char-profile shown flag) is already set, just redraw the navigation page
    tst.w   d5
    beq.b   .l24ffa
; d5 = 13 = ShowCharProfile mode (drives the profile display variant)
    moveq   #$D,d5
; Compute selected char index: list[(d3 + d2) * 2] = char index at (page_col + row_offset)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    add.l   d0, d0
    movea.l d0, a0
; -$C(a6) = selected char index from the local owned-char list
    move.w  (a5,a0.l), -$c(a6)
; GameCommand #$1A(via a4): clear a $C*$1E region at page ($D,1,0,0) -- wipe the sub-panel
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
; Second clear: same region with variant args (write priority $1 to clear foreground layer)
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
; GameCommand #$10 (via a4, arg=$40): commit display changes
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    lea     $28(a7), a7
; ShowCharProfile(player_index, char_index, 0, mode=d5, 2, 1)
; Displays the full character portrait + stat panel in the cleared area
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  -$c(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
; GameCommand #$E (arg=$10): sync display after profile draw
    pea     ($0010).w
    pea     ($000E).w
    jsr     (a4)
    lea     $20(a7), a7
; Clear d5 to indicate profile is now showing; next A press will re-enter list mode
    clr.w   d5
    bra.w   .l24ffa
; --- B Button ($10): Cancel / Return to parent screen ---
.l25116:
    move.w  d6, d0
    andi.w  #$10, d0
    beq.b   .l2512e
; B button pressed: clear both input flags and exit char management screen
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l2524a
; --- Left Arrow ($01): Navigate to Previous Character ---
.l2512e:
    move.w  d6, d0
    andi.w  #$1, d0
    beq.b   .l251b2
; Left pressed: set input_mode_flag=1 (enables countdown on next ProcessInputLoop call)
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
; Move selection left: decrement column d2
    subq.w  #$1, d2
    tst.w   d2
    bge.w   .l24ffa
; d2 went negative: wrap to previous page if more than 5 chars, else clamp to 0
    cmpi.w  #$5, d4
    ble.b   .l251ac
; More than 5 chars: scroll to previous page (d3 -= 5 for page, d2 = 4 for last col)
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
; If d3 goes negative, wrap to the last page
    bge.b   .l2515e
; Wrap: load saved last-page page (d3=-$2(a6)) and last-col (d2=-$6(a6))
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
.l2515e:
; Redraw page at (player, d4, d3, a5): call OrchestrateGraphicsPipeline for new page
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
; PreLoopInit + ShowPlayerInfo: re-initialize display for the new page
    jsr PreLoopInit
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $20(a7), a7
.l2518c:
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w OrchestrateGraphicsPipeline
    lea     $10(a7), a7
    bra.w   .l24ffa
.l251ac:
; 5 or fewer chars: just clamp column to 0 (no page wrap needed)
    clr.w   d2
    bra.w   .l24ffa
; --- Right Arrow ($02): Navigate to Next Character ---
.l251b2:
    move.w  d6, d0
    andi.w  #$2, d0
    beq.w   .l24ffa
; Right pressed: set input_mode_flag=1, advance column
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
    addq.w  #$1, d2
; Check if d2 + d3 (= absolute char index) exceeds total char count - 1
    cmpi.w  #$4, d2
    bgt.b   .l251e2
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
; If still within range, just redraw with new column
    cmp.l   d1, d0
    ble.b   .l25240
.l251e2:
; Column exceeds page or total: advance page if more than 5 chars
    cmpi.w  #$5, d4
    ble.b   .l25214
; Scroll to next page: wrap column to 0, page += 5
    clr.w   d2
    addq.w  #$5, d3
; If new page * 5 exceeds total, wrap back to page 0
    cmp.w   d4, d3
    ble.b   .l251f4
    clr.w   d3
    clr.w   d2
.l251f4:
; Trigger full page redraw for the new page
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l2518c
.l25214:
; 5 or fewer chars: clamp column to last valid index (min of d3+d2, d4-1)
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
; If within bounds, use d3+d2 as new d2 (absolute index on small list)
    bge.b   .l25234
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l2523a
.l25234:
; Clamp to total_chars - 1
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l2523a:
    move.w  d0, d2
    bra.w   .l24ffa
.l25240:
; Small list: check if column alone is already within bounds for a <= 5 char set
    cmpi.w  #$5, d4
    bge.w   .l24ffa
    bra.b   .l25214
; --- Phase: Exit ---
.l2524a:
    movem.l -$54(a6), d2-d7/a2-a5
    unlk    a6
    rts
