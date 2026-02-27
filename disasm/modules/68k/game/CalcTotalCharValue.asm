; ============================================================================
; CalcTotalCharValue -- sums weighted relation values across all characters owned by a given player
; Called: ?? times.
; 226 bytes | $0102CE-$0103AF
; ============================================================================
CalcTotalCharValue:                                                  ; $0102CE
    movem.l d2-d6,-(sp)
    move.l  $0018(sp),d5
    moveq   #$0,d4
    clr.w   d3
.l102da:                                                ; $0102DA
    clr.w   d2
    move.w  d3,d6
    ext.l   d6
    move.l  d6,d0
    add.l   d6,d6
    add.l   d0,d6
    add.l   d6,d6
.l102e8:                                                ; $0102E8
    move.w  d6,d0
    add.w   d2,d0
    movea.l #$00ff0420,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d5,d0
    bne.b   .l10332
    move.w  d6,d0
    add.w   d2,d0
    movea.l #$00ff1704,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$2,d0
    add.l   d0,d4
.l10332:                                                ; $010332
    addq.w  #$1,d2
    cmpi.w  #$6,d2
    blt.b   .l102e8
    addq.w  #$1,d3
    cmpi.w  #$20,d3
    blt.b   .l102da
    clr.w   d3
.l10344:                                                ; $010344
    clr.w   d2
.l10346:                                                ; $010346
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff04e0,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    cmp.w   d5,d0
    bne.b   .l10398
    move.w  d3,d0
    lsl.w   #$2,d0
    add.w   d2,d0
    movea.l #$00ff1620,a0
    move.b  (a0,d0.w),d0
    andi.l  #$ff,d0
    move.l  d0,-(sp)
    move.w  d3,d0
    addi.w  #$20,d0
    move.l  d0,-(sp)
    move.w  d5,d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$e08e                           ; jsr $00E08E
    lea     $000c(sp),sp
    move.l  d0,d1
    add.l   d0,d0
    add.l   d1,d0
    lsr.l   #$2,d0
    add.l   d0,d4
.l10398:                                                ; $010398
    addq.w  #$1,d2
    cmpi.w  #$4,d2
    blt.b   .l10346
    addq.w  #$1,d3
    cmpi.w  #$39,d3
    blt.b   .l10344
    move.l  d4,d0
    movem.l (sp)+,d2-d6
    rts
