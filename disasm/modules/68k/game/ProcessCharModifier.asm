; ============================================================================
; ProcessCharModifier -- Iterates pending modifier events (state=1) per player; computes stat advantage gained this turn and either plays a relationship panel animation or displays a stat-increase dialog with tile-formatted numbers
; 974 bytes | $02B06C-$02B439
; ============================================================================
ProcessCharModifier:
    link    a6,#-$80
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$ff, d7
    clr.w   d6
.l2b0a0:
    cmpi.b  #$1, $1(a2)
    bne.w   .l2b424
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr GetModeRowOffset
    add.b   d0, $3(a2)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharRating
    lea     $10(a7), a7
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $3(a2), d0
    cmp.w   d3, d0
    bcs.w   .l2b424
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.l  d0, d4
    moveq   #$0,d0
    move.b  $2(a2), d0
    cmp.w   d0, d4
    ble.b   .l2b136
    moveq   #$0,d4
    move.b  $2(a2), d4
    bra.b   .l2b14c
.l2b136:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcCharAdvantage
    addq.l  #$8, a7
    move.l  d0, d4
.l2b14c:
    ext.l   d4
    add.b   d4, $1(a3)
    cmpi.b  #$1, (a5)
    bne.w   .l2b410
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    cmp.w   d3, d7
    beq.b   .l2b1ac
    jsr ResourceLoad
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0003).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
    move.w  d3, d7
.l2b1ac:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d4
    bne.b   .l2b1ea
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($00042530).l
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    bra.w   .l2b412
.l2b1ea:
    moveq   #$0,d0
    move.b  $2(a2), d0
    move.w  d4, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l2b23e
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d4
    bne.b   .l2b214
    pea     ($00042506).l
    bra.b   .l2b21a
.l2b214:
    pea     ($00042500).l
.l2b21a:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004250C).l
    pea     -$80(a6)
    jsr sprintf
    lea     $14(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    bra.b   .l2b282
.l2b23e:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d4
    bne.b   .l2b25a
    pea     ($000424D0).l
    bra.b   .l2b260
.l2b25a:
    pea     ($000424CA).l
.l2b260:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000424D6).l
    pea     -$80(a6)
    jsr sprintf
    lea     $14(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
.l2b282:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     -$80(a6)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($001E).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0546).w
    jsr TilePlacement
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0548).w
    jsr TilePlacement
    pea     ($000A).w
    jsr PollInputChange
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    cmpi.w  #$20, d2
    bcc.b   .l2b388
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d2, d1
    sub.w   d0, d1
    bra.b   .l2b3b6
.l2b388:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBE,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d2, d1
    sub.w   d0, d1
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBD,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    add.w   d0, d1
.l2b3b6:
    addi.w  #$1f, d1
    move.w  d1, d3
    moveq   #$0,d2
    move.b  (a4), d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    sub.w   d0, d2
    bra.b   .l2b40a
.l2b3ca:
    addq.b  #$1, (a4)
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$660, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    jsr PlaceFormattedTiles
    pea     ($0001).w
    jsr PollInputChange
    lea     $18(a7), a7
.l2b40a:
    subq.w  #$1, d4
    bge.b   .l2b3ca
    bra.b   .l2b412
.l2b410:
    add.b   d4, (a4)
.l2b412:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
.l2b424:
    addq.l  #$8, a2
    addq.w  #$1, d6
    cmpi.w  #$4, d6
    bcs.w   .l2b0a0
    movem.l -$a8(a6), d2-d7/a2-a5
    unlk    a6
    rts
