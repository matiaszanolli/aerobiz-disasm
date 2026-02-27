; ============================================================================
; CmdReadInput -- Read controller buttons (current + previous) for player 1 or 2 from input tables
; 76 bytes | $00060C-$000657
; ============================================================================
CmdReadInput:
    move.l  $e(a6), d2
    andi.l  #$1, d2
    moveq   #$0,d0
    movea.l  #$00FFFC06,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_00634
    move.b  $4(a0, d2.w), d0
    asl.l   #$8, d0
    andi.l  #$ff00, d0
    move.b  $2(a0, d2.w), d0
l_00634:
    moveq   #$0,d1
    movea.l  #$00FFFC2E,a0
    cmpi.w  #$1, (a0)
    bhi.b   l_00652
    move.b  $4(a0, d2.w), d1
    asl.l   #$8, d1
    andi.l  #$ff00, d1
    move.b  $2(a0, d2.w), d1
l_00652:
    swap    d1
    or.l    d1, d0
    rts
