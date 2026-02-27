; ============================================================================
; ScanRouteSlots -- Iterates all route slots for the given player comparing each slot's assigned-char byte to the target char index and accumulates up to 4 matching route entries
; Called: ?? times.
; 158 bytes | $01A468-$01A505
; ============================================================================
ScanRouteSlots:                                                  ; $01A468
    movem.l d2-d6/a2,-(sp)
    move.l  $0024(sp),d4
    move.l  $0020(sp),d5
    move.l  $001c(sp),d6
    move.w  d6,d0
    lsl.w   #$5,d0
    movea.l #$00ff0338,a0
    lea     (a0,d0.w),a0
    movea.l a0,a2
    pea     ($0001).w
    pea     ($000F).w
    move.w  d6,d0
    add.w   d0,d0
    movea.l #$00ff0118,a0
    pea     (a0,d0.w)
    dc.w    $4eb9,$0000,$5092                           ; jsr $005092
    lea     $000c(sp),sp
    clr.w   d3
.l1a4aa:                                                ; $01A4AA
    moveq   #$0,d0
    move.b  $0001(a2),d0
    move.w  d4,d1
    ext.l   d1
    cmp.l   d1,d0
    bne.b   .l1a4f6
    cmpi.w  #$6,d4
    beq.b   .l1a4d4
.l1a4be:                                                ; $01A4BE
    moveq   #$0,d2
    move.b  (a2),d2
    move.w  d2,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d2
    bra.b   .l1a4f4
.l1a4d4:                                                ; $01A4D4
    cmpi.w  #$3,$0006(a2)
    beq.b   .l1a4be
    moveq   #$0,d2
    move.b  (a2),d2
    move.w  d5,d0
    ext.l   d0
    move.l  d0,-(sp)
    move.w  d6,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$9dc4                           ; jsr $009DC4
    addq.l  #$8,sp
.l1a4f4:                                                ; $01A4F4
    cmp.w   d5,d2
.l1a4f6:                                                ; $01A4F6
    addq.l  #$8,a2
    addq.w  #$1,d3
    cmpi.w  #$4,d3
    blt.b   .l1a4aa
    movem.l (sp)+,d2-d6/a2
    rts
