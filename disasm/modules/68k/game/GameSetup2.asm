; ============================================================================
; GameSetup2 -- Top-level new-game setup loop: plays the intro (RunIntroLoop or LoadMapGraphics), shows ending credits or main menu based on outcome, then waits for Start button and initialises display mode
; 232 bytes | $03CA4E-$03CB35
; ============================================================================
GameSetup2:
    movem.l d2/a2-a4, -(a7)
    movea.l  #$00FFA78E,a2
    movea.l  #$0001E1EC,a3
    movea.l  #$000053BA,a4
    clr.w   (a2)
    moveq   #$1,d2
l_3ca68:
    pea     ($0001).w
    clr.l   -(a7)
    jsr SetScrollQuadrant
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$ffff, -(a7)
    bsr.w UpdateScrollRegisters
    lea     $14(a7), a7
    jsr     (a4)
    bsr.w InitGameScreen
    tst.w   (a2)
    beq.b   l_3ca9e
    clr.l   -(a7)
    clr.l   -(a7)
    jsr MenuSelectEntry
    addq.l  #$8, a7
    bra.b   l_3cab0
l_3ca9e:
    bsr.w RunIntroLoop
    tst.w   (a2)
    bne.b   l_3cab0
    bsr.w LoadMapGraphics
    clr.w   d2
    tst.w   d2
    bne.b   l_3ca68
l_3cab0:
    tst.w   (a2)
    bne.b   l_3caba
    bsr.w RenderEndingCredits
    bra.b   l_3cabe
l_3caba:
    bsr.w RenderMainMenu
l_3cabe:
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    andi.w  #$80, d0
    bne.b   l_3cabe
    bra.b   l_3cb02
l_3cacc:
    jsr RefreshAndWait
    tst.w   d0
    bne.b   l_3caf2
    clr.l   -(a7)
    jsr SetDisplayMode
    jsr ResourceLoad
    jsr     (a4)
    pea     ($001E).w
    jsr GameCommand
    addq.l  #$8, a7
l_3caf2:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_3cb02:
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$4, a7
    move.w  d0, d2
    andi.w  #$80, d0
    beq.b   l_3cacc
    jsr ResourceLoad
    clr.l   -(a7)
    jsr SetDisplayMode
    jsr     (a4)
    pea     ($0003).w
    clr.l   -(a7)
    jsr SetScrollQuadrant
    lea     $c(a7), a7
    movem.l (a7)+, d2/a2-a4
    rts
