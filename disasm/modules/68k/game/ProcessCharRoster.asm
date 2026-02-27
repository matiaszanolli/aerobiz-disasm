; ============================================================================
; ProcessCharRoster -- Draw route arcs on the world map for all domestic and international routes of a player
; 534 bytes | $009A88-$009C9D
; ============================================================================
ProcessCharRoster:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d5
    move.l  $10(a6), d6
    move.l  $8(a6), d7
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    and.l   (a0,d0.w), d4
    move.w  d7, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    move.w  d5, d0
    mulu.w  #$e, d0
    movea.l  #$0005E234,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    bra.w   l_09bc0
l_09af6:
    cmpi.b  #$ff, (a2)
    beq.w   l_09bba
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   l_09b1e
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    beq.w   l_09bba
l_09b1e:
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d5, d0
    beq.b   l_09b56
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    bra.b   l_09b8c
l_09b56:
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    cmp.w   d5, d0
    beq.b   l_09b8c
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a3
l_09b8c:
    tst.w   d6
    bne.b   l_09ba2
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_09b9e
    moveq   #$1,d2
    bra.b   l_09ba4
l_09b9e:
    moveq   #$2,d2
    bra.b   l_09ba4
l_09ba2:
    moveq   #$3,d2
l_09ba4:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    bsr.w DrawRoutePair
    lea     $10(a7), a7
l_09bba:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_09bc0:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    cmp.l   d1, d0
    blt.w   l_09af6
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    and.l   (a0,d0.w), d4
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   l_09c7c
l_09c0e:
    cmpi.b  #$ff, (a2)
    beq.b   l_09c76
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    beq.b   l_09c76
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.w   d6
    bne.b   l_09c5e
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   l_09c5a
    moveq   #$1,d2
    bra.b   l_09c60
l_09c5a:
    moveq   #$2,d2
    bra.b   l_09c60
l_09c5e:
    moveq   #$3,d2
l_09c60:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    bsr.w DrawRoutePair
    lea     $10(a7), a7
l_09c76:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d3
l_09c7c:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a5), d1
    cmp.l   d1, d0
    blt.b   l_09c0e
    pea     ($000C).w
    jsr GameCommand
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts
