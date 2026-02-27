; ============================================================================
; CmdSetBoundsAndClamp -- Store four X/Y min/max bounds, then re-clamp current coordinates to the new range
; 94 bytes | $000EBA-$000F17
; ============================================================================
CmdSetBoundsAndClamp:
    move.l  $e(a6), d2
    move.w  d2, $c52(a5)
    move.l  $12(a6), d2
    move.w  d2, $c54(a5)
    move.l  $16(a6), d2
    move.w  d2, $c56(a5)
    move.l  $1a(a6), d2
    move.w  d2, $c58(a5)
    move.w  $c5c(a5), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_00eea
    move.w  $c52(a5), d0
    bra.b   l_00ef4
l_00eea:
    cmp.w   $c56(a5), d0
    ble.b   l_00ef4
    move.w  $c56(a5), d0
l_00ef4:
    move.w  d0, $c5c(a5)
    move.w  $c5e(a5), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_00f08
    move.w  $c54(a5), d1
    bra.b   l_00f12
l_00f08:
    cmp.w   $c58(a5), d1
    ble.b   l_00f12
    move.w  $c58(a5), d1
l_00f12:
    move.w  d1, $c5e(a5)
    rts
