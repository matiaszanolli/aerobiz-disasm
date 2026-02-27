; ============================================================================
; ValidateMenuInput -- Main menu input validation loop: iterates until exit code 0x0B, dispatching each input to PrepareRelationPush (non-flagged entries) or ExecMenuCommand (flagged), refreshing the main menu after each action.
; 158 bytes | $01BB2E-$01BBCB
; ============================================================================
ValidateMenuInput:
    link    a6,#$0
    movem.l d2-d3/a2, -(a7)
    move.l  $8(a6), d3
    lea     $e(a6), a2
    clr.w   d2
    clr.w   ($00FF14B8).l
    bra.b   l_1bba0
l_1bb48:
    move.w  (a2), ($00FF9A1C).l
    move.w  d2, d0
    andi.l  #$8000, d0
    bne.b   l_1bb7a
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (PrepareRelationPush,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$b, d0
    beq.b   l_1bbc2
    move.w  ($00FF9A1C).l, (a2)
    bra.b   l_1bb94
l_1bb7a:
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ExecMenuCommand,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, (a2)
    andi.w  #$7fff, d2
l_1bb94:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    addq.l  #$4, a7
l_1bba0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     $e(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCharTrade,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$b, d0
    bne.b   l_1bb48
l_1bbc2:
    movem.l -$c(a6), d2-d3/a2
    unlk    a6
    rts
