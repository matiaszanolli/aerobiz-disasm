; ============================================================================
; ShowCharPanelS2 -- Draws a single character panel cell at its screen position: selects the appropriate tile set by slot index, places the tile grid, draws a background block, sets a text window, and prints the character name and role labels
; 344 bytes | $02D10C-$02D263
; ============================================================================
ShowCharPanelS2:
    link    a6,#$0
    movem.l d2/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$00000D64,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1480,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$b, d2
    bge.b   .l2d154
    move.w  d2, d0
    mulu.w  #$90, d0
    add.w   d0, d0
    movea.l  #$0004F3A6,a0
    pea     (a0, d0.w)
    bra.b   .l2d15a
.l2d154:
    pea     ($0004FEE6).l
.l2d15a:
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0640).w
    jsr DrawTileGrid
    pea     ($6000).w
    pea     ($0003).w
    pea     ($0003).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0640).w
    jsr TilePlacement
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $18(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0014).w
    pea     ($0010).w
    pea     ($0008).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    cmpi.w  #$b, d2
    bge.b   .l2d22c
    pea     ($0010).w
    pea     ($0008).w
    jsr     (a4)
    tst.w   d2
    beq.b   .l2d208
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F04C,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   .l2d20e
.l2d208:
    pea     ($0004465A).l
.l2d20e:
    pea     ($0004465E).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0016).w
    jsr     (a4)
    lea     $18(a7), a7
    pea     ($00044652).l
    bra.b   .l2d258
.l2d22c:
    cmpi.w  #$b, d2
    bne.b   .l2d25a
    pea     ($0010).w
    pea     ($0008).w
    jsr     (a4)
    pea     ($00044646).l
    jsr     (a3)
    pea     ($0010).w
    pea     ($0016).w
    jsr     (a4)
    lea     $14(a7), a7
    pea     ($00044640).l
.l2d258:
    jsr     (a3)
.l2d25a:
    movem.l -$14(a6), d2/a2-a5
    unlk    a6
    rts
