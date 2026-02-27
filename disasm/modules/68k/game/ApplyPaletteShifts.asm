; ============================================================================
; ApplyPaletteShifts -- Load tiles via GameCommand, apply palette index shift to each entry, then flush
; 182 bytes | $004A66-$004B1B
; ============================================================================
ApplyPaletteShifts:
    link    a6,#-$800
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $1c(a6), d3
    move.l  $18(a6), d4
    move.l  $14(a6), d5
    move.l  $10(a6), d6
    move.l  $c(a6), d7
    lea     -$800(a6), a3
    andi.w  #$3, d3
    moveq   #$D,d0
    lsl.w   d0, d3
    movea.l a3, a2
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    pea     ($001C).w
    jsr GameCommand
    lea     $1c(a7), a7
    clr.w   d2
    bra.b   l_04ad0
l_04ac4:
    move.w  (a2), d0
    andi.w  #$9fff, d0
    add.w   d3, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
l_04ad0:
    moveq   #$0,d0
    move.w  d5, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_04ac4
    move.l  a3, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    pea     ($001B).w
    jsr GameCommand
    movem.l -$820(a6), d2-d7/a2-a3
    unlk    a6
    rts
