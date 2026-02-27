; ============================================================================
; HandleScenarioTurns -- Display scenario selection menu for all 4 players with navigation and confirmation, return chosen scenario index
; 1080 bytes | $00A5E4-$00AA1B
; ============================================================================
HandleScenarioTurns:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0002,a2
    movea.l  #$0003B246,a3
    movea.l  #$00000D64,a4
    movea.l  #$00047630,a5
    clr.l   -(a7)
    jsr CmdSetBackground
    moveq   #$5,d3
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
    clr.w   d2
.l0a63a:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E570).l
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    addq.w  #$3, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a63a
    jsr ResourceUnload
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475DC).l, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0a6c2
    moveq   #$1,d4
    bra.b   .l0a6c4
.l0a6c2:
    moveq   #$0,d4
.l0a6c4:
    clr.w   d5
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   (a2)
.l0a6d4:
    move.w  (a2), d3
    add.w   d3, d3
    add.w   (a2), d3
    addq.w  #$4, d3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$9, d0
    move.l  d0, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    tst.w   d4
    beq.b   .l0a734
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0a734
    pea     ($0002).w
.l0a72a:
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l0a6d4
.l0a734:
    clr.w   d4
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$20, d0
    beq.w   .l0a99c
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2
    ext.l   d2
    lsl.l   #$3, d2
    addi.l  #$9, d2
    move.l  d2, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0546).w
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)
    pea     ($0011).w
    pea     ($0002).w
    pea     ($0548).w
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    lea     $2c(a7), a7
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E562).l
    jsr     (a3)
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    pea     ($0003E55E).l
    jsr     (a3)
    move.w  (a2), d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    pea     ($0003E55A).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($001B).w
    pea     ($0002).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($0007).w
    pea     ($0002).w
    jsr SetTextCursor
    lea     $30(a7), a7
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047650,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E556).l
    jsr     (a3)
    pea     ($000D).w
    pea     ($0002).w
    jsr SetTextCursor
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047660,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E538).l
    jsr     (a3)
    pea     ($0003E52A).l
    move.l  ($000475F0).l, -(a7)
    pea     -$80(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$80(a6)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $14(a7), a7
    tst.w   d0
    bne.w   .l0aa0e
    clr.l   -(a7)
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    moveq   #$5,d3
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0004).w
    clr.l   -(a7)
    jsr DrawBox
    lea     $2c(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d2
.l0a926:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E522).l
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $10(a5, a0.l), -(a7)
    jsr     (a3)
    lea     $20(a7), a7
    addq.w  #$3, d3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0a926
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($000475DC).l, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $14(a7), a7
    bra.w   .l0a6d4
.l0a99c:
    move.w  d5, d0
    andi.w  #$10, d0
    beq.b   .l0a9ba
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    jsr ResourceLoad
    bra.b   .l0aa10
.l0a9ba:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0a9e2
    move.w  #$1, ($00FF13FC).l
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$3,d1
    cmp.l   d0, d1
    ble.b   .l0a9de
    move.w  (a2), d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0a9e0
.l0a9de:
    moveq   #$3,d0
.l0a9e0:
    move.w  d0, (a2)
.l0a9e2:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0aa06
    move.w  #$1, ($00FF13FC).l
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0aa02
    move.w  (a2), d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0aa04
.l0aa02:
    moveq   #$0,d0
.l0aa04:
    move.w  d0, (a2)
.l0aa06:
    pea     ($0005).w
    bra.w   .l0a72a
.l0aa0e:
    moveq   #$1,d2
.l0aa10:
    move.w  d2, d0
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
