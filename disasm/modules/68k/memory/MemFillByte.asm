; ============================================================================
; MemFillByte -- Fill memory with a byte value (71 calls)
; Args (stack): 4(sp)=dest, 8(sp)=fill byte, C(sp)=count
; ============================================================================
MemFillByte:                                                     ; $01D520
    move.l  $C(sp),d1                                            ; D1 = count
    move.l  $8(sp),d0                                            ; D0 = fill value
    movea.l $4(sp),a0                                            ; A0 = dest pointer
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D52E
    move.b  d0,(a0)+                                             ; *dest++ = fill byte
    subq.w  #1,d1                                                ; count--
.check:                                                          ; $01D532
    tst.w   d1                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
