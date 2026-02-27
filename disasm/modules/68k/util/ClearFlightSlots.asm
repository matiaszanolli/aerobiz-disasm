; ============================================================================
; ClearFlightSlots -- Clears the sprite count register and zeroes the flight-slot array at $FF153C; a subset of InitFlightDisplay used for mid-screen resets
; 38 bytes | $01A64C-$01A671
; ============================================================================
ClearFlightSlots:                                                  ; $01A64C
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0048).w
    clr.l   -(sp)
    pea     ($00FF153C).l
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $0014(sp),sp
    rts
