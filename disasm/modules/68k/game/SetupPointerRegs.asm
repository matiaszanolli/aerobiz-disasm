; ============================================================================
; SetupPointerRegs -- Copies a null-terminated string from A1 to A2 (byte by byte until the NUL is copied), then returns the original start address of A2 in D0; a strcpy that also saves/restores A2.
; 22 bytes | $01E1A4-$01E1B9
; ============================================================================
SetupPointerRegs:
    move.l  a2, -(a7)
    movea.l $8(a7), a2
    movea.l $c(a7), a1
    movea.l a2, a0
l_1e1b0:
    move.b  (a1)+, (a2)+
    bne.b   l_1e1b0
    move.l  a0, d0
    movea.l (a7)+, a2
    rts
