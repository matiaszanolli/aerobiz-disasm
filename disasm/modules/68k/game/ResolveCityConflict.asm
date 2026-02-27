; ============================================================================
; ResolveCityConflict -- Draws a text box, calls GenerateEventResult for the box outline, prints city and player name strings, then shows confirmation text based on conflict-type flag
; 268 bytes | $01725A-$017365
; ============================================================================
ResolveCityConflict:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0003B270,a2
    movea.l  #$0003AB2C,a3
    movea.l  #$00047A78,a4
    pea     ($008F).w
    tst.w   d3
    bne.b   l_17280
    moveq   #$C,d0
    bra.b   l_17282
l_17280:
    moveq   #$8,d0
l_17282:
    move.l  d0, -(a7)
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0005).w
    jsr (GenerateEventResult,PC)
    nop
    pea     ($0004).w
    pea     ($0008).w
    jsr     (a3)
    lea     $1c(a7), a7
    tst.w   d3
    bne.b   l_172ac
    moveq   #$5,d4
    bra.b   l_172ae
l_172ac:
    moveq   #$2,d4
l_172ae:
    clr.w   d2
    bra.b   l_172dc
l_172b2:
    move.w  #$8, ($00FF128A).l
    move.w  d3, d0
    mulu.w  #$14, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00047A36,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F94C).l
    jsr     (a2)
    addq.l  #$8, a7
    addq.w  #$1, d2
l_172dc:
    cmp.w   d4, d2
    blt.b   l_172b2
    tst.w   d3
    bne.b   l_17322
    pea     ($0006).w
    pea     ($0014).w
    jsr     (a3)
    move.w  ($00FF000A).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    jsr     (a2)
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a3)
    lea     $14(a7), a7
    move.w  ($00FF0008).l, d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   l_1735c
l_17322:
    pea     ($0004).w
    pea     ($0014).w
    jsr     (a3)
    move.w  ($00FF000C).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    jsr     (a2)
    pea     ($0006).w
    pea     ($0014).w
    jsr     (a3)
    lea     $14(a7), a7
    move.w  ($00FF000E).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
l_1735c:
    jsr     (a2)
    addq.l  #$4, a7
    movem.l (a7)+, d2-d4/a2-a4
    rts
