; ============================================================================
; RenderPlayerStatusUI -- Loads and uploads the complete player-status panel graphics: background frames, stat bar icons, name/profit tilesets, and aircraft icon tiles to VRAM
; 476 bytes | $03D278-$03D453
; ============================================================================
RenderPlayerStatusUI:
    movem.l a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF1804,a3
    movea.l  #$00003FEC,a4
    jsr ResourceLoad
    move.l  #$9000, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetScrollQuadrant
    clr.l   -(a7)
    clr.l   -(a7)
    bsr.w QueueVRAMWriteAddr
    pea     ($000635D0).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($0020).w
    move.l  a3, -(a7)
    pea     ($0590).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($00063CF4).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0B40).w
    move.l  a3, -(a7)
    pea     ($00D0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($00063E36).l
    move.l  a3, -(a7)
    jsr     (a4)
    lea     $28(a7), a7
    clr.l   -(a7)
    pea     ($0CE0).w
    move.l  a3, -(a7)
    pea     ($0340).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    pea     ($00063350).l
    pea     ($000A).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($000638F4).l
    pea     ($0010).w
    pea     ($0020).w
    pea     ($000A).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($00063D36).l
    pea     ($0004).w
    pea     ($0020).w
    pea     ($0018).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    lea     $1c(a7), a7
    clr.l   -(a7)
    pea     ($4040).w
    pea     ($00059794).l
    pea     ($19D0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    pea     ($000A).w
    pea     ($000E).w
    jsr     (a2)
    lea     $20(a7), a7
    clr.l   -(a7)
    pea     ($1360).w
    pea     ($0005CBB4).l
    pea     ($06C0).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($20E0).w
    pea     ($0005D934).l
    pea     ($0480).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $30(a7), a7
    clr.l   -(a7)
    pea     ($29E0).w
    pea     ($00051522).l
    pea     ($0210).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    clr.l   -(a7)
    pea     ($2E00).w
    pea     ($0006541E).l
    pea     ($0210).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a2)
    lea     $30(a7), a7
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00063330).l
    jsr DisplaySetup
    lea     $c(a7), a7
    movem.l (a7)+, a2-a4
    rts
