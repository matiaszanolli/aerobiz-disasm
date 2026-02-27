; ============================================================================
; ClearTileArea -- Fills the entire background plane with blank (space) tiles by calling GameCommand with $001A (fill-plane)
; Called: ?? times.
; 36 bytes | $03A9AC-$03A9CF
; ============================================================================
ClearTileArea:                                                  ; $03A9AC
    move.l  #$8000,-(sp)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    rts
; === Translated block $03A9D0-$03AAF4 ===
; 5 functions, 292 bytes
