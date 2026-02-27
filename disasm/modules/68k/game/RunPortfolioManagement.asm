; ============================================================================
; RunPortfolioManagement -- Reset player records, display portfolio options menu, handle cursor navigation and player count confirmation
; 742 bytes | $00AA1C-$00AD01
; ============================================================================
RunPortfolioManagement:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00000D64,a3
    lea     -$20(a6), a4
    movea.l  #$00FF13FC,a5
    movea.l  #$00FF0018,a2
    clr.w   d2
.l0aa3c:
    clr.b   (a2)
    move.b  #$ff, $1(a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l0aa3c
    move.l  #$8000, -(a7)
    pea     ($0011).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l
    jsr DisplaySetup
    move.l  ($000A1B0C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0055).w
    pea     ($010F).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00071D24).l
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a3)
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003E578).l
    clr.l   -(a7)
    jsr (DisplayMessageWithParams,PC)
    nop
    clr.l   -(a7)
    jsr ReadInput
    lea     $18(a7), a7
    tst.w   d0
    beq.b   .l0aaf2
    moveq   #$1,d2
    bra.b   .l0aaf4
.l0aaf2:
    moveq   #$0,d2
.l0aaf4:
    clr.w   d5
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    moveq   #$1,d3
    clr.w   d4
.l0ab02:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$30, d0
    move.l  d0, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    tst.w   d4
    bne.b   .l0ab44
    cmpi.w  #$4, d4
    beq.b   .l0ab9a
.l0ab44:
    cmp.w   d3, d4
    beq.b   .l0ab9a
    move.w  #$40, $12(a4)
    move.w  #$40, $14(a4)
    move.w  #$40, $16(a4)
    move.w  #$40, $18(a4)
    move.w  #$40, $1a(a4)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$60, $12(a4, a0.l)
    pea     ($0005).w
    pea     ($0039).w
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.w  d3, d4
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    lea     $14(a7), a7
.l0ab9a:
    tst.w   d2
    beq.b   .l0abbc
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l0abbc
    pea     ($0002).w
.l0abb0:
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8, a7
    bra.w   .l0ab02
.l0abbc:
    clr.w   d2
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d5
    andi.w  #$30, d0
    beq.w   .l0ac68
    clr.w   (a5)
    clr.w   ($00FFA7D8).l
    move.w  d5, d0
    andi.w  #$20, d0
    beq.b   .l0ac64
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3, d2
    ext.l   d2
    lsl.l   #$4, d2
    addi.l  #$30, d2
    move.l  d2, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0546).w
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2, -(a7)
    pea     ($0048).w
    pea     ($0002).w
    pea     ($0548).w
    jsr TilePlacement
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    moveq   #$1,d4
.l0ac52:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $c(a7), a7
    bra.b   .l0acb4
.l0ac64:
    clr.w   d4
    bra.b   .l0ac52
.l0ac68:
    move.w  d5, d0
    andi.w  #$1, d0
    beq.b   .l0ac88
    move.w  #$1, (a5)
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   .l0ac84
    move.w  d3, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   .l0acaa
.l0ac84:
    moveq   #$0,d0
    bra.b   .l0acaa
.l0ac88:
    move.w  d5, d0
    andi.w  #$2, d0
    beq.b   .l0acac
    move.w  #$1, (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   .l0aca8
    move.w  d3, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   .l0acaa
.l0aca8:
    moveq   #$4,d0
.l0acaa:
    move.w  d0, d3
.l0acac:
    pea     ($0004).w
    bra.w   .l0abb0
.l0acb4:
    move.l  #$8000, -(a7)
    pea     ($000F).w
    pea     ($0012).w
    pea     ($0002).w
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    movea.l  #$00FF0018,a2
    clr.w   d2
    bra.b   .l0ace6
.l0acdc:
    move.b  #$1, (a2)
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l0ace6:
    cmp.w   d3, d2
    blt.b   .l0acdc
    move.w  d3, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FF0A34).l
    move.w  d4, d0
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts
