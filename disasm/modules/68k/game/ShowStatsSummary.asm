; ============================================================================
; ShowStatsSummary -- Computes rank change for a player, formats a summary string, builds the quarterly route/char bonus table, filters by age, and calls result-display for each slot
; Called: ?? times.
; 1030 bytes | $018214-$018619
; ============================================================================
ShowStatsSummary:                                                  ; $018214
    link    a6,#-$d4
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d6
    lea     -$00b0(a6),a5
    clr.w   d7
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$045a                           ; jsr $01045A
    move.w  d0,-$00d2(a6)
    move.w  ($00FF0006).l,d5
    ext.l   d5
    asr.l   #$2,d5
    addi.w  #$37,d5
    tst.w   -$00d2(a6)
    ble.b   .l1824a
    moveq   #$1,d7
.l1824a:                                                ; $01824A
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0492                           ; jsr $010492
    addq.l  #$8,sp
    move.w  d0,d2
    tst.w   d2
    bne.b   .l1827e
    move.l  ($00047B7C).l,-(sp)
    move.l  ($00047C1C).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    pea     ($0002).w
    move.l  a5,-(sp)
    bra.w   .l185f6
.l1827e:                                                ; $01827E
    cmp.w   -$00d2(a6),d2
    bne.b   .l182b2
    cmpi.w  #$1,d2
    bne.b   .l18292
    pea     ($000410A4).l
    bra.b   .l18298
.l18292:                                                ; $018292
    pea     ($0004109C).l
.l18298:                                                ; $018298
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C2C).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0010(sp),sp
    bra.b   .l18318
.l182b2:                                                ; $0182B2
    tst.w   -$00d2(a6)
    bne.b   .l182d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C28).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    bra.b   .l18318
.l182d2:                                                ; $0182D2
    move.w  d2,d0
    ext.l   d0
    move.w  -$00d2(a6),d1
    ext.l   d1
    sub.l   d1,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bne.b   .l182ec
    pea     ($00041096).l
    bra.b   .l182f2
.l182ec:                                                ; $0182EC
    pea     ($0004108E).l
.l182f2:                                                ; $0182F2
    move.w  d2,d0
    ext.l   d0
    move.w  -$00d2(a6),d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($00047C24).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0014(sp),sp
.l18318:                                                ; $018318
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $0010(sp),sp
    clr.w   d2
    move.w  d2,d0
    lsl.w   #$2,d0
    lea     -$10(a6,d0.w),a0
    movea.l a0,a2
.l18346:                                                ; $018346
    move.w  #$ffff,(a2)
    move.w  #$ffff,$0002(a2)
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l18346
    clr.w   d2
.l1835c:                                                ; $01835C
    move.w  d2,d0
    add.w   d0,d0
    lea     -$00d0(a6),a0
    move.w  #$ffff,(a0,d0.w)
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l1835c
    move.w  d6,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0004(a2),d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a2),d1
    ext.l   d1
    add.l   d1,d0
    ble.w   .l1841e
    move.w  d6,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d2
    move.b  $0004(a2),d2
    moveq   #$0,d0
    move.b  $0005(a2),d0
    add.w   d0,d2
    clr.w   d3
    bra.b   .l1841a
.l183be:                                                ; $0183BE
    moveq   #$1,d4
    bra.b   .l183c4
.l183c2:                                                ; $0183C2
    addq.w  #$1,d4
.l183c4:                                                ; $0183C4
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$7412                           ; jsr $007412
    addq.l  #$4,sp
    ext.l   d0
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$e,d1
    cmp.l   d0,d1
    bgt.b   .l183c2
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.w  d4,d1
    sub.w   d0,d1
    move.w  d1,d4
    tst.w   d4
    ble.b   .l18414
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    add.w   d0,d0
    lea     -$00d0(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a2
    add.w   d4,(a2)
.l18414:                                                ; $018414
    moveq   #$14,d0
    adda.l  d0,a3
    addq.w  #$1,d3
.l1841a:                                                ; $01841A
    cmp.w   d2,d3
    blt.b   .l183be
.l1841e:                                                ; $01841E
    clr.w   d3
    move.w  d6,d0
    lsl.w   #$5,d0
    move.w  d3,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    add.w   d0,d0
    lea     -$00d0(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a4
.l18444:                                                ; $018444
    clr.w   d4
    tst.w   (a4)
    ble.w   .l184d0
    move.w  d3,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0007(a2),d0
    ext.l   d0
    move.w  d5,d1
    ext.l   d1
    addq.l  #$2,d1
    cmp.l   d1,d0
    bgt.b   .l18480
    moveq   #$0,d0
    move.b  $0007(a2),d0
    cmp.w   d5,d0
    ble.b   .l18480
.l1847a:                                                ; $01847A
    move.w  #$ffff,(a4)
    bra.b   .l184d0
.l18480:                                                ; $018480
    move.w  d6,d0
    mulu.w  #$14,d0
    movea.l #$00ff02e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
.l18494:                                                ; $018494
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d3,d0
    bne.b   .l184a4
    moveq   #$0,d4
    move.b  $0001(a2),d4
    bra.b   .l184ae
.l184a4:                                                ; $0184A4
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$5,d2
    blt.b   .l18494
.l184ae:                                                ; $0184AE
    move.w  d4,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3),d1
    ext.l   d1
    add.l   d1,d0
    moveq   #$63,d1
    cmp.l   d0,d1
    ble.b   .l1847a
    cmpi.w  #$1,d7
    bne.b   .l184ce
    moveq   #$0,d0
    move.b  $0001(a3),d0
    add.w   d0,d4
.l184ce:                                                ; $0184CE
    sub.w   d4,(a4)
.l184d0:                                                ; $0184D0
    addq.l  #$2,a4
    addq.l  #$2,a3
    addq.w  #$1,d3
    cmpi.w  #$10,d3
    blt.w   .l18444
    clr.w   d3
    move.w  d3,d0
    add.w   d0,d0
    lea     -$00d0(a6),a0
    lea     (a0,d0.w),a1
    movea.l a1,a2
.l184ee:                                                ; $0184EE
    tst.w   (a2)
    blt.b   .l1850a
    move.w  d3,-$0004(a6)
    move.w  (a2),-$0002(a6)
    pea     ($0004).w
    pea     -$0010(a6)
    dc.w    $4eb9,$0001,$09fa                           ; jsr $0109FA
    addq.l  #$8,sp
.l1850a:                                                ; $01850A
    addq.l  #$2,a2
    addq.w  #$1,d3
    cmpi.w  #$10,d3
    blt.b   .l184ee
    clr.w   d3
    clr.w   d2
    move.w  d2,d0
    lsl.w   #$2,d0
    lea     -$10(a6,d0.w),a0
    movea.l a0,a3
.l18522:                                                ; $018522
    move.w  (a3),d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l185be
    move.w  d2,d0
    lsl.w   #$2,d0
    tst.w   -$e(a6,d0.w)
    ble.w   .l185be
    move.w  (a3),d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0006(a2),d0
    cmp.w   d5,d0
    bgt.b   .l18564
    moveq   #$0,d0
    move.b  $0007(a2),d0
    cmp.w   d5,d0
    blt.b   .l18564
    move.w  d2,d3
    bra.b   .l18566
.l18564:                                                ; $018564
    moveq   #$5,d3
.l18566:                                                ; $018566
    move.w  (a3),d0
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00047c0c,a0
    move.l  (a0,d0.w),-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $001c(sp),sp
    moveq   #$1,d3
.l185be:                                                ; $0185BE
    addq.l  #$4,a3
    addq.w  #$1,d2
    cmpi.w  #$2,d2
    blt.w   .l18522
    move.w  d3,d0
    or.w    -$00d2(a6),d0
    bne.b   .l185dc
    clr.l   -(sp)
    move.l  ($00047C30).l,-(sp)
    bra.b   .l185f6
.l185dc:                                                ; $0185DC
    clr.l   -(sp)
    cmpi.w  #$1,d3
    bne.b   .l185e8
    moveq   #$2,d0
    bra.b   .l185ea
.l185e8:                                                ; $0185E8
    moveq   #$3,d0
.l185ea:                                                ; $0185EA
    lsl.w   #$2,d0
    movea.l #$00047c0c,a0
    move.l  (a0,d0.w),-(sp)
.l185f6:                                                ; $0185F6
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    movem.l -$00FC(a6),d2-d7/a2-a5
    unlk    a6
    rts
