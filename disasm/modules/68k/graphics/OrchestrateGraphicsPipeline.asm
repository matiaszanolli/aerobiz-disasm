; ============================================================================
; OrchestrateGraphicsPipeline -- Render a comparative chart of character statistics across multiple rows for the planning screen, showing char name, city relation delta, availability count, and aircraft count.
; 746 bytes | $024C10-$024EF9
; ============================================================================
OrchestrateGraphicsPipeline:
; --- Phase: Setup ---
; Args: $8(a6)=?, $A(a6)=player_index, $E(a6)=col_start_offset,
;       $12(a6)=row_limit, $14(a6)=char_index_array (word array: one char index per row)
; Renders up to 5 rows of a comparison chart. Each row shows:
;   col1=char name, col2=city-relation delta, col3=availability, col4=aircraft count
; d2=row_counter(0-4), d3=scan_index, d4=base_col(2), d5=row_stride(3)
; d6=current_char_index, d7=aircraft_count
; a3=char_index_array, a4=PrintfWide ($3B270), a5=SetTextCursor ($3AB2C)
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $14(a6), a3          ; a3 = char_index_array (word per row entry)
    movea.l  #$0003B270,a4       ; a4 = PrintfWide: format+display in wide (2-tile) font
    movea.l  #$0003AB2C,a5       ; a5 = SetTextCursor: set text output X/Y position
    moveq   #$2,d4               ; d4 = base column X = 2
    moveq   #$3,d5               ; d5 = row stride = 3 (rows are spaced 3 apart vertically... actually used as d5+d2*2)
    jsr PreLoopInit              ; one-time display/timing initialization

; --- Phase: Header Background Setup ---
; Load chart header background tiles from ROM $4978E; 16×16 region
    pea     ($0010).w            ; height = $10
    pea     ($0010).w            ; width = $10
    pea     ($0004978E).l        ; ROM: compressed background tile data for chart header
    jsr DisplaySetup             ; decompress and place background

; GameCommand #$1B: place header tile strip (column labels row)
; col=2, row=$1E, layer=1, count=1 (one strip)
    pea     ($0004E116).l        ; ROM: tile strip data for column headers
    pea     ($0002).w            ; col = 2
    pea     ($001E).w            ; row = $1E = 30
    pea     ($0001).w            ; layer = 1
    pea     ($0002).w            ; count = 2
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand              ; GameCommand #$1B: place header tile strip

; Decompress char icon tiles to work buffer at save_buf_base ($FF1804)
    pea     ($0004E18E).l        ; ROM source: LZ-compressed char icon tile data
    pea     ($00FF1804).l        ; dest: save_buf_base ($FF1804) work buffer
    jsr LZ_Decompress            ; LZSS decompress char icon graphics
    lea     $30(a7), a7

; VRAMBulkLoad: DMA 6 tiles to VRAM at tile slot $375 (char portrait area)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l        ; source: decompressed icon tiles
    pea     ($0006).w            ; 6 tiles
    pea     ($0375).w            ; VRAM tile index $375 = portrait slot
    jsr VRAMBulkLoad

; Set text window to full 32×32 screen for column header text output
    pea     ($0020).w            ; width = $20 = 32
    pea     ($0020).w            ; height = $20 = 32
    clr.l   -(a7)               ; col = 0
    clr.l   -(a7)               ; row = 0
    jsr SetTextWindow

; --- Phase: Print Column Header Labels ---
; Header 1: SetTextCursor(col=1, row=d4+1), PrintfWide("Name" or equivalent)
    pea     ($0001).w            ; col = 1
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0             ; row = d4+1 = 3
    move.l  d0, -(a7)
    jsr     (a5)                 ; SetTextCursor(col=1, row=d4+1)
    pea     ($000413CE).l        ; ROM string: column header 1 (char name label)
    jsr     (a4)                 ; PrintfWide: print name column header
    lea     $30(a7), a7

; Header 2: col=1, row=d4+$A (= d4+10)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$a, d0             ; row = d4+10
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413C6).l        ; ROM string: column header 2 (relation delta label)
    jsr     (a4)

; Header 3: col=1, row=d4+$11 (= d4+17)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$11, d0            ; row = d4+17
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413C0).l        ; ROM string: column header 3 (availability count label)
    jsr     (a4)

; Header 4: col=1, row=d4+$17 (= d4+23)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    addi.l  #$17, d0            ; row = d4+23
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($000413BA).l        ; ROM string: column header 4 (aircraft count label)
    jsr     (a4)
    lea     $24(a7), a7

; --- Phase: Per-Row Data Loop ---
    clr.w   d2                   ; d2 = row index (0..4, up to 5 rows)
    bra.w   .l24ed2              ; check loop bounds before first iteration

.l24d1e:
; Compute d6 = char_index for this row:
; char_index_array[col_offset + d2] (word array, word stride)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0               ; d0 = d2*2 (word offset)
    lea     (a3,d0.l), a0        ; a0 = &char_index_array[d2]
    move.w  $e(a6), d1           ; $E(a6) = col_start_offset (which column to start from)
    ext.l   d1
    add.l   d1, d1               ; d1 = col_start_offset*2
    adda.l  d1, a0               ; a0 = &char_index_array[col_offset + d2]
    move.w  (a0), d6             ; d6 = char_index for this row

; Compute a2 = event_records entry for this char:
; event_records($FFB9E8): stride $20 per player, then char_index*2 within player block
    move.w  $a(a6), d0           ; $A(a6) = player_index
    lsl.w   #$5, d0              ; player_index * $20 = player block offset (32 bytes each)
    move.w  d6, d1
    add.w   d1, d1               ; char_index * 2 (word stride within player block)
    add.w   d1, d0               ; total offset = player*$20 + char*2
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 -> event_records[player_index][char_index]

; Load per-row char portrait background (16×32 tile region at ROM $4E0F6)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0004E0F6).l        ; ROM: char portrait tile data (row background)
    jsr DisplaySetup

; GameCommand #$1B: place tile strip at row's Y position
; col=d4, row=d5+d2*2, count=$1E, layer=1
    pea     ($0004E116).l        ; tile strip data (same header strip reused per-row)
    pea     ($0002).w            ; col = 2
    pea     ($001E).w            ; count = $1E = 30
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1               ; d1 = d2*2
    add.l   d1, d0               ; d0 = d5 + d2*2 = row Y for this chart entry
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)            ; col = d4
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand              ; GameCommand #$1B: place row tile strip

; Decompress and DMA char portrait icon (same asset, per-row instance)
    pea     ($0004E18E).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0006).w
    pea     ($0375).w
    jsr VRAMBulkLoad             ; DMA row char portrait to VRAM slot $375

; Reset text window to full screen for row data output
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow

; Column 1: Character name
; SetTextCursor(col=d4+1, row=d5+d2*2) -> PrintfWide(name_string)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1               ; d2*2
    add.l   d1, d0               ; row = d5 + d2*2
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0             ; col = d4+1
    move.l  d0, -(a7)
    jsr     (a5)                 ; SetTextCursor
    lea     $2c(a7), a7
; Look up char's display name string:
; $FF1278 = city/char display lookup (byte per char index -> name table index)
; $5ECFC = ROM pointer table: string pointers indexed by name_table_index*4
    movea.l  #$00FF1278,a0       ; city/char display lookup array
    move.b  (a0,d6.w), d0        ; byte for char d6 = display name index
    andi.l  #$ff, d0
    lsl.w   #$2, d0              ; name_index * 4 (long pointer table stride)
    movea.l  #$0005ECFC,a0       ; ROM: city/char name string pointer table
    move.l  (a0,d0.w), -(a7)    ; push name string pointer
    pea     ($000413B6).l        ; ROM format string: "%s" (character name)
    jsr     (a4)                 ; PrintfWide: display character name

; Column 2: City relation delta
; event_records[player][char]+$0 = city_a count; +$1 = city_b count
; delta = city_a - city_b (positive = more routes in city A than city B)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$c, d0             ; col = d4+$C = d4+12
    move.l  d0, -(a7)
    jsr     (a5)                 ; SetTextCursor(col=d4+12, row=d5+d2*2)
    moveq   #$0,d0
    move.b  (a2), d0             ; event_records byte 0: city A assignment/count
    moveq   #$0,d1
    move.b  $1(a2), d1           ; event_records byte 1: city B assignment/count
    sub.l   d1, d0               ; delta = city_A - city_B
    move.l  d0, -(a7)
    pea     ($000413B2).l        ; ROM format string: "%+d" or delta format
    jsr     (a4)                 ; PrintfWide: display city relation delta

; Column 3: Availability count (event_records byte 1 = available count)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$12, d0            ; col = d4+$12 = d4+18
    move.l  d0, -(a7)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0           ; event_records+$1 = availability or scheduled count
    move.l  d0, -(a7)
    pea     ($000413AE).l        ; ROM format string: "%d" availability
    jsr     (a4)                 ; PrintfWide: display availability count

; Column 4: Aircraft count -- scan $FF02E8 char slot group for matching char index
; $FF02E8 = char display slot table ($14 bytes per player); entries: [char_idx, aircraft_cnt, ...]
    move.w  $a(a6), d0           ; player_index
    mulu.w  #$14, d0             ; player_index * $14 = player block offset (20 bytes each)
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 -> player's char slot group in $FF02E8
    clr.w   d3                   ; d3 = scan index (0..4, up to 5 slots)
    clr.w   d7                   ; d7 = aircraft count (default 0 if not found)
    bra.b   .l24e9a

.l24e8a:
; Compare first byte of each 4-byte entry to current char_index (d6)
    cmp.b   (a2), d6             ; does this slot's char_index match d6?
    bne.b   .l24e96              ; no: advance to next
    moveq   #$0,d7
    move.b  $1(a2), d7           ; match: d7 = aircraft count from slot[+1]
    bra.b   .l24ea0              ; stop scanning
.l24e96:
    addq.l  #$4, a2              ; advance to next 4-byte slot entry
    addq.w  #$1, d3
.l24e9a:
    cmpi.w  #$5, d3              ; scanned all 5 slots?
    blt.b   .l24e8a              ; no: continue scan

.l24ea0:
; Print aircraft count at col d4+$18 (= d4+24)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$18, d0            ; col = d4+$18 = d4+24
    move.l  d0, -(a7)
    jsr     (a5)                 ; SetTextCursor(col=d4+24, row=d5+d2*2)
    lea     $30(a7), a7
    move.w  d7, d0               ; d7 = aircraft count (from $FF02E8 scan, or 0)
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000413AA).l        ; ROM format string: "%d" aircraft count
    jsr     (a4)                 ; PrintfWide: display aircraft count
    addq.l  #$8, a7
    addq.w  #$1, d2              ; next row

; --- Phase: Loop Condition ---
.l24ed2:
; Render up to 5 rows (d2 < 5) AND within caller's window ($E(a6)+d2 < $12(a6))
    cmpi.w  #$5, d2              ; hard cap at 5 rows
    bge.b   .l24ef0
    move.w  $e(a6), d0           ; col_start_offset (used as row window start here)
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0               ; d0 = col_start_offset + d2
    move.w  $12(a6), d1          ; row_limit: stop when col_start+d2 >= row_limit
    ext.l   d1
    cmp.l   d1, d0               ; (start + d2) < row_limit?
    blt.w   .l24d1e              ; yes: render this row

; --- Phase: Return ---
.l24ef0:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
