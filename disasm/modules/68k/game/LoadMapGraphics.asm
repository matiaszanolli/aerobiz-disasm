; ============================================================================
; LoadMapGraphics -- Loads and renders the full world-map sequence: decompresses route/city LZ tiles, tiles them to VRAM in chunks, animates a scrolling preview, and loops through all map regions before returning
; 1252 bytes | $03C1B8-$03C69B
; ============================================================================
LoadMapGraphics:
    link    a6,#-$80
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00000D64,a2
    lea     -$80(a6), a3
    movea.l  #$00FF1804,a4
    movea.l  #$000045B2,a5
    move.l  ($000B753C).l, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    pea     ($00BF).w
    pea     ($0001).w
    move.l  a4, -(a7)
    jsr CmdPlaceTile
    move.l  ($000B7540).l, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    lea     $1c(a7), a7
    clr.w   d2
l_3c208:
    moveq   #$0,d3
    move.w  d2, d3
    addi.l  #$80, d3
    cmpi.l  #$2e0, d3
    bge.b   l_3c222
    move.l  #$80, d3
    bra.b   l_3c22e
l_3c222:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$2e0, d3
    sub.l   d0, d3
l_3c22e:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$c0, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0
    pea     (a4, d0.l)
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addi.w  #$80, d2
    cmpi.w  #$2e0, d2
    bcs.b   l_3c208
    move.l  ($000B7544).l, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    addq.l  #$8, a7
    clr.w   d2
l_3c27a:
    moveq   #$0,d3
    move.w  d2, d3
    addi.l  #$80, d3
    cmpi.l  #$200, d3
    bge.b   l_3c294
    move.l  #$80, d3
    bra.b   l_3c2a0
l_3c294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$200, d3
    sub.l   d0, d3
l_3c2a0:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$400, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$5, d0
    pea     (a4, d0.l)
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $14(a7), a7
    addi.w  #$80, d2
    cmpi.w  #$200, d2
    bcs.b   l_3c27a
    pea     ($0007486E).l
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($00074AEE).l
    pea     ($0012).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($0080).w
    pea     ($0080).w
    pea     ($0007586E).l
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    pea     ($0100).w
    pea     ($0080).w
    pea     ($0007596E).l
    pea     ($0020).w
    pea     ($0020).w
    pea     ($000F).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($00076F16).l
    jsr     (a5)
    lea     $2c(a7), a7
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F36).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F96).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F76).l
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($0006).w
    pea     ($0040).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    pea     ($00048D30).l
    bsr.w RenderColorTileset
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($00076F36).l
    jsr     (a5)
    pea     ($0020).w
    move.l  a3, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F56).l
    jsr     (a5)
    lea     $2c(a7), a7
    move.l  a3, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.w   d2
l_3c42e:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  #$80, d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0080).w
    pea     ($0007586E).l
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_3c46a
l_3c462:
    bsr.w ShowGameOverScreen
    bra.w   l_3c692
l_3c46a:
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$100, d0
    move.l  d0, -(a7)
    pea     ($0080).w
    pea     ($0007596E).l
    pea     ($0020).w
    pea     ($0020).w
    pea     ($000F).w
    jsr     (a2)
    pea     ($0002).w
    bsr.w WaitForStartButton
    lea     $1c(a7), a7
    tst.w   d0
    bne.b   l_3c462
    addq.w  #$1, d2
    cmpi.w  #$80, d2
    bcs.b   l_3c42e
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $28(a7), a7
    pea     ($0100).w
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    move.l  ($000B7548).l, -(a7)
    move.l  a4, -(a7)
    jsr LZ_Decompress
    pea     ($0120).w
    pea     ($0400).w
    move.l  a4, -(a7)
    jsr CmdPlaceTile
    lea     $20(a7), a7
    pea     ($00075A6E).l
    pea     ($0010).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($000A).w
    jsr LoadDisplaySet
    lea     $20(a7), a7
    clr.w   d2
    move.w  #$80, d3
    bra.b   l_3c5aa
l_3c52e:
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    cmpi.w  #$150, d0
    beq.b   l_3c550
    cmpi.w  #$1a8, d0
    beq.b   l_3c558
    bra.b   l_3c57a
l_3c550:
    pea     ($000753EE).l
    bra.b   l_3c55e
l_3c558:
    pea     ($00074F6E).l
l_3c55e:
    pea     ($0012).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
l_3c57a:
    pea     ($0002).w
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_3c594
l_3c588:
    pea     ($0018).w
    jsr     (a2)
    addq.l  #$4, a7
    bra.w   l_3c462
l_3c594:
    tst.w   d3
    beq.b   l_3c5a0
    moveq   #$0,d0
    move.w  d3, d0
    subq.l  #$1, d0
    bra.b   l_3c5a6
l_3c5a0:
    move.l  #$200, d0
l_3c5a6:
    move.w  d0, d3
    addq.w  #$1, d2
l_3c5aa:
    cmpi.w  #$180, d2
    bcs.w   l_3c52e
    pea     ($0018).w
    jsr     (a2)
    pea     ($0013).w
    jsr LoadDisplaySet
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    move.w  #$100, d3
l_3c5e4:
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    lea     $c(a7), a7
    moveq   #$0,d0
    move.w  d3, d0
    cmpi.w  #$1b8, d0
    beq.b   l_3c60c
    cmpi.w  #$160, d0
    beq.b   l_3c614
    cmpi.w  #$108, d0
    beq.b   l_3c61c
    bra.b   l_3c63e
l_3c60c:
    pea     ($00075F2E).l
    bra.b   l_3c622
l_3c614:
    pea     ($00075ECE).l
    bra.b   l_3c622
l_3c61c:
    pea     ($00075E6E).l
l_3c622:
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000C).w
    pea     ($0009).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
l_3c63e:
    pea     ($0001).w
    bsr.w WaitForStartButton
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3c588
    addq.w  #$1, d3
    cmpi.w  #$200, d3
    bcs.b   l_3c5e4
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    pea     ($0018).w
    jsr     (a2)
    pea     ($0040).w
    bsr.w WaitForStartButton
    lea     $14(a7), a7
    tst.w   d0
    bne.w   l_3c462
    move.l  #$8000, -(a7)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
l_3c692:
    movem.l -$98(a6), d2-d3/a2-a5
    unlk    a6
    rts
