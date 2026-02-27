; ============================================================================
; FillSequentialWords -- Write N incrementing word values starting from initial value into a buffer
; Called: ?? times.
; 34 bytes | $005EDE-$005EFF
; ============================================================================
FillSequentialWords:                                                  ; $005EDE
    move.l  d2,-(sp)
    move.l  $000c(sp),d1
    move.l  $0010(sp),d0
    movea.l $0008(sp),a0
    clr.w   d2
    bra.b   .l5ef8
.l5ef0:                                                 ; $005EF0
    move.w  d1,(a0)
    addq.w  #$1,d2
    addq.l  #$2,a0
    addq.w  #$1,d1
.l5ef8:                                                 ; $005EF8
    cmp.w   d0,d2
    bcs.b   .l5ef0
    move.l  (sp)+,d2
    rts
LoadTileGraphics:                                                  ; $005F00
    link    a6,#-$3c
    movem.l d2-d5,-(sp)
    move.l  $0008(a6),d2
    move.l  $0014(a6),d3
    move.l  $0018(a6),d4
    moveq   #$0,d0
    move.w  d2,d0
    lsl.l   #$2,d0
    movea.l #$000ae0c4,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    move.w  d3,d5
    moveq   #$d,d0
    lsl.w   d0,d5
    or.w    d4,d5
    pea     ($001E).w
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     -$003c(a6)
    bsr.w FillSequentialWords
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$000473d0,a0
    move.w  (a0,d0.w),d2
    cmpi.w  #$10,d2
    beq.b   .l5f74
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00047390,a0
    bra.b   .l5f8c
.l5f74:                                                 ; $005F74
    pea     ($0010).w
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$4,d0
    move.l  d0,-(sp)
    move.w  $0022(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff03e0,a0
.l5f8c:                                                 ; $005F8C
    move.l  (a0,d0.w),-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($001E).w
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    pea     ($00FF899C).l
    dc.w    $4eb9,$0000,$45e6                           ; jsr $0045E6
    lea     $002c(sp),sp
    pea     -$003c(a6)
    pea     ($0006).w
    pea     ($0005).w
    moveq   #$0,d0
    move.w  $0012(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $001e(a6),d0
    move.l  d0,-(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$004c(a6),d2-d5
    unlk    a6
    rts
