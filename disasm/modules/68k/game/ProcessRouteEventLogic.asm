; ============================================================================
; ProcessRouteEventLogic -- Handle route event: collect available chars, show comparison UI, confirm purchase or decline, update player record
; 476 bytes | $00E8AA-$00EA85
; ============================================================================
ProcessRouteEventLogic:
    link    a6,#-$70
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    jsr ResourceLoad
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0005).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w CollectPlayerChars
    lea     $24(a7), a7
    move.w  d0, d4
    jsr ResourceUnload
    tst.w   d4
    bgt.w   l_0ea3e
    bra.w   l_0ea5c
l_0e920:
    lea     -$a(a6), a2
    pea     ($000A).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d3, d0
    mulu.w  #$a, d0
    add.w   d0, d0
    movea.l  #$00FF1A04,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    jsr MemCopy
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w ShowCharCompare
    move.w  d0, d3
    cmpi.w  #$1, d3
    bne.b   l_0e96a
    moveq   #$1,d3
    bra.b   l_0e96c
l_0e96a:
    moveq   #$2,d3
l_0e96c:
    move.w  $4(a2), d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$000477B0,a0
    move.l  (a0,d0.w), -(a7)
    pea     -$6e(a6)
    jsr sprintf
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    pea     -$6e(a6)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_0ea22
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    bsr.w CalcCharValue
    move.l  d0, d2
    add.l   d0, d0
    add.l   d2, d0
    bge.b   l_0e9da
    addq.l  #$3, d0
l_0e9da:
    asr.l   #$2, d0
    move.l  d0, d2
    add.l   d2, $6(a3)
    cmpi.w  #$20, (a2)
    bge.b   l_0e9fa
    move.w  (a2), d0
    mulu.w  #$6, d0
    add.w   $2(a2), d0
    movea.l  #$00FF0420,a0
    bra.b   l_0ea08
l_0e9fa:
    move.w  (a2), d0
    lsl.w   #$2, d0
    add.w   $2(a2), d0
    movea.l  #$00FF0460,a0
l_0ea08:
    move.b  #$ff, (a0,d0.w)
    pea     ($0001).w
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr InitCharRecord
    lea     $14(a7), a7
    bra.b   l_0ea7a
l_0ea22:
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $10(a7), a7
l_0ea3e:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunPlayerStatCompareUI
    addq.l  #$8, a7
    move.w  d0, d3
    cmpi.w  #$ff, d0
    bne.w   l_0e920
    bra.b   l_0ea7a
l_0ea5c:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    move.l  ($000477A8).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
l_0ea7a:
    moveq   #$1,d0
    movem.l -$84(a6), d2-d4/a2-a3
    unlk    a6
    rts
