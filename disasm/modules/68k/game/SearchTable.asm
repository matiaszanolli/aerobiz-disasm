; ============================================================================
; SearchTable -- Returns the length of a null-terminated string at the address in the stack arg: scans forward byte by byte until the NUL, then returns the byte count (string length) in D0.W.
; 20 bytes | $01E1D8-$01E1EB
; ============================================================================
SearchTable:
    movea.l $4(a7), a1
    movea.l a1, a0
    bra.b   l_1e1e2
l_1e1e0:
    addq.l  #$1, a1
l_1e1e2:
    tst.b   (a1)
    bne.b   l_1e1e0
    move.w  a1, d0
    sub.w   a0, d0
    rts
