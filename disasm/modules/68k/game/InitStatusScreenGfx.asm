; ============================================================================
; InitStatusScreenGfx -- Loads and uploads all status-screen background graphics to VRAM: decompresses character stat tiles, city icons, and panel tilesets; sets up scroll quadrant and clears planes
; 448 bytes | $03CBEC-$03CDAB
; ============================================================================
InitStatusScreenGfx:
    movem.l a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00003FEC,a4
    jsr ResourceLoad
    pea     ($0010).w
    pea     ($0013).w
    jsr     (a2)
    move.l  #$9010, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    pea     ($0001).w
    clr.l   -(a7)
    jsr SetScrollQuadrant
    clr.l   -(a7)
    clr.l   -(a7)
    jsr (QueueVRAMWriteAddr,PC)
    nop
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    pea     ($000543E2).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($12F0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($00054F82).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($2600).w
    move.l  a3, -(a7)
    pea     ($1470).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($00050006).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($4EE0).w
    move.l  a3, -(a7)
    pea     ($13E0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($0030).w
    pea     ($0010).w
    pea     ($00053482).l
    jsr DisplaySetup
    lea     $24(a7), a7
    pea     ($000534E2).l
    pea     ($001E).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00053C62).l
    pea     ($001E).w
    pea     ($0020).w
    pea     ($001E).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00064140).l
    pea     ($000E).w
    pea     ($0020).w
    pea     ($002E).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($76A0).w
    pea     ($00055C54).l
    pea     ($06C0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $18(a7), a7
    movem.l (a7)+, a2-a4
    rts
