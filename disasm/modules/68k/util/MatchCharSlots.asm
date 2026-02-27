; ============================================================================
; MatchCharSlots -- Matches character slots between two players: calls RangeLookup to map player IDs to slot counts, then fills the 4-entry slot array at $FF8804 with matched character indices (0xFF when no match).
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
; === Translated block $01B49A-$01C43C ===
; 6 functions, 4002 bytes
