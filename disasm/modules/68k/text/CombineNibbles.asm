; ============================================================================
; CombineNibbles -- Poll two nibbles from port and combine into an inverted 8-bit button byte
; 30 bytes | $001C4E-$001C6B
; ============================================================================
CombineNibbles:
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    andi.w  #$f, d0
    move.w  d0, d1
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    asl.w   #$4, d0
    or.b    d0, d1
    not.b   d1
    rts
