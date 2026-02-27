; ============================================================================
; CmdSetCharState -- Update character animation state flags and timer registers in work RAM
; 26 bytes | $000B28-$000B41
; ============================================================================
CmdSetCharState:
    move.l  $e(a6), d0
    move.b  d0, $2fb(a5)
    move.l  $12(a6), d0
    move.w  d0, $304(a5)
    move.l  $16(a6), d0
    move.w  d0, $300(a5)
    rts
