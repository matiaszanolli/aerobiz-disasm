; ============================================================================
; CalcScalar -- Calls GameCommand($1A, 0, 0, 0, $20, $20, mode_arg) to configure a background-layer scalar; a thin wrapper that pushes fixed arguments plus one variable arg from the caller's frame.
; 34 bytes | $01DE30-$01DE51
; ============================================================================
CalcScalar:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($001A).w
    jsr GameCommand
    unlk    a6
    rts
