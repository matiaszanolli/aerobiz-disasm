; ============================================================================
; FindCharSlot -- Find absolute roster index for char code D4 in player D2 slot; return -1 if not found
; Called: ?? times.
; 114 bytes | $00759E-$00760F
; ============================================================================
FindCharSlot:                                                  ; $00759E
    movem.l d2-d6/a2,-(sp)
    move.l  $001c(sp),d2
    move.l  $0020(sp),d4
    clr.w   d5
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d3
    move.b  $0004(a1),d3
    move.w  d3,d6
    move.w  d2,d0
    mulu.w  #$0320,d0
    move.w  d6,d1
    mulu.w  #$14,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l75f8
.l75e4:                                                 ; $0075E4
    moveq   #$0,d0
    move.b  (a2),d0
    cmp.w   d4,d0
    bne.b   .l75f0
    moveq   #$1,d5
    bra.b   .l7602
.l75f0:                                                 ; $0075F0
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d3
    addq.w  #$1,d2
.l75f8:                                                 ; $0075F8
    moveq   #$0,d0
    move.b  $0005(a1),d0
    cmp.w   d2,d0
    bhi.b   .l75e4
.l7602:                                                 ; $007602
    tst.w   d5
    bne.b   .l7608
    moveq   #-$1,d3
.l7608:                                                 ; $007608
    move.w  d3,d0
    movem.l (sp)+,d2-d6/a2
    rts
