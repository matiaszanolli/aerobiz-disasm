; ============================================================================
; CollectPlayerChars -- Collect and sort purchasable characters for player filtered by ownership and stat range, calling CalcCharValue for each
; Called: ?? times.
; 498 bytes | $00E152-$00E343
; ============================================================================
CollectPlayerChars:                                                  ; $00E152
    link    a6,#-$10
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0010(a6),d3
    move.l  $0008(a6),d7
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    cmpi.w  #$5,d3
    bge.b   .le1ac
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f908,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,-$000c(a6)
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$0005f909,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,-$000e(a6)
    bra.b   .le1b6
.le1ac:                                                 ; $00E1AC
    clr.w   -$000c(a6)
    move.w  #$e,-$000e(a6)
.le1b6:                                                 ; $00E1B6
    lea     -$000a(a6),a3
    clr.w   d5
    clr.w   d4
    moveq   #$0,d3
    move.b  (a5),d3
    moveq   #$0,d6
    move.b  $0001(a5),d6
    bra.w   .le276
.le1cc:                                                 ; $00E1CC
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00ff1704,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.le1f2:                                                 ; $00E1F2
    moveq   #$0,d0
    move.b  (a4),d0
    move.w  d7,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .le266
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000c(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    blt.b   .le266
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000e(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    bgt.b   .le266
    move.w  d3,(a3)
    move.w  d2,$0002(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d0,$0004(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    bsr.w CalcCharValue
    move.l  d0,$0006(a3)
    pea     ($000A).w
    move.w  d5,d0
    add.w   d0,d0
    movea.l #$00ff1a04,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0020(sp),sp
    addi.w  #$a,d5
    addq.w  #$1,d4
.le266:                                                 ; $00E266
    addq.l  #$1,a2
    addq.l  #$1,a4
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .le1f2
    subq.w  #$1,d6
    addq.w  #$1,d3
.le276:                                                 ; $00E276
    tst.w   d6
    bgt.w   .le1cc
    moveq   #$0,d3
    move.b  $0002(a5),d3
    moveq   #$0,d6
    move.b  $0003(a5),d6
    bra.w   .le332
.le28c:                                                 ; $00E28C
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.le2ae:                                                 ; $00E2AE
    moveq   #$0,d0
    move.b  (a4),d0
    move.w  d7,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .le322
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000c(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    blt.b   .le322
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  -$000e(a6),d1
    ext.l   d1
    cmp.l   d1,d0
    bgt.b   .le322
    move.w  d3,(a3)
    move.w  d2,$0002(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d0,$0004(a3)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    bsr.w CalcCharValue
    move.l  d0,$0006(a3)
    pea     ($000A).w
    move.w  d5,d0
    add.w   d0,d0
    movea.l #$00ff1a04,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0020(sp),sp
    addi.w  #$a,d5
    addq.w  #$1,d4
.le322:                                                 ; $00E322
    addq.l  #$1,a2
    addq.l  #$1,a4
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .le2ae
    subq.w  #$1,d6
    addq.w  #$1,d3
.le332:                                                 ; $00E332
    tst.w   d6
    bgt.w   .le28c
    move.w  d4,d0
    movem.l -$0038(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $00E344-$00E6B2 ===
; 2 functions, 878 bytes
