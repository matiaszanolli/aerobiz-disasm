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
    dc.w    $48E7,$3C00; $010CAC
    dc.w    $242F,$0018,$262F,$0014,$282F,$0020,$2A2F,$001C; $010CB0
    dc.w    $3003,$2F00,$4878,$0001,$3002,$C0FC,$001E,$0640; $010CC0
    dc.w    $0560,$2F00,$4878,$0002,$3004,$2F00,$3005,$2F00; $010CD0
    dc.w    $3003,$C0FC,$000A,$3202,$D241,$D041,$207C,$00FF; $010CE0
    dc.w    $03B8,$3230,$0000,$2F01,$4EB9,$0000,$5F00,$4FEF; $010CF0
    dc.w    $001C,$4CDF,$003C,$4E75,$4E56,$FFF0,$48E7,$3F3C; $010D00
    dc.w    $2C2E,$0008,$2E2E,$000C,$287C,$0000,$0D64,$2A7C; $010D10
    dc.w    $00FF,$1804,$4878,$000E,$42A7,$486E,$FFF2,$4EB9; $010D20
    dc.w    $0001,$D520,$4EB9,$0001,$D71C,$42A7,$4EB9,$0000; $010D30
    dc.w    $538E,$4878,$0040,$42A7,$4878,$0010,$4E94,$4878; $010D40
    dc.w    $0010,$4878,$0030,$4879,$0004,$A5BA,$4EB9,$0000; $010D50
    dc.w    $5092,$4FEF,$0028,$4879,$0004,$A5DA,$4878,$0006; $010D60
    dc.w    $4878,$0008,$4878,$0002,$4878,$0003,$42A7,$4878; $010D70
    dc.w    $001B,$4E94,$4879,$0004,$A63A,$2F0D,$4EB9,$0000; $010D80
    dc.w    $3FEC,$4FEF,$0024,$42A7,$42A7,$2F0D,$4878,$0025; $010D90
    dc.w    $4878,$0330,$4EB9,$0001,$D568,$4FEF,$0014,$0C47; $010DA0
    dc.w    $0003,$6C5C,$3007,$D040,$207C,$0004,$797C,$3030; $010DB0
    dc.w    $0000,$0280,$0000,$FFFF,$E588,$207C,$000A,$1B14; $010DC0
    dc.w    $2F30,$0800,$2F0D,$4EB9,$0000,$3FEC,$4878,$0014; $010DD0
    dc.w    $4878,$03CD,$2F0D,$4EB9,$0000,$4668,$4879,$0007; $010DE0
    dc.w    $1F98,$4878,$0004,$4878,$0005,$4878,$0003,$4878; $010DF0
    dc.w    $0019,$4878,$0001,$4878,$001B,$4E94,$4FEF,$0030; $010E00
    dc.w    $3006,$EB48,$207C,$00FF,$0338,$41F0,$0000,$2448; $010E10
    dc.w    $4243,$3A03,$0245,$0001,$CAFC,$0006,$0645,$000D; $010E20
    dc.w    $3803,$48C4,$E284,$E74C,$5444,$3004,$2F00,$3005; $010E30
    dc.w    $2F00,$3003,$2F00,$3006,$2F00,$6100,$FE60,$4FEF; $010E40
    dc.w    $0010,$4A2A,$0001,$664E,$42A7,$4878,$0002,$4878; $010E50
    dc.w    $0001,$3004,$48C0,$E788,$0680,$0000,$0028,$2F00; $010E60
    dc.w    $3005,$48C0,$E788,$0680,$0000,$0020,$2F00,$3003; $010E70
    dc.w    $48C0,$0680,$0000,$003B,$2F00,$4878,$0544,$4EB9; $010E80
    dc.w    $0001,$E044,$4878,$0001,$4878,$000E,$4E94,$4FEF; $010E90
    dc.w    $0024,$6000,$013A,$0C2A,$0006,$0001,$660E,$0C6A; $010EA0
    dc.w    $0003,$0006,$6706,$7400,$1412,$6010,$7000,$1012; $010EB0
    dc.w    $2F00,$4EB9,$0000,$D648,$588F,$3400,$3002,$D040; $010EC0
    dc.w    $207C,$0005,$F088,$41F0,$0000,$2648,$42A7,$4878; $010ED0
    dc.w    $0002,$4878,$0001,$7000,$102B,$0001,$0680,$0000; $010EE0
    dc.w    $0010,$2F00,$3002,$D040,$3036,$00F2,$48C0,$7200; $010EF0
    dc.w    $1213,$D081,$0680,$0000,$0018,$2F00,$3003,$48C0; $010F00
    dc.w    $0680,$0000,$003B,$2F00,$4878,$0544,$4EB9,$0001; $010F10
    dc.w    $E044,$4878,$0001,$4878,$000E,$4E94,$3002,$D040; $010F20
    dc.w    $5676,$00F2,$3003,$48C0,$2F00,$3006,$48C0,$2F00; $010F30
    dc.w    $4EBA,$09C4,$4E71,$4FEF,$002C,$48C0,$7203,$4EB9; $010F40
    dc.w    $0003,$E08A,$3400,$0C42,$0005,$6C06,$3002,$48C0; $010F50
    dc.w    $6002,$7005,$3400,$4878,$0774,$4878,$0001,$4878; $010F60
    dc.w    $0020,$4878,$0001,$3002,$48C0,$2F00,$3004,$48C0; $010F70
    dc.w    $5C80,$2F00,$3005,$48C0,$2F00,$4878,$0001,$4EB9; $010F80
    dc.w    $0000,$6760,$4FEF,$0020,$3002,$48C0,$7205,$9280; $010F90
    dc.w    $6F3C,$4878,$0775,$4878,$0002,$4878,$0020,$4878; $010FA0
    dc.w    $0001,$3002,$48C0,$7205,$9280,$2F01,$3004,$48C0; $010FB0
    dc.w    $5C80,$2F00,$3005,$48C0,$3202,$48C1,$D081,$2F00; $010FC0
    dc.w    $4878,$0001,$4EB9,$0000,$6760,$4FEF,$0020,$508A; $010FD0
    dc.w    $5243,$0C43,$0004,$6D00,$FE3A,$0C47,$0003,$6C14; $010FE0
    dc.w    $4878,$000A,$4878,$0019,$4878,$0004,$3006,$2F00; $010FF0
    dc.w    $6100,$FCAA,$4EB9,$0001,$D748,$4CEE,$3CFC,$FFC8; $011000
    dc.w    $4E5E,$4E75,$4E56,$0000,$48E7,$383C,$262E,$000C; $011010
    dc.w    $282E,$0008,$267C,$0003,$B246,$287C,$0003,$AB2C; $011020
    dc.w    $2A7C,$0001,$E0B8,$2F3C,$0000,$8000,$4878,$0008; $011030
    dc.w    $4878,$0008,$4878,$0009,$4878,$0004,$42A7,$4878; $011040
    dc.w    $001A,$4EB9,$0000,$0D64,$4FEF,$001C,$4878,$075C; $011050
    dc.w    $4878,$0002,$42A7,$4878,$0004,$4878,$000B,$4878; $011060
    dc.w    $0009,$4878,$0001,$4878,$0001,$4EB9,$0000,$6760; $011070
    dc.w    $4FEF,$0020,$4878,$075D,$4878,$000A,$42A7,$4878; $011080
    dc.w    $0002,$4878,$000B,$4878,$000D,$4878,$0001,$4878; $011090
    dc.w    $0001,$4EB9,$0000,$6760,$4FEF,$0020,$4878,$075E; $0110A0
    dc.w    $4878,$000B,$42A7,$4878,$0002,$4878,$000B,$4878; $0110B0
    dc.w    $000F,$4878,$0001,$4878,$0001,$4EB9,$0000,$6760; $0110C0
    dc.w    $2F39,$000A,$1B2C,$4879,$00FF,$1804,$4EB9,$0000; $0110D0
    dc.w    $3FEC,$4FEF,$0028,$4878,$0012,$4878,$03E1,$4879; $0110E0
    dc.w    $00FF,$1804,$4EB9,$0000,$4668,$4879,$0007,$2658; $0110F0
    dc.w    $4878,$0002,$4878,$0003,$4878,$0009,$4878,$0001; $011100
    dc.w    $42A7,$4878,$001B,$4EB9,$0000,$0D64,$4FEF,$0028; $011110
    dc.w    $4879,$0007,$2664,$4878,$0002,$4878,$0003,$4878; $011120
    dc.w    $000D,$4878,$0001,$42A7,$4878,$001B,$4EB9,$0000; $011130
    dc.w    $0D64,$4FEF,$001C,$4879,$0007,$2670,$4878,$0002; $011140
    dc.w    $4878,$0003,$4878,$000F,$4878,$0001,$42A7,$4878; $011150
    dc.w    $001B,$4EB9,$0000,$0D64,$4878,$0002,$4878,$0037; $011160
    dc.w    $4E95,$4FEF,$0024,$0C43,$0004,$6C00,$0160,$3004; $011170
    dc.w    $EB48,$3203,$E749,$D041,$207C,$00FF,$0338,$41F0; $011180
    dc.w    $0000,$2448,$4A2A,$0001,$6700,$0142,$4878,$0006; $011190
    dc.w    $4878,$0009,$4878,$000B,$4878,$0004,$4EB9,$0003; $0111A0
    dc.w    $A942,$4878,$0002,$4878,$0037,$4E95,$4FEF,$0018; $0111B0
    dc.w    $0C2A,$0006,$0001,$6748,$4878,$0001,$4878,$0640; $0111C0
    dc.w    $42A7,$4878,$0058,$4878,$0008,$7000,$1012,$48C0; $0111D0
    dc.w    $2F00,$4EB9,$0000,$883A,$4878,$0009,$4878,$0004; $0111E0
    dc.w    $4E94,$4FEF,$0020,$7000,$1012,$E548,$207C,$0004; $0111F0
    dc.w    $7818,$2F30,$0000,$4EB9,$0003,$B270,$588F,$6064; $011200
    dc.w    $0C6A,$0003,$0006,$6612,$7000,$1012,$2F00,$4EB9; $011210
    dc.w    $0000,$D648,$588F,$3400,$6004,$7400,$1412,$4878; $011220
    dc.w    $0009,$4878,$0004,$4E94,$508F,$0C42,$0003,$660A; $011230
    dc.w    $4879,$0003,$F116,$4E93,$60C2,$0C42,$0002,$6608; $011240
    dc.w    $4879,$0003,$F10A,$60EE,$3002,$E548,$207C,$0005; $011250
    dc.w    $EC84,$2F30,$0000,$4879,$0003,$F106,$4EB9,$0003; $011260
    dc.w    $B270,$508F,$7400,$142A,$0001,$0642,$FFFF,$4878; $011270
    dc.w    $000D,$4878,$0004,$4E94,$3002,$E548,$207C,$0004; $011280
    dc.w    $77E8,$2F30,$0000,$4E93,$3003,$48C0,$2F00,$3004; $011290
    dc.w    $48C0,$2F00,$4EBA,$0660,$4E71,$3600,$4878,$000F; $0112A0
    dc.w    $4878,$0004,$4E94,$4FEF,$001C,$0C43,$000C,$6E10; $0112B0
    dc.w    $3003,$48C0,$2F00,$4879,$0003,$F0FA,$4E93,$6014; $0112C0
    dc.w    $4879,$0003,$F0EC,$4E93,$588F,$6008,$4878,$0002; $0112D0
    dc.w    $42A7,$4E95,$4CEE,$3C1C,$FFE4,$4E5E,$4E75      ; $0112E0
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
    dc.w    $6100,$f9ae                                 ; bsr.w $010D08
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
    dc.w    $6100,$fb62                                 ; bsr.w $011014
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
    dc.w    $4EB9,$0003,$A942                                ; jsr SetTextWindow
    pea     ($0019).w                                        ; x = 25
    pea     ($0013).w                                        ; y = 19
    dc.w    $4EB9,$0003,$AB2C                                ; jsr SetTextCursor
    move.w  d2,d0
    mulu.w  #$0024,d0                                        ; index * 36 (record size)
    movea.l #$00FF001E,a0                                    ; record table base
    move.l  (a0,d0.w),-(sp)                                  ; push record field
    pea     ($0003F1B2).l                                    ; format string
    dc.w    $4EB9,$0003,$B270                                ; jsr PrintfWide
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
    dc.w    $4EB9,$0000,$643C                                ; jsr $643C (display fn)
    lea     $20(sp),sp                                       ; clean 32 bytes
    cmpi.w  #$0001,$001A(a6)                                 ; flag1 == 1?
    bne.s   .check_f2                                        ; no, check flag2
    pea     ($001A).w
    pea     ($0006).w
    dc.w    $4EB9,$0000,$7784                                ; jsr $7784 (input fn)
    addq.l  #8,sp                                            ; clean args
    move.w  d0,d3                                            ; d3 = result
    bra.s   .epilogue
.check_f2:                                                   ; $0118E4
    cmpi.w  #$0001,$001E(a6)                                 ; flag2 == 1?
    bne.s   .epilogue                                        ; no, skip
    pea     ($0001).w
    pea     ($0003).w
    dc.w    $4EB9,$0001,$D62C                                ; jsr PollAction
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
    dc.w    $4E56,$FFFC,$48E7,$3C00,$282E; $011B26
    dc.w    $0008,$3004,$E548,$207C,$00FF,$08EC,$2A30,$0000; $011B30
    dc.w    $206E,$000C,$0028,$0080,$000A,$3004,$C0FC,$0024; $011B40
    dc.w    $207C,$00FF,$0019,$1030,$0000,$0280,$0000,$00FF; $011B50
    dc.w    $7601,$E1AB,$486E,$FFFC,$2F03,$2F03,$3004,$2F00; $011B60
    dc.w    $4EBA,$01DE,$4E71,$4FEF,$0010,$7601,$4242,$202E; $011B70
    dc.w    $FFFC,$2205,$B380,$C083,$6714,$3002,$48C0,$2F00; $011B80
    dc.w    $7000,$3004,$2F00,$4EBA,$02D4,$4E71,$508F,$D683; $011B90
    dc.w    $5242,$0C42,$0020,$6DD6,$4CEE,$003C,$FFEC,$4E5E; $011BA0
    dc.w    $4E75                                            ; $011BB0
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
; func_011CF6 -- (TODO: name)
; 90 bytes | $011CF6-$011D4F
; ============================================================================
func_011CF6:
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
; func_011D50 -- (TODO: name)
; 58 bytes | $011D50-$011D89
; ============================================================================
func_011D50:
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
    dc.w    $4EBA,$0014                                 ; jsr $011D8A(pc)
    nop
    lea     $c(a7), a7
    move.l  d0, d2
    or.l    d2, d3
    bra.b   .l11d64
.l11d84:
    movem.l (a7)+, d2-d4/a2
    rts

; ============================================================================
; func_011D8A -- (TODO: name)
; 226 bytes | $011D8A-$011E6B
; ============================================================================
func_011D8A:
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
; func_011E6C -- (TODO: name)
; 258 bytes | $011E6C-$011F6D
; ============================================================================
func_011E6C:
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
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
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
; func_011F6E -- (TODO: name)
; 264 bytes | $011F6E-$012075
; ============================================================================
func_011F6E:
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
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
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
    dc.w    $4EBA,$0E4C                                 ; jsr $012E2E(pc)
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
    dc.w    $4EB9,$0000,$6EEA                           ; jsr $006EEA
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
; func_012076 -- (TODO: name)
; 1182 bytes | $012076-$012513
; ============================================================================
func_012076:
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
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
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
    dc.w    $4EBA,$0D46                                 ; jsr $012E2E(pc)
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
    dc.w    $4EB9,$0001,$A506                           ; jsr $01A506
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
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
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
    dc.w    $4EB9,$0001,$D538                           ; jsr $01D538
    pea     ($0014).w
    clr.l   -(a7)
    move.l  a5, -(a7)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
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
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    pea     ($000E).w
    clr.l   -(a7)
    move.w  d4, d0
    mulu.w  #$e, d0
    movea.l  #$00FFBD6C,a0
    pea     (a0, d0.w)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
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
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
    move.w  d0, d3
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
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
    dc.w    $6100,$FA66                                 ; bsr.w $011F6E
    movem.l -$44(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_012514 -- (TODO: name)
; 706 bytes | $012514-$0127D5
; ============================================================================
func_012514:
    link    a6,#-$190
    movem.l d2-d7/a2-a5, -(a7)
    movea.l  #$0003B22C,a5
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$a0(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.l  ($00095118).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
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
    dc.w    $4EB9,$0001,$DC26                           ; jsr $01DC26
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$45E6                           ; jsr $0045E6
    pea     ($00070198).l
    pea     ($0014).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $28(a7), a7
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
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
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$a0(a6)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $20(a7), a7
    tst.w   d4
    ble.b   .l127ae
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.w  $a(a6), d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0396                                 ; jsr $012B3E(pc)
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
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    move.w  d0, d2
    movem.l -$1b8(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_0127D6 -- (TODO: name)
; 872 bytes | $0127D6-$012B3D
; ============================================================================
func_0127D6:
    link    a6,#-$140
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $c(a6), d4
    move.l  $8(a6), d7
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    pea     ($0050).w
    clr.l   -(a7)
    pea     -$50(a6)
    dc.w    $4EB9,$0001,$D520                           ; jsr $01D520
    dc.w    $4EB9,$0000,$814A                           ; jsr $00814A
    moveq   #$0,d0
    move.w  d4, d0
    lsl.l   #$2, d0
    movea.l  #$0009511C,a0
    move.l  (a0,d0.l), -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
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
    dc.w    $4EB9,$0000,$D648                           ; jsr $00D648
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
    dc.w    $4EB9,$0000,$9994                           ; jsr $009994
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
    dc.w    $4EB9,$0001,$8EBA                           ; jsr $018EBA
    lea     $c(a7), a7
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $2c(a7), a7
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$45E6                           ; jsr $0045E6
    pea     ($0010).w
    pea     ($0010).w
    pea     ($0007677E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    cmpi.w  #$1, d3
    bne.b   .l12a34
    pea     ($0003F258).l
    pea     -$a0(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
    bra.b   .l12a4e
.l12a34:
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    move.l  ($0004799A).l, -(a7)
    pea     -$a0(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
.l12a4e:
    cmpi.w  #$1, d6
    bne.b   .l12a68
    pea     ($0003F250).l
    pea     -$f0(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    addq.l  #$8, a7
    bra.b   .l12a82
.l12a68:
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    move.l  ($0004799E).l, -(a7)
    pea     -$f0(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $c(a7), a7
.l12a82:
    tst.w   d6
    bne.b   .l12aa0
    pea     -$a0(a6)
    pea     ($0003F24C).l
.l12a90:
    pea     -$140(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
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
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    lea     $10(a7), a7
.l12acc:
    pea     -$140(a6)
    move.l  ($000479A6).l, -(a7)
    pea     -$50(a6)
    dc.w    $4EB9,$0003,$B22C                           ; jsr $03B22C
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    pea     ($0001).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     -$50(a6)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $20(a7), a7
    tst.w   d6
    beq.b   .l12b1a
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d7, d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$002A                                 ; jsr $012B3E(pc)
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
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    movem.l -$168(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_012B3E -- (TODO: name)
; 710 bytes | $012B3E-$012E03
; ============================================================================
func_012B3E:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l  #$00000D64,a5
    clr.w   d4
    moveq   #$1,d7
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.w  d5, d0
    mulu.w  #$320, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
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
    dc.w    $4EB9,$0001,$9244                           ; jsr $019244
    lea     $14(a7), a7
    movea.l a2, a4
.l12c66:
    cmpi.w  #$1, d7
    bne.b   .l12c90
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
    clr.l   -(a7)
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($0003F268).l
    move.w  d5, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
    lea     $14(a7), a7
    clr.w   d7
.l12c90:
    tst.w   -$2(a6)
    beq.b   .l12ca6
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$D62C                           ; jsr $01D62C
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
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
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
; func_012E04 -- (TODO: name)
; 42 bytes | $012E04-$012E2D
; ============================================================================
func_012E04:
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
; func_012E2E -- (TODO: name)
; 100 bytes | $012E2E-$012E91
; ============================================================================
func_012E2E:
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
    dc.w    $4EB9,$0000,$9D92                           ; jsr $009D92
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
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
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
    dc.w    $48E7,$3820,$7201; $0131DA
    dc.w    $302F,$0016,$E548,$207C,$0005,$ECBC,$41F0,$0000; $0131E0
    dc.w    $2248,$2448,$1610,$0283,$0000,$00FF,$7800,$1829; $0131F0
    dc.w    $0001,$4242,$6018,$207C,$00FF,$09D8,$1030,$3000; $013200
    dc.w    $0200,$0003,$6704,$4241,$6008,$5242,$5243,$B444; $013210
    dc.w    $6DE4,$0C41,$0001,$662C,$7600,$162A,$0002,$7800; $013220
    dc.w    $182A,$0003,$4242,$6018,$207C,$00FF,$09D8,$1030; $013230
    dc.w    $3000,$0200,$0003,$6704,$4241,$6008,$5242,$5243; $013240
    dc.w    $B444,$6DE4,$3001,$4CDF,$041C,$4E75,$4E56,$FF48; $013250
    dc.w    $48E7,$3F3C,$262E,$0008,$2C2E,$000C,$246E,$0014; $013260
    dc.w    $267C,$00FF,$13FC,$287C,$0004,$79AE,$4BEE,$FF4A; $013270
    dc.w    $4EB9,$0001,$D71C,$4EB9,$0003,$A9AC,$3006,$48C0; $013280
    dc.w    $2F00,$3003,$48C0,$2F00,$4EBA,$025C,$4E71,$4EB9; $013290
    dc.w    $0001,$D748,$7A01,$343C,$00FF,$2F0A,$42A7,$3006; $0132A0
    dc.w    $48C0,$2F00,$3003,$48C0,$2F00,$4EBA,$0A58,$4E71; $0132B0
    dc.w    $4FEF,$0018,$42A7,$4878,$0002,$4878,$0001,$3002; $0132C0
    dc.w    $48C0,$E988,$0680,$0000,$0030,$2F00,$42A7,$4878; $0132D0
    dc.w    $0002,$4878,$0544,$4EB9,$0001,$E044,$4878,$0001; $0132E0
    dc.w    $4878,$000E,$4EB9,$0000,$0D64,$42A7,$4EB9,$0001; $0132F0
    dc.w    $E1EC,$4FEF,$0028,$4A40,$6704,$7001,$6002,$7000; $013300
    dc.w    $3D40,$FFFE,$4247,$4253,$4279,$00FF,$A7D8,$4242; $013310
    dc.w    $4A45,$6724,$42A7,$42A7,$42A7,$302E,$0012,$48C0; $013320
    dc.w    $2F00,$2F2C,$001C,$3003,$48C0,$2F00,$4EB9,$0001; $013330
    dc.w    $183A,$4FEF,$0018,$4245,$4A6E,$FFFE,$670E,$42A7; $013340
    dc.w    $4EB9,$0001,$E1EC,$588F,$4A40,$66C4,$426E,$FFFE; $013350
    dc.w    $3007,$2F00,$4878,$000A,$4EB9,$0001,$E290,$508F; $013360
    dc.w    $0240,$0033,$3E00,$48C0,$7220,$B041,$671C,$7210; $013370
    dc.w    $B041,$6700,$00B8,$7201,$B041,$6700,$00BE,$7202; $013380
    dc.w    $B041,$6700,$0130,$6000,$0138,$4253,$4279,$00FF; $013390
    dc.w    $A7D8,$3002,$E548,$207C,$00FF,$9A10,$4A70,$0000; $0133A0
    dc.w    $6F78,$3002,$48C0,$2F00,$3006,$48C0,$2F00,$3003; $0133B0
    dc.w    $48C0,$2F00,$4EBA,$08FA,$4E71,$4FEF,$000C,$4A40; $0133C0
    dc.w    $6616,$4878,$0001,$4878,$0002,$4EB9,$0001,$E0B8; $0133D0
    dc.w    $508F,$3002,$6000,$0106,$3002,$48C0,$E588,$2040; $0133E0
    dc.w    $2F34,$8808,$2F2C,$0004,$2F0D,$4EB9,$0003,$B22C; $0133F0
    dc.w    $4878,$0001,$42A7,$4878,$0002,$302E,$0012,$48C0; $013400
    dc.w    $2F00,$2F0D,$3003,$48C0,$2F00,$4EB9,$0001,$183A; $013410
    dc.w    $4FEF,$0024,$7A01,$6000,$00B0,$3002,$48C0,$E588; $013420
    dc.w    $2040,$2F34,$8808,$2F2C,$0018,$60BC,$4253,$4279; $013430
    dc.w    $00FF,$A7D8,$343C,$00FF,$6088,$36BC,$0001,$3002; $013440
    dc.w    $48C0,$5480,$7203,$4EB9,$0003,$E146,$3400,$0C42; $013450
    dc.w    $0001,$6604,$7803,$6002,$3802,$42A7,$4878,$0002; $013460
    dc.w    $4878,$0001,$3002,$48C0,$E988,$0680,$0000,$0020; $013470
    dc.w    $2F00,$42A7,$4878,$0002,$4878,$0544,$4EB9,$0001; $013480
    dc.w    $E044,$4878,$0001,$4878,$000E,$4EB9,$0000,$0D64; $013490
    dc.w    $4FEF,$0024,$2F0A,$3004,$48C0,$2F00,$3006,$48C0; $0134A0
    dc.w    $2F00,$3003,$48C0,$2F00,$4EBA,$085A,$4E71,$4FEF; $0134B0
    dc.w    $0010,$6014,$36BC,$0001,$3002,$48C0,$5280,$6084; $0134C0
    dc.w    $4253,$4279,$00FF,$A7D8,$4878,$0003,$4878,$000E; $0134D0
    dc.w    $4EB9,$0000,$0D64,$508F,$6000,$FE36,$4CEE,$3CFC; $0134E0
    dc.w    $FF20,$4E5E,$4E75,$48E7,$3E38,$2A2F,$0028,$2C2F; $0134F0
    dc.w    $0024,$267C,$0003,$B270,$287C,$0003,$AB2C,$3005; $013500
    dc.w    $48C0,$2F00,$3006,$48C0,$2F00,$4EBA,$01DC,$4E71; $013510
    dc.w    $4878,$0013,$4878,$001F,$4878,$0001,$4878,$0001; $013520
    dc.w    $4EB9,$0003,$A942,$4878,$0002,$4878,$0001,$4E94; $013530
    dc.w    $4879,$0003,$F5EC,$4E93,$4878,$0002,$4878,$0011; $013540
    dc.w    $4E94,$4879,$0003,$F5DC,$4E93,$4FEF,$0030,$247C; $013550
    dc.w    $00FF,$9A10,$7804,$4242,$3004,$48C0,$2F00,$4878; $013560
    dc.w    $0001,$4E94,$3002,$48C0,$E588,$207C,$0005,$E296; $013570
    dc.w    $2F30,$0800,$4E93,$3004,$48C0,$2F00,$4878,$0013; $013580
    dc.w    $4E94,$4FEF,$0014,$4A52,$6F5C,$3002,$48C0,$2F00; $013590
    dc.w    $3005,$48C0,$2F00,$3006,$48C0,$2F00,$4EBA,$0712; $0135A0
    dc.w    $4E71,$4FEF,$000C,$3600,$4A43,$6624,$3012,$48C0; $0135B0
    dc.w    $2F00,$4EBA,$0B18,$4E71,$3600,$C0FC,$000A,$48C0; $0135C0
    dc.w    $2F00,$4879,$0003,$F5D6,$4E93,$4FEF,$000C,$6020; $0135D0
    dc.w    $0C43,$0004,$6608,$4879,$0003,$F5CA,$600E,$4879; $0135E0
    dc.w    $0003,$F5C2,$6006,$4879,$0003,$F5B4,$4E93,$588F; $0135F0
    dc.w    $5444,$588A,$5242,$0C42,$0003,$6D00,$FF5C,$4CDF; $013600
    dc.w    $1C7C,$4E75,$48E7,$3F38,$2E2F,$0028,$286F,$0030; $013610
    dc.w    $302F,$002E,$E548,$207C,$0005,$ECBC,$41F0,$0000; $013620
    dc.w    $2248,$4243,$7800,$1811,$7A00,$1A29,$0001,$3C04; $013630
    dc.w    $48C6,$2006,$DC86,$DC80,$DC86,$6042,$207C,$00FF; $013640
    dc.w    $1704,$47F0,$6000,$207C,$00FF,$0420,$45F0,$6000; $013650
    dc.w    $4242,$7000,$1012,$3207,$48C1,$B081,$660E,$5243; $013660
    dc.w    $7000,$1013,$D080,$2040,$5274,$8800,$528B,$528A; $013670
    dc.w    $5242,$0C42,$0006,$6DDA,$5C86,$5345,$5244,$4A45; $013680
    dc.w    $6EBA,$7800,$1829,$0002,$7A00,$1A29,$0003,$604C; $013690
    dc.w    $3004,$E548,$207C,$00FF,$15A0,$41F0,$0000,$2648; $0136A0
    dc.w    $3004,$E548,$207C,$00FF,$0460,$41F0,$0000,$2448; $0136B0
    dc.w    $4242,$7000,$1012,$3207,$48C1,$B081,$660E,$5243; $0136C0
    dc.w    $7000,$1013,$D080,$2040,$5274,$8800,$528B,$528A; $0136D0
    dc.w    $5242,$0C42,$0004,$6DDA,$5345,$5244,$4A45,$6EB0; $0136E0
    dc.w    $3003,$4CDF,$1CFC,$4E75,$48E7,$3830,$242F,$0018; $0136F0
    dc.w    $282F,$001C,$3002,$C0FC,$0024,$207C,$00FF,$0018; $013700
    dc.w    $41F0,$0000,$2648,$4243,$4A2B,$0005,$6758,$3004; $013710
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$6EEA; $013720
    dc.w    $508F,$3800,$7000,$102B,$0004,$C0FC,$0014,$3202; $013730
    dc.w    $C2FC,$0320,$D041,$207C,$00FF,$9A20,$41F0,$0000; $013740
    dc.w    $2448,$4242,$6012,$B812,$6706,$B82A,$0001,$6602; $013750
    dc.w    $5243,$7014,$D5C0,$5242,$3002,$48C0,$7200,$122B; $013760
    dc.w    $0005,$B081,$6DE0,$3003,$4CDF,$0C1C,$4E75,$4E56; $013770
    dc.w    $FFEC,$48E7,$3F3C,$2E2E,$0008,$2A7C,$0003,$B270; $013780
    dc.w    $3007,$EB48,$322E,$0012,$E749,$D041,$207C,$00FF; $013790
    dc.w    $0338,$41F0,$0000,$2448,$3007,$C0FC,$0024,$207C; $0137A0
    dc.w    $00FF,$0018,$41F0,$0000,$2648,$302A,$0006,$E548; $0137B0
    dc.w    $207C,$00FF,$9A10,$41F0,$0000,$2848,$3014,$48C0; $0137C0
    dc.w    $2F00,$4EBA,$0908,$4E71,$48C0,$2200,$E588,$D081; $0137D0
    dc.w    $D080,$2A00,$2D40,$FFF4,$2005,$6C02,$5280,$E280; $0137E0
    dc.w    $2D40,$FFEC,$2005,$6C02,$5680,$E480,$2205,$9280; $0137F0
    dc.w    $2D41,$FFF0,$2005,$D080,$2D40,$FFF8,$2005,$E588; $013800
    dc.w    $2D40,$FFFC,$42A7,$4EB9,$0000,$538E,$4878,$0020; $013810
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$4242; $013820
    dc.w    $7604,$4878,$0020,$4878,$0020,$42A7,$42A7,$4EB9; $013830
    dc.w    $0003,$A942,$4FEF,$0028,$4878,$0011,$4878,$001E; $013840
    dc.w    $4878,$0001,$4878,$0001,$4EB9,$0000,$5A04,$4878; $013850
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $013860
    dc.w    $3003,$48C0,$2F00,$3002,$48C0,$5480,$2F00,$4EB9; $013870
    dc.w    $0003,$AB2C,$7000,$302A,$0006,$E588,$207C,$0005; $013880
    dc.w    $E296,$2F30,$0800,$4E95,$4FEF,$002C,$3003,$48C0; $013890
    dc.w    $5680,$2F00,$3002,$48C0,$5480,$2F00,$4EB9,$0003; $0138A0
    dc.w    $AB2C,$4879,$0003,$F662,$4E95,$3003,$48C0,$5680; $0138B0
    dc.w    $2F00,$3002,$48C0,$0680,$0000,$0014,$2F00,$4EB9; $0138C0
    dc.w    $0003,$AB2C,$2F2E,$FFF4,$4879,$0003,$F65C,$4E95; $0138D0
    dc.w    $3003,$48C0,$5E80,$2F00,$3002,$48C0,$5480,$2F00; $0138E0
    dc.w    $4EB9,$0003,$AB2C,$4879,$0003,$F64A,$4E95,$3003; $0138F0
    dc.w    $48C0,$0680,$0000,$000B,$2F00,$3002,$48C0,$5480; $013900
    dc.w    $2F00,$4EB9,$0003,$AB2C,$4FEF,$0030,$4879,$0003; $013910
    dc.w    $F636,$4E95,$42A7,$42A7,$42A7,$302E,$0012,$48C0; $013920
    dc.w    $2F00,$2F39,$0004,$79D2,$3007,$48C0,$2F00,$4EB9; $013930
    dc.w    $0001,$183A,$4878,$0020,$4878,$0020,$42A7,$42A7; $013940
    dc.w    $4EB9,$0003,$A942,$4FEF,$002C,$42A7,$4EB9,$0001; $013950
    dc.w    $E1EC,$588F,$0240,$0FFF,$66F0,$4246,$4279,$00FF; $013960
    dc.w    $BD58,$4279,$00FF,$13FC,$4279,$00FF,$A7D8,$4245; $013970
    dc.w    $7802,$4A79,$00FF,$BD58,$6700,$0136,$0C45,$0001; $013980
    dc.w    $6600,$0136,$4878,$0020,$4878,$0020,$42A7,$42A7; $013990
    dc.w    $4EB9,$0003,$A942,$4878,$0011,$4878,$001E,$4878; $0139A0
    dc.w    $0001,$4878,$0001,$4EB9,$0000,$5A04,$4878,$0020; $0139B0
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$4FEF; $0139C0
    dc.w    $0030,$3003,$48C0,$2F00,$3002,$48C0,$5480,$2F00; $0139D0
    dc.w    $4EB9,$0003,$AB2C,$7000,$302A,$0006,$E588,$207C; $0139E0
    dc.w    $0005,$E296,$2F30,$0800,$4E95,$3003,$48C0,$5680; $0139F0
    dc.w    $2F00,$3002,$48C0,$5480,$2F00,$4EB9,$0003,$AB2C; $013A00
    dc.w    $4879,$0003,$F624,$4E95,$3003,$48C0,$5680,$2F00; $013A10
    dc.w    $3002,$48C0,$0680,$0000,$0014,$2F00,$4EB9,$0003; $013A20
    dc.w    $AB2C,$2F2E,$FFF4,$4879,$0003,$F61E,$4E95,$3003; $013A30
    dc.w    $48C0,$5E80,$2F00,$3002,$48C0,$5480,$2F00,$4EB9; $013A40
    dc.w    $0003,$AB2C,$4FEF,$0030,$4879,$0003,$F60C,$4E95; $013A50
    dc.w    $3003,$48C0,$0680,$0000,$000B,$2F00,$3002,$48C0; $013A60
    dc.w    $5480,$2F00,$4EB9,$0003,$AB2C,$4879,$0003,$F5F8; $013A70
    dc.w    $4E95,$42A7,$42A7,$42A7,$302E,$0012,$48C0,$2F00; $013A80
    dc.w    $2F39,$0004,$79D2,$3007,$48C0,$2F00,$4EB9,$0001; $013A90
    dc.w    $183A,$4FEF,$0028,$4878,$0020,$4878,$0020,$42A7; $013AA0
    dc.w    $42A7,$4EB9,$0003,$A942,$4FEF,$0010,$4245,$6008; $013AB0
    dc.w    $33FC,$0001,$00FF,$BD58,$3003,$48C0,$5E80,$2F00; $013AC0
    dc.w    $3002,$48C0,$0680,$0000,$0014,$2F00,$4EB9,$0003; $013AD0
    dc.w    $AB2C,$3004,$E548,$2F36,$00EC,$4879,$0003,$F5F2; $013AE0
    dc.w    $4E95,$2F3C,$0000,$8000,$4878,$0002,$4878,$0009; $013AF0
    dc.w    $3003,$48C0,$0680,$0000,$000B,$2F00,$3002,$48C0; $013B00
    dc.w    $0680,$0000,$0015,$2F00,$42A7,$4878,$001A,$4EB9; $013B10
    dc.w    $0000,$0D64,$4FEF,$002C,$3003,$48C0,$0680,$0000; $013B20
    dc.w    $000B,$2F00,$3002,$48C0,$0680,$0000,$0015,$2F00; $013B30
    dc.w    $4EB9,$0003,$AB2C,$3004,$E548,$207C,$0004,$79E2; $013B40
    dc.w    $2F30,$0000,$4E95,$3006,$2F00,$4878,$0033,$3003; $013B50
    dc.w    $E748,$0640,$0048,$2F00,$3002,$E748,$0640,$00C0; $013B60
    dc.w    $2F00,$3003,$E748,$0640,$0030,$2F00,$3002,$E748; $013B70
    dc.w    $0640,$00C0,$2F00,$4EB9,$0001,$AEB8,$4FEF,$0024; $013B80
    dc.w    $3C00,$48C0,$7220,$B041,$671C,$7210,$B041,$6700; $013B90
    dc.w    $00BC,$7201,$B041,$6700,$00BE,$7202,$B041,$6700; $013BA0
    dc.w    $00D6,$6000,$00EE,$4279,$00FF,$13FC,$3004,$E548; $013BB0
    dc.w    $2A36,$00EC,$BAAB,$0006,$6E48,$357C,$0064,$0004; $013BC0
    dc.w    $3404,$C4FC,$0014,$0642,$000A,$302E,$000E,$48C0; $013BD0
    dc.w    $2F00,$3007,$48C0,$2F00,$4EBA,$052E,$4E71,$508F; $013BE0
    dc.w    $D440,$0C42,$0064,$6406,$7000,$3002,$6002,$7064; $013BF0
    dc.w    $1540,$0002,$3004,$E548,$2A36,$00EC,$2005,$6000; $013C00
    dc.w    $00A6,$42A7,$4878,$0012,$4878,$0020,$42A7,$42A7; $013C10
    dc.w    $42A7,$4878,$001A,$4EB9,$0000,$0D64,$4FEF,$001C; $013C20
    dc.w    $4878,$0001,$42A7,$4878,$0002,$302E,$0012,$48C0; $013C30
    dc.w    $2F00,$2F39,$0004,$79DE,$3007,$48C0,$2F00,$4EB9; $013C40
    dc.w    $0001,$183A,$4FEF,$0018,$7A01,$6046,$4279,$00FF; $013C50
    dc.w    $13FC,$7A00,$60A6,$33FC,$0001,$00FF,$13FC,$3004; $013C60
    dc.w    $48C0,$5280,$7204,$B280,$6F08,$3004,$48C0,$5280; $013C70
    dc.w    $601E,$7004,$601A,$33FC,$0001,$00FF,$13FC,$3004; $013C80
    dc.w    $48C0,$5380,$6F08,$3004,$48C0,$5380,$6002,$7000; $013C90
    dc.w    $3800,$4878,$0006,$4878,$000E,$4EB9,$0000,$0D64; $013CA0
    dc.w    $508F,$6000,$FCCE,$4CEE,$3CFC,$FFC4,$4E5E,$4E75; $013CB0
    dc.w    $48E7,$3800,$262F,$0018,$282F,$0014,$302F,$0012; $013CC0
    dc.w    $EB48,$207C,$00FF,$0338,$41F0,$0000,$2248,$4242; $013CD0
    dc.w    $0C29,$0006,$0001,$661A,$7000,$3029,$0006,$3203; $013CE0
    dc.w    $48C1,$B081,$660C,$B811,$6608,$7000,$1029,$0003; $013CF0
    dc.w    $600C,$5089,$5242,$0C42,$0004,$6DD4,$7000,$4CDF; $013D00
    dc.w    $001C,$4E75,$4E56,$FFC4,$48E7,$3F38,$2F3C,$0000; $013D10
    dc.w    $8000,$4878,$0006,$4878,$001B,$4878,$000A,$4878; $013D20
    dc.w    $0003,$42A7,$4878,$001A,$4EB9,$0000,$0D64,$4878; $013D30
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $013D40
    dc.w    $4FEF,$002C,$4878,$0010,$4878,$0030,$4879,$0007; $013D50
    dc.w    $67DE,$4EB9,$0000,$5092,$4FEF,$000C,$383C,$0640; $013D60
    dc.w    $7A03,$7E0A,$4246,$302E,$0012,$D040,$207C,$0005; $013D70
    dc.w    $F908,$41F0,$0000,$2848,$7600,$1614,$3003,$48C0; $013D80
    dc.w    $D080,$D0AE,$0014,$2640,$6000,$00AC,$3003,$48C0; $013D90
    dc.w    $E588,$207C,$0009,$C840,$2F30,$0800,$4879,$00FF; $013DA0
    dc.w    $1804,$4EB9,$0000,$3FEC,$4878,$001E,$3004,$48C0; $013DB0
    dc.w    $2F00,$4879,$00FF,$1804,$4EB9,$0000,$4668,$45EE; $013DC0
    dc.w    $FFC4,$4242,$3004,$D042,$0040,$6000,$34C0,$5242; $013DD0
    dc.w    $0C42,$001E,$6DEE,$486E,$FFC4,$4878,$0005,$4878; $013DE0
    dc.w    $0006,$3007,$48C0,$2F00,$3005,$48C0,$2F00,$42A7; $013DF0
    dc.w    $4878,$001B,$4EB9,$0000,$0D64,$4FEF,$0030,$3007; $013E00
    dc.w    $48C0,$5A80,$2F00,$3005,$48C0,$5880,$2F00,$4EB9; $013E10
    dc.w    $0003,$AB2C,$3013,$48C0,$2F00,$4879,$0003,$F674; $013E20
    dc.w    $4EB9,$0003,$B246,$4FEF,$0010,$DC53,$0644,$001E; $013E30
    dc.w    $5E45,$548B,$5243,$3003,$48C0,$7200,$122C,$0001; $013E40
    dc.w    $B081,$6F00,$FF48,$3006,$4CEE,$1CFC,$FFA0,$4E5E; $013E50
    dc.w    $4E75,$48E7,$383C,$2A6F,$0024,$4244,$4878,$000C; $013E60
    dc.w    $42A7,$4879,$00FF,$9A10,$4EB9,$0001,$D520,$4FEF; $013E70
    dc.w    $000C,$267C,$00FF,$9A10,$4243,$4A43,$6604,$4242; $013E80
    dc.w    $600C,$0C43,$0001,$6604,$7403,$6002,$7402,$3002; $013E90
    dc.w    $D040,$207C,$0005,$F908,$41F0,$0000,$2848,$7400; $013EA0
    dc.w    $1414,$3002,$48C0,$D080,$41F5,$0800,$2448,$6012; $013EB0
    dc.w    $4A52,$6F0A,$3012,$D153,$526B,$0002,$7801,$548A; $013EC0
    dc.w    $5242,$3002,$48C0,$7200,$122C,$0001,$B081,$6FE0; $013ED0
    dc.w    $588B,$5243,$0C43,$0003,$6DA0,$3004,$4CDF,$3C1C; $013EE0
    dc.w    $4E75,$4E56,$FFF8,$48E7,$3F3C,$282E,$0010,$2A2E; $013EF0
    dc.w    $0008,$302E,$000E,$E548,$207C,$0005,$ECBC,$41F0; $013F00
    dc.w    $0000,$2D48,$FFFC,$1610,$0283,$0000,$00FF,$3004; $013F10
    dc.w    $D040,$207C,$0005,$F908,$41F0,$0000,$2848,$4246; $013F20
    dc.w    $7E1F,$3D7C,$0007,$FFFA,$3003,$D040,$207C,$0005; $013F30
    dc.w    $E9FA,$41F0,$0000,$2A48,$206E,$FFFC,$1828,$0001; $013F40
    dc.w    $0284,$0000,$00FF,$6000,$0096,$3003,$C0FC,$0006; $013F50
    dc.w    $207C,$00FF,$1704,$41F0,$0000,$2448,$3003,$C0FC; $013F60
    dc.w    $0006,$207C,$00FF,$0420,$41F0,$0000,$2648,$4242; $013F70
    dc.w    $7000,$1013,$3205,$48C1,$B081,$6630,$1012,$B014; $013F80
    dc.w    $652A,$1012,$B02C,$0001,$6222,$526E,$FFFA,$3003; $013F90
    dc.w    $48C0,$7201,$E1A9,$2001,$3205,$E549,$207C,$00FF; $013FA0
    dc.w    $A6A0,$C0B0,$1000,$6710,$5246,$600C,$528A,$528B; $013FB0
    dc.w    $5242,$0C42,$0006,$6DB8,$3003,$48C0,$2F00,$302E; $013FC0
    dc.w    $000E,$48C0,$2F00,$3005,$48C0,$2F00,$4EB9,$0001; $013FD0
    dc.w    $8EBA,$4FEF,$000C,$5247,$548D,$5344,$5243,$4A44; $013FE0
    dc.w    $6E00,$FF68,$206E,$FFFC,$1628,$0002,$0283,$0000; $013FF0
    dc.w    $00FF,$3003,$D040,$207C,$0005,$E9FA,$41F0,$0000; $014000
    dc.w    $2A48,$206E,$FFFC,$1828,$0003,$0284,$0000,$00FF; $014010
    dc.w    $6000,$00A8,$3003,$E548,$207C,$00FF,$15A0,$41F0; $014020
    dc.w    $0000,$2448,$3003,$E548,$207C,$00FF,$0460,$41F0; $014030
    dc.w    $0000,$2648,$4242,$7000,$1013,$3205,$48C1,$B081; $014040
    dc.w    $6646,$1012,$B014,$6540,$1012,$B02C,$0001,$6238; $014050
    dc.w    $526E,$FFFA,$3003,$48C0,$7201,$E1A9,$2001,$3205; $014060
    dc.w    $C2FC,$000E,$2047,$3E2E,$000E,$DE47,$CF88,$D248; $014070
    dc.w    $207C,$00FF,$BD6C,$3230,$1000,$0281,$0000,$FFFF; $014080
    dc.w    $C081,$6710,$5246,$600C,$528A,$528B,$5242,$0C42; $014090
    dc.w    $0004,$6DA2,$3003,$48C0,$2F00,$302E,$000E,$48C0; $0140A0
    dc.w    $2F00,$3005,$48C0,$2F00,$4EB9,$0001,$8EBA,$4FEF; $0140B0
    dc.w    $000C,$548D,$5247,$5344,$5243,$4A44,$6E00,$FF56; $0140C0
    dc.w    $3006,$4CEE,$3CFC,$FFD0,$4E5E,$4E75               ; $0140D0
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
    dc.w    $48E7,$3E30,$2A2F,$0020                          ; $014118
    dc.w    $4243,$302F,$0026,$E548,$207C,$0005,$ECBC,$41F0; $014120
    dc.w    $0000,$2248,$7400,$1411,$7C00,$1C11,$7000,$1029; $014130
    dc.w    $0001,$DC40,$7000,$3002,$2200,$D080,$D081,$D080; $014140
    dc.w    $2800,$207C,$00FF,$1704,$41F0,$0000,$2648,$207C; $014150
    dc.w    $00FF,$0420,$45F0,$4000,$3802,$6024,$4242,$0C13; $014160
    dc.w    $000E,$660E,$7000,$1012,$7200,$3205,$B081,$6602; $014170
    dc.w    $5243,$528B,$528A,$5242,$0C42,$0006,$65E0,$5244; $014180
    dc.w    $B846,$65D8,$7400,$1429,$0002,$7C00,$1C29,$0002; $014190
    dc.w    $7000,$1029,$0003,$DC40,$3002,$E548,$207C,$00FF; $0141A0
    dc.w    $15A0,$41F0,$0000,$2648,$3002,$E548,$207C,$00FF; $0141B0
    dc.w    $0460,$41F0,$0000,$2448,$3802,$6024,$4242,$0C13; $0141C0
    dc.w    $000E,$660E,$7000,$1012,$7200,$3205,$B081,$6602; $0141D0
    dc.w    $5243,$528B,$528A,$5242,$0C42,$0004,$65E0,$5244; $0141E0
    dc.w    $B846,$65D8,$3A03,$CAFC,$001E,$3005,$4CDF,$0C7C; $0141F0
    dc.w    $4E75                                             ; $014200
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
; func_014692 -- (TODO: name)
; 524 bytes | $014692-$01489D
; ============================================================================
func_014692:
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
    dc.w    $4EB9,$0001,$E398                           ; jsr $01E398
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    move.w  d0, ($00FFBD5C).l
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
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
    dc.w    $4EB9,$0001,$D71C                           ; jsr $01D71C
    move.l  a2, -(a7)
    dc.w    $4EBA,$0240                                 ; jsr $014972(pc)
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
    dc.w    $4EB9,$0001,$9244                           ; jsr $019244
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
    dc.w    $4EBA,$033C                                 ; jsr $014AAA(pc)
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EBA,$0852                                 ; jsr $015040(pc)
    nop
    bra.b   .l14834
.l147f4:
    cmpi.w  #$3, d2
    bne.b   .l1480a
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$0CF4                                 ; jsr $0154F8(pc)
    nop
    bra.b   .l14834
.l1480a:
    cmpi.w  #$4, d2
    bne.b   .l14820
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1434                                 ; jsr $015C4E(pc)
    nop
    bra.b   .l14834
.l14820:
    cmpi.w  #$5, d2
    bne.b   .l1483c
    move.l  a2, -(a7)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EBA,$1BB2                                 ; jsr $0163E2(pc)
    nop
.l14834:
    addq.l  #$8, a7
.l14836:
    move.l  a2, -(a7)
    jsr     (a3)
    addq.l  #$4, a7
.l1483c:
    dc.w    $4EB9,$0001,$D748                           ; jsr $01D748
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
; func_01489E -- (TODO: name)
; 212 bytes | $01489E-$014971
; ============================================================================
func_01489E:
    link    a6,#-$10
    movem.l d2-d3/a2, -(a7)
    movea.l $8(a6), a2
    moveq   #-$1,d3
    pea     ($0004E28A).l
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($00FF1804).l
    pea     ($0018).w
    pea     ($037B).w
    dc.w    $4EB9,$0001,$D568                           ; jsr $01D568
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$1c(a6), d2-d3/a2
    unlk    a6
    rts

; ============================================================================
; func_014972 -- (TODO: name)
; 312 bytes | $014972-$014AA9
; ============================================================================
func_014972:
    movem.l d2-d3/a2-a4, -(a7)
    movea.l $18(a7), a2
    movea.l  #$0003B270,a3
    movea.l  #$0003AB2C,a4
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
    move.w  d0, d3
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    move.w  d0, d2
    pea     ($0040).w
    clr.l   -(a7)
    pea     ($0010).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    pea     ($0010).w
    pea     ($0020).w
    pea     ($00076A1E).l
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B00).l, -(a7)
    pea     ($00FF899C).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $28(a7), a7
    pea     ($0080).w
    pea     ($006A).w
    pea     ($00FF899C).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
    pea     ($0007184C).l
    pea     ($0004).w
    pea     ($001E).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0001).w
    pea     ($001B).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $28(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
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
; func_014AAA -- (TODO: name)
; 698 bytes | $014AAA-$014D63
; ============================================================================
func_014AAA:
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
    dc.w    $4EB9,$0003,$8544                           ; jsr $038544
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14b1a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0003F7D8).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
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
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0001,$A2CE                           ; jsr $01A2CE
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
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  d4, d0
    ext.l   d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$8544                           ; jsr $038544
    lea     $30(a7), a7
    tst.w   d0
    beq.b   .l14d3a
    pea     ($0004).w
    pea     ($001C).w
    pea     ($0014).w
    pea     ($0001).w
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0003F7B4).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    lea     $24(a7), a7
.l14d3a:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
; func_014D64 -- (TODO: name)
; 66 bytes | $014D64-$014DA5
; ============================================================================
func_014D64:
    movem.l d2-d4, -(a7)
    move.l  $10(a7), d2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    move.w  d0, d4
    bra.b   .l14d9c
.l14d7a:
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    move.w  d0, d3
    cmp.w   d3, d4
    bne.b   .l14da0
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    subq.w  #$1, d2
.l14d9c:
    tst.w   d2
    bne.b   .l14d7a
.l14da0:
    movem.l (a7)+, d2-d4
    rts

; ============================================================================
; func_014DA6 -- (TODO: name)
; 666 bytes | $014DA6-$01503F
; ============================================================================
func_014DA6:
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    pea     ($077D).w
    pea     ($000A).w
    pea     ($0020).w
    pea     ($0013).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0003,$A9AC                           ; jsr $03A9AC
    pea     ($0001).w
    pea     ($0001).w
    pea     ($0013).w
    clr.l   -(a7)
    move.w  d6, d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$9660                           ; jsr $019660
    clr.w   -$54(a6)
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0003,$A9AC                           ; jsr $03A9AC
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
    dc.w    $4EB9,$0001,$9660                           ; jsr $019660
    pea     ($0020).w
    dc.w    $6100,$FE38                                 ; bsr.w $014D64
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
    dc.w    $4EB9,$0000,$7158                           ; jsr $007158
    addq.l  #$8, a7
    cmpi.w  #$1, d0
    tst.w   d5
    beq.b   .l14f7e
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l14f7e
    pea     ($0002).w
.l14f6e:
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    bra.w   .l14edc
.l14f7e:
    clr.w   d5
    move.w  -$52(a6), d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0000,$7912                           ; jsr $007912
.l15032:
    move.w  #$ff, d0
.l15036:
    movem.l -$7c(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_015040 -- (TODO: name)
; 1208 bytes | $015040-$0154F7
; ============================================================================
func_015040:
    link    a6,#-$28
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d5
    movea.l $c(a6), a2
    lea     -$20(a6), a4
    movea.l  #$00000D64,a5
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
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
    dc.w    $4EB9,$0000,$818A                           ; jsr $00818A
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
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
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
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
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
    dc.w    $4EB9,$0000,$7D92                           ; jsr $007D92
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
    dc.w    $4EB9,$0003,$A5A8                           ; jsr $03A5A8
    lea     $18(a7), a7
    clr.w   d6
.l1525a:
    tst.w   d2
    beq.b   .l1527c
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  d3, d0
    ext.l   d0
    add.l   d0, d0
    movea.l d0, a0
    move.w  (a4,a0.l), d0
    ext.l   d0
    move.l  d0, -(a7)
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7390                           ; jsr $007390
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
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    lea     $1c(a7), a7
    move.w  d2, d1
    ext.l   d1
    cmp.l   d1, d0
    bge.b   .l15366
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
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
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
    pea     ($0010).w
    pea     ($000E).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d2, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F838).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$99FA                           ; jsr $0199FA
    lea     $2c(a7), a7
    clr.l   -(a7)
    pea     ($0002).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$9DE6                           ; jsr $019DE6
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
    dc.w    $4EB9,$0003,$A5A8                           ; jsr $03A5A8
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
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
    dc.w    $4EB9,$0001,$DE92                           ; jsr $01DE92
    movem.l -$50(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_0154F8 -- (TODO: name)
; 1878 bytes | $0154F8-$015C4D
; ============================================================================
func_0154F8:
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
    dc.w    $4EB9,$0000,$74E0                           ; jsr $0074E0
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
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
    move.w  d0, d3
    move.w  d0, -$2(a6)
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
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
    dc.w    $4EB9,$0000,$5092                           ; jsr $005092
    move.l  ($000A1B04).l, -(a7)
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$3FEC                           ; jsr $003FEC
    lea     $2c(a7), a7
    pea     ($0059).w
    pea     ($0011).w
    pea     ($00FF1804).l
    dc.w    $4EB9,$0000,$4668                           ; jsr $004668
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F854).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F850).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    lea     $10(a7), a7
    tst.w   d2
    beq.b   .l1571a
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
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
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0000,$73A6                           ; jsr $0073A6
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  -$32(a6), d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $3(a2), d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F84C).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0008).w
    pea     ($0015).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
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
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    addq.l  #$8, a7
    bra.w   .l15bc8
.l158f4:
    clr.w   ($00FF13FC).l
    clr.w   ($00FFA7D8).l
    pea     ($0010).w
    pea     ($000E).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    addq.l  #$8, a7
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7402                           ; jsr $007402
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
    dc.w    $4EB9,$0001,$ACBA                           ; jsr $01ACBA
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F840).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    move.l  a2, -(a7)
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    lea     $14(a7), a7
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
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
    dc.w    $4EB9,$0001,$ACBA                           ; jsr $01ACBA
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    moveq   #$0,d0
    move.b  $1(a3), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    sub.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F83C).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
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
    dc.w    $4EB9,$0000,$7412                           ; jsr $007412
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$14,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($0009).w
    pea     ($0010).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$99FA                           ; jsr $0199FA
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($000D).w
    pea     ($0010).w
    move.l  a2, -(a7)
    dc.w    $4EB9,$0001,$9DE6                           ; jsr $019DE6
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
; func_015C4E -- (TODO: name)
; 1940 bytes | $015C4E-$0163E1
; ============================================================================
func_015C4E:
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$12, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $28(a7), a7
    move.w  d5, d0
    addq.w  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    addi.w  #$12, d0
    move.l  d0, -(a7)
    pea     ($0002).w
    pea     ($0003).w
    dc.w    $4EB9,$0000,$595E                           ; jsr $00595E
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
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F870).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0008).w
    pea     ($0015).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F86C).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($000F).w
    pea     ($001B).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F868).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    lea     $30(a7), a7
    move.w  d5, d0
    ext.l   d0
    addq.l  #$1, d0
    move.l  d0, -(a7)
    move.w  d6, d0
    ext.l   d0
    addi.l  #$10, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F864).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $1c(a7), a7
    tst.w   d2
    beq.b   .l15ff2
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    beq.b   .l15ff2
.l15fde:
    pea     ($0003).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
    move.l  #$8000, -(a7)
    pea     ($0001).w
    pea     ($0001).w
    pea     ($007C).w
    pea     ($00F0).w
    pea     ($003A).w
    pea     ($0773).w
    dc.w    $4EB9,$0001,$E044                           ; jsr $01E044
    lea     $1c(a7), a7
.l1605e:
    pea     ($0001).w
    pea     ($000E).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    addq.l  #$8, a7
    bra.b   .l16096
.l16070:
    cmpi.w  #$f, -$7c(a6)
    bne.b   .l1608a
    pea     ($0002).w
    pea     ($0039).w
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
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
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0001,$9DE6                           ; jsr $019DE6
    pea     ($0008).w
    pea     ($0005).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  -$7a(a6), d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F860).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($0008).w
    pea     ($0015).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    lea     $2c(a7), a7
    move.w  d7, d0
    ext.l   d0
    move.w  d3, d1
    ext.l   d1
    add.l   d1, d0
    move.l  d0, -(a7)
    pea     ($0003F85C).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($000F).w
    pea     ($001B).w
    dc.w    $4EB9,$0003,$AB2C                           ; jsr $03AB2C
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F858).l
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
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
    dc.w    $4EB9,$0001,$E0B8                           ; jsr $01E0B8
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    clr.l   -(a7)
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    lea     $24(a7), a7
    clr.l   -(a7)
    pea     ($000D).w
    pea     ($0020).w
    pea     ($0012).w
    clr.l   -(a7)
    pea     ($0001).w
    pea     ($001A).w
    dc.w    $4EB9,$0000,$0D64                           ; jsr $000D64
    movem.l -$a4(a6), d2-d7/a2-a5
    unlk    a6
    rts

; ============================================================================
; func_0163E2 -- (TODO: name)
; 1158 bytes | $0163E2-$016867
; ============================================================================
func_0163E2:
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
    dc.w    $4EB9,$0000,$70DC                           ; jsr $0070DC
    move.w  d0, d4
    pea     ($0064).w
    pea     ($0096).w
    move.w  d4, d0
    move.l  d0, -(a7)
    dc.w    $4EB9,$0001,$E11C                           ; jsr $01E11C
    move.w  d0, -$4(a6)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.w  d4, d1
    ext.l   d1
    sub.l   d1, d0
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  d4, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
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
    dc.w    $4EB9,$0000,$5A04                           ; jsr $005A04
    lea     $24(a7), a7
    pea     ($0020).w
    pea     ($0020).w
    clr.l   -(a7)
    clr.l   -(a7)
    dc.w    $4EB9,$0003,$A942                           ; jsr $03A942
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
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
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
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
    dc.w    $4EB9,$0003,$B270                           ; jsr $03B270
    addq.l  #$4, a7
.l1657a:
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d3, d0
    ext.l   d0
    move.l  d0, -(a7)
    pea     ($0003F886).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F880).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l165e6
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
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
    dc.w    $4EBA,$0272                                 ; jsr $016868(pc)
    nop
    lea     $28(a7), a7
    move.w  d2, d5
.l16600:
    tst.w   -$2(a6)
    beq.b   .l16616
    clr.l   -(a7)
    dc.w    $4EB9,$0001,$E1EC                           ; jsr $01E1EC
    addq.l  #$4, a7
    tst.w   d0
    bne.w   .l164f2
.l16616:
    clr.w   -$2(a6)
    move.w  d6, d0
    move.l  d0, -(a7)
    pea     ($000A).w
    dc.w    $4EB9,$0001,$E290                           ; jsr $01E290
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
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    move.w  d4, d1
    ext.l   d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    addi.l  #$32, d0
    move.l  d0, d2
    ext.l   d0
    moveq   #$5,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
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
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
    move.w  d0, d7
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
    moveq   #$1,d1
    cmp.l   d0, d1
    ble.b   .l166de
    move.w  d2, d0
    ext.l   d0
    moveq   #$A,d1
    dc.w    $4EB9,$0003,$E146                           ; jsr $03E146
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
    dc.w    $4EBA,$017A                                 ; jsr $016868(pc)
    nop
    pea     ($000D).w
    pea     ($0019).w
    jsr     (a5)
    moveq   #$0,d0
    move.w  $4(a2), d0
    move.l  d0, -(a7)
    pea     ($0003F87A).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
    pea     ($000E).w
    pea     ($0019).w
    jsr     (a5)
    move.w  d2, d0
    ext.l   d0
    subi.l  #$32, d0
    move.l  d0, -(a7)
    pea     ($0003F874).l
    dc.w    $4EB9,$0003,$B246                           ; jsr $03B246
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
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
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
    dc.w    $4EB9,$0003,$E05C                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4EB9,$0003,$E08A                           ; jsr $03E08A
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
; func_016868 -- (TODO: name)
; 240 bytes | $016868-$016957
; ============================================================================
func_016868:
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
    dc.w    $0010,$1428,$FFFF,$7000,$1004,$72DE,$B280,$6616; $016F50
    dc.w    $7000,$1002,$72B6,$B280,$6E16,$7000,$1002,$72C4; $016F60
    dc.w    $B280,$6C20,$600A,$7000,$1004,$72DF,$B280,$6614; $016F70
    dc.w    $7000,$1002,$72CA,$B280,$6E0C,$7000,$1002,$72CE; $016F80
    dc.w    $B280,$6D02,$7601,$3003,$4CDF,$001C,$4E75         ; $016F90
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
    dc.w    $48E7,$3800,$42A7,$4EB9,$0000,$538E; $0171B4
    dc.w    $4878,$0001,$4EBA,$0094,$4E71,$508F,$7604,$4244; $0171C0
    dc.w    $42A7,$42A7,$42A7,$4879,$0004,$7A5E,$3039,$00FF; $0171D0
    dc.w    $A792,$48C0,$2F00,$4EB9,$0000,$7912,$4878,$0002; $0171E0
    dc.w    $3003,$48C0,$2F00,$4EBA,$016E,$4E71,$4FEF,$001C; $0171F0
    dc.w    $3400,$48C0,$72FF,$B280,$6730,$0C42,$00FF,$6706; $017200
    dc.w    $3602,$D643,$5843,$3002,$48C0,$4A40,$6708,$7201; $017210
    dc.w    $B041,$6708,$6010,$4878,$0001,$6002,$42A7,$4EBA; $017220
    dc.w    $0628,$4E71,$588F,$4A44,$6796,$4878,$0008,$4878; $017230
    dc.w    $0018,$4878,$0003,$4878,$0005,$4EBA,$0A52,$4E71; $017240
    dc.w    $4FEF,$0010,$4CDF,$001C,$4E75,$48E7,$3838,$262F; $017250
    dc.w    $001C,$247C,$0003,$B270,$267C,$0003,$AB2C,$287C; $017260
    dc.w    $0004,$7A78,$4878,$008F,$4A43,$6604,$700C,$6002; $017270
    dc.w    $7008,$2F00,$4878,$0018,$4878,$0003,$4878,$0005; $017280
    dc.w    $4EBA,$09DC,$4E71,$4878,$0004,$4878,$0008,$4E93; $017290
    dc.w    $4FEF,$001C,$4A43,$6604,$7805,$6002,$7802,$4242; $0172A0
    dc.w    $602A,$33FC,$0008,$00FF,$128A,$3003,$C0FC,$0014; $0172B0
    dc.w    $3202,$E549,$D041,$207C,$0004,$7A36,$2F30,$0000; $0172C0
    dc.w    $4879,$0003,$F94C,$4E92,$508F,$5242,$B444,$6DD2; $0172D0
    dc.w    $4A43,$663E,$4878,$0006,$4878,$0014,$4E93,$3039; $0172E0
    dc.w    $00FF,$000A,$48C0,$E588,$2040,$2F34,$8800,$4E92; $0172F0
    dc.w    $4878,$000A,$4878,$0014,$4E93,$4FEF,$0014,$3039; $017300
    dc.w    $00FF,$0008,$E548,$207C,$0004,$7A88,$2F30,$0000; $017310
    dc.w    $603A,$4878,$0004,$4878,$0014,$4E93,$3039,$00FF; $017320
    dc.w    $000C,$48C0,$E588,$2040,$2F34,$8800,$4E92,$4878; $017330
    dc.w    $0006,$4878,$0014,$4E93,$4FEF,$0014,$3039,$00FF; $017340
    dc.w    $000E,$48C0,$E588,$2040,$2F34,$8800,$4E92,$588F; $017350
    dc.w    $4CDF,$1C1C,$4E75,$48E7,$3C30,$242F,$001C,$2A2F; $017360
    dc.w    $0020,$247C,$0000,$0D64,$267C,$00FF,$13FC,$4878; $017370
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $017380
    dc.w    $42A7,$4EB9,$0001,$E1EC,$4FEF,$0014,$4A40,$6704; $017390
    dc.w    $7601,$6002,$7600,$4244,$4253,$4279,$00FF,$A7D8; $0173A0
    dc.w    $2F3C,$0000,$8000,$4878,$0002,$4878,$0001,$3002; $0173B0
    dc.w    $48C0,$E788,$2F00,$4878,$0038,$42A7,$4878,$0544; $0173C0
    dc.w    $4EB9,$0001,$E044,$4878,$0001,$4878,$000E,$4E92; $0173D0
    dc.w    $4FEF,$0024,$4A43,$671C,$42A7,$4EB9,$0001,$E1EC; $0173E0
    dc.w    $588F,$4A40,$670E,$4878,$0003,$4878,$000E,$4E92; $0173F0
    dc.w    $508F,$60AC,$4243,$3004,$2F00,$4878,$000A,$4EB9; $017400
    dc.w    $0001,$E290,$508F,$0240,$0033,$3800,$0240,$0030; $017410
    dc.w    $6720,$4253,$4279,$00FF,$A7D8,$3004,$0240,$0020; $017420
    dc.w    $6756,$3002,$48C0,$5980,$6C02,$5280,$E280,$3400; $017430
    dc.w    $6048,$3004,$0240,$0001,$6714,$36BC,$0001,$0C42; $017440
    dc.w    $0004,$6606,$3405,$D442,$6024,$5542,$6022,$3004; $017450
    dc.w    $0240,$0002,$671A,$36BC,$0001,$3002,$48C0,$3205; $017460
    dc.w    $48C1,$D281,$5481,$B081,$6604,$7404,$6002,$5442; $017470
    dc.w    $4878,$0005,$6000,$FF74,$74FF,$4878,$0040,$42A7; $017480
    dc.w    $4878,$0010,$4E92,$4FEF,$000C,$3002,$4CDF,$0C3C; $017490
    dc.w    $4E75,$48E7,$2020,$247C,$0000,$0D64,$42A7,$4EB9; $0174A0
    dc.w    $0000,$538E,$4EBA,$030E,$4E71,$4878,$0020,$4878; $0174B0
    dc.w    $0020,$42A7,$42A7,$4EB9,$0003,$A942,$4878,$0001; $0174C0
    dc.w    $4EBA,$0094,$4E71,$4FEF,$0018,$3400,$48C0,$72FF; $0174D0
    dc.w    $B280,$6764,$3002,$48C0,$2F00,$4EB9,$0000,$EB28; $0174E0
    dc.w    $3002,$2F00,$4EBA,$0312,$4E71,$42A7,$4878,$0002; $0174F0
    dc.w    $4878,$001E,$4878,$0018,$4878,$0002,$42A7,$4878; $017500
    dc.w    $001A,$4E92,$4FEF,$0024,$4878,$0002,$4878,$001E; $017510
    dc.w    $4878,$0018,$4878,$0002,$4EB9,$0003,$A942,$4879; $017520
    dc.w    $0003,$F950,$4EB9,$0003,$B270,$4878,$003C,$4878; $017530
    dc.w    $000E,$4E92,$4FEF,$001C,$42A7,$4EB9,$0000,$538E; $017540
    dc.w    $4878,$0040,$42A7,$4878,$0010,$4E92,$4FEF,$0010; $017550
    dc.w    $4CDF,$0404,$4E75                                ; $017560
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
    dc.w    $222F,$0004,$3001,$48C0; $017808
    dc.w    $2F00,$4EB9,$0000,$F104,$588F,$4E75,$7001,$B179; $017810
    dc.w    $00FF,$000A,$4878,$0002,$4878,$0004,$4878,$0006; $017820
    dc.w    $4878,$0014,$4EB9,$0003,$A942,$3039,$00FF,$000A; $017830
    dc.w    $E548,$207C,$0004,$7A78,$2F30,$0000,$4EB9,$0003; $017840
    dc.w    $B270,$4FEF,$0014,$4E75,$48E7,$2030,$242F,$0010; $017850
    dc.w    $247C,$00FF,$000C,$267C,$00FF,$000E,$0C42,$0001; $017860
    dc.w    $6652,$7001,$B152,$4878,$0002,$4878,$0004,$4878; $017870
    dc.w    $0004,$4878,$0014,$4EB9,$0003,$A942,$3012,$E548; $017880
    dc.w    $207C,$0004,$7A78,$2F30,$0000,$4EB9,$0003,$B270; $017890
    dc.w    $3012,$2F00,$4EB9,$0001,$D340,$4878,$0001,$3039; $0178A0
    dc.w    $00FF,$9A1C,$5440,$2F00,$4EB9,$0001,$D3AC,$4FEF; $0178B0
    dc.w    $0020,$603C,$7001,$B153,$4878,$0002,$4878,$0004; $0178C0
    dc.w    $4878,$0006,$4878,$0014,$4EB9,$0003,$A942,$3013; $0178D0
    dc.w    $E548,$207C,$0004,$7A78,$2F30,$0000,$4EB9,$0003; $0178E0
    dc.w    $B270,$3013,$2F00,$4EB9,$0001,$D37A,$4FEF,$0018; $0178F0
    dc.w    $4CDF,$0C04,$4E75,$4E56,$FF80,$48E7,$3838,$247C; $017900
    dc.w    $0000,$0D64,$267C,$00FF,$13FC,$287C,$00FF,$0008; $017910
    dc.w    $42A7,$4EB9,$0000,$538E,$4878,$008F,$4878,$0008; $017920
    dc.w    $4878,$000C,$4878,$0004,$4878,$000A,$4EBA,$0330; $017930
    dc.w    $4E71,$4EBA,$01C6,$4E71,$3014,$E548,$207C,$0004; $017940
    dc.w    $7A88,$2F30,$0000,$4879,$0003,$F960,$486E,$FF80; $017950
    dc.w    $4EB9,$0003,$B22C,$4FEF,$0024,$42A7,$42A7,$42A7; $017960
    dc.w    $486E,$FF80,$3039,$00FF,$A792,$48C0,$2F00,$4EB9; $017970
    dc.w    $0000,$7912,$3414,$D442,$5A42,$2F3C,$0000,$8000; $017980
    dc.w    $4878,$0002,$4878,$0001,$3002,$48C0,$E788,$2F00; $017990
    dc.w    $4878,$0050,$42A7,$4878,$0544,$4EB9,$0001,$E044; $0179A0
    dc.w    $4FEF,$0030,$4878,$0001,$4878,$000E,$4E92,$4878; $0179B0
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $0179C0
    dc.w    $42A7,$4EB9,$0001,$E1EC,$4FEF,$001C,$4A40,$6704; $0179D0
    dc.w    $7601,$6002,$7600,$4244,$4253,$4279,$00FF,$A7D8; $0179E0
    dc.w    $42A7,$4878,$0006,$4878,$0001,$4878,$0005,$4878; $0179F0
    dc.w    $000A,$42A7,$4878,$001A,$4E92,$4FEF,$001C,$2F3C; $017A00
    dc.w    $0000,$8000,$4878,$0002,$4878,$0001,$3002,$48C0; $017A10
    dc.w    $E788,$2F00,$4878,$0050,$42A7,$4878,$0544,$4EB9; $017A20
    dc.w    $0001,$E044,$4878,$0001,$4878,$000E,$4E92,$4FEF; $017A30
    dc.w    $0024,$4A43,$671C,$42A7,$4EB9,$0001,$E1EC,$588F; $017A40
    dc.w    $4A40,$670E,$4878,$0003,$4878,$000E,$4E92,$508F; $017A50
    dc.w    $608E,$4243,$3004,$2F00,$4878,$000A,$4EB9,$0001; $017A60
    dc.w    $E290,$508F,$0240,$0033,$3800,$0240,$0030,$6732; $017A70
    dc.w    $4253,$4279,$00FF,$A7D8,$3004,$0240,$0020,$675C; $017A80
    dc.w    $3002,$48C0,$5B80,$6C02,$5280,$E280,$3880,$4EBA; $017A90
    dc.w    $006A,$4E71,$4878,$0014,$4878,$000E,$4E92,$508F; $017AA0
    dc.w    $603A,$3004,$0240,$0001,$6712,$36BC,$0001,$0C42; $017AB0
    dc.w    $0005,$6604,$7409,$608C,$5542,$6088,$3004,$0240; $017AC0
    dc.w    $0002,$6700,$FF80,$36BC,$0001,$0C42,$0009,$6606; $017AD0
    dc.w    $7405,$6000,$FF70,$5442,$6000,$FF6A,$4878,$0040; $017AE0
    dc.w    $42A7,$4878,$0010,$4E92,$42A7,$4EB9,$0000,$538E; $017AF0
    dc.w    $4CEE,$1C1C,$FF68,$4E5E,$4E75,$48E7,$3000,$4878; $017B00
    dc.w    $0006,$4878,$000A,$4878,$0005,$4878,$000B,$4EB9; $017B10
    dc.w    $0003,$A942,$4FEF,$0010,$4242,$3602,$48C3,$D683; $017B20
    dc.w    $5A83,$2F03,$4878,$000C,$4EB9,$0003,$AB2C,$3002; $017B30
    dc.w    $E548,$207C,$0004,$7A88,$2F30,$0000,$4879,$0003; $017B40
    dc.w    $F9B0,$4EB9,$0003,$B270,$4FEF,$0010,$5242,$0C42; $017B50
    dc.w    $0003,$6DC6,$4CDF,$000C,$4E75,$48E7,$3C3C,$267C; $017B60
    dc.w    $00FF,$A792,$287C,$0000,$0D64,$2A7C,$00FF,$0018; $017B70
    dc.w    $42A7,$4878,$0001,$42A7,$2F39,$0004,$7A94,$3013; $017B80
    dc.w    $48C0,$2F00,$4EB9,$0000,$7912,$4FEF,$0014,$3A00; $017B90
    dc.w    $0C40,$0001,$6600,$00C0,$7801,$4242,$3613,$B443; $017BA0
    dc.w    $671A,$3002,$48C0,$2200,$E788,$D081,$E588,$2040; $017BB0
    dc.w    $0C35,$0001,$8800,$6604,$4244,$6008,$5242,$0C42; $017BC0
    dc.w    $0004,$6DDA,$0C44,$0001,$6650,$42A7,$4878,$0012; $017BD0
    dc.w    $4878,$0020,$42A7,$42A7,$42A7,$4878,$001A,$4E94; $017BE0
    dc.w    $42A7,$4878,$0001,$42A7,$2F39,$0004,$7A98,$3013; $017BF0
    dc.w    $48C0,$2F00,$4EB9,$0000,$7912,$4FEF,$0030,$4A40; $017C00
    dc.w    $6632,$4878,$000A,$4878,$0013,$4E94,$42A7,$4EB9; $017C10
    dc.w    $0003,$B428,$4FEF,$000C,$6036,$42A7,$4878,$0012; $017C20
    dc.w    $4878,$0020,$42A7,$42A7,$42A7,$4878,$001A,$4E94; $017C30
    dc.w    $4FEF,$001C,$3013,$48C0,$2200,$E788,$D081,$E588; $017C40
    dc.w    $41F5,$0800,$2448,$4212,$33FC,$0001,$00FF,$1296; $017C50
    dc.w    $5379,$00FF,$0A34,$3005,$4CDF,$3C3C,$4E75,$4E56; $017C60
    dc.w    $FFF8,$43EE,$000E,$41EE,$000A,$302E,$0016,$2F00; $017C70
    dc.w    $302E,$0012,$5440,$2F00,$3011,$2F00,$3010,$0640; $017C80
    dc.w    $FFFF,$2F00,$4EB9,$0000,$5A04,$4E5E,$4E75,$48E7; $017C90
    dc.w    $3800,$242F,$001C,$262F,$0018,$282F,$0014,$222F; $017CA0
    dc.w    $0010,$42A7,$3002,$48C0,$2F00,$3003,$48C0,$5480; $017CB0
    dc.w    $2F00,$3004,$48C0,$2F00,$3001,$48C0,$5380,$2F00; $017CC0
    dc.w    $42A7,$4878,$001A,$4EB9,$0000,$0D64,$4FEF,$001C; $017CD0
    dc.w    $4CDF,$001C,$4E75                                ; $017CE0
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
    dc.w    $48E7,$3830,$242E,$0008,$3002,$D040,$207C,$00FF; $017D70
    dc.w    $0728,$41F0,$0000,$2448,$3002,$D040,$207C,$00FF; $017D80
    dc.w    $8824,$41F0,$0000,$2648,$532A,$0001,$4A2A,$0001; $017D90
    dc.w    $6600,$0096,$7000,$1012,$7808,$9840,$D844,$0644; $017DA0
    dc.w    $000A,$7600,$1613,$D644,$0C43,$00FF,$6406,$7000; $017DB0
    dc.w    $3003,$6006,$203C,$0000,$00FF,$1680,$5212,$4878; $017DC0
    dc.w    $000A,$4878,$001E,$4878,$0011,$4878,$0001,$4EB9; $017DD0
    dc.w    $0000,$5A04,$7000,$3004,$2F00,$3002,$E548,$207C; $017DE0
    dc.w    $0005,$E680,$2F30,$0000,$4879,$0004,$1038,$4EB9; $017DF0
    dc.w    $0003,$B270,$4878,$0001,$4878,$0003,$4EB9,$0001; $017E00
    dc.w    $D62C,$4FEF,$0024,$2F3C,$0000,$8000,$4878,$000A; $017E10
    dc.w    $4878,$001E,$4878,$0011,$4878,$0001,$42A7,$4878; $017E20
    dc.w    $001A,$4EB9,$0000,$0D64,$4CEE,$0C1C,$FFEC,$4E5E; $017E30
    dc.w    $4E75,$4E56,$0000,$302E,$000A,$D040,$207C,$00FF; $017E40
    dc.w    $0728,$41F0,$0000,$2248,$4A29,$0001,$660E,$0C11; $017E50
    dc.w    $0009,$6408,$1011,$5600,$1340,$0001,$4E5E,$4E75; $017E60
    dc.w    $48E7,$203C,$2A7C,$0000,$C860,$287C,$0005,$F26A; $017E70
    dc.w    $267C,$0005,$F3CE,$247C,$00FF,$1298,$4A79,$00FF; $017E80
    dc.w    $0002,$6624,$4242,$156C,$0001,$0001,$156C,$0002; $017E90
    dc.w    $0002,$156C,$0003,$0003,$588C,$588A,$5242,$0C42; $017EA0
    dc.w    $0059,$65E2,$6000,$0090,$0C79,$0003,$00FF,$0002; $017EB0
    dc.w    $6622,$4242,$156B,$0001,$0001,$156B,$0002,$0002; $017EC0
    dc.w    $156B,$0003,$0003,$588B,$588A,$5242,$0C42,$0059; $017ED0
    dc.w    $65E2,$6062,$4242,$7000,$102B,$0001,$48C0,$2F00; $017EE0
    dc.w    $7000,$102C,$0001,$48C0,$2F00,$4E95,$1540,$0001; $017EF0
    dc.w    $7000,$102B,$0002,$48C0,$2F00,$7000,$102C,$0002; $017F00
    dc.w    $48C0,$2F00,$4E95,$1540,$0002,$7000,$102B,$0003; $017F10
    dc.w    $48C0,$2F00,$7000,$102C,$0003,$48C0,$2F00,$4E95; $017F20
    dc.w    $4FEF,$0018,$1540,$0003,$588C,$588B,$588A,$5242; $017F30
    dc.w    $0C42,$0059,$65A0,$4CDF,$3C04,$4E75,$48E7,$203C; $017F40
    dc.w    $242F,$0018,$2A7C,$0000,$C860,$3002,$E548,$207C; $017F50
    dc.w    $0005,$F26A,$41F0,$0000,$2848,$3002,$E548,$207C; $017F60
    dc.w    $0005,$F3CE,$41F0,$0000,$2648,$3002,$E548,$207C; $017F70
    dc.w    $00FF,$1298,$41F0,$0000,$2448,$4A79,$00FF,$0002; $017F80
    dc.w    $6614,$156C,$0001,$0001,$156C,$0002,$0002,$156C; $017F90
    dc.w    $0003,$0003,$6070,$0C79,$0003,$00FF,$0002,$6614; $017FA0
    dc.w    $156B,$0001,$0001,$156B,$0002,$0002,$156B,$0003; $017FB0
    dc.w    $0003,$6052,$7000,$102B,$0001,$48C0,$2F00,$7000; $017FC0
    dc.w    $102C,$0001,$48C0,$2F00,$4E95,$1540,$0001,$7000; $017FD0
    dc.w    $102B,$0002,$48C0,$2F00,$7000,$102C,$0002,$48C0; $017FE0
    dc.w    $2F00,$4E95,$1540,$0002,$7000,$102B,$0003,$48C0; $017FF0
    dc.w    $2F00,$7000,$102C,$0003,$48C0,$2F00,$4E95,$4FEF; $018000
    dc.w    $0018,$1540,$0003,$4CDF,$3C04,$4E75          ; $018010
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
    dc.w    $6100,$ff06                                 ; bsr.w $017F4C
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
    dc.w    $6100,$fcc8                                 ; bsr.w $017E70
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
    dc.w    $6100,$fe3c                                 ; bsr.w $01801C
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
    dc.w    $4E56,$FF60,$48E7,$3020,$262E,$0008,$45EE,$FF60; $018C80
    dc.w    $4878,$0001,$3003,$2F00,$4EB9,$0000,$FFF8,$508F; $018C90
    dc.w    $3400,$4A42,$661A,$2F39,$0004,$7B78,$2F39,$0004; $018CA0
    dc.w    $7C9C,$2F0A,$4EB9,$0003,$B22C,$4FEF,$000C,$602C; $018CB0
    dc.w    $0C42,$0001,$6608,$4879,$0004,$10C6,$6006,$2F39; $018CC0
    dc.w    $0004,$7B78,$3002,$48C0,$2F00,$2F39,$0004,$7CA0; $018CD0
    dc.w    $2F0A,$4EB9,$0003,$B22C,$4FEF,$0010,$42A7,$2F0A; $018CE0
    dc.w    $4878,$0003,$42A7,$4EB9,$0001,$D6A4,$508F,$2F00; $018CF0
    dc.w    $3003,$2F00,$4EB9,$0002,$FBD6,$4CEE,$040C,$FF54; $018D00
    dc.w    $4E5E,$4E75,$4E56,$FF54,$48E7,$383C,$262E,$0008; $018D10
    dc.w    $4BEE,$FF54,$3003,$C0FC,$0024,$207C,$00FF,$0018; $018D20
    dc.w    $41F0,$0000,$2848,$486E,$FFF4,$486E,$FFF8,$486E; $018D30
    dc.w    $FFFC,$3003,$2F00,$4EB9,$0001,$03B0,$4FEF,$0010; $018D40
    dc.w    $3003,$48C0,$E788,$2400,$207C,$00FF,$09A2,$4AB0; $018D50
    dc.w    $0000,$6700,$014C,$207C,$00FF,$09A2,$45F0,$2000; $018D60
    dc.w    $204A,$5888,$2648,$2010,$B092,$6400,$00B2,$207C; $018D70
    dc.w    $00FF,$09A2,$2030,$2000,$207C,$00FF,$09A6,$90B0; $018D80
    dc.w    $2000,$2400,$B4AE,$FFF4,$6D26,$2F02,$2F39,$0004; $018D90
    dc.w    $7B78,$2F39,$0004,$7CB0,$2F0D,$4EB9,$0003,$B22C; $018DA0
    dc.w    $4FEF,$0010,$42A7,$2F0D,$4878,$0003,$6000,$00E8; $018DB0
    dc.w    $2002,$7264,$4EB9,$0003,$E05C,$222E,$FFF4,$4EB9; $018DC0
    dc.w    $0003,$E08A,$3800,$4A44,$6F38,$0C44,$0064,$6C32; $018DD0
    dc.w    $3004,$48C0,$2F00,$2F02,$2F39,$0004,$7B78,$2F39; $018DE0
    dc.w    $0004,$7CAC,$2F0D,$4EB9,$0003,$B22C,$4FEF,$0014; $018DF0
    dc.w    $0C44,$001E,$6D04,$7001,$6002,$7000,$2F00,$6000; $018E00
    dc.w    $0090,$2F02,$2F39,$0004,$7B78,$2F39,$0004,$7CB0; $018E10
    dc.w    $2F0D,$4EB9,$0003,$B22C,$4FEF,$0010,$6070,$207C; $018E20
    dc.w    $00FF,$09A2,$41F0,$2000,$2448,$2010,$B093,$660E; $018E30
    dc.w    $2F39,$0004,$7B78,$2F39,$0004,$7CD0,$6044,$2413; $018E40
    dc.w    $9492,$2F02,$2F39,$0004,$7B78,$2F39,$0004,$7CB4; $018E50
    dc.w    $2F0D,$4EB9,$0003,$B22C,$4878,$0002,$2F0D,$4878; $018E60
    dc.w    $0002,$3003,$2F00,$4EB9,$0002,$FBD6,$4FEF,$0020; $018E70
    dc.w    $4AAC,$0006,$6C2A,$2F39,$0004,$7B78,$2F39,$0004; $018E80
    dc.w    $7CB8,$2F0D,$4EB9,$0003,$B22C,$4FEF,$000C,$42A7; $018E90
    dc.w    $2F0D,$4878,$0002,$3003,$2F00,$4EB9,$0002,$FBD6; $018EA0
    dc.w    $4CEE,$3C1C,$FF38,$4E5E,$4E75                     ; $018EB0
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
    dc.w    $6100,$f2c8                                 ; bsr.w $019660
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
    dc.w    $48E7,$3F3C,$2A2F,$002C,$266F,$0030,$2A7C; $01A790
    dc.w    $0001,$D6A4,$4878,$0003,$42A7,$4E95,$508F,$4A80; $01A7A0
    dc.w    $6600,$012A,$4878,$0003,$42A7,$4E95,$508F,$3800; $01A7B0
    dc.w    $C0FC,$0007,$D045,$207C,$00FF,$A7BC,$4A30,$0000; $01A7C0
    dc.w    $6700,$0280,$3005,$48C0,$2F00,$3004,$48C0,$2F00; $01A7D0
    dc.w    $4EB9,$0000,$6EEA,$508F,$3E00,$0C47,$00FF,$6616; $01A7E0
    dc.w    $3005,$48C0,$2F00,$3004,$48C0,$2F00,$4EB9,$0000; $01A7F0
    dc.w    $9DC4,$508F,$3E00,$0C47,$00FF,$6700,$0246,$4878; $01A800
    dc.w    $0006,$42A7,$4E95,$508F,$3C00,$48C0,$7201,$E1A9; $01A810
    dc.w    $2001,$3204,$C2FC,$0007,$D245,$207C,$00FF,$A7BC; $01A820
    dc.w    $1230,$1000,$0281,$0000,$00FF,$C081,$67D0,$3006; $01A830
    dc.w    $48C0,$2F00,$3004,$48C0,$2F00,$4EB9,$0000,$6EEA; $01A840
    dc.w    $508F,$3400,$0C40,$00FF,$6616,$3006,$48C0,$2F00; $01A850
    dc.w    $3004,$48C0,$2F00,$4EB9,$0000,$9DC4,$508F,$3400; $01A860
    dc.w    $1684,$4878,$0001,$42A7,$4E95,$508F,$3600,$4A43; $01A870
    dc.w    $6634,$3007,$D040,$207C,$0005,$E9FA,$41F0,$0000; $01A880
    dc.w    $2448,$3005,$C0FC,$000E,$3206,$D241,$D041,$207C; $01A890
    dc.w    $0005,$E234,$41F0,$0000,$2848,$1747,$0001,$1742; $01A8A0
    dc.w    $0002,$6000,$018E,$3007,$D040,$207C,$0005,$E9FA; $01A8B0
    dc.w    $41F0,$0000,$2848,$3005,$C0FC,$000E,$3206,$D241; $01A8C0
    dc.w    $D041,$207C,$0005,$E234,$6000,$015A,$3005,$E548; $01A8D0
    dc.w    $207C,$0005,$ECBC,$41F0,$0000,$2448,$7C00,$1C2A; $01A8E0
    dc.w    $0001,$7000,$102A,$0003,$DC40,$0646,$FFFF,$4878; $01A8F0
    dc.w    $0003,$42A7,$4E95,$508F,$3800,$E548,$207C,$00FF; $01A900
    dc.w    $A6A0,$2030,$0000,$3205,$E549,$207C,$0005,$ECDC; $01A910
    dc.w    $C0B0,$1000,$661A,$3004,$C0FC,$000E,$3205,$D241; $01A920
    dc.w    $D041,$207C,$00FF,$BD6C,$4A70,$0000,$6700,$0114; $01A930
    dc.w    $3005,$48C0,$2F00,$3004,$48C0,$2F00,$4EB9,$0000; $01A940
    dc.w    $6EEA,$508F,$3E00,$0C40,$00FF,$6700,$00F6,$4243; $01A950
    dc.w    $3006,$48C0,$2F00,$42A7,$4E95,$508F,$3400,$7000; $01A960
    dc.w    $102A,$0001,$B042,$6F22,$7000,$1012,$D440,$3002; $01A970
    dc.w    $48C0,$7201,$E1A9,$2001,$3204,$E549,$207C,$00FF; $01A980
    dc.w    $A6A0,$C0B0,$1000,$6742,$604A,$7000,$102A,$0001; $01A990
    dc.w    $9440,$3002,$48C0,$7201,$E1A9,$2001,$3204,$C2FC; $01A9A0
    dc.w    $000E,$2047,$3E05,$DE47,$CF88,$D248,$207C,$00FF; $01A9B0
    dc.w    $BD6C,$3230,$1000,$0281,$0000,$FFFF,$C081,$670A; $01A9C0
    dc.w    $7000,$102A,$0002,$D440,$600A,$5243,$0C43,$0010; $01A9D0
    dc.w    $6D00,$FF7E,$0C43,$0010,$6C68,$1684,$4878,$0001; $01A9E0
    dc.w    $42A7,$4E95,$508F,$3600,$4A43,$661E,$3007,$D040; $01A9F0
    dc.w    $207C,$0005,$E9FA,$41F0,$0000,$2448,$3002,$D040; $01AA00
    dc.w    $207C,$0005,$E9FA,$6000,$FE8C,$3007,$D040,$207C; $01AA10
    dc.w    $0005,$E9FA,$41F0,$0000,$2848,$3002,$D040,$207C; $01AA20
    dc.w    $0005,$E9FA,$41F0,$0000,$2448,$1747,$0002,$1742; $01AA30
    dc.w    $0001,$2F0C,$2F0A,$2F0B,$4EBA,$000E,$4E71,$4FEF; $01AA40
    dc.w    $000C,$4CDF,$3CFC,$4E75,$4E56,$FFFC,$48E7,$3F30; $01AA50
    dc.w    $266E,$0008,$226E,$0010,$206E,$000C,$247C,$00FF; $01AA60
    dc.w    $153C,$4242,$B7CA,$672A,$102B,$0001,$B02A,$0001; $01AA70
    dc.w    $6620,$102B,$0002,$B02A,$0002,$6616,$4878,$0012; $01AA80
    dc.w    $42A7,$2F0B,$4EB9,$0001,$D520,$4FEF,$000C,$6000; $01AA90
    dc.w    $0106,$7012,$D5C0,$5242,$0C42,$0004,$6DC6,$7400; $01AAA0
    dc.w    $1410,$7000,$1028,$0001,$3D40,$FFFE,$7C00,$1C11; $01AAB0
    dc.w    $7E00,$1E29,$0001,$B446,$6606,$BE6E,$FFFE,$67BC; $01AAC0
    dc.w    $363C,$8560,$B446,$6204,$7800,$6002,$7801,$4A44; $01AAD0
    dc.w    $670A,$7800,$3802,$7000,$3006,$6008,$7800,$3806; $01AAE0
    dc.w    $7000,$3002,$9880,$3A2E,$FFFE,$9A47,$3005,$48C0; $01AAF0
    dc.w    $3204,$48C1,$D281,$B081,$6E48,$3004,$48C0,$6C02; $01AB00
    dc.w    $5280,$E280,$3205,$48C1,$B081,$6C04,$5843,$6032; $01AB10
    dc.w    $3004,$48C0,$6C02,$5280,$E280,$4480,$3205,$48C1; $01AB20
    dc.w    $B081,$6C04,$5043,$601A,$3005,$48C0,$3204,$48C1; $01AB30
    dc.w    $D281,$4481,$B081,$6F06,$0643,$000C,$6004,$0043; $01AB40
    dc.w    $1000,$B446,$6308,$203C,$0000,$0800,$6002,$7000; $01AB50
    dc.w    $8640,$4A45,$6F06,$3005,$48C0,$6006,$3005,$48C0; $01AB60
    dc.w    $4480,$D044,$3800,$0C44,$0080,$6308,$203C,$0000; $01AB70
    dc.w    $0080,$6002,$7040,$3800,$3742,$0004,$376E,$FFFE; $01AB80
    dc.w    $0006,$3746,$0008,$3747,$000A,$426B,$000C,$3744; $01AB90
    dc.w    $000E,$3743,$0010,$4CEE,$0CFC,$FFDC,$4E5E,$4E75; $01ABA0
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
    dc.w    $6100,$f9c4                                 ; bsr.w $01A672
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
    dc.w    $4E56,$FFE0,$48E7                                ; $01B49A
    dc.w    $3C3C,$2A7C,$00FF,$0016,$4245,$33FC,$0080,$00FF; $01B4A0
    dc.w    $BD64,$33FC,$0080,$00FF,$BD66,$4A79,$00FF,$17C4; $01B4B0
    dc.w    $6606,$4EB9,$0002,$8B46,$4A79,$00FF,$17C4,$665E; $01B4C0
    dc.w    $33FC,$FFFE,$00FF,$0A32,$4EB9,$0002,$C2FA,$4EB9; $01B4D0
    dc.w    $0001,$D748,$4242,$4243,$603A,$4878,$0003,$42A7; $01B4E0
    dc.w    $4EB9,$0001,$D6A4,$508F,$1A80,$7000,$1015,$7201; $01B4F0
    dc.w    $E1A9,$2001,$7200,$3203,$C081,$6618,$7000,$1015; $01B500
    dc.w    $7201,$E169,$2001,$8640,$207C,$00FF,$0012,$1195; $01B510
    dc.w    $2000,$5242,$0C42,$0004,$6DC0,$4242,$6016,$4242; $01B520
    dc.w    $1615,$6002,$5242,$207C,$00FF,$0012,$1030,$2000; $01B530
    dc.w    $B003,$66F0,$4279,$00FF,$9A1C,$382E,$FFFE,$49EE; $01B540
    dc.w    $FFFE,$6000,$033E,$207C,$00FF,$0012,$1AB0,$2000; $01B550
    dc.w    $7000,$1015,$C0FC,$0024,$207C,$00FF,$0018,$41F0; $01B560
    dc.w    $0000,$2648,$0C79,$0007,$00FF,$9A1C,$6700,$00AC; $01B570
    dc.w    $4EB9,$0001,$D71C,$4EB9,$0001,$E398,$7000,$1015; $01B580
    dc.w    $D040,$207C,$00FF,$0118,$3830,$0000,$4878,$0001; $01B590
    dc.w    $4878,$000F,$2F0C,$4EB9,$0000,$5092,$4878,$0007; $01B5A0
    dc.w    $4EB9,$0000,$9F4A,$4878,$0001,$4EB9,$0000,$538E; $01B5B0
    dc.w    $4878,$0040,$42A7,$4878,$0010,$4EB9,$0000,$0D64; $01B5C0
    dc.w    $42A7,$4EB9,$0000,$538E,$4878,$0001,$42A7,$7000; $01B5D0
    dc.w    $1015,$48C0,$2F00,$4EB9,$0000,$68CA,$4FEF,$0030; $01B5E0
    dc.w    $4878,$0002,$4878,$0007,$7000,$1015,$48C0,$2F00; $01B5F0
    dc.w    $4EB9,$0000,$6B78,$7000,$1015,$48C0,$2F00,$4EBA; $01B600
    dc.w    $0E2C,$4E71,$4FEF,$0010,$33FC,$0007,$00FF,$9A1C; $01B610
    dc.w    $4EB9,$0001,$D748,$6000,$017E,$4EB9,$0001,$D71C; $01B620
    dc.w    $4EB9,$0001,$E398,$7000,$1015,$D040,$207C,$00FF; $01B630
    dc.w    $0118,$3830,$0000,$4878,$0001,$4878,$000F,$2F0C; $01B640
    dc.w    $4EB9,$0000,$5092,$4878,$0040,$42A7,$4878,$0010; $01B650
    dc.w    $4EB9,$0000,$0D64,$42A7,$4EB9,$0000,$538E,$4878; $01B660
    dc.w    $0001,$42A7,$7000,$1015,$48C0,$2F00,$4EB9,$0000; $01B670
    dc.w    $68CA,$4FEF,$0028,$4878,$0002,$4878,$0007,$7000; $01B680
    dc.w    $1015,$48C0,$2F00,$4EB9,$0000,$6B78,$7000,$1015; $01B690
    dc.w    $48C0,$2F00,$4EBA,$0D96,$4E71,$4FEF,$0010,$4EB9; $01B6A0
    dc.w    $0001,$D748,$0C13,$0001,$6600,$00EC,$7000,$102B; $01B6B0
    dc.w    $0001,$D040,$207C,$0005,$E948,$41F0,$0000,$2448; $01B6C0
    dc.w    $4243,$2F3C,$0000,$8000,$4878,$0001,$4878,$0001; $01B6D0
    dc.w    $7000,$102A,$0001,$5980,$2F00,$7000,$1012,$5980; $01B6E0
    dc.w    $2F00,$4878,$0001,$4878,$0766,$4EB9,$0001,$E044; $01B6F0
    dc.w    $4878,$0001,$4878,$000E,$4EB9,$0000,$0D64,$4878; $01B700
    dc.w    $0001,$4878,$0001,$4EB9,$0001,$E0B8,$4FEF,$002C; $01B710
    dc.w    $4878,$0001,$4878,$000E,$4EB9,$0000,$0D64,$508F; $01B720
    dc.w    $5243,$0C43,$0005,$6D9A,$2F3C,$0000,$8000,$4878; $01B730
    dc.w    $0001,$4878,$0001,$7000,$102A,$0001,$5980,$2F00; $01B740
    dc.w    $7000,$1012,$5980,$2F00,$4878,$0001,$4878,$0766; $01B750
    dc.w    $4EB9,$0001,$E044,$4878,$0001,$4878,$000E,$4EB9; $01B760
    dc.w    $0000,$0D64,$4878,$0001,$4878,$0003,$4EB9,$0001; $01B770
    dc.w    $D62C,$4FEF,$002C,$4878,$0001,$4878,$0001,$4EB9; $01B780
    dc.w    $0001,$E0B8,$4878,$0001,$4878,$000E,$4EB9,$0000; $01B790
    dc.w    $0D64,$4FEF,$0010,$4A79,$00FF,$17C4,$6618,$4EB9; $01B7A0
    dc.w    $0002,$A738,$0C79,$FFFF,$00FF,$0A32,$670E,$4EB9; $01B7B0
    dc.w    $0002,$C2FA,$6006,$4EB9,$0001,$E398,$0C13,$0001; $01B7C0
    dc.w    $6600,$0092,$4EB9,$0001,$D71C,$7000,$102B,$0001; $01B7D0
    dc.w    $2F00,$4EB9,$0000,$D648,$33C0,$00FF,$9A1C,$48C0; $01B7E0
    dc.w    $2F00,$4EB9,$0000,$9F4A,$4878,$0001,$3039,$00FF; $01B7F0
    dc.w    $9A1C,$48C0,$2F00,$7000,$1015,$48C0,$2F00,$4EB9; $01B800
    dc.w    $0000,$6A2E,$4878,$0002,$3039,$00FF,$9A1C,$48C0; $01B810
    dc.w    $2F00,$7000,$1015,$48C0,$2F00,$4EB9,$0000,$6B78; $01B820
    dc.w    $7000,$1015,$48C0,$2F00,$4EBA,$00E0,$4E71,$4EB9; $01B830
    dc.w    $0001,$D748,$3039,$00FF,$9A1C,$48C0,$2F00,$7000; $01B840
    dc.w    $1015,$48C0,$2F00,$4EBA,$02D6,$4E71,$4FEF,$002C; $01B850
    dc.w    $7A01,$6026,$4878,$0040,$42A7,$4878,$0010,$4EB9; $01B860
    dc.w    $0000,$0D64,$4EB9,$0003,$204A,$4878,$003C,$4EB9; $01B870
    dc.w    $0001,$E2F4,$4FEF,$0010,$4245,$4279,$00FF,$17C4; $01B880
    dc.w    $5242,$0C42,$0004,$6D00,$FCBE,$3D44,$FFFE,$0C45; $01B890
    dc.w    $0001,$665C,$4EB9,$0001,$D71C,$4878,$0020,$4878; $01B8A0
    dc.w    $0020,$42A7,$42A7,$4EB9,$0003,$A942,$4878,$0007; $01B8B0
    dc.w    $4EB9,$0000,$9F4A,$4EB9,$0001,$E398,$4878,$0040; $01B8C0
    dc.w    $42A7,$4878,$0010,$4EB9,$0000,$0D64,$42A7,$4EB9; $01B8D0
    dc.w    $0000,$538E,$4878,$0001,$42A7,$4878,$0004,$4EB9; $01B8E0
    dc.w    $0000,$68CA,$4FEF,$0030,$4EB9,$0001,$D748,$6010; $01B8F0
    dc.w    $4878,$0040,$42A7,$4878,$0010,$4EB9,$0000,$0D64; $01B900
    dc.w    $4CEE,$3C3C,$FFC0,$4E5E,$4E75,$4E56,$FFFC,$48E7; $01B910
    dc.w    $3000,$242E,$0008,$3639,$00FF,$9A1C,$42A7,$4EB9; $01B920
    dc.w    $0000,$538E,$4878,$077F,$4878,$0001,$4878,$0020; $01B930
    dc.w    $4878,$0013,$42A7,$4878,$0001,$4878,$001A,$4EB9; $01B940
    dc.w    $0000,$0D64,$4FEF,$0020,$4878,$077D,$4878,$0008; $01B950
    dc.w    $4878,$0020,$4878,$0014,$42A7,$4878,$0001,$4878; $01B960
    dc.w    $001A,$4EB9,$0000,$0D64,$3003,$48C0,$2F00,$3002; $01B970
    dc.w    $48C0,$2F00,$4EBA,$11FC,$4E71,$3002,$48C0,$2F00; $01B980
    dc.w    $4EBA,$0AAA,$4E71,$4CEE,$000C,$FFF4,$4E5E,$4E75; $01B990
    dc.w    $4E56,$0000,$4878,$0006,$4878,$06A0,$302E,$000A; $01B9A0
    dc.w    $48C0,$2200,$D080,$D081,$ED88,$D0B9,$000A,$1B58; $01B9B0
    dc.w    $2F00,$4EB9,$0000,$4668,$302E,$0012,$48C0,$E788; $01B9C0
    dc.w    $5180,$2F00,$302E,$000E,$48C0,$E788,$5180,$2F00; $01B9D0
    dc.w    $4879,$0004,$7CE4,$4878,$0001,$4878,$0039,$4878; $01B9E0
    dc.w    $000F,$4EB9,$0000,$0D64,$4878,$000A,$4878,$000E; $01B9F0
    dc.w    $4EB9,$0000,$0D64,$4FEF,$002C,$4878,$0001,$4878; $01BA00
    dc.w    $0039,$4EB9,$0001,$E0B8,$4E5E,$4E75,$4E56,$0000; $01BA10
    dc.w    $48E7,$2038,$242E,$0010,$267C,$0000,$0D64,$287C; $01BA20
    dc.w    $0001,$E044,$0C42,$0020,$3002,$D040,$207C,$0005; $01BA30
    dc.w    $E9FA,$41F0,$0000,$2448,$3002,$48C0,$2F00,$4EB9; $01BA40
    dc.w    $0000,$D648,$588F,$B06E,$000E,$6600,$009E,$0C6E; $01BA50
    dc.w    $0001,$0016,$6600,$0094,$4242,$2F3C,$0000,$8000; $01BA60
    dc.w    $4878,$0001,$4878,$0001,$7000,$102A,$0001,$2F00; $01BA70
    dc.w    $7000,$1012,$2F00,$4878,$0001,$4878,$0766,$4E94; $01BA80
    dc.w    $4878,$0001,$4878,$000E,$4E93,$4FEF,$0024,$42A7; $01BA90
    dc.w    $4878,$0001,$4878,$0001,$7000,$102A,$0001,$2F00; $01BAA0
    dc.w    $7000,$1012,$2F00,$4878,$0001,$42A7,$4E94,$4878; $01BAB0
    dc.w    $0001,$4878,$000E,$4E93,$4FEF,$0024,$5242,$0C42; $01BAC0
    dc.w    $0005,$6D96,$2F3C,$0000,$8000,$4878,$0001,$4878; $01BAD0
    dc.w    $0001,$7000,$102A,$0001,$2F00,$7000,$1012,$2F00; $01BAE0
    dc.w    $4878,$0001,$4878,$0766,$601E,$42A7,$4878,$0001; $01BAF0
    dc.w    $4878,$0001,$7000,$102A,$0001,$2F00,$7000,$1012; $01BB00
    dc.w    $2F00,$4878,$0001,$42A7,$4E94,$4878,$0001,$4878; $01BB10
    dc.w    $000E,$4E93,$4CEE,$1C04,$FFF0,$4E5E,$4E75,$4E56; $01BB20
    dc.w    $0000,$48E7,$3020,$262E,$0008,$45EE,$000E,$4242; $01BB30
    dc.w    $4279,$00FF,$14B8,$6058,$33D2,$00FF,$9A1C,$3002; $01BB40
    dc.w    $0280,$0000,$8000,$6622,$7000,$3002,$2F00,$3003; $01BB50
    dc.w    $48C0,$2F00,$4EBA,$0728,$4E71,$508F,$0C40,$000B; $01BB60
    dc.w    $6750,$34B9,$00FF,$9A1C,$601A,$3012,$48C0,$2F00; $01BB70
    dc.w    $3003,$48C0,$2F00,$4EBA,$0044,$4E71,$508F,$3480; $01BB80
    dc.w    $0242,$7FFF,$3003,$48C0,$2F00,$6100,$FD7E,$588F; $01BB90
    dc.w    $7000,$3002,$2F00,$486E,$000E,$3003,$48C0,$2F00; $01BBA0
    dc.w    $4EBA,$0A94,$4E71,$4FEF,$000C,$3400,$0C40,$000B; $01BBB0
    dc.w    $6686,$4CEE,$040C,$FFF4,$4E5E,$4E75,$4E56,$FFFC; $01BBC0
    dc.w    $48E7,$3F3C,$2A2E,$000C,$2C2E,$0008,$2A7C,$0000; $01BBD0
    dc.w    $0D64,$3006,$C0FC,$0024,$207C,$00FF,$0018,$41F0; $01BBE0
    dc.w    $0000,$2648,$247C,$00FF,$BD64,$7000,$102B,$0001; $01BBF0
    dc.w    $48C0,$2F00,$4EB9,$0000,$D648,$B045,$6636,$7000; $01BC00
    dc.w    $102B,$0001,$D040,$207C,$0005,$E9FA,$1030,$0000; $01BC10
    dc.w    $0280,$0000,$00FF,$3480,$7000,$102B,$0001,$D040; $01BC20
    dc.w    $207C,$0005,$E9FB,$1030,$0000,$0280,$0000,$00FF; $01BC30
    dc.w    $3540,$0002,$363C,$00FF,$303C,$00FF,$3E00,$3D40; $01BC40
    dc.w    $FFFE,$4878,$0004,$4878,$003B,$4EB9,$0001,$E0B8; $01BC50
    dc.w    $42A7,$4878,$000A,$4878,$0020,$4878,$0014,$42A7; $01BC60
    dc.w    $42A7,$4878,$001A,$4E95,$4FEF,$0028,$4878,$077F; $01BC70
    dc.w    $4878,$0001,$4878,$0020,$4878,$0013,$42A7,$4878; $01BC80
    dc.w    $0001,$4878,$001A,$4E95,$4FEF,$001C,$4878,$077D; $01BC90
    dc.w    $4878,$0008,$4878,$0020,$4878,$0014,$42A7,$4878; $01BCA0
    dc.w    $0001,$4878,$001A,$4E95,$4FEF,$001C,$2F3C,$0000; $01BCB0
    dc.w    $8000,$4878,$0002,$4878,$0002,$7000,$302A,$0002; $01BCC0
    dc.w    $2F00,$7000,$3012,$2F00,$42A7,$4878,$0740,$4EB9; $01BCD0
    dc.w    $0001,$E044,$4878,$0001,$4878,$000E,$4E95,$4FEF; $01BCE0
    dc.w    $0024,$4878,$077E,$4878,$0006,$4878,$001C,$4878; $01BCF0
    dc.w    $0013,$4878,$0002,$4878,$0001,$4878,$001A,$4E95; $01BD00
    dc.w    $4FEF,$001C,$4879,$0004,$DD9C,$4878,$0009,$4878; $01BD10
    dc.w    $001E,$4878,$0012,$4878,$0001,$42A7,$4878,$001B; $01BD20
    dc.w    $4E95,$4879,$0004,$DFB8,$4879,$00FF,$1804,$4EB9; $01BD30
    dc.w    $0000,$3FEC,$4FEF,$0024,$42A7,$42A7,$4879,$00FF; $01BD40
    dc.w    $1804,$4878,$000F,$4878,$02E1,$4EB9,$0001,$D568; $01BD50
    dc.w    $4FEF,$0014,$42A7,$4878,$0003,$4EB9,$0001,$D62C; $01BD60
    dc.w    $508F,$0240,$00C0,$66EC,$267C,$0004,$DFB8,$287C; $01BD70
    dc.w    $0004,$DD9C,$4EB9,$0001,$D748,$3005,$48C0,$2F00; $01BD80
    dc.w    $2F0A,$4EB9,$0000,$7B1E,$508F,$3400,$B46E,$FFFE; $01BD90
    dc.w    $675C,$0C43,$00FF,$6652,$0C42,$00FF,$6720,$4878; $01BDA0
    dc.w    $0037,$4878,$0013,$42A7,$4878,$0001,$3002,$48C0; $01BDB0
    dc.w    $2F00,$4EB9,$0000,$88EA,$4FEF,$0014,$602C,$42A7; $01BDC0
    dc.w    $4878,$0002,$4878,$000D,$4878,$0013,$4878,$0004; $01BDD0
    dc.w    $42A7,$4878,$001A,$4E95,$4878,$0002,$4878,$0037; $01BDE0
    dc.w    $4EB9,$0001,$E0B8,$4FEF,$0024,$3D42,$FFFE,$BE42; $01BDF0
    dc.w    $6700,$00B8,$0C43,$00FF,$6700,$00AE,$0C42,$00FF; $01BE00
    dc.w    $6754,$4878,$0039,$4878,$0013,$4878,$0001,$4878; $01BE10
    dc.w    $0001,$3002,$48C0,$2F00,$4EB9,$0000,$88EA,$3002; $01BE20
    dc.w    $48C0,$2F00,$3003,$48C0,$2F00,$3006,$48C0,$2F00; $01BE30
    dc.w    $4EBA,$1284,$4E71,$4878,$0001,$3003,$48C0,$2F00; $01BE40
    dc.w    $3005,$48C0,$2F00,$3006,$48C0,$2F00,$6100,$FBBE; $01BE50
    dc.w    $4FEF,$0030,$6052,$2F3C,$0000,$8000,$4878,$0002; $01BE60
    dc.w    $4878,$0010,$4878,$0013,$4878,$000E,$42A7,$4878; $01BE70
    dc.w    $001A,$4E95,$4FEF,$001C,$2F3C,$0000,$8000,$4878; $01BE80
    dc.w    $0004,$4878,$0011,$4878,$0015,$4878,$000D,$42A7; $01BE90
    dc.w    $4878,$001A,$4E95,$4878,$0002,$4878,$0039,$4EB9; $01BEA0
    dc.w    $0001,$E0B8,$4FEF,$0024,$3E02,$2F3C,$0000,$8000; $01BEB0
    dc.w    $4878,$0002,$4878,$0002,$7000,$302A,$0002,$2F00; $01BEC0
    dc.w    $7000,$3012,$2F00,$42A7,$4878,$0740,$4EB9,$0001; $01BED0
    dc.w    $E044,$4878,$0001,$4878,$000E,$4E95,$4FEF,$0024; $01BEE0
    dc.w    $42A7,$4878,$0003,$4EB9,$0001,$D62C,$508F,$3800; $01BEF0
    dc.w    $0280,$0000,$00FF,$67E8,$3004,$0240,$000F,$6738; $01BF00
    dc.w    $3004,$48C0,$2F00,$2F0A,$4EB9,$0000,$7A74,$4878; $01BF10
    dc.w    $0001,$4878,$000E,$4E95,$3004,$48C0,$2F00,$2F0A; $01BF20
    dc.w    $4EB9,$0000,$7A74,$4878,$0001,$4878,$000E,$4E95; $01BF30
    dc.w    $4FEF,$0020,$6000,$FE3E,$3004,$0240,$0040,$6730; $01BF40
    dc.w    $0C43,$00FF,$671C,$42A7,$3003,$48C0,$2F00,$3005; $01BF50
    dc.w    $48C0,$2F00,$3006,$48C0,$2F00,$6100,$FAB0,$4FEF; $01BF60
    dc.w    $0010,$42A7,$4878,$0002,$4878,$0017,$6000,$02EE; $01BF70
    dc.w    $3004,$0240,$0080,$6700,$00D2,$42A7,$4878,$0006; $01BF80
    dc.w    $4878,$0008,$4878,$0015,$4878,$0001,$42A7,$4878; $01BF90
    dc.w    $001A,$4E95,$3005,$48C0,$2F00,$3006,$48C0,$2F00; $01BFA0
    dc.w    $4EB9,$0000,$8A4A,$4FEF,$0024,$3400,$4878,$077E; $01BFB0
    dc.w    $4878,$0006,$4878,$001C,$4878,$0013,$4878,$0002; $01BFC0
    dc.w    $4878,$0001,$4878,$001A,$4E95,$4FEF,$001C,$2F0C; $01BFD0
    dc.w    $4878,$0009,$4878,$001E,$4878,$0012,$4878,$0001; $01BFE0
    dc.w    $42A7,$4878,$001B,$4E95,$2F0B,$4879,$00FF,$1804; $01BFF0
    dc.w    $4EB9,$0000,$3FEC,$4FEF,$0024,$42A7,$42A7,$4879; $01C000
    dc.w    $00FF,$1804,$4878,$000F,$4878,$02E1,$4EB9,$0001; $01C010
    dc.w    $D568,$4FEF,$0014,$0C42,$00FF,$6726,$3A02,$0C43; $01C020
    dc.w    $00FF,$671E,$4878,$0037,$4878,$0013,$42A7,$4878; $01C030
    dc.w    $0001,$3003,$48C0,$2F00,$4EB9,$0000,$88EA,$4FEF; $01C040
    dc.w    $0014,$3E3C,$00FF,$6000,$FD2C,$3004,$0240,$0020; $01C050
    dc.w    $6700,$014C,$0C42,$00FF,$6700,$FD1A,$0C43,$00FF; $01C060
    dc.w    $6650,$4878,$0001,$302A,$0002,$48C0,$2F00,$3012; $01C070
    dc.w    $48C0,$2F00,$4EB9,$0000,$9CEC,$4878,$0001,$3002; $01C080
    dc.w    $48C0,$2F00,$3005,$48C0,$2F00,$3006,$48C0,$2F00; $01C090
    dc.w    $6100,$F97A,$4FEF,$001C,$3602,$42A7,$4878,$0003; $01C0A0
    dc.w    $4EB9,$0001,$D62C,$508F,$0240,$0020,$66EC,$6000; $01C0B0
    dc.w    $FCC4,$B642,$6600,$FCBE,$42A7,$302A,$0002,$48C0; $01C0C0
    dc.w    $2F00,$3012,$48C0,$2F00,$4EB9,$0000,$9CEC,$3002; $01C0D0
    dc.w    $48C0,$2F00,$3005,$48C0,$2F00,$3006,$48C0,$2F00; $01C0E0
    dc.w    $4EBA,$0250,$4E71,$4878,$0004,$4878,$003B,$4EB9; $01C0F0
    dc.w    $0001,$E0B8,$4FEF,$0020,$4878,$077E,$4878,$0006; $01C100
    dc.w    $4878,$001C,$4878,$0013,$4878,$0002,$4878,$0001; $01C110
    dc.w    $4878,$001A,$4E95,$4FEF,$001C,$2F0C,$4878,$0009; $01C120
    dc.w    $4878,$001E,$4878,$0012,$4878,$0001,$42A7,$4878; $01C130
    dc.w    $001B,$4E95,$2F0B,$4879,$00FF,$1804,$4EB9,$0000; $01C140
    dc.w    $3FEC,$4FEF,$0024,$42A7,$42A7,$4879,$00FF,$1804; $01C150
    dc.w    $4878,$000F,$4878,$02E1,$4EB9,$0001,$D568,$4878; $01C160
    dc.w    $0037,$4878,$0013,$42A7,$4878,$0001,$3002,$48C0; $01C170
    dc.w    $2F00,$4EB9,$0000,$88EA,$4FEF,$0028,$4878,$0001; $01C180
    dc.w    $3002,$48C0,$2F00,$3005,$48C0,$2F00,$3006,$48C0; $01C190
    dc.w    $2F00,$6100,$F878,$4FEF,$0010,$6000,$FEA6,$3004; $01C1A0
    dc.w    $0240,$0010,$6700,$FBCE,$0C43,$00FF,$6700,$00A4; $01C1B0
    dc.w    $4878,$0002,$4878,$0039,$4EB9,$0001,$E0B8,$42A7; $01C1C0
    dc.w    $3003,$48C0,$2F00,$3005,$48C0,$2F00,$3006,$48C0; $01C1D0
    dc.w    $2F00,$6100,$F838,$4FEF,$0018,$B443,$6624,$42A7; $01C1E0
    dc.w    $4878,$0006,$4878,$000B,$4878,$0013,$4878,$0013; $01C1F0
    dc.w    $42A7,$4878,$001A,$4E95,$4FEF,$001C,$3E3C,$00FF; $01C200
    dc.w    $6034,$4878,$0002,$4878,$0037,$4EB9,$0001,$E0B8; $01C210
    dc.w    $42A7,$4878,$0006,$4878,$001C,$4878,$0013,$4878; $01C220
    dc.w    $0002,$42A7,$4878,$001A,$4E95,$4FEF,$0024,$3E3C; $01C230
    dc.w    $00FF,$3D47,$FFFE,$363C,$00FF,$42A7,$4878,$0003; $01C240
    dc.w    $4EB9,$0001,$D62C,$508F,$0240,$0010,$66EC,$6000; $01C250
    dc.w    $FB24,$42A7,$4878,$0002,$4878,$0019,$4878,$0013; $01C260
    dc.w    $4878,$0004,$42A7,$4878,$001A,$4E95,$4EB9,$0003; $01C270
    dc.w    $77C8,$3005,$4CEE,$3CFC,$FFD4,$4E5E,$4E75,$2F02; $01C280
    dc.w    $242F,$000C,$4878,$0020,$4878,$0020,$42A7,$42A7; $01C290
    dc.w    $4EB9,$0003,$A942,$4FEF,$0010,$3002,$48C0,$720A; $01C2A0
    dc.w    $B081,$6200,$0088,$D080,$303B,$0806,$4EFB,$0002; $01C2B0
    dc.w    $0016,$001E,$0046,$002E,$004E,$005E,$0026,$0056; $01C2C0
    dc.w    $0036,$0066,$006E,$4EB9,$0003,$6F12,$605E,$4EB9; $01C2D0
    dc.w    $0001,$4202,$6056,$4EB9,$0000,$F5AA,$604E,$4EB9; $01C2E0
    dc.w    $0002,$C9C8,$6046,$4EB9,$0002,$F712,$33FC,$0001; $01C2F0
    dc.w    $00FF,$14B8,$6036,$4EB9,$0002,$7F18,$602E,$4EB9; $01C300
    dc.w    $0002,$9ABC,$6026,$4EB9,$0001,$2E92,$601E,$4EB9; $01C310
    dc.w    $0000,$D6BE,$6016,$4EB9,$0002,$3EA8,$600E,$4EB9; $01C320
    dc.w    $0001,$6F9E,$0C40,$0001,$6602,$740B,$3002,$241F; $01C330
    dc.w    $4E75,$4E56,$FFFC,$48E7,$3F00,$242E,$0010,$2E2E; $01C340
    dc.w    $0008,$3002,$0040,$8000,$33C0,$00FF,$A6B0,$4EB9; $01C350
    dc.w    $0002,$0A64,$4EB9,$0001,$D748,$0C42,$0020,$6C04; $01C360
    dc.w    $7C06,$6002,$7C04,$3A3C,$00E2,$603C,$7811,$7608; $01C370
    dc.w    $4242,$601C,$3002,$48C0,$D0AE,$FFFC,$2040,$1010; $01C380
    dc.w    $5A43,$3003,$0C40,$0012,$6D04,$5C44,$7608,$5242; $01C390
    dc.w    $B446,$6DE0,$4878,$0001,$4878,$000E,$4EB9,$0000; $01C3A0
    dc.w    $0D64,$508F,$7002,$B145,$42A7,$4878,$0003,$4EB9; $01C3B0
    dc.w    $0001,$D62C,$508F,$0280,$0000,$0010,$67AE,$4878; $01C3C0
    dc.w    $0001,$4878,$0003,$4EB9,$0001,$D62C,$508F,$0280; $01C3D0
    dc.w    $0000,$0010,$67E8,$4EB9,$0001,$D71C,$4EB9,$0001; $01C3E0
    dc.w    $E398,$4878,$0001,$302E,$000E,$48C0,$2F00,$3007; $01C3F0
    dc.w    $48C0,$2F00,$4EB9,$0000,$6A2E,$4878,$0002,$302E; $01C400
    dc.w    $000E,$48C0,$2F00,$3007,$48C0,$2F00,$4EB9,$0000; $01C410
    dc.w    $6B78,$3007,$48C0,$2F00,$6100,$F4F0,$4EB9,$0001; $01C420
    dc.w    $D748,$4CEE,$00FC,$FFE4,$4E5E,$4E75              ; $01C430
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
    dc.w    $48E7                                            ; $01C54E
    dc.w    $2030,$267C,$00FF,$0018,$4EB9,$0001,$D748,$4878; $01C550
    dc.w    $0003,$4878,$001D,$4878,$0012,$4878,$0002,$4EB9; $01C560
    dc.w    $0000,$5A04,$4FEF,$0010,$244B,$4242,$4878,$0013; $01C570
    dc.w    $3002,$48C0,$2200,$E788,$9081,$5680,$2F00,$4EB9; $01C580
    dc.w    $0003,$AB2C,$0C12,$0001,$6610,$3002,$48C0,$5280; $01C590
    dc.w    $2F00,$4879,$0004,$1164,$600E,$3002,$48C0,$5280; $01C5A0
    dc.w    $2F00,$4879,$0004,$115C,$4EB9,$0003,$B246,$4FEF; $01C5B0
    dc.w    $0010,$5242,$7024,$D5C0,$0C42,$0004,$6DAE,$4878; $01C5C0
    dc.w    $0001,$4878,$0003,$4EB9,$0001,$D62C,$508F,$3400; $01C5D0
    dc.w    $0280,$0000,$00D0,$67E6,$3002,$0240,$0040,$6706; $01C5E0
    dc.w    $244B,$7001,$B112,$3002,$0240,$0010,$670A,$244B; $01C5F0
    dc.w    $7048,$D5C0,$7001,$B112,$3002,$0240,$0040,$670A; $01C600
    dc.w    $244B,$7024,$D5C0,$7001,$B112,$3002,$0240,$0080; $01C610
    dc.w    $670A,$244B,$706C,$D5C0,$7001,$B112,$4878,$0002; $01C620
    dc.w    $4878,$000E,$4EB9,$0000,$0D64,$508F,$6000,$FF3A; $01C630
    dc.w    $4CDF,$0C04,$4E75,$4E56,$0000,$48E7,$3F3C,$2E2E; $01C640
    dc.w    $0010,$246E,$000C,$267C,$00FF,$13FC,$287C,$0000; $01C650
    dc.w    $0D64,$2A7C,$00FF,$A7D8,$7000,$3007,$7206,$4EB9; $01C660
    dc.w    $0003,$E146,$2C00,$CCFC,$0003,$0646,$000E,$7000; $01C670
    dc.w    $3007,$7206,$4EB9,$0003,$E08A,$2A00,$DA45,$0645; $01C680
    dc.w    $0016,$2F39,$000A,$1B54,$4879,$00FF,$1804,$4EB9; $01C690
    dc.w    $0000,$3FEC,$4878,$0047,$4878,$02E1,$4879,$00FF; $01C6A0
    dc.w    $1804,$4EB9,$0000,$4668,$4879,$0007,$2DCC,$4878; $01C6B0
    dc.w    $0004,$4878,$0012,$4878,$0015,$4878,$000D,$42A7; $01C6C0
    dc.w    $4878,$001B,$4E94,$4FEF,$0030,$2F3C,$0000,$8000; $01C6D0
    dc.w    $4878,$0002,$4878,$0002,$3005,$48C0,$E788,$2F00; $01C6E0
    dc.w    $3006,$48C0,$E788,$2F00,$42A7,$4878,$0740,$4EB9; $01C6F0
    dc.w    $0001,$E044,$4878,$0001,$4878,$000E,$4E94,$4EB9; $01C700
    dc.w    $0001,$D748,$4EB9,$0001,$A60E,$4878,$0001,$3012; $01C710
    dc.w    $48C0,$2F00,$4EB9,$0001,$A672,$42A7,$4EB9,$0001; $01C720
    dc.w    $E1EC,$4FEF,$0030,$4A40,$6704,$7801,$6002,$7800; $01C730
    dc.w    $4243,$4253,$4255,$4A44,$672A,$42A7,$4EB9,$0001; $01C740
    dc.w    $E1EC,$588F,$4A40,$671C,$3012,$48C0,$2F00,$4EB9; $01C750
    dc.w    $0001,$ABB0,$4878,$0001,$4878,$000E,$4E94,$4FEF; $01C760
    dc.w    $000C,$60D2,$4244,$0C53,$0001,$6642,$4A55,$663E; $01C770
    dc.w    $740A,$6032,$42A7,$4EB9,$0001,$E1EC,$588F,$0280; $01C780
    dc.w    $0000,$FFFF,$3203,$48C1,$B081,$6622,$3012,$48C0; $01C790
    dc.w    $2F00,$4EB9,$0001,$ABB0,$4878,$0001,$4878,$000E; $01C7A0
    dc.w    $4E94,$4FEF,$000C,$2002,$5342,$4A40,$66C6,$0C53; $01C7B0
    dc.w    $0001,$6604,$3ABC,$0001,$42A7,$4EB9,$0001,$E1EC; $01C7C0
    dc.w    $588F,$3600,$48C0,$7208,$B041,$6738,$7204,$B041; $01C7D0
    dc.w    $6752,$7202,$B041,$6768,$7201,$B041,$6700,$0082; $01C7E0
    dc.w    $7220,$B041,$6700,$0096,$7240,$B041,$6700,$00E0; $01C7F0
    dc.w    $0C40,$0080,$6700,$00E2,$7210,$B041,$6700,$01CA; $01C800
    dc.w    $6000,$0302,$36BC,$0001,$3006,$48C0,$5680,$721D; $01C810
    dc.w    $B280,$6F08,$3006,$48C0,$5680,$6002,$701D,$3C00; $01C820
    dc.w    $6000,$02E6,$36BC,$0001,$3006,$48C0,$5780,$720E; $01C830
    dc.w    $B280,$6C08,$3006,$48C0,$5780,$60E2,$700E,$60DE; $01C840
    dc.w    $36BC,$0001,$3005,$48C0,$5480,$7218,$B280,$6F08; $01C850
    dc.w    $3005,$48C0,$5480,$6002,$7018,$3A00,$6000,$02AA; $01C860
    dc.w    $36BC,$0001,$3005,$48C0,$5580,$7216,$B280,$6C08; $01C870
    dc.w    $3005,$48C0,$5580,$60E2,$7016,$60DE,$4253,$4255; $01C880
    dc.w    $3005,$48C0,$0480,$0000,$0016,$6C02,$5280,$E280; $01C890
    dc.w    $2E00,$CEFC,$0006,$2F07,$3006,$48C0,$0480,$0000; $01C8A0
    dc.w    $000E,$7203,$4EB9,$0003,$E08A,$D09F,$3E00,$3005; $01C8B0
    dc.w    $2F00,$3006,$2F00,$3007,$2F00,$6100,$F0D4,$4FEF; $01C8C0
    dc.w    $000C,$4EB9,$0001,$A64C,$3007,$6000,$029C,$4253; $01C8D0
    dc.w    $4255,$0047,$8000,$60EA,$4253,$4255,$4EB9,$0001; $01C8E0
    dc.w    $A64C,$42A7,$4878,$0006,$4878,$0008,$4878,$0015; $01C8F0
    dc.w    $4878,$0001,$42A7,$4878,$001A,$4E94,$3012,$48C0; $01C900
    dc.w    $2F00,$302E,$000A,$48C0,$2F00,$4EB9,$0000,$8A4A; $01C910
    dc.w    $3400,$0C42,$00FF,$6706,$B452,$6702,$3482,$302E; $01C920
    dc.w    $000A,$48C0,$2F00,$6100,$EFE2,$2F39,$000A,$1B54; $01C930
    dc.w    $4879,$00FF,$1804,$4EB9,$0000,$3FEC,$4FEF,$0030; $01C940
    dc.w    $4878,$0047,$4878,$02E1,$4879,$00FF,$1804,$4EB9; $01C950
    dc.w    $0000,$4668,$4879,$0007,$2DCC,$4878,$0004,$4878; $01C960
    dc.w    $0012,$4878,$0015,$4878,$000D,$42A7,$4878,$001B; $01C970
    dc.w    $4E94,$4FEF,$0028,$2F3C,$0000,$8000,$4878,$0002; $01C980
    dc.w    $4878,$0002,$3005,$48C0,$E788,$2F00,$3006,$48C0; $01C990
    dc.w    $E788,$2F00,$42A7,$4878,$0740,$4EB9,$0001,$E044; $01C9A0
    dc.w    $4878,$0001,$4878,$000E,$4E94,$4878,$0001,$3012; $01C9B0
    dc.w    $48C0,$2F00,$4EB9,$0001,$A672,$4FEF,$002C,$4EB9; $01C9C0
    dc.w    $0001,$D748,$6000,$0142,$4253,$4255,$4EB9,$0001; $01C9D0
    dc.w    $A64C,$4EB9,$0001,$D71C,$33FC,$0007,$00FF,$9A1C; $01C9E0
    dc.w    $4878,$0040,$42A7,$4878,$0010,$4E94,$4878,$0040; $01C9F0
    dc.w    $42A7,$4EB9,$0000,$538E,$4878,$0001,$42A7,$302E; $01CA00
    dc.w    $000A,$48C0,$2F00,$4EB9,$0000,$68CA,$4878,$0002; $01CA10
    dc.w    $4878,$0007,$302E,$000A,$48C0,$2F00,$4EB9,$0000; $01CA20
    dc.w    $6B78,$302E,$000A,$48C0,$2F00,$6100,$FA00,$4FEF; $01CA30
    dc.w    $0030,$4EB9,$0001,$D748,$4243,$3003,$2F00,$4878; $01CA40
    dc.w    $000A,$4EB9,$0001,$E290,$508F,$0280,$0000,$0090; $01CA50
    dc.w    $67E8,$4EB9,$0001,$D71C,$33D2,$00FF,$9A1C,$4878; $01CA60
    dc.w    $0001,$3039,$00FF,$9A1C,$48C0,$2F00,$302E,$000A; $01CA70
    dc.w    $48C0,$2F00,$4EB9,$0000,$6A2E,$4878,$0002,$3039; $01CA80
    dc.w    $00FF,$9A1C,$48C0,$2F00,$302E,$000A,$48C0,$2F00; $01CA90
    dc.w    $4EB9,$0000,$6B78,$302E,$000A,$48C0,$2F00,$6100; $01CAA0
    dc.w    $EE6A,$2F39,$000A,$1B54,$4879,$00FF,$1804,$4EB9; $01CAB0
    dc.w    $0000,$3FEC,$4878,$0047,$4878,$02E1,$4879,$00FF; $01CAC0
    dc.w    $1804,$4EB9,$0000,$4668,$4FEF,$0030,$4879,$0007; $01CAD0
    dc.w    $2DCC,$4878,$0004,$4878,$0012,$4878,$0015,$4878; $01CAE0
    dc.w    $000D,$42A7,$4878,$001B,$4E94,$4878,$0001,$3012; $01CAF0
    dc.w    $48C0,$2F00,$4EB9,$0001,$A672,$4FEF,$0024,$4EB9; $01CB00
    dc.w    $0001,$D748,$4253,$4255,$2F3C,$0000,$8000,$4878; $01CB10
    dc.w    $0002,$4878,$0002,$3005,$48C0,$E788,$2F00,$3006; $01CB20
    dc.w    $48C0,$E788,$2F00,$42A7,$4878,$0740,$4EB9,$0001; $01CB30
    dc.w    $E044,$4878,$0001,$4878,$000E,$4E94,$4FEF,$0024; $01CB40
    dc.w    $4242,$3012,$48C0,$2F00,$4EB9,$0001,$ABB0,$4878; $01CB50
    dc.w    $0001,$4878,$000E,$4E94,$4FEF,$000C,$5242,$0C42; $01CB60
    dc.w    $0004,$65DE,$6000,$FBD0,$4CEE,$3CFC,$FFD8,$4E5E; $01CB70
    dc.w    $4E75,$4E56,$FFC0,$48E7,$3E3C,$2A2E,$0008,$2C2E; $01CB80
    dc.w    $000C,$287C,$0004,$A5B8,$4BEE,$FFE2,$4878,$0010; $01CB90
    dc.w    $486E,$FFF0,$42A7,$200C,$7212,$D081,$2F00,$42A7; $01CBA0
    dc.w    $4EB9,$0001,$D538,$4242,$3005,$E548,$207C,$00FF; $01CBB0
    dc.w    $A6A0,$2030,$0000,$3202,$E549,$207C,$0005,$ECDC; $01CBC0
    dc.w    $C0B0,$1000,$6716,$3005,$D040,$207C,$00FF,$0118; $01CBD0
    dc.w    $3030,$0000,$3202,$D241,$3D80,$10F0,$5242,$0C42; $01CBE0
    dc.w    $0007,$6DC4,$4878,$0010,$4878,$0030,$200C,$5480; $01CBF0
    dc.w    $2F00,$4EB9,$0000,$5092,$200C,$0680,$0000,$0082; $01CC00
    dc.w    $2F00,$4879,$00FF,$1804,$4EB9,$0000,$3FEC,$4FEF; $01CC10
    dc.w    $0028,$42A7,$42A7,$4879,$00FF,$1804,$4878,$0025; $01CC20
    dc.w    $4878,$0330,$4EB9,$0001,$D568,$200C,$7222,$D081; $01CC30
    dc.w    $2F00,$4878,$0006,$4878,$0008,$4878,$0015,$4878; $01CC40
    dc.w    $0001,$42A7,$4878,$001B,$4EB9,$0000,$0D64,$4FEF; $01CC50
    dc.w    $0030,$4878,$0008,$4878,$0038,$486E,$FFF0,$4EB9; $01CC60
    dc.w    $0000,$5092,$4878,$000E,$42A7,$2F0D,$4EB9,$0001; $01CC70
    dc.w    $D520,$3005,$D040,$207C,$00FF,$0118,$3D70,$0000; $01CC80
    dc.w    $FFE0,$4878,$0001,$4878,$000F,$486E,$FFE0,$4EB9; $01CC90
    dc.w    $0000,$5092,$4FEF,$0024,$3005,$EB48,$207C,$00FF; $01CCA0
    dc.w    $0338,$41F0,$0000,$2448,$4243,$4244,$6000,$0104; $01CCB0
    dc.w    $4A2A,$0001,$664A,$42A7,$4878,$0002,$4878,$0001; $01CCC0
    dc.w    $4878,$00A8,$3004,$48C0,$E788,$0680,$0000,$0048; $01CCD0
    dc.w    $2F00,$3003,$48C0,$0680,$0000,$003B,$2F00,$4878; $01CCE0
    dc.w    $0544,$4EB9,$0001,$E044,$4878,$0001,$4878,$000E; $01CCF0
    dc.w    $4EB9,$0000,$0D64,$4FEF,$0024,$5244,$6000,$00B0; $01CD00
    dc.w    $0C2A,$0006,$0001,$6716,$7400,$1412,$3002,$48C0; $01CD10
    dc.w    $2F00,$4EB9,$0000,$D648,$588F,$3400,$6018,$7400; $01CD20
    dc.w    $1412,$3006,$48C0,$2F00,$3005,$48C0,$2F00,$4EB9; $01CD30
    dc.w    $0000,$9DC4,$508F,$B446,$6774,$3002,$D040,$207C; $01CD40
    dc.w    $0005,$F088,$41F0,$0000,$2648,$42A7,$4878,$0002; $01CD50
    dc.w    $4878,$0001,$7000,$102B,$0001,$0680,$0000,$00A8; $01CD60
    dc.w    $2F00,$3002,$48C0,$D080,$2040,$3035,$8800,$48C0; $01CD70
    dc.w    $7200,$1213,$D081,$5080,$2F00,$3003,$48C0,$0680; $01CD80
    dc.w    $0000,$003B,$2F00,$4878,$0544,$4EB9,$0001,$E044; $01CD90
    dc.w    $4878,$0001,$4878,$000E,$4EB9,$0000,$0D64,$4FEF; $01CDA0
    dc.w    $0024,$3002,$48C0,$D080,$2040,$5675,$8800,$508A; $01CDB0
    dc.w    $5243,$0C43,$0004,$6D00,$FEF8,$3039,$00FF,$0006; $01CDC0
    dc.w    $48C0,$7204,$4EB9,$0003,$E146,$2400,$C4FC,$0003; $01CDD0
    dc.w    $3039,$00FF,$0006,$48C0,$6C02,$5680,$E480,$0640; $01CDE0
    dc.w    $07A3,$3600,$4878,$0020,$4878,$0020,$42A7,$42A7; $01CDF0
    dc.w    $4EB9,$0003,$A942,$4878,$0015,$4878,$0001,$4EB9; $01CE00
    dc.w    $0003,$AB2C,$3003,$48C0,$2F00,$3002,$E548,$207C; $01CE10
    dc.w    $0005,$F096,$2F30,$0000,$4879,$0004,$116C,$4EB9; $01CE20
    dc.w    $0003,$B246,$4CEE,$3C7C,$FF9C,$4E5E,$4E75,$48E7; $01CE30
    dc.w    $3E20,$262F,$0020,$2C2F,$001C,$247C,$0000,$0D64; $01CE40
    dc.w    $3406,$383C,$0080,$3004,$0240,$0080,$6700,$00AC; $01CE50
    dc.w    $3002,$48C0,$5280,$7204,$4EB9,$0003,$E146,$3400; $01CE60
    dc.w    $4878,$0001,$3003,$48C0,$2F00,$3002,$48C0,$2F00; $01CE70
    dc.w    $4EB9,$0000,$6A2E,$4878,$0002,$3003,$48C0,$2F00; $01CE80
    dc.w    $3002,$48C0,$2F00,$4EB9,$0000,$6B78,$3002,$48C0; $01CE90
    dc.w    $2F00,$6100,$EA76,$4FEF,$001C,$3002,$EB48,$3203; $01CEA0
    dc.w    $E549,$D041,$207C,$00FF,$0130,$4AB0,$0000,$674A; $01CEB0
    dc.w    $4878,$0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003; $01CEC0
    dc.w    $A942,$4878,$0015,$4878,$000E,$4EB9,$0003,$AB2C; $01CED0
    dc.w    $3002,$E748,$D043,$207C,$00FF,$0270,$1030,$0000; $01CEE0
    dc.w    $0280,$0000,$00FF,$48C0,$2F00,$4879,$0004,$1180; $01CEF0
    dc.w    $4EB9,$0003,$B270,$4FEF,$0020,$4878,$0004,$4878; $01CF00
    dc.w    $000E,$4E92,$508F,$42A7,$4878,$0003,$4EB9,$0001; $01CF10
    dc.w    $D62C,$508F,$3800,$0280,$0000,$0090,$67E8,$3004; $01CF20
    dc.w    $0240,$0010,$6600,$0126,$3004,$0240,$0020,$6700; $01CF30
    dc.w    $FF16,$3004,$0240,$0020,$674E,$42A7,$4878,$0006; $01CF40
    dc.w    $4878,$0008,$4878,$0015,$4878,$0001,$42A7,$4878; $01CF50
    dc.w    $001A,$4E92,$3003,$48C0,$2F00,$3002,$48C0,$2F00; $01CF60
    dc.w    $4EB9,$0000,$8A4A,$4FEF,$0024,$3A00,$42A7,$42A7; $01CF70
    dc.w    $4878,$0020,$4878,$0012,$42A7,$42A7,$4878,$001A; $01CF80
    dc.w    $4E92,$4FEF,$001C,$601E,$3004,$48C0,$2F00,$3003; $01CF90
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$9F48; $01CFA0
    dc.w    $4FEF,$000C,$3A00,$0C45,$00FF,$6700,$008A,$BA43; $01CFB0
    dc.w    $6700,$0084,$3605,$3002,$EB48,$3203,$E549,$D041; $01CFC0
    dc.w    $207C,$00FF,$0130,$4AB0,$0000,$674C,$4878,$0020; $01CFD0
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$4878; $01CFE0
    dc.w    $0015,$4878,$000E,$4EB9,$0003,$AB2C,$3002,$E748; $01CFF0
    dc.w    $D043,$207C,$00FF,$0270,$1030,$0000,$0280,$0000; $01D000
    dc.w    $00FF,$48C0,$2F00,$4879,$0004,$1172,$4EB9,$0003; $01D010
    dc.w    $B270,$4FEF,$0020,$601E,$42A7,$4878,$0002,$4878; $01D020
    dc.w    $0006,$4878,$0015,$4878,$000E,$42A7,$4878,$001A; $01D030
    dc.w    $4E92,$4FEF,$001C,$3003,$48C0,$2F00,$3002,$48C0; $01D040
    dc.w    $2F00,$6100,$FB2E,$508F,$6000,$FDFC,$BC42,$673C; $01D050
    dc.w    $4878,$0001,$3003,$48C0,$2F00,$3006,$48C0,$2F00; $01D060
    dc.w    $4EB9,$0000,$6A2E,$4878,$0002,$3003,$48C0,$2F00; $01D070
    dc.w    $3006,$48C0,$2F00,$4EB9,$0000,$6B78,$3006,$48C0; $01D080
    dc.w    $2F00,$6100,$E886,$4FEF,$001C,$601E,$42A7,$4878; $01D090
    dc.w    $0002,$4878,$0012,$4878,$0015,$4878,$000E,$42A7; $01D0A0
    dc.w    $4878,$001A,$4E92,$4FEF,$001C,$33C3,$00FF,$9A1C; $01D0B0
    dc.w    $4CDF,$047C,$4E75,$48E7,$3E38,$242F,$002C,$262F; $01D0C0
    dc.w    $0028,$2A2F,$0024,$247C,$0000,$0D64,$267C,$0003; $01D0D0
    dc.w    $B270,$287C,$0003,$AB2C,$B642,$6700,$01DA,$3002; $01D0E0
    dc.w    $48C0,$2F00,$4EB9,$0000,$D648,$3C00,$4878,$0020; $01D0F0
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$3002; $01D100
    dc.w    $48C0,$2F00,$3003,$48C0,$2F00,$4EB9,$0000,$6F42; $01D110
    dc.w    $4FEF,$001C,$2800,$0284,$0000,$FFFF,$0C84,$0000; $01D120
    dc.w    $FFFF,$6700,$0192,$4A84,$6700,$018C,$4878,$0015; $01D130
    dc.w    $4878,$000D,$4E94,$4879,$0004,$11A0,$4E93,$4878; $01D140
    dc.w    $0015,$4878,$0016,$4E94,$2F04,$4879,$0004,$1198; $01D150
    dc.w    $4E93,$4878,$0017,$4878,$000D,$4E94,$4878,$0003; $01D160
    dc.w    $3002,$2F00,$3003,$2F00,$4EB9,$0001,$A506,$4FEF; $01D170
    dc.w    $000C,$2F00,$4879,$0004,$118E,$4E93,$4FEF,$002C; $01D180
    dc.w    $4878,$0001,$4878,$0003,$4EB9,$0001,$D62C,$508F; $01D190
    dc.w    $3800,$0240,$0020,$6700,$010A,$4878,$0001,$3039; $01D1A0
    dc.w    $00FF,$BD66,$48C0,$2F00,$3039,$00FF,$BD64,$48C0; $01D1B0
    dc.w    $2F00,$4EB9,$0000,$9CEC,$3002,$48C0,$2F00,$3003; $01D1C0
    dc.w    $48C0,$2F00,$3005,$48C0,$2F00,$4EB9,$0001,$8F8E; $01D1D0
    dc.w    $4FEF,$0018,$7201,$B280,$6600,$00C8,$4878,$077E; $01D1E0
    dc.w    $4878,$0006,$4878,$001C,$4878,$0013,$4878,$0002; $01D1F0
    dc.w    $4878,$0001,$4878,$001A,$4E92,$4FEF,$001C,$4879; $01D200
    dc.w    $0004,$DD9C,$4878,$0009,$4878,$001E,$4878,$0012; $01D210
    dc.w    $4878,$0001,$42A7,$4878,$001B,$4E92,$4879,$0004; $01D220
    dc.w    $DFB8,$4879,$00FF,$1804,$4EB9,$0000,$3FEC,$4FEF; $01D230
    dc.w    $0024,$42A7,$42A7,$4879,$00FF,$1804,$4878,$000F; $01D240
    dc.w    $4878,$02E1,$4EB9,$0001,$D568,$4878,$0037,$4878; $01D250
    dc.w    $0013,$42A7,$4878,$0001,$3003,$48C0,$2F00,$4EB9; $01D260
    dc.w    $0000,$88EA,$4FEF,$0028,$4878,$0001,$3003,$48C0; $01D270
    dc.w    $2F00,$3006,$48C0,$2F00,$3005,$48C0,$2F00,$6100; $01D280
    dc.w    $E78C,$4878,$0039,$4878,$0013,$4878,$0001,$4878; $01D290
    dc.w    $0001,$3002,$48C0,$2F00,$4EB9,$0000,$88EA,$4FEF; $01D2A0
    dc.w    $0024,$42A7,$4878,$0003,$4EB9,$0001,$D62C,$508F; $01D2B0
    dc.w    $0240,$0010,$66EC,$4878,$077F,$4878,$0001,$4878; $01D2C0
    dc.w    $0020,$4878,$0013,$42A7,$4878,$0001,$4878,$001A; $01D2D0
    dc.w    $4E92,$4FEF,$001C,$4878,$077E,$4878,$0006,$4878; $01D2E0
    dc.w    $001C,$4878,$0013,$4878,$0002,$4878,$0001,$4878; $01D2F0
    dc.w    $001A,$4E92,$4FEF,$001C,$4CDF,$1C7C,$4E75,$4E75; $01D300
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
    dc.w    $6100,$FF64                                  ; bsr.w $01D340
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
    dc.w    $4EB9,$0003,$E08A                                ; jsr SignedDiv
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
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
    dc.w    $4EBA,$0C62                                          ; jsr $1E2F4(pc) (delay)
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
    addq.l  #4,sp                                                ; clean arg
    add.w   d0,d2                                                ; accumulate return value
    move.l  (a2),d0                                              ; D0 = RNG state
    move.l  #$41C64E6D,d1                                        ; D1 = LCG multiplier (1103515245)
    dc.w    $4EB9,$0003,$E05C                                    ; jsr Multiply32 (D0 * D1)
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
    dc.w    $4EB9,$0003,$E146                                    ; jsr Divide32 (D0 / D1, remainder)
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
    dc.w    $4EB9,$0000,$4CB6                                    ; jsr $00004CB6
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
    dc.w    $4EB9,$0000,$4D04                                    ; jsr $00004D04
    lea     $10(sp),sp                                           ; clean 16 bytes of args
    clr.w   ($00FFA7DC).l                                        ; clear loaded flag
.done:                                                           ; $01D770
    rts
; ---
    dc.w    $4E56,$FFF8,$48E7,$3000,$242E,$0010,$262E          ; $01D772 (next fn)
    dc.w    $000C,$322E,$0016,$9243,$302E,$001A,$9042,$C2C0; $01D780
    dc.w    $302E,$000A,$48C0,$2F00,$3001,$48C0,$2F00,$3002; $01D790
    dc.w    $48C0,$2F00,$3003,$48C0,$2F00,$486E,$FFF8,$4EBA; $01D7A0
    dc.w    $06A2,$4E71,$4CEE,$000C,$FFF0,$4E5E,$4E75       ; $01D7B0
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
    dc.w    $262F,$001C,$2A2F,$0020,$2C2F,$0024,$246F,$0028; $01D840
    dc.w    $3003,$EB48,$3600,$4244,$6046,$4242,$6038,$42A7; $01D850
    dc.w    $3003,$48C0,$2F00,$3005,$48C0,$EB88,$3202,$48C1; $01D860
    dc.w    $4EB9,$0003,$E05C,$4872,$0800,$4878,$0010,$4878; $01D870
    dc.w    $0002,$4878,$0005,$4EB9,$0000,$0D64,$4FEF,$0018; $01D880
    dc.w    $0643,$0020,$5242,$B446,$6DC4,$7020,$D5C0,$5244; $01D890
    dc.w    $B845,$6DB6,$4CDF,$047C,$4E75,$2F02,$242F,$000C; $01D8A0
    dc.w    $222F,$0008,$206F,$0010,$42A7,$3001,$48C0,$EB88; $01D8B0
    dc.w    $2F00,$2F08,$3002,$48C0,$E988,$2F00,$4878,$0002; $01D8C0
    dc.w    $4878,$0005,$4EB9,$0000,$0D64,$4FEF,$0018,$241F; $01D8D0
    dc.w    $4E75,$4878,$0010,$4878,$0013,$4EB9,$0000,$0D64; $01D8E0
    dc.w    $508F,$4E75                                      ; $01D8F0
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
    dc.w    $6100,$fbf4                                 ; bsr.w $01D520
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
    dc.w    $242F,$0028,$262F,$002C,$282F,$0024,$2A2F,$0020; $01D990
    dc.w    $267C,$0000,$0D64,$287C,$00FF,$1804,$4878,$0800; $01D9A0
    dc.w    $42A7,$200C,$0680,$0000,$5000,$2F00,$6100,$FB62; $01D9B0
    dc.w    $4FEF,$000C,$4A43,$660E,$2F3C,$0000,$8B00,$42A7; $01D9C0
    dc.w    $4E93,$508F,$6034,$2F3C,$0000,$8B02,$42A7,$4E93; $01D9D0
    dc.w    $508F,$3004,$48C0,$EB88,$41F4,$0800,$41E8,$5000; $01D9E0
    dc.w    $2448,$0C45,$0001,$6602,$548A,$4443,$6008,$3483; $01D9F0
    dc.w    $5342,$7020,$D5C0,$4A42,$6EF4,$42A7,$2F3C,$0000; $01DA00
    dc.w    $FC00,$200C,$0680,$0000,$5000,$2F00,$4878,$0200; $01DA10
    dc.w    $4878,$0002,$4878,$0005,$4E93,$4FEF,$0018,$4CDF; $01DA20
    dc.w    $1C3C,$4E75,$4E56,$FFF0,$48E7,$3F38,$242E,$0010; $01DA30
    dc.w    $262E,$0014,$2A2E,$0008,$2C2E,$000C,$2E2E,$0018; $01DA40
    dc.w    $266E,$001C,$49EE,$FFFC,$43EE,$FFFE,$3007,$720C; $01DA50
    dc.w    $E368,$3D40,$FFF2,$3007,$E148,$3D40,$FFF4,$3007; $01DA60
    dc.w    $E948,$3D40,$FFF6,$3D47,$FFF8,$0C45,$0020,$6614; $01DA70
    dc.w    $0C46,$0022,$660E,$0C42,$00DC,$6608,$0C43,$0066; $01DA80
    dc.w    $6602,$5346,$3002,$9045,$3280,$BC43,$6F06,$3006; $01DA90
    dc.w    $9043,$6004,$3003,$9046,$3880,$BA42,$6C04,$BC43; $01DAA0
    dc.w    $6D08,$BA42,$6F08,$BC43,$6F04,$7001,$6002,$70FF; $01DAB0
    dc.w    $3D40,$FFFA,$3011,$B054,$6F00,$00AC,$BA42,$6F04; $01DAC0
    dc.w    $3A02,$3C03,$3011,$48C0,$6C02,$5280,$E280,$3800; $01DAD0
    dc.w    $3605,$3E05,$DE51,$6000,$0084,$4A43,$6C08,$3403; $01DAE0
    dc.w    $0642,$0100,$6010,$0C43,$0100,$6D08,$3403,$0642; $01DAF0
    dc.w    $FF00,$6002,$3403,$3002,$48C0,$E680,$EB88,$41F3; $01DB00
    dc.w    $0800,$3202,$48C1,$E481,$0281,$0000,$0001,$D281; $01DB10
    dc.w    $D1C1,$3006,$48C0,$E680,$720A,$E3A8,$D1C0,$3006; $01DB20
    dc.w    $0280,$0000,$0007,$E588,$D1C0,$2448,$3002,$0240; $01DB30
    dc.w    $0003,$D040,$207C,$0005,$F9B6,$3030,$0000,$C152; $01DB40
    dc.w    $3002,$0240,$0003,$D040,$3036,$00F2,$8152,$9854; $01DB50
    dc.w    $4A44,$6C06,$D851,$DC6E,$FFFA,$5243,$B647,$6F00; $01DB60
    dc.w    $FF7A,$6000,$00A8,$BC43,$6F04,$3C03,$3A02,$3014; $01DB70
    dc.w    $48C0,$6C02,$5280,$E280,$3800,$3606,$3E06,$DE54; $01DB80
    dc.w    $6000,$0084,$4A45,$6C08,$3405,$0642,$0100,$6010; $01DB90
    dc.w    $0C45,$0100,$6D08,$3405,$0642,$FF00,$6002,$3405; $01DBA0
    dc.w    $3002,$48C0,$E680,$EB88,$41F3,$0800,$3202,$48C1; $01DBB0
    dc.w    $E481,$0281,$0000,$0001,$D281,$D1C1,$3003,$48C0; $01DBC0
    dc.w    $E680,$720A,$E3A8,$D1C0,$3003,$0280,$0000,$0007; $01DBD0
    dc.w    $E588,$D1C0,$2448,$3002,$0240,$0003,$D040,$207C; $01DBE0
    dc.w    $0005,$F9B6,$3030,$0000,$C152,$3002,$0240,$0003; $01DBF0
    dc.w    $D040,$3036,$00F2,$8152,$9851,$4A44,$6C06,$D854; $01DC00
    dc.w    $DA6E,$FFFA,$5243,$B647,$6F00,$FF7A,$4CEE,$1CFC; $01DC10
    dc.w    $FFCC,$4E5E,$4E75                                ; $01DC20
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
    dc.w    $4878,$0020,$4878,$0020,$42A7,$42A7,$302E,$000A; $01DE30
    dc.w    $48C0,$2F00,$4878,$001A,$4EB9,$0000,$0D64,$4E5E; $01DE40
    dc.w    $4E75,$206F,$0004,$30BC,$0080,$302F,$000A,$0640; $01DE50
    dc.w    $FFFF,$0240,$0003,$720A,$E368,$322F,$000E,$0641; $01DE60
    dc.w    $FFFF,$0241,$0003,$E149,$8081,$3140,$0002,$302F; $01DE70
    dc.w    $0016,$0040,$8000,$3140,$0004,$317C,$0080,$0006; $01DE80
    dc.w    $4E75                                              ; $01DE90
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
    dc.w    $6100,$f8fc                                 ; bsr.w $01D7BE
    pea     ($0004959E).l
    move.l  a2,-(sp)
    jsr     (a3)
    move.l  a2,-(sp)
    pea     ($0014).w
    pea     ($0760).w
    dc.w    $6100,$f9d0                                 ; bsr.w $01D8AA
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
    dc.w    $48E7,$303C,$242F,$001C,$266F,$0020,$2A7C,$0004; $01DF30
    dc.w    $8E00,$4A42,$6F62,$0C42,$0063,$6C06,$3002,$48C0; $01DF40
    dc.w    $6002,$7063,$3400,$48C0,$720A,$4EB9,$0003,$E08A; $01DF50
    dc.w    $3600,$3002,$48C0,$720A,$4EB9,$0003,$E146,$3400; $01DF60
    dc.w    $4A43,$6F10,$3003,$48C0,$EB88,$41F5,$0800,$5488; $01DF70
    dc.w    $2448,$6006,$244D,$45EA,$0140,$3002,$48C0,$EB88; $01DF80
    dc.w    $41F5,$0800,$2848,$4242,$201A,$809C,$26C0,$5242; $01DF90
    dc.w    $0C42,$0008,$6DF2,$6010,$4878,$0020,$42A7,$2F0B; $01DFA0
    dc.w    $6100,$F56E,$4FEF,$000C,$4CDF,$3C0C,$4E75     ; $01DFB0
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
    dc.w    $6100,$ff52                                 ; bsr.w $01DF30
    pea     -$0020(a6)
    pea     ($0001).w
    move.w  d3,d0
    move.l  d0,-(sp)
    dc.w    $6100,$f8bc                                 ; bsr.w $01D8AA
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
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
    dc.w    $2F0A,$246F,$0008,$226F,$000C,$204A; $01E1A0
    dc.w    $14D9,$66FC,$2008,$245F,$4E75                    ; $01E1B0
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
    dc.w    $226F,$0004,$2049,$6002                          ; $01E1D8
    dc.w    $5289,$4A11,$66FA,$3009,$9048,$4E75              ; $01E1E0 (end strlen fn)
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
    dc.w    $4EB9,$0000,$0D64                                    ; jsr GameCommand
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
    dc.w    $2F02,$4A79,$00FF,$0A34,$6612,$603C                ; $01E234 (next fn)
    dc.w    $4878,$0001,$4878,$000E,$4EB9,$0000,$0D64,$508F; $01E240
    dc.w    $42A7,$6100,$FF98,$588F,$4A40,$66E4,$6010,$4878; $01E250
    dc.w    $0001,$4878,$000E,$4EB9,$0000,$0D64,$508F,$42A7; $01E260
    dc.w    $6100,$FF7A,$588F,$3400,$67E4,$600E,$4878,$003C; $01E270
    dc.w    $4EBA,$0072,$4E71,$588F,$3400,$3002,$241F,$4E75; $01E280
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
    dc.w    $6100,$FF38                                               ; bsr.w ReadInput [$1E1EC]
    ADDQ.L  #4,SP
    CMP.W   D3,D0                                                     ; compare with target
    BNE.S   .pil_after                                                ; if match, continue; else exit
    PEA     ($0001).W
    PEA     ($000E).W                                                 ; command 14
    dc.w    $4EB9,$0000,$0D64                                         ; jsr GameCommand
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
    dc.w    $6100,$FF02                                               ; bsr.w ReadInput [$1E1EC]
    ADDQ.L  #4,SP
    MOVEM.L (SP)+,D2-D3
    RTS
; === PollInputChange ($01E2F4, 82B) ===
PollInputChange:                                                      ; $01E2F4
    MOVEM.L D2-D4,-(SP)
    MOVE.L  $10(SP),D3                                                ; arg (loop count)
    CLR.L   -(SP)
    dc.w    $6100,$FEEC                                               ; bsr.w ReadInput [$1E1EC]
    ADDQ.L  #4,SP
    MOVE.W  D0,D4                                                     ; D4 = initial input
    BRA.S   .pic_check
.pic_loop:                                                            ; $01E308
    CLR.L   -(SP)
    dc.w    $6100,$FEE0                                               ; bsr.w ReadInput [$1E1EC]
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
    dc.w    $4EB9,$0000,$0D64                                         ; jsr GameCommand
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
    dc.w    $6100,$fdbe                                 ; bsr.w $01E1BA
    addq.l  #$8,sp
    rts
    dc.w    $2F02,$4EBA,$00E6,$4E71,$4242,$7000,$3002        ; $01E402
    dc.w    $2F00,$4EBA,$057A,$4E71,$588F,$5242,$0C42,$0007; $01E410
    dc.w    $65EA,$4EBA,$0096,$4E71,$4A40,$6706,$4EB9,$0001; $01E420
    dc.w    $D748,$4878,$0001,$4878,$0012,$4EB9,$0001,$D3AC; $01E430
    dc.w    $4878,$001B,$4878,$0020,$42A7,$42A7,$4EB9,$0003; $01E440
    dc.w    $A942,$4FEF,$0018,$4A79,$00FF,$000A,$6622,$4878; $01E450
    dc.w    $0040,$42A7,$4878,$0010,$4EB9,$0000,$0D64,$42A7; $01E460
    dc.w    $42A7,$4878,$0004,$4EB9,$0000,$68CA,$4FEF,$0018; $01E470
    dc.w    $4EBA,$07BE,$4E71,$4242,$7000,$3002,$2F00,$4EBA; $01E480
    dc.w    $2128,$4E71,$588F,$5242,$0C42,$0004,$65EA,$4EBA; $01E490
    dc.w    $03B4,$4E71,$4EBA,$244C,$4E71,$4EBA,$2572,$4E71; $01E4A0
    dc.w    $4EB9,$0001,$D71C,$241F,$4E75,$48E7,$3000,$4243; $01E4B0
    dc.w    $207C,$00FF,$0018,$4242,$7000,$1028,$0004,$7200; $01E4C0
    dc.w    $1228,$0005,$D041,$D640,$7024,$D1C0,$5242,$0C42; $01E4D0
    dc.w    $0004,$65E4,$3003,$4CDF,$000C,$4E75,$48E7,$383C; $01E4E0
    dc.w    $2A7C,$0000,$D648,$4878,$0500,$42A7,$4879,$00FF; $01E4F0
    dc.w    $B4E4,$4EB9,$0001,$D520,$4FEF,$000C,$287C,$00FF; $01E500
    dc.w    $0018,$4243,$3003,$C0FC,$0320,$207C,$00FF,$9A20; $01E510
    dc.w    $41F0,$0000,$2648,$3003,$C0FC,$0140,$207C,$00FF; $01E520
    dc.w    $B4E4,$41F0,$0000,$2448,$4242,$6030,$7000,$1013; $01E530
    dc.w    $48C0,$2F00,$4E95,$3480,$7000,$102B,$0001,$48C0; $01E540
    dc.w    $2F00,$4E95,$508F,$3540,$0002,$426A,$0004,$357C; $01E550
    dc.w    $0064,$0006,$7014,$D7C0,$508A,$5242,$7000,$3002; $01E560
    dc.w    $7200,$122C,$0004,$B081,$6DC2,$7800,$182C,$0004; $01E570
    dc.w    $7000,$102C,$0005,$D840,$7400,$142C,$0004,$6024; $01E580
    dc.w    $7000,$1013,$48C0,$2F00,$4E95,$588F,$3540,$0002; $01E590
    dc.w    $3480,$426A,$0004,$357C,$0064,$0006,$7014,$D7C0; $01E5A0
    dc.w    $508A,$5242,$B444,$65D8,$7024,$D9C0,$5243,$0C43; $01E5B0
    dc.w    $0004,$6500,$FF50,$4EBA,$000A,$4E71,$4CDF,$3C1C; $01E5C0
    dc.w    $4E75,$48E7,$3F3C,$2A7C,$00FF,$0018,$247C,$00FF; $01E5D0
    dc.w    $0338,$4243,$7E00,$1E2D,$0004,$7000,$102D,$0005; $01E5E0
    dc.w    $DE40,$4244,$0C2A,$0006,$0001,$6600,$00CC,$7000; $01E5F0
    dc.w    $1012,$0280,$0000,$FFFF,$2F00,$7000,$3003,$2F00; $01E600
    dc.w    $4EB9,$0000,$6EEA,$508F,$3400,$0C42,$0020,$6400; $01E610
    dc.w    $00A8,$7000,$302A,$0006,$2F00,$7000,$3002,$2F00; $01E620
    dc.w    $7000,$3003,$2F00,$4EBA,$00B0,$4E71,$4FEF,$000C; $01E630
    dc.w    $3C00,$7000,$102D,$0004,$C0FC,$0014,$3203,$C2FC; $01E640
    dc.w    $0320,$D041,$207C,$00FF,$9A20,$41F0,$0000,$2848; $01E650
    dc.w    $3003,$C0FC,$0140,$7200,$122D,$0004,$E749,$D041; $01E660
    dc.w    $207C,$00FF,$B4E4,$41F0,$0000,$2648,$7400,$142D; $01E670
    dc.w    $0004,$6040,$7000,$1012,$B053,$6630,$7000,$302A; $01E680
    dc.w    $0006,$2F00,$7000,$102C,$0001,$0280,$0000,$FFFF; $01E690
    dc.w    $2F00,$7000,$3003,$2F00,$4EBA,$003E,$4E71,$4FEF; $01E6A0
    dc.w    $000C,$3A00,$3006,$D045,$D16B,$0006,$7014,$D9C0; $01E6B0
    dc.w    $508B,$5242,$B447,$65BC,$508A,$5244,$0C44,$0004; $01E6C0
    dc.w    $6500,$FF22,$7024,$DBC0,$5243,$0C43,$0004,$6500; $01E6D0
    dc.w    $FF04,$4CDF,$3CFC,$4E75,$4E56,$0000,$48E7,$3F3C; $01E6E0
    dc.w    $262E,$0010,$2C2E,$0008,$4BEE,$000E,$0C55,$0020; $01E6F0
    dc.w    $6428,$3015,$C0FC,$0006,$207C,$00FF,$1704,$41F0; $01E700
    dc.w    $0000,$2648,$3015,$C0FC,$0006,$207C,$00FF,$0420; $01E710
    dc.w    $41F0,$0000,$2448,$7E06,$6022,$3015,$E548,$207C; $01E720
    dc.w    $00FF,$15A0,$41F0,$0000,$2648,$3015,$E548,$207C; $01E730
    dc.w    $00FF,$0460,$41F0,$0000,$2448,$7E04,$4A43,$6604; $01E740
    dc.w    $4245,$600C,$0C43,$0001,$6604,$7A03,$6002,$7A02; $01E750
    dc.w    $4243,$4244,$4242,$6038,$7000,$1012,$7200,$3206; $01E760
    dc.w    $B081,$6626,$7000,$1013,$E548,$207C,$0005,$E31A; $01E770
    dc.w    $41F0,$0000,$2848,$7000,$102C,$0003,$B045,$660A; $01E780
    dc.w    $7000,$102C,$0002,$D640,$5244,$528B,$528A,$5242; $01E790
    dc.w    $B447,$65C4,$4A44,$6776,$7000,$3004,$2200,$D080; $01E7A0
    dc.w    $D081,$D080,$726A,$9280,$2001,$7200,$3203,$4EB9; $01E7B0
    dc.w    $0003,$E05C,$7264,$4EB9,$0003,$E08A,$3600,$7000; $01E7C0
    dc.w    $3015,$2F00,$4EB9,$0000,$D648,$3400,$7000,$3002; $01E7D0
    dc.w    $2F00,$7000,$3006,$2F00,$4EB9,$0000,$6EEA,$4FEF; $01E7E0
    dc.w    $000C,$48C0,$7200,$3215,$B081,$6622,$7000,$3015; $01E7F0
    dc.w    $2F00,$7000,$3006,$2F00,$4EB9,$0000,$74F8,$3400; $01E800
    dc.w    $670A,$3003,$48C0,$80C2,$3600,$6002,$4243,$3039; $01E810
    dc.w    $00FF,$0002,$48C0,$7203,$9280,$2001,$E588,$D081; $01E820
    dc.w    $0680,$0000,$000F,$7200,$3203,$4EB9,$0003,$E05C; $01E830
    dc.w    $720A,$4EB9,$0003,$E0C6,$3600,$4CEE,$3CFC,$FFD8; $01E840
    dc.w    $4E5E,$4E75,$48E7,$3C3C,$267C,$00FF,$0120,$2A7C; $01E850
    dc.w    $00FF,$0230,$4245,$3005,$EB48,$207C,$00FF,$01B0; $01E860
    dc.w    $41F0,$0000,$2848,$7400,$142B,$0001,$C4F9,$00FF; $01E870
    dc.w    $999C,$7000,$102B,$0002,$C0F9,$00FF,$BA68,$D440; $01E880
    dc.w    $7000,$102B,$0003,$C0F9,$00FF,$1288,$D440,$7000; $01E890
    dc.w    $3002,$7264,$4EB9,$0003,$E08A,$3400,$1682,$202C; $01E8A0
    dc.w    $001C,$720C,$4EB9,$0003,$E08A,$7200,$3202,$4EB9; $01E8B0
    dc.w    $0003,$E05C,$2800,$E084,$0C84,$0000,$FFFF,$6C1C; $01E8C0
    dc.w    $202C,$001C,$720C,$4EB9,$0003,$E08A,$7200,$3202; $01E8D0
    dc.w    $4EB9,$0003,$E05C,$2800,$E084,$6006,$283C,$0000; $01E8E0
    dc.w    $FFFF,$0C44,$0064,$6306,$7000,$3004,$6002,$7064; $01E8F0
    dc.w    $3A80,$4243,$7000,$3003,$E588,$41F4,$0800,$2448; $01E900
    dc.w    $2012,$720C,$4EB9,$0003,$E08A,$7200,$3202,$4EB9; $01E910
    dc.w    $0003,$E05C,$2800,$E084,$0C84,$0000,$FFFF,$6C1A; $01E920
    dc.w    $2012,$720C,$4EB9,$0003,$E08A,$7200,$3202,$4EB9; $01E930
    dc.w    $0003,$E05C,$2800,$E084,$6006,$283C,$0000,$FFFF; $01E940
    dc.w    $0C44,$0032,$6306,$7000,$3004,$6002,$7032,$7200; $01E950
    dc.w    $3203,$D281,$2041,$3B80,$8802,$588A,$5243,$0C43; $01E960
    dc.w    $0007,$659C,$588B,$7010,$DBC0,$7020,$D9C0,$5245; $01E970
    dc.w    $0C45,$0004,$6500,$FEF0,$4CDF,$3C3C,$4E75         ; $01E980
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
    dc.w    $2F02; $01EC0E
    dc.w    $4241,$302F,$000A,$E748,$207C,$00FF,$BA80,$41F0; $01EC10
    dc.w    $0000,$2248,$4242,$4A29,$0001,$6704,$7201,$600A; $01EC20
    dc.w    $5489,$5242,$0C42,$0004,$65EC,$3001,$241F,$4E75; $01EC30
    dc.w    $4E56,$FFFC,$48E7,$3E3C,$4878,$0080,$42A7,$4879; $01EC40
    dc.w    $00FF,$01B0,$4EB9,$0001,$D520,$4878,$0070,$42A7; $01EC50
    dc.w    $4879,$00FF,$1004,$4EB9,$0001,$D520,$4FEF,$0018; $01EC60
    dc.w    $4243,$2A7C,$00FF,$0018,$4242,$4A2D,$0004,$6704; $01EC70
    dc.w    $7601,$600C,$7024,$DBC0,$5242,$0C42,$0004,$65EA; $01EC80
    dc.w    $7C01,$0C43,$0001,$6600,$0146,$3006,$48C0,$2F00; $01EC90
    dc.w    $4878,$0007,$4EBA,$02B4,$4E71,$508F,$7C01,$2A7C; $01ECA0
    dc.w    $00FF,$0018,$4242,$3002,$C0FC,$001C,$207C,$00FF; $01ECB0
    dc.w    $1004,$41F0,$0000,$2848,$3002,$C0FC,$0320,$207C; $01ECC0
    dc.w    $00FF,$9A20,$41F0,$0000,$2648,$3002,$C0FC,$0140; $01ECD0
    dc.w    $207C,$00FF,$B4E4,$41F0,$0000,$2448,$4243,$6064; $01ECE0
    dc.w    $4A6A,$0004,$6620,$7000,$3003,$2F00,$7000,$3002; $01ECF0
    dc.w    $2F00,$4EBA,$064E,$4E71,$4878,$0007,$4EBA,$042E; $01ED00
    dc.w    $4E71,$4FEF,$000C,$7000,$302B,$0008,$6C04,$727F; $01ED10
    dc.w    $D081,$EE80,$7200,$3212,$E589,$2041,$D1B4,$8800; $01ED20
    dc.w    $7000,$302B,$0008,$6C04,$727F,$D081,$EE80,$7200; $01ED30
    dc.w    $322A,$0002,$E589,$2041,$D1B4,$8800,$7014,$D7C0; $01ED40
    dc.w    $508A,$5243,$7000,$3003,$7200,$122D,$0004,$B081; $01ED50
    dc.w    $6D8E,$4244,$3639,$00FF,$0002,$3003,$48C0,$D080; $01ED60
    dc.w    $5680,$7200,$3204,$E589,$2041,$D1B4,$8800,$5244; $01ED70
    dc.w    $0C44,$0007,$65E4,$7000,$102D,$0001,$48C0,$2F00; $01ED80
    dc.w    $4EB9,$0000,$D648,$588F,$3600,$3039,$00FF,$0002; $01ED90
    dc.w    $48C0,$6C02,$5280,$E280,$5280,$7200,$3203,$E589; $01EDA0
    dc.w    $2041,$D1B4,$8800,$7024,$DBC0,$701C,$D9C0,$5242; $01EDB0
    dc.w    $0C42,$0004,$6500,$FF02,$0C79,$0001,$00FF,$000A; $01EDC0
    dc.w    $660C,$4878,$003C,$4EB9,$0001,$E2F4,$588F,$267C; $01EDD0
    dc.w    $0005,$ECBC,$4244,$4243,$4242,$7000,$3004,$2F00; $01EDE0
    dc.w    $7000,$3002,$2F00,$4EB9,$0000,$6EEA,$508F,$3A00; $01EDF0
    dc.w    $0C45,$0020,$6420,$7000,$3005,$2F00,$7000,$3002; $01EE00
    dc.w    $2F00,$4EB9,$0000,$759E,$508F,$48C0,$72FF,$B280; $01EE10
    dc.w    $6704,$7601,$6008,$5242,$0C42,$0004,$65BC,$0C43; $01EE20
    dc.w    $0001,$6600,$00FA,$3006,$48C0,$2F00,$7000,$3004; $01EE30
    dc.w    $2F00,$4EBA,$0116,$4E71,$508F,$7C01,$7600,$162B; $01EE40
    dc.w    $0002,$6044,$3003,$E748,$207C,$00FF,$BA80,$41F0; $01EE50
    dc.w    $0000,$2448,$4242,$4A2A,$0001,$660A,$548A,$5242; $01EE60
    dc.w    $0C42,$0004,$65F0,$0C42,$0004,$641A,$7000,$3003; $01EE70
    dc.w    $2F00,$4EBA,$0DCC,$4E71,$7000,$3004,$2F00,$4EBA; $01EE80
    dc.w    $02AC,$4E71,$508F,$5243,$7000,$102B,$0002,$7200; $01EE90
    dc.w    $122B,$0003,$D081,$7200,$3203,$B081,$6EA6,$7600; $01EEA0
    dc.w    $1613,$6066,$3003,$E748,$207C,$00FF,$BA80,$41F0; $01EEB0
    dc.w    $0000,$2448,$4242,$4A2A,$0001,$660A,$548A,$5242; $01EEC0
    dc.w    $0C42,$0004,$65F0,$0C42,$0004,$643C,$7000,$3003; $01EED0
    dc.w    $2F00,$4EBA,$0216,$4E71,$0C40,$0001,$660E,$7000; $01EEE0
    dc.w    $3003,$2F00,$4EBA,$0938,$4E71,$600C,$7000,$3003; $01EEF0
    dc.w    $2F00,$4EBA,$0D4C,$4E71,$7000,$3004,$2F00,$4EBA; $01EF00
    dc.w    $022C,$4E71,$4FEF,$000C,$5243,$7000,$1013,$7200; $01EF10
    dc.w    $122B,$0001,$D081,$7200,$3203,$B081,$6E86,$0C79; $01EF20
    dc.w    $0001,$00FF,$000A,$660C,$4878,$003C,$4EB9,$0001; $01EF30
    dc.w    $E2F4,$588F,$588B,$5244,$0C44,$0007,$6500,$FE98; $01EF40
    dc.w    $4CEE,$3C7C,$FFD8,$4E5E,$4E75,$48E7,$3030,$242F; $01EF50
    dc.w    $0018,$262F,$0014,$247C,$0003,$B270,$267C,$0000; $01EF60
    dc.w    $0D64,$0C79,$0001,$00FF,$000A,$6600,$0178,$0C43; $01EF70
    dc.w    $0007,$6442,$4EB9,$0001,$D71C,$42A7,$7000,$3003; $01EF80
    dc.w    $2F00,$4878,$0004,$4EB9,$0000,$6A2E,$4878,$0040; $01EF90
    dc.w    $42A7,$4878,$0010,$4E93,$4FEF,$0018,$4A42,$660E; $01EFA0
    dc.w    $7000,$3003,$2F00,$4EBA,$0184,$4E71,$588F,$4EB9; $01EFB0
    dc.w    $0001,$D748,$6032,$4878,$0040,$42A7,$4878,$0010; $01EFC0
    dc.w    $4E93,$42A7,$4EB9,$0000,$538E,$42A7,$42A7,$4878; $01EFD0
    dc.w    $0004,$4EB9,$0000,$68CA,$4878,$0040,$42A7,$4878; $01EFE0
    dc.w    $0010,$4E93,$4FEF,$0028,$0C42,$0001,$6600,$00A4; $01EFF0
    dc.w    $4878,$0004,$4878,$0031,$4879,$00FF,$0118,$4EB9; $01F000
    dc.w    $0000,$5092,$4878,$001B,$4878,$0020,$42A7,$42A7; $01F010
    dc.w    $4EB9,$0003,$A942,$4FEF,$001C,$4242,$7000,$3002; $01F020
    dc.w    $0680,$0000,$0774,$2F00,$7000,$3002,$5280,$2F00; $01F030
    dc.w    $4878,$0003,$4878,$0002,$4878,$0007,$7000,$3002; $01F040
    dc.w    $2200,$E588,$D081,$5680,$2F00,$4878,$0001,$4878; $01F050
    dc.w    $0001,$4EB9,$0000,$6760,$7000,$3002,$2200,$E588; $01F060
    dc.w    $D081,$5680,$2F00,$4878,$0001,$4EB9,$0003,$AB2C; $01F070
    dc.w    $3002,$E948,$207C,$00FF,$00A8,$4870,$0000,$4879; $01F080
    dc.w    $0004,$11EE,$4E92,$4FEF,$0030,$5242,$0C42,$0004; $01F090
    dc.w    $658A,$4878,$0006,$4878,$001C,$4878,$0015,$4878; $01F0A0
    dc.w    $0002,$4EB9,$0000,$5A04,$4FEF,$0010,$0C43,$0007; $01F0B0
    dc.w    $641A,$3003,$E548,$207C,$0005,$EC84,$2F30,$0000; $01F0C0
    dc.w    $4879,$0004,$11D6,$4E92,$508F,$600A,$4879,$0004; $01F0D0
    dc.w    $11AA,$4E92,$588F,$7000,$3003,$2F00,$4EBA,$004E; $01F0E0
    dc.w    $4E71,$588F,$4CDF,$0C0C,$4E75,$48E7,$3800,$262F; $01F0F0
    dc.w    $0010,$0C43,$0020,$642A,$4244,$7000,$3003,$7201; $01F100
    dc.w    $E1A9,$2601,$207C,$00FF,$08EC,$4242,$2003,$C090; $01F110
    dc.w    $6704,$7801,$600E,$5888,$5242,$0C42,$0004,$65EC; $01F120
    dc.w    $6002,$4244,$3004,$4CDF,$001C,$4E75,$48E7,$3F38; $01F130
    dc.w    $2C2F,$0028,$287C,$00FF,$0002,$0C79,$0001,$00FF; $01F140
    dc.w    $000A,$6600,$01F8,$4245,$0C46,$0007,$6448,$4243; $01F150
    dc.w    $7000,$3006,$2F00,$7000,$3003,$2F00,$4EB9,$0000; $01F160
    dc.w    $6EEA,$508F,$3400,$0C42,$0020,$6420,$3002,$E748; $01F170
    dc.w    $3203,$D241,$D041,$207C,$00FF,$BA81,$1830,$0000; $01F180
    dc.w    $0284,$0000,$00FF,$B845,$6302,$3A04,$5243,$0C43; $01F190
    dc.w    $0004,$65BC,$604E,$267C,$00FF,$0018,$4243,$4244; $01F1A0
    dc.w    $3003,$C0FC,$0320,$207C,$00FF,$9A20,$41F0,$0000; $01F1B0
    dc.w    $2448,$4242,$600E,$7000,$102A,$0003,$D840,$7014; $01F1C0
    dc.w    $D5C0,$5242,$7000,$3002,$7200,$122B,$0004,$B081; $01F1D0
    dc.w    $6DE4,$B845,$6302,$3A04,$7024,$D7C0,$5243,$0C43; $01F1E0
    dc.w    $0004,$65BA,$4A54,$6608,$243C,$0000,$00C0,$6022; $01F1F0
    dc.w    $0C54,$0001,$6608,$243C,$0000,$0190,$6014,$0C54; $01F200
    dc.w    $0002,$6608,$243C,$0000,$01A0,$6006,$243C,$0000; $01F210
    dc.w    $0320,$7000,$3005,$2200,$D080,$D081,$E588,$2202; $01F220
    dc.w    $4EB9,$0003,$E05C,$2800,$7001,$B084,$6404,$2004; $01F230
    dc.w    $6002,$7001,$2800,$4878,$001B,$4878,$0020,$42A7; $01F240
    dc.w    $42A7,$4EB9,$0003,$A942,$4FEF,$0010,$4243,$3003; $01F250
    dc.w    $EB48,$3206,$E549,$D041,$207C,$00FF,$01B0,$41F0; $01F260
    dc.w    $0000,$2448,$7A00,$3A03,$2005,$E58D,$DA80,$5A85; $01F270
    dc.w    $7E00,$3E03,$2007,$E58F,$DE80,$E78F,$0687,$0000; $01F280
    dc.w    $0018,$2012,$2200,$E588,$D081,$E588,$E788,$2204; $01F290
    dc.w    $4EB9,$0003,$E0C6,$3400,$0C42,$00A0,$6406,$7000; $01F2A0
    dc.w    $3002,$6006,$203C,$0000,$00A0,$0640,$0040,$3400; $01F2B0
    dc.w    $3C07,$2F3C,$0000,$8000,$4878,$0002,$4878,$0002; $01F2C0
    dc.w    $7000,$3006,$2F00,$7000,$3002,$2F00,$7000,$3003; $01F2D0
    dc.w    $0680,$0000,$003B,$2F00,$4878,$0750,$4EB9,$0001; $01F2E0
    dc.w    $E044,$4878,$0002,$4878,$000E,$4EB9,$0000,$0D64; $01F2F0
    dc.w    $2F05,$4878,$0013,$4EB9,$0003,$AB2C,$4FEF,$002C; $01F300
    dc.w    $2F12,$4879,$0004,$11F2,$4EB9,$0003,$B246,$3005; $01F310
    dc.w    $2F00,$4878,$001D,$4878,$0001,$4878,$0001,$4EB9; $01F320
    dc.w    $0000,$595E,$4FEF,$0018,$7028,$DE80,$5A85,$7020; $01F330
    dc.w    $D5C0,$5243,$0C43,$0004,$6500,$FF48,$4CDF,$1CFC; $01F340
    dc.w    $4E75,$4E56,$FFDC,$48E7,$3F3C,$262E,$0008,$2E2E; $01F350
    dc.w    $000C,$287C,$00FF,$0002,$4BEE,$FFEC,$3C3C,$3A98; $01F360
    dc.w    $3003,$C0FC,$0140,$3207,$E749,$D041,$207C,$00FF; $01F370
    dc.w    $B4E4,$41F0,$0000,$2448,$3D52,$FFFC,$3D6A,$0002; $01F380
    dc.w    $FFFA,$302E,$FFFC,$E548,$207C,$00FF,$BDE4,$41F0; $01F390
    dc.w    $0000,$2448,$302E,$FFFA,$E548,$207C,$00FF,$BDE4; $01F3A0
    dc.w    $41F0,$0000,$2648,$3039,$00FF,$BD4C,$48C0,$7264; $01F3B0
    dc.w    $9280,$2001,$7200,$122B,$0003,$48C1,$4EB9,$0003; $01F3C0
    dc.w    $E05C,$2F00,$7000,$102B,$0002,$48C0,$3239,$00FF; $01F3D0
    dc.w    $BD4C,$48C1,$4EB9,$0003,$E05C,$D09F,$7264,$4EB9; $01F3E0
    dc.w    $0003,$E08A,$3D40,$FFF4,$7000,$102A,$0003,$0280; $01F3F0
    dc.w    $0000,$FFFF,$725A,$4EB9,$0003,$E05C,$7264,$4EB9; $01F400
    dc.w    $0003,$E08A,$0640,$000A,$3800,$7000,$3012,$7200; $01F410
    dc.w    $322E,$FFF4,$4EB9,$0003,$E05C,$7200,$3204,$4EB9; $01F420
    dc.w    $0003,$E05C,$2D40,$FFF6,$3039,$00FF,$BD4C,$48C0; $01F430
    dc.w    $7264,$9280,$2001,$7200,$122A,$0003,$48C1,$4EB9; $01F440
    dc.w    $0003,$E05C,$2F00,$7000,$102A,$0002,$48C0,$3239; $01F450
    dc.w    $00FF,$BD4C,$48C1,$4EB9,$0003,$E05C,$D09F,$7264; $01F460
    dc.w    $4EB9,$0003,$E08A,$3400,$7000,$102B,$0003,$0280; $01F470
    dc.w    $0000,$FFFF,$725A,$4EB9,$0003,$E05C,$7264,$4EB9; $01F480
    dc.w    $0003,$E08A,$0640,$000A,$3800,$7000,$3013,$7200; $01F490
    dc.w    $3202,$4EB9,$0003,$E05C,$7200,$3204,$4EB9,$0003; $01F4A0
    dc.w    $E05C,$2400,$202E,$FFF6,$D082,$7200,$3206,$4EB9; $01F4B0
    dc.w    $0003,$E0C6,$3D40,$FFFE,$4242,$6010,$7000,$3002; $01F4C0
    dc.w    $D080,$2040,$3BBC,$00FF,$8800,$5242,$B443,$65EC; $01F4D0
    dc.w    $7000,$3003,$D080,$2040,$3B87,$8800,$3403,$602C; $01F4E0
    dc.w    $7000,$302E,$FFFA,$2F00,$7000,$302E,$FFFC,$2F00; $01F4F0
    dc.w    $7000,$3002,$2F00,$4EBA,$02B8,$4E71,$4FEF,$000C; $01F500
    dc.w    $7200,$3202,$D281,$2041,$3B80,$8800,$5242,$0C42; $01F510
    dc.w    $0004,$65CC,$4247,$7C00,$3403,$3002,$E548,$41F6; $01F520
    dc.w    $00DC,$2448,$6000,$00A8,$7000,$3002,$D080,$2040; $01F530
    dc.w    $3835,$8800,$0C44,$0028,$6400,$0090,$3002,$C0FC; $01F540
    dc.w    $0320,$3204,$C2FC,$0014,$D041,$207C,$00FF,$9A2A; $01F550
    dc.w    $1030,$0000,$0280,$0000,$0002,$666E,$3002,$E948; $01F560
    dc.w    $207C,$00FF,$0230,$41F0,$0000,$2648,$7000,$302E; $01F570
    dc.w    $FFFC,$D080,$2040,$3033,$8802,$0280,$0000,$FFFF; $01F580
    dc.w    $7200,$322E,$FFFA,$D281,$2041,$3233,$8802,$0281; $01F590
    dc.w    $0000,$FFFF,$D081,$3202,$C2FC,$0140,$2047,$3E04; $01F5A0
    dc.w    $E74F,$CF88,$D248,$207C,$00FF,$B4EA,$3230,$1000; $01F5B0
    dc.w    $0281,$0000,$FFFF,$4EB9,$0003,$E05C,$7264,$4EB9; $01F5C0
    dc.w    $0003,$E0C6,$2480,$DC92,$5247,$588A,$5242,$0C42; $01F5D0
    dc.w    $0004,$6500,$FF54,$3403,$6000,$01C4,$7000,$3002; $01F5E0
    dc.w    $D080,$2040,$3835,$8800,$0C44,$0028,$6400,$01AE; $01F5F0
    dc.w    $3002,$C0FC,$0320,$3204,$C2FC,$0014,$D041,$207C; $01F600
    dc.w    $00FF,$9A20,$41F0,$0000,$2448,$102A,$000A,$0280; $01F610
    dc.w    $0000,$0002,$6600,$0100,$3002,$E948,$207C,$00FF; $01F620
    dc.w    $0230,$41F0,$0000,$2648,$4A86,$671E,$3002,$E548; $01F630
    dc.w    $2036,$00DC,$7200,$322E,$FFFE,$4EB9,$0003,$E05C; $01F640
    dc.w    $2206,$4EB9,$0003,$E0C6,$6010,$7000,$302E,$FFFE; $01F650
    dc.w    $7200,$3207,$4EB9,$0003,$E08A,$3600,$7000,$302E; $01F660
    dc.w    $FFFA,$D080,$2040,$3033,$8802,$0280,$0000,$FFFF; $01F670
    dc.w    $3214,$48C1,$5481,$4EB9,$0003,$E08A,$2F00,$7000; $01F680
    dc.w    $302E,$FFFC,$D080,$2040,$3033,$8802,$0280,$0000; $01F690
    dc.w    $FFFF,$3214,$48C1,$5481,$4EB9,$0003,$E08A,$D09F; $01F6A0
    dc.w    $2A00,$4A85,$6C02,$5285,$E285,$0C85,$0000,$36B0; $01F6B0
    dc.w    $6C04,$2005,$6006,$203C,$0000,$36B0,$D640,$7000; $01F6C0
    dc.w    $102A,$0001,$48C0,$2F00,$7000,$1012,$48C0,$2F00; $01F6D0
    dc.w    $4EB9,$0000,$7610,$508F,$3A00,$0C45,$0003,$660E; $01F6E0
    dc.w    $7000,$3003,$6C02,$5680,$E480,$3600,$602A,$0C45; $01F6F0
    dc.w    $0002,$660C,$7000,$3003,$6C02,$5280,$E280,$60EA; $01F700
    dc.w    $0C45,$0001,$6612,$7000,$3003,$7205,$4EB9,$0003; $01F710
    dc.w    $E08A,$9640,$6002,$4243,$3002,$C0FC,$0140,$3204; $01F720
    dc.w    $E749,$D041,$207C,$00FF,$B4EA,$3030,$0000,$0280; $01F730
    dc.w    $0000,$FFFF,$7200,$3203,$4EB9,$0003,$E05C,$7264; $01F740
    dc.w    $4EB9,$0003,$E0C6,$3600,$4A54,$660E,$7000,$3003; $01F750
    dc.w    $6C02,$5280,$E280,$D640,$6026,$0C54,$0001,$660C; $01F760
    dc.w    $7000,$3003,$6C02,$5680,$E480,$60EA,$0C54,$0003; $01F770
    dc.w    $660E,$7000,$3003,$7203,$4EB9,$0003,$E08A,$9640; $01F780
    dc.w    $7000,$3003,$2F00,$7000,$3004,$2F00,$7000,$3002; $01F790
    dc.w    $2F00,$4EBA,$07FA,$4E71,$4FEF,$000C,$5242,$0C42; $01F7A0
    dc.w    $0004,$6500,$FE38,$4CEE,$3CFC,$FFB4,$4E5E,$4E75; $01F7B0
    dc.w    $48E7,$3C20,$262F,$0020,$282F,$001C,$2A2F,$0018; $01F7C0
    dc.w    $3005,$C0FC,$0024,$207C,$00FF,$0018,$41F0,$0000; $01F7D0
    dc.w    $2248,$3005,$C0FC,$0140,$207C,$00FF,$B4E4,$41F0; $01F7E0
    dc.w    $0000,$2448,$3A3C,$00FF,$4242,$601C,$B852,$660A; $01F7F0
    dc.w    $B66A,$0002,$660E,$3A02,$601C,$B652,$6606,$B86A; $01F800
    dc.w    $0002,$60F0,$508A,$5242,$7000,$3002,$7200,$1229; $01F810
    dc.w    $0004,$B081,$6DD6,$3005,$4CDF,$043C,$4E75,$4E56; $01F820
    dc.w    $FFDC,$48E7,$3F3C,$7000,$302E,$000A,$2F00,$4EB9; $01F830
    dc.w    $0000,$D648,$588F,$3A00,$E548,$207C,$0005,$ECBC; $01F840
    dc.w    $41F0,$0000,$2D48,$FFFC,$2A7C,$00FF,$0120,$3A2E; $01F850
    dc.w    $000A,$6000,$02EE,$7000,$3005,$2F00,$6100,$F88C; $01F860
    dc.w    $588F,$4A40,$6700,$02DC,$4242,$7000,$3005,$2F00; $01F870
    dc.w    $7000,$302E,$000A,$2F00,$7000,$3002,$2F00,$4EBA; $01F880
    dc.w    $02F4,$4E71,$4FEF,$000C,$3202,$D241,$3D80,$10F4; $01F890
    dc.w    $3002,$D040,$3636,$00F4,$0C43,$0028,$6446,$3002; $01F8A0
    dc.w    $C0FC,$0320,$3203,$C2FC,$0014,$D041,$207C,$00FF; $01F8B0
    dc.w    $9A2A,$1030,$0000,$0280,$0000,$0002,$6626,$3002; $01F8C0
    dc.w    $C0FC,$0140,$3203,$E749,$D041,$207C,$00FF,$B4E8; $01F8D0
    dc.w    $4A70,$0000,$6604,$5247,$600A,$3002,$D040,$3DBC; $01F8E0
    dc.w    $00FF,$00F4,$5242,$0C42,$0004,$6500,$FF7E,$0C47; $01F8F0
    dc.w    $0001,$6300,$0168,$7C00,$4242,$3002,$C0FC,$001C; $01F900
    dc.w    $207C,$00FF,$1004,$41F0,$0000,$2648,$3002,$C0FC; $01F910
    dc.w    $0140,$207C,$00FF,$B4E4,$41F0,$0000,$2448,$3002; $01F920
    dc.w    $D040,$3636,$00F4,$0C43,$0028,$6400,$011C,$3002; $01F930
    dc.w    $C0FC,$0320,$3203,$C2FC,$0014,$D041,$207C,$00FF; $01F940
    dc.w    $9A20,$41F0,$0000,$2848,$7000,$3003,$E788,$41F2; $01F950
    dc.w    $0800,$2D48,$FFF0,$102C,$000A,$0280,$0000,$0002; $01F960
    dc.w    $6600,$00E6,$7000,$302C,$0004,$7264,$4EB9,$0003; $01F970
    dc.w    $E08A,$7201,$B280,$6C12,$7000,$302C,$0004,$7264; $01F980
    dc.w    $4EB9,$0003,$E08A,$2F00,$6006,$2F3C,$0000,$0001; $01F990
    dc.w    $206E,$FFF0,$3010,$0280,$0000,$FFFF,$E588,$2040; $01F9A0
    dc.w    $2033,$8800,$206E,$FFF0,$3228,$0002,$0281,$0000; $01F9B0
    dc.w    $FFFF,$E589,$2041,$D0B3,$8800,$7200,$3203,$E789; $01F9C0
    dc.w    $2041,$3232,$8806,$0281,$0000,$FFFF,$4EB9,$0003; $01F9D0
    dc.w    $E05C,$221F,$4EB9,$0003,$E0C6,$7264,$4EB9,$0003; $01F9E0
    dc.w    $E0C6,$3202,$E549,$2D80,$10E0,$7200,$1215,$3002; $01F9F0
    dc.w    $E548,$41F6,$00E0,$2240,$2010,$4EB9,$0003,$E05C; $01FA00
    dc.w    $2080,$C189,$3002,$E548,$41F6,$00E0,$2240,$2010; $01FA10
    dc.w    $720A,$4EB9,$0003,$E0C6,$2080,$C189,$3002,$E548; $01FA20
    dc.w    $2036,$00E0,$7201,$B280,$640A,$3002,$E548,$2036; $01FA30
    dc.w    $00E0,$6002,$7001,$3202,$E549,$2D80,$10E0,$3002; $01FA40
    dc.w    $E548,$2036,$00E0,$DC80,$588D,$45EA,$0140,$701C; $01FA50
    dc.w    $D7C0,$5242,$0C42,$0004,$6500,$FEC4,$7000,$3005; $01FA60
    dc.w    $2F00,$7000,$302E,$000A,$2F00,$4EB9,$0000,$865E; $01FA70
    dc.w    $508F,$3D40,$FFDE,$4242,$3002,$D040,$3636,$00F4; $01FA80
    dc.w    $0C43,$0028,$6400,$00B2,$3002,$C0FC,$0320,$3203; $01FA90
    dc.w    $C2FC,$0014,$D041,$207C,$00FF,$9A2A,$1030,$0000; $01FAA0
    dc.w    $0280,$0000,$0002,$662C,$0C47,$0001,$6320,$3002; $01FAB0
    dc.w    $E548,$2036,$00E0,$7200,$322E,$FFDE,$4EB9,$0003; $01FAC0
    dc.w    $E05C,$2206,$4EB9,$0003,$E0C6,$3800,$6008,$382E; $01FAD0
    dc.w    $FFDE,$6002,$4244,$3002,$C0FC,$0140,$3203,$E749; $01FAE0
    dc.w    $D041,$207C,$00FF,$B4EA,$3030,$0000,$0280,$0000; $01FAF0
    dc.w    $FFFF,$7200,$3204,$4EB9,$0003,$E05C,$7264,$4EB9; $01FB00
    dc.w    $0003,$E0C6,$3800,$7000,$3003,$2F00,$7000,$3002; $01FB10
    dc.w    $2F00,$4EBA,$09F8,$4E71,$C0C4,$3800,$7000,$3004; $01FB20
    dc.w    $2F00,$7000,$3003,$2F00,$7000,$3002,$2F00,$4EBA; $01FB30
    dc.w    $045E,$4E71,$4FEF,$0014,$5242,$0C42,$0004,$6500; $01FB40
    dc.w    $FF38,$5245,$206E,$FFFC,$1028,$0001,$0280,$0000; $01FB50
    dc.w    $00FF,$206E,$FFFC,$1210,$0281,$0000,$00FF,$D081; $01FB60
    dc.w    $7200,$3205,$B081,$6E00,$FCEE,$4CEE,$3CFC,$FFB4; $01FB70
    dc.w    $4E5E,$4E75,$48E7,$3E30,$242F,$0020,$262F,$0028; $01FB80
    dc.w    $282F,$0024,$3C3C,$00FF,$3002,$C0FC,$0024,$207C; $01FB90
    dc.w    $00FF,$0018,$41F0,$0000,$2648,$7A00,$1A2B,$0004; $01FBA0
    dc.w    $7000,$102B,$0005,$DA40,$3004,$E748,$3202,$D241; $01FBB0
    dc.w    $D041,$207C,$00FF,$BA80,$41F0,$0000,$2448,$3003; $01FBC0
    dc.w    $E748,$3202,$D241,$D041,$207C,$00FF,$BA80,$41F0; $01FBD0
    dc.w    $0000,$2248,$4A2A,$0001,$675E,$4A29,$0001,$6758; $01FBE0
    dc.w    $7000,$102B,$0004,$C0FC,$0014,$3202,$C2FC,$0320; $01FBF0
    dc.w    $D041,$207C,$00FF,$9A20,$41F0,$0000,$2448,$7400; $01FC00
    dc.w    $142B,$0004,$602E,$7000,$1012,$B044,$660E,$7000; $01FC10
    dc.w    $102A,$0001,$B043,$6616,$3C02,$601C,$7000,$1012; $01FC20
    dc.w    $B043,$660A,$7000,$102A,$0001,$B044,$60E8,$7014; $01FC30
    dc.w    $D5C0,$5242,$B445,$65CE,$3006,$4CDF,$0C7C,$4E75; $01FC40
    dc.w    $4E56,$FFE0,$48E7,$3E3C,$282E,$0008,$4245,$4242; $01FC50
    dc.w    $3002,$D040,$41F6,$00F8,$2448,$7000,$3004,$2F00; $01FC60
    dc.w    $7000,$3002,$2F00,$4EBA,$0294,$4E71,$508F,$3480; $01FC70
    dc.w    $3612,$0C43,$0028,$6440,$3002,$C0FC,$0320,$3203; $01FC80
    dc.w    $C2FC,$0014,$D041,$207C,$00FF,$9A2A,$1030,$0000; $01FC90
    dc.w    $0280,$0000,$0002,$6620,$3002,$C0FC,$0140,$3203; $01FCA0
    dc.w    $E749,$D041,$207C,$00FF,$B4E8,$4A70,$0000,$6604; $01FCB0
    dc.w    $5245,$6004,$34BC,$00FF,$548A,$5242,$0C42,$0004; $01FCC0
    dc.w    $6598,$0C45,$0001,$6300,$0148,$7C00,$2D7C,$00FF; $01FCD0
    dc.w    $0120,$FFE0,$4242,$3002,$E548,$41F6,$00E8,$2648; $01FCE0
    dc.w    $3002,$C0FC,$001C,$207C,$00FF,$1004,$41F0,$0000; $01FCF0
    dc.w    $2A48,$3002,$C0FC,$0140,$207C,$00FF,$B4E4,$41F0; $01FD00
    dc.w    $0000,$2848,$3002,$D040,$3636,$00F8,$0C43,$0028; $01FD10
    dc.w    $6400,$00E6,$3002,$C0FC,$0320,$3203,$C2FC,$0014; $01FD20
    dc.w    $D041,$207C,$00FF,$9A20,$41F0,$0000,$2448,$7000; $01FD30
    dc.w    $3003,$E788,$2600,$41F4,$0800,$2D48,$FFE4,$102A; $01FD40
    dc.w    $000A,$0280,$0000,$0002,$6600,$00AE,$7000,$302A; $01FD50
    dc.w    $0004,$7264,$4EB9,$0003,$E08A,$7201,$B280,$6C12; $01FD60
    dc.w    $7000,$302A,$0004,$7264,$4EB9,$0003,$E08A,$2F00; $01FD70
    dc.w    $6006,$2F3C,$0000,$0001,$206E,$FFE4,$3010,$0280; $01FD80
    dc.w    $0000,$FFFF,$E588,$2040,$2035,$8800,$206E,$FFE4; $01FD90
    dc.w    $3228,$0002,$0281,$0000,$FFFF,$E589,$2041,$D0B5; $01FDA0
    dc.w    $8800,$204C,$D1C3,$3228,$0006,$0281,$0000,$FFFF; $01FDB0
    dc.w    $4EB9,$0003,$E05C,$221F,$4EB9,$0003,$E0C6,$7264; $01FDC0
    dc.w    $4EB9,$0003,$E0C6,$2680,$206E,$FFE0,$1210,$0281; $01FDD0
    dc.w    $0000,$00FF,$2013,$4EB9,$0003,$E05C,$2680,$720A; $01FDE0
    dc.w    $4EB9,$0003,$E0C6,$2680,$7001,$B093,$6404,$2013; $01FDF0
    dc.w    $6002,$7001,$2680,$DC93,$58AE,$FFE0,$49EC,$0140; $01FE00
    dc.w    $701C,$DBC0,$588B,$5242,$0C42,$0004,$6500,$FEF6; $01FE10
    dc.w    $4242,$3002,$D040,$3636,$00F8,$0C43,$0028,$6400; $01FE20
    dc.w    $00C8,$3002,$C0FC,$0320,$3203,$C2FC,$0014,$D041; $01FE30
    dc.w    $207C,$00FF,$9A20,$41F0,$0000,$2448,$102A,$000A; $01FE40
    dc.w    $0280,$0000,$0002,$663C,$7000,$102A,$0001,$2F00; $01FE50
    dc.w    $7000,$1012,$2F00,$4EB9,$0000,$865E,$508F,$3800; $01FE60
    dc.w    $0C45,$0001,$6320,$3002,$E548,$2036,$00E8,$7200; $01FE70
    dc.w    $3204,$4EB9,$0003,$E05C,$2206,$4EB9,$0003,$E0C6; $01FE80
    dc.w    $3800,$6002,$4244,$3002,$C0FC,$0140,$3203,$E749; $01FE90
    dc.w    $D041,$207C,$00FF,$B4EA,$3030,$0000,$0280,$0000; $01FEA0
    dc.w    $FFFF,$7200,$3204,$4EB9,$0003,$E05C,$7264,$4EB9; $01FEB0
    dc.w    $0003,$E0C6,$3800,$7000,$3003,$2F00,$7000,$3002; $01FEC0
    dc.w    $2F00,$4EBA,$0648,$4E71,$C0C4,$3800,$7000,$3004; $01FED0
    dc.w    $2F00,$7000,$3003,$2F00,$7000,$3002,$2F00,$4EBA; $01FEE0
    dc.w    $00AE,$4E71,$4FEF,$0014,$5242,$0C42,$0004,$6500; $01FEF0
    dc.w    $FF22,$4CEE,$3C7C,$FFBC,$4E5E,$4E75,$48E7,$3C20; $01FF00
    dc.w    $242F,$0018,$262F,$001C,$3A3C,$00FF,$3002,$C0FC; $01FF10
    dc.w    $0024,$207C,$00FF,$0018,$41F0,$0000,$2248,$7800; $01FF20
    dc.w    $1829,$0004,$7000,$1029,$0005,$D840,$3003,$E748; $01FF30
    dc.w    $3202,$D241,$D041,$207C,$00FF,$BA80,$41F0,$0000; $01FF40
    dc.w    $2448,$4A2A,$0001,$673E,$7000,$1029,$0004,$C0FC; $01FF50
    dc.w    $0014,$3202,$C2FC,$0320,$D041,$207C,$00FF,$9A20; $01FF60
    dc.w    $41F0,$0000,$2448,$7400,$1429,$0004,$6014,$7000; $01FF70
    dc.w    $102A,$0001,$B043,$6604,$3A02,$600A,$7014,$D5C0; $01FF80
    dc.w    $5242,$B444,$65E8,$3005,$4CDF,$043C,$4E75,$4E56; $01FF90
    dc.w    $FFFC,$48E7,$3F3C,$262E,$0010,$2C2E,$0008,$2E2E; $01FFA0
    dc.w    $000C,$3006,$C0FC,$0024,$207C,$00FF,$0018,$41F0; $01FFB0
    dc.w    $0000,$2D48,$FFFC,$3006,$C0FC,$0320,$3207,$C2FC; $01FFC0
    dc.w    $0014,$D041,$207C,$00FF,$9A20,$41F0,$0000,$2448; $01FFD0
    dc.w    $3006,$C0FC,$0140,$3207,$E749,$D041,$207C,$00FF; $01FFE0
    dc.w    $B4E4,$41F0,$0000,$2A48,$7000,$3007,$2F00,$7000; $01FFF0

