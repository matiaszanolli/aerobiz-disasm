; ============================================================================
; RenderDetailedStats -- Renders the full detailed player-stats screen: calls RenderPlayerStatusUI, then draws per-stat bar rows with VRAM read addresses, aircraft icons, and city performance data; ends with ShowPlayerDetailScreen
; 1216 bytes | $03D454-$03D913
; ============================================================================
; --- Phase: Setup and Initial Data Load ---
; a4 = GameCommand dispatcher ($000D64).
; a5 = DisplaySetup ($005092) -- display/graphics setup for sub-screens.
; -$2(a6) = VRAM read address accumulator (word), starts at $FFD8.
; d3 = row counter for VRAM read address queuing.
; d4 = VRAM address word index.
; d5 = stat-row counter (counts down from $12 to $0B for first pass, then down to 0).
; d6 = Y pixel position accumulator (signed, counts through stat row positions).
RenderDetailedStats:
    link    a6,#-$4               ; allocate 4 bytes of frame local space (-$2(a6) = VRAM addr word)
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00000D64,a4        ; a4 = GameCommand dispatcher
    movea.l  #$00005092,a5        ; a5 = DisplaySetup ($005092)
; Draw the player status UI header (name, cash, approval bar, etc.)
    bsr.w RenderPlayerStatusUI    ; render the top-of-screen player status bar
; Load the initial stat icon graphics tileset via DisplaySetup
    pea     ($0010).w             ; mode/size arg
    pea     ($0020).w             ; palette arg
    pea     ($00056A94).l         ; ROM pointer to stat-icon graphics data
    jsr     (a5)                  ; DisplaySetup: decompress and load stat icon tiles
    jsr ResourceUnload            ; release any previously loaded resource
; Copy $200 (512) bytes from ROM stat table ($5FE24) to work RAM at $FF1074
; $FF1074 = screen_buf region; this pre-loads VRAM reference address words for stat rows.
    pea     ($0200).w             ; byte count = $200 = 512
    pea     ($00FF1074).l         ; destination = $FF1074 (VRAM address word table in RAM)
    clr.l   -(a7)                 ; flags = 0
    pea     ($0005FE24).l         ; source = ROM stat address table at $5FE24
    clr.l   -(a7)                 ; padding
    jsr MemCopy                   ; copy 512 bytes from ROM to $FF1074
    lea     $20(a7), a7           ; pop all args (5 longs = $14, but pea pushed 5 args... = 5*4 = $14, not $20 -- adjust for DisplaySetup args too)
; Initialize loop variables for the first stat-bar rendering pass
    moveq   #-$3C,d6              ; d6 = -$3C = -60 (starting Y pixel offset, signed; first stat bar row)
    move.w  #$ffd8, -$2(a6)      ; -$2(a6) = $FFD8 (starting VRAM read address, signed word)
    clr.w   d3                    ; d3 = row counter = 0
    clr.w   d4                    ; d4 = VRAM index word = 0
    bra.b   l_3d4f2               ; jump to loop-entry test (loop runs while d6 < $4C)
; --- Phase: VRAM Read Address Queue Loop (Header Rows) ---
; This loop queues VRAM read address tokens for each stat bar header row.
; Each iteration: call GameCommand #$0F to set up a render token with Y position
; and VRAM address, then call QueueVRAMReadAddr to log the read back address.
; Loop runs while d6 < $4C (from -$3C to $4B = 136 iterations = one for each pixel row of header).
l_3d4ae:
; Push GameCommand #$0F args: (VRAM read addr, Y pos, $FF1234 ptr, size=$8, 0, cmd=$0F)
    move.w  -$2(a6), d0          ; -$2(a6) = current VRAM address (advances each iter)
    ext.l   d0
    move.l  d0, -(a7)            ; push VRAM address
    move.w  d6, d0               ; d6 = Y pixel offset (signed)
    ext.l   d0
    move.l  d0, -(a7)            ; push Y position
    pea     ($00FF1234).l        ; push pointer to stat-bar render buffer at $FF1234
    pea     ($0008).w             ; size = 8 (bytes per row token)
    clr.l   -(a7)                 ; reserved = 0
    pea     ($000F).w             ; GameCommand #$0F = place stat bar row token
    jsr     (a4)                  ; queue stat bar render token
; Queue the VRAM read-back address for this row (used for H-scroll or VRAM copy sync)
    move.w  d4, d0               ; d4 = VRAM address word index
    move.l  d0, -(a7)
    move.w  d3, d0               ; d3 = row counter (sequential row number)
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr       ; log VRAM read address for this row into internal table
; Wait 4 frames for display sync
    pea     ($0004).w
    pea     ($000E).w             ; GameCommand #$0E = frame wait
    jsr     (a4)
    lea     $28(a7), a7           ; pop all args
; Advance loop counters
    addq.w  #$1, d3               ; row counter++
    addq.w  #$2, d4               ; VRAM index += 2 (each entry is a word pair)
    addq.w  #$1, d6               ; Y pixel position++
    addq.w  #$1, -$2(a6)         ; VRAM address++
; Loop test: continue until d6 reaches $4C (bottom of header region)
l_3d4f2:
    cmpi.w  #$4c, d6             ; d6 < $4C?
    blt.b   l_3d4ae              ; yes: continue queuing header rows
; --- Phase: First Stat-Bar Pass Initialization ---
; Initialize pointers for the per-stat-row rendering pass.
; $5FDD8 = stat row value table (word per stat, indexed by d5*2). a3 -> current entry.
; $5FDFC = stat row icon/type table (word per stat, indexed by d5*2). a2 -> current entry.
; d5 = stat row index, starts at $12 = 18, counts DOWN to $0B (8 iterations per pass).
    moveq   #$12,d5               ; d5 = $12 = 18 (starting stat row index)
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2 (word offset)
    movea.l  #$0005FDD8,a0       ; a0 -> ROM stat value table ($5FDD8)
    lea     (a0,d0.w), a0        ; a0 -> entry for stat d5 in value table
    movea.l a0, a3               ; a3 = stat value pointer (moves back by 2 per iteration)
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2
    movea.l  #$0005FDFC,a0       ; a0 -> ROM stat icon/type table ($5FDFC)
    lea     (a0,d0.w), a0        ; a0 -> entry for stat d5 in type table
    movea.l a0, a2               ; a2 = stat type pointer (moves back by 2 per iteration)
; --- First Stat-Bar Row Loop ---
; Renders aircraft icon column + stat bar for each of 8 stat rows (d5: $12 down to $0B).
l_3d51a:
; Look up d2 = VRAM base offset for this stat row from the parallel table at $5FDD6.
; $5FDD6 is offset by -2 from $5FDD8, so (a0 + d5*2) at $5FDD6 gives the row's VRAM base.
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2
    movea.l  #$0005FDD6,a0       ; a0 -> stat VRAM base table ($5FDD6, parallel to $5FDD8)
    move.w  (a0,d0.w), d2        ; d2 = VRAM base word for this stat row
; Queue VRAM read-back address for this stat row
    move.w  d4, d0
    move.l  d0, -(a7)            ; VRAM index
    move.w  d3, d0
    move.l  d0, -(a7)            ; row counter
    bsr.w QueueVRAMReadAddr       ; log this row's VRAM address into read table
    addq.l  #$8, a7
; Test parity of d5 to determine stat column (even=left/wide icon, odd=right/narrow icon)
    move.w  d5, d0
    andi.l  #$1, d0              ; d0 = d5 & 1 (0=even stat row, 1=odd stat row)
    bne.b   l_3d596              ; odd: use narrow ($20) icon style
; Even stat row: load aircraft icon with $30 (48-pixel wide) spacing
    pea     ($0010).w             ; size/mode
    pea     ($0030).w             ; icon pitch = $30 (wide style, 48px)
    move.w  (a2), d0             ; (a2) = stat type code for current row
    add.w   d0, d0               ; * 2 (word offset into aircraft icon table)
    movea.l  #$000569D4,a0       ; a0 -> aircraft/stat icon graphics pointer table ($569D4)
    pea     (a0, d0.w)           ; push pointer to this stat's aircraft icon data
    jsr     (a5)                  ; DisplaySetup: load aircraft icon tiles
; Call GameCommand #$0F to place the stat bar for this row
    move.w  -$2(a6), d0         ; -$2(a6) = VRAM address for this row
    ext.l   d0
    move.l  d0, -(a7)            ; push VRAM address
    move.w  d6, d0               ; d6 = Y pixel position
    ext.l   d0
    move.l  d0, -(a7)            ; push Y position
    move.w  d2, d0               ; d2 = VRAM base index for this stat
    lsl.w   #$3, d0              ; * 8 (byte stride: each VRAM word entry is 8 bytes in $FF1074)
    movea.l  #$00FF1074,a0       ; a0 -> VRAM address table copied from ROM (screen_buf region)
    pea     (a0, d0.w)           ; push pointer to this row's VRAM entry in RAM table
    moveq   #$0,d0
    move.w  (a3), d0             ; (a3) = stat value (from $5FDD8 table)
    move.w  d2, d1               ; d1 = d2 (VRAM base)
    ext.l   d1
    sub.l   d1, d0               ; d0 = stat value - VRAM base (delta for bar rendering)
    move.l  d0, -(a7)            ; push bar delta value
    clr.l   -(a7)                 ; reserved/flags = 0
    pea     ($000F).w             ; GameCommand #$0F = render stat bar row
    jsr     (a4)                  ; render the stat bar row for even stat
    lea     $24(a7), a7
    pea     ($0008).w             ; arg for follow-up GameCommand
    pea     ($000A).w             ; GameCommand #$0A
    bra.b   l_3d5ea               ; merge with odd-row path

l_3d596:
; Odd stat row: load aircraft icon with $20 (32-pixel narrow) spacing
    pea     ($0010).w             ; size/mode
    pea     ($0020).w             ; icon pitch = $20 (narrow style, 32px)
    move.w  (a2), d0             ; stat type code
    add.w   d0, d0               ; * 2
    movea.l  #$000569D4,a0       ; a0 -> aircraft icon table
    pea     (a0, d0.w)           ; push icon data pointer
    jsr     (a5)                  ; load aircraft icon tiles (narrow)
; Place stat bar row (same logic as even but different GameCommand arg order)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0              ; d2 * 8 = byte offset into $FF1074 table
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0             ; stat value
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0               ; delta value for bar
    move.l  d0, -(a7)
    pea     ($000A).w             ; arg order differs from even path
    pea     ($000F).w             ; GameCommand #$0F = render stat bar
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)                 ; last arg = 0 for odd path

; Shared tail for both even and odd stat rows
l_3d5ea:
    pea     ($0010).w             ; GameCommand #$10 arg
    jsr     (a4)                  ; GameCommand #$10 (sprite placement / tile update)
    pea     ($0004).w             ; wait 4 frames
    pea     ($000E).w             ; GameCommand #$0E = frame sync
    jsr     (a4)
    lea     $14(a7), a7           ; pop shared tail args
; Advance loop pointers and counters (moving backward through table since d5 counts down)
    subq.l  #$2, a2              ; a2 -= 2 (prev stat type entry)
    subq.l  #$2, a3              ; a3 -= 2 (prev stat value entry)
    addq.w  #$1, d3              ; row counter++
    addq.w  #$3, d4              ; VRAM index += 3 (3 words per stat row)
    subq.w  #$1, d5              ; stat row index-- (counts down)
    cmpi.w  #$b, d5              ; d5 >= $0B? (haven't reached bottom of first pass)
    bge.w   l_3d51a              ; yes: render next stat row
; --- Phase: City Performance Data Rows ---
; Queue VRAM read addresses for $30 (48) city data rows.
; Each row: QueueVRAMReadAddr + 2-frame wait. d2 = city row counter (0 to $2F).
    clr.w   d2                    ; d2 = city row counter = 0
l_3d612:
    move.w  d4, d0               ; d4 = VRAM index
    move.l  d0, -(a7)
    move.w  d3, d0               ; d3 = row counter
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr       ; queue VRAM read address for this city row
; Wait 2 frames
    pea     ($0002).w
    pea     ($000E).w             ; GameCommand #$0E = frame sync
    jsr     (a4)
    lea     $10(a7), a7           ; pop 4 args
    addq.w  #$1, d2               ; city row counter++
    addq.w  #$1, d3               ; row counter++
    addq.w  #$3, d4               ; VRAM index += 3
    cmpi.w  #$30, d2             ; processed all $30 = 48 city rows?
    blt.b   l_3d612              ; no: continue
; Load two sets of city performance graphics (background tiles for city data panels)
    pea     ($0010).w             ; mode/size
    clr.l   -(a7)                 ; palette = 0
    pea     ($0005CB74).l         ; ROM pointer to city bar background tile data
    jsr     (a5)                  ; DisplaySetup: load city bar background tiles
    pea     ($0010).w             ; mode/size
    pea     ($0020).w             ; palette $20
    pea     ($0005CB34).l         ; ROM pointer to alternate city performance tiles
    jsr     (a5)                  ; DisplaySetup: load alternate city tiles
    lea     $18(a7), a7           ; pop both DisplaySetup calls (3 args each = $0C per call)
; --- Phase: City Performance Bar Rendering (First Set) ---
; Render GameCommand #$0F city bar rows for the first city performance set.
; d2 = X bar start position (starts at -$50 = -80, counts to $114 = 276).
; d7 = value accumulator (starts at -$78 = -120, increments by 2 per row).
; Each row: GameCommand #$0F to place bar sprite, optional sub-bar if d7 < $160,
; then QueueVRAMReadAddr + 1-frame wait.
    moveq   #-$50,d2              ; d2 = -$50 = -80 (initial X pixel position for first city bar)
    moveq   #-$78,d7              ; d7 = -$78 = -120 (initial bar height/value accumulator)
    bra.b   l_3d6cc              ; jump to loop test
l_3d660:
; Place the main city performance bar tile
    pea     ($0020).w             ; palette/priority
    move.w  d2, d0               ; d2 = X position (signed, increases per city)
    ext.l   d0
    move.l  d0, -(a7)            ; X pixel position
    pea     ($000600B4).l        ; ROM pointer to city bar sprite data table (at $600B4)
    pea     ($0003).w             ; height = 3 tiles
    pea     ($0012).w             ; width = $12 = 18 tiles
    pea     ($000F).w             ; GameCommand #$0F = place bar tile
    jsr     (a4)                  ; render main city performance bar
    lea     $18(a7), a7
; If d7 < $160: also render a sub-bar (secondary indicator below main bar)
    cmpi.w  #$160, d7            ; d7 >= $160 (maximum indicator level)?
    bge.b   l_3d6aa              ; yes: skip sub-bar
    pea     ($00A0).w             ; sub-bar height = $A0 = 160
    move.w  d7, d0               ; d7 = sub-bar value
    ext.l   d0
    move.l  d0, -(a7)            ; push sub-bar value
    pea     ($00060024).l        ; ROM pointer to sub-bar sprite data (at $60024)
    pea     ($000C).w             ; height = $C = 12
    pea     ($0015).w             ; width = $15 = 21
    pea     ($000F).w             ; GameCommand #$0F
    jsr     (a4)                  ; render secondary performance indicator
    lea     $18(a7), a7
l_3d6aa:
; Queue VRAM read address and wait 1 frame
    move.w  d4, d0
    move.l  d0, -(a7)            ; VRAM index
    move.w  d3, d0
    move.l  d0, -(a7)            ; row counter
    bsr.w QueueVRAMReadAddr
    pea     ($0001).w             ; wait 1 frame
    pea     ($000E).w             ; GameCommand #$0E
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2               ; X position++ (next city bar position)
    addq.w  #$2, d7               ; value accumulator += 2 (next city performance value)
    addq.w  #$1, d3               ; row counter++
    addq.w  #$3, d4               ; VRAM index += 3
; Loop test: continue while d2 < $114 (end of first city performance set)
l_3d6cc:
    cmpi.w  #$114, d2            ; d2 < $114?
    blt.b   l_3d660              ; yes: render next city bar
; Between city bar passes: final GameCommand, load second city bar tileset, reset counters
    pea     ($000F).w             ; GameCommand #$0F arg
    pea     ($0012).w             ; arg
    pea     ($0010).w             ; arg
    jsr     (a4)                  ; GameCommand #$0F (finalize first city bar set rendering)
; Load second set of city performance graphics tiles
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0005CB94).l         ; ROM pointer to second city bar background tileset
    jsr     (a5)                  ; DisplaySetup: load second city background tiles
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0005CB54).l         ; ROM pointer to second city performance tile variant
    jsr     (a5)                  ; DisplaySetup: load alternate second city tiles
    lea     $24(a7), a7
; Reset loop counters for second city performance bar pass
    move.w  #$ff4c, d2            ; d2 = $FF4C = -180 (starting X pixel for second city set)
    moveq   #-$3C,d7              ; d7 = -$3C = -60 (reset value accumulator)
    bra.b   l_3d776              ; jump to loop test for second pass

; --- Phase: City Performance Bar Rendering (Second Set) ---
; Same pattern as first set but uses different sprite data tables and d2 range.
; Runs from d2=$FF4C up to $15E.
l_3d70a:
    pea     ($0020).w             ; palette/priority
    move.w  d2, d0               ; d2 = X position
    ext.l   d0
    move.l  d0, -(a7)            ; push X position
    pea     ($00060084).l        ; ROM pointer to second city bar sprite data ($60084)
    pea     ($0006).w             ; height = 6 tiles
    pea     ($0015).w             ; width = $15 = 21 tiles
    pea     ($000F).w             ; GameCommand #$0F = place bar tile
    jsr     (a4)                  ; render second-set main city bar
    lea     $18(a7), a7
; If d7 < $160: render a secondary indicator for this city bar
    cmpi.w  #$160, d7            ; d7 at maximum?
    bge.b   l_3d754              ; yes: skip sub-bar
    pea     ($00A0).w             ; sub-bar height
    move.w  d7, d0               ; value
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000600CC).l        ; ROM pointer to second city sub-bar data ($600CC)
    pea     ($0003).w             ; height = 3
    pea     ($0012).w             ; width = $12
    pea     ($000F).w             ; GameCommand #$0F
    jsr     (a4)                  ; render secondary city indicator (second set)
    lea     $18(a7), a7
l_3d754:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr       ; queue VRAM read address for this second-set city row
    pea     ($0001).w             ; 1 frame wait
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2               ; X position++
    addq.w  #$2, d7               ; value accumulator += 2
    addq.w  #$1, d3               ; row counter++
    addq.w  #$3, d4               ; VRAM index += 3
; Loop test: continue while d2 < $15E
l_3d776:
    cmpi.w  #$15e, d2            ; d2 < $15E?
    blt.b   l_3d70a              ; yes: render next second-set city bar
; After second city bar pass: finalize rendering, load stat icon tiles, place title bar
    pea     ($0009).w             ; GameCommand #$0F args (finalize second city bar set)
    pea     ($0012).w
    pea     ($0010).w
    jsr     (a4)                  ; finalize second city performance bar rendering
; Reload stat icon tiles for the second stat-bar rendering pass
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00056A54).l         ; ROM pointer to stat icon tileset (shared with first pass init)
    jsr     (a5)                  ; DisplaySetup: reload stat icons (wide style)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00056A54).l         ; same tileset, narrow palette variant
    jsr     (a5)                  ; DisplaySetup: reload stat icons (narrow style)
    lea     $24(a7), a7
; Place the divider/title bar between stat sections
; Args: (cmd=$5, count=$2, Y=$1970, src=$56AB4, height=$1360, flags=0)
    clr.l   -(a7)                 ; reserved
    pea     ($1360).w             ; height arg for title bar placement
    pea     ($00056AB4).l         ; ROM pointer to divider bar tile data
    pea     ($1970).w             ; Y pixel position for divider bar ($1970 = large val, screen-wrapped?)
    pea     ($0002).w             ; width = 2
    pea     ($0005).w             ; GameCommand #$05 = place divider bar
    jsr     (a4)                  ; place the section divider bar on screen
    lea     $18(a7), a7
; Re-initialize stat-row pointers for the second stat-bar rendering pass
; d5 still holds its value from end of first pass (was decremented to $0A); reinit a2/a3
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2
    movea.l  #$0005FDD8,a0       ; stat value table
    lea     (a0,d0.w), a0
    movea.l a0, a3               ; a3 -> current stat value entry for second pass
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDFC,a0       ; stat type table
    lea     (a0,d0.w), a0
    movea.l a0, a2               ; a2 -> current stat type entry for second pass
    bra.w   l_3d8de              ; jump to second-pass loop test (d5 >= 0)
; --- Phase: Second Stat-Bar Pass ---
; Same structure as first pass (l_3d51a), but d5 now counts from its remaining value
; down to 0. Renders the remaining stat rows (the second half of the stat bar display).
l_3d7f0:
    move.w  d5, d0
    add.w   d0, d0               ; d0 = d5 * 2
    movea.l  #$0005FDD6,a0       ; stat VRAM base table
    move.w  (a0,d0.w), d2        ; d2 = VRAM base for this stat row (second pass)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr       ; queue VRAM read address for this second-pass row
    addq.l  #$8, a7
    move.w  d5, d0
    andi.l  #$1, d0              ; d5 & 1: even=wide icon, odd=narrow icon
    bne.b   l_3d86c              ; odd: narrow icon path
    pea     ($0010).w
    pea     ($0030).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    pea     ($000A).w
    bra.b   l_3d8c0
l_3d86c:
    pea     ($0010).w
    pea     ($0020).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)
; Shared tail for second-pass even/odd rows (same as first pass l_3d5ea)
l_3d8c0:
    pea     ($0010).w             ; GameCommand #$10 (sprite/tile update)
    jsr     (a4)
    pea     ($0004).w             ; wait 4 frames
    pea     ($000E).w             ; GameCommand #$0E = frame sync
    jsr     (a4)
    lea     $14(a7), a7           ; pop shared tail args
; Advance second-pass loop counters (same as first pass)
    subq.l  #$2, a2              ; a2 -= 2 (move to previous stat type entry)
    subq.l  #$2, a3              ; a3 -= 2 (move to previous stat value entry)
    addq.w  #$1, d3              ; row counter++
    addq.w  #$3, d4              ; VRAM index += 3
    subq.w  #$1, d5              ; stat row index-- (towards 0)
; Second-pass loop test: continue while d5 >= 0
l_3d8de:
    tst.w   d5                   ; d5 >= 0? (more stat rows to render)
    bge.w   l_3d7f0              ; yes: render next second-pass stat row

; --- Phase: Final Cleanup and Detailed Screen Display ---
; All stat bars and city performance bars rendered. Load resources and show detail screen.
    pea     ($000A).w             ; wait $0A = 10 frames (settle display)
    pea     ($000E).w             ; GameCommand #$0E = frame wait
    jsr     (a4)
    jsr ResourceLoad              ; load the resources needed for ShowPlayerDetailScreen
; Show the full detailed player stats screen (stat bars, city map, etc.)
    move.w  $a(a6), d0           ; $a(a6) = player index (argument to ShowPlayerDetailScreen)
    move.l  d0, -(a7)
    jsr (ShowPlayerDetailScreen,PC) ; display the interactive player detail stats screen
    nop
; Wait $C8 = 200 frames (~3.3 seconds at 60fps) before returning
    pea     ($00C8).w             ; $C8 = 200 frames
    pea     ($000E).w             ; GameCommand #$0E = frame wait
    jsr     (a4)                  ; wait for display to be visible
; --- Epilog ---
    movem.l -$2c(a6), d2-d7/a2-a5 ; restore saved registers from link frame
    unlk    a6                    ; restore A6 and deallocate frame
    rts
