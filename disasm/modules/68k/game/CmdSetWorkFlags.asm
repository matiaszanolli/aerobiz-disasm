; ============================================================================
; CmdSetWorkFlags -- Store two word values into scroll work-RAM shadow registers $38 and $3A
; 18 bytes | $000A50-$000A61
; ============================================================================
CmdSetWorkFlags:
    move.l  $e(a6), d0
    move.w  d0, $38(a5)
    move.l  $12(a6), d0
    move.w  d0, $3a(a5)
    rts
