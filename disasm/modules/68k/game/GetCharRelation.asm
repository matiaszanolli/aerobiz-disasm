; ============================================================================
; GetCharRelation -- Returns a tile-code for the relationship between two characters: same ($0760), married ($0761), bonded ($0762), or unrelated ($0763/$0764/$0765) based on city-type and bitmask
; ============================================================================
GetCharRelation:                                                  ; $018EBA
    movem.l d2-d5/a2,-(sp)
    move.l  $0020(sp),d2
    move.l  $0018(sp),d3
    move.l  $001c(sp),d4
    cmpi.w  #$20,d2
    bge.b   .l18f3a
    move.w  d3,d0
    mulu.w  #$24,d0
    movea.l #$00ff0019,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.w  d2,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l18ef6
    move.w  #$0760,d2
    bra.w   .l18f86
.l18ef6:                                                ; $018EF6
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d3,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$6eea                           ; jsr $006EEA
    addq.l  #$8,sp
    cmp.w   d2,d0
    bne.b   .l18f14
    move.w  #$0761,d2
    bra.b   .l18f86
.l18f14:                                                ; $018F14
    move.w  d2,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d3,d1
    lsl.w   #$2,d1
    movea.l #$00ffa6a0,a0
    and.l   (a0,d1.w),d0
    beq.b   .l18f34
    move.w  #$0762,d2
    bra.b   .l18f86
.l18f34:                                                ; $018F34
    move.w  #$0763,d2
    bra.b   .l18f86
.l18f3a:                                                ; $018F3A
    move.w  d4,d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    moveq   #$0,d0
    move.b  $0002(a2),d0
    sub.w   d0,d2
    move.w  d2,d0
    ext.l   d0
    moveq   #$1,d1
    lsl.l   d0,d1
    move.l  d1,d0
    move.w  d3,d1
    mulu.w  #$e,d1
    move.w  d4,d5
    add.w   d5,d5
    add.w   d5,d1
    movea.l #$00ffbd6c,a0
    move.w  (a0,d1.w),d1
    andi.l  #$ffff,d1
    and.l   d1,d0
    beq.b   .l18f82
    move.w  #$0764,d2
    bra.b   .l18f86
.l18f82:                                                ; $018F82
    move.w  #$0765,d2
.l18f86:                                                ; $018F86
    move.w  d2,d0
    movem.l (sp)+,d2-d5/a2
    rts
