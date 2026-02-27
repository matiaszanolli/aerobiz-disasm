; ============================================================================
; DrawRoutePair -- Draw one or two line segments between two city screen positions with profitability color coding
; Called: ?? times.
; 244 bytes | $009994-$009A87
; ============================================================================
DrawRoutePair:                                                  ; $009994
    movem.l d2-d7/a2-a5,-(sp)
    move.l  $0038(sp),d6
    move.l  $0034(sp),d7
    movea.l $0030(sp),a2
    movea.l $002c(sp),a3
    movea.l #$00ff1804,a4
    movea.l #$0001da34,a5
    move.b  (a3),d0
    cmp.b   (a2),d0
    bcc.b   .l99d0
    moveq   #$0,d5
    move.b  (a3),d5
    moveq   #$0,d4
    move.b  $0001(a3),d4
    moveq   #$0,d3
    move.b  (a2),d3
    moveq   #$0,d2
    move.b  $0001(a2),d2
    bra.b   .l99e4
.l99d0:                                                 ; $0099D0
    moveq   #$0,d3
    move.b  (a3),d3
    moveq   #$0,d2
    move.b  $0001(a3),d2
    moveq   #$0,d5
    move.b  (a2),d5
    moveq   #$0,d4
    move.b  $0001(a2),d4
.l99e4:                                                 ; $0099E4
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    jsr     (a5)
    lea     $0018(sp),sp
    cmpi.w  #$1,d7
    ble.b   .l9a82
    move.w  d3,d0
    ext.l   d0
    move.w  d5,d1
    ext.l   d1
    sub.l   d1,d0
    move.w  d2,d1
    ext.l   d1
    movea.l d7,a0
    move.w  d4,d7
    ext.l   d7
    exg     d7,a0
    sub.l   a0,d1
    cmp.l   d1,d0
    ble.b   .l9a54
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$5,d0
    bra.b   .l9a72
.l9a54:                                                 ; $009A54
    move.l  a4,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d2,d0
    ext.l   d0
    addq.l  #$4,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    move.w  d4,d0
    ext.l   d0
    addq.l  #$4,d0
.l9a72:                                                 ; $009A72
    move.l  d0,-(sp)
    move.w  d5,d0
    ext.l   d0
    addq.l  #$5,d0
    move.l  d0,-(sp)
    jsr     (a5)
    lea     $0018(sp),sp
.l9a82:                                                 ; $009A82
    movem.l (sp)+,d2-d7/a2-a5
    rts
; === Translated block $009A88-$009C9E ===
; 1 functions, 534 bytes
