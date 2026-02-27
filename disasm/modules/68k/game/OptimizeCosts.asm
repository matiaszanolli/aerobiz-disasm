; ============================================================================
; OptimizeCosts -- Scans all player route slots for pending cost-optimisation events (type 6, stage 4); for each generates a random outcome and either offers the human player an upgrade dialog or silently accepts/rejects for AI players, clearing the slot on rejection.
; 516 bytes | $0298B8-$029ABB
; ============================================================================
OptimizeCosts:
    link    a6,#-$80
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00005FF6,a4
    lea     -$80(a6), a5
    movea.l  #$00FF0018,a3
    movea.l  #$00FF0338,a2
    clr.w   d3
l_298d8:
    clr.w   d4
l_298da:
    cmpi.b  #$6, $1(a2)
    bne.w   l_29a98
    cmpi.b  #$4, $3(a2)
    bne.w   l_29a98
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000420E6).l
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0064).w
    pea     ($0001).w
    jsr RandRange
    lea     $1c(a7), a7
    move.w  d4, d1
    mulu.w  #$7, d1
    moveq   #$0,d5
    move.b  $2(a2), d5
    add.w   d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.w   l_299ec
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    beq.b   l_299a0
    jsr ResourceLoad
    jsr PreLoopInit
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $18(a7), a7
    jsr ResourceUnload
    bra.b   l_299b2
l_299a0:
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $c(a7), a7
l_299b2:
    pea     ($0008).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    jsr DrawBox
    move.l  a5, -(a7)
    pea     ($000420D2).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
    bra.w   l_29a98
l_299ec:
    cmpi.b  #$1, (a3)
    bne.w   l_29a86
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    beq.b   l_29a3e
    jsr ResourceLoad
    jsr ClearBothPlanes
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0012).w
    jsr     (a4)
    lea     $18(a7), a7
    jsr ResourceUnload
    bra.b   l_29a50
l_29a3e:
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a4)
    lea     $c(a7), a7
l_29a50:
    pea     ($0008).w
    pea     ($001E).w
    pea     ($0013).w
    pea     ($0001).w
    jsr DrawBox
    move.l  a5, -(a7)
    pea     ($000420C6).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $20(a7), a7
l_29a86:
    clr.b   (a2)
    clr.b   $1(a2)
    clr.b   $2(a2)
    clr.b   $3(a2)
    clr.w   $4(a2)
l_29a98:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_298da
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_298d8
    movem.l -$a0(a6), d2-d5/a2-a5
    unlk    a6
    rts
