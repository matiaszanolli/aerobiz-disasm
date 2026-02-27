; ============================================================================
; RenderQuarterScreenGrid -- Render the quarterly results grid showing aircraft icon tiles and profit values for each active route slot.
; 420 bytes | $020FF2-$021195
; ============================================================================
RenderQuarterScreenGrid:
    link    a6,#-$3C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00FF1804,a5
    move.l  ($000A1AF8).l, -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0010).w
    pea     ($01E1).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     $14(a7), a7
    cmpi.w  #$20, d3
    bcc.b   l_21054
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$6,d7
    bra.b   l_21076
l_21054:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$4,d7
l_21076:
    move.w  #$640, d5
    moveq   #$D,d6
    moveq   #$5,d4
    clr.w   d3
    bra.w   l_21186
l_21084:
    cmpi.b  #$f, (a2)
    bcc.w   l_21180
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     -$3c(a6), a3
    clr.w   d2
l_210bc:
    move.w  d5, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a3)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_210bc
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    move.b  (a4), d2
    andi.w  #$7f, d2
    cmpi.w  #$4, d2
    bge.b   l_2116e
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$18, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$1e1, d0
    move.l  d0, -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
l_2116e:
    addi.w  #$1e, d5
    addq.w  #$5, d4
    move.w  d4, d0
    cmpi.w  #$f, d0
    blt.b   l_21180
    addq.w  #$6, d6
    moveq   #$5,d4
l_21180:
    addq.l  #$1, a2
    addq.l  #$1, a4
    addq.w  #$1, d3
l_21186:
    cmp.w   d7, d3
    blt.w   l_21084
    movem.l -$64(a6), d2-d7/a2-a5
    unlk    a6
    rts
