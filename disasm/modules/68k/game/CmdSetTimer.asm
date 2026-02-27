; ============================================================================
; CmdSetTimer -- Initialize countdown timer from two longword args and return current elapsed count
; 32 bytes | $000D04-$000D23
; ============================================================================
CmdSetTimer:
    move.l  $e(a6), d0
    beq.b   l_00d1e
    move.l  $16(a6), d0
    swap    d0
    or.l    $12(a6), d0
    move.l  d0, $be4(a5)
    moveq   #$0,d0
    move.l  d0, $be8(a5)
l_00d1e:
    move.l  $be8(a5), d0
    rts
