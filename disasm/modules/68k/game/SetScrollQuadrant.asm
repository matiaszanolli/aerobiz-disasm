; ============================================================================
; SetScrollQuadrant -- Select scroll quadrant via lookup table, set palette register and scroll offsets
; Called: ?? times.
; 114 bytes | $005518-$005589
; ============================================================================
SetScrollQuadrant:                                                  ; $005518
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $0010(sp),d3
    cmpi.w  #$3,d3
    bhi.b   .l5530
    cmpi.w  #$3,d2
    bls.b   .l5534
.l5530:                                                 ; $005530
    clr.w   d3
    clr.w   d2
.l5534:                                                 ; $005534
    move.w  d2,d0
    lsl.w   #$2,d0
    add.w   d3,d0
    movea.l #$0004737e,a0
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4
    tst.w   d4
    bne.b   .l5552
    clr.w   d3
    clr.w   d2
.l5552:                                                 ; $005552
    moveq   #$0,d0
    move.w  d4,d0
    ori.l   #$9000,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    move.w  d3,d0
    lsl.w   #$5,d0
    addi.w  #$20,d0
    move.w  d0,($00FFA77E).l
    move.w  d2,d0
    lsl.w   #$5,d0
    addi.w  #$20,d0
    move.w  d0,($00FFA77C).l
    movem.l (sp)+,d2-d4
    rts
    dc.w    $2F02,$242F,$0008; $00558A
; === Translated block $005590-$0058FC ===
; 13 functions, 876 bytes
