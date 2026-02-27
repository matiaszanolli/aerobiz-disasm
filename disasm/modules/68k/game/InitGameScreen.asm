; ============================================================================
; InitGameScreen -- Loads game graphics, resets state, initialises tile buffer and text window, then renders all 20 text blocks of the scenario intro narrative with pause prompts between sections
; 232 bytes | $03BC36-$03BD1D
; ============================================================================
InitGameScreen:
    move.l  d2, -(a7)
    jsr LoadGameGraphics
    jsr ResetGameState
    jsr InitTileBuffer
    move.w  #$1, ($00FFA7DC).l
    pea     ($0010).w
    clr.l   -(a7)
    pea     ($0007651E).l
    jsr DisplaySetup
    pea     ($001A).w
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextWindow
    clr.w   ($00FF1800).l
    moveq   #$1,d0
    move.w  d0, ($00FFA77A).l
    move.w  d0, ($00FF99DE).l
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextCursor
    lea     $24(a7), a7
    clr.w   d2
l_3bca2:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00048DB0,a0
    move.l  (a0,d0.w), -(a7)
    jsr RenderTextBlock
    addq.l  #$4, a7
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$6,d1
    cmp.w   d1, d0
    beq.b   l_3bcce
    moveq   #$D,d1
    cmp.w   d1, d0
    beq.b   l_3bcce
    moveq   #$13,d1
    cmp.w   d1, d0
    bne.b   l_3bd12
l_3bcce:
    jsr ResourceUnload
    pea     ($00F0).w
    bsr.w DelayWithInputCheck
    jsr ResourceLoad
    move.l  #$8000, -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextCursor
    lea     $28(a7), a7
l_3bd12:
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    bcs.b   l_3bca2
    move.l  (a7)+, d2
    rts
