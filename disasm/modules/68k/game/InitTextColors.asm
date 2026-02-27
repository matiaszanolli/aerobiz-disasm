; ============================================================================
; InitTextColors -- Initialises the text color palette entries in RAM and uploads two CRAM palette rows (normal and inverted) to the VDP via GameCommand $05/$08
; 164 bytes | $03B29C-$03B33F
; ============================================================================
InitTextColors:
    link    a6,#-$4
    movem.l d2-d3/a2, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    lea     -$4(a6), a2
    move.w  d2, d0
    move.w  d0, ($00FFA782).l
    move.w  d0, ($00FFA786).l
    move.w  d2, d0
    andi.w  #$3ff, d0
    move.w  d0, -$4(a6)
    move.w  d2, d0
    andi.w  #$3ff, d0
    add.w   ($00FFA780).l, d0
    move.w  d0, $2(a2)
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    move.w  d3, d0
    move.w  d0, ($00FFA784).l
    move.w  d0, ($00FFA788).l
    move.w  d3, d0
    neg.w   d0
    andi.w  #$3ff, d0
    move.w  d0, $2(a2)
    move.w  d0, -$4(a6)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    moveq   #$0,d0
    move.w  ($00FFA78A).l, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0008).w
    jsr GameCommand
    movem.l -$10(a6), d2-d3/a2
    unlk    a6
    rts
