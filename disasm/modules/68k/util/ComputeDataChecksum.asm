; ============================================================================
; ComputeDataChecksum -- Sum bytes from interleaved region (arg=start index, count), return total
; 52 bytes | $005890-$0058C3
; ============================================================================
ComputeDataChecksum:
    movem.l d2-d4, -(a7)
    move.l  $14(a7), d1
    move.l  $10(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    moveq   #$0,d3
    bra.b   l_058b8
l_058ac:
    move.b  (a0), d4
    moveq   #$0,d0
    move.b  d4, d0
    add.l   d0, d3
    addq.l  #$2, a0
    addq.l  #$1, d2
l_058b8:
    cmp.l   d1, d2
    bcs.b   l_058ac
    move.l  d3, d0
    movem.l (a7)+, d2-d4
    rts
