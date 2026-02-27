; ============================================================================
; ParseDecimalDigit -- Reads consecutive ASCII decimal digit characters from a pointer, accumulates the value (base-10), and advances the pointer; returns the integer value in D0
; 50 bytes | $03A9D0-$03AA01
; ============================================================================
ParseDecimalDigit:
    move.l  d2, -(a7)
    movea.l $8(a7), a1
    clr.w   d2
    bra.b   l_3a9e6
l_3a9da:
    move.w  d2, d0
    mulu.w  #$a, d0
    add.w   d1, d0
    move.w  d0, d2
    addq.l  #$1, (a1)
l_3a9e6:
    movea.l (a1), a0
    move.b  (a0), d0
    andi.l  #$ff, d0
    addi.w  #$ffd0, d0
    move.w  d0, d1
    cmpi.w  #$a, d0
    bcs.b   l_3a9da
    move.w  d2, d0
    move.l  (a7)+, d2
    rts
