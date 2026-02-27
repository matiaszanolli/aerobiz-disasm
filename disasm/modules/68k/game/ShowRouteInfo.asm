; ============================================================================
; ShowRouteInfo -- Display route information panel: show player slot details, city/char names, route stats, and price/category labels
; Called: ?? times.
; 1046 bytes | $00F104-$00F519
; ============================================================================
ShowRouteInfo:                                                  ; $00F104
    link    a6,#$0
    movem.l d2-d4/a2-a5,-(sp)
    move.l  $0008(a6),d4
    movea.l #$0003b270,a5
    moveq   #$1,d3
    move.w  d4,d2
    mulu.w  #$b,d2
    addq.w  #$2,d2
    tst.w   d4
    bne.w   .lf322
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0426                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
    tst.w   d0
    bne.b   .lf170
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
    pea     ($0003EA6C).l
.lf168:                                                 ; $00F168
    jsr     (a5)
    addq.l  #$4,sp
    bra.w   .lf518
.lf170:                                                 ; $00F170
    movea.l #$00ff1804,a4
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
    movea.l a4,a3
    lea     $00a4(a3),a3
    addq.w  #$1,d2
    clr.w   d3
.lf186:                                                 ; $00F186
    cmpi.b  #$20,$0001(a2)
    bcc.b   .lf1fe
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  a3,-(sp)
    pea     ($0003EA66).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA62).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA5C).l
    jsr     (a5)
    lea     $0030(sp),sp
.lf1fe:                                                 ; $00F1FE
    moveq   #$24,d0
    adda.l  d0,a2
    moveq   #$10,d0
    adda.l  d0,a3
    addq.w  #$2,d2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .lf186
    tst.w   d4
    bne.b   .lf21a
    moveq   #$2,d2
    bra.b   .lf21c
.lf21a:                                                 ; $00F21A
    moveq   #$d,d2
.lf21c:                                                 ; $00F21C
    addq.w  #$1,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA58).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA54).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA50).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA4C).l
    jsr     (a5)
    move.w  $0008(a4),d3
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.l  d0,d4
    mulu.w  #$3,d4
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    bge.b   .lf2cc
    addq.l  #$3,d0
.lf2cc:                                                 ; $00F2CC
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d3
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA48).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA44).l
    bra.w   .lf516
.lf322:                                                 ; $00F322
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$022a                                 ; jsr $00F552
    nop
    addq.l  #$4,sp
    tst.w   d0
    bne.b   .lf368
    pea     ($000A).w
    pea     ($001E).w
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0018(sp),sp
    pea     ($0003EA36).l
    bra.w   .lf168
.lf368:                                                 ; $00F368
    movea.l #$00ff1804,a4
    movea.l a4,a2
    moveq   #$14,d0
    adda.l  d0,a2
    movea.l a4,a3
    lea     $00a4(a3),a3
    addq.w  #$1,d2
    clr.w   d3
.lf37e:                                                 ; $00F37E
    cmpi.b  #$20,$0001(a2)
    bcc.b   .lf3f6
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  a3,-(sp)
    pea     ($0003EA30).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000B).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005f926,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA2C).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA26).l
    jsr     (a5)
    lea     $0030(sp),sp
.lf3f6:                                                 ; $00F3F6
    moveq   #$24,d0
    adda.l  d0,a2
    moveq   #$10,d0
    adda.l  d0,a3
    addq.w  #$2,d2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .lf37e
    tst.w   d4
    bne.b   .lf412
    moveq   #$2,d2
    bra.b   .lf414
.lf412:                                                 ; $00F412
    moveq   #$d,d2
.lf414:                                                 ; $00F414
    addq.w  #$1,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA22).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0006(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA1E).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     ($0003EA1A).l
    jsr     (a5)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001C).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0007(a4),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0003EA16).l
    jsr     (a5)
    move.w  $0008(a4),d3
    move.w  d3,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.l  d0,d4
    mulu.w  #$3,d4
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$c,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d4
    move.w  d3,d0
    ext.l   d0
    bge.b   .lf4c4
    addq.l  #$3,d0
.lf4c4:                                                 ; $00F4C4
    asr.l   #$2,d0
    addi.w  #$07a3,d0
    move.w  d0,d3
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0019).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0003EA12).l
    jsr     (a5)
    addq.w  #$2,d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0020(sp),sp
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005f096,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0003EA0E).l
.lf516:                                                 ; $00F516
    jsr     (a5)
.lf518:                                                 ; $00F518
    movem.l -$1C(a6),d2-d4/a2-a5
    unlk    a6
    rts
; === Translated block $00F522-$00F552 ===
; 1 functions, 48 bytes
