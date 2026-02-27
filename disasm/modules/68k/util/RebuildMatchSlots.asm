; ============================================================================
; RebuildMatchSlots -- Reorders match slots for a player: saves, clears, and rebuilds slot list from saved data
; 204 bytes | $033F62-$03402D
; ============================================================================
RebuildMatchSlots:
    link    a6,#-$30
    movem.l d2-d3/a2-a5, -(a7)
    movea.l  #$00FF88DC,a4
    movea.l  #$0001D538,a5
    pea     ($0030).w
    pea     -$30(a6)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$4, d0
    move.l  d0, d2
    move.l  d0, d3
    pea     (a4, d0.l)
    clr.l   -(a7)
    jsr     (a5)
    pea     ($0030).w
    clr.l   -(a7)
    pea     (a4, d2.l)
    jsr MemFillByte
    lea     $20(a7), a7
    move.w  #$ff, (a4,d2.l)
    lea     (a4,d2.l), a0
    movea.l a0, a2
    move.w  #$ff, $2(a0)
    moveq   #$1,d2
    bra.b   l_33fe6
l_33fc4:
    pea     ($000C).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    pea     (a2, d0.l)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    addq.w  #$1, d2
l_33fe6:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_33fc4
    lea     -$30(a6), a2
    lea     (a4,d3.l), a3
    clr.w   d2
    bra.b   l_3401c
l_33ffa:
    cmpi.w  #$59, (a2)
    bcc.b   l_34016
    pea     ($000C).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    moveq   #$C,d0
    adda.l  d0, a3
l_34016:
    moveq   #$C,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_3401c:
    cmp.w   ($00FFA7DA).l, d2
    bcs.b   l_33ffa
    movem.l -$48(a6), d2-d3/a2-a5
    unlk    a6
    rts
