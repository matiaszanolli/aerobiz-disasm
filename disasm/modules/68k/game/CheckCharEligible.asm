; ============================================================================
; CheckCharEligible -- Check if a char entry is within active contract period and region-compatible with player hub city, return 1 if eligible
; Called: ?? times.
; 156 bytes | $00FEDA-$00FF75
; ============================================================================
CheckCharEligible:                                                  ; $00FEDA
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0018(sp),d2
    move.l  $001c(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .lff04
    addq.l  #$3,d0
.lff04:                                                 ; $00FF04
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d2
    clr.w   d3
    move.w  d4,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0006(a2),d0
    cmp.w   d2,d0
    bgt.b   .lff6e
    moveq   #$0,d0
    move.b  $0007(a2),d0
    cmp.w   d2,d0
    ble.b   .lff6e
    moveq   #$0,d0
    move.b  (a2),d0
    movea.l #$0005f07c,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    cmpi.w  #$3,d0
    beq.b   .lff6e
    moveq   #$1,d3
.lff6e:                                                 ; $00FF6E
    move.w  d3,d0
    movem.l (sp)+,d2-d4/a2-a3
    rts
