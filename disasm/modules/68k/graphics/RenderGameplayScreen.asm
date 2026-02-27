; ============================================================================
; RenderGameplayScreen -- Main map interaction loop: handles cursor, tile selection, char comparison, and dialog display
; 1638 bytes | $037162-$0377C7
; ============================================================================
RenderGameplayScreen:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d5
    movea.l  #$00000D64,a5
    move.w  #$1, -$b8(a6)
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  #$ff, d6
    move.w  #$ff, d4
    movea.l  #$00FFBD64,a2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $30(a7), a7
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3720c
    moveq   #$1,d2
    bra.b   l_3720e
l_3720c:
    moveq   #$0,d2
l_3720e:
    clr.w   d7
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_3721c:
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
    tst.w   d2
    beq.b   l_37272
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_37272
    pea     ($0003).w
l_37268:
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_3721c
l_37272:
    clr.w   d2
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bf, d0
    move.w  d0, d7
    tst.w   -$b8(a6)
    beq.w   l_37480
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr HitTestMapTile
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    beq.w   l_37428
    cmp.w   d4, d6
    beq.w   l_3747c
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    lea     $30(a7), a7
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$ffff, d6
    beq.b   l_37388
    tst.w   d6
    beq.b   l_37388
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($00044F76).l
    jsr PrintfNarrow
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    move.l  d0, -(a7)
    pea     ($00044F6C).l
    jsr PrintfNarrow
    addq.l  #$8, a7
    bra.w   l_37424
l_37388:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    cmp.w   d3, d4
    bne.b   l_373e8
    pea     ($0003).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextWindow
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    movea.l (a0,d0.w), a3
    move.l  a3, -(a7)
    move.l  a3, -(a7)
    pea     ($00044F46).l
    jsr PrintfNarrow
    lea     $1c(a7), a7
    bra.b   l_3740e
l_373e8:
    pea     ($0003).w
    pea     ($001C).w
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($00044F12).l
    jsr PrintfNarrow
    lea     $14(a7), a7
l_3740e:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
l_37424:
    move.w  d4, d6
    bra.b   l_3747c
l_37428:
    cmpi.w  #$ff, d6
    beq.b   l_3747c
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($0037).w
    jsr GameCmd16
    lea     $24(a7), a7
    move.w  #$ff, d6
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
l_3747c:
    clr.w   -$b8(a6)
l_37480:
    move.w  d7, d0
    andi.w  #$20, d0
    beq.w   l_3769c
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
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
    cmpi.w  #$ff, d4
    beq.w   l_37694
    pea     ($0001).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    lea     $c(a7), a7
    cmp.w   d3, d4
    beq.w   l_375f0
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindRelationRecord
    lea     $c(a7), a7
    tst.l   d0
    bne.w   l_375d8
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CheckAlliancePermission,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    beq.w   l_375c2
    pea     ($0003).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    cmp.l   $6(a4), d0
    bgt.b   l_37576
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr MatchCharSlots
    lea     $c(a7), a7
    bra.w   l_377bc
l_37576:
    jsr (ClearCharSprites,PC)
    nop
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048642).l, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000485F6).l, -(a7)
    pea     -$b6(a6)
    jsr sprintf
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    bra.b   l_37622
l_375c2:
    jsr (ClearCharSprites,PC)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00044EDC).l
    bra.b   l_37626
l_375d8:
    jsr (ClearCharSprites,PC)
    nop
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  ($00048636).l, -(a7)
    bra.b   l_37626
l_375f0:
    jsr (ClearCharSprites,PC)
    nop
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($0004861A).l, -(a7)
    pea     -$b6(a6)
    jsr sprintf
    lea     $c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
l_37622:
    pea     -$b6(a6)
l_37626:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_37676:
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
l_37694:
    pea     ($0002).w
    bra.w   l_37268
l_3769c:
    move.w  d7, d0
    andi.w  #$10, d0
    beq.b   l_376b8
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d4
    bra.w   l_377bc
l_376b8:
    move.w  d7, d0
    andi.w  #$80, d0
    beq.w   l_37796
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    lea     $24(a7), a7
    move.w  d0, -$2(a6)
    cmpi.w  #$ff, -$2(a6)
    beq.b   l_37720
    move.w  -$2(a6), d0
    cmp.w   $e(a6), d0
    beq.b   l_37720
    move.w  -$2(a6), $e(a6)
l_37720:
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
    bra.w   l_37676
l_37796:
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos
    addq.l  #$8, a7
    move.w  #$1, ($00FF13FC).l
    move.w  #$1, -$b8(a6)
    pea     ($0001).w
    bra.w   l_37268
l_377bc:
    move.w  d4, d0
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts
