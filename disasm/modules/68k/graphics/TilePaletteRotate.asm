; ============================================================================
; TilePaletteRotate -- Place tile block via cmd 5 then fill sequential tile indices in one call
; 74 bytes | $00475A-$0047A3
; ============================================================================
TilePaletteRotate:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $24(a7), d2
    move.l  $20(a7), d3
    move.l  $2c(a7), d4
    move.l  $28(a7), d5
    movea.l $30(a7), a2
    movea.l $1c(a7), a3
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  a3, -(a7)
    bsr.w CmdPlaceTile
    move.l  a2, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w FillTileSequence
    lea     $20(a7), a7
    movem.l (a7)+, d2-d5/a2-a3
    rts
