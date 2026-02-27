; ============================================================================
; CopyBytesToWords -- Copies N bytes from a source array to every-other byte of a destination array (stride 2), effectively expanding a byte array into the low byte of each word slot.
; Called: ?? times.
; 30 bytes | $01E0E0-$01E0FD
; ============================================================================
CopyBytesToWords:                                                  ; $01E0E0
    move.l  $000c(sp),d0
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    clr.w   d1
    bra.b   .l1e0f8
.l1e0f0:                                                ; $01E0F0
    move.b  (a0),(a1)
    addq.w  #$1,d1
    addq.l  #$1,a0
    addq.l  #$2,a1
.l1e0f8:                                                ; $01E0F8
    cmp.w   d0,d1
    blt.b   .l1e0f0
    rts
