; ============================================================================
; DrawLayersReverse -- Iterate 8 palette layers in reverse order, calling FadePalette each step
; Called: ?? times.
; 78 bytes | $004CB6-$004D03
; ============================================================================
DrawLayersReverse:                                                  ; $004CB6
    movem.l d2-d5/a2,-(sp)
    move.l  $0024(sp),d3
    move.l  $0020(sp),d4
    move.l  $001c(sp),d5
    movea.l $0018(sp),a2
    moveq   #$7,d2
.l4ccc:                                                 ; $004CCC
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w FadePalette
    lea     $0010(sp),sp
    tst.w   d3
    beq.b   .l4cf8
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
.l4cf8:                                                 ; $004CF8
    subq.w  #$1,d2
    tst.w   d2
    bge.b   .l4ccc
    movem.l (sp)+,d2-d5/a2
    rts
