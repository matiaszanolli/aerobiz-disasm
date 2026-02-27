; ============================================================================
; ManageRouteSlots -- Interactive browser for a player's route slots; builds slot revenue list, renders route slot screen, and handles slot selection input.
; Called: ?? times.
; 1366 bytes | $0112EE-$011843
;
; Args: $A(a6) = player_index (word)
;       $E(a6) = scenario_type (word)  [0-3: standard dialog; >=4: ShowPlayerInfo variant]
; Frame layout (a6-relative):
;   -$000A : base of slot-type lookup result array (5 words, a3 = ptr)
;            Words 0-3: resolved aircraft index per $FF0338 entry, or $FFFF if empty
;            Word  4:   $FFFF sentinel terminator
;   -$000C : palette word 4 / a4 base  (also -$000C(a6) == (a4))
;   -$000E : palette word 3
;   -$0010 : palette word 2
;   -$0012 : palette word 1  -- four-word block passed to DisplaySetup ($005092)
;            Normal section:    $026A / $04AE / $0666 / $0AAA
;            Alternate section: $0666 / $0AAA / $026A / $04AE  (swapped at d2>=$18)
;   -$0094 : 148-byte string work buffer (used by ShowDialog and sprintf calls)
;   -$0096 : saved d2 from previous frame (change detection for redraw)
;   -$0098 : saved d6 from previous frame (change detection for redraw)
;   -$009A : display param A for DisplaySetup (init = $03FF)
;   -$009C : display param B for DisplaySetup (init = $06A2)
;   -$009E : display column counter (0-3, cycles mod 4 for tile placement column)
;   -$00A0 : auto-scroll flag (1 = call ReadInput an extra frame this tick)
; Register usage:
;   D2 = row cursor: $0C (col 0) or $12 (col 1) or $18+ (alt section); steps by 6
;   D3 = slot index in current position (0-3 normal, 4 = alt-section sentinel; $FF = exit)
;   D4 = resolved aircraft index for current slot (from result array or RangeLookup)
;   D5 = ProcessInputLoop decoded button word
;   D6 = sub-column cursor (1 or 9; toggles between two row positions)
;   D7 = redraw flag: 1 = force route detail redraw this frame
;   A2 = ptr to current $FF0338 8-byte entry
;   A3 = ptr to slot-type result array base (a6-$0A)
;   A4 = ptr to palette word 4 (a6-$0C)
;   A5 = ptr to this player's $FF0338 block base
; ============================================================================
ManageRouteSlots:                                                  ; $0112EE
    link    a6,#-$a0
    movem.l d2-d7/a2-a5,-(sp)

; --- Phase: Initialize display scroll seeds and redraw flag ---
    move.w  #$03ff,-$009a(a6)          ; display param A (scroll seed)
    move.w  #$06a2,-$009c(a6)          ; display param B (scroll seed)
    moveq   #$1,d7                     ; d7 = 1: force redraw on first iteration

; --- Phase: Build slot-type lookup table from $FF0338 player block ---
    ; $FF0338: per-player route slot state table, stride $20 (32 bytes) per player.
    ; Each 8-byte entry: byte[0]=aircraft_code, byte[1]=slot_type_flags (0=empty).
    ; Loop scans 4 entries, resolves each to an aircraft category via RangeLookup,
    ; or stores $FFFF for empty slots. Results go into the frame array at a6-$0A.
    move.w  $000a(a6),d0               ; player_index
    lsl.w   #$5,d0                     ; * 32 = player stride in $FF0338 table
    movea.l #$00ff0338,a0             ; $FF0338: per-player route slot state table
    lea     (a0,d0.w),a0              ; a0 = base of this player's block
    movea.l a0,a2                      ; a2 = walking ptr (8 bytes per entry)
    lea     -$000a(a6),a3             ; a3 = result array (5 words, a6-$0A)
    clr.w   d3                         ; d3 = loop counter (0-3)
.l1131c:                                                ; $01131C
    tst.b   $0001(a2)                  ; slot_type_flags == 0?
    beq.b   .l11334                    ; yes: empty slot
    moveq   #$0,d0
    move.b  (a2),d0                    ; byte[0] = aircraft_code
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648          ; jsr RangeLookup ($00D648): map aircraft_code -> category 0-7
    addq.l  #$4,sp
    move.w  d0,(a3)                    ; store resolved aircraft index
    bra.b   .l11338
.l11334:                                                ; $011334
    move.w  #$ffff,(a3)                ; $FFFF = empty / no aircraft in this slot
.l11338:                                                ; $011338
    addq.l  #$8,a2                     ; next 8-byte $FF0338 entry
    addq.l  #$2,a3                     ; next word in result array
    addq.w  #$1,d3
    cmpi.w  #$4,d3                     ; 4 entries total
    blt.b   .l1131c
    move.w  #$ffff,(a3)                ; sentinel $FFFF: marks end of result array

; --- Phase: Render initial route slot screen ---
    move.w  $000e(a6),d0               ; scenario_type
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0               ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w RenderRouteSlotScreen        ; draw full route slot panel for this player/scenario

; --- Phase: Initialize palette word block for DisplaySetup ---
    ; Four-word color palette block: passed to DisplaySetup ($005092) as a display descriptor.
    ; The two sets swap when the cursor moves into the alternate section (d2 >= $18).
    move.w  #$026a,-$0012(a6)          ; palette[0] = $026A (primary normal)
    move.w  #$04ae,-$0010(a6)          ; palette[1] = $04AE (primary normal)
    move.w  #$0666,-$000e(a6)          ; palette[2] = $0666 (secondary normal)
    move.w  #$0aaa,-$000c(a6)          ; palette[3] = $0AAA (secondary normal)
    pea     ($0004).w                  ; 4 palette words
    pea     ($0031).w                  ; display mode = $31
    pea     -$0012(a6)                 ; ptr to palette word block
    dc.w    $4eb9,$0000,$5092          ; jsr DisplaySetup ($005092): apply palette to display
    pea     ($0040).w                  ; fill = 64 bytes
    clr.l   -(sp)                      ; fill value = 0
    pea     -$0094(a6)                 ; string work buffer
    dc.w    $4eb9,$0001,$d520          ; jsr MemFillByte ($01D520): clear string work buffer
    lea     $0020(sp),sp

; --- Phase: scenario_type dispatch for intro dialog ---
    cmpi.w  #$4,$000e(a6)             ; scenario_type >= 4?
    bge.b   .l113e8                   ; yes: skip to ShowPlayerInfo path

    ; scenario_type 0-3: build intro dialog string from ROM prefix + per-scenario suffix
    movea.l ($00047992).l,a0          ; $47992: ROM ptr to dialog prefix string
    lea     -$0094(a6),a1             ; a1 = string work buffer
.l113ac:                                                ; $0113AC
    move.b  (a0)+,(a1)+               ; copy bytes until null terminator (strcpy idiom)
    bne.b   .l113ac
    ; Append scenario-specific string from 4-entry pointer table at $47982
    move.w  $000e(a6),d0              ; scenario_type (0-3)
    lsl.w   #$2,d0                    ; * 4 = longword index
    movea.l #$00047982,a0            ; $47982: 4 ROM longword ptrs (one per scenario type)
    move.l  (a0,d0.w),-(sp)          ; push scenario string ptr
    pea     -$0094(a6)                ; push work buffer (already has prefix)
    dc.w    $4eb9,$0001,$e1ba         ; jsr StringAppend ($01E1BA): strcat scenario string
    ; ShowDialog: display assembled string as an in-game dialog
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$0094(a6)                ; assembled string ptr
    move.w  $000a(a6),d0             ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912         ; jsr ShowDialog ($007912)
    lea     $001c(sp),sp
    bra.b   .l113f8

.l113e8:                                                ; $0113E8
    ; scenario_type >= 4: show player info banner instead of text dialog
    move.w  $000a(a6),d0             ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$c43c         ; jsr ShowPlayerInfo ($01C43C)
    addq.l  #$4,sp

; --- Phase: Initialize main loop variables ---
.l113f8:                                                ; $0113F8
    lea     -$000a(a6),a3            ; a3 = slot-type result array base (reset after dialog)
    clr.w   d3                        ; d3 = slot index = 0
    moveq   #$c,d2                    ; d2 = row cursor = $0C (first column group base)
    moveq   #$1,d6                    ; d6 = sub-column cursor = 1 (first row position)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec         ; jsr ReadInput ($01E1EC): seed initial input state
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l11414
    moveq   #$1,d0
    bra.b   .l11416
.l11414:                                                ; $011414
    moveq   #$0,d0
.l11416:                                                ; $011416
    move.w  d0,-$00a0(a6)             ; auto-scroll flag: 1 if ReadInput had pending input
    clr.w   d5                        ; d5 = button state = 0
    clr.w   ($00FF13FC).l             ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag = 0
    clr.w   -$009e(a6)                ; display column counter = 0

    ; A5 = base of this player's $FF0338 block (indexed by player_index)
    move.w  $000a(a6),d0             ; player_index
    lsl.w   #$5,d0                   ; * 32
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5                    ; a5 = player's $FF0338 block base

    lea     -$000c(a6),a4            ; a4 = ptr to palette word 4 (= -$000C(a6))

; ============================================================================
; --- Phase: Main input/display loop ---
; ============================================================================
.l11442:                                                ; $011442
    ; Trigger redraw every 16 input frames (d5 & $F == 0 means counter wrapped)
    move.w  d5,d0
    andi.w  #$f,d0
    beq.b   .l1144c
    moveq   #$1,d7                    ; periodic redraw trigger
.l1144c:                                                ; $01144C
    cmpi.w  #$1,d7                    ; redraw flag set?
    bne.b   .l114b8                   ; no: skip to auto-scroll check

    ; Redraw only if d2 (row) or d6 (sub-col) changed since last frame
    cmp.w   -$0096(a6),d2            ; d2 == prev_d2?
    bne.b   .l1145e
    cmp.w   -$0098(a6),d6            ; d6 == prev_d6?
    beq.b   .l114b6                  ; same position: skip detail redraw

.l1145e:                                                ; $01145E
    ; --- Phase: Redraw route detail panel for current position ---
    ; GameCommand $1A: configure display region (rows 1-17, cols 12-18)
    clr.l   -(sp)
    pea     ($0011).w                 ; height = $11 (17 rows)
    pea     ($0013).w                 ; width = $13 (19 cols)
    pea     ($0001).w                 ; y = 1
    pea     ($000C).w                 ; x = $0C (col 12)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64         ; jsr GameCommand $1A
    ; DrawBox: draw bordered dialog box at (row=d2, col=d6), 9 rows x 7 cols
    pea     ($0009).w                 ; box height = 9
    pea     ($0007).w                 ; box width = 7
    move.w  d6,d0
    move.l  d0,-(sp)                  ; col = d6 (sub-column cursor)
    move.w  d2,d0
    move.l  d0,-(sp)                  ; row = d2 (row cursor)
    dc.w    $4eb9,$0000,$5a04         ; jsr DrawBox ($005A04)
    pea     ($0003F1B0).l             ; ROM: route detail text format string at $03F1B0
    dc.w    $4eb9,$0003,$b246         ; jsr PrintfNarrow ($03B246): format route detail
    lea     $0030(sp),sp
    ; ShowRouteDetailsDialog: show full route info for slot d3, this player
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; slot index
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)                  ; player_index
    bsr.w ShowRouteDetailsDialog
    addq.l  #$8,sp

.l114b6:                                                ; $0114B6
    clr.w   d7                        ; clear redraw flag

; --- Phase: Auto-scroll -- read extra input frame if flag set ---
.l114b8:                                                ; $0114B8
    tst.w   -$00a0(a6)                ; auto-scroll flag set?
    beq.b   .l114ce
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec         ; jsr ReadInput ($01E1EC): drain one more input frame
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l11442                   ; still getting input: loop immediately

; --- Phase: Poll controller input via ProcessInputLoop ---
.l114ce:                                                ; $0114CE
    clr.w   -$00a0(a6)                ; clear auto-scroll flag
    move.w  d5,d0                     ; previous button state (repeat input)
    move.l  d0,-(sp)
    pea     ($000A).w                 ; mode $0A = standard joypad decode
    dc.w    $4eb9,$0001,$e290         ; jsr ProcessInputLoop ($01E290): returns D0 = button word
    addq.l  #$8,sp
    move.w  d0,d5                     ; d5 = new button state

    ; Save d2/d6 for change detection next frame
    move.w  d2,-$0096(a6)
    move.w  d6,-$0098(a6)

; --- Phase: Resolve aircraft index for current slot (d3) ---
    ; Navigate to A5 entry: a5 + d3 * 8 (stride = 8 bytes per $FF0338 entry)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0                    ; d3 * 8
    lea     (a5,d0.l),a0
    movea.l a0,a2                     ; a2 = ptr to current slot entry in player's $FF0338 block

    cmpi.b  #$06,$0001(a2)            ; slot_type_flags == 6? (special type)
    beq.b   .l1150e                   ; yes: use special lookup path

    ; Standard path: use pre-built result array (a6-$0A), indexed by d3
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0                     ; d3 * 2 = word offset into result array
    movea.l d0,a0
    move.w  (a3,a0.l),d4             ; d4 = aircraft index from result array
    bra.b   .l1152c

.l1150e:                                                ; $01150E
    ; Special slot_type==6: two sub-paths depending on $FF0338 entry word at +$06
    cmpi.w  #$3,$0006(a2)            ; word at +$06 == 3?
    bne.b   .l11528                  ; no: use raw aircraft_code byte
    ; Use RangeLookup to map raw aircraft_code to aircraft category 0-7
    moveq   #$0,d0
    move.b  (a2),d0                   ; byte[0] = aircraft_code
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648         ; jsr RangeLookup ($00D648)
    addq.l  #$4,sp
    move.w  d0,d4                     ; d4 = resolved aircraft index
    bra.b   .l1152c

.l11528:                                                ; $011528
    ; Raw fallback: aircraft_code byte used directly (no range remapping)
    moveq   #$0,d4
    move.b  (a2),d4                   ; d4 = raw aircraft_code

; --- Phase: Place aircraft icon tile for current slot ---
.l1152c:                                                ; $01152C
    cmpi.w  #$ffff,d4                 ; $FFFF = empty slot?
    beq.b   .l11582                   ; skip tile placement for empty slot

    ; Choose which DisplaySetup param to use based on column counter (cycles 0-3)
    cmpi.w  #$2,-$009e(a6)           ; column counter < 2?
    bge.b   .l11550                  ; no: use param B ($009C)
    ; Use param A ($009A) for columns 0-1
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0                   ; tile_id = aircraft_index + $38 (aircraft tile base offset)
    move.l  d0,-(sp)
    pea     -$009a(a6)                ; display param A ptr
    bra.b   .l11564

.l11550:                                                ; $011550
    ; Use param B ($009C) for columns 2-3
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0                   ; tile_id = aircraft_index + $38
    move.l  d0,-(sp)
    pea     -$009c(a6)                ; display param B ptr

.l11564:                                                ; $011564
    dc.w    $4eb9,$0000,$5092         ; jsr DisplaySetup ($005092): render aircraft icon tile
    lea     $000c(sp),sp
    ; Advance column counter mod 4 (cycles 0 -> 1 -> 2 -> 3 -> 0)
    move.w  -$009e(a6),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146         ; jsr SignedMod ($03E146): d0 = (counter+1) mod 4
    move.w  d0,-$009e(a6)            ; store updated column counter

; ============================================================================
; --- Phase: Button dispatch ---
; ============================================================================
.l11582:                                                ; $011582
    move.w  d5,d0
    andi.w  #$3f,d0                   ; any directional/action bits?
    beq.w   .l11814                   ; no input: go to loop tail

    ; Highlight current slot using param B (provides visual cursor feedback)
    cmpi.w  #$ffff,d4                 ; empty slot?
    beq.b   .l115b0                   ; skip cursor tile for empty
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0                   ; tile_id = aircraft_index + $38
    move.l  d0,-(sp)
    pea     -$009c(a6)                ; use param B for cursor highlight
    dc.w    $4eb9,$0000,$5092         ; jsr DisplaySetup
    lea     $000c(sp),sp

.l115b0:                                                ; $0115B0
    ; --- Test bit 5 = A button (confirm / open slot) ---
    move.w  d5,d0
    andi.w  #$20,d0
    beq.w   .l116da                   ; A not pressed: check other buttons

    ; A button pressed -- confirm slot selection
    clr.w   ($00FF13FC).l             ; input_mode_flag = 0
    clr.w   ($00FFA7D8).l             ; input_init_flag = 0
    cmpi.w  #$4,d3                    ; d3 >= 4 = alt-section sentinel?
    bge.w   .l11828                   ; yes: exit function
    cmpi.w  #$4,$000e(a6)            ; scenario_type >= 4?
    bge.w   .l116da                   ; skip route-open for high scenario types

    ; Navigate to the selected slot's $FF0338 entry
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0                    ; d3 * 8
    lea     (a5,d0.l),a0
    movea.l a0,a2

    tst.b   $0001(a2)                 ; slot_type_flags == 0?
    bne.w   .l1168c                   ; nonzero type: go to occupied-slot path

    ; --- Empty slot (slot_type == 0): offer to add a new route ---
    ; Place "add route" icon at screen position derived from d6 (row) and d2 (col):
    ;   y = d6 * 8 + $30,  x = d2 * 8 + $28,  tile_id = d3 + $3B
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$3,d0                    ; d6 * 8
    addi.l  #$30,d0                   ; + $30 = y pixel coord
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0                    ; d2 * 8
    addi.l  #$28,d0                   ; + $28 = x pixel coord
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$3b,d0                   ; tile_id = d3 + $3B (empty-slot tile base)
    move.l  d0,-(sp)
    pea     ($0546).w                 ; tile $0546 = "add route" empty-slot left icon
    dc.w    $4eb9,$0001,$e044         ; jsr TilePlacement ($01E044)
    pea     ($000A).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64         ; jsr GameCommand $0E: commit tile to display
    lea     $0024(sp),sp

    ; Second tile: same position, alternate icon (right/complement icon)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$30,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$28,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$3b,d0
    move.l  d0,-(sp)
    pea     ($0548).w                 ; tile $0548 = "add route" empty-slot right icon
    dc.w    $4eb9,$0001,$e044         ; jsr TilePlacement
    pea     ($000A).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64         ; jsr GameCommand $0E
    lea     $0024(sp),sp
    bra.w   .l11828                   ; exit after route-add UI

.l1168c:                                                ; $01168C
    ; --- Occupied slot: format route info string and show text dialog ---
    moveq   #$0,d4
    move.b  $0001(a2),d4              ; slot_type_flags byte (1-based)
    addi.w  #$ffff,d4                 ; make 0-based: slot_type - 1
    move.w  d4,d0
    lsl.w   #$2,d0                    ; * 4 = longword index
    movea.l #$00047800,a0            ; $47800: ROM table of route format string ptrs (by slot type)
    move.l  (a0,d0.w),-(sp)          ; push route-type format string
    move.l  ($00047996).l,-(sp)      ; $47996: ROM ptr to revenue/profit format string
    pea     -$0094(a6)                ; string work buffer
    dc.w    $4eb9,$0003,$b22c         ; jsr sprintf ($03B22C): format route info into buffer
    ; ShowTextDialog: display formatted route info as a text dialog
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)                  ; slot index
    pea     -$0094(a6)                ; formatted string
    move.w  $000a(a6),d0             ; player_index
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0168               ; jsr ShowTextDialog ($01183A) [PC-relative]
    nop
    lea     $0024(sp),sp

; --- Test bit 4 = B button (back / exit) ---
.l116da:                                                ; $0116DA
    move.w  d5,d0
    andi.w  #$10,d0                   ; bit 4 = B button
    beq.b   .l116f6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff,d3                   ; d3 = $FF: exit sentinel for caller
    bra.w   .l11828

; ============================================================================
; --- Phase: Directional navigation -- update d2, d6 cursor position ---
; ============================================================================
.l116f6:                                                ; $0116F6
    move.w  d3,d4                     ; save current slot index for change detection

    ; --- Bit 0 = D-pad Up ---
    move.w  d5,d0
    andi.w  #$1,d0
    beq.b   .l11716
    move.w  #$1,($00FF13FC).l         ; mark input consumed
    ; d6 wraps 9 -> 1 when in the low column group (d2 < $18)
    cmpi.w  #$18,d2                   ; d2 >= $18 (alt section)?
    bge.b   .l11716                   ; no wrap for alt section
    cmpi.w  #$9,d6                    ; d6 == 9?
    bne.b   .l11716
    moveq   #$1,d6                    ; wrap: 9 -> 1

.l11716:                                                ; $011716
    ; --- Bit 1 = D-pad Down ---
    move.w  d5,d0
    andi.w  #$2,d0
    beq.b   .l1172e
    move.w  #$1,($00FF13FC).l
    ; d6 wraps 1 -> 9
    cmpi.w  #$1,d6                    ; d6 == 1?
    bne.b   .l1172e
    moveq   #$9,d6                    ; wrap: 1 -> 9

.l1172e:                                                ; $01172E
    ; --- Bit 2 = D-pad Left ---
    move.w  d5,d0
    andi.w  #$4,d0
    beq.b   .l11756
    move.w  #$1,($00FF13FC).l
    ; Move d2 left by 6 (one column group back), clamped at $0C minimum
    move.w  d2,d0
    ext.l   d0
    subq.l  #$6,d0                    ; d2 - 6 = candidate new value
    moveq   #$c,d1                    ; minimum allowed = $0C (first column)
    cmp.l   d0,d1                     ; $0C >= d0?
    bge.b   .l11752                   ; proposed value underflows: clamp
    move.w  d2,d0
    ext.l   d0
    subq.l  #$6,d0
    bra.b   .l11754
.l11752:                                                ; $011752
    moveq   #$c,d0                    ; clamped to $0C
.l11754:                                                ; $011754
    move.w  d0,d2

.l11756:                                                ; $011756
    ; --- Bit 3 = D-pad Right ---
    move.w  d5,d0
    andi.w  #$8,d0
    beq.b   .l117a4
    move.w  #$1,($00FF13FC).l
    addq.w  #$6,d2                    ; d2 + 6 = one column group right
    ; Clamp d2 based on d6 and scenario_type:
    ;   d6 == 1:  max d2 = $12
    ;   d6 != 1:  max d2 = $18 (or $12 for scenario types 3/4)
    cmpi.w  #$1,d6
    bne.b   .l1177a
    ; d6 == 1 path
    cmpi.w  #$12,d2                   ; d2 >= $12?
    bge.b   .l117a0                   ; clamp to $12
.l11774:                                                ; $011774
    move.w  d2,d0
    ext.l   d0
    bra.b   .l117a2

.l1177a:                                                ; $01177A
    ; d6 != 1 path: max is $18 normally, but clamped to $12 for scenario types 3/4 later
    cmpi.w  #$18,d2                   ; d2 >= $18?
    bge.b   .l11786
    move.w  d2,d0
    ext.l   d0
    bra.b   .l11788
.l11786:                                                ; $011786
    moveq   #$18,d0                   ; clamp d2 at $18 (alt-section boundary)
.l11788:                                                ; $011788
    move.w  d0,d2
    ; Additional clamp for scenario types 3 and 4: max is $12 not $18
    cmpi.w  #$3,$000e(a6)
    beq.b   .l1179a
    cmpi.w  #$4,$000e(a6)
    bne.b   .l117a4
.l1179a:                                                ; $01179A
    cmpi.w  #$12,d2                   ; d2 >= $12?
    blt.b   .l11774
.l117a0:                                                ; $0117A0
    moveq   #$12,d0                   ; clamp to $12
.l117a2:                                                ; $0117A2
    move.w  d0,d2

; --- Phase: Compute slot index d3 from cursor position (d2, d6) ---
.l117a4:                                                ; $0117A4
    cmpi.w  #$18,d2                   ; d2 >= $18? (alt/extra section)
    bge.b   .l117e0                   ; yes: slot index = 4 (extra sentinel), swap colors

    ; Normal section (d2 in {$0C, $12}, d6 in {1, 9}):
    ; Slot index = (d2 - $0C) / 6  +  (d6 >> 3) * 2
    ; d2=$0C -> col_part=0; d2=$12 -> col_part=1
    ; d6=1   -> row_part=0; d6=9   -> row_part=1
    ; Combined: slot 0=$0C,1 / slot 1=$0C,9 / slot 2=$12,1 / slot 3=$12,9
    move.w  d2,d0
    ext.l   d0
    subi.l  #$c,d0                    ; d2 - $0C (0 or 6)
    moveq   #$6,d1
    dc.w    $4eb9,$0003,$e08a         ; jsr SignedDiv ($03E08A): d0 = (d2-$0C) / 6 -> 0 or 1
    move.w  d0,d3                     ; d3 = column component
    move.w  d6,d0
    ext.l   d0
    asr.l   #$3,d0                    ; d6 >> 3: d6=1->0, d6=9->1
    add.w   d0,d0                     ; * 2
    add.w   d0,d3                     ; d3 = col*1 + row*2  (slots 0-3)

    ; Normal section palette: primary $026A/$04AE, secondary $0666/$0AAA
    move.w  #$026a,-$0012(a6)
    move.w  #$04ae,-$0010(a6)
    move.w  #$0666,-$000e(a6)
    move.w  #$0aaa,(a4)               ; (a4) = -$000C(a6): fourth palette word
    bra.b   .l117f8

.l117e0:                                                ; $0117E0
    ; Alt/extra section (d2 >= $18): slot index 4, swap palette to indicate selection
    moveq   #$4,d3                    ; d3 = 4: alt-section sentinel (not a normal slot)
    move.w  #$0666,-$0012(a6)         ; swap: alternate palette becomes primary
    move.w  #$0aaa,-$0010(a6)
    move.w  #$026a,-$000e(a6)
    move.w  #$04ae,(a4)

; --- Phase: Apply updated palette to display ---
.l117f8:                                                ; $0117F8
    pea     ($0004).w                 ; 4 palette words
    pea     ($0031).w
    pea     -$0012(a6)                ; ptr to palette block
    dc.w    $4eb9,$0000,$5092         ; jsr DisplaySetup: update display with new palette
    lea     $000c(sp),sp
    cmp.w   d3,d4                     ; slot index changed from prev frame?
    beq.b   .l11814                   ; same slot: no redraw needed
    moveq   #$1,d7                    ; new slot selected: trigger detail redraw

; --- Phase: Loop tail -- commit pending tile updates and iterate ---
.l11814:                                                ; $011814
    pea     ($0003).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64         ; jsr GameCommand $0E: commit pending display tiles
    addq.l  #$8,sp
    bra.w   .l11442                   ; back to top of main loop

; --- Phase: Exit ---
.l11828:                                                ; $011828
    dc.w    $4eb9,$0001,$e398         ; jsr PreLoopInit ($01E398): display cleanup
    move.w  d3,d0                     ; return: selected slot index, or $FF = cancelled
    movem.l -$00c8(a6),d2-d7/a2-a5
    unlk    a6
    rts
