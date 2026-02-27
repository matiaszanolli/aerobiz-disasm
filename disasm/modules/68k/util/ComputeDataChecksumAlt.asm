; ============================================================================
; ComputeDataChecksumAlt -- Sum bytes from a flat contiguous buffer (no interleaving), return total
; 40 bytes | $0058C4-$0058EB
; ============================================================================
ComputeDataChecksumAlt:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d1
    movea.l $10(a7), a0
    moveq   #$0,d2
    moveq   #$0,d3
    bra.b   l_058e0
l_058d6:
    move.b  (a0)+, d4
    moveq   #$0,d0
    move.b  d4, d0
    add.l   d0, d3
    addq.l  #$1, d2
l_058e0:
    cmp.l   d1, d2
    bcs.b   l_058d6
    move.l  d3, d0
    movem.l (a7)+, d2-d4
    rts
