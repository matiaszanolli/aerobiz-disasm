; ============================================================================
; ConfigDmaMode -- Initialize VDP registers 4-23 for DMA mode via a sequence of GameCommand calls
; 164 bytes | $0055B0-$005653
; ============================================================================
ConfigDmaMode:
    move.l  a2, -(a7)
    movea.l  #$00000D64,a2
    move.l  #$8004, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8104, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8600, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8700, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8800, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8900, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$8a3f, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8c00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8e00, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$8f02, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9030, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $30(a7), a7
    move.l  #$9100, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    move.l  #$9200, -(a7)
    clr.l   -(a7)
    jsr     (a2)
    lea     $10(a7), a7
    movea.l (a7)+, a2
    rts
