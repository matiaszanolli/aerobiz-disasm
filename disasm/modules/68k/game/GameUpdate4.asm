; ============================================================================
; GameUpdate4 -- Orchestrates an end-of-month update: calls CalculatePlayerWealth, CalcPlayerRankings, UpdatePlayerStatusDisplay, UpdatePlayerHealthBars, checks for game-win every fourth turn, and processes invoices for each player.
; 128 bytes | $026128-$0261A7
; ============================================================================
GameUpdate4:
    movem.l d2/a2, -(a7)
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    lea     $c(a7), a7
    jsr (CalculatePlayerWealth,PC)
    nop
    jsr (CalcPlayerRankings,PC)
    nop
    jsr (UpdatePlayerStatusDisplay,PC)
    nop
    jsr (UpdatePlayerHealthBars,PC)
    nop
    movea.l  #$00FF0018,a2
    clr.w   d2
.l26160:
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    tst.l   d0
    bne.b   .l2617a
    jsr (CheckDisplayGameWin,PC)
    nop
.l2617a:
    cmpi.b  #$60, $22(a2)
    bhi.b   .l26190
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ManagePlayerInvoice,PC)
    nop
    addq.l  #$4, a7
.l26190:
    moveq   #$24,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   .l26160
    jsr ResourceLoad
    movem.l (a7)+, d2/a2
    rts
