; ============================================================================
; FindSpriteByID -- Searches a player's four route slots for one with status 6 whose char-ID and city-ID match given arguments; returns the slot's byte-field-4 value or 0 if not found.
; 84 bytes | $013CC0-$013D13
; ============================================================================
FindSpriteByID:
    movem.l d2-d4, -(a7)
    move.l  $18(a7), d3
    move.l  $14(a7), d4
    move.w  $12(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_13ce0:
    cmpi.b  #$6, $1(a1)
    bne.b   l_13d02
    moveq   #$0,d0
    move.w  $6(a1), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_13d02
    cmp.b   (a1), d4
    bne.b   l_13d02
    moveq   #$0,d0
    move.b  $3(a1), d0
    bra.b   l_13d0e
l_13d02:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_13ce0
    moveq   #$0,d0
l_13d0e:
    movem.l (a7)+, d2-d4
    rts
