; ============================================================================
; UpdateGraphicsState -- Manages the player-select screen: cycles the active player display (mod 4), calls LoadScreen, ShowRelPanel, and RunMainMenu each iteration, polls for input (D-pad to browse chars via CharacterBrowser, Enter to select, Back to exit), updates the relation text window, and stores the final selection in $FF9A1C before returning.
; 648 bytes | $01CE3E-$01D0C5
; ============================================================================
UpdateGraphicsState:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $1c(a7), d6
    movea.l  #$00000D64,a2
    move.w  d6, d2
    move.w  #$80, d4
l_1ce56:
    move.w  d4, d0
    andi.w  #$80, d0
    beq.w   l_1cf0a
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    lea     $1c(a7), a7
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF0130,a0
    tst.l   (a0,d0.w)
    beq.b   l_1cf0a
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041180).l
    jsr PrintfWide
    lea     $20(a7), a7
l_1cf0a:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
l_1cf16:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$90, d0
    beq.b   l_1cf16
    move.w  d4, d0
    andi.w  #$10, d0
    bne.w   l_1d05c
    move.w  d4, d0
    andi.w  #$20, d0
    beq.w   l_1ce56
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_1cf98
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    lea     $24(a7), a7
    move.w  d0, d5
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    bra.b   l_1cfb6
l_1cf98:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr NopStub
    lea     $c(a7), a7
    move.w  d0, d5
l_1cfb6:
    cmpi.w  #$ff, d5
    beq.w   l_1d046
    cmp.w   d3, d5
    beq.w   l_1d046
    move.w  d5, d3
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF0130,a0
    tst.l   (a0,d0.w)
    beq.b   l_1d028
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041172).l
    jsr PrintfWide
    lea     $20(a7), a7
    bra.b   l_1d046
l_1d028:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0006).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_1d046:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RenderDisplayBuffer
    addq.l  #$8, a7
    bra.w   l_1ce56
l_1d05c:
    cmp.w   d2, d6
    beq.b   l_1d09c
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    lea     $1c(a7), a7
    bra.b   l_1d0ba
l_1d09c:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_1d0ba:
    move.w  d3, ($00FF9A1C).l
    movem.l (a7)+, d2-d6/a2
    rts
