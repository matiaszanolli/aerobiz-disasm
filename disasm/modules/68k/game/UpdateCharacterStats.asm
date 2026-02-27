; ============================================================================
; UpdateCharacterStats -- Counts trainer entries (action-type $0E) matching a given character ID across both 6-slot and 4-slot char-groups; returns count * 30.
; 234 bytes | $014118-$014201
; ============================================================================
UpdateCharacterStats:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d5
    clr.w   d3
    move.w  $26(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d2
    move.b  (a1), d2
    moveq   #$0,d6
    move.b  (a1), d6
    moveq   #$0,d0
    move.b  $1(a1), d0
    add.w   d0, d6
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d4
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF0420,a0
    lea     (a0,d4.w), a2
    move.w  d2, d4
    bra.b   l_14190
l_1416c:
    clr.w   d2
l_1416e:
    cmpi.b  #$e, (a3)
    bne.b   l_14182
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_14182
    addq.w  #$1, d3
l_14182:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_1416e
    addq.w  #$1, d4
l_14190:
    cmp.w   d6, d4
    bcs.b   l_1416c
    moveq   #$0,d2
    move.b  $2(a1), d2
    moveq   #$0,d6
    move.b  $2(a1), d6
    moveq   #$0,d0
    move.b  $3(a1), d0
    add.w   d0, d6
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d4
    bra.b   l_141f0
l_141cc:
    clr.w   d2
l_141ce:
    cmpi.b  #$e, (a3)
    bne.b   l_141e2
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_141e2
    addq.w  #$1, d3
l_141e2:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_141ce
    addq.w  #$1, d4
l_141f0:
    cmp.w   d6, d4
    bcs.b   l_141cc
    move.w  d3, d5
    mulu.w  #$1e, d5
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts
