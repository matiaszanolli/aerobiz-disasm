; ============================================================================
; ClearMemoryRange -- Zero a range of bytes in interleaved ROM/RAM region (every-other-byte stride)
; 38 bytes | $0057F2-$005817
; ============================================================================
ClearMemoryRange:
    move.l  d2, -(a7)
    move.l  $c(a7), d1
    move.l  $8(a7), d0
    add.l   d0, d0
    addi.l  #$200003, d0
    movea.l d0, a0
    moveq   #$0,d2
    bra.b   l_05810
l_0580a:
    clr.b   (a0)
    addq.l  #$2, a0
    addq.l  #$1, d2
l_05810:
    cmp.l   d1, d2
    bcs.b   l_0580a
    move.l  (a7)+, d2
    rts
