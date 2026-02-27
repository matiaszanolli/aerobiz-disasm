; ============================================================================
; CalcCharOutput -- Compute character productivity for a route and time slot using stat descriptors, region params, and scenario scaling
; Called: ?? times.
; 568 bytes | $00969A-$0098D1
; ============================================================================
CalcCharOutput:                                                  ; $00969A
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0028(sp),d2
    move.l  $002c(sp),d3
    move.l  $0030(sp),d4
    movea.l $0034(sp),a2
    cmpi.w  #$20,d3
    bcc.b   .l96c4
    move.w  d3,d0
    mulu.w  #$6,d0
    add.w   d4,d0
    movea.l #$00ff1704,a0
    bra.b   .l96d0
.l96c4:                                                 ; $0096C4
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d4,d0
    movea.l #$00ff15a0,a0
.l96d0:                                                 ; $0096D0
    move.b  (a0,d0.w),d5
    andi.l  #$ff,d5
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    tst.b   $0003(a4)
    bne.b   .l9724
    moveq   #$0,d0
    move.b  $0002(a3),d0
.l9706:                                                 ; $009706
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    andi.l  #$ffff,d1
.l9718:                                                 ; $009718
    add.l   d1,d0
    bge.b   .l971e
    addq.l  #$1,d0
.l971e:                                                 ; $00971E
    asr.l   #$1,d0
    bra.w   .l97b0
.l9724:                                                 ; $009724
    cmpi.b  #$01,$0003(a4)
    bne.b   .l9742
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    bra.b   .l9706
.l9742:                                                 ; $009742
    cmpi.b  #$02,$0003(a4)
    bne.b   .l9760
    moveq   #$0,d0
    move.b  $0002(a3),d0
.l9750:                                                 ; $009750
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.w  ($00FFBA68).l,d1
    bra.b   .l9718
.l9760:                                                 ; $009760
    cmpi.b  #$03,$0003(a4)
    bne.b   .l9770
    moveq   #$0,d0
    move.b  $0003(a3),d0
    bra.b   .l9750
.l9770:                                                 ; $009770
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0120,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0003(a5),d1
    andi.l  #$ffff,d1
    add.l   d1,d0
    moveq   #$0,d1
    move.b  $0002(a5),d1
    andi.l  #$ffff,d1
    add.l   d1,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l97b0:                                                 ; $0097B0
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  $0026(sp),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d4,d1
    add.l   d1,d0
    moveq   #$8,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d3
    cmpi.w  #$5,d3
    blt.b   .l97da
    moveq   #$8,d0
    sub.w   d3,d0
    move.w  d0,d3
.l97da:                                                 ; $0097DA
    addq.w  #$8,d3
    moveq   #$0,d0
    move.b  (a4),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.b  $0001(a3),d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,(a2)
    moveq   #$1,d0
    cmp.l   (a2),d0
    bge.b   .l981a
    move.l  (a2),d0
    bra.b   .l981c
.l981a:                                                 ; $00981A
    moveq   #$1,d0
.l981c:                                                 ; $00981C
    move.l  d0,(a2)
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$6,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$46,d0
    move.l  (a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,(a2)
    moveq   #$0,d0
    move.b  $0001(a4),d0
    move.l  (a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  ($00FF1294).l,d1
    ext.l   d1
    move.l  #$82,d2
    sub.l   d1,d2
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,d2
    move.w  d3,d0
    ext.l   d0
    subi.l  #$9,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    tst.l   d0
    bge.b   .l989e
    addq.l  #$1,d0
.l989e:                                                 ; $00989E
    asr.l   #$1,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    move.l  d0,d2
    move.l  (a2),d0
    bge.b   .l98ae
    addq.l  #$1,d0
.l98ae:                                                 ; $0098AE
    asr.l   #$1,d0
    cmp.l   d2,d0
    ble.b   .l98b8
    move.l  d2,d0
    bra.b   .l98c0
.l98b8:                                                 ; $0098B8
    move.l  (a2),d0
    bge.b   .l98be
    addq.l  #$1,d0
.l98be:                                                 ; $0098BE
    asr.l   #$1,d0
.l98c0:                                                 ; $0098C0
    move.l  d0,d2
    move.l  (a2),d0
    sub.l   d2,d0
    movea.l $0038(sp),a0
    move.l  d0,(a0)
    movem.l (sp)+,d2-d5/a2-a5
    rts
