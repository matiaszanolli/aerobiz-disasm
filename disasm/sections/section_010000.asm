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
    moveq   #$ff,d5
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
    moveq   #$ff,d3
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
    moveq   #$ff,d1
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
    moveq   #$ff,d5
    tst.w   $0012(a6)
    bne.b   .l10980
    move.l  #$3b9ac9ff,d3
    bra.b   .l10982
.l10980:                                                ; $010980
    moveq   #$ff,d3
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
    moveq   #$ff,d0
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
    dc.w    $42A7,$4E95,$4CEE,$3C1C,$FFE4,$4E5E,$4E75,$4E56; $0112E0
    dc.w    $FF60,$48E7,$3F3C,$3D7C,$03FF,$FF66,$3D7C,$06A2; $0112F0
    dc.w    $FF64,$7E01,$302E,$000A,$EB48,$207C,$00FF,$0338; $011300
    dc.w    $41F0,$0000,$2448,$47EE,$FFF6,$4243,$4A2A,$0001; $011310
    dc.w    $6712,$7000,$1012,$2F00,$4EB9,$0000,$D648,$588F; $011320
    dc.w    $3680,$6004,$36BC,$FFFF,$508A,$548B,$5243,$0C43; $011330
    dc.w    $0004,$6DD8,$36BC,$FFFF,$302E,$000E,$48C0,$2F00; $011340
    dc.w    $302E,$000A,$48C0,$2F00,$6100,$F9AE,$3D7C,$026A; $011350
    dc.w    $FFEE,$3D7C,$04AE,$FFF0,$3D7C,$0666,$FFF2,$3D7C; $011360
    dc.w    $0AAA,$FFF4,$4878,$0004,$4878,$0031,$486E,$FFEE; $011370
    dc.w    $4EB9,$0000,$5092,$4878,$0040,$42A7,$486E,$FF6C; $011380
    dc.w    $4EB9,$0001,$D520,$4FEF,$0020,$0C6E,$0004,$000E; $011390
    dc.w    $6C46,$2079,$0004,$7992,$43EE,$FF6C,$12D8,$66FC; $0113A0
    dc.w    $302E,$000E,$E548,$207C,$0004,$7982,$2F30,$0000; $0113B0
    dc.w    $486E,$FF6C,$4EB9,$0001,$E1BA,$42A7,$42A7,$42A7; $0113C0
    dc.w    $486E,$FF6C,$302E,$000A,$48C0,$2F00,$4EB9,$0000; $0113D0
    dc.w    $7912,$4FEF,$001C,$6010,$302E,$000A,$48C0,$2F00; $0113E0
    dc.w    $4EB9,$0001,$C43C,$588F,$47EE,$FFF6,$4243,$740C; $0113F0
    dc.w    $7C01,$42A7,$4EB9,$0001,$E1EC,$588F,$4A40,$6704; $011400
    dc.w    $7001,$6002,$7000,$3D40,$FF60,$4245,$4279,$00FF; $011410
    dc.w    $13FC,$4279,$00FF,$A7D8,$426E,$FF62,$302E,$000A; $011420
    dc.w    $EB48,$207C,$00FF,$0338,$41F0,$0000,$2A48,$49EE; $011430
    dc.w    $FFF4,$3005,$0240,$000F,$6702,$7E01,$0C47,$0001; $011440
    dc.w    $6666,$B46E,$FF6A,$6606,$BC6E,$FF68,$6758,$42A7; $011450
    dc.w    $4878,$0011,$4878,$0013,$4878,$0001,$4878,$000C; $011460
    dc.w    $42A7,$4878,$001A,$4EB9,$0000,$0D64,$4878,$0009; $011470
    dc.w    $4878,$0007,$3006,$2F00,$3002,$2F00,$4EB9,$0000; $011480
    dc.w    $5A04,$4879,$0003,$F1B0,$4EB9,$0003,$B246,$4FEF; $011490
    dc.w    $0030,$3003,$48C0,$2F00,$302E,$000A,$48C0,$2F00; $0114A0
    dc.w    $6100,$FB62,$508F,$4247,$4A6E,$FF60,$6710,$42A7; $0114B0
    dc.w    $4EB9,$0001,$E1EC,$588F,$4A40,$6600,$FF76,$426E; $0114C0
    dc.w    $FF60,$3005,$2F00,$4878,$000A,$4EB9,$0001,$E290; $0114D0
    dc.w    $508F,$3A00,$3D42,$FF6A,$3D46,$FF68,$3003,$48C0; $0114E0
    dc.w    $E788,$41F5,$0800,$2448,$0C2A,$0006,$0001,$670E; $0114F0
    dc.w    $3003,$48C0,$D080,$2040,$3833,$8800,$601E,$0C6A; $011500
    dc.w    $0003,$0006,$6612,$7000,$1012,$2F00,$4EB9,$0000; $011510
    dc.w    $D648,$588F,$3800,$6004,$7800,$1812,$0C44,$FFFF; $011520
    dc.w    $6750,$0C6E,$0002,$FF62,$6C16,$4878,$0001,$7000; $011530
    dc.w    $3004,$0680,$0000,$0038,$2F00,$486E,$FF66,$6014; $011540
    dc.w    $4878,$0001,$7000,$3004,$0680,$0000,$0038,$2F00; $011550
    dc.w    $486E,$FF64,$4EB9,$0000,$5092,$4FEF,$000C,$302E; $011560
    dc.w    $FF62,$48C0,$5280,$7204,$4EB9,$0003,$E146,$3D40; $011570
    dc.w    $FF62,$3005,$0240,$003F,$6700,$028A,$0C44,$FFFF; $011580
    dc.w    $671E,$4878,$0001,$7000,$3004,$0680,$0000,$0038; $011590
    dc.w    $2F00,$486E,$FF64,$4EB9,$0000,$5092,$4FEF,$000C; $0115A0
    dc.w    $3005,$0240,$0020,$6700,$0122,$4279,$00FF,$13FC; $0115B0
    dc.w    $4279,$00FF,$A7D8,$0C43,$0004,$6C00,$025C,$0C6E; $0115C0
    dc.w    $0004,$000E,$6C00,$0104,$3003,$48C0,$E788,$41F5; $0115D0
    dc.w    $0800,$2448,$4A2A,$0001,$6600,$00A2,$42A7,$4878; $0115E0
    dc.w    $0002,$4878,$0001,$3006,$48C0,$E788,$0680,$0000; $0115F0
    dc.w    $0030,$2F00,$3002,$48C0,$E788,$0680,$0000,$0028; $011600
    dc.w    $2F00,$3003,$48C0,$0680,$0000,$003B,$2F00,$4878; $011610
    dc.w    $0546,$4EB9,$0001,$E044,$4878,$000A,$4878,$000E; $011620
    dc.w    $4EB9,$0000,$0D64,$4FEF,$0024,$42A7,$4878,$0002; $011630
    dc.w    $4878,$0001,$3006,$48C0,$E788,$0680,$0000,$0030; $011640
    dc.w    $2F00,$3002,$48C0,$E788,$0680,$0000,$0028,$2F00; $011650
    dc.w    $3003,$48C0,$0680,$0000,$003B,$2F00,$4878,$0548; $011660
    dc.w    $4EB9,$0001,$E044,$4878,$000A,$4878,$000E,$4EB9; $011670
    dc.w    $0000,$0D64,$4FEF,$0024,$6000,$019E,$7800,$182A; $011680
    dc.w    $0001,$0644,$FFFF,$3004,$E548,$207C,$0004,$7800; $011690
    dc.w    $2F30,$0000,$2F39,$0004,$7996,$486E,$FF6C,$4EB9; $0116A0
    dc.w    $0003,$B22C,$4878,$0001,$42A7,$4878,$0002,$3003; $0116B0
    dc.w    $48C0,$2F00,$486E,$FF6C,$302E,$000A,$48C0,$2F00; $0116C0
    dc.w    $4EBA,$0168,$4E71,$4FEF,$0024,$3005,$0240,$0010; $0116D0
    dc.w    $6714,$4279,$00FF,$13FC,$4279,$00FF,$A7D8,$363C; $0116E0
    dc.w    $00FF,$6000,$0134,$3803,$3005,$0240,$0001,$6716; $0116F0
    dc.w    $33FC,$0001,$00FF,$13FC,$0C42,$0018,$6C08,$0C46; $011700
    dc.w    $0009,$6602,$7C01,$3005,$0240,$0002,$6710,$33FC; $011710
    dc.w    $0001,$00FF,$13FC,$0C46,$0001,$6602,$7C09,$3005; $011720
    dc.w    $0240,$0004,$6720,$33FC,$0001,$00FF,$13FC,$3002; $011730
    dc.w    $48C0,$5D80,$720C,$B280,$6C08,$3002,$48C0,$5D80; $011740
    dc.w    $6002,$700C,$3400,$3005,$0240,$0008,$6746,$33FC; $011750
    dc.w    $0001,$00FF,$13FC,$5C42,$0C46,$0001,$660C,$0C42; $011760
    dc.w    $0012,$6C2C,$3002,$48C0,$6028,$0C42,$0018,$6C06; $011770
    dc.w    $3002,$48C0,$6002,$7018,$3400,$0C6E,$0003,$000E; $011780
    dc.w    $6708,$0C6E,$0004,$000E,$660A,$0C42,$0012,$6DD4; $011790
    dc.w    $7012,$3400,$0C42,$0018,$6C36,$3002,$48C0,$0480; $0117A0
    dc.w    $0000,$000C,$7206,$4EB9,$0003,$E08A,$3600,$3006; $0117B0
    dc.w    $48C0,$E680,$D040,$D640,$3D7C,$026A,$FFEE,$3D7C; $0117C0
    dc.w    $04AE,$FFF0,$3D7C,$0666,$FFF2,$38BC,$0AAA,$6018; $0117D0
    dc.w    $7604,$3D7C,$0666,$FFEE,$3D7C,$0AAA,$FFF0,$3D7C; $0117E0
    dc.w    $026A,$FFF2,$38BC,$04AE,$4878,$0004,$4878,$0031; $0117F0
    dc.w    $486E,$FFEE,$4EB9,$0000,$5092,$4FEF,$000C,$B843; $011800
    dc.w    $6702,$7E01,$4878,$0003,$4878,$000E,$4EB9,$0000; $011810
    dc.w    $0D64,$508F,$6000,$FC1C,$4EB9,$0001,$E398,$3003; $011820
    dc.w    $4CEE,$3CFC,$FF38,$4E5E,$4E75                    ; $011830 (prev fn epilogue)
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
    dc.w    $2F02,$222F,$0008,$3001,$C0FC; $011CF6
    dc.w    $0320,$207C,$00FF,$9A20,$41F0,$0000,$2248,$3001; $011D00
    dc.w    $C0FC,$0024,$207C,$00FF,$001C,$1030,$0000,$0280; $011D10
    dc.w    $0000,$00FF,$3200,$4242,$601C,$1029,$000A,$0280; $011D20
    dc.w    $0000,$0080,$0C80,$0000,$0080,$6604,$7001,$600C; $011D30
    dc.w    $7014,$D3C0,$5242,$B441,$65E0,$7000,$241F,$4E75; $011D40
    dc.w    $48E7,$3820,$242F,$0018,$262F,$001C,$282F,$0014; $011D50
    dc.w    $246F,$0020,$4A82,$6604,$2483,$6018,$2F03,$2F02; $011D60
    dc.w    $3004,$2F00,$4EBA,$0014,$4E71,$4FEF,$000C,$2400; $011D70
    dc.w    $8682,$60E0,$4CDF,$041C,$4E75,$4E56,$FFF8,$48E7; $011D80
    dc.w    $3E30,$222E,$0010,$47EE,$FFF8,$43EE,$000A,$3011; $011D90
    dc.w    $E548,$207C,$00FF,$08EC,$2C30,$0000,$7600,$7001; $011DA0
    dc.w    $2680,$4244,$3011,$C0FC,$0024,$207C,$00FF,$001C; $011DB0
    dc.w    $1D70,$0000,$FFFF,$6000,$0090,$202E,$000C,$C093; $011DC0
    dc.w    $6700,$0080,$3011,$C0FC,$0320,$207C,$00FF,$9A20; $011DD0
    dc.w    $41F0,$0000,$2448,$7000,$102E,$FFFF,$3D40,$FFFC; $011DE0
    dc.w    $4245,$6058,$102A,$000A,$0280,$0000,$0080,$0C80; $011DF0
    dc.w    $0000,$0080,$6740,$7000,$1012,$B044,$6618,$7000; $011E00
    dc.w    $102A,$0001,$7401,$E1AA,$2006,$C082,$6708,$2001; $011E10
    dc.w    $C082,$6602,$8682,$7000,$102A,$0001,$B044,$6616; $011E20
    dc.w    $7000,$1012,$7401,$E1AA,$2006,$C082,$6708,$2001; $011E30
    dc.w    $C082,$6602,$8682,$7014,$D5C0,$5245,$BA6E,$FFFC; $011E40
    dc.w    $6DA2,$2013,$D193,$5244,$0C44,$0020,$6500,$FF6C; $011E50
    dc.w    $2003,$4CEE,$0C7C,$FFDC,$4E5E,$4E75,$48E7,$3C38; $011E60
    dc.w    $242F,$0020,$262F,$0024,$3002,$C0FC,$0024,$207C; $011E70
    dc.w    $00FF,$0018,$41F0,$0000,$2648,$3003,$48C0,$7201; $011E80
    dc.w    $E1A9,$2001,$4680,$3202,$E549,$207C,$00FF,$08EC; $011E90
    dc.w    $41F0,$1000,$2848,$C190,$3002,$48C0,$223C,$0000; $011EA0
    dc.w    $0320,$4EB9,$0003,$E05C,$2A00,$207C,$00FF,$9A20; $011EB0
    dc.w    $41F0,$0000,$2448,$4242,$2814,$603C,$7000,$1012; $011EC0
    dc.w    $3203,$48C1,$B081,$6608,$7000,$102A,$0001,$6012; $011ED0
    dc.w    $7000,$102A,$0001,$3203,$48C1,$B081,$6614,$7000; $011EE0
    dc.w    $1012,$7201,$E1A9,$2001,$C084,$6606,$002A,$0080; $011EF0
    dc.w    $000A,$7014,$D5C0,$5242,$3002,$48C0,$7200,$122B; $011F00
    dc.w    $0004,$B081,$6DB6,$7000,$102B,$0004,$2200,$E588; $011F10
    dc.w    $D081,$E588,$D085,$207C,$00FF,$9A20,$D1C0,$2448; $011F20
    dc.w    $4242,$6026,$7000,$1012,$3203,$48C1,$B081,$670E; $011F30
    dc.w    $7000,$102A,$0001,$3203,$48C1,$B081,$6606,$002A; $011F40
    dc.w    $0080,$000A,$7014,$D5C0,$5242,$3002,$48C0,$7200; $011F50
    dc.w    $122B,$0005,$B081,$6DCC,$4CDF,$1C3C,$4E75,$48E7; $011F60
    dc.w    $3E30,$242F,$0020,$2A2F,$0024,$3002,$C0FC,$0024; $011F70
    dc.w    $207C,$00FF,$0018,$41F0,$0000,$2648,$3002,$EB48; $011F80
    dc.w    $207C,$00FF,$0338,$41F0,$0000,$2448,$4243,$0C2A; $011F90
    dc.w    $0003,$0001,$664E,$7000,$1012,$48C0,$2F00,$4EB9; $011FA0
    dc.w    $0000,$D648,$588F,$0C12,$0020,$6400,$00A8,$7000; $011FB0
    dc.w    $1012,$7201,$E1A9,$2001,$C085,$6700,$0098,$422A; $011FC0
    dc.w    $0001,$7000,$1012,$48C0,$2F00,$3002,$48C0,$2F00; $011FD0
    dc.w    $4EBA,$0E4C,$4E71,$508F,$0280,$0000,$FFFF,$D1AB; $011FE0
    dc.w    $0006,$6070,$0C2A,$0006,$0001,$6668,$7800,$1812; $011FF0
    dc.w    $3004,$48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000; $012000
    dc.w    $6EEA,$508F,$0C40,$00FF,$6746,$3004,$E548,$207C; $012010
    dc.w    $0005,$ECDC,$2030,$0000,$3202,$E549,$207C,$00FF; $012020
    dc.w    $08EC,$2C30,$1000,$BD80,$3202,$E549,$207C,$00FF; $012030
    dc.w    $A6A0,$C0B0,$1000,$661C,$3002,$C0FC,$000E,$3204; $012040
    dc.w    $D241,$D041,$207C,$00FF,$BD6C,$4A70,$0000,$6604; $012050
    dc.w    $422A,$0001,$508A,$5243,$0C43,$0004,$6D00,$FF30; $012060
    dc.w    $4CDF,$0C7C,$4E75,$4E56,$FFE4,$48E7,$3F3C,$262E; $012070
    dc.w    $000C,$282E,$0008,$3004,$E548,$207C,$00FF,$A6A0; $012080
    dc.w    $2D70,$0000,$FFF4,$4878,$000E,$486E,$FFE6,$42A7; $012090
    dc.w    $3004,$C0FC,$000E,$207C,$00FF,$BD6C,$4870,$0000; $0120A0
    dc.w    $42A7,$4EB9,$0001,$D538,$4FEF,$0014,$3004,$C0FC; $0120B0
    dc.w    $0024,$207C,$00FF,$0018,$41F0,$0000,$2648,$4242; $0120C0
    dc.w    $7A01,$6028,$2003,$C085,$671E,$3002,$48C0,$2F00; $0120D0
    dc.w    $3004,$48C0,$2F00,$4EBA,$0D46,$4E71,$508F,$0280; $0120E0
    dc.w    $0000,$FFFF,$D1AB,$0006,$5242,$DA85,$0C42,$0020; $0120F0
    dc.w    $6DD2,$3004,$C0FC,$0320,$207C,$00FF,$9A20,$41F0; $012100
    dc.w    $0000,$2448,$4242,$3004,$C0FC,$0320,$207C,$00FF; $012110
    dc.w    $9D2C,$41F0,$0000,$2A48,$0C12,$00FF,$6700,$0112; $012120
    dc.w    $102A,$000A,$0800,$0007,$6700,$00F8,$7000,$1012; $012130
    dc.w    $E748,$3204,$D241,$D041,$207C,$00FF,$BA80,$41F0; $012140
    dc.w    $0000,$2848,$102A,$0003,$912C,$0001,$7000,$102A; $012150
    dc.w    $0001,$E748,$3204,$D241,$D041,$207C,$00FF,$BA80; $012160
    dc.w    $41F0,$0000,$2848,$102A,$0003,$912C,$0001,$4878; $012170
    dc.w    $0003,$7000,$102A,$0001,$2F00,$7000,$1012,$2F00; $012180
    dc.w    $4EB9,$0001,$A506,$E288,$D1AB,$0006,$7600,$162A; $012190
    dc.w    $0002,$E883,$0243,$000F,$1A2A,$0002,$0245,$000F; $0121A0
    dc.w    $3004,$EB48,$3203,$D241,$D041,$207C,$00FF,$B9E8; $0121B0
    dc.w    $41F0,$0000,$2848,$DB2C,$0001,$4878,$0014,$42A7; $0121C0
    dc.w    $2F0A,$4EB9,$0001,$D520,$4FEF,$0018,$14BC,$00FF; $0121D0
    dc.w    $157C,$00FF,$0001,$7628,$9642,$0643,$FFFF,$4A43; $0121E0
    dc.w    $6F46,$3003,$48C0,$2200,$E588,$D081,$E588,$2F00; $0121F0
    dc.w    $2F0A,$42A7,$200A,$7214,$D081,$2F00,$42A7,$4EB9; $012200
    dc.w    $0001,$D538,$4878,$0014,$42A7,$2F0D,$4EB9,$0001; $012210
    dc.w    $D520,$4FEF,$0020,$1ABC,$00FF,$1B7C,$00FF,$0001; $012220
    dc.w    $6006,$5242,$7014,$D5C0,$0C42,$0028,$6D00,$FEEA; $012230
    dc.w    $177C,$0001,$0002,$422B,$0003,$422B,$0004,$422B; $012240
    dc.w    $0005,$7000,$102B,$0001,$7201,$E1A9,$3004,$E548; $012250
    dc.w    $207C,$00FF,$A6A0,$2181,$0000,$4878,$0007,$42A7; $012260
    dc.w    $3004,$C0FC,$0007,$207C,$00FF,$A7BC,$4870,$0000; $012270
    dc.w    $4EB9,$0001,$D520,$4878,$000E,$42A7,$3004,$C0FC; $012280
    dc.w    $000E,$207C,$00FF,$BD6C,$4870,$0000,$4EB9,$0001; $012290
    dc.w    $D520,$4FEF,$0018,$3004,$C0FC,$0320,$207C,$00FF; $0122A0
    dc.w    $9A20,$41F0,$0000,$2448,$4242,$3004,$C0FC,$000E; $0122B0
    dc.w    $207C,$00FF,$BD6C,$41F0,$0000,$2D48,$FFFC,$3004; $0122C0
    dc.w    $C0FC,$0007,$207C,$00FF,$A7BC,$41F0,$0000,$2D48; $0122D0
    dc.w    $FFF8,$0C12,$00FF,$6700,$01C4,$7000,$1012,$48C0; $0122E0
    dc.w    $2F00,$4EB9,$0000,$D648,$3600,$7000,$102A,$0001; $0122F0
    dc.w    $48C0,$2F00,$4EB9,$0000,$D648,$508F,$3A00,$3003; $012300
    dc.w    $E548,$207C,$0005,$ECBC,$41F0,$0000,$2848,$3005; $012310
    dc.w    $E548,$207C,$0005,$ECBC,$41F0,$0000,$2A48,$B645; $012320
    dc.w    $6700,$00A0,$522B,$0004,$7000,$1012,$7C01,$E1AE; $012330
    dc.w    $7000,$102A,$0001,$7E01,$E1AF,$3004,$E548,$207C; $012340
    dc.w    $00FF,$A6A0,$2030,$0000,$C086,$6612,$522B,$0002; $012350
    dc.w    $3004,$E548,$207C,$00FF,$A6A0,$8DB0,$0000,$3004; $012360
    dc.w    $E548,$207C,$00FF,$A6A0,$2030,$0000,$C087,$6612; $012370
    dc.w    $522B,$0002,$3004,$E548,$207C,$00FF,$A6A0,$8FB0; $012380
    dc.w    $0000,$3004,$E548,$207C,$00FF,$08EC,$2030,$0000; $012390
    dc.w    $C086,$660A,$1C12,$14AA,$0001,$1546,$0001,$7001; $0123A0
    dc.w    $EB28,$3203,$48C1,$D2AE,$FFF8,$2041,$8110,$7001; $0123B0
    dc.w    $E728,$3205,$48C1,$D2AE,$FFF8,$2041,$8110,$6000; $0123C0
    dc.w    $00DC,$522B,$0005,$0C12,$0020,$642E,$7000,$1012; $0123D0
    dc.w    $7C01,$E1AE,$3004,$E548,$207C,$00FF,$A6A0,$2030; $0123E0
    dc.w    $0000,$C086,$6648,$522B,$0002,$3004,$E548,$207C; $0123F0
    dc.w    $00FF,$A6A0,$8DB0,$0000,$6034,$7000,$1012,$7200; $012400
    dc.w    $122C,$0002,$9041,$7C01,$E16E,$3003,$48C0,$D080; $012410
    dc.w    $D0AE,$FFFC,$2040,$3010,$C046,$6612,$522B,$0003; $012420
    dc.w    $3003,$48C0,$D080,$D0AE,$FFFC,$2040,$8D50,$0C2A; $012430
    dc.w    $0020,$0001,$6430,$7000,$102A,$0001,$7E01,$E1AF; $012440
    dc.w    $3004,$E548,$207C,$00FF,$A6A0,$2030,$0000,$C087; $012450
    dc.w    $664A,$522B,$0002,$3004,$E548,$207C,$00FF,$A6A0; $012460
    dc.w    $8FB0,$0000,$6036,$7000,$102A,$0001,$7200,$122D; $012470
    dc.w    $0002,$9041,$7601,$E16B,$3005,$48C0,$D080,$D0AE; $012480
    dc.w    $FFFC,$2040,$3010,$C043,$6612,$522B,$0003,$3005; $012490
    dc.w    $48C0,$D080,$D0AE,$FFFC,$2040,$8750,$7014,$D5C0; $0124A0
    dc.w    $5242,$0C42,$0028,$6D00,$FE2A,$4242,$3004,$C0FC; $0124B0
    dc.w    $000E,$3202,$D241,$D041,$207C,$00FF,$BD6C,$3030; $0124C0
    dc.w    $0000,$4640,$3202,$D241,$C176,$10E6,$5242,$0C42; $0124D0
    dc.w    $0007,$6DD8,$3004,$E548,$207C,$00FF,$A6A0,$2030; $0124E0
    dc.w    $0000,$4680,$C1AE,$FFF4,$486E,$FFE6,$2F2E,$FFF4; $0124F0
    dc.w    $3004,$48C0,$2F00,$6100,$FA66,$4CEE,$3CFC,$FFBC; $012500
    dc.w    $4E5E,$4E75,$4E56,$FE70,$48E7,$3F3C,$2A7C,$0003; $012510
    dc.w    $B22C,$4878,$0050,$42A7,$486E,$FF60,$4EB9,$0001; $012520
    dc.w    $D520,$4EB9,$0001,$D71C,$4EB9,$0001,$E398,$2F39; $012530
    dc.w    $0009,$5118,$4879,$00FF,$1804,$4EB9,$0000,$3FEC; $012540
    dc.w    $4FEF,$0014,$302E,$000A,$C0FC,$0320,$207C,$00FF; $012550
    dc.w    $9A20,$41F0,$0000,$2648,$4242,$4244,$6000,$0098; $012560
    dc.w    $0C13,$00FF,$6700,$008A,$102B,$000A,$0280,$0000; $012570
    dc.w    $0080,$677C,$7000,$1013,$D040,$207C,$0005,$E948; $012580
    dc.w    $41F0,$0000,$2448,$7000,$102B,$0001,$D040,$207C; $012590
    dc.w    $0005,$E948,$41F0,$0000,$2848,$1012,$B014,$6416; $0125A0
    dc.w    $7600,$1612,$7E00,$1E2A,$0001,$7C00,$1C14,$7A00; $0125B0
    dc.w    $1A2C,$0001,$6014,$7C00,$1C12,$7A00,$1A2A,$0001; $0125C0
    dc.w    $7600,$1614,$7E00,$1E2C,$0001,$4879,$00FF,$1804; $0125D0
    dc.w    $4878,$0001,$3005,$2F00,$3006,$2F00,$3007,$2F00; $0125E0
    dc.w    $3003,$2F00,$4EB9,$0001,$DC26,$4FEF,$0018,$5244; $0125F0
    dc.w    $7014,$D7C0,$5242,$0C42,$0028,$6D00,$FF64,$247C; $012600
    dc.w    $0005,$E948,$4242,$4243,$6056,$3002,$48C0,$7201; $012610
    dc.w    $E1A9,$2001,$C0AE,$000C,$6742,$42A7,$4878,$0001; $012620
    dc.w    $4878,$0001,$7000,$102A,$0001,$5980,$2F00,$7000; $012630
    dc.w    $1012,$5980,$2F00,$3002,$48C0,$5E80,$2F00,$4878; $012640
    dc.w    $0761,$4EB9,$0001,$E044,$4878,$0001,$4878,$000E; $012650
    dc.w    $4EB9,$0000,$0D64,$4FEF,$0024,$5243,$548A,$5242; $012660
    dc.w    $0C42,$0020,$6DA4,$4878,$02C0,$4878,$0001,$4879; $012670
    dc.w    $00FF,$1804,$4EB9,$0000,$45E6,$4879,$0007,$0198; $012680
    dc.w    $4878,$0014,$4878,$0020,$42A7,$42A7,$4878,$0001; $012690
    dc.w    $4878,$001B,$4EB9,$0000,$0D64,$4FEF,$0028,$4878; $0126A0
    dc.w    $0010,$4878,$0010,$4879,$0007,$677E,$4EB9,$0000; $0126B0
    dc.w    $5092,$4FEF,$000C,$0C43,$0001,$6610,$4879,$0003; $0126C0
    dc.w    $F238,$486E,$FF10,$4E95,$508F,$6016,$3003,$48C0; $0126D0
    dc.w    $2F00,$2F39,$0004,$799A,$486E,$FF10,$4E95,$4FEF; $0126E0
    dc.w    $000C,$0C44,$0001,$6610,$4879,$0003,$F230,$486E; $0126F0
    dc.w    $FEC0,$4E95,$508F,$6016,$3004,$48C0,$2F00,$2F39; $012700
    dc.w    $0004,$799E,$486E,$FEC0,$4E95,$4FEF,$000C,$4A44; $012710
    dc.w    $6616,$486E,$FF10,$4879,$0003,$F22C,$486E,$FE70; $012720
    dc.w    $4E95,$4FEF,$000C,$6028,$4A43,$660C,$486E,$FEC0; $012730
    dc.w    $4879,$0003,$F228,$60E4,$486E,$FEC0,$486E,$FF10; $012740
    dc.w    $2F39,$0004,$79A2,$486E,$FE70,$4E95,$4FEF,$0010; $012750
    dc.w    $486E,$FE70,$2F39,$0004,$79A6,$486E,$FF60,$4E95; $012760
    dc.w    $4EB9,$0001,$D748,$4878,$0001,$42A7,$42A7,$486E; $012770
    dc.w    $FF60,$302E,$000A,$48C0,$2F00,$4EB9,$0000,$7912; $012780
    dc.w    $4FEF,$0020,$4A44,$6F16,$3004,$48C0,$2F00,$302E; $012790
    dc.w    $000A,$48C0,$2F00,$4EBA,$0396,$4E71,$508F,$42A7; $0127A0
    dc.w    $4878,$0001,$42A7,$2F39,$0004,$79AA,$302E,$000A; $0127B0
    dc.w    $48C0,$2F00,$4EB9,$0000,$7912,$3400,$4CEE,$3CFC; $0127C0
    dc.w    $FE48,$4E5E,$4E75,$4E56,$FEC0,$48E7,$3F3C,$282E; $0127D0
    dc.w    $000C,$2E2E,$0008,$4EB9,$0001,$D71C,$4878,$0050; $0127E0
    dc.w    $42A7,$486E,$FFB0,$4EB9,$0001,$D520,$4EB9,$0000; $0127F0
    dc.w    $814A,$7000,$3004,$E588,$207C,$0009,$511C,$2F30; $012800
    dc.w    $0800,$4879,$00FF,$1804,$4EB9,$0000,$3FEC,$4FEF; $012810
    dc.w    $0014,$7A07,$3007,$C0FC,$0024,$207C,$00FF,$0018; $012820
    dc.w    $41F0,$0000,$2A48,$7000,$102D,$0004,$C0FC,$0014; $012830
    dc.w    $3207,$C2FC,$0320,$D041,$207C,$00FF,$9A20,$41F0; $012840
    dc.w    $0000,$2448,$4246,$4242,$6000,$00E8,$7000,$1012; $012850
    dc.w    $0280,$0000,$FFFF,$2F00,$4EB9,$0000,$D648,$588F; $012860
    dc.w    $48C0,$7200,$3204,$B081,$6600,$00C2,$102A,$000A; $012870
    dc.w    $0280,$0000,$0080,$0C80,$0000,$0080,$6600,$00AE; $012880
    dc.w    $7000,$1012,$D040,$207C,$0005,$E9FA,$41F0,$0000; $012890
    dc.w    $2848,$7000,$102A,$0001,$D040,$207C,$0005,$E9FA; $0128A0
    dc.w    $41F0,$0000,$2648,$302A,$000E,$B06A,$0006,$6504; $0128B0
    dc.w    $7601,$6002,$7602,$3003,$48C0,$2F00,$4878,$0004; $0128C0
    dc.w    $2F0B,$2F0C,$4EB9,$0000,$9994,$42A7,$4878,$0001; $0128D0
    dc.w    $4878,$0001,$7000,$102B,$0001,$2F00,$7000,$1013; $0128E0
    dc.w    $2F00,$7000,$3005,$2F00,$7000,$102A,$0001,$0280; $0128F0
    dc.w    $0000,$FFFF,$2F00,$7000,$3004,$2F00,$7000,$3007; $012900
    dc.w    $2F00,$4EB9,$0001,$8EBA,$4FEF,$000C,$2F00,$4EB9; $012910
    dc.w    $0001,$E044,$4FEF,$002C,$4878,$0001,$4878,$000E; $012920
    dc.w    $4EB9,$0000,$0D64,$508F,$5245,$5246,$7014,$D5C0; $012930
    dc.w    $5242,$7000,$102D,$0005,$B042,$6200,$FF10,$4878; $012940
    dc.w    $02E0,$4878,$0001,$4879,$00FF,$1804,$4EB9,$0000; $012950
    dc.w    $45E6,$4878,$0010,$4878,$0010,$4879,$0007,$677E; $012960
    dc.w    $4EB9,$0000,$5092,$4FEF,$0018,$4243,$3004,$E548; $012970
    dc.w    $207C,$0005,$ECDC,$2030,$0000,$C0AE,$0010,$2800; $012980
    dc.w    $6764,$4242,$7000,$3002,$7201,$E1A9,$2001,$B084; $012990
    dc.w    $6708,$5242,$0C42,$0020,$65EA,$3002,$D040,$207C; $0129A0
    dc.w    $0005,$E9FA,$41F0,$0000,$2848,$42A7,$4878,$0001; $0129B0
    dc.w    $4878,$0001,$7000,$102C,$0001,$2F00,$7000,$1014; $0129C0
    dc.w    $2F00,$7000,$3005,$2F00,$4878,$0761,$4EB9,$0001; $0129D0
    dc.w    $E044,$4878,$0001,$4878,$000E,$4EB9,$0000,$0D64; $0129E0
    dc.w    $4FEF,$0024,$5243,$4879,$0007,$0198,$4878,$0017; $0129F0
    dc.w    $4878,$0020,$42A7,$42A7,$4878,$0001,$4878,$001B; $012A00
    dc.w    $4EB9,$0000,$0D64,$4FEF,$001C,$0C43,$0001,$6614; $012A10
    dc.w    $4879,$0003,$F258,$486E,$FF60,$4EB9,$0003,$B22C; $012A20
    dc.w    $508F,$601A,$7000,$3003,$2F00,$2F39,$0004,$799A; $012A30
    dc.w    $486E,$FF60,$4EB9,$0003,$B22C,$4FEF,$000C,$0C46; $012A40
    dc.w    $0001,$6614,$4879,$0003,$F250,$486E,$FF10,$4EB9; $012A50
    dc.w    $0003,$B22C,$508F,$601A,$7000,$3006,$2F00,$2F39; $012A60
    dc.w    $0004,$799E,$486E,$FF10,$4EB9,$0003,$B22C,$4FEF; $012A70
    dc.w    $000C,$4A46,$661A,$486E,$FF60,$4879,$0003,$F24C; $012A80
    dc.w    $486E,$FEC0,$4EB9,$0003,$B22C,$4FEF,$000C,$602C; $012A90
    dc.w    $4A43,$660C,$486E,$FF10,$4879,$0003,$F248,$60E0; $012AA0
    dc.w    $486E,$FF10,$486E,$FF60,$2F39,$0004,$79A2,$486E; $012AB0
    dc.w    $FEC0,$4EB9,$0003,$B22C,$4FEF,$0010,$486E,$FEC0; $012AC0
    dc.w    $2F39,$0004,$79A6,$486E,$FFB0,$4EB9,$0003,$B22C; $012AD0
    dc.w    $4EB9,$0001,$D748,$4878,$0001,$42A7,$42A7,$486E; $012AE0
    dc.w    $FFB0,$7000,$3007,$2F00,$4EB9,$0000,$7912,$4FEF; $012AF0
    dc.w    $0020,$4A46,$6714,$7000,$3006,$2F00,$7000,$3007; $012B00
    dc.w    $2F00,$4EBA,$002A,$4E71,$508F,$42A7,$4878,$0001; $012B10
    dc.w    $42A7,$2F39,$0004,$79AA,$7000,$3007,$2F00,$4EB9; $012B20
    dc.w    $0000,$7912,$4CEE,$3CFC,$FE98,$4E5E,$4E75,$4E56; $012B30
    dc.w    $FFFC,$48E7,$3F3C,$2A2E,$0008,$2A7C,$0000,$0D64; $012B40
    dc.w    $4244,$7E01,$4EB9,$0001,$E398,$3005,$C0FC,$0320; $012B50
    dc.w    $207C,$00FF,$9A20,$41F0,$0000,$2448,$42A7,$4EB9; $012B60
    dc.w    $0001,$E1EC,$588F,$4A40,$6704,$7001,$6002,$7000; $012B70
    dc.w    $3D40,$FFFE,$4246,$4279,$00FF,$13FC,$4279,$00FF; $012B80
    dc.w    $A7D8,$4EB9,$0001,$D71C,$7000,$2840,$4242,$4243; $012B90
    dc.w    $3005,$C0FC,$0320,$207C,$00FF,$9A20,$41F0,$0000; $012BA0
    dc.w    $2648,$0C42,$0028,$6D04,$244B,$4242,$4A42,$6C08; $012BB0
    dc.w    $244B,$45EA,$030C,$7427,$102A,$000A,$0800,$0007; $012BC0
    dc.w    $6616,$0C44,$0001,$6608,$7014,$D5C0,$5242,$60D2; $012BD0
    dc.w    $7014,$95C0,$5342,$60CA,$B9CA,$677A,$2F3C,$0000; $012BE0
    dc.w    $8000,$4878,$000D,$4878,$001E,$4878,$0002,$4878; $012BF0
    dc.w    $0001,$42A7,$4878,$001A,$4E95,$4878,$0001,$4878; $012C00
    dc.w    $000E,$4E95,$4FEF,$0024,$2F3C,$0000,$8000,$4878; $012C10
    dc.w    $000D,$4878,$001E,$4878,$0002,$4878,$0001,$4878; $012C20
    dc.w    $0001,$4878,$001A,$4E95,$4878,$0001,$4878,$000E; $012C30
    dc.w    $4E95,$4FEF,$0024,$4878,$0001,$4878,$0002,$4878; $012C40
    dc.w    $0001,$3005,$48C0,$2F00,$2F0A,$4EB9,$0001,$9244; $012C50
    dc.w    $4FEF,$0014,$284A,$0C47,$0001,$6624,$4EB9,$0001; $012C60
    dc.w    $D748,$42A7,$42A7,$42A7,$4879,$0003,$F268,$3005; $012C70
    dc.w    $48C0,$2F00,$4EB9,$0000,$7912,$4FEF,$0014,$4247; $012C80
    dc.w    $4A6E,$FFFE,$6710,$42A7,$4EB9,$0001,$E1EC,$588F; $012C90
    dc.w    $4A40,$6600,$FEFC,$426E,$FFFE,$0C6E,$0002,$000E; $012CA0
    dc.w    $6C24,$4878,$0001,$4878,$0003,$4EB9,$0001,$D62C; $012CB0
    dc.w    $508F,$0280,$0000,$0030,$67E8,$0C46,$0020,$6600; $012CC0
    dc.w    $012A,$6000,$0126,$5243,$0C43,$0001,$6668,$2F3C; $012CD0
    dc.w    $0000,$8000,$4878,$0001,$4878,$0001,$4878,$0008; $012CE0
    dc.w    $4878,$0078,$4878,$0039,$4878,$0770,$4EB9,$0001; $012CF0
    dc.w    $E044,$4878,$0001,$4878,$000E,$4E95,$4FEF,$0024; $012D00
    dc.w    $2F3C,$0000,$8000,$4878,$0001,$4878,$0001,$4878; $012D10
    dc.w    $0078,$4878,$0078,$4878,$003A,$4878,$0771,$4EB9; $012D20
    dc.w    $0001,$E044,$4FEF,$001C,$4878,$0001,$4878,$000E; $012D30
    dc.w    $4E95,$508F,$6020,$0C43,$000F,$6612,$4878,$0002; $012D40
    dc.w    $4878,$0039,$4EB9,$0001,$E0B8,$508F,$60DA,$0C43; $012D50
    dc.w    $001E,$6602,$4243,$3006,$2F00,$4878,$000A,$4EB9; $012D60
    dc.w    $0001,$E290,$508F,$0240,$0033,$3C00,$48C0,$7220; $012D70
    dc.w    $B041,$6714,$7210,$B041,$6720,$7201,$B041,$672A; $012D80
    dc.w    $7202,$B041,$6736,$6046,$4279,$00FF,$13FC,$4279; $012D90
    dc.w    $00FF,$A7D8,$7401,$3002,$6050,$4279,$00FF,$13FC; $012DA0
    dc.w    $4279,$00FF,$A7D8,$4242,$60EC,$33FC,$0001,$00FF; $012DB0
    dc.w    $13FC,$4244,$7014,$95C0,$5342,$601E,$33FC,$0001; $012DC0
    dc.w    $00FF,$13FC,$7801,$7014,$D5C0,$5242,$600C,$4279; $012DD0
    dc.w    $00FF,$13FC,$4279,$00FF,$A7D8,$4878,$0005,$4878; $012DE0
    dc.w    $000E,$4E95,$508F,$6000,$FDA8,$4CEE,$3CFC,$FFD4; $012DF0
    dc.w    $4E5E,$4E75,$302F,$0006,$C0FC,$0320,$207C,$00FF; $012E00
    dc.w    $9A20,$41F0,$0000,$2248,$4241,$0229,$007F,$000A; $012E10
    dc.w    $7014,$D3C0,$5241,$0C41,$0028,$6DEE,$4E75,$48E7; $012E20
    dc.w    $3020,$242F,$0014,$262F,$0010,$3002,$E548,$207C; $012E30
    dc.w    $00FF,$1298,$41F0,$0000,$2448,$3002,$48C0,$2F00; $012E40
    dc.w    $3003,$48C0,$2F00,$4EB9,$0000,$9D92,$508F,$3400; $012E50
    dc.w    $7000,$102A,$0003,$48C0,$2200,$E988,$9081,$D080; $012E60
    dc.w    $0680,$0000,$0258,$3202,$48C1,$5281,$4EB9,$0003; $012E70
    dc.w    $E05C,$4A80,$6C02,$5680,$E480,$3400,$4CDF,$040C; $012E80
    dc.w    $4E75,$4E56,$FF90,$48E7,$3E3C,$49EE,$FF92,$4BEE; $012E90
    dc.w    $FFE2,$7400,$1439,$00FF,$0016,$3639,$00FF,$9A1C; $012EA0
    dc.w    $3002,$C0FC,$0024,$207C,$00FF,$0018,$41F0,$0000; $012EB0
    dc.w    $2648,$4878,$0001,$42A7,$4EB9,$0001,$E0B8,$4878; $012EC0
    dc.w    $0004,$4878,$003B,$4EB9,$0001,$E0B8,$3003,$48C0; $012ED0
    dc.w    $2F00,$4EBA,$02F6,$4E71,$4FEF,$0014,$0C40,$0001; $012EE0
    dc.w    $6600,$0250,$3003,$48C0,$2F00,$3002,$48C0,$2F00; $012EF0
    dc.w    $4EBA,$07F6,$4E71,$508F,$4A40,$6F00,$0200,$4878; $012F00
    dc.w    $001E,$42A7,$2F0D,$4EB9,$0001,$D520,$2F0D,$3003; $012F10
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EBA,$06E8,$4E71; $012F20
    dc.w    $2F0D,$3002,$48C0,$2F00,$4EBA,$0F28,$4E71,$4FEF; $012F30
    dc.w    $0020,$0C40,$0001,$6600,$018E,$4EB9,$0001,$D748; $012F40
    dc.w    $4878,$0003,$3002,$48C0,$2F00,$4EB9,$0001,$12EE; $012F50
    dc.w    $508F,$3800,$0C40,$00FF,$6700,$0230,$4EB9,$0001; $012F60
    dc.w    $D71C,$4878,$0001,$3003,$48C0,$2F00,$3002,$48C0; $012F70
    dc.w    $2F00,$4EB9,$0000,$6A2E,$2F0D,$3004,$48C0,$2F00; $012F80
    dc.w    $3003,$48C0,$2F00,$3002,$48C0,$2F00,$4EBA,$02BE; $012F90
    dc.w    $4E71,$4FEF,$001C,$3A00,$0C40,$00FF,$679C,$0C45; $012FA0
    dc.w    $0001,$6604,$7C03,$6002,$3C05,$3006,$48C0,$2F00; $012FB0
    dc.w    $3003,$48C0,$2F00,$3002,$48C0,$2F00,$4EBA,$0F24; $012FC0
    dc.w    $4E71,$4878,$0001,$42A7,$42A7,$3004,$48C0,$2F00; $012FD0
    dc.w    $3005,$E548,$207C,$0004,$79F6,$2F30,$0000,$3002; $012FE0
    dc.w    $48C0,$2F00,$4EB9,$0001,$183A,$3002,$EB48,$3204; $012FF0
    dc.w    $E749,$D041,$207C,$00FF,$0338,$41F0,$0000,$2448; $013000
    dc.w    $157C,$0006,$0001,$3545,$0006,$1483,$3004,$48C0; $013010
    dc.w    $2F00,$3003,$48C0,$2F00,$3002,$48C0,$2F00,$4EBA; $013020
    dc.w    $074E,$4E71,$4FEF,$0030,$2C00,$6F00,$008A,$3005; $013030
    dc.w    $48C0,$E588,$207C,$0005,$E296,$2F30,$0800,$2F39; $013040
    dc.w    $0004,$79C2,$2F0C,$4EB9,$0003,$B22C,$42A7,$4878; $013050
    dc.w    $0001,$42A7,$3004,$48C0,$2F00,$2F0C,$3002,$48C0; $013060
    dc.w    $2F00,$4EB9,$0001,$183A,$4FEF,$0024,$0C40,$0001; $013070
    dc.w    $6644,$157C,$0004,$0003,$9DAB,$0006,$4878,$0005; $013080
    dc.w    $4878,$000A,$4878,$0013,$4EB9,$0000,$5FF6,$4878; $013090
    dc.w    $0001,$42A7,$42A7,$3004,$48C0,$2F00,$2F39,$0004; $0130A0
    dc.w    $79D6,$3002,$48C0,$2F00,$4EB9,$0001,$183A,$4FEF; $0130B0
    dc.w    $0024,$6000,$FE86,$422A,$0001,$426A,$0006,$14BC; $0130C0
    dc.w    $00FF,$6000,$FE98,$42A7,$4878,$000D,$4878,$0020; $0130D0
    dc.w    $4878,$0013,$42A7,$42A7,$4878,$001A,$4EB9,$0000; $0130E0
    dc.w    $0D64,$4FEF,$001C,$3003,$E548,$207C,$0005,$EC84; $0130F0
    dc.w    $2F30,$0000,$2F39,$0004,$79CE,$606A,$42A7,$4878; $013100
    dc.w    $000D,$4878,$0020,$4878,$0013,$42A7,$42A7,$4878; $013110
    dc.w    $001A,$4EB9,$0000,$0D64,$4FEF,$001C,$3003,$E548; $013120
    dc.w    $207C,$0005,$EC84,$2F30,$0000,$2F39,$0004,$79AE; $013130
    dc.w    $6034,$42A7,$4878,$000D,$4878,$0020,$4878,$0013; $013140
    dc.w    $42A7,$42A7,$4878,$001A,$4EB9,$0000,$0D64,$4FEF; $013150
    dc.w    $001C,$3003,$E548,$207C,$0005,$EC84,$2F30,$0000; $013160
    dc.w    $2F39,$0004,$79DA,$2F0C,$4EB9,$0003,$B22C,$4878; $013170
    dc.w    $0001,$42A7,$4878,$0002,$2F0C,$3002,$48C0,$2F00; $013180
    dc.w    $4EB9,$0000,$7912,$4FEF,$0020,$4EB9,$0001,$D71C; $013190
    dc.w    $4878,$0001,$3003,$48C0,$2F00,$3002,$48C0,$2F00; $0131A0
    dc.w    $4EB9,$0000,$6A2E,$4878,$0002,$3039,$00FF,$9A1C; $0131B0
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$6B78; $0131C0
    dc.w    $4CEE,$3C7C,$FF6C,$4E5E,$4E75,$48E7,$3820,$7201; $0131D0
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
    dc.w    $4E75,$4E56,$FFFC,$48E7,$3F3C,$7400,$1439,$00FF; $014200
    dc.w    $0016,$3002,$C0FC,$0024,$207C,$00FF,$0018,$41F0; $014210
    dc.w    $0000,$2D48,$FFFC,$287C,$00FF,$BA6C,$4247,$4878; $014220
    dc.w    $0040,$42A7,$4878,$0010,$4EB9,$0000,$0D64,$42A7; $014230
    dc.w    $4EB9,$0000,$538E,$4878,$0002,$3039,$00FF,$9A1C; $014240
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$6B78; $014250
    dc.w    $4FEF,$001C,$3002,$EB48,$207C,$00FF,$B9E8,$41F0; $014260
    dc.w    $0000,$2A48,$6000,$040A,$4878,$0020,$4878,$0020; $014270
    dc.w    $42A7,$42A7,$4EB9,$0003,$A942,$4245,$4243,$4878; $014280
    dc.w    $0014,$42A7,$2F0C,$4EB9,$0001,$D520,$3039,$00FF; $014290
    dc.w    $9A1C,$48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000; $0142A0
    dc.w    $6EEA,$4FEF,$0024,$3C00,$0C46,$00FF,$6600,$00D6; $0142B0
    dc.w    $2F3C,$0000,$8000,$4878,$0005,$4878,$0003,$4878; $0142C0
    dc.w    $0020,$4878,$0015,$42A7,$4878,$001A,$4EB9,$0000; $0142D0
    dc.w    $0D64,$4FEF,$001C,$3039,$00FF,$9A1C,$E548,$207C; $0142E0
    dc.w    $0005,$ECBC,$41F0,$0000,$2648,$4244,$602A,$7000; $0142F0
    dc.w    $1013,$3204,$48C1,$D081,$7201,$E1A9,$2001,$3202; $014300
    dc.w    $E549,$207C,$00FF,$A6A0,$C0B0,$1000,$6708,$7C00; $014310
    dc.w    $1C13,$DC44,$6010,$5244,$3004,$48C0,$7200,$122B; $014320
    dc.w    $0001,$B081,$6DC8,$0C46,$00FF,$6658,$4878,$0001; $014330
    dc.w    $42A7,$4878,$0002,$4879,$0003,$F772,$3002,$48C0; $014340
    dc.w    $2F00,$4EB9,$0000,$7912,$4EB9,$0001,$D71C,$4878; $014350
    dc.w    $0002,$3039,$00FF,$9A1C,$48C0,$2F00,$3002,$48C0; $014360
    dc.w    $2F00,$4EB9,$0000,$6A2E,$42A7,$3039,$00FF,$9A1C; $014370
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$6B78; $014380
    dc.w    $4FEF,$002C,$0C46,$00FF,$6700,$00CA,$42A7,$4EB9; $014390
    dc.w    $0000,$538E,$3007,$48C0,$2F00,$3006,$48C0,$2F00; $0143A0
    dc.w    $3002,$48C0,$2F00,$4EBA,$09EE,$4E71,$4FEF,$0010; $0143B0
    dc.w    $3E00,$0C47,$00FF,$664C,$4EB9,$0001,$D71C,$4878; $0143C0
    dc.w    $0002,$3039,$00FF,$9A1C,$48C0,$2F00,$3002,$48C0; $0143D0
    dc.w    $2F00,$4EB9,$0000,$6A2E,$42A7,$3039,$00FF,$9A1C; $0143E0
    dc.w    $48C0,$2F00,$3002,$48C0,$2F00,$4EB9,$0000,$6B78; $0143F0
    dc.w    $4FEF,$0018,$0C79,$0007,$00FF,$9A1C,$6656,$363C; $014400
    dc.w    $00FF,$6052,$3002,$C0FC,$0320,$3207,$C2FC,$0014; $014410
    dc.w    $D041,$207C,$00FF,$9A20,$41F0,$0000,$2448,$4878; $014420
    dc.w    $0014,$2F0C,$42A7,$2F0A,$42A7,$4EB9,$0001,$D538; $014430
    dc.w    $7000,$102A,$0001,$48C0,$2F00,$7000,$1012,$48C0; $014440
    dc.w    $2F00,$3002,$48C0,$2F00,$4EB9,$0001,$B324,$4FEF; $014450
    dc.w    $0020,$6002,$760C,$0C43,$000C,$6700,$0214,$0C43; $014460
    dc.w    $00FF,$6700,$020C,$2F0C,$3002,$48C0,$2F00,$4EBA; $014470
    dc.w    $0212,$4E71,$508F,$3600,$0C43,$0001,$663A,$2F0A; $014480
    dc.w    $3002,$48C0,$2F00,$4EB9,$0001,$19B4,$508F,$4247; $014490
    dc.w    $206E,$FFFC,$1028,$0004,$0280,$0000,$00FF,$206E; $0144A0
    dc.w    $FFFC,$1228,$0005,$0281,$0000,$00FF,$D081,$6E00; $0144B0
    dc.w    $0176,$760C,$6000,$0170,$0C43,$00FF,$6700,$0168; $0144C0
    dc.w    $102A,$0002,$B02C,$0002,$661E,$102A,$0003,$B02C; $0144D0
    dc.w    $0003,$6614,$302A,$0004,$B06C,$0004,$660A,$102A; $0144E0
    dc.w    $000A,$B02C,$000A,$6702,$7A01,$0C45,$0001,$6600; $0144F0
    dc.w    $0136,$2F3C,$0000,$8000,$4878,$0005,$4878,$0020; $014500
    dc.w    $42A7,$42A7,$42A7,$4878,$001A,$4EB9,$0000,$0D64; $014510
    dc.w    $4FEF,$001C,$2F3C,$0000,$8000,$4878,$0005,$4878; $014520
    dc.w    $0020,$42A7,$42A7,$4878,$0001,$4878,$001A,$4EB9; $014530
    dc.w    $0000,$0D64,$42A7,$4878,$0001,$42A7,$4879,$0003; $014540
    dc.w    $F748,$3002,$48C0,$2F00,$4EB9,$0000,$7912,$4FEF; $014550
    dc.w    $0030,$0C40,$0001,$6600,$00CE,$7000,$1012,$E748; $014560
    dc.w    $3202,$D241,$D041,$122A,$0003,$207C,$00FF,$BA81; $014570
    dc.w    $9330,$0000,$7000,$102A,$0001,$E748,$3202,$D241; $014580
    dc.w    $D041,$122A,$0003,$207C,$00FF,$BA81,$9330,$0000; $014590
    dc.w    $2F0A,$4EB9,$0000,$74E0,$0280,$0000,$FFFF,$D080; $0145A0
    dc.w    $41F5,$0800,$5288,$2648,$2F0A,$4EB9,$0000,$7402; $0145B0
    dc.w    $D113,$4878,$0014,$2F0A,$42A7,$2F0C,$42A7,$4EB9; $0145C0
    dc.w    $0001,$D538,$7000,$1012,$E748,$3202,$D241,$D041; $0145D0
    dc.w    $122A,$0003,$207C,$00FF,$BA81,$D330,$0000,$7000; $0145E0
    dc.w    $102A,$0001,$E748,$3202,$D241,$D041,$122A,$0003; $0145F0
    dc.w    $207C,$00FF,$BA81,$D330,$0000,$2F0A,$4EB9,$0000; $014600
    dc.w    $74E0,$0280,$0000,$FFFF,$D080,$41F5,$0800,$5288; $014610
    dc.w    $2648,$2F0A,$4EB9,$0000,$7402,$4FEF,$0024,$9113; $014620
    dc.w    $002A,$0001,$000A,$4EB9,$0001,$D71C,$4EB9,$0001; $014630
    dc.w    $E398,$4878,$0001,$3039,$00FF,$9A1C,$48C0,$2F00; $014640
    dc.w    $3002,$48C0,$2F00,$4EB9,$0000,$6A2E,$4878,$0002; $014650
    dc.w    $3039,$00FF,$9A1C,$48C0,$2F00,$3002,$48C0,$2F00; $014660
    dc.w    $4EB9,$0000,$6B78,$4FEF,$0018,$4EB9,$0001,$D748; $014670
    dc.w    $0C43,$000C,$6600,$FBF2,$4CEE,$3CFC,$FFD4,$4E5E; $014680
    dc.w    $4E75,$48E7,$3F3C,$262F,$002C,$246F,$0030,$267C; $014690
    dc.w    $0001,$489E,$287C,$00FF,$BA80,$2A7C,$00FF,$BD4E; $0146A0
    dc.w    $7000,$1012,$E788,$41F4,$0800,$3203,$48C1,$D281; $0146B0
    dc.w    $D1C1,$1E28,$0001,$0287,$0000,$00FF,$7000,$102A; $0146C0
    dc.w    $0001,$E788,$41F4,$0800,$3203,$48C1,$D281,$D1C1; $0146D0
    dc.w    $1C28,$0001,$0286,$0000,$00FF,$4EB9,$0001,$E398; $0146E0
    dc.w    $2F0A,$4EB9,$0000,$74E0,$33C0,$00FF,$BD5C,$2F0A; $0146F0
    dc.w    $4EB9,$0000,$7402,$3A80,$3003,$48C0,$EB88,$2800; $014700
    dc.w    $3239,$00FF,$BD5C,$D241,$D041,$122D,$0001,$207C; $014710
    dc.w    $00FF,$B9E9,$D330,$0000,$4EB9,$0001,$D71C,$2F0A; $014720
    dc.w    $4EBA,$0240,$4E71,$7402,$7A01,$3005,$48C0,$2F00; $014730
    dc.w    $4878,$0005,$4878,$0001,$3003,$48C0,$2F00,$2F0A; $014740
    dc.w    $4EB9,$0001,$9244,$4FEF,$0020,$6000,$00E0,$2F0A; $014750
    dc.w    $3002,$48C0,$2F00,$3003,$48C0,$2F00,$4EBA,$033C; $014760
    dc.w    $4E71,$4FEF,$000C,$3400,$4A42,$665C,$102A,$000A; $014770
    dc.w    $0800,$0001,$6724,$022A,$0001,$000A,$2F3C,$0000; $014780
    dc.w    $8000,$4878,$0002,$4878,$0004,$4878,$0001,$4878; $014790
    dc.w    $0001,$42A7,$4878,$001A,$6022,$002A,$0002,$000A; $0147A0
    dc.w    $4879,$0007,$193C,$4878,$0002,$4878,$0004,$4878; $0147B0
    dc.w    $0001,$4878,$0001,$42A7,$4878,$001B,$4EB9,$0000; $0147C0
    dc.w    $0D64,$4FEF,$001C,$605E,$0C42,$0001,$6772,$0C42; $0147D0
    dc.w    $0002,$6610,$2F0A,$3003,$48C0,$2F00,$4EBA,$0852; $0147E0
    dc.w    $4E71,$6040,$0C42,$0003,$6610,$2F0A,$3003,$48C0; $0147F0
    dc.w    $2F00,$4EBA,$0CF4,$4E71,$602A,$0C42,$0004,$6610; $014800
    dc.w    $2F0A,$3003,$48C0,$2F00,$4EBA,$1434,$4E71,$6014; $014810
    dc.w    $0C42,$0005,$6616,$2F0A,$3003,$48C0,$2F00,$4EBA; $014820
    dc.w    $1BB2,$4E71,$508F,$2F0A,$4E93,$588F,$4EB9,$0001; $014830
    dc.w    $D748,$0C42,$00FF,$6708,$0C42,$0006,$6600,$FF10; $014840
    dc.w    $7000,$1012,$E788,$41F4,$0800,$3203,$48C1,$D281; $014850
    dc.w    $D1C1,$1147,$0001,$7000,$102A,$0001,$E788,$41F4; $014860
    dc.w    $0800,$3203,$48C1,$D281,$D1C1,$1146,$0001,$3039; $014870
    dc.w    $00FF,$BD5C,$D040,$D044,$122D,$0001,$207C,$00FF; $014880
    dc.w    $B9E9,$9330,$0000,$3002,$4CDF,$3CFC,$4E75,$4E56; $014890
    dc.w    $FFF0,$48E7,$3020,$246E,$0008,$76FF,$4879,$0004; $0148A0
    dc.w    $E28A,$4879,$00FF,$1804,$4EB9,$0000,$3FEC,$42A7; $0148B0
    dc.w    $42A7,$4879,$00FF,$1804,$4878,$0018,$4878,$037B; $0148C0
    dc.w    $4EB9,$0001,$D568,$4FEF,$001C,$102A,$000A,$0800; $0148D0
    dc.w    $0002,$6704,$7600,$601A,$102A,$000A,$0800,$0001; $0148E0
    dc.w    $6704,$7610,$600C,$102A,$000A,$0800,$0000,$6702; $0148F0
    dc.w    $7608,$70FF,$B083,$6C3E,$4242,$3002,$48C0,$D083; $014900
    dc.w    $0680,$0000,$637B,$2600,$3002,$D040,$3D83,$00F0; $014910
    dc.w    $5283,$5242,$0C42,$0008,$6DEE,$486E,$FFF0,$4878; $014920
    dc.w    $0002,$4878,$0004,$4878,$0009,$4878,$0002,$42A7; $014930
    dc.w    $4878,$001B,$601C,$2F3C,$0000,$8000,$4878,$0002; $014940
    dc.w    $4878,$0004,$4878,$0009,$4878,$0002,$42A7,$4878; $014950
    dc.w    $001A,$4EB9,$0000,$0D64,$4CEE,$040C,$FFE4,$4E5E; $014960
    dc.w    $4E75,$48E7,$3038,$246F,$0018,$267C,$0003,$B270; $014970
    dc.w    $287C,$0003,$AB2C,$2F0A,$4EB9,$0000,$74E0,$3600; $014980
    dc.w    $2F0A,$4EB9,$0000,$7402,$3400,$4878,$0040,$42A7; $014990
    dc.w    $4878,$0010,$4EB9,$0000,$0D64,$4878,$0010,$4878; $0149A0
    dc.w    $0020,$4879,$0007,$6A1E,$4EB9,$0000,$5092,$2F39; $0149B0
    dc.w    $000A,$1B00,$4879,$00FF,$899C,$4EB9,$0000,$3FEC; $0149C0
    dc.w    $4FEF,$0028,$4878,$0080,$4878,$006A,$4879,$00FF; $0149D0
    dc.w    $899C,$4EB9,$0000,$4668,$4879,$0007,$184C,$4878; $0149E0
    dc.w    $0004,$4878,$001E,$4878,$0001,$4878,$0001,$4878; $0149F0
    dc.w    $0001,$4878,$001B,$4EB9,$0000,$0D64,$4FEF,$0028; $014A00
    dc.w    $4878,$0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003; $014A10
    dc.w    $A942,$4878,$0003,$4878,$0009,$4E94,$207C,$00FF; $014A20
    dc.w    $1278,$1030,$3000,$0280,$0000,$00FF,$E548,$207C; $014A30
    dc.w    $0005,$ECFC,$2F30,$0000,$4879,$0003,$F7B0,$4E93; $014A40
    dc.w    $4878,$0003,$4878,$0011,$4E94,$3002,$48C0,$2F00; $014A50
    dc.w    $4879,$0003,$F7AC,$4E93,$4FEF,$0030,$4878,$0003; $014A60
    dc.w    $4878,$0015,$4E94,$7000,$102A,$0003,$2F00,$4879; $014A70
    dc.w    $0003,$F7A8,$4E93,$4878,$0003,$4878,$001A,$4E94; $014A80
    dc.w    $7000,$302A,$0004,$2F00,$4879,$0003,$F7A4,$4E93; $014A90
    dc.w    $4FEF,$0020,$4CDF,$1C0C,$4E75,$4E56,$FFFC,$48E7; $014AA0
    dc.w    $383C,$242E,$000C,$282E,$0008,$246E,$0010,$267C; $014AB0
    dc.w    $00FF,$13FC,$287C,$0000,$5092,$2A7C,$0000,$0D64; $014AC0
    dc.w    $3004,$48C0,$2F00,$4EB9,$0003,$8544,$588F,$4A40; $014AD0
    dc.w    $6738,$4878,$0004,$4878,$001C,$4878,$0014,$4878; $014AE0
    dc.w    $0001,$4EB9,$0000,$5A04,$4879,$0003,$F7D8,$4EB9; $014AF0
    dc.w    $0003,$B246,$4878,$0020,$4878,$0020,$42A7,$42A7; $014B00
    dc.w    $4EB9,$0003,$A942,$4FEF,$0024,$3D7C,$088A,$FFFE; $014B10
    dc.w    $3D7C,$0448,$FFFC,$4878,$0001,$3002,$48C0,$0680; $014B20
    dc.w    $0000,$0029,$2F00,$486E,$FFFE,$4E94,$4FEF,$000C; $014B30
    dc.w    $42A7,$4EB9,$0001,$E1EC,$588F,$0240,$0FFF,$66F0; $014B40
    dc.w    $4243,$4253,$4279,$00FF,$A7D8,$4878,$0001,$3002; $014B50
    dc.w    $48C0,$0680,$0000,$0029,$2F00,$486E,$FFFE,$4E94; $014B60
    dc.w    $4FEF,$000C,$3003,$2F00,$4878,$0014,$4EB9,$0001; $014B70
    dc.w    $E290,$508F,$3600,$0280,$0000,$00BC,$67E6,$3003; $014B80
    dc.w    $48C0,$7220,$B041,$6720,$7210,$B041,$6744,$7208; $014B90
    dc.w    $B041,$6746,$7204,$B041,$6700,$0090,$0C40,$0080; $014BA0
    dc.w    $6700,$00CA,$6000,$0194,$4253,$2F3C,$0000,$8000; $014BB0
    dc.w    $4878,$0004,$4878,$001C,$4878,$0014,$4878,$0001; $014BC0
    dc.w    $42A7,$4878,$001A,$4E95,$4FEF,$001C,$3002,$6000; $014BD0
    dc.w    $017A,$4253,$343C,$00FF,$60F2,$36BC,$0001,$0C42; $014BE0
    dc.w    $0006,$6C32,$4878,$0001,$3002,$48C0,$0680,$0000; $014BF0
    dc.w    $0029,$2F00,$486E,$FFFC,$4E94,$5242,$4878,$0001; $014C00
    dc.w    $3002,$48C0,$0680,$0000,$0029,$2F00,$486E,$FFFE; $014C10
    dc.w    $4E94,$4FEF,$0018,$0C42,$0006,$6C06,$3002,$48C0; $014C20
    dc.w    $6002,$7006,$3400,$6000,$0112,$36BC,$0001,$4A42; $014C30
    dc.w    $6F32,$4878,$0001,$3002,$48C0,$0680,$0000,$0029; $014C40
    dc.w    $2F00,$486E,$FFFC,$4E94,$5342,$4878,$0001,$3002; $014C50
    dc.w    $48C0,$0680,$0000,$0029,$2F00,$486E,$FFFE,$4E94; $014C60
    dc.w    $4FEF,$0018,$4A42,$6EB4,$7000,$60B8,$4253,$2F3C; $014C70
    dc.w    $0000,$8000,$4878,$0001,$4878,$001E,$4878,$0012; $014C80
    dc.w    $4878,$0001,$42A7,$4878,$001A,$4E95,$7000,$102A; $014C90
    dc.w    $0001,$48C0,$2F00,$7000,$1012,$48C0,$2F00,$3004; $014CA0
    dc.w    $48C0,$2F00,$4EB9,$0001,$A2CE,$4FEF,$0028,$2F3C; $014CB0
    dc.w    $0000,$8000,$4878,$000A,$4878,$001E,$4878,$0012; $014CC0
    dc.w    $4878,$0001,$42A7,$4878,$001A,$4E95,$4878,$0020; $014CD0
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$3004; $014CE0
    dc.w    $48C0,$2F00,$4EB9,$0003,$8544,$4FEF,$0030,$4A40; $014CF0
    dc.w    $6738,$4878,$0004,$4878,$001C,$4878,$0014,$4878; $014D00
    dc.w    $0001,$4EB9,$0000,$5A04,$4879,$0003,$F7B4,$4EB9; $014D10
    dc.w    $0003,$B246,$4878,$0020,$4878,$0020,$42A7,$42A7; $014D20
    dc.w    $4EB9,$0003,$A942,$4FEF,$0024,$42A7,$4EB9,$0001; $014D30
    dc.w    $E1EC,$588F,$0240,$0FFF,$66F0,$4878,$0003,$4878; $014D40
    dc.w    $000E,$4E95,$508F,$6000,$FE02,$4CEE,$3C1C,$FFE0; $014D50
    dc.w    $4E5E,$4E75,$48E7,$3800,$242F,$0010,$42A7,$4EB9; $014D60
    dc.w    $0001,$E1EC,$588F,$3800,$6022,$42A7,$4EB9,$0001; $014D70
    dc.w    $E1EC,$588F,$3600,$B843,$6616,$4878,$0001,$4878; $014D80
    dc.w    $000E,$4EB9,$0000,$0D64,$508F,$5342,$4A42,$66DA; $014D90
    dc.w    $4CDF,$001C,$4E75,$4E56,$FFAC,$48E7,$3F3C,$282E; $014DA0
    dc.w    $0010,$2A2E,$000C,$2C2E,$0008,$287C,$00FF,$13FC; $014DB0
    dc.w    $2A7C,$00FF,$A7D8,$4247,$3006,$C0FC,$0024,$207C; $014DC0
    dc.w    $00FF,$0018,$41F0,$0000,$2648,$2F3C,$0000,$8000; $014DD0
    dc.w    $4878,$000A,$4878,$0020,$4878,$0013,$42A7,$42A7; $014DE0
    dc.w    $4878,$001A,$4EB9,$0000,$0D64,$4FEF,$001C,$4878; $014DF0
    dc.w    $077D,$4878,$000A,$4878,$0020,$4878,$0013,$42A7; $014E00
    dc.w    $4878,$0001,$4878,$001A,$4EB9,$0000,$0D64,$4FEF; $014E10
    dc.w    $001C,$3006,$C0FC,$0320,$207C,$00FF,$9A20,$41F0; $014E20
    dc.w    $0000,$2448,$4242,$4243,$6020,$BA12,$6706,$BA2A; $014E30
    dc.w    $0001,$6610,$3003,$D040,$3D82,$00B0,$B842,$6602; $014E40
    dc.w    $3803,$5243,$5242,$7014,$D5C0,$7000,$102B,$0004; $014E50
    dc.w    $7200,$122B,$0005,$D081,$3202,$48C1,$B081,$6ECA; $014E60
    dc.w    $4A43,$6F00,$01A2,$3004,$D040,$3036,$00B0,$C0FC; $014E70
    dc.w    $0014,$3206,$C2FC,$0320,$D041,$207C,$00FF,$9A20; $014E80
    dc.w    $41F0,$0000,$2448,$4EB9,$0003,$A9AC,$4878,$0001; $014E90
    dc.w    $4878,$0001,$4878,$0013,$42A7,$3006,$48C0,$2F00; $014EA0
    dc.w    $2F0A,$4EB9,$0001,$9660,$426E,$FFAC,$42A7,$4EB9; $014EB0
    dc.w    $0001,$E1EC,$4FEF,$001C,$4A40,$6704,$7A01,$6002; $014EC0
    dc.w    $7A00,$426E,$FFAE,$4254,$4255,$3404,$4A47,$6758; $014ED0
    dc.w    $3002,$D040,$3036,$00B0,$C0FC,$0014,$3206,$C2FC; $014EE0
    dc.w    $0320,$D041,$207C,$00FF,$9A20,$41F0,$0000,$2448; $014EF0
    dc.w    $4EB9,$0003,$A9AC,$4878,$0001,$302E,$FFAC,$48C0; $014F00
    dc.w    $2F00,$4878,$0013,$42A7,$3006,$48C0,$2F00,$2F0A; $014F10
    dc.w    $4EB9,$0001,$9660,$4878,$0020,$6100,$FE38,$4FEF; $014F20
    dc.w    $001C,$426E,$FFAC,$4247,$7801,$7000,$102A,$0001; $014F30
    dc.w    $48C0,$2F00,$7000,$1012,$48C0,$2F00,$4EB9,$0000; $014F40
    dc.w    $7158,$508F,$0C40,$0001,$4A45,$6722,$42A7,$4EB9; $014F50
    dc.w    $0001,$E1EC,$588F,$4A40,$6714,$4878,$0002,$4878; $014F60
    dc.w    $000E,$4EB9,$0000,$0D64,$508F,$6000,$FF60,$4245; $014F70
    dc.w    $302E,$FFAE,$2F00,$4878,$000A,$4EB9,$0001,$E290; $014F80
    dc.w    $508F,$0240,$0033,$3D40,$FFAE,$0C44,$0001,$302E; $014F90
    dc.w    $FFAE,$48C0,$7220,$B041,$6714,$7210,$B041,$671C; $014FA0
    dc.w    $7202,$B041,$671C,$7201,$B041,$6736,$604C,$4254; $014FB0
    dc.w    $4255,$3002,$D040,$3036,$00B0,$606A,$4254,$4255; $014FC0
    dc.w    $6060,$38BC,$0001,$0C43,$0001,$6F32,$5242,$3002; $014FD0
    dc.w    $48C0,$3203,$48C1,$5381,$B081,$6F02,$4242,$7E01; $014FE0
    dc.w    $601C,$38BC,$0001,$0C43,$0001,$6F12,$5342,$4A42; $014FF0
    dc.w    $6CEC,$3403,$0642,$FFFF,$60E4,$4254,$4255,$4878; $015000
    dc.w    $0004,$6000,$FF5A,$4878,$0001,$42A7,$4878,$0002; $015010
    dc.w    $4879,$0003,$F7FC,$3006,$48C0,$2F00,$4EB9,$0000; $015020
    dc.w    $7912,$303C,$00FF,$4CEE,$3CFC,$FF84,$4E5E,$4E75; $015030
    dc.w    $4E56,$FFD8,$48E7,$3F3C,$2A2E,$0008,$246E,$000C; $015040
    dc.w    $49EE,$FFE0,$2A7C,$0000,$0D64,$2F0A,$4EB9,$0000; $015050
    dc.w    $7402,$3D40,$FFD8,$2F3C,$0000,$8000,$4878,$0002; $015060
    dc.w    $4878,$0004,$4878,$0009,$4878,$0002,$42A7,$4878; $015070
    dc.w    $001A,$4E95,$4FEF,$0020,$3005,$EB48,$207C,$00FF; $015080
    dc.w    $B9E8,$41F0,$0000,$2648,$4243,$4242,$4A13,$6750; $015090
    dc.w    $7000,$102A,$0001,$48C0,$2F00,$7000,$1012,$48C0; $0150A0
    dc.w    $2F00,$3002,$48C0,$2F00,$4EB9,$0000,$818A,$4FEF; $0150B0
    dc.w    $000C,$7201,$B280,$6628,$3003,$48C0,$D080,$2040; $0150C0
    dc.w    $3982,$8800,$2F0A,$4EB9,$0000,$74E0,$588F,$0280; $0150D0
    dc.w    $0000,$FFFF,$3202,$48C1,$B081,$6602,$3E03,$5243; $0150E0
    dc.w    $548B,$5242,$0C42,$0010,$6DA2,$3003,$0640,$FFFF; $0150F0
    dc.w    $3D40,$FFDC,$4A6E,$FFDC,$6608,$3D7C,$0001,$FFDA; $015100
    dc.w    $6004,$426E,$FFDA,$3607,$3005,$EB48,$3207,$48C1; $015110
    dc.w    $D281,$2041,$3234,$8800,$D241,$D041,$122E,$FFD9; $015120
    dc.w    $207C,$00FF,$B9E9,$9330,$0000,$42A7,$4EB9,$0001; $015130
    dc.w    $E1EC,$588F,$4A40,$6704,$7401,$6002,$7400,$426E; $015140
    dc.w    $FFDE,$4279,$00FF,$13FC,$4279,$00FF,$A7D8,$7C01; $015150
    dc.w    $4244,$5244,$0C44,$0001,$6668,$2F3C,$0000,$8000; $015160
    dc.w    $4878,$0001,$4878,$0001,$4878,$0094,$4878,$0008; $015170
    dc.w    $4878,$0039,$4878,$0772,$4EB9,$0001,$E044,$4878; $015180
    dc.w    $0001,$4878,$000E,$4E95,$4FEF,$0024,$2F3C,$0000; $015190
    dc.w    $8000,$4878,$0001,$4878,$0001,$4878,$0094,$4878; $0151A0
    dc.w    $0080,$4878,$003A,$4878,$0773,$4EB9,$0001,$E044; $0151B0
    dc.w    $4FEF,$001C,$4878,$0001,$4878,$000E,$4E95,$508F; $0151C0
    dc.w    $6020,$0C44,$000F,$6612,$4878,$0002,$4878,$0039; $0151D0
    dc.w    $4EB9,$0001,$E0B8,$508F,$60DA,$0C44,$001E,$6602; $0151E0
    dc.w    $4244,$0C46,$0001,$6662,$4878,$0003,$4878,$0001; $0151F0
    dc.w    $4878,$0013,$4878,$0002,$42A7,$3003,$48C0,$D080; $015200
    dc.w    $2040,$3034,$8800,$48C0,$2F00,$3005,$48C0,$2F00; $015210
    dc.w    $4EB9,$0000,$7D92,$4FEF,$001C,$3005,$48C0,$2F00; $015220
    dc.w    $4878,$0007,$42A7,$4878,$0009,$4878,$0002,$3003; $015230
    dc.w    $48C0,$D080,$2040,$3034,$8800,$48C0,$2F00,$4EB9; $015240
    dc.w    $0003,$A5A8,$4FEF,$0018,$4246,$4A42,$671E,$42A7; $015250
    dc.w    $4EB9,$0001,$E1EC,$588F,$4A40,$6710,$4878,$0003; $015260
    dc.w    $4878,$000E,$4E95,$508F,$6000,$FEE8,$4242,$302E; $015270
    dc.w    $FFDE,$2F00,$4878,$000A,$4EB9,$0001,$E290,$508F; $015280
    dc.w    $0240,$00BC,$3D40,$FFDE,$48C0,$7220,$B041,$671C; $015290
    dc.w    $7210,$B041,$6700,$014C,$7204,$B041,$6700,$0184; $0152A0
    dc.w    $7208,$B041,$6700,$0192,$6000,$01A4,$4279,$00FF; $0152B0
    dc.w    $13FC,$4279,$00FF,$A7D8,$B647,$6700,$01AE,$3005; $0152C0
    dc.w    $EB48,$3203,$48C1,$D281,$2041,$3234,$8800,$D241; $0152D0
    dc.w    $D041,$207C,$00FF,$B9E9,$1030,$0000,$0280,$0000; $0152E0
    dc.w    $00FF,$4A40,$6F00,$00F8,$4878,$0020,$4878,$0020; $0152F0
    dc.w    $42A7,$42A7,$4EB9,$0003,$A942,$3003,$48C0,$D080; $015300
    dc.w    $2040,$3034,$8800,$48C0,$2F00,$2F0A,$4EB9,$0000; $015310
    dc.w    $7390,$3005,$EB48,$3203,$48C1,$D281,$2041,$3234; $015320
    dc.w    $8800,$D241,$D041,$207C,$00FF,$B9E9,$1430,$0000; $015330
    dc.w    $0282,$0000,$00FF,$2F0A,$4EB9,$0000,$7402,$4FEF; $015340
    dc.w    $001C,$3202,$48C1,$B081,$6C0C,$2F0A,$4EB9,$0000; $015350
    dc.w    $7402,$588F,$6004,$3002,$48C0,$3400,$48C0,$2F00; $015360
    dc.w    $2F0A,$4EB9,$0000,$73A6,$4878,$0010,$4878,$000E; $015370
    dc.w    $4EB9,$0003,$AB2C,$3002,$48C0,$2F00,$4879,$0003; $015380
    dc.w    $F838,$4EB9,$0003,$B246,$42A7,$4878,$0002,$4878; $015390
    dc.w    $0009,$4878,$0010,$2F0A,$4EB9,$0001,$99FA,$4FEF; $0153A0
    dc.w    $002C,$42A7,$4878,$0002,$4878,$000D,$4878,$0010; $0153B0
    dc.w    $2F0A,$4EB9,$0001,$9DE6,$4878,$064C,$4878,$0008; $0153C0
    dc.w    $4878,$000E,$4878,$0009,$4878,$0002,$4878,$0001; $0153D0
    dc.w    $4878,$001A,$4E95,$4FEF,$0030,$6000,$008E,$4246; $0153E0
    dc.w    $6078,$4279,$00FF,$13FC,$4279,$00FF,$A7D8,$B647; $0153F0
    dc.w    $6778,$3005,$48C0,$2F00,$4878,$0007,$42A7,$4878; $015400
    dc.w    $0009,$4878,$0002,$3007,$48C0,$D080,$2040,$3034; $015410
    dc.w    $8800,$48C0,$2F00,$4EB9,$0003,$A5A8,$4FEF,$0018; $015420
    dc.w    $6048,$33FC,$0001,$00FF,$13FC,$7C01,$5343,$4A43; $015430
    dc.w    $6C28,$362E,$FFDC,$6022,$33FC,$0001,$00FF,$13FC; $015440
    dc.w    $7C01,$5243,$B66E,$FFDC,$6F10,$4243,$600C,$4279; $015450
    dc.w    $00FF,$13FC,$4279,$00FF,$A7D8,$0C6E,$0001,$FFDA; $015460
    dc.w    $6600,$FDFA,$4246,$6000,$FDF4,$4878,$0002,$4878; $015470
    dc.w    $0039,$4EB9,$0001,$E0B8,$2F3C,$0000,$8000,$4878; $015480
    dc.w    $000D,$4878,$0020,$4878,$0013,$42A7,$4878,$0001; $015490
    dc.w    $4878,$001A,$4E95,$4FEF,$0024,$2F3C,$0000,$8000; $0154A0
    dc.w    $4878,$000D,$4878,$0020,$4878,$0013,$42A7,$42A7; $0154B0
    dc.w    $4878,$001A,$4E95,$3005,$EB48,$3207,$48C1,$D281; $0154C0
    dc.w    $2041,$3234,$8800,$D241,$D041,$122E,$FFD9,$207C; $0154D0
    dc.w    $00FF,$B9E9,$D330,$0000,$4EB9,$0001,$DE92,$4CEE; $0154E0
    dc.w    $3CFC,$FFB0,$4E5E,$4E75,$4E56,$FFC8,$48E7,$3F3C; $0154F0
    dc.w    $246E,$000C,$287C,$0000,$0D64,$4BEE,$FFD2,$7000; $015500
    dc.w    $1012,$E748,$322E,$000A,$D241,$D041,$207C,$00FF; $015510
    dc.w    $BA81,$1030,$0000,$0280,$0000,$00FF,$7200,$122A; $015520
    dc.w    $0003,$9041,$3D40,$FFCE,$7000,$102A,$0001,$E748; $015530
    dc.w    $322E,$000A,$D241,$D041,$207C,$00FF,$BA81,$1030; $015540
    dc.w    $0000,$0280,$0000,$00FF,$7200,$122A,$0003,$9041; $015550
    dc.w    $3D40,$FFCC,$2F0A,$4EB9,$0000,$74E0,$0280,$0000; $015560
    dc.w    $FFFF,$D080,$322E,$000A,$EB49,$D081,$207C,$00FF; $015570
    dc.w    $B9E8,$D1C0,$2648,$7000,$102B,$0001,$3A80,$7C00; $015580
    dc.w    $1C2A,$000B,$0C55,$0009,$6C06,$3015,$48C0,$6002; $015590
    dc.w    $7009,$3A80,$2F0A,$4EB9,$0000,$7402,$3600,$3D40; $0155A0
    dc.w    $FFFE,$4878,$0020,$4878,$0020,$42A7,$42A7,$4EB9; $0155B0
    dc.w    $0003,$A942,$7E12,$4242,$3002,$0640,$2D7F,$3202; $0155C0
    dc.w    $D241,$3D80,$10D6,$5242,$0C42,$0014,$6DEA,$4878; $0155D0
    dc.w    $0010,$4878,$0010,$4879,$0007,$6A3E,$4EB9,$0000; $0155E0
    dc.w    $5092,$2F39,$000A,$1B04,$4879,$00FF,$1804,$4EB9; $0155F0
    dc.w    $0000,$3FEC,$4FEF,$002C,$4878,$0059,$4878,$0011; $015600
    dc.w    $4879,$00FF,$1804,$4EB9,$0000,$4668,$4FEF,$000C; $015610
    dc.w    $3015,$48C0,$3203,$48C1,$9081,$6F2E,$4879,$0007; $015620
    dc.w    $1A14,$4878,$0004,$4878,$000A,$3007,$48C0,$2F00; $015630
    dc.w    $4878,$0001,$4878,$0001,$4878,$001B,$4E94,$4FEF; $015640
    dc.w    $001C,$3D7C,$0001,$FFD0,$602A,$4879,$0007,$19C4; $015650
    dc.w    $4878,$0004,$4878,$000A,$3007,$48C0,$2F00,$4878; $015660
    dc.w    $0001,$4878,$0001,$4878,$001B,$4E94,$4FEF,$001C; $015670
    dc.w    $426E,$FFD0,$3007,$48C0,$5480,$2F00,$4878,$0004; $015680
    dc.w    $4EB9,$0003,$AB2C,$7000,$102B,$0001,$48C0,$3203; $015690
    dc.w    $48C1,$9081,$2F00,$4879,$0003,$F854,$4EB9,$0003; $0156A0
    dc.w    $B270,$42A7,$4EB9,$0001,$E1EC,$4FEF,$0014,$4A40; $0156B0
    dc.w    $6704,$7401,$6002,$7400,$426E,$FFD4,$4279,$00FF; $0156C0
    dc.w    $13FC,$4279,$00FF,$A7D8,$4244,$426E,$FFCA,$6000; $0156D0
    dc.w    $04E0,$4878,$0010,$4878,$000E,$4EB9,$0003,$AB2C; $0156E0
    dc.w    $3003,$48C0,$2F00,$4879,$0003,$F850,$4EB9,$0003; $0156F0
    dc.w    $B246,$4FEF,$0010,$4A42,$6710,$42A7,$4EB9,$0001; $015700
    dc.w    $E1EC,$588F,$4A40,$6600,$049C,$4242,$526E,$FFCA; $015710
    dc.w    $0C6E,$0001,$FFCA,$667C,$2F3C,$0000,$8000,$4878; $015720
    dc.w    $0001,$4878,$0001,$3007,$48C0,$E788,$0680,$0000; $015730
    dc.w    $000C,$2F00,$4878,$0008,$4878,$0039,$4878,$0772; $015740
    dc.w    $4EB9,$0001,$E044,$4878,$0001,$4878,$000E,$4E94; $015750
    dc.w    $4FEF,$0024,$2F3C,$0000,$8000,$4878,$0001,$4878; $015760
    dc.w    $0001,$3007,$48C0,$E788,$0680,$0000,$000C,$2F00; $015770
    dc.w    $4878,$0050,$4878,$003A,$4878,$0773,$4EB9,$0001; $015780
    dc.w    $E044,$4FEF,$001C,$4878,$0001,$4878,$000E,$4E94; $015790
    dc.w    $508F,$6026,$0C6E,$000F,$FFCA,$6612,$4878,$0002; $0157A0
    dc.w    $4878,$0039,$4EB9,$0001,$E0B8,$508F,$60D8,$0C6E; $0157B0
    dc.w    $001E,$FFCA,$6604,$426E,$FFCA,$302E,$FFD4,$2F00; $0157C0
    dc.w    $4878,$000A,$4EB9,$0001,$E290,$508F,$0240,$003C; $0157D0
    dc.w    $3D40,$FFD4,$48C0,$7220,$B041,$671C,$7210,$B041; $0157E0
    dc.w    $6700,$0102,$7204,$B041,$6700,$012A,$7208,$B041; $0157F0
    dc.w    $6700,$027E,$6000,$03A2,$4279,$00FF,$13FC,$4279; $015800
    dc.w    $00FF,$A7D8,$B66E,$FFFE,$6700,$03AE,$3003,$48C0; $015810
    dc.w    $2F00,$2F0A,$4EB9,$0000,$73A6,$7000,$102A,$0003; $015820
    dc.w    $3206,$48C1,$B081,$6C08,$7000,$102A,$0003,$6004; $015830
    dc.w    $3006,$48C0,$1540,$0003,$102E,$FFCF,$D02A,$0003; $015840
    dc.w    $7200,$1212,$E749,$2047,$3E2E,$000A,$DE47,$CF88; $015850
    dc.w    $D248,$207C,$00FF,$BA81,$1180,$1000,$102E,$FFCD; $015860
    dc.w    $D02A,$0003,$7200,$122A,$0001,$E749,$2047,$3E2E; $015870
    dc.w    $000A,$DE47,$CF88,$D248,$207C,$00FF,$BA81,$1180; $015880
    dc.w    $1000,$4878,$0008,$4878,$0005,$4EB9,$0003,$AB2C; $015890
    dc.w    $302E,$FFCE,$48C0,$7200,$122A,$0003,$48C1,$D081; $0158A0
    dc.w    $2F00,$4879,$0003,$F84C,$4EB9,$0003,$B246,$4878; $0158B0
    dc.w    $0008,$4878,$0015,$4EB9,$0003,$AB2C,$4FEF,$0020; $0158C0
    dc.w    $302E,$FFCC,$48C0,$7200,$122A,$0003,$48C1,$D081; $0158D0
    dc.w    $2F00,$4879,$0003,$F848,$4EB9,$0003,$B246,$508F; $0158E0
    dc.w    $6000,$02D6,$4279,$00FF,$13FC,$4279,$00FF,$A7D8; $0158F0
    dc.w    $4878,$0010,$4878,$000E,$4EB9,$0003,$AB2C,$508F; $015900
    dc.w    $2F0A,$4EB9,$0000,$7402,$588F,$2F00,$4879,$0003; $015910
    dc.w    $F844,$60C4,$33FC,$0001,$00FF,$13FC,$5343,$3015; $015920
    dc.w    $48C0,$3203,$48C1,$9081,$6F38,$0C55,$0001,$6F32; $015930
    dc.w    $4A6E,$FFD0,$662C,$4879,$0007,$1A14,$4878,$0004; $015940
    dc.w    $4878,$000A,$3007,$48C0,$2F00,$4878,$0001,$4878; $015950
    dc.w    $0001,$4878,$001B,$4E94,$4FEF,$001C,$3D7C,$0001; $015960
    dc.w    $FFD0,$4A43,$6F18,$42A7,$3007,$48C0,$5780,$2F00; $015970
    dc.w    $4878,$000E,$4EB9,$0001,$ACBA,$4FEF,$000C,$0C43; $015980
    dc.w    $0001,$6F06,$3003,$48C0,$6002,$7001,$3600,$3007; $015990
    dc.w    $48C0,$5480,$2F00,$4878,$0004,$4EB9,$0003,$AB2C; $0159A0
    dc.w    $7000,$102B,$0001,$48C0,$3203,$48C1,$9081,$2F00; $0159B0
    dc.w    $4879,$0003,$F840,$4EB9,$0003,$B270,$2F0A,$4EB9; $0159C0
    dc.w    $0000,$7412,$4FEF,$0014,$48C0,$3203,$48C1,$4EB9; $0159D0
    dc.w    $0003,$E05C,$7214,$4EB9,$0003,$E08A,$3C00,$3A06; $0159E0
    dc.w    $48C5,$5F85,$6F08,$3A06,$48C5,$5F85,$6002,$7A00; $0159F0
    dc.w    $0C45,$0007,$6C30,$4878,$077E,$4878,$0001,$3005; $015A00
    dc.w    $48C0,$7207,$9280,$2F01,$4878,$0010,$3005,$48C0; $015A10
    dc.w    $0680,$0000,$0014,$2F00,$4878,$0001,$4878,$001A; $015A20
    dc.w    $4E94,$4FEF,$001C,$0C46,$0007,$6C06,$3A06,$48C5; $015A30
    dc.w    $6002,$7A07,$0C45,$0007,$6C00,$016A,$4878,$077E; $015A40
    dc.w    $4878,$0001,$3005,$48C0,$7207,$9280,$2F01,$4878; $015A50
    dc.w    $000F,$3005,$48C0,$0680,$0000,$0014,$2F00,$4878; $015A60
    dc.w    $0001,$4878,$001A,$4E94,$4FEF,$001C,$6000,$0136; $015A70
    dc.w    $33FC,$0001,$00FF,$13FC,$5243,$B655,$6E18,$4878; $015A80
    dc.w    $0001,$3007,$48C0,$2F00,$4878,$0001,$4EB9,$0001; $015A90
    dc.w    $ACBA,$4FEF,$000C,$B655,$6C04,$3003,$6002,$3015; $015AA0
    dc.w    $48C0,$3600,$3007,$48C0,$5480,$2F00,$4878,$0004; $015AB0
    dc.w    $4EB9,$0003,$AB2C,$7000,$102B,$0001,$48C0,$3203; $015AC0
    dc.w    $48C1,$9081,$2F00,$4879,$0003,$F83C,$4EB9,$0003; $015AD0
    dc.w    $B270,$4FEF,$0010,$3015,$48C0,$3203,$48C1,$9081; $015AE0
    dc.w    $6E32,$0C6E,$0001,$FFD0,$662A,$4879,$0007,$19C4; $015AF0
    dc.w    $4878,$0004,$4878,$000A,$3007,$48C0,$2F00,$4878; $015B00
    dc.w    $0001,$4878,$0001,$4878,$001B,$4E94,$4FEF,$001C; $015B10
    dc.w    $426E,$FFD0,$2F0A,$4EB9,$0000,$7412,$48C0,$3203; $015B20
    dc.w    $48C1,$4EB9,$0003,$E05C,$7214,$4EB9,$0003,$E08A; $015B30
    dc.w    $3C00,$0C46,$0007,$6C06,$3A06,$48C5,$6002,$7A07; $015B40
    dc.w    $4878,$033E,$4878,$0001,$3005,$48C0,$2F00,$4878; $015B50
    dc.w    $000F,$4878,$0014,$4878,$0001,$4878,$001A,$4E94; $015B60
    dc.w    $4FEF,$0020,$3A06,$48C5,$5F85,$7007,$B085,$6F08; $015B70
    dc.w    $3A06,$48C5,$5F85,$6002,$7A07,$4A45,$6F26,$4878; $015B80
    dc.w    $033E,$4878,$0001,$3005,$48C0,$2F00,$4878,$0010; $015B90
    dc.w    $4878,$0014,$6000,$FEC8,$4279,$00FF,$13FC,$4279; $015BA0
    dc.w    $00FF,$A7D8,$4878,$0003,$4878,$000E,$4E94,$508F; $015BB0
    dc.w    $0C44,$00FF,$6600,$FB1C,$4878,$0002,$4878,$0039; $015BC0
    dc.w    $4EB9,$0001,$E0B8,$42A7,$4878,$0001,$4878,$0009; $015BD0
    dc.w    $4878,$0010,$2F0A,$4EB9,$0001,$99FA,$42A7,$4878; $015BE0
    dc.w    $0001,$4878,$000D,$4878,$0010,$2F0A,$4EB9,$0001; $015BF0
    dc.w    $9DE6,$4FEF,$0030,$2F3C,$0000,$8000,$4878,$000D; $015C00
    dc.w    $4878,$0020,$4878,$0012,$42A7,$42A7,$4878,$001A; $015C10
    dc.w    $4E94,$4FEF,$001C,$2F3C,$0000,$8000,$4878,$000D; $015C20
    dc.w    $4878,$0020,$4878,$0012,$42A7,$4878,$0001,$4878; $015C30
    dc.w    $001A,$4E94,$4CEE,$3CFC,$FFA0,$4E5E,$4E75,$4E56; $015C40
    dc.w    $FF84,$48E7,$3F3C,$286E,$000C,$4BEE,$FFFA,$7000; $015C50
    dc.w    $1014,$E748,$322E,$000A,$D241,$D041,$207C,$00FF; $015C60
    dc.w    $BA80,$1430,$0000,$0282,$0000,$00FF,$7000,$1014; $015C70
    dc.w    $E748,$322E,$000A,$D241,$D041,$207C,$00FF,$BA81; $015C80
    dc.w    $1030,$0000,$0280,$0000,$00FF,$9440,$7000,$102C; $015C90
    dc.w    $0001,$E748,$322E,$000A,$D241,$D041,$207C,$00FF; $015CA0
    dc.w    $BA80,$1630,$0000,$0283,$0000,$00FF,$7000,$102C; $015CB0
    dc.w    $0001,$E748,$322E,$000A,$D241,$D041,$207C,$00FF; $015CC0
    dc.w    $BA81,$1030,$0000,$0280,$0000,$00FF,$9640,$B443; $015CD0
    dc.w    $6C04,$3002,$6002,$3003,$48C0,$3400,$7000,$102C; $015CE0
    dc.w    $0003,$D440,$7800,$182C,$000B,$0C44,$000E,$6C06; $015CF0
    dc.w    $3004,$48C0,$6002,$700E,$3800,$B842,$6C04,$3004; $015D00
    dc.w    $6002,$3002,$48C0,$3800,$7400,$142C,$0003,$B444; $015D10
    dc.w    $6C04,$3002,$6002,$3004,$48C0,$1940,$0003,$0C2C; $015D20
    dc.w    $0001,$0003,$6308,$7600,$162C,$0003,$6002,$7601; $015D30
    dc.w    $0C43,$0007,$6C06,$3003,$48C0,$6002,$7007,$3A80; $015D40
    dc.w    $4878,$033D,$4878,$0001,$3015,$48C0,$2F00,$4878; $015D50
    dc.w    $000F,$4878,$0014,$4878,$0001,$4878,$001A,$4EB9; $015D60
    dc.w    $0000,$0D64,$4FEF,$001C,$3003,$0640,$FFF9,$3A80; $015D70
    dc.w    $4A55,$6F28,$4878,$033D,$4878,$0001,$3015,$48C0; $015D80
    dc.w    $2F00,$4878,$0010,$4878,$0014,$4878,$0001,$4878; $015D90
    dc.w    $001A,$4EB9,$0000,$0D64,$4FEF,$001C,$4242,$3002; $015DA0
    dc.w    $D040,$41F6,$0088,$2648,$3002,$D040,$41F6,$00C0; $015DB0
    dc.w    $2448,$601C,$B443,$6C0A,$34BC,$8541,$36BC,$8542; $015DC0
    dc.w    $6008,$34BC,$8000,$36BC,$8543,$548A,$548B,$5242; $015DD0
    dc.w    $B444,$6DE0,$3002,$D040,$4276,$00C0,$3002,$D040; $015DE0
    dc.w    $4276,$0088,$7C01,$7A12,$4878,$0004,$4878,$0014; $015DF0
    dc.w    $3005,$2F00,$3006,$2F00,$4EB9,$0000,$5A04,$4878; $015E00
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $015E10
    dc.w    $3005,$48C0,$5280,$2F00,$3006,$48C0,$0680,$0000; $015E20
    dc.w    $0012,$2F00,$4EB9,$0003,$AB2C,$4FEF,$0028,$3005; $015E30
    dc.w    $5240,$2F00,$3006,$0640,$0012,$2F00,$4878,$0002; $015E40
    dc.w    $4878,$0003,$4EB9,$0000,$595E,$7000,$1014,$E748; $015E50
    dc.w    $322E,$000A,$D241,$D041,$207C,$00FF,$BA81,$1030; $015E60
    dc.w    $0000,$0280,$0000,$00FF,$9043,$3D40,$FF86,$7000; $015E70
    dc.w    $102C,$0001,$E748,$322E,$000A,$D241,$D041,$207C; $015E80
    dc.w    $00FF,$BA81,$1E30,$0000,$0287,$0000,$00FF,$9E43; $015E90
    dc.w    $42A7,$4EB9,$0001,$E1EC,$4FEF,$0014,$4A40,$6704; $015EA0
    dc.w    $7401,$6002,$7400,$426E,$FFFE,$4279,$00FF,$13FC; $015EB0
    dc.w    $4279,$00FF,$A7D8,$7000,$3D40,$FF84,$0280,$0000; $015EC0
    dc.w    $FFFF,$4878,$0008,$4878,$0005,$4EB9,$0003,$AB2C; $015ED0
    dc.w    $302E,$FF86,$48C0,$3203,$48C1,$D081,$2F00,$4879; $015EE0
    dc.w    $0003,$F870,$4EB9,$0003,$B246,$4878,$0008,$4878; $015EF0
    dc.w    $0015,$4EB9,$0003,$AB2C,$3007,$48C0,$3203,$48C1; $015F00
    dc.w    $D081,$2F00,$4879,$0003,$F86C,$4EB9,$0003,$B246; $015F10
    dc.w    $4878,$000F,$4878,$001B,$4EB9,$0003,$AB2C,$3003; $015F20
    dc.w    $48C0,$2F00,$4879,$0003,$F868,$4EB9,$0003,$B270; $015F30
    dc.w    $4FEF,$0030,$3005,$48C0,$5280,$2F00,$3006,$48C0; $015F40
    dc.w    $0680,$0000,$0010,$2F00,$4EB9,$0003,$AB2C,$3003; $015F50
    dc.w    $48C0,$2F00,$4879,$0003,$F864,$4EB9,$0003,$B270; $015F60
    dc.w    $486E,$FFC0,$4878,$0001,$3004,$48C0,$2F00,$3005; $015F70
    dc.w    $48C0,$5280,$2F00,$3006,$48C0,$5280,$2F00,$42A7; $015F80
    dc.w    $4878,$001B,$4EB9,$0000,$0D64,$4FEF,$002C,$486E; $015F90
    dc.w    $FF88,$4878,$0001,$3004,$48C0,$2F00,$3005,$48C0; $015FA0
    dc.w    $5480,$2F00,$3006,$48C0,$5280,$2F00,$42A7,$4878; $015FB0
    dc.w    $001B,$4EB9,$0000,$0D64,$4FEF,$001C,$4A42,$6722; $015FC0
    dc.w    $42A7,$4EB9,$0001,$E1EC,$588F,$4A40,$6714,$4878; $015FD0
    dc.w    $0003,$4878,$000E,$4EB9,$0000,$0D64,$508F,$6000; $015FE0
    dc.w    $FEE2,$4242,$526E,$FF84,$0C6E,$0001,$FF84,$6670; $015FF0
    dc.w    $2F3C,$0000,$8000,$4878,$0001,$4878,$0001,$4878; $016000
    dc.w    $007C,$4878,$0098,$4878,$0039,$4878,$0772,$4EB9; $016010
    dc.w    $0001,$E044,$4878,$0001,$4878,$000E,$4EB9,$0000; $016020
    dc.w    $0D64,$4FEF,$0024,$2F3C,$0000,$8000,$4878,$0001; $016030
    dc.w    $4878,$0001,$4878,$007C,$4878,$00F0,$4878,$003A; $016040
    dc.w    $4878,$0773,$4EB9,$0001,$E044,$4FEF,$001C,$4878; $016050
    dc.w    $0001,$4878,$000E,$4EB9,$0000,$0D64,$508F,$6026; $016060
    dc.w    $0C6E,$000F,$FF84,$6612,$4878,$0002,$4878,$0039; $016070
    dc.w    $4EB9,$0001,$E0B8,$508F,$60D4,$0C6E,$001E,$FF84; $016080
    dc.w    $6604,$426E,$FF84,$302E,$FFFE,$2F00,$4878,$000A; $016090
    dc.w    $4EB9,$0001,$E290,$508F,$0240,$003C,$3D40,$FFFE; $0160A0
    dc.w    $48C0,$7220,$B041,$671A,$7210,$B041,$676C,$7204; $0160B0
    dc.w    $B041,$6700,$0112,$7208,$B041,$6700,$0226,$6000; $0160C0
    dc.w    $02AC,$4279,$00FF,$13FC,$4279,$00FF,$A7D8,$1943; $0160D0
    dc.w    $0003,$102E,$FF87,$D003,$7200,$1214,$E749,$2047; $0160E0
    dc.w    $3E2E,$000A,$DE47,$CF88,$D248,$207C,$00FF,$BA81; $0160F0
    dc.w    $1180,$1000,$1007,$D003,$7200,$122C,$0001,$E749; $016100
    dc.w    $2047,$3E2E,$000A,$DE47,$CF88,$D248,$207C,$00FF; $016110
    dc.w    $BA81,$1180,$1000,$6000,$0264,$4279,$00FF,$13FC; $016120
    dc.w    $4279,$00FF,$A7D8,$3003,$48C0,$7200,$122C,$0003; $016130
    dc.w    $B081,$6700,$0248,$42A7,$4878,$0001,$4878,$000D; $016140
    dc.w    $4878,$0010,$2F0C,$4EB9,$0001,$9DE6,$4878,$0008; $016150
    dc.w    $4878,$0005,$4EB9,$0003,$AB2C,$302E,$FF86,$48C0; $016160
    dc.w    $3203,$48C1,$D081,$2F00,$4879,$0003,$F860,$4EB9; $016170
    dc.w    $0003,$B246,$4878,$0008,$4878,$0015,$4EB9,$0003; $016180
    dc.w    $AB2C,$4FEF,$002C,$3007,$48C0,$3203,$48C1,$D081; $016190
    dc.w    $2F00,$4879,$0003,$F85C,$4EB9,$0003,$B246,$4878; $0161A0
    dc.w    $000F,$4878,$001B,$4EB9,$0003,$AB2C,$3003,$48C0; $0161B0
    dc.w    $2F00,$4879,$0003,$F858,$4EB9,$0003,$B270,$4FEF; $0161C0
    dc.w    $0018,$6000,$01B8,$33FC,$0001,$00FF,$13FC,$5343; $0161D0
    dc.w    $0C43,$0001,$6F06,$3003,$48C0,$6002,$7001,$3600; $0161E0
    dc.w    $0C44,$0001,$6F14,$3003,$D040,$3DBC,$8000,$00C0; $0161F0
    dc.w    $3003,$D040,$3DBC,$8543,$0088,$0C43,$0007,$662A; $016200
    dc.w    $4878,$033E,$4878,$0001,$3004,$48C0,$5F80,$2F00; $016210
    dc.w    $4878,$0010,$4878,$0014,$4878,$0001,$4878,$001A; $016220
    dc.w    $4EB9,$0000,$0D64,$4FEF,$001C,$0C43,$0007,$6F40; $016230
    dc.w    $3003,$0640,$FFF9,$3A80,$4878,$033E,$4878,$0001; $016240
    dc.w    $3004,$48C0,$3215,$48C1,$9081,$5F80,$2F00,$4878; $016250
    dc.w    $0010,$3015,$48C0,$0680,$0000,$0014,$2F00,$4878; $016260
    dc.w    $0001,$4878,$001A,$4EB9,$0000,$0D64,$4FEF,$001C; $016270
    dc.w    $0C43,$0007,$6C06,$3003,$48C0,$6002,$7007,$3A80; $016280
    dc.w    $0C55,$0007,$6C00,$FD48,$0C44,$0007,$6C06,$3004; $016290
    dc.w    $48C0,$6002,$7007,$3D40,$FFF8,$48C0,$3215,$48C1; $0162A0
    dc.w    $9081,$6F00,$FD2A,$4878,$033E,$4878,$0001,$302E; $0162B0
    dc.w    $FFF8,$48C0,$3215,$48C1,$9081,$2F00,$4878,$000F; $0162C0
    dc.w    $3015,$48C0,$0680,$0000,$0014,$2F00,$4878,$0001; $0162D0
    dc.w    $4878,$001A,$4EB9,$0000,$0D64,$4FEF,$001C,$6000; $0162E0
    dc.w    $FCEE,$33FC,$0001,$00FF,$13FC,$5243,$B644,$6C04; $0162F0
    dc.w    $3003,$6002,$3004,$48C0,$3600,$D040,$3DBC,$8541; $016300
    dc.w    $00BE,$3003,$D040,$3DBC,$8542,$0086,$0C43,$0007; $016310
    dc.w    $6C06,$3003,$48C0,$6002,$7007,$3A80,$4878,$033D; $016320
    dc.w    $4878,$0001,$3015,$48C0,$2F00,$4878,$000F,$4878; $016330
    dc.w    $0014,$4878,$0001,$4878,$001A,$4EB9,$0000,$0D64; $016340
    dc.w    $4FEF,$001C,$3003,$0640,$FFF9,$3A80,$4A55,$6F00; $016350
    dc.w    $FC7E,$4878,$033D,$4878,$0001,$3015,$48C0,$2F00; $016360
    dc.w    $4878,$0010,$4878,$0014,$6000,$FF62,$4279,$00FF; $016370
    dc.w    $13FC,$4279,$00FF,$A7D8,$6000,$FC54,$4878,$0002; $016380
    dc.w    $4878,$0039,$4EB9,$0001,$E0B8,$42A7,$4878,$000D; $016390
    dc.w    $4878,$0020,$4878,$0012,$42A7,$42A7,$4878,$001A; $0163A0
    dc.w    $4EB9,$0000,$0D64,$4FEF,$0024,$42A7,$4878,$000D; $0163B0
    dc.w    $4878,$0020,$4878,$0012,$42A7,$4878,$0001,$4878; $0163C0
    dc.w    $001A,$4EB9,$0000,$0D64,$4CEE,$3CFC,$FF5C,$4E5E; $0163D0
    dc.w    $4E75,$4E56,$FFFC,$48E7,$3F3C,$246E,$000C,$267C; $0163E0
    dc.w    $0000,$0D64,$287C,$00FF,$13FC,$2A7C,$0003,$AB2C; $0163F0
    dc.w    $7000,$102A,$0001,$48C0,$2F00,$7000,$1012,$48C0; $016400
    dc.w    $2F00,$4EB9,$0000,$70DC,$3800,$4878,$0064,$4878; $016410
    dc.w    $0096,$3004,$2F00,$4EB9,$0001,$E11C,$3D40,$FFFC; $016420
    dc.w    $7000,$302A,$0004,$3204,$48C1,$9081,$7264,$4EB9; $016430
    dc.w    $0003,$E05C,$3204,$48C1,$4EB9,$0003,$E08A,$0680; $016440
    dc.w    $0000,$0032,$2400,$48C0,$7205,$4EB9,$0003,$E146; $016450
    dc.w    $3600,$6710,$0C43,$0003,$6C04,$9443,$6006,$7005; $016460
    dc.w    $9043,$D440,$4878,$0004,$4878,$001E,$4878,$0012; $016470
    dc.w    $4878,$0001,$4EB9,$0000,$5A04,$4FEF,$0024,$4878; $016480
    dc.w    $0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942; $016490
    dc.w    $42A7,$4EB9,$0001,$E1EC,$4FEF,$0014,$4A40,$6704; $0164A0
    dc.w    $7001,$6002,$7000,$3D40,$FFFE,$4246,$4254,$4279; $0164B0
    dc.w    $00FF,$A7D8,$7AFF,$4878,$0001,$42A7,$42A7,$4879; $0164C0
    dc.w    $0004,$7A26,$4878,$0020,$4878,$0002,$4878,$0039; $0164D0
    dc.w    $4878,$000B,$4E93,$4FEF,$0020,$302A,$0004,$3600; $0164E0
    dc.w    $48C0,$4A42,$6F06,$3002,$48C0,$6002,$7000,$3400; $0164F0
    dc.w    $0C42,$0064,$6C06,$3002,$48C0,$6002,$7064,$3400; $016500
    dc.w    $B445,$6700,$00EC,$4878,$0013,$4878,$000F,$4E95; $016510
    dc.w    $508F,$3002,$48C0,$0480,$0000,$0032,$673E,$3002; $016520
    dc.w    $48C0,$0480,$0000,$0032,$6C1E,$3002,$48C0,$4480; $016530
    dc.w    $0680,$0000,$0032,$2F00,$4879,$0003,$F8AE,$4EB9; $016540
    dc.w    $0003,$B270,$508F,$6022,$3002,$48C0,$0480,$0000; $016550
    dc.w    $0032,$2F00,$4879,$0003,$F89C,$60E2,$4879,$0003; $016560
    dc.w    $F88C,$4EB9,$0003,$B270,$588F,$4878,$000D,$4878; $016570
    dc.w    $0019,$4E95,$3003,$48C0,$2F00,$4879,$0003,$F886; $016580
    dc.w    $4EB9,$0003,$B246,$4878,$000E,$4878,$0019,$4E95; $016590
    dc.w    $3002,$48C0,$0480,$0000,$0032,$2F00,$4879,$0003; $0165A0
    dc.w    $F880,$4EB9,$0003,$B246,$3002,$48C0,$720A,$4EB9; $0165B0
    dc.w    $0003,$E08A,$3E00,$3002,$48C0,$720A,$4EB9,$0003; $0165C0
    dc.w    $E146,$7201,$B280,$6F0E,$3002,$48C0,$720A,$4EB9; $0165D0
    dc.w    $0003,$E146,$6002,$7001,$3A00,$48C0,$2F00,$3007; $0165E0
    dc.w    $48C0,$2F00,$4EBA,$0272,$4E71,$4FEF,$0028,$3A02; $0165F0
    dc.w    $4A6E,$FFFE,$6710,$42A7,$4EB9,$0001,$E1EC,$588F; $016600
    dc.w    $4A40,$6600,$FEDE,$426E,$FFFE,$3006,$2F00,$4878; $016610
    dc.w    $000A,$4EB9,$0001,$E290,$508F,$0240,$003C,$3C00; $016620
    dc.w    $48C0,$7220,$B041,$6700,$018E,$7210,$B041,$6714; $016630
    dc.w    $7204,$B041,$6700,$00F4,$7208,$B041,$6700,$013A; $016640
    dc.w    $6000,$0168,$4254,$4279,$00FF,$A7D8,$3003,$48C0; $016650
    dc.w    $7200,$322A,$0004,$B081,$6700,$0168,$7000,$302A; $016660
    dc.w    $0004,$3204,$48C1,$9081,$7264,$4EB9,$0003,$E05C; $016670
    dc.w    $3204,$48C1,$4EB9,$0003,$E08A,$0680,$0000,$0032; $016680
    dc.w    $2400,$48C0,$7205,$4EB9,$0003,$E146,$3600,$6710; $016690
    dc.w    $0C43,$0003,$6C04,$9443,$6006,$7005,$9043,$D440; $0166A0
    dc.w    $3002,$48C0,$720A,$4EB9,$0003,$E08A,$3E00,$3002; $0166B0
    dc.w    $48C0,$720A,$4EB9,$0003,$E146,$7201,$B280,$6F0E; $0166C0
    dc.w    $3002,$48C0,$720A,$4EB9,$0003,$E146,$6002,$7001; $0166D0
    dc.w    $3A00,$48C0,$2F00,$3007,$48C0,$2F00,$4EBA,$017A; $0166E0
    dc.w    $4E71,$4878,$000D,$4878,$0019,$4E95,$7000,$302A; $0166F0
    dc.w    $0004,$2F00,$4879,$0003,$F87A,$4EB9,$0003,$B246; $016700
    dc.w    $4878,$000E,$4878,$0019,$4E95,$3002,$48C0,$0480; $016710
    dc.w    $0000,$0032,$2F00,$4879,$0003,$F874,$4EB9,$0003; $016720
    dc.w    $B246,$4FEF,$0028,$6000,$009A,$38BC,$0001,$5B42; $016730
    dc.w    $3004,$48C0,$3202,$48C1,$0481,$0000,$0032,$4EB9; $016740
    dc.w    $0003,$E05C,$7264,$4EB9,$0003,$E08A,$D044,$3600; $016750
    dc.w    $3004,$48C0,$6C02,$5280,$E280,$3203,$48C1,$B081; $016760
    dc.w    $6C06,$3003,$48C0,$600A,$3004,$48C0,$6C02,$5280; $016770
    dc.w    $E280,$3600,$6000,$FD6C,$38BC,$0001,$5A42,$3004; $016780
    dc.w    $48C0,$3202,$48C1,$0481,$0000,$0032,$4EB9,$0003; $016790
    dc.w    $E05C,$7264,$4EB9,$0003,$E08A,$D044,$3600,$B66E; $0167A0
    dc.w    $FFFC,$6DBE,$302E,$FFFC,$60BA,$4254,$4279,$00FF; $0167B0
    dc.w    $A7D8,$6000,$FD2E,$4254,$4279,$00FF,$A7D8,$3543; $0167C0
    dc.w    $0004,$42A7,$42A7,$42A7,$4879,$0004,$7A26,$4878; $0167D0
    dc.w    $0020,$4878,$0002,$4878,$0039,$4878,$000B,$4E93; $0167E0
    dc.w    $4878,$0002,$4878,$0039,$4878,$0010,$4E93,$4FEF; $0167F0
    dc.w    $002C,$4878,$0001,$4878,$000E,$4E93,$2F3C,$0000; $016800
    dc.w    $8000,$4878,$000D,$4878,$0020,$4878,$0012,$42A7; $016810
    dc.w    $42A7,$4878,$001A,$4E93,$4878,$0001,$4878,$000E; $016820
    dc.w    $4E93,$4FEF,$002C,$2F3C,$0000,$8000,$4878,$000D; $016830
    dc.w    $4878,$0020,$4878,$0012,$42A7,$4878,$0001,$4878; $016840
    dc.w    $001A,$4E93,$4878,$0001,$4878,$000E,$4E93,$4CEE; $016850
    dc.w    $3CFC,$FFD4,$4E5E,$4E75,$4E56,$FFE8,$48E7,$3830; $016860
    dc.w    $262E,$0008,$282E,$000C,$45EE,$FFEA,$267C,$0000; $016870
    dc.w    $0D64,$0C43,$000A,$6C06,$3003,$48C0,$6002,$700A; $016880
    dc.w    $3600,$0C44,$0001,$6C06,$3004,$48C0,$6002,$7001; $016890
    dc.w    $3800,$4242,$6010,$7000,$3002,$D080,$2040,$35BC; $0168A0
    dc.w    $033A,$8800,$5242,$7000,$3002,$3203,$48C1,$B081; $0168B0
    dc.w    $6DE4,$6010,$7000,$3002,$D080,$2040,$35BC,$033B; $0168C0
    dc.w    $8800,$5242,$3003,$48C0,$3204,$48C1,$D081,$7200; $0168D0
    dc.w    $3202,$B081,$6EDE,$6010,$7000,$3002,$D080,$2040; $0168E0
    dc.w    $35BC,$033C,$8800,$5242,$0C42,$000A,$65EA,$2F0A; $0168F0
    dc.w    $4878,$0001,$4878,$000A,$4878,$000E,$4878,$0014; $016900
    dc.w    $4878,$0001,$4878,$001B,$4E93,$4878,$0001,$4878; $016910
    dc.w    $000E,$4E93,$4FEF,$0024,$2F0A,$4878,$0001,$4878; $016920
    dc.w    $000A,$4878,$0014,$4878,$0003,$4878,$0001,$4878; $016930
    dc.w    $001B,$4E93,$4878,$0001,$4878,$000E,$4E93,$4CEE; $016940
    dc.w    $0C1C,$FFD4,$4E5E,$4E75,$4E56,$FFE4,$48E7,$3F3C; $016950
    dc.w    $282E,$0008,$47EE,$FFFA,$287C,$0000,$0D64,$4BEE; $016960
    dc.w    $FFF8,$2F3C,$0000,$8000,$4878,$000A,$4878,$0020; $016970
    dc.w    $4878,$0012,$42A7,$42A7,$4878,$001A,$4E94,$4878; $016980
    dc.w    $0010,$4878,$0010,$4879,$0004,$C976,$4EB9,$0000; $016990
    dc.w    $5092,$4FEF,$0028,$4879,$0004,$CD56,$4878,$000D; $0169A0
    dc.w    $4878,$0020,$4878,$000F,$42A7,$4878,$0001,$4878; $0169B0
    dc.w    $001B,$4E94,$4FEF,$001C,$4242,$3002,$48C0,$0680; $0169C0
    dc.w    $0000,$0774,$2F00,$3002,$48C0,$5280,$2F00,$4878; $0169D0
    dc.w    $0010,$4878,$0002,$4878,$0007,$3002,$48C0,$D080; $0169E0
    dc.w    $5680,$2F00,$4878,$0003,$4878,$0001,$4EB9,$0000; $0169F0
    dc.w    $6760,$4FEF,$0020,$5242,$0C42,$0004,$6DBC,$4878; $016A00
    dc.w    $0010,$4878,$0030,$4879,$0007,$6A5E,$4EB9,$0000; $016A10
    dc.w    $5092,$2F39,$000A,$1B08,$4879,$00FF,$1804,$4EB9; $016A20
    dc.w    $0000,$3FEC,$4878,$006B,$4878,$010F,$4879,$00FF; $016A30
    dc.w    $1804,$4EB9,$0000,$4668,$4FEF,$0020,$4879,$0007; $016A40
    dc.w    $1A64,$4878,$000B,$4878,$0020,$4878,$000E,$42A7; $016A50
    dc.w    $42A7,$4878,$001B,$4E94,$7E07,$422E,$FFE6,$45EE; $016A60
    dc.w    $FFE6,$4245,$36BC,$0016,$3ABC,$0003,$7617,$7412; $016A70
    dc.w    $4878,$0020,$4878,$0020,$42A7,$42A7,$4EB9,$0003; $016A80
    dc.w    $A942,$42A7,$4EB9,$0001,$E1EC,$4FEF,$0030,$4A40; $016A90
    dc.w    $6704,$7001,$6002,$7000,$3D40,$FFFE,$426E,$FFFC; $016AA0
    dc.w    $4279,$00FF,$13FC,$4279,$00FF,$A7D8,$4246,$0C43; $016AB0
    dc.w    $0017,$6D1E,$0C42,$0012,$6618,$2F3C,$0000,$8000; $016AC0
    dc.w    $4878,$0002,$4878,$0002,$4878,$00B6,$4878,$00CB; $016AD0
    dc.w    $6034,$2F3C,$0000,$8000,$4878,$0002,$4878,$0002; $016AE0
    dc.w    $3002,$48C0,$2200,$D080,$D081,$E588,$3202,$48C1; $016AF0
    dc.w    $E789,$D081,$0480,$0000,$00AE,$2F00,$3003,$48C0; $016B00
    dc.w    $E788,$5680,$2F00,$42A7,$4878,$0740,$4EB9,$0001; $016B10
    dc.w    $E044,$4878,$0001,$4878,$000E,$4E94,$4FEF,$0024; $016B20
    dc.w    $7001,$B146,$BA47,$6C2A,$2F3C,$0000,$8000,$4878; $016B30
    dc.w    $0001,$4878,$0001,$4878,$0088,$3005,$48C0,$E788; $016B40
    dc.w    $0680,$0000,$00B0,$2F00,$4878,$0001,$4878,$0770; $016B50
    dc.w    $6014,$42A7,$4878,$0001,$4878,$0001,$42A7,$42A7; $016B60
    dc.w    $4878,$0001,$42A7,$4EB9,$0001,$E044,$4878,$0001; $016B70
    dc.w    $4878,$000E,$4E94,$4FEF,$0024,$4A6E,$FFFE,$671E; $016B80
    dc.w    $42A7,$4EB9,$0001,$E1EC,$588F,$4A40,$6710,$4878; $016B90
    dc.w    $0003,$4878,$000E,$4E94,$508F,$6000,$FF12,$426E; $016BA0
    dc.w    $FFFE,$4878,$0004,$4878,$000E,$4E94,$302E,$FFFC; $016BB0
    dc.w    $2F00,$4878,$000A,$4EB9,$0001,$E290,$4FEF,$0010; $016BC0
    dc.w    $0240,$003F,$3D40,$FFFC,$0240,$0030,$6700,$00DC; $016BD0
    dc.w    $4279,$00FF,$13FC,$4279,$00FF,$A7D8,$302E,$FFFC; $016BE0
    dc.w    $0240,$0020,$6778,$0C43,$0017,$6D08,$0C42,$0012; $016BF0
    dc.w    $6700,$0264,$3015,$C0FC,$001C,$D053,$207C,$0004; $016C00
    dc.w    $7A9C,$1D70,$0000,$FFF7,$0C2E,$002D,$FFF7,$6606; $016C10
    dc.w    $1D7C,$0020,$FFF7,$BA47,$6C00,$FE94,$5245,$14EE; $016C20
    dc.w    $FFF7,$4212,$4878,$000F,$4878,$0016,$4EB9,$0003; $016C30
    dc.w    $AB2C,$486E,$FFE6,$4879,$0003,$F948,$4EB9,$0003; $016C40
    dc.w    $B270,$4FEF,$0010,$BA47,$660C,$7617,$7412,$36BC; $016C50
    dc.w    $0016,$3ABC,$0003,$4878,$0006,$6000,$FF36,$4A45; $016C60
    dc.w    $6F00,$FE4C,$538A,$4212,$5345,$42A7,$4878,$0003; $016C70
    dc.w    $4878,$0008,$4878,$000F,$4878,$0016,$42A7,$4878; $016C80
    dc.w    $001A,$4E94,$4878,$000F,$4878,$0016,$4EB9,$0003; $016C90
    dc.w    $AB2C,$4FEF,$0024,$486E,$FFE6,$4879,$0003,$F944; $016CA0
    dc.w    $4EB9,$0003,$B270,$6000,$FEF0,$33FC,$0001,$00FF; $016CB0
    dc.w    $13FC,$302E,$FFFC,$0240,$0002,$6748,$3015,$48C0; $016CC0
    dc.w    $5280,$7203,$B280,$6F08,$3015,$48C0,$5280,$6002; $016CD0
    dc.w    $7003,$3A80,$3002,$48C0,$5280,$7212,$B280,$6F08; $016CE0
    dc.w    $3002,$48C0,$5280,$6002,$7012,$3400,$0C42,$0012; $016CF0
    dc.w    $6612,$0C43,$0018,$6706,$0C43,$0019,$6606,$7617; $016D00
    dc.w    $36BC,$0016,$302E,$FFFC,$0240,$0001,$6738,$0C43; $016D10
    dc.w    $0015,$6D06,$0C42,$0011,$6F2C,$3015,$48C0,$5380; $016D20
    dc.w    $6F08,$3015,$48C0,$5380,$6002,$7000,$3A80,$3002; $016D30
    dc.w    $48C0,$5380,$720F,$B280,$6C08,$3002,$48C0,$5380; $016D40
    dc.w    $6002,$700F,$3400,$302E,$FFFC,$0240,$0008,$6700; $016D50
    dc.w    $00B0,$0C42,$0011,$6C08,$0C43,$0014,$6C00,$00A2; $016D60
    dc.w    $0C42,$0011,$662C,$3013,$48C0,$5280,$7218,$B280; $016D70
    dc.w    $6F08,$3013,$48C0,$5280,$6002,$7018,$3680,$3003; $016D80
    dc.w    $48C0,$5280,$7219,$B280,$6F5A,$3003,$48C0,$5280; $016D90
    dc.w    $6054,$0C42,$0012,$6628,$3013,$48C0,$5280,$7216; $016DA0
    dc.w    $B280,$6F08,$3013,$48C0,$5280,$6002,$7016,$3680; $016DB0
    dc.w    $3003,$48C0,$5280,$7217,$B280,$6ECE,$7017,$6026; $016DC0
    dc.w    $3013,$48C0,$5280,$721A,$B280,$6F08,$3013,$48C0; $016DD0
    dc.w    $5280,$6002,$701A,$3680,$3003,$48C0,$5280,$7219; $016DE0
    dc.w    $B280,$6EA6,$7019,$3600,$3015,$C0FC,$001C,$D053; $016DF0
    dc.w    $207C,$0004,$7A9C,$0C30,$0020,$0000,$6700,$FF62; $016E00
    dc.w    $302E,$FFFC,$0240,$0004,$6700,$FCA4,$3013,$48C0; $016E10
    dc.w    $5380,$7201,$B280,$6C08,$3013,$48C0,$5380,$6002; $016E20
    dc.w    $7001,$3680,$3003,$48C0,$5380,$7202,$B280,$6C08; $016E30
    dc.w    $3003,$48C0,$5380,$6002,$7002,$3600,$3015,$C0FC; $016E40
    dc.w    $001C,$D053,$207C,$0004,$7A9C,$0C30,$0020,$0000; $016E50
    dc.w    $67BA,$6000,$FC5A,$4A45,$6734,$4242,$4243,$600C; $016E60
    dc.w    $0C36,$0020,$30E6,$6702,$5242,$5243,$B645,$6DF0; $016E70
    dc.w    $4A42,$671A,$486E,$FFE6,$3004,$E948,$207C,$00FF; $016E80
    dc.w    $00A8,$4870,$0000,$4EB9,$0003,$B22C,$508F,$4878; $016E90
    dc.w    $0002,$42A7,$4EB9,$0001,$E0B8,$42A7,$4878,$000B; $016EA0
    dc.w    $4878,$0020,$4878,$000E,$42A7,$42A7,$4878,$001A; $016EB0
    dc.w    $4E94,$4FEF,$0024,$4878,$0020,$4878,$0020,$42A7; $016EC0
    dc.w    $42A7,$4EB9,$0003,$A942,$4FEF,$0010,$4244,$42A7; $016ED0
    dc.w    $4878,$0002,$4878,$0007,$3004,$48C0,$D080,$5680; $016EE0
    dc.w    $2F00,$4878,$0003,$42A7,$4878,$001A,$4E94,$3004; $016EF0
    dc.w    $48C0,$D080,$5680,$2F00,$4878,$0003,$4EB9,$0003; $016F00
    dc.w    $AB2C,$3004,$E948,$207C,$00FF,$00A8,$4870,$0000; $016F10
    dc.w    $4EB9,$0003,$B270,$4FEF,$0028,$5244,$0C44,$0004; $016F20
    dc.w    $6DAC,$4CEE,$3CFC,$FFBC,$4E5E,$4E75,$48E7,$3800; $016F30
    dc.w    $282F,$0018,$4243,$4202,$4A6F,$0016,$6F08,$206F; $016F40
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
    moveq   #$ff,d1
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
    moveq   #$ff,d0
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
    dc.w    $4E56,$FF2C,$48E7,$3F3C,$2C2E,$0008              ; $018214
    dc.w    $4BEE,$FF50,$4247,$3006,$2F00,$4EB9,$0001,$045A; $018220
    dc.w    $3D40,$FF2E,$3A39,$00FF,$0006,$48C5,$E485,$0645; $018230
    dc.w    $0037,$4A6E,$FF2E,$6F02,$7E01,$3006,$2F00,$4EB9; $018240
    dc.w    $0001,$0492,$508F,$3400,$4A42,$6622,$2F39,$0004; $018250
    dc.w    $7B7C,$2F39,$0004,$7C1C,$2F0D,$4EB9,$0003,$B22C; $018260
    dc.w    $4FEF,$000C,$4878,$0002,$2F0D,$6000,$037A,$B46E; $018270
    dc.w    $FF2E,$662E,$0C42,$0001,$6608,$4879,$0004,$10A4; $018280
    dc.w    $6006,$4879,$0004,$109C,$3002,$48C0,$2F00,$2F39; $018290
    dc.w    $0004,$7C2C,$2F0D,$4EB9,$0003,$B22C,$4FEF,$0010; $0182A0
    dc.w    $6066,$4A6E,$FF2E,$661A,$3002,$48C0,$2F00,$2F39; $0182B0
    dc.w    $0004,$7C28,$2F0D,$4EB9,$0003,$B22C,$4FEF,$000C; $0182C0
    dc.w    $6046,$3002,$48C0,$322E,$FF2E,$48C1,$9081,$7201; $0182D0
    dc.w    $B280,$6608,$4879,$0004,$1096,$6006,$4879,$0004; $0182E0
    dc.w    $108E,$3002,$48C0,$322E,$FF2E,$48C1,$9081,$2F00; $0182F0
    dc.w    $3002,$48C0,$2F00,$2F39,$0004,$7C24,$2F0D,$4EB9; $018300
    dc.w    $0003,$B22C,$4FEF,$0014,$42A7,$2F0D,$4878,$0003; $018310
    dc.w    $42A7,$4EB9,$0001,$D6A4,$508F,$2F00,$3006,$2F00; $018320
    dc.w    $4EB9,$0002,$FBD6,$4FEF,$0010,$4242,$3002,$E548; $018330
    dc.w    $41F6,$00F0,$2448,$34BC,$FFFF,$357C,$FFFF,$0002; $018340
    dc.w    $588A,$5242,$0C42,$0004,$6DEC,$4242,$3002,$D040; $018350
    dc.w    $41EE,$FF30,$31BC,$FFFF,$0000,$5242,$0C42,$0010; $018360
    dc.w    $6DEA,$3006,$C0FC,$0024,$207C,$00FF,$0018,$41F0; $018370
    dc.w    $0000,$2448,$7000,$102A,$0004,$48C0,$7200,$122A; $018380
    dc.w    $0005,$48C1,$D081,$6F00,$0086,$3006,$C0FC,$0320; $018390
    dc.w    $207C,$00FF,$9A20,$41F0,$0000,$2648,$7400,$142A; $0183A0
    dc.w    $0004,$7000,$102A,$0005,$D440,$4243,$605C,$7801; $0183B0
    dc.w    $6002,$5244,$2F0B,$4EB9,$0000,$7412,$588F,$48C0; $0183C0
    dc.w    $3204,$48C1,$4EB9,$0003,$E05C,$7214,$4EB9,$0003; $0183D0
    dc.w    $E08A,$720E,$B280,$6EDA,$2F0B,$4EB9,$0000,$7402; $0183E0
    dc.w    $588F,$3204,$9240,$3801,$4A44,$6F18,$2F0B,$4EB9; $0183F0
    dc.w    $0000,$74E0,$588F,$D040,$41EE,$FF30,$43F0,$0000; $018400
    dc.w    $2449,$D952,$7014,$D7C0,$5243,$B642,$6DA0,$4243; $018410
    dc.w    $3006,$EB48,$3203,$D241,$D041,$207C,$00FF,$B9E8; $018420
    dc.w    $41F0,$0000,$2648,$3003,$D040,$41EE,$FF30,$43F0; $018430
    dc.w    $0000,$2849,$4244,$4A54,$6F00,$0086,$3003,$C0FC; $018440
    dc.w    $000C,$207C,$00FF,$A6B8,$41F0,$0000,$2448,$7000; $018450
    dc.w    $102A,$0007,$48C0,$3205,$48C1,$5481,$B081,$6E10; $018460
    dc.w    $7000,$102A,$0007,$B045,$6F06,$38BC,$FFFF,$6050; $018470
    dc.w    $3006,$C0FC,$0014,$207C,$00FF,$02E8,$41F0,$0000; $018480
    dc.w    $2448,$4242,$7000,$1012,$B043,$6608,$7800,$182A; $018490
    dc.w    $0001,$600A,$588A,$5242,$0C42,$0005,$6DE6,$3004; $0184A0
    dc.w    $48C0,$7200,$1213,$48C1,$D081,$7263,$B280,$6FBA; $0184B0
    dc.w    $0C47,$0001,$6608,$7000,$102B,$0001,$D840,$9954; $0184C0
    dc.w    $548C,$548B,$5243,$0C43,$0010,$6D00,$FF68,$4243; $0184D0
    dc.w    $3003,$D040,$41EE,$FF30,$43F0,$0000,$2449,$4A52; $0184E0
    dc.w    $6D18,$3D43,$FFFC,$3D52,$FFFE,$4878,$0004,$486E; $0184F0
    dc.w    $FFF0,$4EB9,$0001,$09FA,$508F,$548A,$5243,$0C43; $018500
    dc.w    $0010,$6DDA,$4243,$4242,$3002,$E548,$41F6,$00F0; $018510
    dc.w    $2648,$3013,$48C0,$72FF,$B280,$6700,$0092,$3002; $018520
    dc.w    $E548,$4A76,$00F2,$6F00,$0086,$3013,$C0FC,$000C; $018530
    dc.w    $207C,$00FF,$A6B8,$41F0,$0000,$2448,$7000,$102A; $018540
    dc.w    $0006,$B045,$6E0E,$7000,$102A,$0007,$B045,$6D04; $018550
    dc.w    $3602,$6002,$7605,$3013,$207C,$00FF,$1278,$1030; $018560
    dc.w    $0000,$0280,$0000,$00FF,$E548,$207C,$0005,$ECFC; $018570
    dc.w    $2F30,$0000,$3003,$E548,$207C,$0004,$7C0C,$2F30; $018580
    dc.w    $0000,$2F0D,$4EB9,$0003,$B22C,$42A7,$2F0D,$4878; $018590
    dc.w    $0003,$42A7,$4EB9,$0001,$D6A4,$508F,$2F00,$3006; $0185A0
    dc.w    $2F00,$4EB9,$0002,$FBD6,$4FEF,$001C,$7601,$588B; $0185B0
    dc.w    $5242,$0C42,$0002,$6D00,$FF5A,$3003,$806E,$FF2E; $0185C0
    dc.w    $660A,$42A7,$2F39,$0004,$7C30,$601A,$42A7,$0C43; $0185D0
    dc.w    $0001,$6604,$7002,$6002,$7003,$E548,$207C,$0004; $0185E0
    dc.w    $7C0C,$2F30,$0000,$4878,$0003,$42A7,$4EB9,$0001; $0185F0
    dc.w    $D6A4,$508F,$2F00,$3006,$2F00,$4EB9,$0002,$FBD6; $018600
    dc.w    $4CEE,$3CFC,$FF04,$4E5E,$4E75,$4E56,$FF44,$48E7; $018610
    dc.w    $3F3C,$49EE,$000A,$4BEE,$FF52,$3014,$C0FC,$0024; $018620
    dc.w    $207C,$00FF,$0018,$41F0,$0000,$2648,$3014,$2F00; $018630
    dc.w    $4EBA,$063E,$4E71,$588F,$302E,$000E,$48C0,$72FF; $018640
    dc.w    $B280,$670C,$3014,$2F00,$4EBA,$06BA,$4E71,$588F; $018650
    dc.w    $4AAB,$0006,$6F00,$05D8,$426E,$FF4C,$426E,$FF4A; $018660
    dc.w    $426E,$FF48,$426E,$FF46,$7800,$3D7C,$FFFF,$FFFE; $018670
    dc.w    $3D7C,$FFFF,$FF50,$4A39,$00FF,$09C2,$6612,$7000; $018680
    dc.w    $1039,$00FF,$09C3,$E748,$207C,$0005,$F9E1,$601A; $018690
    dc.w    $0C39,$0001,$00FF,$09C2,$662A,$7000,$1039,$00FF; $0186A0
    dc.w    $09C3,$E548,$207C,$0005,$FA11,$1030,$0000,$0280; $0186B0
    dc.w    $0000,$00FF,$48C0,$2F00,$4EB9,$0000,$D648,$588F; $0186C0
    dc.w    $3D40,$FF50,$7000,$102B,$0004,$7200,$122B,$0005; $0186D0
    dc.w    $D041,$3D40,$FF4E,$3014,$C0FC,$0320,$207C,$00FF; $0186E0
    dc.w    $9A20,$41F0,$0000,$2448,$7A6F,$7EFF,$4243,$6000; $0186F0
    dc.w    $00B4,$102A,$000A,$0280,$0000,$0004,$6600,$00A0; $018700
    dc.w    $102A,$000A,$0280,$0000,$0002,$6600,$0092,$7000; $018710
    dc.w    $102A,$0001,$48C0,$2F00,$4EB9,$0000,$D648,$588F; $018720
    dc.w    $2F00,$7000,$1012,$48C0,$2F00,$4EB9,$0000,$D648; $018730
    dc.w    $588F,$221F,$B041,$6666,$7000,$102A,$0001,$48C0; $018740
    dc.w    $2F00,$4EB9,$0000,$D648,$588F,$B06E,$FF50,$674E; $018750
    dc.w    $302A,$000E,$B06A,$0006,$6418,$7400,$342A,$0006; $018760
    dc.w    $7000,$302A,$000E,$9480,$B882,$6C06,$2802,$3D43; $018770
    dc.w    $FFFE,$7C00,$1C2A,$000B,$7400,$142A,$0003,$3006; $018780
    dc.w    $2F00,$4878,$0064,$3002,$2F00,$4EB9,$0001,$E11C; $018790
    dc.w    $4FEF,$000C,$3400,$B445,$6C04,$3A02,$3E03,$7014; $0187A0
    dc.w    $D5C0,$5243,$B66E,$FF4E,$6D00,$FF48,$BE6E,$FFFE; $0187B0
    dc.w    $6602,$7EFF,$302E,$FFFE,$48C0,$72FF,$B280,$6700; $0187C0
    dc.w    $020E,$4878,$000C,$4878,$00FF,$486E,$FFF2,$4EB9; $0187D0
    dc.w    $0001,$D520,$3014,$C0FC,$0320,$322E,$FFFE,$C2FC; $0187E0
    dc.w    $0014,$D041,$207C,$00FF,$9A20,$41F0,$0000,$2448; $0187F0
    dc.w    $4878,$0001,$42A7,$4EB9,$0001,$D6A4,$4A80,$6606; $018800
    dc.w    $7600,$1612,$6006,$7600,$162A,$0001,$3003,$48C0; $018810
    dc.w    $2F00,$4EB9,$0000,$D648,$4FEF,$0018,$7000,$302A; $018820
    dc.w    $000E,$2200,$D080,$D081,$7200,$322A,$0006,$D281; $018830
    dc.w    $B081,$6F3A,$42A7,$3003,$2F00,$3014,$2F00,$4EB9; $018840
    dc.w    $0001,$08F2,$4FEF,$000C,$3400,$48C0,$72FF,$B280; $018850
    dc.w    $671C,$3002,$2F00,$3003,$2F00,$3014,$2F00,$4EB9; $018860
    dc.w    $0000,$E08E,$4FEF,$000C,$B0AB,$0006,$6312,$3003; $018870
    dc.w    $2F00,$3014,$2F00,$4EB9,$0001,$0686,$508F,$3400; $018880
    dc.w    $3002,$48C0,$72FF,$B280,$6700,$0144,$3002,$E548; $018890
    dc.w    $207C,$0005,$E31D,$1830,$0000,$0284,$0000,$00FF; $0188A0
    dc.w    $4878,$FFFF,$3003,$48C0,$2F00,$4EB9,$0000,$D648; $0188B0
    dc.w    $588F,$2F00,$4EB9,$0001,$00F2,$508F,$0C44,$0001; $0188C0
    dc.w    $6778,$0C44,$0003,$6E72,$0C44,$0003,$6602,$7801; $0188D0
    dc.w    $3004,$48C0,$E588,$207C,$0005,$E296,$2F30,$0800; $0188E0
    dc.w    $3003,$E548,$207C,$0005,$E680,$2F30,$0000,$3002; $0188F0
    dc.w    $E548,$207C,$0005,$E2A2,$2F30,$0000,$2F39,$0004; $018900
    dc.w    $7CA4,$2F0D,$4EB9,$0003,$B22C,$42A7,$2F0D,$4878; $018910
    dc.w    $0003,$42A7,$4EB9,$0001,$D6A4,$508F,$2F00,$3014; $018920
    dc.w    $2F00,$4EB9,$0002,$FBD6,$4FEF,$0024,$3D7C,$0001; $018930
    dc.w    $FF4C,$3D7C,$0001,$FF48,$6052,$3002,$E548,$207C; $018940
    dc.w    $0005,$E2A2,$2F30,$0000,$3003,$E548,$207C,$0005; $018950
    dc.w    $E680,$2F30,$0000,$2F39,$0004,$7CA8,$2F0D,$4EB9; $018960
    dc.w    $0003,$B22C,$42A7,$2F0D,$4878,$0003,$42A7,$4EB9; $018970
    dc.w    $0001,$D6A4,$508F,$2F00,$3014,$2F00,$4EB9,$0002; $018980
    dc.w    $FBD6,$4FEF,$0020,$3D7C,$0001,$FF4C,$3002,$2F00; $018990
    dc.w    $3003,$2F00,$3014,$2F00,$4EB9,$0000,$E08E,$4FEF; $0189A0
    dc.w    $000C,$2400,$D080,$D082,$B0AB,$0006,$6F20,$42A7; $0189B0
    dc.w    $2F39,$0004,$7CC0,$4878,$0004,$3014,$2F00,$4EB9; $0189C0
    dc.w    $0002,$FBD6,$4FEF,$0010,$3D7C,$0001,$FF4A,$3007; $0189D0
    dc.w    $48C0,$72FF,$B280,$6700,$0284,$4A6E,$FF4A,$6600; $0189E0
    dc.w    $027C,$3014,$C0FC,$0320,$3207,$C2FC,$0014,$D041; $0189F0
    dc.w    $207C,$00FF,$9A20,$41F0,$0000,$2448,$4878,$0001; $018A00
    dc.w    $42A7,$4EB9,$0001,$D6A4,$508F,$4A80,$660C,$7600; $018A10
    dc.w    $1612,$3D7C,$0001,$FF46,$6006,$7600,$162A,$0001; $018A20
    dc.w    $0C45,$0028,$6E06,$4A6E,$FF48,$6708,$0C6E,$0001; $018A30
    dc.w    $FF46,$6612,$3003,$2F00,$3014,$2F00,$4EB9,$0001; $018A40
    dc.w    $0686,$508F,$6016,$4878,$0001,$3003,$2F00,$3014; $018A50
    dc.w    $2F00,$4EB9,$0001,$08F2,$4FEF,$000C,$3400,$48C0; $018A60
    dc.w    $72FF,$B280,$6700,$01F6,$3002,$E548,$207C,$0005; $018A70
    dc.w    $E31D,$1830,$0000,$0284,$0000,$00FF,$4878,$FFFF; $018A80
    dc.w    $3003,$48C0,$2F00,$4EB9,$0000,$D648,$588F,$2F00; $018A90
    dc.w    $4EB9,$0001,$00F2,$508F,$0C44,$0001,$6708,$0C45; $018AA0
    dc.w    $0028,$6F00,$0146,$3002,$2F00,$3003,$2F00,$3014; $018AB0
    dc.w    $2F00,$4EB9,$0000,$E08E,$4FEF,$000C,$E588,$B0AB; $018AC0
    dc.w    $0006,$6C78,$0C6E,$0001,$FF4C,$6624,$3003,$E548; $018AD0
    dc.w    $207C,$0005,$E680,$2F30,$0000,$3002,$E548,$207C; $018AE0
    dc.w    $0005,$E2A2,$2F30,$0000,$4879,$0004,$10C0,$6022; $018AF0
    dc.w    $3003,$E548,$207C,$0005,$E680,$2F30,$0000,$3002; $018B00
    dc.w    $E548,$207C,$0005,$E2A2,$2F30,$0000,$4879,$0004; $018B10
    dc.w    $10B8,$2F39,$0004,$7CC4,$2F0D,$4EB9,$0003,$B22C; $018B20
    dc.w    $4FEF,$0014,$42A7,$2F0D,$4878,$0003,$42A7,$4EB9; $018B30
    dc.w    $0001,$D6A4,$508F,$2F00,$6000,$0114,$0C6E,$0001; $018B40
    dc.w    $FF46,$6612,$3003,$2F00,$3014,$2F00,$4EB9,$0001; $018B50
    dc.w    $0686,$508F,$6014,$42A7,$3003,$2F00,$3014,$2F00; $018B60
    dc.w    $4EB9,$0001,$08F2,$4FEF,$000C,$3400,$48C0,$72FF; $018B70
    dc.w    $B280,$6700,$00E8,$4878,$FFFF,$3003,$48C0,$2F00; $018B80
    dc.w    $4EB9,$0000,$D648,$588F,$2F00,$4EB9,$0001,$00F2; $018B90
    dc.w    $508F,$0C6E,$0001,$FF4C,$6624,$3003,$E548,$207C; $018BA0
    dc.w    $0005,$E680,$2F30,$0000,$3002,$E548,$207C,$0005; $018BB0
    dc.w    $E2A2,$2F30,$0000,$4879,$0004,$10B2,$6022,$3003; $018BC0
    dc.w    $E548,$207C,$0005,$E680,$2F30,$0000,$3002,$E548; $018BD0
    dc.w    $207C,$0005,$E2A2,$2F30,$0000,$4879,$0004,$10AA; $018BE0
    dc.w    $2F39,$0004,$7CC8,$6000,$FF30,$0C44,$0003,$6E6C; $018BF0
    dc.w    $0C44,$0003,$6602,$7801,$3004,$48C0,$E588,$207C; $018C00
    dc.w    $0005,$E296,$2F30,$0800,$3003,$E548,$207C,$0005; $018C10
    dc.w    $E680,$2F30,$0000,$3002,$E548,$207C,$0005,$E2A2; $018C20
    dc.w    $2F30,$0000,$2F39,$0004,$7CA4,$6000,$FEEC,$2F39; $018C30
    dc.w    $0004,$7B78,$2F39,$0004,$7CBC,$2F0D,$4EB9,$0003; $018C40
    dc.w    $B22C,$4FEF,$000C,$42A7,$2F0D,$4878,$0003,$3014; $018C50
    dc.w    $2F00,$4EB9,$0002,$FBD6,$4FEF,$0010,$3014,$2F00; $018C60
    dc.w    $4EB9,$0001,$01CA,$4CEE,$3CFC,$FF1C,$4E5E,$4E75; $018C70
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
    dc.w    $4E56,$FFF0,$48E7,$3C3C,$242E,$0018; $019244
    dc.w    $262E,$000C,$282E,$0014,$246E,$0008,$267C,$00FF; $019250
    dc.w    $1804,$287C,$0003,$AB2C,$2A7C,$00FF,$BA80,$7A01; $019260
    dc.w    $2F3C,$0000,$8000,$4878,$000D,$4878,$001E,$3004; $019270
    dc.w    $48C0,$2F00,$3005,$48C0,$2F00,$4878,$0001,$4878; $019280
    dc.w    $001A,$4EB9,$0000,$0D64,$4FEF,$001C,$0C42,$0001; $019290
    dc.w    $6600,$0098,$7000,$102A,$0001,$2F00,$7000,$1012; $0192A0
    dc.w    $2F00,$4EB9,$0000,$7158,$4A40,$6708,$2F39,$000A; $0192B0
    dc.w    $1B50,$6006,$2F39,$000A,$1B4C,$2F0B,$4EB9,$0000; $0192C0
    dc.w    $3FEC,$4878,$0010,$4878,$0001,$2F0B,$4EB9,$0000; $0192D0
    dc.w    $4668,$4879,$0004,$DCE8,$2F0B,$4EB9,$0000,$3FEC; $0192E0
    dc.w    $4FEF,$0024,$302E,$0012,$48C0,$2F00,$42A7,$2F0B; $0192F0
    dc.w    $4878,$001A,$4878,$0328,$4EB9,$0001,$D568,$4879; $019300
    dc.w    $0007,$2AC0,$4878,$000D,$4878,$001E,$3004,$48C0; $019310
    dc.w    $2F00,$3005,$48C0,$2F00,$4878,$0001,$4878,$001B; $019320
    dc.w    $4EB9,$0000,$0D64,$4FEF,$0030,$4878,$0020,$4878; $019330
    dc.w    $0020,$42A7,$42A7,$4EB9,$0003,$A942,$3004,$48C0; $019340
    dc.w    $5280,$2F00,$3005,$48C0,$5280,$2F00,$4E94,$7000; $019350
    dc.w    $1012,$E548,$207C,$0005,$E7E4,$2F30,$0000,$4879; $019360
    dc.w    $0004,$10F8,$4EB9,$0003,$B270,$3004,$48C0,$5280; $019370
    dc.w    $2F00,$3005,$48C0,$0680,$0000,$000C,$2F00,$4E94; $019380
    dc.w    $4FEF,$0028,$3004,$5240,$2F00,$3005,$0640,$000B; $019390
    dc.w    $2F00,$42A7,$4EB9,$0000,$58FC,$3004,$5240,$2F00; $0193A0
    dc.w    $3005,$0640,$0012,$2F00,$4878,$0001,$4EB9,$0000; $0193B0
    dc.w    $58FC,$3004,$5240,$2F00,$3005,$0640,$0011,$2F00; $0193C0
    dc.w    $4878,$0002,$4878,$0002,$4EB9,$0000,$595E,$7000; $0193D0
    dc.w    $102A,$0001,$48C0,$2F00,$7000,$1012,$48C0,$2F00; $0193E0
    dc.w    $4EB9,$0000,$6F42,$508F,$0280,$0000,$FFFF,$2F00; $0193F0
    dc.w    $4879,$0004,$10F4,$4EB9,$0003,$B270,$4FEF,$0030; $019400
    dc.w    $3004,$48C0,$5280,$2F00,$3005,$48C0,$0680,$0000; $019410
    dc.w    $0013,$2F00,$4E94,$7000,$102A,$0001,$E548,$207C; $019420
    dc.w    $0005,$E7E4,$2F30,$0000,$4879,$0004,$10F0,$4EB9; $019430
    dc.w    $0003,$B270,$3004,$48C0,$5680,$2F00,$3005,$48C0; $019440
    dc.w    $5880,$2F00,$4E94,$7000,$1012,$E788,$41F5,$0800; $019450
    dc.w    $3203,$48C1,$D281,$D1C1,$1010,$0280,$0000,$00FF; $019460
    dc.w    $2F00,$7000,$1012,$E788,$41F5,$0800,$3203,$48C1; $019470
    dc.w    $D281,$D1C1,$1028,$0001,$0280,$0000,$00FF,$2F00; $019480
    dc.w    $4879,$0004,$10E6,$4EB9,$0003,$B246,$3004,$48C0; $019490
    dc.w    $5680,$2F00,$3005,$48C0,$0680,$0000,$0014,$2F00; $0194A0
    dc.w    $4E94,$4FEF,$002C,$7000,$102A,$0001,$E788,$41F5; $0194B0
    dc.w    $0800,$3203,$48C1,$D281,$D1C1,$1010,$0280,$0000; $0194C0
    dc.w    $00FF,$2F00,$7000,$102A,$0001,$E788,$41F5,$0800; $0194D0
    dc.w    $3203,$48C1,$D281,$D1C1,$1028,$0001,$0280,$0000; $0194E0
    dc.w    $00FF,$2F00,$4879,$0004,$10DC,$4EB9,$0003,$B246; $0194F0
    dc.w    $3004,$48C0,$0680,$0000,$000B,$2F00,$4878,$000E; $019500
    dc.w    $4E94,$2F0A,$4EB9,$0000,$7402,$588F,$2F00,$4879; $019510
    dc.w    $0004,$10D8,$4EB9,$0003,$B246,$4FEF,$001C,$3003; $019520
    dc.w    $48C0,$2F00,$4878,$0007,$42A7,$3004,$48C0,$5880; $019530
    dc.w    $2F00,$3005,$48C0,$5280,$2F00,$2F0A,$4EB9,$0000; $019540
    dc.w    $74E0,$588F,$0280,$0000,$FFFF,$2F00,$4EB9,$0003; $019550
    dc.w    $A5A8,$3002,$48C0,$2F00,$4878,$0001,$3004,$48C0; $019560
    dc.w    $5880,$2F00,$3005,$48C0,$0680,$0000,$000F,$2F00; $019570
    dc.w    $2F0A,$4EBA,$0476,$4E71,$4FEF,$002C,$3002,$48C0; $019580
    dc.w    $2F00,$4878,$0001,$3004,$48C0,$5080,$2F00,$3005; $019590
    dc.w    $48C0,$0680,$0000,$000F,$2F00,$2F0A,$4EBA,$0838; $0195A0
    dc.w    $4E71,$4FEF,$0014,$76FF,$102A,$000A,$0800,$0002; $0195B0
    dc.w    $6704,$7600,$601A,$102A,$000A,$0800,$0001,$6704; $0195C0
    dc.w    $7610,$600C,$102A,$000A,$0800,$0000,$6702,$7608; $0195D0
    dc.w    $70FF,$B083,$6C70,$4242,$3002,$48C0,$D083,$0680; $0195E0
    dc.w    $0000,$037B,$2600,$3002,$D040,$3D83,$00F0,$5283; $0195F0
    dc.w    $5242,$0C42,$0008,$6DEE,$486E,$FFF0,$4878,$0002; $019600
    dc.w    $4878,$0004,$3004,$48C0,$5880,$2F00,$3005,$48C0; $019610
    dc.w    $5280,$2F00,$42A7,$4878,$001B,$4EB9,$0000,$0D64; $019620
    dc.w    $4879,$0004,$E28A,$2F0B,$4EB9,$0000,$3FEC,$4FEF; $019630
    dc.w    $0024,$42A7,$42A7,$2F0B,$4878,$0018,$4878,$037B; $019640
    dc.w    $4EB9,$0001,$D568,$4CEE,$3C3C,$FFD0,$4E5E,$4E75; $019650
    dc.w    $4E56,$FFF0,$48E7,$3C3C,$262E,$0018,$282E,$0014; $019660
    dc.w    $246E,$0008,$267C,$0003,$B270,$287C,$0003,$AB2C; $019670
    dc.w    $2A7C,$00FF,$1804,$7A01,$4EB9,$0003,$77C8,$2F3C; $019680
    dc.w    $0000,$8000,$4878,$000C,$4878,$0020,$3004,$48C0; $019690
    dc.w    $2F00,$42A7,$42A7,$4878,$001A,$4EB9,$0000,$0D64; $0196A0
    dc.w    $7000,$102A,$0001,$2F00,$7000,$1012,$2F00,$4EB9; $0196B0
    dc.w    $0000,$7158,$4FEF,$0024,$4A40,$6704,$7402,$6002; $0196C0
    dc.w    $7401,$4878,$075E,$3002,$48C0,$2F00,$42A7,$4878; $0196D0
    dc.w    $0002,$4878,$001E,$3004,$48C0,$2F00,$3005,$48C0; $0196E0
    dc.w    $2F00,$4878,$0001,$4EB9,$0000,$6760,$4FEF,$0020; $0196F0
    dc.w    $4878,$075F,$302E,$000E,$48C0,$5280,$2F00,$42A7; $019700
    dc.w    $4878,$0002,$4878,$001E,$3004,$48C0,$5480,$2F00; $019710
    dc.w    $3005,$48C0,$2F00,$4878,$0001,$4EB9,$0000,$6760; $019720
    dc.w    $4FEF,$0020,$4878,$077E,$4878,$0004,$4878,$000B; $019730
    dc.w    $3004,$48C0,$5880,$2F00,$3005,$48C0,$5880,$2F00; $019740
    dc.w    $4878,$0001,$4878,$001A,$4EB9,$0000,$0D64,$4FEF; $019750
    dc.w    $001C,$4878,$077E,$4878,$0004,$4878,$000B,$3004; $019760
    dc.w    $48C0,$5880,$2F00,$3005,$48C0,$0680,$0000,$0013; $019770
    dc.w    $2F00,$4878,$0001,$4878,$001A,$4EB9,$0000,$0D64; $019780
    dc.w    $4FEF,$001C,$0C43,$0001,$662C,$4879,$0004,$DCE8; $019790
    dc.w    $2F0D,$4EB9,$0000,$3FEC,$302E,$0012,$48C0,$2F00; $0197A0
    dc.w    $42A7,$2F0D,$4878,$001A,$4878,$0328,$4EB9,$0001; $0197B0
    dc.w    $D568,$4FEF,$001C,$4878,$0020,$4878,$0020,$42A7; $0197C0
    dc.w    $42A7,$4EB9,$0003,$A942,$3004,$48C0,$2F00,$3005; $0197D0
    dc.w    $48C0,$5280,$2F00,$4E94,$7000,$1012,$E548,$207C; $0197E0
    dc.w    $0005,$E7E4,$2F30,$0000,$4879,$0004,$110C,$4E93; $0197F0
    dc.w    $3004,$48C0,$2F00,$3005,$48C0,$0680,$0000,$000C; $019800
    dc.w    $2F00,$4E94,$7000,$102A,$0001,$48C0,$2F00,$7000; $019810
    dc.w    $1012,$48C0,$2F00,$4EB9,$0000,$6F42,$508F,$0280; $019820
    dc.w    $0000,$FFFF,$2F00,$4879,$0004,$1108,$4E93,$4FEF; $019830
    dc.w    $0030,$3004,$48C0,$2F00,$3005,$48C0,$0680,$0000; $019840
    dc.w    $0013,$2F00,$4E94,$3004,$2F00,$3005,$0640,$000B; $019850
    dc.w    $2F00,$42A7,$4EB9,$0000,$58FC,$3004,$2F00,$3005; $019860
    dc.w    $0640,$0012,$2F00,$4878,$0001,$4EB9,$0000,$58FC; $019870
    dc.w    $3004,$2F00,$3005,$0640,$0011,$2F00,$4878,$0002; $019880
    dc.w    $4878,$0002,$4EB9,$0000,$595E,$4FEF,$0030,$7000; $019890
    dc.w    $102A,$0001,$E548,$207C,$0005,$E7E4,$2F30,$0000; $0198A0
    dc.w    $4879,$0004,$1104,$4E93,$3004,$48C0,$5480,$2F00; $0198B0
    dc.w    $3005,$48C0,$5A80,$2F00,$4E94,$2F0A,$4EB9,$0000; $0198C0
    dc.w    $7402,$588F,$2F00,$2F0A,$4EB9,$0000,$74E0,$588F; $0198D0
    dc.w    $207C,$00FF,$1278,$1030,$0000,$0280,$0000,$00FF; $0198E0
    dc.w    $E548,$207C,$0005,$ECFC,$2F30,$0000,$4879,$0004; $0198F0
    dc.w    $10FC,$4E93,$3003,$48C0,$2F00,$4878,$0001,$3004; $019900
    dc.w    $48C0,$5880,$2F00,$3005,$48C0,$2F00,$2F0A,$4EBA; $019910
    dc.w    $00DA,$4E71,$4FEF,$0030,$3003,$48C0,$2F00,$4878; $019920
    dc.w    $0001,$3004,$48C0,$5880,$2F00,$3005,$48C0,$0680; $019930
    dc.w    $0000,$000F,$2F00,$2F0A,$4EBA,$049C,$4E71,$4FEF; $019940
    dc.w    $0014,$76FF,$102A,$000A,$0800,$0002,$6704,$7600; $019950
    dc.w    $601A,$102A,$000A,$0800,$0001,$6704,$7610,$600C; $019960
    dc.w    $102A,$000A,$0800,$0000,$6702,$7608,$70FF,$B083; $019970
    dc.w    $6C6E,$4242,$3002,$48C0,$D083,$0680,$0000,$637B; $019980
    dc.w    $2600,$3002,$D040,$3D83,$00F0,$5283,$5242,$0C42; $019990
    dc.w    $0008,$6DEE,$486E,$FFF0,$4878,$0002,$4878,$0004; $0199A0
    dc.w    $3004,$48C0,$5480,$2F00,$3005,$48C0,$2F00,$42A7; $0199B0
    dc.w    $4878,$001B,$4EB9,$0000,$0D64,$4879,$0004,$E28A; $0199C0
    dc.w    $2F0D,$4EB9,$0000,$3FEC,$4FEF,$0024,$42A7,$42A7; $0199D0
    dc.w    $2F0D,$4878,$0018,$4878,$037B,$4EB9,$0001,$D568; $0199E0
    dc.w    $4CEE,$3C3C,$FFD0,$4E5E,$4E75,$4E56,$0000,$48E7; $0199F0
    dc.w    $3F3C,$246E,$0008,$267C,$0000,$0D64,$49EE,$0016; $019A00
    dc.w    $4BEE,$0012,$0C6E,$0001,$001A,$6650,$2F39,$000A; $019A10
    dc.w    $1AE4,$4879,$00FF,$1804,$4EB9,$0000,$3FEC,$4878; $019A20
    dc.w    $0020,$4878,$0694,$4879,$00FF,$1804,$4EB9,$0000; $019A30
    dc.w    $4668,$4879,$0007,$0F38,$4878,$0004,$4878,$0004; $019A40
    dc.w    $3015,$48C0,$2F00,$302E,$000E,$48C0,$2F00,$4878; $019A50
    dc.w    $0001,$4878,$001B,$4E93,$4FEF,$0030,$4878,$0020; $019A60
    dc.w    $4878,$0020,$42A7,$42A7,$4EB9,$0003,$A942,$4FEF; $019A70
    dc.w    $0010,$3C2E,$000E,$5846,$3A15,$4244,$302A,$000E; $019A80
    dc.w    $B06A,$0006,$6300,$0122,$3E3C,$0331,$3004,$48C0; $019A90
    dc.w    $3207,$48C1,$D081,$5380,$2F00,$4878,$0001,$4878; $019AA0
    dc.w    $000A,$3005,$48C0,$2F00,$3006,$48C0,$2F00,$3014; $019AB0
    dc.w    $48C0,$2F00,$4878,$001A,$4E93,$302A,$000E,$2F00; $019AC0
    dc.w    $4878,$0064,$302A,$0006,$2F00,$4EB9,$0001,$E11C; $019AD0
    dc.w    $4FEF,$0028,$3600,$48C0,$720A,$4EB9,$0003,$E08A; $019AE0
    dc.w    $3400,$4A42,$6F36,$3004,$48C0,$3207,$48C1,$D081; $019AF0
    dc.w    $5080,$2F00,$4878,$0001,$3002,$48C0,$2F00,$3005; $019B00
    dc.w    $48C0,$5280,$2F00,$3006,$48C0,$2F00,$3014,$48C0; $019B10
    dc.w    $2F00,$4878,$001A,$4E93,$4FEF,$001C,$3003,$48C0; $019B20
    dc.w    $720A,$4EB9,$0003,$E146,$E788,$720A,$4EB9,$0003; $019B30
    dc.w    $E08A,$D047,$3600,$3004,$48C0,$3203,$48C1,$D081; $019B40
    dc.w    $2F00,$4878,$0001,$4878,$0001,$3005,$48C0,$5280; $019B50
    dc.w    $2F00,$3006,$48C0,$3202,$48C1,$D081,$2F00,$3014; $019B60
    dc.w    $48C0,$2F00,$4878,$001A,$4E93,$4FEF,$001C,$5242; $019B70
    dc.w    $0C42,$000A,$6C00,$01B6,$3004,$48C0,$3207,$48C1; $019B80
    dc.w    $D081,$2F00,$4878,$0001,$3002,$48C0,$720A,$9280; $019B90
    dc.w    $2F01,$3005,$48C0,$5280,$2F00,$3006,$48C0,$3202; $019BA0
    dc.w    $48C1,$D081,$6000,$0174,$4A6A,$0006,$6700,$011C; $019BB0
    dc.w    $3E3C,$0328,$3004,$48C0,$3207,$48C1,$D081,$0680; $019BC0
    dc.w    $0000,$0011,$2F00,$4878,$0001,$4878,$000A,$3005; $019BD0
    dc.w    $48C0,$5280,$2F00,$3006,$48C0,$2F00,$3014,$48C0; $019BE0
    dc.w    $2F00,$4878,$001A,$4E93,$302A,$0006,$2F00,$4878; $019BF0
    dc.w    $0064,$302A,$000E,$2F00,$4EB9,$0001,$E11C,$4FEF; $019C00
    dc.w    $0028,$3600,$48C0,$720A,$4EB9,$0003,$E08A,$3400; $019C10
    dc.w    $4A42,$6F34,$3004,$48C0,$3207,$48C1,$D081,$5080; $019C20
    dc.w    $2F00,$4878,$0001,$3002,$48C0,$2F00,$3005,$48C0; $019C30
    dc.w    $2F00,$3006,$48C0,$2F00,$3014,$48C0,$2F00,$4878; $019C40
    dc.w    $001A,$4E93,$4FEF,$001C,$0C42,$000A,$6C00,$00DE; $019C50
    dc.w    $3003,$48C0,$720A,$4EB9,$0003,$E146,$E788,$720A; $019C60
    dc.w    $4EB9,$0003,$E08A,$DE40,$3004,$48C0,$3207,$48C1; $019C70
    dc.w    $D081,$2F00,$4878,$0001,$4878,$0001,$3005,$48C0; $019C80
    dc.w    $2F00,$3006,$48C0,$3202,$48C1,$D081,$2F00,$3014; $019C90
    dc.w    $48C0,$2F00,$4878,$001A,$4E93,$4FEF,$001C,$5242; $019CA0
    dc.w    $0C42,$000A,$6C00,$0086,$3004,$48C0,$0680,$0000; $019CB0
    dc.w    $0328,$2F00,$4878,$0001,$3002,$48C0,$720A,$9280; $019CC0
    dc.w    $2F01,$3005,$48C0,$6000,$FED0,$3004,$48C0,$0680; $019CD0
    dc.w    $0000,$0328,$2F00,$4878,$0001,$4878,$000A,$3005; $019CE0
    dc.w    $48C0,$2F00,$3006,$48C0,$2F00,$3014,$48C0,$2F00; $019CF0
    dc.w    $4878,$001A,$4E93,$4FEF,$001C,$3004,$48C0,$0680; $019D00
    dc.w    $0000,$0328,$2F00,$4878,$0001,$4878,$000A,$3005; $019D10
    dc.w    $48C0,$5280,$2F00,$3006,$48C0,$2F00,$3014,$48C0; $019D20
    dc.w    $2F00,$4878,$001A,$4E93,$4FEF,$001C,$3015,$48C0; $019D30
    dc.w    $2F00,$302E,$000E,$48C0,$5880,$2F00,$4EB9,$0003; $019D40
    dc.w    $AB2C,$7000,$302A,$000E,$2F00,$4879,$0004,$1116; $019D50
    dc.w    $4EB9,$0003,$B270,$2F0A,$4EB9,$0000,$74E0,$3400; $019D60
    dc.w    $C0FC,$000C,$207C,$00FF,$A6B9,$1030,$0000,$0280; $019D70
    dc.w    $0000,$00FF,$C0FC,$000A,$3400,$2F00,$4878,$0064; $019D80
    dc.w    $302A,$0010,$2F00,$4EB9,$0001,$E11C,$3600,$0C43; $019D90
    dc.w    $0064,$6C06,$3003,$48C0,$6002,$7064,$3600,$3015; $019DA0
    dc.w    $48C0,$5480,$2F00,$302E,$000E,$48C0,$0680,$0000; $019DB0
    dc.w    $0009,$2F00,$4EB9,$0003,$AB2C,$3003,$48C0,$2F00; $019DC0
    dc.w    $4879,$0004,$1110,$4EB9,$0003,$B270,$4CEE,$3CFC; $019DD0
    dc.w    $FFD8,$4E5E,$4E75,$4E56,$0000,$48E7,$3F3C,$246E; $019DE0
    dc.w    $0008,$267C,$0000,$0D64,$49EE,$0016,$4BEE,$0012; $019DF0
    dc.w    $0C6E,$0001,$001A,$6650,$2F39,$000A,$1AE4,$4879; $019E00
    dc.w    $00FF,$1804,$4EB9,$0000,$3FEC,$4878,$0020,$4878; $019E10
    dc.w    $0694,$4879,$00FF,$1804,$4EB9,$0000,$4668,$4879; $019E20
    dc.w    $0007,$0F58,$4878,$0004,$4878,$0004,$3015,$48C0; $019E30
    dc.w    $2F00,$302E,$000E,$48C0,$2F00,$4878,$0001,$4878; $019E40
    dc.w    $001B,$4E93,$4FEF,$0030,$4878,$0020,$4878,$0020; $019E50
    dc.w    $42A7,$42A7,$4EB9,$0003,$A942,$3E2E,$000E,$5847; $019E60
    dc.w    $3C15,$4245,$7000,$102A,$0001,$2F00,$7000,$1012; $019E70
    dc.w    $2F00,$4EB9,$0000,$70DC,$3400,$4878,$0064,$4878; $019E80
    dc.w    $0096,$3002,$2F00,$4EB9,$0001,$E11C,$4FEF,$0024; $019E90
    dc.w    $3002,$48C0,$7214,$4EB9,$0003,$E08A,$3800,$4A6A; $019EA0
    dc.w    $0004,$674E,$7000,$302A,$0004,$3202,$48C1,$B081; $019EB0
    dc.w    $6F22,$7000,$302A,$0004,$3202,$48C1,$9081,$3204; $019EC0
    dc.w    $48C1,$4EB9,$0003,$E08A,$2600,$C6FC,$0005,$0643; $019ED0
    dc.w    $0032,$601E,$3002,$48C0,$7200,$322A,$0004,$9081; $019EE0
    dc.w    $3204,$48C1,$4EB9,$0003,$E08A,$C0FC,$0005,$7632; $019EF0
    dc.w    $9640,$0C43,$0064,$6C06,$3003,$48C0,$6002,$7064; $019F00
    dc.w    $3600,$4A43,$6F06,$3003,$48C0,$6002,$7000,$3600; $019F10
    dc.w    $48C0,$720A,$4EB9,$0003,$E08A,$3400,$3003,$48C0; $019F20
    dc.w    $720A,$4EB9,$0003,$E146,$7201,$B280,$6F0E,$3003; $019F30
    dc.w    $48C0,$720A,$4EB9,$0003,$E146,$6002,$7001,$3800; $019F40
    dc.w    $4A42,$6F34,$3005,$48C0,$0680,$0000,$033A,$2F00; $019F50
    dc.w    $4878,$0001,$3002,$48C0,$2F00,$3006,$48C0,$5280; $019F60
    dc.w    $2F00,$3007,$48C0,$2F00,$3014,$48C0,$2F00,$4878; $019F70
    dc.w    $001A,$4E93,$4FEF,$001C,$4A44,$6738,$3005,$48C0; $019F80
    dc.w    $0680,$0000,$033B,$2F00,$4878,$0001,$4878,$0001; $019F90
    dc.w    $3006,$48C0,$5280,$2F00,$3007,$48C0,$3202,$48C1; $019FA0
    dc.w    $D081,$2F00,$3014,$48C0,$2F00,$4878,$001A,$4E93; $019FB0
    dc.w    $4FEF,$001C,$3002,$48C0,$720A,$9280,$3004,$48C0; $019FC0
    dc.w    $9280,$6F4A,$3005,$48C0,$0680,$0000,$033C,$2F00; $019FD0
    dc.w    $4878,$0001,$3002,$48C0,$720A,$9280,$3004,$48C0; $019FE0
    dc.w    $9280,$2F01,$3006,$48C0,$5280,$2F00,$3007,$48C0; $019FF0
    dc.w    $3202,$48C1,$D081,$3204,$48C1,$D081,$2F00,$3014; $01A000
    dc.w    $48C0,$2F00,$4878,$001A,$4E93,$4FEF,$001C,$3015; $01A010
    dc.w    $48C0,$2F00,$302E,$000E,$48C0,$0680,$0000,$0009; $01A020
    dc.w    $2F00,$4EB9,$0003,$AB2C,$7000,$302A,$0004,$2F00; $01A030
    dc.w    $4879,$0004,$1128,$4EB9,$0003,$B246,$3015,$48C0; $01A040
    dc.w    $5280,$2F00,$302E,$000E,$48C0,$0680,$0000,$0009; $01A050
    dc.w    $2F00,$4EB9,$0003,$AB2C,$0443,$0032,$3003,$48C0; $01A060
    dc.w    $2F00,$4879,$0004,$1122,$4EB9,$0003,$B246,$4FEF; $01A070
    dc.w    $0020,$0C2A,$000E,$000B,$6408,$7800,$182A,$000B; $01A080
    dc.w    $6002,$780E,$0C44,$0007,$6C06,$3404,$48C2,$6002; $01A090
    dc.w    $7407,$3005,$48C0,$0680,$0000,$033E,$2F00,$4878; $01A0A0
    dc.w    $0001,$3002,$48C0,$2F00,$3006,$48C0,$5480,$2F00; $01A0B0
    dc.w    $3007,$48C0,$2F00,$3014,$48C0,$2F00,$4878,$001A; $01A0C0
    dc.w    $4E93,$4FEF,$001C,$0C42,$0007,$6C3E,$3005,$48C0; $01A0D0
    dc.w    $0680,$0000,$0328,$2F00,$4878,$0001,$3002,$48C0; $01A0E0
    dc.w    $7207,$9280,$2F01,$3006,$48C0,$5480,$2F00,$3007; $01A0F0
    dc.w    $48C0,$3202,$48C1,$D081,$2F00,$3014,$48C0,$2F00; $01A100
    dc.w    $4878,$001A,$4E93,$4FEF,$001C,$0C2A,$0007,$0003; $01A110
    dc.w    $6408,$7400,$142A,$0003,$6002,$7407,$3005,$48C0; $01A120
    dc.w    $0680,$0000,$033D,$2F00,$4878,$0001,$3002,$48C0; $01A130
    dc.w    $2F00,$3006,$48C0,$5480,$2F00,$3007,$48C0,$2F00; $01A140
    dc.w    $3014,$48C0,$2F00,$4878,$001A,$4E93,$4FEF,$001C; $01A150
    dc.w    $3404,$0642,$FFF9,$4A42,$6F06,$3002,$48C0,$6002; $01A160
    dc.w    $7000,$3400,$4A42,$6F78,$3005,$48C0,$0680,$0000; $01A170
    dc.w    $033E,$2F00,$4878,$0001,$3002,$48C0,$2F00,$3006; $01A180
    dc.w    $48C0,$5680,$2F00,$3007,$48C0,$2F00,$3014,$48C0; $01A190
    dc.w    $2F00,$4878,$001A,$4E93,$4FEF,$001C,$0C42,$0007; $01A1A0
    dc.w    $6C3E,$3005,$48C0,$0680,$0000,$0328,$2F00,$4878; $01A1B0
    dc.w    $0001,$3002,$48C0,$7207,$9280,$2F01,$3006,$48C0; $01A1C0
    dc.w    $5680,$2F00,$3007,$48C0,$3202,$48C1,$D081,$2F00; $01A1D0
    dc.w    $3014,$48C0,$2F00,$4878,$001A,$4E93,$4FEF,$001C; $01A1E0
    dc.w    $0C42,$0007,$6C3E,$3005,$48C0,$0680,$0000,$0328; $01A1F0
    dc.w    $2F00,$4878,$0001,$3002,$48C0,$7207,$9280,$2F01; $01A200
    dc.w    $3006,$48C0,$5680,$2F00,$3007,$48C0,$3202,$48C1; $01A210
    dc.w    $D081,$2F00,$3014,$48C0,$2F00,$4878,$001A,$4E93; $01A220
    dc.w    $4FEF,$001C,$7400,$142A,$0003,$0642,$FFF9,$4A42; $01A230
    dc.w    $6F34,$3005,$48C0,$0680,$0000,$033D,$2F00,$4878; $01A240
    dc.w    $0001,$3002,$48C0,$2F00,$3006,$48C0,$5680,$2F00; $01A250
    dc.w    $3007,$48C0,$2F00,$3014,$48C0,$2F00,$4878,$001A; $01A260
    dc.w    $4E93,$4FEF,$001C,$3015,$48C0,$5480,$2F00,$302E; $01A270
    dc.w    $000E,$48C0,$0680,$0000,$000A,$2F00,$4EB9,$0003; $01A280
    dc.w    $AB2C,$7000,$102A,$0003,$2F00,$4879,$0004,$111C; $01A290
    dc.w    $4EB9,$0003,$B270,$3015,$5440,$2F00,$302E,$000E; $01A2A0
    dc.w    $0640,$000D,$2F00,$4878,$0002,$4878,$0003,$4EB9; $01A2B0
    dc.w    $0000,$595E,$4CEE,$3CFC,$FFD8,$4E5E,$4E75         ; $01A2C0
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
    moveq   #$ff,d0
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

