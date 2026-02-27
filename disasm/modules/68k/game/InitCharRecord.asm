; ============================================================================
; InitCharRecord -- Initialize character record from player data
; Called: 11 times.
; 78 bytes | $0181C6-$018213
; ============================================================================
InitCharRecord:                                                  ; $0181C6
    movem.l d2-d3/a2,-(sp)
    move.l  $0010(sp),d2
    move.l  $0014(sp),d3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w CalcCityCharBonus
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.l  a2,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$1e5e                           ; jsr $021E5E
    lea     $0014(sp),sp
    movem.l (sp)+,d2-d3/a2
    rts
