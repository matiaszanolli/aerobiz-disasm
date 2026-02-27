; ============================================================================
; DisplayPlayerLeaderboard -- Shows the end-game leaderboard sequence for a winning player: clears the screen, loads the winner's graphic, presents rank dialog boxes for all four players with final standings, then restores the play screen.
; 444 bytes | $02771C-$0278D7
; ============================================================================
DisplayPlayerLeaderboard:
    link    a6,#-$C8
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    lea     -$a0(a6), a3
    movea.l  #$0003B22C,a4
    movea.l  #$000482D8,a5
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.b  #$1, (a2)
    bne.w   l_278bc
    jsr ClearBothPlanes
    move.w  #$1, ($00FF000A).l
    move.w  #$1, ($00FF0008).l
    move.w  #$1, ($00FF000C).l
    move.w  #$1, ($00FF000E).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    lea     $24(a7), a7
    jsr ResourceUnload
    cmpi.w  #$7, d3
    bcs.b   l_277ca
    pea     ($000416D0).l
    bra.b   l_277e2
l_277ca:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  $1c(a5), -(a7)
    pea     -$c8(a6)
    jsr     (a4)
    lea     $c(a7), a7
    pea     -$c8(a6)
l_277e2:
    move.l  ($000482D8).l, -(a7)
    move.l  a3, -(a7)
    jsr     (a4)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    clr.w   d3
    moveq   #$1,d2
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    bra.b   l_27876
l_2781a:
    move.w  d2, d0
    andi.w  #$1, d0
    beq.b   l_27836
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  (a2), -(a7)
    bra.b   l_27860
l_27836:
    move.w  d4, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    move.l  (a2), -(a7)
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
l_27860:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    addq.l  #$4, a2
    addq.w  #$1, d3
    addq.w  #$1, d2
l_27876:
    cmpi.w  #$4, d3
    blt.b   l_2781a
    moveq   #$5,d2
l_2787e:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_2787e
    pea     ($0014).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_278bc:
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr ShowPlayerScreen
    movem.l -$e4(a6), d2-d4/a2-a5
    unlk    a6
    rts
