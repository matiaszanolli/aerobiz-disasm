; ============================================================================
; RunModelSelectUI -- Full player hub city selection screen: show map with labels, select via BrowseCharList, confirm via dialog
; 856 bytes | $00B3F4-$00B74B
; ============================================================================
RunModelSelectUI:
    link    a6,#-$54
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d4
    lea     -$52(a6), a4
    movea.l  #$00000D64,a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  #$80, ($00FFBD64).l
    move.w  #$80, ($00FFBD66).l
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0007).w
    bsr.w PlacePlayerNameLabels
    lea     $20(a7), a7
    jsr ResourceUnload
    movea.l  #$000475E8,a2
.l0b47a:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5D2).l
    move.l  (a2), -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
.l0b4a2:
    jsr (RunDestSelectLoop,PC)
    nop
    move.w  d0, -$2(a6)
    cmpi.w  #$ff, d0
    beq.b   .l0b4a2
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    lea     $30(a7), a7
    pea     ($0003).w
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  -$2(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w PlacePlayerNameLabels
    jsr ResourceUnload
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003E5CC).l
    move.l  (a2), -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    lea     $20(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
.l0b550:
    pea     -$2(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bge.w   .l0b670
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.w   .l0b60c
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475F0).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $20(a7), a7
    cmpi.w  #$1, d0
    beq.b   .l0b5dc
    move.w  #$ff, d2
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.w   .l0b6c0
.l0b5dc:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    bra.w   .l0b6e6
.l0b60c:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475FC).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d2
    bra.b   .l0b6de
.l0b670:
    cmpi.w  #$20, d2
    blt.b   .l0b6de
    cmpi.w  #$ff, d2
    beq.b   .l0b6de
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000475EC).l, -(a7)
    move.l  a4, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a4, -(a7)
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    lea     $28(a7), a7
    move.w  #$ff, d2
.l0b6c0:
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
.l0b6de:
    cmpi.w  #$ff, d2
    bne.w   .l0b550
.l0b6e6:
    cmpi.w  #$ff, d2
    bne.b   .l0b72e
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a5)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0007).w
    bsr.w PlacePlayerNameLabels
    lea     $20(a7), a7
    jsr ResourceUnload
.l0b72e:
    cmpi.w  #$ff, d2
    beq.w   .l0b47a
    move.b  d2, $1(a3)
    jsr ResourceLoad
    move.w  d2, d0
    movem.l -$70(a6), d2-d4/a2-a5
    unlk    a6
    rts
