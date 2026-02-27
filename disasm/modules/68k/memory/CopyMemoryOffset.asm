; ============================================================================
; CopyMemoryOffset -- Copy bytes from source to interleaved region, accumulating byte-sum checksum
; 60 bytes | $005818-$005853
; ============================================================================
CopyMemoryOffset:
    movem.l d2-d4, -(a7)
    move.l  $18(a7), d1
    movea.l $10(a7), a1
    move.l  $14(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    moveq   #$0,d4
    bra.b   l_05848
l_05838:
    move.b  (a1), d3
    move.b  d3, (a0)
    moveq   #$0,d0
    move.b  d3, d0
    add.l   d0, d4
    addq.l  #$2, a0
    addq.l  #$1, a1
    addq.l  #$1, d2
l_05848:
    cmp.l   d1, d2
    bcs.b   l_05838
    move.l  d4, d0
    movem.l (a7)+, d2-d4
    rts
