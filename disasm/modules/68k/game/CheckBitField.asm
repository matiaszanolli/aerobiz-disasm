; ============================================================================
; CheckBitField -- AND player bitfield at $FFA6A0 with $5ECDC relation mask; resolve slot via $D648 if D2=$FF
; Called: ?? times.
; 80 bytes | $007A24-$007A73
; ============================================================================
CheckBitField:                                                  ; $007A24
    movem.l d2-d5,-(sp)
    move.l  $0018(sp),d2
    move.l  $001c(sp),d4
    move.l  $0014(sp),d5
    clr.w   d3
    cmpi.w  #$ff,d2
    bne.b   .l7a4c
    move.w  d4,d0
    ext.l   d0
    move.l  d0,-(sp)
    dc.w    $4eb9,$0000,$d648                           ; jsr $00D648
    addq.l  #$4,sp
    move.w  d0,d2
.l7a4c:                                                 ; $007A4C
    move.w  d5,d0
    lsl.w   #$2,d0
    movea.l #$00ffa6a0,a0
    move.l  (a0,d0.w),d0
    move.w  d2,d1
    lsl.w   #$2,d1
    movea.l #$0005ecdc,a0
    and.l   (a0,d1.w),d0
    beq.b   .l7a6c
    moveq   #$1,d3
.l7a6c:                                                 ; $007A6C
    move.w  d3,d0
    movem.l (sp)+,d2-d5
    rts
AdjustScrollPos:                                                  ; $007A74
    movem.l d2/a2,-(sp)
    move.l  $0010(sp),d2
    movea.l $000c(sp),a2
    move.w  d2,d0
    andi.w  #$f,d0
    beq.w   .l7b18
    move.w  d2,d0
    andi.w  #$1,d0
    beq.b   .l7ab0
    moveq   #$0,d0
    move.w  $0002(a2),d0
    subq.l  #$2,d0
    moveq   #$1,d1
    cmp.l   d0,d1
    bge.b   .l7aaa
    moveq   #$0,d0
    move.w  $0002(a2),d0
    subq.l  #$2,d0
    bra.b   .l7aac
.l7aaa:                                                 ; $007AAA
    moveq   #$1,d0
.l7aac:                                                 ; $007AAC
    move.w  d0,$0002(a2)
.l7ab0:                                                 ; $007AB0
    move.w  d2,d0
    andi.w  #$2,d0
    beq.b   .l7adc
    moveq   #$0,d0
    move.w  $0002(a2),d0
    addq.l  #$2,d0
    cmpi.l  #$90,d0
    bge.b   .l7ad2
    moveq   #$0,d0
    move.w  $0002(a2),d0
    addq.l  #$2,d0
    bra.b   .l7ad8
.l7ad2:                                                 ; $007AD2
    move.l  #$90,d0
.l7ad8:                                                 ; $007AD8
    move.w  d0,$0002(a2)
.l7adc:                                                 ; $007ADC
    move.w  d2,d0
    andi.w  #$8,d0
    beq.b   .l7af8
    moveq   #$0,d0
    move.w  (a2),d0
    addq.l  #$2,d0
    move.l  #$0100,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a2)
.l7af8:                                                 ; $007AF8
    move.w  d2,d0
    andi.w  #$4,d0
    beq.b   .l7b18
    moveq   #$0,d0
    move.w  (a2),d0
    addi.l  #$fe,d0
    move.l  #$0100,d1
    dc.w    $4eb9,$0003,$e146                           ; jsr $03E146
    move.w  d0,(a2)
.l7b18:                                                 ; $007B18
    movem.l (sp)+,d2/a2
    rts
