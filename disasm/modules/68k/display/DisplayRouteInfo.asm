; ============================================================================
; DisplayRouteInfo -- Decompress and place the character's portrait tile and framing border in the route info panel.
; 160 bytes | $020F52-$020FF1
; ============================================================================
DisplayRouteInfo:
    movem.l d2-d3, -(a7)
    move.l  $c(a7), d2
    move.l  $10(a7), d3
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr GetCharStat
    move.w  d0, d2
    move.l  ($000A1AF4).l, -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    pea     ($0006).w
    pea     ($01DB).w
    move.w  d2, d0
    mulu.w  #$6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF899C,a0
    pea     (a0, d0.w)
    jsr CmdPlaceTile
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0007).w
    pea     ($00D8).w
    pea     ($003A).w
    pea     ($01DB).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    movem.l (a7)+, d2-d3
    rts
