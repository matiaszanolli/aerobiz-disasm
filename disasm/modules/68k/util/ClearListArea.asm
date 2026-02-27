; ============================================================================
; ClearListArea -- Clear the dialog/list display area via GameCommand $1A for a 10x17 region with priority flag.
; Called: ?? times.
; 40 bytes | $0237A8-$0237CF
; ============================================================================
ClearListArea:                                                  ; $0237A8
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($001D).w
    pea     ($0011).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; === Translated block $0237D0-$0238F0 ===
; 4 functions, 288 bytes
