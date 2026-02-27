; ============================================================================
; RunSlotCountPicker -- Presents a numbered selector widget for choosing how many char slots to commit (1 through N), using left/right input to navigate and A/B to confirm or cancel, returning the selected count.
; 674 bytes | $0288A4-$028B45
; ============================================================================
RunSlotCountPicker:
    link    a6,#-$54
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    lea     -$52(a6), a4
    lea     -$2a(a6), a5
    clr.w   d2
    bra.b   l_288e6
l_288c8:
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)
    addq.w  #$1, d2
l_288e6:
    cmp.w   d5, d2
    blt.b   l_288c8
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    clr.w   (a4,a0.l)
    move.w  #$8541, -$2a(a6)
    move.w  #$8542, -$52(a6)
    moveq   #$2,d7
    moveq   #$15,d6
    pea     ($0004).w
    pea     ($0017).w
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr DrawBox
    pea     ($0004).w
    pea     ($0017).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetTextWindow
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    pea     ($00041AE4).l
    jsr PrintfNarrow
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_28970
    moveq   #$1,d0
    bra.b   l_28972
l_28970:
    moveq   #$0,d0
l_28972:
    move.w  d0, -$2(a6)
    clr.w   d3
    moveq   #$1,d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d2
l_28984:
    tst.w   d4
    beq.w   l_28a6c
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AE0).l
    jsr PrintfWide
    lea     $10(a7), a7
    cmpi.w  #$1, d2
    bne.b   l_289f4
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0005).w
    pea     ($0017).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($00041ADA).l
    bra.b   l_28a0a
l_289f4:
    pea     ($0017).w
    pea     ($0013).w
    jsr SetTextCursor
    addq.l  #$8, a7
    pea     ($00041AD4).l
l_28a0a:
    jsr PrintfNarrow
    move.l  a5, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $20(a7), a7
    move.l  a4, -(a7)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    clr.w   d4
l_28a6c:
    tst.w   -$2(a6)
    beq.b   l_28a82
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_28984
l_28a82:
    clr.w   -$2(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d3
    andi.w  #$8, d0
    beq.b   l_28acc
    move.w  #$1, (a3)
    cmp.w   d5, d2
    bge.b   l_28ac8
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8541, -$2(a5, a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8542, -$2(a4, a0.l)
l_28ac8:
    moveq   #$1,d4
    bra.b   l_28b2a
l_28acc:
    move.w  d3, d0
    andi.w  #$4, d0
    beq.b   l_28b04
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
    moveq   #$1,d1
    cmp.l   d0, d1
    bgt.b   l_28ac8
    subq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8000, (a5,a0.l)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$8543, (a4,a0.l)
    bra.b   l_28ac8
l_28b04:
    move.w  d3, d0
    andi.w  #$10, d0
    beq.b   l_28b18
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d2
    bra.b   l_28b3a
l_28b18:
    move.w  d3, d0
    andi.w  #$20, d0
    beq.b   l_28b2a
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    bra.b   l_28b3a
l_28b2a:
    pea     ($0006).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.w   l_28984
l_28b3a:
    move.w  d2, d0
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts
