; ============================================================================
; FindRelationIndex -- Find route slot index by city pair in player array, return slot index or  if not found
; Called: ?? times.
; 286 bytes | $00957C-$009699
; ============================================================================
FindRelationIndex:                                                  ; $00957C
    movem.l d2-d4/a2-a3,-(sp)
    move.l  $0018(sp),d2
    move.l  $0020(sp),d3
    move.l  $001c(sp),d4
    move.w  d2,d0
    mulu.w  #$24,d0
    movea.l #$00ff0018,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$7158                           ; jsr $007158
    addq.l  #$8,sp
    tst.w   d0
    bne.b   .l961c
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l960c
.l95cc:                                                 ; $0095CC
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l95e6
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l9600
.l95e6:                                                 ; $0095E6
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9606
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9606
.l9600:                                                 ; $009600
    move.w  d2,d0
    bra.w   .l9694
.l9606:                                                 ; $009606
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l960c:                                                 ; $00960C
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.b   .l95cc
    bra.b   .l9690
.l961c:                                                 ; $00961C
    moveq   #$0,d0
    move.b  $0004(a3),d0
    mulu.w  #$14,d0
    move.w  d2,d1
    mulu.w  #$0320,d1
    add.w   d1,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l9682
.l963e:                                                 ; $00963E
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l9658
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l9672
.l9658:                                                 ; $009658
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l967c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l967c
.l9672:                                                 ; $009672
    moveq   #$0,d0
    move.b  $0004(a3),d0
    add.w   d2,d0
    bra.b   .l9694
.l967c:                                                 ; $00967C
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l9682:                                                 ; $009682
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    cmp.l   d1,d0
    blt.b   .l963e
.l9690:                                                 ; $009690
    move.w  #$ff,d0
.l9694:                                                 ; $009694
    movem.l (sp)+,d2-d4/a2-a3
    rts
