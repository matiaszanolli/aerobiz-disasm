; ============================================================================
; FormatRelationStats -- Draws the compact relation stats cell: renders both character names, compatibility fraction, portrait icon, and score value into a tile panel at the given position
; Called: ?? times.
; 922 bytes | $019660-$0199F9
; ============================================================================
FormatRelationStats:                                                  ; $019660
; --- Phase: Setup ---
; Frame layout:
;   $8(a6)  = a2 arg: pointer to relation record (2 bytes: [0]=char_a, [1]=char_b)
;   $E(a6)  = column offset argument (word)
;   $12(a6) = display mode flag (word: 1 = show portrait DMA, 0 = skip)
;   $14(a6) = d4 arg: column/X position for tile placement
;   $18(a6) = d3 arg: row/Y position for tile placement
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
; d3 = row (Y tile position), d4 = column (X tile position) for placing the stats cell
    move.l  $0018(a6),d3
    move.l  $0014(a6),d4
; a2 = relation record pointer: byte[0]=char_a_code, byte[1]=char_b_code
    movea.l $0008(a6),a2
; a3 = PrintfWide ($3B270): cached for repeated wide-font prints
    movea.l #$0003b270,a3
; a4 = SetTextCursor ($3AB2C): cached for cursor positioning
    movea.l #$0003ab2c,a4
; a5 = $FF1804: save_buf_base -- used as decompress destination for portrait tile data
    movea.l #$00ff1804,a5
; d5 = 1: priority/mode flag passed to FillTileRect calls (bit 0 = use foreground palette)
    moveq   #$1,d5
; ClearCharSprites ($377C8): clear any existing character sprites from the panel area
; Ensures a clean slate before drawing the new relation cell
    dc.w    $4eb9,$0003,$77c8                           ; jsr $0377C8
; GameCommand #$1A: clear tile region for the cell background
; Args: width=$C, height=$20, col=d4, priority=$8000 (high-priority erase), row=0, area=0
    move.l  #$8000,-(sp)
    pea     ($000C).w
    pea     ($0020).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
; --- Phase: Compatibility Check for Tile Color ---
; RangeMatch($7158): test if char_a and char_b are in the same range/type category
; Returns d0=1 if same range (compatible pair), 0 if different
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    lea     $0024(sp),sp
    tst.w   d0
    beq.b   .l196d0
; Same range: use tile variant 2 (highlighted / compatible coloring)
    moveq   #$2,d2
    bra.b   .l196d2
.l196d0:                                                ; $0196D0
; Different range: use tile variant 1 (standard coloring)
    moveq   #$1,d2
.l196d2:                                                ; $0196D2
; --- Phase: Draw Character Name Tiles (char_a) ---
; FillTileRect($6760): draw character A's name tiles at (col=d4, row=d5, width=$B, height=2)
; Tile $075E = start of char name tile strip (wide font, 2 rows)
    pea     ($075E).w
; d2 = tile color variant (1=normal, 2=compatible highlight)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
; --- Phase: Draw Character Name Tiles (char_b) ---
; FillTileRect: draw character B's name tiles at (col=d4+2, row from $E(a6)+1)
; Tile $075F = char_b name tile strip (adjacent to char_a strip)
    pea     ($075F).w
; $E(a6)+1 = row offset argument + 1 for char_b's row
    move.w  $000e(a6),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
; --- Phase: Draw Compatibility Fraction Background Tiles ---
; GameCommand #$1A: place tile $077E at (col=d4+4, row=d5+4, width=$B, height=4)
; Tile $077E = compatibility fraction display area background / frame tile
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
; Second block of tile $077E at (col=d4+4, row=d5+$13): the bottom half of the fraction panel
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
; --- Phase: Optional Portrait DMA (mode flag check) ---
; If display mode argument ($12(a6)) == 1, decompress and DMA the portrait tile set
    cmpi.w  #$1,d3
    bne.b   .l197c6
; LZ_Decompress: decompress portrait gfx from ROM $4DCE8 into save_buf_base ($FF1804)
    pea     ($0004DCE8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
; VRAMBulkLoad($1D568): DMA transfer $328 bytes from $FF1804 to VRAM page #$12(a6)
; $328 = 808 bytes = 2 tile rows of portrait graphics data
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
.l197c6:                                                ; $0197C6
; --- Phase: Print Char A Name ---
; SetTextWindow: open a 32×32 window (full panel) for text rendering
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
; SetTextCursor(col=d4, row=d5+1): position cursor just below the top of the cell
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    jsr     (a4)
; PrintfWide: print char A name string
; char_a code (a2[0]) * 4 -> lookup ROM table $5E7E4 (char name pointer table)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
; Format string at $41110C: single-argument name print ("%s" or similar)
    pea     ($0004110C).l
    jsr     (a3)
; --- Phase: Print Char B Name ---
; SetTextCursor(col=d4, row=d5+$C): position for char B, 12 rows below cell top
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
; PrintfWide: print char B name
; char_b code (a2[1]) * 4 -> lookup same name pointer table
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
; CharCodeCompare($6F42): compute compatibility index between char_a and char_b
; Returns d0 = compat score (0-100)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
; Format string at $41108 displays the compat score as a fraction or percentage
    pea     ($00041108).l
    jsr     (a3)
    lea     $0030(sp),sp
; --- Phase: Print Char Type / Score Label ---
; SetTextCursor(col=d4, row=d5+$13): far-right row for the type/score line
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
; PlaceIconPair($58FC): place pair-type icon tiles at (col=d4, row=d5+$B)
; $58FC places 2 icon tiles side by side (from packed arg)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
; Second PlaceIconPair with offset $12 rows (second icon row)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
; PlaceIconTiles($595E): place 2x2 icon tile block at (col=d4, row=d5+$11)
; Args: tile_x=2, tile_y=2
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    lea     $0030(sp),sp
; PrintfWide: print char B's name one more time (for the score/type line)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
; Format at $41104: shorter name format for the bottom section label
    pea     ($00041104).l
    jsr     (a3)
; --- Phase: Compute and Display Relation Type Icon ---
; SetTextCursor(col=d4+2, row=d5+5): position for the relation type indicator
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    jsr     (a4)
; GetLowNibble($7402): extract low nibble of relation record byte[0] = char_a sub-type
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
; GetByteField4($74E0): extract packed 4-bit field from byte[0] = char_a slot ID
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
; Translate byte field through display index table at $FF1278:
; movea $FF1278, index by d0 byte -> relation type display offset
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
; Use result * 4 to index ROM table $5ECFC: pointer to relation type name string
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
; Format at $410FC: print the relation type name (e.g., "Business", "Rival", etc.)
    pea     ($000410FC).l
    jsr     (a3)
; --- Phase: ShowRelationAction and ShowRelationResult ---
; ShowRelationAction($199FA): display the action button hints for this relation pair
; Args: a2=record, row=d5, col=d4+4, mode=1, d3=row_param
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$00da                                 ; jsr $0199FA
    nop
    lea     $0030(sp),sp
; ShowRelationResult($199DE6): display the outcome/relationship status at (col+4, row+$F)
; Shows the relationship progression result (e.g., score change arrow)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$049c                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
; --- Phase: Decode Relation Status Flags for Score Display ---
; a2+$0A = stat_record +$0A: flags/status field (bit 2, 1, 0 encode the score tier)
; d3 = -1 initially (means "no score display")
    moveq   #-$1,d3
    move.b  $000a(a2),d0
; Bit 2: highest tier flag
    btst    #$02,d0
    beq.b   .l19962
; Bit 2 set: score tier 0 (best) -- use base offset $637B
    moveq   #$0,d3
    bra.b   .l1997c
.l19962:                                                ; $019962
    move.b  $000a(a2),d0
; Bit 1: middle tier flag
    btst    #$01,d0
    beq.b   .l19970
; Bit 1 set: score tier $10 (mid) -- offset $637B + $10
    moveq   #$10,d3
    bra.b   .l1997c
.l19970:                                                ; $019970
    move.b  $000a(a2),d0
; Bit 0: lowest active tier flag
    btst    #$00,d0
    beq.b   .l1997c
; Bit 0 set: score tier $8 (low) -- offset $637B + $8
    moveq   #$8,d3
.l1997c:                                                ; $01997C
; If d3 is still -1 (no bits set), skip the score DMA entirely
    moveq   #-$1,d0
    cmp.l   d3,d0
    bge.b   .l199f0
; --- Phase: Build Score Tile Table and DMA to VRAM ---
; d3 now holds the tier offset (0, $8, or $10)
; Compute the VRAM tile index sequence: base = d3 + $637B
; Then fill 8 consecutive entries in the local frame buffer at -$10(a6)
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    add.l   d3,d0
    addi.l  #$637b,d0
; d3 = absolute VRAM tile index for score tier (first of 8 sequential tiles)
    move.l  d0,d3
.l19992:                                                ; $019992
; Write 8 tile indices to -$10(a6) buffer: d3, d3+1, ... d3+7
; Each stored as a word at stride 2 (d2*2 offset into the -$10 frame buffer)
    move.w  d2,d0
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
    addq.l  #$1,d3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
; Fill 8 entries (8 tiles = 1 row of score meter graphic)
    blt.b   .l19992
; GameCommand #$1B: place tile block from the local frame buffer
; Args: addr=-$10(a6), height=4, width=2, col=d4+2, row=d5, flags=0
    pea     -$0010(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
; LZ_Decompress: decompress score-tier graphic from ROM $4E28A into $FF1804
; $4E28A contains the score meter tile graphics for all 3 tiers
    pea     ($0004E28A).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
; VRAMBulkLoad($1D568): DMA $18 bytes of decompressed score graphic data to VRAM
; Target VRAM page $037B: score-tier icon tile set
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l199f0:                                                ; $0199F0
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
