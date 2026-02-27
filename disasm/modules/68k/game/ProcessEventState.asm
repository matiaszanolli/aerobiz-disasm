; ============================================================================
; ProcessEventState -- Process an active event record: display route city info or char name in a dialog box, poll input, and update character availability flags.
; 576 bytes | $02211A-$022359
; ============================================================================
ProcessEventState:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$000181C6,a4
    lea     -$80(a6), a5
    movea.l  #$00FF09C2,a3
    clr.w   d2
l_22138:
    cmp.b   (a3), d5
    beq.b   l_22146
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$2, d2
    blt.b   l_22138
l_22146:
    cmpi.w  #$2, d2
    bge.w   l_22350
    tst.b   (a3)
    bne.w   l_2220e
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$3, d0
    movea.l  #$0005F9DE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    addq.l  #$3, a2
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$00047D7C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047DC0).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr ClearListArea
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $28(a7), a7
    move.b  #$ff, (a3)
    clr.w   d2
    bra.b   l_221fc
l_221da:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    moveq   #$0,d0
    move.b  (a2), d0
    movea.l  #$00FF09D8,a0
    andi.b  #$fe, (a0,d0.w)
    addq.l  #$1, a2
    addq.w  #$1, d2
l_221fc:
    cmpi.b  #$ff, (a2)
    beq.w   l_22350
    cmpi.w  #$5, d2
    blt.b   l_221da
    bra.w   l_22350
l_2220e:
    cmpi.b  #$2, (a3)
    bne.w   l_2229e
    move.b  $1(a3), d5
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    move.b  #$ff, (a3)
    moveq   #$0,d0
    move.b  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  (a2), d3
    moveq   #$0,d4
    move.b  $1(a2), d4
    clr.w   d2
    bra.b   l_22260
l_2224e:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    addq.b  #$1, d3
    addq.w  #$1, d2
l_22260:
    cmp.w   d4, d2
    blt.b   l_2224e
    moveq   #$0,d0
    move.b  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_22296
l_22284:
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$8, a7
    addq.b  #$1, d3
    addq.w  #$1, d2
l_22296:
    cmp.w   d4, d2
    blt.b   l_22284
    bra.w   l_22350
l_2229e:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$1,d1
    cmp.b   d1, d0
    beq.b   l_222b8
    moveq   #$3,d1
    cmp.b   d1, d0
    beq.b   l_2231a
    moveq   #$4,d1
    cmp.b   d1, d0
    beq.b   l_22320
    bra.w   l_22350
l_222b8:
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005FA11,a0
    move.b  (a0,d0.w), d3
    moveq   #$0,d0
    move.b  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00047DF0).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr DrawLabeledBox
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $18(a7), a7
    jsr ClearListArea
    moveq   #$0,d0
    move.b  d3, d0
    movea.l  #$00FF09D8,a0
    andi.b  #$fd, (a0,d0.w)
    bra.b   l_22332
l_2231a:
    move.b  $1(a3), d3
    bra.b   l_22332
l_22320:
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr (CalcEventValue,PC)
    nop
    addq.l  #$4, a7
    move.b  d0, d3
l_22332:
    pea     ($0004).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    move.b  #$ff, (a3)
    pea     ($0001).w
    moveq   #$0,d0
    move.b  d3, d0
    move.l  d0, -(a7)
    jsr     (a4)
l_22350:
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
