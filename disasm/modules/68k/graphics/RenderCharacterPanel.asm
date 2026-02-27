; ============================================================================
; RenderCharacterPanel -- Draws the character detail panel for one route slot; prints char name, displays bonus value labels computed from CalcQuarterBonus, and shows a star rating bar.
; 1346 bytes | $01377E-$013CBF
; ============================================================================
RenderCharacterPanel:
    link    a6,#-$14
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$0003B270,a5
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  $12(a6), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  $6(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF9A10,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcQuarterBonus,PC)
    nop
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d5
    move.l  d0, -$c(a6)
    move.l  d5, d0
    bge.b   l_137ee
    addq.l  #$1, d0
l_137ee:
    asr.l   #$1, d0
    move.l  d0, -$14(a6)
    move.l  d5, d0
    bge.b   l_137fa
    addq.l  #$3, d0
l_137fa:
    asr.l   #$2, d0
    move.l  d5, d1
    sub.l   d0, d1
    move.l  d1, -$10(a6)
    move.l  d5, d0
    add.l   d0, d0
    move.l  d0, -$8(a6)
    move.l  d5, d0
    lsl.l   #$2, d0
    move.l  d0, -$4(a6)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.w   d2
    moveq   #$4,d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F662).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    pea     ($0003F65C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F64A).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F636).l
    jsr     (a5)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
l_1395a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   l_1395a
    clr.w   d6
    clr.w   ($00FFBD58).l
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d5
    moveq   #$2,d4
l_13982:
    tst.w   ($00FFBD58).l
    beq.w   l_13ac0
    cmpi.w  #$1, d5
    bne.w   l_13ac8
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F624).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    pea     ($0003F61E).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F60C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F5F8).l
    jsr     (a5)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d5
    bra.b   l_13ac8
l_13ac0:
    move.w  #$1, ($00FFBD58).l
l_13ac8:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), -(a7)
    pea     ($0003F5F2).l
    jsr     (a5)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0009).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000479E2,a0
    move.l  (a0,d0.w), -(a7)
    jsr     (a5)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0033).w
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$48, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$30, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    move.l  d0, -(a7)
    jsr ShowPlayerCompare
    lea     $24(a7), a7
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_13bb6
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_13c5c
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_13c66
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_13c86
    bra.w   l_13ca2
l_13bb6:
    clr.w   ($00FF13FC).l
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
    cmp.l   $6(a3), d5
    bgt.b   l_13c12
    move.w  #$64, $4(a2)
    move.w  d4, d2
    mulu.w  #$14, d2
    addi.w  #$a, d2
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharacterStats,PC)
    nop
    addq.l  #$8, a7
    add.w   d0, d2
    cmpi.w  #$64, d2
    bcc.b   l_13bfe
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_13c00
l_13bfe:
    moveq   #$64,d0
l_13c00:
    move.b  d0, $2(a2)
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
l_13c0c:
    move.l  d5, d0
    bra.w   l_13cb6
l_13c12:
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479DE).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    moveq   #$1,d5
    bra.b   l_13ca2
l_13c5c:
    clr.w   ($00FF13FC).l
    moveq   #$0,d5
    bra.b   l_13c0c
l_13c66:
    move.w  #$1, ($00FF13FC).l
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   l_13c82
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   l_13ca0
l_13c82:
    moveq   #$4,d0
    bra.b   l_13ca0
l_13c86:
    move.w  #$1, ($00FF13FC).l
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   l_13c9e
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   l_13ca0
l_13c9e:
    moveq   #$0,d0
l_13ca0:
    move.w  d0, d4
l_13ca2:
    pea     ($0006).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_13982
l_13cb6:
    movem.l -$3c(a6), d2-d7/a2-a5
    unlk    a6
    rts
