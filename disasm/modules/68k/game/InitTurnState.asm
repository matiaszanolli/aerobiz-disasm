; ============================================================================
; InitTurnState -- Selects a random route and character for the current turn via bitfield search, looks up city and char compatibility, and fills the turn-state record with route/char/speed data
; 710 bytes | $01A792-$01AA57
; ============================================================================
InitTurnState:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d5
    movea.l $30(a7), a3
    movea.l  #$0001D6A4,a5
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    tst.l   d0
    bne.w   l_1a8dc
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d4
    mulu.w  #$7, d0
    add.w   d5, d0
    movea.l  #$00FFA7BC,a0
    tst.b   (a0,d0.w)
    beq.w   l_1aa52
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$ff, d7
    bne.b   l_1a806
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d7
l_1a806:
    cmpi.w  #$ff, d7
    beq.w   l_1aa52
l_1a80e:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d6
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$7, d1
    add.w   d5, d1
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    and.l   d1, d0
    beq.b   l_1a80e
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.b   l_1a870
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d2
l_1a870:
    move.b  d4, (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1a8b6
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
l_1a8a4:
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  d7, $1(a3)
    move.b  d2, $2(a3)
    bra.w   l_1aa42
l_1a8b6:
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
    bra.w   l_1aa34
l_1a8dc:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d6
    move.b  $1(a2), d6
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d6
    addi.w  #$ffff, d6
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d4
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    bne.b   l_1a940
    move.w  d4, d0
    mulu.w  #$e, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    tst.w   (a0,d0.w)
    beq.w   l_1aa52
l_1a940:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$ff, d0
    beq.w   l_1aa52
    clr.w   d3
l_1a960:
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    ble.b   l_1a99a
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d2
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_1a9da
    bra.b   l_1a9e4
l_1a99a:
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d5, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    beq.b   l_1a9da
    moveq   #$0,d0
    move.b  $2(a2), d0
    add.w   d0, d2
    bra.b   l_1a9e4
l_1a9da:
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    blt.w   l_1a960
l_1a9e4:
    cmpi.w  #$10, d3
    bge.b   l_1aa52
    move.b  d4, (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1aa1a
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    bra.w   l_1a8a4
l_1aa1a:
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
l_1aa34:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d7, $2(a3)
    move.b  d2, $1(a3)
l_1aa42:
    move.l  a4, -(a7)
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    jsr (ProgressGamePhase,PC)
    nop
    lea     $c(a7), a7
l_1aa52:
    movem.l (a7)+, d2-d7/a2-a5
    rts


; === Translated block $01AA58-$01ABB0 ===
; 1 functions, 344 bytes
