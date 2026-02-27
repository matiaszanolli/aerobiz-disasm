; ============================================================================
; FindCompatChars -- Scan 7 character slots for bitfield matches and render tile icons for each match
; 358 bytes | $00722A-$00738F
; ============================================================================
FindCompatChars:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $c(a6), d7
    lea     $a(a6), a3
    move.w  (a3), d0
    mulu.w  #$7, d0
    add.w   d7, d0
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$2(a6)
    clr.w   d2
    moveq   #$2,d3
    bra.w   l_0737e
l_0725e:
    cmp.w   d7, d2
    beq.w   l_0737c
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    and.l   d1, d0
    beq.w   l_0737c
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d0
    bne.b   l_072aa
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d4
l_072aa:
    move.w  d7, d0
    mulu.w  #$e, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d5
    add.w   d5, d5
    addi.w  #$670, d5
    move.w  d4, d0
    lsl.w   #$6, d0
    movea.l  #$00051942,a0
    pea     (a0, d0.w)
    pea     ($0001).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr DrawTileGrid
    lea     $10(a7), a7
    cmpi.b  #$f0, (a2)
    bcc.b   l_072fc
    moveq   #$0,d4
    move.b  (a2), d4
    bra.b   l_07302
l_072fc:
    move.l  #$f0, d4
l_07302:
    cmpi.b  #$9f, $1(a2)
    bcc.b   l_07312
    moveq   #$0,d6
    move.b  $1(a2), d6
    bra.b   l_07318
l_07312:
    move.l  #$9f, d6
l_07318:
    cmpi.w  #$6, d3
    bgt.b   l_0733c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bra.b   l_0735c
l_0733c:
    cmpi.w  #$7, d3
    bne.b   l_0737a
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($003F).w
l_0735c:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
l_0737a:
    addq.w  #$1, d3
l_0737c:
    addq.w  #$1, d2
l_0737e:
    cmpi.w  #$7, d2
    blt.w   l_0725e
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts
