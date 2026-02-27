; ============================================================================
; UpdateCharRelation -- Updates a character relation between two players: saves the mode flag, calls ShowGameScreen and ResourceUnload, polls an input loop rendering 6 or 4 relation slots (depending on char index) until the action button is pressed, then reloads resources and returns to the main menu.
; 250 bytes | $01C342-$01C43B
; ============================================================================
UpdateCharRelation:
    link    a6,#-$4
    movem.l d2-d7, -(a7)
    move.l  $10(a6), d2
    move.l  $8(a6), d7
    move.w  d2, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
    cmpi.w  #$20, d2
    bge.b   l_1c374
    moveq   #$6,d6
    bra.b   l_1c376
l_1c374:
    moveq   #$4,d6
l_1c376:
    move.w  #$e2, d5
    bra.b   l_1c3b8
l_1c37c:
    moveq   #$11,d4
    moveq   #$8,d3
    clr.w   d2
    bra.b   l_1c3a0
l_1c384:
    move.w  d2, d0
    ext.l   d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.b  (a0), d0
    addq.w  #$5, d3
    move.w  d3, d0
    cmpi.w  #$12, d0
    blt.b   l_1c39e
    addq.w  #$6, d4
    moveq   #$8,d3
l_1c39e:
    addq.w  #$1, d2
l_1c3a0:
    cmp.w   d6, d2
    blt.b   l_1c384
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    moveq   #$2,d0
    eor.w   d0, d5
l_1c3b8:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   l_1c37c
l_1c3ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   l_1c3ce
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    jsr ResourceUnload
    movem.l -$1c(a6), d2-d7
    unlk    a6
    rts
