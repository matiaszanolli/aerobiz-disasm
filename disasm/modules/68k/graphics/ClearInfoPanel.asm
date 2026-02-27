; ============================================================================
; ClearInfoPanel -- Clear info panel area with priority flag via GameCommand #$1A
; Called: 11 times.
; 40 bytes | $023930-$023957
; ============================================================================
ClearInfoPanel:                                                  ; $023930
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($000C).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
