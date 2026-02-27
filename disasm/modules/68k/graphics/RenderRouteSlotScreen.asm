; ============================================================================
; RenderRouteSlotScreen -- draws the full route slot screen with character portraits and revenue bar graphs for a player
; 780 bytes | $010D08-$011013
; ============================================================================
RenderRouteSlotScreen:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    movea.l  #$00000D64,a4
    movea.l  #$00FF1804,a5
    pea     ($000E).w
    clr.l   -(a7)
    pea     -$e(a6)
    jsr MemFillByte
    jsr ResourceLoad
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0004A5BA).l
    jsr DisplaySetup
    lea     $28(a7), a7
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0002).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004A63A).l
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0025).w
    pea     ($0330).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    cmpi.w  #$3, d7
    bge.b   l_10e10
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0004797C,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$000A1B14,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0014).w
    pea     ($03CD).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    pea     ($00071F98).l
    pea     ($0004).w
    pea     ($0005).w
    pea     ($0003).w
    pea     ($0019).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
l_10e10:
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_10e22:
    move.w  d3, d5
    andi.w  #$1, d5
    mulu.w  #$6, d5
    addi.w  #$d, d5
    move.w  d3, d4
    ext.l   d4
    asr.l   #$1, d4
    lsl.w   #$3, d4
    addq.w  #$2, d4
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude
    lea     $10(a7), a7
    tst.b   $1(a2)
    bne.b   l_10ea6
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    bra.w   l_10fde
l_10ea6:
    cmpi.b  #$6, $1(a2)
    bne.b   l_10ebc
    cmpi.w  #$3, $6(a2)
    beq.b   l_10ebc
    moveq   #$0,d2
    move.b  (a2), d2
    bra.b   l_10ecc
l_10ebc:
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
l_10ecc:
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
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1
    add.l   d1, d0
    addi.l  #$18, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    move.w  d2, d0
    add.w   d0, d0
    addq.w  #$3, -$e(a6, d0.w)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteRevenue,PC)
    nop
    lea     $2c(a7), a7
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$5, d2
    bge.b   l_10f62
    move.w  d2, d0
    ext.l   d0
    bra.b   l_10f64
l_10f62:
    moveq   #$5,d0
l_10f64:
    move.w  d0, d2
    pea     ($0774).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    ble.b   l_10fde
    pea     ($0775).w
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
l_10fde:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   l_10e22
    cmpi.w  #$3, d7
    bge.b   l_11004
    pea     ($000A).w
    pea     ($0019).w
    pea     ($0004).w
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude
l_11004:
    jsr ResourceUnload
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts
