; ============================================================================
; RenderPlayerListUI -- Renders the 13-row player rankings/list screen: loads panel graphics, decompresses LZ background, builds each row via PrintfWide from the player name table at $0658D2
; 396 bytes | $03DECE-$03E059
; ============================================================================
RenderPlayerListUI:
    link    a6,#-$4
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    movea.l  #$00064DEE,a4
    movea.l  #$0003D0C0,a5
    clr.w   -$2(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr     (a5)
    jsr PreLoopInit
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$2(a6)
    jsr DisplaySetup
    pea     ($0012).w
    pea     ($0020).w
    bsr.w FillRectColor
    move.l  a4, d0
    addi.l  #$1a0, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($00FF1804).l
    pea     ($0860).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    lea     $24(a7), a7
    move.l  a4, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($000C).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    clr.l   -(a7)
    pea     (-$AF).w
    jsr     (a5)
    jsr ResourceUnload
    pea     ($0028).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.w  #$ff51, d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d4
    moveq   #$2,d5
    bra.b   l_3e038
l_3dfd8:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000658D2,a0
    movea.l (a0,d0.w), a2
    move.l  a2, -(a7)
    pea     ($00046848).l
    jsr PrintfWide
    pea     ($0050).w
    pea     ($000E).w
    jsr     (a3)
    lea     $18(a7), a7
    clr.w   d2
l_3e014:
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr     (a5)
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a3)
    lea     $10(a7), a7
    addq.w  #$1, d2
    addq.w  #$1, d3
    cmpi.w  #$10, d2
    blt.b   l_3e014
    addq.w  #$1, d4
    addq.w  #$2, d5
l_3e038:
    cmpi.w  #$d, d4
    blt.b   l_3dfd8
    pea     ($00C8).w
    pea     ($000E).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    movem.l -$24(a6), d2-d5/a2-a5
    unlk    a6
    rts
