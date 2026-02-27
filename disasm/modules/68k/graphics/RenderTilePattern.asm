; ============================================================================
; RenderTilePattern -- Displays chars compatible with the current slot type; builds compatible-char index list, renders names with selection cursor, handles paging, and updates stat bytes on selection change.
; 1208 bytes | $015040-$0154F7
; ============================================================================
RenderTilePattern:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l $c(a6), a2
    lea     -$20(a6), a4
    movea.l  #$00000D64,a5
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, -$28(a6)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $20(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
    clr.w   d2
.l1509c:
    tst.b   (a3)
    beq.b   .l150f0
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckCharCompat
    lea     $c(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l150f0
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d2, (a4,a0.l)
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l150ee
    move.w  d3, d7
.l150ee:
    addq.w  #$1, d3
.l150f0:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l1509c
    move.w  d3, d0
    addi.w  #$ffff, d0
    move.w  d0, -$24(a6)
    tst.w   -$24(a6)
    bne.b   .l15112
    move.w  #$1, -$26(a6)
    bra.b   .l15116
.l15112:
    clr.w   -$26(a6)
.l15116:
    move.w  d7, d3
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  -$27(a6), d1
    movea.l  #$00FFB9E9,a0
    sub.b   d1, (a0,d0.w)
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l1514c
    moveq   #$1,d2
    bra.b   .l1514e
.l1514c:
    moveq   #$0,d2
.l1514e:
    clr.w   -$22(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
    clr.w   d4
.l15162:
    addq.w  #$1, d4
    cmpi.w  #$1, d4
    bne.b   .l151d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0094).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0094).w
    pea     ($0080).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l151c4:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l151f2
.l151d2:
    cmpi.w  #$f, d4
    bne.b   .l151ea
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l151c4
.l151ea:
    cmpi.w  #$1e, d4
    bne.b   .l151f2
    clr.w   d4
.l151f2:
    cmpi.w  #$1, d6
    bne.b   .l1525a
    pea     ($0003).w
    pea     ($0001).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharDetail
    lea     $1c(a7), a7
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
    clr.w   d6
.l1525a:
    tst.w   d2
    beq.b   .l1527c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l1527c
.l1526c:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l15162
.l1527c:
    clr.w   d2
    move.w  -$22(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$22(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l152bc
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l153f2
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15432
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15448
    bra.w   .l1545e
.l152bc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   d7, d3
    beq.w   .l1547a
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    ble.w   .l153ee
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr SetHighNibble
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    move.l  a2, -(a7)
    jsr GetLowNibble
    lea     $1c(a7), a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l15366
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    bra.b   .l1536a
.l15366:
    move.w  d2, d0
    ext.l   d0
.l1536a:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F838).l
    jsr PrintfNarrow
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationAction
    lea     $2c(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationResult
    pea     ($064C).w
    pea     ($0008).w
    pea     ($000E).w
    pea     ($0009).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    bra.w   .l1547a
.l153ee:
    clr.w   d6
    bra.b   .l1546a
.l153f2:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   d7, d3
    beq.b   .l1547a
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($0002).w
    move.w  d7, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
    bra.b   .l1547a
.l15432:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d6
    subq.w  #$1, d3
    tst.w   d3
    bge.b   .l1546a
    move.w  -$24(a6), d3
    bra.b   .l1546a
.l15448:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d6
    addq.w  #$1, d3
    cmp.w   -$24(a6), d3
    ble.b   .l1546a
    clr.w   d3
    bra.b   .l1546a
.l1545e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l1546a:
    cmpi.w  #$1, -$26(a6)
    bne.w   .l1526c
    clr.w   d6
    bra.w   .l1526c
.l1547a:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  -$27(a6), d1
    movea.l  #$00FFB9E9,a0
    add.b   d1, (a0,d0.w)
    jsr LoadMapTiles
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts
