; ============================================================================
; CalcRecruitmentCost -- Finds best char replacement for a slot; transfers or trains char based on skill level comparison
; 274 bytes | $0331CC-$0332DD
; ============================================================================
CalcRecruitmentCost:
    link    a6,#-$4
    movem.l d2-d7/a2-a5, -(a7)
    move.l  $8(a6), d3
    move.l  $10(a6), d4
    move.l  $c(a6), d5
    clr.w   d7
    moveq   #$0,d0
    move.w  d4, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (FindBestCharForSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d2
    cmpi.w  #$10, d2
    bcc.w   l_332d2
    move.w  d2, d0
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a4
    move.w  d3, d0
    lsl.w   #$5, d0
    move.w  d2, d1
    add.w   d1, d1
    add.w   d1, d0
    movea.l  #$00FFB9E8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d5, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a3
    move.l  a3, -(a7)
    jsr GetByteField4
    move.w  d0, d6
    mulu.w  #$c, d0
    movea.l  #$00FFA6B8,a0
    lea     (a0,d0.w), a0
    movea.l a0, a5
    move.l  a3, -(a7)
    jsr GetLowNibble
    addq.l  #$8, a7
    move.w  d0, d6
    tst.w   d4
    bne.b   l_332b4
    moveq   #$0,d0
    move.b  $1(a2), d0
    moveq   #$0,d1
    move.b  $1(a4), d1
    mulu.w  d1, d0
    move.w  d0, -$2(a6)
    moveq   #$0,d4
    move.b  $1(a5), d4
    mulu.w  d6, d4
    cmp.w   -$2(a6), d4
    bhi.b   l_332c0
l_33294:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d5, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (TransferCharSlot,PC)
    nop
    lea     $c(a7), a7
    move.w  d0, d7
    bra.b   l_332d2
l_332b4:
    cmpi.w  #$1, d4
    bne.b   l_332d2
    tst.b   $1(a2)
    bne.b   l_33294
l_332c0:
    moveq   #$0,d0
    move.w  d2, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (TrainCharSkill,PC)
    nop
l_332d2:
    move.w  d7, d0
    movem.l -$2c(a6), d2-d7/a2-a5
    unlk    a6
    rts

FindBestCharForSlot:                                                  ; $0332DE
    link    a6,#-$4
    movem.l d2-d7/a2-a3,-(sp)
    move.l  $000c(a6),d2
    move.l  $0010(a6),d5
    move.w  #$ff,d6
    move.w  $000a(a6),d0
    mulu.w  #$0320,d0
    move.w  d2,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6f42                           ; jsr $006F42
    move.w  d0,-$0002(a6)
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    lea     $000c(sp),sp
    move.w  d0,d2
    tst.w   d5
    bne.b   .l33354
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ffa6b9,a0
    move.b  (a0,d0.w),d3
    andi.l  #$ff,d3
    bra.b   .l3338e
.l33354:                                                ; $033354
    cmpi.w  #$1,d5
    bne.b   .l3338e
    pea     ($0001).w
    move.l  a3,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    andi.l  #$ffff,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr $0206EE
    lea     $0010(sp),sp
    move.w  d0,d3
.l3338e:                                                ; $03338E
    move.w  ($00FF0006).l,d0
    ext.l   d0
    bge.b   .l3339a
    addq.l  #$3,d0
.l3339a:                                                ; $03339A
    asr.l   #$2,d0
    addi.w  #$37,d0
    move.w  d0,d7
    movea.l #$00ffa6b8,a2
    clr.w   d2
.l333aa:                                                ; $0333AA
    move.w  $0002(a2),d0
    cmp.w   -$0002(a6),d0
    bcs.w   .l33444
    moveq   #$0,d0
    move.b  $0006(a2),d0
    addi.w  #$ffff,d0
    ext.l   d0
    moveq   #$0,d1
    move.w  d7,d1
    cmp.l   d1,d0
    bgt.b   .l33444
    moveq   #$0,d0
    move.w  d7,d0
    moveq   #$0,d1
    move.b  $0007(a2),d1
    ext.l   d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    bge.b   .l33444
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $000a(a6),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$8016                           ; jsr $008016
    addq.l  #$8,sp
    cmpi.w  #$ffff,d0
    beq.b   .l33444
    tst.w   d5
    bne.b   .l3340e
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$0,d1
    move.w  d3,d1
    cmp.l   d1,d0
    ble.b   .l33444
    moveq   #$0,d3
    move.b  $0001(a2),d3
    bra.b   .l33442
.l3340e:                                                ; $03340E
    cmpi.w  #$1,d5
    bne.b   .l33444
    pea     ($0001).w
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0001(a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a3),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0002,$06ee                           ; jsr $0206EE
    lea     $0010(sp),sp
    move.w  d0,d4
    cmp.w   d3,d4
    bcc.b   .l33444
    move.w  d4,d3
.l33442:                                                ; $033442
    move.w  d2,d6
.l33444:                                                ; $033444
    moveq   #$c,d0
    adda.l  d0,a2
    addq.w  #$1,d2
    cmpi.w  #$10,d2
    bcs.w   .l333aa
    move.w  d6,d0
    movem.l -$0024(a6),d2-d7/a2-a3
    unlk    a6
    rts
; === Translated block $03345E-$034CC4 ===
; 26 functions, 6246 bytes
