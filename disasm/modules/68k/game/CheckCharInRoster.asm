; ============================================================================
; CheckCharInRoster -- Checks whether a character (by code pair) already exists in a player's active roster; returns 1 if found, 0 if not
; 116 bytes | $039DDE-$039E51
; ============================================================================
CheckCharInRoster:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $20(a7), d4
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    addq.l  #$8, a7
    move.w  d0, d3
    clr.w   d4
    clr.w   d2
l_39e18:
    tst.b   $1(a3)
    beq.b   l_39e42
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    blt.b   l_39e42
    moveq   #$1,d4
    bra.b   l_39e4a
l_39e42:
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   l_39e18
l_39e4a:
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts
