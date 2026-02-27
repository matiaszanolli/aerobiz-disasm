; ============================================================================
; CalcPlayerWealth -- Computes a single player's total wealth: sums cash balance, outstanding loans, and three categories of route-slot values, returning the result in D0.
; Called: ?? times.
; 116 bytes | $026270-$0262E3
; ============================================================================
CalcPlayerWealth:                                                  ; $026270
    movem.l d2/a2-a3,-(sp)
    move.l  $0010(sp),d2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    move.w  d2,d0
    mulu.w  #$6,d0
    movea.l #$00ff0290,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d2,d0
    mulu.w  #$c,d0
    movea.l #$00ff03f0,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d2
    move.w  (a3),d2
    add.l   $000e(a1),d2
    moveq   #$0,d0
    move.w  $0002(a3),d0
    add.l   d0,d2
    moveq   #$0,d0
    move.w  $0004(a3),d0
    add.l   d0,d2
    moveq   #$0,d0
    move.w  (a2),d0
    moveq   #$0,d1
    move.w  $0002(a2),d1
    add.l   d1,d0
    moveq   #$0,d1
    move.w  $0004(a2),d1
    add.l   d1,d0
    add.l   d0,d2
    move.l  d2,d0
    movem.l (sp)+,d2/a2-a3
    rts
