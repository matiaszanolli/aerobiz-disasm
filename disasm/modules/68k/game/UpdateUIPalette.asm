; ============================================================================
; UpdateUIPalette -- Updates a single player/slot palette entry: given player index (D6), slot index (D7), and a revenue value (D3), resolves the player's airline record ($FF0018), the route entry ($FF9A20), and the capacity table ($FFB4E4), then stores the scaled colour value into the route's palette slot.
; 98 bytes | $01FF9E-$01FFFF
; ============================================================================
UpdateUIPalette:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.w  d6, d0
    mulu.w  #$320, d0
    move.w  d7, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    mulu.w  #$140, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
