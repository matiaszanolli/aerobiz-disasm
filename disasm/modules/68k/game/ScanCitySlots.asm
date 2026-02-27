; ============================================================================
; ScanCitySlots -- Renders a tile panel for a city slot row and runs a navigation input loop; handles up/down/confirm/cancel and returns the chosen slot index in D0
; 316 bytes | $017366-$0174A1
; ============================================================================
ScanCitySlots:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d2
    move.l  $20(a7), d5
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_173a4
    moveq   #$1,d3
    bra.b   l_173a6
l_173a4:
    moveq   #$0,d3
l_173a6:
    clr.w   d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_173b0:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d3
    beq.b   l_17404
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_17404
    pea     ($0003).w
l_173fa:
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_173b0
l_17404:
    clr.w   d3
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d4
    andi.w  #$30, d0
    beq.b   l_17442
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_17488
    move.w  d2, d0
    ext.l   d0
    subq.l  #$4, d0
    bge.b   l_1743c
    addq.l  #$1, d0
l_1743c:
    asr.l   #$1, d0
    move.w  d0, d2
    bra.b   l_1748a
l_17442:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_1745e
    move.w  #$1, (a3)
    cmpi.w  #$4, d2
    bne.b   l_1745a
    move.w  d5, d2
    add.w   d2, d2
    bra.b   l_1747e
l_1745a:
    subq.w  #$2, d2
    bra.b   l_17480
l_1745e:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.b   l_17480
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    addq.l  #$2, d1
    cmp.l   d1, d0
    bne.b   l_1747e
    moveq   #$4,d2
    bra.b   l_17480
l_1747e:
    addq.w  #$2, d2
l_17480:
    pea     ($0005).w
    bra.w   l_173fa
l_17488:
    moveq   #-$1,d2
l_1748a:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $c(a7), a7
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts
