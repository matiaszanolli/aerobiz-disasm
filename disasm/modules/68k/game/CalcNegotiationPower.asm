; ============================================================================
; CalcNegotiationPower -- Compute negotiation power from two stat descriptors, win_bottom scaling, and route type bonus
; Called: ?? times.
; 476 bytes | $00865E-$008839
; ============================================================================
CalcNegotiationPower:                                                  ; $00865E
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0030(sp),d4
    move.l  $002c(sp),d5
    movea.l #$00ffbd4c,a4
    movea.l #$00ff0002,a5
    moveq   #$a,d6
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a4),d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0002(a2),d0
    ext.l   d0
    move.w  (a4),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$5a,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.w  #$a,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0001(a3),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$50,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d7
    move.w  (a4),d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0002(a3),d0
    ext.l   d0
    move.w  (a4),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0003(a2),d0
    andi.l  #$ffff,d0
    moveq   #$5a,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.w  #$a,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$50,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.w  d2,d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d6,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    move.w  d0,d3
    cmpi.w  #$3,d3
    bne.b   .l87d4
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l87ce
    addq.l  #$3,d0
.l87ce:                                                 ; $0087CE
    asr.l   #$2,d0
.l87d0:                                                 ; $0087D0
    move.w  d0,d2
    bra.b   .l87fa
.l87d4:                                                 ; $0087D4
    cmpi.w  #$2,d3
    bne.b   .l87e6
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l87e2
    addq.l  #$1,d0
.l87e2:                                                 ; $0087E2
    asr.l   #$1,d0
    bra.b   .l87d0
.l87e6:                                                 ; $0087E6
    cmpi.w  #$1,d3
    bne.b   .l87fa
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$5,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    sub.w   d0,d2
.l87fa:                                                 ; $0087FA
    tst.w   (a5)
    bne.b   .l880c
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l8806
    addq.l  #$1,d0
.l8806:                                                 ; $008806
    asr.l   #$1,d0
.l8808:                                                 ; $008808
    add.w   d0,d2
    bra.b   .l8832
.l880c:                                                 ; $00880C
    cmpi.w  #$1,(a5)
    bne.b   .l881e
    moveq   #$0,d0
    move.w  d2,d0
    bge.b   .l881a
    addq.l  #$3,d0
.l881a:                                                 ; $00881A
    asr.l   #$2,d0
    bra.b   .l8808
.l881e:                                                 ; $00881E
    cmpi.w  #$3,(a5)
    bne.b   .l8832
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    sub.w   d0,d2
.l8832:                                                 ; $008832
    move.w  d2,d0
    movem.l (sp)+,d2-d7/a2-a5
    rts
