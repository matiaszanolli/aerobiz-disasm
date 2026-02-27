; ============================================================================
; ClearBothPlanes -- Clear both scroll planes via GameCommand #$1A
; Called: 15 times.
; 64 bytes | $00814A-$008189
; ============================================================================
ClearBothPlanes:                                                  ; $00814A
    clr.l   -(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    clr.l   -(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
