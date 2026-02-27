; ============================================================================
; CmdGetCoords -- Read clamped X and Y coordinate words from work RAM into caller-provided pointer slots
; 24 bytes | $000E92-$000EA9
; ============================================================================
CmdGetCoords:
    moveq   #$0,d2
    movea.l $e(a6), a2
    move.w  $c5c(a5), d2
    move.l  d2, (a2)
    movea.l $12(a6), a2
    move.w  $c5e(a5), d2
    move.l  d2, (a2)
    rts
