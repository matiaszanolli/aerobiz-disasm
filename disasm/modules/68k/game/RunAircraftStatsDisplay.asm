; ============================================================================
; RunAircraftStatsDisplay -- Display all 4 players aircraft type and hub city in a formatted stats panel, wait for confirm or back input
; 486 bytes | $00C1AC-$00C391
; ============================================================================
RunAircraftStatsDisplay:
    link    a6,#$0
    movem.l d2/a2-a4, -(a7)
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    jsr ResourceLoad
.l0c1c6:
    pea     ($001E).w
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($000A).w
    pea     ($001F).w
    pea     ($0002).w
    pea     ($0001).w
    jsr DrawBox
    lea     $20(a7), a7
    movea.l  #$00FF0018,a2
    clr.w   d2
.l0c1fe:
    move.w  d2, d0
    ext.l   d0
    addi.l  #$774, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0007).w
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0001).w
    jsr FillTileRect
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($0003E5F2).l
    jsr     (a3)
    lea     $30(a7), a7
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000B).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005F926,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5EE).l
    jsr     (a3)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E7E4,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E5EA).l
    jsr     (a3)
    lea     $20(a7), a7
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.w   .l0c1fe
    pea     ($0003).w
    pea     ($001A).w
    jsr     (a4)
    pea     ($0003E5E4).l
    jsr     (a3)
    pea     ($0005).w
    pea     ($001C).w
    jsr     (a4)
    move.w  ($00FF0002).l, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5E0).l
    jsr     (a3)
    pea     ($0008).w
    pea     ($001A).w
    jsr     (a4)
    move.w  ($00FF0004).l, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5DA).l
    jsr     (a3)
    lea     $2c(a7), a7
    jsr ResourceUnload
    jsr (PollSingleButtonPress,PC)
    nop
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.b   .l0c33c
    pea     ($0001).w
    jsr (WaitForEventInput,PC)
    nop
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bra.b   .l0c33e
.l0c33c:
    tst.w   d2
.l0c33e:
    bne.w   .l0c1c6
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000475F8).l, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    move.w  d0, d2
    jsr ResourceLoad
    clr.l   -(a7)
    pea     ($0008).w
    pea     ($0007).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    jsr ClearTileArea
    move.w  d2, d0
    movem.l -$10(a6), d2/a2-a4
    unlk    a6
    rts
