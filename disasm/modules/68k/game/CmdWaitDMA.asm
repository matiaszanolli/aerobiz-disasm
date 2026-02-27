; ============================================================================
; CmdWaitDMA -- Queue a V-INT-driven DMA transfer and busy-wait until V-INT signals completion
; 90 bytes | $0009F6-$000A4F
; ============================================================================
CmdWaitDMA:
    jsr (ComputeMapCoordOffset,PC)
    move.l  d0, d1
    lsl.l   #$2, d0
    andi.l  #$30000, d0
    swap    d0
    andi.l  #$3fff, d1
    swap    d1
    or.l    d1, d0
    move.l  d0, $4e(a5)
    move.l  $1a(a6), d0
    move.b  d0, $4c(a5)
    move.l  $1e(a6), d0
    move.b  d0, $4d(a5)
    move.l  $22(a6), d0
    move.l  d0, $54(a5)
    move.b  #$4, d0
    move.b  d0, $2b(a5)
    move.b  $1(a5), d0
    btst    #$5, d0
    bne.b   l_00a48
l_00a3e:
    bsr.w VInt_Handler3
    move.b  $2b(a5), d0
    bne.b   l_00a3e
l_00a48:
    move.b  $2b(a5), d0
    bne.b   l_00a48
    rts
