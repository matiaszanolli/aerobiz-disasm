; ============================================================================
; ClearDisplayBuffers -- Clear both VDP scroll planes, then reload map tiles and game graphics
; 88 bytes | $00D500-$00D557
; ============================================================================
ClearDisplayBuffers:
    pea     ($0040).w
    clr.l   -(a7)
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    jsr LoadMapTiles
    jsr LoadGameGraphics
    rts
