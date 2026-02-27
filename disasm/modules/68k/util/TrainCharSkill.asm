; ============================================================================
; TrainCharSkill -- Checks skill cost vs player wealth and char stat threshold; deducts cost and records new skill if passed
; 410 bytes | $0355E8-$035781
; ============================================================================
TrainCharSkill:
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    clr.w   d7
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d4, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_35626
    addq.l  #$3, d0
l_35626:
    asr.l   #$2, d0
    addi.w  #$37, d0
    move.w  d0, d2
    cmpi.l  #$bb8, $6(a2)
    ble.w   l_3577a
    moveq   #$0,d0
    move.b  $6(a3), d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.w   l_3577a
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $7(a3), d1
    ext.l   d1
    cmp.l   d1, d0
    bge.w   l_3577a
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr CalcWeightedStat
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$ffff, d0
    beq.w   l_3577a
    move.b  (a3), d0
    cmp.b   ($00FF09A0).l, d0
    bne.b   l_3568e
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_3568a
    addq.l  #$1, d0
l_3568a:
    asr.l   #$1, d0
    move.w  d0, d3
l_3568e:
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    cmp.l   $6(a2), d0
    bge.b   l_3569e
    moveq   #$3,d2
    bra.b   l_356c4
l_3569e:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    cmp.l   $6(a2), d0
    bge.b   l_356b2
    moveq   #$2,d2
    bra.b   l_356c4
l_356b2:
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    cmp.l   $6(a2), d0
    bge.b   l_356c2
    moveq   #$1,d2
    bra.b   l_356c4
l_356c2:
    clr.w   d2
l_356c4:
    tst.w   d2
    beq.w   l_3577a
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr FindCharSlotInGroup
    addq.l  #$8, a7
    move.w  d0, d6
    cmpi.w  #$5, d6
    bcc.w   l_3577a
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    sub.l   d0, $6(a2)
    move.w  d5, d0
    mulu.w  #$14, d0
    move.w  d6, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF02E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d4, (a2)
    add.b   d2, $1(a2)
    move.b  #$1, $2(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    movea.l  #$00FF1278,a0
    move.b  (a0,d4.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044938).l
    jsr PrintfWide
    pea     ($001E).w
    jsr PollInputChange
    lea     $20(a7), a7
    moveq   #$1,d7
l_3577a:
    move.w  d7, d0
    movem.l (a7)+, d2-d7/a2-a3
    rts
