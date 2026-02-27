; ============================================================================
; FindRelationByChar -- Counts how many times a given character ID appears across all player slot char-arrays and tallies occurrence counts into a caller-supplied output array.
; 228 bytes | $013614-$0136F7
; ============================================================================
FindRelationByChar:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d7
    movea.l $30(a7), a4
    move.w  $2e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d3
    moveq   #$0,d4
    move.b  (a1), d4
    moveq   #$0,d5
    move.b  $1(a1), d5
    move.w  d4, d6
    ext.l   d6
    move.l  d6, d0
    add.l   d6, d6
    add.l   d0, d6
    add.l   d6, d6
    bra.b   l_1368e
l_1364c:
    movea.l  #$00FF1704,a0
    lea     (a0,d6.w), a3
    movea.l  #$00FF0420,a0
    lea     (a0,d6.w), a2
    clr.w   d2
l_13662:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_1367c
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
l_1367c:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_13662
    addq.l  #$6, d6
    subq.w  #$1, d5
    addq.w  #$1, d4
l_1368e:
    tst.w   d5
    bgt.b   l_1364c
    moveq   #$0,d4
    move.b  $2(a1), d4
    moveq   #$0,d5
    move.b  $3(a1), d5
    bra.b   l_136ec
l_136a0:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_136c2:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_136dc
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
l_136dc:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_136c2
    subq.w  #$1, d5
    addq.w  #$1, d4
l_136ec:
    tst.w   d5
    bgt.b   l_136a0
    move.w  d3, d0
    movem.l (a7)+, d2-d7/a2-a4
    rts
