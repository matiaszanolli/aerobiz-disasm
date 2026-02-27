; ============================================================================
; Init5 -- Bulk-copy 800 bytes from ROM data table ($1D88) to VRAM via VDP data port
; 36 bytes | $0010DA-$0010FD
; ============================================================================
Init5:
    movea.l  #$00001D88,a6
    move.l  #$31f, d1
    movea.l  #$00C00000,a5
    move.l  #$40000000, ($00C00004).l
l_010f6:
    move.w  (a6)+, (a5)
    dbra    d1, $10F6
    rts
