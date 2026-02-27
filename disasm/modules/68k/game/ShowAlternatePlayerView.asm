; ============================================================================
; ShowAlternatePlayerView -- Renders the alternate player info screen: loads background tiles, builds a 17-row info panel with competitor data (names, owned cities, aircraft) via sprintf + PrintfWide, then cleans up
; 746 bytes | $03DBE4-$03DECD
; ============================================================================
ShowAlternatePlayerView:
    link    a6,#-$88
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    movea.l  #$00000D64,a4
    movea.l  #$0003B22C,a5
    clr.w   -$88(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$88(a6)
    jsr DisplaySetup
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w QueueVRAMWriteAddr
    jsr PreLoopInit
    pea     ($0012).w
    pea     ($0020).w
    bsr.w FillRectColor
    pea     ($00064660).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($00FF1804).l
    pea     ($0AC0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($000644C0).l
    jsr DisplaySetup
    lea     $24(a7), a7
    pea     ($000644E0).l
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   d3
    clr.w   d2
    bra.b   l_3dcbc
l_3dca8:
    cmp.w   d6, d3
    beq.b   l_3dcba
    move.w  d2, d0
    add.w   d0, d0
    lea     -$86(a6), a0
    move.w  d3, (a0,d0.w)
    addq.w  #$1, d2
l_3dcba:
    addq.w  #$1, d3
l_3dcbc:
    cmpi.w  #$4, d3
    blt.b   l_3dca8
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     (-$AF).w
    bsr.w QueueVRAMWriteAddr
    jsr ResourceUnload
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a4)
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  #$ff51, d4
    clr.w   d2
    moveq   #$2,d5
    move.w  d6, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    bra.w   l_3deaa
l_3dd2c:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    addq.l  #$8, a7
    cmpi.w  #$10, d2
    bne.b   l_3dd5e
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_3dd5e:
    tst.w   d2
    bne.b   l_3dd8e
    lea     -$80(a6), a2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_3dd72
    addq.l  #$3, d0
l_3dd72:
    asr.l   #$2, d0
    addi.l  #$7a3, d0
    move.l  d0, -(a7)
    move.l  ($0006588E).l, -(a7)
l_3dd82:
    move.l  a2, -(a7)
    jsr     (a5)
    lea     $c(a7), a7
    bra.w   l_3de66
l_3dd8e:
    cmpi.w  #$1, d2
    bne.b   l_3dda2
    lea     -$80(a6), a2
    move.l  a3, -(a7)
    move.l  ($00065892).l, -(a7)
    bra.b   l_3dd82
l_3dda2:
    cmpi.w  #$4, d2
    bne.b   l_3ddd8
    lea     -$80(a6), a2
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$4, d0
    moveq   #$7,d1
    cmp.l   d0, d1
    ble.b   l_3ddca
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    bra.b   l_3ddd0
l_3ddca:
    move.l  #$7, -(a7)
l_3ddd0:
    move.l  ($0006589E).l, -(a7)
    bra.b   l_3dd82
l_3ddd8:
    cmpi.w  #$6, d2
    bne.b   l_3ddfa
    lea     -$80(a6), a2
    move.w  -$86(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658A6).l, -(a7)
    bra.b   l_3dd82
l_3ddfa:
    cmpi.w  #$7, d2
    bne.b   l_3de1e
    lea     -$80(a6), a2
    move.w  -$84(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658AA).l, -(a7)
    bra.w   l_3dd82
l_3de1e:
    cmpi.w  #$8, d2
    bne.b   l_3de42
    lea     -$80(a6), a2
    move.w  -$82(a6), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($000658AE).l, -(a7)
    bra.w   l_3dd82
l_3de42:
    cmpi.w  #$a, d2
    bne.b   l_3de58
    lea     -$80(a6), a2
    move.l  a3, -(a7)
    move.l  ($000658B6).l, -(a7)
    bra.w   l_3dd82
l_3de58:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0006588E,a0
    movea.l (a0,d0.w), a2
l_3de66:
    move.l  a2, -(a7)
    pea     ($00046844).l
    jsr PrintfWide
    pea     ($0050).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    clr.w   d3
l_3de84:
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMWriteAddr
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d3
    addq.w  #$1, d4
    cmpi.w  #$10, d3
    blt.b   l_3de84
    addq.w  #$1, d2
    addq.w  #$2, d5
l_3deaa:
    cmpi.w  #$11, d2
    blt.w   l_3dd2c
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a4)
    clr.l   -(a7)
    jsr CmdSetBackground
    movem.l -$ac(a6), d2-d6/a2-a5
    unlk    a6
    rts
