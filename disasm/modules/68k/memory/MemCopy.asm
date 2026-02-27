; ============================================================================
; MemCopy -- Copy bytes from source to destination
; Args (stack): 8(sp)=src, 10(sp)=dest, 14(sp)=count
; ============================================================================
MemCopy:                                                         ; $01D538
    move.l  $14(sp),d0                                           ; D0 = count
    movea.l $10(sp),a1                                           ; A1 = dest
    movea.l $8(sp),a0                                            ; A0 = src
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D546
    move.b  (a0)+,(a1)+                                          ; *dest++ = *src++
    subq.w  #1,d0                                                ; count--
.check:                                                          ; $01D54A
    tst.w   d0                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
