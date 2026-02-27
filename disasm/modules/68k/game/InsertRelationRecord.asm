; ============================================================================
; InsertRelationRecord -- Insert new route entry into sorted player route array, shifting existing entries via memory copy
; Called: ?? times.
; 372 bytes | $0082E4-$008457
; ============================================================================
InsertRelationRecord:                                                  ; $0082E4
    movem.l d2-d3/a2-a5,-(sp)
    move.l  $001c(sp),d2
    movea.l $0020(sp),a2
    movea.l #$0001d538,a5
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    moveq   #$0,d0
    move.b  $0001(a2),d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$00ff08ec,a0
    and.l   (a0,d1.w),d0
    beq.b   .l834a
    move.b  (a2),d0
    cmp.b   $0001(a2),d0
    bls.b   .l834a
    moveq   #$0,d2
    move.b  $0001(a2),d2
    move.b  (a2),$0001(a2)
    move.b  d2,(a2)
.l834a:                                                 ; $00834A
    pea     ($0320).w
    pea     ($00FF1804).l
    clr.l   -(sp)
    move.l  a3,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.l  d0,-(sp)
    moveq   #$0,d0
    move.b  (a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    lea     $001c(sp),sp
    cmpi.w  #$1,d0
    bne.b   .l83a0
    moveq   #$0,d2
    move.b  $0004(a4),d2
    moveq   #$0,d0
    move.b  $0004(a4),d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    adda.l  d0,a3
    moveq   #$0,d3
    move.b  $0004(a4),d3
    moveq   #$0,d0
    move.b  $0005(a4),d0
    add.w   d0,d3
    bra.b   .l83a8
.l83a0:                                                 ; $0083A0
    clr.w   d2
    moveq   #$0,d3
    move.b  $0004(a4),d3
.l83a8:                                                 ; $0083A8
    addi.w  #$ffff,d3
    tst.w   d3
    ble.b   .l83f0
    bra.b   .l83e8
.l83b2:                                                 ; $0083B2
    move.b  (a2),d0
    cmp.b   (a3),d0
    bne.b   .l83d6
    move.b  $0001(a2),d0
    cmp.b   $0001(a3),d0
    bcc.b   .l83e2
.l83c2:                                                 ; $0083C2
    pea     ($0014).w
    move.l  a3,-(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
    bra.b   .l83ec
.l83d6:                                                 ; $0083D6
    move.b  (a2),d0
    cmp.b   (a3),d0
    bcs.b   .l83c2
    cmpi.b  #$ff,(a3)
    beq.b   .l83c2
.l83e2:                                                 ; $0083E2
    moveq   #$14,d0
    adda.l  d0,a3
    addq.w  #$1,d2
.l83e8:                                                 ; $0083E8
    cmp.w   d3,d2
    blt.b   .l83b2
.l83ec:                                                 ; $0083EC
    cmp.w   d3,d2
    bne.b   .l8402
.l83f0:                                                 ; $0083F0
    pea     ($0014).w
    move.l  a3,-(sp)
    clr.l   -(sp)
    move.l  a2,-(sp)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
.l8402:                                                 ; $008402
    move.w  d2,d0
    ext.l   d0
    moveq   #$28,d1
    sub.l   d0,d1
    subq.l  #$1,d1
    ble.b   .l8452
    move.w  d2,d0
    ext.l   d0
    moveq   #$28,d1
    sub.l   d0,d1
    move.l  d1,d0
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    subi.l  #$14,d0
    move.l  d0,-(sp)
    move.l  a3,d0
    moveq   #$14,d1
    add.l   d1,d0
    move.l  d0,-(sp)
    clr.l   -(sp)
    move.w  d2,d0
    ext.l   d0
    move.l  d0,d1
    lsl.l   #$2,d0
    add.l   d1,d0
    lsl.l   #$2,d0
    lsr.l   #$1,d0
    add.w   d0,d0
    movea.l #$00ff1804,a0
    pea     (a0,d0.w)
    clr.l   -(sp)
    jsr     (a5)
    lea     $0014(sp),sp
.l8452:                                                 ; $008452
    movem.l (sp)+,d2-d3/a2-a5
    rts
