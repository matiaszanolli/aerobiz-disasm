; ============================================================================
; ToUpperCase -- Converts a single ASCII character (passed by value in the low byte of the stack arg) to uppercase: subtracts 0x20 if it is in the range 'a'–'z', otherwise returns it unchanged, in D0.
; Called: ?? times.
; 34 bytes | $01E14A-$01E16B
; ============================================================================
ToUpperCase:                                                  ; $01E14A
    move.l  $0004(sp),d1
    cmpi.b  #$61,d1
    bcs.b   .l1e166
    cmpi.b  #$7a,d1
    bhi.b   .l1e166
    moveq   #$0,d0
    move.b  d1,d0
    subi.l  #$20,d0
    bra.b   .l1e16a
.l1e166:                                                ; $01E166
    moveq   #$0,d0
    move.b  d1,d0
.l1e16a:                                                ; $01E16A
    rts
; ---------------------------------------------------------------------------
MemMoveWords:                                                  ; $01E16C
    move.l  $000c(sp),d1
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    cmpa.l  a1,a0
    bls.b   .l1e188
    bra.b   .l1e182
.l1e17e:                                                ; $01E17E
    move.w  (a0)+,(a1)+
    subq.w  #$1,d1
.l1e182:                                                ; $01E182
    tst.w   d1
    bne.b   .l1e17e
    bra.b   .l1e1a2
.l1e188:                                                ; $01E188
    moveq   #$0,d0
    move.w  d1,d0
    add.l   d0,d0
    adda.l  d0,a1
    moveq   #$0,d0
    move.w  d1,d0
    add.l   d0,d0
    adda.l  d0,a0
    bra.b   .l1e19e
.l1e19a:                                                ; $01E19A
    move.w  -(a0),-(a1)
    subq.w  #$1,d1
.l1e19e:                                                ; $01E19E
    tst.w   d1
    bne.b   .l1e19a
.l1e1a2:                                                ; $01E1A2
    rts
; ---------------------------------------------------------------------------

; === Translated block $01E1A4-$01E1BA ===
; 1 functions, 22 bytes
