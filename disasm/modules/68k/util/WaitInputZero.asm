; ============================================================================
; WaitInputZero -- Set port to zero and spin until bit 4 rises; set carry on timeout
; 20 bytes | $001C86-$001C99
; ============================================================================
WaitInputZero:
l_01c86:
    move.b  #$0, (a0)
l_01c8a:
    move.b  (a0), d0
    btst    #$4, d0
    dbeq    d7, $1C8A
    bne.b   l_01c9a
    move.b  (a0), d0
    rts
