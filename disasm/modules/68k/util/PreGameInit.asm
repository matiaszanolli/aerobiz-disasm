; ============================================================================
; PreGameInit -- Clear display, fill work RAM, load VRAM map, configure DMA, initialize scroll modes
; 74 bytes | $005736-$00577F
; ============================================================================
PreGameInit:
    move.l  a2, -(a7)
    movea.l  #$00000D64,a2
    pea     ($000D).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($7000).w
    move.l  #$ff0000, -(a7)
    jsr MemFillWord
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  #$10000, -(a7)
    pea     ($0001).w
    pea     ($0007).w
    jsr     (a2)
    bsr.w ConfigDmaMode
    bsr.w InitScrollModes
    pea     ($000C).w
    jsr     (a2)
    lea     $28(a7), a7
    movea.l (a7)+, a2
    rts
