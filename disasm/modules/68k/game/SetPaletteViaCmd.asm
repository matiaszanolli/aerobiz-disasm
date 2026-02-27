; ============================================================================
; SetPaletteViaCmd -- Write palette data to CRAM via GameCommand(8, 2) with VRAM base offset
; 74 bytes | $004888-$0048D1
; ============================================================================
SetPaletteViaCmd:
    movem.l d2-d3, -(a7)
    move.l  $10(a7), d2
    move.l  $c(a7), d3
    movea.l $14(a7), a0
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    lsl.l   #$2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    moveq   #$0,d1
    move.w  ($00FFA778).l, d1
    add.l   d1, d0
    move.l  d0, -(a7)
    move.l  a0, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d3
    rts
