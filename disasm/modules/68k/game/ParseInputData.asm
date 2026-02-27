; ============================================================================
; ParseInputData -- Read two nibble pairs from port to assemble a 16-bit input data packet
; 78 bytes | $001AD4-$001B21
; ============================================================================
ParseInputData:
l_01ad4:
    moveq   #$0,d2
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    andi.w  #$f, d0
    move.b  d0, d2
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    asl.b   #$4, d0
    or.b    d0, d2
    swap    d2
    bsr.b   $1B02
    bcs.w   l_01c9a
    asl.w   #$4, d2
    bsr.b   $1B02
    bcs.w   l_01c9a
    bra.b   l_01b22
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    andi.b  #$f, d0
    or.b    d0, d2
    bsr.w PollInputStatus
    bcs.w   l_01c9a
    asl.w   #$4, d2
    andi.w  #$f, d0
    or.b    d0, d2
    rts
