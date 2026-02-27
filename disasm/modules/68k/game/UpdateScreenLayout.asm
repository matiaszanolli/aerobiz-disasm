; ============================================================================
; UpdateScreenLayout -- Computes bar-chart display parameters from two characters' stats and renders a score comparison panel with navigation loop
; 1940 bytes | $015C4E-$0163E1
; ============================================================================
UpdateScreenLayout:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d3
    cmp.w   d3, d2
    bge.b   .l15ce6
    move.w  d2, d0
    bra.b   .l15ce8
.l15ce6:
    move.w  d3, d0
.l15ce8:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a4), d0
    add.w   d0, d2
    moveq   #$0,d4
    move.b  $b(a4), d4
    cmpi.w  #$e, d4
    bge.b   .l15d06
    move.w  d4, d0
    ext.l   d0
    bra.b   .l15d08
.l15d06:
    moveq   #$E,d0
.l15d08:
    move.w  d0, d4
    cmp.w   d2, d4
    bge.b   .l15d12
    move.w  d4, d0
    bra.b   .l15d14
.l15d12:
    move.w  d2, d0
.l15d14:
    ext.l   d0
    move.w  d0, d4
    moveq   #$0,d2
    move.b  $3(a4), d2
    cmp.w   d4, d2
    bge.b   .l15d26
    move.w  d2, d0
    bra.b   .l15d28
.l15d26:
    move.w  d4, d0
.l15d28:
    ext.l   d0
    move.b  d0, $3(a4)
    cmpi.b  #$1, $3(a4)
    bls.b   .l15d3e
    moveq   #$0,d3
    move.b  $3(a4), d3
    bra.b   .l15d40
.l15d3e:
    moveq   #$1,d3
.l15d40:
    cmpi.w  #$7, d3
    bge.b   .l15d4c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l15d4e
.l15d4c:
    moveq   #$7,d0
.l15d4e:
    move.w  d0, (a5)
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    tst.w   (a5)
    ble.b   .l15dac
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l15dac:
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$78(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a2
    bra.b   .l15de0
.l15dc4:
    cmp.w   d3, d2
    bge.b   .l15dd2
    move.w  #$8541, (a2)
    move.w  #$8542, (a3)
    bra.b   .l15dda
.l15dd2:
    move.w  #$8000, (a2)
    move.w  #$8543, (a3)
.l15dda:
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
.l15de0:
    cmp.w   d4, d2
    blt.b   .l15dc4
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)
    moveq   #$1,d6
    moveq   #$12,d5
    pea     ($0004).w
    pea     ($0014).w
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $28(a7), a7
    move.w  d5, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d3, d0
    move.w  d0, -$7a(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d7
    andi.l  #$ff, d7
    sub.w   d3, d7
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l15eb4
    moveq   #$1,d2
    bra.b   .l15eb6
.l15eb4:
    moveq   #$0,d2
.l15eb6:
    clr.w   -$2(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$0,d0
    move.w  d0, -$7c(a6)
    andi.l  #$ffff, d0
.l15ed2:
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F870).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F86C).l
    jsr PrintfNarrow
    pea     ($000F).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F868).l
    jsr PrintfWide
    lea     $30(a7), a7
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F864).l
    jsr PrintfWide
    pea     -$40(a6)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     -$78(a6)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    tst.w   d2
    beq.b   .l15ff2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l15ff2
.l15fde:
    pea     ($0003).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l15ed2
.l15ff2:
    clr.w   d2
    addq.w  #$1, -$7c(a6)
    cmpi.w  #$1, -$7c(a6)
    bne.b   .l16070
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($0098).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l1605e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.b   .l16096
.l16070:
    cmpi.w  #$f, -$7c(a6)
    bne.b   .l1608a
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l1605e
.l1608a:
    cmpi.w  #$1e, -$7c(a6)
    bne.b   .l16096
    clr.w   -$7c(a6)
.l16096:
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, -$2(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l160d2
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l1612a
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l161d6
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l162f2
    bra.w   .l1637c
.l160d2:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.b  d3, $3(a4)
    move.b  -$79(a6), d0
    add.b   d3, d0
    moveq   #$0,d1
    move.b  (a4), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    move.b  d7, d0
    add.b   d3, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    bra.w   .l1638c
.l1612a:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    cmp.l   d1, d0
    beq.w   .l1638c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a4, -(a7)
    jsr ShowRelationResult
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F860).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F85C).l
    jsr PrintfNarrow
    pea     ($000F).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F858).l
    jsr PrintfWide
    lea     $18(a7), a7
    bra.w   .l1638c
.l161d6:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d3
    cmpi.w  #$1, d3
    ble.b   .l161ec
    move.w  d3, d0
    ext.l   d0
    bra.b   .l161ee
.l161ec:
    moveq   #$1,d0
.l161ee:
    move.w  d0, d3
    cmpi.w  #$1, d4
    ble.b   .l1620a
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8000, -$40(a6, d0.w)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)
.l1620a:
    cmpi.w  #$7, d3
    bne.b   .l1623a
    pea     ($033E).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l1623a:
    cmpi.w  #$7, d3
    ble.b   .l16280
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l16280:
    cmpi.w  #$7, d3
    bge.b   .l1628c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1628e
.l1628c:
    moveq   #$7,d0
.l1628e:
    move.w  d0, (a5)
    cmpi.w  #$7, (a5)
    bge.w   .l15fde
    cmpi.w  #$7, d4
    bge.b   .l162a4
    move.w  d4, d0
    ext.l   d0
    bra.b   .l162a6
.l162a4:
    moveq   #$7,d0
.l162a6:
    move.w  d0, -$8(a6)
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    ble.w   .l15fde
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
.l162dc:
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    bra.w   .l15fde
.l162f2:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d3
    cmp.w   d4, d3
    bge.b   .l16304
    move.w  d3, d0
    bra.b   .l16306
.l16304:
    move.w  d4, d0
.l16306:
    ext.l   d0
    move.w  d0, d3
    add.w   d0, d0
    move.w  #$8541, -$42(a6, d0.w)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)
    cmpi.w  #$7, d3
    bge.b   .l16328
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1632a
.l16328:
    moveq   #$7,d0
.l1632a:
    move.w  d0, (a5)
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    tst.w   (a5)
    ble.w   .l15fde
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    bra.w   .l162dc
.l1637c:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l15fde
.l1638c:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts
