; ============================================================================
; UpdatePassengerDemand -- Compute byte sum of demand table starting at +6, store result and input value into header fields
; 48 bytes | $00F522-$00F551
; ============================================================================
UpdatePassengerDemand:
    movem.l d2/a2-a3, -(a7)
    move.l  $14(a7), d2
    movea.l  #$00FF1804,a3
    movea.l a3, a2
    move.w  d2, d0
    move.l  d0, -(a7)
    move.l  a3, d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    jsr ByteSum
    addq.l  #$8, a7
    move.w  d0, $2(a2)
    move.w  d2, $4(a2)
    movem.l (a7)+, d2/a2-a3
    rts
