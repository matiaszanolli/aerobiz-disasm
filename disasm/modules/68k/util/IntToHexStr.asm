; ============================================================================
; IntToHexStr -- Recursively converts an unsigned 32-bit integer to a hexadecimal ASCII string ('0'-'9','A'-'F'), writing digits to the buffer pointer argument
; 88 bytes | $03AA58-$03AAAF
; ============================================================================
IntToHexStr:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    movea.l $10(a7), a2
    moveq   #$10,d0
    cmp.l   d2, d0
    bls.b   l_3aa88
    moveq   #$A,d0
    cmp.l   d2, d0
    bls.b   l_3aa78
    move.b  d2, d0
    addi.b  #$30, d0
    bra.b   l_3aa7e
l_3aa78:
    move.b  d2, d0
    addi.b  #$37, d0
l_3aa7e:
    movea.l (a2), a0
    addq.l  #$1, (a2)
    move.b  d0, (a0)
    moveq   #$1,d0
    bra.b   l_3aaaa
l_3aa88:
    move.l  d2, d0
    lsr.l   #$4, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    bsr.w IntToHexStr
    move.w  d0, d3
    moveq   #$F,d0
    and.l   d2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    bsr.w IntToHexStr
    lea     $10(a7), a7
    move.w  d3, d0
    addq.w  #$1, d0
l_3aaaa:
    movem.l (a7)+, d2-d3/a2
    rts
