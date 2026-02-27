; ============================================================================
; StringConcat -- Thin wrapper around StringAppend: pushes both pointer args onto the stack and calls StringAppend, returning the base of the destination string in D0.
; 20 bytes | $01E3EE-$01E401
; ============================================================================
StringConcat:                                                  ; $01E3EE
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    move.l  a1,-(sp)
    move.l  a0,-(sp)
    bsr.w StringAppend
    addq.l  #$8,sp
    rts
; === Translated block $01E402-$01E98E ===
; 6 functions, 1420 bytes
