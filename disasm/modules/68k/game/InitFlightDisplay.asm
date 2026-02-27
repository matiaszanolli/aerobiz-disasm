; ============================================================================
; InitFlightDisplay -- Loads the flight-path background graphic, initialises the scroll table, clears the sprite counter, and zeroes the flight-slot array at $FF153C
; Called: ?? times.
; 62 bytes | $01A60E-$01A64B
; ============================================================================
InitFlightDisplay:                                                  ; $01A60E
    pea     ($00049B26).l
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0560).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0048).w
    clr.l   -(sp)
    pea     ($00FF153C).l
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $0024(sp),sp
    rts
