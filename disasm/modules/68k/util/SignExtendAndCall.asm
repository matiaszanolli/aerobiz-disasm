; ============================================================================
; SignExtendAndCall -- Sign-extends the word argument to a long and calls ShowRouteInfo; a thin adapter shim
; 20 bytes | $017808-$01781B
; ============================================================================
SignExtendAndCall:
    move.l  $4(a7), d1
    move.w  d1, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRouteInfo
    addq.l  #$4, a7
    rts
