; ============================================================================
; InitGraphicsMemory -- Initialize and run the main character management screen: build owned char list, enter full navigation loop with page management, and dispatch to sub-screens.
; 858 bytes | $024EFA-$025253
; ============================================================================
InitGraphicsMemory:
    link    a6,#-$2C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$00000D64,a4
    lea     -$2c(a6), a5
    moveq   #$1,d5
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    addq.l  #$4, a7
    move.w  d7, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d4
    clr.w   d2
.l24f40:
    tst.b   (a3)
    beq.b   .l24f54
.l24f44:
    move.w  d4, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d2, (a5,a0.l)
    addq.w  #$1, d4
    bra.b   .l24f7c
.l24f54:
    move.w  d7, d0
    mulu.w  #$14, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
.l24f68:
    cmp.b   (a2), d2
    bne.b   .l24f72
    tst.b   $1(a2)
    bne.b   .l24f44
.l24f72:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$5, d3
    blt.b   .l24f68
.l24f7c:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l24f40
    tst.w   d4
    ble.w   .l2524a
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w OrchestrateGraphicsPipeline
    jsr ResourceUnload
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l24fba
    moveq   #$1,d0
    bra.b   .l24fbc
.l24fba:
    moveq   #$0,d0
.l24fbc:
    move.w  d0, -$a(a6)
    clr.w   d6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    clr.w   d3
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedDiv
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    move.l  d0, -$4(a6)
    move.w  d4, d0
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    subq.l  #$1, d0
    move.l  d0, -$8(a6)
.l24ffa:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$1d, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($0773).w
    jsr TilePlacement
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    tst.w   -$a(a6)
    beq.b   .l25048
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   .l24ffa
.l25048:
    clr.w   -$a(a6)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d6
    andi.w  #$20, d0
    beq.w   .l25116
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    tst.w   d5
    beq.b   .l24ffa
    moveq   #$D,d5
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), -$c(a6)
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($000C).w
    pea     ($001E).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  -$c(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharProfile
    pea     ($0010).w
    pea     ($000E).w
    jsr     (a4)
    lea     $20(a7), a7
    clr.w   d5
    bra.w   .l24ffa
.l25116:
    move.w  d6, d0
    andi.w  #$10, d0
    beq.b   .l2512e
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l2524a
.l2512e:
    move.w  d6, d0
    andi.w  #$1, d0
    beq.b   .l251b2
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
    subq.w  #$1, d2
    tst.w   d2
    bge.w   .l24ffa
    cmpi.w  #$5, d4
    ble.b   .l251ac
    moveq   #$4,d2
    subq.w  #$5, d3
    tst.w   d3
    bge.b   .l2515e
    move.w  -$2(a6), d3
    move.w  -$6(a6), d2
.l2515e:
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    jsr PreLoopInit
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $20(a7), a7
.l2518c:
    move.l  a5, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w OrchestrateGraphicsPipeline
    lea     $10(a7), a7
    bra.w   .l24ffa
.l251ac:
    clr.w   d2
    bra.w   .l24ffa
.l251b2:
    move.w  d6, d0
    andi.w  #$2, d0
    beq.w   .l24ffa
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d5
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bgt.b   .l251e2
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l25240
.l251e2:
    cmpi.w  #$5, d4
    ble.b   .l25214
    clr.w   d2
    addq.w  #$5, d3
    cmp.w   d4, d3
    ble.b   .l251f4
    clr.w   d3
    clr.w   d2
.l251f4:
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000C).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l2518c
.l25214:
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.w  d4, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   .l25234
    move.w  d3, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    bra.b   .l2523a
.l25234:
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
.l2523a:
    move.w  d0, d2
    bra.w   .l24ffa
.l25240:
    cmpi.w  #$5, d4
    bge.w   .l24ffa
    bra.b   .l25214
.l2524a:
    movem.l -$54(a6), d2-d7/a2-a5
    unlk    a6
    rts
