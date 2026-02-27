; ============================================================================
; RunAssignmentUI -- Draws the assignment screen with character icon grid and runs a character-code entry loop supporting append and delete, printing the typed name
; Called: ?? times.
; 1524 bytes | $016958-$016F4B
; ============================================================================
RunAssignmentUI:                                                  ; $016958
; --- Phase: Frame setup -- allocate locals and establish base pointers ---
; Frame: link a6,#-$1c allocates $1C bytes of locals.
; Key locals:
;   -$0002(a6)  = has_input_flag   (1 = hardware input latched and ready)
;   -$0004(a6)  = last_input_raw   (raw button word for ProcessInputLoop state machine)
;   -$0006(a6)  = col_offset       (a3 points here; horizontal cursor column offset in grid)
;   -$0008(a6)  = row_group        (a5 points here; which of the 4 char-type rows is active)
;   -$0009(a6)  = char_code        (byte: most-recently-decoded char code from grid)
;   -$001a(a6)  = typed_name_buf   (7-byte zero-terminated buffer for the typed char name)
; Register usage throughout:
;   d2  = cursor column within the current grid row
;   d3  = cursor row (grid y: $17 = top area, changes as user navigates)
;   d4  = player_index argument
;   d5  = typed char count (0..d7)
;   d6  = blink_phase (toggled 0/1 each frame for cursor blink)
;   d7  = max_chars (constant: 7)
;   a2  = typed_name_buf write pointer (advances with each typed char)
;   a3  = col_offset ptr (-$0006 from a6)
;   a4  = GameCommand dispatcher ($0D64)
;   a5  = row_group ptr (-$0008 from a6)
    link    a6,#-$1c
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4               ; d4 = player_index (argument)
    lea     -$0006(a6),a3              ; a3 = &col_offset (grid column cursor state)
    movea.l #$0d64,a4                  ; a4 = GameCommand dispatcher ($0D64)
    lea     -$0008(a6),a5              ; a5 = &row_group  (grid row-group selector, 0-3)

; ============================================================================
; --- Phase: Screen layout -- draw background and char icon grid ---
; ============================================================================

; GameCommand $1A: set up the main display area (background + borders)
; Args: mode=$8000, rows=$A, cols=$20, y=$12, x=0, x2=0
    move.l  #$8000,-(sp)               ; display attribute: $8000 (priority flag)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)                       ; GameCommand(26, 0, 0, $12, $20, $A, $8000)

; DisplaySetup: load background tileset from ROM at $4C976 into VRAM
    pea     ($0010).w                  ; VRAM tile offset
    pea     ($0010).w                  ; tile count
    pea     ($0004C976).l              ; ptr to compressed tile data at $4C976
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092 -- DisplaySetup($4C976, $10, $10)
    lea     $0028(sp),sp

; GameCommand $1B: draw the char-type panel with sprite data from $4CD56
; Args: ptr=$4CD56, col=$D, cols=$20, row=$F, x=0, y=1
    pea     ($0004CD56).l              ; ptr to panel sprite data at $4CD56
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)                       ; GameCommand(27, 1, 0, $F, $20, $D, $4CD56)
    lea     $001c(sp),sp

; ============================================================================
; --- Phase: Draw 4 char-code icon rows (d2 = 0..3) ---
; Each row displays icons for one char-type group (4 groups total).
; The icon tile address is $0774 + d2 (base tile offset into VRAM).
; Screen placement: column = d2*2+3, row = 7, tile count = 1.
; ============================================================================
    clr.w   d2                         ; d2 = row iterator (0-3)
.l169ca:                                                ; $0169CA
    move.w  d2,d0
    ext.l   d0
    addi.l  #$0774,d0                  ; VRAM tile number = $0774 + d2 (icon tile IDs)
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0                     ; tile index (1-based row label)
    move.l  d0,-(sp)
    pea     ($0010).w                  ; display column $10 (right half)
    pea     ($0002).w                  ; display row 2
    pea     ($0007).w                  ; VDP BAT row $7 (tile y coord)
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0                     ; screen col = d2*2 + 3 (left-aligned, 2-wide spacing)
    move.l  d0,-(sp)
    pea     ($0003).w                  ; sprite width = 3
    pea     ($0001).w                  ; sprite height = 1
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760 -- PlaceSpriteIcon(1, 3, col, 7, 2, $10, idx, tile)
    lea     $0020(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l169ca                    ; loop 4 times (one icon per char-type row)

; Load the assignment grid tilemap from ROM at $76A5E ($30 tiles, VRAM slot $10)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l              ; ptr to assignment grid tile data at $76A5E
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092 -- DisplaySetup($76A5E, $30, $10)

; LZ_Decompress: decompress assignment grid graphics from $0A1B08 into save_buf_base
    move.l  ($000A1B08).l,-(sp)       ; ptr to compressed assignment grid LZ data
    pea     ($00FF1804).l              ; dest: save_buf_base ($FF1804)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC -- LZ_Decompress

; CmdPlaceTile: stamp decompressed tiles into VRAM at position ($6B, $10F)
    pea     ($006B).w                  ; tile row $6B
    pea     ($010F).w                  ; tile column $10F
    pea     ($00FF1804).l              ; source data
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668 -- CmdPlaceTile($FF1804, $10F, $6B)
    lea     $0020(sp),sp

; GameCommand $1B: draw the char name label panel from $71A64
    pea     ($00071A64).l              ; ptr to label tile data at $71A64
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)                       ; GameCommand(27, 0, 0, $E, $20, $B, $71A64)

; ============================================================================
; --- Phase: Init input state and cursor ---
; ============================================================================
    moveq   #$7,d7                     ; d7 = max_chars = 7 (max name length)
    clr.b   -$001a(a6)                ; typed_name_buf[0] = '\0' (empty name)
    lea     -$001a(a6),a2             ; a2 = typed_name_buf write pointer
    clr.w   d5                         ; d5 = typed char count = 0
    move.w  #$16,(a3)                 ; col_offset = $16 (initial column in grid; $16 = far right)
    move.w  #$3,(a5)                  ; row_group = 3 (start at bottom char-type row)
    moveq   #$17,d3                    ; d3 = cursor_row = $17 (initial y within grid)
    moveq   #$12,d2                    ; d2 = cursor_col = $12 (initial x within grid)

; Wait for VBlank / display sync before entering input loop
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942 -- WaitVBlank/DisplaySync($20, $20, 0, 0)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC -- ReadInputOnce(0) -> d0 (flush stale input)
    lea     $0030(sp),sp
    tst.w   d0
    beq.b   .l16aa6
    moveq   #$1,d0                     ; d0 = 1 if hardware input was ready
    bra.b   .l16aa8
.l16aa6:                                                ; $016AA6
    moveq   #$0,d0
.l16aa8:                                                ; $016AA8
    move.w  d0,-$0002(a6)             ; has_input_flag = d0
    clr.w   -$0004(a6)                ; last_input_raw = 0
    clr.w   ($00FF13FC).l             ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l            ; input_init_flag = 0
    clr.w   d6                         ; d6 = blink_phase = 0

; ============================================================================
; --- Phase: Main input loop -- blink cursor, poll input, handle edits ---
; ============================================================================
.l16abe:                                                ; $016ABE
; Blink cursor: flash at current grid position.
; Cursor in "return zone": if d3=$17 and d2=$12 (corner), use fixed coords ($CB, $B6).
; Otherwise: x = d3*8+3, y = d2*12 + d2*8 - $AE (screen pixel formula).
    cmpi.w  #$17,d3
    blt.b   .l16ae2                    ; d3 < $17: not in return zone
    cmpi.w  #$12,d2
    bne.b   .l16ae2                    ; d2 != $12: not in return zone
    ; Return-key cursor position ($CB col, $B6 row):
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00B6).w                  ; cursor pixel y = $B6
    pea     ($00CB).w                  ; cursor pixel x = $CB
    bra.b   .l16b16
.l16ae2:                                                ; $016AE2
    ; Regular cursor: compute screen position from (d2, d3)
    ; x = d2*12 + d2*8 - $AE = d2*(12+8) - $AE = d2*20 - $AE
    ; y = d3*8 + 3
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0                      ; d0 = d2 * 3
    lsl.l   #$2,d0                     ; d0 = d2 * 12  (3 * 4)
    move.w  d2,d1
    ext.l   d1
    lsl.l   #$3,d1                     ; d1 = d2 * 8
    add.l   d1,d0                      ; d0 = d2*12 + d2*8 = d2*20
    subi.l  #$ae,d0                    ; d0 = d2*20 - $AE (pixel y offset)
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0                     ; d0 = d3 * 8
    addq.l  #$3,d0                     ; d0 = d3*8 + 3 (pixel x offset)
    move.l  d0,-(sp)
.l16b16:                                                ; $016B16
    clr.l   -(sp)
    pea     ($0740).w                  ; blink tile ID $0740 (cursor sprite)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044 -- DrawSprite($0740, 0, x, y, 2, 2, $8000)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)                       ; GameCommand($E, 1) -- display flush
    lea     $0024(sp),sp
    moveq   #$1,d0
    eor.w   d0,d6                     ; toggle blink_phase (0->1->0)

; Draw current typed name in input box if any chars typed
    cmp.w   d7,d5                      ; d5 >= d7 (max chars reached)?
    bge.b   .l16b62
    ; Show name-in-progress (highlighted, at screen position $B0 + d5*8, row $88)
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0088).w                  ; sprite y = $88 (name display row)
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$3,d0                     ; d5 * 8 (char width in pixels)
    addi.l  #$b0,d0                    ; x = d5*8 + $B0 (name display x origin)
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0770).w                  ; char tile base $0770
    bra.b   .l16b76
.l16b62:                                                ; $016B62
    ; All chars filled: draw blank tile at end position
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)                      ; tile = 0 (blank)
.l16b76:                                                ; $016B76
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044 -- DrawSprite(tile, 1, x, y, 1, 1, attr)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)                       ; GameCommand($E, 1)
    lea     $0024(sp),sp

; --- Check has_input_flag: if set, try ReadInputOnce to consume it ---
    tst.w   -$0002(a6)                ; has_input_flag?
    beq.b   .l16bae                    ; not set -- skip to ProcessInputLoop
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC -- ReadInputOnce(0) -> d0
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l16bae
    pea     ($0003).w
.l16ba2:                                                ; $016BA2
    pea     ($000E).w
    jsr     (a4)                       ; GameCommand($E, 3)
.l16ba8:                                                ; $016BA8
    addq.l  #$8,sp
    bra.w   .l16abe                    ; loop back

; ============================================================================
; --- Phase: Input decode via ProcessInputLoop ---
; ============================================================================
.l16bae:                                                ; $016BAE
    clr.w   -$0002(a6)                ; has_input_flag = 0
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)                       ; GameCommand($E, 4) -- display sync
    move.w  -$0004(a6),d0             ; last_input_raw
    move.l  d0,-(sp)
    pea     ($000A).w                  ; timeout = $A frames
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290 -- ProcessInputLoop(raw, $A) -> d0
    lea     $0010(sp),sp

; Decode button bits: lower 6 bits = D-pad (bits 0-3) + action keys (bits 4-5)
    andi.w  #$3f,d0                    ; mask to 6 button bits
    move.w  d0,-$0004(a6)            ; store as last_input_raw for next iteration
    andi.w  #$30,d0                    ; test bits 4-5: A/B action buttons
    beq.w   .l16cba                    ; no action button: go to D-pad navigation

; --- Action button pressed ---
    clr.w   ($00FF13FC).l             ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l            ; input_init_flag = 0
    move.w  -$0004(a6),d0
    andi.w  #$20,d0                    ; bit 5 = A button (append char)?
    beq.b   .l16c6e                    ; not A: must be B (delete)

; ============================================================================
; --- Phase: Append char -- A button pressed ---
; Decode current cursor position to a char code from the grid table at $47A9C.
; The grid is organized as: row_group * $1C columns + col_offset
; Char code table at $47A9C: indexed by row_group * $1C + col_offset
; ============================================================================
.l16c04:                                                ; $016C04
    ; Check if cursor is at the "return" position (d3=$17, d2=$12)
    cmpi.w  #$17,d3
    blt.b   .l16c04_notret             ; d3 < $17: definitely not return zone
    cmpi.w  #$12,d2
    beq.w   .l16e66                    ; d3>=$17 AND d2=$12: Enter key -- commit name
.l16c04_notret:                                         ; $016C04 + 2
    ; Decode char: index = row_group * $1C + col_offset
    move.w  (a5),d0                    ; row_group (0-3)
    mulu.w  #$1c,d0                    ; row_group * $1C (28 chars per row group)
    add.w   (a3),d0                    ; + col_offset = final table index
    movea.l #$00047a9c,a0             ; char code lookup table at $47A9C
    move.b  (a0,d0.w),-$0009(a6)     ; char_code = table[index]

; Remap char code $2D (hyphen) to $20 (space) for display purposes
    cmpi.b  #$2d,-$0009(a6)           ; char_code == '-' ($2D)?
    bne.b   .l16c26
    move.b  #$20,-$0009(a6)           ; replace with space ($20)
.l16c26:                                                ; $016C26

; Ignore if typed_name is already full
    cmp.w   d7,d5                      ; d5 >= max_chars (7)?
    bge.w   .l16abe                    ; yes -- discard input

; Append char to typed_name_buf
    addq.w  #$1,d5                     ; d5++ (typed char count)
    move.b  -$0009(a6),(a2)+          ; *a2++ = char_code (append to buffer)
    clr.b   (a2)                       ; null-terminate after new char

; Render the updated name in the display box
    pea     ($000F).w                  ; display row $F
    pea     ($0016).w                  ; display column $16
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C -- SetDisplayCursor($16, $F)
    pea     -$001a(a6)                 ; ptr to typed_name_buf
    pea     ($0003F948).l             ; format string for name display at $3F948
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270 -- PrintString(fmt, buf)
    lea     $0010(sp),sp

; If name is now full (d5 == d7), move cursor to the "return" key position
    cmp.w   d7,d5
    bne.b   .l16c66
    moveq   #$17,d3                    ; cursor_row = $17 (return row)
    moveq   #$12,d2                    ; cursor_col = $12 (return column)
    move.w  #$16,(a3)                 ; col_offset = $16 (rightmost grid column)
    move.w  #$3,(a5)                  ; row_group = 3 (bottom group)
.l16c66:                                                ; $016C66
    pea     ($0006).w                  ; play sound effect 6 (key click)
    bra.w   .l16ba2                    ; -> GameCommand($E) and loop

; ============================================================================
; --- Phase: Delete char -- B button pressed ---
; ============================================================================
.l16c6e:                                                ; $016C6E
    tst.w   d5                         ; any chars to delete?
    ble.w   .l16abe                    ; buffer empty -- ignore

; Remove last char from typed_name_buf
    subq.l  #$1,a2                     ; a2-- (move write pointer back)
    clr.b   (a2)                       ; null-terminate at new position
    subq.w  #$1,d5                     ; d5-- (typed char count)

; Erase the last char from the display using GameCommand (draw blank/space)
    clr.l   -(sp)
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000F).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)                       ; GameCommand(26, 0, $16, $F, 8, 3, 0) -- erase char box

; Re-render name with one fewer char
    pea     ($000F).w
    pea     ($0016).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C -- SetDisplayCursor($16, $F)
    lea     $0024(sp),sp
    pea     -$001a(a6)
    pea     ($0003F944).l             ; format string for delete/clear at $3F944
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270 -- PrintString(fmt, buf)
    bra.w   .l16ba8                    ; loop back

; ============================================================================
; --- Phase: D-pad navigation -- no action button, decode direction ---
; ============================================================================
.l16cba:                                                ; $016CBA
    move.w  #$1,($00FF13FC).l         ; input_mode_flag = 1 (navigation active)

; Bit $02 = Down
    move.w  -$0004(a6),d0
    andi.w  #$2,d0
    beq.b   .l16d14                    ; not down -- try other directions

; --- Down: advance row_group and cursor_col ---
; row_group cycles 0..3 (clamped at 3)
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0                     ; row_group + 1
    moveq   #$3,d1
    cmp.l   d0,d1
    ble.b   .l16ce0                    ; > 3?
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0                     ; use row_group+1 (it was <= 3)
    bra.b   .l16ce2
.l16ce0:                                                ; $016CE0
    moveq   #$3,d0                     ; clamp to max = 3
.l16ce2:                                                ; $016CE2
    move.w  d0,(a5)                    ; row_group = new value
; cursor_col (d2) cycles $F...$12 (clamped at $12)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$12,d1
    cmp.l   d0,d1
    ble.b   .l16cf8
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16cfa
.l16cf8:                                                ; $016CF8
    moveq   #$12,d0                    ; clamp col at $12
.l16cfa:                                                ; $016CFA
    move.w  d0,d2                      ; cursor_col = new value
; Special: if col=$12 and cursor_row is $18/$19, snap row to $17 (return row area)
    cmpi.w  #$12,d2
    bne.b   .l16d14
    cmpi.w  #$18,d3
    beq.b   .l16d0e
    cmpi.w  #$19,d3
    bne.b   .l16d14
.l16d0e:                                                ; $016D0E
    moveq   #$17,d3                    ; snap cursor_row to $17 (return zone)
    move.w  #$16,(a3)                 ; col_offset = $16

; Bit $01 = Up
.l16d14:                                                ; $016D14
    move.w  -$0004(a6),d0
    andi.w  #$1,d0
    beq.b   .l16d56                    ; not up

; Guard: don't navigate up if already at boundary (d3 < $15 or d2 <= $11)
    cmpi.w  #$15,d3
    blt.b   .l16d2a
    cmpi.w  #$11,d2
    ble.b   .l16d56                    ; at boundary -- ignore up

; --- Up: decrement row_group and cursor_col ---
.l16d2a:                                                ; $016D2A
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0                     ; row_group - 1
    ble.b   .l16d3a                    ; <= 0: clamp to 0
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d3c
.l16d3a:                                                ; $016D3A
    moveq   #$0,d0                     ; clamp to 0
.l16d3c:                                                ; $016D3C
    move.w  d0,(a5)
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0                     ; cursor_col - 1
    moveq   #$f,d1
    cmp.l   d0,d1
    bge.b   .l16d52                    ; >= $F: value is valid
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d54
.l16d52:                                                ; $016D52
    moveq   #$f,d0                     ; clamp to $F (minimum col)
.l16d54:                                                ; $016D54
    move.w  d0,d2

; Bit $08 = Right (advance column within row)
.l16d56:                                                ; $016D56
    move.w  -$0004(a6),d0
    andi.w  #$8,d0
    beq.w   .l16e10                    ; not right

; Guard: boundary check for right movement
    cmpi.w  #$11,d2
    bge.b   .l16d70                    ; d2 >= $11: handle row-dependent col wrap
    cmpi.w  #$14,d3
    bge.w   .l16e10                    ; d3 >= $14 and d2 < $11: blocked at bottom

.l16d70:                                                ; $016D70
; Row-specific column limits for Right navigation:
;   d2 == $11 (row group A): col_offset max $18, cursor_row max $19
;   d2 == $12 (row group B): col_offset max $16, cursor_row max $17
;   else (other rows):       col_offset max $1A, cursor_row max $19
    cmpi.w  #$11,d2
    bne.b   .l16da2

; Row group A ($11): advance col_offset, then cursor_row
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0                     ; col_offset + 1
    moveq   #$18,d1
    cmp.l   d0,d1
    ble.b   .l16d8a
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16d8c
.l16d8a:                                                ; $016D8A
    moveq   #$18,d0                    ; clamp col_offset at $18
.l16d8c:                                                ; $016D8C
    move.w  d0,(a3)                    ; col_offset = new value
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0                     ; cursor_row + 1
    moveq   #$19,d1
    cmp.l   d0,d1
    ble.b   .l16df4
.l16d9a:                                                ; $016D9A
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0                     ; use incremented row (it exceeds limit: wrap in caller)
    bra.b   .l16df6

.l16da2:                                                ; $016DA2
    cmpi.w  #$12,d2
    bne.b   .l16dd0

; Row group B ($12): col_offset max $16, cursor_row max $17
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$16,d1
    cmp.l   d0,d1
    ble.b   .l16dbc
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16dbe
.l16dbc:                                                ; $016DBC
    moveq   #$16,d0                    ; clamp col_offset at $16
.l16dbe:                                                ; $016DBE
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$17,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a                    ; exceeds $17: wrap (handled by caller)
    moveq   #$17,d0                    ; clamp cursor_row at $17
    bra.b   .l16df6

.l16dd0:                                                ; $016DD0
; Other rows: col_offset max $1A, cursor_row max $19
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$1a,d1
    cmp.l   d0,d1
    ble.b   .l16de4
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16de6
.l16de4:                                                ; $016DE4
    moveq   #$1a,d0                    ; clamp col_offset at $1A
.l16de6:                                                ; $016DE6
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$19,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a
.l16df4:                                                ; $016DF4
    moveq   #$19,d0                    ; clamp cursor_row at $19
.l16df6:                                                ; $016DF6
    move.w  d0,d3                      ; cursor_row = new value

; Validate: skip to space? If grid cell at new position is $20 (space), keep searching right
    move.w  (a5),d0
    mulu.w  #$1c,d0                    ; row_group * $1C (28 chars per row)
    add.w   (a3),d0                    ; + col_offset = table index
    movea.l #$00047a9c,a0             ; char code table at $47A9C
    cmpi.b  #$20,(a0,d0.w)            ; cell == space ($20)?
    beq.w   .l16d70                    ; yes -- advance again (skip empty cells)

; Bit $04 = Left (decrement column within row)
.l16e10:                                                ; $016E10
    move.w  -$0004(a6),d0
    andi.w  #$4,d0
    beq.w   .l16abe                    ; not left -- restart loop

; --- Left: decrement col_offset and cursor_row ---
.l16e1c:                                                ; $016E1C
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0                     ; col_offset - 1
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l16e30                    ; >= 1: valid
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e32
.l16e30:                                                ; $016E30
    moveq   #$1,d0                     ; clamp col_offset at 1 (minimum)
.l16e32:                                                ; $016E32
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0                     ; cursor_row - 1
    moveq   #$2,d1
    cmp.l   d0,d1
    bge.b   .l16e48                    ; >= 2: valid
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e4a
.l16e48:                                                ; $016E48
    moveq   #$2,d0                     ; clamp cursor_row at 2 (minimum)
.l16e4a:                                                ; $016E4A
    move.w  d0,d3

; Validate: skip spaces when moving left too
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    cmpi.b  #$20,(a0,d0.w)            ; space char?
    beq.b   .l16e1c                    ; yes -- keep moving left
    bra.w   .l16abe                    ; done -- restart main loop

; ============================================================================
; --- Phase: Enter key -- commit typed name and search for matching char ---
; ============================================================================
.l16e66:                                                ; $016E66
    tst.w   d5                         ; any chars typed?
    beq.b   .l16e9e                    ; empty name -- skip search, go to exit setup

; Count non-space chars in typed_name_buf (d2 = effective char count)
    clr.w   d2                         ; d2 = non-space char count
    clr.w   d3                         ; d3 = index into typed_name_buf
    bra.b   .l16e7c
.l16e70:                                                ; $016E70
    cmpi.b  #$20,-$1a(a6,d3.w)        ; typed_name_buf[d3] == space?
    beq.b   .l16e7a
    addq.w  #$1,d2                     ; non-space: increment count
.l16e7a:                                                ; $016E7A
    addq.w  #$1,d3
.l16e7c:                                                ; $016E7C
    cmp.w   d5,d3                      ; iterated all typed chars?
    blt.b   .l16e70
    tst.w   d2                         ; any non-space chars?
    beq.b   .l16e9e                    ; all spaces -- skip lookup

; Lookup matching char in player's record block at $FF00A8 + player*$10
; $FF00A8: 4 player blocks * $10 bytes; player_index stride = $10 (lsl.w #$4 = *16)
    pea     -$001a(a6)                 ; typed_name_buf
    move.w  d4,d0
    lsl.w   #$4,d0                     ; player_index * $10 (16 bytes per player block)
    movea.l #$00ff00a8,a0             ; $FF00A8: player name lookup / assignment block
    pea     (a0,d0.w)                  ; ptr to this player's block
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C -- LookupCharByName(player_block, typed_name)
    addq.l  #$8,sp

; ============================================================================
; --- Phase: Teardown and exit -- restore display and show assignment results ---
; ============================================================================
.l16e9e:                                                ; $016E9E
; Display sync + clear assignment panel
    pea     ($0002).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8 -- WaitFrames(0, 2) (2 frame delay)

; GameCommand $1A: restore original background display area
    clr.l   -(sp)
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)                       ; GameCommand(26, 0, 0, $E, $20, $B, 0)
    lea     $0024(sp),sp

; WaitVBlank: sync display before drawing new content
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942 -- WaitVBlank($20, $20, 0, 0)
    lea     $0010(sp),sp

; ============================================================================
; --- Phase: Draw 4 player assignment summaries (d4 = 0..3) ---
; For each player, render: char slot indicator + player name strip + assignment data.
; Player block stride at $FF00A8: $10 bytes per player (lsl.w #$4 = *16).
; ============================================================================
    clr.w   d4                         ; d4 = player iterator (0-3)
.l16ede:                                                ; $016EDE
; GameCommand $1A: clear player row area
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0007).w
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0                     ; screen row = d4*2 + 3 (two rows per player, starting at 3)
    move.l  d0,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)                       ; GameCommand(26, 0, 3, row, 7, 2, 0)

; SetDisplayCursor at player's row
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0                     ; same row calculation
    move.l  d0,-(sp)
    pea     ($0003).w                  ; column 3
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C -- SetDisplayCursor(3, row)

; Print player name from $FF00A8 + player*$10 block
    move.w  d4,d0
    lsl.w   #$4,d0                     ; player * $10 (16 bytes per player block)
    movea.l #$00ff00a8,a0             ; $FF00A8: player name block base
    pea     (a0,d0.w)                  ; ptr to this player's block
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270 -- PrintString(block_ptr)
    lea     $0028(sp),sp
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l16ede                    ; loop for all 4 players

; ============================================================================
; --- Phase: Epilog -- restore registers and return ---
; ============================================================================
    movem.l -$0044(a6),d2-d7/a2-a5
    unlk    a6
    rts
    movem.l d2-d4,-(sp)
    move.l  $0018(sp),d4
    clr.w   d3
    clr.b   d2
    tst.w   $0016(sp)
    dc.w    $6F08,$206F                                          ; $016F4C
; === Translated block $016F50-$016F9E ===
; 1 functions, 78 bytes
