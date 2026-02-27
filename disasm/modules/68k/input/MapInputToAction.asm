; ============================================================================
; MapInputToAction -- Maps a city/player index to a display action: if the system is active and the index is < 7, loads the city screen and optionally calls UpdateAnimation to show the city's roster; for index >= 7 loads a full-screen background; then draws the route-slot selection box with city and player name tiles and calls UpdateAnimation for the current slot.
; 416 bytes | $01EF5A-$01F0F9
; ============================================================================
MapInputToAction:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $14(a7), d3
    movea.l  #$0003B270,a2
    movea.l  #$00000D64,a3
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_1f0f4
    cmpi.w  #$7, d3
    bcc.b   l_1efc6
    jsr ResourceLoad
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr LoadScreen
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $18(a7), a7
    tst.w   d2
    bne.b   l_1efbe
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$4, a7
l_1efbe:
    jsr ResourceUnload
    bra.b   l_1eff8
l_1efc6:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
l_1eff8:
    cmpi.w  #$1, d2
    bne.w   l_1f0a2
    pea     ($0004).w
    pea     ($0031).w
    pea     ($00FF0118).l
    jsr DisplaySetup
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $1c(a7), a7
    clr.w   d2
l_1f02c:
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$774, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000411EE).l
    jsr     (a2)
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f02c
l_1f0a2:
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0015).w
    pea     ($0002).w
    jsr DrawBox
    lea     $10(a7), a7
    cmpi.w  #$7, d3
    bcc.b   l_1f0dc
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000411D6).l
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_1f0e6
l_1f0dc:
    pea     ($000411AA).l
    jsr     (a2)
    addq.l  #$4, a7
l_1f0e6:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$4, a7
l_1f0f4:
    movem.l (a7)+, d2-d3/a2-a3
    rts
