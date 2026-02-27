; ============================================================================
; SelectRouteDestination -- Show route selection dialog, call BrowseCharList for destination pick, validate against session block, loop until done
; 230 bytes | $00DA8C-$00DB71
; ============================================================================
SelectRouteDestination:
    movem.l d2-d4/a2, -(a7)
    move.l  $14(a7), d3
    move.l  $18(a7), d4
    movea.l $1c(a7), a2
l_0da9c:
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047784).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseCharList
    lea     $24(a7), a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    beq.b   l_0db62
    movea.l  #$00FF09D8,a0
    move.b  (a0,d2.w), d0
    andi.b  #$3, d0
    beq.b   l_0db6a
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000477AC).l, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $20(a7), a7
l_0db62:
    cmpi.w  #$ff, d2
    bne.w   l_0da9c
l_0db6a:
    move.w  d2, d0
    movem.l (a7)+, d2-d4/a2
    rts
