; ============================================================================
; ShowRouteInfo -- Display route information panel: show player slot details, city/char names, route stats, and price/category labels
; Called: ?? times.
; 1046 bytes | $00F104-$00F519
; ============================================================================
; --- Phase: Function Prologue -- Register Setup ---
ShowRouteInfo:                                                  ; $00F104
    link    a6,#$0
    movem.l d2-d4/a2-a5,-(sp)
; d4 = panel_id: stack arg +$8, 0 = left panel (player 1), nonzero = right panel (player 2+)
    move.l  $0008(a6),d4
; a5 = PrintfWide ($03B270): format + display string in wide font
    movea.l #$0003b270,a5
; d3 = 1: initial row counter increment / loop base index
    moveq   #$1,d3
; d2 = d4 * $B + 2: starting Y row for this panel (left panel: 2; right panel: $D+2=$F)
; $B = 11 = column width per panel; this places right panel 11 columns to the right
    move.w  d4,d2
    mulu.w  #$b,d2
    addq.w  #$2,d2
; --- Phase: Dispatch by Panel Side ---
; d4 == 0: left panel (player 1 slot) -> fall through to left-panel path
; d4 != 0: right panel -> jump to .lf322
    tst.w   d4
    bne.w   .lf322
; --- Phase: Left Panel -- Checksum Verify (slot validity) ---
; VerifyChecksum ($00F552): verify route slot data integrity; d4 = slot index
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0426                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
; d0 = 0: checksum valid (slot has real data) -> display slot contents
; d0 != 0: checksum bad / slot empty -> draw empty panel box
    tst.w   d0
    bne.b   .lf170
; --- Phase: Left Panel -- Empty Slot: Draw Box and Label ---
; DrawBox ($005A04): draw bordered dialog box at (d2, d3) with size $1E × $A
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
; d3 = 1: top row of left panel
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
; SetTextCursor ($03AB2C): position at (d2+1, row 3) inside the box for "EMPTY" label
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
; PrintfWide: print "empty slot" label string at $3EA6C; shared tail jumps to epilogue
    pea     ($0003EA6C).l
; shared tail: call PrintfWide then branch to function epilogue
.lf168:                                                 ; $00F168
    jsr     (a5)
    addq.l  #$4,sp
    bra.w   .lf518
; --- Phase: Left Panel -- Valid Slot: Set Up Pointers and Draw Route Rows ---
.lf170:                                                 ; $00F170
; a4 = save_buf_base ($FF1804): start of save state / route slot data buffer
    movea.l #$00ff1804,a4
; a2 = $FF1804 + $14 = $FF1818: start of route slot data within save buffer
; Each route entry is $24 bytes; a2 steps through them in the loop below
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
; a3 = $FF1804 + $A4 = $FF18A8: secondary data sub-table (char names, route identifiers)
    movea.l a4,a3
    lea     $00a4(a3),a3
; d2 += 1: advance to first content row within the panel box (past the border)
    addq.w  #$1,d2
; d3 = 0: slot row counter (iterates 0..3 for up to 4 route rows)
    clr.w   d3
; --- Phase: Left Panel -- Route Slot Row Loop (4 rows, d3 = 0..3) ---
.lf186:                                                 ; $00F186
; check a2+$01 (route slot hub_city / city_b field): $20 = empty/placeholder city code
; player record +$01 = hub_city; $20+ = special/alliance city; < $20 = valid city index
    cmpi.b  #$20,$0001(a2)
; if city code >= $20: slot not active / empty city, skip to next row
    bcc.b   .lf1fe
; valid slot: print char name from secondary table at a3
; SetTextCursor: position at (d2, row 3) for char name
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; PrintfWide: print char name string (pointer at a3) with format $3EA66
    move.l  a3,-(sp)
    pea     ($0003EA66).l
    jsr     (a5)
; SetTextCursor: position at (d2, row $B) for city A name
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; look up city A name pointer: (a2)+$00 = city_a index (route slot field +$00)
; city name pointer table at $5F926: indexed by city_a * 4
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
; PrintfWide: print city A name using format at $3EA62
    pea     ($0003EA62).l
    jsr     (a5)
; SetTextCursor: position at (d2, row $F) for city B name
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; look up city B name pointer: (a2)+$01 = city_b index (route slot field +$01)
; city name pointer table at $5E680: same structure, but destination city table
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
; PrintfWide: print city B name using format at $3EA5C
    pea     ($0003EA5C).l
    jsr     (a5)
    lea     $0030(sp),sp
; advance to next route slot entry
.lf1fe:                                                 ; $00F1FE
; a2 += $24: step to next route slot record ($24 = 36 bytes per slot in display buffer)
    moveq   #$24,d0
    adda.l  d0,a2
; a3 += $10: step to next char name entry ($10 = 16 bytes per name in secondary table)
    moveq   #$10,d0
    adda.l  d0,a3
; d2 += 2: advance Y row by 2 (each slot row occupies 2 display rows)
    addq.w  #$2,d2
    addq.w  #$1,d3
; loop 4 times (d3 = 0..3): show up to 4 route slots per panel
    cmpi.w  #$4,d3
    blt.w   .lf186
; --- Phase: Left Panel -- Route Stats Footer (frequency / ticket price) ---
; reset d2 to the correct panel-base column for the stats footer row
; d4 == 0: left panel base col = 2; d4 != 0: right panel base col = $D (13)
    tst.w   d4
    bne.b   .lf21a
    moveq   #$2,d2
    bra.b   .lf21c
.lf21a:                                                 ; $00F21A
    moveq   #$d,d2
.lf21c:                                                 ; $00F21C
; d2 += 1: column for the first stats row (just inside panel left border)
    addq.w  #$1,d2
; SetTextCursor: position at (d2, row $1A) for "FREQUENCY" label
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; PrintfWide: print "FREQUENCY:" label from $3EA58
    pea     ($0003EA58).l
    jsr     (a5)
; SetTextCursor: position at (d2, col $1C) for frequency value
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; a4+$06 = save_buf_base+$06: route frequency byte (+1 to convert 0-based to 1-based display)
; Route slot +$03 = frequency field; here accessed via save buffer at a4+$06
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
; +1: display frequency as 1-based (stored 0-based internally)
    addq.l  #$1,d0
    move.l  d0,-(sp)
; PrintfWide: print frequency value using format at $3EA54
    pea     ($0003EA54).l
    jsr     (a5)
; d2 += 2: next stats row (2-row spacing)
    addq.w  #$2,d2
; SetTextCursor: position at (d2, row $1A) for "TICKET" or "PRICE" label
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; PrintfWide: print "PRICE:" label from $3EA50
    pea     ($0003EA50).l
    jsr     (a5)
; SetTextCursor: position at (d2, col $1C) for price value
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
; a4+$07 = ticket_price byte from save buffer (route slot +$04 = ticket_price word, low byte here)
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
; +1: convert to 1-based display value
    addq.l  #$1,d0
    move.l  d0,-(sp)
; PrintfWide: print ticket price value using format at $3EA4C
    pea     ($0003EA4C).l
    jsr     (a5)
; --- Phase: Left Panel -- Service Quality Score and Category Label ---
; a4+$08 = route slot +$08 word = gross_revenue; used here as raw service quality score
    move.w  $0008(a4),d3
; d3 = raw quality score from slot
; compute (d3 + 3) mod 4: round up to nearest group of 4 (maps score to quality tier)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
; SignedMod ($03E146): d0 mod 4 -> d0 = tier index 0..3
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
; d4 = tier * 3: multiply by 3 to get display icon offset
    move.l  d0,d4
    mulu.w  #$3,d4
; compute (d4 + 3) mod $C: maps icon offset into 12-element service-quality table
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
; SignedMod: d0 mod 12 -> d0 = service category index (0..11)
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
; d4 = final service category index for the graphic lookup table
    move.w  d0,d4
; compute display score label tile ID: (d3 + bias) / 4 + $7A3
; signed arithmetic shift to handle negative quality values
    move.w  d3,d0
    ext.l   d0
; if d3 >= 0: no bias needed; branch past bias addition
    bge.b   .lf2cc
; negative d3: add 3 before arithmetic shift (standard floor-toward-zero rounding fix)
    addq.l  #$3,d0
.lf2cc:                                                 ; $00F2CC
; ASR.L #2: divide by 4 (arithmetic right shift, preserves sign)
    asr.l   #$2,d0
; $7A3 = base tile index for quality-score bar/label tiles in VRAM
    addi.w  #$07a3,d0
; d3 = tile ID for the quality score graphic
    move.w  d0,d3
; d2 += 2: advance to next row pair for quality display
    addq.w  #$2,d2
; SetTextCursor: position at (d2, col $19) for quality score tile
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; PrintfWide: print quality score tile (d3) using format at $3EA48
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA48).l
    jsr     (a5)
; d2 += 2: advance to category label row
    addq.w  #$2,d2
; SetTextCursor: position at (d2, row $1A) for route category name
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
; look up category name string pointer: d4 * 4 into table at $5F096
; $5F096 = route category name pointer table (domestic, international, etc.)
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
; PrintfWide: print category name at $3EA44; branch to shared print-and-return tail
    pea     ($0003EA44).l
    bra.w   .lf516
; --- Phase: Right Panel -- Checksum Verify (mirrors left panel logic) ---
.lf322:                                                 ; $00F322
; VerifyChecksum: validate right panel slot; d4 = slot index (nonzero)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$022a                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
; d0 != 0: slot has valid data; d0 == 0: slot empty -> draw empty panel
    tst.w   d0
    bne.b   .lf368
; --- Phase: Right Panel -- Empty Slot: Draw Box and "Empty" Label ---
; DrawBox: draw bordered panel box at (d2, d3) with size $1E × $A
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
; SetTextCursor: position at (d2+1, row 3) for "empty" label
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
; PrintfWide: print right-panel "empty" label at $3EA36 (different string from left $3EA6C)
; then share tail at .lf168 (call a5 + branch to epilogue)
    pea     ($0003EA36).l
    bra.w   .lf168
; --- Phase: Right Panel -- Valid Slot: Set Up Pointers and Draw Route Rows ---
; Identical structure to left panel (.lf170 path) but uses different format string addresses
.lf368:                                                 ; $00F368
; a4 = save_buf_base ($FF1804)
    movea.l #$00ff1804,a4
; a2 = $FF1818: route data start (same offset as left panel)
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
; a3 = $FF18A8: secondary char name table (same offset)
    movea.l a4,a3
    lea     $00a4(a3),a3
; d2 += 1: first content row inside right panel
    addq.w  #$1,d2
    clr.w   d3
; --- Phase: Right Panel -- Route Slot Row Loop ---
.lf37e:                                                 ; $00F37E
; check a2+$01 (city_b/hub_city): < $20 = valid slot, >= $20 = empty/skip
    cmpi.b  #$20,$0001(a2)
    bcc.b   .lf3f6
; print char name from a3 (SetTextCursor at row 3, PrintfWide with right-panel format $3EA30)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; right-panel char name format $3EA30 (vs left-panel $3EA66)
    move.l  a3,-(sp)
    pea     ($0003EA30).l
    jsr     (a5)
; print city A name: route slot +$00 = city_a index, lookup in $5F926 table
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
; right-panel city A format $3EA2C
    pea     ($0003EA2C).l
    jsr     (a5)
; print city B name: route slot +$01 = city_b index, lookup in $5E680 table
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
; right-panel city B format $3EA26
    pea     ($0003EA26).l
    jsr     (a5)
    lea     $0030(sp),sp
; advance to next slot (same strides as left panel: a2 += $24, a3 += $10, d2 += 2)
.lf3f6:                                                 ; $00F3F6
    moveq   #$24,d0
    adda.l  d0,a2
    moveq   #$10,d0
    adda.l  d0,a3
    addq.w  #$2,d2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .lf37e
; --- Phase: Right Panel -- Route Stats Footer (mirrors left panel, different format strings) ---
; reset d2 to panel base column (same logic as left panel)
    tst.w   d4
    bne.b   .lf412
    moveq   #$2,d2
    bra.b   .lf414
.lf412:                                                 ; $00F412
    moveq   #$d,d2
.lf414:                                                 ; $00F414
    addq.w  #$1,d2
; SetTextCursor: position for "FREQUENCY:" label (right-panel format $3EA22)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA22).l
    jsr     (a5)
; SetTextCursor: position for frequency value (right-panel format $3EA1E)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
; a4+$06 = frequency byte (+1 for 1-based display)
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA1E).l
    jsr     (a5)
    addq.w  #$2,d2
; SetTextCursor: position for "PRICE:" label (right-panel format $3EA1A)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA1A).l
    jsr     (a5)
; SetTextCursor: position for price value (right-panel format $3EA16)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
; a4+$07 = ticket price byte (+1 for 1-based display)
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA16).l
    jsr     (a5)
; --- Phase: Right Panel -- Service Quality Score and Category Label (mirrors left panel) ---
; a4+$08 = gross_revenue word used as raw quality score (same field as left panel)
    move.w  $0008(a4),d3
; same quality tier computation as left panel: (d3+3) mod 4 * 3 mod 12 -> category index
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.l  d0,d4
    mulu.w  #$3,d4
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
; d4 = service category index (0..11) for right panel
    move.w  d0,d4
; same arithmetic-shift tile ID formula as left panel
    move.w  d3,d0
    ext.l   d0
    bge.b   .lf4c4
    addq.l  #$3,d0
.lf4c4:                                                 ; $00F4C4
; ASR.L #2 = divide by 4; + $7A3 = base tile ID for quality score tiles
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d3
    addq.w  #$2,d2
; SetTextCursor: position for quality score tile (right-panel format $3EA12)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA12).l
    jsr     (a5)
    addq.w  #$2,d2
; SetTextCursor: position for route category label (right-panel format $3EA0E)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
; look up route category string pointer: d4 * 4 into $5F096 category name table
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
; right-panel category format $3EA0E
    pea     ($0003EA0E).l
; --- Phase: Shared Tail -- PrintfWide + Epilogue ---
; both panels converge here: call PrintfWide for the last string, then fall into epilogue
.lf516:                                                 ; $00F516
    jsr     (a5)
; --- Phase: Epilogue ---
.lf518:                                                 ; $00F518
    movem.l -$1C(a6),d2-d4/a2-a5
    unlk    a6
    rts
; === Translated block $00F522-$00F552 ===
; 1 functions, 48 bytes
