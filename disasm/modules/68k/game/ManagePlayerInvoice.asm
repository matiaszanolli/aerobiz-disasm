; ============================================================================
; ManagePlayerInvoice -- Handles the loan-invoice screen for one player: shows the invoice dialog with repayment options; accepting reduces the active-player count, and if the sole survivor is refusing triggers game-over.
; 460 bytes | $0278D8-$027AA3
; ============================================================================
ManagePlayerInvoice:
    link    a6,#-$C4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d2
    lea     -$c0(a6), a3
    movea.l  #$00027ACA,a4
    movea.l  #$00007912,a5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   (a2)
    bne.b   l_27918
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    bra.w   l_27a9a
l_27918:
    move.b  ($00FF0016).l, d4
    move.b  d2, ($00FF0016).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    pea     ($0013).w
    jsr MenuSelectEntry
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0018).w
    jsr LoadCompressedGfx
    jsr ResourceUnload
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$4, d0
    move.l  d0, d3
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00041718).l
    move.l  a3, -(a7)
    jsr sprintf
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($000416EC).l
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $28(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_27a4c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    jsr ResourceLoad
    pea     ($0004).w
    pea     ($000A).w
    pea     ($0019).w
    jsr LoadCompressedGfx
    jsr ResourceUnload
    movea.l  #$00FF00A8,a0
    pea     (a0, d3.w)
    pea     ($000416D4).l
    move.l  a3, -(a7)
    jsr sprintf
    lea     $24(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $14(a7), a7
    bra.b   l_27a8e
l_27a4c:
    jsr (CountActivePlayers,PC)
    nop
    cmpi.w  #$1, d0
    bls.b   l_27a6c
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr     (a4)
    addq.l  #$4, a7
    clr.b   (a2)
    subq.w  #$1, ($00FF0A34).l
    bra.b   l_27a8e
l_27a6c:
    clr.w   -$c2(a6)
    pea     ($0001).w
    clr.l   -(a7)
    pea     -$c2(a6)
    jsr DisplaySetup
    jsr PreLoopInit
    clr.l   -(a7)
    jsr GameSetup1
l_27a8e:
    jsr PreLoopInit
    move.b  d4, ($00FF0016).l
l_27a9a:
    movem.l -$e0(a6), d2-d4/a2-a5
    unlk    a6
    rts
