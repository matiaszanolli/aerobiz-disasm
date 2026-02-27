; ============================================================================
; UpdateEventState -- Decrements the slot countdown; when it reaches zero computes a bonus delta, adds to the accumulator, advances the slot type, and shows a notification box with button wait
; 210 bytes | $017D70-$017E41
; ============================================================================
UpdateEventState:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    subq.b  #$1, $1(a2)
    tst.b   $1(a2)
    bne.w   l_17e38
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$8,d4
    sub.w   d0, d4
    add.w   d4, d4
    addi.w  #$a, d4
    moveq   #$0,d3
    move.b  (a3), d3
    add.w   d4, d3
    cmpi.w  #$ff, d3
    bcc.b   l_17dc4
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   l_17dca
l_17dc4:
    move.l  #$ff, d0
l_17dca:
    move.b  d0, (a3)
    addq.b  #$1, (a2)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0011).w
    pea     ($0001).w
    jsr DrawBox
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041038).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0011).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
l_17e38:
    movem.l -$14(a6), d2-d4/a2-a3
    unlk    a6
    rts
