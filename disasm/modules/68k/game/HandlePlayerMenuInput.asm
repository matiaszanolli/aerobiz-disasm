; ============================================================================
; HandlePlayerMenuInput -- Handles negotiation menu: shows stat bars, processes directional input, confirms char selection
; 2036 bytes | $038E94-$039687
; ============================================================================
HandlePlayerMenuInput:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    movea.l  #$00000D64,a5
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    lea     $18(a7), a7
    tst.w   d0
    beq.b   l_38ee2
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    addq.l  #$4, a7
l_38ee2:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    cmpi.b  #$e, $b(a4)
    bcc.b   l_38f04
    moveq   #$0,d5
    move.b  $b(a4), d5
    bra.b   l_38f06
l_38f04:
    moveq   #$E,d5
l_38f06:
    moveq   #$0,d0
    move.b  $3(a4), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_38f1c
    moveq   #$0,d0
    move.b  $3(a4), d0
    bra.b   l_38f20
l_38f1c:
    move.w  d5, d0
    ext.l   d0
l_38f20:
    move.b  d0, $3(a4)
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d4
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2
    cmp.w   d2, d4
    bge.b   l_38fac
    move.w  d4, d0
    bra.b   l_38fae
l_38fac:
    move.w  d2, d0
l_38fae:
    ext.l   d0
    move.w  d0, d4
    cmp.w   d4, d5
    bge.b   l_38fba
    move.w  d5, d0
    bra.b   l_38fbc
l_38fba:
    move.w  d4, d0
l_38fbc:
    ext.l   d0
    move.w  d0, d5
    moveq   #$1,d4
    cmpi.w  #$7, d4
    bge.b   l_38fce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_38fd0
l_38fce:
    moveq   #$7,d0
l_38fd0:
    move.w  d0, -$6(a6)
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.b   l_3902c
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_3902c:
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$78(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a2
    bra.b   l_39060
l_39044:
    cmp.w   d4, d2
    bge.b   l_39052
    move.w  #$8541, (a2)
    move.w  #$8542, (a3)
    bra.b   l_3905a
l_39052:
    move.w  #$8000, (a2)
    move.w  #$8543, (a3)
l_3905a:
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
l_39060:
    cmp.w   d5, d2
    blt.b   l_39044
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)
    moveq   #$1,d7
    moveq   #$E,d6
    pea     ($0004).w
    pea     ($0015).w
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $28(a7), a7
    move.w  d6, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
    pea     ($000B).w
    pea     ($001D).w
    jsr SetTextCursor
    pea     ($000B).w
    pea     ($001D).w
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
    move.w  d0, -$7a(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, -$7c(a6)
    clr.l   -(a7)
    jsr ReadInput
    lea     $2c(a7), a7
    tst.w   d0
    beq.b   l_39158
    moveq   #$1,d0
    bra.b   l_3915a
l_39158:
    moveq   #$0,d0
l_3915a:
    move.w  d0, -$2(a6)
    clr.w   -$4(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    clr.w   d3
    bra.w   l_39676
l_39176:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   l_391e6
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
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
    pea     ($007C).w
    pea     ($00A0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
l_391d8:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   l_39206
l_391e6:
    cmpi.w  #$f, d3
    bne.b   l_391fe
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   l_391d8
l_391fe:
    cmpi.w  #$1e, d3
    bne.b   l_39206
    clr.w   d3
l_39206:
    pea     ($000B).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FEE).l
    jsr PrintfWide
    pea     ($0004).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FEA).l
    jsr PrintfNarrow
    pea     ($0004).w
    pea     ($0015).w
    jsr SetTextCursor
    move.w  -$7c(a6), d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($00044FE6).l
    jsr PrintfNarrow
    lea     $30(a7), a7
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00044FE2).l
    jsr PrintfWide
    pea     -$40(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $2c(a7), a7
    pea     -$78(a6)
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    lea     $1c(a7), a7
    tst.w   -$2(a6)
    beq.b   l_39310
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   l_3966a
l_39310:
    clr.w   -$2(a6)
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$4(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_3935a
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_393cc
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   l_3941e
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   l_39538
    cmpi.w  #$80, d0
    beq.w   l_395c6
    bra.w   l_3965e
l_3935a:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.b  d4, $3(a4)
    moveq   #$3,d2
l_3936c:
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0015).w
    pea     ($000E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0018).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $28(a7), a7
    move.w  d2, d0
    bra.w   l_3967e
l_393cc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$5,d2
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0002).w
    pea     ($000A).w
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3936c
l_3941e:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d4
    cmpi.w  #$1, d4
    ble.b   l_39434
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39436
l_39434:
    moveq   #$1,d0
l_39436:
    move.w  d0, d4
    cmpi.w  #$1, d5
    ble.b   l_39452
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8000, -$40(a6, d0.w)
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)
l_39452:
    cmpi.w  #$7, d4
    bne.b   l_3947c
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_3947c:
    cmpi.w  #$7, d4
    ble.b   l_394c2
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($000C).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
l_394c2:
    cmpi.w  #$7, d4
    bge.b   l_394ce
    move.w  d4, d0
    ext.l   d0
    bra.b   l_394d0
l_394ce:
    moveq   #$7,d0
l_394d0:
    move.w  d0, -$6(a6)
    cmpi.w  #$7, -$6(a6)
    bge.w   l_3966a
    cmpi.w  #$7, d5
    bge.b   l_394ea
    move.w  d5, d0
    ext.l   d0
    bra.b   l_394ec
l_394ea:
    moveq   #$7,d0
l_394ec:
    move.w  d0, -$8(a6)
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    ble.w   l_3966a
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  -$6(a6), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000B).w
    move.w  -$6(a6), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
l_39528:
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    bra.w   l_3966a
l_39538:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d4
    cmp.w   d5, d4
    bge.b   l_3954a
    move.w  d4, d0
    bra.b   l_3954c
l_3954a:
    move.w  d5, d0
l_3954c:
    ext.l   d0
    move.w  d0, d4
    add.w   d0, d0
    move.w  #$8541, -$42(a6, d0.w)
    move.w  d4, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)
    cmpi.w  #$7, d4
    bge.b   l_3956e
    move.w  d4, d0
    ext.l   d0
    bra.b   l_39570
l_3956e:
    moveq   #$7,d0
l_39570:
    move.w  d0, -$6(a6)
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000B).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  d4, d0
    addi.w  #$fff9, d0
    move.w  d0, -$6(a6)
    tst.w   -$6(a6)
    ble.w   l_3966a
    pea     ($033D).w
    pea     ($0001).w
    move.w  -$6(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000C).w
    pea     ($0014).w
    bra.w   l_39528
l_395c6:
    clr.w   ($00FF13FC).l
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CheckMatchSlots
    addq.l  #$4, a7
    cmpi.w  #$1, d0
    bne.w   l_3966a
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048606).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.l  ($00048612).l, -(a7)
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    bra.b   l_3966a
l_3965e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
l_3966a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
l_39676:
    cmpi.w  #$ff, d2
    bne.w   l_39176
l_3967e:
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts
