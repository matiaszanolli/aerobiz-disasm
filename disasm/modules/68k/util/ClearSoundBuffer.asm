; ============================================================================
; ClearSoundBuffer -- Stops sound playback (GameCommand $0D), reloads the VDP tile font from ROM, and re-enables display (GameCommand $0C)
; 42 bytes | $03B340-$03B369
; ============================================================================
ClearSoundBuffer:
    pea     ($000D).w
    jsr GameCommand
    move.l  ($000AF190).l, -(a7)
    pea     ($4000).w
    jsr DecompressVDPTiles
    pea     ($000C).w
    jsr GameCommand
    lea     $10(a7), a7
    rts
