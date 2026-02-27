; ============================================================================
; DisplayPlayerStatsScreen -- Loads resources and renders the full player stats screen showing profit/loss, rank, route type summary, and character employment for one player, then waits for a button press.
; 686 bytes | $025E44-$0260F1
; ============================================================================
DisplayPlayerStatsScreen:
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $20(a7), d2
    movea.l  #$0003B246,a4
    movea.l  #$0003AB2C,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    jsr ResourceLoad
    jsr PreLoopInit
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004A598).l
    jsr DisplaySetup
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowPlayerInfo
    lea     $24(a7), a7
    move.w  ($00FF0004).l, d4
    addq.w  #$4, d4
    pea     ($0017).w
    pea     ($0018).w
    pea     ($0001).w
    pea     ($0004).w
    jsr DrawBox
    pea     ($0002).w
    pea     ($0006).w
    jsr     (a5)
    pea     ($000414DA).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0015).w
    pea     ($0004).w
    pea     ($0006).w
    jsr SetTextWindow
    lea     $2c(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041498).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0006).w
    jsr     (a5)
    lea     $10(a7), a7
    cmpi.w  #$7, d4
    bge.b   .l25f52
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041476).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l25f5c
.l25f52:
    pea     ($00041452).l
    jsr     (a4)
    addq.l  #$4, a7
.l25f5c:
    pea     ($000B).w
    pea     ($0006).w
    jsr     (a5)
    pea     ($00041438).l
    jsr     (a4)
    pea     ($0004).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041436).l
    jsr     (a4)
    pea     ($0006).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041434).l
    jsr     (a4)
    pea     ($0009).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041432).l
    jsr     (a4)
    lea     $30(a7), a7
    pea     ($000B).w
    pea     ($0005).w
    jsr     (a5)
    pea     ($00041430).l
    jsr     (a4)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $1c(a7), a7
    move.w  d2, d0
    lsl.w   #$3, d0
    movea.l  #$00FF0270,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0130,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
.l25ff2:
    moveq   #$5,d4
    move.w  d2, d3
    addi.w  #$e, d3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    cmpi.w  #$2, d2
    bne.b   .l26016
    pea     ($0004141C).l
    bra.b   .l26024
.l26016:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
.l26024:
    pea     ($0004142C).l
    jsr     (a4)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addi.l  #$11, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $18(a7), a7
    tst.l   (a3)
    ble.b   .l2605a
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($00041418).l
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l26064
.l2605a:
    pea     ($00041414).l
    jsr     (a4)
    addq.l  #$4, a7
.l26064:
    addq.l  #$1, a2
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.w   .l25ff2
    move.w  ($00FF0002).l, d2
    mulu.w  #$f, d2
    addi.w  #$7a3, d2
    pea     ($0016).w
    pea     ($0005).w
    jsr     (a5)
    move.w  ($00FF0004).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005F6DE,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a4)
    pea     ($0016).w
    pea     ($0010).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004140E).l
    jsr     (a4)
    lea     $20(a7), a7
    jsr ResourceUnload
.l260ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l260ce
    jsr ResourceLoad
    movem.l (a7)+, d2-d4/a2-a5
    rts
