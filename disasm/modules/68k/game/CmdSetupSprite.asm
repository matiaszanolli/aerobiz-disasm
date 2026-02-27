; ============================================================================
; CmdSetupSprite -- Configure VDP DMA command word for sprite table upload, optionally blocking until done
; 168 bytes | $000550-$0005F7
; ============================================================================
CmdSetupSprite:
    move.l  $e(a6), d0
    move.b  d0, $2a(a5)
    move.l  $12(a6), d0
    move.l  d0, $30(a5)
    move.l  $1a(a6), d0
    move.w  d0, $34(a5)
    move.l  $22(a6), d2
    move.l  $16(a6), d1
    move.l  $1e(a6), d0
    bne.b   l_00598
    move.l  d1, d0
    lsl.l   #$2, d0
    swap    d0
    andi.l  #$3, d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d0, d1
    btst    #$0, d2
    bne.b   l_005d6
    bset    #$1e, d1
    bra.b   l_005d6
l_00598:
    btst    #$0, d0
    beq.b   l_005ba
    swap    d1
    andi.l  #$7f0000, d1
    btst    #$0, d2
    bne.b   l_005b4
    ori.l   #$c0000000, d1
    bra.b   l_005d6
l_005b4:
    bset    #$5, d1
    bra.b   l_005d6
l_005ba:
    btst    #$1, d0
    beq.b   l_005f6
    swap    d1
    andi.l  #$7f0000, d1
    bset    #$4, d1
    btst    #$0, d2
    bne.b   l_005d6
    bset    #$1e, d1
l_005d6:
    move.l  d1, $2c(a5)
    move.b  $1(a5), d0
    btst    #$5, d0
    bne.b   l_005e8
    bra.w   l_01346
l_005e8:
    move.b  #$1, d0
    move.b  d0, $2b(a5)
l_005f0:
    move.b  $2b(a5), d0
    bne.b   l_005f0
l_005f6:
    rts
