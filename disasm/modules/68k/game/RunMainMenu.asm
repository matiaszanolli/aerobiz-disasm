; ============================================================================
; RunMainMenu -- Renders the main menu screen for a given player: clears the background, draws two header tile rows, calls RenderDisplayBuffer to populate the display, then calls ShowPlayerInfo.
; 134 bytes | $01B91A-$01B99F
; ============================================================================
RunMainMenu:
    link    a6,#-$4
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d2
    move.w  ($00FF9A1C).l, d3
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $20(a7), a7
    pea     ($077D).w
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderDisplayBuffer,PC)
    nop
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    movem.l -$c(a6), d2-d3
    unlk    a6
    rts
