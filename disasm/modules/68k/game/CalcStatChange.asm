; ============================================================================
; CalcStatChange -- Compute stat point delta for an event type and current value with category-specific scaling limits
; Called: ?? times.
; 456 bytes | $0090F4-$0092BB
; ============================================================================
CalcStatChange:                                                  ; $0090F4
    movem.l d2-d3/a2,-(sp)
    move.l  $0018(sp),d2
    move.l  $0014(sp),d3
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.w   d3
    bne.w   .l91a0
    moveq   #$0,d3
    move.b  $0001(a2),d3
    tst.w   d2
    bne.b   .l9156
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$5,d1
.l9146:                                                 ; $009146
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    bra.b   .l9150
.l914e:                                                 ; $00914E
    moveq   #$1,d0
.l9150:                                                 ; $009150
    move.w  d0,d2
    bra.w   .l926e
.l9156:                                                 ; $009156
    cmpi.w  #$1,d2
    bne.b   .l9182
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$a,d1
    bra.b   .l9146
.l9182:                                                 ; $009182
    cmpi.w  #$2,d2
    bne.b   .l918e
.l9188:                                                 ; $009188
    clr.w   d2
    bra.w   .l926e
.l918e:                                                 ; $00918E
    cmpi.w  #$3,d2
    bne.b   .l919a
    moveq   #-$5,d2
    bra.w   .l926e
.l919a:                                                 ; $00919A
    moveq   #-$14,d2
    bra.w   .l926e
.l91a0:                                                 ; $0091A0
    cmpi.w  #$1,d3
    bne.b   .l9220
    moveq   #$0,d3
    move.b  $0002(a2),d3
    tst.w   d2
    bne.b   .l91da
.l91b0:                                                 ; $0091B0
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    bge.b   .l91be
    addq.l  #$3,d0
.l91be:                                                 ; $0091BE
    asr.l   #$2,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    bge.b   .l91d4
    addq.l  #$3,d0
.l91d4:                                                 ; $0091D4
    asr.l   #$2,d0
    bra.w   .l9150
.l91da:                                                 ; $0091DA
    cmpi.w  #$1,d2
    bne.b   .l920a
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$9,d1
    bra.w   .l9146
.l920a:                                                 ; $00920A
    cmpi.w  #$2,d2
    beq.w   .l9188
    cmpi.w  #$3,d2
    bne.b   .l921c
    moveq   #-$A,d2
    bra.b   .l926e
.l921c:                                                 ; $00921C
    moveq   #-$1E,d2
    bra.b   .l926e
.l9220:                                                 ; $009220
    moveq   #$0,d3
    move.b  $0003(a2),d3
    tst.w   d2
    bne.b   .l9254
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.w   .l914e
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$3,d1
    bra.w   .l9146
.l9254:                                                 ; $009254
    cmpi.w  #$1,d2
    beq.w   .l91b0
    cmpi.w  #$2,d2
    beq.w   .l9188
    cmpi.w  #$3,d2
    beq.w   .l919a
    moveq   #-$32,d2
.l926e:                                                 ; $00926E
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    ble.b   .l9286
    move.w  d2,d0
    ext.l   d0
    bra.b   .l9290
.l9286:                                                 ; $009286
    move.w  d3,d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
.l9290:                                                 ; $009290
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    bge.b   .l92aa
    move.w  d2,d0
    ext.l   d0
    bra.b   .l92b4
.l92aa:                                                 ; $0092AA
    move.w  d3,d0
    ext.l   d0
    moveq   #$0,d1
    sub.l   d0,d1
    move.l  d1,d0
.l92b4:                                                 ; $0092B4
    move.w  d0,d2
    movem.l (sp)+,d2-d3/a2
    rts
