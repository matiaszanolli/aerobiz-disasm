; ============================================================================
; CmdSetupDMA -- Configure DMA transfer parameters in work RAM and trigger VDP DMA (VRAM/CRAM/VSRAM)
; 116 bytes | $00047C-$0004EF
; ============================================================================
CmdSetupDMA:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.l  $e(a6), d0
    move.b  d0, $1d(a5)
    move.l  $12(a6), d0
    move.w  d0, $1e(a5)
    move.l  $16(a6), d0
    move.l  d0, $20(a5)
    move.l  $1a(a6), d0
    move.l  d0, $24(a5)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    swap    d1
    andi.l  #$3fff0000, d1
    or.l    d1, d0
    move.l  $1e(a6), d1
    move.b  d1, $37(a5)
    bne.b   l_004ca
    ori.l   #$40000080, d0
    bra.b   l_004e4
l_004ca:
    btst    #$0, d1
    beq.b   l_004d8
    ori.l   #$c0000080, d0
    bra.b   l_004e4
l_004d8:
    btst    #$1, d1
    beq.b   l_004ec
    ori.l   #$40000090, d0
l_004e4:
    move.l  d0, $42(a5)
    bsr.w TriggerVDPDMA
l_004ec:
    move.w  (a7)+, sr
    rts
