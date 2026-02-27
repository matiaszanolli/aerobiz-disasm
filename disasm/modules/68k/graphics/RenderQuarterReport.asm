; ============================================================================
; RenderQuarterReport -- Draws one page of the quarterly report: on first call loads and sets up the full background; dispatches to DisplayRouteCargoInfo, ShowRoutePassengers, DisplayRouteFunds, or DrawQuarterResultsScreen depending on the page selector argument.
; 1176 bytes | $026598-$026A2F
; ============================================================================
; --- Phase: Prologue / Argument Capture ---
RenderQuarterReport:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d5             ; d5 = 3rd stack arg (cargo/passenger data ptr, passed to sub-renderers)
    move.l  $14(a6), d6             ; d6 = 4th stack arg (funds data ptr, passed to DisplayRouteFunds)
    move.l  $8(a6), d7              ; d7 = 1st stack arg: page-mode selector (1 = first-call setup, else sub-page)
    movea.l  #$0003B270,a4          ; a4 = PrintfWide: format+display string in 2-tile wide font
    movea.l  #$00000D64,a5          ; a5 = GameCommand: central command dispatcher
    ; --- Compute tile base index from frame counter (calendar quarter display) ---
    move.w  ($00FF0006).l, d0       ; d0 = frame_counter ($FF0006): incremented each main-loop tick
    ext.l   d0                      ; sign-extend to 32 bits for arithmetic right-shift
    bge.b   l_265c4                 ; if non-negative, skip rounding correction
    addq.l  #$3, d0                 ; rounding correction for negative: bias before arithmetic shift
l_265c4:
    asr.l   #$2, d0                 ; d0 = frame_counter / 4 (arithmetic right-shift: integer quarter index)
    addi.w  #$7a3, d0               ; d0 += $7A3 = 1955: tile VRAM char# offset for quarter report font/tiles
    move.w  d0, d2                  ; d2 = computed tile base index, used throughout for text display
    cmpi.w  #$1, d7                 ; is this the first call (full background setup)?
    bne.w   l_26850                 ; no: skip background init, go straight to sub-page render
    ; --- Phase: Background Setup (first call only, d7 == 1) ---
    jsr ResourceLoad                ; load the quarter-report resource set into VRAM (sets load flag)
    jsr ClearTileArea               ; wipe the tile area to blank before drawing the report background
    ; GameCommand #$10 ($0040=priority flag, #$10=cmd): clear scroll planes
    pea     ($0040).w               ; arg: $8000 priority flag
    clr.l   -(a7)                   ; arg: 0 (no extra param)
    pea     ($0010).w               ; arg: GameCommand #$10 = clear screen command
    jsr     (a5)                    ; GameCommand: clear background tile plane
    clr.l   -(a7)
    jsr CmdSetBackground            ; set background color / palette for the report screen
    ; LoadScreenGfx with screen index 4: load the quarter-report BG tile graphics
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w               ; screen index 4 = quarter report screen graphics set
    jsr LoadScreenGfx               ; decompress and load background tile graphics for screen 4
    ; Position cursor at (col=1, row=4) for the screen title text
    pea     ($0001).w               ; cursor X = column 1
    pea     ($0004).w               ; cursor Y = row 4
    jsr SetTextCursor
    ; Print the screen title string using the computed tile base (d2 = tile char# index)
    pea     ($00041560).l           ; ROM ptr to title format string for quarter report header
    jsr     (a4)                    ; PrintfWide: render title at current cursor position
    lea     $28(a7), a7             ; clean up 10 longwords from stack ($28 bytes)
    ; Define the main text rendering window: 27 rows, 32 cols, origin (0,0)
    pea     ($001B).w               ; window height = $1B = 27 rows
    pea     ($0020).w               ; window width  = $20 = 32 columns
    clr.l   -(a7)                   ; window top    = 0
    clr.l   -(a7)                   ; window left   = 0
    jsr SetTextWindow               ; establish text window bounds for subsequent rendering
    ; DisplaySetup with ROM data at $76A9E, width=$30 (48), height=$10 (16)
    pea     ($0010).w               ; height = 16 tiles
    pea     ($0030).w               ; width  = 48 tiles
    pea     ($00076A9E).l           ; ROM: display parameter/tile layout data for report BG
    jsr DisplaySetup                ; configure display parameters for the BG tile area
    ; LZ decompress first graphics block and place tiles (top panel)
    move.l  ($000A1B68).l, -(a7)   ; ROM compressed graphics ptr from pointer table at $A1B68
    pea     ($00FF1804).l           ; dest = save_buf_base ($FF1804): decompress into staging buffer
    jsr LZ_Decompress               ; LZSS decompress first report graphic asset
    ; Place the decompressed tiles at tile position ($0F, $21) with attributes $030F
    pea     ($0015).w               ; tile row = $15
    pea     ($030F).w               ; tile attribute word: palette+priority bits for top-panel graphic
    pea     ($00FF1804).l           ; src = decompressed tile data at save_buf_base
    jsr CmdPlaceTile                ; copy decompressed tiles from staging buffer into VRAM at target
    lea     $30(a7), a7             ; clean up 12 longwords ($30 bytes)
    ; GameCommand #$1B (draw box): place decorative border at (1,2) size ($1E cols × 1 row × 1 depth)
    pea     ($00073378).l           ; ROM: border tile pattern data for report window frame
    pea     ($0002).w               ; box height = 2
    pea     ($001E).w               ; box width  = $1E = 30 columns
    pea     ($0001).w               ; arg 4 = 1
    pea     ($0001).w               ; arg 3 = 1
    pea     ($0001).w               ; box top    = row 1
    pea     ($001B).w               ; GameCommand #$1B = draw bordered rectangle
    jsr     (a5)                    ; GameCommand: draw the report window border
    ; LZ decompress second graphics block and place tiles (bottom panel)
    move.l  ($000A1B24).l, -(a7)   ; ROM compressed graphics ptr from pointer table at $A1B24
    pea     ($00FF1804).l           ; dest = save_buf_base staging buffer
    jsr LZ_Decompress               ; LZSS decompress second report graphic asset
    pea     ($001A).w               ; tile row = $1A
    pea     ($0324).w               ; tile attribute word for bottom-panel graphic
    pea     ($00FF1804).l           ; src = decompressed tile data
    jsr CmdPlaceTile                ; place second graphic into VRAM
    lea     $30(a7), a7             ; clean up 12 longwords
    ; DisplaySetup for the player_word_tab area: width=$21 (33), height=4, data at $FF0118
    pea     ($0004).w               ; height = 4 rows
    pea     ($0021).w               ; width  = $21 = 33 columns
    pea     ($00FF0118).l           ; player_word_tab ($FF0118): 4 words, one per player
    jsr DisplaySetup                ; set up display params using per-player word table
    ; Position text cursor for route-list column headers at (col=1, row=$16)
    pea     ($0001).w               ; cursor X = column 1
    pea     ($0016).w               ; cursor Y = row $16 = 22
    jsr SetTextCursor
    lea     $14(a7), a7             ; clean up 5 longwords
    ; --- Phase: Quarter Number Label (selects "Q1"/"Q2"/"Q3"/"Q4" string) ---
    ; Compute (frame_counter / 4) mod 4 to get current quarter index (0-3)
    move.w  ($00FF0006).l, d0       ; d0 = frame_counter ($FF0006)
    ext.l   d0                      ; sign-extend for signed arithmetic
    moveq   #$4,d1                  ; divisor = 4 (quarters per year)
    jsr SignedMod                   ; d0 = frame_counter mod 4 = current quarter index (0=Q1, 1=Q2, 2=Q3, 3=Q4)
    moveq   #$3,d1                  ; upper bound for jump table (indices 0-3)
    cmp.l   d1, d0                  ; is quarter index > 3?
    bhi.b   l_26726                 ; if out of range, skip label (guard against bad frame_counter)
    ; Jump table dispatch: select the right quarter-name string ptr based on quarter index
    add.l   d0, d0                  ; d0 *= 2: convert to word-offset into jump table
    dc.w    $303B,$0806             ; move.w (6,pc,d0.l),d0 -- load signed word offset from jump table
    dc.w    $4EFB,$0002             ; jmp (pc,d0.w) -- jump to case via PC-relative offset
    dc.w    $0008                   ; case 0 (Q1): offset to pea $4155C
    dc.w    $0010                   ; case 1 (Q2): offset to pea $41558
    dc.w    $0018                   ; case 2 (Q3): offset to pea $41554
    dc.w    $0020                   ; case 3 (Q4): offset to pea $41550
    pea     ($0004155C).l           ; case 0 = "1st Quarter" string ptr
    bra.b   l_26722
    pea     ($00041558).l           ; case 1 = "2nd Quarter" string ptr
    bra.b   l_26722
    pea     ($00041554).l           ; case 2 = "3rd Quarter" string ptr
    bra.b   l_26722
    pea     ($00041550).l           ; case 3 = "4th Quarter" string ptr
l_26722:
    jsr     (a4)                    ; PrintfWide: display the selected quarter-name label
    addq.l  #$4, a7                 ; clean up: 1 longword (the string pointer)
l_26726:
    ; Print the tile-index (year/report) number to the right of the quarter label
    pea     ($0001).w               ; cursor X = column 1
    pea     ($001A).w               ; cursor Y = row $1A = 26 (bottom of report, just above window edge)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d2, d0                  ; d0 = tile base index (computed at top from frame_counter/4 + $7A3)
    move.l  d0, -(a7)              ; pass tile index as numeric arg to PrintfWide
    pea     ($0004154C).l           ; ROM: format string for the year/tile-index field
    jsr     (a4)                    ; PrintfWide: render the year/report-number value
    lea     $10(a7), a7             ; clean up 4 longwords
    ; --- Phase: Route Column Loop (draws 4 player route-status rows in background) ---
    movea.l  #$00FF0018,a2          ; a2 = player_records base ($FF0018): stride $24, 4 players
    movea.l  #$00FF14B0,a3          ; a3 = tile_buf+$F4 area: per-player display offset table
    clr.w   d2                      ; d2 = player column index (loop counter 0..3)
    moveq   #$0,d3
    move.w  d2, d3                  ; d3 = tile column offset accumulator, starts at 0
    move.l  d3, d0                  ; d0 = d3 (0)
    add.l   d3, d3                  ; d3 *= 2
    add.l   d0, d3                  ; d3 *= 3
    add.l   d3, d3                  ; d3 *= 6 (each player occupies 6 tile columns wide in the BG layout)
l_26760:
    ; Read route_type_a (+$02) and route_type_b (+$03) from current player record
    ; Sum them to determine whether player has more than 1 route type (domestic + intl)
    moveq   #$0,d4
    move.b  $2(a2), d4              ; d4 = player_record[+$02] = route_type_a (domestic route count)
    moveq   #$0,d0
    move.b  $3(a2), d0              ; d0 = player_record[+$03] = route_type_b (international route count)
    add.w   d0, d4                  ; d4 = total active route categories for this player
    cmpi.w  #$1, d4                 ; does player have more than 1 route type?
    ble.b   l_2677c                 ; only domestic (or none): use single-route icon
    pea     ($0007257E).l           ; ROM: tile data for dual-route (domestic+international) column icon
    bra.b   l_26782
l_2677c:
    pea     ($00072524).l           ; ROM: tile data for single-route (domestic only) column icon
l_26782:
    ; GameCommand #$1B: draw player column header box at computed tile position
    pea     ($0005).w               ; box height = 5 rows
    pea     ($0009).w               ; box width  = 9 columns
    move.l  d3, d0
    addq.l  #$4, d0                 ; column X = d3 + 4 (offset within the player column band)
    move.l  d0, -(a7)              ; push X position
    pea     ($0001).w               ; box row = 1
    pea     ($0001).w               ; arg depth = 1
    pea     ($001B).w               ; GameCommand #$1B = draw bordered rectangle
    jsr     (a5)                    ; GameCommand: place player-column header box on BG plane
    lea     $1c(a7), a7             ; clean up 7 longwords
    ; FillTileRect: fill a 2-high × 7-wide tile block for the player name area
    ; Tile char# = d2 (player column index) + $754 = player-name tile character index
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$754, d0              ; d0 = base tile char# for player name ($754 = tile index offset)
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0                ; d0 = player_index + 1 (sequential fill count)
    move.l  d0, -(a7)
    clr.l   -(a7)                   ; fill start char = 0
    pea     ($0002).w               ; rect height = 2 rows
    pea     ($0007).w               ; rect width  = 7 columns
    move.l  d3, d0
    addq.l  #$5, d0                 ; rect X = d3 + 5 (right half of player column band)
    move.l  d0, -(a7)
    pea     ($0002).w               ; rect Y = row 2
    pea     ($0001).w               ; attr = 1 (palette 0)
    jsr FillTileRect                ; fill tile block with sequential player-name tile chars
    ; SetTextCursor: position cursor for printing text at a row computed from per-player offset table
    moveq   #$0,d0
    move.w  (a3), d0                ; d0 = per-player row offset from tile_buf table at a3
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0                  ; d0 *= 3
    add.l   d0, d0                  ; d0 *= 6: compute tile row from offset (×6 stride)
    addq.l  #$5, d0                 ; d0 += 5 (row offset within player column)
    move.l  d0, -(a7)              ; cursor Y = computed row
    pea     ($0002).w               ; cursor X = column 2
    jsr SetTextCursor
    ; Print player name or label from $FF00A8 block (64-byte unknown block, stride $10 per player)
    move.w  d2, d0
    lsl.w   #$4, d0                 ; d0 = player_index * $10 (16-byte stride in $FF00A8 block)
    movea.l  #$00FF00A8,a0          ; a0 = $FF00A8: player display name buffer (64 bytes, 4×$10)
    pea     (a0, d0.w)              ; push ptr to this player's 16-byte name entry
    jsr     (a4)                    ; PrintfWide: render player name from display name buffer
    lea     $2c(a7), a7             ; clean up 11 longwords
    ; SetTextCursor: position cursor for route-count display (7 rows below the name row)
    moveq   #$0,d0
    move.w  (a3), d0                ; d0 = per-player row offset (same source as above)
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0                  ; d0 *= 3
    add.l   d0, d0                  ; d0 *= 6
    addq.l  #$7, d0                 ; d0 += 7 (2 rows below name = route total line)
    move.l  d0, -(a7)              ; cursor Y
    pea     ($0005).w               ; cursor X = column 5
    jsr SetTextCursor
    ; Reload route_type_a + route_type_b to display the total route count for this player
    moveq   #$0,d4
    move.b  $2(a2), d4              ; d4 = route_type_a (domestic count)
    moveq   #$0,d0
    move.b  $3(a2), d0              ; d0 = route_type_b (international count)
    add.w   d0, d4                  ; d4 = total route category count
    move.w  d4, d0
    ext.l   d0                      ; sign-extend for PrintfWide numeric arg
    move.l  d0, -(a7)              ; push route count as numeric argument
    pea     ($00041548).l           ; ROM: format string for route-count field (e.g., "%d routes")
    jsr     (a4)                    ; PrintfWide: display total route count
    lea     $10(a7), a7             ; clean up 4 longwords
    ; Advance to next player: a2 += $24 (next player_record), a3 += 2 (next offset word)
    ; d3 += 6 (next column X-band), d2++ (column index)
    moveq   #$24,d0
    adda.l  d0, a2                  ; a2 → next player record (stride $24 = 36 bytes)
    addq.l  #$2, a3                 ; a3 → next per-player offset word (stride 2)
    addq.l  #$6, d3                 ; d3 += 6: advance column tile X-band by 6
    addq.w  #$1, d2                 ; d2++: next player column index
    cmpi.w  #$4, d2                 ; processed all 4 players?
    bcs.w   l_26760                 ; no: loop back for next player column
    bra.b   l_2687e                 ; done with first-call setup; fall through to sub-page dispatch
; --- Phase: Non-First-Call Window Setup (d7 != 1: subsequent page renders) ---
l_26850:
    ; Draw the content window box for subsequent-call renders (no full BG rebuild)
    ; GameCommand #$1A: clear a region at (row=0, col=$A) size $14 wide × $18 tall
    move.l  #$8000, -(a7)           ; priority flag $8000
    pea     ($0018).w               ; height = $18 = 24 rows
    pea     ($0014).w               ; width  = $14 = 20 columns
    pea     ($0004).w               ; top row = 4
    pea     ($000A).w               ; left col = $A = 10
    clr.l   -(a7)                   ; arg = 0
    pea     ($001A).w               ; GameCommand #$1A = clear tile area
    jsr     (a5)                    ; GameCommand: clear the content pane before redrawing sub-page
    ; Also run a second clear: GameCommand #$10 (clear entire BG planes)
    pea     ($0040).w               ; priority flag $40
    clr.l   -(a7)                   ; arg = 0
    pea     ($0010).w               ; GameCommand #$10 = clear screen
    jsr     (a5)                    ; GameCommand: clear screen for fresh render
    lea     $28(a7), a7             ; clean up 10 longwords ($28 bytes)
l_2687e:
    ; --- Phase: Sub-Page Dispatch (select which quarterly content panel to draw) ---
    ; $E(a6) = 2nd stack arg = page selector index (0=cargo, 1=passengers, 2=funds, 3=results, 4=all)
    moveq   #$0,d0
    move.w  $e(a6), d0              ; d0 = page selector (which sub-page to render)
    moveq   #$4,d1                  ; max valid index = 4
    cmp.l   d1, d0                  ; is page selector > 4?
    bhi.w   l_26a1a                 ; out of range: skip rendering entirely
    add.l   d0, d0                  ; d0 *= 2: word offset into jump table
    dc.w    $303B,$0806             ; move.w (6,pc,d0.l),d0 -- load dispatch offset from table
    dc.w    $4EFB,$0002             ; jmp (pc,d0.w) -- branch to selected sub-page case
    dc.w    $000A                   ; case 0 (cargo): offset to DisplayRouteCargoInfo block
    dc.w    $0050                   ; case 1 (passengers): offset to ShowRoutePassengers block
    dc.w    $0096                   ; case 2 (funds): offset to DisplayRouteFunds block
    dc.w    $00DC                   ; case 3 (results): offset to DrawQuarterResultsScreen block
    dc.w    $011E                   ; case 4 (all): offset to combined all-pages block

    ; -- Case 0: Cargo page --
    pea     ($0001).w               ; mode flag = 1 (single-page display)
    move.l  d5, -(a7)              ; d5 = cargo data ptr (3rd original arg)
    jsr (DisplayRouteCargoInfo,PC)  ; render route cargo information panel
    nop
    ; After rendering: clear the label area and reset cursor for page title
    move.l  #$8000, -(a7)           ; priority = $8000
    pea     ($0002).w               ; height = 2
    pea     ($0011).w               ; width  = $11 = 17
    pea     ($0001).w               ; top    = row 1
    pea     ($0004).w               ; left   = col 4
    clr.l   -(a7)                   ; arg = 0
    pea     ($001A).w               ; GameCommand #$1A = clear tile area
    jsr     (a5)                    ; clear the page title area before writing new label
    pea     ($0001).w               ; cursor X = col 1
    pea     ($0004).w               ; cursor Y = row 4
    jsr SetTextCursor               ; position cursor for page title text
    lea     $2c(a7), a7             ; clean up 11 longwords
    pea     ($00041536).l           ; ROM: "Cargo" page title string ptr
    bra.w   l_26a16                 ; jump to PrintfWide call for page title

    ; -- Case 1: Passengers page --
    pea     ($0001).w               ; mode flag = 1 (single-page display)
    move.l  d5, -(a7)              ; d5 = passenger data ptr
    jsr (ShowRoutePassengers,PC)    ; render route passenger load information panel
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                    ; clear page title area
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041524).l           ; ROM: "Passengers" page title string ptr
    bra.w   l_26a16

    ; -- Case 2: Funds page --
    pea     ($0001).w               ; mode flag = 1 (single-page display)
    move.l  d6, -(a7)              ; d6 = funds data ptr (4th original arg)
    jsr (DisplayRouteFunds,PC)      ; render route financial summary panel
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                    ; clear page title area
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041512).l           ; ROM: "Funds" page title string ptr
    bra.w   l_26a16

    ; -- Case 3: Quarterly results page --
    pea     ($0001).w               ; mode flag = 1 (single-page display)
    jsr (DrawQuarterResultsScreen,PC) ; render the quarterly profit/loss results summary
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                    ; clear page title area
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $28(a7), a7             ; clean up (DrawQuarterResultsScreen takes 1 arg, not 2)
    pea     ($00041500).l           ; ROM: "Results" page title string ptr
    bra.b   l_26a16

    ; -- Case 4: All pages combined (compact multi-panel view) --
    ; Call all four sub-renderers in sequence with mode=0 (compact/no-label variant)
    clr.l   -(a7)                   ; mode flag = 0 (compact display, no individual page headers)
    move.l  d5, -(a7)
    jsr (DisplayRouteCargoInfo,PC)  ; render cargo panel (compact)
    nop
    pea     ($0001).w
    move.l  d5, -(a7)
    jsr (ShowRoutePassengers,PC)    ; render passengers panel (compact)
    nop
    clr.l   -(a7)
    move.l  d6, -(a7)
    jsr (DisplayRouteFunds,PC)      ; render funds panel (compact)
    nop
    clr.l   -(a7)
    jsr (DrawQuarterResultsScreen,PC) ; render results panel (compact)
    nop
    lea     $1c(a7), a7             ; clean up 7 longwords from all 4 sub-renderer calls
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)                    ; clear combined-view title area
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $24(a7), a7
    pea     ($000414EE).l           ; ROM: combined-view title string ptr (e.g., "All Routes")
l_26a16:
    jsr     (a4)                    ; PrintfWide: display the selected page title string
    addq.l  #$4, a7                 ; clean up the string pointer pushed above
l_26a1a:
    ; --- Phase: Epilogue / Resource Unload ---
    cmpi.w  #$1, d7                 ; was this a first-call render (d7 == 1)?
    bne.b   l_26a26                 ; no: skip resource unload (resources stay loaded for sub-pages)
    jsr ResourceUnload              ; first-call path: unload resources now that BG is committed
l_26a26:
    movem.l -$28(a6), d2-d7/a2-a5  ; restore saved registers from link frame
    unlk    a6
    rts
