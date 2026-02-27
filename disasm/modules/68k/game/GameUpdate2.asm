; ============================================================================
; GameUpdate2 -- Main per-turn update loop: selects active player order, iterates all four players running their menu or AI strategy, manages resource load/unload, shows relation panels and player info, and handles scenario events and post-turn screen transitions.
; 1152 bytes | $01B49A-$01B919
; ============================================================================
GameUpdate2:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0016,a5
    clr.w   d5
    move.w  #$80, ($00FFBD64).l
    move.w  #$80, ($00FFBD66).l
    tst.w   ($00FF17C4).l
    bne.b   l_1b4c8
    jsr RunEventSequence
l_1b4c8:
    tst.w   ($00FF17C4).l
    bne.b   l_1b52e
    move.w  #$fffe, ($00FF0A32).l
    jsr RunScenarioMenu
    jsr ResourceUnload
    clr.w   d2
    clr.w   d3
    bra.b   l_1b524
l_1b4ea:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.b  d0, (a5)
    moveq   #$0,d0
    move.b  (a5), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    and.l   d1, d0
    bne.b   l_1b524
    moveq   #$0,d0
    move.b  (a5), d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    or.w    d0, d3
    movea.l  #$00FF0012,a0
    move.b  (a5), (a0,d2.w)
    addq.w  #$1, d2
l_1b524:
    cmpi.w  #$4, d2
    blt.b   l_1b4ea
    clr.w   d2
    bra.b   l_1b544
l_1b52e:
    clr.w   d2
    move.b  (a5), d3
    bra.b   l_1b536
l_1b534:
    addq.w  #$1, d2
l_1b536:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), d0
    cmp.b   d3, d0
    bne.b   l_1b534
l_1b544:
    clr.w   ($00FF9A1C).l
    move.w  -$2(a6), d4
    lea     -$2(a6), a4
    bra.w   l_1b892
l_1b556:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), (a5)
    moveq   #$0,d0
    move.b  (a5), d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    cmpi.w  #$7, ($00FF9A1C).l
    beq.w   l_1b62a
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.b  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    pea     ($0007).w
    jsr SelectMenuItem
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    lea     $30(a7), a7
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    lea     $10(a7), a7
    move.w  #$7, ($00FF9A1C).l
    jsr ResourceUnload
    bra.w   l_1b7a6
l_1b62a:
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.b  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    lea     $28(a7), a7
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    lea     $10(a7), a7
    jsr ResourceUnload
    cmpi.b  #$1, (a3)
    bne.w   l_1b7a6
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_1b6d2:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    addq.w  #$1, d3
    cmpi.w  #$5, d3
    blt.b   l_1b6d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $10(a7), a7
l_1b7a6:
    tst.w   ($00FF17C4).l
    bne.b   l_1b7c6
    jsr RunAITurn
    cmpi.w  #$ffff, ($00FF0A32).l
    beq.b   l_1b7cc
    jsr RunScenarioMenu
    bra.b   l_1b7cc
l_1b7c6:
    jsr PreLoopInit
l_1b7cc:
    cmpi.b  #$1, (a3)
    bne.w   l_1b864
    jsr ResourceLoad
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, ($00FF9A1C).l
    ext.l   d0
    move.l  d0, -(a7)
    jsr SelectMenuItem
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunMainMenu,PC)
    nop
    jsr ResourceUnload
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ValidateMenuInput,PC)
    nop
    lea     $2c(a7), a7
    moveq   #$1,d5
    bra.b   l_1b88a
l_1b864:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    jsr RunAIStrategy
    pea     ($003C).w
    jsr PollInputChange
    lea     $10(a7), a7
    clr.w   d5
l_1b88a:
    clr.w   ($00FF17C4).l
    addq.w  #$1, d2
l_1b892:
    cmpi.w  #$4, d2
    blt.w   l_1b556
    move.w  d4, -$2(a6)
    cmpi.w  #$1, d5
    bne.b   l_1b900
    jsr ResourceLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0007).w
    jsr SelectMenuItem
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $30(a7), a7
    jsr ResourceUnload
    bra.b   l_1b910
l_1b900:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
l_1b910:
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts
