; ============================================================================
; HitTestMapTile -- Test screen (X,Y) against two hit-rect groups from $5E9FA/$5ECBC tables; return region or $FF
; Called: ?? times.
; 286 bytes | $007B1E-$007C3B
; ============================================================================
HitTestMapTile:                                                  ; $007B1E
    movem.l d2-d4/a2-a3,-(sp)
    movea.l $0018(sp),a1
    move.w  $001e(sp),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a3
    moveq   #$0,d0
    move.b  (a3),d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    move.w  $0002(a1),d4
    move.w  (a1),d3
    bra.b   .l7ba6
.l7b54:                                                 ; $007B54
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    blt.b   .l7ba2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    blt.b   .l7ba2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7ba2
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7ba2
    moveq   #$0,d0
    move.b  (a3),d0
.l7b9c:                                                 ; $007B9C
    add.w   d2,d0
    bra.w   .l7c36
.l7ba2:                                                 ; $007BA2
    addq.l  #$2,a2
    addq.w  #$1,d2
.l7ba6:                                                 ; $007BA6
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0001(a3),d1
    cmp.l   d1,d0
    blt.b   .l7b54
    moveq   #$0,d0
    move.b  $0002(a3),d0
    add.w   d0,d0
    movea.l #$0005e9fa,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    clr.w   d2
    move.w  $0002(a1),d4
    move.w  (a1),d3
    bra.b   .l7c24
.l7bd2:                                                 ; $007BD2
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    ble.b   .l7c20
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    subq.l  #$2,d1
    cmp.l   d1,d0
    ble.b   .l7c20
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.b  (a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7c20
    moveq   #$0,d0
    move.w  d4,d0
    moveq   #$0,d1
    move.b  $0001(a2),d1
    addi.l  #$a,d1
    cmp.l   d1,d0
    bge.b   .l7c20
    moveq   #$0,d0
    move.b  $0002(a3),d0
    bra.w   .l7b9c
.l7c20:                                                 ; $007C20
    addq.l  #$2,a2
    addq.w  #$1,d2
.l7c24:                                                 ; $007C24
    move.w  d2,d0
    ext.l   d0
    moveq   #$0,d1
    move.b  $0003(a3),d1
    cmp.l   d1,d0
    blt.b   .l7bd2
    move.w  #$ff,d0
.l7c36:                                                 ; $007C36
    movem.l (sp)+,d2-d4/a2-a3
    rts
