; ============================================================================
; BuildPaletteWord -- Build BAT attribute word from palette and flip args, load tiles, write to output buffer
; 96 bytes | $004828-$004887
; ============================================================================
BuildPaletteWord:
    link    a6,#$0
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a6), d2
    move.l  $10(a6), d3
    move.l  $c(a6), d4
    movea.l $1c(a6), a2
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.l  $8(a6), -(a7)
    bsr.w LoadPaletteDataTile
    clr.w   (a2)+
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0004734C,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    add.w   d1, d1
    movea.l  #$00047354,a0
    or.w    (a0,d1.w), d0
    andi.l  #$ffff, d0
    move.w  d0, (a2)+
    move.w  d4, (a2)+
    clr.w   (a2)
    movem.l -$10(a6), d2-d4/a2
    unlk    a6
    rts
