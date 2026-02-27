; ============================================================================
; ExecPassengerLoadUnload -- Pack char_stat_array bytes into output buffer (4 per source byte, 2-bit wide), return end pointer
; 54 bytes | $00EF92-$00EFC7
; ============================================================================
ExecPassengerLoadUnload:
    movem.l d2-d3, -(a7)
    movea.l $c(a7), a0
    movea.l  #$00FF05C4,a1
    clr.w   d1
l_0efa2:
    clr.b   d3
    clr.w   d2
l_0efa6:
    move.b  (a1), d0
    lsl.b   d2, d0
    or.b    d0, d3
    addq.l  #$1, a1
    addq.w  #$2, d2
    cmpi.w  #$8, d2
    bcs.b   l_0efa6
    move.b  d3, (a0)+
    addq.w  #$1, d1
    cmpi.w  #$39, d1
    bcs.b   l_0efa2
    move.l  a0, d0
    movem.l (a7)+, d2-d3
    rts
