; ============================================================================
; RenderEndingCredits -- Renders the game ending/credits screen: decompresses staff-roll graphics, animates horizontal scroll oscillation, and displays multiple credit text blocks before returning
; 678 bytes | $03C69C-$03C941
; ============================================================================
RenderEndingCredits:
    link    a6,#-$C0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$c0(a6), a2
    movea.l  #$000045B2,a3
    movea.l  #$00000D64,a4
    movea.l  #$0003B994,a5
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076FB6).l
    jsr DisplaySetup
    move.l  ($000B754C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($01A0).w
    pea     ($0400).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0023).w
    jsr     (a4)
    pea     ($0020).w
    move.l  a2, -(a7)
    pea     ($00076F16).l
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076F36).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076FB6).l
    jsr     (a3)
    pea     ($0040).w
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00048D30).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    addi.l  #$a0, d0
    move.l  d0, -(a7)
    pea     ($00076FD6).l
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0003).w
    pea     ($0030).w
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    bsr.w RenderColorTileset
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0040).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($0001).w
    jsr SetScrollQuadrant
    clr.l   -(a7)
    pea     ($0100).w
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    lea     $30(a7), a7
    pea     ($000760A6).l
    pea     ($0008).w
    pea     ($001A).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    jsr     (a5)
    lea     $20(a7), a7
    pea     ($00076246).l
    pea     ($0006).w
    pea     ($001A).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    jsr     (a5)
    lea     $20(a7), a7
    pea     ($00075F8E).l
    pea     ($0004).w
    pea     ($001B).w
    pea     ($000F).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    pea     ($0020).w
    move.l  a2, -(a7)
    pea     ($0007651E).l
    jsr     (a3)
    lea     $28(a7), a7
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$20,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0007651E).l
    jsr     (a3)
    pea     ($0020).w
    move.l  a2, d0
    moveq   #$40,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00076FF6).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0030).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.l  a2, d0
    moveq   #$60,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    bsr.w RenderColorTileset
    pea     ($0020).w
    jsr     (a5)
    lea     $30(a7), a7
    moveq   #$10,d2
l_3c8ba:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$2,d1
    jsr SignedMod
    tst.l   d0
    beq.b   l_3c8d6
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8d2
    addq.l  #$1, d0
l_3c8d2:
    asr.l   #$1, d0
    bra.b   l_3c8ea
l_3c8d6:
    moveq   #$0,d0
    move.w  d2, d0
    bge.b   l_3c8de
    addq.l  #$1, d0
l_3c8de:
    asr.l   #$1, d0
    move.l  #$200, d1
    sub.l   d0, d1
    move.l  d1, d0
l_3c8ea:
    move.w  d0, d3
    clr.l   -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    pea     ($0001).w
    jsr     (a5)
    lea     $10(a7), a7
    subq.w  #$1, d2
    tst.w   d2
    bne.b   l_3c8ba
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w UpdateScrollRegisters
    pea     ($0080).w
    jsr     (a5)
    pea     ($00076066).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    movem.l -$d8(a6), d2-d3/a2-a5
    unlk    a6
    rts
