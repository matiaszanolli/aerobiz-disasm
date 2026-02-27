; ============================================================================
; RenderDetailedStats -- Renders the full detailed player-stats screen: calls RenderPlayerStatusUI, then draws per-stat bar rows with VRAM read addresses, aircraft icons, and city performance data; ends with ShowPlayerDetailScreen
; 1216 bytes | $03D454-$03D913
; ============================================================================
RenderDetailedStats:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00000D64,a4
    movea.l  #$00005092,a5
    bsr.w RenderPlayerStatusUI
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00056A94).l
    jsr     (a5)
    jsr ResourceUnload
    pea     ($0200).w
    pea     ($00FF1074).l
    clr.l   -(a7)
    pea     ($0005FE24).l
    clr.l   -(a7)
    jsr MemCopy
    lea     $20(a7), a7
    moveq   #-$3C,d6
    move.w  #$ffd8, -$2(a6)
    clr.w   d3
    clr.w   d4
    bra.b   l_3d4f2
l_3d4ae:
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1234).l
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $28(a7), a7
    addq.w  #$1, d3
    addq.w  #$2, d4
    addq.w  #$1, d6
    addq.w  #$1, -$2(a6)
l_3d4f2:
    cmpi.w  #$4c, d6
    blt.b   l_3d4ae
    moveq   #$12,d5
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDFC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_3d51a:
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD6,a0
    move.w  (a0,d0.w), d2
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    addq.l  #$8, a7
    move.w  d5, d0
    andi.l  #$1, d0
    bne.b   l_3d596
    pea     ($0010).w
    pea     ($0030).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    pea     ($000A).w
    bra.b   l_3d5ea
l_3d596:
    pea     ($0010).w
    pea     ($0020).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)
l_3d5ea:
    pea     ($0010).w
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $14(a7), a7
    subq.l  #$2, a2
    subq.l  #$2, a3
    addq.w  #$1, d3
    addq.w  #$3, d4
    subq.w  #$1, d5
    cmpi.w  #$b, d5
    bge.w   l_3d51a
    clr.w   d2
l_3d612:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    addq.w  #$3, d4
    cmpi.w  #$30, d2
    blt.b   l_3d612
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0005CB74).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0005CB34).l
    jsr     (a5)
    lea     $18(a7), a7
    moveq   #-$50,d2
    moveq   #-$78,d7
    bra.b   l_3d6cc
l_3d660:
    pea     ($0020).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000600B4).l
    pea     ($0003).w
    pea     ($0012).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
    cmpi.w  #$160, d7
    bge.b   l_3d6aa
    pea     ($00A0).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00060024).l
    pea     ($000C).w
    pea     ($0015).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
l_3d6aa:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$2, d7
    addq.w  #$1, d3
    addq.w  #$3, d4
l_3d6cc:
    cmpi.w  #$114, d2
    blt.b   l_3d660
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0005CB94).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($0005CB54).l
    jsr     (a5)
    lea     $24(a7), a7
    move.w  #$ff4c, d2
    moveq   #-$3C,d7
    bra.b   l_3d776
l_3d70a:
    pea     ($0020).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00060084).l
    pea     ($0006).w
    pea     ($0015).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
    cmpi.w  #$160, d7
    bge.b   l_3d754
    pea     ($00A0).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000600CC).l
    pea     ($0003).w
    pea     ($0012).w
    pea     ($000F).w
    jsr     (a4)
    lea     $18(a7), a7
l_3d754:
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$2, d7
    addq.w  #$1, d3
    addq.w  #$3, d4
l_3d776:
    cmpi.w  #$15e, d2
    blt.b   l_3d70a
    pea     ($0009).w
    pea     ($0012).w
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00056A54).l
    jsr     (a5)
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00056A54).l
    jsr     (a5)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($1360).w
    pea     ($00056AB4).l
    pea     ($1970).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a4)
    lea     $18(a7), a7
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDFC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    bra.w   l_3d8de
l_3d7f0:
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$0005FDD6,a0
    move.w  (a0,d0.w), d2
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w QueueVRAMReadAddr
    addq.l  #$8, a7
    move.w  d5, d0
    andi.l  #$1, d0
    bne.b   l_3d86c
    pea     ($0010).w
    pea     ($0030).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    pea     ($000A).w
    bra.b   l_3d8c0
l_3d86c:
    pea     ($0010).w
    pea     ($0020).w
    move.w  (a2), d0
    add.w   d0, d0
    movea.l  #$000569D4,a0
    pea     (a0, d0.w)
    jsr     (a5)
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF1074,a0
    pea     (a0, d0.w)
    moveq   #$0,d0
    move.w  (a3), d0
    move.w  d2, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    pea     ($000F).w
    jsr     (a4)
    lea     $24(a7), a7
    pea     ($0008).w
    clr.l   -(a7)
l_3d8c0:
    pea     ($0010).w
    jsr     (a4)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    lea     $14(a7), a7
    subq.l  #$2, a2
    subq.l  #$2, a3
    addq.w  #$1, d3
    addq.w  #$3, d4
    subq.w  #$1, d5
l_3d8de:
    tst.w   d5
    bge.w   l_3d7f0
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a4)
    jsr ResourceLoad
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr (ShowPlayerDetailScreen,PC)
    nop
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a4)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
