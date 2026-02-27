; ============================================================================
; CmdClampCoords -- Clamp two input coordinates to stored min/max bounds and save results to work RAM
; 62 bytes | $000E54-$000E91
; ============================================================================
CmdClampCoords:
    move.l  $e(a6), d0
    cmp.w   $c52(a5), d0
    bgt.b   l_00e64
    move.w  $c52(a5), d0
    bra.b   l_00e6e
l_00e64:
    cmp.w   $c56(a5), d0
    ble.b   l_00e6e
    move.w  $c56(a5), d0
l_00e6e:
    move.w  d0, $c5c(a5)
    move.l  $12(a6), d1
    cmp.w   $c54(a5), d1
    bgt.b   l_00e82
    move.w  $c54(a5), d1
    bra.b   l_00e8c
l_00e82:
    cmp.w   $c58(a5), d1
    ble.b   l_00e8c
    move.w  $c58(a5), d1
l_00e8c:
    move.w  d1, $c5e(a5)
    rts
