; ============================================================================
; ShowCompatibilityScore -- Computes and displays a character compatibility value between two players: calls RangeLookup and CharCodeCompare to check compatibility, then if valid shows the relation score panel (name, value, rating) via PrintfNarrow calls, offers a browse-relations interaction, and updates the displayed character stat.
; 584 bytes | $01D0C6-$01D30D
; ============================================================================
ShowCompatibilityScore:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $2c(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d5
    movea.l  #$00000D64,a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    cmp.w   d2, d3
    beq.w   l_1d2c6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    lea     $1c(a7), a7
    move.l  d0, d4
    andi.l  #$ffff, d4
    cmpi.l  #$ffff, d4
    beq.w   l_1d2c6
    tst.l   d4
    beq.w   l_1d2c6
    pea     ($0015).w
    pea     ($000D).w
    jsr     (a4)
    pea     ($000411A0).l
    jsr     (a3)
    pea     ($0015).w
    pea     ($0016).w
    jsr     (a4)
    move.l  d4, -(a7)
    pea     ($00041198).l
    jsr     (a3)
    pea     ($0017).w
    pea     ($000D).w
    jsr     (a4)
    pea     ($0003).w
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    move.l  d0, -(a7)
    pea     ($0004118E).l
    jsr     (a3)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.w  #$20, d0
    beq.w   l_1d2b2
    pea     ($0001).w
    move.w  ($00FFBD66).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  ($00FFBD64).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseRelations
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.w   l_1d2b2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
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
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $28(a7), a7
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $24(a7), a7
l_1d2b2:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$10, d0
    bne.b   l_1d2b2
l_1d2c6:
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d6/a2-a4
    rts
