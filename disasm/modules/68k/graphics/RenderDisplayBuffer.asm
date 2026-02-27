; ============================================================================
; RenderDisplayBuffer -- Renders the main world-map display buffer for a given player/mode: copies layout data, resolves up to 7 visible players' screen positions from RAM tables, decompresses the background tileset and DMA-loads it to VRAM, iterates 4 route slots placing airline icons at computed tile coordinates, then prints the current year/quarter string in a text window.
; 700 bytes | $01CB82-$01CE3D
; ============================================================================
RenderDisplayBuffer:
    link    a6,#-$40
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.l  $c(a6), d6
    movea.l  #$0004A5B8,a4
    lea     -$1e(a6), a5
    pea     ($0010).w
    pea     -$10(a6)
    clr.l   -(a7)
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    clr.w   d2
l_1cbb8:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   l_1cbec
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$10(a6, d1.w)
l_1cbec:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_1cbb8
    pea     ($0010).w
    pea     ($0030).w
    move.l  a4, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a4, d0
    addi.l  #$82, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    jsr VRAMBulkLoad
    move.l  a4, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0008).w
    pea     ($0038).w
    pea     -$10(a6)
    jsr DisplaySetup
    pea     ($000E).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    jsr MemFillByte
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), -$20(a6)
    pea     ($0001).w
    pea     ($000F).w
    pea     -$20(a6)
    jsr DisplaySetup
    lea     $24(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d4
    bra.w   l_1cdc2
l_1ccc0:
    tst.b   $1(a2)
    bne.b   l_1cd10
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($00A8).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$48, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d4
    bra.w   l_1cdbe
l_1cd10:
    cmpi.b  #$6, $1(a2)
    beq.b   l_1cd2e
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    bra.b   l_1cd46
l_1cd2e:
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
l_1cd46:
    cmp.w   d6, d2
    beq.b   l_1cdbe
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005F088,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    addi.l  #$a8, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1
    add.l   d1, d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$3, (a5,a0.l)
l_1cdbe:
    addq.l  #$8, a2
    addq.w  #$1, d3
l_1cdc2:
    cmpi.w  #$4, d3
    blt.w   l_1ccc0
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, d2
    mulu.w  #$3, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_1cdec
    addq.l  #$3, d0
l_1cdec:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($0001).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004116C).l
    jsr PrintfNarrow
    movem.l -$64(a6), d2-d6/a2-a5
    unlk    a6
    rts
