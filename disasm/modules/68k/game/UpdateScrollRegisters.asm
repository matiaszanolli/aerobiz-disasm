; ============================================================================
; UpdateScrollRegisters -- Updates the VDP horizontal and vertical scroll registers for planes A and B based on the given scroll offsets (clamped to tile dimensions), then uploads new CRAM palette row
; 250 bytes | $03BB3C-$03BC35
; ============================================================================
UpdateScrollRegisters:
    link    a6,#-$4
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $10(a6), d3
    lea     -$4(a6), a2
    movea.l  #$00FFA786,a3
    movea.l  #$00FFA788,a4
    movea.l  #$00FFA782,a5
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.w  ($00FFA77E).l, d1
    lsl.l   #$3, d1
    jsr SignedMod
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.w  ($00FFA77C).l, d1
    lsl.l   #$3, d1
    jsr SignedMod
    move.w  d0, d3
    moveq   #$0,d0
    move.w  $a(a6), d0
    beq.b   l_3bb9e
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_3bba4
    bra.b   l_3bbae
l_3bb9e:
    move.w  d2, (a4)
    move.w  d3, (a3)
    bra.b   l_3bbbe
l_3bba4:
    move.w  d2, ($00FFA784).l
    move.w  d3, (a5)
    bra.b   l_3bbbe
l_3bbae:
    move.w  d2, d0
    move.w  d0, ($00FFA784).l
    move.w  d0, (a4)
    move.w  d3, d0
    move.w  d0, (a5)
    move.w  d0, (a3)
l_3bbbe:
    move.w  (a3), -$4(a6)
    move.w  ($00FFA780).l, d0
    add.w   (a5), d0
    move.w  d0, $2(a2)
    pea     ($0002).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    moveq   #$0,d0
    move.w  ($00FFA77E).l, d0
    lsl.l   #$3, d0
    move.l  d0, d2
    sub.w   (a4), d0
    move.w  d0, -$4(a6)
    move.w  d2, d0
    sub.w   ($00FFA784).l, d0
    move.w  d0, $2(a2)
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
    movem.l -$1c(a6), d2-d3/a2-a5
    unlk    a6
    rts
