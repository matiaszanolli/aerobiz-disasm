; ============================================================================
; ExecMenuCommand -- Executes a menu command for a selected city: initialises the route-map display, polls directional and button input in a loop, dispatches to CharacterBrowser (B), UpdateCharRelation (A on same city), or DrawStatDisplay/DisplayMenuOption (cursor), and returns the selected city index or an exit code.
; 1730 bytes | $01BBCC-$01C28D
; ============================================================================
ExecMenuCommand:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d5
    move.l  $8(a6), d6
    movea.l  #$00000D64,a5
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FFBD64,a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    cmp.w   d5, d0
    bne.b   l_1bc44
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E9FB,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, $2(a2)
l_1bc44:
    move.w  #$ff, d3
    move.w  #$ff, d0
    move.w  d0, d7
    move.w  d0, -$2(a6)
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $28(a7), a7
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
l_1bd64:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$c0, d0
    bne.b   l_1bd64
    movea.l  #$0004DFB8,a3
    movea.l  #$0004DD9C,a4
l_1bd84:
    jsr ResourceUnload
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr HitTestMapTile
    addq.l  #$8, a7
    move.w  d0, d2
    cmp.w   -$2(a6), d2
    beq.b   l_1bdfe
    cmpi.w  #$ff, d3
    bne.b   l_1bdfa
    cmpi.w  #$ff, d2
    beq.b   l_1bdce
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
    bra.b   l_1bdfa
l_1bdce:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    lea     $24(a7), a7
l_1bdfa:
    move.w  d2, -$2(a6)
l_1bdfe:
    cmp.w   d2, d7
    beq.w   l_1beba
    cmpi.w  #$ff, d3
    beq.w   l_1beb8
    cmpi.w  #$ff, d2
    beq.b   l_1be66
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowCompatibilityScore,PC)
    nop
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $30(a7), a7
    bra.b   l_1beb8
l_1be66:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0011).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
l_1beb8:
    move.w  d2, d7
l_1beba:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
l_1bef0:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$ff, d0
    beq.b   l_1bef0
    move.w  d4, d0
    andi.w  #$f, d0
    beq.b   l_1bf48
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $20(a7), a7
    bra.w   l_1bd84
l_1bf48:
    move.w  d4, d0
    andi.w  #$40, d0
    beq.b   l_1bf80
    cmpi.w  #$ff, d3
    beq.b   l_1bf72
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $10(a7), a7
l_1bf72:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0017).w
    bra.w   l_1c26c
l_1bf80:
    move.w  d4, d0
    andi.w  #$80, d0
    beq.w   l_1c05a
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    lea     $24(a7), a7
    move.w  d0, d2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a4, -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    cmpi.w  #$ff, d2
    beq.b   l_1c052
    move.w  d2, d5
    cmpi.w  #$ff, d3
    beq.b   l_1c052
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
l_1c052:
    move.w  #$ff, d7
    bra.w   l_1bd84
l_1c05a:
    move.w  d4, d0
    andi.w  #$20, d0
    beq.w   l_1c1ae
    cmpi.w  #$ff, d2
    beq.w   l_1bd84
    cmpi.w  #$ff, d3
    bne.b   l_1c0c2
    pea     ($0001).w
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $1c(a7), a7
    move.w  d2, d3
l_1c0aa:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$20, d0
    bne.b   l_1c0aa
    bra.w   l_1bd84
l_1c0c2:
    cmp.w   d2, d3
    bne.w   l_1bd84
    clr.l   -(a7)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharRelation,PC)
    nop
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16
    lea     $20(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a4, -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $28(a7), a7
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $10(a7), a7
    bra.w   l_1c052
l_1c1ae:
    move.w  d4, d0
    andi.w  #$10, d0
    beq.w   l_1bd84
    cmpi.w  #$ff, d3
    beq.w   l_1c262
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $18(a7), a7
    cmp.w   d3, d2
    bne.b   l_1c212
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($000B).w
    pea     ($0013).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d7
    bra.b   l_1c246
l_1c212:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    move.w  #$ff, d7
    move.w  d7, -$2(a6)
l_1c246:
    move.w  #$ff, d3
l_1c24a:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$10, d0
    bne.b   l_1c24a
    bra.w   l_1bd84
l_1c262:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0019).w
l_1c26c:
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    jsr ClearCharSprites
    move.w  d5, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

PrepareRelationPush:                                         ; $01C28E
    dc.w    $2F02                                            ; move.w d1,-(sp) [thunk before callee]

; === Translated block $01C290-$01C43C ===
; 2 functions, 428 bytes
