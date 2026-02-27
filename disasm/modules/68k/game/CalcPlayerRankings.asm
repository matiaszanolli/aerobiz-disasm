; ============================================================================
; CalcPlayerRankings -- Rebuilds the per-player rank and tie-count arrays in $FF0270/$FFBE00 by comparing each player's accumulated wealth score against every other player, applying tie-break rules.
; Called: ?? times.
; 256 bytes | $0262E4-$0263E3
; ============================================================================
CalcPlayerRankings:                                                  ; $0262E4
    link    a6,#-$8
    movem.l d2-d3/a2-a4,-(sp)
    movea.l #$00ff0270,a2
    movea.l #$00ffbe00,a3
    clr.w   d3
.l262fa:                                                ; $0262FA
    clr.w   d2
.l262fc:                                                ; $0262FC
    move.b  #$01,(a2)
    move.w  #$1,(a3)
    addq.l  #$1,a2
    addq.l  #$2,a3
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    bcs.b   .l262fc
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    bcs.b   .l262fa
    move.l  #$00ff00e8,-$0004(a6)
    clr.w   d3
.l26322:                                                ; $026322
    move.l  #$00ff00e8,-$0008(a6)
    clr.w   d1
.l2632c:                                                ; $02632C
    cmp.w   d1,d3
    beq.w   .l263ba
    move.w  d3,d0
    lsl.w   #$3,d0
    movea.l #$00ff0270,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    move.w  d3,d0
    lsl.w   #$4,d0
    movea.l #$00ffbe00,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    move.w  d1,d0
    lsl.w   #$5,d0
    movea.l #$00ff0130,a0
    lea     (a0,d0.w),a0
    movea.l a0,a4
    clr.w   d2
.l26374:                                                ; $026374
    move.l  (a1),d0
    cmp.l   (a4),d0
    bcc.b   .l26380
    addq.b  #$01,(a2)
    addq.w  #$1,(a3)
    bra.b   .l263aa
.l26380:                                                ; $026380
    move.l  (a1),d0
    cmp.l   (a4),d0
    bne.b   .l263aa
    addq.w  #$1,(a3)
    movea.l -$0004(a6),a0
    move.l  (a0),d0
    movea.l -$0008(a6),a0
    cmp.l   (a0),d0
    bcs.b   .l263a8
    movea.l -$0004(a6),a0
    move.l  (a0),d0
    movea.l -$0008(a6),a0
    cmp.l   (a0),d0
    bne.b   .l263aa
    cmp.w   d1,d3
    bls.b   .l263aa
.l263a8:                                                ; $0263A8
    addq.b  #$01,(a2)
.l263aa:                                                ; $0263AA
    addq.l  #$1,a2
    addq.l  #$2,a3
    addq.l  #$4,a1
    addq.l  #$4,a4
    addq.w  #$1,d2
    cmpi.w  #$8,d2
    bcs.b   .l26374
.l263ba:                                                ; $0263BA
    moveq   #$c,d0
    add.l   d0,-$0008(a6)
    addq.w  #$1,d1
    cmpi.w  #$4,d1
    bcs.w   .l2632c
    moveq   #$c,d0
    add.l   d0,-$0004(a6)
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    bcs.w   .l26322
    movem.l -$001c(a6),d2-d3/a2-a4
    unlk    a6
    rts
; === Translated block $0263E4-$027184 ===
; 2 functions, 3488 bytes
