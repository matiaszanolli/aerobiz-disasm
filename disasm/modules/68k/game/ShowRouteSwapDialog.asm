; ============================================================================
; ShowRouteSwapDialog -- Shows a confirmation dialog comparing two route-revenue values for a proposed char swap, and if confirmed copies the char assignment into the target slot.
; 262 bytes | $028470-$028575
; ============================================================================
ShowRouteSwapDialog:
    link    a6,#-$40
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.l  $10(a6), d3
    move.l  $c(a6), d4
    clr.w   d6
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w FindRouteSlotByCharState
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    move.w  d0, d5
    move.b  d3, (a3)
    move.b  #$2, $1(a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcRouteRevenue
    move.w  d0, d3
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00048324).l, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $30(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2856a
    cmp.w   d3, d5
    ble.b   l_2852a
    lea     -$40(a6), a2
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00048328).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_28530
l_2852a:
    movea.l ($0004832C).l, a2
l_28530:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    cmpi.w  #$1, d0
    bne.b   l_2855c
    moveq   #$1,d6
    bra.b   l_2856a
l_2855c:
    pea     ($0008).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
l_2856a:
    move.w  d6, d0
    movem.l -$5c(a6), d2-d6/a2-a3
    unlk    a6
    rts
