; ============================================================================
; AdvanceToNextMonth -- Search bitfield for available route slot, prompt player to confirm or skip, update route mask and reload screen
; 280 bytes | $00FCAC-$00FDC3
; ============================================================================
AdvanceToNextMonth:
    link    a6,#-$194
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $c(a6), d3
    lea     -$194(a6), a2
    movea.l  #$00006A2E,a3
    clr.w   d5
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$ff, d4
    beq.w   l_0fd68
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477E4).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $2c(a7), a7
    cmpi.w  #$1, d0
    bne.w   l_0fdb8
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateRouteMask
    jsr ResourceLoad
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    lea     $14(a7), a7
    moveq   #$1,d5
    bra.b   l_0fdb8
l_0fd68:
    jsr ResourceLoad
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a3)
    jsr ResourceUnload
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    move.l  ($000477E0).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
l_0fdb8:
    move.w  d5, d0
    movem.l -$1ac(a6), d2-d5/a2-a3
    unlk    a6
    rts
