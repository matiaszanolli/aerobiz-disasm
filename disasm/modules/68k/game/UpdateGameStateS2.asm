; ============================================================================
; UpdateGameStateS2 -- Process pending route slot state changes in $FF09CE: execute trade offers and display route slot result notifications for types 0 and 1.
; 750 bytes | $022FC8-$0232B5
; ============================================================================
UpdateGameStateS2:
    link    a6,#-$A0
    movem.l d2-d3/a2-a5, -(a7)
    lea     -$80(a6), a5
    movea.l  #$00FF09CE,a2
    clr.w   d3
l_22fdc:
    tst.b   (a2)
    bne.w   l_23112
    tst.w   ($00FF000A).l
    beq.b   l_22ff8
    pea     ($0012).w
    clr.l   -(a7)
    jsr DecompressTilePair
    addq.l  #$8, a7
l_22ff8:
    clr.l   -(a7)
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$320, d0
    add.l   (a7)+, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000480DC).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    lea     $1c(a7), a7
    tst.w   ($00FF000A).l
    beq.b   l_23088
    pea     ($0003).w
    jsr TogglePageDisplay
    addq.l  #$4, a7
    bra.b   l_23098
l_23088:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
l_23098:
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  $1(a4), d2
    addi.w  #$ffec, d2
    tst.w   d2
    ble.b   l_230c0
    move.w  d2, d0
    ext.l   d0
    bra.b   l_230c2
l_230c0:
    moveq   #$0,d0
l_230c2:
    move.b  d0, $1(a4)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    jsr (ExecuteTradeOffer,PC)
    nop
    lea     $c(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_23102
    pea     ($00048114).l
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $c(a7), a7
l_23102:
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    bra.w   l_2320e
l_23112:
    cmpi.b  #$1, (a2)
    bne.w   l_2320e
    tst.w   ($00FF000A).l
    beq.b   l_23132
    pea     ($0013).w
    pea     ($0001).w
    jsr DecompressTilePair
    addq.l  #$8, a7
l_23132:
    pea     ($0001).w
    jsr InitInfoPanel
    moveq   #$0,d0
    move.b  $2(a2), d0
    mulu.w  #$14, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    mulu.w  #$320, d0
    add.l   (a7)+, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00048158).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    lea     $1c(a7), a7
    tst.w   ($00FF000A).l
    beq.b   l_231c4
    pea     ($0003).w
    jsr TogglePageDisplay
    addq.l  #$4, a7
    bra.b   l_231d4
l_231c4:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
l_231d4:
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0120,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  $1(a4), d2
    addi.w  #$fff6, d2
    tst.w   d2
    ble.b   l_23208
    move.w  d2, d0
    ext.l   d0
    bra.b   l_2320a
l_23208:
    moveq   #$0,d0
l_2320a:
    move.b  d0, $1(a4)
l_2320e:
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$2, d3
    blt.w   l_22fdc
    cmpi.w  #$ff, ($00FF09D6).l
    beq.w   l_232ac
    pea     ($000F).w
    jsr InitInfoPanel
    move.w  ($00FF09D6).l, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     -$a0(a6)
    jsr StringConcat
    pea     -$a0(a6)
    pea     ($00048198).l
    move.l  a5, -(a7)
    jsr sprintf
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    pea     -$a0(a6)
    pea     ($000481DA).l
    move.l  a5, -(a7)
    jsr sprintf
    lea     $30(a7), a7
    move.l  a5, -(a7)
    jsr (DrawLabeledBox,PC)
    nop
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    jsr (ClearListArea,PC)
    nop
    jsr ClearInfoPanel
l_232ac:
    movem.l -$b8(a6), d2-d3/a2-a5
    unlk    a6
    rts
