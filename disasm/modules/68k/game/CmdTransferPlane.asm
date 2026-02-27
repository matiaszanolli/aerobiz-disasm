; ============================================================================
; CmdTransferPlane -- Set up DMA params and dispatch VDP write for a nametable plane transfer
; 48 bytes | $0004F0-$00051F
; ============================================================================
CmdTransferPlane:
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
    jsr (DispatchVDPWrite,PC)
    nop
    move.w  (a7)+, sr
    rts
