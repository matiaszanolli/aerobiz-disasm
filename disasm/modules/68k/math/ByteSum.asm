; ============================================================================
; ByteSum -- Sum bytes in a buffer, return sum in D0.W
; Args (stack): 4(sp)=src ptr, 8(sp)=count
; ============================================================================
ByteSum:                                                         ; $01D6FC
    move.l  d2,-(sp)                                             ; Save D2
    move.l  $C(sp),d2                                            ; D2 = count (+4 from push)
    movea.l $8(sp),a0                                            ; A0 = src pointer
    clr.w   d1                                                   ; D1 = accumulator = 0
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D70A
    moveq   #0,d0                                                ; zero-extend
    move.b  (a0)+,d0                                             ; D0 = next byte
    add.w   d0,d1                                                ; accumulate
    subq.w  #1,d2                                                ; count--
.check:                                                          ; $01D712
    tst.w   d2                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    move.w  d1,d0                                                ; D0 = result sum
    move.l  (sp)+,d2                                             ; Restore D2
    rts
