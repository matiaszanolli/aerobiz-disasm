; ============================================================================
; InputCaseDispatch -- PC-relative jump table for controller type dispatch plus 3-button read handler
; 60 bytes | $00198E-$0019C9
; ============================================================================
InputCaseDispatch:
    bra.w   l_019e4
    bra.w   l_01aa2
    bra.w   l_019e4
    bra.w   l_01b70
    bra.w   l_019e4
    bra.w   l_019e4
    bra.w   l_01a20
    bra.w   l_019e8
    movem.l d2-d3, -(a7)
    moveq   #$0,d0
    move.b  #$70, (a0)
    bsr.b   $19CA
    swap    d1
    move.b  #$30, (a0)
    add.w   d0, d0
    bsr.b   $19CA
    movem.l (a7)+, d2-d3
    rts
