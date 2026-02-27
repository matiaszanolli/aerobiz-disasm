; ============================================================================
; CopyBufferPair -- Call CopyWithMultiply twice for both layer buffers (source flag 0 and 1)
; 110 bytes | $005284-$0052F1
; ============================================================================
CopyBufferPair:
    movem.l d2-d7, -(a7)
    move.l  $30(a7), d2
    move.l  $2c(a7), d3
    move.l  $28(a7), d4
    move.l  $24(a7), d5
    move.l  $20(a7), d6
    move.l  $1c(a7), d7
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    bsr.w CopyWithMultiply
    lea     $20(a7), a7
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    bsr.w CopyWithMultiply
    lea     $20(a7), a7
    movem.l (a7)+, d2-d7
    rts
