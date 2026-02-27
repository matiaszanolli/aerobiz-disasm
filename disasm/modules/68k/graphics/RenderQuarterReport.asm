; ============================================================================
; RenderQuarterReport -- Draws one page of the quarterly report: on first call loads and sets up the full background; dispatches to DisplayRouteCargoInfo, ShowRoutePassengers, DisplayRouteFunds, or DrawQuarterResultsScreen depending on the page selector argument.
; 1176 bytes | $026598-$026A2F
; ============================================================================
RenderQuarterReport:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d5
    move.l  $14(a6), d6
    move.l  $8(a6), d7
    movea.l  #$0003B270,a4
    movea.l  #$00000D64,a5
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_265c4
    addq.l  #$3, d0
l_265c4:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d2
    cmpi.w  #$1, d7
    bne.w   l_26850
    jsr ResourceLoad
    jsr ClearTileArea
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    pea     ($00041560).l
    jsr     (a4)
    lea     $28(a7), a7
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A9E).l
    jsr DisplaySetup
    move.l  ($000A1B68).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0015).w
    pea     ($030F).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00073378).l
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    move.l  ($000A1B24).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001A).w
    pea     ($0324).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($0004).w
    pea     ($0021).w
    pea     ($00FF0118).l
    jsr DisplaySetup
    pea     ($0001).w
    pea     ($0016).w
    jsr SetTextCursor
    lea     $14(a7), a7
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    moveq   #$3,d1
    cmp.l   d1, d0
    bhi.b   l_26726
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0008
    dc.w    $0010
    dc.w    $0018
    dc.w    $0020
    pea     ($0004155C).l
    bra.b   l_26722
    pea     ($00041558).l
    bra.b   l_26722
    pea     ($00041554).l
    bra.b   l_26722
    pea     ($00041550).l
l_26722:
    jsr     (a4)
    addq.l  #$4, a7
l_26726:
    pea     ($0001).w
    pea     ($001A).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     ($0004154C).l
    jsr     (a4)
    lea     $10(a7), a7
    movea.l  #$00FF0018,a2
    movea.l  #$00FF14B0,a3
    clr.w   d2
    moveq   #$0,d3
    move.w  d2, d3
    move.l  d3, d0
    add.l   d3, d3
    add.l   d0, d3
    add.l   d3, d3
l_26760:
    moveq   #$0,d4
    move.b  $2(a2), d4
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    cmpi.w  #$1, d4
    ble.b   l_2677c
    pea     ($0007257E).l
    bra.b   l_26782
l_2677c:
    pea     ($00072524).l
l_26782:
    pea     ($0005).w
    pea     ($0009).w
    move.l  d3, d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$754, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0007).w
    move.l  d3, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    jsr FillTileRect
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  (a3), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0005).w
    jsr SetTextCursor
    moveq   #$0,d4
    move.b  $2(a2), d4
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041548).l
    jsr     (a4)
    lea     $10(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.l  #$2, a3
    addq.l  #$6, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_26760
    bra.b   l_2687e
l_26850:
    move.l  #$8000, -(a7)
    pea     ($0018).w
    pea     ($0014).w
    pea     ($0004).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    lea     $28(a7), a7
l_2687e:
    moveq   #$0,d0
    move.w  $e(a6), d0
    moveq   #$4,d1
    cmp.l   d1, d0
    bhi.w   l_26a1a
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $000A
    dc.w    $0050
    dc.w    $0096
    dc.w    $00DC
    dc.w    $011E
    pea     ($0001).w
    move.l  d5, -(a7)
    jsr (DisplayRouteCargoInfo,PC)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041536).l
    bra.w   l_26a16
    pea     ($0001).w
    move.l  d5, -(a7)
    jsr (ShowRoutePassengers,PC)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041524).l
    bra.w   l_26a16
    pea     ($0001).w
    move.l  d6, -(a7)
    jsr (DisplayRouteFunds,PC)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    pea     ($00041512).l
    bra.w   l_26a16
    pea     ($0001).w
    jsr (DrawQuarterResultsScreen,PC)
    nop
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $28(a7), a7
    pea     ($00041500).l
    bra.b   l_26a16
    clr.l   -(a7)
    move.l  d5, -(a7)
    jsr (DisplayRouteCargoInfo,PC)
    nop
    pea     ($0001).w
    move.l  d5, -(a7)
    jsr (ShowRoutePassengers,PC)
    nop
    clr.l   -(a7)
    move.l  d6, -(a7)
    jsr (DisplayRouteFunds,PC)
    nop
    clr.l   -(a7)
    jsr (DrawQuarterResultsScreen,PC)
    nop
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0011).w
    pea     ($0001).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($0004).w
    jsr SetTextCursor
    lea     $24(a7), a7
    pea     ($000414EE).l
l_26a16:
    jsr     (a4)
    addq.l  #$4, a7
l_26a1a:
    cmpi.w  #$1, d7
    bne.b   l_26a26
    jsr ResourceUnload
l_26a26:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts
