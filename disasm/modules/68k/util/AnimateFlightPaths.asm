; ============================================================================
; AnimateFlightPaths -- Interpolates each active flight slot one step toward its destination, places the result in the sprite work buffer, issues the sprite-DMA command, and advances the slot counter
; ============================================================================
AnimateFlightPaths:                                                  ; $01ABB0
    link    a6,#-$20
    movem.l d2-d6/a2-a4,-(sp)
    lea     -$0020(a6),a4
    tst.w   ($00FF000A).l
    beq.w   .l1acb0
    movea.l #$00ff153c,a2
    pea     ($0020).w
    clr.l   -(sp)
    move.l  a4,-(sp)
    dc.w    $4eb9,$0001,$d520                           ; jsr $01D520
    lea     $000c(sp),sp
    clr.w   d4
    clr.w   d5
    moveq   #$0,d0
    move.w  d4,d0
    lsl.l   #$3,d0
    lea     (a4,d0.l),a0
    movea.l a0,a3
    bra.w   .l1ac7a
.l1abf2:                                                ; $01ABF2
    cmpi.b  #$ff,$0001(a2)
    beq.w   .l1ac82
    move.w  $000c(a2),d2
    move.w  $000e(a2),d3
    cmp.w   d3,d2
    bcc.b   .l1ac72
    moveq   #$0,d0
    move.w  d3,d0
    moveq   #$0,d1
    move.w  d2,d1
    sub.l   d1,d0
    subq.l  #$1,d0
    move.l  d0,d6
    move.l  d0,-(sp)
    move.w  $0004(a2),d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $0008(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e346                           ; jsr $01E346
    move.w  d0,d3
    move.w  d6,d0
    move.l  d0,-(sp)
    move.w  $0006(a2),d0
    move.l  d0,-(sp)
    move.w  d2,d0
    move.l  d0,-(sp)
    move.w  $000a(a2),d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0001,$e346                           ; jsr $01E346
    lea     $0020(sp),sp
    move.w  d0,d2
    addi.w  #$7c,d0
    move.w  d0,(a3)
    move.w  #$0500,$0002(a3)
    move.w  $0010(a2),$0004(a3)
    move.w  d3,d0
    addi.w  #$7c,d0
    move.w  d0,$0006(a3)
    addq.w  #$1,$000c(a2)
    addq.w  #$1,d5
.l1ac72:                                                ; $01AC72
    addq.l  #$8,a3
    addq.w  #$1,d4
    moveq   #$12,d0
    adda.l  d0,a2
.l1ac7a:                                                ; $01AC7A
    cmpi.w  #$4,d4
    bcs.w   .l1abf2
.l1ac82:                                                ; $01AC82
    clr.l   -(sp)
    clr.l   -(sp)
    move.l  a4,-(sp)
    pea     ($0004).w
    pea     ($0037).w
    pea     ($000F).w
    dc.w    $4eb9,$0000,$0d64                           ; jsr $000D64
    lea     $0018(sp),sp
    tst.w   d5
    bne.b   .l1acb0
    clr.l   -(sp)
    move.w  $000a(a6),d0
    ext.l   d0
    move.l  d0,-(sp)
    bsr.w UpdateFlightSlots
.l1acb0:                                                ; $01ACB0
    movem.l -$0040(a6),d2-d6/a2-a4
    unlk    a6
    rts
