; ============================================================================
; RenderCharInfoPanel -- Renders the char info/relationship status panel for a given player char pair
; 610 bytes | $0377DA-$037A3B
; ============================================================================
RenderCharInfoPanel:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $10(a6), d3
    move.l  $8(a6), d4
    move.l  $14(a6), d5
    lea     -$50(a6), a3
    movea.l  #$00007912,a4
    movea.l  #$00048616,a5
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_37836
    bsr.w ClearCharSprites
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $34(a5), -(a7)
l_37824:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$0,d0
    bra.w   l_37a32
l_37836:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmp.w   d3, d0
    bne.b   l_37884
    cmpi.w  #$1, d5
    bne.b   l_37884
    bsr.w ClearCharSprites
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $4(a5), -(a7)
l_3786a:
    move.l  a3, -(a7)
    jsr sprintf
    lea     $c(a7), a7
l_37876:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    bra.b   l_37824
l_37884:
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    beq.w   l_37948
    move.b  (a2), d0
    cmp.b   $1(a2), d0
    bhi.w   l_37994
    bsr.w ClearCharSprites
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $10(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d4, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    clr.w   d5
    bra.b   l_37910
l_378f6:
    tst.b   $1(a2)
    beq.b   l_3790c
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_3790c
    moveq   #$1,d5
    bra.b   l_37916
l_3790c:
    addq.l  #$8, a2
    addq.w  #$1, d2
l_37910:
    cmpi.w  #$4, d2
    blt.b   l_378f6
l_37916:
    cmpi.w  #$1, d5
    bne.b   l_37932
    bsr.w ClearCharSprites
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $18(a5), -(a7)
    bra.w   l_37824
l_37932:
    bsr.w ClearCharSprites
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $1c(a5), -(a7)
    bra.w   l_37824
l_37948:
    bsr.w ClearCharSprites
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $c(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  $14(a5), -(a7)
    bra.w   l_3786a
l_37994:
    cmpi.w  #$1, d5
    bne.w   l_37a30
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d5
    cmp.w   d2, d0
    beq.w   l_37a30
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.b   l_379ea
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   l_37a30
l_379ea:
    cmp.w   d3, d2
    beq.b   l_37a30
    bsr.w ClearCharSprites
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$2, d5
    bne.b   l_37a0e
    pea     ($00044F86).l
    bra.b   l_37a1c
l_37a0e:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
l_37a1c:
    move.l  $38(a5), -(a7)
    move.l  a3, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.w   l_37876
l_37a30:
    moveq   #$1,d0
l_37a32:
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts
