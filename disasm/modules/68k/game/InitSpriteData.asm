; ============================================================================
; InitSpriteData -- Scans chars compatible with a given player and char-type, fills the sprite-data working area with their indices and revenue values for the route management display.
; 490 bytes | $013EF2-$0140DB
; ============================================================================
InitSpriteData:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d4
    move.l  $8(a6), d5
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.b  (a0), d3
    andi.l  #$ff, d3
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d6
    moveq   #$1F,d7
    move.w  #$7, -$6(a6)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    movea.l -$4(a6), a0
    move.b  $1(a0), d4
    andi.l  #$ff, d4
    bra.w   l_13fee
l_13f5a:
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_13f80:
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_13fbc
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcs.b   l_13fbc
    move.b  (a2), d0
    cmp.b   $1(a4), d0
    bhi.b   l_13fbc
    addq.w  #$1, -$6(a6)
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_13fc8
    addq.w  #$1, d6
    bra.b   l_13fc8
l_13fbc:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_13f80
l_13fc8:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    addq.w  #$1, d7
    addq.l  #$2, a5
    subq.w  #$1, d4
    addq.w  #$1, d3
l_13fee:
    tst.w   d4
    bgt.w   l_13f5a
    movea.l -$4(a6), a0
    move.b  $2(a0), d3
    andi.l  #$ff, d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    movea.l -$4(a6), a0
    move.b  $3(a0), d4
    andi.l  #$ff, d4
    bra.w   l_140ca
l_14024:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_14046:
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_14098
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcs.b   l_14098
    move.b  (a2), d0
    cmp.b   $1(a4), d0
    bhi.b   l_14098
    addq.w  #$1, -$6(a6)
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  $e(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    beq.b   l_140a4
    addq.w  #$1, d6
    bra.b   l_140a4
l_14098:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_14046
l_140a4:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    addq.l  #$2, a5
    addq.w  #$1, d7
    subq.w  #$1, d4
    addq.w  #$1, d3
l_140ca:
    tst.w   d4
    bgt.w   l_14024
    move.w  d6, d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts
