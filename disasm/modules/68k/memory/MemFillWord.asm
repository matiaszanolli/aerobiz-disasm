; ============================================================================
; MemFillWord -- Fill memory with a word value
; Args (stack): 4(sp)=dest, 8(sp)=count, C(sp)=fill word
; ============================================================================
MemFillWord:                                                     ; $01D550
    move.l  $8(sp),d1                                            ; D1 = count
    move.l  $C(sp),d0                                            ; D0 = fill value
    movea.l $4(sp),a0                                            ; A0 = dest pointer
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D55E
    move.w  d0,(a0)+                                             ; *dest++ = fill word
    subq.w  #1,d1                                                ; count--
.check:                                                          ; $01D562
    tst.w   d1                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
