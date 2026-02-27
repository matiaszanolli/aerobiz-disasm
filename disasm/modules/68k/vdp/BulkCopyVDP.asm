; ============================================================================
; BulkCopyVDP -- Issue VDP command word then loop-write D1 words from A0 to VDP data port
; 10 bytes | $001386-$00138F
; ============================================================================
BulkCopyVDP:
l_01386:
    move.l  d0, (a4)
l_01388:
    move.w  (a0)+, (a3)
    subq.w  #$1, d1
    bne.b   l_01388
    rts
