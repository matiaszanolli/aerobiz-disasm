; ============================================================================
; CalcCityMetrics -- Sets background, shows a dialog, then loops calling ScanCitySlots and NavigateCharList to browse city slot data; draws result box on exit
; 166 bytes | $0171B4-$017259
; ============================================================================
CalcCityMetrics:
    movem.l d2-d4, -(a7)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    jsr (ResolveCityConflict,PC)
    nop
    addq.l  #$8, a7
    moveq   #$4,d3
    clr.w   d4
l_171d0:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A5E).l
    move.w  ($00FFA792).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScanCitySlots,PC)
    nop
    lea     $1c(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_1723a
    cmpi.w  #$ff, d2
    beq.b   l_17216
    move.w  d2, d3
    add.w   d3, d3
    addq.w  #$4, d3
l_17216:
    move.w  d2, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_17226
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_1722c
    bra.b   l_17236
l_17226:
    pea     ($0001).w
    bra.b   l_1722e
l_1722c:
    clr.l   -(a7)
l_1722e:
    jsr (NavigateCharList,PC)
    nop
    addq.l  #$4, a7
l_17236:
    tst.w   d4
    beq.b   l_171d0
l_1723a:
    pea     ($0008).w
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0005).w
    jsr (RecordEventOutcome,PC)
    nop
    lea     $10(a7), a7
    movem.l (a7)+, d2-d4
    rts
