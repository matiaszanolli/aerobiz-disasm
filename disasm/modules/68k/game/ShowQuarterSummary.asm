; ============================================================================
; ShowQuarterSummary -- Displays the end-of-quarter summary screen; calls route-selection and profit helpers, shows a summary dialog with route results and financial totals.
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
