; ============================================================================
; StringAppend -- Appends a null-terminated string from A1 onto the end of the null-terminated string at A2: scans A2 to its terminator, then copies from A1 including the NUL, returning the original A2 base in D0.
; 30 bytes | $01E1BA-$01E1D7
; ============================================================================
StringAppend:                                                  ; $01E1BA
    move.l  a2,-(sp)
    movea.l $0008(sp),a2
    movea.l $000c(sp),a1
    movea.l a2,a0
    bra.b   .l1e1ca
.l1e1c8:                                                ; $01E1C8
    addq.l  #$1,a2
.l1e1ca:                                                ; $01E1CA
    tst.b   (a2)
    bne.b   .l1e1c8
.l1e1ce:                                                ; $01E1CE
    move.b  (a1)+,(a2)+
    bne.b   .l1e1ce
    move.l  a0,d0
    movea.l (sp)+,a2
    rts
; === Translated block $01E1D8-$01E1EC ===
; 1 functions, 20 bytes
