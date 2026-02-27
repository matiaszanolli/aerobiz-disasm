; ============================================================================
; ConfigVDPDMA -- Program VDP DMA registers from RAM parameters and trigger the transfer
; 190 bytes | $001198-$001255
; ============================================================================
ConfigVDPDMA:
    move.w  sr, -(a7)
    ori.w   #$700, sr
    move.w  $c70(a5), d0
    bne.b   l_011a8
    jsr (VDPWriteZ80Path,PC)
l_011a8:
    jsr (WaitVDPAndWrite,PC)
    move.w  #$8100, d0
    move.b  $1(a5), d0
    bclr    #$5, d0
    bset    #$4, d0
    move.w  d0, (a4)
    moveq   #$0,d0
    move.w  $1e(a5), d0
    move.l  d0, d2
    move.w  #$9300, d1
    andi.w  #$ff, d0
    or.w    d1, d0
    move.w  d0, (a4)
    exg     d0, d2
    lsr.w   #$8, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  $20(a5), d0
    lsr.l   #$1, d0
    move.l  d0, d2
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    move.l  d2, d0
    lsr.w   #$8, d0
    andi.l  #$ff, d0
    addi.w  #$100, d1
    or.w    d1, d0
    move.w  d0, (a4)
    addi.w  #$100, d1
    move.l  d2, d0
    swap    d0
    andi.w  #$7f, d0
    or.w    d1, d0
    move.w  d0, (a4)
    dc.w    $4EB9,$00FF,$F000                           ; jsr $FFF000
l_0121c:
    move.w  (a4), d1
    btst    #$1, d1
    bne.b   l_0121c
    move.l  $20(a5), d0
    btst    #$16, d0
    beq.b   l_01244
    movea.l d0, a0
    move.l  $42(a5), d0
    bclr    #$7, d0
    movea.l  #$00C00000,a3
    moveq   #$1,d1
    bsr.w BulkCopyVDP
l_01244:
    bsr.w SetVDPDisplayBit
    move.w  $c70(a5), d0
    bne.b   l_01252
    bsr.w ReleaseZ80BusDirect
l_01252:
    move.w  (a7)+, sr
    rts
