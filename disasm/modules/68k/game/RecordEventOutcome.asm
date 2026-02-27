; ============================================================================
; RecordEventOutcome -- Draws a filled rectangle using GameCommand, adjusting the passed coordinates by column+2 and row-1; a display utility for event result frames
; 72 bytes | $017C9E-$017CE5
; ============================================================================
RecordEventOutcome:
    movem.l d2-d4, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    move.l  $14(a7), d4
    move.l  $10(a7), d1
    clr.l   -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d1, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d4
    rts
