; ============================================================================
; DisplayRouteDestChoice -- Display selectable destination slots for a route type, handle scrolling navigation and selection input
; 1308 bytes | $00DB72-$00E08D
; ============================================================================
DisplayRouteDestChoice:
    link    a6,#-$60
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7
    movea.l  #$00000D64,a5
    cmpi.w  #$20, d7
    bge.b   l_0dbc4
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d2
l_0dbb0:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.b   l_0dbf8
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_0dbb0
    bra.b   l_0dbf8
l_0dbc4:
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d2
l_0dbe6:
    movea.w d2, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.b   l_0dbf8
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_0dbe6
l_0dbf8:
    cmpi.w  #$1, $16(a6)
    bne.b   l_0dc12
    move.w  d7, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
l_0dc12:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004778C).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0017).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$D,d6
    moveq   #$5,d5
    clr.l   -(a7)
    jsr ReadInput
    lea     $20(a7), a7
    tst.w   d0
    beq.b   l_0dc6c
    moveq   #$1,d0
    bra.b   l_0dc6e
l_0dc6c:
    moveq   #$0,d0
l_0dc6e:
    move.w  d0, -$2(a6)
    clr.w   -$4(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  $1a(a6), d3
    move.w  #$ff, d4
l_0dc8a:
    cmp.w   d3, d4
    beq.w   l_0de02
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000F).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($000C).w
    pea     ($000F).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  d3, d6
    ext.l   d6
    asr.l   #$1, d6
    mulu.w  #$6, d6
    addi.w  #$d, d6
    move.w  d3, d5
    andi.w  #$1, d5
    mulu.w  #$5, d5
    addq.w  #$5, d5
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    lea     (a2,d3.w), a0
    movea.l a0, a3
    cmpi.b  #$f, (a0)
    bcc.w   l_0de00
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcCharValue,PC)
    nop
    lea     $1c(a7), a7
    move.l  d0, d4
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($001F).w
    pea     ($0010).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0010).w
    pea     ($0001).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003E8CC).l
    jsr PrintfWide
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0014).w
    jsr SetTextCursor
    move.l  d4, -(a7)
    pea     ($0003E8C6).l
    jsr PrintfWide
    lea     $10(a7), a7
l_0de00:
    move.w  d3, d4
l_0de02:
    tst.w   -$2(a6)
    beq.b   l_0de26
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_0de26
    pea     ($0002).w
l_0de1a:
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   l_0dc8a
l_0de26:
    clr.w   -$2(a6)
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    move.w  d0, -$4(a6)
    andi.w  #$20, d0
    beq.w   l_0df84
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0546).w
    jsr TilePlacement
    pea     ($0002).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)
    bcc.w   l_0df84
    movea.w d3, a0
    cmpi.b  #$ff, (a4,a0.w)
    bne.b   l_0deb6
    movea.w d3, a0
    cmpi.b  #$f, (a2,a0.w)
    bcs.w   l_0e05e
l_0deb6:
    lea     (a4,d3.w), a0
    movea.l a0, a3
    move.b  (a0), d0
    andi.l  #$7f, d0
    move.w  $a(a6), d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_0defc
    movea.w d3, a0
    move.b  (a2,a0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477A0).l, -(a7)
    pea     -$5e(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_0df3a
l_0defc:
    move.b  (a3), d0
    andi.w  #$7f, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    movea.w d3, a0
    move.b  (a2,a0.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($00047790).l, -(a7)
    pea     -$5e(a6)
    jsr sprintf
    lea     $10(a7), a7
l_0df3a:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$5e(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004778C).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $30(a7), a7
l_0df84:
    move.w  -$4(a6), d0
    andi.w  #$10, d0
    beq.b   l_0dfa2
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d3
    bra.w   l_0e05e
l_0dfa2:
    move.w  -$4(a6), d0
    andi.w  #$f, d0
    beq.w   l_0e056
    move.w  -$4(a6), d0
    andi.w  #$8, d0
    beq.b   l_0dfd0
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    addq.l  #$2, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_0dfd0
    addq.w  #$2, d3
l_0dfd0:
    move.w  -$4(a6), d0
    andi.w  #$4, d0
    beq.b   l_0e006
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0
    move.w  d3, d1
    andi.l  #$1, d1
    cmp.l   d1, d0
    ble.b   l_0dffc
    move.w  d3, d0
    ext.l   d0
    subq.l  #$2, d0
    bra.b   l_0e004
l_0dffc:
    move.w  d3, d0
    andi.l  #$1, d0
l_0e004:
    move.w  d0, d3
l_0e006:
    move.w  -$4(a6), d0
    andi.w  #$2, d0
    beq.b   l_0e040
    move.w  #$1, ($00FF13FC).l
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0
    move.w  d2, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    bge.b   l_0e038
    move.w  d3, d0
    ext.l   d0
    ori.l   #$1, d0
    bra.b   l_0e03e
l_0e038:
    move.w  d2, d0
    ext.l   d0
    subq.l  #$1, d0
l_0e03e:
    move.w  d0, d3
l_0e040:
    move.w  -$4(a6), d0
    andi.w  #$1, d0
    beq.b   l_0e056
    move.w  #$1, ($00FF13FC).l
    andi.w  #$fe, d3
l_0e056:
    pea     ($0004).w
    bra.w   l_0de1a
l_0e05e:
    move.l  #$8000, -(a7)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    move.w  d3, d0
    movem.l -$88(a6), d2-d7/a2-a5
    unlk    a6
    rts
