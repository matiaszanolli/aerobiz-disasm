; ============================================================================
; CheckCharCompat -- Call FindRelationRecord for two cities, compare returned score against compatibility threshold
; Called: ?? times.
; 72 bytes | $00818A-$0081D1
; ============================================================================
CheckCharCompat:                                                  ; $00818A
    movem.l d2-d5/a2,-(sp)
    move.l  $0020(sp),d3
    move.l  $001c(sp),d4
    move.l  $0018(sp),d5
    clr.w   d2
    move.w  d5,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    cmp.w   $0002(a2),d0
    bhi.b   .l81ca
    moveq   #$1,d2
.l81ca:                                                 ; $0081CA
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2
    rts
