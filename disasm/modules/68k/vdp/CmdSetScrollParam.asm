; ============================================================================
; CmdSetScrollParam -- Store one word to work RAM scroll parameter register $C5A
; 10 bytes | $000F18-$000F21
; ============================================================================
CmdSetScrollParam:
    move.l  $e(a6), d2
    move.w  d2, $c5a(a5)
    rts
