; ============================================================================
; CmdDMARowWrite -- DMA-copy sequential nametable rows from source data to VRAM, advancing by plane stride each row
; 178 bytes | $000944-$0009F5
; ============================================================================
CmdDMARowWrite:
    jsr (ComputeMapCoordOffset,PC)
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $1a(a6), d1
    move.l  $1e(a6), d2
    move.l  $22(a6), d3
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
    beq.b   l_009bc
    cmpi.b  #$1, d6
    bne.b   l_009b4
    lsl.l   #$1, d5
    bra.b   l_009bc
l_009b4:
    cmpi.b  #$3, d6
    bne.b   l_009bc
    lsl.l   #$2, d5
l_009bc:
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
    move.l  $20(a5), d0
    add.l   d1, d0
    move.l  d0, $20(a5)
    dbra    d2, $9BC
    move.w  (a7)+, sr
    rts
