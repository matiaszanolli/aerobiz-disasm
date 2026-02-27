; ============================================================================
; ProcessCharTrade -- Runs the character trade screen: decompresses the trade background, places the cursor sprite, calls InitFlightDisplay/UpdateFlightSlots, then processes a directional+button input loop supporting cursor movement (D-pad), character browsing (B), character selection (A), player info view (Start), and exit (C/back), animating flight paths between inputs.
; 1340 bytes | $01C646-$01CB81
; ============================================================================
ProcessCharTrade:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7
    movea.l $c(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFA7D8,a5
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedMod
    move.l  d0, d6
    mulu.w  #$3, d6
    addi.w  #$e, d6
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedDiv
    move.l  d0, d5
    add.w   d5, d5
    addi.w  #$16, d5
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    jsr ResourceUnload
    jsr InitFlightDisplay
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_1c73e
    moveq   #$1,d4
    bra.b   l_1c740
l_1c73e:
    moveq   #$0,d4
l_1c740:
    clr.w   d3
    clr.w   (a3)
    clr.w   (a5)
l_1c746:
    tst.w   d4
    beq.b   l_1c774
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_1c774
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
    bra.b   l_1c746
l_1c774:
    clr.w   d4
    cmpi.w  #$1, (a3)
    bne.b   l_1c7be
    tst.w   (a5)
    bne.b   l_1c7be
    moveq   #$A,d2
    bra.b   l_1c7b6
l_1c784:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_1c7be
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
l_1c7b6:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    bne.b   l_1c784
l_1c7be:
    cmpi.w  #$1, (a3)
    bne.b   l_1c7c8
    move.w  #$1, (a5)
l_1c7c8:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.b   l_1c814
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.b   l_1c834
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_1c850
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1c870
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   l_1c88c
    moveq   #$40,d1
    cmp.w   d1, d0
    beq.w   l_1c8de
    cmpi.w  #$80, d0
    beq.w   l_1c8e8
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1c9d8
    bra.w   l_1cb14
l_1c814:
    move.w  #$1, (a3)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$1D,d1
    cmp.l   d0, d1
    ble.b   l_1c82c
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    bra.b   l_1c82e
l_1c82c:
    moveq   #$1D,d0
l_1c82e:
    move.w  d0, d6
    bra.w   l_1cb18
l_1c834:
    move.w  #$1, (a3)
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0
    moveq   #$E,d1
    cmp.l   d0, d1
    bge.b   l_1c84c
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0
    bra.b   l_1c82e
l_1c84c:
    moveq   #$E,d0
    bra.b   l_1c82e
l_1c850:
    move.w  #$1, (a3)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    moveq   #$18,d1
    cmp.l   d0, d1
    ble.b   l_1c868
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    bra.b   l_1c86a
l_1c868:
    moveq   #$18,d0
l_1c86a:
    move.w  d0, d5
    bra.w   l_1cb18
l_1c870:
    move.w  #$1, (a3)
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0
    moveq   #$16,d1
    cmp.l   d0, d1
    bge.b   l_1c888
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0
    bra.b   l_1c86a
l_1c888:
    moveq   #$16,d0
    bra.b   l_1c86a
l_1c88c:
    clr.w   (a3)
    clr.w   (a5)
    move.w  d5, d0
    ext.l   d0
    subi.l  #$16, d0
    bge.b   l_1c89e
    addq.l  #$1, d0
l_1c89e:
    asr.l   #$1, d0
    move.l  d0, d7
    mulu.w  #$6, d7
    move.l  d7, -(a7)
    move.w  d6, d0
    ext.l   d0
    subi.l  #$e, d0
    moveq   #$3,d1
    jsr SignedDiv
    add.l   (a7)+, d0
    move.w  d0, d7
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w HandleMenuSelection
    lea     $c(a7), a7
l_1c8d2:
    jsr ClearFlightSlots
    move.w  d7, d0
    bra.w   l_1cb78
l_1c8de:
    clr.w   (a3)
    clr.w   (a5)
    ori.w   #$8000, d7
    bra.b   l_1c8d2
l_1c8e8:
    clr.w   (a3)
    clr.w   (a5)
    jsr ClearFlightSlots
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    move.w  d0, d2
    cmpi.w  #$ff, d2
    beq.b   l_1c92e
    cmp.w   (a2), d2
    beq.b   l_1c92e
    move.w  d2, (a2)
l_1c92e:
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $28(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $2c(a7), a7
    jsr ResourceUnload
    bra.w   l_1cb18
l_1c9d8:
    clr.w   (a3)
    clr.w   (a5)
    jsr ClearFlightSlots
    jsr ResourceLoad
    move.w  #$7, ($00FF9A1C).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0002).w
    pea     ($0007).w
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w ShowPlayerInfo
    lea     $30(a7), a7
    jsr ResourceUnload
    clr.w   d3
l_1ca4a:
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.l  #$90, d0
    beq.b   l_1ca4a
    jsr ResourceLoad
    move.w  (a2), ($00FF9A1C).l
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $24(a7), a7
    jsr ResourceUnload
l_1cb14:
    clr.w   (a3)
    clr.w   (a5)
l_1cb18:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    clr.w   d2
l_1cb52:
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1cb52
    bra.w   l_1c746
l_1cb78:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
