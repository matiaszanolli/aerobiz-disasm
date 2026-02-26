; ===========================================================================
; ROM Data: $010000-$01FFFF
; 65536 bytes (32768 words)
; ===========================================================================

    move.l  $0008(a6),d6
    clr.w   d5
    clr.w   d4
    move.w  ($00FF0006).l,d7
    addi.w  #$ffff,d7
    clr.w   d3
.l10014:                                                ; $010014
    clr.w   d2
.l10016:                                                ; $010016
    move.w  d3,d0
    mulu.w  #$6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l10062
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    lea     $0018(sp),sp
    move.l  -$0004(a6),d0
    cmp.l   -$0008(a6),d0
    bge.b   .l10060
    addq.w  #$1,d5
.l10060:                                                ; $010060
    addq.w  #$1,d4
.l10062:                                                ; $010062
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l10016
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    blt.b   .l10014
    clr.w   d3
.l10074:                                                ; $010074
    clr.w   d2
.l10076:                                                ; $010076
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff04e0,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d6,d0
    bne.b   .l100c4
    pea     -$0008(a6)
    pea     -$0004(a6)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    addi.w  #$20,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$969a                           ; jsr $00969A
    lea     $0018(sp),sp
    move.l  -$0004(a6),d0
    cmp.l   -$0008(a6),d0
    bge.b   .l100c2
    addq.w  #$1,d5
.l100c2:                                                ; $0100C2
    addq.w  #$1,d4
.l100c4:                                                ; $0100C4
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l10076
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    blt.b   .l10074
    tst.w   d4
    bne.b   .l100da
    moveq   #-$1,d5
.l100da:                                                ; $0100DA
    cmpi.w  #$1,$000e(a6)
    bne.b   .l100e6
    move.w  d4,d0
    bra.b   .l100e8
.l100e6:                                                ; $0100E6
    move.w  d5,d0
.l100e8:                                                ; $0100E8
    movem.l -$0020(a6),d2-d7
    unlk    a6
    rts
; ============================================================================
; LoadScreenPalette -- (TODO: describe)
; Called: 7 times.
; 216 bytes | $0100F2-$0101C9
; ============================================================================
LoadScreenPalette:                                                  ; $0100F2
    link    a6,#-$10
    movem.l d2-d5/a2-a3,-(sp)
    move.l  $000c(a6),d4
    move.l  $0008(a6),d5
    movea.l #$0d64,a2
    lea     -$0010(a6),a3
    moveq   #$0,d3
    move.b  ($00FF0016).l,d3
    pea     ($0010).w
    move.l  a3,-(sp)
    pea     ($00076ACE).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    clr.w   d2
.l10128:                                                ; $010128
    cmp.w   d2,d5
    beq.b   .l10130
    cmp.w   d2,d4
    bne.b   .l1014a
.l10130:                                                ; $010130
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    move.w  (a0,d0.w),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a3,a0.l)
.l1014a:                                                ; $01014A
    addq.w  #$1,d2
    cmpi.w  #$7,d2
    blt.b   .l10128
    pea     ($0004A63A).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0030(sp),sp
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(sp)
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0008).w
    pea     ($0038).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    movem.l -$0028(a6),d2-d5/a2-a3
    unlk    a6
    rts
; ============================================================================
; ShowPlayerChart -- (TODO: describe)
; Called: ?? times.
; 260 bytes | $0101CA-$0102CD
; ============================================================================
ShowPlayerChart:                                                  ; $0101CA
    link    a6,#-$10
    movem.l d2-d3/a2,-(sp)
    move.l  $0008(a6),d3
    lea     -$0010(a6),a2
    pea     ($0010).w
    move.l  a2,-(sp)
    pea     ($00076ACE).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    clr.w   d2
.l101ee:                                                ; $0101EE
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$0005ecdc,a0
    and.l   (a0,d1.w),d0
    beq.b   .l10226
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    move.w  (a0,d0.w),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a2,a0.l)
.l10226:                                                ; $010226
    addq.w  #$1,d2
    cmpi.w  #$7,d2
    blt.b   .l101ee
    pea     ($0008).w
    pea     ($0030).w
    pea     ($00076ABE).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004A63A).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0020(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    clr.l   -(sp)
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
    pea     ($0008).w
    pea     ($0038).w
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($6330).w
    pea     ($0006).w
    pea     ($000A).w
    clr.l   -(sp)
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$001c(a6),d2-d3/a2
    unlk    a6
    rts
; ============================================================================
; CalcTotalCharValue -- (TODO: describe)
; Called: ?? times.
; 226 bytes | $0102CE-$0103AF
; ============================================================================
CalcTotalCharValue:                                                  ; $0102CE
    movem.l d2-d6,-(sp)
    move.l  $0018(sp),d5
    moveq   #$0,d4
    clr.w   d3
.l102da:                                                ; $0102DA
    clr.w   d2
    move.w  d3,d6
    ext.l   d6
    move.l  d6,d0
    add.l   d6,d6
    add.l   d0,d6
    add.l   d6,d6
.l102e8:                                                ; $0102E8
    move.w  d6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d5,d0
    bne.b   .l10332
    move.w  d6,d0
    add.w   d2,d0
    movea.l #$00ff1704,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$2,d0
    add.l   d0,d4
.l10332:                                                ; $010332
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l102e8
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    blt.b   .l102da
    clr.w   d3
.l10344:                                                ; $010344
    clr.w   d2
.l10346:                                                ; $010346
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff04e0,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d5,d0
    bne.b   .l10398
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff1620,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    addi.w  #$20,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$2,d0
    add.l   d0,d4
.l10398:                                                ; $010398
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l10346
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    blt.b   .l10344
    move.l  d4,d0
    movem.l (sp)+,d2-d6
    rts
; ============================================================================
; CalcPlayerFinances -- (TODO: describe)
; Called: ?? times.
; 170 bytes | $0103B0-$010459
; ============================================================================
CalcPlayerFinances:                                                  ; $0103B0
    movem.l d2/a2-a4,-(sp)
    move.l  $0014(sp),d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    move.w  d2,d0
    mulu.w  #$6,d0
    movea.l #$00ff0290,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ff03f0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    lsl.w   #$3,d0
    movea.l #$00ff09a2,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.w  (a3),d0
    add.l   $000e(a1),d0
    moveq   #$0,d1
    move.w  $0002(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0004(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  (a2),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0002(a2),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    add.l   d1,d0
    add.l   $0004(a4),d0
    movea.l $001c(sp),a0
    move.l  d0,(a0)
    move.l  $000a(a1),d0
    add.l   (a4),d0
    movea.l $0018(sp),a0
    move.l  d0,(a0)
    movea.l $0018(sp),a0
    move.l  (a0),d0
    movea.l $001c(sp),a0
    sub.l   (a0),d0
    movea.l $0020(sp),a0
    move.l  d0,(a0)
    movem.l (sp)+,d2/a2-a4
    rts
; ============================================================================
; SumPlayerStats -- (TODO: describe)
; Called: ?? times.
; 56 bytes | $01045A-$010491
; ============================================================================
SumPlayerStats:                                                  ; $01045A
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    clr.w   d3
    clr.w   d2
.l10466:                                                ; $010466
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l10466
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; SumStatBytes -- (TODO: describe)
; Called: ?? times.
; 56 bytes | $010492-$0104C9
; ============================================================================
SumStatBytes:                                                  ; $010492
    movem.l d2-d4,-(sp)
    move.l  $0010(sp),d4
    clr.w   d3
    clr.w   d2
.l1049e:                                                ; $01049E
    move.w  d4,d0
    lsl.w   #$5,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    blt.b   .l1049e
    move.w  d3,d0
    movem.l (sp)+,d2-d4
    rts
; ============================================================================
; CountProfitableRelations -- (TODO: describe)
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
; ============================================================================
; SortWordPairs -- (TODO: describe)
; Called: ?? times.
; 188 bytes | $0109FA-$010AB5
; ============================================================================
SortWordPairs:                                                  ; $0109FA
    link    a6,#-$1c
    movem.l d2-d6/a2-a4,-(sp)
    move.l  $000c(a6),d5
    movea.l $0008(a6),a4
    lea     -$001c(a6),a1
    movea.l a4,a2
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    movea.l a0,a3
    bra.b   .l10a2a
.l10a20:                                                ; $010A20
    move.w  (a2)+,(a3)
    move.w  (a2)+,$0002(a3)
    addq.l  #$4,a3
    addq.w  #$1,d2
.l10a2a:                                                ; $010A2A
    cmp.w   d5,d2
    blt.b   .l10a20
    move.w  d5,d1
    addi.w  #$ffff,d1
    clr.w   d6
    bra.b   .l10a88
.l10a38:                                                ; $010A38
    clr.w   d3
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    addq.l  #$4,a0
    movea.l a0,a2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    movea.l a0,a3
    bra.b   .l10a7e
.l10a58:                                                ; $010A58
    move.w  $0002(a3),d0
    cmp.w   $0002(a2),d0
    bge.b   .l10a78
    move.w  (a3),d3
    move.w  $0002(a3),d4
    move.w  (a2),(a3)
    move.w  $0002(a2),$0002(a3)
    move.w  d3,(a2)
    move.w  d4,$0002(a2)
    moveq   #$1,d3
.l10a78:                                                ; $010A78
    addq.l  #$4,a3
    addq.l  #$4,a2
    addq.w  #$1,d2
.l10a7e:                                                ; $010A7E
    cmp.w   d1,d2
    blt.b   .l10a58
    tst.w   d3
    beq.b   .l10a8c
    addq.w  #$1,d6
.l10a88:                                                ; $010A88
    cmp.w   d5,d6
    blt.b   .l10a38
.l10a8c:                                                ; $010A8C
    movea.l a4,a2
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    lea     (a1,d0.l),a0
    movea.l a0,a3
    bra.b   .l10aa8
.l10a9e:                                                ; $010A9E
    move.w  (a3),(a2)+
    move.w  $0002(a3),(a2)+
    addq.l  #$4,a3
    addq.w  #$1,d2
.l10aa8:                                                ; $010AA8
    cmp.w   d5,d2
    blt.b   .l10a9e
    movem.l -$003c(a6),d2-d6/a2-a4
    unlk    a6
    rts
RunPlayerSelectUI:                                                  ; $010AB6
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    lea     -$0010(a6),a4
    movea.l #$0d64,a5
    move.w  $000e(a6),d2
    move.w  d2,d5
    pea     ($0008).w
    move.l  a4,-(sp)
    pea     ($00076AC0).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    pea     ($0008).w
    move.l  a4,d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    pea     ($00076AC0).l
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    lea     $0018(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$0aaa,(a4,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$88,$8(a4,a0.l)
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a5)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0020(sp),sp
    tst.w   d0
    beq.b   .l10b46
    moveq   #$1,d4
    bra.b   .l10b48
.l10b46:                                                ; $010B46
    moveq   #$0,d4
.l10b48:                                                ; $010B48
    clr.w   d3
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    movea.l #$00076ac0,a3
    movea.l a4,a2
    addq.l  #$8,a2
.l10b60:                                                ; $010B60
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8,sp
    tst.w   d4
    beq.b   .l10b80
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    bne.w   .l10c9c
.l10b80:                                                ; $010B80
    clr.w   d4
    move.w  d3,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l10bb6
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l10bd2
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l10bea
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l10c0e
    bra.b   .l10c30
.l10bb6:                                                ; $010BB6
    move.w  #$1,($00FF13FC).l
    cmpi.w  #$3,d2
    bcc.b   .l10bcc
    moveq   #$0,d0
    move.w  d2,d0
    addq.l  #$1,d0
    bra.b   .l10bce
.l10bcc:                                                ; $010BCC
    moveq   #$0,d0
.l10bce:                                                ; $010BCE
    move.w  d0,d2
    bra.b   .l10c3c
.l10bd2:                                                ; $010BD2
    move.w  #$1,($00FF13FC).l
    tst.w   d2
    beq.b   .l10be6
    moveq   #$0,d0
    move.w  d2,d0
    subq.l  #$1,d0
    bra.b   .l10bce
.l10be6:                                                ; $010BE6
    moveq   #$3,d0
    bra.b   .l10bce
.l10bea:                                                ; $010BEA
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    clr.l   -(sp)
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
    move.w  d2,d0
    bra.w   .l10ca2
.l10c0e:                                                ; $010C0E
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    clr.l   -(sp)
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
    moveq   #-$1,d0
    bra.b   .l10ca2
.l10c30:                                                ; $010C30
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l10c3c:                                                ; $010C3C
    cmp.w   d5,d2
    beq.b   .l10c9c
    pea     ($0008).w
    move.l  a4,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    pea     ($0008).w
    move.l  a2,-(sp)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$45b2                           ; jsr $0045B2
    lea     $0018(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$0aaa,(a4,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  #$88,(a2,a0.l)
    move.l  a4,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0031).w
    pea     ($0001).w
    pea     ($0023).w
    jsr     (a5)
    lea     $001c(sp),sp
.l10c9c:                                                ; $010C9C
    move.w  d2,d5
    bra.w   .l10b60
.l10ca2:                                                ; $010CA2
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
CalcCharDisplayIndex_Prelude:                                ; $010CAC
    dc.w    $48E7,$3C00                                      ; movem.l d2-d5/a2-a3,-(sp) [falls through]
; === Translated block $010CB0-$0112EE ===
; 3 functions, 1598 bytes

; ============================================================================
; CalcCharDisplayIndex -- (TODO: name)
; 88 bytes | $010CB0-$010D07
; ============================================================================
CalcCharDisplayIndex:
    move.l  $18(a7), d2
    move.l  $14(a7), d3
    move.l  $20(a7), d4
    move.l  $1c(a7), d5
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    move.w  d2, d0
    mulu.w  #$1e, d0
    addi.w  #$560, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    mulu.w  #$a, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FF03B8,a0
    move.w  (a0,d0.w), d1
    move.l  d1, -(a7)
    jsr LoadTileGraphics
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d5
    rts

; ============================================================================
; RenderRouteSlotScreen -- (TODO: name)
; 780 bytes | $010D08-$011013
; ============================================================================
RenderRouteSlotScreen:
    link    a6,#-$10
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    movea.l  #$00000D64,a4
    movea.l  #$00FF1804,a5
    pea     ($000E).w
    clr.l   -(a7)
    pea     -$e(a6)
    jsr MemFillByte
    jsr ResourceLoad
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0030).w
    pea     ($0004A5BA).l
    jsr DisplaySetup
    lea     $28(a7), a7
    pea     ($0004A5DA).l
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0002).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0004A63A).l
    move.l  a5, -(a7)
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0025).w
    pea     ($0330).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    cmpi.w  #$3, d7
    bge.b   l_10e10
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0004797C,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l  #$000A1B14,a0
    move.l  (a0,d0.l), -(a7)
    move.l  a5, -(a7)
    jsr LZ_Decompress
    pea     ($0014).w
    pea     ($03CD).w
    move.l  a5, -(a7)
    jsr CmdPlaceTile
    pea     ($00071F98).l
    pea     ($0004).w
    pea     ($0005).w
    pea     ($0003).w
    pea     ($0019).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
l_10e10:
    move.w  d6, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_10e22:
    move.w  d3, d5
    andi.w  #$1, d5
    mulu.w  #$6, d5
    addi.w  #$d, d5
    move.w  d3, d4
    ext.l   d4
    asr.l   #$1, d4
    lsl.w   #$3, d4
    addq.w  #$2, d4
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude
    lea     $10(a7), a7
    tst.b   $1(a2)
    bne.b   l_10ea6
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$28, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    bra.w   l_10fde
l_10ea6:
    cmpi.b  #$6, $1(a2)
    bne.b   l_10ebc
    cmpi.w  #$3, $6(a2)
    beq.b   l_10ebc
    moveq   #$0,d2
    move.b  (a2), d2
    bra.b   l_10ecc
l_10ebc:
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
l_10ecc:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005F088,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1
    add.l   d1, d0
    addi.l  #$18, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    move.w  d2, d0
    add.w   d0, d0
    addq.w  #$3, -$e(a6, d0.w)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteRevenue,PC)
    nop
    lea     $2c(a7), a7
    ext.l   d0
    moveq   #$3,d1
    jsr SignedDiv
    move.w  d0, d2
    cmpi.w  #$5, d2
    bge.b   l_10f62
    move.w  d2, d0
    ext.l   d0
    bra.b   l_10f64
l_10f62:
    moveq   #$5,d0
l_10f64:
    move.w  d0, d2
    pea     ($0774).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    ble.b   l_10fde
    pea     ($0775).w
    pea     ($0002).w
    pea     ($0020).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    moveq   #$5,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    move.w  d4, d0
    ext.l   d0
    addq.l  #$6, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
l_10fde:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   l_10e22
    cmpi.w  #$3, d7
    bge.b   l_11004
    pea     ($000A).w
    pea     ($0019).w
    pea     ($0004).w
    move.w  d6, d0
    move.l  d0, -(a7)
    bsr.w CalcCharDisplayIndex_Prelude
l_11004:
    jsr ResourceUnload
    movem.l -$38(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ShowRouteDetailsDialog -- (TODO: name)
; 730 bytes | $011014-$0112ED
; ============================================================================
ShowRouteDetailsDialog:
    link    a6,#$0
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    movea.l  #$0003B246,a3
    movea.l  #$0003AB2C,a4
    movea.l  #$0001E0B8,a5
    move.l  #$8000, -(a7)
    pea     ($0008).w
    pea     ($0008).w
    pea     ($0009).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($075C).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($0004).w
    pea     ($000B).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    pea     ($075D).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000D).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    lea     $20(a7), a7
    pea     ($075E).w
    pea     ($000B).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000B).w
    pea     ($000F).w
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    move.l  ($000A1B2C).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    pea     ($0012).w
    pea     ($03E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072658).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($0009).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($00072664).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000D).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($00072670).l
    pea     ($0002).w
    pea     ($0003).w
    pea     ($000F).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    pea     ($0002).w
    pea     ($0037).w
    jsr     (a5)
    lea     $24(a7), a7
    cmpi.w  #$4, d3
    bge.w   l_112dc
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.w   l_112dc
    pea     ($0006).w
    pea     ($0009).w
    pea     ($000B).w
    pea     ($0004).w
    jsr SetTextWindow
    pea     ($0002).w
    pea     ($0037).w
    jsr     (a5)
    lea     $18(a7), a7
    cmpi.b  #$6, $1(a2)
    beq.b   l_11210
    pea     ($0001).w
    pea     ($0640).w
    clr.l   -(a7)
    pea     ($0058).w
    pea     ($0008).w
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCharSprite
    pea     ($0009).w
    pea     ($0004).w
    jsr     (a4)
    lea     $20(a7), a7
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047818,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
l_1120c:
    addq.l  #$4, a7
    bra.b   l_11274
l_11210:
    cmpi.w  #$3, $6(a2)
    bne.b   l_1122a
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    bra.b   l_1122e
l_1122a:
    moveq   #$0,d2
    move.b  (a2), d2
l_1122e:
    pea     ($0009).w
    pea     ($0004).w
    jsr     (a4)
    addq.l  #$8, a7
    cmpi.w  #$3, d2
    bne.b   l_1124a
    pea     ($0003F116).l
l_11246:
    jsr     (a3)
    bra.b   l_1120c
l_1124a:
    cmpi.w  #$2, d2
    bne.b   l_11258
    pea     ($0003F10A).l
    bra.b   l_11246
l_11258:
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F106).l
    jsr PrintfWide
    addq.l  #$8, a7
l_11274:
    moveq   #$0,d2
    move.b  $1(a2), d2
    addi.w  #$ffff, d2
    pea     ($000D).w
    pea     ($0004).w
    jsr     (a4)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$000477E8,a0
    move.l  (a0,d0.w), -(a7)
    jsr     (a3)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteRevenue,PC)
    nop
    move.w  d0, d3
    pea     ($000F).w
    pea     ($0004).w
    jsr     (a4)
    lea     $1c(a7), a7
    cmpi.w  #$c, d3
    bgt.b   l_112d0
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F0FA).l
    jsr     (a3)
    bra.b   l_112e4
l_112d0:
    pea     ($0003F0EC).l
    jsr     (a3)
    addq.l  #$4, a7
    bra.b   l_112e4
l_112dc:
    pea     ($0002).w
    clr.l   -(a7)
    jsr     (a5)
l_112e4:
    movem.l -$1c(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; ManageRouteSlots -- (TODO: describe)
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
; ============================================================================
; ShowTextDialog -- Display text dialog with formatted output (31 calls)
; Uses link frame. Displays formatted text via PrintfWide, does table lookup
; via $643C, then optionally calls $7784 or PollAction based on flag args.
; Args: $8.l=index, $C.l=data, $12.w=col, $16.w=param, $1A.w=flag1, $1E.w=flag2
; ============================================================================
ShowTextDialog:                                              ; $01183A
    link    a6,#$0000
    movem.l d2-d3,-(sp)
    move.l  $0008(a6),d2                                     ; d2 = index
    pea     ($0020).w                                        ; width = 32
    pea     ($0020).w                                        ; height = 32
    clr.l   -(sp)                                            ; left = 0
    clr.l   -(sp)                                            ; top = 0
    jsr SetTextWindow
    pea     ($0019).w                                        ; x = 25
    pea     ($0013).w                                        ; y = 19
    jsr SetTextCursor
    move.w  d2,d0
    mulu.w  #$0024,d0                                        ; index * 36 (record size)
    movea.l #$00FF001E,a0                                    ; record table base
    move.l  (a0,d0.w),-(sp)                                  ; push record field
    pea     ($0003F1B2).l                                    ; format string
    jsr PrintfWide
    lea     $20(sp),sp                                       ; clean 32 bytes
    move.l  $000C(a6),-(sp)                                  ; push data arg
    pea     ($0001).w
    pea     ($0001).w
    move.w  $0016(a6),d0
    move.l  d0,-(sp)                                         ; param (extended)
    move.w  d2,d0
    move.l  d0,-(sp)                                         ; index (extended)
    pea     ($0002).w
    pea     ($0780).w
    move.w  d2,d0
    mulu.w  #$000A,d0                                        ; index * 10
    move.w  $0012(a6),d1                                     ; col arg
    add.w   d1,d1                                            ; col * 2
    add.w   d1,d0                                            ; offset += col*2
    movea.l #$00FF03B8,a0                                    ; lookup table base
    move.w  (a0,d0.w),d1                                     ; table[index*10+col*2]
    move.l  d1,-(sp)
    jsr DrawCharInfoPanel
    lea     $20(sp),sp                                       ; clean 32 bytes
    cmpi.w  #$0001,$001A(a6)                                 ; flag1 == 1?
    bne.s   .check_f2                                        ; no, check flag2
    pea     ($001A).w
    pea     ($0006).w
    jsr SelectPreviewPage
    addq.l  #8,sp                                            ; clean args
    move.w  d0,d3                                            ; d3 = result
    bra.s   .epilogue
.check_f2:                                                   ; $0118E4
    cmpi.w  #$0001,$001E(a6)                                 ; flag2 == 1?
    bne.s   .epilogue                                        ; no, skip
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
.epilogue:                                                   ; $0118FA
    move.w  d3,d0                                            ; return value
    movem.l -$08(a6),d2-d3
    unlk    a6
    rts
; ============================================================================
; CalcRouteRevenue -- (TODO: describe)
; 174 bytes | $011906-$0119B3
; ============================================================================
CalcRouteRevenue:                                                  ; $011906
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d2
    move.l  $0020(sp),d3
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$5,d0
    move.l  d0,d5
    move.w  d3,d1
    ext.l   d1
    lsl.l   #$3,d1
    move.l  d1,d4
    add.w   d1,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d6
    move.b  (a2),d6
    cmpi.b  #$03,$0001(a2)
    bcc.b   .l11996
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$afca                           ; jsr $01AFCA
    move.w  d0,d3
    movea.w d5,a2
    adda.w  d4,a2
    movea.l #$00ff0338,a0
    lea     (a0,a2.w),a2
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$769c                           ; jsr $00769C
    lea     $0010(sp),sp
    move.w  d0,d2
    ext.l   d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    sub.l   d1,d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    subq.l  #$1,d0
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    bra.b   .l119a8
.l11996:                                                ; $011996
    cmpi.b  #$06,$0001(a2)
    bne.b   .l119a6
    moveq   #$0,d2
    move.b  $0003(a2),d2
    bra.b   .l119a8
.l119a6:                                                ; $0119A6
    moveq   #$1,d2
.l119a8:                                                ; $0119A8
    move.w  d2,d0
    mulu.w  #$3,d0
    movem.l (sp)+,d2-d6/a2
    rts
ProcessRouteChange:                                                  ; $0119B4
    movem.l d2-d4/a2-a4,-(sp)
    move.l  $001c(sp),d2
    movea.l $0020(sp),a2
    movea.l #$00ff08ec,a3
    movea.l #$d648,a4
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  (sp)+,d1
    cmp.w   d1,d0
    beq.b   .l11a28
    move.l  a2,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0126                                 ; jsr $011B26
    nop
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0af6                                 ; jsr $012514
    nop
    lea     $0010(sp),sp
    bra.b   .l11a60
.l11a28:                                                ; $011A28
    ori.b   #$80,$000a(a2)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    jsr     (a4)
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0d7e                                 ; jsr $0127D6
    nop
    lea     $000c(sp),sp
.l11a60:                                                ; $011A60
    move.w  d0,d4
    cmpi.w  #$1,d4
    bne.w   .l11b00
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    clr.l   -(sp)
    pea     ($000F).w
    dc.w    $4eb9,$0001,$d3ac                           ; jsr $01D3AC
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0017).w
    dc.w    $4eb9,$0000,$5ff6                           ; jsr $005FF6
    lea     $0020(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0003F212).l
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a3,a0.l),d0
    move.l  d3,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0590                                 ; jsr $012076
    nop
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9f4a                           ; jsr $009F4A
    lea     $0020(sp),sp
    bra.b   .l11b20
.l11b00:                                                ; $011B00
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  d3,(a3,a0.l)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$12f0                                 ; jsr $012E04
    nop
    addq.l  #$4,sp
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
.l11b20:                                                ; $011B20
    movem.l (sp)+,d2-d4/a2-a4
    rts
; === Translated block $011B26-$011BB2 ===
; 1 functions, 140 bytes

; ============================================================================
; ProcessPlayerRoutes -- (TODO: name)
; 140 bytes | $011B26-$011BB1
; ============================================================================
ProcessPlayerRoutes:
    link    a6,#-$4
    movem.l d2-d5, -(a7)
    move.l  $8(a6), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d5
    movea.l $c(a6), a0
    ori.b   #$80, $a(a0)
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0019,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$1,d3
    lsl.l   d0, d3
    pea     -$4(a6)
    move.l  d3, -(a7)
    move.l  d3, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (AccumulateRouteBits,PC)
    nop
    lea     $10(a7), a7
    moveq   #$1,d3
    clr.w   d2
l_11b7e:
    move.l  -$4(a6), d0
    move.l  d5, d1
    eor.l   d1, d0
    and.l   d3, d0
    beq.b   l_11b9e
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (ClearRouteSlotBit,PC)
    nop
    addq.l  #$8, a7
l_11b9e:
    add.l   d3, d3
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    blt.b   l_11b7e
    movem.l -$14(a6), d2-d5
    unlk    a6
    rts

UpdateRouteMask:                                                  ; $011BB2
    link    a6,#-$4
    movem.l d2-d6/a2,-(sp)
    move.l  $0008(a6),d4
    move.l  $000c(a6),d6
    movea.l #$00ff08ec,a2
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d5
    move.w  d4,d0
    mulu.w  #$24,d0
    movea.l #$00ff0019,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    moveq   #$1,d3
    lsl.l   d0,d3
    moveq   #$0,d0
    move.w  d6,d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.w  d4,d1
    lsl.l   #$2,d1
    movea.l d1,a0
    eor.l   d0,(a2,a0.l)
    pea     -$0004(a6)
    move.l  d3,-(sp)
    move.l  d3,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$013e                                 ; jsr $011D50
    nop
    lea     $0010(sp),sp
    moveq   #$1,d3
    clr.w   d2
.l11c1e:                                                ; $011C1E
    move.l  -$0004(a6),d0
    move.l  d5,d1
    eor.l   d1,d0
    and.l   d3,d0
    beq.b   .l11c3e
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0234                                 ; jsr $011E6C
    nop
    addq.l  #$8,sp
.l11c3e:                                                ; $011C3E
    add.l   d3,d3
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    blt.b   .l11c1e
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00a8                                 ; jsr $011CF6
    nop
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l11c7a
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$08a2                                 ; jsr $012514
    nop
    addq.l  #$8,sp
    bra.b   .l11caa
.l11c7a:                                                ; $011C7A
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d6,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0b34                                 ; jsr $0127D6
    nop
    lea     $000c(sp),sp
.l11caa:                                                ; $011CAA
    move.w  d0,d2
    cmpi.w  #$1,d2
    bne.b   .l11cd4
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a2,a0.l),d0
    move.l  d5,d1
    eor.l   d1,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$03aa                                 ; jsr $012076
    nop
    addq.l  #$8,sp
    bra.b   .l11cec
.l11cd4:                                                ; $011CD4
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  d5,(a2,a0.l)
    moveq   #$0,d0
    move.w  d4,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$111c                                 ; jsr $012E04
    nop
.l11cec:                                                ; $011CEC
    movem.l -$001c(a6),d2-d6/a2
    unlk    a6
    rts
; === Translated block $011CF6-$012E92 ===
; 11 functions, 4508 bytes

; ============================================================================
; IsRouteSlotPending -- (TODO: name)
; 90 bytes | $011CF6-$011D4F
; ============================================================================
IsRouteSlotPending:
    move.l  d2, -(a7)
    move.l  $8(a7), d1
    move.w  d1, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.w  d1, d0
    mulu.w  #$24, d0
    movea.l  #$00FF001C,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, d1
    clr.w   d2
    bra.b   .l11d46
.l11d2a:
    move.b  $a(a1), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    bne.b   .l11d40
    moveq   #$1,d0
    bra.b   .l11d4c
.l11d40:
    moveq   #$14,d0
    adda.l  d0, a1
    addq.w  #$1, d2
.l11d46:
    cmp.w   d1, d2
    bcs.b   .l11d2a
    moveq   #$0,d0
.l11d4c:
    move.l  (a7)+, d2
    rts

; ============================================================================
; AccumulateRouteBits -- (TODO: name)
; 58 bytes | $011D50-$011D89
; ============================================================================
AccumulateRouteBits:
    movem.l d2-d4/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.l  $14(a7), d4
    movea.l $20(a7), a2
.l11d64:
    tst.l   d2
    bne.b   .l11d6c
    move.l  d3, (a2)
    bra.b   .l11d84
.l11d6c:
    move.l  d3, -(a7)
    move.l  d2, -(a7)
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (FindAvailSlot,PC)
    nop
    lea     $c(a7), a7
    move.l  d0, d2
    or.l    d2, d3
    bra.b   .l11d64
.l11d84:
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; FindAvailSlot -- (TODO: name)
; 226 bytes | $011D8A-$011E6B
; ============================================================================
FindAvailSlot:
    link    a6,#-$8
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $10(a6), d1
    lea     -$8(a6), a3
    lea     $a(a6), a1
    move.w  (a1), d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d6
    moveq   #$0,d3
    moveq   #$1,d0
    move.l  d0, (a3)
    clr.w   d4
    move.w  (a1), d0
    mulu.w  #$24, d0
    movea.l  #$00FF001C,a0
    move.b  (a0,d0.w), -$1(a6)
    bra.w   .l11e58
.l11dca:
    move.l  $c(a6), d0
    and.l   (a3), d0
    beq.w   .l11e52
    move.w  (a1), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  -$1(a6), d0
    move.w  d0, -$4(a6)
    clr.w   d5
    bra.b   .l11e4c
.l11df4:
    move.b  $a(a2), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    beq.b   .l11e46
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    bne.b   .l11e26
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d2
    lsl.l   d0, d2
    move.l  d6, d0
    and.l   d2, d0
    beq.b   .l11e26
    move.l  d1, d0
    and.l   d2, d0
    bne.b   .l11e26
    or.l    d2, d3
.l11e26:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bne.b   .l11e46
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d2
    lsl.l   d0, d2
    move.l  d6, d0
    and.l   d2, d0
    beq.b   .l11e46
    move.l  d1, d0
    and.l   d2, d0
    bne.b   .l11e46
    or.l    d2, d3
.l11e46:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d5
.l11e4c:
    cmp.w   -$4(a6), d5
    blt.b   .l11df4
.l11e52:
    move.l  (a3), d0
    add.l   d0, (a3)
    addq.w  #$1, d4
.l11e58:
    cmpi.w  #$20, d4
    bcs.w   .l11dca
    move.l  d3, d0
    movem.l -$24(a6), d2-d6/a2-a3
    unlk    a6
    rts

; ============================================================================
; ClearRouteSlotBit -- (TODO: name)
; 258 bytes | $011E6C-$011F6D
; ============================================================================
ClearRouteSlotBit:
    movem.l d2-d5/a2-a4, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d3
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    not.l   d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    lea     (a0,d1.w), a0
    movea.l a0, a4
    and.l   d0, (a0)
    move.w  d2, d0
    ext.l   d0
    move.l  #$320, d1
    jsr Multiply32
    move.l  d0, d5
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.l  (a4), d4
    bra.b   .l11f08
.l11ecc:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11ee0
    moveq   #$0,d0
    move.b  $1(a2), d0
    bra.b   .l11ef2
.l11ee0:
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11f02
    moveq   #$0,d0
    move.b  (a2), d0
.l11ef2:
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d4, d0
    bne.b   .l11f02
    ori.b   #$80, $a(a2)
.l11f02:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l11f08:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   .l11ecc
    moveq   #$0,d0
    move.b  $4(a3), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    add.l   d5, d0
    movea.l  #$00FF9A20,a0
    adda.l  d0, a0
    movea.l a0, a2
    clr.w   d2
    bra.b   .l11f5a
.l11f34:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    beq.b   .l11f4e
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l11f54
.l11f4e:
    ori.b   #$80, $a(a2)
.l11f54:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l11f5a:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    cmp.l   d1, d0
    blt.b   .l11f34
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; UpdateRouteRevenue -- (TODO: name)
; 264 bytes | $011F6E-$012075
; ============================================================================
UpdateRouteRevenue:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
.l11f9e:
    cmpi.b  #$3, $1(a2)
    bne.b   .l11ff4
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmpi.b  #$20, (a2)
    bcc.w   .l12064
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   d5, d0
    beq.w   .l12064
    clr.b   $1(a2)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteValue,PC)
    nop
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    add.l   d0, $6(a3)
    bra.b   .l12064
.l11ff4:
    cmpi.b  #$6, $1(a2)
    bne.b   .l12064
    moveq   #$0,d4
    move.b  (a2), d4
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    cmpi.w  #$ff, d0
    beq.b   .l12060
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FF08EC,a0
    move.l  (a0,d1.w), d6
    eor.l   d6, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    bne.b   .l12064
    move.w  d2, d0
    mulu.w  #$e, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    tst.w   (a0,d0.w)
    bne.b   .l12064
.l12060:
    clr.b   $1(a2)
.l12064:
    addq.l  #$8, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    blt.w   .l11f9e
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; CalcRouteProfit -- (TODO: name)
; 1182 bytes | $012076-$012513
; ============================================================================
CalcRouteProfit:
    link    a6,#-$1C
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d3
    move.l  $8(a6), d4
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), -$c(a6)
    pea     ($000E).w
    pea     -$1a(a6)
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    clr.l   -(a7)
    jsr MemCopy
    lea     $14(a7), a7
    move.w  d4, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
    moveq   #$1,d5
    bra.b   .l120fc
.l120d4:
    move.l  d3, d0
    and.l   d5, d0
    beq.b   .l120f8
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcRouteValue,PC)
    nop
    addq.l  #$8, a7
    andi.l  #$ffff, d0
    add.l   d0, $6(a3)
.l120f8:
    addq.w  #$1, d2
    add.l   d5, d5
.l120fc:
    cmpi.w  #$20, d2
    blt.b   .l120d4
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9D2C,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
.l12128:
    cmpi.b  #$ff, (a2)
    beq.w   .l12240
    move.b  $a(a2), d0
    btst    #$7, d0
    beq.w   .l12232
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0
    sub.b   d0, $1(a4)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  d4, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  $3(a2), d0
    sub.b   d0, $1(a4)
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lsr.l   #$1, d0
    add.l   d0, $6(a3)
    moveq   #$0,d3
    move.b  $2(a2), d3
    asr.l   #$4, d3
    andi.w  #$f, d3
    move.b  $2(a2), d5
    andi.w  #$f, d5
    move.w  d4, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    add.b   d5, $1(a4)
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a2, -(a7)
    jsr MemFillByte
    lea     $18(a7), a7
    move.b  #$ff, (a2)
    move.b  #$ff, $1(a2)
    moveq   #$28,d3
    sub.w   d2, d3
    addi.w  #$ffff, d3
    tst.w   d3
    ble.b   .l12238
    move.w  d3, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.l  a2, d0
    moveq   #$14,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    jsr MemFillByte
    lea     $20(a7), a7
    move.b  #$ff, (a5)
    move.b  #$ff, $1(a5)
    bra.b   .l12238
.l12232:
    addq.w  #$1, d2
    moveq   #$14,d0
    adda.l  d0, a2
.l12238:
    cmpi.w  #$28, d2
    blt.w   .l12128
.l12240:
    move.b  #$1, $2(a3)
    clr.b   $3(a3)
    clr.b   $4(a3)
    clr.b   $5(a3)
    moveq   #$0,d0
    move.b  $1(a3), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  d1, (a0,d0.w)
    pea     ($0007).w
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    pea     (a0, d0.w)
    jsr MemFillByte
    pea     ($000E).w
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    jsr MemFillByte
    lea     $18(a7), a7
    move.w  d4, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.w  d4, d0
    mulu.w  #$7, d0
    movea.l  #$00FFA7BC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$8(a6)
.l122e2:
    cmpi.b  #$ff, (a2)
    beq.w   .l124ac
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$8, a7
    move.w  d0, d5
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    cmp.w   d5, d3
    beq.w   .l123d2
    addq.b  #$1, $4(a3)
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d6
    lsl.l   d0, d6
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d7
    lsl.l   d0, d7
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l1236e
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)
.l1236e:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0
    bne.b   .l12392
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)
.l12392:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF08EC,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l123ae
    move.b  (a2), d6
    move.b  $1(a2), (a2)
    move.b  d6, $1(a2)
.l123ae:
    moveq   #$1,d0
    lsl.b   d5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   -$8(a6), d1
    movea.l d1, a0
    or.b    d0, (a0)
    moveq   #$1,d0
    lsl.b   d3, d0
    move.w  d5, d1
    ext.l   d1
    add.l   -$8(a6), d1
    movea.l d1, a0
    or.b    d0, (a0)
    bra.w   .l124ac
.l123d2:
    addq.b  #$1, $5(a3)
    cmpi.b  #$20, (a2)
    bcc.b   .l1240a
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$1,d6
    lsl.l   d0, d6
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d6, d0
    bne.b   .l1243e
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d6, (a0,d0.w)
    bra.b   .l1243e
.l1240a:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.b  $2(a4), d1
    sub.w   d1, d0
    moveq   #$1,d6
    lsl.w   d0, d6
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d6, d0
    bne.b   .l1243e
    addq.b  #$1, $3(a3)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d6, (a0)
.l1243e:
    cmpi.b  #$20, $1(a2)
    bcc.b   .l12476
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$1,d7
    lsl.l   d0, d7
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    and.l   d7, d0
    bne.b   .l124ac
    addq.b  #$1, $2(a3)
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    or.l    d7, (a0,d0.w)
    bra.b   .l124ac
.l12476:
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  $2(a5), d1
    sub.w   d1, d0
    moveq   #$1,d3
    lsl.w   d0, d3
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.w  (a0), d0
    and.w   d3, d0
    bne.b   .l124ac
    addq.b  #$1, $3(a3)
    move.w  d5, d0
    ext.l   d0
    add.l   d0, d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    or.w    d3, (a0)
.l124ac:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$28, d2
    blt.w   .l122e2
    clr.w   d2
.l124bc:
    move.w  d4, d0
    mulu.w  #$e, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d0.w), d0
    not.w   d0
    move.w  d2, d1
    add.w   d1, d1
    and.w   d0, -$1a(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   .l124bc
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    not.l   d0
    and.l   d0, -$c(a6)
    pea     -$1a(a6)
    move.l  -$c(a6), -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w UpdateRouteRevenue
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ShowRouteInfoDlg -- (TODO: name)
; 706 bytes | $012514-$0127D5
; ============================================================================
ShowRouteInfoDlg:
    link    a6,#-$190
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$0003B22C,a5
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$a0(a6)
    jsr MemFillByte
    jsr ResourceLoad
    jsr PreLoopInit
    move.l  ($00095118).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $14(a7), a7
    move.w  $a(a6), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
    clr.w   d4
    bra.w   .l12606
.l12570:
    cmpi.b  #$ff, (a3)
    beq.w   .l12600
    move.b  $a(a3), d0
    andi.l  #$80, d0
    beq.b   .l12600
    moveq   #$0,d0
    move.b  (a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcc.b   .l125c6
    moveq   #$0,d3
    move.b  (a2), d3
    moveq   #$0,d7
    move.b  $1(a2), d7
    moveq   #$0,d6
    move.b  (a4), d6
    moveq   #$0,d5
    move.b  $1(a4), d5
    bra.b   .l125da
.l125c6:
    moveq   #$0,d6
    move.b  (a2), d6
    moveq   #$0,d5
    move.b  $1(a2), d5
    moveq   #$0,d3
    move.b  (a4), d3
    moveq   #$0,d7
    move.b  $1(a4), d7
.l125da:
    pea     ($00FF1804).l
    pea     ($0001).w
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr DrawTilemapLine
    lea     $18(a7), a7
    addq.w  #$1, d4
.l12600:
    moveq   #$14,d0
    adda.l  d0, a3
    addq.w  #$1, d2
.l12606:
    cmpi.w  #$28, d2
    blt.w   .l12570
    movea.l  #$0005E948,a2
    clr.w   d2
    clr.w   d3
    bra.b   .l12670
.l1261a:
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    and.l   $c(a6), d0
    beq.b   .l1266c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0761).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d3
.l1266c:
    addq.l  #$2, a2
    addq.w  #$1, d2
.l12670:
    cmpi.w  #$20, d2
    blt.b   .l1261a
    pea     ($02C0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    pea     ($00070198).l
    pea     ($0014).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $c(a7), a7
    cmpi.w  #$1, d3
    bne.b   .l126dc
    pea     ($0003F238).l
    pea     -$f0(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l126f2
.l126dc:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$f0(a6)
    jsr     (a5)
    lea     $c(a7), a7
.l126f2:
    cmpi.w  #$1, d4
    bne.b   .l12708
    pea     ($0003F230).l
    pea     -$140(a6)
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l1271e
.l12708:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$140(a6)
    jsr     (a5)
    lea     $c(a7), a7
.l1271e:
    tst.w   d4
    bne.b   .l12738
    pea     -$f0(a6)
    pea     ($0003F22C).l
.l1272c:
    pea     -$190(a6)
    jsr     (a5)
    lea     $c(a7), a7
    bra.b   .l12760
.l12738:
    tst.w   d3
    bne.b   .l12748
    pea     -$140(a6)
    pea     ($0003F228).l
    bra.b   .l1272c
.l12748:
    pea     -$140(a6)
    pea     -$f0(a6)
    move.l  ($000479A2).l, -(a7)
    pea     -$190(a6)
    jsr     (a5)
    lea     $10(a7), a7
.l12760:
    pea     -$190(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$a0(a6)
    jsr     (a5)
    jsr ResourceUnload
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$a0(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    tst.w   d4
    ble.b   .l127ae
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (GetCharStatField,PC)
    nop
    addq.l  #$8, a7
.l127ae:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000479AA).l, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  d0, d2
    movem.l -$1b8(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; FormatRouteDetails -- (TODO: name)
; 872 bytes | $0127D6-$012B3D
; ============================================================================
FormatRouteDetails:
    link    a6,#-$140
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    jsr ResourceLoad
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$50(a6)
    jsr MemFillByte
    jsr ClearBothPlanes
    moveq   #$0,d0
    move.w  d4, d0
    lsl.l   #$2, d0
    movea.l  #$0009511C,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $14(a7), a7
    moveq   #$7,d5
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d7, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d6
    clr.w   d2
    bra.w   .l12942
.l1285c:
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    ext.l   d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bne.w   .l1293c
    move.b  $a(a2), d0
    andi.l  #$80, d0
    cmpi.l  #$80, d0
    bne.w   .l1293c
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $1(a2), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  $e(a2), d0
    cmp.w   $6(a2), d0
    bcs.b   .l128c4
    moveq   #$1,d3
    bra.b   .l128c6
.l128c4:
    moveq   #$2,d3
.l128c6:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0004).w
    move.l  a3, -(a7)
    move.l  a4, -(a7)
    jsr DrawRoutePair
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a3), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    move.l  d0, -(a7)
    jsr TilePlacement
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    addq.w  #$1, d5
    addq.w  #$1, d6
.l1293c:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
.l12942:
    moveq   #$0,d0
    move.b  $5(a5), d0
    cmp.w   d2, d0
    bhi.w   .l1285c
    pea     ($02E0).w
    pea     ($0001).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile2
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    jsr DisplaySetup
    lea     $18(a7), a7
    clr.w   d3
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECDC,a0
    move.l  (a0,d0.w), d0
    and.l   $10(a6), d0
    move.l  d0, d4
    beq.b   .l129f6
    clr.w   d2
.l12994:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    cmp.l   d4, d0
    beq.b   .l129aa
    addq.w  #$1, d2
    cmpi.w  #$20, d2
    bcs.b   .l12994
.l129aa:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a4), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($0761).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d3
.l129f6:
    pea     ($00070198).l
    pea     ($0017).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    cmpi.w  #$1, d3
    bne.b   .l12a34
    pea     ($0003F258).l
    pea     -$a0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a4e
.l12a34:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$a0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a4e:
    cmpi.w  #$1, d6
    bne.b   .l12a68
    pea     ($0003F250).l
    pea     -$f0(a6)
    jsr sprintf
    addq.l  #$8, a7
    bra.b   .l12a82
.l12a68:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$f0(a6)
    jsr sprintf
    lea     $c(a7), a7
.l12a82:
    tst.w   d6
    bne.b   .l12aa0
    pea     -$a0(a6)
    pea     ($0003F24C).l
.l12a90:
    pea     -$140(a6)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   .l12acc
.l12aa0:
    tst.w   d3
    bne.b   .l12ab0
    pea     -$f0(a6)
    pea     ($0003F248).l
    bra.b   .l12a90
.l12ab0:
    pea     -$f0(a6)
    pea     -$a0(a6)
    move.l  ($000479A2).l, -(a7)
    pea     -$140(a6)
    jsr sprintf
    lea     $10(a7), a7
.l12acc:
    pea     -$140(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$50(a6)
    jsr sprintf
    jsr ResourceUnload
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $20(a7), a7
    tst.w   d6
    beq.b   .l12b1a
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr (GetCharStatField,PC)
    nop
    addq.l  #$8, a7
.l12b1a:
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($000479AA).l, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    jsr ShowDialog
    movem.l -$168(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; GetCharStatField -- (TODO: name)
; 710 bytes | $012B3E-$012E03
; ============================================================================
GetCharStatField:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$00000D64,a5
    clr.w   d4
    moveq   #$1,d7
    jsr PreLoopInit
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l12b7e
    moveq   #$1,d0
    bra.b   .l12b80
.l12b7e:
    moveq   #$0,d0
.l12b80:
    move.w  d0, -$2(a6)
    clr.w   d6
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    jsr ResourceLoad
    moveq   #$0,d0
    movea.l d0, a4
    clr.w   d2
    clr.w   d3
.l12ba0:
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
.l12bb2:
    cmpi.w  #$28, d2
    blt.b   .l12bbc
    movea.l a3, a2
    clr.w   d2
.l12bbc:
    tst.w   d2
    bge.b   .l12bc8
    movea.l a3, a2
    lea     $30c(a2), a2
    moveq   #$27,d2
.l12bc8:
    move.b  $a(a2), d0
    btst    #$7, d0
    bne.b   .l12be8
    cmpi.w  #$1, d4
    bne.b   .l12be0
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    bra.b   .l12bb2
.l12be0:
    moveq   #$14,d0
    suba.l  d0, a2
    subq.w  #$1, d2
    bra.b   .l12bb2
.l12be8:
    cmpa.l  a2, a4
    beq.b   .l12c66
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($0001).w
    pea     ($0002).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationDisplay
    lea     $14(a7), a7
    movea.l a2, a4
.l12c66:
    cmpi.w  #$1, d7
    bne.b   .l12c90
    jsr ResourceUnload
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003F268).l
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    clr.w   d7
.l12c90:
    tst.w   -$2(a6)
    beq.b   .l12ca6
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l12ba0
.l12ca6:
    clr.w   -$2(a6)
    cmpi.w  #$2, $e(a6)
    bge.b   .l12cd6
.l12cb2:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$30, d0
    beq.b   .l12cb2
    cmpi.w  #$20, d6
    bne.w   .l12dfa
    bra.w   .l12dfa
.l12cd6:
    addq.w  #$1, d3
    cmpi.w  #$1, d3
    bne.b   .l12d46
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0008).w
    pea     ($0078).w
    pea     ($0039).w
    pea     ($0770).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0078).w
    pea     ($0078).w
    pea     ($003A).w
    pea     ($0771).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l12d38:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l12d66
.l12d46:
    cmpi.w  #$f, d3
    bne.b   .l12d5e
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l12d38
.l12d5e:
    cmpi.w  #$1e, d3
    bne.b   .l12d66
    clr.w   d3
.l12d66:
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l12d98
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l12daa
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   .l12dba
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   .l12dcc
    bra.b   .l12dde
.l12d98:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$1,d2
.l12da6:
    move.w  d2, d0
    bra.b   .l12dfa
.l12daa:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d2
    bra.b   .l12da6
.l12dba:
    move.w  #$1, ($00FF13FC).l
    clr.w   d4
    moveq   #$14,d0
    suba.l  d0, a2
    subq.w  #$1, d2
    bra.b   .l12dea
.l12dcc:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d4
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    bra.b   .l12dea
.l12dde:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l12dea:
    pea     ($0005).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l12ba0
.l12dfa:
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ClearRoutePendingFlags -- (TODO: name)
; 42 bytes | $012E04-$012E2D
; ============================================================================
ClearRoutePendingFlags:
    move.w  $6(a7), d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d1
.l12e1a:
    andi.b  #$7f, $a(a1)
    moveq   #$14,d0
    adda.l  d0, a1
    addq.w  #$1, d1
    cmpi.w  #$28, d1
    blt.b   .l12e1a
    rts

; ============================================================================
; CalcRouteValue -- (TODO: name)
; 100 bytes | $012E2E-$012E91
; ============================================================================
CalcRouteValue:
    movem.l d2-d3/a2, -(a7)
    move.l  $14(a7), d2
    move.l  $10(a7), d3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharStat
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a2), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$4, d0
    sub.l   d1, d0
    add.l   d0, d0
    addi.l  #$258, d0
    move.w  d2, d1
    ext.l   d1
    addq.l  #$1, d1
    jsr Multiply32
    tst.l   d0
    bge.b   .l12e88
    addq.l  #$3, d0
.l12e88:
    asr.l   #$2, d0
    move.w  d0, d2
    movem.l (a7)+, d2-d3/a2
    rts

; ============================================================================
; ShowQuarterSummary -- (TODO: describe)
; Called: ?? times.
; 840 bytes | $012E92-$0131D9
; ============================================================================
ShowQuarterSummary:                                                  ; $012E92
    link    a6,#-$70
    movem.l d2-d6/a2-a5,-(sp)
    lea     -$006e(a6),a4
    lea     -$001e(a6),a5
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  ($00FF9A1C).l,d3
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02f6                                 ; jsr $0131DA
    nop
    lea     $0014(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l13142
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$07f6                                 ; jsr $0136F8
    nop
    addq.l  #$8,sp
    tst.w   d0
    ble.w   .l1310c
    pea     ($001E).w
    clr.l   -(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.l  a5,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$06e8                                 ; jsr $013614
    nop
    move.l  a5,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0f28                                 ; jsr $013E62
    nop
    lea     $0020(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l130d6
.l12f4a:                                                ; $012F4A
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0003).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$12ee                           ; jsr $0112EE
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$ff,d0
    beq.w   .l1319a
.l12f6c:                                                ; $012F6C
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    move.l  a5,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02be                                 ; jsr $01325C
    nop
    lea     $001c(sp),sp
    move.w  d0,d5
    cmpi.w  #$ff,d0
    beq.b   .l12f4a
    cmpi.w  #$1,d5
    bne.b   .l12fb8
    moveq   #$3,d6
    bra.b   .l12fba
.l12fb8:                                                ; $012FB8
    move.w  d5,d6
.l12fba:                                                ; $012FBA
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0f24                                 ; jsr $013EF2
    nop
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$000479f6,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d4,d1
    lsl.w   #$3,d1
    add.w   d1,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.b  #$06,$0001(a2)
    move.w  d5,$0006(a2)
    move.b  d3,(a2)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$074e                                 ; jsr $01377E
    nop
    lea     $0030(sp),sp
    move.l  d0,d6
    ble.w   .l130c6
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$0005e296,a0
    move.l  (a0,d0.l),-(sp)
    move.l  ($000479C2).l,-(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a4,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l130c6
    move.b  #$04,$0003(a2)
    sub.l   d6,$0006(a3)
    pea     ($0005).w
    pea     ($000A).w
    pea     ($0013).w
    dc.w    $4eb9,$0000,$5ff6                           ; jsr $005FF6
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  ($000479D6).l,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$183a                           ; jsr $01183A
    lea     $0024(sp),sp
    bra.w   .l12f4a
.l130c6:                                                ; $0130C6
    clr.b   $0001(a2)
    clr.w   $0006(a2)
    move.b  #$ff,(a2)
    bra.w   .l12f6c
.l130d6:                                                ; $0130D6
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($000479CE).l,-(sp)
    bra.b   .l13176
.l1310c:                                                ; $01310C
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($000479AE).l,-(sp)
    bra.b   .l13176
.l13142:                                                ; $013142
    clr.l   -(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005ec84,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($000479DA).l,-(sp)
.l13176:                                                ; $013176
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    move.l  a4,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0020(sp),sp
.l1319a:                                                ; $01319A
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    movem.l -$0094(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $0131DA-$0140DC ===
; 10 functions, 3842 bytes

; ============================================================================
; IsCharAttrValid -- (TODO: name)
; 130 bytes | $0131DA-$01325B
; ============================================================================
IsCharAttrValid:
    movem.l d2-d4/a2, -(a7)
    moveq   #$1,d1
    move.w  $16(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    movea.l a0, a2
    move.b  (a0), d3
    andi.l  #$ff, d3
    moveq   #$0,d4
    move.b  $1(a1), d4
    clr.w   d2
    bra.b   l_1321e
l_13206:
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_1321a
    clr.w   d1
    bra.b   l_13222
l_1321a:
    addq.w  #$1, d2
    addq.w  #$1, d3
l_1321e:
    cmp.w   d4, d2
    blt.b   l_13206
l_13222:
    cmpi.w  #$1, d1
    bne.b   l_13254
    moveq   #$0,d3
    move.b  $2(a2), d3
    moveq   #$0,d4
    move.b  $3(a2), d4
    clr.w   d2
    bra.b   l_13250
l_13238:
    movea.l  #$00FF09D8,a0
    move.b  (a0,d3.w), d0
    andi.b  #$3, d0
    beq.b   l_1324c
    clr.w   d1
    bra.b   l_13254
l_1324c:
    addq.w  #$1, d2
    addq.w  #$1, d3
l_13250:
    cmp.w   d4, d2
    blt.b   l_13238
l_13254:
    move.w  d1, d0
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; RunRouteManagementUI -- (TODO: name)
; 666 bytes | $01325C-$0134F5
; ============================================================================
RunRouteManagementUI:
    link    a6,#-$B8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d6
    movea.l $14(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$000479AE,a4
    lea     -$b6(a6), a5
    jsr ResourceLoad
    jsr ClearTileArea
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (SelectCharRelation,PC)
    nop
    jsr ResourceUnload
    moveq   #$1,d5
    move.w  #$ff, d2
    move.l  a2, -(a7)
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateSpritePos,PC)
    nop
    lea     $18(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$30, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    clr.l   -(a7)
    jsr ReadInput
    lea     $28(a7), a7
    tst.w   d0
    beq.b   l_1330e
    moveq   #$1,d0
    bra.b   l_13310
l_1330e:
    moveq   #$0,d0
l_13310:
    move.w  d0, -$2(a6)
    clr.w   d7
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d2
l_13320:
    tst.w   d5
    beq.b   l_13348
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  $1c(a4), -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    clr.w   d5
l_13348:
    tst.w   -$2(a6)
    beq.b   l_1335c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_13320
l_1335c:
    clr.w   -$2(a6)
    move.w  d7, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d7
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_1339a
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1343c
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1344a
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_134c4
    bra.w   l_134d0
l_1339a:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF9A10,a0
    tst.w   (a0,d0.w)
    ble.b   l_1342a
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (FindSpriteByID,PC)
    nop
    lea     $c(a7), a7
    tst.w   d0
    bne.b   l_133e8
l_133d2:
    pea     ($0001).w
    pea     ($0002).w
    jsr GameCmd16
    addq.l  #$8, a7
    move.w  d2, d0
    bra.w   l_134ec
l_133e8:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7)
    move.l  $4(a4), -(a7)
l_133f8:
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a5, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $24(a7), a7
    moveq   #$1,d5
    bra.w   l_134d8
l_1342a:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  $8(a4, a0.l), -(a7)
    move.l  $18(a4), -(a7)
    bra.b   l_133f8
l_1343c:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  #$ff, d2
    bra.b   l_133d2
l_1344a:
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
l_13454:
    moveq   #$3,d1
    jsr SignedMod
    move.w  d0, d2
    cmpi.w  #$1, d2
    bne.b   l_13468
    moveq   #$3,d4
    bra.b   l_1346a
l_13468:
    move.w  d2, d4
l_1346a:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    addi.l  #$20, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  a2, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateSpritePos,PC)
    nop
    lea     $10(a7), a7
    bra.b   l_134d8
l_134c4:
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   l_13454
l_134d0:
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_134d8:
    pea     ($0003).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_13320
l_134ec:
    movem.l -$e0(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; SelectCharRelation -- (TODO: name)
; 286 bytes | $0134F6-$013613
; ============================================================================
SelectCharRelation:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $28(a7), d5
    move.l  $24(a7), d6
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (SearchCharInSlots,PC)
    nop
    pea     ($0013).w
    pea     ($001F).w
    pea     ($0001).w
    pea     ($0001).w
    jsr SetTextWindow
    pea     ($0002).w
    pea     ($0001).w
    jsr     (a4)
    pea     ($0003F5EC).l
    jsr     (a3)
    pea     ($0002).w
    pea     ($0011).w
    jsr     (a4)
    pea     ($0003F5DC).l
    jsr     (a3)
    lea     $30(a7), a7
    movea.l  #$00FF9A10,a2
    moveq   #$4,d4
    clr.w   d2
l_13568:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a3)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0013).w
    jsr     (a4)
    lea     $14(a7), a7
    tst.w   (a2)
    ble.b   l_135f6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (FindSpriteByID,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_135e0
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcQuarterBonus,PC)
    nop
    move.w  d0, d3
    mulu.w  #$a, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F5D6).l
    jsr     (a3)
    lea     $c(a7), a7
    bra.b   l_13600
l_135e0:
    cmpi.w  #$4, d3
    bne.b   l_135ee
    pea     ($0003F5CA).l
    bra.b   l_135fc
l_135ee:
    pea     ($0003F5C2).l
    bra.b   l_135fc
l_135f6:
    pea     ($0003F5B4).l
l_135fc:
    jsr     (a3)
    addq.l  #$4, a7
l_13600:
    addq.w  #$2, d4
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.w   l_13568
    movem.l (a7)+, d2-d6/a2-a4
    rts

; ============================================================================
; FindRelationByChar -- (TODO: name)
; 228 bytes | $013614-$0136F7
; ============================================================================
FindRelationByChar:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d7
    movea.l $30(a7), a4
    move.w  $2e(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d3
    moveq   #$0,d4
    move.b  (a1), d4
    moveq   #$0,d5
    move.b  $1(a1), d5
    move.w  d4, d6
    ext.l   d6
    move.l  d6, d0
    add.l   d6, d6
    add.l   d0, d6
    add.l   d6, d6
    bra.b   l_1368e
l_1364c:
    movea.l  #$00FF1704,a0
    lea     (a0,d6.w), a3
    movea.l  #$00FF0420,a0
    lea     (a0,d6.w), a2
    clr.w   d2
l_13662:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_1367c
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
l_1367c:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_13662
    addq.l  #$6, d6
    subq.w  #$1, d5
    addq.w  #$1, d4
l_1368e:
    tst.w   d5
    bgt.b   l_1364c
    moveq   #$0,d4
    move.b  $2(a1), d4
    moveq   #$0,d5
    move.b  $3(a1), d5
    bra.b   l_136ec
l_136a0:
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_136c2:
    moveq   #$0,d0
    move.b  (a2), d0
    move.w  d7, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_136dc
    addq.w  #$1, d3
    moveq   #$0,d0
    move.b  (a3), d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$1, (a4,a0.l)
l_136dc:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_136c2
    subq.w  #$1, d5
    addq.w  #$1, d4
l_136ec:
    tst.w   d5
    bgt.b   l_136a0
    move.w  d3, d0
    movem.l (a7)+, d2-d7/a2-a4
    rts

; ============================================================================
; SearchCharInSlots -- (TODO: name)
; 134 bytes | $0136F8-$01377D
; ============================================================================
SearchCharInSlots:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d4
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
    tst.b   $5(a3)
    beq.b   l_13776
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_13768
l_13756:
    cmp.b   (a2), d4
    beq.b   l_13760
    cmp.b   $1(a2), d4
    bne.b   l_13762
l_13760:
    addq.w  #$1, d3
l_13762:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_13768:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    cmp.l   d1, d0
    blt.b   l_13756
l_13776:
    move.w  d3, d0
    movem.l (a7)+, d2-d4/a2-a3
    rts

; ============================================================================
; RenderCharacterPanel -- (TODO: name)
; 1346 bytes | $01377E-$013CBF
; ============================================================================
RenderCharacterPanel:
    link    a6,#-$14
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d7
    movea.l  #$0003B270,a5
    move.w  d7, d0
    lsl.w   #$5, d0
    move.w  $12(a6), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d7, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  $6(a2), d0
    lsl.w   #$2, d0
    movea.l  #$00FF9A10,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  (a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (CalcQuarterBonus,PC)
    nop
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d5
    move.l  d0, -$c(a6)
    move.l  d5, d0
    bge.b   l_137ee
    addq.l  #$1, d0
l_137ee:
    asr.l   #$1, d0
    move.l  d0, -$14(a6)
    move.l  d5, d0
    bge.b   l_137fa
    addq.l  #$3, d0
l_137fa:
    asr.l   #$2, d0
    move.l  d5, d1
    sub.l   d0, d1
    move.l  d1, -$10(a6)
    move.l  d5, d0
    add.l   d0, d0
    move.l  d0, -$8(a6)
    move.l  d5, d0
    lsl.l   #$2, d0
    move.l  d0, -$4(a6)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.w   d2
    moveq   #$4,d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $28(a7), a7
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a5)
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F662).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    pea     ($0003F65C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F64A).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F636).l
    jsr     (a5)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
l_1395a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   l_1395a
    clr.w   d6
    clr.w   ($00FFBD58).l
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d5
    moveq   #$2,d4
l_13982:
    tst.w   ($00FFBD58).l
    beq.w   l_13ac0
    cmpi.w  #$1, d5
    bne.w   l_13ac8
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0011).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $30(a7), a7
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    moveq   #$0,d0
    move.w  $6(a2), d0
    lsl.l   #$2, d0
    movea.l  #$0005E296,a0
    move.l  (a0,d0.l), -(a7)
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F624).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.l  -$c(a6), -(a7)
    pea     ($0003F61E).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $30(a7), a7
    pea     ($0003F60C).l
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    pea     ($0003F5F8).l
    jsr     (a5)
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479D2).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d5
    bra.b   l_13ac8
l_13ac0:
    move.w  #$1, ($00FFBD58).l
l_13ac8:
    move.w  d3, d0
    ext.l   d0
    addq.l  #$7, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), -(a7)
    pea     ($0003F5F2).l
    jsr     (a5)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0009).w
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $2c(a7), a7
    move.w  d3, d0
    ext.l   d0
    addi.l  #$b, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    addi.l  #$15, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d4, d0
    lsl.w   #$2, d0
    movea.l  #$000479E2,a0
    move.l  (a0,d0.w), -(a7)
    jsr     (a5)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($0033).w
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$48, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    lsl.w   #$3, d0
    addi.w  #$30, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$3, d0
    addi.w  #$c0, d0
    move.l  d0, -(a7)
    jsr ShowPlayerCompare
    lea     $24(a7), a7
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   l_13bb6
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_13c5c
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_13c66
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.w   l_13c86
    bra.w   l_13ca2
l_13bb6:
    clr.w   ($00FF13FC).l
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
    cmp.l   $6(a3), d5
    bgt.b   l_13c12
    move.w  #$64, $4(a2)
    move.w  d4, d2
    mulu.w  #$14, d2
    addi.w  #$a, d2
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharacterStats,PC)
    nop
    addq.l  #$8, a7
    add.w   d0, d2
    cmpi.w  #$64, d2
    bcc.b   l_13bfe
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_13c00
l_13bfe:
    moveq   #$64,d0
l_13c00:
    move.b  d0, $2(a2)
    move.w  d4, d0
    lsl.w   #$2, d0
    move.l  -$14(a6, d0.w), d5
l_13c0c:
    move.l  d5, d0
    bra.w   l_13cb6
l_13c12:
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    move.w  $12(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($000479DE).l, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowTextDialog
    lea     $18(a7), a7
    moveq   #$1,d5
    bra.b   l_13ca2
l_13c5c:
    clr.w   ($00FF13FC).l
    moveq   #$0,d5
    bra.b   l_13c0c
l_13c66:
    move.w  #$1, ($00FF13FC).l
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    cmp.l   d0, d1
    ble.b   l_13c82
    move.w  d4, d0
    ext.l   d0
    addq.l  #$1, d0
    bra.b   l_13ca0
l_13c82:
    moveq   #$4,d0
    bra.b   l_13ca0
l_13c86:
    move.w  #$1, ($00FF13FC).l
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    ble.b   l_13c9e
    move.w  d4, d0
    ext.l   d0
    subq.l  #$1, d0
    bra.b   l_13ca0
l_13c9e:
    moveq   #$0,d0
l_13ca0:
    move.w  d0, d4
l_13ca2:
    pea     ($0006).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_13982
l_13cb6:
    movem.l -$3c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; FindSpriteByID -- (TODO: name)
; 84 bytes | $013CC0-$013D13
; ============================================================================
FindSpriteByID:
    movem.l d2-d4, -(a7)
    move.l  $18(a7), d3
    move.l  $14(a7), d4
    move.w  $12(a7), d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_13ce0:
    cmpi.b  #$6, $1(a1)
    bne.b   l_13d02
    moveq   #$0,d0
    move.w  $6(a1), d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_13d02
    cmp.b   (a1), d4
    bne.b   l_13d02
    moveq   #$0,d0
    move.b  $3(a1), d0
    bra.b   l_13d0e
l_13d02:
    addq.l  #$8, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_13ce0
    moveq   #$0,d0
l_13d0e:
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; UpdateSpritePos -- (TODO: name)
; 334 bytes | $013D14-$013E61
; ============================================================================
UpdateSpritePos:
    link    a6,#-$3C
    movem.l d2-d7/a2-a4, -(a7)
    move.l  #$8000, -(a7)
    pea     ($0006).w
    pea     ($001B).w
    pea     ($000A).w
    pea     ($0003).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $2c(a7), a7
    pea     ($0010).w
    pea     ($0030).w
    pea     ($000767DE).l
    jsr DisplaySetup
    lea     $c(a7), a7
    move.w  #$640, d4
    moveq   #$3,d5
    moveq   #$A,d7
    clr.w   d6
    move.w  $12(a6), d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d3
    move.b  (a4), d3
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    add.l   $14(a6), d0
    movea.l d0, a3
    bra.w   l_13e46
l_13d9c:
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l  #$0009C840,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($001E).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     -$3c(a6), a2
    clr.w   d2
l_13dd4:
    move.w  d4, d0
    add.w   d2, d0
    ori.w   #$6000, d0
    move.w  d0, (a2)+
    addq.w  #$1, d2
    cmpi.w  #$1e, d2
    blt.b   l_13dd4
    pea     -$3c(a6)
    pea     ($0005).w
    pea     ($0006).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    move.w  d7, d0
    ext.l   d0
    addq.l  #$5, d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$4, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F674).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    add.w   (a3), d6
    addi.w  #$1e, d4
    addq.w  #$7, d5
    addq.l  #$2, a3
    addq.w  #$1, d3
l_13e46:
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    cmp.l   d1, d0
    ble.w   l_13d9c
    move.w  d6, d0
    movem.l -$60(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; InitRouteBuffer -- (TODO: name)
; 144 bytes | $013E62-$013EF1
; ============================================================================
InitRouteBuffer:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l $24(a7), a5
    clr.w   d4
    pea     ($000C).w
    clr.l   -(a7)
    pea     ($00FF9A10).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF9A10,a3
    clr.w   d3
l_13e8a:
    tst.w   d3
    bne.b   l_13e92
    clr.w   d2
    bra.b   l_13e9e
l_13e92:
    cmpi.w  #$1, d3
    bne.b   l_13e9c
    moveq   #$3,d2
    bra.b   l_13e9e
l_13e9c:
    moveq   #$2,d2
l_13e9e:
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d2
    move.b  (a4), d2
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    bra.b   l_13ed2
l_13ec0:
    tst.w   (a2)
    ble.b   l_13ece
    move.w  (a2), d0
    add.w   d0, (a3)
    addq.w  #$1, $2(a3)
    moveq   #$1,d4
l_13ece:
    addq.l  #$2, a2
    addq.w  #$1, d2
l_13ed2:
    move.w  d2, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    cmp.l   d1, d0
    ble.b   l_13ec0
    addq.l  #$4, a3
    addq.w  #$1, d3
    cmpi.w  #$3, d3
    blt.b   l_13e8a
    move.w  d4, d0
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; InitSpriteData -- (TODO: name)
; 490 bytes | $013EF2-$0140DB
; ============================================================================
InitSpriteData:
    link    a6,#-$8
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d4
    move.l  $8(a6), d5
    move.w  $e(a6), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.b  (a0), d3
    andi.l  #$ff, d3
    move.w  d4, d0
    add.w   d0, d0
    movea.l  #$0005F908,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    clr.w   d6
    moveq   #$1F,d7
    move.w  #$7, -$6(a6)
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    movea.l -$4(a6), a0
    move.b  $1(a0), d4
    andi.l  #$ff, d4
    bra.w   l_13fee
l_13f5a:
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_13f80:
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_13fbc
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcs.b   l_13fbc
    move.b  (a2), d0
    cmp.b   $1(a4), d0
    bhi.b   l_13fbc
    addq.w  #$1, -$6(a6)
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_13fc8
    addq.w  #$1, d6
    bra.b   l_13fc8
l_13fbc:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    blt.b   l_13f80
l_13fc8:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    addq.w  #$1, d7
    addq.l  #$2, a5
    subq.w  #$1, d4
    addq.w  #$1, d3
l_13fee:
    tst.w   d4
    bgt.w   l_13f5a
    movea.l -$4(a6), a0
    move.b  $2(a0), d3
    andi.l  #$ff, d3
    move.w  d3, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    movea.l -$4(a6), a0
    move.b  $3(a0), d4
    andi.l  #$ff, d4
    bra.w   l_140ca
l_14024:
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d2
l_14046:
    moveq   #$0,d0
    move.b  (a3), d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_14098
    move.b  (a2), d0
    cmp.b   (a4), d0
    bcs.b   l_14098
    move.b  (a2), d0
    cmp.b   $1(a4), d0
    bhi.b   l_14098
    addq.w  #$1, -$6(a6)
    move.w  d3, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d5, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  $e(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    beq.b   l_140a4
    addq.w  #$1, d6
    bra.b   l_140a4
l_14098:
    addq.l  #$1, a2
    addq.l  #$1, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_14046
l_140a4:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr GetCharRelation
    lea     $c(a7), a7
    addq.l  #$2, a5
    addq.w  #$1, d7
    subq.w  #$1, d4
    addq.w  #$1, d3
l_140ca:
    tst.w   d4
    bgt.w   l_14024
    move.w  d6, d0
    movem.l -$30(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; CalcQuarterBonus -- (TODO: describe)
; Called: ?? times.
; 60 bytes | $0140DC-$014117
; ============================================================================
CalcQuarterBonus:                                                  ; $0140DC
    move.l  d2,-(sp)
    move.w  $000a(sp),d2
    ext.l   d2
    move.l  d2,d0
    lsl.l   #$2,d2
    add.l   d0,d2
    lsl.l   #$2,d2
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    move.l  (sp)+,d2
    rts
; === Translated block $014118-$014202 ===
; 1 functions, 234 bytes

; ============================================================================
; UpdateCharacterStats -- (TODO: name)
; 234 bytes | $014118-$014201
; ============================================================================
UpdateCharacterStats:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d5
    clr.w   d3
    move.w  $26(a7), d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d2
    move.b  (a1), d2
    moveq   #$0,d6
    move.b  (a1), d6
    moveq   #$0,d0
    move.b  $1(a1), d0
    add.w   d0, d6
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    move.l  d0, d4
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FF0420,a0
    lea     (a0,d4.w), a2
    move.w  d2, d4
    bra.b   l_14190
l_1416c:
    clr.w   d2
l_1416e:
    cmpi.b  #$e, (a3)
    bne.b   l_14182
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_14182
    addq.w  #$1, d3
l_14182:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$6, d2
    bcs.b   l_1416e
    addq.w  #$1, d4
l_14190:
    cmp.w   d6, d4
    bcs.b   l_1416c
    moveq   #$0,d2
    move.b  $2(a1), d2
    moveq   #$0,d6
    move.b  $2(a1), d6
    moveq   #$0,d0
    move.b  $3(a1), d0
    add.w   d0, d6
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d4
    bra.b   l_141f0
l_141cc:
    clr.w   d2
l_141ce:
    cmpi.b  #$e, (a3)
    bne.b   l_141e2
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bne.b   l_141e2
    addq.w  #$1, d3
l_141e2:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_141ce
    addq.w  #$1, d4
l_141f0:
    cmp.w   d6, d4
    bcs.b   l_141cc
    move.w  d3, d5
    mulu.w  #$1e, d5
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; ProcessCharActions -- (TODO: describe)
; Called: ?? times.
; 1168 bytes | $014202-$014691
; ============================================================================
ProcessCharActions:                                                  ; $014202
    link    a6,#-$4
    movem.l d2-d7/a2-a5,-(sp)
    moveq   #$0,d2
    move.b  ($00FF0016).l,d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    move.l  a0,-$0004(a6)
    movea.l #$00ffba6c,a4
    clr.w   d7
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $001c(sp),sp
    move.w  d2,d0
    lsl.w   #$5,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    bra.w   .l14680
.l14278:                                                ; $014278
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    clr.w   d5
    clr.w   d3
    pea     ($0014).w
    clr.l   -(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    lea     $0024(sp),sp
    move.w  d0,d6
    cmpi.w  #$ff,d6
    bne.w   .l14394
    move.l  #$8000,-(sp)
    pea     ($0005).w
    pea     ($0003).w
    pea     ($0020).w
    pea     ($0015).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.w  ($00FF9A1C).l,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.w   d4
    bra.b   .l14328
.l142fe:                                                ; $0142FE
    moveq   #$0,d0
    move.b  (a3),d0
    move.w  d4,d1
    ext.l   d1
    add.l   d1,d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$00ffa6a0,a0
    and.l   (a0,d1.w),d0
    beq.b   .l14326
    moveq   #$0,d6
    move.b  (a3),d6
    add.w   d4,d6
    bra.b   .l14336
.l14326:                                                ; $014326
    addq.w  #$1,d4
.l14328:                                                ; $014328
    move.w  d4,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l142fe
.l14336:                                                ; $014336
    cmpi.w  #$ff,d6
    bne.b   .l14394
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0003F772).l
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    clr.l   -(sp)
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $002c(sp),sp
.l14394:                                                ; $014394
    cmpi.w  #$ff,d6
    beq.w   .l14464
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$538e                           ; jsr $00538E
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$09ee                                 ; jsr $014DA6
    nop
    lea     $0010(sp),sp
    move.w  d0,d7
    cmpi.w  #$ff,d7
    bne.b   .l14414
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    clr.l   -(sp)
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $0018(sp),sp
    cmpi.w  #$7,($00FF9A1C).l
    bne.b   .l14464
    move.w  #$ff,d3
    bra.b   .l14466
.l14414:                                                ; $014414
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d7,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0014).w
    move.l  a4,-(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$b324                           ; jsr $01B324
    lea     $0020(sp),sp
    bra.b   .l14466
.l14464:                                                ; $014464
    moveq   #$c,d3
.l14466:                                                ; $014466
    cmpi.w  #$c,d3
    beq.w   .l14680
    cmpi.w  #$ff,d3
    beq.w   .l14680
    move.l  a4,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0212                                 ; jsr $014692
    nop
    addq.l  #$8,sp
    move.w  d0,d3
    cmpi.w  #$1,d3
    bne.b   .l144c8
    move.l  a2,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$19b4                           ; jsr $0119B4
    addq.l  #$8,sp
    clr.w   d7
    movea.l -$0004(a6),a0
    move.b  $0004(a0),d0
    andi.l  #$ff,d0
    movea.l -$0004(a6),a0
    move.b  $0005(a0),d1
    andi.l  #$ff,d1
    add.l   d1,d0
    bgt.w   .l14636
    moveq   #$c,d3
    bra.w   .l14636
.l144c8:                                                ; $0144C8
    cmpi.w  #$ff,d3
    beq.w   .l14636
    move.b  $0002(a2),d0
    cmp.b   $0002(a4),d0
    bne.b   .l144f8
    move.b  $0003(a2),d0
    cmp.b   $0003(a4),d0
    bne.b   .l144f8
    move.w  $0004(a2),d0
    cmp.w   $0004(a4),d0
    bne.b   .l144f8
    move.b  $000a(a2),d0
    cmp.b   $000a(a4),d0
    beq.b   .l144fa
.l144f8:                                                ; $0144F8
    moveq   #$1,d5
.l144fa:                                                ; $0144FA
    cmpi.w  #$1,d5
    bne.w   .l14636
    move.l  #$8000,-(sp)
    pea     ($0005).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0005).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($0003F748).l
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    lea     $0030(sp),sp
    cmpi.w  #$1,d0
    bne.w   .l14636
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    sub.b   d1,(a0,d0.w)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    andi.l  #$ffff,d0
    add.l   d0,d0
    lea     (a5,d0.l),a0
    addq.l  #$1,a0
    movea.l a0,a3
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    add.b   d0,(a3)
    pea     ($0014).w
    move.l  a2,-(sp)
    clr.l   -(sp)
    move.l  a4,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    add.b   d1,(a0,d0.w)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$3,d0
    move.w  d2,d1
    add.w   d1,d1
    add.w   d1,d0
    move.b  $0003(a2),d1
    movea.l #$00ffba81,a0
    add.b   d1,(a0,d0.w)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    andi.l  #$ffff,d0
    add.l   d0,d0
    lea     (a5,d0.l),a0
    addq.l  #$1,a0
    movea.l a0,a3
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    lea     $0024(sp),sp
    sub.b   d0,(a3)
    ori.b   #$01,$000a(a2)
.l14636:                                                ; $014636
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0001).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6a2e                           ; jsr $006A2E
    pea     ($0002).w
    move.w  ($00FF9A1C).l,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    lea     $0018(sp),sp
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
.l14680:                                                ; $014680
    cmpi.w  #$c,d3
    bne.w   .l14278
    movem.l -$2C(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $014692-$016958 ===
; 11 functions, 8902 bytes

; ============================================================================
; ProcessCharacterAction -- (TODO: name)
; 524 bytes | $014692-$01489D
; ============================================================================
ProcessCharacterAction:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d3
    movea.l $30(a7), a2
    movea.l  #$0001489E,a3
    movea.l  #$00FFBA80,a4
    movea.l  #$00FFBD4E,a5
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  $1(a0), d7
    andi.l  #$ff, d7
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  $1(a0), d6
    andi.l  #$ff, d6
    jsr PreLoopInit
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, ($00FFBD5C).l
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, (a5)
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.l  d0, d4
    move.w  ($00FFBD5C).l, d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  $1(a5), d1
    movea.l  #$00FFB9E9,a0
    add.b   d1, (a0,d0.w)
    jsr ResourceLoad
    move.l  a2, -(a7)
    jsr (CalcCharacterBonus,PC)
    nop
    moveq   #$2,d2
    moveq   #$1,d5
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0005).w
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationDisplay
    lea     $20(a7), a7
    bra.w   .l1483c
.l1475e:
    move.l  a2, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ApplyCharacterEffect,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    tst.w   d2
    bne.b   .l147d8
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l147aa
    andi.b  #$1, $a(a2)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    bra.b   .l147cc
.l147aa:
    ori.b   #$2, $a(a2)
    pea     ($0007193C).l
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
.l147cc:
    jsr GameCommand
    lea     $1c(a7), a7
    bra.b   .l14836
.l147d8:
    cmpi.w  #$1, d2
    beq.b   .l14850
    cmpi.w  #$2, d2
    bne.b   .l147f4
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderTilePattern,PC)
    nop
    bra.b   .l14834
.l147f4:
    cmpi.w  #$3, d2
    bne.b   .l1480a
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (DrawScreenElement,PC)
    nop
    bra.b   .l14834
.l1480a:
    cmpi.w  #$4, d2
    bne.b   .l14820
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateScreenLayout,PC)
    nop
    bra.b   .l14834
.l14820:
    cmpi.w  #$5, d2
    bne.b   .l1483c
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RefreshDisplayArea,PC)
    nop
.l14834:
    addq.l  #$8, a7
.l14836:
    move.l  a2, -(a7)
    jsr     (a3)
    addq.l  #$4, a7
.l1483c:
    jsr ResourceUnload
    cmpi.w  #$ff, d2
    beq.b   .l14850
    cmpi.w  #$6, d2
    bne.w   .l1475e
.l14850:
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  d7, $1(a0)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.l   #$3, d0
    lea     (a4,d0.l), a0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    adda.l  d1, a0
    move.b  d6, $1(a0)
    move.w  ($00FFBD5C).l, d0
    add.w   d0, d0
    add.w   d4, d0
    move.b  $1(a5), d1
    movea.l  #$00FFB9E9,a0
    sub.b   d1, (a0,d0.w)
    move.w  d2, d0
    movem.l (a7)+, d2-d7/a2-a5
    rts

; ============================================================================
; ValidateCharacterState -- (TODO: name)
; 212 bytes | $01489E-$014971
; ============================================================================
ValidateCharacterState:
    link    a6,#-$10
    movem.l d2-d3/a2, -(a7)
    movea.l $8(a6), a2
    moveq   #-$1,d3
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    jsr VRAMBulkLoad
    lea     $1c(a7), a7
    move.b  $a(a2), d0
    btst    #$2, d0
    beq.b   .l148e8
    moveq   #$0,d3
    bra.b   .l14902
.l148e8:
    move.b  $a(a2), d0
    btst    #$1, d0
    beq.b   .l148f6
    moveq   #$10,d3
    bra.b   .l14902
.l148f6:
    move.b  $a(a2), d0
    btst    #$0, d0
    beq.b   .l14902
    moveq   #$8,d3
.l14902:
    moveq   #-$1,d0
    cmp.l   d3, d0
    bge.b   .l14946
    clr.w   d2
    move.w  d2, d0
    ext.l   d0
    add.l   d3, d0
    addi.l  #$637b, d0
    move.l  d0, d3
.l14918:
    move.w  d2, d0
    add.w   d0, d0
    move.w  d3, -$10(a6, d0.w)
    addq.l  #$1, d3
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   .l14918
    pea     -$10(a6)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001B).w
    bra.b   .l14962
.l14946:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
.l14962:
    jsr GameCommand
    movem.l -$1c(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; CalcCharacterBonus -- (TODO: name)
; 312 bytes | $014972-$014AA9
; ============================================================================
CalcCharacterBonus:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l $18(a7), a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    move.l  a2, -(a7)
    jsr GetByteField4
    move.w  d0, d3
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, d2
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076A1E).l
    jsr DisplaySetup
    move.l  ($000A1B00).l, -(a7)
    pea     ($00FF899C).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    pea     ($0080).w
    pea     ($006A).w
    pea     ($00FF899C).l
    jsr CmdPlaceTile
    pea     ($0007184C).l
    pea     ($0004).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr GameCommand
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0003).w
    pea     ($0009).w
    jsr     (a4)
    movea.l  #$00FF1278,a0
    move.b  (a0,d3.w), d0
    andi.l  #$ff, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECFC,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F7B0).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($0011).w
    jsr     (a4)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F7AC).l
    jsr     (a3)
    lea     $30(a7), a7
    pea     ($0003).w
    pea     ($0015).w
    jsr     (a4)
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F7A8).l
    jsr     (a3)
    pea     ($0003).w
    pea     ($001A).w
    jsr     (a4)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F7A4).l
    jsr     (a3)
    lea     $20(a7), a7
    movem.l (a7)+, d2-d3/a2-a4
    rts

; ============================================================================
; ApplyCharacterEffect -- (TODO: name)
; 698 bytes | $014AAA-$014D63
; ============================================================================
ApplyCharacterEffect:
    link    a6,#-$4
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d4
    movea.l $10(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00005092,a4
    movea.l  #$00000D64,a5
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14b1a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0003F7D8).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
.l14b1a:
    move.w  #$88a, -$2(a6)
    move.w  #$448, -$4(a6)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $c(a7), a7
.l14b40:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l14b40
    clr.w   d3
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
.l14b5a:
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $c(a7), a7
.l14b74:
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0014).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    move.w  d0, d3
    andi.l  #$bc, d0
    beq.b   .l14b74
    move.w  d3, d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l14bb8
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l14be2
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.b   .l14bea
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l14c3a
    cmpi.w  #$80, d0
    beq.w   .l14c7c
    bra.w   .l14d4a
.l14bb8:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
.l14bdc:
    move.w  d2, d0
    bra.w   .l14d5a
.l14be2:
    clr.w   (a3)
    move.w  #$ff, d2
    bra.b   .l14bdc
.l14bea:
    move.w  #$1, (a3)
    cmpi.w  #$6, d2
    bge.b   .l14c26
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    jsr     (a4)
    addq.w  #$1, d2
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $18(a7), a7
.l14c26:
    cmpi.w  #$6, d2
    bge.b   .l14c32
.l14c2c:
    move.w  d2, d0
    ext.l   d0
    bra.b   .l14c34
.l14c32:
    moveq   #$6,d0
.l14c34:
    move.w  d0, d2
    bra.w   .l14d4a
.l14c3a:
    move.w  #$1, (a3)
    tst.w   d2
    ble.b   .l14c74
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$4(a6)
    jsr     (a4)
    subq.w  #$1, d2
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    addi.l  #$29, d0
    move.l  d0, -(a7)
    pea     -$2(a6)
    jsr     (a4)
    lea     $18(a7), a7
.l14c74:
    tst.w   d2
    bgt.b   .l14c2c
    moveq   #$0,d0
    bra.b   .l14c34
.l14c7c:
    clr.w   (a3)
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowsePartners
    lea     $28(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckMatchSlots
    lea     $30(a7), a7
    tst.w   d0
    beq.b   .l14d3a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    jsr DrawBox
    pea     ($0003F7B4).l
    jsr PrintfNarrow
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $24(a7), a7
.l14d3a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.w  #$fff, d0
    bne.b   .l14d3a
.l14d4a:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l14b5a
.l14d5a:
    movem.l -$20(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ============================================================================
; WaitStableInput -- (TODO: name)
; 66 bytes | $014D64-$014DA5
; ============================================================================
WaitStableInput:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d4
    bra.b   .l14d9c
.l14d7a:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d3
    cmp.w   d3, d4
    bne.b   .l14da0
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    subq.w  #$1, d2
.l14d9c:
    tst.w   d2
    bne.b   .l14d7a
.l14da0:
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; RankCharCandidatesFull -- (TODO: name)
; 666 bytes | $014DA6-$01503F
; ============================================================================
RankCharCandidatesFull:
    link    a6,#-$54
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    move.l  $8(a6), d6
    movea.l  #$00FF13FC,a4
    movea.l  #$00FFA7D8,a5
    clr.w   d7
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d6, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    clr.w   d3
    bra.b   .l14e5a
.l14e3a:
    cmp.b   (a2), d5
    beq.b   .l14e44
    cmp.b   $1(a2), d5
    bne.b   .l14e54
.l14e44:
    move.w  d3, d0
    add.w   d0, d0
    move.w  d2, -$50(a6, d0.w)
    cmp.w   d2, d4
    bne.b   .l14e52
    move.w  d3, d4
.l14e52:
    addq.w  #$1, d3
.l14e54:
    addq.w  #$1, d2
    moveq   #$14,d0
    adda.l  d0, a2
.l14e5a:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bgt.b   .l14e3a
    tst.w   d3
    ble.w   .l15016
    move.w  d4, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    mulu.w  #$14, d0
    move.w  d6, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ClearTileArea
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0013).w
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationStats
    clr.w   -$54(a6)
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   .l14ed0
    moveq   #$1,d5
    bra.b   .l14ed2
.l14ed0:
    moveq   #$0,d5
.l14ed2:
    clr.w   -$52(a6)
    clr.w   (a4)
    clr.w   (a5)
    move.w  d4, d2
.l14edc:
    tst.w   d7
    beq.b   .l14f38
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    mulu.w  #$14, d0
    move.w  d6, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    jsr ClearTileArea
    pea     ($0001).w
    move.w  -$54(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0013).w
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr FormatRelationStats
    pea     ($0020).w
    bsr.w WaitStableInput
    lea     $1c(a7), a7
    clr.w   -$54(a6)
    clr.w   d7
.l14f38:
    moveq   #$1,d4
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeMatch
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    tst.w   d5
    beq.b   .l14f7e
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14f7e
    pea     ($0002).w
.l14f6e:
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l14edc
.l14f7e:
    clr.w   d5
    move.w  -$52(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, -$52(a6)
    cmpi.w  #$1, d4
    move.w  -$52(a6), d0
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l14fbe
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l14fcc
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   .l14fd2
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   .l14ff2
    bra.b   .l1500a
.l14fbe:
    clr.w   (a4)
    clr.w   (a5)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$50(a6, d0.w), d0
    bra.b   .l15036
.l14fcc:
    clr.w   (a4)
    clr.w   (a5)
    bra.b   .l15032
.l14fd2:
    move.w  #$1, (a4)
    cmpi.w  #$1, d3
    ble.b   .l1500e
    addq.w  #$1, d2
    move.w  d2, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    subq.l  #$1, d1
    cmp.l   d1, d0
    ble.b   .l14fee
    clr.w   d2
.l14fee:
    moveq   #$1,d7
    bra.b   .l1500e
.l14ff2:
    move.w  #$1, (a4)
    cmpi.w  #$1, d3
    ble.b   .l1500e
    subq.w  #$1, d2
    tst.w   d2
    bge.b   .l14fee
    move.w  d3, d2
    addi.w  #$ffff, d2
    bra.b   .l14fee
.l1500a:
    clr.w   (a4)
    clr.w   (a5)
.l1500e:
    pea     ($0004).w
    bra.w   .l14f6e
.l15016:
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0003F7FC).l
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
.l15032:
    move.w  #$ff, d0
.l15036:
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RenderTilePattern -- (TODO: name)
; 1208 bytes | $015040-$0154F7
; ============================================================================
RenderTilePattern:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l $c(a6), a2
    lea     -$20(a6), a4
    movea.l  #$00000D64,a5
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, -$28(a6)
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0009).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $20(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d3
    clr.w   d2
.l1509c:
    tst.b   (a3)
    beq.b   .l150f0
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CheckCharCompat
    lea     $c(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.b   .l150f0
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d2, (a4,a0.l)
    move.l  a2, -(a7)
    jsr GetByteField4
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   .l150ee
    move.w  d3, d7
.l150ee:
    addq.w  #$1, d3
.l150f0:
    addq.l  #$2, a3
    addq.w  #$1, d2
    cmpi.w  #$10, d2
    blt.b   .l1509c
    move.w  d3, d0
    addi.w  #$ffff, d0
    move.w  d0, -$24(a6)
    tst.w   -$24(a6)
    bne.b   .l15112
    move.w  #$1, -$26(a6)
    bra.b   .l15116
.l15112:
    clr.w   -$26(a6)
.l15116:
    move.w  d7, d3
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  -$27(a6), d1
    movea.l  #$00FFB9E9,a0
    sub.b   d1, (a0,d0.w)
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l1514c
    moveq   #$1,d2
    bra.b   .l1514e
.l1514c:
    moveq   #$0,d2
.l1514e:
    clr.w   -$22(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$1,d6
    clr.w   d4
.l15162:
    addq.w  #$1, d4
    cmpi.w  #$1, d4
    bne.b   .l151d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0094).w
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0094).w
    pea     ($0080).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l151c4:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.b   .l151f2
.l151d2:
    cmpi.w  #$f, d4
    bne.b   .l151ea
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l151c4
.l151ea:
    cmpi.w  #$1e, d4
    bne.b   .l151f2
    clr.w   d4
.l151f2:
    cmpi.w  #$1, d6
    bne.b   .l1525a
    pea     ($0003).w
    pea     ($0001).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharDetail
    lea     $1c(a7), a7
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
    clr.w   d6
.l1525a:
    tst.w   d2
    beq.b   .l1527c
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l1527c
.l1526c:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a5)
    addq.l  #$8, a7
    bra.w   .l15162
.l1527c:
    clr.w   d2
    move.w  -$22(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$bc, d0
    move.w  d0, -$22(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l152bc
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l153f2
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15432
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15448
    bra.w   .l1545e
.l152bc:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   d7, d3
    beq.w   .l1547a
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    tst.w   d0
    ble.w   .l153ee
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr SetHighNibble
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E9,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    move.l  a2, -(a7)
    jsr GetLowNibble
    lea     $1c(a7), a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l15366
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    bra.b   .l1536a
.l15366:
    move.w  d2, d0
    ext.l   d0
.l1536a:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F838).l
    jsr PrintfNarrow
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationAction
    lea     $2c(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationResult
    pea     ($064C).w
    pea     ($0008).w
    pea     ($000E).w
    pea     ($0009).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $30(a7), a7
    bra.w   .l1547a
.l153ee:
    clr.w   d6
    bra.b   .l1546a
.l153f2:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   d7, d3
    beq.b   .l1547a
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    clr.l   -(a7)
    pea     ($0009).w
    pea     ($0002).w
    move.w  d7, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowCharPortrait
    lea     $18(a7), a7
    bra.b   .l1547a
.l15432:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d6
    subq.w  #$1, d3
    tst.w   d3
    bge.b   .l1546a
    move.w  -$24(a6), d3
    bra.b   .l1546a
.l15448:
    move.w  #$1, ($00FF13FC).l
    moveq   #$1,d6
    addq.w  #$1, d3
    cmp.w   -$24(a6), d3
    ble.b   .l1546a
    clr.w   d3
    bra.b   .l1546a
.l1545e:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l1546a:
    cmpi.w  #$1, -$26(a6)
    bne.w   .l1526c
    clr.w   d6
    bra.w   .l1526c
.l1547a:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    move.w  d5, d0
    lsl.w   #$5, d0
    move.w  d7, d1
    ext.l   d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  (a4,a0.l), d1
    add.w   d1, d1
    add.w   d1, d0
    move.b  -$27(a6), d1
    movea.l  #$00FFB9E9,a0
    add.b   d1, (a0,d0.w)
    jsr LoadMapTiles
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; DrawScreenElement -- (TODO: name)
; 1878 bytes | $0154F8-$015C4D
; ============================================================================
DrawScreenElement:
    link    a6,#-$38
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a4
    lea     -$2e(a6), a5
    moveq   #$0,d0
    move.b  (a2), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, -$32(a6)
    moveq   #$0,d0
    move.b  $1(a2), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    sub.w   d1, d0
    move.w  d0, -$34(a6)
    move.l  a2, -(a7)
    jsr GetByteField4
    andi.l  #$ffff, d0
    add.l   d0, d0
    move.w  $a(a6), d1
    lsl.w   #$5, d1
    add.l   d1, d0
    movea.l  #$00FFB9E8,a0
    adda.l  d0, a0
    movea.l a0, a3
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.w  d0, (a5)
    moveq   #$0,d6
    move.b  $b(a2), d6
    cmpi.w  #$9, (a5)
    bge.b   .l155a0
    move.w  (a5), d0
    ext.l   d0
    bra.b   .l155a2
.l155a0:
    moveq   #$9,d0
.l155a2:
    move.w  d0, (a5)
    move.l  a2, -(a7)
    jsr GetLowNibble
    move.w  d0, d3
    move.w  d0, -$2(a6)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    moveq   #$12,d7
    clr.w   d2
.l155c8:
    move.w  d2, d0
    addi.w  #$2d7f, d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$2a(a6, d1.w)
    addq.w  #$1, d2
    cmpi.w  #$14, d2
    blt.b   .l155c8
    pea     ($0010).w
    pea     ($0010).w
    pea     ($00076A3E).l
    jsr DisplaySetup
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $2c(a7), a7
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $c(a7), a7
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   .l1565a
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
    bra.b   .l15684
.l1565a:
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
.l15684:
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F854).l
    jsr PrintfWide
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l156c6
    moveq   #$1,d2
    bra.b   .l156c8
.l156c6:
    moveq   #$0,d2
.l156c8:
    clr.w   -$2c(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d4
    clr.w   -$36(a6)
    bra.w   .l15bc0
.l156e2:
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F850).l
    jsr PrintfNarrow
    lea     $10(a7), a7
    tst.w   d2
    beq.b   .l1571a
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l15bb4
.l1571a:
    clr.w   d2
    addq.w  #$1, -$36(a6)
    cmpi.w  #$1, -$36(a6)
    bne.b   .l157a4
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
    pea     ($0008).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$c, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l15796:
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
    bra.b   .l157ca
.l157a4:
    cmpi.w  #$f, -$36(a6)
    bne.b   .l157be
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l15796
.l157be:
    cmpi.w  #$1e, -$36(a6)
    bne.b   .l157ca
    clr.w   -$36(a6)
.l157ca:
    move.w  -$2c(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, -$2c(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l15808
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   .l158f4
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l15924
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l15a80
    bra.w   .l15ba8
.l15808:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    cmp.w   -$2(a6), d3
    beq.w   .l15bc8
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr UpdateCharField
    moveq   #$0,d0
    move.b  $3(a2), d0
    move.w  d6, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l15840
    moveq   #$0,d0
    move.b  $3(a2), d0
    bra.b   .l15844
.l15840:
    move.w  d6, d0
    ext.l   d0
.l15844:
    move.b  d0, $3(a2)
    move.b  -$31(a6), d0
    add.b   $3(a2), d0
    moveq   #$0,d1
    move.b  (a2), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    move.b  -$33(a6), d0
    add.b   $3(a2), d0
    moveq   #$0,d1
    move.b  $1(a2), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$32(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F84C).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $20(a7), a7
    move.w  -$34(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F848).l
.l158e8:
    jsr PrintfNarrow
    addq.l  #$8, a7
    bra.w   .l15bc8
.l158f4:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    pea     ($0010).w
    pea     ($000E).w
    jsr SetTextCursor
    addq.l  #$8, a7
    move.l  a2, -(a7)
    jsr GetLowNibble
    addq.l  #$4, a7
    move.l  d0, -(a7)
    pea     ($0003F844).l
    bra.b   .l158e8
.l15924:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d3
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    ble.b   .l15972
    cmpi.w  #$1, (a5)
    ble.b   .l15972
    tst.w   -$30(a6)
    bne.b   .l15972
    pea     ($00071A14).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.w  #$1, -$30(a6)
.l15972:
    tst.w   d3
    ble.b   .l1598e
    clr.l   -(a7)
    move.w  d7, d0
    ext.l   d0
    subq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($000E).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l1598e:
    cmpi.w  #$1, d3
    ble.b   .l1599a
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1599c
.l1599a:
    moveq   #$1,d0
.l1599c:
    move.w  d0, d3
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F840).l
    jsr PrintfWide
    move.l  a2, -(a7)
    jsr CalcCompatScore
    lea     $14(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d6
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    ble.b   .l159fe
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15a00
.l159fe:
    moveq   #$0,d5
.l15a00:
    cmpi.w  #$7, d5
    bge.b   .l15a36
    pea     ($077E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($0010).w
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
.l15a36:
    cmpi.w  #$7, d6
    bge.b   .l15a42
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15a44
.l15a42:
    moveq   #$7,d5
.l15a44:
    cmpi.w  #$7, d5
    bge.w   .l15bb4
    pea     ($077E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0, d1
    move.l  d1, -(a7)
    pea     ($000F).w
    move.w  d5, d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
.l15a6e:
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    bra.w   .l15bb4
.l15a80:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d3
    cmp.w   (a5), d3
    bgt.b   .l15aa6
    pea     ($0001).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr DiagonalWipe
    lea     $c(a7), a7
.l15aa6:
    cmp.w   (a5), d3
    bge.b   .l15aae
    move.w  d3, d0
    bra.b   .l15ab0
.l15aae:
    move.w  (a5), d0
.l15ab0:
    ext.l   d0
    move.w  d0, d3
    move.w  d7, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr SetTextCursor
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F83C).l
    jsr PrintfWide
    lea     $10(a7), a7
    move.w  (a5), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    bgt.b   .l15b24
    cmpi.w  #$1, -$30(a6)
    bne.b   .l15b24
    pea     ($000719C4).l
    pea     ($0004).w
    pea     ($000A).w
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $1c(a7), a7
    clr.w   -$30(a6)
.l15b24:
    move.l  a2, -(a7)
    jsr CalcCompatScore
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    jsr Multiply32
    moveq   #$14,d1
    jsr SignedDiv
    move.w  d0, d6
    cmpi.w  #$7, d6
    bge.b   .l15b4e
    move.w  d6, d5
    ext.l   d5
    bra.b   .l15b50
.l15b4e:
    moveq   #$7,d5
.l15b50:
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    lea     $20(a7), a7
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    moveq   #$7,d0
    cmp.l   d5, d0
    ble.b   .l15b88
    move.w  d6, d5
    ext.l   d5
    subq.l  #$7, d5
    bra.b   .l15b8a
.l15b88:
    moveq   #$7,d5
.l15b8a:
    tst.w   d5
    ble.b   .l15bb4
    pea     ($033E).w
    pea     ($0001).w
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    bra.w   .l15a6e
.l15ba8:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
.l15bb4:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a4)
    addq.l  #$8, a7
.l15bc0:
    cmpi.w  #$ff, d4
    bne.w   .l156e2
.l15bc8:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationAction
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    jsr ShowRelationResult
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a4)
    movem.l -$60(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateScreenLayout -- (TODO: name)
; 1940 bytes | $015C4E-$0163E1
; ============================================================================
UpdateScreenLayout:
    link    a6,#-$7C
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a4
    lea     -$6(a6), a5
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d2
    andi.l  #$ff, d2
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d2
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    move.b  (a0,d0.w), d3
    andi.l  #$ff, d3
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d0, d3
    cmp.w   d3, d2
    bge.b   .l15ce6
    move.w  d2, d0
    bra.b   .l15ce8
.l15ce6:
    move.w  d3, d0
.l15ce8:
    ext.l   d0
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a4), d0
    add.w   d0, d2
    moveq   #$0,d4
    move.b  $b(a4), d4
    cmpi.w  #$e, d4
    bge.b   .l15d06
    move.w  d4, d0
    ext.l   d0
    bra.b   .l15d08
.l15d06:
    moveq   #$E,d0
.l15d08:
    move.w  d0, d4
    cmp.w   d2, d4
    bge.b   .l15d12
    move.w  d4, d0
    bra.b   .l15d14
.l15d12:
    move.w  d2, d0
.l15d14:
    ext.l   d0
    move.w  d0, d4
    moveq   #$0,d2
    move.b  $3(a4), d2
    cmp.w   d4, d2
    bge.b   .l15d26
    move.w  d2, d0
    bra.b   .l15d28
.l15d26:
    move.w  d4, d0
.l15d28:
    ext.l   d0
    move.b  d0, $3(a4)
    cmpi.b  #$1, $3(a4)
    bls.b   .l15d3e
    moveq   #$0,d3
    move.b  $3(a4), d3
    bra.b   .l15d40
.l15d3e:
    moveq   #$1,d3
.l15d40:
    cmpi.w  #$7, d3
    bge.b   .l15d4c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l15d4e
.l15d4c:
    moveq   #$7,d0
.l15d4e:
    move.w  d0, (a5)
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    tst.w   (a5)
    ble.b   .l15dac
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l15dac:
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$78(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    add.w   d0, d0
    lea     -$40(a6, d0.w), a0
    movea.l a0, a2
    bra.b   .l15de0
.l15dc4:
    cmp.w   d3, d2
    bge.b   .l15dd2
    move.w  #$8541, (a2)
    move.w  #$8542, (a3)
    bra.b   .l15dda
.l15dd2:
    move.w  #$8000, (a2)
    move.w  #$8543, (a3)
.l15dda:
    addq.l  #$2, a2
    addq.l  #$2, a3
    addq.w  #$1, d2
.l15de0:
    cmp.w   d4, d2
    blt.b   .l15dc4
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$40(a6, d0.w)
    move.w  d2, d0
    add.w   d0, d0
    clr.w   -$78(a6, d0.w)
    moveq   #$1,d6
    moveq   #$12,d5
    pea     ($0004).w
    pea     ($0014).w
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr DrawBox
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    lea     $28(a7), a7
    move.w  d5, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    jsr PlaceIconTiles
    moveq   #$0,d0
    move.b  (a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    sub.w   d3, d0
    move.w  d0, -$7a(a6)
    moveq   #$0,d0
    move.b  $1(a4), d0
    lsl.w   #$3, d0
    move.w  $a(a6), d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d7
    andi.l  #$ff, d7
    sub.w   d3, d7
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l15eb4
    moveq   #$1,d2
    bra.b   .l15eb6
.l15eb4:
    moveq   #$0,d2
.l15eb6:
    clr.w   -$2(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    moveq   #$0,d0
    move.w  d0, -$7c(a6)
    andi.l  #$ffff, d0
.l15ed2:
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F870).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F86C).l
    jsr PrintfNarrow
    pea     ($000F).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F868).l
    jsr PrintfWide
    lea     $30(a7), a7
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F864).l
    jsr PrintfWide
    pea     -$40(a6)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     -$78(a6)
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $1c(a7), a7
    tst.w   d2
    beq.b   .l15ff2
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l15ff2
.l15fde:
    pea     ($0003).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   .l15ed2
.l15ff2:
    clr.w   d2
    addq.w  #$1, -$7c(a6)
    cmpi.w  #$1, -$7c(a6)
    bne.b   .l16070
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($0098).w
    pea     ($0039).w
    pea     ($0772).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0773).w
    jsr TilePlacement
    lea     $1c(a7), a7
.l1605e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.b   .l16096
.l16070:
    cmpi.w  #$f, -$7c(a6)
    bne.b   .l1608a
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    addq.l  #$8, a7
    bra.b   .l1605e
.l1608a:
    cmpi.w  #$1e, -$7c(a6)
    bne.b   .l16096
    clr.w   -$7c(a6)
.l16096:
    move.w  -$2(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, -$2(a6)
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.b   .l160d2
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l1612a
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l161d6
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l162f2
    bra.w   .l1637c
.l160d2:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.b  d3, $3(a4)
    move.b  -$79(a6), d0
    add.b   d3, d0
    moveq   #$0,d1
    move.b  (a4), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    move.b  d7, d0
    add.b   d3, d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    lsl.w   #$3, d1
    movea.l d7, a0
    move.w  $a(a6), d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBA81,a0
    move.b  d0, (a0,d1.w)
    bra.w   .l1638c
.l1612a:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a4), d1
    cmp.l   d1, d0
    beq.w   .l1638c
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a4, -(a7)
    jsr ShowRelationResult
    pea     ($0008).w
    pea     ($0005).w
    jsr SetTextCursor
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F860).l
    jsr PrintfNarrow
    pea     ($0008).w
    pea     ($0015).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F85C).l
    jsr PrintfNarrow
    pea     ($000F).w
    pea     ($001B).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F858).l
    jsr PrintfWide
    lea     $18(a7), a7
    bra.w   .l1638c
.l161d6:
    move.w  #$1, ($00FF13FC).l
    subq.w  #$1, d3
    cmpi.w  #$1, d3
    ble.b   .l161ec
    move.w  d3, d0
    ext.l   d0
    bra.b   .l161ee
.l161ec:
    moveq   #$1,d0
.l161ee:
    move.w  d0, d3
    cmpi.w  #$1, d4
    ble.b   .l1620a
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8000, -$40(a6, d0.w)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8543, -$78(a6, d0.w)
.l1620a:
    cmpi.w  #$7, d3
    bne.b   .l1623a
    pea     ($033E).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l1623a:
    cmpi.w  #$7, d3
    ble.b   .l16280
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    pea     ($033E).w
    pea     ($0001).w
    move.w  d4, d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    subq.l  #$7, d0
    move.l  d0, -(a7)
    pea     ($0010).w
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
.l16280:
    cmpi.w  #$7, d3
    bge.b   .l1628c
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1628e
.l1628c:
    moveq   #$7,d0
.l1628e:
    move.w  d0, (a5)
    cmpi.w  #$7, (a5)
    bge.w   .l15fde
    cmpi.w  #$7, d4
    bge.b   .l162a4
    move.w  d4, d0
    ext.l   d0
    bra.b   .l162a6
.l162a4:
    moveq   #$7,d0
.l162a6:
    move.w  d0, -$8(a6)
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    ble.w   .l15fde
    pea     ($033E).w
    pea     ($0001).w
    move.w  -$8(a6), d0
    ext.l   d0
    move.w  (a5), d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($000F).w
    move.w  (a5), d0
    ext.l   d0
    addi.l  #$14, d0
    move.l  d0, -(a7)
.l162dc:
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    bra.w   .l15fde
.l162f2:
    move.w  #$1, ($00FF13FC).l
    addq.w  #$1, d3
    cmp.w   d4, d3
    bge.b   .l16304
    move.w  d3, d0
    bra.b   .l16306
.l16304:
    move.w  d4, d0
.l16306:
    ext.l   d0
    move.w  d0, d3
    add.w   d0, d0
    move.w  #$8541, -$42(a6, d0.w)
    move.w  d3, d0
    add.w   d0, d0
    move.w  #$8542, -$7a(a6, d0.w)
    cmpi.w  #$7, d3
    bge.b   .l16328
    move.w  d3, d0
    ext.l   d0
    bra.b   .l1632a
.l16328:
    moveq   #$7,d0
.l1632a:
    move.w  d0, (a5)
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($000F).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    move.w  d3, d0
    addi.w  #$fff9, d0
    move.w  d0, (a5)
    tst.w   (a5)
    ble.w   .l15fde
    pea     ($033D).w
    pea     ($0001).w
    move.w  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0010).w
    pea     ($0014).w
    bra.w   .l162dc
.l1637c:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    bra.w   .l15fde
.l1638c:
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RefreshDisplayArea -- (TODO: name)
; 1158 bytes | $0163E2-$016867
; ============================================================================
RefreshDisplayArea:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    movea.l $c(a6), a2
    movea.l  #$00000D64,a3
    movea.l  #$00FF13FC,a4
    movea.l  #$0003AB2C,a5
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, d4
    pea     ($0064).w
    pea     ($0096).w
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr MulDiv
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1
    jsr SignedDiv
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d3
    beq.b   .l16474
    cmpi.w  #$3, d3
    bge.b   .l1646e
    sub.w   d3, d2
    bra.b   .l16474
.l1646e:
    moveq   #$5,d0
    sub.w   d3, d0
    add.w   d0, d2
.l16474:
    pea     ($0004).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    jsr DrawBox
    lea     $24(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   .l164b4
    moveq   #$1,d0
    bra.b   .l164b6
.l164b4:
    moveq   #$0,d0
.l164b6:
    move.w  d0, -$2(a6)
    clr.w   d6
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    moveq   #-$1,d5
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)
    lea     $20(a7), a7
    move.w  $4(a2), d0
    move.w  d0, d3
    ext.l   d0
.l164f2:
    tst.w   d2
    ble.b   .l164fc
    move.w  d2, d0
    ext.l   d0
    bra.b   .l164fe
.l164fc:
    moveq   #$0,d0
.l164fe:
    move.w  d0, d2
    cmpi.w  #$64, d2
    bge.b   .l1650c
    move.w  d2, d0
    ext.l   d0
    bra.b   .l1650e
.l1650c:
    moveq   #$64,d0
.l1650e:
    move.w  d0, d2
    cmp.w   d5, d2
    beq.w   .l16600
    pea     ($0013).w
    pea     ($000F).w
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    beq.b   .l1656c
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    bge.b   .l16558
    move.w  d2, d0
    ext.l   d0
    neg.l   d0
    addi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F8AE).l
.l1654e:
    jsr PrintfWide
    addq.l  #$8, a7
    bra.b   .l1657a
.l16558:
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F89C).l
    bra.b   .l1654e
.l1656c:
    pea     ($0003F88C).l
    jsr PrintfWide
    addq.l  #$4, a7
.l1657a:
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F886).l
    jsr PrintfNarrow
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F880).l
    jsr PrintfNarrow
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l165e6
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l165e8
.l165e6:
    moveq   #$1,d0
.l165e8:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCityChange,PC)
    nop
    lea     $28(a7), a7
    move.w  d2, d5
.l16600:
    tst.w   -$2(a6)
    beq.b   .l16616
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l164f2
.l16616:
    clr.w   -$2(a6)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$3c, d0
    move.w  d0, d6
    ext.l   d0
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   .l167c6
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.b   .l16654
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.w   .l1673a
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.w   .l16788
    bra.w   .l167ba
.l16654:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d3, d0
    ext.l   d0
    moveq   #$0,d1
    move.w  $4(a2), d1
    cmp.l   d1, d0
    beq.w   .l167d2
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d4, d1
    ext.l   d1
    jsr SignedDiv
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    jsr SignedMod
    move.w  d0, d3
    beq.b   .l166b0
    cmpi.w  #$3, d3
    bge.b   .l166aa
    sub.w   d3, d2
    bra.b   .l166b0
.l166aa:
    moveq   #$5,d0
    sub.w   d3, d0
    add.w   d0, d2
.l166b0:
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l166de
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    bra.b   .l166e0
.l166de:
    moveq   #$1,d0
.l166e0:
    move.w  d0, d5
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCityChange,PC)
    nop
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F87A).l
    jsr PrintfNarrow
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F874).l
    jsr PrintfNarrow
    lea     $28(a7), a7
    bra.w   .l167d2
.l1673a:
    move.w  #$1, (a4)
    subq.w  #$5, d2
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   d4, d0
    move.w  d0, d3
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16768
    addq.l  #$1, d0
.l16768:
    asr.l   #$1, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l16778
.l16772:
    move.w  d3, d0
.l16774:
    ext.l   d0
    bra.b   .l16782
.l16778:
    move.w  d4, d0
    ext.l   d0
    bge.b   .l16780
    addq.l  #$1, d0
.l16780:
    asr.l   #$1, d0
.l16782:
    move.w  d0, d3
    bra.w   .l164f2
.l16788:
    move.w  #$1, (a4)
    addq.w  #$5, d2
    move.w  d4, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    subi.l  #$32, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    add.w   d4, d0
    move.w  d0, d3
    cmp.w   -$4(a6), d3
    blt.b   .l16772
    move.w  -$4(a6), d0
    bra.b   .l16774
.l167ba:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    bra.w   .l164f2
.l167c6:
    clr.w   (a4)
    clr.w   ($00FFA7D8).l
    move.w  d3, $4(a2)
.l167d2:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A26).l
    pea     ($0020).w
    pea     ($0002).w
    pea     ($0039).w
    pea     ($000B).w
    jsr     (a3)
    pea     ($0002).w
    pea     ($0039).w
    pea     ($0010).w
    jsr     (a3)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $2c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ProcessCityChange -- (TODO: name)
; 240 bytes | $016868-$016957
; ============================================================================
ProcessCityChange:
    link    a6,#-$18
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d4
    lea     -$16(a6), a2
    movea.l  #$00000D64,a3
    cmpi.w  #$a, d3
    bge.b   .l1688e
    move.w  d3, d0
    ext.l   d0
    bra.b   .l16890
.l1688e:
    moveq   #$A,d0
.l16890:
    move.w  d0, d3
    cmpi.w  #$1, d4
    bge.b   .l1689e
    move.w  d4, d0
    ext.l   d0
    bra.b   .l168a0
.l1689e:
    moveq   #$1,d0
.l168a0:
    move.w  d0, d4
    clr.w   d2
    bra.b   .l168b6
.l168a6:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33a, (a2,a0.l)
    addq.w  #$1, d2
.l168b6:
    moveq   #$0,d0
    move.w  d2, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    blt.b   .l168a6
    bra.b   .l168d4
.l168c4:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33b, (a2,a0.l)
    addq.w  #$1, d2
.l168d4:
    move.w  d3, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   .l168c4
    bra.b   .l168f8
.l168e8:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$33c, (a2,a0.l)
    addq.w  #$1, d2
.l168f8:
    cmpi.w  #$a, d2
    bcs.b   .l168e8
    move.l  a2, -(a7)
    pea     ($0001).w
    pea     ($000A).w
    pea     ($000E).w
    pea     ($0014).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    move.l  a2, -(a7)
    pea     ($0001).w
    pea     ($000A).w
    pea     ($0014).w
    pea     ($0003).w
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$2c(a6), d2-d4/a2-a3
    unlk    a6
    rts

; ============================================================================
; RunAssignmentUI -- (TODO: describe)
; Called: ?? times.
; 1524 bytes | $016958-$016F4B
; ============================================================================
RunAssignmentUI:                                                  ; $016958
    link    a6,#-$1c
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d4
    lea     -$0006(a6),a3
    movea.l #$0d64,a4
    lea     -$0008(a6),a5
    move.l  #$8000,-(sp)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C976).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0028(sp),sp
    pea     ($0004CD56).l
    pea     ($000D).w
    pea     ($0020).w
    pea     ($000F).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a4)
    lea     $001c(sp),sp
    clr.w   d2
.l169ca:                                                ; $0169CA
    move.w  d2,d0
    ext.l   d0
    addi.l  #$0774,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0007).w
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l169ca
    pea     ($0010).w
    pea     ($0030).w
    pea     ($00076A5E).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B08).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($006B).w
    pea     ($010F).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    lea     $0020(sp),sp
    pea     ($00071A64).l
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001B).w
    jsr     (a4)
    moveq   #$7,d7
    clr.b   -$001a(a6)
    lea     -$001a(a6),a2
    clr.w   d5
    move.w  #$16,(a3)
    move.w  #$3,(a5)
    moveq   #$17,d3
    moveq   #$12,d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0030(sp),sp
    tst.w   d0
    beq.b   .l16aa6
    moveq   #$1,d0
    bra.b   .l16aa8
.l16aa6:                                                ; $016AA6
    moveq   #$0,d0
.l16aa8:                                                ; $016AA8
    move.w  d0,-$0002(a6)
    clr.w   -$0004(a6)
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    clr.w   d6
.l16abe:                                                ; $016ABE
    cmpi.w  #$17,d3
    blt.b   .l16ae2
    cmpi.w  #$12,d2
    bne.b   .l16ae2
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($00B6).w
    pea     ($00CB).w
    bra.b   .l16b16
.l16ae2:                                                ; $016AE2
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    move.w  d2,d1
    ext.l   d1
    lsl.l   #$3,d1
    add.l   d1,d0
    subi.l  #$ae,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$3,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
.l16b16:                                                ; $016B16
    clr.l   -(sp)
    pea     ($0740).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    moveq   #$1,d0
    eor.w   d0,d6
    cmp.w   d7,d5
    bge.b   .l16b62
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0088).w
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$3,d0
    addi.l  #$b0,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0770).w
    bra.b   .l16b76
.l16b62:                                                ; $016B62
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    clr.l   -(sp)
.l16b76:                                                ; $016B76
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $0024(sp),sp
    tst.w   -$0002(a6)
    beq.b   .l16bae
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l16bae
    pea     ($0003).w
.l16ba2:                                                ; $016BA2
    pea     ($000E).w
    jsr     (a4)
.l16ba8:                                                ; $016BA8
    addq.l  #$8,sp
    bra.w   .l16abe
.l16bae:                                                ; $016BAE
    clr.w   -$0002(a6)
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a4)
    move.w  -$0004(a6),d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    lea     $0010(sp),sp
    andi.w  #$3f,d0
    move.w  d0,-$0004(a6)
    andi.w  #$30,d0
    beq.w   .l16cba
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    move.w  -$0004(a6),d0
    andi.w  #$20,d0
    beq.b   .l16c6e
    cmpi.w  #$17,d3
    blt.b   .l16c04
    cmpi.w  #$12,d2
    beq.w   .l16e66
.l16c04:                                                ; $016C04
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    move.b  (a0,d0.w),-$0009(a6)
    cmpi.b  #$2d,-$0009(a6)
    bne.b   .l16c26
    move.b  #$20,-$0009(a6)
.l16c26:                                                ; $016C26
    cmp.w   d7,d5
    bge.w   .l16abe
    addq.w  #$1,d5
    move.b  -$0009(a6),(a2)+
    clr.b   (a2)
    pea     ($000F).w
    pea     ($0016).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    pea     -$001a(a6)
    pea     ($0003F948).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0010(sp),sp
    cmp.w   d7,d5
    bne.b   .l16c66
    moveq   #$17,d3
    moveq   #$12,d2
    move.w  #$16,(a3)
    move.w  #$3,(a5)
.l16c66:                                                ; $016C66
    pea     ($0006).w
    bra.w   .l16ba2
.l16c6e:                                                ; $016C6E
    tst.w   d5
    ble.w   .l16abe
    subq.l  #$1,a2
    clr.b   (a2)
    subq.w  #$1,d5
    clr.l   -(sp)
    pea     ($0003).w
    pea     ($0008).w
    pea     ($000F).w
    pea     ($0016).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($0016).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    lea     $0024(sp),sp
    pea     -$001a(a6)
    pea     ($0003F944).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    bra.w   .l16ba8
.l16cba:                                                ; $016CBA
    move.w  #$1,($00FF13FC).l
    move.w  -$0004(a6),d0
    andi.w  #$2,d0
    beq.b   .l16d14
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$3,d1
    cmp.l   d0,d1
    ble.b   .l16ce0
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16ce2
.l16ce0:                                                ; $016CE0
    moveq   #$3,d0
.l16ce2:                                                ; $016CE2
    move.w  d0,(a5)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$12,d1
    cmp.l   d0,d1
    ble.b   .l16cf8
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16cfa
.l16cf8:                                                ; $016CF8
    moveq   #$12,d0
.l16cfa:                                                ; $016CFA
    move.w  d0,d2
    cmpi.w  #$12,d2
    bne.b   .l16d14
    cmpi.w  #$18,d3
    beq.b   .l16d0e
    cmpi.w  #$19,d3
    bne.b   .l16d14
.l16d0e:                                                ; $016D0E
    moveq   #$17,d3
    move.w  #$16,(a3)
.l16d14:                                                ; $016D14
    move.w  -$0004(a6),d0
    andi.w  #$1,d0
    beq.b   .l16d56
    cmpi.w  #$15,d3
    blt.b   .l16d2a
    cmpi.w  #$11,d2
    ble.b   .l16d56
.l16d2a:                                                ; $016D2A
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0
    ble.b   .l16d3a
    move.w  (a5),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d3c
.l16d3a:                                                ; $016D3A
    moveq   #$0,d0
.l16d3c:                                                ; $016D3C
    move.w  d0,(a5)
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$f,d1
    cmp.l   d0,d1
    bge.b   .l16d52
    move.w  d2,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16d54
.l16d52:                                                ; $016D52
    moveq   #$f,d0
.l16d54:                                                ; $016D54
    move.w  d0,d2
.l16d56:                                                ; $016D56
    move.w  -$0004(a6),d0
    andi.w  #$8,d0
    beq.w   .l16e10
    cmpi.w  #$11,d2
    bge.b   .l16d70
    cmpi.w  #$14,d3
    bge.w   .l16e10
.l16d70:                                                ; $016D70
    cmpi.w  #$11,d2
    bne.b   .l16da2
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$18,d1
    cmp.l   d0,d1
    ble.b   .l16d8a
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16d8c
.l16d8a:                                                ; $016D8A
    moveq   #$18,d0
.l16d8c:                                                ; $016D8C
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$19,d1
    cmp.l   d0,d1
    ble.b   .l16df4
.l16d9a:                                                ; $016D9A
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16df6
.l16da2:                                                ; $016DA2
    cmpi.w  #$12,d2
    bne.b   .l16dd0
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$16,d1
    cmp.l   d0,d1
    ble.b   .l16dbc
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16dbe
.l16dbc:                                                ; $016DBC
    moveq   #$16,d0
.l16dbe:                                                ; $016DBE
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$17,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a
    moveq   #$17,d0
    bra.b   .l16df6
.l16dd0:                                                ; $016DD0
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$1a,d1
    cmp.l   d0,d1
    ble.b   .l16de4
    move.w  (a3),d0
    ext.l   d0
    addq.l  #$1,d0
    bra.b   .l16de6
.l16de4:                                                ; $016DE4
    moveq   #$1a,d0
.l16de6:                                                ; $016DE6
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$19,d1
    cmp.l   d0,d1
    bgt.b   .l16d9a
.l16df4:                                                ; $016DF4
    moveq   #$19,d0
.l16df6:                                                ; $016DF6
    move.w  d0,d3
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    cmpi.b  #$20,(a0,d0.w)
    beq.w   .l16d70
.l16e10:                                                ; $016E10
    move.w  -$0004(a6),d0
    andi.w  #$4,d0
    beq.w   .l16abe
.l16e1c:                                                ; $016E1C
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l16e30
    move.w  (a3),d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e32
.l16e30:                                                ; $016E30
    moveq   #$1,d0
.l16e32:                                                ; $016E32
    move.w  d0,(a3)
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0
    moveq   #$2,d1
    cmp.l   d0,d1
    bge.b   .l16e48
    move.w  d3,d0
    ext.l   d0
    subq.l  #$1,d0
    bra.b   .l16e4a
.l16e48:                                                ; $016E48
    moveq   #$2,d0
.l16e4a:                                                ; $016E4A
    move.w  d0,d3
    move.w  (a5),d0
    mulu.w  #$1c,d0
    add.w   (a3),d0
    movea.l #$00047a9c,a0
    cmpi.b  #$20,(a0,d0.w)
    beq.b   .l16e1c
    bra.w   .l16abe
.l16e66:                                                ; $016E66
    tst.w   d5
    beq.b   .l16e9e
    clr.w   d2
    clr.w   d3
    bra.b   .l16e7c
.l16e70:                                                ; $016E70
    cmpi.b  #$20,-$1a(a6,d3.w)
    beq.b   .l16e7a
    addq.w  #$1,d2
.l16e7a:                                                ; $016E7A
    addq.w  #$1,d3
.l16e7c:                                                ; $016E7C
    cmp.w   d5,d3
    blt.b   .l16e70
    tst.w   d2
    beq.b   .l16e9e
    pea     -$001a(a6)
    move.w  d4,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    addq.l  #$8,sp
.l16e9e:                                                ; $016E9E
    pea     ($0002).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    clr.l   -(sp)
    pea     ($000B).w
    pea     ($0020).w
    pea     ($000E).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    lea     $0024(sp),sp
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    clr.w   d4
.l16ede:                                                ; $016EDE
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0007).w
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a4)
    move.w  d4,d0
    ext.l   d0
    add.l   d0,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d4,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0028(sp),sp
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l16ede
    movem.l -$0044(a6),d2-d7/a2-a5
    unlk    a6
    rts
    movem.l d2-d4,-(sp)
    move.l  $0018(sp),d4
    clr.w   d3
    clr.b   d2
    tst.w   $0016(sp)
    dc.w    $6F08,$206F                                          ; $016F4C
; === Translated block $016F50-$016F9E ===
; 1 functions, 78 bytes

; ============================================================================
; UpdateCityStatus -- (TODO: name)
; 78 bytes | $016F50-$016F9D
; ============================================================================
UpdateCityStatus:
    dc.w    $0010,$1428                     ; ori.b #$28,(a0) - high byte $14 is compiler junk
    dc.w    $FFFF
    moveq   #$0,d0
    move.b  d4, d0
    moveq   #-$22,d1
    cmp.l   d0, d1
    bne.b   l_16f76
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$4A,d1
    cmp.l   d0, d1
    bgt.b   l_16f80
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$3C,d1
    cmp.l   d0, d1
    bge.b   l_16f94
    bra.b   l_16f80
l_16f76:
    moveq   #$0,d0
    move.b  d4, d0
    moveq   #-$21,d1
    cmp.l   d0, d1
    bne.b   l_16f94
l_16f80:
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$36,d1
    cmp.l   d0, d1
    bgt.b   l_16f96
    moveq   #$0,d0
    move.b  d2, d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    blt.b   l_16f96
l_16f94:
    moveq   #$1,d3
l_16f96:
    move.w  d3, d0
    movem.l (a7)+, d2-d4
    rts

RunGameMenu:                                                  ; $016F9E
    movem.l d2-d4/a2-a5,-(sp)
    movea.l #$0001725a,a2
    movea.l #$00ffa792,a3
    movea.l #$00017c9e,a4
    movea.l #$0d64,a5
    moveq   #$0,d0
    move.b  ($00FF0016).l,d0
    move.w  d0,(a3)
    dc.w    $4eb9,$0001,$d71c                           ; jsr $01D71C
    dc.w    $4eb9,$0001,$e398                           ; jsr $01E398
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0004C976).l
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004C996).l
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a5)
    pea     ($0004D096).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    pea     ($0004).w
    pea     ($003B).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $0018(sp),sp
    moveq   #$4,d4
    clr.w   d3
    clr.w   ($00FF1296).l
    dc.w    $6000,$00dc                                 ; bra.w $017160
    clr.l   -(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($00047A5E).l
    move.w  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7912                           ; jsr $007912
    pea     ($0005).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$02bc                                 ; jsr $017366
    nop
    lea     $001c(sp),sp
    move.w  d0,d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    dc.w    $6700,$00b0                                 ; beq.w $01716C
    cmpi.w  #$ff,d2
    beq.b   .l170ca
    move.w  d2,d4
    add.w   d4,d4
    addq.w  #$4,d4
.l170ca:                                                ; $0170CA
    move.w  d2,d0
    ext.l   d0
    moveq   #$4,d1
    cmp.l   d1,d0
    dc.w    $6200,$0092                                 ; bhi.w $017166
    add.l   d0,d0
    move.w  $170e0(pc,d0.l),d0
    jmp     $170e0(pc,d0.w)
    ; WARNING: 212 undecoded trailing bytes at $0170E0
    dc.w    $000a
    dc.w    $002e
    dc.w    $0036
    dc.w    $0054
    dc.w    $0072
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $039a
    dc.w    $4e71
    dc.w    $6052
    dc.w    $4eba
    dc.w    $070c
    dc.w    $4e71
    dc.w    $6050
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $0086
    dc.w    $4e71
    dc.w    $602c
    dc.w    $4878
    dc.w    $0010
    dc.w    $4878
    dc.w    $0018
    dc.w    $4878
    dc.w    $0001
    dc.w    $4878
    dc.w    $0005
    dc.w    $4e94
    dc.w    $4fef
    dc.w    $0010
    dc.w    $4eba
    dc.w    $07ba
    dc.w    $4e71
    dc.w    $600e
    dc.w    $4eba
    dc.w    $0a16
    dc.w    $4e71
    dc.w    $0c40
    dc.w    $0001
    dc.w    $6602
    dc.w    $7601
    dc.w    $42a7
    dc.w    $4e92
    dc.w    $588f
    dc.w    $4a43
    dc.w    $6700
    dc.w    $ff1c
    dc.w    $4eb9
    dc.w    $0001
    dc.w    $d71c
    dc.w    $42a7
    dc.w    $3039
    dc.w    $00ff
    dc.w    $9a1c
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3013
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6a2e
    dc.w    $4878
    dc.w    $0002
    dc.w    $3039
    dc.w    $00ff
    dc.w    $9a1c
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $3013
    dc.w    $48c0
    dc.w    $2f00
    dc.w    $4eb9
    dc.w    $0000
    dc.w    $6b78
    dc.w    $4fef
    dc.w    $0018
    dc.w    $3039
    dc.w    $00ff
    dc.w    $1296
    dc.w    $4cdf
    dc.w    $3c1c
    dc.w    $4e75
; === Translated block $0171B4-$017566 ===
; 4 functions, 946 bytes

; ============================================================================
; CalcCityMetrics -- (TODO: name)
; 166 bytes | $0171B4-$017259
; ============================================================================
CalcCityMetrics:
    movem.l d2-d4, -(a7)
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    jsr (ResolveCityConflict,PC)
    nop
    addq.l  #$8, a7
    moveq   #$4,d3
    clr.w   d4
l_171d0:
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00047A5E).l
    move.w  ($00FFA792).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ScanCitySlots,PC)
    nop
    lea     $1c(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_1723a
    cmpi.w  #$ff, d2
    beq.b   l_17216
    move.w  d2, d3
    add.w   d3, d3
    addq.w  #$4, d3
l_17216:
    move.w  d2, d0
    ext.l   d0
    tst.w   d0
    beq.b   l_17226
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.b   l_1722c
    bra.b   l_17236
l_17226:
    pea     ($0001).w
    bra.b   l_1722e
l_1722c:
    clr.l   -(a7)
l_1722e:
    jsr (NavigateCharList,PC)
    nop
    addq.l  #$4, a7
l_17236:
    tst.w   d4
    beq.b   l_171d0
l_1723a:
    pea     ($0008).w
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0005).w
    jsr (RecordEventOutcome,PC)
    nop
    lea     $10(a7), a7
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; ResolveCityConflict -- (TODO: name)
; 268 bytes | $01725A-$017365
; ============================================================================
ResolveCityConflict:
    movem.l d2-d4/a2-a4, -(a7)
    move.l  $1c(a7), d3
    movea.l  #$0003B270,a2
    movea.l  #$0003AB2C,a3
    movea.l  #$00047A78,a4
    pea     ($008F).w
    tst.w   d3
    bne.b   l_17280
    moveq   #$C,d0
    bra.b   l_17282
l_17280:
    moveq   #$8,d0
l_17282:
    move.l  d0, -(a7)
    pea     ($0018).w
    pea     ($0003).w
    pea     ($0005).w
    jsr (GenerateEventResult,PC)
    nop
    pea     ($0004).w
    pea     ($0008).w
    jsr     (a3)
    lea     $1c(a7), a7
    tst.w   d3
    bne.b   l_172ac
    moveq   #$5,d4
    bra.b   l_172ae
l_172ac:
    moveq   #$2,d4
l_172ae:
    clr.w   d2
    bra.b   l_172dc
l_172b2:
    move.w  #$8, ($00FF128A).l
    move.w  d3, d0
    mulu.w  #$14, d0
    move.w  d2, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00047A36,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F94C).l
    jsr     (a2)
    addq.l  #$8, a7
    addq.w  #$1, d2
l_172dc:
    cmp.w   d4, d2
    blt.b   l_172b2
    tst.w   d3
    bne.b   l_17322
    pea     ($0006).w
    pea     ($0014).w
    jsr     (a3)
    move.w  ($00FF000A).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    jsr     (a2)
    pea     ($000A).w
    pea     ($0014).w
    jsr     (a3)
    lea     $14(a7), a7
    move.w  ($00FF0008).l, d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    bra.b   l_1735c
l_17322:
    pea     ($0004).w
    pea     ($0014).w
    jsr     (a3)
    move.w  ($00FF000C).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
    jsr     (a2)
    pea     ($0006).w
    pea     ($0014).w
    jsr     (a3)
    lea     $14(a7), a7
    move.w  ($00FF000E).l, d0
    ext.l   d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a4,a0.l), -(a7)
l_1735c:
    jsr     (a2)
    addq.l  #$4, a7
    movem.l (a7)+, d2-d4/a2-a4
    rts

; ============================================================================
; ScanCitySlots -- (TODO: name)
; 316 bytes | $017366-$0174A1
; ============================================================================
ScanCitySlots:
    movem.l d2-d5/a2-a3, -(a7)
    move.l  $1c(a7), d2
    move.l  $20(a7), d5
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $14(a7), a7
    tst.w   d0
    beq.b   l_173a4
    moveq   #$1,d3
    bra.b   l_173a6
l_173a4:
    moveq   #$0,d3
l_173a6:
    clr.w   d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_173b0:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0038).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d3
    beq.b   l_17404
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_17404
    pea     ($0003).w
l_173fa:
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_173b0
l_17404:
    clr.w   d3
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d4
    andi.w  #$30, d0
    beq.b   l_17442
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_17488
    move.w  d2, d0
    ext.l   d0
    subq.l  #$4, d0
    bge.b   l_1743c
    addq.l  #$1, d0
l_1743c:
    asr.l   #$1, d0
    move.w  d0, d2
    bra.b   l_1748a
l_17442:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_1745e
    move.w  #$1, (a3)
    cmpi.w  #$4, d2
    bne.b   l_1745a
    move.w  d5, d2
    add.w   d2, d2
    bra.b   l_1747e
l_1745a:
    subq.w  #$2, d2
    bra.b   l_17480
l_1745e:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.b   l_17480
    move.w  #$1, (a3)
    move.w  d2, d0
    ext.l   d0
    move.w  d5, d1
    ext.l   d1
    add.l   d1, d1
    addq.l  #$2, d1
    cmp.l   d1, d0
    bne.b   l_1747e
    moveq   #$4,d2
    bra.b   l_17480
l_1747e:
    addq.w  #$2, d2
l_17480:
    pea     ($0005).w
    bra.w   l_173fa
l_17488:
    moveq   #-$1,d2
l_1748a:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $c(a7), a7
    move.w  d2, d0
    movem.l (a7)+, d2-d5/a2-a3
    rts

; ============================================================================
; ProcessCharSelectInput -- (TODO: name)
; 196 bytes | $0174A2-$017565
; ============================================================================
ProcessCharSelectInput:
    movem.l d2/a2, -(a7)
    movea.l  #$00000D64,a2
    clr.l   -(a7)
    jsr CmdSetBackground
    jsr (DrawDualPanels,PC)
    nop
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0001).w
    jsr (BrowseMapPages,PC)
    nop
    lea     $18(a7), a7
    move.w  d0, d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_17548
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PackSaveState
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (SignExtendAndCall,PC)
    nop
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0018).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $24(a7), a7
    pea     ($0002).w
    pea     ($001E).w
    pea     ($0018).w
    pea     ($0002).w
    jsr SetTextWindow
    pea     ($0003F950).l
    jsr PrintfWide
    pea     ($003C).w
    pea     ($000E).w
    jsr     (a2)
    lea     $1c(a7), a7
l_17548:
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    lea     $10(a7), a7
    movem.l (a7)+, d2/a2
    rts

BrowseMapPages:                                                  ; $017566
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d6
    movea.l #$0d64,a2
    movea.l #$00ff13fc,a3
    movea.l #$0001e044,a4
    movea.l #$0004c974,a5
    pea     ($0010).w
    pea     ($0010).w
    move.l  a5,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    move.l  a5,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($001C).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a2)
    move.l  a5,d0
    addi.l  #$0722,d0
    move.l  d0,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0030(sp),sp
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0104).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    dc.w    $4eb9,$0001,$d748                           ; jsr $01D748
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l17618
    moveq   #$1,d4
    bra.b   .l1761a
.l17618:                                                ; $017618
    moveq   #$0,d4
.l1761a:                                                ; $01761A
    clr.w   d5
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   d3
.l17626:                                                ; $017626
    move.w  d3,d2
    ext.l   d2
    move.l  d2,d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d2
    addq.l  #$3,d2
    move.l  d2,-(sp)
    pea     ($0002).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0544).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $002c(sp),sp
    tst.w   d4
    beq.b   .l17692
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l17692
    pea     ($0003).w
.l17688:                                                ; $017688
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l17626
.l17692:                                                ; $017692
    clr.w   d4
    move.w  d5,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d5
    andi.w  #$30,d0
    beq.w   .l1774a
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d5,d0
    andi.w  #$20,d0
    beq.w   .l17746
    tst.w   d6
    bne.b   .l176da
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$f552                           ; jsr $00F552
    addq.l  #$4,sp
    tst.w   d0
    beq.w   .l177a4
.l176da:                                                ; $0176DA
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d3,d0
    ext.l   d0
    moveq   #$b,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    addq.l  #$3,d0
    move.l  d0,d2
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0546).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0002).w
    pea     ($0001).w
    move.l  d2,d0
    lsl.l   #$3,d0
    move.l  d0,-(sp)
    pea     ($0010).w
    clr.l   -(sp)
    pea     ($0548).w
    jsr     (a4)
    pea     ($000F).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    bra.b   .l177ac
.l17746:                                                ; $017746
    moveq   #-$1,d0
    bra.b   .l177be
.l1774a:                                                ; $01774A
    move.w  d5,d0
    andi.w  #$1,d0
    beq.b   .l17778
    move.w  #$1,(a3)
    clr.w   d3
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($000E).w
    pea     ($0002).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    bra.b   .l177a4
.l17778:                                                ; $017778
    move.w  d5,d0
    andi.w  #$2,d0
    beq.b   .l177a4
    move.w  #$1,(a3)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($0003).w
    pea     ($0002).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    moveq   #$1,d3
.l177a4:                                                ; $0177A4
    pea     ($0005).w
    bra.w   .l17688
.l177ac:                                                ; $0177AC
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a2)
    lea     $000c(sp),sp
    move.w  d3,d0
.l177be:                                                ; $0177BE
    movem.l (sp)+,d2-d6/a2-a5
    rts
; ============================================================================
; DrawDualPanels -- (TODO: describe)
; Called: ?? times.
; 68 bytes | $0177C4-$017807
; ============================================================================
DrawDualPanels:                                                  ; $0177C4
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0002).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$f104                           ; jsr $00F104
    pea     ($000A).w
    pea     ($001E).w
    pea     ($000D).w
    pea     ($0001).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     ($0001).w
    dc.w    $4eb9,$0000,$f104                           ; jsr $00F104
    lea     $0028(sp),sp
    rts
; === Translated block $017808-$017CE6 ===
; 8 functions, 1246 bytes

; ============================================================================
; SignExtendAndCall -- (TODO: name)
; 20 bytes | $017808-$01781B
; ============================================================================
SignExtendAndCall:
    move.l  $4(a7), d1
    move.w  d1, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRouteInfo
    addq.l  #$4, a7
    rts

; ============================================================================
; ToggleDisplayMode -- (TODO: name)
; 60 bytes | $01781C-$017857
; ============================================================================
ToggleDisplayMode:
    moveq   #$1,d0
    eor.w   d0, ($00FF000A).l
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0006).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  ($00FF000A).l, d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    lea     $14(a7), a7
    rts

; ============================================================================
; NavigateCharList -- (TODO: name)
; 174 bytes | $017858-$017905
; ============================================================================
NavigateCharList:
    movem.l d2/a2-a3, -(a7)
    move.l  $10(a7), d2
    movea.l  #$00FF000C,a2
    movea.l  #$00FF000E,a3
    cmpi.w  #$1, d2
    bne.b   l_178c4
    moveq   #$1,d0
    eor.w   d0, (a2)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0004).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  (a2), d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    move.w  (a2), d0
    move.l  d0, -(a7)
    jsr SetDisplayMode
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    addq.w  #$2, d0
    move.l  d0, -(a7)
    jsr MenuSelectEntry
    lea     $20(a7), a7
    bra.b   l_17900
l_178c4:
    moveq   #$1,d0
    eor.w   d0, (a3)
    pea     ($0002).w
    pea     ($0004).w
    pea     ($0006).w
    pea     ($0014).w
    jsr SetTextWindow
    move.w  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$00047A78,a0
    move.l  (a0,d0.w), -(a7)
    jsr PrintfWide
    move.w  (a3), d0
    move.l  d0, -(a7)
    jsr SetDisplayPage
    lea     $18(a7), a7
l_17900:
    movem.l (a7)+, d2/a2-a3
    rts

; ============================================================================
; HandleCharListAction -- (TODO: name)
; 516 bytes | $017906-$017B09
; ============================================================================
HandleCharListAction:
    link    a6,#-$80
    movem.l d2-d4/a2-a4, -(a7)
    movea.l  #$00000D64,a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00FF0008,a4
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($008F).w
    pea     ($0008).w
    pea     ($000C).w
    pea     ($0004).w
    pea     ($000A).w
    jsr (GenerateEventResult,PC)
    nop
    jsr (ProcessEventSequence,PC)
    nop
    move.w  (a4), d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F960).l
    pea     -$80(a6)
    jsr sprintf
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$80(a6)
    move.w  ($00FFA792).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    move.w  (a4), d2
    add.w   d2, d2
    addq.w  #$5, d2
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    lea     $30(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    clr.l   -(a7)
    jsr ReadInput
    lea     $1c(a7), a7
    tst.w   d0
    beq.b   l_179e4
    moveq   #$1,d3
    bra.b   l_179e6
l_179e4:
    moveq   #$0,d3
l_179e6:
    clr.w   d4
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
l_179f0:
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0001).w
    pea     ($0005).w
    pea     ($000A).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    pea     ($0050).w
    clr.l   -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $24(a7), a7
    tst.w   d3
    beq.b   l_17a62
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_17a62
l_17a54:
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_179f0
l_17a62:
    clr.w   d3
    move.w  d4, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.w  #$33, d0
    move.w  d0, d4
    andi.w  #$30, d0
    beq.b   l_17ab2
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_17aec
    move.w  d2, d0
    ext.l   d0
    subq.l  #$5, d0
    bge.b   l_17a9a
    addq.l  #$1, d0
l_17a9a:
    asr.l   #$1, d0
    move.w  d0, (a4)
    jsr (ProcessEventSequence,PC)
    nop
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_17aec
l_17ab2:
    move.w  d4, d0
    andi.w  #$1, d0
    beq.b   l_17acc
    move.w  #$1, (a3)
    cmpi.w  #$5, d2
    bne.b   l_17ac8
    moveq   #$9,d2
    bra.b   l_17a54
l_17ac8:
    subq.w  #$2, d2
    bra.b   l_17a54
l_17acc:
    move.w  d4, d0
    andi.w  #$2, d0
    beq.w   l_17a54
    move.w  #$1, (a3)
    cmpi.w  #$9, d2
    bne.b   l_17ae6
    moveq   #$5,d2
    bra.w   l_17a54
l_17ae6:
    addq.w  #$2, d2
    bra.w   l_17a54
l_17aec:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a2)
    clr.l   -(a7)
    jsr CmdSetBackground
    movem.l -$98(a6), d2-d4/a2-a4
    unlk    a6
    rts

; ============================================================================
; ProcessEventSequence -- (TODO: name)
; 96 bytes | $017B0A-$017B69
; ============================================================================
ProcessEventSequence:
    movem.l d2-d3, -(a7)
    pea     ($0006).w
    pea     ($000A).w
    pea     ($0005).w
    pea     ($000B).w
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d2
l_17b2a:
    move.w  d2, d3
    ext.l   d3
    add.l   d3, d3
    addq.l  #$5, d3
    move.l  d3, -(a7)
    pea     ($000C).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00047A88,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0003F9B0).l
    jsr PrintfWide
    lea     $10(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$3, d2
    blt.b   l_17b2a
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; EvaluateEventCond -- (TODO: name)
; 260 bytes | $017B6A-$017C6D
; ============================================================================
EvaluateEventCond:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FFA792,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FF0018,a5
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($00047A94).l, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $14(a7), a7
    move.w  d0, d5
    cmpi.w  #$1, d0
    bne.w   l_17c66
    moveq   #$1,d4
    clr.w   d2
    move.w  (a3), d3
l_17bae:
    cmp.w   d3, d2
    beq.b   l_17bcc
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    cmpi.b  #$1, (a5,a0.l)
    bne.b   l_17bcc
    clr.w   d4
    bra.b   l_17bd4
l_17bcc:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_17bae
l_17bd4:
    cmpi.w  #$1, d4
    bne.b   l_17c2a
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    clr.l   -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    move.l  ($00047A98).l, -(a7)
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowDialog
    lea     $30(a7), a7
    tst.w   d0
    bne.b   l_17c44
    pea     ($000A).w
    pea     ($0013).w
    jsr     (a4)
    clr.l   -(a7)
    jsr GameSetup1
    lea     $c(a7), a7
    bra.b   l_17c60
l_17c2a:
    clr.l   -(a7)
    pea     ($0012).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    lea     $1c(a7), a7
l_17c44:
    move.w  (a3), d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    lea     (a5,d0.l), a0
    movea.l a0, a2
    clr.b   (a2)
    move.w  #$1, ($00FF1296).l
l_17c60:
    subq.w  #$1, ($00FF0A34).l
l_17c66:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2-a5
    rts

; ============================================================================
; GenerateEventResult -- (TODO: name)
; 48 bytes | $017C6E-$017C9D
; ============================================================================
GenerateEventResult:
    link    a6,#-$8
    lea     $e(a6), a1
    lea     $a(a6), a0
    move.w  $16(a6), d0
    move.l  d0, -(a7)
    move.w  $12(a6), d0
    addq.w  #$2, d0
    move.l  d0, -(a7)
    move.w  (a1), d0
    move.l  d0, -(a7)
    move.w  (a0), d0
    addi.w  #$ffff, d0
    move.l  d0, -(a7)
    jsr DrawBox
    unlk    a6
    rts

; ============================================================================
; RecordEventOutcome -- (TODO: name)
; 72 bytes | $017C9E-$017CE5
; ============================================================================
RecordEventOutcome:
    movem.l d2-d4, -(a7)
    move.l  $1c(a7), d2
    move.l  $18(a7), d3
    move.l  $14(a7), d4
    move.l  $10(a7), d1
    clr.l   -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d1, d0
    ext.l   d0
    subq.l  #$1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; UpdateSlotEvents -- (TODO: describe)
; Called: ?? times.
; 134 bytes | $017CE6-$017D6B
; ============================================================================
UpdateSlotEvents:                                                  ; $017CE6
    movem.l d2-d3/a2-a3,-(sp)
    movea.l #$00ff0728,a3
    movea.l #$00ff8824,a2
    clr.w   d2
.l17cf8:                                                ; $017CF8
    tst.b   $0001(a3)
    beq.b   .l17d0c
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0066                                 ; jsr $017D6C
    nop
    addq.l  #$4,sp
.l17d0c:                                                ; $017D0C
    tst.b   $0001(a3)
    bne.b   .l17d5a
    cmpi.b  #$ff,(a2)
    bcc.b   .l17d5a
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.l   #$2,d0
    moveq   #$41,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.b  (a2),d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    moveq   #$0,d1
    move.b  (a2),d1
    ext.l   d1
    moveq   #$0,d3
    move.b  $0001(a2),d3
    ext.l   d3
    sub.l   d3,d1
    cmp.l   d1,d0
    blt.b   .l17d5a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$00ee                                 ; jsr $017E42
    nop
    addq.l  #$4,sp
.l17d5a:                                                ; $017D5A
    addq.l  #$2,a3
    addq.l  #$2,a2
    addq.w  #$1,d2
    cmpi.w  #$20,d2
    bcs.b   .l17cf8
    movem.l (sp)+,d2-d3/a2-a3
    rts
    dc.w    $4E56,$0000                                      ; $017D6C
; === Translated block $017D70-$01801C ===
; 4 functions, 684 bytes

; ============================================================================
; UpdateEventState -- (TODO: name)
; 210 bytes | $017D70-$017E41
; ============================================================================
UpdateEventState:
    movem.l d2-d4/a2-a3, -(a7)
    move.l  $8(a6), d2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$00FF8824,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    subq.b  #$1, $1(a2)
    tst.b   $1(a2)
    bne.w   l_17e38
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$8,d4
    sub.w   d0, d4
    add.w   d4, d4
    addi.w  #$a, d4
    moveq   #$0,d3
    move.b  (a3), d3
    add.w   d4, d3
    cmpi.w  #$ff, d3
    bcc.b   l_17dc4
    moveq   #$0,d0
    move.w  d3, d0
    bra.b   l_17dca
l_17dc4:
    move.l  #$ff, d0
l_17dca:
    move.b  d0, (a3)
    addq.b  #$1, (a2)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0011).w
    pea     ($0001).w
    jsr DrawBox
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($00041038).l
    jsr PrintfWide
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($000A).w
    pea     ($001E).w
    pea     ($0011).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr GameCommand
l_17e38:
    movem.l -$14(a6), d2-d4/a2-a3
    unlk    a6
    rts

; ============================================================================
; ApplyEventEffect -- (TODO: name)
; 46 bytes | $017E42-$017E6F
; ============================================================================
ApplyEventEffect:
    link    a6,#$0
    move.w  $a(a6), d0
    add.w   d0, d0
    movea.l  #$00FF0728,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a1)
    bne.b   l_17e6c
    cmpi.b  #$9, (a1)
    bcc.b   l_17e6c
    move.b  (a1), d0
    addq.b  #$3, d0
    move.b  d0, $1(a1)
l_17e6c:
    unlk    a6
    rts

; ============================================================================
; HandleEventCallback -- (TODO: name)
; 220 bytes | $017E70-$017F4B
; ============================================================================
HandleEventCallback:
    movem.l d2/a2-a5, -(a7)
    movea.l  #$0000C860,a5
    movea.l  #$0005F26A,a4
    movea.l  #$0005F3CE,a3
    movea.l  #$00FF1298,a2
    tst.w   ($00FF0002).l
    bne.b   l_17eb8
    clr.w   d2
l_17e96:
    move.b  $1(a4), $1(a2)
    move.b  $2(a4), $2(a2)
    move.b  $3(a4), $3(a2)
    addq.l  #$4, a4
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17e96
    bra.w   l_17f46
l_17eb8:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   l_17ee4
    clr.w   d2
l_17ec4:
    move.b  $1(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    move.b  $3(a3), $3(a2)
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17ec4
    bra.b   l_17f46
l_17ee4:
    clr.w   d2
l_17ee6:
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $18(a7), a7
    move.b  d0, $3(a2)
    addq.l  #$4, a4
    addq.l  #$4, a3
    addq.l  #$4, a2
    addq.w  #$1, d2
    cmpi.w  #$59, d2
    bcs.b   l_17ee6
l_17f46:
    movem.l (a7)+, d2/a2-a5
    rts

; ============================================================================
; ResetEventData -- (TODO: name)
; 208 bytes | $017F4C-$01801B
; ============================================================================
ResetEventData:
    movem.l d2/a2-a5, -(a7)
    move.l  $18(a7), d2
    movea.l  #$0000C860,a5
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F26A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F3CE,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$00FF1298,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.w   ($00FF0002).l
    bne.b   l_17fa6
    move.b  $1(a4), $1(a2)
    move.b  $2(a4), $2(a2)
    move.b  $3(a4), $3(a2)
    bra.b   l_18016
l_17fa6:
    cmpi.w  #$3, ($00FF0002).l
    bne.b   l_17fc4
    move.b  $1(a3), $1(a2)
    move.b  $2(a3), $2(a2)
    move.b  $3(a3), $3(a2)
    bra.b   l_18016
l_17fc4:
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $1(a2)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.b  d0, $2(a2)
    moveq   #$0,d0
    move.b  $3(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $3(a4), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    lea     $18(a7), a7
    move.b  d0, $3(a2)
l_18016:
    movem.l (a7)+, d2/a2-a5
    rts

CalcCityCharBonus:                                                  ; $01801C
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0024(sp),d2
    move.l  $0028(sp),d5
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    cmpi.w  #$1,d5
    bne.b   .l1804a
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w ResetEventData
    addq.l  #$4,sp
.l1804a:                                                ; $01804A
    cmpi.w  #$20,d2
    bcc.b   .l18078
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    add.l   d0,d0
    move.l  d0,d2
    movea.l #$00ff1704,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    movea.l #$00ff0420,a0
    lea     (a0,d2.w),a5
    moveq   #$6,d5
    bra.b   .l1809a
.l18078:                                                ; $018078
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff15a0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff0460,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$4,d5
.l1809a:                                                ; $01809A
    clr.w   d3
    clr.w   d4
    clr.w   d2
    bra.b   .l18118
.l180a2:                                                ; $0180A2
    cmpi.b  #$0f,(a3)
    beq.b   .l18112
    cmpi.b  #$04,(a5)
    bcc.b   .l18112
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.w   #$2,d0
    movea.l #$0005e31a,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    tst.b   $0003(a2)
    beq.b   .l180ce
    cmpi.b  #$02,$0003(a2)
    bne.b   .l180ec
.l180ce:                                                ; $0180CE
    move.b  (a2),d0
    add.b   d0,$0002(a4)
    cmpi.b  #$64,$0002(a4)
    bcc.b   .l180e4
    moveq   #$0,d0
    move.b  $0002(a4),d0
    bra.b   .l180e6
.l180e4:                                                ; $0180E4
    moveq   #$64,d0
.l180e6:                                                ; $0180E6
    move.b  d0,$0002(a4)
    bra.b   .l18112
.l180ec:                                                ; $0180EC
    cmpi.b  #$03,$0003(a2)
    bne.b   .l18112
    cmpi.b  #$0d,(a3)
    beq.b   .l18112
    addq.w  #$1,d3
    moveq   #$0,d0
    move.b  $0002(a2),d0
    andi.l  #$ffff,d0
    tst.l   d0
    bge.b   .l1810e
    addq.l  #$1,d0
.l1810e:                                                ; $01810E
    asr.l   #$1,d0
    add.w   d0,d4
.l18112:                                                ; $018112
    addq.l  #$1,a3
    addq.l  #$1,a5
    addq.w  #$1,d2
.l18118:                                                ; $018118
    cmp.w   d5,d2
    bcs.b   .l180a2
    tst.w   d3
    beq.b   .l18196
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$a,d1
    sub.l   d0,d1
    addq.l  #$1,d1
    move.l  d1,d0
    moveq   #$0,d1
    move.w  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d4
    moveq   #$0,d0
    move.b  $0001(a4),d0
    moveq   #$0,d1
    move.w  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d2
    moveq   #$0,d0
    move.w  d2,d0
    moveq   #$0,d1
    move.w  d3,d1
    add.l   d1,d1
    cmp.l   d1,d0
    ble.b   .l1816e
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l18174
.l1816e:                                                ; $01816E
    moveq   #$0,d0
    move.w  d3,d0
    add.l   d0,d0
.l18174:                                                ; $018174
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a4),d0
    add.w   d2,d0
    move.w  d0,d2
    cmpi.w  #$ff,d2
    bcc.b   .l1818c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l18192
.l1818c:                                                ; $01818C
    move.l  #$ff,d0
.l18192:                                                ; $018192
    move.b  d0,$0001(a4)
.l18196:                                                ; $018196
    movem.l (sp)+,d2-d5/a2-a5
    rts
; ============================================================================
; InitAllCharRecords -- (TODO: describe)
; 42 bytes | $01819C-$0181C5
; ============================================================================
InitAllCharRecords:                                                  ; $01819C
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    beq.b   .l181aa
    bsr.w HandleEventCallback
.l181aa:                                                ; $0181AA
    clr.w   d2
.l181ac:                                                ; $0181AC
    clr.l   -(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0012                                 ; jsr $0181C6
    nop
    addq.l  #$8,sp
    addq.w  #$1,d2
    cmpi.w  #$59,d2
    bcs.b   .l181ac
    move.l  (sp)+,d2
    rts
; ============================================================================
; InitCharRecord -- Initialize character record from player data
; Called: 11 times.
; 78 bytes | $0181C6-$018213
; ============================================================================
InitCharRecord:                                                  ; $0181C6
    movem.l d2-d3/a2,-(sp)
    move.l  $0010(sp),d2
    move.l  $0014(sp),d3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    bsr.w CalcCityCharBonus
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.l  a2,d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$1e5e                           ; jsr $021E5E
    lea     $0014(sp),sp
    movem.l (sp)+,d2-d3/a2
    rts
; ============================================================================
; ShowStatsSummary -- (TODO: describe)
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
; ============================================================================
; RunCharManagement -- (TODO: describe)
; Called: ?? times.
; 1638 bytes | $01861A-$018C7F
; ============================================================================
RunCharManagement:                                                  ; $01861A
    link    a6,#-$bc
    movem.l d2-d7/a2-a5,-(sp)
    lea     $000a(a6),a4
    lea     -$00ae(a6),a5
    move.w  (a4),d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$063e                                 ; jsr $018C80
    nop
    addq.l  #$4,sp
    move.w  $000e(a6),d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l18660
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eba,$06ba                                 ; jsr $018D14
    nop
    addq.l  #$4,sp
.l18660:                                                ; $018660
    tst.l   $0006(a3)
    ble.w   .l18c3e
    clr.w   -$00b4(a6)
    clr.w   -$00b6(a6)
    clr.w   -$00b8(a6)
    clr.w   -$00ba(a6)
    moveq   #$0,d4
    move.w  #$ffff,-$0002(a6)
    move.w  #$ffff,-$00b0(a6)
    tst.b   ($00FF09C2).l
    bne.b   .l186a0
    moveq   #$0,d0
    move.b  ($00FF09C3).l,d0
    lsl.w   #$3,d0
    movea.l #$0005f9e1,a0
    bra.b   .l186ba
.l186a0:                                                ; $0186A0
    cmpi.b  #$01,($00FF09C2).l
    bne.b   .l186d4
    moveq   #$0,d0
    move.b  ($00FF09C3).l,d0
    lsl.w   #$2,d0
    movea.l #$0005fa11,a0
.l186ba:                                                ; $0186BA
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,-$00b0(a6)
.l186d4:                                                ; $0186D4
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.w   d1,d0
    move.w  d0,-$00b2(a6)
    move.w  (a4),d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$6f,d5
    moveq   #-$1,d7
    clr.w   d3
    bra.w   .l187b4
.l18702:                                                ; $018702
    move.b  $000a(a2),d0
    andi.l  #$4,d0
    bne.w   .l187ae
    move.b  $000a(a2),d0
    andi.l  #$2,d0
    bne.w   .l187ae
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  (sp)+,d1
    cmp.w   d1,d0
    bne.b   .l187ae
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    cmp.w   -$00b0(a6),d0
    beq.b   .l187ae
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bcc.b   .l18782
    moveq   #$0,d2
    move.w  $0006(a2),d2
    moveq   #$0,d0
    move.w  $000e(a2),d0
    sub.l   d0,d2
    cmp.l   d2,d4
    bge.b   .l18782
    move.l  d2,d4
    move.w  d3,-$0002(a6)
.l18782:                                                ; $018782
    moveq   #$0,d6
    move.b  $000b(a2),d6
    moveq   #$0,d2
    move.b  $0003(a2),d2
    move.w  d6,d0
    move.l  d0,-(sp)
    pea     ($0064).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $000c(sp),sp
    move.w  d0,d2
    cmp.w   d5,d2
    bge.b   .l187ae
    move.w  d2,d5
    move.w  d3,d7
.l187ae:                                                ; $0187AE
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
.l187b4:                                                ; $0187B4
    cmp.w   -$00b2(a6),d3
    blt.w   .l18702
    cmp.w   -$0002(a6),d7
    bne.b   .l187c4
    moveq   #-$1,d7
.l187c4:                                                ; $0187C4
    move.w  -$0002(a6),d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l189de
    pea     ($000C).w
    pea     ($00FF).w
    pea     -$000e(a6)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    move.w  (a4),d0
    mulu.w  #$0320,d0
    move.w  -$0002(a6),d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    tst.l   d0
    bne.b   .l18816
    moveq   #$0,d3
    move.b  (a2),d3
    bra.b   .l1881c
.l18816:                                                ; $018816
    moveq   #$0,d3
    move.b  $0001(a2),d3
.l1881c:                                                ; $01881C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lea     $0018(sp),sp
    moveq   #$0,d0
    move.w  $000e(a2),d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0006(a2),d1
    add.l   d1,d1
    cmp.l   d1,d0
    ble.b   .l1887e
    clr.l   -(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2
    lea     $000c(sp),sp
    move.w  d0,d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.b   .l1887e
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    cmp.l   $0006(a3),d0
    bls.b   .l18890
.l1887e:                                                ; $01887E
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686
    addq.l  #$8,sp
    move.w  d0,d2
.l18890:                                                ; $018890
    move.w  d2,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l189de
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4
    pea     ($FFFFFFFF).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2
    addq.l  #$8,sp
    cmpi.w  #$1,d4
    beq.b   .l1894a
    cmpi.w  #$3,d4
    bgt.b   .l1894a
    cmpi.w  #$3,d4
    bne.b   .l188e0
    moveq   #$1,d4
.l188e0:                                                ; $0188E0
    move.w  d4,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$0005e296,a0
    move.l  (a0,d0.l),-(sp)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047CA4).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $0024(sp),sp
    move.w  #$1,-$00b4(a6)
    move.w  #$1,-$00b8(a6)
    bra.b   .l1899c
.l1894a:                                                ; $01894A
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047CA8).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $0020(sp),sp
    move.w  #$1,-$00b4(a6)
.l1899c:                                                ; $01899C
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    add.l   d0,d0
    add.l   d2,d0
    cmp.l   $0006(a3),d0
    ble.b   .l189de
    clr.l   -(sp)
    move.l  ($00047CC0).l,-(sp)
    pea     ($0004).w
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $0010(sp),sp
    move.w  #$1,-$00b6(a6)
.l189de:                                                ; $0189DE
    move.w  d7,d0
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c
    tst.w   -$00b6(a6)
    bne.w   .l18c6c
    move.w  (a4),d0
    mulu.w  #$0320,d0
    move.w  d7,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    tst.l   d0
    bne.b   .l18a2a
    moveq   #$0,d3
    move.b  (a2),d3
    move.w  #$1,-$00ba(a6)
    bra.b   .l18a30
.l18a2a:                                                ; $018A2A
    moveq   #$0,d3
    move.b  $0001(a2),d3
.l18a30:                                                ; $018A30
    cmpi.w  #$28,d5
    bgt.b   .l18a3c
    tst.w   -$00b8(a6)
    beq.b   .l18a44
.l18a3c:                                                ; $018A3C
    cmpi.w  #$1,-$00ba(a6)
    bne.b   .l18a56
.l18a44:                                                ; $018A44
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686
    addq.l  #$8,sp
    bra.b   .l18a6c
.l18a56:                                                ; $018A56
    pea     ($0001).w
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2
    lea     $000c(sp),sp
.l18a6c:                                                ; $018A6C
    move.w  d0,d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e31d,a0
    move.b  (a0,d0.w),d4
    andi.l  #$ff,d4
    pea     ($FFFFFFFF).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2
    addq.l  #$8,sp
    cmpi.w  #$1,d4
    beq.b   .l18ab6
    cmpi.w  #$28,d5
    ble.w   .l18bfa
.l18ab6:                                                ; $018AB6
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    lsl.l   #$2,d0
    cmp.l   $0006(a3),d0
    bge.b   .l18b4c
    cmpi.w  #$1,-$00b4(a6)
    bne.b   .l18b00
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410C0).l
    bra.b   .l18b22
.l18b00:                                                ; $018B00
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410B8).l
.l18b22:                                                ; $018B22
    move.l  ($00047CC4).l,-(sp)
.l18b28:                                                ; $018B28
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0014(sp),sp
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d6a4                           ; jsr $01D6A4
    addq.l  #$8,sp
    move.l  d0,-(sp)
    bra.w   .l18c5e
.l18b4c:                                                ; $018B4C
    cmpi.w  #$1,-$00ba(a6)
    bne.b   .l18b66
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$0686                           ; jsr $010686
    addq.l  #$8,sp
    bra.b   .l18b7a
.l18b66:                                                ; $018B66
    clr.l   -(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$08f2                           ; jsr $0108F2
    lea     $000c(sp),sp
.l18b7a:                                                ; $018B7A
    move.w  d0,d2
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0,d1
    beq.w   .l18c6c
    pea     ($FFFFFFFF).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$00f2                           ; jsr $0100F2
    addq.l  #$8,sp
    cmpi.w  #$1,-$00b4(a6)
    bne.b   .l18bce
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410B2).l
    bra.b   .l18bf0
.l18bce:                                                ; $018BCE
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410AA).l
.l18bf0:                                                ; $018BF0
    move.l  ($00047CC8).l,-(sp)
    bra.w   .l18b28
.l18bfa:                                                ; $018BFA
    cmpi.w  #$3,d4
    bgt.b   .l18c6c
    cmpi.w  #$3,d4
    bne.b   .l18c08
    moveq   #$1,d4
.l18c08:                                                ; $018C08
    move.w  d4,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$0005e296,a0
    move.l  (a0,d0.l),-(sp)
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d2,d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.l  ($00047CA4).l,-(sp)
    bra.w   .l18b28
.l18c3e:                                                ; $018C3E
    move.l  ($00047B78).l,-(sp)
    move.l  ($00047CBC).l,-(sp)
    move.l  a5,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $000c(sp),sp
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0003).w
.l18c5e:                                                ; $018C5E
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$fbd6                           ; jsr $02FBD6
    lea     $0010(sp),sp
.l18c6c:                                                ; $018C6C
    move.w  (a4),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$01ca                           ; jsr $0101CA
    movem.l -$00e4(a6),d2-d7/a2-a5
    unlk    a6
    rts
; === Translated block $018C80-$018EBA ===
; 2 functions, 570 bytes

; ============================================================================
; ComputeQuarterResults -- (TODO: name)
; 148 bytes | $018C80-$018D13
; ============================================================================
ComputeQuarterResults:
    link    a6,#-$A0
    movem.l d2-d3/a2, -(a7)
    move.l  $8(a6), d3
    lea     -$a0(a6), a2
    pea     ($0001).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CountCharPerformance
    addq.l  #$8, a7
    move.w  d0, d2
    tst.w   d2
    bne.b   l_18cc0
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047C9C).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $c(a7), a7
    bra.b   l_18cec
l_18cc0:
    cmpi.w  #$1, d2
    bne.b   l_18cce
    pea     ($000410C6).l
    bra.b   l_18cd4
l_18cce:
    move.l  ($00047B78).l, -(a7)
l_18cd4:
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  ($00047CA0).l, -(a7)
    move.l  a2, -(a7)
    jsr sprintf
    lea     $10(a7), a7
l_18cec:
    clr.l   -(a7)
    move.l  a2, -(a7)
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
    movem.l -$ac(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; UpdatePlayerAssets -- (TODO: name)
; 422 bytes | $018D14-$018EB9
; ============================================================================
UpdatePlayerAssets:
    link    a6,#-$AC
    movem.l d2-d4/a2-a5, -(a7)
    move.l  $8(a6), d3
    lea     -$ac(a6), a5
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    pea     -$c(a6)
    pea     -$8(a6)
    pea     -$4(a6)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcPlayerFinances
    lea     $10(a7), a7
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, d2
    movea.l  #$00FF09A2,a0
    tst.l   (a0,d0.w)
    beq.w   l_18eb0
    movea.l  #$00FF09A2,a0
    lea     (a0,d2.w), a2
    movea.l a2, a0
    addq.l  #$4, a0
    movea.l a0, a3
    move.l  (a0), d0
    cmp.l   (a2), d0
    bcc.w   l_18e2e
    movea.l  #$00FF09A2,a0
    move.l  (a0,d2.w), d0
    movea.l  #$00FF09A6,a0
    sub.l   (a0,d2.w), d0
    move.l  d0, d2
    cmp.l   -$c(a6), d2
    blt.b   l_18dc0
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    clr.l   -(a7)
    move.l  a5, -(a7)
    pea     ($0003).w
    bra.w   l_18ea6
l_18dc0:
    move.l  d2, d0
    moveq   #$64,d1
    jsr Multiply32
    move.l  -$c(a6), d1
    jsr SignedDiv
    move.w  d0, d4
    tst.w   d4
    ble.b   l_18e12
    cmpi.w  #$64, d4
    bge.b   l_18e12
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CAC).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $14(a7), a7
    cmpi.w  #$1e, d4
    blt.b   l_18e0a
    moveq   #$1,d0
    bra.b   l_18e0c
l_18e0a:
    moveq   #$0,d0
l_18e0c:
    move.l  d0, -(a7)
    bra.w   l_18ea0
l_18e12:
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB0).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    lea     $10(a7), a7
    bra.b   l_18e9e
l_18e2e:
    movea.l  #$00FF09A2,a0
    lea     (a0,d2.w), a0
    movea.l a0, a2
    move.l  (a0), d0
    cmp.l   (a3), d0
    bne.b   l_18e4e
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CD0).l, -(a7)
    bra.b   l_18e92
l_18e4e:
    move.l  (a3), d2
    sub.l   (a2), d2
    move.l  d2, -(a7)
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB4).l, -(a7)
    move.l  a5, -(a7)
    jsr sprintf
    pea     ($0002).w
    move.l  a5, -(a7)
    pea     ($0002).w
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
    lea     $20(a7), a7
    tst.l   $6(a4)
    bge.b   l_18eb0
    move.l  ($00047B78).l, -(a7)
    move.l  ($00047CB8).l, -(a7)
l_18e92:
    move.l  a5, -(a7)
    jsr sprintf
    lea     $c(a7), a7
l_18e9e:
    clr.l   -(a7)
l_18ea0:
    move.l  a5, -(a7)
    pea     ($0002).w
l_18ea6:
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr ShowText
l_18eb0:
    movem.l -$c8(a6), d2-d4/a2-a5
    unlk    a6
    rts

; ---------------------------------------------------------------------------
GetCharRelation:                                                  ; $018EBA
    movem.l d2-d5/a2,-(sp)
    move.l  $0020(sp),d2
    move.l  $0018(sp),d3
    move.l  $001c(sp),d4
    cmpi.w  #$20,d2
    bge.b   .l18f3a
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0019,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l18ef6
    move.w  #$0760,d2
    bra.w   .l18f86
.l18ef6:                                                ; $018EF6
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    cmp.w   d2,d0
    bne.b   .l18f14
    move.w  #$0761,d2
    bra.b   .l18f86
.l18f14:                                                ; $018F14
    move.w  d2,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    movea.l #$00ffa6a0,a0
    and.l   (a0,d1.w),d0
    beq.b   .l18f34
    move.w  #$0762,d2
    bra.b   .l18f86
.l18f34:                                                ; $018F34
    move.w  #$0763,d2
    bra.b   .l18f86
.l18f3a:                                                ; $018F3A
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0002(a2),d0
    sub.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d3,d1
    mulu.w  #$e,d1
    move.w  d4,d5
    add.w   d5,d5
    add.w   d5,d1
    movea.l #$00ffbd6c,a0
    move.w  (a0,d1.w),d1
    andi.l  #$ffff,d1
    and.l   d1,d0
    beq.b   .l18f82
    move.w  #$0764,d2
    bra.b   .l18f86
.l18f82:                                                ; $018F82
    move.w  #$0765,d2
.l18f86:                                                ; $018F86
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2
    rts
; ---------------------------------------------------------------------------
BrowseRelations:                                                  ; $018F8E
    link    a6,#-$14
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d4
    move.l  $0010(a6),d6
    movea.l #$0d64,a2
    movea.l #$00ff13fc,a3
    lea     -$0012(a6),a4
    lea     -$0010(a6),a5
    clr.w   d7
    moveq   #$1,d5
    clr.w   d3
.l18fbc:                                                ; $018FBC
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$81d2                           ; jsr $0081D2
    lea     $000c(sp),sp
    move.w  d3,d1
    ext.l   d1
    lsl.l   #$2,d1
    movea.l d1,a0
    move.l  d0,(a5,a0.l)
    beq.b   .l18fe8
    moveq   #$1,d7
.l18fe8:                                                ; $018FE8
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l18fbc
    cmpi.w  #$1,d7
    bne.w   .l1923a
    clr.l   -(sp)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077D).w
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    pea     ($0008).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    move.w  #$ff,d3
    bra.b   .l19054
.l19044:                                                ; $019044
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
.l19054:                                                ; $019054
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l19044
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    lea     $0028(sp),sp
    tst.w   d0
    beq.b   .l19076
    moveq   #$1,d4
    bra.b   .l19078
.l19076:                                                ; $019076
    moveq   #$0,d4
.l19078:                                                ; $019078
    clr.w   d6
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.w   (a4)
.l19084:                                                ; $019084
    cmp.w   d2,d3
    beq.b   .l190b8
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0013).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.l  (a5,a0.l),-(sp)
    dc.w    $4eba,$05b4                                 ; jsr $019660
    nop
    lea     $0018(sp),sp
    move.w  d2,d3
    clr.w   d5
.l190b8:                                                ; $0190B8
    tst.w   d4
    beq.b   .l190d8
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$e1ec                           ; jsr $01E1EC
    addq.l  #$4,sp
    tst.w   d0
    beq.b   .l190d8
.l190ca:                                                ; $0190CA
    pea     ($0003).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l19084
.l190d8:                                                ; $0190D8
    clr.w   d4
    addq.w  #$1,(a4)
    cmpi.w  #$1,(a4)
    bne.b   .l1914a
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0098).w
    pea     ($0078).w
    pea     ($0039).w
    pea     ($0770).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($00D0).w
    pea     ($0078).w
    pea     ($003A).w
    pea     ($0771).w
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    lea     $001c(sp),sp
.l1913c:                                                ; $01913C
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8,sp
    bra.b   .l1916a
.l1914a:                                                ; $01914A
    cmpi.w  #$f,(a4)
    bne.b   .l19162
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    addq.l  #$8,sp
    bra.b   .l1913c
.l19162:                                                ; $019162
    cmpi.w  #$1e,(a4)
    bne.b   .l1916a
    clr.w   (a4)
.l1916a:                                                ; $01916A
    move.w  d6,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e290                           ; jsr $01E290
    addq.l  #$8,sp
    andi.w  #$33,d0
    move.w  d0,d6
    ext.l   d0
    moveq   #$2,d1
    cmp.w   d1,d0
    beq.b   .l1919e
    moveq   #$1,d1
    cmp.w   d1,d0
    beq.b   .l191c2
    moveq   #$20,d1
    cmp.w   d1,d0
    beq.b   .l191e6
    moveq   #$10,d1
    cmp.w   d1,d0
    beq.b   .l191e6
    bra.w   .l1922e
.l1919e:                                                ; $01919E
    move.w  #$1,(a3)
.l191a2:                                                ; $0191A2
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l191a2
    bra.w   .l190ca
.l191c2:                                                ; $0191C2
    move.w  #$1,(a3)
.l191c6:                                                ; $0191C6
    move.w  d2,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    lsl.l   #$2,d0
    movea.l d0,a0
    tst.l   (a5,a0.l)
    beq.b   .l191c6
    bra.w   .l190ca
.l191e6:                                                ; $0191E6
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    clr.l   -(sp)
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    pea     ($077D).w
    pea     ($000C).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $001c(sp),sp
    move.w  d7,d0
    bra.b   .l1923a
.l1922e:                                                ; $01922E
    clr.w   (a3)
    clr.w   ($00FFA7D8).l
    bra.w   .l190ca
.l1923a:                                                ; $01923A
    movem.l -$003c(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; FormatRelationDisplay -- (TODO: describe)
; Called: ?? times.
; 1052 bytes | $019244-$01965F
; ============================================================================
FormatRelationDisplay:                                                  ; $019244
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0018(a6),d2
    move.l  $000c(a6),d3
    move.l  $0014(a6),d4
    movea.l $0008(a6),a2
    movea.l #$00ff1804,a3
    movea.l #$0003ab2c,a4
    movea.l #$00ffba80,a5
    moveq   #$1,d5
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    cmpi.w  #$1,d2
    bne.w   .l1933a
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    tst.w   d0
    beq.b   .l192c4
    move.l  ($000A1B50).l,-(sp)
    bra.b   .l192ca
.l192c4:                                                ; $0192C4
    move.l  ($000A1B4C).l,-(sp)
.l192ca:                                                ; $0192CA
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0010).w
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($0004DCE8).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    pea     ($00072AC0).l
    pea     ($000D).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0030(sp),sp
.l1933a:                                                ; $01933A
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410F8).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $0028(sp),sp
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    addq.w  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($000410F4).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0030(sp),sp
    move.w  d4,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410F0).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    pea     ($000410E6).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    move.w  d4,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$14,d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $002c(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  (a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.l   #$3,d0
    lea     (a5,d0.l),a0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    adda.l  d1,a0
    move.b  $0001(a0),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    pea     ($000410DC).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    move.w  d4,d0
    ext.l   d0
    addi.l  #$b,d0
    move.l  d0,-(sp)
    pea     ($000E).w
    jsr     (a4)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
    pea     ($000410D8).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $001c(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0007).w
    clr.l   -(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$0476                                 ; jsr $0199FA
    nop
    lea     $002c(sp),sp
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$0838                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
    moveq   #-$1,d3
    move.b  $000a(a2),d0
    btst    #$02,d0
    beq.b   .l195c6
    moveq   #$0,d3
    bra.b   .l195e0
.l195c6:                                                ; $0195C6
    move.b  $000a(a2),d0
    btst    #$01,d0
    beq.b   .l195d4
    moveq   #$10,d3
    bra.b   .l195e0
.l195d4:                                                ; $0195D4
    move.b  $000a(a2),d0
    btst    #$00,d0
    beq.b   .l195e0
    moveq   #$8,d3
.l195e0:                                                ; $0195E0
    moveq   #-$1,d0
    cmp.l   d3,d0
    bge.b   .l19656
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    add.l   d3,d0
    addi.l  #$037b,d0
    move.l  d0,d3
.l195f6:                                                ; $0195F6
    move.w  d2,d0
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
    addq.l  #$1,d3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l195f6
    pea     -$0010(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0004E28A).l
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a3,-(sp)
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l19656:                                                ; $019656
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
; ============================================================================
; FormatRelationStats -- (TODO: describe)
; Called: ?? times.
; 922 bytes | $019660-$0199F9
; ============================================================================
FormatRelationStats:                                                  ; $019660
    link    a6,#-$10
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0018(a6),d3
    move.l  $0014(a6),d4
    movea.l $0008(a6),a2
    movea.l #$0003b270,a3
    movea.l #$0003ab2c,a4
    movea.l #$00ff1804,a5
    moveq   #$1,d5
    dc.w    $4eb9,$0003,$77c8                           ; jsr $0377C8
    move.l  #$8000,-(sp)
    pea     ($000C).w
    pea     ($0020).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    lea     $0024(sp),sp
    tst.w   d0
    beq.b   .l196d0
    moveq   #$2,d2
    bra.b   .l196d2
.l196d0:                                                ; $0196D0
    moveq   #$1,d2
.l196d2:                                                ; $0196D2
    pea     ($075E).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    pea     ($075F).w
    move.w  $000e(a6),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($001E).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$6760                           ; jsr $006760
    lea     $0020(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    pea     ($077E).w
    pea     ($0004).w
    pea     ($000B).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    cmpi.w  #$1,d3
    bne.b   .l197c6
    pea     ($0004DCE8).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($001A).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $001c(sp),sp
.l197c6:                                                ; $0197C6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($0004110C).l
    jsr     (a3)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$c,d0
    move.l  d0,-(sp)
    jsr     (a4)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    addq.l  #$8,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($00041108).l
    jsr     (a3)
    lea     $0030(sp),sp
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$13,d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$b,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$12,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    dc.w    $4eb9,$0000,$58fc                           ; jsr $0058FC
    move.w  d4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    addi.w  #$11,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    lea     $0030(sp),sp
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e7e4,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($00041104).l
    jsr     (a3)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    jsr     (a4)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    addq.l  #$4,sp
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    movea.l #$00ff1278,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    lsl.w   #$2,d0
    movea.l #$0005ecfc,a0
    move.l  (a0,d0.w),-(sp)
    pea     ($000410FC).l
    jsr     (a3)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$00da                                 ; jsr $0199FA
    nop
    lea     $0030(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    dc.w    $4eba,$049c                                 ; jsr $019DE6
    nop
    lea     $0014(sp),sp
    moveq   #-$1,d3
    move.b  $000a(a2),d0
    btst    #$02,d0
    beq.b   .l19962
    moveq   #$0,d3
    bra.b   .l1997c
.l19962:                                                ; $019962
    move.b  $000a(a2),d0
    btst    #$01,d0
    beq.b   .l19970
    moveq   #$10,d3
    bra.b   .l1997c
.l19970:                                                ; $019970
    move.b  $000a(a2),d0
    btst    #$00,d0
    beq.b   .l1997c
    moveq   #$8,d3
.l1997c:                                                ; $01997C
    moveq   #-$1,d0
    cmp.l   d3,d0
    bge.b   .l199f0
    clr.w   d2
    move.w  d2,d0
    ext.l   d0
    add.l   d3,d0
    addi.l  #$637b,d0
    move.l  d0,d3
.l19992:                                                ; $019992
    move.w  d2,d0
    add.w   d0,d0
    move.w  d3,-$10(a6,d0.w)
    addq.l  #$1,d3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    blt.b   .l19992
    pea     -$0010(a6)
    pea     ($0002).w
    pea     ($0004).w
    move.w  d4,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0004E28A).l
    move.l  a5,-(sp)
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    lea     $0024(sp),sp
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a5,-(sp)
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
.l199f0:                                                ; $0199F0
    movem.l -$0030(a6),d2-d5/a2-a5
    unlk    a6
    rts
; ============================================================================
; ShowRelationAction -- (TODO: describe)
; Called: ?? times.
; 1004 bytes | $0199FA-$019DE5
; ============================================================================
ShowRelationAction:                                                  ; $0199FA
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2
    movea.l #$0d64,a3
    lea     $0016(a6),a4
    lea     $0012(a6),a5
    cmpi.w  #$1,$001a(a6)
    bne.b   .l19a6c
    move.l  ($000A1AE4).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0020).w
    pea     ($0694).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00070F38).l
    pea     ($0004).w
    pea     ($0004).w
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0030(sp),sp
.l19a6c:                                                ; $019A6C
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $0010(sp),sp
    move.w  $000e(a6),d6
    addq.w  #$4,d6
    move.w  (a5),d5
    clr.w   d4
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bls.w   .l19bb8
    move.w  #$0331,d7
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    subq.l  #$1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
    pea     ($0064).w
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $0028(sp),sp
    move.w  d0,d3
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    tst.w   d2
    ble.b   .l19b2c
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l19b2c:                                                ; $019B2C
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    lsl.l   #$3,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    add.w   d7,d0
    move.w  d0,d3
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$a,d2
    bge.w   .l19d3c
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
.l19ba8:                                                ; $019BA8
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    bra.w   .l19d2a
.l19bb8:                                                ; $019BB8
    tst.w   $0006(a2)
    beq.w   .l19cda
    move.w  #$0328,d7
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addi.l  #$11,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
    pea     ($0064).w
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $0028(sp),sp
    move.w  d0,d3
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    tst.w   d2
    ble.b   .l19c58
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    addq.l  #$8,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l19c58:                                                ; $019C58
    cmpi.w  #$a,d2
    bge.w   .l19d3c
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    lsl.l   #$3,d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    add.w   d0,d7
    move.w  d4,d0
    ext.l   d0
    move.w  d7,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    addq.w  #$1,d2
    cmpi.w  #$a,d2
    bge.w   .l19d3c
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d5,d0
    ext.l   d0
    bra.w   .l19ba8
.l19cda:                                                ; $019CDA
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.w  d4,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($000A).w
    move.w  d5,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
.l19d2a:                                                ; $019D2A
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l19d3c:                                                ; $019D3C
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  $000e(a2),d0
    move.l  d0,-(sp)
    pea     ($00041116).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    move.w  d0,d2
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    mulu.w  #$a,d0
    move.w  d0,d2
    move.l  d0,-(sp)
    pea     ($0064).w
    move.w  $0010(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    move.w  d0,d3
    cmpi.w  #$64,d3
    bge.b   .l19daa
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19dac
.l19daa:                                                ; $019DAA
    moveq   #$64,d0
.l19dac:                                                ; $019DAC
    move.w  d0,d3
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($00041110).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    movem.l -$0028(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; ShowRelationResult -- (TODO: describe)
; Called: ?? times.
; 1256 bytes | $019DE6-$01A2CD
; ============================================================================
ShowRelationResult:                                                  ; $019DE6
    link    a6,#$0
    movem.l d2-d7/a2-a5,-(sp)
    movea.l $0008(a6),a2
    movea.l #$0d64,a3
    lea     $0016(a6),a4
    lea     $0012(a6),a5
    cmpi.w  #$1,$001a(a6)
    bne.b   .l19e58
    move.l  ($000A1AE4).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0020).w
    pea     ($0694).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00070F58).l
    pea     ($0004).w
    pea     ($0004).w
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0030(sp),sp
.l19e58:                                                ; $019E58
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    move.w  $000e(a6),d7
    addq.w  #$4,d7
    move.w  (a5),d6
    clr.w   d5
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$70dc                           ; jsr $0070DC
    move.w  d0,d2
    pea     ($0064).w
    pea     ($0096).w
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e11c                           ; jsr $01E11C
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d4
    tst.w   $0004(a2)
    beq.b   .l19f02
    moveq   #$0,d0
    move.w  $0004(a2),d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    ble.b   .l19ee4
    moveq   #$0,d0
    move.w  $0004(a2),d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.l  d0,d3
    mulu.w  #$5,d3
    addi.w  #$32,d3
    bra.b   .l19f02
.l19ee4:                                                ; $019EE4
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    sub.l   d1,d0
    move.w  d4,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    mulu.w  #$5,d0
    moveq   #$32,d3
    sub.w   d0,d3
.l19f02:                                                ; $019F02
    cmpi.w  #$64,d3
    bge.b   .l19f0e
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19f10
.l19f0e:                                                ; $019F0E
    moveq   #$64,d0
.l19f10:                                                ; $019F10
    move.w  d0,d3
    tst.w   d3
    ble.b   .l19f1c
    move.w  d3,d0
    ext.l   d0
    bra.b   .l19f1e
.l19f1c:                                                ; $019F1C
    moveq   #$0,d0
.l19f1e:                                                ; $019F1E
    move.w  d0,d3
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0,d1
    ble.b   .l19f4c
    move.w  d3,d0
    ext.l   d0
    moveq   #$a,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    bra.b   .l19f4e
.l19f4c:                                                ; $019F4C
    moveq   #$1,d0
.l19f4e:                                                ; $019F4E
    move.w  d0,d4
    tst.w   d2
    ble.b   .l19f88
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033a,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l19f88:                                                ; $019F88
    tst.w   d4
    beq.b   .l19fc4
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033b,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l19fc4:                                                ; $019FC4
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.w  d4,d0
    ext.l   d0
    sub.l   d0,d1
    ble.b   .l1a01e
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033c,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$a,d1
    sub.l   d0,d1
    move.w  d4,d0
    ext.l   d0
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.w  d4,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a01e:                                                ; $01A01E
    move.w  (a5),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  $0004(a2),d0
    move.l  d0,-(sp)
    pea     ($00041128).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addi.l  #$9,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    subi.w  #$32,d3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($00041122).l
    dc.w    $4eb9,$0003,$b246                           ; jsr $03B246
    lea     $0020(sp),sp
    cmpi.b  #$0e,$000b(a2)
    bcc.b   .l1a092
    moveq   #$0,d4
    move.b  $000b(a2),d4
    bra.b   .l1a094
.l1a092:                                                ; $01A092
    moveq   #$e,d4
.l1a094:                                                ; $01A094
    cmpi.w  #$7,d4
    bge.b   .l1a0a0
    move.w  d4,d2
    ext.l   d2
    bra.b   .l1a0a2
.l1a0a0:                                                ; $01A0A0
    moveq   #$7,d2
.l1a0a2:                                                ; $01A0A2
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033e,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    cmpi.w  #$7,d2
    bge.b   .l1a11a
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a11a:                                                ; $01A11A
    cmpi.b  #$07,$0003(a2)
    bcc.b   .l1a12a
    moveq   #$0,d2
    move.b  $0003(a2),d2
    bra.b   .l1a12c
.l1a12a:                                                ; $01A12A
    moveq   #$7,d2
.l1a12c:                                                ; $01A12C
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033d,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.w  d4,d2
    addi.w  #$fff9,d2
    tst.w   d2
    ble.b   .l1a170
    move.w  d2,d0
    ext.l   d0
    bra.b   .l1a172
.l1a170:                                                ; $01A170
    moveq   #$0,d0
.l1a172:                                                ; $01A172
    move.w  d0,d2
    tst.w   d2
    ble.b   .l1a1f0
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033e,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    cmpi.w  #$7,d2
    bge.b   .l1a1f0
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a1f0:                                                ; $01A1F0
    cmpi.w  #$7,d2
    bge.b   .l1a234
    move.w  d5,d0
    ext.l   d0
    addi.l  #$0328,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    moveq   #$7,d1
    sub.l   d0,d1
    move.l  d1,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a234:                                                ; $01A234
    moveq   #$0,d2
    move.b  $0003(a2),d2
    addi.w  #$fff9,d2
    tst.w   d2
    ble.b   .l1a276
    move.w  d5,d0
    ext.l   d0
    addi.l  #$033d,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    addq.l  #$3,d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  (a4),d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a276:                                                ; $01A276
    move.w  (a5),d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    ext.l   d0
    addi.l  #$a,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0003(a2),d0
    move.l  d0,-(sp)
    pea     ($0004111C).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    move.w  (a5),d0
    addq.w  #$2,d0
    move.l  d0,-(sp)
    move.w  $000e(a6),d0
    addi.w  #$d,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0003).w
    dc.w    $4eb9,$0000,$595e                           ; jsr $00595E
    movem.l -$0028(a6),d2-d7/a2-a5
    unlk    a6
    rts
; ============================================================================
; BrowsePartners -- (TODO: describe)
; Called: ?? times.
; 410 bytes | $01A2CE-$01A467
; ============================================================================
BrowsePartners:                                                  ; $01A2CE
    movem.l d2-d5/a2-a4,-(sp)
    move.l  $0020(sp),d3
    movea.l #$0d64,a3
    movea.l #$00ff8804,a4
    clr.w   d2
.l1a2e4:                                                ; $01A2E4
    cmp.w   d3,d2
    beq.b   .l1a2f8
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    bne.b   .l1a300
.l1a2f8:                                                ; $01A2F8
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l1a2e4
.l1a300:                                                ; $01A300
    cmpi.w  #$4,d2
    bge.w   .l1a462
    move.l  #$8000,-(sp)
    pea     ($000B).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($000B).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.w  #$ff,d3
    moveq   #$1,d5
    bra.w   .l1a408
.l1a358:                                                ; $01A358
    cmp.w   d2,d3
    beq.b   .l1a3a2
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a4,a0.l),d0
    mulu.w  #$14,d0
    move.w  d2,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.l   -(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0013).w
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    bsr.w FormatRelationStats
    lea     $0018(sp),sp
    clr.w   d5
    move.w  d2,d3
.l1a3a2:                                                ; $01A3A2
    move.w  d4,d0
    andi.w  #$1,d0
    beq.b   .l1a3ca
.l1a3aa:                                                ; $01A3AA
    move.w  d2,d0
    ext.l   d0
    addq.l  #$3,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    beq.b   .l1a3aa
    bra.b   .l1a3f0
.l1a3ca:                                                ; $01A3CA
    move.w  d4,d0
    andi.w  #$2,d0
    beq.b   .l1a3fc
.l1a3d2:                                                ; $01A3D2
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    moveq   #$4,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,d2
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    cmpi.w  #$ff,(a4,a0.l)
    beq.b   .l1a3d2
.l1a3f0:                                                ; $01A3F0
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
.l1a3fc:                                                ; $01A3FC
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a3)
    addq.l  #$8,sp
.l1a408:                                                ; $01A408
    clr.l   -(sp)
    pea     ($0003).w
    dc.w    $4eb9,$0001,$d62c                           ; jsr $01D62C
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$10,d0
    bne.w   .l1a358
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    clr.l   -(sp)
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
    move.l  #$8000,-(sp)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a3)
    lea     $001c(sp),sp
.l1a462:                                                ; $01A462
    movem.l (sp)+,d2-d5/a2-a4
    rts
; ============================================================================
; ScanRouteSlots -- (TODO: describe)
; Called: ?? times.
; 158 bytes | $01A468-$01A505
; ============================================================================
ScanRouteSlots:                                                  ; $01A468
    movem.l d2-d6/a2,-(sp)
    move.l  $0024(sp),d4
    move.l  $0020(sp),d5
    move.l  $001c(sp),d6
    move.w  d6,d0
    lsl.w   #$5,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    pea     ($000F).w
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    clr.w   d3
.l1a4aa:                                                ; $01A4AA
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l1a4f6
    cmpi.w  #$6,d4
    beq.b   .l1a4d4
.l1a4be:                                                ; $01A4BE
    moveq   #$0,d2
    move.b  (a2),d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d2
    bra.b   .l1a4f4
.l1a4d4:                                                ; $01A4D4
    cmpi.w  #$3,$0006(a2)
    beq.b   .l1a4be
    moveq   #$0,d2
    move.b  (a2),d2
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9dc4                           ; jsr $009DC4
    addq.l  #$8,sp
.l1a4f4:                                                ; $01A4F4
    cmp.w   d5,d2
.l1a4f6:                                                ; $01A4F6
    addq.l  #$8,a2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l1a4aa
    movem.l (sp)+,d2-d6/a2
    rts
; ============================================================================
; CalcRelationValue -- (TODO: describe)
; Called: 7 times.
; 264 bytes | $01A506-$01A60D
; ============================================================================
CalcRelationValue:                                                  ; $01A506
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d3
    move.l  $0024(sp),d5
    move.l  $0020(sp),d6
    movea.l #$00ff1298,a2
    moveq   #$0,d0
    move.w  d6,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7610                           ; jsr $007610
    addq.l  #$8,sp
    move.w  d0,d2
    moveq   #$0,d4
    move.w  d2,d4
    move.l  d4,d0
    lsl.l   #$2,d4
    add.l   d0,d4
    add.l   d4,d4
    move.l  d4,d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d4
    addi.l  #$2710,d4
    moveq   #$0,d2
    cmpi.w  #$1,d5
    bne.b   .l1a57c
    moveq   #$0,d0
    move.w  d3,d0
.l1a55c:                                                ; $01A55C
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    bra.b   .l1a5da
.l1a57c:                                                ; $01A57C
    cmpi.w  #$2,d5
    bne.b   .l1a588
    moveq   #$0,d0
    move.w  d6,d0
    bra.b   .l1a55c
.l1a588:                                                ; $01A588
    cmpi.w  #$3,d5
    bne.b   .l1a5dc
    moveq   #$0,d0
    move.w  d3,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d3
    moveq   #$0,d0
    move.w  d6,d0
    lsl.l   #$2,d0
    movea.l d0,a0
    move.b  $1(a2,a0.l),d0
    andi.l  #$ff,d0
    move.l  d4,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    move.l  d3,d0
    add.l   d2,d0
.l1a5da:                                                ; $01A5DA
    move.l  d0,d2
.l1a5dc:                                                ; $01A5DC
    move.w  ($00FF0006).l,d0
    ext.l   d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addi.l  #$1e,d0
    move.l  d0,d3
    move.l  d2,d0
    move.l  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d2
    movem.l (sp)+,d2-d6/a2
    rts
; ============================================================================
; InitFlightDisplay -- (TODO: describe)
; Called: ?? times.
; 62 bytes | $01A60E-$01A64B
; ============================================================================
InitFlightDisplay:                                                  ; $01A60E
    pea     ($00049B26).l
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0560).w
    dc.w    $4eb9,$0001,$d7be                           ; jsr $01D7BE
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0048).w
    clr.l   -(sp)
    pea     ($00FF153C).l
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $0024(sp),sp
    rts
; ============================================================================
; ClearFlightSlots -- (TODO: describe)
; 38 bytes | $01A64C-$01A671
; ============================================================================
ClearFlightSlots:                                                  ; $01A64C
    pea     ($0004).w
    pea     ($0037).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0048).w
    clr.l   -(sp)
    pea     ($00FF153C).l
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $0014(sp),sp
    rts
; ---------------------------------------------------------------------------
UpdateFlightSlots:                                                  ; $01A672
    movem.l d2-d6/a2-a3,-(sp)
    move.l  $0024(sp),d4
    move.l  $0020(sp),d5
    movea.l #$00ff153c,a3
    tst.w   ($00FF000A).l
    beq.w   .l1a78c
    cmpi.w  #$1,d4
    bne.w   .l1a75a
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    clr.w   d3
    bra.b   .l1a720
.l1a6ac:                                                ; $01A6AC
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d2
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecdc,a0
    and.l   (a0,d0.w),d2
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d2,d1
    lsr.l   d0,d1
    move.l  d1,d2
    bra.b   .l1a6e2
.l1a6d4:                                                ; $01A6D4
    btst    #$00,d2
    beq.b   .l1a6dc
    addq.w  #$1,d3
.l1a6dc:                                                ; $01A6DC
    move.l  d2,d0
    lsr.l   #$1,d0
    move.l  d0,d2
.l1a6e2:                                                ; $01A6E2
    tst.l   d2
    beq.b   .l1a6ec
    cmpi.w  #$6,d3
    blt.b   .l1a6d4
.l1a6ec:                                                ; $01A6EC
    move.w  d4,d0
    mulu.w  #$e,d0
    move.w  d5,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffbd6c,a0
    move.w  (a0,d0.w),d2
    bra.b   .l1a714
.l1a704:                                                ; $01A704
    move.w  d2,d0
    andi.w  #$1,d0
    beq.b   .l1a70e
    addq.w  #$1,d3
.l1a70e:                                                ; $01A70E
    move.w  d2,d0
    lsr.w   #$1,d0
    move.w  d0,d2
.l1a714:                                                ; $01A714
    tst.w   d2
    beq.b   .l1a71e
    cmpi.w  #$8,d3
    blt.b   .l1a704
.l1a71e:                                                ; $01A71E
    addq.w  #$1,d4
.l1a720:                                                ; $01A720
    cmpi.w  #$4,d4
    bge.b   .l1a72e
    cmpi.w  #$6,d3
    blt.w   .l1a6ac
.l1a72e:                                                ; $01A72E
    move.w  d3,d0
    asr.w   #$1,d0
    move.w  d0,d3
    cmpi.w  #$4,d3
    bge.b   .l1a75a
    move.w  d3,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$3,d0
    add.l   d1,d0
    add.l   d0,d0
    move.l  d0,d6
    movea.l d0,a0
    move.b  #$ff,$1(a3,a0.l)
    movea.l a3,a0
    adda.l  d6,a0
    move.b  #$ff,$0002(a0)
.l1a75a:                                                ; $01A75A
    movea.l a3,a2
    clr.w   d4
.l1a75e:                                                ; $01A75E
    cmpi.b  #$ff,$0001(a2)
    beq.b   .l1a78c
    move.w  $000c(a2),d0
    cmp.w   $000e(a2),d0
    bcs.b   .l1a780
    move.l  a2,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0018                                 ; jsr $01A792
    nop
    addq.l  #$8,sp
.l1a780:                                                ; $01A780
    moveq   #$12,d0
    adda.l  d0,a2
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    blt.b   .l1a75e
.l1a78c:                                                ; $01A78C
    movem.l (sp)+,d2-d6/a2-a3
    rts
; ---------------------------------------------------------------------------
; === Translated block $01A790-$01ABAE ===
; 2 functions, 1054 bytes

; ============================================================================
; InitTurnState -- (TODO: name)
; 710 bytes | $01A792-$01AA57
; ============================================================================
InitTurnState:
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $2c(a7), d5
    movea.l $30(a7), a3
    movea.l  #$0001D6A4,a5
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    tst.l   d0
    bne.w   l_1a8dc
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d4
    mulu.w  #$7, d0
    add.w   d5, d0
    movea.l  #$00FFA7BC,a0
    tst.b   (a0,d0.w)
    beq.w   l_1aa52
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$ff, d7
    bne.b   l_1a806
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d7
l_1a806:
    cmpi.w  #$ff, d7
    beq.w   l_1aa52
l_1a80e:
    pea     ($0006).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d6
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$7, d1
    add.w   d5, d1
    movea.l  #$00FFA7BC,a0
    move.b  (a0,d1.w), d1
    andi.l  #$ff, d1
    and.l   d1, d0
    beq.b   l_1a80e
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$ff, d0
    bne.b   l_1a870
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
    move.w  d0, d2
l_1a870:
    move.b  d4, (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1a8b6
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
l_1a8a4:
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.b  d7, $1(a3)
    move.b  d2, $2(a3)
    bra.w   l_1aa42
l_1a8b6:
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d5, d0
    mulu.w  #$e, d0
    move.w  d6, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$0005E234,a0
    bra.w   l_1aa34
l_1a8dc:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d6
    move.b  $1(a2), d6
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d6
    addi.w  #$ffff, d6
    pea     ($0003).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d4
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d5, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    bne.b   l_1a940
    move.w  d4, d0
    mulu.w  #$e, d0
    move.w  d5, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBD6C,a0
    tst.w   (a0,d0.w)
    beq.w   l_1aa52
l_1a940:
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d7
    cmpi.w  #$ff, d0
    beq.w   l_1aa52
    clr.w   d3
l_1a960:
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d2, d0
    ble.b   l_1a99a
    moveq   #$0,d0
    move.b  (a2), d0
    add.w   d0, d2
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    lsl.w   #$2, d1
    movea.l  #$00FFA6A0,a0
    and.l   (a0,d1.w), d0
    beq.b   l_1a9da
    bra.b   l_1a9e4
l_1a99a:
    moveq   #$0,d0
    move.b  $1(a2), d0
    sub.w   d0, d2
    move.w  d2, d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    move.w  d4, d1
    mulu.w  #$e, d1
    movea.l d7, a0
    move.w  d5, d7
    add.w   d7, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFBD6C,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    and.l   d1, d0
    beq.b   l_1a9da
    moveq   #$0,d0
    move.b  $2(a2), d0
    add.w   d0, d2
    bra.b   l_1a9e4
l_1a9da:
    addq.w  #$1, d3
    cmpi.w  #$10, d3
    blt.w   l_1a960
l_1a9e4:
    cmpi.w  #$10, d3
    bge.b   l_1aa52
    move.b  d4, (a3)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, d3
    tst.w   d3
    bne.b   l_1aa1a
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    bra.w   l_1a8a4
l_1aa1a:
    move.w  d7, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
l_1aa34:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d7, $2(a3)
    move.b  d2, $1(a3)
l_1aa42:
    move.l  a4, -(a7)
    move.l  a2, -(a7)
    move.l  a3, -(a7)
    jsr (ProgressGamePhase,PC)
    nop
    lea     $c(a7), a7
l_1aa52:
    movem.l (a7)+, d2-d7/a2-a5
    rts


; === Translated block $01AA58-$01ABB0 ===
; 1 functions, 344 bytes

; ============================================================================
; ProgressGamePhase -- (TODO: name)
; 344 bytes | $01AA58-$01ABAF
; ============================================================================
ProgressGamePhase:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    movea.l $8(a6), a3
    movea.l $10(a6), a1
    movea.l $c(a6), a0
    movea.l  #$00FF153C,a2
    clr.w   d2
l_1aa74:
    cmpa.l  a2, a3
    beq.b   l_1aaa2
    move.b  $1(a3), d0
    cmp.b   $1(a2), d0
    bne.b   l_1aaa2
    move.b  $2(a3), d0
    cmp.b   $2(a2), d0
    bne.b   l_1aaa2
l_1aa8c:
    pea     ($0012).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    jsr MemFillByte
    lea     $c(a7), a7
    bra.w   l_1aba6
l_1aaa2:
    moveq   #$12,d0
    adda.l  d0, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    blt.b   l_1aa74
    moveq   #$0,d2
    move.b  (a0), d2
    moveq   #$0,d0
    move.b  $1(a0), d0
    move.w  d0, -$2(a6)
    moveq   #$0,d6
    move.b  (a1), d6
    moveq   #$0,d7
    move.b  $1(a1), d7
    cmp.w   d6, d2
    bne.b   l_1aad0
    cmp.w   -$2(a6), d7
    beq.b   l_1aa8c
l_1aad0:
    move.w  #$8560, d3
    cmp.w   d6, d2
    bhi.b   l_1aadc
    moveq   #$0,d4
    bra.b   l_1aade
l_1aadc:
    moveq   #$1,d4
l_1aade:
    tst.w   d4
    beq.b   l_1aaec
    moveq   #$0,d4
    move.w  d2, d4
    moveq   #$0,d0
    move.w  d6, d0
    bra.b   l_1aaf4
l_1aaec:
    moveq   #$0,d4
    move.w  d6, d4
    moveq   #$0,d0
    move.w  d2, d0
l_1aaf4:
    sub.l   d0, d4
    move.w  -$2(a6), d5
    sub.w   d7, d5
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    cmp.l   d1, d0
    bgt.b   l_1ab52
    move.w  d4, d0
    ext.l   d0
    bge.b   l_1ab12
    addq.l  #$1, d0
l_1ab12:
    asr.l   #$1, d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_1ab20
    addq.w  #$4, d3
    bra.b   l_1ab52
l_1ab20:
    move.w  d4, d0
    ext.l   d0
    bge.b   l_1ab28
    addq.l  #$1, d0
l_1ab28:
    asr.l   #$1, d0
    neg.l   d0
    move.w  d5, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   l_1ab38
    addq.w  #$8, d3
    bra.b   l_1ab52
l_1ab38:
    move.w  d5, d0
    ext.l   d0
    move.w  d4, d1
    ext.l   d1
    add.l   d1, d1
    neg.l   d1
    cmp.l   d1, d0
    ble.b   l_1ab4e
    addi.w  #$c, d3
    bra.b   l_1ab52
l_1ab4e:
    ori.w   #$1000, d3
l_1ab52:
    cmp.w   d6, d2
    bls.b   l_1ab5e
    move.l  #$800, d0
    bra.b   l_1ab60
l_1ab5e:
    moveq   #$0,d0
l_1ab60:
    or.w    d0, d3
    tst.w   d5
    ble.b   l_1ab6c
    move.w  d5, d0
    ext.l   d0
    bra.b   l_1ab72
l_1ab6c:
    move.w  d5, d0
    ext.l   d0
    neg.l   d0
l_1ab72:
    add.w   d4, d0
    move.w  d0, d4
    cmpi.w  #$80, d4
    bls.b   l_1ab84
    move.l  #$80, d0
    bra.b   l_1ab86
l_1ab84:
    moveq   #$40,d0
l_1ab86:
    move.w  d0, d4
    move.w  d2, $4(a3)
    move.w  -$2(a6), $6(a3)
    move.w  d6, $8(a3)
    move.w  d7, $a(a3)
    clr.w   $c(a3)
    move.w  d4, $e(a3)
    move.w  d3, $10(a3)
l_1aba6:
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts


; ---------------------------------------------------------------------------
AnimateFlightPaths:                                                  ; $01ABB0
    link    a6,#-$20
    movem.l d2-d6/a2-a4,-(sp)
    lea     -$0020(a6),a4
    tst.w   ($00FF000A).l
    beq.w   .l1acb0
    movea.l #$00ff153c,a2
    pea     ($0020).w
    clr.l   -(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $000c(sp),sp
    clr.w   d4
    clr.w   d5
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$3,d0
    lea     (a4,d0.l),a0
    movea.l a0,a3
    bra.w   .l1ac7a
.l1abf2:                                                ; $01ABF2
    cmpi.b  #$ff,$0001(a2)
    beq.w   .l1ac82
    move.w  $000c(a2),d2
    move.w  $000e(a2),d3
    cmp.w   d3,d2
    bcc.b   .l1ac72
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    subq.l  #$1,d0
    move.l  d0,d6
    move.l  d0,-(sp)
    move.w  $0004(a2),d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $0008(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e346                           ; jsr $01E346
    move.w  d0,d3
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $000a(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e346                           ; jsr $01E346
    lea     $0020(sp),sp
    move.w  d0,d2
    addi.w  #$7c,d0
    move.w  d0,(a3)
    move.w  #$0500,$0002(a3)
    move.w  $0010(a2),$0004(a3)
    move.w  d3,d0
    addi.w  #$7c,d0
    move.w  d0,$0006(a3)
    addq.w  #$1,$000c(a2)
    addq.w  #$1,d5
.l1ac72:                                                ; $01AC72
    addq.l  #$8,a3
    addq.w  #$1,d4
    moveq   #$12,d0
    adda.l  d0,a2
.l1ac7a:                                                ; $01AC7A
    cmpi.w  #$4,d4
    bcs.w   .l1abf2
.l1ac82:                                                ; $01AC82
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($0037).w
    pea     ($000F).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0018(sp),sp
    tst.w   d5
    bne.b   .l1acb0
    clr.l   -(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w UpdateFlightSlots
.l1acb0:                                                ; $01ACB0
    movem.l -$0040(a6),d2-d6/a2-a4
    unlk    a6
    rts
; ============================================================================
; DiagonalWipe -- (TODO: describe)
; Called: ?? times.
; 510 bytes | $01ACBA-$01AEB7
; ============================================================================
DiagonalWipe:                                                  ; $01ACBA
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $0028(sp),d4
    move.l  $0024(sp),d5
    move.l  $002c(sp),d7
    movea.l #$0d64,a2
    movea.l #$0001e044,a3
    move.w  #$0750,d6
    clr.w   d2
    clr.w   d3
    cmpi.w  #$1,d7
    bne.w   .l1adb8
    lsl.w   #$3,d5
    addi.w  #$3c,d5
    lsl.w   #$3,d4
    addi.w  #$a,d4
    pea     ($0004).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
    bra.b   .l1ad46
.l1ad00:                                                ; $01AD00
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$2,d0
    add.w   d0,d2
.l1ad46:                                                ; $01AD46
    cmpi.w  #$14,d2
    blt.b   .l1ad00
    bra.b   .l1adae
.l1ad4e:                                                ; $01AD4E
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
    addq.w  #$1,d2
    addq.w  #$1,d3
.l1adae:                                                ; $01ADAE
    cmpi.w  #$22,d3
    blt.b   .l1ad4e
    bra.w   .l1ae9a
.l1adb8:                                                ; $01ADB8
    move.w  d5,d0
    lsl.w   #$3,d0
    move.w  d0,d5
    move.w  d4,d0
    lsl.w   #$3,d0
    move.w  d0,d4
    pea     ($0005).w
    dc.w    $4eb9,$0001,$d444                           ; jsr $01D444
    addq.l  #$4,sp
    bra.b   .l1ae3c
.l1add2:                                                ; $01ADD2
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$36,d1
    sub.l   d0,d1
    move.l  d1,d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d3
.l1ae3c:                                                ; $01AE3C
    cmpi.w  #$22,d3
    blt.b   .l1add2
    bra.b   .l1ae94
.l1ae44:                                                ; $01AE44
    pea     ($0800).w
    pea     ($0002).w
    pea     ($0002).w
    move.w  d4,d0
    ext.l   d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    move.w  d2,d1
    ext.l   d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000F).w
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a3)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.w  d2,d0
    ext.l   d0
    moveq   #$14,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    addq.w  #$1,d0
    add.w   d0,d2
    addq.w  #$1,d2
.l1ae94:                                                ; $01AE94
    cmpi.w  #$36,d2
    blt.b   .l1ae44
.l1ae9a:                                                ; $01AE9A
    pea     ($0018).w
    jsr     (a2)
    pea     ($0001).w
    pea     ($000F).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    lea     $000c(sp),sp
    movem.l (sp)+,d2-d7/a2-a3
    rts
ShowPlayerCompare:                                                  ; $01AEB8
    link    a6,#$0
    movem.l d2-d7/a2,-(sp)
    move.l  $001c(a6),d5
    move.l  $0010(a6),d6
    move.l  $0008(a6),d7
    movea.l #$0d64,a2
    cmp.w   d6,d7
    bne.b   .l1aee2
    move.w  #$0770,d4
    move.w  #$0771,d3
    bra.w   .l1af88
.l1aee2:                                                ; $01AEE2
    move.w  #$0772,d4
    move.w  #$0773,d3
    bra.w   .l1af88
.l1aeee:                                                ; $01AEEE
    cmpi.w  #$1,d2
    bne.b   .l1af6c
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $000e(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d7,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0039).w
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    move.l  #$8000,-(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  $0016(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($003A).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0024(sp),sp
    clr.w   d2
    bra.b   .l1af8a
.l1af6c:                                                ; $01AF6C
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    lea     $0010(sp),sp
.l1af88:                                                ; $01AF88
    moveq   #$1,d2
.l1af8a:                                                ; $01AF8A
    pea     ($000A).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    addq.l  #$4,sp
    move.w  d0,d5
    ext.l   d0
    moveq   #$0,d1
    move.w  $001a(a6),d1
    and.l   d1,d0
    beq.w   .l1aeee
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4eb9,$0001,$e0b8                           ; jsr $01E0B8
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a2)
    move.w  d5,d0
    movem.l -$001c(a6),d2-d7/a2
    unlk    a6
    rts
; ---------------------------------------------------------------------------
GetModeRowOffset:                                                  ; $01AFCA
    move.l  $0008(sp),d1
    tst.w   d1
    bne.b   .l1afd6
    moveq   #$2a,d1
    bra.b   .l1afec
.l1afd6:                                                ; $01AFD6
    cmpi.w  #$1,d1
    bne.b   .l1afe0
    moveq   #$26,d1
    bra.b   .l1afec
.l1afe0:                                                ; $01AFE0
    cmpi.w  #$2,d1
    bne.b   .l1afea
    moveq   #$22,d1
    bra.b   .l1afec
.l1afea:                                                ; $01AFEA
    moveq   #$19,d1
.l1afec:                                                ; $01AFEC
    move.w  d1,d0
    rts
; ============================================================================
; DrawCharDetailPanel -- (TODO: describe)
; Called: ?? times.
; 222 bytes | $01AFF0-$01B0CD
; ============================================================================
DrawCharDetailPanel:                                                  ; $01AFF0
    movem.l d2-d3/a2-a3,-(sp)
    move.l  $001c(sp),d3
    movea.l #$0004978c,a2
    movea.l #$0d64,a3
    moveq   #$1,d2
    pea     ($0040).w
    clr.l   -(sp)
    pea     ($0010).w
    jsr     (a3)
    pea     ($0010).w
    pea     ($0010).w
    move.l  a2,d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $0018(sp),sp
    move.l  a2,d0
    moveq   #$22,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    pea     ($000A).w
    pea     ($001E).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    pea     ($0001).w
    clr.l   -(sp)
    move.l  a2,d0
    addi.l  #$027a,d0
    move.l  d0,-(sp)
    pea     ($0009).w
    pea     ($0001).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0030(sp),sp
    move.l  ($000A1AE8).l,-(sp)
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0037).w
    pea     ($06B4).w
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$4668                           ; jsr $004668
    pea     ($00070F78).l
    pea     ($0008).w
    pea     ($000E).w
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addi.l  #$f,d0
    move.l  d0,-(sp)
    pea     ($0001).w
    pea     ($001B).w
    jsr     (a3)
    lea     $0030(sp),sp
    movem.l (sp)+,d2-d3/a2-a3
    rts
; ============================================================================
; ShowCharStats -- (TODO: describe)
; Called: ?? times.
; 598 bytes | $01B0CE-$01B323
; ============================================================================
ShowCharStats:                                                  ; $01B0CE
    link    a6,#-$80
    movem.l d2-d5/a2-a5,-(sp)
    move.l  $0014(a6),d3
    move.l  $000c(a6),d4
    move.l  $0008(a6),d5
    lea     -$0080(a6),a4
    movea.l #$0003b270,a5
    moveq   #$1,d2
    clr.l   -(sp)
    pea     ($0008).w
    pea     ($000E).w
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $001a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$1,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$a5a8                           ; jsr $03A5A8
    lea     $0018(sp),sp
    addi.w  #$f,d2
    addq.w  #$1,d3
    move.w  d4,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d5,d0
    lsl.w   #$5,d0
    move.w  d4,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.l   -(sp)
    pea     ($0008).w
    pea     ($000E).w
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addq.w  #$8,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.w  $0002(a2),d0
    move.l  d0,-(sp)
    pea     ($0004114E).l
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$2,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addi.w  #$9,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    mulu.w  #$a,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($0004114A).l
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addq.w  #$4,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0008(a2),d0
    moveq   #$64,d1
    sub.w   d0,d1
    move.l  d1,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($00041146).l
    jsr     (a5)
    lea     $0030(sp),sp
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addi.w  #$b,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0009(a2),d0
    moveq   #$64,d1
    sub.w   d0,d1
    move.l  d1,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($00041142).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    move.l  a4,-(sp)
    pea     ($0004113E).l
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addq.w  #$4,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  (a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    sub.l   d1,d0
    move.l  d0,-(sp)
    pea     ($0004113A).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    lea     $0030(sp),sp
    move.l  a4,-(sp)
    pea     ($00041136).l
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$6,d0
    move.l  d0,-(sp)
    move.w  d2,d0
    addi.w  #$b,d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $0001(a3),d0
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    pea     ($00041132).l
    move.l  a4,-(sp)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    move.l  a4,-(sp)
    pea     ($0004112E).l
    jsr     (a5)
    movem.l -$00a0(a6),d2-d5/a2-a5
    unlk    a6
    rts
; ============================================================================
; MatchCharSlots -- (TODO: describe)
; 374 bytes | $01B324-$01B499
; ============================================================================
MatchCharSlots:                                                  ; $01B324
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0030(sp),d2
    move.l  $002c(sp),d4
    move.l  $0028(sp),d7
    movea.l #$957c,a4
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d6
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$8,sp
    move.w  d0,d5
    cmp.w   d5,d6
    bne.b   .l1b39e
    clr.w   d3
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff8804,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
.l1b36e:                                                ; $01B36E
    move.w  #$ff,(a2)
    cmp.w   d7,d3
    beq.b   .l1b390
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $000c(sp),sp
    move.w  d0,(a2)
.l1b390:                                                ; $01B390
    addq.l  #$2,a2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l1b36e
    bra.w   .l1b494
.l1b39e:                                                ; $01B39E
    clr.w   d3
    move.w  d3,d0
    add.w   d0,d0
    movea.l #$00ff8804,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
.l1b3b0:                                                ; $01B3B0
    move.w  #$ff,(a3)
    cmp.w   d7,d3
    beq.w   .l1b488
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$ff,d0
    beq.b   .l1b422
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l1b412
.l1b3ea:                                                ; $01B3EA
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $000c(sp),sp
    move.w  d0,(a3)
    cmpi.w  #$ff,d0
    bne.b   .l1b488
    addq.w  #$1,d2
.l1b412:                                                ; $01B412
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    cmp.l   d1,d0
    blt.b   .l1b3ea
    bra.b   .l1b488
.l1b422:                                                ; $01B422
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    move.w  d0,d4
    cmpi.w  #$ff,d0
    beq.b   .l1b488
    move.w  d6,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l1b47a
.l1b452:                                                ; $01B452
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    jsr     (a4)
    lea     $000c(sp),sp
    move.w  d0,(a3)
    cmpi.w  #$ff,d0
    bne.b   .l1b488
    addq.w  #$1,d2
.l1b47a:                                                ; $01B47A
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    cmp.l   d1,d0
    blt.b   .l1b452
.l1b488:                                                ; $01B488
    addq.l  #$2,a3
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.w   .l1b3b0
.l1b494:                                                ; $01B494
    movem.l (sp)+,d2-d7/a2-a4
    rts
; === Translated block $01B49A-$01C43C ===
; 6 functions, 4002 bytes

; ============================================================================
; GameUpdate2 -- (TODO: name)
; 1152 bytes | $01B49A-$01B919
; ============================================================================
GameUpdate2:
    link    a6,#-$20
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0016,a5
    clr.w   d5
    move.w  #$80, ($00FFBD64).l
    move.w  #$80, ($00FFBD66).l
    tst.w   ($00FF17C4).l
    bne.b   l_1b4c8
    jsr RunEventSequence
l_1b4c8:
    tst.w   ($00FF17C4).l
    bne.b   l_1b52e
    move.w  #$fffe, ($00FF0A32).l
    jsr RunScenarioMenu
    jsr ResourceUnload
    clr.w   d2
    clr.w   d3
    bra.b   l_1b524
l_1b4ea:
    pea     ($0003).w
    clr.l   -(a7)
    jsr RandRange
    addq.l  #$8, a7
    move.b  d0, (a5)
    moveq   #$0,d0
    move.b  (a5), d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    and.l   d1, d0
    bne.b   l_1b524
    moveq   #$0,d0
    move.b  (a5), d0
    moveq   #$1,d1
    lsl.w   d0, d1
    move.l  d1, d0
    or.w    d0, d3
    movea.l  #$00FF0012,a0
    move.b  (a5), (a0,d2.w)
    addq.w  #$1, d2
l_1b524:
    cmpi.w  #$4, d2
    blt.b   l_1b4ea
    clr.w   d2
    bra.b   l_1b544
l_1b52e:
    clr.w   d2
    move.b  (a5), d3
    bra.b   l_1b536
l_1b534:
    addq.w  #$1, d2
l_1b536:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), d0
    cmp.b   d3, d0
    bne.b   l_1b534
l_1b544:
    clr.w   ($00FF9A1C).l
    move.w  -$2(a6), d4
    lea     -$2(a6), a4
    bra.w   l_1b892
l_1b556:
    movea.l  #$00FF0012,a0
    move.b  (a0,d2.w), (a5)
    moveq   #$0,d0
    move.b  (a5), d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    cmpi.w  #$7, ($00FF9A1C).l
    beq.w   l_1b62a
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.b  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    pea     ($0007).w
    jsr SelectMenuItem
    pea     ($0001).w
    jsr CmdSetBackground
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    lea     $30(a7), a7
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    lea     $10(a7), a7
    move.w  #$7, ($00FF9A1C).l
    jsr ResourceUnload
    bra.w   l_1b7a6
l_1b62a:
    jsr ResourceLoad
    jsr PreLoopInit
    moveq   #$0,d0
    move.b  (a5), d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d4
    pea     ($0001).w
    pea     ($000F).w
    move.l  a4, -(a7)
    jsr DisplaySetup
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    lea     $28(a7), a7
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    lea     $10(a7), a7
    jsr ResourceUnload
    cmpi.b  #$1, (a3)
    bne.w   l_1b7a6
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E948,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
l_1b6d2:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    addq.w  #$1, d3
    cmpi.w  #$5, d3
    blt.b   l_1b6d2
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    subq.l  #$4, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0001).w
    jsr GameCmd16
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $10(a7), a7
l_1b7a6:
    tst.w   ($00FF17C4).l
    bne.b   l_1b7c6
    jsr RunAITurn
    cmpi.w  #$ffff, ($00FF0A32).l
    beq.b   l_1b7cc
    jsr RunScenarioMenu
    bra.b   l_1b7cc
l_1b7c6:
    jsr PreLoopInit
l_1b7cc:
    cmpi.b  #$1, (a3)
    bne.w   l_1b864
    jsr ResourceLoad
    moveq   #$0,d0
    move.b  $1(a3), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, ($00FF9A1C).l
    ext.l   d0
    move.l  d0, -(a7)
    jsr SelectMenuItem
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RunMainMenu,PC)
    nop
    jsr ResourceUnload
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ValidateMenuInput,PC)
    nop
    lea     $2c(a7), a7
    moveq   #$1,d5
    bra.b   l_1b88a
l_1b864:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    jsr RunAIStrategy
    pea     ($003C).w
    jsr PollInputChange
    lea     $10(a7), a7
    clr.w   d5
l_1b88a:
    clr.w   ($00FF17C4).l
    addq.w  #$1, d2
l_1b892:
    cmpi.w  #$4, d2
    blt.w   l_1b556
    move.w  d4, -$2(a6)
    cmpi.w  #$1, d5
    bne.b   l_1b900
    jsr ResourceLoad
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0007).w
    jsr SelectMenuItem
    jsr PreLoopInit
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $30(a7), a7
    jsr ResourceUnload
    bra.b   l_1b910
l_1b900:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
l_1b910:
    movem.l -$40(a6), d2-d5/a2-a5
    unlk    a6
    rts

; ============================================================================
; RunMainMenu -- (TODO: name)
; 134 bytes | $01B91A-$01B99F
; ============================================================================
RunMainMenu:
    link    a6,#-$4
    movem.l d2-d3, -(a7)
    move.l  $8(a6), d2
    move.w  ($00FF9A1C).l, d3
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    lea     $20(a7), a7
    pea     ($077D).w
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr GameCommand
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (RenderDisplayBuffer,PC)
    nop
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ShowPlayerInfo,PC)
    nop
    movem.l -$c(a6), d2-d3
    unlk    a6
    rts

; ============================================================================
; HandleMenuSelection -- (TODO: name)
; 124 bytes | $01B9A0-$01BA1B
; ============================================================================
HandleMenuSelection:
    link    a6,#$0
    pea     ($0006).w
    pea     ($06A0).w
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$6, d0
    add.l   ($000A1B58).l, d0
    move.l  d0, -(a7)
    jsr CmdPlaceTile
    move.w  $12(a6), d0
    ext.l   d0
    lsl.l   #$3, d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    move.w  $e(a6), d0
    ext.l   d0
    lsl.l   #$3, d0
    subq.l  #$8, d0
    move.l  d0, -(a7)
    pea     ($00047CE4).l
    pea     ($0001).w
    pea     ($0039).w
    pea     ($000F).w
    jsr GameCommand
    pea     ($000A).w
    pea     ($000E).w
    jsr GameCommand
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0039).w
    jsr GameCmd16
    unlk    a6
    rts

; ============================================================================
; DisplayMenuOption -- (TODO: name)
; 274 bytes | $01BA1C-$01BB2D
; ============================================================================
DisplayMenuOption:
    link    a6,#$0
    movem.l d2/a2-a4, -(a7)
    move.l  $10(a6), d2
    movea.l  #$00000D64,a3
    movea.l  #$0001E044,a4
    cmpi.w  #$20, d2
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    cmp.w   $e(a6), d0
    bne.w   l_1bafa
    cmpi.w  #$1, $16(a6)
    bne.w   l_1bafa
    clr.w   d2
l_1ba6a:
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    lea     $24(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$5, d2
    blt.b   l_1ba6a
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0766).w
    bra.b   l_1bb18
l_1bafa:
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    pea     ($0001).w
    clr.l   -(a7)
l_1bb18:
    jsr     (a4)
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a3)
    movem.l -$10(a6), d2/a2-a4
    unlk    a6
    rts

; ============================================================================
; ValidateMenuInput -- (TODO: name)
; 158 bytes | $01BB2E-$01BBCB
; ============================================================================
ValidateMenuInput:
    link    a6,#$0
    movem.l d2-d3/a2, -(a7)
    move.l  $8(a6), d3
    lea     $e(a6), a2
    clr.w   d2
    clr.w   ($00FF14B8).l
    bra.b   l_1bba0
l_1bb48:
    move.w  (a2), ($00FF9A1C).l
    move.w  d2, d0
    andi.l  #$8000, d0
    bne.b   l_1bb7a
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (PrepareRelationPush,PC)
    nop
    addq.l  #$8, a7
    cmpi.w  #$b, d0
    beq.b   l_1bbc2
    move.w  ($00FF9A1C).l, (a2)
    bra.b   l_1bb94
l_1bb7a:
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ExecMenuCommand,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, (a2)
    andi.w  #$7fff, d2
l_1bb94:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    addq.l  #$4, a7
l_1bba0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    pea     $e(a6)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (ProcessCharTrade,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$b, d0
    bne.b   l_1bb48
l_1bbc2:
    movem.l -$c(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; ExecMenuCommand -- (TODO: name)
; 1730 bytes | $01BBCC-$01C28D
; ============================================================================
ExecMenuCommand:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d5
    move.l  $8(a6), d6
    movea.l  #$00000D64,a5
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    movea.l  #$00FFBD64,a2
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    cmp.w   d5, d0
    bne.b   l_1bc44
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E9FA,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    add.w   d0, d0
    movea.l  #$0005E9FB,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    move.w  d0, $2(a2)
l_1bc44:
    move.w  #$ff, d3
    move.w  #$ff, d0
    move.w  d0, d7
    move.w  d0, -$2(a6)
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $28(a7), a7
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($0008).w
    pea     ($0020).w
    pea     ($0014).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
l_1bd64:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$c0, d0
    bne.b   l_1bd64
    movea.l  #$0004DFB8,a3
    movea.l  #$0004DD9C,a4
l_1bd84:
    jsr ResourceUnload
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr HitTestMapTile
    addq.l  #$8, a7
    move.w  d0, d2
    cmp.w   -$2(a6), d2
    beq.b   l_1bdfe
    cmpi.w  #$ff, d3
    bne.b   l_1bdfa
    cmpi.w  #$ff, d2
    beq.b   l_1bdce
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
    bra.b   l_1bdfa
l_1bdce:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    lea     $24(a7), a7
l_1bdfa:
    move.w  d2, -$2(a6)
l_1bdfe:
    cmp.w   d2, d7
    beq.w   l_1beba
    cmpi.w  #$ff, d3
    beq.w   l_1beb8
    cmpi.w  #$ff, d2
    beq.b   l_1be66
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (AllocGraphicsMemory,PC)
    nop
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $30(a7), a7
    bra.b   l_1beb8
l_1be66:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0010).w
    pea     ($0013).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0004).w
    pea     ($0011).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    lea     $24(a7), a7
l_1beb8:
    move.w  d2, d7
l_1beba:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  $2(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  (a2), d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $24(a7), a7
l_1bef0:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$ff, d0
    beq.b   l_1bef0
    move.w  d4, d0
    andi.w  #$f, d0
    beq.b   l_1bf48
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    jsr AdjustScrollPos
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a5)
    lea     $20(a7), a7
    bra.w   l_1bd84
l_1bf48:
    move.w  d4, d0
    andi.w  #$40, d0
    beq.b   l_1bf80
    cmpi.w  #$ff, d3
    beq.b   l_1bf72
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $10(a7), a7
l_1bf72:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0017).w
    bra.w   l_1c26c
l_1bf80:
    move.w  d4, d0
    andi.w  #$80, d0
    beq.w   l_1c05a
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    lea     $24(a7), a7
    move.w  d0, d2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a4, -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    lea     $14(a7), a7
    cmpi.w  #$ff, d2
    beq.b   l_1c052
    move.w  d2, d5
    cmpi.w  #$ff, d3
    beq.b   l_1c052
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $14(a7), a7
l_1c052:
    move.w  #$ff, d7
    bra.w   l_1bd84
l_1c05a:
    move.w  d4, d0
    andi.w  #$20, d0
    beq.w   l_1c1ae
    cmpi.w  #$ff, d2
    beq.w   l_1bd84
    cmpi.w  #$ff, d3
    bne.b   l_1c0c2
    pea     ($0001).w
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $1c(a7), a7
    move.w  d2, d3
l_1c0aa:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$20, d0
    bne.b   l_1c0aa
    bra.w   l_1bd84
l_1c0c2:
    cmp.w   d2, d3
    bne.w   l_1bd84
    clr.l   -(a7)
    move.w  $2(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr (UpdateCharRelation,PC)
    nop
    pea     ($0004).w
    pea     ($003B).w
    jsr GameCmd16
    lea     $20(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.l  a4, -(a7)
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a5)
    move.l  a3, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $28(a7), a7
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $10(a7), a7
    bra.w   l_1c052
l_1c1ae:
    move.w  d4, d0
    andi.w  #$10, d0
    beq.w   l_1bd84
    cmpi.w  #$ff, d3
    beq.w   l_1c262
    pea     ($0002).w
    pea     ($0039).w
    jsr GameCmd16
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    lea     $18(a7), a7
    cmp.w   d3, d2
    bne.b   l_1c212
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($000B).w
    pea     ($0013).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $1c(a7), a7
    move.w  #$ff, d7
    bra.b   l_1c246
l_1c212:
    pea     ($0002).w
    pea     ($0037).w
    jsr GameCmd16
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    lea     $24(a7), a7
    move.w  #$ff, d7
    move.w  d7, -$2(a6)
l_1c246:
    move.w  #$ff, d3
l_1c24a:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$10, d0
    bne.b   l_1c24a
    bra.w   l_1bd84
l_1c262:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0019).w
l_1c26c:
    pea     ($0013).w
    pea     ($0004).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a5)
    jsr ClearCharSprites
    move.w  d5, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

PrepareRelationPush:                                         ; $01C28E
    dc.w    $2F02                                            ; move.w d1,-(sp) [thunk before callee]

; === Translated block $01C290-$01C43C ===
; 2 functions, 428 bytes

; ============================================================================
; CalcRelationship -- (TODO: name)
; 178 bytes | $01C290-$01C341
; ============================================================================
CalcRelationship:
    move.l  $c(a7), d2
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    cmp.l   d1, d0
    bhi.w   l_1c33c
    add.l   d0, d0
    dc.w    $303B,$0806                                 ; move.w (6,pc,d0.l),d0
    dc.w    $4EFB,$0002                                 ; jmp (pc,d0.w)
    dc.w    $0016
    dc.w    $001E
    dc.w    $0046
    dc.w    $002E
    dc.w    $004E
    dc.w    $005E
    dc.w    $0026
    dc.w    $0056
    dc.w    $0036
    dc.w    $0066
    dc.w    $006E
    jsr RecruitCharacter
    bra.b   l_1c33c
    jsr ProcessCharActions
    bra.b   l_1c33c
    jsr ProcessRouteAction
    bra.b   l_1c33c
    jsr RunPurchaseMenu
    bra.b   l_1c33c
    jsr ShowQuarterReport
    move.w  #$1, ($00FF14B8).l
    bra.b   l_1c33c
    jsr BuildRouteLoop
    bra.b   l_1c33c
    jsr RunTurnSequence
    bra.b   l_1c33c
    jsr ShowQuarterSummary
    bra.b   l_1c33c
    jsr RunPlayerTurn
    bra.b   l_1c33c
    jsr RunQuarterScreen
    bra.b   l_1c33c
    jsr RunGameMenu
    cmpi.w  #$1, d0
    bne.b   l_1c33c
    moveq   #$B,d2
l_1c33c:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; UpdateCharRelation -- (TODO: name)
; 250 bytes | $01C342-$01C43B
; ============================================================================
UpdateCharRelation:
    link    a6,#-$4
    movem.l d2-d7, -(a7)
    move.l  $10(a6), d2
    move.l  $8(a6), d7
    move.w  d2, d0
    ori.w   #$8000, d0
    move.w  d0, ($00FFA6B0).l
    jsr ShowGameScreen
    jsr ResourceUnload
    cmpi.w  #$20, d2
    bge.b   l_1c374
    moveq   #$6,d6
    bra.b   l_1c376
l_1c374:
    moveq   #$4,d6
l_1c376:
    move.w  #$e2, d5
    bra.b   l_1c3b8
l_1c37c:
    moveq   #$11,d4
    moveq   #$8,d3
    clr.w   d2
    bra.b   l_1c3a0
l_1c384:
    move.w  d2, d0
    ext.l   d0
    add.l   -$4(a6), d0
    movea.l d0, a0
    move.b  (a0), d0
    addq.w  #$5, d3
    move.w  d3, d0
    cmpi.w  #$12, d0
    blt.b   l_1c39e
    addq.w  #$6, d4
    moveq   #$8,d3
l_1c39e:
    addq.w  #$1, d2
l_1c3a0:
    cmp.w   d6, d2
    blt.b   l_1c384
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    moveq   #$2,d0
    eor.w   d0, d5
l_1c3b8:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   l_1c37c
l_1c3ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.l  #$10, d0
    beq.b   l_1c3ce
    jsr ResourceLoad
    jsr PreLoopInit
    pea     ($0001).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  $e(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d7, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    jsr ResourceUnload
    movem.l -$1c(a6), d2-d7
    unlk    a6
    rts


; ============================================================================
; ShowPlayerInfo -- Display player info screen with formatted data
; Called: 12 times.
; 274 bytes | $01C43C-$01C54D
; ============================================================================
ShowPlayerInfo:                                                  ; $01C43C
    movem.l d2/a2,-(sp)
    move.l  $000c(sp),d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    pea     ($000F).w
    move.w  d2,d0
    add.w   d0,d0
    movea.l #$00076520,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    pea     ($0004975E).l
    pea     ($00FF1804).l
    dc.w    $4eb9,$0000,$3fec                           ; jsr $003FEC
    pea     ($0001).w
    clr.l   -(sp)
    pea     ($00FF1804).l
    pea     ($0008).w
    pea     ($0328).w
    dc.w    $4eb9,$0001,$d568                           ; jsr $01D568
    lea     $0028(sp),sp
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    clr.l   -(sp)
    pea     ($001A).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $001c(sp),sp
    pea     ($00049706).l
    pea     ($0002).w
    pea     ($0016).w
    pea     ($0019).w
    pea     ($0009).w
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0003,$a942                           ; jsr $03A942
    lea     $002c(sp),sp
    pea     ($0019).w
    pea     ($000A).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($00041158).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0019).w
    pea     ($0013).w
    dc.w    $4eb9,$0003,$ab2c                           ; jsr $03AB2C
    move.l  $0006(a2),-(sp)
    pea     ($00041152).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    lea     $0020(sp),sp
    movem.l (sp)+,d2/a2
    rts
; === Translated block $01C54E-$01D310 ===
; 6 functions, 3522 bytes

; ============================================================================
; EvalCharMatch -- (TODO: name)
; 248 bytes | $01C54E-$01C645
; ============================================================================
EvalCharMatch:
    movem.l d2/a2-a3, -(a7)
    movea.l  #$00FF0018,a3
    jsr ResourceUnload
    pea     ($0003).w
    pea     ($001D).w
    pea     ($0012).w
    pea     ($0002).w
    jsr DrawBox
    lea     $10(a7), a7
l_1c578:
    movea.l a3, a2
    clr.w   d2
l_1c57c:
    pea     ($0013).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, d1
    lsl.l   #$3, d0
    sub.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    jsr SetTextCursor
    cmpi.b  #$1, (a2)
    bne.b   l_1c5aa
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($00041164).l
    bra.b   l_1c5b8
l_1c5aa:
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0004115C).l
l_1c5b8:
    jsr PrintfNarrow
    lea     $10(a7), a7
    addq.w  #$1, d2
    moveq   #$24,d0
    adda.l  d0, a2
    cmpi.w  #$4, d2
    blt.b   l_1c57c
l_1c5ce:
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d2
    andi.l  #$d0, d0
    beq.b   l_1c5ce
    move.w  d2, d0
    andi.w  #$40, d0
    beq.b   l_1c5f6
    movea.l a3, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c5f6:
    move.w  d2, d0
    andi.w  #$10, d0
    beq.b   l_1c608
    movea.l a3, a2
    moveq   #$48,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c608:
    move.w  d2, d0
    andi.w  #$40, d0
    beq.b   l_1c61a
    movea.l a3, a2
    moveq   #$24,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c61a:
    move.w  d2, d0
    andi.w  #$80, d0
    beq.b   l_1c62c
    movea.l a3, a2
    moveq   #$6C,d0
    adda.l  d0, a2
    moveq   #$1,d0
    eor.b   d0, (a2)
l_1c62c:
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
    bra.w   l_1c578
    movem.l (a7)+, d2/a2-a3
    rts

; ============================================================================
; ProcessCharTrade -- (TODO: name)
; 1340 bytes | $01C646-$01CB81
; ============================================================================
ProcessCharTrade:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d7
    movea.l $c(a6), a2
    movea.l  #$00FF13FC,a3
    movea.l  #$00000D64,a4
    movea.l  #$00FFA7D8,a5
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedMod
    move.l  d0, d6
    mulu.w  #$3, d6
    addi.w  #$e, d6
    moveq   #$0,d0
    move.w  d7, d0
    moveq   #$6,d1
    jsr SignedDiv
    move.l  d0, d5
    add.w   d5, d5
    addi.w  #$16, d5
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $30(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    jsr ResourceUnload
    jsr InitFlightDisplay
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    clr.l   -(a7)
    jsr ReadInput
    lea     $30(a7), a7
    tst.w   d0
    beq.b   l_1c73e
    moveq   #$1,d4
    bra.b   l_1c740
l_1c73e:
    moveq   #$0,d4
l_1c740:
    clr.w   d3
    clr.w   (a3)
    clr.w   (a5)
l_1c746:
    tst.w   d4
    beq.b   l_1c774
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    tst.w   d0
    beq.b   l_1c774
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
    bra.b   l_1c746
l_1c774:
    clr.w   d4
    cmpi.w  #$1, (a3)
    bne.b   l_1c7be
    tst.w   (a5)
    bne.b   l_1c7be
    moveq   #$A,d2
    bra.b   l_1c7b6
l_1c784:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    andi.l  #$ffff, d0
    move.w  d3, d1
    ext.l   d1
    cmp.l   d1, d0
    bne.b   l_1c7be
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
l_1c7b6:
    move.l  d2, d0
    subq.w  #$1, d2
    tst.w   d0
    bne.b   l_1c784
l_1c7be:
    cmpi.w  #$1, (a3)
    bne.b   l_1c7c8
    move.w  #$1, (a5)
l_1c7c8:
    clr.l   -(a7)
    jsr ReadInput
    addq.l  #$4, a7
    move.w  d0, d3
    ext.l   d0
    moveq   #$8,d1
    cmp.w   d1, d0
    beq.b   l_1c814
    moveq   #$4,d1
    cmp.w   d1, d0
    beq.b   l_1c834
    moveq   #$2,d1
    cmp.w   d1, d0
    beq.b   l_1c850
    moveq   #$1,d1
    cmp.w   d1, d0
    beq.w   l_1c870
    moveq   #$20,d1
    cmp.w   d1, d0
    beq.w   l_1c88c
    moveq   #$40,d1
    cmp.w   d1, d0
    beq.w   l_1c8de
    cmpi.w  #$80, d0
    beq.w   l_1c8e8
    moveq   #$10,d1
    cmp.w   d1, d0
    beq.w   l_1c9d8
    bra.w   l_1cb14
l_1c814:
    move.w  #$1, (a3)
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    moveq   #$1D,d1
    cmp.l   d0, d1
    ble.b   l_1c82c
    move.w  d6, d0
    ext.l   d0
    addq.l  #$3, d0
    bra.b   l_1c82e
l_1c82c:
    moveq   #$1D,d0
l_1c82e:
    move.w  d0, d6
    bra.w   l_1cb18
l_1c834:
    move.w  #$1, (a3)
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0
    moveq   #$E,d1
    cmp.l   d0, d1
    bge.b   l_1c84c
    move.w  d6, d0
    ext.l   d0
    subq.l  #$3, d0
    bra.b   l_1c82e
l_1c84c:
    moveq   #$E,d0
    bra.b   l_1c82e
l_1c850:
    move.w  #$1, (a3)
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    moveq   #$18,d1
    cmp.l   d0, d1
    ble.b   l_1c868
    move.w  d5, d0
    ext.l   d0
    addq.l  #$2, d0
    bra.b   l_1c86a
l_1c868:
    moveq   #$18,d0
l_1c86a:
    move.w  d0, d5
    bra.w   l_1cb18
l_1c870:
    move.w  #$1, (a3)
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0
    moveq   #$16,d1
    cmp.l   d0, d1
    bge.b   l_1c888
    move.w  d5, d0
    ext.l   d0
    subq.l  #$2, d0
    bra.b   l_1c86a
l_1c888:
    moveq   #$16,d0
    bra.b   l_1c86a
l_1c88c:
    clr.w   (a3)
    clr.w   (a5)
    move.w  d5, d0
    ext.l   d0
    subi.l  #$16, d0
    bge.b   l_1c89e
    addq.l  #$1, d0
l_1c89e:
    asr.l   #$1, d0
    move.l  d0, d7
    mulu.w  #$6, d7
    move.l  d7, -(a7)
    move.w  d6, d0
    ext.l   d0
    subi.l  #$e, d0
    moveq   #$3,d1
    jsr SignedDiv
    add.l   (a7)+, d0
    move.w  d0, d7
    move.w  d5, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    move.l  d0, -(a7)
    move.w  d7, d0
    move.l  d0, -(a7)
    bsr.w HandleMenuSelection
    lea     $c(a7), a7
l_1c8d2:
    jsr ClearFlightSlots
    move.w  d7, d0
    bra.w   l_1cb78
l_1c8de:
    clr.w   (a3)
    clr.w   (a5)
    ori.w   #$8000, d7
    bra.b   l_1c8d2
l_1c8e8:
    clr.w   (a3)
    clr.w   (a5)
    jsr ClearFlightSlots
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a4)
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    move.w  d0, d2
    cmpi.w  #$ff, d2
    beq.b   l_1c92e
    cmp.w   (a2), d2
    beq.b   l_1c92e
    move.w  d2, (a2)
l_1c92e:
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $30(a7), a7
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    lea     $28(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $2c(a7), a7
    jsr ResourceUnload
    bra.w   l_1cb18
l_1c9d8:
    clr.w   (a3)
    clr.w   (a5)
    jsr ClearFlightSlots
    jsr ResourceLoad
    move.w  #$7, ($00FF9A1C).l
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a4)
    pea     ($0040).w
    clr.l   -(a7)
    jsr CmdSetBackground
    pea     ($0001).w
    clr.l   -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreenGfx
    pea     ($0002).w
    pea     ($0007).w
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w ShowPlayerInfo
    lea     $30(a7), a7
    jsr ResourceUnload
    clr.w   d3
l_1ca4a:
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    jsr ProcessInputLoop
    addq.l  #$8, a7
    andi.l  #$90, d0
    beq.b   l_1ca4a
    jsr ResourceLoad
    move.w  (a2), ($00FF9A1C).l
    pea     ($0001).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  ($00FF9A1C).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    move.l  ($000A1B54).l, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    pea     ($0047).w
    pea     ($02E1).w
    pea     ($00FF1804).l
    jsr CmdPlaceTile
    lea     $30(a7), a7
    pea     ($00072DCC).l
    pea     ($0004).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000D).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a4)
    pea     ($0001).w
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr UpdateFlightSlots
    lea     $24(a7), a7
    jsr ResourceUnload
l_1cb14:
    clr.w   (a3)
    clr.w   (a5)
l_1cb18:
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    lsl.l   #$3, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    pea     ($0740).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $24(a7), a7
    clr.w   d2
l_1cb52:
    move.w  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr AnimateFlightPaths
    pea     ($0001).w
    pea     ($000E).w
    jsr     (a4)
    lea     $c(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1cb52
    bra.w   l_1c746
l_1cb78:
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; RenderDisplayBuffer -- (TODO: name)
; 700 bytes | $01CB82-$01CE3D
; ============================================================================
RenderDisplayBuffer:
    link    a6,#-$40
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d5
    move.l  $c(a6), d6
    movea.l  #$0004A5B8,a4
    lea     -$1e(a6), a5
    pea     ($0010).w
    pea     -$10(a6)
    clr.l   -(a7)
    move.l  a4, d0
    moveq   #$12,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    clr.l   -(a7)
    jsr MemCopy
    clr.w   d2
l_1cbb8:
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$00FFA6A0,a0
    move.l  (a0,d0.w), d0
    move.w  d2, d1
    lsl.w   #$2, d1
    movea.l  #$0005ECDC,a0
    and.l   (a0,d1.w), d0
    beq.b   l_1cbec
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), d0
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$10(a6, d1.w)
l_1cbec:
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    blt.b   l_1cbb8
    pea     ($0010).w
    pea     ($0030).w
    move.l  a4, d0
    addq.l  #$2, d0
    move.l  d0, -(a7)
    jsr DisplaySetup
    move.l  a4, d0
    addi.l  #$82, d0
    move.l  d0, -(a7)
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $28(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0025).w
    pea     ($0330).w
    jsr VRAMBulkLoad
    move.l  a4, d0
    moveq   #$22,d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr GameCommand
    lea     $30(a7), a7
    pea     ($0008).w
    pea     ($0038).w
    pea     -$10(a6)
    jsr DisplaySetup
    pea     ($000E).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    jsr MemFillByte
    move.w  d5, d0
    add.w   d0, d0
    movea.l  #$00FF0118,a0
    move.w  (a0,d0.w), -$20(a6)
    pea     ($0001).w
    pea     ($000F).w
    pea     -$20(a6)
    jsr DisplaySetup
    lea     $24(a7), a7
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    clr.w   d4
    bra.w   l_1cdc2
l_1ccc0:
    tst.b   $1(a2)
    bne.b   l_1cd10
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    pea     ($00A8).w
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$3, d0
    addi.l  #$48, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    addq.w  #$1, d4
    bra.w   l_1cdbe
l_1cd10:
    cmpi.b  #$6, $1(a2)
    beq.b   l_1cd2e
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d2
    bra.b   l_1cd46
l_1cd2e:
    moveq   #$0,d2
    move.b  (a2), d2
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr FindBitInField
    addq.l  #$8, a7
l_1cd46:
    cmp.w   d6, d2
    beq.b   l_1cdbe
    move.w  d2, d0
    add.w   d0, d0
    movea.l  #$0005F088,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0001).w
    moveq   #$0,d0
    move.b  $1(a3), d0
    addi.l  #$a8, d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  (a3), d1
    add.l   d1, d0
    addq.l  #$8, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0544).w
    jsr TilePlacement
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    lea     $24(a7), a7
    move.w  d2, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    addq.w  #$3, (a5,a0.l)
l_1cdbe:
    addq.l  #$8, a2
    addq.w  #$1, d3
l_1cdc2:
    cmpi.w  #$4, d3
    blt.w   l_1ccc0
    move.w  ($00FF0006).l, d0
    ext.l   d0
    moveq   #$4,d1
    jsr SignedMod
    move.l  d0, d2
    mulu.w  #$3, d2
    move.w  ($00FF0006).l, d0
    ext.l   d0
    bge.b   l_1cdec
    addq.l  #$3, d0
l_1cdec:
    asr.l   #$2, d0
    addi.w  #$7a3, d0
    move.w  d0, d3
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($0001).w
    jsr SetTextCursor
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005F096,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($0004116C).l
    jsr PrintfNarrow
    movem.l -$64(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; UpdateGraphicsState -- (TODO: name)
; 648 bytes | $01CE3E-$01D0C5
; ============================================================================
UpdateGraphicsState:
    movem.l d2-d6/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $1c(a7), d6
    movea.l  #$00000D64,a2
    move.w  d6, d2
    move.w  #$80, d4
l_1ce56:
    move.w  d4, d0
    andi.w  #$80, d0
    beq.w   l_1cf0a
    move.w  d2, d0
    ext.l   d0
    addq.l  #$1, d0
    moveq   #$4,d1
    jsr SignedMod
    move.w  d0, d2
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    lea     $1c(a7), a7
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF0130,a0
    tst.l   (a0,d0.w)
    beq.b   l_1cf0a
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041180).l
    jsr PrintfWide
    lea     $20(a7), a7
l_1cf0a:
    pea     ($0004).w
    pea     ($000E).w
    jsr     (a2)
    addq.l  #$8, a7
l_1cf16:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.l  #$90, d0
    beq.b   l_1cf16
    move.w  d4, d0
    andi.w  #$10, d0
    bne.w   l_1d05c
    move.w  d4, d0
    andi.w  #$20, d0
    beq.w   l_1ce56
    move.w  d4, d0
    andi.w  #$20, d0
    beq.b   l_1cf98
    clr.l   -(a7)
    pea     ($0006).w
    pea     ($0008).w
    pea     ($0015).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharacterBrowser
    lea     $24(a7), a7
    move.w  d0, d5
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    bra.b   l_1cfb6
l_1cf98:
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr NopStub
    lea     $c(a7), a7
    move.w  d0, d5
l_1cfb6:
    cmpi.w  #$ff, d5
    beq.w   l_1d046
    cmp.w   d3, d5
    beq.w   l_1d046
    move.w  d5, d3
    move.w  d2, d0
    lsl.w   #$5, d0
    move.w  d3, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF0130,a0
    tst.l   (a0,d0.w)
    beq.b   l_1d028
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    pea     ($0015).w
    pea     ($000E).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$3, d0
    add.w   d3, d0
    movea.l  #$00FF0270,a0
    move.b  (a0,d0.w), d0
    andi.l  #$ff, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($00041172).l
    jsr PrintfWide
    lea     $20(a7), a7
    bra.b   l_1d046
l_1d028:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0006).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_1d046:
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RenderDisplayBuffer
    addq.l  #$8, a7
    bra.w   l_1ce56
l_1d05c:
    cmp.w   d2, d6
    beq.b   l_1d09c
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr LoadScreen
    pea     ($0002).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr ShowRelPanel
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w RunMainMenu
    lea     $1c(a7), a7
    bra.b   l_1d0ba
l_1d09c:
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0012).w
    pea     ($0015).w
    pea     ($000E).w
    clr.l   -(a7)
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
l_1d0ba:
    move.w  d3, ($00FF9A1C).l
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; AllocGraphicsMemory -- (TODO: name)
; 584 bytes | $01D0C6-$01D30D
; ============================================================================
AllocGraphicsMemory:
    movem.l d2-d6/a2-a4, -(a7)
    move.l  $2c(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d5
    movea.l  #$00000D64,a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    cmp.w   d2, d3
    beq.w   l_1d2c6
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d6
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeCompare
    lea     $1c(a7), a7
    move.l  d0, d4
    andi.l  #$ffff, d4
    cmpi.l  #$ffff, d4
    beq.w   l_1d2c6
    tst.l   d4
    beq.w   l_1d2c6
    pea     ($0015).w
    pea     ($000D).w
    jsr     (a4)
    pea     ($000411A0).l
    jsr     (a3)
    pea     ($0015).w
    pea     ($0016).w
    jsr     (a4)
    move.l  d4, -(a7)
    pea     ($00041198).l
    jsr     (a3)
    pea     ($0017).w
    pea     ($000D).w
    jsr     (a4)
    pea     ($0003).w
    move.w  d2, d0
    move.l  d0, -(a7)
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcRelationValue
    lea     $c(a7), a7
    move.l  d0, -(a7)
    pea     ($0004118E).l
    jsr     (a3)
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    move.w  d0, d4
    andi.w  #$20, d0
    beq.w   l_1d2b2
    pea     ($0001).w
    move.w  ($00FFBD66).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  ($00FFBD64).l, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr PlaceCursor
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr BrowseRelations
    lea     $18(a7), a7
    moveq   #$1,d1
    cmp.l   d0, d1
    bne.w   l_1d2b2
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($0004DD9C).l
    pea     ($0009).w
    pea     ($001E).w
    pea     ($0012).w
    pea     ($0001).w
    clr.l   -(a7)
    pea     ($001B).w
    jsr     (a2)
    pea     ($0004DFB8).l
    pea     ($00FF1804).l
    jsr LZ_Decompress
    lea     $24(a7), a7
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($000F).w
    pea     ($02E1).w
    jsr VRAMBulkLoad
    pea     ($0037).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $28(a7), a7
    pea     ($0001).w
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    bsr.w DisplayMenuOption
    pea     ($0039).w
    pea     ($0013).w
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr DrawStatDisplay
    lea     $24(a7), a7
l_1d2b2:
    clr.l   -(a7)
    pea     ($0003).w
    jsr PollAction
    addq.l  #$8, a7
    andi.w  #$10, d0
    bne.b   l_1d2b2
l_1d2c6:
    pea     ($077F).w
    pea     ($0001).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    pea     ($077E).w
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0013).w
    pea     ($0002).w
    pea     ($0001).w
    pea     ($001A).w
    jsr     (a2)
    lea     $1c(a7), a7
    movem.l (a7)+, d2-d6/a2-a4
    rts

; ============================================================================
; ClearGraphicsArea -- (TODO: name)
; 2 bytes | $01D30E-$01D30F
; ============================================================================
ClearGraphicsArea:
    rts

; ============================================================================
; RefreshAndWait -- (TODO: describe)
; 48 bytes | $01D310-$01D33F
; ============================================================================
RefreshAndWait:                                                  ; $01D310
    move.l  d2,-(sp)
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    pea     ($0014).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $000c(sp),sp
    move.b  d0,d2
    btst    #$00,d2
    beq.b   .l1d33a
    moveq   #$1,d0
    bra.b   .l1d33c
.l1d33a:                                                ; $01D33A
    moveq   #$0,d0
.l1d33c:                                                ; $01D33C
    move.l  (sp)+,d2
    rts
; ============================================================================
; SetDisplayMode -- (TODO: describe)
; Called: 7 times.
; 58 bytes | $01D340-$01D379
; ============================================================================
SetDisplayMode:                                                  ; $01D340
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    bne.b   .l1d362
    pea     ($0010).w
    pea     ($0013).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    move.w  #$ffff,($00FFBD52).l
.l1d362:                                                ; $01D362
    move.w  ($00FF1274).l,d0
    andi.w  #$ff00,d0
    or.w    d2,d0
    move.w  d0,($00FF1274).l
    moveq   #$0,d0
    move.l  (sp)+,d2
    rts
; ---------------------------------------------------------------------------
SetDisplayPage:                                                  ; $01D37A
    move.l  d2,-(sp)
    move.l  $0008(sp),d2
    tst.w   d2
    bne.b   .l1d390
    pea     ($0018).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$4,sp
.l1d390:                                                ; $01D390
    move.w  d2,d0
    lsl.w   #$8,d0
    move.w  ($00FF1274).l,d1
    andi.w  #$ff,d1
    or.l    d1,d0
    move.w  d0,($00FF1274).l
    moveq   #$0,d0
    move.l  (sp)+,d2
    rts
; ============================================================================
; MenuSelectEntry -- Validate selection index, dispatch GameCommand calls
; Called: 14 times. Args (stack): 8(a6)=selection index (w), E(a6)=mode flag (w)
; ============================================================================
MenuSelectEntry:                                             ; $01D3AC
    link    a6,#$0000
    movem.l d2/a2/a3,-(sp)
    move.l  $0008(a6),d2                                 ; D2 = selection index
    movea.l #$00000D64,a2                                ; A2 = GameCommand
    movea.l #$00FFBD52,a3                                ; A3 = stored selection ptr
    move.w  ($00FF1274).l,d0                             ; D0 = display state
    andi.l  #$00000001,d0                                ; isolate active bit
    moveq   #1,d1
    cmp.l   d0,d1                                        ; active?
    bne.s   .done                                        ; no -> exit
    pea     ($0001).w
    bsr.w SetDisplayMode
    addq.l  #4,sp
    tst.w   d2                                           ; index >= 0?
    bge.s   .check_upper
    cmpi.w  #$0016,d2
    bgt.s   .done                                        ; out of range
.check_upper:                                            ; $01D3EA
    cmp.w   (a3),d2                                      ; already selected?
    beq.s   .do_set
    pea     ($0008).w
    pea     ($0013).w
    jsr     (a2)                                         ; GameCommand($13,$8)
    pea     ($0014).w
    pea     ($000E).w
    jsr     (a2)                                         ; GameCommand($14,$E)
    move.w  d2,d0
    ext.l   d0
    lsl.l   #2,d0                                        ; D0 = index * 4
    movea.l #$000F0000,a0                                ; A0 = table base
    move.l  (a0,d0.l),-(sp)                              ; push table[index]
    pea     ($0012).w
    jsr     (a2)                                         ; GameCommand($12,entry)
    lea     $18(sp),sp                                   ; clean 6 args (3 calls)
.do_set:                                                 ; $01D41C
    cmpi.w  #$0001,$000E(a6)                             ; mode flag == 1?
    bne.s   .store_ffff
    move.w  d2,(a3)                                      ; save selection
    pea     ($0001).w
    bra.s   .call_game15
.store_ffff:                                             ; $01D42C
    move.w  #$FFFF,(a3)                                  ; reset stored selection
    clr.l   -(sp)
.call_game15:                                            ; $01D432
    pea     ($0015).w
    jsr     (a2)                                         ; GameCommand($15,...)
.done:                                                   ; $01D438
    moveq   #0,d0
    movem.l -$C(a6),d2/a2/a3
    unlk    a6
    rts
; ============================================================================
; LoadDisplaySet -- Load triple-pointer display resource set from table
; Called: 16 times.
; 220 bytes | $01D444-$01D51F
; ============================================================================
LoadDisplaySet:                                                  ; $01D444
    movem.l d2-d3/a2-a5,-(sp)
    move.l  $001c(sp),d3
    movea.l #$0d64,a5
    move.w  ($00FF1274).l,d0
    andi.l  #$0100,d0
    cmpi.l  #$0100,d0
    bne.w   .l1d518
    tst.w   d3
    blt.w   .l1d518
    cmpi.w  #$17,d3
    bgt.w   .l1d518
    move.w  d3,d0
    mulu.w  #$6,d0
    movea.l #$00047cec,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  (a0),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d498
    moveq   #$0,d0
    movea.l d0,a4
    bra.b   .l1d4a8
.l1d498:                                                ; $01D498
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc0ca,a0
    movea.l (a0,d0.l),a4
.l1d4a8:                                                ; $01D4A8
    move.w  $0002(a2),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d4ba
    moveq   #$0,d0
    movea.l d0,a3
    bra.b   .l1d4ca
.l1d4ba:                                                ; $01D4BA
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc0ca,a0
    movea.l (a0,d0.l),a3
.l1d4ca:                                                ; $01D4CA
    move.w  $0004(a2),d0
    move.w  d0,d2
    cmpi.w  #$ff,d0
    bne.b   .l1d4dc
    moveq   #$0,d0
    movea.l d0,a2
    bra.b   .l1d4ec
.l1d4dc:                                                ; $01D4DC
    move.w  d2,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc052,a0
    movea.l (a0,d0.l),a2
.l1d4ec:                                                ; $01D4EC
    pea     ($0018).w
    jsr     (a5)
    move.l  a2,-(sp)
    move.l  a3,-(sp)
    move.l  a4,-(sp)
    pea     ($0016).w
    jsr     (a5)
    move.w  d3,d0
    ext.l   d0
    lsl.l   #$2,d0
    movea.l #$000fc13e,a0
    move.l  (a0,d0.l),-(sp)
    pea     ($0017).w
    jsr     (a5)
    lea     $001c(sp),sp
.l1d518:                                                ; $01D518
    moveq   #$0,d0
    movem.l (sp)+,d2-d3/a2-a5
    rts
; ============================================================================
; MemFillByte -- Fill memory with a byte value (71 calls)
; Args (stack): 4(sp)=dest, 8(sp)=fill byte, C(sp)=count
; ============================================================================
MemFillByte:                                                     ; $01D520
    move.l  $C(sp),d1                                            ; D1 = count
    move.l  $8(sp),d0                                            ; D0 = fill value
    movea.l $4(sp),a0                                            ; A0 = dest pointer
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D52E
    move.b  d0,(a0)+                                             ; *dest++ = fill byte
    subq.w  #1,d1                                                ; count--
.check:                                                          ; $01D532
    tst.w   d1                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
; ============================================================================
; MemCopy -- Copy bytes from source to destination
; Args (stack): 8(sp)=src, 10(sp)=dest, 14(sp)=count
; ============================================================================
MemCopy:                                                         ; $01D538
    move.l  $14(sp),d0                                           ; D0 = count
    movea.l $10(sp),a1                                           ; A1 = dest
    movea.l $8(sp),a0                                            ; A0 = src
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D546
    move.b  (a0)+,(a1)+                                          ; *dest++ = *src++
    subq.w  #1,d0                                                ; count--
.check:                                                          ; $01D54A
    tst.w   d0                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
; ============================================================================
; MemFillWord -- Fill memory with a word value
; Args (stack): 4(sp)=dest, 8(sp)=count, C(sp)=fill word
; ============================================================================
MemFillWord:                                                     ; $01D550
    move.l  $8(sp),d1                                            ; D1 = count
    move.l  $C(sp),d0                                            ; D0 = fill value
    movea.l $4(sp),a0                                            ; A0 = dest pointer
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D55E
    move.w  d0,(a0)+                                             ; *dest++ = fill word
    subq.w  #1,d1                                                ; count--
.check:                                                          ; $01D562
    tst.w   d1                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    rts
; ============================================================================
; VRAMBulkLoad -- Transfer tile data to VRAM in chunks via GameCommand (46 calls)
; Chunks large transfers into $80-unit pieces, each $800 bytes via DMA command.
; Args: $A(a6).w = tile base, $C(a6).l = count, $10(a6).l = source ptr
; ============================================================================
VRAMBulkLoad:                                                ; $01D568
    link    a6,#$0000
    movem.l d2-d3/a2-a3,-(sp)
    move.l  $000C(a6),d2                                     ; d2 = transfer count
    movea.l $0010(a6),a2                                     ; a2 = source pointer
    movea.l #$00000D64,a3                                    ; a3 = GameCommand
    move.w  $000A(a6),d3                                     ; d3 = tile base
    lsl.w   #5,d3                                            ; tile# -> VRAM offset (*32)
    cmpi.w  #$0200,d2                                        ; count >= $200?
    blt.s   .small                                           ; no, single transfer
    bra.s   .chunk_test                                      ; enter chunked loop
.chunk_loop:                                                 ; $01D58C
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    pea     ($0800).w                                        ; chunk size ($800 bytes)
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,$800,src,ofs,0)
    pea     ($0004).w                                        ; wait count
    pea     ($000E).w                                        ; cmd: wait/sync
    jsr     (a3)                                             ; GameCommand($E,4)
    lea     $20(sp),sp                                       ; clean 32 bytes
    addi.w  #$1000,d3                                        ; next VRAM chunk offset
    lea     $1000(a2),a2                                     ; next source chunk
    subi.w  #$0080,d2                                        ; count -= $80
.chunk_test:                                                 ; $01D5BE
    cmpi.w  #$0080,d2                                        ; count > $80?
    bgt.s   .chunk_loop                                      ; yes, keep chunking
    tst.w   d2                                               ; any remainder?
    ble.s   .done                                            ; no, finished
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    move.w  d2,d0
    ext.l   d0
    lsl.l   #4,d0                                            ; remainder * 16
    move.l  d0,-(sp)                                         ; byte count
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,rem*16,src,ofs,0)
    lea     $18(sp),sp                                       ; clean 24 bytes
    pea     ($0002).w                                        ; wait count
    bra.s   .tail                                            ; -> common tail
.small:                                                      ; $01D5EE
    clr.l   -(sp)                                            ; flags = 0
    moveq   #0,d0
    move.w  d3,d0
    move.l  d0,-(sp)                                         ; VRAM offset
    move.l  a2,-(sp)                                         ; source address
    move.w  d2,d0
    ext.l   d0
    lsl.l   #4,d0                                            ; count * 16
    move.l  d0,-(sp)                                         ; byte count
    pea     ($0002).w                                        ; sub: VRAM
    pea     ($0005).w                                        ; cmd: DMA transfer
    jsr     (a3)                                             ; GameCommand(5,2,cnt*16,src,ofs,0)
    lea     $18(sp),sp                                       ; clean 24 bytes
    move.w  d2,d0
    ext.l   d0
    moveq   #$64,d1                                          ; divisor = 100
    jsr SignedDiv
    move.l  d0,-(sp)                                         ; push count/100
.tail:                                                       ; $01D61C
    pea     ($000E).w                                        ; cmd: wait/sync
    jsr     (a3)                                             ; GameCommand($E,<n>)
.done:                                                       ; $01D622
    movem.l -$10(a6),d2-d3/a2-a3
    unlk    a6
    rts
; ============================================================================
; PollAction -- Poll for action/input with different loop strategies (65 calls)
; If flag $FF0A34 is clear, delays 60 frames and returns 16 (default).
; Otherwise loops calling utility $1E1EC based on arg at $E(a6).
; ============================================================================
PollAction:                                                      ; $01D62C
    link    a6,#$0000                                            ; create stack frame
    movem.l d2/a2,-(sp)                                          ; save working registers
    movea.l #$0001E1EC,a2                                        ; A2 = utility function
    tst.w   ($00FF0A34).l                                        ; is UI/system active?
    beq.s   .inactive                                            ; no -> delay and return default
    tst.w   $E(a6)                                               ; test second arg
    bne.s   .pollA                                               ; non-zero -> flush-then-wait
    bra.s   .once                                                ; zero -> single call
; -- Flush loop: call GameCmd #14 between polls (re-entry) --
.retryA:                                                         ; $01D64A
    pea     ($0001).w                                            ; sub-arg: 1
    pea     ($000E).w                                            ; GameCommand #14
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 pea args
; -- Flush: poll until result is zero (release detection) --
.pollA:                                                          ; $01D65A
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    tst.w   d0                                                   ; still active?
    bne.s   .retryA                                              ; non-zero -> keep flushing
    bra.s   .pollB                                               ; zero -> now wait for input
; -- Wait loop: call GameCmd #14 between polls (re-entry) --
.retryB:                                                         ; $01D666
    pea     ($0001).w                                            ; sub-arg: 1
    pea     ($000E).w                                            ; GameCommand #14
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 pea args
; -- Wait: poll until result is non-zero (press detection) --
.pollB:                                                          ; $01D676
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    move.w  d0,d2                                                ; D2 = result
    beq.s   .retryB                                              ; zero -> keep waiting
    bra.s   .result                                              ; non-zero -> done
; -- Single call path --
.once:                                                           ; $01D682
    clr.l   -(sp)                                                ; push 0 (utility arg)
    jsr     (a2)                                                 ; call utility $1E1EC
    addq.l  #4,sp                                                ; clean arg
    move.w  d0,d2                                                ; D2 = result
    bra.s   .result
; -- Inactive path: delay and return default --
.inactive:                                                       ; $01D68C
    pea     ($003C).w                                            ; push 60 (frame count)
    jsr (PollInputChange,PC)
    nop                                                          ; padding
    moveq   #$10,d2                                              ; D2 = 16 (default result)
.result:                                                         ; $01D698
    move.w  d2,d0                                                ; D0 = result
    movem.l -8(a6),d2/a2                                         ; restore from link frame
    unlk    a6                                                   ; destroy stack frame
    rts
; ============================================================================
; RandRange -- Random integer in [min, max] (64 calls)
; Uses classic C LCG: state = state * 1103515245 + 12345
; Args (stack): $18(sp)=min (word), $1C(sp)=max (word)
;   (offsets shifted by 20 bytes of saved registers)
; RNG state at $FFA7E0 (longword + word accumulator)
; ============================================================================
RandRange:                                                       ; $01D6A4
    movem.l d2-d5/a2,-(sp)                                      ; save working registers
    move.l  $18(sp),d3                                           ; D3 = min
    move.l  $1C(sp),d4                                           ; D4 = max
    movea.l #$00FFA7E0,a2                                        ; A2 = RNG state pointer
    move.w  $2(a2),d2                                            ; D2 = accumulator word
    pea     ($0003).w                                            ; GameCommand #3
    jsr GameCommand
    addq.l  #4,sp                                                ; clean arg
    add.w   d0,d2                                                ; accumulate return value
    move.l  (a2),d0                                              ; D0 = RNG state
    move.l  #$41C64E6D,d1                                        ; D1 = LCG multiplier (1103515245)
    jsr Multiply32
    addi.l  #$00003039,d0                                        ; D0 += 12345 (LCG increment)
    move.l  d0,(a2)                                              ; store new RNG state
    moveq   #0,d0                                                ; zero-extend
    move.w  d2,d0                                                ; D0 = accumulator (unsigned)
    move.w  d4,d1                                                ; D1 = max
    ext.l   d1                                                   ; sign-extend to long
    move.w  d3,d5                                                ; D5 = min
    ext.l   d5                                                   ; sign-extend to long
    sub.l   d5,d1                                                ; D1 = max - min
    addq.l  #1,d1                                                ; D1 = range (max - min + 1)
    jsr SignedMod
    add.w   d3,d0                                                ; D0 = (random % range) + min
    movem.l (sp)+,d2-d5/a2                                       ; restore registers
    rts
; ============================================================================
; ByteSum -- Sum bytes in a buffer, return sum in D0.W
; Args (stack): 4(sp)=src ptr, 8(sp)=count
; ============================================================================
ByteSum:                                                         ; $01D6FC
    move.l  d2,-(sp)                                             ; Save D2
    move.l  $C(sp),d2                                            ; D2 = count (+4 from push)
    movea.l $8(sp),a0                                            ; A0 = src pointer
    clr.w   d1                                                   ; D1 = accumulator = 0
    bra.s   .check                                               ; enter loop at test
.loop:                                                           ; $01D70A
    moveq   #0,d0                                                ; zero-extend
    move.b  (a0)+,d0                                             ; D0 = next byte
    add.w   d0,d1                                                ; accumulate
    subq.w  #1,d2                                                ; count--
.check:                                                          ; $01D712
    tst.w   d2                                                   ; count == 0?
    bne.s   .loop                                                ; loop if not done
    move.w  d1,d0                                                ; D0 = result sum
    move.l  (sp)+,d2                                             ; Restore D2
    rts
; ============================================================================
; ResourceLoad -- Load resource if not already loaded (106 calls)
; Pushes 4 args, calls $4CB6, sets flag at $FFA7DC
; ============================================================================
ResourceLoad:                                                    ; $01D71C
    tst.w   ($00FFA7DC).l                                        ; Already loaded?
    bne.s   .done                                                ; Yes -> skip
    pea     ($0002).w                                            ; arg: 2
    pea     ($0040).w                                            ; arg: $40
    clr.l   -(sp)                                                ; arg: 0
    pea     ($00FF14BC).l                                        ; arg: work RAM buffer
    jsr DrawLayersReverse
    lea     $10(sp),sp                                           ; clean 16 bytes of args
    move.w  #$0001,($00FFA7DC).l                                 ; set loaded flag
.done:                                                           ; $01D746
    rts
; ============================================================================
; ResourceUnload -- Unload resource if loaded (95 calls)
; Pushes 4 args, calls $4D04, clears flag at $FFA7DC
; ============================================================================
ResourceUnload:                                                  ; $01D748
    tst.w   ($00FFA7DC).l                                        ; Is it loaded?
    beq.s   .done                                                ; No -> skip
    pea     ($0002).w                                            ; arg: 2
    pea     ($0040).w                                            ; arg: $40
    clr.l   -(sp)                                                ; arg: 0
    pea     ($00FF14BC).l                                        ; arg: work RAM buffer
    jsr DrawLayersForward
    lea     $10(sp),sp                                           ; clean 16 bytes of args
    clr.w   ($00FFA7DC).l                                        ; clear loaded flag
.done:                                                           ; $01D770
    rts
; ---
; === Translated block $01D772-$01D7BE ===
; 1 functions, 76 bytes

; ============================================================================
; FormatTextString -- (TODO: name)
; 76 bytes | $01D772-$01D7BD
; ============================================================================
FormatTextString:
    link    a6,#-$8
    movem.l d2-d3, -(a7)
    move.l  $10(a6), d2
    move.l  $c(a6), d3
    move.w  $16(a6), d1
    sub.w   d3, d1
    move.w  $1a(a6), d0
    sub.w   d2, d0
    mulu.w  d0, d1
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d1, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     -$8(a6)
    jsr (AdjustPercentage,PC)
    nop
    movem.l -$10(a6), d2-d3
    unlk    a6
    rts

; ============================================================================
; DrawTileGrid -- Draw grid of tiles from data buffer in nested row/col loop
; Called: 14 times.
; 126 bytes | $01D7BE-$01D83B
; ============================================================================
DrawTileGrid:                                                  ; $01D7BE
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d3
    move.l  $0020(sp),d5
    move.l  $0024(sp),d6
    movea.l $0028(sp),a2
    move.w  d3,d0
    lsl.w   #$5,d0
    move.w  d0,d3
    clr.w   d4
    bra.b   .l1d822
.l1d7dc:                                                ; $01D7DC
    clr.w   d2
    bra.b   .l1d818
.l1d7e0:                                                ; $01D7E0
    clr.l   -(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    lsl.l   #$5,d0
    move.w  d2,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    pea     (a2,d0.l)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0018(sp),sp
    addi.w  #$20,d3
    addq.w  #$1,d2
.l1d818:                                                ; $01D818
    cmp.w   d6,d2
    blt.b   .l1d7e0
    moveq   #$20,d0
    adda.l  d0,a2
    addq.w  #$1,d4
.l1d822:                                                ; $01D822
    cmp.w   d5,d4
    blt.b   .l1d7dc
    pea     ($0002).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    addq.l  #$8,sp
    movem.l (sp)+,d2-d6/a2
    rts
    dc.w    $48E7,$3E20                                      ; $01D83C
; === Translated block $01D840-$01D8F4 ===
; 3 functions, 180 bytes

; ============================================================================
; RenderTextLineS1 -- (TODO: name)
; 106 bytes | $01D840-$01D8A9
; ============================================================================
RenderTextLineS1:
    move.l  $1c(a7), d3
    move.l  $20(a7), d5
    move.l  $24(a7), d6
    movea.l $28(a7), a2
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d0, d3
    clr.w   d4
    bra.b   l_1d8a0
l_1d85a:
    clr.w   d2
    bra.b   l_1d896
l_1d85e:
    clr.l   -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  d5, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.w  d2, d1
    ext.l   d1
    jsr Multiply32
    pea     (a2, d0.l)
    pea     ($0010).w
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    addi.w  #$20, d3
    addq.w  #$1, d2
l_1d896:
    cmp.w   d6, d2
    blt.b   l_1d85e
    moveq   #$20,d0
    adda.l  d0, a2
    addq.w  #$1, d4
l_1d8a0:
    cmp.w   d5, d4
    blt.b   l_1d85a
    movem.l (a7)+, d2-d6/a2
    rts

; ============================================================================
; ProcessTextControl -- (TODO: name)
; 56 bytes | $01D8AA-$01D8E1
; ============================================================================
ProcessTextControl:
    move.l  d2, -(a7)
    move.l  $c(a7), d2
    move.l  $8(a7), d1
    movea.l $10(a7), a0
    clr.l   -(a7)
    move.w  d1, d0
    ext.l   d0
    lsl.l   #$5, d0
    move.l  d0, -(a7)
    move.l  a0, -(a7)
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$4, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0005).w
    jsr GameCommand
    lea     $18(a7), a7
    move.l  (a7)+, d2
    rts

; ============================================================================
; AlignTextBlock -- (TODO: name)
; 18 bytes | $01D8E2-$01D8F3
; ============================================================================
AlignTextBlock:
    pea     ($0010).w
    pea     ($0013).w
    jsr GameCommand
    addq.l  #$8, a7
    rts

; ============================================================================
; SetScrollOffset -- (TODO: describe)
; Called: ?? times.
; 152 bytes | $01D8F4-$01D98B
; ============================================================================
SetScrollOffset:                                                  ; $01D8F4
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $001c(sp),d2
    move.l  $0020(sp),d3
    move.l  $0018(sp),d4
    movea.l #$0d64,a3
    move.l  #$8b00,-(sp)
    clr.l   -(sp)
    jsr     (a3)
    addq.l  #$8,sp
    movea.l #$00ff5804,a2
    move.w  d2,d0
    or.w    d3,d0
    bne.b   .l1d934
    pea     ($0008).w
    clr.l   -(sp)
    move.l  a2,-(sp)
    bsr.w MemFillByte
    lea     $000c(sp),sp
    bra.b   .l1d94a
.l1d934:                                                ; $01D934
    neg.w   d2
    tst.w   d4
    bne.b   .l1d944
    move.w  d2,$0002(a2)
    move.w  d3,$0006(a2)
    bra.b   .l1d94a
.l1d944:                                                ; $01D944
    move.w  d2,(a2)
    move.w  d3,$0004(a2)
.l1d94a:                                                ; $01D94A
    clr.l   -(sp)
    pea     ($0002).w
    pea     ($0002).w
    clr.l   -(sp)
    move.l  a2,d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    pea     ($0002).w
    pea     ($0008).w
    jsr     (a3)
    lea     $001c(sp),sp
    clr.l   -(sp)
    move.l  #$fc00,-(sp)
    move.l  a2,-(sp)
    pea     ($0002).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $0018(sp),sp
    movem.l (sp)+,d2-d4/a2-a3
    rts
    dc.w    $48E7,$3C38                                      ; $01D98C
; === Translated block $01D990-$01DC26 ===
; 2 functions, 662 bytes

; ============================================================================
; PackGameState -- (TODO: name)
; 164 bytes | $01D990-$01DA33
; ============================================================================
PackGameState:
    move.l  $28(a7), d2
    move.l  $2c(a7), d3
    move.l  $24(a7), d4
    move.l  $20(a7), d5
    movea.l  #$00000D64,a3
    movea.l  #$00FF1804,a4
    pea     ($0800).w
    clr.l   -(a7)
    move.l  a4, d0
    addi.l  #$5000, d0
    move.l  d0, -(a7)
    bsr.w MemFillByte
    lea     $c(a7), a7
    tst.w   d3
    bne.b   l_1d9d6
    move.l  #$8b00, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    bra.b   l_1da0a
l_1d9d6:
    move.l  #$8b02, -(a7)
    clr.l   -(a7)
    jsr     (a3)
    addq.l  #$8, a7
    move.w  d4, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a4,d0.l), a0
    lea     $5000(a0), a0
    movea.l a0, a2
    cmpi.w  #$1, d5
    bne.b   l_1d9fa
    addq.l  #$2, a2
l_1d9fa:
    neg.w   d3
    bra.b   l_1da06
l_1d9fe:
    move.w  d3, (a2)
    subq.w  #$1, d2
    moveq   #$20,d0
    adda.l  d0, a2
l_1da06:
    tst.w   d2
    bgt.b   l_1d9fe
l_1da0a:
    clr.l   -(a7)
    move.l  #$fc00, -(a7)
    move.l  a4, d0
    addi.l  #$5000, d0
    move.l  d0, -(a7)
    pea     ($0200).w
    pea     ($0002).w
    pea     ($0005).w
    jsr     (a3)
    lea     $18(a7), a7
    movem.l (a7)+, d2-d5/a2-a4
    rts

; ============================================================================
; UnpackGameState -- (TODO: name)
; 498 bytes | $01DA34-$01DC25
; ============================================================================
UnpackGameState:
    link    a6,#-$10
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $10(a6), d2
    move.l  $14(a6), d3
    move.l  $8(a6), d5
    move.l  $c(a6), d6
    move.l  $18(a6), d7
    movea.l $1c(a6), a3
    lea     -$4(a6), a4
    lea     -$2(a6), a1
    move.w  d7, d0
    moveq   #$C,d1
    lsl.w   d1, d0
    move.w  d0, -$e(a6)
    move.w  d7, d0
    lsl.w   #$8, d0
    move.w  d0, -$c(a6)
    move.w  d7, d0
    lsl.w   #$4, d0
    move.w  d0, -$a(a6)
    move.w  d7, -$8(a6)
    cmpi.w  #$20, d5
    bne.b   l_1da94
    cmpi.w  #$22, d6
    bne.b   l_1da94
    cmpi.w  #$dc, d2
    bne.b   l_1da94
    cmpi.w  #$66, d3
    bne.b   l_1da94
    subq.w  #$1, d6
l_1da94:
    move.w  d2, d0
    sub.w   d5, d0
    move.w  d0, (a1)
    cmp.w   d3, d6
    ble.b   l_1daa4
    move.w  d6, d0
    sub.w   d3, d0
    bra.b   l_1daa8
l_1daa4:
    move.w  d3, d0
    sub.w   d6, d0
l_1daa8:
    move.w  d0, (a4)
    cmp.w   d2, d5
    bge.b   l_1dab2
    cmp.w   d3, d6
    blt.b   l_1daba
l_1dab2:
    cmp.w   d2, d5
    ble.b   l_1dabe
    cmp.w   d3, d6
    ble.b   l_1dabe
l_1daba:
    moveq   #$1,d0
    bra.b   l_1dac0
l_1dabe:
    moveq   #-$1,d0
l_1dac0:
    move.w  d0, -$6(a6)
    move.w  (a1), d0
    cmp.w   (a4), d0
    ble.w   l_1db76
    cmp.w   d2, d5
    ble.b   l_1dad4
    move.w  d2, d5
    move.w  d3, d6
l_1dad4:
    move.w  (a1), d0
    ext.l   d0
    bge.b   l_1dadc
    addq.l  #$1, d0
l_1dadc:
    asr.l   #$1, d0
    move.w  d0, d4
    move.w  d5, d3
    move.w  d5, d7
    add.w   (a1), d7
    bra.w   l_1db6c
l_1daea:
    tst.w   d3
    bge.b   l_1daf6
    move.w  d3, d2
    addi.w  #$100, d2
    bra.b   l_1db06
l_1daf6:
    cmpi.w  #$100, d3
    blt.b   l_1db04
    move.w  d3, d2
    addi.w  #$ff00, d2
    bra.b   l_1db06
l_1db04:
    move.w  d3, d2
l_1db06:
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1
    andi.l  #$1, d1
    add.l   d1, d1
    adda.l  d1, a0
    move.w  d6, d0
    ext.l   d0
    asr.l   #$3, d0
    moveq   #$A,d1
    lsl.l   d1, d0
    adda.l  d0, a0
    move.w  d6, d0
    andi.l  #$7, d0
    lsl.l   #$2, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    movea.l  #$0005F9B6,a0
    move.w  (a0,d0.w), d0
    and.w   d0, (a2)
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    or.w    d0, (a2)
    sub.w   (a4), d4
    tst.w   d4
    bge.b   l_1db6a
    add.w   (a1), d4
    add.w   -$6(a6), d6
l_1db6a:
    addq.w  #$1, d3
l_1db6c:
    cmp.w   d7, d3
    ble.w   l_1daea
    bra.w   l_1dc1c
l_1db76:
    cmp.w   d3, d6
    ble.b   l_1db7e
    move.w  d3, d6
    move.w  d2, d5
l_1db7e:
    move.w  (a4), d0
    ext.l   d0
    bge.b   l_1db86
    addq.l  #$1, d0
l_1db86:
    asr.l   #$1, d0
    move.w  d0, d4
    move.w  d6, d3
    move.w  d6, d7
    add.w   (a4), d7
    bra.w   l_1dc16
l_1db94:
    tst.w   d5
    bge.b   l_1dba0
    move.w  d5, d2
    addi.w  #$100, d2
    bra.b   l_1dbb0
l_1dba0:
    cmpi.w  #$100, d5
    blt.b   l_1dbae
    move.w  d5, d2
    addi.w  #$ff00, d2
    bra.b   l_1dbb0
l_1dbae:
    move.w  d5, d2
l_1dbb0:
    move.w  d2, d0
    ext.l   d0
    asr.l   #$3, d0
    lsl.l   #$5, d0
    lea     (a3,d0.l), a0
    move.w  d2, d1
    ext.l   d1
    asr.l   #$2, d1
    andi.l  #$1, d1
    add.l   d1, d1
    adda.l  d1, a0
    move.w  d3, d0
    ext.l   d0
    asr.l   #$3, d0
    moveq   #$A,d1
    lsl.l   d1, d0
    adda.l  d0, a0
    move.w  d3, d0
    andi.l  #$7, d0
    lsl.l   #$2, d0
    adda.l  d0, a0
    movea.l a0, a2
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    movea.l  #$0005F9B6,a0
    move.w  (a0,d0.w), d0
    and.w   d0, (a2)
    move.w  d2, d0
    andi.w  #$3, d0
    add.w   d0, d0
    move.w  -$e(a6, d0.w), d0
    or.w    d0, (a2)
    sub.w   (a1), d4
    tst.w   d4
    bge.b   l_1dc14
    add.w   (a4), d4
    add.w   -$6(a6), d5
l_1dc14:
    addq.w  #$1, d3
l_1dc16:
    cmp.w   d7, d3
    ble.w   l_1db94
l_1dc1c:
    movem.l -$34(a6), d2-d7/a2-a4
    unlk    a6
    rts

; ============================================================================
; DrawTilemapLine -- (TODO: describe)
; 516 bytes | $01DC26-$01DE29
; ============================================================================
DrawTilemapLine:                                                  ; $01DC26
    link    a6,#-$10
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0010(a6),d2
    move.l  $0014(a6),d3
    move.l  $0008(a6),d5
    move.l  $000c(a6),d6
    move.l  $0018(a6),d7
    movea.l $001c(a6),a3
    lea     -$0002(a6),a4
    lea     -$0004(a6),a1
    move.w  d7,d0
    moveq   #$c,d1
    lsl.w   d1,d0
    move.w  d0,-$000e(a6)
    move.w  d7,d0
    lsl.w   #$8,d0
    move.w  d0,-$000c(a6)
    move.w  d7,d0
    lsl.w   #$4,d0
    move.w  d0,-$000a(a6)
    move.w  d7,-$0008(a6)
    cmpi.w  #$20,d5
    bne.b   .l1dc86
    cmpi.w  #$22,d6
    bne.b   .l1dc86
    cmpi.w  #$dc,d2
    bne.b   .l1dc86
    cmpi.w  #$66,d3
    bne.b   .l1dc86
    subq.w  #$1,d6
.l1dc86:                                                ; $01DC86
    move.w  d2,d0
    sub.w   d5,d0
    move.w  d0,(a4)
    move.w  #$0100,d4
    sub.w   d2,d4
    add.w   d5,d4
    cmp.w   (a4),d4
    bge.b   .l1dc9e
    move.w  d4,(a4)
    addi.w  #$0100,d5
.l1dc9e:                                                ; $01DC9E
    cmp.w   d3,d6
    ble.b   .l1dca8
    move.w  d6,d0
    sub.w   d3,d0
    bra.b   .l1dcac
.l1dca8:                                                ; $01DCA8
    move.w  d3,d0
    sub.w   d6,d0
.l1dcac:                                                ; $01DCAC
    move.w  d0,(a1)
    cmp.w   d2,d5
    bge.b   .l1dcb6
    cmp.w   d3,d6
    blt.b   .l1dcbe
.l1dcb6:                                                ; $01DCB6
    cmp.w   d2,d5
    ble.b   .l1dcc2
    cmp.w   d3,d6
    ble.b   .l1dcc2
.l1dcbe:                                                ; $01DCBE
    moveq   #$1,d0
    bra.b   .l1dcc4
.l1dcc2:                                                ; $01DCC2
    moveq   #-$1,d0
.l1dcc4:                                                ; $01DCC4
    move.w  d0,-$0006(a6)
    move.w  (a4),d0
    cmp.w   (a1),d0
    ble.w   .l1dd7a
    cmp.w   d2,d5
    ble.b   .l1dcd8
    move.w  d2,d5
    move.w  d3,d6
.l1dcd8:                                                ; $01DCD8
    move.w  (a4),d0
    ext.l   d0
    bge.b   .l1dce0
    addq.l  #$1,d0
.l1dce0:                                                ; $01DCE0
    asr.l   #$1,d0
    move.w  d0,d4
    move.w  d5,d3
    move.w  d5,d7
    add.w   (a4),d7
    bra.w   .l1dd70
.l1dcee:                                                ; $01DCEE
    tst.w   d3
    bge.b   .l1dcfa
    move.w  d3,d2
    addi.w  #$0100,d2
    bra.b   .l1dd0a
.l1dcfa:                                                ; $01DCFA
    cmpi.w  #$0100,d3
    blt.b   .l1dd08
    move.w  d3,d2
    addi.w  #$ff00,d2
    bra.b   .l1dd0a
.l1dd08:                                                ; $01DD08
    move.w  d3,d2
.l1dd0a:                                                ; $01DD0A
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0
    lsl.l   #$5,d0
    lea     (a3,d0.l),a0
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1
    andi.l  #$1,d1
    add.l   d1,d1
    adda.l  d1,a0
    move.w  d6,d0
    ext.l   d0
    asr.l   #$3,d0
    moveq   #$a,d1
    lsl.l   d1,d0
    adda.l  d0,a0
    move.w  d6,d0
    andi.l  #$7,d0
    lsl.l   #$2,d0
    adda.l  d0,a0
    movea.l a0,a2
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    movea.l #$0005f9b6,a0
    move.w  (a0,d0.w),d0
    and.w   d0,(a2)
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    move.w  -$e(a6,d0.w),d0
    or.w    d0,(a2)
    sub.w   (a1),d4
    tst.w   d4
    bge.b   .l1dd6e
    add.w   (a4),d4
    add.w   -$0006(a6),d6
.l1dd6e:                                                ; $01DD6E
    addq.w  #$1,d3
.l1dd70:                                                ; $01DD70
    cmp.w   d7,d3
    ble.w   .l1dcee
    bra.w   .l1de20
.l1dd7a:                                                ; $01DD7A
    cmp.w   d3,d6
    ble.b   .l1dd82
    move.w  d3,d6
    move.w  d2,d5
.l1dd82:                                                ; $01DD82
    move.w  (a1),d0
    ext.l   d0
    bge.b   .l1dd8a
    addq.l  #$1,d0
.l1dd8a:                                                ; $01DD8A
    asr.l   #$1,d0
    move.w  d0,d4
    move.w  d6,d3
    move.w  d6,d7
    add.w   (a1),d7
    bra.w   .l1de1a
.l1dd98:                                                ; $01DD98
    tst.w   d5
    bge.b   .l1dda4
    move.w  d5,d2
    addi.w  #$0100,d2
    bra.b   .l1ddb4
.l1dda4:                                                ; $01DDA4
    cmpi.w  #$0100,d5
    blt.b   .l1ddb2
    move.w  d5,d2
    addi.w  #$ff00,d2
    bra.b   .l1ddb4
.l1ddb2:                                                ; $01DDB2
    move.w  d5,d2
.l1ddb4:                                                ; $01DDB4
    move.w  d2,d0
    ext.l   d0
    asr.l   #$3,d0
    lsl.l   #$5,d0
    lea     (a3,d0.l),a0
    move.w  d2,d1
    ext.l   d1
    asr.l   #$2,d1
    andi.l  #$1,d1
    add.l   d1,d1
    adda.l  d1,a0
    move.w  d3,d0
    ext.l   d0
    asr.l   #$3,d0
    moveq   #$a,d1
    lsl.l   d1,d0
    adda.l  d0,a0
    move.w  d3,d0
    andi.l  #$7,d0
    lsl.l   #$2,d0
    adda.l  d0,a0
    movea.l a0,a2
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    movea.l #$0005f9b6,a0
    move.w  (a0,d0.w),d0
    and.w   d0,(a2)
    move.w  d2,d0
    andi.w  #$3,d0
    add.w   d0,d0
    move.w  -$e(a6,d0.w),d0
    or.w    d0,(a2)
    sub.w   (a4),d4
    tst.w   d4
    bge.b   .l1de18
    add.w   (a1),d4
    add.w   -$0006(a6),d5
.l1de18:                                                ; $01DE18
    addq.w  #$1,d3
.l1de1a:                                                ; $01DE1A
    cmp.w   d7,d3
    ble.w   .l1dd98
.l1de20:                                                ; $01DE20
    movem.l -$0034(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $4E56,$0000,$42A7                                ; $01DE2A
; === Translated block $01DE30-$01DE92 ===
; 2 functions, 98 bytes

; ============================================================================
; CalcScalar -- (TODO: name)
; 34 bytes | $01DE30-$01DE51
; ============================================================================
CalcScalar:
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($001A).w
    jsr GameCommand
    unlk    a6
    rts

; ============================================================================
; AdjustPercentage -- (TODO: name)
; 64 bytes | $01DE52-$01DE91
; ============================================================================
AdjustPercentage:
    movea.l $4(a7), a0
    move.w  #$80, (a0)
    move.w  $a(a7), d0
    addi.w  #$ffff, d0
    andi.w  #$3, d0
    moveq   #$A,d1
    lsl.w   d1, d0
    move.w  $e(a7), d1
    addi.w  #$ffff, d1
    andi.w  #$3, d1
    lsl.w   #$8, d1
    or.l    d1, d0
    move.w  d0, $2(a0)
    move.w  $16(a7), d0
    ori.w   #$8000, d0
    move.w  d0, $4(a0)
    move.w  #$80, $6(a0)
    rts

; ---------------------------------------------------------------------------
LoadMapTiles:                                                  ; $01DE92
    movem.l a2-a4,-(sp)
    movea.l #$00ff1804,a2
    movea.l #$3fec,a3
    movea.l #$0001d568,a4
    pea     ($0004943A).l
    move.l  a2,-(sp)
    jsr     (a3)
    move.l  a2,-(sp)
    pea     ($0002).w
    pea     ($000A).w
    pea     ($0740).w
    bsr.w DrawTileGrid
    pea     ($0004959E).l
    move.l  a2,-(sp)
    jsr     (a3)
    move.l  a2,-(sp)
    pea     ($0014).w
    pea     ($0760).w
    bsr.w ProcessTextControl
    lea     $002c(sp),sp
    pea     ($0004E1D8).l
    move.l  a2,-(sp)
    jsr     (a3)
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($077D).w
    jsr     (a4)
    clr.l   -(sp)
    pea     ($0004E1EC).l
    pea     ($0001).w
    pea     ($077F).w
    jsr     (a4)
    pea     ($0004E230).l
    move.l  a2,-(sp)
    jsr     (a3)
    lea     $0030(sp),sp
    clr.l   -(sp)
    move.l  a2,-(sp)
    pea     ($0001).w
    pea     ($077E).w
    jsr     (a4)
    lea     $0010(sp),sp
    movem.l (sp)+,a2-a4
    rts
; === Translated block $01DF30-$01DFBE ===
; 1 functions, 142 bytes

; ============================================================================
; RoundValue -- (TODO: name)
; 142 bytes | $01DF30-$01DFBD
; ============================================================================
RoundValue:
    movem.l d2-d3/a2-a5, -(a7)
    move.l  $1c(a7), d2
    movea.l $20(a7), a3
    movea.l  #$00048E00,a5
    tst.w   d2
    ble.b   l_1dfa8
    cmpi.w  #$63, d2
    bge.b   l_1df52
    move.w  d2, d0
    ext.l   d0
    bra.b   l_1df54
l_1df52:
    moveq   #$63,d0
l_1df54:
    move.w  d0, d2
    ext.l   d0
    moveq   #$A,d1
    jsr SignedDiv
    move.w  d0, d3
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    jsr SignedMod
    move.w  d0, d2
    tst.w   d3
    ble.b   l_1df84
    move.w  d3, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a5,d0.l), a0
    addq.l  #$2, a0
    movea.l a0, a2
    bra.b   l_1df8a
l_1df84:
    movea.l a5, a2
    lea     $140(a2), a2
l_1df8a:
    move.w  d2, d0
    ext.l   d0
    lsl.l   #$5, d0
    lea     (a5,d0.l), a0
    movea.l a0, a4
    clr.w   d2
l_1df98:
    move.l  (a2)+, d0
    or.l    (a4)+, d0
    move.l  d0, (a3)+
    addq.w  #$1, d2
    cmpi.w  #$8, d2
    blt.b   l_1df98
    bra.b   l_1dfb8
l_1dfa8:
    pea     ($0020).w
    clr.l   -(a7)
    move.l  a3, -(a7)
    bsr.w MemFillByte
    lea     $c(a7), a7
l_1dfb8:
    movem.l (a7)+, d2-d3/a2-a5
    rts

; ---------------------------------------------------------------------------
PlaceFormattedTiles:                                                  ; $01DFBE
    link    a6,#-$20
    movem.l d2-d4,-(sp)
    move.l  $000c(a6),d2
    move.l  $0014(a6),d3
    move.l  $0008(a6),d4
    pea     -$0020(a6)
    move.w  $001a(a6),d0
    move.l  d0,-(sp)
    bsr.w RoundValue
    pea     -$0020(a6)
    pea     ($0001).w
    move.w  d3,d0
    move.l  d0,-(sp)
    bsr.w ProcessTextControl
    cmpi.w  #$e,d4
    bne.b   .l1dffe
    cmpi.w  #$1e,d2
    bne.b   .l1dffe
    moveq   #$e,d2
.l1dffe:                                                ; $01DFFE
    clr.l   -(sp)
    pea     ($0001).w
    pea     ($0001).w
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  $0012(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eba,$0020                                 ; jsr $01E044
    nop
    lea     $0030(sp),sp
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    movem.l -$002c(a6),d2-d4
    unlk    a6
    rts
; ============================================================================
; TilePlacement -- Set up tile/sprite parameters, call GameCommand #15 (100 calls)
; Builds 8-byte parameter block on stack from args, then dispatches.
; Args via link frame: $E-$22(a6) = various tile params
; ============================================================================
TilePlacement:                                                   ; $01E044
    link    a6,#-8                                               ; allocate 8 bytes local
    lea     -8(a6),a0                                            ; A0 = local buffer
    move.w  #$0080,-8(a6)                                        ; buf[0] = $80 (default flags)
    move.w  $1A(a6),d0                                           ; D0 = tile row param
    addi.w  #$FFFF,d0                                            ; D0 -= 1
    andi.w  #$0003,d0                                            ; D0 &= 3 (0-3)
    moveq   #$0A,d1                                              ; D1 = 10
    lsl.w   d1,d0                                                ; D0 <<= 10 (row -> VRAM offset)
    move.w  $1E(a6),d1                                           ; D1 = tile col param
    addi.w  #$FFFF,d1                                            ; D1 -= 1
    andi.w  #$0003,d1                                            ; D1 &= 3 (0-3)
    lsl.w   #8,d1                                                ; D1 <<= 8 (col -> VRAM offset)
    or.l    d1,d0                                                ; combine row + col
    move.w  d0,2(a0)                                             ; buf[2] = tile position
    move.w  $22(a6),d0                                           ; D0 = palette/priority
    andi.w  #$FC00,d0                                            ; keep top 6 bits
    or.w    $A(a6),d0                                            ; OR with tile ID arg
    move.w  d0,4(a0)                                             ; buf[4] = tile attr + ID
    move.w  #$0080,6(a0)                                         ; buf[6] = $80 (flags)
    move.w  $16(a6),d0                                           ; D0 = height param
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push height
    move.w  $12(a6),d0                                           ; D0 = width param
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push width
    move.l  a0,-(sp)                                             ; push buffer ptr
    pea     ($0001).w                                            ; push 1 (mode)
    move.w  $E(a6),d0                                            ; D0 = plane select
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push plane
    pea     ($000F).w                                            ; GameCommand #15
    jsr GameCommand
    unlk    a6                                                   ; cleanup (discards args + locals)
    rts
; ============================================================================
; GameCmd16 -- Call GameCommand #16 with two args (77 calls)
; Args (stack): 4(sp)=arg1 (word), 8(sp)=arg2 (word)
; ============================================================================
GameCmd16:                                                       ; $01E0B8
    move.l  d2,-(sp)                                             ; save D2
    move.l  $C(sp),d2                                            ; D2 = arg2 (shifted +4)
    move.l  $8(sp),d1                                            ; D1 = arg1
    move.w  d2,d0                                                ; D0 = arg2
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push arg2
    move.w  d1,d0                                                ; D0 = arg1
    ext.l   d0                                                   ; sign-extend
    move.l  d0,-(sp)                                             ; push arg1
    pea     ($0010).w                                            ; GameCommand #16
    jsr GameCommand
    lea     $C(sp),sp                                            ; clean 12 bytes (3 args)
    move.l  (sp)+,d2                                             ; restore D2
    rts
; ============================================================================
; CopyBytesToWords -- (TODO: describe)
; Called: ?? times.
; 30 bytes | $01E0E0-$01E0FD
; ============================================================================
CopyBytesToWords:                                                  ; $01E0E0
    move.l  $000c(sp),d0
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    clr.w   d1
    bra.b   .l1e0f8
.l1e0f0:                                                ; $01E0F0
    move.b  (a0),(a1)
    addq.w  #$1,d1
    addq.l  #$1,a0
    addq.l  #$2,a1
.l1e0f8:                                                ; $01E0F8
    cmp.w   d0,d1
    blt.b   .l1e0f0
    rts
; ============================================================================
; CopyAlternateBytes -- (TODO: describe)
; 30 bytes | $01E0FE-$01E11B
; ============================================================================
CopyAlternateBytes:                                                  ; $01E0FE
    move.l  $000c(sp),d0
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    clr.w   d1
    bra.b   .l1e116
.l1e10e:                                                ; $01E10E
    move.b  (a1),(a0)
    addq.w  #$1,d1
    addq.l  #$1,a0
    addq.l  #$2,a1
.l1e116:                                                ; $01E116
    cmp.w   d0,d1
    blt.b   .l1e10e
    rts
; ============================================================================
; MulDiv -- Multiply then divide: (a * b) / c via Multiply32 + SignedDiv
; Called: 13 times.
; 46 bytes | $01E11C-$01E149
; ============================================================================
MulDiv:                                                  ; $01E11C
    move.l  d2,-(sp)
    move.l  $0010(sp),d2
    tst.w   d2
    bne.b   .l1e12a
    moveq   #$0,d0
    bra.b   .l1e146
.l1e12a:                                                ; $01E12A
    moveq   #$0,d0
    move.w  $000a(sp),d0
    moveq   #$0,d1
    move.w  $000e(sp),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l1e146:                                                ; $01E146
    move.l  (sp)+,d2
    rts
; ============================================================================
; ToUpperCase -- (TODO: describe)
; Called: ?? times.
; 34 bytes | $01E14A-$01E16B
; ============================================================================
ToUpperCase:                                                  ; $01E14A
    move.l  $0004(sp),d1
    cmpi.b  #$61,d1
    bcs.b   .l1e166
    cmpi.b  #$7a,d1
    bhi.b   .l1e166
    moveq   #$0,d0
    move.b  d1,d0
    subi.l  #$20,d0
    bra.b   .l1e16a
.l1e166:                                                ; $01E166
    moveq   #$0,d0
    move.b  d1,d0
.l1e16a:                                                ; $01E16A
    rts
; ---------------------------------------------------------------------------
MemMoveWords:                                                  ; $01E16C
    move.l  $000c(sp),d1
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    cmpa.l  a1,a0
    bls.b   .l1e188
    bra.b   .l1e182
.l1e17e:                                                ; $01E17E
    move.w  (a0)+,(a1)+
    subq.w  #$1,d1
.l1e182:                                                ; $01E182
    tst.w   d1
    bne.b   .l1e17e
    bra.b   .l1e1a2
.l1e188:                                                ; $01E188
    moveq   #$0,d0
    move.w  d1,d0
    add.l   d0,d0
    adda.l  d0,a1
    moveq   #$0,d0
    move.w  d1,d0
    add.l   d0,d0
    adda.l  d0,a0
    bra.b   .l1e19e
.l1e19a:                                                ; $01E19A
    move.w  -(a0),-(a1)
    subq.w  #$1,d1
.l1e19e:                                                ; $01E19E
    tst.w   d1
    bne.b   .l1e19a
.l1e1a2:                                                ; $01E1A2
    rts
; ---------------------------------------------------------------------------

; === Translated block $01E1A4-$01E1BA ===
; 1 functions, 22 bytes

; ============================================================================
; SetupPointerRegs -- (TODO: name)
; 22 bytes | $01E1A4-$01E1B9
; ============================================================================
SetupPointerRegs:
    move.l  a2, -(a7)
    movea.l $8(a7), a2
    movea.l $c(a7), a1
    movea.l a2, a0
l_1e1b0:
    move.b  (a1)+, (a2)+
    bne.b   l_1e1b0
    move.l  a0, d0
    movea.l (a7)+, a2
    rts


; ============================================================================
; StringAppend -- (TODO: describe)
; 30 bytes | $01E1BA-$01E1D7
; ============================================================================
StringAppend:                                                  ; $01E1BA
    move.l  a2,-(sp)
    movea.l $0008(sp),a2
    movea.l $000c(sp),a1
    movea.l a2,a0
    bra.b   .l1e1ca
.l1e1c8:                                                ; $01E1C8
    addq.l  #$1,a2
.l1e1ca:                                                ; $01E1CA
    tst.b   (a2)
    bne.b   .l1e1c8
.l1e1ce:                                                ; $01E1CE
    move.b  (a1)+,(a2)+
    bne.b   .l1e1ce
    move.l  a0,d0
    movea.l (sp)+,a2
    rts
; === Translated block $01E1D8-$01E1EC ===
; 1 functions, 20 bytes

; ============================================================================
; SearchTable -- (TODO: name)
; 20 bytes | $01E1D8-$01E1EB
; ============================================================================
SearchTable:
    movea.l $4(a7), a1
    movea.l a1, a0
    bra.b   l_1e1e2
l_1e1e0:
    addq.l  #$1, a1
l_1e1e2:
    tst.b   (a1)
    bne.b   l_1e1e0
    move.w  a1, d0
    sub.w   a0, d0
    rts

; ============================================================================
; ReadInput -- Read joypad input via GameCommand #10 (95 calls)
; Arg (stack): $10(sp)=mode (0=high|low, 2=high only, other=low only)
; Input mask at $FFA790 filters which buttons are reported.
; Returns: D0.W = masked input value (byte)
; ============================================================================
ReadInput:                                                       ; $01E1EC
    movem.l d2-d3/a2,-(sp)                                      ; save working registers
    move.l  $10(sp),d3                                           ; D3 = mode arg (shifted +12)
    movea.l #$00FFA790,a2                                        ; A2 = input mask pointer
    clr.l   -(sp)                                                ; push 0 (sub-arg)
    pea     ($000A).w                                            ; GameCommand #10 (read input)
    jsr GameCommand
    addq.l  #8,sp                                                ; clean 2 args
    move.l  d0,d2                                                ; D2 = raw input (longword)
    tst.l   d3                                                   ; check mode
    beq.s   .modeOr                                              ; mode 0 -> OR both halves
    moveq   #2,d0                                                ; compare value
    cmp.l   d3,d0                                                ; mode == 2?
    bne.s   .modeLow                                             ; no -> use low word
; -- Mode 2: extract high word only (new presses) --
.modeHigh:                                                       ; $01E214
    move.l  d2,d0                                                ; D0 = raw input
    moveq   #$10,d1                                              ; D1 = 16
    lsr.l   d1,d0                                                ; D0 = high word (>> 16)
    bra.s   .mask                                                ; apply mask
; -- Mode other: use low word only (held buttons) --
.modeLow:                                                        ; $01E21C
    move.w  d2,d0                                                ; D0 = low word
    bra.s   .mask                                                ; apply mask
; -- Mode 0: OR high and low words (any activity) --
.modeOr:                                                         ; $01E220
    move.l  d2,d0                                                ; D0 = raw input
    moveq   #$10,d1                                              ; D1 = 16
    lsr.l   d1,d0                                                ; D0 = high word (>> 16)
    or.w    d2,d0                                                ; D0 |= low word
.mask:                                                           ; $01E228
    and.w   (a2),d0                                              ; mask with allowed buttons
    andi.w  #$00FF,d0                                            ; keep low byte only
    movem.l (sp)+,d2-d3/a2                                       ; restore registers
    rts
; ---
; === Translated block $01E234-$01E290 ===
; 1 functions, 92 bytes

; ============================================================================
; IterateCollection -- (TODO: name)
; 92 bytes | $01E234-$01E28F
; ============================================================================
IterateCollection:
    move.l  d2, -(a7)
    tst.w   ($00FF0A34).l
    bne.b   l_1e250
    bra.b   l_1e27c
l_1e240:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_1e250:
    clr.l   -(a7)
    bsr.w ReadInput
    addq.l  #$4, a7
    tst.w   d0
    bne.b   l_1e240
    bra.b   l_1e26e
l_1e25e:
    pea     ($0001).w
    pea     ($000E).w
    jsr GameCommand
    addq.l  #$8, a7
l_1e26e:
    clr.l   -(a7)
    bsr.w ReadInput
    addq.l  #$4, a7
    move.w  d0, d2
    beq.b   l_1e25e
    bra.b   l_1e28a
l_1e27c:
    pea     ($003C).w
    jsr (PollInputChange,PC)
    nop
    addq.l  #$4, a7
    move.w  d0, d2
l_1e28a:
    move.w  d2, d0
    move.l  (a7)+, d2
    rts

; === ProcessInputLoop ($01E290, 100B) ===
ProcessInputLoop:                                                     ; $01E290
    MOVEM.L D2-D3,-(SP)
    MOVE.L  $C(SP),D2                                                 ; arg1 (iteration count)
    MOVE.L  $10(SP),D3                                                ; arg2 (target input)
    CMPI.W  #1,($00FF13FC).L                                         ; check mode flag
    BNE.S   .pil_after                                                ; if != 1, skip loop
    TST.W   ($00FFA7D8).L                                            ; check init flag
    BEQ.S   .pil_countdown                                            ; if == 0, start countdown
    BRA.S   .pil_after                                                ; else skip
.pil_loop:                                                            ; $01E2B0
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    CMP.W   D3,D0                                                     ; compare with target
    BNE.S   .pil_after                                                ; if match, continue; else exit
    PEA     ($0001).W
    PEA     ($000E).W                                                 ; command 14
    jsr GameCommand
    ADDQ.L  #8,SP
.pil_countdown:                                                       ; $01E2CC
    MOVE.L  D2,D0
    SUBQ.W  #1,D2                                                     ; decrement counter
    TST.W   D0                                                        ; test pre-decrement value
    BNE.S   .pil_loop                                                 ; continue while != 0
.pil_after:                                                           ; $01E2D4
    CMPI.W  #1,($00FF13FC).L
    BNE.S   .pil_epilogue
    MOVE.W  #1,($00FFA7D8).L                                         ; set init flag
.pil_epilogue:                                                        ; $01E2E6
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVEM.L (SP)+,D2-D3
    RTS
; === PollInputChange ($01E2F4, 82B) ===
PollInputChange:                                                      ; $01E2F4
    MOVEM.L D2-D4,-(SP)
    MOVE.L  $10(SP),D3                                                ; arg (loop count)
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVE.W  D0,D4                                                     ; D4 = initial input
    BRA.S   .pic_check
.pic_loop:                                                            ; $01E308
    CLR.L   -(SP)
    bsr.w ReadInput
    ADDQ.L  #4,SP
    MOVE.W  D0,D2                                                     ; D2 = new input
    TST.W   D2
    BEQ.S   .pic_nochange                                             ; if 0, skip
    CMP.W   D2,D4
    BEQ.S   .pic_nochange                                             ; if same as last, skip
    MOVE.W  D2,D0                                                     ; found different input
    BRA.S   .pic_exit
.pic_nochange:                                                        ; $01E31E
    MOVE.W  ($00FF0008).L,D0                                         ; frame counter
    EXT.L   D0                                                        ; sign-extend
    ADDQ.L  #1,D0                                                     ; frame + 1
    MOVE.L  D0,-(SP)
    PEA     ($000E).W                                                 ; command 14
    jsr GameCommand
    ADDQ.L  #8,SP
    MOVE.W  D2,D4                                                     ; update last input
    SUBQ.W  #1,D3                                                     ; loop counter--
.pic_check:                                                           ; $01E33A
    TST.W   D3
    BNE.S   .pic_loop                                                 ; continue while != 0
    MOVE.W  D4,D0                                                     ; return last value
.pic_exit:                                                            ; $01E340
    MOVEM.L (SP)+,D2-D4
    RTS
; ============================================================================
; WeightedAverage -- (TODO: describe)
; Called: ?? times.
; 82 bytes | $01E346-$01E397
; ============================================================================
WeightedAverage:                                                  ; $01E346
    movem.l d2-d4,-(sp)
    move.l  $0014(sp),d2
    move.l  $001c(sp),d3
    move.w  d2,d0
    or.w    d3,d0
    bne.b   .l1e35c
    moveq   #$0,d0
    bra.b   .l1e392
.l1e35c:                                                ; $01E35C
    moveq   #$0,d0
    move.w  $001a(sp),d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  $0016(sp),d0
    moveq   #$0,d1
    move.w  d2,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.w  d2,d1
    moveq   #$0,d4
    move.w  d3,d4
    add.l   d4,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.w  d0,d2
.l1e392:                                                ; $01E392
    movem.l (sp)+,d2-d4
    rts
; ---------------------------------------------------------------------------
; PreLoopInit -- Initialize display layers before main game loop
; Sets up display mode (GameCommand 16) and two background layers (GameCommand 26)
; Called 57 times
; ---------------------------------------------------------------------------
PreLoopInit:                                                   ; $01E398
    MOVE.L  A2,-(SP)                                           ; save A2
    MOVEA.L #$00000D64,A2                                      ; A2 = GameCommand
    PEA     ($0040).W                                          ; push 64 (columns)
    CLR.L   -(SP)                                              ; push 0
    PEA     ($0010).W                                          ; command 16 (set display mode)
    JSR     (A2)                                               ; GameCommand(16, 0, 64)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0 (y)
    CLR.L   -(SP)                                              ; push 0 (x)
    CLR.L   -(SP)                                              ; push 0 (layer 0)
    PEA     ($001A).W                                          ; command 26 (set background)
    JSR     (A2)                                               ; GameCommand(26, 0, 0, 0, 32, 32, $8000)
    LEA     $28(SP),SP                                         ; pop 10 args (both calls)
    MOVE.L  #$00008000,-(SP)                                   ; push VRAM base
    PEA     ($0020).W                                          ; push 32 (height)
    PEA     ($0020).W                                          ; push 32 (width)
    CLR.L   -(SP)                                              ; push 0 (y)
    CLR.L   -(SP)                                              ; push 0 (x)
    PEA     ($0001).W                                          ; push 1 (layer 1)
    PEA     ($001A).W                                          ; command 26
    JSR     (A2)                                               ; GameCommand(26, 1, 0, 0, 32, 32, $8000)
    LEA     $1C(SP),SP                                         ; pop 7 args
    MOVEA.L (SP)+,A2                                           ; restore A2
    RTS
; ============================================================================
; StringConcat -- (TODO: describe)
; 20 bytes | $01E3EE-$01E401
; ============================================================================
StringConcat:                                                  ; $01E3EE
    movea.l $0008(sp),a1
    movea.l $0004(sp),a0
    move.l  a1,-(sp)
    move.l  a0,-(sp)
    bsr.w StringAppend
    addq.l  #$8,sp
    rts
; === Translated block $01E402-$01E98E ===
; 6 functions, 1420 bytes

; ============================================================================
; GameUpdate3 -- (TODO: name)
; 184 bytes | $01E402-$01E4B9
; ============================================================================
GameUpdate3:
    move.l  d2, -(a7)
    jsr (ClampValue,PC)
    nop
    clr.w   d2
l_1e40c:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (CalcCityStats,PC)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$7, d2
    bcs.b   l_1e40c
    jsr (ValidateRange,PC)
    nop
    tst.w   d0
    beq.b   l_1e432
    jsr ResourceUnload
l_1e432:
    pea     ($0001).w
    pea     ($0012).w
    jsr MenuSelectEntry
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $18(a7), a7
    tst.w   ($00FF000A).l
    bne.b   l_1e480
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr GameCommand
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    lea     $18(a7), a7
l_1e480:
    jsr (ProcessInputEvent,PC)
    nop
    clr.w   d2
l_1e488:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (PrepareTradeOffer,PC)
    nop
    addq.l  #$4, a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1e488
    jsr (FilterCollection,PC)
    nop
    jsr (UpdateRouteFieldValues,PC)
    nop
    jsr (UpdateGameStateCounters,PC)
    nop
    jsr ResourceLoad
    move.l  (a7)+, d2
    rts

; ============================================================================
; ValidateRange -- (TODO: name)
; 50 bytes | $01E4BA-$01E4EB
; ============================================================================
ValidateRange:
    movem.l d2-d3, -(a7)
    clr.w   d3
    movea.l  #$00FF0018,a0
    clr.w   d2
l_1e4c8:
    moveq   #$0,d0
    move.b  $4(a0), d0
    moveq   #$0,d1
    move.b  $5(a0), d1
    add.w   d1, d0
    add.w   d0, d3
    moveq   #$24,d0
    adda.l  d0, a0
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1e4c8
    move.w  d3, d0
    movem.l (a7)+, d2-d3
    rts

; ============================================================================
; ClampValue -- (TODO: name)
; 230 bytes | $01E4EC-$01E5D1
; ============================================================================
ClampValue:
    movem.l d2-d4/a2-a5, -(a7)
    movea.l  #$0000D648,a5
    pea     ($0500).w
    clr.l   -(a7)
    pea     ($00FFB4E4).l
    jsr MemFillByte
    lea     $c(a7), a7
    movea.l  #$00FF0018,a4
    clr.w   d3
l_1e514:
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d3, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_1e56c
l_1e53c:
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    move.w  d0, (a2)
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$8, a7
    move.w  d0, $2(a2)
    clr.w   $4(a2)
    move.w  #$64, $6(a2)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1e56c:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a4), d1
    cmp.l   d1, d0
    blt.b   l_1e53c
    moveq   #$0,d4
    move.b  $4(a4), d4
    moveq   #$0,d0
    move.b  $5(a4), d0
    add.w   d0, d4
    moveq   #$0,d2
    move.b  $4(a4), d2
    bra.b   l_1e5b4
l_1e590:
    moveq   #$0,d0
    move.b  (a3), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr     (a5)
    addq.l  #$4, a7
    move.w  d0, $2(a2)
    move.w  d0, (a2)
    clr.w   $4(a2)
    move.w  #$64, $6(a2)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1e5b4:
    cmp.w   d4, d2
    bcs.b   l_1e590
    moveq   #$24,d0
    adda.l  d0, a4
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1e514
    jsr (CompareElements,PC)
    nop
    movem.l (a7)+, d2-d4/a2-a5
    rts

; ============================================================================
; CompareElements -- (TODO: name)
; 278 bytes | $01E5D2-$01E6E7
; ============================================================================
CompareElements:
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$00FF0018,a5
    movea.l  #$00FF0338,a2
    clr.w   d3
l_1e5e4:
    moveq   #$0,d7
    move.b  $4(a5), d7
    moveq   #$0,d0
    move.b  $5(a5), d0
    add.w   d0, d7
    clr.w   d4
l_1e5f4:
    cmpi.b  #$6, $1(a2)
    bne.w   l_1e6c8
    moveq   #$0,d0
    move.b  (a2), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bcc.w   l_1e6c8
    moveq   #$0,d0
    move.w  $6(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (SortElements,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d6
    moveq   #$0,d0
    move.b  $4(a5), d0
    mulu.w  #$14, d0
    move.w  d3, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    mulu.w  #$140, d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d2
    move.b  $4(a5), d2
    bra.b   l_1e6c4
l_1e684:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   (a3), d0
    bne.b   l_1e6bc
    moveq   #$0,d0
    move.w  $6(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $1(a4), d0
    andi.l  #$ffff, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (SortElements,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d5
    move.w  d6, d0
    add.w   d5, d0
    add.w   d0, $6(a3)
l_1e6bc:
    moveq   #$14,d0
    adda.l  d0, a4
    addq.l  #$8, a3
    addq.w  #$1, d2
l_1e6c4:
    cmp.w   d7, d2
    bcs.b   l_1e684
l_1e6c8:
    addq.l  #$8, a2
    addq.w  #$1, d4
    cmpi.w  #$4, d4
    bcs.w   l_1e5f4
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1e5e4
    movem.l (a7)+, d2-d7/a2-a5
    rts

; ============================================================================
; SortElements -- (TODO: name)
; 364 bytes | $01E6E8-$01E853
; ============================================================================
SortElements:
    link    a6,#$0
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d6
    lea     $e(a6), a5
    cmpi.w  #$20, (a5)
    bcc.b   l_1e72a
    move.w  (a5), d0
    mulu.w  #$6, d0
    movea.l  #$00FF1704,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d0
    mulu.w  #$6, d0
    movea.l  #$00FF0420,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$6,d7
    bra.b   l_1e74c
l_1e72a:
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF15A0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  (a5), d0
    lsl.w   #$2, d0
    movea.l  #$00FF0460,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$4,d7
l_1e74c:
    tst.w   d3
    bne.b   l_1e754
    clr.w   d5
    bra.b   l_1e760
l_1e754:
    cmpi.w  #$1, d3
    bne.b   l_1e75e
    moveq   #$3,d5
    bra.b   l_1e760
l_1e75e:
    moveq   #$2,d5
l_1e760:
    clr.w   d3
    clr.w   d4
    clr.w   d2
    bra.b   l_1e7a0
l_1e768:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d6, d1
    cmp.l   d1, d0
    bne.b   l_1e79a
    moveq   #$0,d0
    move.b  (a3), d0
    lsl.w   #$2, d0
    movea.l  #$0005E31A,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.b  $3(a4), d0
    cmp.w   d5, d0
    bne.b   l_1e79a
    moveq   #$0,d0
    move.b  $2(a4), d0
    add.w   d0, d3
    addq.w  #$1, d4
l_1e79a:
    addq.l  #$1, a3
    addq.l  #$1, a2
    addq.w  #$1, d2
l_1e7a0:
    cmp.w   d7, d2
    bcs.b   l_1e768
    tst.w   d4
    beq.b   l_1e81e
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    add.l   d0, d0
    moveq   #$6A,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d3
    moveq   #$0,d0
    move.w  (a5), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    move.w  d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    lea     $c(a7), a7
    ext.l   d0
    moveq   #$0,d1
    move.w  (a5), d1
    cmp.l   d1, d0
    bne.b   l_1e81e
    moveq   #$0,d0
    move.w  (a5), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    move.w  d0, d2
    beq.b   l_1e81c
    move.w  d3, d0
    ext.l   d0
    divu.w  d2, d0
    move.w  d0, d3
    bra.b   l_1e81e
l_1e81c:
    clr.w   d3
l_1e81e:
    move.w  ($00FF0002).l, d0
    ext.l   d0
    moveq   #$3,d1
    sub.l   d0, d1
    move.l  d1, d0
    lsl.l   #$2, d0
    add.l   d1, d0
    addi.l  #$f, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$A,d1
    jsr UnsignedDivide
    move.w  d0, d3
    movem.l -$28(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; FilterCollection -- (TODO: name)
; 314 bytes | $01E854-$01E98D
; ============================================================================
FilterCollection:
    movem.l d2-d5/a2-a5, -(a7)
    movea.l  #$00FF0120,a3
    movea.l  #$00FF0230,a5
    clr.w   d5
    move.w  d5, d0
    lsl.w   #$5, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1e876:
    moveq   #$0,d2
    move.b  $1(a3), d2
    mulu.w  ($00FF999C).l, d2
    moveq   #$0,d0
    move.b  $2(a3), d0
    mulu.w  ($00FFBA68).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    mulu.w  ($00FF1288).l, d0
    add.w   d0, d2
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    move.b  d2, (a3)
    move.l  $1c(a4), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    cmpi.l  #$ffff, d4
    bge.b   l_1e8ec
    move.l  $1c(a4), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e8f2
l_1e8ec:
    move.l  #$ffff, d4
l_1e8f2:
    cmpi.w  #$64, d4
    bls.b   l_1e8fe
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_1e900
l_1e8fe:
    moveq   #$64,d0
l_1e900:
    move.w  d0, (a5)
    clr.w   d3
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$2, d0
    lea     (a4,d0.l), a0
    movea.l a0, a2
l_1e910:
    move.l  (a2), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    cmpi.l  #$ffff, d4
    bge.b   l_1e94a
    move.l  (a2), d0
    moveq   #$C,d1
    jsr SignedDiv
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    move.l  d0, d4
    asr.l   #$8, d4
    bra.b   l_1e950
l_1e94a:
    move.l  #$ffff, d4
l_1e950:
    cmpi.w  #$32, d4
    bls.b   l_1e95c
    moveq   #$0,d0
    move.w  d4, d0
    bra.b   l_1e95e
l_1e95c:
    moveq   #$32,d0
l_1e95e:
    moveq   #$0,d1
    move.w  d3, d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, $2(a5, a0.l)
    addq.l  #$4, a2
    addq.w  #$1, d3
    cmpi.w  #$7, d3
    bcs.b   l_1e910
    addq.l  #$4, a3
    moveq   #$10,d0
    adda.l  d0, a5
    moveq   #$20,d0
    adda.l  d0, a4
    addq.w  #$1, d5
    cmpi.w  #$4, d5
    bcs.w   l_1e876
    movem.l (a7)+, d2-d5/a2-a5
    rts

CalcCityStats:                                                  ; $01E98E
    link    a6,#-$8
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0008(a6),d5
    lea     -$0006(a6),a5
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    clr.w   d5
    moveq   #$0,d6
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1e9f8
.l1e9d8:                                                ; $01E9D8
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   d0,d6
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1e9f8:                                                ; $01E9F8
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l1e9d8
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    asr.l   #$1,d0
    move.w  d0,d5
    move.l  d6,d0
    add.l   d0,d0
    add.l   d6,d0
    lsr.l   #$1,d0
    move.l  d0,d6
    moveq   #$0,d0
    move.b  $0002(a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1eaa2
.l1ea36:                                                ; $01EA36
    moveq   #$0,d0
    move.b  $0002(a3),d0
    moveq   #$0,d1
    move.w  d4,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    dc.w    $4eba,$01c8                                 ; jsr $01EC0E
    nop
    addq.l  #$4,sp
    tst.w   d0
    ble.b   .l1ea82
    moveq   #$0,d0
    move.b  $0001(a2),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    asr.l   #$1,d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$1,d0
    bra.b   .l1ea9c
.l1ea82:                                                ; $01EA82
    moveq   #$0,d0
    move.b  $0001(a2),d0
    add.w   d0,d5
    moveq   #$0,d0
    move.b  $0003(a2),d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l1ea9c:                                                ; $01EA9C
    add.l   d0,d6
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1eaa2:                                                ; $01EAA2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l1ea36
    moveq   #$0,d1
    move.w  d5,d1
    move.l  d6,d0
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    move.l  d0,d6
    clr.w   d2
.l1eac0:                                                ; $01EAC0
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    clr.w   (a5,a0.l)
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eac0
    moveq   #$0,d0
    move.b  (a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1eb44
.l1eaea:                                                ; $01EAEA
    clr.w   d2
.l1eaec:                                                ; $01EAEC
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    moveq   #$0,d1
    move.b  $0002(a2),d1
    cmp.w   d1,d0
    bcc.b   .l1eb38
    moveq   #$2,d3
    bra.b   .l1eb20
.l1eb06:                                                ; $01EB06
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    subq.w  #$1,d3
.l1eb20:                                                ; $01EB20
    cmp.w   d2,d3
    bgt.b   .l1eb06
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    bra.b   .l1eb40
.l1eb38:                                                ; $01EB38
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eaec
.l1eb40:                                                ; $01EB40
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1eb44:                                                ; $01EB44
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l1eaea
    moveq   #$0,d0
    move.b  $0002(a3),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d4
    bra.b   .l1ebc4
.l1eb6a:                                                ; $01EB6A
    clr.w   d2
.l1eb6c:                                                ; $01EB6C
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    moveq   #$0,d1
    move.b  $0002(a2),d1
    cmp.w   d1,d0
    bcc.b   .l1ebb8
    moveq   #$2,d3
    bra.b   .l1eba0
.l1eb86:                                                ; $01EB86
    move.w  d3,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  -$2(a5,a0.l),d0
    move.w  d3,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    subq.w  #$1,d3
.l1eba0:                                                ; $01EBA0
    cmp.w   d2,d3
    bgt.b   .l1eb86
    moveq   #$0,d0
    move.b  $0002(a2),d0
    move.w  d2,d1
    ext.l   d1
    add.l   d1,d1
    movea.l d1,a0
    move.w  d0,(a5,a0.l)
    bra.b   .l1ebc0
.l1ebb8:                                                ; $01EBB8
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1eb6c
.l1ebc0:                                                ; $01EBC0
    addq.l  #$4,a2
    addq.w  #$1,d4
.l1ebc4:                                                ; $01EBC4
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l1eb6a
    clr.w   d3
    clr.w   d2
.l1ebd6:                                                ; $01EBD6
    move.w  d2,d0
    ext.l   d0
    add.l   d0,d0
    movea.l d0,a0
    move.w  (a5,a0.l),d0
    add.w   d0,d3
    addq.w  #$1,d2
    cmpi.w  #$3,d2
    blt.b   .l1ebd6
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$3,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    move.w  d5,(a4)
    move.b  d3,$0002(a4)
    move.b  d6,$0003(a4)
    movem.l -$002c(a6),d2-d6/a2-a5
    unlk    a6
    rts
; === Translated block $01EC0E-$020000 ===
; 11 functions, 5106 bytes

; ============================================================================
; GetPlayerInput -- (TODO: name)
; 50 bytes | $01EC0E-$01EC3F
; ============================================================================
GetPlayerInput:
    move.l  d2, -(a7)
    clr.w   d1
    move.w  $a(a7), d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    clr.w   d2
l_1ec26:
    tst.b   $1(a1)
    beq.b   l_1ec30
    moveq   #$1,d1
    bra.b   l_1ec3a
l_1ec30:
    addq.l  #$2, a1
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ec26
l_1ec3a:
    move.w  d1, d0
    move.l  (a7)+, d2
    rts

; ============================================================================
; ProcessInputEvent -- (TODO: name)
; 794 bytes | $01EC40-$01EF59
; ============================================================================
ProcessInputEvent:
    link    a6,#-$4
    movem.l d2-d6/a2-a5, -(a7)
    pea     ($0080).w
    clr.l   -(a7)
    pea     ($00FF01B0).l
    jsr MemFillByte
    pea     ($0070).w
    clr.l   -(a7)
    pea     ($00FF1004).l
    jsr MemFillByte
    lea     $18(a7), a7
    clr.w   d3
    movea.l  #$00FF0018,a5
    clr.w   d2
l_1ec7a:
    tst.b   $4(a5)
    beq.b   l_1ec84
    moveq   #$1,d3
    bra.b   l_1ec90
l_1ec84:
    moveq   #$24,d0
    adda.l  d0, a5
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ec7a
l_1ec90:
    moveq   #$1,d6
    cmpi.w  #$1, d3
    bne.w   l_1edde
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0007).w
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
    moveq   #$1,d6
    movea.l  #$00FF0018,a5
    clr.w   d2
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1ecc8:
    move.w  d2, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d3
    bra.b   l_1ed54
l_1ecf0:
    tst.w   $4(a2)
    bne.b   l_1ed16
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (RenderAnimFrame,PC)
    nop
    pea     ($0007).w
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ed16:
    moveq   #$0,d0
    move.w  $8(a3), d0
    bge.b   l_1ed22
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed22:
    asr.l   #$7, d0
    moveq   #$0,d1
    move.w  (a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$0,d0
    move.w  $8(a3), d0
    bge.b   l_1ed3c
    moveq   #$7F,d1
    add.l   d1, d0
l_1ed3c:
    asr.l   #$7, d0
    moveq   #$0,d1
    move.w  $2(a2), d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$14,d0
    adda.l  d0, a3
    addq.l  #$8, a2
    addq.w  #$1, d3
l_1ed54:
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$0,d1
    move.b  $4(a5), d1
    cmp.l   d1, d0
    blt.b   l_1ecf0
    clr.w   d4
    move.w  ($00FF0002).l, d3
l_1ed6a:
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    addq.l  #$3, d0
    moveq   #$0,d1
    move.w  d4, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.b   l_1ed6a
    moveq   #$0,d0
    move.b  $1(a5), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d3
    move.w  ($00FF0002).l, d0
    ext.l   d0
    bge.b   l_1eda6
    addq.l  #$1, d0
l_1eda6:
    asr.l   #$1, d0
    addq.l  #$1, d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   d0, (a4,a0.l)
    moveq   #$24,d0
    adda.l  d0, a5
    moveq   #$1C,d0
    adda.l  d0, a4
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1ecc8
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1edde
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
l_1edde:
    movea.l  #$0005ECBC,a3
    clr.w   d4
l_1ede6:
    clr.w   d3
    clr.w   d2
l_1edea:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$20, d5
    bcc.b   l_1ee26
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_1ee26
    moveq   #$1,d3
    bra.b   l_1ee2e
l_1ee26:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1edea
l_1ee2e:
    cmpi.w  #$1, d3
    bne.w   l_1ef2e
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (MapInputToAction,PC)
    nop
    addq.l  #$8, a7
    moveq   #$1,d6
    moveq   #$0,d3
    move.b  $2(a3), d3
    bra.b   l_1ee98
l_1ee54:
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1ee66:
    tst.b   $1(a2)
    bne.b   l_1ee76
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1ee66
l_1ee76:
    cmpi.w  #$4, d2
    bcc.b   l_1ee96
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$8, a7
l_1ee96:
    addq.w  #$1, d3
l_1ee98:
    moveq   #$0,d0
    move.b  $2(a3), d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1ee54
    moveq   #$0,d3
    move.b  (a3), d3
    bra.b   l_1ef1a
l_1eeb4:
    move.w  d3, d0
    lsl.w   #$3, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
l_1eec6:
    tst.b   $1(a2)
    bne.b   l_1eed6
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1eec6
l_1eed6:
    cmpi.w  #$4, d2
    bcc.b   l_1ef18
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (ValidateInputState,PC)
    nop
    cmpi.w  #$1, d0
    bne.b   l_1eefc
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FadeGraphics,PC)
    nop
    bra.b   l_1ef08
l_1eefc:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (PositionUIControl,PC)
    nop
l_1ef08:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    lea     $c(a7), a7
l_1ef18:
    addq.w  #$1, d3
l_1ef1a:
    moveq   #$0,d0
    move.b  (a3), d0
    moveq   #$0,d1
    move.b  $1(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d3, d1
    cmp.l   d1, d0
    bgt.b   l_1eeb4
l_1ef2e:
    cmpi.w  #$1, ($00FF000A).l
    bne.b   l_1ef44
    pea     ($003C).w
    jsr PollInputChange
    addq.l  #$4, a7
l_1ef44:
    addq.l  #$4, a3
    addq.w  #$1, d4
    cmpi.w  #$7, d4
    bcs.w   l_1ede6
    movem.l -$28(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; MapInputToAction -- (TODO: name)
; 416 bytes | $01EF5A-$01F0F9
; ============================================================================
MapInputToAction:
    movem.l d2-d3/a2-a3, -(a7)
    move.l  $18(a7), d2
    move.l  $14(a7), d3
    movea.l  #$0003B270,a2
    movea.l  #$00000D64,a3
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_1f0f4
    cmpi.w  #$7, d3
    bcc.b   l_1efc6
    jsr ResourceLoad
    clr.l   -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    pea     ($0004).w
    jsr LoadScreen
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $18(a7), a7
    tst.w   d2
    bne.b   l_1efbe
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$4, a7
l_1efbe:
    jsr ResourceUnload
    bra.b   l_1eff8
l_1efc6:
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    clr.l   -(a7)
    jsr CmdSetBackground
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0004).w
    jsr LoadScreenGfx
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    jsr     (a3)
    lea     $28(a7), a7
l_1eff8:
    cmpi.w  #$1, d2
    bne.w   l_1f0a2
    pea     ($0004).w
    pea     ($0031).w
    pea     ($00FF0118).l
    jsr DisplaySetup
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $1c(a7), a7
    clr.w   d2
l_1f02c:
    moveq   #$0,d0
    move.w  d2, d0
    addi.l  #$774, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    pea     ($0003).w
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    jsr FillTileRect
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    addq.l  #$3, d0
    move.l  d0, -(a7)
    pea     ($0001).w
    jsr SetTextCursor
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($000411EE).l
    jsr     (a2)
    lea     $30(a7), a7
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f02c
l_1f0a2:
    pea     ($0006).w
    pea     ($001C).w
    pea     ($0015).w
    pea     ($0002).w
    jsr DrawBox
    lea     $10(a7), a7
    cmpi.w  #$7, d3
    bcc.b   l_1f0dc
    move.w  d3, d0
    lsl.w   #$2, d0
    movea.l  #$0005EC84,a0
    move.l  (a0,d0.w), -(a7)
    pea     ($000411D6).l
    jsr     (a2)
    addq.l  #$8, a7
    bra.b   l_1f0e6
l_1f0dc:
    pea     ($000411AA).l
    jsr     (a2)
    addq.l  #$4, a7
l_1f0e6:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (UpdateAnimation,PC)
    nop
    addq.l  #$4, a7
l_1f0f4:
    movem.l (a7)+, d2-d3/a2-a3
    rts

; ============================================================================
; ValidateInputState -- (TODO: name)
; 66 bytes | $01F0FA-$01F13B
; ============================================================================
ValidateInputState:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d3
    cmpi.w  #$20, d3
    bcc.b   l_1f132
    clr.w   d4
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$1,d1
    lsl.l   d0, d1
    move.l  d1, d3
    movea.l  #$00FF08EC,a0
    clr.w   d2
l_1f11c:
    move.l  d3, d0
    and.l   (a0), d0
    beq.b   l_1f126
    moveq   #$1,d4
    bra.b   l_1f134
l_1f126:
    addq.l  #$4, a0
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f11c
    bra.b   l_1f134
l_1f132:
    clr.w   d4
l_1f134:
    move.w  d4, d0
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; UpdateAnimation -- (TODO: name)
; 534 bytes | $01F13C-$01F351
; ============================================================================
UpdateAnimation:
    movem.l d2-d7/a2-a4, -(a7)
    move.l  $28(a7), d6
    movea.l  #$00FF0002,a4
    cmpi.w  #$1, ($00FF000A).l
    bne.w   l_1f34c
    clr.w   d5
    cmpi.w  #$7, d6
    bcc.b   l_1f1a6
    clr.w   d3
l_1f160:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d2
    cmpi.w  #$20, d2
    bcc.b   l_1f19c
    move.w  d2, d0
    lsl.w   #$3, d0
    move.w  d3, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA81,a0
    move.b  (a0,d0.w), d4
    andi.l  #$ff, d4
    cmp.w   d5, d4
    bls.b   l_1f19c
    move.w  d4, d5
l_1f19c:
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_1f160
    bra.b   l_1f1f4
l_1f1a6:
    movea.l  #$00FF0018,a3
    clr.w   d3
l_1f1ae:
    clr.w   d4
    move.w  d3, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.w   d2
    bra.b   l_1f1d4
l_1f1c6:
    moveq   #$0,d0
    move.b  $3(a2), d0
    add.w   d0, d4
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1f1d4:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a3), d1
    cmp.l   d1, d0
    blt.b   l_1f1c6
    cmp.w   d5, d4
    bls.b   l_1f1e8
    move.w  d4, d5
l_1f1e8:
    moveq   #$24,d0
    adda.l  d0, a3
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.b   l_1f1ae
l_1f1f4:
    tst.w   (a4)
    bne.b   l_1f200
    move.l  #$c0, d2
    bra.b   l_1f222
l_1f200:
    cmpi.w  #$1, (a4)
    bne.b   l_1f20e
    move.l  #$190, d2
    bra.b   l_1f222
l_1f20e:
    cmpi.w  #$2, (a4)
    bne.b   l_1f21c
    move.l  #$1a0, d2
    bra.b   l_1f222
l_1f21c:
    move.l  #$320, d2
l_1f222:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, d1
    add.l   d0, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    move.l  d2, d1
    jsr Multiply32
    move.l  d0, d4
    moveq   #$1,d0
    cmp.l   d4, d0
    bcc.b   l_1f242
    move.l  d4, d0
    bra.b   l_1f244
l_1f242:
    moveq   #$1,d0
l_1f244:
    move.l  d0, d4
    pea     ($001B).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    jsr SetTextWindow
    lea     $10(a7), a7
    clr.w   d3
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d6, d1
    lsl.w   #$2, d1
    add.w   d1, d0
    movea.l  #$00FF01B0,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d5
    move.w  d3, d5
    move.l  d5, d0
    lsl.l   #$2, d5
    add.l   d0, d5
    addq.l  #$5, d5
    moveq   #$0,d7
    move.w  d3, d7
    move.l  d7, d0
    lsl.l   #$2, d7
    add.l   d0, d7
    lsl.l   #$3, d7
    addi.l  #$18, d7
l_1f292:
    move.l  (a2), d0
    move.l  d0, d1
    lsl.l   #$2, d0
    add.l   d1, d0
    lsl.l   #$2, d0
    lsl.l   #$3, d0
    move.l  d4, d1
    jsr UnsignedDivide
    move.w  d0, d2
    cmpi.w  #$a0, d2
    bcc.b   l_1f2b4
    moveq   #$0,d0
    move.w  d2, d0
    bra.b   l_1f2ba
l_1f2b4:
    move.l  #$a0, d0
l_1f2ba:
    addi.w  #$40, d0
    move.w  d0, d2
    move.w  d7, d6
    move.l  #$8000, -(a7)
    pea     ($0002).w
    pea     ($0002).w
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    addi.l  #$3b, d0
    move.l  d0, -(a7)
    pea     ($0750).w
    jsr TilePlacement
    pea     ($0002).w
    pea     ($000E).w
    jsr GameCommand
    move.l  d5, -(a7)
    pea     ($0013).w
    jsr SetTextCursor
    lea     $2c(a7), a7
    move.l  (a2), -(a7)
    pea     ($000411F2).l
    jsr PrintfNarrow
    move.w  d5, d0
    move.l  d0, -(a7)
    pea     ($001D).w
    pea     ($0001).w
    pea     ($0001).w
    jsr PlaceIconTiles
    lea     $18(a7), a7
    moveq   #$28,d0
    add.l   d0, d7
    addq.l  #$5, d5
    moveq   #$20,d0
    adda.l  d0, a2
    addq.w  #$1, d3
    cmpi.w  #$4, d3
    bcs.w   l_1f292
l_1f34c:
    movem.l (a7)+, d2-d7/a2-a4
    rts

; ============================================================================
; RenderAnimFrame -- (TODO: name)
; 1134 bytes | $01F352-$01F7BF
; ============================================================================
RenderAnimFrame:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $c(a6), d7
    movea.l  #$00FF0002,a4
    lea     -$14(a6), a5
    move.w  #$3a98, d6
    move.w  d3, d0
    mulu.w  #$140, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  (a2), -$4(a6)
    move.w  $2(a2), -$6(a6)
    move.w  -$4(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  -$6(a6), d0
    lsl.w   #$2, d0
    movea.l  #$00FFBDE4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a3), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a3), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, -$c(a6)
    moveq   #$0,d0
    move.b  $3(a2), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  (a2), d0
    moveq   #$0,d1
    move.w  -$c(a6), d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d0, -$a(a6)
    move.w  ($00FFBD4C).l, d0
    ext.l   d0
    moveq   #$64,d1
    sub.l   d0, d1
    move.l  d1, d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    jsr Multiply32
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  $2(a2), d0
    ext.l   d0
    move.w  ($00FFBD4C).l, d1
    ext.l   d1
    jsr Multiply32
    add.l   (a7)+, d0
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, d2
    moveq   #$0,d0
    move.b  $3(a3), d0
    andi.l  #$ffff, d0
    moveq   #$5A,d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    addi.w  #$a, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  (a3), d0
    moveq   #$0,d1
    move.w  d2, d1
    jsr Multiply32
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d0, d2
    move.l  -$a(a6), d0
    add.l   d2, d0
    moveq   #$0,d1
    move.w  d6, d1
    jsr UnsignedDivide
    move.w  d0, -$2(a6)
    clr.w   d2
    bra.b   l_1f4dc
l_1f4cc:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  #$ff, (a5,a0.l)
    addq.w  #$1, d2
l_1f4dc:
    cmp.w   d3, d2
    bcs.b   l_1f4cc
    moveq   #$0,d0
    move.w  d3, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  d7, (a5,a0.l)
    move.w  d3, d2
    bra.b   l_1f51c
l_1f4f0:
    moveq   #$0,d0
    move.w  -$6(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$4(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (TransitionEffect,PC)
    nop
    lea     $c(a7), a7
    moveq   #$0,d1
    move.w  d2, d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  d0, (a5,a0.l)
l_1f51c:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1f4f0
    clr.w   d7
    moveq   #$0,d6
    move.w  d3, d2
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$24(a6, d0.w), a0
    movea.l a0, a2
    bra.w   l_1f5de
l_1f538:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    cmpi.w  #$28, d4
    bcc.w   l_1f5da
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1f5da
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF0230,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  -$4(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  -$6(a6), d1
    add.l   d1, d1
    movea.l d1, a0
    move.w  $2(a3, a0.l), d1
    andi.l  #$ffff, d1
    add.l   d1, d0
    move.w  d2, d1
    mulu.w  #$140, d1
    movea.l d7, a0
    move.w  d4, d7
    lsl.w   #$3, d7
    exg     d7, a0
    add.w   a0, d1
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d1.w), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.l  d0, (a2)
    add.l   (a2), d6
    addq.w  #$1, d7
l_1f5da:
    addq.l  #$4, a2
    addq.w  #$1, d2
l_1f5de:
    cmpi.w  #$4, d2
    bcs.w   l_1f538
    move.w  d3, d2
    bra.w   l_1f7ae
l_1f5ec:
    moveq   #$0,d0
    move.w  d2, d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a5,a0.l), d4
    cmpi.w  #$28, d4
    bcc.w   l_1f7ac
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d4, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_1f726
    move.w  d2, d0
    lsl.w   #$4, d0
    movea.l  #$00FF0230,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    tst.l   d6
    beq.b   l_1f65a
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$24(a6, d0.w), d0
    moveq   #$0,d1
    move.w  -$2(a6), d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    bra.b   l_1f66a
l_1f65a:
    moveq   #$0,d0
    move.w  -$2(a6), d0
    moveq   #$0,d1
    move.w  d7, d1
    jsr SignedDiv
l_1f66a:
    move.w  d0, d3
    moveq   #$0,d0
    move.w  -$6(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    move.w  (a4), d1
    ext.l   d1
    addq.l  #$2, d1
    jsr SignedDiv
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  -$4(a6), d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  $2(a3, a0.l), d0
    andi.l  #$ffff, d0
    move.w  (a4), d1
    ext.l   d1
    addq.l  #$2, d1
    jsr SignedDiv
    add.l   (a7)+, d0
    move.l  d0, d5
    tst.l   d5
    bge.b   l_1f6b8
    addq.l  #$1, d5
l_1f6b8:
    asr.l   #$1, d5
    cmpi.l  #$36b0, d5
    bge.b   l_1f6c6
    move.l  d5, d0
    bra.b   l_1f6cc
l_1f6c6:
    move.l  #$36b0, d0
l_1f6cc:
    add.w   d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CalcTypeDistance
    addq.l  #$8, a7
    move.w  d0, d5
    cmpi.w  #$3, d5
    bne.b   l_1f6fe
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f6f8
    addq.l  #$3, d0
l_1f6f8:
    asr.l   #$2, d0
l_1f6fa:
    move.w  d0, d3
    bra.b   l_1f728
l_1f6fe:
    cmpi.w  #$2, d5
    bne.b   l_1f710
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f70c
    addq.l  #$1, d0
l_1f70c:
    asr.l   #$1, d0
    bra.b   l_1f6fa
l_1f710:
    cmpi.w  #$1, d5
    bne.b   l_1f728
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$5,d1
    jsr SignedDiv
    sub.w   d0, d3
    bra.b   l_1f728
l_1f726:
    clr.w   d3
l_1f728:
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d4, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d3, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d3
    tst.w   (a4)
    bne.b   l_1f76a
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f764
    addq.l  #$1, d0
l_1f764:
    asr.l   #$1, d0
l_1f766:
    add.w   d0, d3
    bra.b   l_1f790
l_1f76a:
    cmpi.w  #$1, (a4)
    bne.b   l_1f77c
    moveq   #$0,d0
    move.w  d3, d0
    bge.b   l_1f778
    addq.l  #$3, d0
l_1f778:
    asr.l   #$2, d0
    bra.b   l_1f766
l_1f77c:
    cmpi.w  #$3, (a4)
    bne.b   l_1f790
    moveq   #$0,d0
    move.w  d3, d0
    moveq   #$3,d1
    jsr SignedDiv
    sub.w   d0, d3
l_1f790:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (UpdateUIPalette,PC)
    nop
    lea     $c(a7), a7
l_1f7ac:
    addq.w  #$1, d2
l_1f7ae:
    cmpi.w  #$4, d2
    bcs.w   l_1f5ec
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; TransitionEffect -- (TODO: name)
; 110 bytes | $01F7C0-$01F82D
; ============================================================================
TransitionEffect:
    movem.l d2-d5/a2, -(a7)
    move.l  $20(a7), d3
    move.l  $1c(a7), d4
    move.l  $18(a7), d5
    move.w  d5, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    move.w  d5, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  #$ff, d5
    clr.w   d2
    bra.b   l_1f818
l_1f7fc:
    cmp.w   (a2), d4
    bne.b   l_1f80a
    cmp.w   $2(a2), d3
l_1f804:
    bne.b   l_1f814
    move.w  d2, d5
    bra.b   l_1f826
l_1f80a:
    cmp.w   (a2), d3
    bne.b   l_1f814
    cmp.w   $2(a2), d4
    bra.b   l_1f804
l_1f814:
    addq.l  #$8, a2
    addq.w  #$1, d2
l_1f818:
    moveq   #$0,d0
    move.w  d2, d0
    moveq   #$0,d1
    move.b  $4(a1), d1
    cmp.l   d1, d0
    blt.b   l_1f7fc
l_1f826:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts

; ============================================================================
; FadeGraphics -- (TODO: name)
; 854 bytes | $01F82E-$01FB83
; ============================================================================
FadeGraphics:
    link    a6,#-$24
    movem.l d2-d7/a2-a5, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr RangeLookup
    addq.l  #$4, a7
    move.w  d0, d5
    lsl.w   #$2, d0
    movea.l  #$0005ECBC,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    movea.l  #$00FF0120,a5
    move.w  $a(a6), d5
    bra.w   l_1fb52
l_1f866:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    bsr.w ValidateInputState
    addq.l  #$4, a7
    tst.w   d0
    beq.w   l_1fb52
    clr.w   d2
l_1f87a:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ManageUIElement,PC)
    nop
    lea     $c(a7), a7
    move.w  d2, d1
    add.w   d1, d1
    move.w  d0, -$c(a6, d1.w)
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.b   l_1f8f4
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1f8f4
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E8,a0
    tst.w   (a0,d0.w)
    bne.b   l_1f8ea
    addq.w  #$1, d7
    bra.b   l_1f8f4
l_1f8ea:
    move.w  d2, d0
    add.w   d0, d0
    move.w  #$ff, -$c(a6, d0.w)
l_1f8f4:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f87a
    cmpi.w  #$1, d7
    bls.w   l_1fa6c
    moveq   #$0,d6
    clr.w   d2
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
l_1f92e:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fa58
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    lea     (a2,d0.l), a0
    move.l  a0, -$10(a6)
    move.b  $a(a4), d0
    andi.l  #$2, d0
    bne.w   l_1fa58
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1f99a
    moveq   #$0,d0
    move.w  $4(a4), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    bra.b   l_1f9a0
l_1f99a:
    move.l  #$1, -(a7)
l_1f9a0:
    movea.l -$10(a6), a0
    move.w  (a0), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a3,a0.l), d0
    movea.l -$10(a6), a0
    move.w  $2(a0), d1
    andi.l  #$ffff, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   (a3,a0.l), d0
    moveq   #$0,d1
    move.w  d3, d1
    lsl.l   #$3, d1
    movea.l d1, a0
    move.w  $6(a2, a0.l), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr UnsignedDivide
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    moveq   #$0,d1
    move.b  (a5), d1
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    jsr Multiply32
    move.l  d0, (a0)
    exg     d0, a1
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$20(a6, d0.w), a0
    movea.l d0, a1
    move.l  (a0), d0
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a0)
    exg     d0, a1
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$1,d1
    cmp.l   d0, d1
    bcc.b   l_1fa44
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    bra.b   l_1fa46
l_1fa44:
    moveq   #$1,d0
l_1fa46:
    move.w  d2, d1
    lsl.w   #$2, d1
    move.l  d0, -$20(a6, d1.w)
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    add.l   d0, d6
l_1fa58:
    addq.l  #$4, a5
    lea     $140(a2), a2
    moveq   #$1C,d0
    adda.l  d0, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1f92e
l_1fa6c:
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  $a(a6), d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    addq.l  #$8, a7
    move.w  d0, -$22(a6)
    clr.w   d2
l_1fa88:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$c(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fb48
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1fae4
    cmpi.w  #$1, d7
    bls.b   l_1fade
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$20(a6, d0.w), d0
    moveq   #$0,d1
    move.w  -$22(a6), d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    move.w  d0, d4
    bra.b   l_1fae6
l_1fade:
    move.w  -$22(a6), d4
    bra.b   l_1fae6
l_1fae4:
    clr.w   d4
l_1fae6:
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ValidateTradeReq,PC)
    nop
    mulu.w  d4, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (UpdateUIPalette,PC)
    nop
    lea     $14(a7), a7
l_1fb48:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fa88
l_1fb52:
    addq.w  #$1, d5
    movea.l -$4(a6), a0
    move.b  $1(a0), d0
    andi.l  #$ff, d0
    movea.l -$4(a6), a0
    move.b  (a0), d1
    andi.l  #$ff, d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d5, d1
    cmp.l   d1, d0
    bgt.w   l_1f866
    movem.l -$4c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; ManageUIElement -- (TODO: name)
; 204 bytes | $01FB84-$01FC4F
; ============================================================================
ManageUIElement:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $28(a7), d3
    move.l  $24(a7), d4
    move.w  #$ff, d6
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d5
    move.b  $4(a3), d5
    moveq   #$0,d0
    move.b  $5(a3), d0
    add.w   d0, d5
    move.w  d4, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    tst.b   $1(a2)
    beq.b   l_1fc48
    tst.b   $1(a1)
    beq.b   l_1fc48
    moveq   #$0,d0
    move.b  $4(a3), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a3), d2
    bra.b   l_1fc44
l_1fc16:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d4, d0
    bne.b   l_1fc2c
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
l_1fc26:
    bne.b   l_1fc3e
    move.w  d2, d6
    bra.b   l_1fc48
l_1fc2c:
    moveq   #$0,d0
    move.b  (a2), d0
    cmp.w   d3, d0
    bne.b   l_1fc3e
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d4, d0
    bra.b   l_1fc26
l_1fc3e:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1fc44:
    cmp.w   d5, d2
    bcs.b   l_1fc16
l_1fc48:
    move.w  d6, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

; ============================================================================
; PositionUIControl -- (TODO: name)
; 700 bytes | $01FC50-$01FF0B
; ============================================================================
PositionUIControl:
    link    a6,#-$20
    movem.l d2-d6/a2-a5, -(a7)
    move.l  $8(a6), d4
    clr.w   d5
    clr.w   d2
    move.w  d2, d0
    add.w   d0, d0
    lea     -$8(a6, d0.w), a0
    movea.l a0, a2
l_1fc6a:
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ResizeUIPanel,PC)
    nop
    addq.l  #$8, a7
    move.w  d0, (a2)
    move.w  (a2), d3
    cmpi.w  #$28, d3
    bcc.b   l_1fcc8
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A2A,a0
    move.b  (a0,d0.w), d0
    andi.l  #$2, d0
    bne.b   l_1fcc8
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E8,a0
    tst.w   (a0,d0.w)
    bne.b   l_1fcc4
    addq.w  #$1, d5
    bra.b   l_1fcc8
l_1fcc4:
    move.w  #$ff, (a2)
l_1fcc8:
    addq.l  #$2, a2
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.b   l_1fc6a
    cmpi.w  #$1, d5
    bls.w   l_1fe20
    moveq   #$0,d6
    move.l  #$ff0120, -$20(a6)
    clr.w   d2
    move.w  d2, d0
    lsl.w   #$2, d0
    lea     -$18(a6, d0.w), a0
    movea.l a0, a3
    move.w  d2, d0
    mulu.w  #$1c, d0
    movea.l  #$00FF1004,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.w  d2, d0
    mulu.w  #$140, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
l_1fd14:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fe08
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.w  d3, d0
    lsl.l   #$3, d0
    move.l  d0, d3
    lea     (a4,d0.l), a0
    move.l  a0, -$1c(a6)
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.w   l_1fe08
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$64,d1
    jsr SignedDiv
    moveq   #$1,d1
    cmp.l   d0, d1
    bge.b   l_1fd82
    moveq   #$0,d0
    move.w  $4(a2), d0
    moveq   #$64,d1
    jsr SignedDiv
    move.l  d0, -(a7)
    bra.b   l_1fd88
l_1fd82:
    move.l  #$1, -(a7)
l_1fd88:
    movea.l -$1c(a6), a0
    move.w  (a0), d0
    andi.l  #$ffff, d0
    lsl.l   #$2, d0
    movea.l d0, a0
    move.l  (a5,a0.l), d0
    movea.l -$1c(a6), a0
    move.w  $2(a0), d1
    andi.l  #$ffff, d1
    lsl.l   #$2, d1
    movea.l d1, a0
    add.l   (a5,a0.l), d0
    movea.l a4, a0
    adda.l  d3, a0
    move.w  $6(a0), d1
    andi.l  #$ffff, d1
    jsr Multiply32
    move.l  (a7)+, d1
    jsr UnsignedDivide
    moveq   #$64,d1
    jsr UnsignedDivide
    move.l  d0, (a3)
    movea.l -$20(a6), a0
    move.b  (a0), d1
    andi.l  #$ff, d1
    move.l  (a3), d0
    jsr Multiply32
    move.l  d0, (a3)
    moveq   #$A,d1
    jsr UnsignedDivide
    move.l  d0, (a3)
    moveq   #$1,d0
    cmp.l   (a3), d0
    bcc.b   l_1fe02
    move.l  (a3), d0
    bra.b   l_1fe04
l_1fe02:
    moveq   #$1,d0
l_1fe04:
    move.l  d0, (a3)
    add.l   (a3), d6
l_1fe08:
    addq.l  #$4, -$20(a6)
    lea     $140(a4), a4
    moveq   #$1C,d0
    adda.l  d0, a5
    addq.l  #$4, a3
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fd14
l_1fe20:
    clr.w   d2
l_1fe22:
    move.w  d2, d0
    add.w   d0, d0
    move.w  -$8(a6, d0.w), d3
    cmpi.w  #$28, d3
    bcc.w   l_1fef8
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d3, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  $a(a2), d0
    andi.l  #$2, d0
    bne.b   l_1fe94
    moveq   #$0,d0
    move.b  $1(a2), d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    move.l  d0, -(a7)
    jsr CalcNegotiationPower
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$1, d5
    bls.b   l_1fe96
    move.w  d2, d0
    lsl.w   #$2, d0
    move.l  -$18(a6, d0.w), d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    move.l  d6, d1
    jsr UnsignedDivide
    move.w  d0, d4
    bra.b   l_1fe96
l_1fe94:
    clr.w   d4
l_1fe96:
    move.w  d2, d0
    mulu.w  #$140, d0
    move.w  d3, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4EA,a0
    move.w  (a0,d0.w), d0
    andi.l  #$ffff, d0
    moveq   #$0,d1
    move.w  d4, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr UnsignedDivide
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (ValidateTradeReq,PC)
    nop
    mulu.w  d4, d0
    move.w  d0, d4
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr (UpdateUIPalette,PC)
    nop
    lea     $14(a7), a7
l_1fef8:
    addq.w  #$1, d2
    cmpi.w  #$4, d2
    bcs.w   l_1fe22
    movem.l -$44(a6), d2-d6/a2-a5
    unlk    a6
    rts

; ============================================================================
; ResizeUIPanel -- (TODO: name)
; 146 bytes | $01FF0C-$01FF9D
; ============================================================================
ResizeUIPanel:
    movem.l d2-d5/a2, -(a7)
    move.l  $18(a7), d2
    move.l  $1c(a7), d3
    move.w  #$ff, d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a1
    moveq   #$0,d4
    move.b  $4(a1), d4
    moveq   #$0,d0
    move.b  $5(a1), d0
    add.w   d0, d4
    move.w  d3, d0
    lsl.w   #$3, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFBA80,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    tst.b   $1(a2)
    beq.b   l_1ff96
    moveq   #$0,d0
    move.b  $4(a1), d0
    mulu.w  #$14, d0
    move.w  d2, d1
    mulu.w  #$320, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d2
    move.b  $4(a1), d2
    bra.b   l_1ff92
l_1ff7e:
    moveq   #$0,d0
    move.b  $1(a2), d0
    cmp.w   d3, d0
    bne.b   l_1ff8c
    move.w  d2, d5
    bra.b   l_1ff96
l_1ff8c:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_1ff92:
    cmp.w   d4, d2
    bcs.b   l_1ff7e
l_1ff96:
    move.w  d5, d0
    movem.l (a7)+, d2-d5/a2
    rts


; === Translated block $01FF9E-$020000 ===
; 1 functions, 98 bytes

; ============================================================================
; UpdateUIPalette -- (TODO: name)
; 98 bytes | $01FF9E-$01FFFF
; ============================================================================
UpdateUIPalette:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $10(a6), d3
    move.l  $8(a6), d6
    move.l  $c(a6), d7
    move.w  d6, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    move.l  a0, -$4(a6)
    move.w  d6, d0
    mulu.w  #$320, d0
    move.w  d7, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d0
    mulu.w  #$140, d0
    move.w  d7, d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FFB4E4,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    moveq   #$0,d0



