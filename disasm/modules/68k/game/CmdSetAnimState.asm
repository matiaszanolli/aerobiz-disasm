; ============================================================================
; CmdSetAnimState -- Set animation mode and base address in work RAM, resetting current frame index
; 24 bytes | $000CEC-$000D03
; ============================================================================
CmdSetAnimState:
    moveq   #$0,d0
    move.w  d0, $bce(a5)
    move.l  $12(a6), d0
    move.l  d0, $bd0(a5)
    move.l  $e(a6), d0
    move.w  d0, $bce(a5)
    rts
