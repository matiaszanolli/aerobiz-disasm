; ============================================================================
; CopyAlternateBytes -- Copies N bytes from alternating (stride-2) positions in a source array to consecutive bytes in a destination array; the reverse direction of CopyBytesToWords.
; 30 bytes | $01E0FE-$01E11B
; ============================================================================
CopyAlternateBytes:                                                  ; $01E0FE
    move.l  $000c(sp),d0
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    clr.w   d1
    bra.b   .l1e116
.l1e10e:                                                ; $01E10E
    move.b  (a1),(a0)
    addq.w  #$1,d1
    addq.l  #$1,a0
    addq.l  #$2,a1
.l1e116:                                                ; $01E116
    cmp.w   d0,d1
    blt.b   .l1e10e
    rts
