; ============================================================================
; SumStatBytes -- sums 16 stat low-bytes for a given player from the character stat table at $FFB9E8
; Called: ?? times.
; 56 bytes | $010492-$0104C9
; ============================================================================
SumStatBytes:                                                  ; $010492
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    clr.w   d3
    clr.w   d2
.l1049e:                                                ; $01049E
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l1049e
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
