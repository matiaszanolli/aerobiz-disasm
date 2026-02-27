; ============================================================================
; GenerateEventResult -- Draws a filled box using DrawBox with coordinates derived from all four stack parameters; adjusts column/row offsets by +2 and -1
; 48 bytes | $017C6E-$017C9D
; ============================================================================
GenerateEventResult:
    link    a6,#-$8
    lea     $e(a6), a1
    lea     $a(a6), a0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    move.w  $12(a6), d0
    addq.w  #$2, d0
    move.l  d0, -(a7)
    move.w  (a1), d0
    move.l  d0, -(a7)
    move.w  (a0), d0
    addi.w  #$ffff, d0
    move.l  d0, -(a7)
    jsr DrawBox
    unlk    a6
    rts
