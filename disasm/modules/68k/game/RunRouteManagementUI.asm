; ============================================================================
; RunRouteManagementUI -- Runs the route management UI; calls SelectCharRelation to build available slots, then loops on directional input to scroll char-relation pairs and update sprite and text panel.
; 666 bytes | $01325C-$0134F5
; ============================================================================
RunRouteManagementUI:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d6
    movea.l $14(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$000479AE,a4
    lea     -$b6(a6), a5
    jsr ResourceLoad
    jsr ClearTileArea
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (SelectCharRelation,PC)
    nop
    jsr ResourceUnload
    moveq   #$1,d5
    move.w  #$ff, d2
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateSpritePos,PC)
    nop
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$30, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    clr.l   -(a7)
    jsr ReadInput
    lea     $28(a7), a7
    tst.w   d0
    beq.b   l_1330e
    moveq   #$1,d0
    bra.b   l_13310
l_1330e:
    moveq   #$0,d0
l_13310:
    move.w  d0, -$2(a6)
    clr.w   d7
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d2
l_13320:
    tst.w   d5
    beq.b   l_13348
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $1c(a4), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.w   d5
l_13348:
    tst.w   -$2(a6)
    beq.b   l_1335c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_13320
l_1335c:
    clr.w   -$2(a6)
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d7
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_1339a
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1343c
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1344a
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_134c4
    bra.w   l_134d0
l_1339a:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF9A10,a0
    tst.w   (a0,d0.w)
    ble.b   l_1342a
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (FindSpriteByID,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_133e8
l_133d2:
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d2, d0
    bra.w   l_134ec
l_133e8:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7)
    move.l  $4(a4), -(a7)
l_133f8:
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
    moveq   #$1,d5
    bra.w   l_134d8
l_1342a:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7)
    move.l  $18(a4), -(a7)
    bra.b   l_133f8
l_1343c:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d2
    bra.b   l_133d2
l_1344a:
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
l_13454:
    moveq   #$3,d1
    jsr SignedMod
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.b   l_13468
    moveq   #$3,d4
    bra.b   l_1346a
l_13468:
    move.w  d2, d4
l_1346a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  a2, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateSpritePos,PC)
    nop
    lea     $10(a7), a7
    bra.b   l_134d8
l_134c4:
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   l_13454
l_134d0:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_134d8:
    pea     ($0003).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_13320
l_134ec:
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts
