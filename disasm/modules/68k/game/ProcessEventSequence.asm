; ============================================================================
; ProcessEventSequence -- Prints the three company/player names into a fixed text window at successive cursor rows; a display-only routine with no input
; 96 bytes | $017B0A-$017B69
; ============================================================================
ProcessEventSequence:
    movem.l d2-d3, -(a7)
    pea     ($0006).w
    pea     ($000A).w
    pea     ($0005).w
    pea     ($000B).w
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d2
l_17b2a:
    move.w  d2, d3
    ext.l   d3
    add.l   d3, d3
    addq.l  #$5, d3
    move.l  d3, -(a7)
    pea     ($000C).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F9B0).l
    jsr PrintfWide
    lea     $10(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_17b2a
    movem.l (a7)+, d2-d3
    rts
