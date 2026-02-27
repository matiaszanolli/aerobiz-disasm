; ============================================================================
; FindRelationRecord -- Search player route slots for a bidirectional city-pair match, return slot pointer or 0
; Called: ?? times.
; 274 bytes | $0081D2-$0082E3
; ============================================================================
FindRelationRecord:                                                  ; $0081D2
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
    bne.b   .l8272
    move.w  d2,d0
    mulu.w  #$0320,d0
    movea.l #$00ff9a20,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    bra.b   .l8262
.l8222:                                                 ; $008222
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l823c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l823c:                                                 ; $00823C
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l825c
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l825c
.l8256:                                                 ; $008256
    move.l  a2,d0
    bra.w   .l82de
.l825c:                                                 ; $00825C
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l8262:                                                 ; $008262
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0004(a3),d1
    cmp.l   d1,d0
    blt.b   .l8222
    bra.b   .l82dc
.l8272:                                                 ; $008272
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
    bra.b   .l82ce
.l8294:                                                 ; $008294
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l82ae
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l82ae:                                                 ; $0082AE
    moveq   #$0,d0
    move.b  (a2),d0
    move.w  d3,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l82c8
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    beq.b   .l8256
.l82c8:                                                 ; $0082C8
    moveq   #$14,d0
    adda.l  d0,a2
    addq.w  #$1,d2
.l82ce:                                                 ; $0082CE
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0005(a3),d1
    cmp.l   d1,d0
    blt.b   .l8294
.l82dc:                                                 ; $0082DC
    moveq   #$0,d0
.l82de:                                                 ; $0082DE
    movem.l (sp)+,d2-d4/a2-a3
    rts
