; ============================================================================
; AcquireCharSlot -- Adjusts char slot value by compatibility offset; updates char base stat if relation score exceeds threshold
; 218 bytes | $032CA0-$032D79
; ============================================================================
AcquireCharSlot:
    movem.l d2-d6/a2, -(a7)
    move.l  $24(a7), d2
    move.l  $1c(a7), d3
    move.l  $20(a7), d6
    move.w  d3, d0
    mulu.w  #$320, d0
    move.w  d6, d1
    mulu.w  #$14, d1
    add.w   d1, d0
    movea.l  #$00FF9A20,a0
    lea     (a0,d0.w), a0
    movea.l a0, a2
    moveq   #$0,d0
    move.b  $1(a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.b  (a2), d0
    ext.l   d0
    move.l  d0, -(a7)
    jsr CharCodeScore
    move.w  d0, d5
    move.w  $4(a2), d0
    sub.w   d5, d0
    ext.l   d0
    moveq   #$64,d1
    jsr Multiply32
    move.w  d5, d1
    ext.l   d1
    jsr SignedDiv
    move.w  d0, d4
    add.w   d2, d0
    move.w  d0, d2
    cmpi.w  #$32, d2
    bge.b   l_32d10
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d12
l_32d10:
    moveq   #$32,d0
l_32d12:
    move.w  d0, d2
    ext.l   d0
    moveq   #-$32,d1
    cmp.l   d0, d1
    bge.b   l_32d22
    move.w  d2, d0
    ext.l   d0
    bra.b   l_32d24
l_32d22:
    moveq   #-$32,d0
l_32d24:
    move.w  d0, d2
    ext.l   d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d6, d0
    move.l  d0, -(a7)
    moveq   #$0,d0
    move.w  d3, d0
    move.l  d0, -(a7)
    jsr (CalcRelationScore,PC)
    nop
    lea     $14(a7), a7
    cmp.w   $6(a2), d0
    bcc.b   l_32d48
    move.w  d4, d2
l_32d48:
    cmp.w   d4, d2
    bne.b   l_32d50
    clr.w   d3
    bra.b   l_32d72
l_32d50:
    move.w  d5, d0
    ext.l   d0
    move.w  d2, d1
    ext.l   d1
    addi.l  #$64, d1
    jsr Multiply32
    moveq   #$64,d1
    jsr SignedDiv
    move.w  d0, $4(a2)
    moveq   #$1,d3
l_32d72:
    move.w  d3, d0
    movem.l (a7)+, d2-d6/a2
    rts

CalcRelationScore:                                                  ; $032D7A
    movem.l d2-d6/a2-a5,-(sp)
    move.l  $0028(sp),d2
    move.l  $002c(sp),d3
    move.l  $0030(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d3,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.l  a2,-(sp)
    dc.w    $4eb9,$0000,$74e0                           ; jsr $0074E0
    addq.l  #$4,sp
    move.w  d0,d2
    mulu.w  #$c,d0
    movea.l #$00ffa6b8,a0
    lea     (a0,d0.w),a0
    movea.l a0,a5
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    bge.b   .l32e54
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$8,sp
    lsl.w   #$2,d0
    movea.l #$00ffbde4,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    moveq   #$0,d1
    move.w  (a4),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    moveq   #$0,d1
    move.w  (a3),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.w  (a3),d1
    moveq   #$0,d2
    move.w  (a4),d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e0c6                           ; jsr $03E0C6
    bra.w   .l32eda
.l32e54:                                                ; $032E54
    moveq   #$0,d0
    move.b  (a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  $0001(a2),d0
    lsl.w   #$2,d0
    movea.l #$00ff1298,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0003(a4),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a4),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  $0003(a3),d0
    andi.l  #$ffff,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    add.l   (sp)+,d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    andi.l  #$ffff,d1
    moveq   #$0,d2
    move.b  $0001(a4),d2
    andi.l  #$ffff,d2
    add.l   d2,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
.l32eda:                                                ; $032EDA
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$70dc                           ; jsr $0070DC
    addq.l  #$8,sp
    move.w  d0,d3
    move.w  $0004(a2),d0
    sub.w   d3,d0
    ext.l   d0
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.w  d3,d1
    ext.l   d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d5
    moveq   #$0,d0
    move.w  d2,d0
    move.w  d4,d1
    ext.l   d1
    sub.l   d1,d0
    addi.l  #$32,d0
    moveq   #$0,d1
    move.w  $0008(a2),d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    move.w  d5,d6
    ext.l   d6
    sub.l   d6,d1
    addi.l  #$32,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$0,d1
    move.w  d2,d1
    cmp.l   d1,d0
    ble.b   .l32f7c
    moveq   #$0,d0
    move.w  d2,d0
    bra.b   .l32fa2
.l32f7c:                                                ; $032F7C
    moveq   #$0,d0
    move.b  $0001(a5),d0
    andi.l  #$ffff,d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    add.l   d0,d0
    moveq   #$0,d1
    move.b  $0003(a2),d1
    andi.l  #$ffff,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
.l32fa2:                                                ; $032FA2
    move.w  d0,d2
    move.w  d3,d0
    ext.l   d0
    move.w  d4,d1
    ext.l   d1
    addi.l  #$64,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    moveq   #$64,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d3
    moveq   #$0,d0
    move.w  d2,d0
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    moveq   #$0,d1
    move.w  d3,d1
    dc.w    $4eb9,$0003,$e05c                           ; jsr $03E05C
    move.l  #$2710,d1
    dc.w    $4eb9,$0003,$e08a                           ; jsr $03E08A
    move.w  d0,d2
    movem.l (sp)+,d2-d6/a2-a5
    rts
DegradeSkillLinked:                                          ; $032FEC
    dc.w    $4E56,$0000                                      ; link a6,#0 [falls through to DegradeCharSkill]
; === Translated block $032FF0-$0332DE ===
; 2 functions, 750 bytes
