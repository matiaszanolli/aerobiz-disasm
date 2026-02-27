; ============================================================================
; CmdInitAnimation -- Set up character animation parameters (frame count, rate, address) and reset counters
; 72 bytes | $000BF0-$000C37
; ============================================================================
CmdInitAnimation:
    moveq   #$0,d0
    move.b  d0, $bd4(a5)
    move.l  $e(a6), d0
    beq.b   l_00c36
    move.l  $16(a6), d0
    beq.b   l_00c26
    move.b  d0, $bd6(a5)
    move.l  $12(a6), d0
    move.b  d0, $bd5(a5)
    move.l  $1a(a6), d0
    move.w  d0, $bd8(a5)
    move.l  $1e(a6), d0
    move.w  d0, $bda(a5)
    move.l  $22(a6), d0
    move.l  d0, $bdc(a5)
l_00c26:
    moveq   #$0,d0
    move.w  d0, $be0(a5)
    move.w  d0, $be2(a5)
    bset    #$0, $bd4(a5)
l_00c36:
    rts
