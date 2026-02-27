; ============================================================================
; WriteEventField -- Writes the event's result byte to either the char-region table ($FF1298) or the global event-effect table ($FF99A4) based on the event's group flag.
; Called: ?? times.
; 60 bytes | $028EBE-$028EF9
; ============================================================================
WriteEventField:                                                  ; $028EBE
    move.w  $0006(sp),d0
    lsl.w   #$3,d0
    movea.l #$0005fab6,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    tst.b   $0006(a1)
    bne.b   .l28ee6
    moveq   #$0,d0
    move.b  $0005(a1),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    bra.b   .l28ef2
.l28ee6:                                                ; $028EE6
    moveq   #$0,d0
    move.b  $0005(a1),d0
    movea.l #$00ff99a4,a0
.l28ef2:                                                ; $028EF2
    move.b  $0007(a1),(a0,d0.w)
    rts
; === Translated block $028EFA-$02949A ===
; 6 functions, 1440 bytes
