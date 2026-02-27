; ============================================================================
; CalcCharDisplayIndex -- computes tile column and row for a character portrait and calls LoadTileGraphics
; 88 bytes | $010CB0-$010D07
; ============================================================================
CalcCharDisplayIndex:
    move.l  $18(a7), d2
    move.l  $14(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d2, d0
    mulu.w  #$1e, d0
    addi.w  #$560, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    mulu.w  #$a, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FF03B8,a0
    move.w  (a0,d0.w), d1
    move.l  d1, -(a7)
    jsr LoadTileGraphics
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d5
    rts
