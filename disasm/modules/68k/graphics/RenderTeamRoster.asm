; ============================================================================
; RenderTeamRoster -- Displays team roster screen with portraits and stats; routes input to sub-screens
; 1474 bytes | $037A3C-$037FFD
; ============================================================================
RenderTeamRoster:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d3
    movea.l $30(a7), a2
    movea.l  #$00000D64,a4
    movea.l  #$00FF1804,a5
    clr.w   d5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0004DCE8).l
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($001A).w
    pea     ($0328).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    jsr ResourceUnload
    clr.w   d2
l_37aa4:
    tst.w   d2
    bne.b   l_37ad4
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderMatchResults,PC)
    nop
    lea     $14(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.w   l_37fee
    bra.w   l_37ff6
l_37ad4:
    cmpi.w  #$1, d2
    beq.b   l_37ae2
    cmpi.w  #$5, d2
    bne.w   l_37d30
l_37ae2:
    cmpi.w  #$1, d2
    bne.w   l_37c50
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeMatch
    tst.w   d0
    beq.b   l_37b48
    move.l  ($000A1B50).l, -(a7)
    bra.b   l_37b4e
l_37b48:
    move.l  ($000A1B4C).l, -(a7)
l_37b4e:
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0001).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007651E).l
    jsr DisplaySetup
    lea     $18(a7), a7
    pea     ($00072AC0).l
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0007651E).l
    jsr DisplaySetup
    move.l  ($000A1AE4).l, -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0694).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    pea     ($00070F38).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0005).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($00070F58).l
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0005).w
    pea     ($0002).w
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr (ShowCharPortrait,PC)
    nop
    lea     $18(a7), a7
l_37c50:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0004).w
    pea     ($0005).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    pea     ($00044FA0).l
    jsr PrintfNarrow
    pea     ($0004).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.l  d0, -(a7)
    pea     ($00044F96).l
    jsr PrintfNarrow
    lea     $c(a7), a7
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderPlayerInterface,PC)
    nop
l_37d28:
    addq.l  #$8, a7
    move.w  d0, d2
    bra.w   l_37fee
l_37d30:
    cmpi.w  #$2, d2
    bne.b   l_37d46
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (HandlePlayerMenuInput,PC)
    nop
    bra.b   l_37d28
l_37d46:
    cmpi.w  #$3, d2
    bne.b   l_37d5c
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderGameDialogs,PC)
    nop
    bra.b   l_37d28
l_37d5c:
    cmpi.w  #$4, d2
    bne.w   l_37fee
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($0004860E).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $30(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_37fe6
    clr.w   $e(a2)
    clr.w   $6(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d5
    moveq   #$0,d4
    move.b  (a2), d4
    moveq   #$0,d6
    move.b  $1(a2), d6
    cmp.w   d5, d2
    beq.b   l_37e46
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    moveq   #$1,d0
    lsl.b   d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    move.l  d0, d4
    add.w   d2, d0
    move.l  (a7)+, d1
    movea.l  #$00FFA7BC,a0
    or.b    d1, (a0,d0.w)
    moveq   #$1,d0
    lsl.b   d2, d0
    move.w  d4, d1
    add.w   d5, d1
    movea.l  #$00FFA7BC,a0
    or.b    d0, (a0,d1.w)
    addq.b  #$1, $4(a3)
    bra.w   l_37efa
l_37e46:
    cmpi.w  #$20, d4
    bge.b   l_37e66
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   l_37e9e
l_37e66:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d4, d1
    sub.w   d0, d1
    move.w  d1, d4
    moveq   #$1,d0
    lsl.w   d4, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    move.w  d2, d7
    add.w   d7, d7
    add.w   d7, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a3)
l_37e9e:
    cmpi.w  #$20, d6
    bge.b   l_37ec0
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    or.l    d0, (a0,d1.w)
    bra.b   l_37ef6
l_37ec0:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d6, d4
    sub.w   d0, d4
    moveq   #$1,d0
    lsl.w   d4, d0
    move.w  d3, d1
    mulu.w  #$e, d1
    move.w  d5, d7
    add.w   d7, d7
    add.w   d7, d1
    movea.l  #$00FFBD6C,a0
    or.w    d0, (a0,d1.w)
    addq.b  #$1, $3(a3)
l_37ef6:
    addq.b  #$1, $5(a3)
l_37efa:
    clr.b   $2(a3)
    clr.w   d2
l_37f00:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_37f1e
    addq.b  #$1, $2(a3)
l_37f1e:
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   l_37f00
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    sub.l   d0, $6(a3)
    move.l  a2, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  d3, d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E9,a0
    adda.l  d0, a0
    movea.l a0, a3
    move.l  a2, -(a7)
    jsr GetLowNibble
    sub.b   d0, (a3)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a2), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $3(a2), d1
    movea.l  #$00FFBA81,a0
    add.b   d1, (a0,d0.w)
    move.b  #$4, $a(a2)
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr InsertRelationRecord
    lea     $24(a7), a7
    moveq   #$1,d5
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_37ff6
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunWorldMapAnimation,PC)
    nop
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SelectMenuItem
    addq.l  #$8, a7
    bra.b   l_37ff6
l_37fe6:
    clr.w   d2
    jsr PreLoopInit
l_37fee:
    cmpi.w  #$ff, d2
    bne.w   l_37aa4
l_37ff6:
    move.w  d5, d0
    movem.l (a7)+, d2-d7/a2-a5
    rts
