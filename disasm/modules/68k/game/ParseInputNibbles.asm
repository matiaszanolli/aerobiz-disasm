; ============================================================================
; ParseInputNibbles -- Read two nibbles, combine into button byte, update current/pressed state
; 42 bytes | $001C10-$001C39
; ============================================================================
ParseInputNibbles:
l_01c10:
    bsr.w CombineNibbles
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    not.b   d0
    andi.w  #$f, d0
    move.b  d0, d2
    move.w  #$1, (a1)+
    move.b  d1, d0
    bsr.w XorAndUpdate
    move.b  d2, d0
    bsr.w XorAndUpdate
    lea     $4(a1), a1
    rts
