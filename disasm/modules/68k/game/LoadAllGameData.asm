; ============================================================================
; LoadAllGameData -- Load game save state from cartridge SRAM, unpack header fields (player count, scenario, frame counter) into work RAM
; 1196 bytes | $00CA3E-$00CEE9
; ============================================================================
LoadAllGameData:
    movem.l d2-d3/a2-a4, -(a7)
    move.l  $18(a7), d3
    movea.l  #$0001D538,a4
    movea.l  #$00FF1804,a3
    pea     ($2000).w
    move.w  d3, d0
    ext.l   d0
    moveq   #$D,d1
    lsl.l   d1, d0
    addi.l  #$200003, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CopyAlternateBytes
    addq.l  #$6, a3
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0002).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0004).l
    pea     ($0002).w
    pea     ($00FF0006).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    addq.l  #$2, a3
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0008).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000A).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000C).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF000E).l
    moveq   #$0,d0
    move.b  (a3)+, d0
    move.w  d0, ($00FF0010).l
    move.w  ($00FF0002).l, d0
    mulu.w  #$3c, d0
    addi.w  #$50, d0
    move.w  d0, ($00FFA6B2).l
    bsr.w BuildAircraftAttrTable
    bsr.w SortAircraftByMetric
    pea     ($0004).w
    pea     ($00FF0012).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$4, a3
    move.b  (a3)+, ($00FF0016).l
    pea     ($0090).w
    pea     ($00FF0018).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $90(a3), a3
    pea     ($0040).w
    pea     ($00FF00A8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
    pea     ($0030).w
    pea     ($00FF00E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$30,d0
    adda.l  d0, a3
    pea     ($0008).w
    pea     ($00FF0118).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$8, a3
    pea     ($0010).w
    pea     ($00FF0120).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    pea     ($0080).w
    pea     ($00FF0130).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $80(a3), a3
    pea     ($0080).w
    pea     ($00FF01B0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
    pea     ($0040).w
    pea     ($00FF0230).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$40,d0
    adda.l  d0, a3
    pea     ($0020).w
    pea     ($00FF0270).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$20,d0
    adda.l  d0, a3
    pea     ($0018).w
    pea     ($00FF0290).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$18,d0
    adda.l  d0, a3
    clr.w   d3
.l0cc2c:
    move.w  d3, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l0cc3e:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    move.b  (a2), $1(a2)
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l0cc3e
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cc2c
    pea     ($0050).w
    pea     ($00FF02E8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$50,d0
    adda.l  d0, a3
    pea     ($0080).w
    pea     ($00FF0338).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $80(a3), a3
    pea     ($0028).w
    pea     ($00FF03B8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$28,d0
    adda.l  d0, a3
    pea     ($0010).w
    pea     ($00FF03E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    pea     ($0030).w
    pea     ($00FF03F0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$30,d0
    adda.l  d0, a3
    pea     ($00C0).w
    pea     ($00FF0420).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    lea     $c0(a3), a3
    pea     ($00E4).w
    pea     ($00FF04E0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $e4(a3), a3
    move.l  a3, -(a7)
    jsr UnpackPixelData
    movea.l d0, a3
    pea     ($0040).w
    pea     ($00FF0728).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$40,d0
    adda.l  d0, a3
    movea.l  #$00FF8824,a2
    clr.w   d2
.l0cd5e:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   .l0cd5e
    movea.l  #$00FFBA80,a2
    clr.w   d2
.l0cd88:
    clr.w   d3
.l0cd8a:
    pea     ($0001).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    addq.l  #$1, a3
    addq.l  #$2, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cd8a
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    blt.b   .l0cd88
    pea     ($0010).w
    pea     ($00FF08EC).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$10,d0
    adda.l  d0, a3
    clr.w   d3
.l0cdd4:
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
.l0cde8:
    pea     ($000C).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $14(a7), a7
    moveq   #$C,d0
    adda.l  d0, a3
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.b   .l0cde8
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.b   .l0cdd4
    pea     ($0004).w
    pea     ($00FF099C).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$4, a3
    pea     ($0001).w
    pea     ($00FF09A0).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    addq.l  #$1, a3
    pea     ($0020).w
    pea     ($00FF09A2).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    moveq   #$20,d0
    adda.l  d0, a3
    move.l  a3, -(a7)
    jsr CopyRouteFields
    movea.l d0, a3
    pea     ($0059).w
    pea     ($00FF09D8).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    lea     $2c(a7), a7
    moveq   #$59,d0
    adda.l  d0, a3
    pea     ($0002).w
    pea     ($00FF0A32).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    addq.l  #$2, a3
    pea     ($0002).w
    pea     ($00FF0A34).l
    clr.l   -(a7)
    move.l  a3, -(a7)
    move.l  #$200003, -(a7)
    jsr     (a4)
    jsr (InitPlayerAircraftState,PC)
    nop
    move.w  ($00FF000C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetDisplayMode
    move.w  ($00FF000E).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr SetDisplayPage
    lea     $30(a7), a7
    movem.l (a7)+, d2-d3/a2-a4
    rts
