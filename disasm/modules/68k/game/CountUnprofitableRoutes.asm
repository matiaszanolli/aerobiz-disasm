; ============================================================================
; CountUnprofitableRoutes -- Count unprofitable routes for a player; return -1 if no routes, -2 if no established routes, else count
; Called: ?? times.
; 130 bytes | $00FF76-$00FFF7
; ============================================================================
CountUnprofitableRoutes:                                                  ; $00FF76
    movem.l d2-d5/a2,-(sp)
    move.l  $0018(sp),d2
    clr.w   d5
    clr.w   d4
    clr.w   d3
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d1
    move.b  $0004(a1),d1
    moveq   #$0,d0
    move.b  $0005(a1),d0
    add.w   d0,d1
    clr.w   d2
    bra.b   .lffdc
.lffba:                                                 ; $00FFBA
    move.w  $000e(a2),d0
    cmp.w   $0006(a2),d0
    bcc.b   .lffc6
    addq.w  #$1,d4
.lffc6:                                                 ; $00FFC6
    move.b  $000a(a2),d0
    andi.l  #$4,d0
    bne.b   .lffd4
    moveq   #$1,d5
.lffd4:                                                 ; $00FFD4
    addq.w  #$1,d3
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.lffdc:                                                 ; $00FFDC
    cmp.w   d1,d2
    blt.b   .lffba
    tst.w   d3
    bne.b   .lffe8
    moveq   #-$1,d0
    bra.b   .lfff2
.lffe8:                                                 ; $00FFE8
    tst.w   d5
    bne.b   .lfff0
    moveq   #-$2,d0
    bra.b   .lfff2
.lfff0:                                                 ; $00FFF0
    move.w  d4,d0
.lfff2:                                                 ; $00FFF2
    movem.l (sp)+,d2-d5/a2
    rts
