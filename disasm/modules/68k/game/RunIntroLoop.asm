; ============================================================================
; RunIntroLoop -- Runs the full intro/demo sequence: displays 5 scenario preview screens, animates a globe flyby with CalcScreenCoord, then shows the opening animation; exits on Start or after full playback
; 1064 bytes | $03BD52-$03C179
; ============================================================================
RunIntroLoop:
    link    a6,#-$80
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    lea     -$80(a6), a4
    movea.l  #$0003BD1E,a5
    pea     ($0010).w
    clr.l   -(a7)
    move.l  ($00077016).l, -(a7)
    jsr DisplaySetup
    pea     ($0010).w
    pea     ($0010).w
    move.l  ($0007702E).l, -(a7)
    jsr DisplaySetup
    pea     ($0010).w
    pea     ($0020).w
    move.l  ($00077046).l, -(a7)
    jsr DisplaySetup
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076EF6).l
    jsr DisplaySetup
    lea     $30(a7), a7
    move.l  ($000B7530).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($037F).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    move.l  ($000B7534).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($003C).w
    pea     ($03C0).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    move.l  ($000B7538).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0078).w
    pea     ($0400).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($000739CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($000740CE).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr MenuSelectEntry
    lea     $24(a7), a7
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    jsr SetScrollBarMode
    jsr ResourceUnload
    pea     ($0040).w
    bsr.w WaitForStartButton
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_3beac
l_3bea6:
    jsr     (a5)
    bra.w   l_3c170
l_3beac:
    clr.w   d2
l_3beae:
    pea     ($0068).w
    pea     ($0068).w
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$000747CE,a0
    pea     (a0, d0.w)
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    lea     $18(a7), a7
    clr.w   d3
l_3bed6:
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$2,d1
    jsr SignedMod
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    jsr DisplaySetup
    pea     ($0020).w
    bsr.w WaitForStartButton
    lea     $10(a7), a7
    tst.w   d0
    bne.b   l_3bea6
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_3bed6
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_3beae
    clr.w   d2
l_3bf1e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$8,d1
    jsr SignedMod
    tst.l   d0
    bne.b   l_3bf5e
    pea     ($0010).w
    pea     ($0020).w
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3bf3e
    addq.l  #$7, d0
l_3bf3e:
    asr.l   #$3, d0
    moveq   #$2,d1
    jsr SignedMod
    lsl.l   #$2, d0
    movea.l  #$00077046,a0
    move.l  (a0,d0.l), -(a7)
    jsr DisplaySetup
    lea     $c(a7), a7
l_3bf5e:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$68,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0068).w
    pea     ($0007480E).l
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    pea     ($0004).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$68, d2
    bcs.b   l_3bf1e
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $c(a7), a7
    clr.w   d2
    movea.l a4, a2
    moveq   #$40,d0
    adda.l  d0, a2
l_3bfb0:
    pea     ($0020).w
    move.l  a4, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077016,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007702E,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
    pea     ($0020).w
    move.l  a2, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$0007701A,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
    pea     ($0020).w
    move.l  a4, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    movea.l  #$00077032,a0
    move.l  (a0,d0.l), -(a7)
    jsr MemMove
    lea     $30(a7), a7
    pea     ($0006).w
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.l  a4, -(a7)
    bsr.w RenderColorTileset
    pea     ($0020).w
    bsr.w WaitForStartButton
    lea     $18(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.w   l_3bfb0
    pea     ($0040).w
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3bea6
    clr.w   d2
l_3c070:
    move.w  d2, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0130).w
    bsr.w CalcScreenCoord
    move.w  d0, d3
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    move.w  #$10f, d0
    sub.w   d2, d0
    move.l  d0, -(a7)
    pea     ($0110).w
    bsr.w CalcScreenCoord
    lea     $20(a7), a7
    move.w  d0, d4
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    subi.l  #$30, d0
    move.l  d0, -(a7)
    pea     ($0007481E).l
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a3)
    pea     ($0001).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    bne.w   l_3bea6
    addq.w  #$1, d2
    cmpi.w  #$110, d2
    bcs.b   l_3c070
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0080).w
    move.l  a4, -(a7)
    pea     ($00FF14BC).l
    jsr MemMove
    pea     ($0006).w
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($00048D30).l
    move.l  a4, -(a7)
    bsr.w RenderColorTileset
    lea     $2c(a7), a7
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollBarMode
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    bsr.w UpdateScrollRegisters
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
l_3c170:
    movem.l -$9c(a6), d2-d4/a2-a5
    unlk    a6
    rts
