; ============================================================================
; CharacterBrowser -- Full scrollable character browser UI: handles region/category navigation, stat display, and selection confirmation
; Called: ?? times.
; 962 bytes | $008A4A-$008E0B
; ============================================================================
; --- Phase: Setup ---
; $0C(a6) = d5 = target category filter code (which character type to search for)
; a4 = -$4(a6): stack word (stores input button state, used as (a4) throughout)
; a5 = $FF1804 = save buffer base (LZ decompress target)
; a3 = GameCommand ($0D64)
; d3 = category_index (which entry in $5F6D6 category table we're scanning)
; d4 = page_refresh_flag (0 = no refresh needed, 1 = refresh on next loop iteration)
; d6 = selected character code (set when player confirms, $FF = none)
; d7 = load_graphics_flag (1 = load new slot graphics, 0 = skip)
; -$6(a6) = scroll_position (which category page is loaded)
; -$2(a6) = saved cursor position (restored on page wrap)
CharacterBrowser:                                                  ; $008A4A
    link    a6,#-$8
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d5
; a3 = GameCommand ($0D64) -- central command dispatcher (VDP, input, display)
    movea.l #$0d64,a3
; a4 = -$4(a6): word on stack used as current input state word
    lea     -$0004(a6),a4
; a5 = $FF1804 = LZ_Decompress destination (save state buffer base, reused as gfx buffer)
    movea.l #$00ff1804,a5
; -$6(a6) = 1: scroll_position starts at 1 (skips the blank category 0 sentinel)
    move.w  #$1,-$0006(a6)
; d4 = 0: page_refresh_flag (initially no refresh queued)
    clr.w   d4
; d7 = 1: load_graphics_flag (load slot graphics on first loop iteration)
    moveq   #$1,d7
; d3 = 0: category_index (start scanning from first entry in category table)
    clr.w   d3
; --- Phase: Find category range containing d5 ---
; $5F6D6 = category table: pairs of bytes (low, high) defining char-code ranges per category
; Scan pairs until we find the one that contains d5 (the target code)
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f6d6,a0
    lea     (a0,d0.w),a0
; a2 = pointer into $5F6D6 table at current category entry (2 bytes per entry: low, high)
    movea.l a0,a2
; --- Category search loop ---
; Scan $5F6D6 table looking for the range that contains d5 (target character code)
; Each entry is 2 bytes: [+0]=range_low, [+1]=range_high
.l8a82:                                                 ; $008A82
    clr.w   d2
    movea.w d2,a0
; Check if d5 matches the low byte of this category range
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
    moveq   #$1,d2
    movea.w d2,a0
; Check if d5 matches the high byte of this category range
    move.b  (a2,a0.w),d0
    cmp.b   d5,d0
    beq.b   .l8aa0
; Neither byte matches: advance to next category entry (+2 bytes)
    addq.l  #$2,a2
    addq.w  #$1,d3
    bra.b   .l8a82
; --- Phase: Initial screen setup ---
; d3 now holds the matching category_index; build the browser screen
.l8aa0:                                                 ; $008AA0
; GameCommand #$40/#$10: clear tile area (or scroll plane clear) before loading panel
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
; CmdSetBackground ($00538E): fill scroll plane with background tile pattern
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
; GameCommand #$1B: place tile strip from $4DD9C (character list panel background)
; width=$09, height=$1E, col=$12, row=$01, layer 0
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
    lea     $002c(sp),sp
; LZ_Decompress: decompress character list panel graphics from ROM $4DFB8 to $FF1804
    pea     ($0004DFB8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
; VRAMBulkLoad: DMA transfer $02E1 tiles at index $000F from $FF1804 to VRAM
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($000F).w
    pea     ($02E1).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
; GameCommand #$1A: draw panel overlay tile strip ($077E = bordered list area)
; at col=$01, row=$02, width=$13, height=$1C
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
; GameCommand #$40/#$10: clear sprite plane before placing new sprites
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    lea     $0028(sp),sp
; DrawBox ($005A04): draw bordered dialog box at col=$07, row=$02, width=$10, height=$10
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
; DisplaySetup ($005092): load character detail panel graphics from $767BE
; 16-tile wide x 32-tile high display region
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
; LZ_Decompress: decompress character portrait from pointer at $9513C to $FF1804
    move.l  ($0009513C).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
; CmdPlaceTile2 ($0045E6): place portrait tile block (96 pixels wide, $0640 palette/flags)
; at VRAM offset from $FF1804 src
    pea     ($0060).w
    pea     ($0640).w
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $0030(sp),sp
; GameCommand #$1B: place title bar tile strip from $70E58
; width=$0A, height=$08, col=$05, row=$0C (character name header area)
    pea     ($00070E58).l
    pea     ($0008).w
    pea     ($000C).w
    pea     ($0005).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a3)
; d6 = currently highlighted character code (initially same as filter target d5)
    move.w  d5,d6
; PrintfNarrow ($03B246): display character name label using format string at $3E1AA
    pea     ($0003E1AA).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
; ReadInput ($01E1EC): check for any pending button presses (mode 0 = immediate)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0024(sp),sp
; If any input already pending: set -$2(a6) = 1 (skip first-frame countdown)
    tst.w   d0
    beq.b   .l8bb6
    moveq   #$1,d0
    bra.b   .l8bb8
.l8bb6:                                                 ; $008BB6
    moveq   #$0,d0
; -$2(a6) = input_ready_flag (1 = input already waiting from before screen load)
.l8bb8:                                                 ; $008BB8
    move.w  d0,-$0002(a6)
; Clear input button state word (a4)
    clr.w   (a4)
; $FF13FC = input_mode_flag: clear for fresh countdown start
    clr.w   ($00FF13FC).l
; $FFA7D8 = input_init_flag: clear debounce state
    clr.w   ($00FFA7D8).l
; --- Phase: Main browser loop ---
; Top of loop: optionally load new slot graphics, update display, read input
.l8bca:                                                 ; $008BCA
; If d7==1 (load_graphics_flag): load/update the slot graphics panel
    cmpi.w  #$1,d7
    bne.b   .l8c00
; LoadSlotGraphics ($009F88): decompress and place character graphics for
; scroll_position (-$6(a6)) and character code d6, at tile col=$0C, row=$0E
    move.w  -$0006(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000E).w
    pea     ($000C).w
    dc.w    $4eba,$13a0                                 ; jsr $009F88
    nop
; Reset scroll_position tracking flag and load_graphics_flag after loading
    clr.w   -$0006(a6)
    clr.w   d7
; GameCommand #$0E: flush VDP after loading slot graphics
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $0018(sp),sp
; GameCommand #$02/#$0E: secondary display housekeeping (double VDP sync)
.l8c00:                                                 ; $008C00
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
; d4 = page_refresh_flag: alternates which character info panel column is displayed
; d4==1: reload the full-page display (character portrait panel at $767BE)
    cmpi.w  #$1,d4
    bne.b   .l8c2e
; DisplaySetup ($005092): reload character portrait panel (16x32 tile, from $767BE)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000767BE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
; Clear page_refresh_flag after refresh
    clr.w   d4
    bra.b   .l8c50
; d4==0: load the stat detail column (character info panel at $767DC + d6*$28 offset)
; $28 = 40 bytes per character entry in the detail panel table
.l8c2e:                                                 ; $008C2E
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
; $28 = 40: per-character slot in the detail panel table (panel for char d6)
    addi.l  #$28,d0
    move.l  d0,-(sp)
    pea     ($000767DC).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
; Set d4=1 so next frame will reload the portrait panel (alternating display)
    moveq   #$1,d4
; If input_ready_flag (-$2(a6)) is set: check for key-up before polling
.l8c50:                                                 ; $008C50
    tst.w   -$0002(a6)
    beq.b   .l8c74
; ReadInput: check if key has been released (mode 0 = immediate)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
; If input still held (d0 != 0): send GameCmd #$03/#$0E and loop back
    tst.w   d0
    beq.b   .l8c74
    pea     ($0003).w
.l8c68:                                                 ; $008C68
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
    bra.w   .l8bca
; --- Phase: Poll input (debounced) ---
.l8c74:                                                 ; $008C74
; Clear input_ready_flag: normal polling from here
    clr.w   -$0002(a6)
; ProcessInputLoop ($01E290): read joypad with mode $A (auto-repeat)
; -$4(a6) holds carry-in state (previous button word)
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
; Mask to relevant 6 bits: $3F = Start/A/B/C + Up/Down/Left/Right
    andi.w  #$3f,d0
; Save masked button state to (a4)
    move.w  d0,(a4)
; Test Start or A buttons ($30 = Start|A: exit or select)
    andi.w  #$30,d0
    beq.b   .l8ca4
; --- A or Start pressed: confirm selection or exit ---
    move.w  (a4),d0
    andi.w  #$10,d0
    beq.b   .l8cfc
; Start button ($10): exit with no selection (d6 = $FF signals "cancelled")
    move.w  #$ff,d6
    bra.b   .l8cfc
; --- D-pad navigation ---
; No A/Start pressed: handle directional navigation
.l8ca4:                                                 ; $008CA4
    move.w  (a4),d0
; Test any d-pad bits ($F = Down/Up/Right/Left)
    andi.w  #$f,d0
    beq.b   .l8cf4
; --- Down ($8): advance to next category row ---
; d3 = category_index (wraps mod 4 since there are 4 category rows)
    move.w  (a4),d0
    andi.w  #$8,d0
    beq.b   .l8cba
    addq.w  #$1,d3
; Wrap: d3 = d3 mod 4 (4 category rows in the character type grid)
    andi.w  #$3,d3
.l8cba:                                                 ; $008CBA
; --- Up ($4): go to previous category row ---
    move.w  (a4),d0
    andi.w  #$4,d0
    beq.b   .l8cc8
; +3 mod 4 = subtract 1 with wrap (no negative needed)
    addq.w  #$3,d3
    andi.w  #$3,d3
.l8cc8:                                                 ; $008CC8
; --- Left ($1): move cursor to first column (d2 = 0) ---
    move.w  (a4),d0
    andi.w  #$1,d0
    beq.b   .l8cd2
    clr.w   d2
.l8cd2:                                                 ; $008CD2
; --- Right ($2): move cursor to second column (d2 = 1) ---
    move.w  (a4),d0
    andi.w  #$2,d0
    beq.b   .l8cdc
    moveq   #$1,d2
; --- Resolve new character code from category table ---
; $5F6D6 table: 2 bytes per row, 4 rows; index = d3*2 + d2
; d2=0 selects row's low code, d2=1 selects row's high code
.l8cdc:                                                 ; $008CDC
    move.w  d3,d0
    add.w   d0,d0
    add.w   d2,d0
    movea.l #$0005f6d6,a0
    move.b  (a0,d0.w),d6
    andi.l  #$ff,d6
; d6 = newly selected character code; set d7=1 to trigger graphics reload next frame
    moveq   #$1,d7
; D-pad: loop back with GameCmd #$02 (small delay command between navigation frames)
.l8cf4:                                                 ; $008CF4
    pea     ($0002).w
    bra.w   .l8c68
; --- Phase: Selection confirmed (A pressed, d6 != $FF) ---
; Draw the selection confirm border and show the character detail view
.l8cfc:                                                 ; $008CFC
; GameCommand #$1A: draw selection highlight box at col=$07, row=$02, width=$10, height=$12
; Priority $8000: high-priority tile (overlays background)
    move.l  #$8000,-(sp)
    pea     ($0010).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; If d6 == $FF (Start pressed / cancelled): skip to ShowRelPanel cleanup path
    cmpi.w  #$ff,d6
    beq.w   .l8dde
; --- Character selected path: load and display character detail ---
; ResourceLoad: load additional graphics for the detail view
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
; GameCommand #$40/#$10: clear sprite layer before loading detail view
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
; CmdSetBackground: fill plane with background tile pattern
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
; LoadDisplaySet ($01D444): load display mode $10 (character detail layout)
    pea     ($0010).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
; GameCommand #$03/#$0E: display housekeeping sync
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a3)
; d5 = confirmed selected character code (copy from d6 for detail display)
    move.w  d6,d5
; SelectMenuItem ($009F4A): register character d5 as the selected menu item
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$11ec                                 ; jsr $009F4A
    nop
; LoadScreen ($006A2E): initialize the character detail screen
; Args: mode=1, character=d5, player=$A(a6)
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    lea     $002c(sp),sp
; ShowRelPanel ($006B78): display character relationship/affinity panel
; mode=2, character=d5, player=$A(a6)
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
; GameCommand #$1A: draw confirm button tile ($077F) at col=$13, row=$20, width=$01, height=$01
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $0028(sp),sp
; GameCommand #$1A: draw back button tile ($077D) at col=$14, row=$20, width=$09, height=$01
    pea     ($077D).w
    pea     ($0009).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
; ResourceUnload: release the detail-view graphics
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    bra.b   .l8dfa
; --- Cancelled/Start path: show relation panel without detail confirm UI ---
.l8dde:                                                 ; $008DDE
; ShowRelPanel ($006B78): mode=2 (display only), character=d5, player=$A(a6)
    pea     ($0002).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $000c(sp),sp
; --- Phase: Exit ---
; GameCommand #$18: trigger display commit / DMA flush before returning
.l8dfa:                                                 ; $008DFA
    pea     ($0018).w
    jsr     (a3)
; Return d5 (selected character code, or $FF if cancelled) to caller
    move.w  d5,d0
    movem.l -$0030(a6),d2-d7/a2-a5
    unlk    a6
    rts
