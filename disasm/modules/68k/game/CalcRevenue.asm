; ============================================================================
; CalcRevenue -- Accumulate total route revenue for a player scaled by flight frequency, popularity, and ticket price
; Called: ?? times.
; 704 bytes | $0092BC-$00957B
; ============================================================================
CalcRevenue:                                                  ; $0092BC
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0024(sp),d2
    move.l  $0020(sp),d3
    move.l  $0028(sp),d5
    movea.l #$00ff1298,a4
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d4
    tst.w   d2
    bne.w   .l93c6
    clr.w   d3
    bra.b   .l9378
.l9302:                                                 ; $009302
    move.b  $000a(a2),d0
    andi.l  #$2,d0
    bne.b   .l9372
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,d2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    mulu.w  #$c,d0
    movea.l #$00ffa6c1,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.l  #$4,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d4
.l9372:                                                 ; $009372
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l9378:                                                 ; $009378
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    bgt.w   .l9302
    move.l  d4,d0
    moveq   #$32,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d4
    moveq   #$a,d0
    cmp.l   d4,d0
    bcc.b   .l93a6
    move.l  d4,d0
    bra.b   .l93a8
.l93a6:                                                 ; $0093A6
    moveq   #$a,d0
.l93a8:                                                 ; $0093A8
    move.l  d0,d4
    move.l  #$1388,d1
.l93b0:                                                 ; $0093B0
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    move.l  #$2710,d1
    bra.w   .l9530
.l93c6:                                                 ; $0093C6
    cmpi.w  #$1,d2
    bne.w   .l9490
    clr.w   d3
    bra.w   .l9454
.l93d4:                                                 ; $0093D4
    move.b  $000a(a2),d0
    andi.l  #$2,d0
    bne.b   .l944e
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,d2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.l  #$4,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  (sp)+,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    lsr.l   #$5,d0
    add.l   d0,d4
.l944e:                                                 ; $00944E
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l9454:                                                 ; $009454
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    bgt.w   .l93d4
    move.l  d4,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d4
    moveq   #$a,d0
    cmp.l   d4,d0
    bcc.b   .l9482
    move.l  d4,d0
    bra.b   .l9484
.l9482:                                                 ; $009482
    moveq   #$a,d0
.l9484:                                                 ; $009484
    move.l  d0,d4
    move.l  #$1d4c,d1
    bra.w   .l93b0
.l9490:                                                 ; $009490
    movea.l a4,a2
    clr.w   d2
.l9494:                                                 ; $009494
    move.w  d2,d0
    lsl.w   #$3,d0
    move.w  d3,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba81,a0
    tst.b   (a0,d0.w)
    beq.b   .l94be
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d4
.l94be:                                                 ; $0094BE
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$59,d2
    bcs.b   .l9494
    moveq   #$0,d0
    move.b  $0001(a3),d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a4,a0.l),d0
    andi.l  #$ff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.b  $3(a4,a0.l),d1
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    cmp.l   d4,d0
    bcc.b   .l94fe
    move.l  d4,d0
    bra.b   .l952c
.l94fe:                                                 ; $0094FE
    moveq   #$0,d0
    move.b  $0001(a3),d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a4,a0.l),d0
    andi.l  #$ff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.b  $3(a4,a0.l),d1
    andi.l  #$ff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l952c:                                                 ; $00952C
    move.l  d0,d4
    moveq   #$32,d1
.l9530:                                                 ; $009530
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    movem.l (sp)+,d2-d5/a2-a4
    rts
