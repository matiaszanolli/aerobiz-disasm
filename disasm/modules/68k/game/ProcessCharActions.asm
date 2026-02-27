; ============================================================================
; ProcessCharActions -- Processes all pending char actions for the current player; iterates char stat blocks, selects target chars via the selection UI, then calls ProcessCharacterAction for each active slot.
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
