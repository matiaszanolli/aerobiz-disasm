; ============================================================================
; DisplayMenuOption -- Draws a menu option entry: looks up the option's screen position from a table, checks whether it is currently selected, and renders the tile with highlight or normal colour for each of up to 5 option slots.
; 274 bytes | $01BA1C-$01BB2D
; ============================================================================
DisplayMenuOption:
    link    a6,#$0
    movem.l d2/a2-a4, -(a7)
    move.l  $10(a6), d2
    movea.l  #$00000D64,a3
    movea.l  #$0001E044,a4
    cmpi.w  #$20, d2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   $e(a6), d0
    bne.w   l_1bafa
    cmpi.w  #$1, $16(a6)
    bne.w   l_1bafa
    clr.w   d2
l_1ba6a:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   l_1ba6a
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    bra.b   l_1bb18
l_1bafa:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
l_1bb18:
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$10(a6), d2/a2-a4
    unlk    a6
    rts
