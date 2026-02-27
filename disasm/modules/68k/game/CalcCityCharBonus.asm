; ============================================================================
; CalcCityCharBonus -- Scans the assigned character list for a city/char slot and accumulates compatibility bonuses, cap-clamping the result into the slot's bonus byte at $FF1298
; ============================================================================
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
