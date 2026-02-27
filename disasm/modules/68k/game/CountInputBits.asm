; ============================================================================
; CountInputBits -- Count how many 2-bit groups in the port byte are non-zero
; 26 bytes | $0019CA-$0019E3
; ============================================================================
CountInputBits:
    move.b  (a0), d1
    move.b  d1, d2
    andi.b  #$c, d2
    beq.b   l_019d6
    addq.w  #$1, d0
l_019d6:
    add.w   d0, d0
    move.b  d1, d3
    andi.w  #$3, d3
    beq.b   l_019e2
    addq.w  #$1, d0
l_019e2:
    rts
