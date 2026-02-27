; ============================================================================
; IntToDecimalStr -- Recursively converts an unsigned 32-bit integer to a decimal ASCII string, writing digits to the buffer pointed to by the pointer argument
; 86 bytes | $03AA02-$03AA57
; ============================================================================
IntToDecimalStr:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    moveq   #$A,d0
    cmp.l   d2, d0
    bls.b   l_3aa24
    move.b  d2, d0
    addi.b  #$30, d0
    movea.l (a2), a0
    addq.l  #$1, (a2)
    move.b  d0, (a0)
    moveq   #$1,d0
    bra.b   l_3aa52
l_3aa24:
    move.l  d2, d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    bsr.w IntToDecimalStr
    move.w  d0, d3
    move.l  d2, d0
    moveq   #$A,d1
    jsr UnsignedMod
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    bsr.w IntToDecimalStr
    lea     $10(a7), a7
    move.w  d3, d0
    addq.w  #$1, d0
l_3aa52:
    movem.l (a7)+, d2-d3/a2
    rts
