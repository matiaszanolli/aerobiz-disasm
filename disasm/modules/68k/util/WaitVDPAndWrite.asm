; ============================================================================
; WaitVDPAndWrite -- Poll VDP until not busy, then write auto-increment register from RAM
; 30 bytes | $00117A-$001197
; ============================================================================
WaitVDPAndWrite:
l_0117a:
    bsr.w WaitVBlank
    andi.w  #$2, d0
    bne.b   l_0117a
    move.b  $1d(a5), d0
    andi.w  #$ff, d0
    ori.w   #$8f00, d0
    move.w  d0, (a4)
    move.b  d0, $f(a5)
    rts
