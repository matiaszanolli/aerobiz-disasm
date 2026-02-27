; ============================================================================
; LinearByteSearch -- Generic linear search: scan a byte array of given count, returning 1 if the target byte is found.
; 44 bytes | $022480-$0224AB
; ============================================================================
LinearByteSearch:
    movem.l d2-d3, -(a7)
    move.l  $14(a7), d3
    move.l  $10(a7), d1
    movea.l $c(a7), a0
    clr.w   d2
    bra.b   l_224a0
l_22494:
    cmp.b   (a0), d3
    bne.b   l_2249c
    moveq   #$1,d0
    bra.b   l_224a6
l_2249c:
    addq.l  #$1, a0
    addq.w  #$1, d2
l_224a0:
    cmp.w   d1, d2
    bcs.b   l_22494
    moveq   #$0,d0
l_224a6:
    movem.l (a7)+, d2-d3
    rts
