; ============================================================================
; SelectVDPInit -- Dispatch to DMA, scroll, or color VDP write based on D0 flag bits
; 38 bytes | $0015B0-$0015D5
; ============================================================================
SelectVDPInit:
    btst    #$0, d0
    bne.b   l_015ca
    btst    #$1, d0
    bne.b   l_015d0
    btst    #$2, d0
    beq.w   l_015d4
    bsr.w VDPWriteColorsPath
    bra.b   l_015d4
l_015ca:
    bsr.w TriggerVDPDMA
    bra.b   l_015d4
l_015d0:
    bsr.w DispatchVDPWrite
l_015d4:
    rts
