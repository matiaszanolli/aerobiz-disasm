; ============================================================================
; ManageCharSlotReassignment -- Manages the char-reassignment screen for a player: allows selection of a char and shifting its assignment count across slots using directional input, confirming or cancelling with dialog prompts.
; 814 bytes | $028576-$0288A3
; ============================================================================
ManageCharSlotReassignment:
    link    a6,#-$50
    movem.l d2-d5/a2-a5, -(a7)
    move.l  $8(a6), d3
    movea.l  #$00007912,a4
    movea.l  #$00048330,a5
    clr.w   d5
    jsr ResourceLoad
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
l_285d0:
    cmpi.w  #$1, d5
    bne.b   l_2861e
    jsr ResourceLoad
    jsr ClearBothPlanes
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    lea     $18(a7), a7
    jsr ResourceUnload
    clr.w   d5
l_2861e:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  ($00048330).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0017).w
    pea     ($0002).w
    jsr SetTextCursor
    pea     $e(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $20(a7), a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.w   l_28896
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    beq.w   l_28886
    moveq   #$0,d2
    move.b  (a2), d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    cmpi.w  #$e, d2
    bge.b   l_286e8
    move.w  d2, d0
    ext.l   d0
    bra.b   l_286ea
l_286e8:
    moveq   #$E,d0
l_286ea:
    move.w  d0, d2
    tst.w   d2
    ble.w   l_28868
    jsr ClearBothPlanes
    move.w  d4, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  $4(a5), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunSlotCountPicker,PC)
    nop
    lea     $18(a7), a7
    move.w  d0, d2
    ble.w   l_28862
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d2
    bne.b   l_28754
    pea     ($00041ACE).l
    bra.b   l_2875a
l_28754:
    pea     ($00041AC8).l
l_2875a:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $8(a5), -(a7)
    pea     -$50(a6)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_28862
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d2, d5
    bra.b   l_28810
l_287a8:
    pea     ($0011).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    addi.l  #$f, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    subq.b  #$1, (a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC4).l
    jsr PrintfNarrow
    subq.b  #$1, $1(a3)
    pea     ($0011).w
    pea     ($0001).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041AC0).l
    jsr PrintfNarrow
    pea     ($0005).w
    pea     ($000E).w
    jsr GameCommand
    lea     $28(a7), a7
l_28810:
    subq.w  #$1, d2
    bge.b   l_287a8
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    cmpi.w  #$1, d5
    bne.b   l_28830
    pea     ($00041AB6).l
    bra.b   l_28836
l_28830:
    pea     ($00041AAA).l
l_28836:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $c(a5), -(a7)
    pea     -$50(a6)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
l_28862:
    moveq   #$1,d5
    bra.w   l_285d0
l_28868:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $14(a5), -(a7)
l_28876:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    bra.w   l_285d0
l_28886:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  $10(a5), -(a7)
    bra.b   l_28876
l_28896:
    move.w  $e(a6), d0
    movem.l -$70(a6), d2-d5/a2-a5
    unlk    a6
    rts
