; ============================================================================
; CalcCharValue -- Calculate character effectiveness from stats and game phase
; Called: 18 times.
; 196 bytes | $00E08E-$00E151
; ============================================================================
CalcCharValue:                                                  ; $00E08E
    movem.l d2-d4/a2,-(sp)
    move.l  $001c(sp),d2
    move.l  $0018(sp),d3
    move.l  $0014(sp),d4
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  #$01f4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9d92                           ; jsr $009D92
    addq.l  #$8,sp
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0003(a2),d0
    addi.w  #$32,d0
    andi.l  #$ffff,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.w  d3,d1
    addq.l  #$2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    tst.l   d0
    bge.b   .le110
    addq.l  #$3,d0
.le110:                                                 ; $00E110
    asr.l   #$2,d0
    addq.w  #$1,d0
    move.w  d0,d3
    moveq   #$0,d1
    move.w  d3,d1
    move.l  d2,d0
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    movem.l (sp)+,d2-d4/a2
    rts
