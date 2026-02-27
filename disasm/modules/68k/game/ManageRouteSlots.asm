; ============================================================================
; ManageRouteSlots -- Interactive browser for a player's route slots; builds slot revenue list, renders route slot screen, and handles slot selection input.
; Called: ?? times.
; 1366 bytes | $0112EE-$011843
; ============================================================================
ManageRouteSlots:                                                  ; $0112EE
    link    a6,#-$a0
    movem.l d2-d7/a2-a5,-(sp)
    move.w  #$03ff,-$009a(a6)
    move.w  #$06a2,-$009c(a6)
    moveq   #$1,d7
    move.w  $000a(a6),d0
    lsl.w   #$5,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    lea     -$000a(a6),a3
    clr.w   d3
.l1131c:                                                ; $01131C
    tst.b   $0001(a2)
    beq.b   .l11334
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,(a3)
    bra.b   .l11338
.l11334:                                                ; $011334
    move.w  #$ffff,(a3)
.l11338:                                                ; $011338
    addq.l  #$8,a2
    addq.l  #$2,a3
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l1131c
    move.w  #$ffff,(a3)
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w RenderRouteSlotScreen
    move.w  #$026a,-$0012(a6)
    move.w  #$04ae,-$0010(a6)
    move.w  #$0666,-$000e(a6)
    move.w  #$0aaa,-$000c(a6)
    pea     ($0004).w
    pea     ($0031).w
    pea     -$0012(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0040).w
    clr.l   -(sp)
    pea     -$0094(a6)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $0020(sp),sp
    cmpi.w  #$4,$000e(a6)
    bge.b   .l113e8
    movea.l ($00047992).l,a0
    lea     -$0094(a6),a1
.l113ac:                                                ; $0113AC
    move.b  (a0)+,(a1)+
    bne.b   .l113ac
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$00047982,a0
    move.l  (a0,d0.w),-(sp)
    pea     -$0094(a6)
    dc.w    $4eb9,$0001,$e1ba                           ; jsr $01E1BA
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     -$0094(a6)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $001c(sp),sp
    bra.b   .l113f8
.l113e8:                                                ; $0113E8
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$c43c                           ; jsr $01C43C
    addq.l  #$4,sp
.l113f8:                                                ; $0113F8
    lea     -$000a(a6),a3
    clr.w   d3
    moveq   #$c,d2
    moveq   #$1,d6
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l11414
    moveq   #$1,d0
    bra.b   .l11416
.l11414:                                                ; $011414
    moveq   #$0,d0
.l11416:                                                ; $011416
    move.w  d0,-$00a0(a6)
    clr.w   d5
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   -$009e(a6)
    move.w  $000a(a6),d0
    lsl.w   #$5,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    lea     -$000c(a6),a4
.l11442:                                                ; $011442
    move.w  d5,d0
    andi.w  #$f,d0
    beq.b   .l1144c
    moveq   #$1,d7
.l1144c:                                                ; $01144C
    cmpi.w  #$1,d7
    bne.b   .l114b8
    cmp.w   -$0096(a6),d2
    bne.b   .l1145e
    cmp.w   -$0098(a6),d6
    beq.b   .l114b6
.l1145e:                                                ; $01145E
    clr.l   -(sp)
    pea     ($0011).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($000C).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0009).w
    pea     ($0007).w
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0003F1B0).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0030(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w ShowRouteDetailsDialog
    addq.l  #$8,sp
.l114b6:                                                ; $0114B6
    clr.w   d7
.l114b8:                                                ; $0114B8
    tst.w   -$00a0(a6)
    beq.b   .l114ce
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l11442
.l114ce:                                                ; $0114CE
    clr.w   -$00a0(a6)
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    move.w  d0,d5
    move.w  d2,-$0096(a6)
    move.w  d6,-$0098(a6)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    movea.l a0,a2
    cmpi.b  #$06,$0001(a2)
    beq.b   .l1150e
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a3,a0.l),d4
    bra.b   .l1152c
.l1150e:                                                ; $01150E
    cmpi.w  #$3,$0006(a2)
    bne.b   .l11528
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d4
    bra.b   .l1152c
.l11528:                                                ; $011528
    moveq   #$0,d4
    move.b  (a2),d4
.l1152c:                                                ; $01152C
    cmpi.w  #$ffff,d4
    beq.b   .l11582
    cmpi.w  #$2,-$009e(a6)
    bge.b   .l11550
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0
    move.l  d0,-(sp)
    pea     -$009a(a6)
    bra.b   .l11564
.l11550:                                                ; $011550
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0
    move.l  d0,-(sp)
    pea     -$009c(a6)
.l11564:                                                ; $011564
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    move.w  -$009e(a6),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,-$009e(a6)
.l11582:                                                ; $011582
    move.w  d5,d0
    andi.w  #$3f,d0
    beq.w   .l11814
    cmpi.w  #$ffff,d4
    beq.b   .l115b0
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d4,d0
    addi.l  #$38,d0
    move.l  d0,-(sp)
    pea     -$009c(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
.l115b0:                                                ; $0115B0
    move.w  d5,d0
    andi.w  #$20,d0
    beq.w   .l116da
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmpi.w  #$4,d3
    bge.w   .l11828
    cmpi.w  #$4,$000e(a6)
    bge.w   .l116da
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    movea.l a0,a2
    tst.b   $0001(a2)
    bne.w   .l1168c
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$30,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$28,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$3b,d0
    move.l  d0,-(sp)
    pea     ($0546).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($000A).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$30,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$28,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addi.l  #$3b,d0
    move.l  d0,-(sp)
    pea     ($0548).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($000A).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0024(sp),sp
    bra.w   .l11828
.l1168c:                                                ; $01168C
    moveq   #$0,d4
    move.b  $0001(a2),d4
    addi.w  #$ffff,d4
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00047800,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047996).l,-(sp)
    pea     -$0094(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     -$0094(a6)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0168                                 ; jsr $01183A
    nop
    lea     $0024(sp),sp
.l116da:                                                ; $0116DA
    move.w  d5,d0
    andi.w  #$10,d0
    beq.b   .l116f6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  #$ff,d3
    bra.w   .l11828
.l116f6:                                                ; $0116F6
    move.w  d3,d4
    move.w  d5,d0
    andi.w  #$1,d0
    beq.b   .l11716
    move.w  #$1,($00FF13FC).l
    cmpi.w  #$18,d2
    bge.b   .l11716
    cmpi.w  #$9,d6
    bne.b   .l11716
    moveq   #$1,d6
.l11716:                                                ; $011716
    move.w  d5,d0
    andi.w  #$2,d0
    beq.b   .l1172e
    move.w  #$1,($00FF13FC).l
    cmpi.w  #$1,d6
    bne.b   .l1172e
    moveq   #$9,d6
.l1172e:                                                ; $01172E
    move.w  d5,d0
    andi.w  #$4,d0
    beq.b   .l11756
    move.w  #$1,($00FF13FC).l
    move.w  d2,d0
    ext.l   d0
    subq.l  #$6,d0
    moveq   #$c,d1
    cmp.l   d0,d1
    bge.b   .l11752
    move.w  d2,d0
    ext.l   d0
    subq.l  #$6,d0
    bra.b   .l11754
.l11752:                                                ; $011752
    moveq   #$c,d0
.l11754:                                                ; $011754
    move.w  d0,d2
.l11756:                                                ; $011756
    move.w  d5,d0
    andi.w  #$8,d0
    beq.b   .l117a4
    move.w  #$1,($00FF13FC).l
    addq.w  #$6,d2
    cmpi.w  #$1,d6
    bne.b   .l1177a
    cmpi.w  #$12,d2
    bge.b   .l117a0
.l11774:                                                ; $011774
    move.w  d2,d0
    ext.l   d0
    bra.b   .l117a2
.l1177a:                                                ; $01177A
    cmpi.w  #$18,d2
    bge.b   .l11786
    move.w  d2,d0
    ext.l   d0
    bra.b   .l11788
.l11786:                                                ; $011786
    moveq   #$18,d0
.l11788:                                                ; $011788
    move.w  d0,d2
    cmpi.w  #$3,$000e(a6)
    beq.b   .l1179a
    cmpi.w  #$4,$000e(a6)
    bne.b   .l117a4
.l1179a:                                                ; $01179A
    cmpi.w  #$12,d2
    blt.b   .l11774
.l117a0:                                                ; $0117A0
    moveq   #$12,d0
.l117a2:                                                ; $0117A2
    move.w  d0,d2
.l117a4:                                                ; $0117A4
    cmpi.w  #$18,d2
    bge.b   .l117e0
    move.w  d2,d0
    ext.l   d0
    subi.l  #$c,d0
    moveq   #$6,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    move.w  d6,d0
    ext.l   d0
    asr.l   #$3,d0
    add.w   d0,d0
    add.w   d0,d3
    move.w  #$026a,-$0012(a6)
    move.w  #$04ae,-$0010(a6)
    move.w  #$0666,-$000e(a6)
    move.w  #$0aaa,(a4)
    bra.b   .l117f8
.l117e0:                                                ; $0117E0
    moveq   #$4,d3
    move.w  #$0666,-$0012(a6)
    move.w  #$0aaa,-$0010(a6)
    move.w  #$026a,-$000e(a6)
    move.w  #$04ae,(a4)
.l117f8:                                                ; $0117F8
    pea     ($0004).w
    pea     ($0031).w
    pea     -$0012(a6)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    cmp.w   d3,d4
    beq.b   .l11814
    moveq   #$1,d7
.l11814:                                                ; $011814
    pea     ($0003).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    bra.w   .l11442
.l11828:                                                ; $011828
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    move.w  d3,d0
    movem.l -$00c8(a6),d2-d7/a2-a5
    unlk    a6
    rts
