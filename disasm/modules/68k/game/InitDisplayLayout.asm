; ============================================================================
; InitDisplayLayout -- Set up sprite DMA parameters (source, dest, length) and trigger transfer
; 104 bytes | $0015D6-$00163D
; ============================================================================
InitDisplayLayout:
    movem.l a0, -(a7)
    movea.l  #$00FFF01C,a0
    moveq   #$0,d3
    move.b  #$2, $1d(a5)
    btst    #$0, (a0)
    bne.b   l_015f6
    move.w  #$100, $1e(a5)
    bra.b   l_015fc
l_015f6:
    move.w  #$140, $1e(a5)
l_015fc:
    move.b  d3, $37(a5)
    move.l  #$fff08a, d0
    move.l  d0, $20(a5)
    moveq   #$0,d0
    move.w  $3e(a5), d0
    move.l  d0, $24(a5)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d1
    andi.l  #$3fff0000, d1
    or.l    d1, d0
    ori.l   #$40000080, d0
    move.l  d0, $42(a5)
    bsr.w TriggerVDPDMA
    movem.l (a7)+, a0
    rts
