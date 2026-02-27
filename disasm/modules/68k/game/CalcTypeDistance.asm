; ============================================================================
; CalcTypeDistance -- Return absolute category distance between two char types from $FF1298/$FF99A4 tables
; Called: 10 times.
; 140 bytes | $007610-$00769B
; ============================================================================
CalcTypeDistance:                                                  ; $007610
    movem.l d2-d3,-(sp)
    move.w  $000e(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    move.b  (a0,d0.w),d2
    andi.l  #$ff,d2
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    move.b  (a0,d0.w),d1
    andi.l  #$ff,d1
    cmp.w   d1,d2
    bne.b   .l7648
    clr.w   d2
    bra.b   .l7694
.l7648:                                                 ; $007648
    movea.l #$00ff99a4,a0
    move.b  (a0,d2.w),d3
    andi.l  #$ff,d3
    movea.l #$00ff99a4,a0
    move.b  (a0,d1.w),d2
    andi.l  #$ff,d2
    cmpi.w  #$4,d3
    beq.b   .l7692
    cmpi.w  #$4,d2
    beq.b   .l7692
    move.w  d3,d0
    sub.w   d2,d0
    move.w  d0,d2
    tst.w   d2
    bge.b   .l7682
    neg.w   d2
    bra.b   .l7694
.l7682:                                                 ; $007682
    tst.w   d2
    bne.b   .l7694
    cmpi.w  #$1,d3
    beq.b   .l7692
    cmpi.w  #$2,d3
    bne.b   .l7694
.l7692:                                                 ; $007692
    moveq   #$1,d2
.l7694:                                                 ; $007694
    move.w  d2,d0
    movem.l (sp)+,d2-d3
    rts
CalcCharRating:                                                  ; $00769C
    link    a6,#-$4
    movem.l d2-d6,-(sp)
    move.l  $000c(a6),d2
    move.l  $0008(a6),d4
    clr.w   d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$26d6                                 ; jsr $009D92
    nop
    move.w  d0,d6
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    lea     $0014(sp),sp
    ext.l   d0
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    beq.b   .l7708
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$002a                                 ; jsr $007728
    nop
    cmpi.w  #$1,d0
    bne.b   .l770a
.l7708:                                                 ; $007708
    moveq   #$1,d3
.l770a:                                                 ; $00770A
    move.w  d6,d2
    mulu.w  #$19,d2
    move.w  d3,d0
    mulu.w  #$19,d0
    sub.w   d0,d2
    addi.w  #$32,d2
    move.w  d2,d0
    movem.l -$0018(a6),d2-d6
    unlk    a6
    rts
