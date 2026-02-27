; ============================================================================
; CmdDMABatchWrite -- DMA-fill multiple nametable rows from a stack-allocated buffer, repeating a fill word
; 206 bytes | $000876-$000943
; ============================================================================
CmdDMABatchWrite:
    jsr (ComputeMapCoordOffset,PC)
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  a7, d3
    move.l  $1a(a6), d2
    lsl.l   #$1, d2
    sub.l   d2, d3
    movea.l d3, a0
    movea.l a0, a7
    move.l  $22(a6), d2
    move.l  $1a(a6), d1
    subq.l  #$1, d1
l_00898:
    move.w  d2, (a0)+
    dbra    d1, $898
    move.l  $1a(a6), d1
    move.l  $1e(a6), d2
    move.b  #$2, $1d(a5)
    move.b  #$0, $37(a5)
    move.w  d1, $1e(a5)
    move.l  d3, $20(a5)
    move.l  d0, $24(a5)
    move.l  d0, d4
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d4
    andi.l  #$3fff0000, d4
    or.l    d4, d0
    ori.l   #$40000080, d0
    move.l  d0, $42(a5)
    andi.w  #$ff, d2
    subq.w  #$1, d2
    lsl.l   #$1, d1
    move.l  #$400000, d5
    move.b  $10(a5), d6
    andi.b  #$3, d6
    beq.b   l_00908
    cmpi.b  #$1, d6
    bne.b   l_00900
    lsl.l   #$1, d5
    bra.b   l_00908
l_00900:
    cmpi.b  #$3, d6
    bne.b   l_00908
    lsl.l   #$2, d5
l_00908:
    movem.l d0-d2, -(a7)
    bsr.w TriggerVDPDMA
    movem.l (a7)+, d0-d2
    move.l  $42(a5), d0
    move.l  $24(a5), d0
    addi.l  #$40, d0
    move.l  d0, $24(a5)
    move.l  $42(a5), d0
    add.l   d5, d0
    move.l  d0, $42(a5)
    dbra    d2, $908
    move.l  a7, d3
    move.l  $1a(a6), d2
    lsl.l   #$1, d2
    add.l   d2, d3
    movea.l d3, a7
    move.w  (a7)+, sr
    rts
