; ============================================================================
; SumPlayerStats -- sums 16 stat high-bytes for a given player from the character stat table at $FFB9E9
; Called: ?? times.
; 56 bytes | $01045A-$010491
; ============================================================================
SumPlayerStats:                                                  ; $01045A
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    clr.w   d3
    clr.w   d2
.l10466:                                                ; $010466
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l10466
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
