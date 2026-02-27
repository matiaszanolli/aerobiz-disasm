; ============================================================================
; SearchCharInSlots -- Counts active relation slots for a given player that contain a specific character ID (as city_a or city_b), returning the total count.
; 134 bytes | $0136F8-$01377D
; ============================================================================
SearchCharInSlots:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d4
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
    tst.b   $5(a3)
    beq.b   l_13776
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_13768
l_13756:
    cmp.b   (a2), d4
    beq.b   l_13760
    cmp.b   $1(a2), d4
    bne.b   l_13762
l_13760:
    addq.w  #$1, d3
l_13762:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_13768:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    cmp.l   d1, d0
    blt.b   l_13756
l_13776:
    move.w  d3, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts
