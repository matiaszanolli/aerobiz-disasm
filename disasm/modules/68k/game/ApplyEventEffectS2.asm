; ============================================================================
; ApplyEventEffectS2 -- Aggregates char assignment counts across all player routes into a work buffer, then for any city whose total exceeds the threshold applies a random bonus increment to matching char assignment records.
; 182 bytes | $02934C-$029401
; ============================================================================
ApplyEventEffectS2:
    link    a6,#-$20
    movem.l d2-d4/a2-a4, -(a7)
    lea     -$20(a6), a4
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF02E8,a2
    clr.w   d3
l_29372:
    clr.w   d2
l_29374:
    tst.b   $1(a2)
    beq.b   l_2938c
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  (a2), d1
    add.l   d1, d1
    movea.l d1, a0
    add.w   d0, (a4,a0.l)
l_2938c:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_29374
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_29372
    movea.l a4, a3
    clr.w   d4
l_293a2:
    cmpi.w  #$f, (a3)
    bcs.b   l_293ee
    pea     ($0064).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    moveq   #$1E,d1
    cmp.l   d0, d1
    ble.b   l_293ee
    movea.l  #$00FF02E8,a2
    clr.w   d3
l_293c4:
    clr.w   d2
l_293c6:
    tst.b   $1(a2)
    beq.b   l_293dc
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.b   l_293dc
    addq.b  #$1, $2(a2)
l_293dc:
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    bcs.b   l_293c6
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_293c4
l_293ee:
    addq.l  #$2, a3
    addq.w  #$1, d4
    cmpi.w  #$10, d4
    bcs.b   l_293a2
    movem.l -$38(a6), d2-d4/a2-a4
    unlk    a6
    rts
