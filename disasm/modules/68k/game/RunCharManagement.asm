; ============================================================================
; RunCharManagement -- Runs the full char management screen: initialises the char list, scans for best negotiation and performance candidates, optionally triggers an event, and shows contract or departure dialogs
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
