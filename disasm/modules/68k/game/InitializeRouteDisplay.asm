; ============================================================================
; InitializeRouteDisplay -- Initialize and render the route display panel for a character slot, including portrait, stat bars, name/type text, city bonus, and route event graphic.
; 640 bytes | $020B38-$020DB7
; ============================================================================
InitializeRouteDisplay:
    link    a6,#-$4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d2
    movea.l  #$0003AB2C,a4
    movea.l  #$00FF899C,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    lea     -$4(a6), a2
    clr.l   -(a7)
    pea     ($00FB).w
    pea     ($0026).w
    pea     ($0008).w
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderRouteUIElements,PC)
    nop
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0006).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004120C).l
    jsr PrintfNarrow
    pea     ($0002).w
    pea     ($0006).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005EB2C,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041208).l
    jsr PrintfNarrow
    pea     ($0003).w
    pea     ($0006).w
    jsr     (a4)
    lea     $28(a7), a7
    moveq   #$0,d3
    move.b  $1(a3), d3
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    pea     ($00041200).l
    jsr PrintfWide
    pea     ($0004).w
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr CalcCityCharBonus
    pea     ($0003).w
    pea     ($0012).w
    jsr     (a4)
    lea     $30(a7), a7
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000411FC).l
    jsr PrintfWide
    pea     ($0003).w
    pea     ($001B).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000411F8).l
    jsr PrintfWide
    pea     ($0004).w
    move.l  a3, -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    lea     $2c(a7), a7
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d4
    movea.l  #$0005F6F4,a0
    move.w  (a0,d0.w), d3
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    jsr DisplaySetup
    pea     ($000733F0).l
    pea     ($0006).w
    pea     ($000C).w
    pea     ($0005).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $30(a7), a7
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C7C4,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0048).w
    pea     ($0127).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    pea     ($00073480).l
    pea     ($0005).w
    pea     ($000C).w
    pea     ($0008).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    movea.l  #$0005F6F2,a0
    move.w  (a0,d4.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$0009C7E0,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($003C).w
    pea     ($016F).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile2
    lea     $1c(a7), a7
    cmpi.w  #$20, d2
    bcc.b   l_20dae
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (DisplayRouteEvent,PC)
    nop
l_20dae:
    movem.l -$20(a6), d2-d4/a2-a5
    unlk    a6
    rts
