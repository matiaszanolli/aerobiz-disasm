; ============================================================================
; DrawCharPanelS2 -- Draws the character stat-adjustment panel: sets up the display and loads panel graphics, calls RenderCharDetails to draw current char slots, then runs an input loop allowing the player to adjust allocated stat points with live tile updates and cost dialogs
; 918 bytes | $02DE6C-$02E201
; ============================================================================
; --- Phase: Setup ---
; d2 = char_group index, d4 = slot_index within group, d7 = cost_per_point
; a2 = pointer to current stat allocation word (counts purchased points)
; a4 = GameCommand jump target, a5 = TilePlacement jump target
DrawCharPanelS2:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d4
    move.l  $1c(a6), d7
    movea.l $14(a6), a2
; a4 = GameCommand ($0D64) -- central command dispatcher
    movea.l  #$00000D64,a4
; a5 = TilePlacement ($01E044) -- builds tile params and calls GameCmd #15
    movea.l  #$0001E044,a5
; --- Phase: Locate group/slot record at $FF02E8 ---
; $FF02E8 is the base of FindCharSlotInGroup records (4-byte stride per slot in group)
; index = char_group * $14 + slot_index * 4
    move.w  d2, d0
    mulu.w  #$14, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
; a3 = pointer to current slot record within $FF02E8 group block
    movea.l a0, a3
; d3 = initial slot count = slot_record[+1] (base count) + current allocation word (a2)
    moveq   #$0,d3
    move.b  $1(a3), d3
    add.w   (a2), d3
; --- Phase: Draw panel background ---
; GameCommand #$1A: clear tile area (width=$14 tiles, height=$0F, at col=2, row=1, priority $8000)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
; DisplaySetup: load panel background graphics (16x16 tile region, from ROM $4E3AC)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004E3AC).l
    jsr DisplaySetup
; LZ_Decompress: decompress panel tile graphics from ROM $4E498 to $FF1804 (save buffer base)
    pea     ($0004E498).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
; VRAMBulkLoad: DMA transfer decompressed panel tiles to VRAM at tile $005B, count $0028 ($FF1804 src)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0028).w
    pea     ($005B).w
    jsr VRAMBulkLoad
; GameCommand #$1B: place tile strip from ROM $4E3CC, 6 wide x 1 high at col=$11, row=$14
    pea     ($0004E3CC).l
    pea     ($0006).w
    pea     ($0011).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
; --- Phase: Initial character detail render ---
; RenderCharDetails: draw all character slot details for the current group
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $e(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderCharDetails,PC)
    nop
    lea     $c(a7), a7
; --- Phase: Initial tile strip rendering loop ---
; d2 = current tile index, d3 = upper limit (initial count + allocation)
; Loop draws one tile per slot from slot_record[+1] up to d3
    moveq   #$0,d2
    move.b  $1(a3), d2
    bra.w   .l2dfe6
.l2df5c:
    addq.w  #$1, d2
; --- Compute tile Y position from slot index (even/odd row split) ---
; d2 mod 2: 0 = even column (left), 1 = odd column (right)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2df84
; Even index: Y offset = (d2/2)*$18 - $8 (tile row calculation, $18=24 pixels per 2 rows)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df76
    addq.l  #$1, d0
.l2df76:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
; addi.w #$fff8 = subtract 8 (signed): fine-tuned Y offset for even-row tiles
    addi.w  #$fff8, d4
    bra.b   .l2df96
.l2df84:
; Odd index: Y offset = (d2/2)*$18 + $8 (offset toward right column)
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   .l2df8c
    addq.l  #$1, d0
.l2df8c:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2df96:
; Compute X position from column parity: d6 = (d2 mod 2)*$10 + $A8
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
; $A8 = base X pixel offset for the stat tile column area
    addi.w  #$a8, d6
    subq.w  #$1, d2
; --- Place tile for this slot using TilePlacement ---
; Tile $0750 = stat panel tile graphic, at (d4=Y, d6=X), size 2x2, priority $8000
; Tile index = $A - d2 (reverse order, so first slots get higher-priority tile indices)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$A,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
; GameCommand #$0E: flush/sync display output after placing tile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    addq.w  #$1, d2
; Loop until d2 >= d3 (all allocated slots rendered)
.l2dfe6:
    cmp.w   d3, d2
    bcs.w   .l2df5c
; --- Phase: Main input loop ---
; d2 = input frame counter (cycles 0-$1D, triggers periodic sprite updates)
    clr.w   d2
; Top of input loop: render cost and allocation text, then read joypad
.l2dfee:
; SetTextWindow: define text window at left=0, top=0, width=$20, height=$04
    pea     ($0004).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    jsr SetTextWindow
; SetTextCursor: move cursor to col=$1C, row=$14 (cost display area)
    pea     ($0014).w
    pea     ($001C).w
    jsr SetTextCursor
; PrintfWide: display current allocation count from (a2) using format string at $446BC
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    pea     ($000446BC).l
    jsr PrintfWide
; SetTextCursor: move to col=$14, row=$16 (total cost row)
    pea     ($0016).w
    pea     ($0014).w
    jsr SetTextCursor
; Compute total cost: d7 (cost_per_point) * (a2) (points bought) = total spent
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$0,d1
    move.w  (a2), d1
    jsr Multiply32
; PrintfWide: display total cost using format string at $446B6
    move.l  d0, -(a7)
    pea     ($000446B6).l
    jsr PrintfWide
    lea     $30(a7), a7
; d2 = frame counter incremented 0..N; drive periodic sprite refresh
    addq.w  #$1, d2
; On first frame (d2==1): place initial portrait sprites for both comparison slots
    cmpi.w  #$1, d2
    bne.b   .l2e0b8
; TilePlacement: place slot-0 portrait tile ($0772) at col=$39, row=$08, size 1x1, X=$AC
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
; TilePlacement: place slot-1 portrait tile ($0773) at col=$3A, row=$80, size 1x1, X=$AC
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00AC).w
    pea     ($0080).w
    pea     ($003A).w
    pea     ($0773).w
    jsr     (a5)
    lea     $1c(a7), a7
; GameCommand #$0E: flush display
.l2e0aa:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l2e0d8
; At d2==$F (15): clear sprite channel $39 via GameCmd16 (mid-cycle sprite reset)
.l2e0b8:
    cmpi.w  #$f, d2
    bne.b   .l2e0d0
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l2e0aa
; At d2==$1E (30): wrap counter back to 0 (portrait animation period = 30 frames)
.l2e0d0:
    cmpi.w  #$1e, d2
    bne.b   .l2e0d8
    clr.w   d2
; --- Phase: Read joypad input ---
; ProcessInputLoop: poll joypad, #$A = debounce/repeat mode; d5 = previous input state
.l2e0d8:
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
; Mask to directional + button bits we care about ($3C = Up/Down/Left/Right)
    andi.w  #$3c, d0
    move.w  d0, d5
; Test Start or A button ($20 or $10): exit input loop, return current d5 to caller
    andi.w  #$20, d0
    bne.w   .l2e1f6
    move.w  d5, d0
    andi.w  #$10, d0
    bne.w   .l2e1f6
; --- Test Left d-pad: decrement allocation ---
; Bit $04 = Left direction
    move.w  d5, d0
    andi.w  #$4, d0
    beq.b   .l2e148
; Guard: only decrement if current allocation > 1 (min 1 point must remain)
    cmpi.w  #$1, (a2)
    bls.w   .l2e1e6
; TilePlacement: erase the slot tile being removed (tile index = $A - d3 + 1, coordinates from d3)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
; Decrement allocation count and update running slot total
    subq.w  #$1, (a2)
    subq.w  #$1, d3
    bra.w   .l2e1e6
; --- Test Right d-pad: increment allocation ---
; Bit $08 = Right direction
.l2e148:
    move.w  d5, d0
    andi.w  #$8, d0
    beq.w   .l2e1e6
; Guard: only increment if allocation < cap (stack arg $1A(a6) = max points allowed)
    move.w  (a2), d0
    cmp.w   $1a(a6), d0
    bcc.w   .l2e1e6
; Increment allocation and running slot total
    addq.w  #$1, (a2)
    addq.w  #$1, d3
; --- Recompute tile coordinates for newly added slot ---
; Same even/odd row split as the initial tile loop above
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2e186
; Even slot: Y = (d3/2)*$18 - $8
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e178
    addq.l  #$1, d0
.l2e178:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addi.w  #$fff8, d4
    bra.b   .l2e198
.l2e186:
; Odd slot: Y = (d3/2)*$18 + $8
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   .l2e18e
    addq.l  #$1, d0
.l2e18e:
    asr.l   #$1, d0
    move.l  d0, d4
    mulu.w  #$18, d4
    addq.w  #$8, d4
.l2e198:
; X = (d3 mod 2)*$10 + $A8
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    move.l  d0, d6
    lsl.w   #$4, d6
    addi.w  #$a8, d6
; TilePlacement: draw the newly added stat tile at computed (d4=Y, d6=X)
; Tile index = $A - d3 + 1, 2x2 tile, priority $8000
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$A,d1
    sub.l   d0, d1
    addq.l  #$1, d1
    move.l  d1, -(a7)
    pea     ($0750).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
; --- Phase: End-of-loop housekeeping ---
; GameCommand #$06 with #$0E: advance display frame / sync VDP
.l2e1e6:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.w   .l2dfee
; --- Phase: Exit ---
; Return d5 (button state that caused exit) to caller
.l2e1f6:
    move.w  d5, d0
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
