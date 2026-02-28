; ============================================================================
; HandleTextCompression -- Display and navigate the text-based route/character information screen: decompress graphics, show player route summary with char names, browse slots, and show relation data on select.
; 914 bytes | $02434C-$0246DD
; ============================================================================
; --- Phase: Setup ---
; $8(a6) = d7 = player_index
; a3 = GameCommand ($0D64), a4 = $FF13FC (input_mode_flag), a5 = PrintfWide
; d6 = selection-state flag (1 = slot selected/active, 0 = navigation mode)
; d3 = page_offset (which group of 4 route slots is displayed, in multiples of 4)
; d2 = cursor position within the visible 4-slot page (0-3)
HandleTextCompression:
    move.l  $8(a6), d7
; a3 = GameCommand ($0D64) -- central VDP/display dispatcher
    movea.l  #$00000D64,a3
; a4 = $FF13FC = input_mode_flag -- nonzero when countdown input active
    movea.l  #$00FF13FC,a4
; a5 = PrintfWide ($03B270) -- format + display string using 2-tile wide font
    movea.l  #$0003B270,a5
; d6 = 1: initial state flag indicating selection mode is active
    moveq   #$1,d6
; ResourceLoad: load graphics resources for this screen
    jsr ResourceLoad
; PreLoopInit: reset input/display state before entering screen loop
    jsr PreLoopInit
; --- Phase: Locate player record and count total route slots ---
; player_record = $FF0018 + player_index * $24 (36 bytes per player)
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
; a2 = player record pointer
    movea.l a0, a2
; d4 = total_slots = domestic_slots (+$04) + intl_slots (+$05)
; player_record +$04 = domestic_slots, +$05 = intl_slots (DATA_STRUCTURES.md)
    moveq   #$0,d4
    move.b  $4(a2), d4
    moveq   #$0,d0
    move.b  $5(a2), d0
    add.w   d0, d4
; d3 = page_offset, initially 0 (first page of route slots)
    clr.w   d3
; --- Phase: Decompress and load screen graphics ---
; LZ_Decompress: decompress background graphics from ROM $4E28A to $FF1804 (save buffer)
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
; VRAMBulkLoad: DMA transfer $037B tiles worth at tile index $0018 to VRAM
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    jsr VRAMBulkLoad
; SetTextWindow: full-screen text area (left=0, top=0, width=$20, height=$20)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
; SetTextCursor: position for slot count display (col=$01, row=$19)
    pea     ($0019).w
    pea     ($0001).w
    jsr SetTextCursor
; Display total slot count: singular ("1 route") vs plural (">1 routes")
    cmpi.w  #$1, d4
    bne.b   .l243f4
; d4==1: use singular format string at $41350 ("1 route assigned")
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041350).l
    bra.b   .l24400
; d4>1: use plural format string at $41346 ("N routes assigned")
.l243f4:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041346).l
; PrintfWide: render the slot count string
.l24400:
    jsr     (a5)
; DisplaySetup: load secondary display layer from ROM $4E0F6, 16x16 tile area
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0004E0F6).l
    jsr DisplaySetup
    lea     $1c(a7), a7
; GameCommand #$1B: place tile strip from $4E116 (route list panel tiles)
; 1-wide x $1E-high at col=1, row=1, 1 layer
    pea     ($0004E116).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
; LZ_Decompress: decompress slot info panel tiles from ROM $4E18E to $FF1804
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
; VRAMBulkLoad: DMA transfer 6 tiles to VRAM tile $0375 (route panel icons)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad
; SetTextCursor + PrintfWide: draw column header labels for route list
; "From" city label at col=$05, row=$01
    pea     ($0001).w
    pea     ($0005).w
    jsr SetTextCursor
    pea     ($0004133E).l
    jsr     (a5)
; "To" city label at col=$0E, row=$01
    pea     ($0001).w
    pea     ($000E).w
    jsr SetTextCursor
    pea     ($00041332).l
    jsr     (a5)
    lea     $2c(a7), a7
; "Aircraft" / plane type label at col=$1A, row=$01
    pea     ($0001).w
    pea     ($001A).w
    jsr SetTextCursor
    pea     ($0004132C).l
    jsr     (a5)
; --- Phase: Decompress and render current page of route slot graphics ---
; DecompressGraphicsData: decompress route slot icons for page d3, player d7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DecompressGraphicsData,PC)
    nop
    jsr ResourceUnload
; --- Phase: Initial input mode determination ---
; ReadInput: check for pending input (mode 0 = immediate poll, no wait)
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
; If any input: set -$6(a6) = 1 (input already waiting, skip countdown)
; Otherwise: -$6(a6) = 0 (normal countdown mode)
    tst.w   d0
    beq.b   .l244dc
    moveq   #$1,d0
    bra.b   .l244de
.l244dc:
    moveq   #$0,d0
.l244de:
; -$6(a6) = input_ready_flag: controls whether countdown or immediate read is used
    move.w  d0, -$6(a6)
; d5 = previous input state (for ProcessInputLoop carry-in)
    clr.w   d5
; Clear input_mode_flag ($FF13FC) and input_init_flag ($FFA7D8) for fresh start
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
; d2 = cursor position within current page (0-3)
    clr.w   d2
; Compute -$4(a6): carry-in remainder for slot paging
; = (total_slots - 1) mod 4 (how many slots are on the last partial page)
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, -$4(a6)
; --- Phase: Main display loop (top of frame) ---
; Draw cursor tile, poll input, handle navigation and selection
.l24500:
; TilePlacement: draw cursor tile $0773 at this cursor's column position
; X = d2*$10 + $1D = cursor column pixel position within route list area
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
; $1D = 29: base X pixel offset for first slot column in route list
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
; Tile $0773 = selection cursor arrow tile
    pea     ($0773).w
    jsr TilePlacement
; GameCommand #$0E: flush VDP output after tile placement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
; If input_ready_flag set: poll immediately (don't wait for countdown)
    tst.w   -$6(a6)
    beq.b   .l2454e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
; If input not yet released: loop back and keep drawing cursor (wait for key-up)
    tst.w   d0
    bne.b   .l24500
; --- Phase: Poll input with debounce ---
.l2454e:
; Clear input_ready_flag now that we've consumed the pending input
    clr.w   -$6(a6)
; ProcessInputLoop: read joypad with mode $A (debounced/repeating), d5 = carry-in state
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
; Mask to relevant bits: $33 = Start/A (bit4/5) + Left/Right (bit0/1)
    andi.w  #$33, d0
    move.w  d0, d5
; Test A button ($20) = select/confirm
    andi.w  #$20, d0
    beq.b   .l245d6
; --- A button pressed: enter detail view or exit ---
; Clear input state flags for the detail screen
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
; If d6 == 0 (navigation mode, nothing selected): return to outer loop
    tst.w   d6
    beq.w   .l246c4
; d6 == 1 (selection active): show detail/relation panel for selected slot
; cmpi.w #$4,d2: unused compare (compiler artifact -- result not used)
    cmpi.w  #$4, d2
; GameCommand #$1A: clear route detail area (width=$C, height=$1E, at col=1, row=0)
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    pea     ($000C).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
; FormatRelationDisplay: render relation/route details for selected slot
; Slot address: $FF9A20 + (d3+d2)*$14 + player*$320
; d3 = page_offset (in slots), d2 = cursor position within page
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
; Route slot address = $FF9A20 + (page_offset + cursor)*$14 + player_index*$320
    move.w  d3, d0
    add.w   d2, d0
    mulu.w  #$14, d0
    move.w  d7, d1
; $320 = 800 bytes per player (40 slots * $14 bytes each)
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    pea     (a0, d0.w)
    jsr FormatRelationDisplay
    lea     $30(a7), a7
; After showing relation detail: clear selection flag, return to navigation
    clr.w   d6
    bra.w   .l246c4
; --- Test B button ($10) = back/cancel ---
.l245d6:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l245ea
; B = exit this screen: clear flags and return to caller
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    bra.w   .l246d4
; --- Test Left direction ($01) = move cursor left / go to previous page ---
.l245ea:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l24668
; Activate input countdown mode
    move.w  #$1, (a4)
; Set d6 = 1 (mark that we're in active navigation)
    moveq   #$1,d6
; Only decrement cursor if there are more than 1 slot total
    cmpi.w  #$1, d4
    ble.b   .l24600
    subq.w  #$1, d2
; If cursor >= 0: stay on current page
.l24600:
    tst.w   d2
    bge.w   .l246c4
; Cursor went negative: scroll to previous page
; Decrease page offset by 4 (one full page backward)
    subq.w  #$4, d3
; If total_slots <= 4: wrap logic is simple (only one page)
    cmpi.w  #$4, d4
    ble.b   .l24662
; Multi-page: set cursor to last slot of the previous page
    moveq   #$3,d2
; If page_offset went negative: wrap to last page
    tst.w   d3
    bge.b   .l24628
; Compute last-page index: last_page = (total_slots-1)/4
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bge.b   .l2461e
    addq.l  #$3, d0
.l2461e:
    asr.l   #$2, d0
; d3 = last_page * 4 (byte offset to last page start in slot table)
    move.l  d0, d3
    lsl.w   #$2, d3
; Restore cursor to saved position from -$2(a6)
    move.w  -$2(a6), d2
; Redraw page: place blank tile to clear old cursor, reload slot graphics
.l24628:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
; TilePlacement with all zeros: clears cursor indicator from display
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
; DecompressGraphicsData: reload slot graphics for new page d3, player d7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DecompressGraphicsData,PC)
    nop
    lea     $2c(a7), a7
    bra.b   .l246c4
; Single-page wrap: reset both page and cursor to beginning
.l24662:
    clr.w   d3
    clr.w   d2
    bra.b   .l246c4
; --- Test Right direction ($02) = move cursor right / go to next page ---
.l24668:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l246c4
; Activate input countdown mode
    move.w  #$1, (a4)
    moveq   #$1,d6
; Only increment cursor if there are more than 1 slot total
    cmpi.w  #$1, d4
    ble.b   .l2467e
    addq.w  #$1, d2
; Check if cursor is still within current page (d2 <= 3 AND d3+d2 <= total_slots-1)
.l2467e:
    cmpi.w  #$3, d2
    bgt.b   .l24698
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
; If d3+d2 <= total_slots-1: cursor is valid, stay on current page
    cmp.l   d1, d0
    ble.b   .l246b0
; Cursor overflow: advance to next page
.l24698:
    addq.w  #$4, d3
; If total_slots <= 4: wrap to page 0
    cmpi.w  #$4, d4
    ble.b   .l246ac
; Multi-page: check if d3 has gone past the last page
    cmp.w   d4, d3
    blt.b   .l246a6
; Past last page: wrap back to first page
    clr.w   d3
.l246a6:
; Cursor resets to slot 0 on page wrap, then redraw
    clr.w   d2
    bra.w   .l24628
; Single-page: wrap to page 0, cursor set to max slot
.l246ac:
    clr.w   d3
    bra.b   .l246be
; Cursor at valid position within page: check d2 hasn't exceeded total_slots-1 in last page
.l246b0:
    move.w  d2, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l246c4
; d2 is past last valid slot: clamp to last slot (total_slots - 1)
.l246be:
    move.w  d4, d2
; addi.w #$ffff = subtract 1 (signed): clamp to total_slots - 1
    addi.w  #$ffff, d2
; --- End of input loop: GameCommand #$03/#$0E = housekeeping, then loop ---
.l246c4:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l24500
; --- Phase: Exit (B pressed) ---
.l246d4:
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
