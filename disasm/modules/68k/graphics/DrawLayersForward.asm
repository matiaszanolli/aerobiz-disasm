; ============================================================================
; DrawLayersForward -- Iterate 8 palette layers in forward order, calling FadePalette each step
; Called: ?? times.
; 80 bytes | $004D04-$004D53
; ============================================================================
DrawLayersForward:                                                  ; $004D04
    movem.l d2-d5/a2,-(sp)
    move.l  $0024(sp),d3
    move.l  $0020(sp),d4
    move.l  $001c(sp),d5
    movea.l $0018(sp),a2
    clr.w   d2
.l4d1a:                                                 ; $004D1A
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
    beq.b   .l4d46
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
.l4d46:                                                 ; $004D46
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l4d1a
    movem.l (sp)+,d2-d5/a2
    rts
; === Translated block $004D54-$005060 ===
; 3 functions, 780 bytes
