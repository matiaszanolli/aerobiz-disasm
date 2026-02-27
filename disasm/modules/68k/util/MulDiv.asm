; ============================================================================
; MulDiv -- Multiply then divide: (a * b) / c via Multiply32 + SignedDiv
; Called: 13 times.
; 46 bytes | $01E11C-$01E149
; ============================================================================
MulDiv:                                                  ; $01E11C
    move.l  d2,-(sp)
    move.l  $0010(sp),d2
    tst.w   d2
    bne.b   .l1e12a
    moveq   #$0,d0
    bra.b   .l1e146
.l1e12a:                                                ; $01E12A
    moveq   #$0,d0
    move.w  $000a(sp),d0
    moveq   #$0,d1
    move.w  $000e(sp),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l1e146:                                                ; $01E146
    move.l  (sp)+,d2
    rts
