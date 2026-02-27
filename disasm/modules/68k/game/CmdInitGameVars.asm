; ============================================================================
; CmdInitGameVars -- Clear and initialize three game state variables at $FFC46-$FFC4C from args
; 40 bytes | $000D3C-$000D63
; ============================================================================
CmdInitGameVars:
    moveq   #$0,d0
    move.b  d0, $c46(a5)
    move.l  d0, $c48(a5)
    move.l  d0, $c4c(a5)
    move.l  $12(a6), d0
    move.l  d0, $c48(a5)
    move.l  $16(a6), d0
    move.l  d0, $c4c(a5)
    move.l  $e(a6), d0
    move.b  d0, $c46(a5)
    rts
