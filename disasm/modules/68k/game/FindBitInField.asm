; ============================================================================
; FindBitInField -- Scan bitfield_tab longword for first set bit of a given entity type, return global bit index or 
; Called: 7 times.
; 88 bytes | $009DC4-$009E1B
; ============================================================================
FindBitInField:                                                  ; $009DC4
    movem.l d2-d3,-(sp)
    move.l  $000c(sp),d1
    move.w  $0012(sp),d0
    lsl.w   #$2,d0
    movea.l #$0005ecbc,a0
    lea     (a0,d0.w),a0
    movea.l a0,a1
    moveq   #$0,d0
    move.b  (a1),d0
    moveq   #$1,d3
    lsl.l   d0,d3
    clr.w   d2
    bra.b   .l9e08
.l9dea:                                                 ; $009DEA
    move.w  d1,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    and.l   d3,d0
    beq.b   .l9e04
    moveq   #$0,d0
    move.b  (a1),d0
    add.w   d2,d0
    bra.b   .l9e16
.l9e04:                                                 ; $009E04
    add.l   d3,d3
    addq.w  #$1,d2
.l9e08:                                                 ; $009E08
    moveq   #$0,d0
    move.b  $0001(a1),d0
    cmp.w   d2,d0
    bgt.b   .l9dea
    move.w  #$ff,d0
.l9e16:                                                 ; $009E16
    movem.l (sp)+,d2-d3
    rts
