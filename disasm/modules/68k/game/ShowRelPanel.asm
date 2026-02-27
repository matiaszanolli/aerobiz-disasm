; ============================================================================
; ShowRelPanel -- Display character relationship/affinity panel
; Called: 40 times.
; Args: $0a(a6)=player_index (l), $0e(a6)=char_index (l)
; Regs: D2-D5/A0-A5 saved. A2=result buf (A6-$C4). A5=player rec ($FF0018+p*36).
; char<7: 2 loops over char record data; char>=7: 32-entry acquaintance scan.
;
; Overview:
;   This function builds a display list in the frame buffer at A6-$C4 describing
;   how each character in the current player's roster relates to one another, then
;   calls GameCommand to render the resulting panel.
;
;   Two code paths:
;   [A] char_index < 7: "relationship detail" path
;       - Reads two range descriptors from CharTypeRangeTable ($05ECBC)
;         indexed by char_index. Each descriptor has (start_char, count) fields.
;       - Loop 1: iterate over count1 characters starting at start_char1.
;         For each char, classify relationship as: same hub (tile $0760),
;         alliance match (tile $0761), fleet member (tile $0762), or other ($0763).
;         Then draw a revenue delta bar via $01DFBE if city_data shows net positive.
;       - Loop 2: iterate over count2 characters starting at start_char2.
;         Same classification but uses alliance word table at $FFBD6C.
;         Draws bar + GameCommand $0E flush per entry.
;       - After both loops: calls GameCommand $0F to render result buffer,
;         then $009D92 and $7226 (PC-relative) for final rendering.
;   [B] char_index >= 7: "acquaintance" path
;       - Uses CharPortraitPos ($05E948) as a 32-entry scan table.
;       - For each entry: classifies as hub match ($0760) or fleet member ($0761),
;         or skips entirely (clears d2). Stores matching entries in result buffer.
;       - Calls GameCommand $0F to render result buffer.
;
; Key data structures:
;   CharTypeRangeTable ($05ECBC): 7 entries x 4 bytes.
;     byte[0]=range1_start, byte[1]=range1_count, byte[2]=range2_start, byte[3]=range2_count
;     Indexed by char_index * 4 to select the right entry.
;   CharRangeScoreMap ($05E9FA): word-pair table indexed by char_code * 2.
;     Each word-pair: word[0]=display_row, word[1]=display_col (screen position).
;   city_data ($FFBA80): 89 cities x 4 entries x 2 bytes stride.
;     byte[0]=metric_A, byte[1]=metric_B at (city_index * 8 + player_index * 2).
;     Revenue bar drawn when (metric_A - metric_B) > 0.
;   entity_bits ($FF08EC): longword bitfield table, 4 longwords (one per player).
;     Fleet membership: (1 << char_code) & entity_bits[player * 4].
;   aircraft_fleet ($FFA6A0): longword bitfield table.
;     Alliance membership: (1 << char_code) & ffa6a0[player * 4].
;   Alliance word table ($FFBD6C): used in loop 2 to test bit in a word table
;     indexed by (player_index * $0E + char_index * 2).
;
; Result buffer format (A6-$C4, built word-by-word):
;   Each entry = 4 words: [display_row+$80, 0, tile_id, display_col+$80]
;   Passed to GameCommand $0F to render the relationship panel.
;
; Register usage (path A):
;   D3 = current char_code being iterated
;   D4 = BitFieldSearch result (bit position of this char in fleet bitfield)
;   D5 = remaining count for current loop
;   D6 = screen row position (starts at $0660, increments each visible entry)
;   D7 = screen base row seed (starts at $1F, increments each visible entry)
;   A2 = walking ptr into result buffer (A6-$C4)
;   A3 = walking ptr into CharRangeScoreMap ($05E9FA, word-pair per char)
;   A4 = ptr to city_data entry for current char (computed each iteration)
;   A5 = ptr to this player's player record ($FF0018 + player_index * $24)
; ============================================================================
ShowRelPanel:                                                ; $006B78
    link    a6,#-$c4
    movem.l d2-d7/a2-a5,-(sp)

; --- Phase: Load player record pointer ---
    ; Player record base: $FF0018, stride $24 (36 bytes), 4 players.
    move.w  $000a(a6),d0              ; player_index
    mulu.w  #$24,d0                   ; * $24 = byte offset into player_records
    movea.l #$00ff0018,a0            ; player_records base ($FF0018)
    lea     (a0,d0.w),a0             ; a0 = this player's record
    movea.l a0,a5                    ; a5 = player record ptr (preserved throughout)

    ; Initialize display counters
    moveq   #$1f,d7                  ; d7 = screen row base seed ($1F = starting tile row)
    move.w  #$0660,d6                ; d6 = screen position word ($0660 = col/row packed)

; --- Phase: GameCommand $10 -- set display mode before rendering ---
    pea     ($0030).w
    pea     ($0007).w
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64        ; jsr GameCommand ($000D64): cmd=$10 (display mode)
    lea     $000c(sp),sp

    lea     -$c4(a6),a2             ; a2 = result buffer base (A6-$C4)

; ============================================================================
; --- Phase: Dispatch on char_index ---
; ============================================================================
    cmpi.w  #$7,$000e(a6)           ; char_index >= 7?
    bge.w   .alt_path               ; yes: acquaintance path

; ============================================================================
; --- Path A: char_index < 7 -- relationship detail path ---
; ============================================================================

; --- Phase: Load CharTypeRangeTable entry for this char_index ---
    ; CharTypeRangeTable ($05ECBC): 7 entries x 4 bytes.
    ; byte[0]=range1_start (char_code of first char to display)
    ; byte[1]=range1_count (number of chars in range 1)
    ; byte[2]=range2_start (char_code of first char in range 2)
    ; byte[3]=range2_count (number of chars in range 2)
    move.w  $000e(a6),d0            ; char_index (0-6)
    lsl.w   #2,d0                   ; * 4 = byte offset into CharTypeRangeTable
    movea.l #$0005ecbc,a0          ; CharTypeRangeTable ($05ECBC)
    lea     (a0,d0.w),a0           ; a0 = entry for this char_index
    move.l  a0,-$4(a6)             ; save ptr to table entry in frame

    ; Load range1_start into D3 and range1_count into D5 (as the loop driver)
    move.b  (a0),d3                 ; d3 = range1_start char_code
    andi.l  #$ff,d3                 ; zero-extend byte
    move.w  $000e(a6),d0           ; char_index
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0           ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02fe             ; jsr BitFieldSearch ($006EEA) [PC-relative]
    nop                             ; BitFieldSearch: find bit position in fleet bitfield
    addq.l  #8,sp
    move.w  d0,d4                  ; d4 = bit position (fleet membership indicator)

    ; Point A3 to CharRangeScoreMap entry for range1_start char_code
    movea.l -$4(a6),a0
    move.b  (a0),d0                ; byte[0] = range1_start
    andi.l  #$ff,d0
    add.w   d0,d0                  ; * 2 = word offset into CharRangeScoreMap
    movea.l #$0005e9fa,a0         ; CharRangeScoreMap ($05E9FA): word-pair per char
    lea     (a0,d0.w),a0
    movea.l a0,a3                  ; a3 = ptr to first CharRangeScoreMap entry

    ; Load range1_count into D5
    movea.l -$4(a6),a0
    move.b  $1(a0),d5              ; byte[1] = range1_count
    andi.l  #$ff,d5
    bra.w   .loop1_check

; ============================================================================
; --- Phase: Loop 1 -- iterate range1 characters ---
; ============================================================================
.loop1_body:                             ; $006C20
    ; Classify relationship for current char D3 relative to this player's record:
    ;   Priority order: hub_city match > alliance match > fleet member > other
    ;
    ; player_record+$01 = hub_city (byte): the player's home city index.
    ; If D3 == hub_city: relationship = "hub" (tile $0760)
    move.w  d3,d0
    ext.l   d0
    moveq   #0,d1
    move.b  $1(a5),d1              ; player_record+$01 = hub_city byte
    cmp.l   d1,d0                  ; D3 == hub_city?
    bne.b   .l1_b
    move.w  #$0760,d2              ; tile $0760 = hub-city match indicator
    bra.b   .l1_commit

.l1_b:                                   ; $006C34
    ; If D3 == D4 (fleet bit position match): alliance indicator
    cmp.w   d4,d3
    bne.b   .l1_c
    move.w  #$0761,d2              ; tile $0761 = alliance/partner indicator
    bra.b   .l1_commit

.l1_c:                                   ; $006C3E
    ; Test aircraft_fleet bitfield ($FFA6A0): bit D3 in player's longword
    ; fleet_bits = FFA6A0[player_index * 4]  (longword)
    ; if (1 << D3) & fleet_bits != 0: char is in player's fleet
    move.w  d3,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1                  ; d1 = 1 << d3 (bitmask for this char)
    move.l  d1,d0
    move.w  $000a(a6),d1          ; player_index
    lsl.w   #2,d1                  ; * 4 = longword offset into FFA6A0 table
    movea.l #$00ffa6a0,a0         ; aircraft_fleet ($FFA6A0): 4 longwords (one per player)
    and.l   (a0,d1.w),d0          ; test bit in player's fleet longword
    beq.b   .l1_d
    move.w  #$0762,d2             ; tile $0762 = fleet member indicator
    bra.b   .l1_commit

.l1_d:                                   ; $006C60
    move.w  #$0763,d2             ; tile $0763 = "other" (no relationship) indicator

; --- Store entry in result buffer ---
.l1_commit:                              ; $006C64
    ; Result buffer entry format: 4 words per char entry
    ;   word[0] = CharRangeScoreMap[char].byte[1] + $80  (display row position)
    ;   word[1] = 0                                       (padding)
    ;   word[2] = tile_id (d2)                            (relationship tile)
    ;   word[3] = CharRangeScoreMap[char].byte[0] + $80  (display col position)
    ; CharRangeScoreMap: A3 points to current char's entry (2 bytes: col, row)
    moveq   #0,d0
    move.b  $1(a3),d0             ; CharRangeScoreMap byte[1] = row coord
    addi.w  #$0080,d0             ; + $80 = display row (GameCommand coordinate offset)
    move.w  d0,(a2)+              ; store row word in result buffer
    clr.w   (a2)+                 ; padding word
    move.w  d2,(a2)+              ; store tile_id
    moveq   #0,d0
    move.b  (a3),d0              ; CharRangeScoreMap byte[0] = col coord
    addi.w  #$0080,d0            ; + $80 = display col
    move.w  d0,(a2)+             ; store col word

; --- Revenue bar: draw if city_data shows net positive for this char's city ---
    ; city_data layout ($FFBA80): 89 cities x 4 entries x 2 bytes = 8 bytes per city
    ;   Access: base + (city_index * 8) + (player_index * 2)
    ;   byte[0] = metric_A, byte[1] = metric_B at that word
    ;   Bar drawn when metric_A - metric_B > 0
    move.w  d3,d0
    lsl.w   #3,d0                  ; city_index * 8 (stride per city in city_data)
    move.w  $000a(a6),d1          ; player_index
    add.w   d1,d1                  ; * 2 = word offset for player within city entry
    add.w   d1,d0                  ; d0 = city_index*8 + player_index*2
    movea.l #$00ffba80,a0         ; city_data ($FFBA80): 89 cities x 4 entries x 2 bytes
    lea     (a0,d0.w),a0
    movea.l a0,a4                  ; a4 = ptr to this city/player word in city_data
    moveq   #0,d0
    move.b  (a4),d0               ; city_data byte[0] = metric_A (e.g. popularity/income)
    moveq   #0,d1
    move.b  $1(a4),d1             ; city_data byte[1] = metric_B (e.g. cost/baseline)
    sub.w   d1,d0                  ; d0 = metric_A - metric_B (net delta)
    move.w  d0,d2
    ble.b   .l1_nobar              ; <= 0: no bar to draw

    ; Draw revenue bar: call $01DFBE with (delta, col_pos, row_pos, row+8, col)
    ; This renders a proportional bar graphic on the relationship panel.
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)               ; bar magnitude
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)               ; screen col position (d6 = $0660 base)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)               ; screen row position (d7 = $1F base)
    moveq   #0,d0
    move.b  $1(a3),d0             ; CharRangeScoreMap byte[1] = row coord
    addq.l  #8,d0                  ; + 8 = offset for bar placement
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0               ; CharRangeScoreMap byte[0] = col coord
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe     ; jsr $01DFBE: draw revenue/affinity bar graphic
    lea     $0014(sp),sp
    addq.w  #1,d6                  ; advance screen col position
.l1_nobar:                               ; $006CD4
    addq.w  #1,d7                  ; advance screen row position
    addq.l  #2,a3                  ; advance CharRangeScoreMap ptr (2 bytes per entry)
    subq.w  #1,d5                  ; decrement remaining count
    addq.w  #1,d3                  ; advance char_code
.loop1_check:                            ; $006CDC
    tst.w   d5                     ; any remaining chars in range1?
    bgt.w   .loop1_body

; ============================================================================
; --- Phase: Load range2 parameters and run loop 2 ---
; ============================================================================
    ; Load range2 from CharTypeRangeTable entry (byte[2] = range2_start, byte[3] = range2_count)
    movea.l -$4(a6),a0
    move.b  $2(a0),d0             ; byte[2] = range2_start char_code
    andi.l  #$ff,d0
    add.w   d0,d0                  ; * 2 = word offset into CharRangeScoreMap
    movea.l #$0005e9fa,a0         ; CharRangeScoreMap ($05E9FA)
    lea     (a0,d0.w),a0
    movea.l a0,a3                  ; a3 = ptr to range2 first CharRangeScoreMap entry

    movea.l -$4(a6),a0
    move.b  $2(a0),d3             ; d3 = range2_start char_code
    andi.l  #$ff,d3

    movea.l -$4(a6),a0
    move.b  $3(a0),d5             ; d5 = range2_count (loop iteration count)
    andi.l  #$ff,d5

    clr.w   d4                    ; d4 = loop2 index (0-based, unlike loop1)
    bra.w   .loop2_check

; ============================================================================
; --- Phase: Loop 2 -- iterate range2 characters (alliance-word path) ---
; ============================================================================
.loop2_body:                             ; $006D20
    ; Alliance membership test: uses the alliance word table at $FFBD6C.
    ; Table layout: indexed by (player_index * $0E + char_index_in_range * 2).
    ; Tests bit D4 in the word read from that offset.
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1                  ; d1 = 1 << d4 (bitmask for current range2 entry)
    move.l  d1,d0

    ; Compute index into alliance table: player_index * $0E + char_index * 2
    ; Note: D7 is temporarily borrowed for the char_index * 2 term (restored after)
    move.w  $000a(a6),d1          ; player_index
    mulu.w  #$000e,d1             ; * $0E (14 = stride of alliance word block per player)
    movea.l d7,a0                 ; borrow d7 as address register (save d7 -> a0)
    move.w  $000e(a6),d7          ; char_index
    add.w   d7,d7                 ; char_index * 2
    exg     d7,a0                 ; restore d7 from a0, put old d7 back in a0
    add.w   a0,d1                 ; d1 = player * $0E + char_index * 2
    movea.l #$00ffbd6c,a0        ; alliance word table ($FFBD6C)
    move.w  (a0,d1.w),d1         ; read alliance word for this player/char slot
    andi.l  #$ffff,d1             ; zero-extend word
    and.l   d1,d0                 ; test bit D4 in alliance word
    beq.b   .l2_b
    move.w  #$0764,d2             ; tile $0764 = allied indicator (range2 variant)
    bra.b   .l2_commit

.l2_b:                                   ; $006D58
    move.w  #$0765,d2             ; tile $0765 = non-allied (range2 variant)

; --- Store range2 entry in result buffer ---
.l2_commit:                              ; $006D5C
    ; Same 4-word format as loop 1: row+$80, 0, tile, col+$80
    moveq   #0,d0
    move.b  $1(a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+
    clr.w   (a2)+
    move.w  d2,(a2)+
    moveq   #0,d0
    move.b  (a3),d0
    addi.w  #$0080,d0
    move.w  d0,(a2)+

    ; Revenue bar for range2 entry (same city_data lookup as loop 1)
    move.w  d3,d0
    lsl.w   #3,d0                  ; city_index * 8
    move.w  $000a(a6),d1
    add.w   d1,d1                  ; player_index * 2
    add.w   d1,d0
    movea.l #$00ffba80,a0         ; city_data ($FFBA80)
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #0,d0
    move.b  (a4),d0               ; metric_A
    moveq   #0,d1
    move.b  $1(a4),d1             ; metric_B
    sub.w   d1,d0                  ; delta = metric_A - metric_B
    move.w  d0,d2
    ble.b   .l2_nobar

    ; Draw revenue bar
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  $1(a3),d0
    addq.l  #8,d0
    move.l  d0,-(sp)
    moveq   #0,d0
    move.b  (a3),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$dfbe     ; jsr $01DFBE: draw revenue bar
    ; Flush display: GameCommand $0E after each bar in loop2 (loop1 did not flush per-entry)
    pea     ($0002).w
    pea     ($000e).w
    dc.w    $4eb9,$0000,$0d64     ; jsr GameCommand $0E: commit bar tile to display
    lea     $001c(sp),sp
    addq.w  #1,d6                 ; advance screen col
.l2_nobar:                               ; $006DDA
    addq.w  #1,d7                 ; advance screen row
    addq.l  #2,a3                 ; advance CharRangeScoreMap ptr
    subq.w  #1,d5                 ; decrement range2 count
    addq.w  #1,d3                 ; advance char_code
    addq.w  #1,d4                 ; advance loop2 index
.loop2_check:                            ; $006DE4
    tst.w   d5
    bgt.w   .loop2_body

; --- Phase: Render result buffer via GameCommand $0F and final display calls ---
    ; Sum of range1_count + range2_count = total entries in result buffer
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)              ; result buffer ptr
    movea.l -$4(a6),a0           ; saved CharTypeRangeTable entry ptr
    move.b  $1(a0),d0            ; byte[1] = range1_count
    andi.l  #$ff,d0
    movea.l -$4(a6),a0
    move.b  $3(a0),d1            ; byte[3] = range2_count
    andi.l  #$ff,d1
    add.w   d1,d0                 ; total_entries = range1_count + range2_count
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64    ; jsr GameCommand $0F: render result buffer as panel
    ; Call char detail display functions
    move.w  $000e(a6),d0         ; char_index
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0         ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9e1c    ; jsr DrawPlayerRoutes ($009E1C): draw player route icons on map
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03e0          ; jsr $007226 (PC-relative): final relationship panel render
    nop
    lea     $0028(sp),sp
    bra.w   .exit

; ============================================================================
; --- Path B: char_index >= 7 -- acquaintance scan path ---
; ============================================================================
.alt_path:                               ; $006E56
    ; Scan first 32 entries of CharPortraitPos ($05E948) for chars in common with player.
    ; CharPortraitPos: word-pair entries (x_screen, y_screen) per char.
    movea.l #$0005e948,a3        ; CharPortraitPos ($05E948): portrait position table
    clr.w   d4                   ; d4 = scan index (0-31)
    clr.w   d3                   ; d3 = count of matching entries stored in result buffer
    bra.b   .alt_check

.alt_body:                               ; $006E62
    ; Classify each char D4: hub match or fleet member?
    moveq   #0,d0
    move.b  $1(a5),d0            ; player_record+$01 = hub_city byte
    cmp.w   d4,d0                ; hub_city == scan_index?
    bne.b   .alt_b
    move.w  #$0760,d2            ; tile $0760 = hub match
    bra.b   .alt_commit

.alt_b:                                  ; $006E72
    ; Test entity_bits ($FF08EC): bit D4 in player's longword
    ; entity_bits: longword array indexed by player_index * 4
    move.w  d4,d0
    ext.l   d0
    moveq   #1,d1
    lsl.l   d0,d1                ; d1 = 1 << d4
    move.l  d1,d0
    move.w  $000a(a6),d1        ; player_index
    lsl.w   #2,d1               ; * 4 = longword offset
    movea.l #$00ff08ec,a0       ; entity_bits ($FF08EC): per-player entity bitfield table
    and.l   (a0,d1.w),d0        ; test bit D4 in player's entity bitfield
    beq.b   .alt_c
    move.w  #$0761,d2           ; tile $0761 = entity/fleet member in acquaintance context
    bra.b   .alt_commit

.alt_c:                                  ; $006E94
    clr.w   d2                   ; d2 = 0: no match (skip this entry)

.alt_commit:                             ; $006E96
    tst.w   d2                   ; d2 == 0 = no relationship?
    beq.b   .alt_skip            ; skip: don't add to result buffer

    ; Store 4-word entry in result buffer
    ; Row/col from CharPortraitPos: byte[1] = row, byte[0] = col (+ $7C offset)
    moveq   #0,d0
    move.b  $1(a3),d0           ; CharPortraitPos byte[1] = row position
    addi.w  #$007c,d0           ; + $7C (portrait coordinate offset, smaller than loop1's $80)
    move.w  d0,(a2)+            ; store row
    clr.w   (a2)+               ; padding
    moveq   #0,d0
    move.w  d2,d0
    move.w  d0,(a2)+            ; store tile_id ($0760 or $0761)
    moveq   #0,d0
    move.b  (a3),d0             ; CharPortraitPos byte[0] = col position
    addi.w  #$007c,d0           ; + $7C
    move.w  d0,(a2)+            ; store col
    addq.w  #1,d3               ; d3++ = one more entry in result buffer

.alt_skip:                               ; $006EBA
    addq.l  #2,a3               ; advance CharPortraitPos ptr (2 bytes per entry)
    addq.w  #1,d4               ; d4++ = next scan index
.alt_check:                              ; $006EBE
    cmpi.w  #$20,d4             ; 32 entries total (0-31)?
    blt.b   .alt_body

; --- Phase: Render acquaintance result buffer via GameCommand $0F ---
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$c4(a6)            ; result buffer ptr
    move.w  d3,d0               ; total entries stored
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    pea     ($000f).w
    dc.w    $4eb9,$0000,$0d64   ; jsr GameCommand $0F: render acquaintance panel

; --- Phase: Exit ---
.exit:                                   ; $006EE0
    movem.l -$ec(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ---------------------------------------------------------------------------
; BitFieldSearch -- Search bitfield in RAM for a set bit
; Args: $C(SP) = entity index (long), $12(SP) = table index (word)
; Returns: D0 = bit position if found, $FF if not
; Uses ROM table at $5ECBC (byte[0]=start bit, byte[1]=count)
; and RAM table at $FF08EC (longwords indexed by entity)
; Called 47 times
; ---------------------------------------------------------------------------
BitFieldSearch:                                                ; $006EEA
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D1                                          ; entity index
    MOVE.W  $12(SP),D0                                         ; table index
    LSL.W   #2,D0                                              ; * 4 (entry size)
    MOVEA.L #$0005ECBC,A0                                      ; ROM lookup table
    LEA     0(A0,D0.W),A0                                      ; point to entry
    MOVEA.L A0,A1                                              ; A1 = entry pointer
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit position
    MOVEQ   #1,D3
    LSL.L   D0,D3                                              ; D3 = 1 << start_bit (mask)
    CLR.W   D2                                                 ; counter = 0
    BRA.S   .bfs_check
.bfs_loop:                                                     ; $006F10
    MOVE.W  D1,D0
    LSL.W   #2,D0                                              ; entity * 4
    MOVEA.L #$00FF08EC,A0                                      ; RAM bitfield table
    MOVE.L  0(A0,D0.W),D0                                      ; load entity bits
    AND.L   D3,D0                                              ; test current bit
    BEQ.S   .bfs_next                                          ; not set, continue
    MOVEQ   #0,D0
    MOVE.B  (A1),D0                                            ; start bit
    ADD.W   D2,D0                                              ; + offset = actual position
    BRA.S   .bfs_exit                                          ; found
.bfs_next:                                                     ; $006F2A
    ADD.L   D3,D3                                              ; shift mask left by 1
    ADDQ.W  #1,D2                                              ; counter++
.bfs_check:                                                    ; $006F2E
    MOVEQ   #0,D0
    MOVE.B  $1(A1),D0                                          ; bit count limit
    CMP.W   D2,D0                                              ; limit > counter?
    BGT.S   .bfs_loop                                          ; continue searching
    MOVE.W  #$00FF,D0                                          ; not found sentinel
.bfs_exit:                                                     ; $006F3C
    MOVEM.L (SP)+,D2-D3
    RTS
