; ============================================================================
; WriteNibble -- Handle type-0 packet: read combined nibble and update button state slot
; 20 bytes | $001C3A-$001C4D
; ============================================================================
WriteNibble:
l_01c3a:
    bsr.b   $1C4E
    bcs.w   l_01c9a
    clr.w   (a1)+
    move.b  d1, d0
    bsr.w XorAndUpdate
    lea     $6(a1), a1
    rts
