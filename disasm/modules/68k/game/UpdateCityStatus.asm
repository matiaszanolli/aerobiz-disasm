; ============================================================================
; UpdateCityStatus -- Evaluates two packed byte values against signed threshold constants and sets result flag D3=1 if the combination is within the accepted range
; 78 bytes | $016F50-$016F9D
; ============================================================================
UpdateCityStatus:
    dc.w    $0010,$1428                     ; ori.b #$28,(a0) - high byte $14 is compiler junk
    dc.w    $FFFF
    moveq   #$0,d0
    move.b  d4, d0
    moveq   #-$22,d1
    cmp.l   d0, d1
    bne.b   l_16f76
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$4A,d1
    cmp.l   d0, d1
    bgt.b   l_16f80
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$3C,d1
    cmp.l   d0, d1
    bge.b   l_16f94
    bra.b   l_16f80
l_16f76:
    moveq   #$0,d0
    move.b  d4, d0
    moveq   #-$21,d1
    cmp.l   d0, d1
    bne.b   l_16f94
l_16f80:
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$36,d1
    cmp.l   d0, d1
    bgt.b   l_16f96
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    blt.b   l_16f96
l_16f94:
    moveq   #$1,d3
l_16f96:
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts
