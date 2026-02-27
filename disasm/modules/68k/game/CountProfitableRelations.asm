; ============================================================================
; CountProfitableRelations -- counts a player's route slots where current revenue exceeds the cost threshold
; Called: ?? times.
; 100 bytes | $0104CA-$01052D
; ============================================================================
CountProfitableRelations:                                                  ; $0104CA
    movem.l d2-d3/a2,-(sp)
    move.l  $0010(sp),d2
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d1
    move.b  $0004(a1),d1
    moveq   #$0,d0
    move.b  $0005(a1),d0
    add.w   d0,d1
    clr.w   d2
    clr.w   d3
    bra.b   .l10522
.l1050a:                                                ; $01050A
    tst.b   $0003(a2)
    beq.b   .l1051c
    move.w  $0006(a2),d0
    cmp.w   $000e(a2),d0
    bls.b   .l1051c
    addq.w  #$1,d3
.l1051c:                                                ; $01051C
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l10522:                                                ; $010522
    cmp.w   d1,d2
    blt.b   .l1050a
    move.w  d3,d0
    movem.l (sp)+,d2-d3/a2
    rts
RankCharCandidates:                                                  ; $01052E
    link    a6,#-$c
    movem.l d2-d6/a2-a4,-(sp)
    move.l  $000c(a6),d4
    move.l  $0008(a6),d5
    lea     -$000c(a6),a4
    pea     ($000C).w
    clr.l   -(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lea     $0010(sp),sp
    move.w  d0,d2
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d6
    move.b  $0002(a3),d6
    moveq   #$0,d0
    move.b  $0003(a3),d0
    add.w   d0,d6
    moveq   #$0,d2
    move.b  (a3),d2
    bra.w   .l10642
.l10586:                                                ; $010586
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    add.l   d1,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l105a0
    moveq   #$0,d2
    move.b  $0002(a3),d2
.l105a0:                                                ; $0105A0
    cmp.w   d2,d4
    beq.w   .l10640
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00ff8824,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.b  (a2),d0
    cmp.b   $0001(a2),d0
    beq.w   .l10640
    move.w  d2,d0
    lsl.w   #$3,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffba80,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.b   $0001(a2)
    bne.b   .l10640
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$5ccc                           ; jsr $035CCC
    lea     $000c(sp),sp
    cmp.w   d3,d0
    bcs.b   .l10640
    moveq   #$0,d3
    move.b  (a2),d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$865e                           ; jsr $00865E
    andi.l  #$ffff,d0
    asr.l   #$1,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    add.w   d1,d0
    move.w  d0,$000a(a4)
    move.w  d2,$0008(a4)
    pea     ($0003).w
    move.l  a4,-(sp)
    dc.w    $4eba,$03c2                                 ; jsr $0109FA
    nop
    lea     $0010(sp),sp
.l10640:                                                ; $010640
    addq.w  #$1,d2
.l10642:                                                ; $010642
    cmp.w   d6,d2
    blt.w   .l10586
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a4,d0.l),a0
    movea.l a0,a2
.l10656:                                                ; $010656
    tst.w   $0002(a2)
    bne.b   .l10660
    move.w  #$ffff,(a2)
.l10660:                                                ; $010660
    addq.l  #$4,a2
    addq.w  #$1,d2
    cmpi.w  #$2,d2
    blt.b   .l10656
    cmpi.w  #$1,$0012(a6)
    bne.b   .l10678
    move.w  -$000c(a6),d0
    bra.b   .l1067c
.l10678:                                                ; $010678
    move.w  $0004(a4),d0
.l1067c:                                                ; $01067C
    movem.l -$002c(a6),d2-d6/a2-a4
    unlk    a6
    rts
; ---------------------------------------------------------------------------
FindBestCharacter:                                                  ; $010686
    link    a6,#-$c
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d6
    move.w  d6,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    pea     ($0008).w
    clr.l   -(sp)
    pea     -$0008(a6)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lea     $0010(sp),sp
    move.w  d0,d2
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d7
    move.b  (a2),d7
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d7
    moveq   #$0,d5
    move.b  (a2),d5
    bra.b   .l10750
.l106e8:                                                ; $0106E8
    clr.w   d2
.l106ea:                                                ; $0106EA
    move.w  d4,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l10746
    move.w  d5,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff1704,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,d3
    tst.w   d3
    blt.b   .l10746
    cmpi.w  #$4,d3
    bge.b   .l10746
    move.w  d3,d0
    add.w   d0,d0
    addq.w  #$1,-$8(a6,d0.w)
.l10746:                                                ; $010746
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l106ea
    addq.w  #$1,d5
.l10750:                                                ; $010750
    cmp.w   d7,d5
    blt.b   .l106e8
    moveq   #$0,d7
    move.b  $0002(a2),d7
    moveq   #$0,d0
    move.b  $0003(a2),d0
    add.w   d0,d7
    moveq   #$0,d5
    move.b  $0002(a2),d5
    bra.b   .l107ce
.l1076a:                                                ; $01076A
    clr.w   d2
.l1076c:                                                ; $01076C
    move.w  d4,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff04e0,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l107c4
    move.w  d5,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff1620,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d0,d3
    tst.w   d3
    blt.b   .l107c4
    cmpi.w  #$4,d3
    bge.b   .l107c4
    move.w  d3,d0
    add.w   d0,d0
    addq.w  #$1,-$8(a6,d0.w)
.l107c4:                                                ; $0107C4
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l1076c
    addq.w  #$1,d5
.l107ce:                                                ; $0107CE
    cmp.w   d7,d5
    blt.b   .l1076a
    clr.w   d2
    clr.w   -$000a(a6)
    clr.w   d4
.l107da:                                                ; $0107DA
    cmpi.w  #$1,d4
    bne.b   .l107e2
    addq.w  #$1,d4
.l107e2:                                                ; $0107E2
    move.w  d4,d0
    add.w   d0,d0
    move.w  -$8(a6,d0.w),d0
    cmp.w   d2,d0
    ble.b   .l107fa
    move.w  d4,d0
    add.w   d0,d0
    move.w  -$8(a6,d0.w),d2
    move.w  d4,-$000a(a6)
.l107fa:                                                ; $0107FA
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l107da
    cmpi.w  #$20,$000e(a6)
    bge.b   .l10836
    move.w  $000e(a6),d0
    mulu.w  #$6,d0
    movea.l #$00ff1704,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  $000e(a6),d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$6,d5
    bra.b   .l1085c
.l10836:                                                ; $010836
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  $000e(a6),d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$4,d5
.l1085c:                                                ; $01085C
    moveq   #-$1,d3
    move.w  d3,d7
    move.l  #$3b9ac9ff,d4
    clr.w   d4
    bra.b   .l108d6
.l1086a:                                                ; $01086A
    cmpi.b  #$0f,(a2)
    beq.b   .l108d0
    cmpi.b  #$ff,(a3)
    bne.b   .l108d0
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    cmp.l   $0006(a5),d2
    bgt.b   .l108d0
    moveq   #$0,d0
    move.b  $0003(a4),d0
    cmp.w   -$000a(a6),d0
    bne.b   .l108c4
    cmpi.l  #$3b9ac9ff,d2
    bcc.b   .l108d0
    moveq   #$0,d3
    move.b  (a2),d3
    bra.b   .l108d0
.l108c4:                                                ; $0108C4
    cmpi.l  #$3b9ac9ff,d2
    bcc.b   .l108d0
    moveq   #$0,d7
    move.b  (a2),d7
.l108d0:                                                ; $0108D0
    addq.w  #$1,d4
    addq.l  #$1,a3
    addq.l  #$1,a2
.l108d6:                                                ; $0108D6
    cmp.w   d5,d4
    blt.b   .l1086a
    move.w  d3,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    bne.b   .l108e6
    move.w  d7,d3
.l108e6:                                                ; $0108E6
    move.w  d3,d0
    movem.l -$0034(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
FindCharByValue:                                                  ; $0108F2
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $000c(a6),d6
    move.w  $000a(a6),d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    cmpi.w  #$20,d6
    bge.b   .l1094e
    move.w  d6,d0
    mulu.w  #$6,d0
    movea.l #$00ff1704,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    mulu.w  #$6,d0
    movea.l #$00ff0420,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$6,d7
    bra.b   .l10970
.l1094e:                                                ; $01094E
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$4,d7
.l10970:                                                ; $010970
    moveq   #-$1,d5
    tst.w   $0012(a6)
    bne.b   .l10980
    move.l  #$3b9ac9ff,d3
    bra.b   .l10982
.l10980:                                                ; $010980
    moveq   #-$1,d3
.l10982:                                                ; $010982
    clr.w   d4
    bra.b   .l109ea
.l10986:                                                ; $010986
    cmpi.b  #$0f,(a2)
    beq.b   .l109e4
    cmpi.b  #$ff,(a3)
    bne.b   .l109e4
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    cmp.l   $0006(a5),d2
    bgt.b   .l109e4
    cmpi.b  #$01,$0003(a4)
    bne.b   .l109e4
    tst.w   $0012(a6)
    bne.b   .l109da
    cmp.l   d3,d2
    bge.b   .l109e4
    bra.b   .l109de
.l109da:                                                ; $0109DA
    cmp.l   d3,d2
    ble.b   .l109e4
.l109de:                                                ; $0109DE
    moveq   #$0,d5
    move.b  (a2),d5
    move.l  d2,d3
.l109e4:                                                ; $0109E4
    addq.w  #$1,d4
    addq.l  #$1,a3
    addq.l  #$1,a2
.l109ea:                                                ; $0109EA
    cmp.w   d7,d4
    blt.b   .l10986
    move.w  d5,d0
    movem.l -$0028(a6),d2-d7/a2-a5
    unlk    a6
    rts
