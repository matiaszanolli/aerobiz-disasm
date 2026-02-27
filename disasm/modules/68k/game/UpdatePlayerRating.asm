; ============================================================================
; UpdatePlayerRating -- Scans player char slots for rival match; returns lowest-cost slot index or $FF on failure
; 214 bytes | $034BEE-$034CC3
; ============================================================================
UpdatePlayerRating:
    movem.l d2-d6/a2-a3, -(a7)
    move.l  $20(a7), d2
    move.l  $24(a7), d6
    move.w  #$ff, d5
    move.w  d2, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr BitFieldSearch
    addq.l  #$8, a7
    move.w  d0, d4
    cmpi.w  #$20, d4
    bcc.w   l_34cbc
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr CountMatchingChars
    addq.l  #$8, a7
    cmpi.w  #$2, d0
    ble.b   l_34cbc
    move.w  #$ffff, d3
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    jsr FindCharSlot
    addq.l  #$8, a7
    move.w  d0, d6
    ext.l   d0
    moveq   #-$1,d1
    cmp.l   d0, d1
    beq.b   l_34cbc
    move.w  d2, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d6, d2
    bra.b   l_34ca6
l_34c88:
    moveq   #$0,d0
    move.b  (a2), d0
    moveq   #$0,d1
    move.w  d4, d1
    cmp.l   d1, d0
    bgt.b   l_34cbc
    cmp.w   $8(a2), d3
    bls.b   l_34ca0
    move.w  $8(a2), d3
    move.w  d2, d5
l_34ca0:
    moveq   #$14,d0
    adda.l  d0, a2
    addq.w  #$1, d2
l_34ca6:
    moveq   #$0,d0
    move.b  $4(a3), d0
    moveq   #$0,d1
    move.b  $5(a3), d1
    add.l   d1, d0
    moveq   #$0,d1
    move.w  d2, d1
    cmp.l   d1, d0
    bgt.b   l_34c88
l_34cbc:
    move.w  d5, d0
    movem.l (a7)+, d2-d6/a2-a3
    rts

RemoveCharRelation:                                                  ; $034CC4
    link    a6,#-$3c
    movem.l d2-d7/a2-a4,-(sp)
    move.l  $0008(a6),d2
    move.l  $000c(a6),d3
    movea.l #$00ff9a20,a4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.w   .l34f80
    moveq   #$0,d0
    move.b  $0004(a3),d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    ble.w   .l34f80
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lea     (a4,d0.l),a0
    adda.l  (sp)+,a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     -$001e(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    pea     -$003c(a6)
    dc.w    $4eb9,$0003,$b22c                           ; jsr $03B22C
    pea     ($0003).w
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$a506                           ; jsr $01A506
    bge.b   .l34d8c
    addq.l  #$1,d0
.l34d8c:                                                ; $034D8C
    asr.l   #$1,d0
    move.l  d0,d5
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    move.w  d0,d4
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    move.w  d0,d7
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$7402                           ; jsr $007402
    lea     $0028(sp),sp
    move.w  d0,d6
    cmpi.b  #$20,$0001(a2)
    bcc.b   .l34de2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$00ffa6a0,a0
    eor.l   d0,(a0,d1.w)
    subq.b  #$01,$0002(a3)
    bra.b   .l34e22
.l34de2:                                                ; $034DE2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    lsl.w   #$2,d1
    movea.l #$0005ecbe,a0
    move.b  (a0,d1.w),d1
    andi.l  #$ff,d1
    sub.w   d1,d0
    moveq   #$1,d1
    lsl.w   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    mulu.w  #$e,d1
    movea.l d7,a0
    move.w  d4,d7
    add.w   d7,d7
    exg     d7,a0
    add.w   a0,d1
    movea.l #$00ffbd6c,a0
    eor.w   d0,(a0,d1.w)
    subq.b  #$01,$0003(a3)
.l34e22:                                                ; $034E22
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
    add.l   d5,$0006(a3)
    subq.b  #$01,$0005(a3)
    move.w  d2,d0
    lsl.w   #$5,d0
    move.w  d7,d1
    add.w   d1,d1
    add.w   d1,d0
    movea.l #$00ffb9e9,a0
    add.b   d6,(a0,d0.w)
    cmpi.w  #$27,d3
    bcc.b   .l34eaa
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$28,d1
    sub.l   d0,d1
    move.l  d1,d0
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    subi.l  #$14,d0
    move.l  d0,-(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    move.l  a2,d0
    moveq   #$14,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    dc.w    $4eb9,$0001,$d538                           ; jsr $01D538
    lea     $0014(sp),sp
.l34eaa:                                                ; $034EAA
    pea     ($0014).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    lea     (a4,d0.l),a0
    lea     $030c(a0),a0
    move.l  a0,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $000c(sp),sp
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030c(a4),a1
    move.b  #$ff,(a1,a0.l)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  #$0320,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    movea.l d0,a0
    lea     $030d(a4),a1
    move.b  #$ff,(a1,a0.l)
    cmpi.w  #$1,$0012(a6)
    bne.b   .l34f80
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    pea     -$003c(a6)
    pea     -$001e(a6)
    move.w  d2,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000448E4).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($0001).w
    clr.l   -(sp)
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$68ca                           ; jsr $0068CA
    lea     $002c(sp),sp
    pea     ($0002).w
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6b78                           ; jsr $006B78
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
.l34f80:                                                ; $034F80
    movem.l -$0060(a6),d2-d7/a2-a4
    unlk    a6
    rts
    dc.w    $48E7,$3020,$242F; $034F8A
; === Translated block $034F90-$0357FE ===
; 11 functions, 2158 bytes
