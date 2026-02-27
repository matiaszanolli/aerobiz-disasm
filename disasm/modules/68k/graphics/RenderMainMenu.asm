; ============================================================================
; RenderMainMenu -- Renders the main title-screen menu: loads title graphics, displays menu option text blocks, and calls WaitForStartButton for the menu selection
; 268 bytes | $03C942-$03CA4D
; ============================================================================
RenderMainMenu:
    movem.l a2-a3, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$0003B994,a3
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr DisplaySetup
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076FF6).l
    jsr DisplaySetup
    move.l  ($000B754C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($01A0).w
    pea     ($0400).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $2c(a7), a7
    pea     ($000760A6).l
    pea     ($0008).w
    pea     ($001A).w
    pea     ($0003).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00076246).l
    pea     ($0006).w
    pea     ($001A).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00075F8E).l
    pea     ($0004).w
    pea     ($001B).w
    pea     ($000F).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    jsr ResourceUnload
    pea     ($0080).w
    jsr     (a3)
    lea     $20(a7), a7
    pea     ($00076066).l
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    movem.l (a7)+, a2-a3
    rts
