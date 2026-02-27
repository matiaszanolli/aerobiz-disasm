; ============================================================================
; ConfigVDPColors -- Set VDP DMA registers and CRAM destination, then write one color word
; 108 bytes | $0012DA-$001345
; ============================================================================
ConfigVDPColors:
    movea.l  #$00C00004,a4
    move.w  #$8100, d0
    move.b  $1(a5), d0
    bclr    #$5, d0
    bset    #$4, d0
    move.w  d0, (a4)
    jsr (WaitVDPAndWrite,PC)
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
    move.w  #$9780, d0
    move.w  d0, (a4)
    move.l  $24(a5), d0
    move.l  d0, d2
    lsl.l   #$2, d0
    swap    d0
    andi.w  #$3, d0
    ori.w   #$80, d0
    andi.w  #$3fff, d2
    bset    #$e, d2
    move.w  d2, (a4)
    move.w  d0, (a4)
    move.w  $28(a5), d0
    move.w  d0, ($00C00000).l
    rts
