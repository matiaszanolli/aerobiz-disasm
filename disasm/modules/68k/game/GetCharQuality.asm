; ============================================================================
; GetCharQuality -- Returns count of player resource entries that exceed a char's stats (higher = lower quality)
; 80 bytes | $034172-$0341C1
; ============================================================================
GetCharQuality:
    movem.l d2-d6, -(a7)
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    clr.w   d3
    clr.w   d2
l_34182:
    move.w  d2, d0
    mulu.w  #$1c, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF1004,a0
    move.l  (a0,d0.w), d0
    move.w  d5, d1
    mulu.w  #$1c, d1
    move.w  d4, d6
    lsl.w   #$2, d6
    add.w   d6, d1
    movea.l  #$00FF1004,a0
    cmp.l   (a0,d1.w), d0
    bcs.b   l_341b2
    addq.w  #$1, d3
l_341b2:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_34182
    move.w  d3, d0
    movem.l (a7)+, d2-d6
    rts
