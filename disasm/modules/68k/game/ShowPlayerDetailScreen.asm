; ============================================================================
; ShowPlayerDetailScreen -- Renders the scrolling player detail screen: decompresses and places tiles, builds 17-row info text (game year, player data from $FF00A8) via sprintf + PrintfWide, and animates VRAM write positions
; 640 bytes | $03D964-$03DBE3
; ============================================================================
ShowPlayerDetailScreen:
    link    a6,#-$84
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d6
    movea.l  #$00000D64,a3
    movea.l  #$00005092,a4
    movea.l  #$00FF1804,a5
    clr.w   -$82(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w QueueVRAMWriteAddr
    jsr PreLoopInit
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr     (a4)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$82(a6)
    jsr     (a4)
    pea     ($0012).w
    pea     ($0020).w
    bsr.w FillRectColor
    lea     $28(a7), a7
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00062782).l
    jsr     (a4)
    pea     ($000627A2).l
    pea     ($000C).w
    pea     ($0010).w
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($00062922).l
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0240).w
    move.l  a5, -(a7)
    pea     ($0B40).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    clr.l   -(a7)
    pea     (-$AF).w
    bsr.w QueueVRAMWriteAddr
    jsr ResourceUnload
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    lea     $28(a7), a7
    move.w  #$ff51, d4
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d3
    moveq   #$2,d5
    bra.w   l_3db2c
l_3da56:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    addq.l  #$8, a7
    cmpi.w  #$10, d3
    bne.b   l_3da88
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    lea     $1c(a7), a7
l_3da88:
    tst.w   d3
    bne.b   l_3daba
    lea     -$80(a6), a2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_3da9c
    addq.l  #$3, d0
l_3da9c:
    asr.l   #$2, d0
    addi.l  #$7a3, d0
    move.l  d0, -(a7)
    move.l  ($0006583E).l, -(a7)
l_3daac:
    move.l  a2, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_3dae8
l_3daba:
    cmpi.w  #$4, d3
    bne.b   l_3dada
    lea     -$80(a6), a2
    move.w  d6, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  ($0006584E).l, -(a7)
    bra.b   l_3daac
l_3dada:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0006583E,a0
    movea.l (a0,d0.w), a2
l_3dae8:
    move.l  a2, -(a7)
    pea     ($00046840).l
    jsr PrintfWide
    pea     ($003C).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    clr.w   d2
l_3db06:
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMWriteAddr
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d4
    cmpi.w  #$10, d2
    blt.b   l_3db06
    addq.w  #$1, d3
    addq.w  #$2, d5
l_3db2c:
    cmpi.w  #$11, d3
    blt.w   l_3da56
    pea     ($0032).w
    pea     ($000E).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w QueueVRAMWriteAddr
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00063310).l
    jsr     (a4)
    pea     ($0017).w
    jsr LoadDisplaySet
    lea     $2c(a7), a7
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A7E).l
    jsr     (a4)
    move.l  ($000A1B64).l, -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0025).w
    pea     ($0110).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     $28(a7), a7
    pea     ($00073318).l
    pea     ($0003).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    pea     ($0064).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$a8(a6), d2-d6/a2-a5
    unlk    a6
    rts
