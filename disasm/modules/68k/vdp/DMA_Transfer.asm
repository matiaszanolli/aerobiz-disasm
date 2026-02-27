; ============================================================================
; DMA_Transfer -- Write 11 words from RAM palette buffer ($FFF06A) to VDP CRAM
; 34 bytes | $00163E-$00165F
; ============================================================================
DMA_Transfer:
    movea.l  #$00C00004,a4
    movea.l  #$00C00000,a3
    movea.l  #$00FFF06A,a0
    moveq   #$A,d0
    move.l  #$c0040000, (a4)
l_01658:
    move.w  (a0)+, (a3)
    dbra    d0, $1658
    rts
