; ============================================================================
; SetHighNibble -- Write argument byte shifted left 4 into high nibble of byte[2] of struct pointer
; Called: ?? times.
; 22 bytes | $007390-$0073A5
; ============================================================================
SetHighNibble:                                                  ; $007390
    movea.l $0004(sp),a0
    andi.b  #$0f,$0002(a0)
    move.b  $000b(sp),d0
    lsl.b   #$04,d0
    or.b    d0,$0002(a0)
    rts
