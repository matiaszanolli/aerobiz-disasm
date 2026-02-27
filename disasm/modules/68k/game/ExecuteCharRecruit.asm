; ============================================================================
; ExecuteCharRecruit -- Deducts char recruitment cost, writes char to skill slot, shows acquisition dialog; returns 1 on success
; 386 bytes | $03654E-$0366CF
; ============================================================================
ExecuteCharRecruit:
    link    a6,#-$4
    movem.l d2-d7/a2-a3, -(a7)
    move.l  $c(a6), d2
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.w  d3, d0
    mulu.w  #$24, d0
    movea.l  #$00FF0018,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    clr.w   d7
    cmpi.w  #$20, d2
    bcc.b   l_365a4
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d4, d0
    movea.l  #$00FF1704,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d2, d0
    mulu.w  #$6, d0
    add.w   d4, d0
    movea.l  #$00FF0420,a0
    bra.b   l_365c6
l_365a4:
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d4, d0
    movea.l  #$00FF15A0,a0
    move.b  (a0,d0.w), d5
    andi.l  #$ff, d5
    move.w  d2, d0
    lsl.w   #$2, d0
    add.w   d4, d0
    movea.l  #$00FF0460,a0
l_365c6:
    lea     (a0,d0.w), a0
    movea.l a0, a2
    cmpi.w  #$f, d5
    beq.w   l_366c4
    cmpi.b  #$ff, (a2)
    bne.w   l_366c4
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr CalcCharValue
    lea     $c(a7), a7
    move.l  d0, d6
    cmp.l   $6(a3), d6
    bcc.w   l_366c4
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    bsr.w FindNextOpenSkillSlot
    addq.l  #$8, a7
    move.w  d0, -$2(a6)
    cmpi.w  #$4, d0
    bcc.w   l_366c4
    sub.l   d6, $6(a3)
    move.b  d3, d0
    ori.b   #$80, d0
    move.b  d0, (a2)
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  -$2(a6), d1
    lsl.w   #$3, d1
    add.w   d1, d0
    movea.l  #$00FF0338,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.b  d2, (a2)
    move.b  #$5, $1(a2)
    move.b  d4, $2(a2)
    move.b  #$1, $3(a2)
    clr.w   $4(a2)
    clr.w   $6(a2)
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    jsr DrawBox
    move.w  d2, d0
    lsl.w   #$2, d0
    movea.l  #$0005E680,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d5, d0
    lsl.w   #$2, d0
    movea.l  #$0005E2A2,a0
    move.l  (a0,d0.w), -(a7)
    move.w  d3, d0
    lsl.w   #$4, d0
    movea.l  #$00FF00A8,a0
    pea     (a0, d0.w)
    pea     ($00044996).l
    jsr PrintfWide
    pea     ($0007).w
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr DrawPlayerRoutes
    pea     ($001E).w
    jsr PollInputChange
    moveq   #$1,d7
l_366c4:
    move.w  d7, d0
    movem.l -$24(a6), d2-d7/a2-a3
    unlk    a6
    rts

CollectCharRevenue:                                                  ; $0366D0
    link    a6,#$0
    movem.l d2-d6/a2-a4,-(sp)
    move.l  $0008(a6),d5
    move.l  $000c(a6),d6
    move.w  d5,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    movea.l #$00ff1704,a2
    movea.l #$00ff0420,a3
    clr.w   d3
.l36700:                                                ; $036700
    clr.w   d4
.l36702:                                                ; $036702
    cmpi.b  #$0f,(a2)
    beq.w   .l367a6
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.w  d5,d1
    cmp.l   d1,d0
    bne.w   .l367a6
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    lsr.l   #$2,d0
    sub.l   d0,d2
    add.l   d2,$0006(a4)
    move.b  #$ff,(a3)
    cmpi.w  #$1,d6
    bne.b   .l367a6
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000449C8).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0024(sp),sp
.l367a6:                                                ; $0367A6
    addq.l  #$1,a2
    addq.l  #$1,a3
    addq.w  #$1,d4
    cmpi.w  #$6,d4
    bcs.w   .l36702
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    bcs.w   .l36700
    movea.l #$00ff1620,a2
    movea.l #$00ff04e0,a3
    moveq   #$20,d3
.l367cc:                                                ; $0367CC
    clr.w   d4
.l367ce:                                                ; $0367CE
    cmpi.b  #$0f,(a2)
    beq.w   .l36872
    moveq   #$0,d0
    move.b  (a3),d0
    moveq   #$0,d1
    move.w  d5,d1
    cmp.l   d1,d0
    bne.w   .l36872
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d3,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d2
    lsr.l   #$2,d0
    sub.l   d0,d2
    add.l   d2,$0006(a4)
    move.b  #$ff,(a3)
    cmpi.w  #$1,d6
    bne.b   .l36872
    pea     ($0008).w
    pea     ($001C).w
    pea     ($0011).w
    pea     ($0002).w
    dc.w    $4eb9,$0000,$5a04                           ; jsr $005A04
    move.w  d3,d0
    lsl.w   #$2,d0
    movea.l #$0005e680,a0
    move.l  (a0,d0.w),-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$0005e2a2,a0
    move.l  (a0,d0.w),-(sp)
    move.w  d5,d0
    lsl.w   #$4,d0
    movea.l #$00ff00a8,a0
    pea     (a0,d0.w)
    pea     ($000449B2).l
    dc.w    $4eb9,$0003,$b270                           ; jsr $03B270
    pea     ($001E).w
    dc.w    $4eb9,$0001,$e2f4                           ; jsr $01E2F4
    lea     $0024(sp),sp
.l36872:                                                ; $036872
    addq.l  #$1,a2
    addq.l  #$1,a3
    addq.w  #$1,d4
    cmpi.w  #$4,d4
    bcs.w   .l367ce
    addq.w  #$1,d3
    cmpi.w  #$59,d3
    bcs.w   .l367cc
    movem.l -$0020(a6),d2-d6/a2-a4
    unlk    a6
    rts
; === Translated block $036894-$036F12 ===
; 7 functions, 1662 bytes
